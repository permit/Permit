#!/usr/bin/perl -I/usr/users/rolesdb/lib/cpa/ -I/usr/users/rolesdb/bin/extract/
###########################################################################
#
#  Extract DACCA Addressee authorizations in the PAYR category to be sent 
#    to SAP to reside in a special table there.
#
#  Create a file of the following format:
#    cc.  1 - 12  Kerberos_name (padded with blanks)
#        13 - 21  MIT ID number
#        22 - 22  blank
#        23 - 52  Function name
#        53 - 53  Code letter: A-amount, P-percent, B-both
#        54 - 54  blank
#        55 - 62  Profit center
#        63 - 63  blank
#        64 - 75  Qualifier code specified in the authorization  
#        76 - 80  Level of qualifier code specified in the authorization
#
#
#  Copyright (C) 2006-2010 Massachusetts Institute of Technology
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
#  Modified 8/15/2006, Jim Repa.  Send file to production SAP instance.
#  Modified 8/17/2006, Jim Repa.  Add filters for do_function and 
#                                 effective_date and expiration_date
#
###########################################################################
#
# Get packages
#
use config('GetValue');  # Use the subroutine GetValue in ~/lib/cpa/config.pm
use dacca_feed('GetSequenceDACCA'); # Use routine in dacca_feed.pm
use dacca_feed('IncrSequenceDACCA'); # Use IncrSequenceDACCA in dacca_feed.pm
use dacca_feed('GetDACCAFilename'); # Use GetDACCAFilename in dacca_feed.pm
#use dacca_feed('GenControlFile');  # Use routine GenCtlFile in dacca_feed.pm
use dacca_feed('GenControlFile2'); # Use routine GenCtlFile in dacca_feed.pm
use dacca_feed('RunPGPforSAPdropbox');  # Use PGP encrypt routine 

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
$outfile = 'dacca.output';
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
#  The SQL statement finds DACCA addressee authorizations in the 
#  category PAYR and expands them down to the Profit Center level.
#
$stmt = 
 "select a.kerberos_name, substr(p.mit_id, 1, 9), a.function_name, 
       decode(a.function_name, 'DACCA ADDRESSEE', 'B',
                               'DACCA ADDRESSEE-AMOUNT ONLY', 'A',
                               'DACCA ADDRESSEE-PERCENT ONLY', 'P',
                               '?'),
       a.qualifier_code, substr(a.qualifier_code, 1, 12), q.qualifier_level
    from authorization a, person p, qualifier q
    where a.function_category = 'PAYR'
    and a.function_name like 'DACCA ADDRESSEE%'
    and p.kerberos_name = a.kerberos_name
    and a.qualifier_code between 'PC000000' and 'PC999999'
    and q.qualifier_id = a.qualifier_id
    and a.do_function = 'Y'
    and sysdate between a.effective_date and nvl(a.expiration_date,sysdate)
  union select a.kerberos_name, substr(p.mit_id, 1, 9), a.function_name, 
       decode(a.function_name, 'DACCA ADDRESSEE', 'B',
                               'DACCA ADDRESSEE-AMOUNT ONLY', 'A',
                               'DACCA ADDRESSEE-PERCENT ONLY', 'P',
                               '?'),
       q1.qualifier_code, substr(a.qualifier_code, 1, 12), q0.qualifier_level
    from authorization a, person p, qualifier q0,
         qualifier_descendent qd, qualifier q1
    where a.function_category = 'PAYR'
    and a.function_name like 'DACCA ADDRESSEE%'
    and p.kerberos_name = a.kerberos_name
    and a.qualifier_code not between 'PC000000' and 'PC999999'
    and a.descend = 'Y'
    and q0.qualifier_id = a.qualifier_id
    and qd.parent_id = a.qualifier_id
    and q1.qualifier_id = qd.child_id
    and q1.qualifier_code between 'PC000000' and 'PC999999'
    and a.do_function = 'Y'
    and sysdate between a.effective_date and nvl(a.expiration_date, sysdate)
  order by 5, 7, 1, 4";

