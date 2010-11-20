###############################################################################
## NAME: roles_qual.pm
##
## DESCRIPTION: 
## This module contains shared routines for qualifier feeds.
##
## MODIFICATION HISTORY:
##
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
## 3/4/1998 Jonathan Ives, Jim Repa. -Created.
## 3/23/1998  Modified to remove duplicates in FixDescendents - J. Repa
## 5/8/1998 Fix bug in check for deleting qualifiers with children - J. Repa
## 5/11/1998 Add &fix_haschild routine - J. Repa
## 5/19/1998 Add DELCHILD, action - J. Repa
## 5/20/1998 Change s/'/''/ -> s/'/''/g - J. Repa
## 6/5/1998, 7/29/1998 Set custom_hierarchy = 'Y' for new P_ or FC_ qualifiers
## 8/31/1998, Set ROLLBACK option on WHENEVER statement - J. Repa
## 7/19/2004, Handle "sensitive" qualifiers, and handle external_auth records.
## 09/20/2006 Adding the status and last_modified_date fields 
###############################################################################

package roles_qual;
$VERSION = 1.0;

use Exporter;				#Standard Perl Module
@ISA = ('Exporter');			#Inherit from Exporter	
@EXPORT_OK = qw(strip ProcessActions FixDescendents sort_actions fix_haschild);
					#These routine names may be imported
					#into the calling modules name space
## Set Test Mode
$TEST_MODE = 1;            ## Test Mode (1 == ON, 0 == OFF)
if ($TEST_MODE) {print "TEST_MODE is ON for roles_base.pm\n";}

## Set the qualifier_name for suppressed qualifiers
$SUPPRESSED_NAME = '(value suppressed)';


###############################################################################
###############################################################################
##
## Subroutines - Common Routines to be used by calling packages
##
###############################################################################
###############################################################################


#######################################################################
#
#  Read the differences file produced by 'compare_cost2.pl' and
#  process the 'ADD' records, adding new records to qualifier table 
#  and qualifier_child table.
#
#######################################################################
#
# Set up Oraperl
#
eval 'use Oraperl; 1' || die $@ if $] >= 5;
die ("Need to use oraperl, not perl\n") unless defined &ora_login;
$| = 1; #Force Ouput Buffer to Flush on each write

use roles_base qw(UsageExit ScriptExit RolesLog RolesNotification ArchiveFile);


#
#  Initialize
#
 $tname = "qualifier";
 $tname2 = "qualifier_child";
 $tname3 = "qualifier_descendent";

