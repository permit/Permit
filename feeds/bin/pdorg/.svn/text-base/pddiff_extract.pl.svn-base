#!/usr/bin/perl -I/usr/users/rolesdb/lib/cpa -I/usr/users/rolesdb/bin/pdorg
###########################################################################
#
#  Reads the file pdorg_roles.compare, strips off the header, and 
#    sends the file to the SAP dropbox via FTP.
#
#  The file has the following format:
#    cc.  1 - 18  Type of difference
#        19 - 21  ' : '
#        22 - 37  Roles spending group code (SG_...)
#        38 - 45  SAP organization code (number 5nnnnnnn)
#        46 - 46  blank
#        47 - 76  Roles approver function
#        77 - 85  username
#        86 - 87  blank
#        88 - 95  SAP position code (number 5nnnnnnn)
#
#  The "Type of difference" field can contain one of the following two
#  values:
#    '     Roles only-->'   Auth. found in Roles DB but not in PD Org
#    '<-- PD Org only   '   Auth. found in the PD Org but not in Roles DB
#
#
#  Copyright (C) 2000-2010 Massachusetts Institute of Technology
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
use config('GetValue');  # Use the subroutine GetValue in config.pm
use pddiff_feed('GetSequencePDDIFF'); # Use subroutine in pddiff_feed.pm
use pddiff_feed('IncrSequencePDDIFF');  # Use subroutine IncrSequencePDDIFF
use pddiff_feed('GetPDDIFFFilename');  # Use subroutine GetPDDIFFFilename
use pddiff_feed('GenControlFile');  # Use subroutine GenControlFile

#
#  Define input and output files
#
$datafile_dir = $ENV{'PDORG_DATADIR'};
$infile = 'pdorg_roles.compare';
$outfile = 'pddiff.output';

#
#  Strip off the header lines from the input file.
#  Also, remove '+' following any username.
#
 
$rc = system("cat $datafile_dir$infile"   # Start with compare-file
             . " \| grep ':'"             # Find lines with ':'
             . " \| grep '\\-\\-'"        # Find lines with '--'
             . " \| sed 's/+/ /g'"        # Change '+' to ' '
             . " \| sed 's/\\* Roles only/  Roles only/'"    # Get rid of '*'
             . " \| sed 's/PD Org only \\*/PD Org only  /'"  # Get rid of '*'
             . " > $datafile_dir$outfile") >> 8;
print "rc = $rc\n";

#
#  Transfer the file with FTP
#
 $new_filename = &GetPDDIFFFilename();
 print "new_filename = $new_filename\n";
 $temp_ctl = 'pddiff.ctl';
 $ctl_file = 'c' . substr($new_filename, 1);
 &GenControlFile($datafile_dir . $outfile, 
                 $datafile_dir . $temp_ctl);
 print "Filename is '$new_filename'\n"
       . "Control file is '$ctl_file'\n";
 my $ftp_rc = 
  &FTPtoDropbox($datafile_dir, $outfile, $new_filename, $temp_ctl, $ctl_file);

#
#  If the FTP transfer worked, then increment the sequence number.
#
 if ($ftp_rc) {
   &IncrSequencePDDIFF();  # Increment the sequence number.
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
 #print "ftp_parm = $ftp_parm\n";
 my $user_id = $1;
 my $user_pw = $2;
 my $ftp_machine = $3;
 #print "user_id=$user_id user_pw=$user_pw ftp_machine=$ftp_machine\n";

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
 chomp($grep_results = `grep -c 'Transfer complete' $temp_file`);
 if ($grep_results == 2) {
   return 1;  # It worked
 }
 else {
   system("cat $temp_file");
   return 0;  # It didn't work
 } 

}
