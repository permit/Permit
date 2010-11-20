#!/usr/bin/perl -I../../lib/cpa
#######################################################################
#
#  Fix the table PRIMARY_AUTH_DESCENDENT.
#
#  This table has two columns, PARENT_ID and CHILD_ID
#    PARENT_ID is the QUALIFIER_ID of each of the 'D_***' department
#     records in the QUALIFIER table (QUALIFIER_TYPE = 'DEPT')
#    CHILD_ID is the QUALIFIER_ID of a FUND, COST, ORGU, SPGP, or BAGS
#     qualifier that is associated with the D_*** department.
#
#  Here's how we do it.
#  There are several qualifier types we'll handle - 
#     COST, SPGP, ORGU, BAGS, FUND
#  For each qualifier type, get a list of parent-child pairs from the 
#    existing table PRIMARY_AUTH_DESCENDENT corresponding to one of the
#    qualifier types. (A)
#  Then, calculate what this list should be by looking at the
#    QUALIFIER_DESCENDENT table. (B)
#  Find the differences between (A) and (B), and generate a set of 
#    transactions to make corrections to PRIMARY_AUTH_DESCENDENT.
#  
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
#  Jim Repa  6/1999
#  Modified, Jim Repa, 5/9/2000
#  Modified, Jim Repa, 6/5/2000 (More prefixes for LORG, and DEPTs)
#  Modified, Jim Repa, 3/9/2001 (Add processing for SISO)
#  Modified, Jim Repa, 3/22/2001 (Handle "super-departments" like D_ASO)
#  Modified, Jim Repa, 6/26/2001 (Tweak "super-departments" - link to self)
#  Modified, Jim Repa, 8/27/2001 (Fix code that accepts optional DB name)
#
#######################################################################
#
# Get packages
#
use config('GetValue');  # Use the subroutine GetValue in ~/lib/cpa/config.pm

#
#  Set some constants
#
$tempdir = $ENV{'ROLES_HOMEDIR'} . "/data/";
$recalc_file = $tempdir . "pa_desc.new";
$existing_file = $tempdir . "pa_desc.old";
$recalc_sort = $tempdir . "pa_desc_new.sort";
$existing_sort = $tempdir . "pa_desc_old.sort";
$diffs_file = $tempdir . "diffs";

#
#  Define SQL fragments to select qualifier_codes from the DEPT hierarchy
#  matching various qualifier types.
#
 %qtype_to_sql_fragment = (
   'COST' => "ltrim(q.qualifier_code, '0H') like 'PC%'",
   'SPGP' => "q.qualifier_code like 'SG%'",
   'BAGS' => "q.qualifier_code like '___'"
             . " and q.qualifier_code between '000' and '999'",
   'FUND' => "q.qualifier_code like 'FC%'",
   'ORGU' => "q.qualifier_code like '______'"
             . " and q.qualifier_code between '000000' and '999999'",
   'LORG' => "((q.qualifier_code between '70000000' and '79999999'"
             . " and q.qualifier_code like '________')"
             . " or (q.qualifier_code like '0HL%')"
             . " or (q.qualifier_code like 'LDS_%'))",
   'DEPT' => "q.qualifier_code like 'D%'"
             . " and substr(q.qualifier_code, 1, 2) = 'D_'",
   'SISO' => "q.qualifier_code like 'SIS_%'",
 );

#
#  Make sure we are set up to use Oraperl.
#
use DBI;
use Oraperl;
if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}