###############################################################################
sub ProcessActions
###############################################################################
{ 

 my($lda, $qualtype, $infile, $sqlfile) = @_;

if (not $lda)      ## If we logged in ok
{	
 &RolesLog("FATAL_MSG",
	"Not Logged into source database");
}
 
#
#  Find out if this qualifier_type is "sensitive".
#
 my $stmt0 = "select nvl(is_sensitive, 'N') from qualifier_type"
           . " where qualifier_type = '$qualtype'";
 my $csr0  = &ora_open($lda, $stmt0)
             || die $ora_errstr;
 my $is_sensitive;
 ($is_sensitive) = &ora_fetch($csr0);
 &ora_close($csr0);
#
#  Open first cursor to get the next available qualifier_id from the
#  qualifier table for the given qualtype.
#
 @stmt = ("select max(qualifier_id) from $tname"
          . " where qualifier_type = '$qualtype'");
 $csr = &ora_open($lda, "@stmt")
        || die $ora_errstr;
 ($max_qual_id) = &ora_fetch($csr);
 do ora_close($csr) || die "can't close cursor";
 $next_qqid = $max_qual_id + 1;  # Add 1
 print "Next qualifier_id = $next_qqid\n"; 
 
#
#  Open another cursor, and read all records from the qualifier table
#  for the given qualtype.  Build a hash %rquid that maps qualifier_code
#  to qualifier_id. Build another one, %rqlevel, that maps qualifier_code
#  to qualifier_level. 
#
 @stmt = ("select qualifier_id, qualifier_code, qualifier_level, has_child, status"
          . " from $tname"
          . " where qualifier_type = '$qualtype'");
 $csr = &ora_open($lda, "@stmt")
        || die $ora_errstr;
 print "Reading in Qualifiers from Oracle table...\n";
 $i = -1;
 while ((($qqid, $qqcode, $qqlevel, $qhaschild,$qstatus) = &ora_fetch($csr))) {
   if (($i++)%5000 == 0) {print $i . "\n";}
   $rquid{$qqcode} = $qqid;
   $rqlevel{$qqcode} = $qqlevel;
   $rqhc{$qqcode} = $qhaschild;
}
 
 do ora_close($csr) || die "can't close cursor";

#
#  Call &get_qual_in_auth to populate the %auth_qcode hash.  We'll
#  use this hash to identify qualifier_codes that are in use by an 
#  authorization, and we'll avoid deleting such qualifiers.
#
 my %auth_qcode = ();
 &get_qual_in_auth($lda, $qualtype, \%auth_qcode);
 
#
#   Open output files.
#
  $outf3 = ">" . $sqlfile;
  if( !open(F3, $outf3) ) {
    die "$0: can't open ($outf3) - $!\n";
  }
  chop($today = `date`);
  print F3 "/* Updates generated " . $today . " */\n";
  print F3 "set define off;\n";
  print F3 "whenever sqlerror exit -1 rollback;\n";  # Halt on errors.
  print F3 "update qualifier set status ='T' where status = 'I' and "
                                            . "qualifier_type = '$qualtype';\n"; 
#
#  Read the input file.  Look up qualifier_id of parent.  
#  Look for ADD, UPDATE, and DELETE records.
#  Also ADDCHILD, DELCHILD.
#  Write SQL statements (INSERT, DELETE, and UPDATE) to $sqlfile.
#  When processing "UPDATE" records, check the
#  field to be updated:  NAME or PARENT.  For NAME, perform an SQL
#  UPDATE of the qualifier_name field.
#  
 unless (open(IN,$infile)) {
   die "Cannot open $infile for reading\n"
 }
 $i = 0;
 @qualid = ();
 @qualcode = ();
 @haschild = ();
 @quallevel = ();
 printf "Reading in the file $infile...\n";
 while ( (chop($line = <IN>)) && ($i++ < 999999) ) {
   #print "$i $line\n";
   ($action, $qcode, $parentcode, $qname) 
     = split("!", $line);   # Split into 4 fields (for ADD records)
   #print "Action = $action, qcode = $qcode, nextqqid = $next_qqid\n";
if ($action eq 'ADD') {
     $qcode = &strip($qcode);
     $qname = &strip($qname);
     $parentcode = &strip($parentcode);
     $parentid = $rquid{$parentcode};
     $parentlevel = $rqlevel{$parentcode};
     $parenthc = $rqhc{$parentcode};
     $new_level = $parentlevel + 1;
     $next_qqid++;    # Increment qualifier id
     $qname =~ s/'/''/g;
     if ($parentid eq '') {
         print "'$qcode' not added: Parent '$parentcode'"
               . " not found in $tname table.\n";
    }
  else {
       if ( ($qcode =~ /^FC\_/) || ($qcode =~ /^P\_/) ) {
         $custom_hierarchy = 'Y';
       }
       else {
         $custom_hierarchy = 'N';
       }
         if ($is_sensitive eq 'Y') {
         print F3 "insert into qualifier (QUALIFIER_ID, QUALIFIER_CODE,"
            . " QUALIFIER_NAME, QUALIFIER_TYPE, CUSTOM_HIERARCHY,"
            . " HAS_CHILD, QUALIFIER_LEVEL,LAST_MODIFIED_DATE)"
            . " values('$next_qqid','$qcode','$SUPPRESSED_NAME',"
            . " '$qualtype','$custom_hierarchy','N','$new_level' ,sysdate);\n";
         print F3 "insert into suppressed_qualname (QUALIFIER_ID,"
            . " QUALIFIER_NAME)"
            . " values('$next_qqid','$qname');\n";
       }
        else 
       {
        print F3 "insert into qualifier (QUALIFIER_ID, QUALIFIER_CODE,"
            . " QUALIFIER_NAME, QUALIFIER_TYPE, CUSTOM_HIERARCHY,"
            . " HAS_CHILD, QUALIFIER_LEVEL,LAST_MODIFIED_DATE)"
            . " values('$next_qqid','$qcode','$qname',"
            . " '$qualtype','$custom_hierarchy','N','$new_level',sysdate);\n";
       }

       print F3 "insert into qualifier_child"
            . " values($parentid, $next_qqid);\n";
       if ($parenthc ne 'Y') {   # Modify has_child field of parent
         print F3 "update qualifier set has_child = 'Y' "
            . "where qualifier_id = $parentid;\n";
       }
       # Add this qualifier to the in-core hashes
       $rquid{$qcode} = $next_qqid;
       $rqlevel{$qcode} = $new_level;
     }
   }
   elsif ($action eq 'ADDCHILD') {
     $qcode = &strip($qcode);
     $qqid = $rquid{$qcode};
     $parentcode = &strip($parentcode);
     $parentid = $rquid{$parentcode};
     $parentlevel = $rqlevel{$parentcode};
     $parenthc = $rqhc{$parentcode};
     $new_level = $parentlevel + 1;
     if ($parentid eq '') {
         print "(child,parent) pair ('$qcode','$parentcode') not added:"
               . " Parent '$parentcode'"
               . " not found in $tname table.\n";
     }
     elsif ($qqid eq '') {
         print "(child,parent) pair ('$qcode','$parentcode') not added:"
               . " Child '$qcode'"
               . " not found in $tname table.\n";
     }
     else {
       print F3 "insert into qualifier_child"
              . " values($parentid, $qqid);\n";
       if ($parenthc ne 'Y') {   # Modify has_child field of parent
         print F3 "update qualifier set has_child = 'Y' "
              . "where qualifier_id = $parentid;\n";
       }
     }
   }
   elsif ($action eq 'DELCHILD') {
     $qcode = &strip($qcode);
     $qqid = $rquid{$qcode};
     $parentcode = &strip($parentcode);
     $parentid = $rquid{$parentcode};
     if ($parentid eq '') {
         print "(child,parent) pair ('$qcode','$parentcode') not deleted:"
               . " Parent '$parentcode'"
               . " not found in $tname table.\n";
     }
     elsif ($qqid eq '') {
         print "(child,parent) pair ('$qcode','$parentcode') not deleted:"
               . " Child '$qcode'"
               . " not found in $tname table.\n";
     }
     else {
       print F3 "delete from qualifier_child where"
              . " parent_id = $parentid and child_id = $qqid;\n";
     }
   }
   elsif ($action eq 'DELETE') {
     $qcode = &strip($qcode);
     $qhaschild = $rqhc{$qcode};
     $qqid = $rquid{$qcode};
     if ($auth_qcode{$qcode} == 1) {
       print "***Cannot delete $qcode:  Referenced by an authorization\n";
       print F3 "update qualifier set status = 'I'"
             . " where qualifier_code =  '$qcode'"
             . " and qualifier_type = '$qualtype'" 
             . " and nvl(status,'A') =  'T';\n"; 
       print F3 "update qualifier set status = 'I',"
             . "last_modified_date = sysdate"
             . " where qualifier_code =  '$qcode'"
             . " and qualifier_type = '$qualtype'" 
             . " and nvl(status,'A') = 'A';\n";     
     }
     elsif ($qhaschild eq 'Y') {
       print "***Cannot delete $qcode:  It has children in the hierarchy\n";
       print F3 "update qualifier set status = 'I'"
            . " where qualifier_code =  '$qcode'"
            . " and qualifier_type = '$qualtype'"           
            . " and nvl(status,'A') = 'T';\n"; 
       print F3 "update qualifier set status ='I'," 
            . "last_modified_date = sysdate"
            . " where qualifier_code =  '$qcode'"
            . " and qualifier_type = '$qualtype'"         
            . " and nvl(status,'A') = 'A';\n";
     }
     elsif ($qqid eq '') {
       print "***Cannot delete $qcode:  qualifier_id not found in table\n";
     }
     else {
       print F3 "delete from qualifier_descendent where child_id = '$qqid';\n";
       print F3 "delete from qualifier_child where child_id = '$qqid';\n";
       if ($is_sensitive eq 'Y') {
         print F3 "delete from suppressed_qualname"
                  . " where qualifier_id = '$qqid';\n";
       }
       print F3 "delete from external_auth where qualifier_id = '$qqid';\n";
       print F3 "delete from qualifier where qualifier_id = '$qqid';\n";
     }
   }
   if ($action eq 'UPDATE') {
     ($action, $qcode, $update_field, $old_value, $new_value)
        = split("!", $line);   # Split into 5 fields (for UPDATE records)
     if ($update_field eq 'NAME') {
       $new_value =~ s/'/''/g;   # Change quotes for SQL statement
       if ($is_sensitive eq 'Y') {
         $qqid = $rquid{$qcode};
         print F3 "update suppressed_qualname"
                . " set qualifier_name = '$new_value'"
                . " where qualifier_id = '$qqid';\n";
       }
       else {
         print F3 "update $tname set qualifier_name = '$new_value'"
                . ",last_modified_date = sysdate"
                . " where qualifier_type = '$qualtype'"
                . " and qualifier_code = '$qcode';\n";
       }
     }
     elsif ($update_field eq 'PARENT') {
       $qqid = $rquid{$qcode};       # Get qualifier_id
       $old_parentcode = &strip($old_value);
       $new_parentcode = &strip($new_value);
       $old_parentid = $rquid{$old_parentcode};
       $old_parentlevel = $rqlevel{$old_parentcode};
       $new_parentid = $rquid{$new_parentcode};
       $new_parentlevel = $rqlevel{$new_parentcode};
       $new_level = $new_parentlevel + 1;
       $old_level = $rqlevel{$qcode};
       $new_parenthc = $rqhc{$new_parentcode};
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
           print F3 "update $tname set qualifier_level = '$new_level',"
                    . " last_modified_date = sysdate"   
                    . " where qualifier_type = '$qualtype'"
                    . " and qualifier_code = '$qcode';\n";
         }
         print F3 "delete from $tname2 where parent_id = $old_parentid and"
            . " child_id = $qqid;\n";
         print F3 "insert into $tname2 values ($new_parentid, $qqid);\n";
         if ($new_parenthc ne 'Y') {   # Modify has_child field of parent
           print F3 "update qualifier set has_child = 'Y' "
                . "where qualifier_id = $new_parentid;\n";
         }
       }
     }
     else {
       print "Unrecognizable update_field: '$update_field'.  qcode=$qcode\n";
     }
   }
 }


 print F3 "update qualifier set status = null, last_modified_date= sysdate where status = 'T' and "
                                                . "qualifier_type = '$qualtype';\n"; 

 print F3 "commit;\n";  # If no errors, commit work.
 print F3 "quit;\n";    # Exit from SQLPLUS

 close(IN);
 close(F3);
 
}  ## End of Process Actions

 
########################################################################
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
#######################################################################

