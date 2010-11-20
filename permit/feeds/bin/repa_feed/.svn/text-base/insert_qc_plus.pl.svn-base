#!/usr/bin/perl
#######################################################################
#
#  Read the input "*.child" file & insert rows into qualifier_child table.
#  Also, make sure the HASCHILD = 'Y' for each of the parent rows
#    in the QUALIFIER table.
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
 $db = "roles";
 $user = "rolesbb";
 $tname = "qualifier_child";
 $tname2 = "qualifier";
 #$infile = "qualchild.table";
 #$infile = "costadd2.child";
 #$infile = "profadd.child";
 #$infile = "prof3.child";
 $infile = "fundadd.child";
 
#
# Set up Oraperl
#
 eval 'use Oraperl; 1' || die $@ if $] >= 5;
 die ("Need to use oraperl, not perl\n") unless defined &ora_login;
 $| = 1; #Force Ouput Buffer to Flush on each write
 
#
#  Open a connection to the database. 
#
 print "Enter password for user '$user' at '$db': ";
 system("stty -echo\n");
 chop($pw = <STDIN>);
 print "\n";
 system("stty echo\n");
 $lda = &ora_login($db, $user, $pw) || die $ora_errstr;
 
#
#  Don't delete all rows from the table.
#
# &ora_do($lda, "delete from $tname") 
#   || die $ora_errstr;
#
 
 
#  
# Set up cursor to insert the rows
#
 $csr = &ora_open($lda,
		 'insert into rdb_t_qualifier_child
		 (PARENT_ID, CHILD_ID) 
                  values (:1, :2)')   
        || die $ora_errstr;
 
#
#  Read the input file.  Insert records into the table.
#
#
 unless (open(IN,$infile)) {
   die "Cannot open $infile for reading\n"
 }
 while (chop($line = <IN>)) {
   ($parent, $child) = split('!', $line);
   printf("%6s %6s\n", $parent, $child);
   &ora_bind($csr, $parent, $child) 
     || die "$_: $ora_errstr\n"; 
   &ora_do($lda, "update $tname2 set has_child = 'Y' "
          . "where qualifier_id = $parent and has_child = 'N'") 
    || die $ora_errstr;
 }
 close(IN);
 
#  
#  Commit work and logoff.
#
 &ora_commit($lda); #Now we can commit
 &ora_logoff($lda);
 
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
