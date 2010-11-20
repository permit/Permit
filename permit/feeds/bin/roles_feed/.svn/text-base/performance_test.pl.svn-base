#!/usr/bin/perl
###########################################################################
#
#  Perl script to display stored procedures for a given user.
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
#  Get username and password.
#
print "Enter database name for sqlplus connection\n";
chop($db = <STDIN>);
print "Enter username for sqlplus connection\n";
chop($user = <STDIN>);
print "Enter password for user '$user' at $db\n";
system ("stty -echo\n");
chop($pw = <STDIN>);
print "\n";
system ("stty echo\n");
$userpw = $user . '/' . $pw;
#print "userpw = '$userpw'\n";

#
#  Make sure we are set up to use Oraperl.
#
use Oraperl;
if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}

#
#  Open connection to oracle
#
print "Ready to do &ora_login...  db='$db' USER='$user'\n";
$lda = &ora_login($db, $userpw, '')
	|| die $ora_errstr;

#
#  Open first connection to oracle.  Find the minimum and maximum
#  qualifier_id associated with the given qualifier_type.
#
 $qualifier_type = 'PCCS';
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
 &ora_close($csr) || die "can't close cursor 1";

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
 &ora_close($csr) || die "can't close cursor 2";


&ora_logoff($lda) || die "can't log off Oracle";
exit();

