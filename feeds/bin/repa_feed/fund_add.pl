#!/usr/bin/perl
#######################################################################
#
#  Read the differences file produced by 'compare_fund3.pl' and
#  process the 'ADD' records, adding new records to qualifier table 
#  and qualifier_child table.
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
 $datafile = "fundadd.data";
 $childfile = "fundadd.child";
 
#
# Set up Oraperl
#
eval 'use Oraperl; 1' || die $@ if $] >= 5;
die ("Need to use oraperl, not perl\n") unless defined &ora_login;
$| = 1; #Force Ouput Buffer to Flush on each write
 
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
#   Open output files.
#
  $outf = "|cat >" . $datafile;
  if( !open(F1, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }
  $outf2 = "|cat >" . $childfile;
  if( !open(F2, $outf2) ) {
    die "$0: can't open ($outf2) - $!\n";
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
   if ($action eq 'ADD') {
     $qcode = &strip($qcode);
     $qname = &strip($qname);
     $parentcode = &strip($parentcode);
     $parentcode =~ s/P/0PR/;   # Translate to the format we're using
     $parentid = $rquid{$parentcode};
     $parentlevel = $rqlevel{$parentcode};
     $new_level = $parentlevel + 1;
     $next_qqid++;    # Increment qualifier id
     # ID CODE NAME TYPE HAS_CHILD LEVEL
     print F1 "$next_qqid!$qcode!$qname!$qualtype!N!$new_level\n";
     print F2 "$parentid!$next_qqid\n";
     # Add this qualifier to the in-core hashes
     $rquid{$qcode} = $next_qqid;
     $rqlevel{$qcode} = $new_level;
   }
   elsif ($action eq 'ADDCHILD') {
     $qcode = &strip($qcode);
     $qqid = $rquid{$qcode};
     $parentcode = &strip($parentcode);
     $parentcode =~ s/P/0PR/;   # Translate to the format we're using
     $parentid = $rquid{$parentcode};
     $parentlevel = $rqlevel{$parentcode};
     $new_level = $parentlevel + 1;
     # PARENTID CHILDID
     print F2 "$parentid!$qqid\n";
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
