#!/usr/bin/perl
###########################################################################
#
#  Perl script populate arrays and hashes to test performance.
#
#
#  Copyright (C) 1998-2010 Massachusetts Institute of Technology
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
#  Set some constants for controlling the performance test
#
 $max_num = 100000;

#
#  Build an array and two hashes with $max_num elements.
#
 print "Building the array and hashes ($max_num)...\n";
 chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
 print "Starting at $time\n";

 %parent_of = ();  # Initialize a null hash for parents/children.
 %child_of = ();  # Initialize a null hash for parents/children.
 @child = (); # Initialize a null array for children.
 my $rec_count = 0;
 my $populate_arrays = 1;
 my $chi = 0;
 my $par = $max_num + 1;
 for ($i=0; $i < $max_num; $i++) {
   if (($rec_count++)%20000 == 0) {print "Record # $rec_count\n";}
   $chi++;
   unless ( ($par % 1000) == 1 ) { $par--; }
   if ($populate_arrays) {
     if (not (exists($parent_of{$chi}))) {
       $parent_of{$chi} = $par;
       push(@child, $chi);  
     }
     else {
       $parent_of{$chi} = $parent_of{$chi} . '!' . $par;
     }
     if (not (exists($child_of{$par}))) {
       $child_of{$par} = $chi;
     }
     else {
       $child_of{$par} = $child_of{$par} . '!' . $chi;
     }
   }
 }

 chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
 print "Ending at $time\n";

exit();

