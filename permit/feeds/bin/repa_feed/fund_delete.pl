#!/usr/bin/perl
#######################################################################
#
#  Read the differences file produced by 'compare_fund3.pl' and
#  process the 'DELETE' records, generating a file with SQL statements
#  to delete the records from the qualifier, qualifier_child, and
#  qualifier_descendent tables.
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
 $infile = "fund.actions";
 $qualtype = 'FUND';
 $outfile = "fund_delete.sql";
 
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
#  Open a cursor, and read all records from the qualifier table
#  for the given qualtype.  Build a hash %rquid that maps qualifier_code
#  to qualifier_id. Build another one, %rqlevel, that maps qualifier_code
#  to qualifier_level. 
#
 @stmt = ("select qualifier_id, qualifier_code, qualifier_level, has_child"
          . " from $tname"
          . " where qualifier_type = '$qualtype'");
 $csr = &ora_open($lda, "@stmt")
        || die $ora_errstr;
 print "Reading in Qualifiers from Oracle table...\n";
 $i = -1;
 while ((($qqid, $qqcode, $qqlevel,$qhaschild) = &ora_fetch($csr))) {
   if (($i++)%1000 == 0) {print $i . "\n";}
   $rquid{$qqcode} = $qqid;
   $rqlevel{$qqcode} = $qqlevel;
   $rhaschild{$qqcode} = $qhaschild;
 }
 
 do ora_close($csr) || die "can't close cursor";
 
#
#  Open another cursor, and read distinct qualifier_codes from the
#  authorization table.
#
 @stmt = ("select distinct qualifier_code from authorization"
          . " where qualifier_code like 'F%'");
 $csr = &ora_open($lda, "@stmt")
        || die $ora_errstr;
 print "Reading in distinct Qualifiers from Authorization table...\n";
 while (($qqcode) = &ora_fetch($csr)) {
   $auth_qcode{$qqcode} = 1;
 }
 
 do ora_close($csr) || die "can't close cursor";
 
#
#   Open output file.
#
  $outf = "|cat >" . $outfile;
  if( !open(F1, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }
 
 
#
#  Read the input file.  Look up qualifier_id of parent.  Write new
#  qualifiers to $datafile.  Write new parent/child pairs to $childfile.
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
   if ($action eq 'DELETE') {
     $qcode = &strip($qcode);
     $qhaschild = $rhaschild{$qcode};
     $qid = $rquid{$qcode};
     if ($auth_qcode{$qcode} == 1) {
       print "Cannot delete $qcode:  Referenced by an authorization\n";
     }
     elsif ($qhaschild eq 'Y') {
       print "Cannot delete $qcode:  It has children in the hierarchy\n";
     }
     elsif ($qid eq '') {
       print "Cannot delete $qcode:  qualifier_id not found in table\n";
     }
     else {
       print F1 "delete from qualifier_descendent where child_id = '$qid';\n";
       print F1 "delete from qualifier_child where child_id = '$qid';\n";
       print F1 "delete from qualifier where qualifier_id = '$qid';\n";
     }
   }
 }
 close(IN);
 close(F1);
 close(F2);
 
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