$csr = &ora_open($lda, $stmt)
	|| die $ora_errstr;

#
#  Read in and process results from the query
#

$i = 0;
$fmt = "%-12s%-10s%-30s%-2s%-9s%-12s%5s\n";
#printf OUT $fmt,
my ($akerbname, $amitid, $afuncname, $afcode, $apc, $aqualcode, $alevel);
#  'Kerb name', 'R', 'Org', 'PC';
while ( ($akerbname, $amitid, $afuncname, $afcode, $apc, $aqualcode, $alevel)
         = &ora_fetch($csr) ) {
  if (($i++)%1000 == 0) {print "$i $akerbname $afcode $apc $aqualcode\n";}
  printf OUT $fmt, 
      $akerbname, $amitid, $afuncname, $afcode, $apc, $aqualcode, $alevel;
}
&ora_close($csr) || die "can't close cursor";
close(OUT);
&ora_logoff($lda) || die "can't log off Oracle";

#
#  Get the record count for the as-yet-unencrypted file
#
 $datapath = $datafile_dir . $outfile;
 chomp ($wc_line = `wc $datapath`);
 my ($record_count, $words, $bytes, $name) = split(' ', $wc_line);
 if ($name eq 'no') {
   die "File $datapath not found\n";
 }
 print "record_count = '$record_count'\n";

#
# Get the PGP key-phrase
#
 my $pgp_config_line = &GetValue('pgpsap');
 #my $pgp_config_line = &GetValue('pgpsapt');
 $pgp_config_line =~ m/^(.*)\/(.*)\@(.*)$/;
 my $pw  = $2;

#
#  Encrypt the file using PGP
#
 $new_filename = &GetDACCAFilename();
 print "copying $datapath to $datafile_dir$new_filename\n";
 system("cp $datapath $datafile_dir$new_filename");
 &RunPGPforSAPdropbox("$datafile_dir$new_filename", $pw);

#
# Get byte count from encrypted file
#
 $new_filename .= ".asc";
 $encrypted_filename = $new_filename;
 $datapath = $datafile_dir . $new_filename;
 print "datapath of encrypted file is '$datapath'\n";
 chomp ($wc_line = `wc $datapath`);
 my ($record_count2, $words2, $bytes2, $name2) = split(' ', $wc_line);

#
#  Transfer the file with FTP
#
#  (Use username rldb2 for SF2, rldbt for SF5, and rldbp for PS1)
#
 $temp_ctl = 'dacca.ctl';
 $ctl_file = 'c' . substr($new_filename, 1);
 print "record count = $record_count  byte-count = $bytes2\n";
 &GenControlFile2($datafile_dir . $temp_ctl, $bytes2, $record_count);
 #&GenControlFile($datafile_dir . $outfile, 
 #                $datafile_dir . $temp_ctl);
 print "Filename is '$encrypted_filename'\n"
       . "Control file is '$ctl_file'\n";
 #my $ftp_rc = 
 # &FTPtoDropbox($datafile_dir, $outfile, $new_filename, $temp_ctl, $ctl_file);
 my $ftp_rc = 
  &FTPtoDropbox($datafile_dir, $encrypted_filename, $encrypted_filename, 
                $temp_ctl, $ctl_file);

#
#  If the FTP transfer worked, then increment the sequence number.
#
 if ($ftp_rc) {
   &IncrSequenceDACCA();  # Increment the sequence number.
   print "File transfered successfully with FTP.\n";
   system("rm $datafile_dir$encrypted_filename");
   $temp_file = substr($encrypted_filename, 0, -4);  # Remove .asc
   system ("rm $datafile_dir$temp_file");
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
 my $ftp_parm = GetValue("ftpsapz");
 #my $ftp_parm = GetValue("ftpsapzt");
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
