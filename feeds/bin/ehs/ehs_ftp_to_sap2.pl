#!/usr/bin/perl -I/usr/users/rolesdb/lib/cpa/ -I/usr/users/rolesdb/bin/extract/ -I/usr/users/rolesdb/bin/ehs/
###########################################################################
#
#  Transfer EHS Roles/SAP differences file (and control file) to SAP dropbox
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
use rdb_ehs_feed('GetSequenceEHS'); # Use routine GetSequenceEHS in rdb_ehs_feed.pm
use rdb_ehs_feed('IncrSequenceEHS'); # Use IncrSequenceEHS in rdb_ehs_feed.pm
use rdb_ehs_feed('GetEHSFilename'); # Use GetEHSFilename in rdb_ehs_feed.pm
use rdb_ehs_feed('GenControlFile2');  # Use routine GenCtlFile in rdb_ehs_feed.pm
use rdb_ehs_feed('run_pgp_for_sap_dropbox');  # Use routine in rdb_ehs_feed.pm

#
#  Set some constants
#
$datafile_dir = $ENV{'ROLES_HOMEDIR'} . '/data/ehs/';
$datafile = 'ehs_roles.compare';

#
#  Get the record count for the as-yet-unencrypted differences file
#
 $datapath = $datafile_dir . $datafile;
 chomp ($wc_line = `wc $datapath`);
 my ($record_count, $words, $bytes, $name) = split(' ', $wc_line);
 if ($name eq 'no') {
   die "File $datapath not found\n";
 }
 print "record_count = '$record_count'\n";

#
#  Encrypt the file using PGP
#
 $new_filename = &GetEHSFilename();
 system("cp $datapath $datafile_dir$new_filename");
 &run_pgp_for_sap_dropbox("$datafile_dir$new_filename", 'pgpsap');

#
#  Get the byte count for the encrypted differences file
#
 $encrypted_datapath = "$datafile_dir${new_filename}.asc";
 chomp ($wc_line = `wc $encrypted_datapath`);
 my ($record_count, $words, $bytes, $name) = split(' ', $wc_line);
 if ($name eq 'no') {
   die "File $encrypted_datapath not found\n";
 }
 print "bytes = '$bytes'\n";

#
#  Transfer the file with FTP
#
#  (Use username rldb2 for SF2, rldbt for SF5, and rldbp for PS1)
#
 $temp_ctl = 'ehs.ctl';
 $encrypted_filename = $new_filename . ".asc";
 $ctl_file = 'c' . substr($encrypted_filename, 1);
 &GenControlFile2($datafile_dir . $temp_ctl, $bytes, $record_count);
 print "Filename is '$new_filename'\n"
       . "Control file is '$ctl_file'\n";
 $encrypted_filename = $new_filename . ".asc";

 my $ftp_rc = 
  &FTPtoDropbox($datafile_dir, $encrypted_filename, $encrypted_filename, 
    $temp_ctl, $ctl_file);
 system("rm $datafile_dir$new_filename");
 system("rm $encrypted_datapath");

#
#  If the FTP transfer worked, then increment the sequence number.
#
 if ($ftp_rc) {
   &IncrSequenceEHS();  # Increment the sequence number.
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
