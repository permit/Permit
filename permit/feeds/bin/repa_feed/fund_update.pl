#!/usr/bin/perl
#######################################################################
#
#  Read the differences file produced by 'compare_cost3.pl' and
#  process the 'UPDATE' records, changing the qualifier_name
#  in the qualifier table and/or the parent of a qualifier (as
#  specified in the qualifier_child and qualifier_descendent tables).
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
#######################################################################
#
#  Initialize
#
 $tname = "qualifier";
 $tname2 = "qualifier_child";
 $tname3 = "qualifier_descendent";
 $infile = "fund.actions";
 #$infile = "aso.changes";
 $qualtype = 'FUND';
 $logfile = "fundupdate.sql";
 
#
#  Make sure we are set up to use Oraperl.
#
 use Oraperl;
 if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}
 
#
#  Get username and password for Warehouse database connection.
#
 print "Enter database name for sqlplus connection: ";
 chop($db = <STDIN>);
 print "Enter username for sqlplus connection: ";
 chop($user = <STDIN>);
 print "Enter password for user '$user' at $db: ";
 system("stty -echo\n");
 chop($pw = <STDIN>);
 print "\n";
 system("stty echo\n");
 $userpw = $user . '/' . $pw;
 
 
#
#  Open connection to oracle
#
 $lda = &ora_login($db, $userpw, '')
        || die $ora_errstr;
 
#
#  Open a cursor and read all records from the qualifier table
#  for the given qualtype.  Build a hash %rquid that maps qualifier_code
#  to qualifier_id. Build another one, %rqlevel, that maps qualifier_code
#  to qualifier_level. 
#
 @stmt = ("select qualifier_id, qualifier_code, qualifier_level from $tname"
          . " where qualifier_type = '$qualtype'");
 $csr = &ora_open($lda, "@stmt")
        || die $ora_errstr;
 print "Reading in Qualifiers from Oracle table...\n";
 $i = -1;
 while ((($qqid, $qqcode, $qqlevel) = &ora_fetch($csr))) {
   if (($i++)%1000 == 0) {print $i . "\n";}
   $rquid{$qqcode} = $qqid;
   $rqlevel{$qqcode} = $qqlevel;
 }
 
 do ora_close($csr) || die "can't close cursor";
 
#
#  Open another cursor and read the table qualifier_child into a hash
#  for the given qualtype.  Build a hash %rquid that maps qualifier_code
#  to qualifier_id. Build another one, %rqlevel, that maps qualifier_code
#  to qualifier_level. 
#
 @stmt = ("select parent_id, child_id from $tname2"
          . " where parent_id >="
          . " (select min(qualifier_id) from qualifier"
          . " where qualifier_type = '$qualtype')"
          . " and parent_id <="
          . " (select max(qualifier_id) from qualifier"
          . " where qualifier_type = '$qualtype')");
 $csr = &ora_open($lda, "@stmt")
        || die $ora_errstr;
#
#  Read the table into a hash.
#
 print "Reading in Qualifier child records from Oracle table...\n";
 $i = -1;
 %parent_of = ();  # Initialize a null hash for parents/children.
 while (($par, $chi) = &ora_fetch($csr)) {
   if (($i++)%1000 == 0) {print $i . "\n";}
   if (exists $parent_of{$chi}) {
     $parent_of{$chi} = $parent_of{$chi} . '!' . $par;
   }
   else {
     $parent_of{$chi} = $par;
   }
 }
 do ora_close($csr) || die "can't close cursor 1";
 
