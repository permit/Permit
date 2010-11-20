#!/usr/bin/perl -I/usr/users/rolesdb/lib/cpa/ -I/usr/users/rolesdb/bin/extract/
###########################################################################
#
#  Extract LABD (Labor Distribution) authorizations to be sent to 
#    LDS system on SAP.
#
#  Create a file of the following format:
#    cc.  1 -  8  Kerberos_name (padded with blanks)
#         9 -  9  Function letter
#        10 - 17  Organization (7nnnnnnn number)
#        18 - 27  Profit center (Pnnnnnn) or *
#
#  (If the authorization is by 7nnnnnnn number, then enter * in the 
#   Profit Center field.  If authorization is by PC, then specify the
#   PC number.) 
#
#  Copyright (C) 2004-2010 Massachusetts Institute of Technology
#  For contact and other information see: http://mit.edu/permit/
#
#  This program is free software; you can redistribute it and/or modify it under the terms of the GNU General 
#  Public License as published by the Free Software Foundation; either version 2 of the License.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even 
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public 
#  License for more details.
#
#  You should have received a copy of the GNU General Public License along with this program; if not, write 
#  to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#
#
###########################################################################
#
# Get packages
#
use config('GetValue');  # Use the subroutine GetValue in ~/lib/cpa/config.pm
use lds_feed('GetSequenceLDS');  # Use subroutine GetSequenceLDS in lds_feed.pm
use lds_feed('IncrSequenceLDS');  # Use routine IncrSequenceLDS in lds_feed.pm
use lds_feed('GetLDSFilename');  # Use subroutine GetLDSFilename in lds_feed.pm
use lds_feed('GenControlFile');  # Use subroutine GenCtlFile in lds_feed.pm

#
#  Get database name
#
 if ($#ARGV >= 1) {
   $db_name = $ARGV[1];
 }
 else {
   $db_name = 'roles';
 }

#
#  Get username and password.
#
 $db_parm = GetValue($db_name);
 $db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
 $user = $1;
 $pw = $2;
 $db = $3;

#
#  Define output file
#
$datafile_dir = $ENV{'ROLES_HOMEDIR'} . '/data/';
$outfile = 'lds.output';
unless (open(OUT, ">$datafile_dir$outfile")) {
  die "Error opening $datafile_dir$outfile for writing\n";
}

#
#  Make sure we are set up to use Oraperl.
#
use DBI;
use Oraperl;
if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}

#
#  Open connection to oracle
#
$lda = &ora_login($db, $user, $pw)
	|| die $ora_errstr;

#
#  The SQL statement is a union of 3 select statements.
#    1st select: Get authorizations at a higher level than 7nnnnnnn
#                organizations.
#
@stmt = q(select a.kerberos_name, a.function_name, q.qualifier_code, '*'
         from authorization a, qualifier q, qualifier_descendent qd
         where a.function_category = 'LABD'
         and a.qualifier_code like '0H%'
         and a.do_function = 'Y'
         and a.descend = 'Y'
         and a.effective_date <= sysdate+1
         and (a.expiration_date is NULL or a.expiration_date >= sysdate)
         and a.qualifier_id = qd.parent_id
         and qd.child_id = q.qualifier_id
         and q.qualifier_code like '7_______'
         union select a.kerberos_name, a.function_name, a.qualifier_code, '*'
         from authorization a
         where a.function_category = 'LABD'
         and a.qualifier_code like '7_______'
         and a.do_function = 'Y'
         and a.descend = 'Y'
         and a.effective_date <= sysdate+1
         and (a.expiration_date is NULL or a.expiration_date >= sysdate)
         union select a.kerberos_name, a.function_name, q.qualifier_code, 
          a.qualifier_code
         from authorization a, qualifier q, qualifier_child qc
         where a.function_category = 'LABD'
         and a.qualifier_code like '______'
         and a.do_function = 'Y'
         and a.descend = 'Y'
         and a.effective_date <= sysdate+1
         and (a.expiration_date is NULL or a.expiration_date >= sysdate)
         and a.qualifier_id = qc.child_id
         and qc.parent_id = q.qualifier_id
         order by 1, 3
);

