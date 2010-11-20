#!/usr/bin/perl
#######################################################################
#
#  This routine reads in the files xxxx.actions and makes a list of
#  qualifiers for which qualifier_descendent table entries must be
#  re-evaluated and fixed.
#
#  For each of these qualifiers q (and children of these qualifiers),
#  it generates a list of records that should be in qualifier_descendent
#  where child_id = q.  It then looks up existing records in the
#  qualifier_descendent table and generates "insert" or "delete" records
#  to fix the qualifier_descendent table.
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
#######################################################################
#
# Set up some constants and variables
#
$action_file = "fund.actions";
#$qualifier_type = 'COST';
#$action_file = "aso.changes";
$qualifier_type = 'FUND';
$outfile = "fix_desc.sql"; 

#
#  Read in $action_file and build an array of qualifiers that must
#  be fixed.
# 
 unless (open(IN,$action_file)) {
   die "Cannot open $action_file for reading\n"
 }
 $i = 0;
 @fix_qcode = ();
 print "Reading $action_file and building list of qualifiers that"
       . " must be fixed in desc. table...\n";
 while ( (chop($line = <IN>)) && ($i++ < 999999) ) {
   ($action, $qcode, $update_field, $old_value, $new_value)
     = split("!", $line);   # Split into 5 fields (for UPDATE records)
   $qcode = &strip($qcode);
   #print "$qcode - $action - $update_field\n";
   if (($action eq 'ADD') || ($action eq 'ADDCHILD')
       || (($action eq 'UPDATE') && ($update_field eq 'PARENT'))) {
     push(@fix_qcode, $qcode);
   }
 }
 #for ($i = 0; $i < @fix_qcode; $i++) {
 #  print "$i $fix_qcode[$i]\n";
 #}
 close(IN);

#
#  Make sure we are set up to use Oraperl.
#
use Oraperl;
if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}

#
#  Get username and password.
#
 $db = 'roles';
 print "Enter username for sqlplus connection: ";
 chop($user = <STDIN>);
 print "Enter password for user '$user' at $db: ";
 system("stty -echo\n");
 chop($pw = <STDIN>);
 print "\n";
 system("stty echo\n");

#
#  Open first connection to oracle.  Find the minimum and maximum
#  qualifier_id associated with the given qualifier_type.
#
 $lda = &ora_login($db, $user, $pw)
 	|| die $ora_errstr;
 @stmt = ("select min(qualifier_id), max(qualifier_id) from qualifier "
          . "where qualifier_type = '$qualifier_type'");
 $csr = &ora_open($lda, "@stmt")
 	|| die $ora_errstr;

#
#  Get the minimum and maximum qualifier_ids.
#
 ($min_id, $max_id) = &ora_fetch($csr);
 print "Qualifier_type = '$qualifier_type': Min(qual_id) = $min_id"
       . " Max(qual_id) = $max_id\n";
 do ora_close($csr) || die "can't close cursor 1";
 
#
#  Open 2nd cursor
#
 $lda = &ora_login($db, $user, $pw)
	|| die $ora_errstr;
 @stmt = ("select parent_id, child_id from qualifier_child "
         . "where parent_id between $min_id and $max_id");
 $csr = &ora_open($lda, "@stmt")
 	|| die $ora_errstr;

