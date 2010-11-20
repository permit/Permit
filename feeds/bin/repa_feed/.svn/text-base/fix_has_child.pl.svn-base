#!/usr/bin/perl
#######################################################################
#
#  Test a subroutine to set the appropriate has_child value in
#  the qualifier table based on whether or not each qualifier has
#  at least one "child" in the qualifier_child table.
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
 $qualtype = 'COST';
 #$qualtype = 'FUND';

#
# Set up Oraperl
#
eval 'use Oraperl; 1' || die $@ if $] >= 5;
die ("Need to use oraperl, not perl\n") unless defined &ora_login;
$| = 1; #Force Ouput Buffer to Flush on each write

#
#  Get username and password for Roles database connection.
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
#  Call subroutine to populate the hash.
#
 &fix_haschild($lda, $qualtype);

 exit();

#######################################################################
#  
#  Subroutine fix_haschild($lda, $qualtype)
#
#  Runs two UPDATE statements to set the haschild field for
#  qualifiers with a given qualifier_type based on whether or not
#  they have children in the qualifier_child table.
#
#######################################################################
sub fix_haschild {
 my $lda = $_[0];           # Handle for Oracle connection
 my $qualtype = $_[1];      # Qualifier type

 my $statement = "update qualifier"
   . " set has_child = 'N'"
   . " where qualifier_id in"
   . " (select q.qualifier_id"
   . " from qualifier q, qualifier_child qc"
   . " where q.qualifier_id = qc.parent_id(+)"
   . " and qc.child_id is null"
   . " and q.qualifier_type = '$qualtype'"
   . " and q.has_child = 'Y')";
 my $result =  &ora_do($lda, $statement);
 if ($result eq '0E0') {$result = 0;}
 print "Number of rows modified by 1st ora_do is $result\n";

 $statement = "update qualifier"
   . " set has_child = 'Y'"
   . " where qualifier_id in"
   . " (select q.qualifier_id"
   . " from qualifier q, qualifier_child qc"
   . " where q.qualifier_id = qc.parent_id(+)"
   . " and qc.child_id is not null"
   . " and q.qualifier_type = '$qualtype'"
   . " and q.has_child = 'N')";
 $result =  &ora_do($lda, $statement);
 if ($result eq '0E0') {$result = 0;}
 print "Number of rows modified by 2nd ora_do is $result\n";

 &ora_commit($lda);

}