###########################################################################
sub FixDescendents #
###########################################################################
{

my($lda, $qualifier_type, $action_file, $outfile) = @_;
print "Qualifier_type = '$qualifier_type'\n";

if (not $lda)      ## If we logged in ok
{	
 &RolesLog("FATAL_MSG",
	"Not Logged into source database");
}
 
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
   if (($action eq 'ADD') || ($action eq 'ADDCHILD') || ($action eq 'DELCHILD')
       || (($action eq 'UPDATE') && ($update_field eq 'PARENT'))) {
     push(@fix_qcode, $qcode);
   }
 }

 close(IN);

#
#  Open first connection to oracle.  Find the minimum and maximum
#  qualifier_id associated with the given qualifier_type.
#
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
 my $rec_count = 0;
 while (($par, $chi) = &ora_fetch($csr)) {
   if (($rec_count++)%20000 == 0) {print "Record # $rec_count\n";}
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
 # Open the .sql file.
 $outf = "|cat >" . $outfile;
 if( !open(F2, $outf) ) {
   die "$0: can't open ($outf) - $!\n";
 }
 # Write some preliminary lines to the .sql file
 chop($today = `date`);
 print F2 "/* Updates generated " . $today . " */\n";
 print F2 "set define off;\n";
 print F2 "whenever sqlerror exit -1 rollback;\n";  # Halt on errors.
 # Now process each qualifier_id in @fix_qid
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
   &get_old_ancestor($lda,$qid);
   #
   #  Compare @old_ancestor and @new_ancestor
   #
    #print "Old: @old_ancestor\n";
    #print "New: @new_ancestor\n";
   grep($mark1{$_}++, @new_ancestor);  # Each item -> mark 
   @old_not_new = grep(!$mark1{$_},@old_ancestor); # Items in @old, not @new 

   grep($mark2{$_}++, @old_ancestor);  # Each item -> mark
   @new_not_old = grep(!$mark2{$_},@new_ancestor); # In @new, not @old
   # Remove dups. from two arrays 
   &remove_duplicates(\@old_not_new);
   &remove_duplicates(\@new_not_old);
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
  
#
#  Now write final lines to the .sql file and close it.
#  
  print F2 "commit;\n";  # Commit changes
  print F2 "quit;\n";    # Exit from SQLPLUS
  close(F2);
 
}  ## End of Sub




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
#  Subroutine &get_old_ancestor($lda, $child_id)
#  Extract a list of parent_ids from qualifier_descendent table
#  where child_id is the given $qid.  Put the result into @old_ancestor;
#
###########################################################################
sub get_old_ancestor {
 my ($lda, $child_id, @stmt, $csr, $par_id);
 $lda = $_[0];
 $child_id = $_[1];
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

##############################################################################
#
#  Subroutine sort_actions(\@actions)
#
#  Takes a reference to an "actions" array as an argument.  Each element
#  of array is a record of one of the following formats:
#     ADD!qualifier_code!parent_code!qualifier_name
#     UPDATE!qualifier_code!PARENT!old_parent_code!new_parent_code 
#     UPDATE!qualifier_code!NAME!old_qualifier_name!new_qualifier_name
#     DELETE!qualifier_code
#
#  The routine sorts all ADD records at the top.  Within ADD records, it
#  makes sure that the ADD record for a qualifier code precedes ADD records
#  for any of its children in the hierarchy.
#
##############################################################################
sub sort_actions {
  my $ractions = $_[0];
  my ($i, $j, $n, $qcodej, $parenti, $dummy1, $dummy2, $dummy3, $counter);

  my @actions1 = grep {/^ADD!/}  @$ractions;     # Grab all ADD records
  my @actions2 = grep {!/^ADD!/}  @$ractions;    # Grab everything else
	
  $n = @actions1;     # No. of elements in @actions1 array.
  $counter = 0;       # Use this to detect infinite loops.
  if ($n > 0) {
    for ($i = 0; $i < $n - 1; $i++) {  # Loop through all ADD records
      ($dummy1, $dummy2, $parenti, $dummy) = split('!', $actions1[$i]);
      $j = $i + 1;  # Counter for inner loop
      while ($j < $n) {  # Outer loop
        if ($counter++ > $n*$n*$n) {
          die "Infinite loop detected in ADD records in .actions file\n";
        }
        ($dummy1, $qcodej, $dummy2, $dummy3) = split('!', $actions1[$j]);
        #print "n=$n i=$i j=$j parenti=$parenti qcodej=$qcodej\n";
       #
       #  If child precedes parent, then swap them, and reset $j to 
       #  loop through all remaining elements again.
       #
        if ($parenti eq $qcodej) {
          $temp = $actions1[$i];            # Swap...
          $actions1[$i] = $actions1[$j];    # ...the two
          $actions1[$j] = $temp;            # ...elements.
          ($dummy1, $dummy2, $parenti, $dummy) = split('!', $actions1[$i]);
          $j = $i + 1;    # Restart scan through inner loop.
        }
       #
       #  Otherwise, increment $j
       #
        else {
          $j++;
        }
      }  # Inner loop
    }  # Outer loop
  }

  @$ractions = @actions1;   # Put sorted ADD records back into original array
  push(@$ractions, @actions2);   # Put everything else back into array
}

##############################################################################
#
#  Subroutine remove_duplicates(\@array)
#
#  Removes the duplicates from an array.
#
##############################################################################
sub remove_duplicates {
 my $rarray = $_[0];
 my ($i, $n);

 my @new_array = ();
 my %counta = ();
 for ($i = 0; $i < @$rarray; $i++) {
   $n = ++$counta{$$rarray[$i]};   # Count the number of occurences of each
   if ($n < 2) {
     push(@new_array, $$rarray[$i]);
   }
 }
 @$rarray = @new_array;
}

#######################################################################
#  
#  Subroutine get_qual_in_auth($lda, $qualtype, \%auth_qcode)
#
#  Reads in distinct qualifier_codes from authorization table
#  and builds a hash where $auth_qcode{$qcode} = 1 for each
#  qualifier_code $qcode that is included in an authorization.
#
#######################################################################
sub get_qual_in_auth {
 my $lda = $_[0];           # Handle for Oracle connection
 my $qualtype = $_[1];     # Qualifier type
 my $rauth_qcode = $_[2];   # Reference to a hash  
 my ($qqcode);

 my @stmt = ("select distinct a.qualifier_code"
             . " from authorization a, function f"
             . " where a.function_id = f.function_id"
             . " and f.qualifier_type = '$qualtype'");
 my $csr = &ora_open($lda, "@stmt")
           || die $ora_errstr;
 print "Reading distinct $qualtype Qualifiers from Authorization table...\n";
 while (($qqcode) = &ora_fetch($csr)) {
   $$rauth_qcode{$qqcode} = 1;
 }
 do ora_close($csr) || die "can't close cursor";
}

#######################################################################
#  
#  Subroutine fix_haschild($lda, $qualtype)
#
#  Runs two UPDATE statements on the qualifier table
#  to set the haschild field for
#  qualifiers with a given qualifier_type based on whether or not
#  they have children in the qualifier_child table.
#
#######################################################################
sub fix_haschild {
 my $lda = $_[0];           # Handle for Oracle connection
 my $qualtype = $_[1];      # Qualifier type

 my $statement = "update qualifier"
   . " set has_child = 'N',"
   . " last_modified_date = sysdate" 
   . " where qualifier_id in"
   . " (select q.qualifier_id"
   . " from qualifier q, qualifier_child qc"
   . " where q.qualifier_id = qc.parent_id(+)"
   . " and qc.child_id is null"
   . " and q.qualifier_type = '$qualtype'"
   . " and q.has_child = 'Y')";
 my $result =  &ora_do($lda, $statement);
 if ($result eq '0E0') {$result = 0;}
 print "Number of '$qualtype' rows where has_child changed to 'N': $result\n";

 $statement = "update qualifier"
   . " set has_child = 'Y',"
   . " last_modified_date = sysdate"  
   . " where qualifier_id in"
   . " (select q.qualifier_id"
   . " from qualifier q, qualifier_child qc"
   . " where q.qualifier_id = qc.parent_id(+)"
   . " and qc.child_id is not null"
   . " and q.qualifier_type = '$qualtype'"
   . " and q.has_child = 'N')";
 $result =  &ora_do($lda, $statement);
 if ($result eq '0E0') {$result = 0;}
 print "Number of '$qualtype' rows where has_child changed to 'Y': $result\n";

 &ora_commit($lda);
}

return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################
