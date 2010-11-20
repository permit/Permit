#!/usr/bin/perl
#######################################################################
#
#  Read a '!'-delimited input file and insert new records into the
#  qualifier table.
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
 $tname = "qualifier";
 $tname2 = "qualifier_child";
 #$infile = "profadd.data";
 #$infile = "costadd2.data";
 $infile = "fundadd.data";
 #$infile = "fundadd2a.data";
 
#
# Set up Oraperl
#
eval 'use Oraperl; 1' || die $@ if $] >= 5;
die ("Need to use oraperl, not perl\n") unless defined &ora_login;
 
 
#
#  Read the input file.
#
#
 @field = ();    # Initialize array of field names
 unless (open(IN,$infile)) {
   die "Cannot open $infile for reading\n"
 }
 $i = 0;
 @qualid = ();
 @qualcode = ();
 @qualname = ();
 @qualtype = ();
 @haschild = ();
 @quallevel = ();
 printf "Reading in the file $infile...\n";
 while (chop($line = <IN>)) {
   ($qid,$qcode, $qname,$qtype,$qhc,$qlev) 
     = split("!", $line);   # Split into 5 fields
   $qcode = &strip($qcode);
   $qname = &strip($qname);
   #print $i . ':' . $qid . ":" . $qcode . ":" . $qname . ":"
   #         . $qtype . ":" . $qhc . ":" . $qlev . "\n";
   push(@qualid, $qid);
   push(@qualcode, $qcode);
   push(@qualname, $qname);
   push(@qualtype, $qtype);
   push(@qualchild, $qhc);
   push(@quallevel, $qlev);
   $i++;
 }
 close(IN);
 
#
#  Open a connection to the database. 
#
 print "Enter password for user '$user' at $db: ";
 system("stty -echo\n");
 chop($pw = <STDIN>);
 print "\n";
 system("stty echo\n");
 $lda = &ora_login($db, $user, $pw) || die $ora_errstr;
 
#
#  Insert each row into the table.
#
 ## Set up cursor to insert the rows
 print "Before ora_open\n";
 $csr = &ora_open($lda,
		 'insert into ' . $tname .
		 ' (QUALIFIER_ID, QUALIFIER_CODE, QUALIFIER_NAME,
                  QUALIFIER_TYPE, HAS_CHILD, QUALIFIER_LEVEL) 
                  values (:1, :2, :3, :4, :5, :6)')   || die $ora_errstr;
 $n = @qualid;  # How many rows to insert?
 print "Before ora_bind\n";
 for $i (0 .. $n-1) {
   printf("%3d %6d %-6s %-30s %4s %1s %1d \n",
              $i, $qualid[$i], $qualcode[$i], $qualname[$i], $qualtype[$i],
              $qualchild[$i], $quallevel[$i]);
   &ora_bind($csr, $qualid[$i], $qualcode[$i], $qualname[$i], $qualtype[$i],
             $qualchild[$i], $quallevel[$i]) 
     || die "$_: $ora_errstr\n"; 
 }
#
#  Insert records into qualifier_child table.
#
 ## Set up cursor to insert the rows
# print "Before 2nd ora_open\n";
# $csr2 = &ora_open($lda,
#		 'insert into ' . $tname2 .
#		 ' (PARENT_ID, CHILD_ID)
#                  values (:1, :2)')   || die $ora_errstr;
# $n = @qualid;  # How many rows to insert?
# print "Before 2nd ora_bind\n";
# for $i (0 .. $n-1) {
#   printf("%3d %6d %6d \n",
#              $i, 300000, $qualid[$i]);
#   &ora_bind($csr2, '300000', $qualid[$i]) 
#     || die "$_: $ora_errstr\n"; 
# }
 
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
