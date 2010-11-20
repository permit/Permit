#!/usr/bin/perl
#######################################################################
#  
#  For a given qualifier_type, generate records for the
#  qualifier_descendent table and compare them with the actual
#  records in the table.  Do inserts and deletes to bring the
#  qualifier_descendent uptodate.
#
#  To improve performance, you can (1) Read qualifier_descendent table
#   before building descendents list from qualifier_child table,
#   (2) Before building descendents list, set the size of the array to
#   the number of rows in qualifier_descendent table to prevent
#   fragmentation.
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
#  Jim Repa  5/1998
#  Modified 11/18/1998 to use temporary files and avoid memory overflow.
#
#######################################################################
#
#  Set some constants
#
$tempdir = "/tmp/rolesdb/";
$desc_file1 = $tempdir . "built.desc";
$desc_file2 = $tempdir . "table.desc";
$desc_sort1 = $desc_file1 . ".sort";
$desc_sort2 = $desc_file2 . ".sort";
$diffs_file = $tempdir . "diffs";

#
#  Make sure we are set up to use Oraperl.
#
use Oraperl;
if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}

#
#  Get username and password.
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
print "Enter 4-character qualifier_type: ";
chop($qualtype = <STDIN>);

#
#  Open connection to oracle
#
#print "Ready to do &ora_login...";
$lda = &ora_login($db, $user, $pw)
	|| die $ora_errstr;

#
#  Call fix_descendent2 to update the qualifier_descendent table.
#
&fix_descendent2($lda, $qualtype);


#
#  Logoff
#

 &ora_logoff($lda);

 exit();

###########################################################################
#
# Subroutine fix_descendent2($lda, $qualtype)
#  
# Presumes that a database connection is already opened.
# It calculates a set of records that should be in the qualifier_descendent
# table (based on what's in the qualifier_child table).  It then compares
# this array with the actual records in the qualifier_descendent table,
# and does inserts and deletes to qualifier_descendent table to 
# bring it uptodate.  
#
###########################################################################
sub fix_descendent2 {
 my ($lda, $qualtype) = @_;   # Get parameters

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
 #  Set select statement for reading qualifier_child table.
 #
 @stmt = ("select parent_id, child_id from qualifier_child "
          . "where parent_id between $min_id and $max_id");
 $csr = &ora_open($lda, "@stmt")
 	|| die $ora_errstr;

 #
 #  Read the table into a hash.
 #
  %parent_of = ();  # Initialize a *global* null hash for parents/children.
  my @child = (); # Initialize a null array for children.
  my ($par, $chi);
  while (($par, $chi) = &ora_fetch($csr)) {
    if (not (exists($parent_of{$chi}))) {
      $parent_of{$chi} = $par;
      push(@child, $chi);  
    }
    else {
      $parent_of{$chi} = $parent_of{$chi} . '!' . $par;
    }
  }
  do ora_close($csr) || die "can't close cursor 1";
  my $n = @child;
  print "There are $n child records\n";

 #
 #  Generate descendents
 #
  print "Generating descendents...\n";
  @desc_pair = ();   # Set *global* descendent-pairs array to empty list
  my @parents;
  foreach $chi (@child) {
    @parents = split('!', $parent_of{$chi});  # Split into elements
    for ($i = 0; $i < @parents; $i++) {
      &gendesc($parents[$i], $chi);  # Call recursive function 
    }
  }
  undef %parent_of;  # Don't need this any more
  #print "Number of descendent pairs = " . @desc_pair . "\n";

 #
 #  Remove duplicates
 #
  print "Removing duplicates from descendents array...\n";
  my @new_pair = ();
  my %counta = ();
  my $i;
  for ($i = 0; $i < @desc_pair; $i++) {
    $n = ++$counta{$desc_pair[$i]};   # Count the number of occurences of each
    if ($n < 2) {
      push(@new_pair, $desc_pair[$i]);
    }
  }
  $n = @new_pair;
  print "Number of descendent pairs = " . @new_pair . "\n";
 
 #
 #  Print @new_pair to a file and undef @new_pair to save memory.
 #
  my $outf = ">" . $desc_file1;
  if( !open(F1, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }
  my $rec;
  foreach $rec (@new_pair) {
    print F1 $rec . "\n";
  }  
  close(F1);
  undef @new_pair;

 #
 #  Drop arrays that we don't need anymore.
 #
  undef @child;
  undef @desc_pair;
  undef %counta;

 #
 #  Read the qualifier_descendent table into an array.
 #  >>>>> Instead, write them to a file.
 #
  $outf = ">" . $desc_file2;
  if( !open(F2, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }
  print "Reading records from qualifier_descendent table...\n";
  @stmt = ("select parent_id, child_id from qualifier_descendent "
           . "where parent_id between $min_id and $max_id");
  $csr = &ora_open($lda, "@stmt")
          || die $ora_errstr;
  $n = 0;
  while (($par, $chi) = &ora_fetch($csr)) {
    print F2 $par . '!' . $chi . "\n";
    $n++;
  }
  do ora_close($csr) || die "can't close cursor 1";
  close(F2);
  print "Number of qualifier_descendent table records = $n\n";

 #
 #  Find differences between qualifier_descendent table and 
 #   built descendent file.
 #  >>>> Use Unix comm command.
 #
  print "Sorting first file...\n";
  $rc = system("sort -o $desc_sort1 $desc_file1\n");
  $rc >>= 8;  # Divide by 256
  if ($rc) {die "Error code $rc from first sort\n";}

  print "Sorting 2nd file...\n";
  $rc = system("sort -o $desc_sort2 $desc_file2\n");
  $rc >>= 8;  # Divide by 256
  if ($rc) {die "Error code $rc from 2nd sort\n";}

  print "Running 'comm' to compare the two files...\n";
  $rc = system("comm -3 $desc_sort2 $desc_sort1 > $diffs_file\n");
  $rc >>= 8;  # Divide by 256
  if ($rc) {die "Error code $rc from comm\n";}

 #
 #  Find a list of @old_not_new pairs.
 #  Find a list of @new_not_old pairs.
 #
  unless (open(F1, $diffs_file)) {
    die "$0: can't open ($diffs_file) for input - $!\n";
  }
  @old_not_new = ();
  @new_not_old = ();
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
  my $line;
  $csr = &ora_open($lda, 
    "delete from qualifier_descendent where parent_id = :1 and child_id = :2")
    || die $ora_errstr;
  $i = 0;
  if (@old_not_new > 0) {
    foreach $line (@old_not_new) {
      ($par, $chi) = split('!', $line);
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
    "insert into qualifier_descendent (PARENT_ID, CHILD_ID) values(:1, :2)")  
    || die $ora_errstr;
  if (@new_not_old > 0) {
    $i = 0;
    foreach $line (@new_not_old) {
      ($par, $chi) = split('!', $line);
      print "$i Inserting ($par, $chi)\n";
      &ora_bind($csr, $par, $chi) || die "$_: $ora_errstr\n"; 
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