#
#  Read the table qualifier_child into two hashes so we can easily find
#  a child from a parent or a parent from a child.
#
 print "Reading in qualifier_child table...\n";
 %parent_of = ();  # Initialize a null hash for parents/children.
 %child_of = ();  # Initialize a null hash for parents/children.
 @child = (); # Initialize a null array for children.
 while (($par, $chi) = &ora_fetch($csr)) {
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
 do ora_close($csr) || die "can't close cursor 2";

#
#  Open 3rd cursor.  Read in qualifier table
#
$lda = &ora_login($db, $user, $pw)
	|| die $ora_errstr;
@stmt = ("select qualifier_code, qualifier_id from qualifier"
         . " where qualifier_type = '$qualifier_type'");
$csr = &ora_open($lda, "@stmt")
	|| die $ora_errstr;

#
#  Read qualifier table into a hash.
#
 print "Reading in qualifier table...\n";
 %qid_of = ();  # Initialize a null hash for qcode -> qid
 $i = 0;
 while (($qqcode, $qqid) = &ora_fetch($csr)) {
   if (($i++)%5000 == 0) {print $i . "\n";}   
   $qid_of{$qqcode} = $qqid;
 }
 do ora_close($csr) || die "can't close cursor 3";

#
#  Convert each each qualifier_code $fix_qcode[$i] to a qualifier_id
#  in @fix_qid array.
#
 @fix_qid = ();  # Set up an empty array of qualifier_id values
 for ($i = 0; $i < @fix_qcode; $i++) {
   $qqid = $qid_of{$fix_qcode[$i]};
   if ($qqid ne '') {
     push(@fix_qid, $qqid);
   }
   else {
     print "Error - qualifier_code '$fix_qcode[$i]' not found\n";
   }
 }
 #for ($i = 0; $i < @fix_qid; $i++) {
 #  print "$i $fix_qid[$i]\n";
 #}

#
#  For each qualifier_id in @fix_qid, call recursive subroutine &add_children
#  to add its children (and its children's children, etc.) to the array.
#
 $n = @fix_qid;
 print "Finding descendents of selected qualifiers...\n";
 for ($i = 0; $i < $n; $i++) {
   &add_children($fix_qid[$i]);
 }

#
#  Remove duplicates from @fix_qid
#
 print 'Removing duplicates from @fix_qid array...', "\n";
 @new_fix_qid = ();
 %counta = ();
 for ($i = 0; $i < @fix_qid; $i++) {
   $n = ++$counta{$fix_qid[$i]};   # Count the number of occurences of each
   if ($n < 2) {
     push(@new_fix_qid, $fix_qid[$i]);
   }
 }
 @fix_qid = @new_fix_qid;

#
#  For each qualifier_id in @fix_qid, call recursive routine &gendesc1 to 
#  get a list of parents (and parents of parents) and put them in 
#  @new_ancestor.
#  Then get a list of parent_id values from table qualifier_descendent where 
#  child_id = the current qualifier_id, putting them in @old_ancestor.
#  For each item in @new_ancestor but not in @old_ancestor, generate an 
#  INSERT record;  for each item in @old_ancestor but not @new_ancestor, 
#  generate a DELETE record.
#
 print "Generating INSERTs and DELETEs...\n";
 $outf = "|cat >" . $outfile;
 if( !open(F2, $outf) ) {
   die "$0: can't open ($outf) - $!\n";
 }
 foreach $qid (@fix_qid) {
   print "Processing $qid...\n";
   @new_ancestor = ();   # Clear the @new_ancestors array
   @old_ancestor = ();   # Clear the @new_ancestors array
   @old_not_new = ();    # Clear
   @new_not_old = ();    # Clear
   %mark1 = ();          # Clear
   %mark2 = ();          # Clear
   @parents = split('!', $parent_of{$qid});  # Split into elements
   for ($i = 0; $i < @parents; $i++) {
     &gendesc1($parents[$i], $qid);  # Call recursive function 
   }
   #
   #  Now open a cursor and get a list of parents into @old_ancestor.
   #
   &get_old_ancestor($qid);
   #
   #  Compare @old_ancestor and @new_ancestor
   #
   grep($mark1{$_}++, @new_ancestor);  # Each item -> mark 
   @old_not_new = grep(!$mark1{$_},@old_ancestor); # Items in @old, not @new 

   grep($mark2{$_}++, @old_ancestor);  # Each item -> mark
   @new_not_old = grep(!$mark2{$_},@new_ancestor); # In @new, not @old
   #print "Old: @old_ancestor \n";
   #print "New: @new_ancestor \n";
   print "Old-not-new: @old_not_new \n";
   print "New-not-old: @new_not_old \n";
   foreach $newid (@new_not_old) {
     print F2 "insert into qualifier_descendent values($newid,$qid);\n"; 
   }
   foreach $oldid (@old_not_new) {
     print F2 "delete from qualifier_descendent where parent_id = '$oldid'"
              . " and child_id = '$qid';\n";
   }
 }

 &ora_logoff($lda);
 exit();

###########################################################################
#
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

########################################################################
#
#  Recursive routine gendesc1($parent,$child) to generate descendents.
#
###########################################################################
sub gendesc1 {
  my($p) = $_[0];  # Local $p is current parent qualifier_id
  my($d) = $_[1];  # Local $d is current descendent qualifier_id
  my(@parents);    # Local array of parents for a node.
  my($i);          # Local counter
  #print "p=$p d=$d\n";
  push(@new_ancestor, $p);  # Add an ancestor
  if (exists($parent_of{$p})) {   # Does the parent have a parent?
    @parents = split('!', $parent_of{$p});  # Split into elements
    for ($i = 0; $i < @parents; $i++) {
      &gendesc1($parents[$i], $d);  # Call recursive function 
    }
  }
}  

########################################################################
#
#  Recursive routine add_children($qid) adds children and grandchildren,
#  etc. of $qid to @fix_qid
#
###########################################################################
sub add_children {
  my($qid) = $_[0];  # Local $qid is current qualifier_id
  my($i, @children);
  @children = split('!', $child_of{$qid});
  for ($i = 0; $i < @children; $i++) {
    push(@fix_qid, $children[$i]);  # Add a child to the array
    &add_children($children[$i]);   # Call recursive function 
  }
}

########################################################################
#
#  Subroutine &get_old_ancestor
#  Extract a list of parent_ids from qualifier_descendent table
#  where child_id is the given $qid.  Put the result into @old_ancestor;
#
###########################################################################
sub get_old_ancestor {
 my ($child_id, @stmt, $csr, $par_id);
 $child_id = $_[0];
 #
 #  Open a cursor
 #
 @stmt = ("select parent_id from qualifier_descendent"
          . " where child_id = '$child_id'");
 $csr = &ora_open($lda, "@stmt")
 	|| die $ora_errstr;
 #
 #  Read in the rows
 #
 while (($par_id) = &ora_fetch($csr)) {
   push(@old_ancestor, $par_id);
   $qid_of{$qqcode} = $qqid;
 }
 do ora_close($csr) || die "can't close cursor in get_old_ancestor";
}





