#!/usr/bin/perl
##############################################################################
#
#  Find the differences in two files of cost collectors.
#  Process the differences to make it easier to do adds, deletes, and
#  updates to qualifier table in Roles DB.
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
##############################################################################
$file1 = "fund.roles";
$file2 = "fund.warehouse";
$diff_file = "fund.diffs";
$outfile = "fund.actions";
$temp1 = "fund1.temp";
$temp2 = "fund2.temp";
 
print "Sorting first file...\n";
system("sort -t '!' -k 1,2 -o $temp1 $file1\n");
print "Sorting 2nd file...\n";
system("sort -t '!' -k 1,2 -o $temp2 $file2\n");
 
 
print "Comparing files $file1 and $file2...\n";
system("diff $temp1 $temp2 |"            # Find differences in two files
       . " grep '^[><]' |"               # Select only added/deleted lines
       . " sed 's/< FUND/<\!FUND/' |"    # Add ! field marker
       . " sed 's/> FUND/>\!FUND/' |"    # Add ! field marker
       . " sort -t '!' -k 2,3 -k 1,1 |"  # Sort on type, qualcode, [<>]
       . " grep -v 'FC_'"             # Omit custom fund groups
       . " > $diff_file");
 
##############################################################################
#
#  Now read in the differences file. 
# 
#  Read '<' records from $diff_file into (@old_code, @old_parent, @old_name)
#  Read '>' records from $diff_file into (@new_code, @new_parent, @new_name)
#
##############################################################################
 unless (open(IN,$diff_file)) {
   die "Cannot open $diff_file for reading\n"
 }
 @old_code = ();
 @old_parent = ();
 @old_name = ();
 @new_code = ();
 @new_parent = ();
 @new_name = ();
 $i = 0;
 print "Reading records from differences file...\n";
 while (chop($line = <IN>)) {
   if (($i++)%1000 == 0) {print $i . "\n";}
   ($oldnew, $qualtype, $qualcode, $parentcode, $qname) = split('!', $line);
   #print "$oldnew - $qualtype - $qualcode - $parentcode - $qname\n";
   if ($oldnew eq '<') {
     push(@old_code, $qualcode);
     push(@old_parent, $parentcode);
     push(@old_name, &strip($qname));
   }
   else {
     push(@new_code, $qualcode);
     push(@new_parent, $parentcode);
     push(@new_name, &strip($qname));
   }
 }
 
#
#   Open output file.
#
  $outf = "|cat >" . $outfile;
  if( !open(F2, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }
#
#  Now compare lines from the old and new arrays.
#  Print out "Delete", "Update", and "Add" records depending on
#  how things match up.
#
 print "Comparing lines from old and new arrays...\n";  
 $old_p = 0;  # Set pointers
 $new_p = 0;  # Set pointers   
 $old_max = @old_code;
 $new_max = @new_code;
 while (($old_p < $old_max) & ($new_p < $new_max)) {
   #print "$old_p $new_p \n";
   if ($old_code[$old_p] lt $new_code[$new_p]) {
     print F2 "DELETE!$old_code[$old_p]\n";
     $old_p++;
   }
   elsif ($old_code[$old_p] eq $new_code[$new_p]) {
     if ($old_parent[$old_p] ne $new_parent[$new_p]) {
       print F2 "UPDATE!$old_code[$old_p]!PARENT"
                . "!$old_parent[$old_p]!$new_parent[$new_p]\n";
     }
     if ($old_name[$old_p] ne $new_name[$new_p]) {
       print F2 "UPDATE!$old_code[$old_p]!NAME"
                . "!$old_name[$old_p]!$new_name[$new_p]\n";
     }
     $old_p++;
     $new_p++;
   }
   else { # $old_code gt $new_code
     print F2 "ADD!$new_code[$new_p]!$new_parent[$new_p]!$new_name[$new_p]\n";
     $new_p++;
   }
 }
 
#
#  Handle left-over lines.
#
 while ($old_p < $old_max) {
   print F2 "DELETE!$old_code[$old_p]\n";
   $old_p++;
 }
 
 while ($new_p < $new_max) {
   print F2 "ADD!$new_code[$new_p]!$new_parent[$new_p]!$new_name[$new_p]\n";
   $new_p++;
 }
 
 close (F2);
 
###########################################################################
#
#  Function &strip(string)
#  Strips off trailing <cr> and leading and trailing blanks.
#
###########################################################################
sub strip {
  local($s);  #temporary string
  $s = $_[0];
  while ($s =~ /[\s\n]$/) {   # Remove trailing <cr> or space
    chop($s);
  }
  while (substr($s,0,1) =~ /^\s/) {
    $s = substr($s,1);
  }
 
  $s;
}
 
 
