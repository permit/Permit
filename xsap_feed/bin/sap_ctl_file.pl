#!/usr/bin/perl -I/usr/users/rolesdb/lib/cpa
##############################################################################
#
#  Build a control file (with line counts and byte counts) 
#  for the Roles -> SAP feed, and build a separate "interface" file
#  to be used by one of routines on the SAP side.
#
#
#  Copyright (C) 1999-2010 Massachusetts Institute of Technology
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
#  Created 12/30/98, Jim Repa
#  Modified 5/6/99, Jim Repa
#
##############################################################################
#
# Get packages
#
 use sap_feed('GetSequence');  # Use the subroutine GetSequence in sap_feed.pm
 use sap_feed('TransformFilename'); # Use TransformFilename in sap_feed.pm

#
#  Set some constants
#
 #$erase_file_days = 14;
 #$datadir = $ENV{"ROLES_HOMEDIR"} . "/sap_feed/data/";
 $datadir = $ENV{"ROLES_HOMEDIR"} . "/xsap_feed/data/";
 $seqno = &GetSequence();
 @filestem_list = qw(r2sauth. r2sdmapl. r2slock. r2snewu. r2sprof. r2sumap.);
 $temp_control_file = $datadir . "tempcontrol";
 $control_file = $datadir . "r2scont." . $seqno;
 $control_file_shortname = "r2scont." . $seqno;
 $temp_interface_file = $datadir . "tempintrf";
 $interface_file = $datadir . "r2sintrf." . $seqno;

#
#  Build a control file that lists the number of bytes and 
#  records in each file.  Use a temporary name -- we'll rename it when
#  it is done.
#
 unless (open(OUT,">$temp_control_file")) {
   die "Cannot open $temp_control_file for writing\n";
 }
 unless (open(OUT2,">$temp_interface_file")) {
   die "Cannot open $temp_interface_file for writing\n";
 }
 print OUT "#Filename:lines:bytes\n";
 print OUT2 "#List of files in current Roles -> SAP feed\n";
 $i = 1;
 foreach $file_stem (@filestem_list) {
   #print "file_stem='$file_stem'\n";
   $filename = $file_stem . $seqno;
   $newname = &TransformFilename($filename);
   $fullpath = $datadir . $filename;
   chomp($wc_out = `wc $fullpath`);
   @temp = split(' ', $wc_out);
   ($wc_lines, $wc_words, $wc_bytes, $wc_filename) = split(' ', $wc_out);
   if ($datadir . $filename eq $wc_filename) {
     print OUT "$newname:$wc_lines:$wc_bytes\n";
     printf OUT2 "%-12s %s\n",
        "sourcefile" . $i++, $newname;
   }
   else {
     print OUT "File $filename not found\n";
     print OUT2 "File $filename not found\n";
     die "File $fullpath not found\n";
   } 
 }

#
#  Write an extra line to the "interface" file listing the control file.
#  Then, print a timestamp and close the control and interface files.
#
 printf OUT2 "%-12s %s\n",
             "sourcefile$i", &TransformFilename($control_file_shortname);

 chomp($time = `date +'%Y/%m/%d %H:%M:%S'`);
 print OUT "#Control file written $time\n";
 print OUT2 "#Interface file written $time\n";
 close(OUT);
 close(OUT2);

#
#  Now, rename the files to their official names.
#
 system("mv $temp_control_file $control_file");
 system("mv $temp_interface_file $interface_file");
 exit();