$csr = &ora_open($lda, "@stmt")
	|| die $ora_errstr;

#
#  Read in and process results from the query
#

$i = 0;
$fmt = "%-12s%-1s%-8s%-10s\n";
#printf OUT $fmt,
#  'Kerb name', 'R', 'Org', 'PC';
while ( ($akerbname, $afuncname, $aorgcode, $apccode) = &ora_fetch($csr) ) {
  if (($i++)%1000 == 0) {print "$i $akerbname $aorgcode $apccode\n";}
  $role_letter = ' ';
  $afuncname =~ /^LDS ([A-Z]):/;
  $role_letter = $1;
  $pc_code = ($apccode eq '*') ? $apccode : "P$apccode";
  if ($role_letter =~ /^[A-K]$/) {
    printf OUT $fmt, 
      $akerbname, $role_letter, $aorgcode, $pc_code;
  }
  else {
    print "Bad Function name found: $afuncname\n";
  }
}
&ora_close($csr) || die "can't close cursor";
close(OUT);
&ora_logoff($lda) || die "can't log off Oracle";

#
#  Transfer the file with FTP
#
 $new_filename = &GetLDSFilename();
 $temp_ctl = 'lds.ctl';
 $ctl_file = 'c' . substr($new_filename, 1);
 &GenControlFile($datafile_dir . $outfile, 
                 $datafile_dir . $temp_ctl);
 print "Filename is '$new_filename'\n"
       . "Control file is '$ctl_file'\n";
 #exit();
 my $ftp_rc = 
  &FTPtoDropbox($datafile_dir, $outfile, $new_filename, $temp_ctl, $ctl_file);

#
#  If the FTP transfer worked, then increment the sequence number.
#
 if ($ftp_rc) {
   &IncrSequenceLDS();  # Increment the sequence number.
   print "File transfered successfully with FTP.\n";
 }
 else {
   print "****** Error.  File not transferred. FTP failed.\n";
 }

#
#  Exit
#
exit();

##############################################################################
#
#  Function FTPtoDropbox($source_dir, $source_file, $sink_file,
#                          $source_ctl_file, $sink_ctl_file);
#
#  Transfers files $source_file and $source_ctl_file from 
#  local directory $source_dir,
#  renaming them to $sink_file and $sink_ctl_file.
#  
#  Returns 1 if it worked, 0 if not.
#
##############################################################################
sub FTPtoDropbox {
 my ($source_dir, $source_file, $sink_file, 
     $source_ctl_file, $sink_ctl_file) = @_;
 
 my @filesource = ($source_file, $source_ctl_file);
 my @filesink = ($sink_file, $sink_ctl_file);
 my $temp_file = $source_dir . 'ftp_temp';

#
#  Get FTP parameters
#
 my $ftp_parm = GetValue("ftpsap");
 $ftp_parm =~ m/^(.*)\/(.*)\@(.*)$/;
 my $user_id = $1;
 my $user_pw = $2;
 my $ftp_machine = $3;

#
#  Run FTP
#
 open (FTP, "|ftp -n -v $ftp_machine > $temp_file\n");
 print FTP "user $user_id $user_pw\n";

 print FTP "lcd $source_dir\n";
 #print FTP "ls -l\n";
 for ($i = 0; $i < @filesource; $i++) {
   #print "put $filesource[$i] $filesink[$i]\n";
   print FTP "put $filesource[$i] $filesink[$i]\n";
 }
 print FTP "quit\n";
 close (FTP);
 print "\nFTP completed.\n";

#
#  Check the output file to make sure there are two instances of
#  the string 'Transfer complete.';
#
 my $grep_results;
 chomp($grep_results = `grep -c 'Transfer complete.' $temp_file`);
 if ($grep_results == 2) {
   return 1;  # It worked
 }
 else {
   system("cat $temp_file");
   return 0;  # It didn't work
 } 

}
