#!/usr/bin/perl
#######################################################################
#  
#  *** This is a new version that handles multiple parents for a given
#  *** node in the hierarchy.
#
#  Read the table qualifier_child and generate records to be inserted
#  into qualifier_descendent.
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
#  Make sure we are set up to use Oraperl.
#
use Oraperl;
if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}

#
#  Get username and password.
#
print "Enter database for sqlplus connection: ";
chop($db = <STDIN>);
print "Enter username for sqlplus connection: ";
chop($user = <STDIN>);
print "Enter password for user '$user' at $db: ";
chop($pw = <STDIN>);

#
#  Open connection to oracle
#
#print "Ready to do &ora_login...";
$lda = &ora_login($db, $user, $pw)
	|| die $ora_errstr;
@stmt = ("select parent_id, child_id from qualifier_child "
         . "where parent_id >= 400000 and parent_id < 500000");

$csr = &ora_open($lda, "@stmt")
	|| die $ora_errstr;

$nfields = &ora_fetch($csr);
print "Query will return $nfields fields\n\n";

#
#  Read the table into a hash.
#
 %parent_of = ();  # Initialize a null hash for parents/children.
 @child = (); # Initialize a null array for children.
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

#
#  Generate descendents
#
 print "Generating descendents...\n";
 @desc_pair = ();   # Null descendent-pairs array
 foreach $chi (@child) {
   @parents = split('!', $parent_of{$chi});  # Split into elements
   for ($i = 0; $i < @parents; $i++) {
     &gendesc($parents[$i], $chi);  # Call recursive function 
   }
 }

#
#  Removing duplicates
#
 print "Number of descendent pairs = " . @desc_pair . "\n";
 print "Removing duplicates from descendents array...\n";
 @new_pair = ();
 %counta = ();
 for ($i = 0; $i < @desc_pair; $i++) {
   $n = ++$counta{$desc_pair[$i]};   # Count the number of occurences of each
   if ($n < 2) {
     push(@new_pair, $desc_pair[$i]);
   }
 }
 $n = @new_pair;
 print "Now, we'll insert $n records into the table qualifier_descendent\n";
 #unless (open(F2,">desc.file")) {
 # do ora_logoff($lda);
 # die "$0 can't open 'desc.file' for output - $!\n";
 #}
 #for ($i = 0; $i < $n; $i++) {
 #  print F2 $new_pair[$i] . "\n";
 #}
 #close(F2);
 #exit();
#
#  Set up a cursor to insert each row into the table.
#
 $csr2 = &ora_open($lda,
                 'insert into ROLESBB.RDB_T_QUALIFIER_DESCENDENT
                 (PARENT_ID, CHILD_ID)
                  values (:1, :2)') || die $ora_errstr;

#
#  Now, insert each record into the table.
#
 $time0 = time();
 for ($i = 0; $i < @new_pair; $i++) {
        ($p, $c) = split('!', $new_pair[$i]);  # Get parent/child pair
        &ora_bind($csr2, $p, $c) 
            || die "$_: $ora_errstr\n"; 
        if ($i%500 == 0) {
          &ora_commit($lda); #Now we can commit
          $elapsed_seconds = time() - $time0;
          print "$i ($elapsed_seconds sec.) $p $c\n";
        }
 }

 close (OUT);
 &ora_commit($lda); #Now we can commit
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