#
#  Get database name
#
 if ($#ARGV >= 0) {
   $db_name = $ARGV[0];
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
 print "db=$db user=$user\n";

#
#  Open connection to oracle
#
#print "Ready to do &ora_login...";
$lda = &ora_login($db, $user, $pw)
	|| die $ora_errstr;

#
#  Process each of the qualifier types in turn.
#  1. Get a list of qualifier_ids for D_ qualifiers that are groups 
#     of departments (so we'll know which D_ qualifier_codes are DLCs).
#  1a. Get a list of qualifier_ids for D_ qualifiers that are groups 
#      of departments but also have direct links to non-'D_' qualifiers.
#  1b. Get a list of parent/child pairs where the parent is a
#      super-department and the child is a non-department with no links to
#      actual departments;  these parent/child pairs should have the 
#      IS_DLC flag set to 'Y' in the PRIMARY_AUTH_DESCENDENT table.
#  2. Build a hash where 
#     the key is a qualifier_code from the DEPT
#     hierarchy matching a specific qualifier type, and
#     the value is a list of ancestors within the DEPT hierarchy
#  3. Use that hash along with a select statement to get a list of
#     all parent-child pairs where the parent is in the DEPT hierarchy
#     and the child is in the $qt hierarchy (for a given qualtype $qt).
#     Write the results to the file $recalc_file.
#  4. Read the existing PRIMARY_AUTH_DESCENDENT table and write 
#     the results to the file $existing_file.
#  5. Finally, find differences between $recalc_file and $existing_file
#     write them to $diffs_file, and do SQL statements to apply the
#     differences to the PRIMARY_AUTH_DESCENDENT table.
#
 %parent_of = ();
 %super_dept = ();
 %special_super_dept = ();
 &get_super_dept_ids($lda, \%super_dept); # 1
 &get_special_super_depts($lda, \%special_super_dept);  # 1a
 #
 #foreach $qt ('SPGP', 'COST', 'BAGS', 'ORGU', 'FUND', 'LORG', 
 #             'SISO', 'DEPT')
 #{
 foreach $qt ('SPGP') {
   $qt4 = substr($qt, 0, 4);
   print "$qt: \n";
   %special_pair = ();
   print "before &get_special_pairs: ";
   print `date`;
   &get_special_pairs($lda, $qt, \%special_super_dept, \%special_pair); # 1b
   print "before &get_ancestors_for_a_type: ";
   print `date`;
   &get_ancestors_for_a_type($lda, $qt4,
      $qtype_to_sql_fragment{$qt}, \%parent_of); # 2
   print "before &recalculate_descendents_for_a_type: ";
   print `date`;
   &recalculate_descendents_for_a_type($lda, $qt4,
      $qtype_to_sql_fragment{$qt}, \%parent_of, \%super_dept, \%special_pair,
      $recalc_file); # 3
   print "before &existing_descendents_for_a_type: ";
   print `date`;
   &existing_descendents_for_a_type($lda, $qt4, $existing_file); # 4
   print "before &find_descendents_diffs: ";
   print `date`;
   &find_descendent_diffs($existing_file, $existing_sort, 
                           $recalc_file, $recalc_sort, $diffs_file); # 5
   print "after &find_descendents_diffs: ";
   print `date`;
 }

#
#  Logoff
#

 &ora_logoff($lda);

 exit();

###########################################################################
#
# Subroutine get_ancestors_by_type($lda, $qualtype, $sql_fragment)
#  
# Presumes that a database connection is already opened.
# Within the DEPT hierarchy, finds all ancestors of nodes matching
# a given qualifier type (where clause is in $sql_fragment).
#
###########################################################################
sub get_ancestors_for_a_type {
 my ($lda, $qualtype, $sql_fragment, $rparent_of) = @_;   # Get parameters

 #
 #  Set select statement for reading ancestors.  (Note that there is
 #   a special case where $qualtype is 'DEPT')
 #
 #print "sql fragment = $sql_fragment\n";
 my @stmt = ();
 if ($qualtype eq 'DEPT') {
   @stmt = ("select q.qualifier_code, q.qualifier_id, qd.parent_id"
            . " from qualifier q, qualifier_descendent qd, qualifier q2,"
            . " qualifier_child qc, qualifier q3"
            . " where q.qualifier_type = 'DEPT'"
            . " and " . $sql_fragment
            . " and qd.child_id = q.qualifier_id"
            . " and q2.qualifier_id = qd.parent_id"
            . " and q2.qualifier_code like 'D%'"
            . " and substr(q2.qualifier_code, 1, 2) = 'D_'"
            . " and qc.parent_id = q.qualifier_id"
            . " and q3.qualifier_id(+) = qc.child_id"
            . " and q3.qualifier_code(+) like 'D%'"
            . " and substr(q3.qualifier_code(+), 1, 2) = 'D_'"
            . " and q3.qualifier_code is NULL"
            . " union "
            . "select distinct q.qualifier_code,q.qualifier_id, q.qualifier_id"
            . " from qualifier q, qualifier_child qc, qualifier q2"
            . " where q.qualifier_type = 'DEPT'"
            . " and " . $sql_fragment
            . " and qc.parent_id = q.qualifier_id"
            . " and q2.qualifier_id = qc.child_id"
            . " and q2.qualifier_code like 'FC%'");  # Has a FC for child
 }
 else {
   @stmt = ("select q.qualifier_code, q.qualifier_id, qd.parent_id"
            . " from qualifier q, qualifier_descendent qd"
            . " where q.qualifier_type = 'DEPT'"
            . " and " . $sql_fragment
            . " and qd.child_id = q.qualifier_id");
 }
 my $csr = &ora_open($lda, "@stmt")
 	|| die $ora_errstr;

 #
 #  Read the table into a hash.
 #
  %$rparent_of = ();  # Initialize a null hash for parents/children
  my ($child_code, $child_id, $parent_id);
  while (($child_code, $child_id, $parent_id) = &ora_fetch($csr)) {
    if (not (exists($parent_of{$child_code})) ) {
      $$rparent_of{$child_code} = $parent_id; # 1st parent
    }
    else {
      $$rparent_of{$child_code} .= ' ' . $parent_id;
    }
  }
  &ora_close($csr) || die "can't close cursor 1";

 #
 #  Print parent codes
 #
  #foreach $key (sort keys %$rparent_of) {
  #  print "$key => $$rparent_of{$key}\n";
  #}

}

############################################################################
#
# Subroutine get_super_dept_ids($lda, \%super_dept)
#  
# Presumes that a database connection is already opened.
# Finds a list of "super-departments", i.e., D_ department 
# codes that have other D_ department codes as children.  Builds
# a hash %super_dept{$qcode} where $super_dept{$qcode} = 1 for
# the "super-departments".  (We need to differentiate between
# DLCs and groups of DLCs.)
#
###########################################################################
sub get_super_dept_ids {
 my ($lda, $rsuper_dept) = @_;   # Get parameters

 #
 #  Set select statement for finding "super-departments"
 #
 #print "sql fragment = $sql_fragment\n";
 my @stmt = ("select distinct q1.qualifier_id"
          . " from qualifier q1, qualifier_child qc, qualifier q2"
          . " where q1.qualifier_type = 'DEPT'"
          . " and substr(q1.qualifier_code, 1, 2) = 'D_'"
          . " and qc.parent_id = q1.qualifier_id"
          . " and q2.qualifier_id = qc.child_id"
          . " and substr(q2.qualifier_code, 1, 2) = 'D_'");
 #print @stmt;
 #print "\n";
 my $csr = &ora_open($lda, "@stmt")
 	|| die $ora_errstr;

 #
 #  Build entries in the hash for these qualifier codes.
 #
  %$rsuper_dept = ();  # Initialize a null hash for super-departments
  my $qualcode;
  while (($qualcode) = &ora_fetch($csr)) {
    $$rsuper_dept{$qualcode} = 1;
  }
  &ora_close($csr) || die "can't close cursor for super-departments";

 #
 #  Print super-departments
 #
  #print "Super-departments:\n";
  #foreach $key (sort keys %$rsuper_dept) {
  #  print "$key\n";
  #}

}

############################################################################
#
# Subroutine get_special_super_depts($lda, \%special_super_dept)
#  
#  Fill in the hash %special_super_dept, which will include special
#  nodes that are super_deptartments, but also have direct links to 
#  non-'D_%' qualifiers.  (Examples are D_ASO, D_DUE, and D_DSL.)
#  Presumes that a database connection is already opened.
#
###########################################################################
sub get_special_super_depts {
 my ($lda, $rspecial_super_dept) = @_;   # Get parameters

 #
 #  Set select statement for finding special "super-departments", the
 #  'D_%' qualifiers having child 'D_%' qualifiers, but also having
 #  one or more direct links to other qualifier types (e.g., D_ASO).
 #  Later, we will use this hash to identify parent/child links that
 #  should be flagged with DLC-flag = 'Y', even though the parent_id
 #  does not represent a leaf-level department.
 #
 my @stmt = ("select distinct q1.qualifier_id"
          . " from qualifier q1, qualifier_child qc, qualifier q2"
          . " where q1.qualifier_type = 'DEPT'"
          . " and substr(q1.qualifier_code, 1, 2) = 'D_'"
          . " and qc.parent_id = q1.qualifier_id"
          . " and q2.qualifier_id = qc.child_id"
          . " and substr(q2.qualifier_code, 1, 2) = 'D_'"
          . " and exists (select q3.qualifier_code"
          . " from qualifier_child qc2, qualifier q3"
          . " where qc2.parent_id = q1.qualifier_id"
          . " and q3.qualifier_id = qc2.child_id"
          . " and substr(q3.qualifier_code, 1, 2) <> 'D_')");
 #print @stmt;
 #print "\n";
 my $csr = &ora_open($lda, "@stmt")
 	|| die $ora_errstr;

 #
 #  Build entries in the hash for these qualifier codes.
 #
  %$rspecial_super_dept = ();  # Initialize a null hash for super-departments
  my $qualid;
  while (($qualid) = &ora_fetch($csr)) {
    $$rspecial_super_dept{$qualid} = 1;
  }
  &ora_close($csr) || die "can't close cursor for special super-departments";

 #
 #  For testing, print super-departments
 #
  if (0) {
    print "Special super-departments:\n";
    foreach $key (sort keys %$rspecial_super_dept) {
      print "$key\n";
    }
  }

}

############################################################################
#  
# Subroutine 
#  get_special_pairs($lda, $qual_type, \%special_super_dept, \%special_pair)
#  
#  Build array %special_pair where $special_pair{"$parent_id!$child_id"} = 1
#  for each pair found by the 4-part select statement below.
#
###########################################################################
sub get_special_pairs {
 my ($lda, $qt, $rspecial_super_dept, $rspecial_pair) = @_; # Get parameters
 my $n = (keys %$rspecial_super_dept);

 #
 #  Set select statement for finding parent/child qualifier_id pairs
 #  where
 #    - There is a link between the parent, a special super-department,
 #      to the child, a non-department code
 #    - There is no link from a different parent, an actual department
 #      (i.e., a D_ qualifier that has no other D_ qualifiers as children)
 #      to the child.
 #  In these cases, we will want to set the IS_DLC flag in the 
 #  primary_auth_descendent table to 'Y'.
 #
  my $sql_fragment = "substr(q.qualifier_code, 1, 2) <> 'D_'";
  my $stmt = "select /*+ ORDERED */ qd.child_id"
           . " from qualifier q0,"
           . " qualifier_child qc, qualifier q, qualifier q3,"
           . " qualifier_descendent qd"
           . " where q0.qualifier_type = 'DEPT'"
           . " and q0.qualifier_id = ?"
           . " and qc.parent_id = q0.qualifier_id"
           . " and q.qualifier_id = qc.child_id"
           . " and $sql_fragment"
           . " and q3.qualifier_code = q.qualifier_code"
           . " and q3.qualifier_type = '$qt'"
           . " and qd.parent_id = q3.qualifier_id"
           . " union select /*+ ORDERED */ q3.qualifier_id"
           . " from qualifier q0,qualifier_child qc,qualifier q,qualifier q3"
           . " where q0.qualifier_type = 'DEPT'"
           . " and q0.qualifier_id = ?"
           . " and qc.parent_id = q0.qualifier_id"
           . " and q.qualifier_id = qc.child_id"
           . " and $sql_fragment"
           . " and q3.qualifier_code = q.qualifier_code"
           . " and q3.qualifier_type = '$qt'"
           . " minus select /*+ ORDERED */ "
           . " qd2.child_id"
           . " from qualifier q0, qualifier_descendent qd, qualifier q1,"
           . "      qualifier_child qc, qualifier q, qualifier q3,"
           . "      qualifier_descendent qd2"
           . " where q0.qualifier_type = 'DEPT'"
           . " and q0.qualifier_id = ?"
           . " and qd.parent_id = q0.qualifier_id"
           . " and q1.qualifier_id = qd.child_id"
           . " and substr(q1.qualifier_code, 1, 2) = 'D_'"
           . " and qc.parent_id = q1.qualifier_id"
           . " and q.qualifier_id = qc.child_id"
           . " and $sql_fragment"
           . " and q3.qualifier_code = q.qualifier_code"
           . " and q3.qualifier_type = '$qt'"
           . " and qd2.parent_id = q3.qualifier_id"
           . " minus select /*+ ORDERED */ q3.qualifier_id"
           . " from qualifier q0, qualifier_descendent qd, qualifier q1,"
           . "      qualifier_child qc, qualifier q, qualifier q3"
           . " where q0.qualifier_type = 'DEPT'"
           . " and q0.qualifier_id = ?"
           . " and qd.parent_id = q0.qualifier_id"
           . " and q1.qualifier_id = qd.child_id"
           . " and substr(q1.qualifier_code, 1, 2) = 'D_'"
           . " and qc.parent_id = q1.qualifier_id"
           . " and q.qualifier_id = qc.child_id"
           . " and $sql_fragment"
           . " and q3.qualifier_code = q.qualifier_code"
           . " and q3.qualifier_type = '$qt'";
 #print "$stmt\n";
 my $sth = $lda->prepare($stmt) || die $lda->errstr;


 #
 #  For each special super-department, bind the variable to the
 #  the select statement, and call the select.  Find all of the
 #  special parent/child pairs, and put them into the hash %special_pair.
 #
  my ($rc, $parentid, $childid);
  %$rspecial_pair = ();  # Init null hash for special parent/child pairs
  foreach $parentid (keys %$rspecial_super_dept) {
    #print "Special super department is $parentid\n";
    $rc = $sth->bind_param(1, $parentid)  || die $sth->errstr;
    $rc = $sth->bind_param(2, $parentid)  || die $sth->errstr;
    $rc = $sth->bind_param(3, $parentid)  || die $sth->errstr;
    $rc = $sth->bind_param(4, $parentid)  || die $sth->errstr;
    $rc = $sth->execute
      || die "Can't execute statement: $DBI::errstr";
    while (($childid) = $sth->fetchrow_array) {
      $$rspecial_pair{"$parentid!$childid"} = 1;
    }
    warn $sth::errstr if $sth::err;
    $sth->finish;
    if ($qt eq 'DEPT') {
      $$rspecial_pair{"$parentid!$parentid"} = 1; #Add link from DEPT to itself
    }
  }

 #
 #  For testing, print special parent/child pairs
 #
  if (0) {
    print "Special parent/child pairs:\n";
    foreach $key (sort keys %$rspecial_pair) {
      print "$key\n";
    }
  }

}

##########################################################################
#
# Subroutine recalculate_descendents_for_a_type($lda, $qualtype, 
#              $sql_fragment, \%parent_of, \%super_dept, \%special_pair,
#              $recalc_file)
#  
# Presumes that a database connection is already opened.
# Looks at qualifier_descendent table and finds parent-child records that
#  should be in primary_auth_descendent table.  Writes the results to
#  $recalc_file.
#
###########################################################################
sub recalculate_descendents_for_a_type {
 # Get parameters
 my ($lda, $qualtype, $sql_fragment, $rparent_of, 
     $rsuper_dept, $rspecial_pair, $recalc_file) = @_;

 #
 #  Open an output file for the recalculated descendent pairs.
 #
  my $outf = ">" . $recalc_file;
  if( !open(F2, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }

 #
 #  Set select statement for reading descendents. (There is a special case
 #   for qualtype 'DEPT')
 #
 #print "sql fragment = $sql_fragment\n";
 my @stmt = ();
 if ($qualtype eq 'DEPT') {
   @stmt = ("select distinct q.qualifier_code, q.qualifier_id"
             . " from qualifier q, qualifier_child qc,"
             . "  qualifier q3"
             . " where q.qualifier_type = 'DEPT'"
             . " and " . $sql_fragment
             . " and qc.parent_id = q.qualifier_id"
             . " and q3.qualifier_id(+) = qc.child_id"
             . " and q3.qualifier_code(+) like 'FC%'"
             . " order by 1,2");
 }
 else {
   @stmt = ("select q.qualifier_code, q2.qualifier_id"
             . " from qualifier q, qualifier q2"
             . " where q2.qualifier_type = '$qualtype'"
             . " and q.qualifier_type = 'DEPT'"
             . " and q2.qualifier_code ="
             . " replace(replace(q.qualifier_code, 'LDS_', ''), 'SIS_', '')"
             . " and " . $sql_fragment
             . " union select q.qualifier_code, qd.child_id"
             . " from qualifier q, qualifier q2, qualifier_descendent qd"
             . " where q2.qualifier_type = '$qualtype'"
             . " and q.qualifier_type = 'DEPT'"
             . " and q2.qualifier_code ="
             . " replace(replace(q.qualifier_code, 'LDS_', ''), 'SIS_', '')"
             . " and " . $sql_fragment
             . " and q2.qualifier_id = qd.parent_id"
             . " order by 1,2");
 }
 #print @stmt;
 #print "\n";
 #exit();
 my $csr = &ora_open($lda, "@stmt")
 	|| die $ora_errstr;

 #
 #  Read the table and generate parent-child records.
 #
  my ($qcode_d, $qid, $child_id);
  my ($ancestor_string);
  my $prev_qcode_d = '';
  my $parent_id;
  my $dlc_flag;
  while (($qcode_d, $child_id) = &ora_fetch($csr)) {
    $ancestor_string = $$rparent_of{$qcode_d};
    #if (!($qcode_d =~ /^7/)) { 
    #   print "$qcode_d -> $ancestor_string\n";
    #}
    foreach $parent_id (split(' ', $ancestor_string)) {
      if ($$rspecial_pair{"$parent_id!$child_id"}) {
        $dlc_flag = 'Y';
      }
      elsif ($$rsuper_dept{$parent_id}) {
        $dlc_flag = '';
      }
      else {
        $dlc_flag = 'Y';
      }
      #$dlc_flag = ($$rsuper_dept{$parent_id}) ? '' : 'Y';
      print F2 "$parent_id!$child_id!$dlc_flag\n";
    }
    $prev_qcode_d = $qcode_d;
  }
  &ora_close($csr) || die "can't close cursor 1";
  close(F2);

}

###########################################################################
#
# Subroutine existing_descendents_for_a_type(
#            $lda, $qualtype, $recalc_file)
#  
# Presumes that a database connection is already opened.
# Finds parent-child pairs in primary_auth_descendent table and writes
#  the result to $recalc_file.
#
###########################################################################
sub existing_descendents_for_a_type {
 # Get parameters
 my ($lda, $qualtype, $existing_file) = @_;

 #
 #  Open an output file for the recalculated descendent pairs.
 #
  my $outf = ">" . $existing_file;
  if( !open(F3, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }

 #
 #  Determine minimum and maximum qualifier_id for a given qualifier_type.
 #
 my @stmt = ("select min(qualifier_id), max(qualifier_id) from qualifier "
          . "where qualifier_type = '$qualtype'");
 
 my $csr = &ora_open($lda, "@stmt")
 	|| die $ora_errstr;
 
 my ($min_id, $max_id) = &ora_fetch($csr);
 &ora_close($csr);
 print "For qualifier_type = '$qualtype', min and max qualifier_ids are"
       . " $min_id and $max_id\n";

 #
 #  Set select statement for reading descendents from primary_auth_descendent
 #
 @stmt = ("select parent_id, child_id, is_dlc"
             . " from primary_auth_descendent pad"
             . " where child_id between $min_id and $max_id"
             . " order by parent_id, child_id");
 #print @stmt;
 #print "\n";
 $csr = &ora_open($lda, "@stmt")
 	|| die $ora_errstr;

 #
 #  Read the table and generate parent-child records.
 #
  my ($parent_id, $child_id, $is_dlc);
  while (($parent_id, $child_id, $is_dlc) = &ora_fetch($csr)) {
    print F3 "$parent_id!$child_id!$is_dlc\n";
  }
  &ora_close($csr) || die "can't close cursor 1";
  close(F3);

}

###########################################################################
#
# Subroutine find_descendent_diffs($existing_file, $existing_sort, 
#                           $recalc_file, $recalc_sort, $diffs_file);
#  
# Uses the Unix command 'comm' to find the differences between the
#  $existing_file (parent-child records in primary_auth_descendent)
#  and $recalc_file (calculated from qualifier_descendent).
# Then does inserts and deletes to primary_auth_descendent to make it
#  match what should be there.
#
###########################################################################
sub find_descendent_diffs {
 my ($desc_file1, $desc_sort1, $desc_file2, $desc_sort2,
     $diffs_file) = @_;   # Get parameters

 #
 #  Find differences between primary_auth_descendent table and 
 #   built descendent file using comm command.
 #
  print "Sorting first file...\n";
  my $rc = system("sort -u -o $desc_sort1 $desc_file1\n");
  $rc >>= 8;  # Divide by 256
  if ($rc) {die "Error code $rc from first sort\n";}

  print "Sorting 2nd file...\n";
  $rc = system("sort -u -o $desc_sort2 $desc_file2\n");
  $rc >>= 8;  # Divide by 256
  if ($rc) {die "Error code $rc from 2nd sort\n";}

  print "Running 'comm' to compare the two files...\n";
  $rc = system("comm -3 $desc_sort1 $desc_sort2 > $diffs_file\n");
  $rc >>= 8;  # Divide by 256
  if ($rc) {die "Error code $rc from comm\n";}

 #
 #  Find a list of @old_not_new pairs.
 #  Find a list of @new_not_old pairs.
 #
  unless (open(F1, $diffs_file)) {
    die "$0: can't open ($diffs_file) for input - $!\n";
  }
  my @old_not_new = ();
  my @new_not_old = ();
  my ($old, $new);
  while (chomp($rec = <F1>)) {
    ($old, $new) = split("\t", $rec);
    if ($old) {
      push(@old_not_new, $old);
    }
    if ($new) {
      push(@new_not_old, $new);
    }
  }  
  close(F1);
  print "Number of records to be deleted from table = " . scalar(@old_not_new)
        . "\n";
  print "Number of records to be inserted into table = " . scalar(@new_not_old)
        . "\n";

 #
 #  Delete 1 record per pair in the @old_not_new array
 #
  my ($line, $par, $chi, $is_dlc);
  $csr = &ora_open($lda, 
    "delete from primary_auth_descendent"
    . " where parent_id = :1 and child_id = :2")
    || die $ora_errstr;
  $i = 0;
  if (@old_not_new > 0) {
    foreach $line (@old_not_new) {
      ($par, $chi, $is_dlc) = split('!', $line);
      print "$i Deleting ($par, $chi)\n";
      &ora_bind($csr, $par, $chi) || die "$_: $ora_errstr\n"; 
      if (($i++)%500 == 0) {
        print "i=$i\n";
        &ora_commit($lda); # Commit to avoid Oracle errors.
      }
    }
  }
  &ora_close($csr);

 #
 #  Insert 1 record per pair in the @new_not_old array
 #
  $csr = &ora_open($lda, 
    "insert into primary_auth_descendent"
    . " (PARENT_ID, CHILD_ID, IS_DLC) values(:1, :2, :3)")
    || die $ora_errstr;
  if (@new_not_old > 0) {
    $i = 0;
    foreach $line (@new_not_old) {
      ($par, $chi, $is_dlc) = split('!', $line);
      print "$i Inserting ($par, $chi, $is_dlc)\n";
      &ora_bind($csr, $par, $chi, $is_dlc) || die "$_: $ora_errstr\n"; 
      if (($i++)%500 == 0) {
        print "i=$i\n";
        &ora_commit($lda); # Commit to avoid Oracle errors.
      }
    }
  }
 
 #
 # Close cursor, and commit.
 #
  print "Committing changes (if any) and undefining arrays...\n";
  &ora_close($csr);
  &ora_commit($lda); #Now we can commit

}

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
#  Recursive routine gendesc($parent,$child) to generate descendents.
#
###########################################################################
sub gendesc {
  my($p) = $_[0];  # Local $p is current parent qualifier_id
  my($d) = $_[1];  # Local $d is current descendent qualifier_id
  my(@parents);    # Local array of parents for a node.
  my($i);          # Local counter
  #print "p=$p d=$d\n";
  push(@desc_pair, $p . '!' . $d);  # Add a descendent
  if (exists($parent_of{$p})) {   # Does the parent have a parent?
    @parents = split('!', $parent_of{$p});  # Split into elements
    for ($i = 0; $i < @parents; $i++) {
      &gendesc($parents[$i], $d);  # Call recursive function 
    }
  }
}  
