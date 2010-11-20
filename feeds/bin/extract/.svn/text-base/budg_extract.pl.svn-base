#!/usr/bin/perl -I/usr/users/rolesdb/lib/cpa/ -I/usr/users/rolesdb/bin/extract/
###########################################################################
#
#  Extract BUDG (SAPBUD) authorizations to be sent to 
#    SAPBUD system on SAP.
#
#  Create a file of the following format:
#    cc.  1 - 12  Kerberos_name (padded with blanks)
#        13 - 42  Function name (with "SAPBUD" stripped off)
#        43 - 57  Qualifier code
#        58 - 58  Descend flag
#
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
###########################################################################
#
# Get packages
#
use config('GetValue');  # Use the subroutine GetValue in ~/lib/cpa/config.pm
use budg_feed('GetSequenceBUDG'); # Use routine GetSequenceBUDG in budg_feed.pm
use budg_feed('IncrSequenceBUDG'); # Use IncrSequenceBUDG in budg_feed.pm
use budg_feed('GetBUDGFilename'); # Use GetBUDGFilename in budg_feed.pm
#use budg_feed('GenControlFile');  # Use routine GenCtlFile in budg_feed.pm
use budg_feed('GenControlFile2'); # Use routine GenCtlFile in budg_feed.pm
use budg_feed('RunPGPforSAPdropbox');  # Use PGP encrypt routine 

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
$outfile = 'budg.output';
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
#  The SQL statement simply finds authorizations in the category BUDG
#
$stmt = "select a.kerberos_name, replace(a.function_name, 'SAPBUD ', ''), 
                a.qualifier_code, a.descend
         from authorization a
         where a.function_category = 'BUDG'
         and a.do_function = 'Y'
         and a.effective_date <= sysdate+1
         and (a.expiration_date is NULL or a.expiration_date >= sysdate)
         order by 1, 2, 3";

$csr = &ora_open($lda, $stmt)
	|| die $ora_errstr;

#
#  Read in and process results from the query
#

$i = 0;
$fmt = "%-12s%-30s%-15s%-1s\n";
#printf OUT $fmt,
my ($akerbname, $afuncname, $aqualcode, $adescend);
#  'Kerb name', 'R', 'Org', 'PC';
while ( ($akerbname, $afuncname, $aqualcode, $adescend) = &ora_fetch($csr) ) {
  if (($i++)%1000 == 0) {print "$i $akerbname $aorgcode $apccode\n";}
  printf OUT $fmt, 
      $akerbname, $afuncname, $aqualcode, $adescend;
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
 $pgp_config_line =~ m/^(.*)\/(.*)\@(.*)$/;
 my $pw  = $2;

#
#  Encrypt the file using PGP
#
 $new_filename = &GetBUDGFilename();
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
 $temp_ctl = 'budg.ctl';
 $ctl_file = 'c' . substr($new_filename, 1);
 print "record count = $record_count  byte-count = $bytes2\n";
 &GenControlFile2($datafile_dir . $temp_ctl, $bytes2, $record_count);
 #&GenControlFile($datafile_dir . $outfile, 
 #                $datafile_dir . $temp_ctl);
 print "Filename is '$new_filename'\n"
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
   &IncrSequenceBUDG();  # Increment the sequence number.
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
