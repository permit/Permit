#!/usr/bin/perl
##############################################################################
#
#  Count the number of bytes used by files in a given directory
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
#  Created 2/2/99, Jim Repa
#
##############################################################################
#
#  Set some constants
#
 #$erase_file_days = 14;
 $datadir = ".";
 $filetemplate = 'umap1.out*';
 $filetemplate = 'cont1.out*';
 $filetemplate = 'auth1.out*';
 $filetemplate = 'user1.lock*';
 $filetemplate = 'user1.new*';
 $filetemplate = 'umap1.delete*';
 $filetemplate = 'prof1.out*';
 $filetemplate = '*.pl;';

#
#  Get output of ls command (use -s option to get count of 1024-byte blocks)
#
 unless (open(LS, "ls -trs1 $datadir/$filetemplate |")) {
   die "Unable to open pipe from ls command\n";
 }
 $tot_kbytes = 0;
 while (chomp($line = <LS>)) {
   #print "'$line' ";
   ($kbytes, $filename) = split(' ', $line);
   $filename =~ /\/([^\/]*)$/;
   $shortname = $1;
   print "$shortname $kbytes\n";
   $tot_kbytes += $kbytes;
 }
 close(LS);
 print "Total kbytes = $tot_kbytes\n";
 exit();