#
#   Open output file.
#
  $outf = "|cat >" . $logfile;
  if( !open(F1, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }
  chop($today = `date`);
  print F1 "/* Updates generated " . $today . " */\n";
  print F1 "set define off;\n";
 
#
#  Read the input file.  Look for "UPDATE" records.  Then check the
#  field to be updated:  NAME or PARENT.  For NAME, perform an SQL
#  UPDATE of the qualifier_name field.  For PARENT, call the
#  recursive subroutine &update_parent();  
#
 unless (open(IN,$infile)) {
   die "Cannot open $infile for reading\n"
 }
 $i = 0;
 print "Reading in the file $infile...\n";
 while ( (chop($line = <IN>)) && ($i++ < 999999) ) {
   print "$i $line\n";
   ($action, $qcode, $update_field, $old_value, $new_value)
     = split("!", $line);   # Split into 5 fields (for UPDATE records)
   $qcode = &strip($qcode);
   $new_value = &strip($new_value);
   #print "Action = $action, update_field = $update_field, "
   #      . "qcode = $qcode, '$old_value'->'$new_value'\n";
   if ($action eq 'UPDATE') {
     if ($update_field eq 'NAME') {
       $new_value =~ s/'/''/;   # Change quotes for SQL statement
       print F1 "update $tname set qualifier_name = '$new_value'"
                . " where qualifier_type = '$qualtype'"
                . " and qualifier_code = '$qcode';\n";
     }
     elsif ($update_field eq 'PARENT') {
       $qqid = $rquid{$qcode};       # Get qualifier_id
       $old_parentcode = &strip($old_value);
       $new_parentcode = &strip($new_value);
       $old_parentcode =~ s/P/0PR/;   # Match format in Roles DB
       $new_parentcode =~ s/P/0PR/;   # Match format in Roles DB
       $old_parentid = $rquid{$old_parentcode};
       $old_parentlevel = $rqlevel{$old_parentcode};
       $new_parentid = $rquid{$new_parentcode};
       $new_parentlevel = $rqlevel{$new_parentcode};
       $new_level = $new_parentlevel + 1;
       $old_level = $rqlevel{$qcode};
       if ($qqid eq '') {               # Error
         print "Error: qualifier '$qcode' not found in $tname table.\n";
       }
       elsif ($old_parentid eq '') {    # Error
         print "Error updating '$qcode': Old parent '$old_parentcode'"
               . " not found in $tname table.\n";
       }
       elsif ($new_parentid eq '') {    # Error
         print "Error updating '$qcode': New parent '$new_parentcode'"
               . " not found in $tname table.\n";
       }
       elsif ($old_level eq '') {       # Error
         print "Error: Blank qualifier_level set for '$qcode'\n";
       }
       else {                           # OK.  Do the update
         if ($new_level != $old_level) {
           print F1 "update $tname set qualifier_level = '$new_level'"
                    . " where qualifier_type = '$qualtype'"
                    . " and qualifier_code = '$qcode';\n";
         }
         &update_parent($qqid, $old_parentid, $new_parentid);
       }
     }
     else {
       print "Unrecognizable update_field: '$update_field'.  qcode=$qcode\n";
     }
   }
 }
 close(IN);
 close(F1);
 
#  
#  Commit work and logoff.
#
 &ora_commit($lda); #Now we can commit
 &ora_logoff($lda);
 exit();
 
##########################################################################
#
#  update_parent:  Updates the parent of a qualifier.
#
##########################################################################
sub update_parent {
  my ($qid, $o_pid, $n_pid, $i, $j);
  $qid = $_[0];
  $o_pid = $_[1];
  $n_pid = $_[2];
  print F1 "/* Updating '$qid' changing parent from '$o_pid' to '$n_pid' */\n";
  #
  #  Save all descendents of $qid.
  #
   @descendents_of_qid = ();
   @stmt = ("select child_id from $tname3"
            . " where parent_id = $qid");
   $csr = &ora_open($lda, "@stmt")
          || die $ora_errstr;
   #print "Reading in descendents of '$qid' from Oracle table...\n";
   while (($chid) = &ora_fetch($csr)) {
     push(@descendents_of_qid, $chid);
   }
   do ora_close($csr) || die "can't close cursor";
 
  #
  #  Delete all records in qualifier_descendent 
  #  where child_id = $qid or child_id is a descendent
  #  of $qid.
  #
   @deleted_desc_pair = ();
   @stmt = ("select parent_id, child_id from qualifier_descendent"
            . " where child_id = $qid"
            . " union"
            . " select parent_id, child_id from qualifier_descendent"
            . " where child_id in (select child_id from qualifier_descendent"
            . " where parent_id = $qid)");
   $csr = &ora_open($lda, "@stmt")
          || die $ora_errstr;
   #print "Finding records to be deleted from qualifier_descendent...\n";
   while (($delp_id, $delc_id) = &ora_fetch($csr)) {
     push(@deleted_desc_pair, $delp_id . '!' . $delc_id);
   }
 
  #
  #  Delete old parent of $qid.  (Update has_child?)
  #  Add new parent of $qid. (Update has_child?)
  #  
   print F1 "delete from $tname2 where parent_id = $o_pid and"
            . " child_id = $qid;\n";
   print F1 "insert into $tname2 values ($n_pid, $qid);\n";
   my @parent = split('!', $parent_of{$qid});  
   my $n = @parent;  # How many parents?
   if ($n == 1) {    # If just 1, then set the parent_of value  
     $parent_of{$qid} = $n_pid;
   }
   else {            # If more than 1, then decompose the string...
     for ($i = 0; $i < $n; $i++) {
       if ($parent[$i] = $o_pid) {
         $parent[$i] = $n_pid;     #...change the appropriate element...
       }
     }
     $parent_of{$qid} = join('!', @parent);  #...and put it back together.
   }
 
  #
  #  Now, call &gendesc to generate records for the qualifier_descendent
  #  table for $qid and each ancestor of its.  Do the same for each
  #  descendent of $qid and the descendent's ancestors.
  #
   @add_desc_pair = (); # Null parents/child array
   # Call &gendesc for $qid and its ancestors
   @parent = split('!', $parent_of{$qid});  
   $n = @parent;  # How many parents?
   for ($i = 0; $i < $n; $i++) {
     #print F1 "n=$n i=$i qid=$qid parent_of{qid}[i]='$parent[$i]'\n";
     &gendesc($parent[$i], $qid); # Call recursive function 
   }
   # Call &gendesc for each descendent of $qid and its ancestors 
   for ($j = 0; $j < @descendents_of_qid; $j++) {
     $desc_id = $descendents_of_qid[$j];
     @parent = split('!', $parent_of{$desc_id});
     $n = @parent;  # How many parents?
     for ($i = 0; $i < $n; $i++) {
      #print F1 "n=$n i=$i desc_id=$desc_id parent_of{qid}[i]='$parent[$i]'\n";
       &gendesc($parent[$i], $desc_id); # Call recursive function 
     }
   }
 
  #
  #  Print out results
  #
  if (0) {
    print F1 "Deleted qualifier_descendent records:\n";
    for ($i = 0; $i < @deleted_desc_pair; $i++) {
      print F1 "$deleted_desc_pair[$i]\n";
    }
    print F1 "Added qualifier_descendent records:\n";
    for ($i = 0; $i < @add_desc_pair; $i++) {
      print F1 "$add_desc_pair[$i]\n";
    }
  }
  
  #
  #  Find the differences between the delete and add arrays.
  #
   local(%count1);  # Hash %count1 will count occurences of array items
   grep($count1{$_}++, @deleted_desc_pair);  # Each item -> count
   @add_not_del = grep(!$count1{$_},@add_desc_pair); # Items in @add, not @del 
 
   local(%count2);  # Hash %count2 will count occurences of array items
   grep($count2{$_}++, @add_desc_pair);  # Each item -> count
   @del_not_add = grep(!$count2{$_},@deleted_desc_pair); # In @del, not @add
 
  #
  #  Do the deletes and adds.
  #
   if (1 == 0) {   # Don't do it:  Let fix_desc.pl do it later.
     for ($i = 0; $i < @del_not_add; $i++) {
       ($p, $c) = split('!',$del_not_add[$i]);
       print F1 "delete from $tname3 where parent_id = $p"
                . " and child_id = $c;\n";
     }
     for ($i = 0; $i < @add_not_del; $i++) {
       ($p, $c) = split('!',$add_not_del[$i]);
       print F1 "insert into  $tname3 values($p, $c);\n";
     }
   }
}
 
 
########################################################################
#
#  Recursive routine gendesc($parent,$child) to generate descendents.
#
###########################################################################
sub gendesc {
  my($p) = $_[0];  # Local $p is current parent qualifier_id
  my($c) = $_[1];  # Local $c is current descendent qualifier_id
  my($i);
  #print "p=$p c=$c\n";
  push(@add_desc_pair,$p . '!' . $c);  # Add a descendent/child pair
  if (exists($parent_of{$p})) {   # Does the parent have a parent?
    my @parent = split('!', $parent_of{$p});
    my $n = @parent;  # How many parents?
    for ($i = 0; $i < $n; $i++) {
       &gendesc($parent[$i], $c);  # Call recursive function 
    }
  }
}  
 
##########################################################################
#
#  Strips off trailing <cr> and leading and trailing blanks.
#
##########################################################################
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
