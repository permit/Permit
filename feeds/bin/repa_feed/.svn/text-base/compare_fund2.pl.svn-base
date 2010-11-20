#!/usr/bin/perl
########################################################################
#
#  Extract FUND data from qualifier table of Roles DB.
#  Do it with two separate select statements for performance.  
#
#
#  Copyright (C) 2000-2010 Massachusetts Institute of Technology
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
########################################################################
$outfile = "fund.roles";
$qqualtype = 'FUND';
 
#
#   Open output file.
#
  $outf = "|cat >" . $outfile;
  if( !open(F2, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }
#
#  Get username and password for database connection.
#
 print "Enter Roles database name for sqlplus connection: ";
 chop($db = <STDIN>);
 print "Enter Roles username for sqlplus connection: ";
 chop($user = <STDIN>);
 print "Enter Roles password for user '$user' at $db: ";
 system("stty -echo\n");
 chop($pw = <STDIN>);
 print "\n";
 system("stty echo\n");
 $userpw = $user . '/' . $pw;
#
#  Make sure we are set up to use Oraperl.
#
 use Oraperl;
 if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}
 
#
#  Open connection to oracle
#
 $lda = &ora_login($db, $userpw, '')
        || die $ora_errstr;
 
#
#  Open first cursor
#
 $time0 = time();
 @stmt = ("select c.parent_id, q.qualifier_id, q.qualifier_code," 
          . " q.qualifier_name, q.has_child" 
          . " from qualifier q, qualifier_child c"
          . " where q.qualifier_id = c.child_id"
          . " and q.qualifier_type = '$qqualtype'"
          . " union"
          . " select -1, qualifier_id, qualifier_code,"
          . " qualifier_name, has_child"
          . " from qualifier"
          . " where qualifier_level = 1 and qualifier_type = '$qqualtype'"
          . " order by 3");
 $csr = &ora_open($lda, "@stmt")
        || die $ora_errstr;
 %qid_to_code = ();
 print "Reading in Qualifiers (type = '$qqualtype') from Oracle table...\n";
 $i = -1;
 while ((($qparentid, $qqid, $qqcode, $qqname, $qhaschild) 
        = &ora_fetch($csr))) 
 {
   if (($i++)%1000 == 0) {print $i . "\n";}
   push(@parentid, $qparentid);
   push(@qualcode, $qqcode);
   push(@qualname, $qqname);
   push(@haschild, $qhaschild);
   $qid_to_code{$qqid} = $qqcode;  # Build hash mapping qual_id to qual_code.
 }
 do ora_close($csr) || die "can't close cursor";
 $elapsed_sec = time() - $time0;
 print "Elapsed time of first query = $elapsed_sec seconds.\n";
 
#
#  Print out file of cost collectors
#
 $time0 = time();
 print "Getting parent qualifier_codes and writing out file...\n";
 for ($i = 0; $i < @parentid; $i++) {
   if ($i%1000 == 0) {print $i . "\n";}
   #if ($qualcode[$i] =~ /^[CIW]/) {  # Look for leaf-level cost collectors
   if (1) {  # Look for all Funds and Fund Centers
     $qparentid = $parentid[$i];
     $qparentcode = $qid_to_code{$qparentid};
     $qparentcode =~ s/0PR/P/;   # Change prof. center codes
     #print "qparentid = $qparentid qparentcode = $qparentcode\n";
     # TYPE, CODE, PARCODE, NAME
     printf F2 "%s!%s!%s!%s\n",
             $qqualtype, $qualcode[$i], $qparentcode, $qualname[$i];
   }
 }
 $elapsed_sec = time() - $time0;
 print "Elapsed time of 2nd stage = $elapsed_sec seconds.\n";
 
 close (F2);
 
 do ora_logoff($lda) || die "can't log off Oracle";
 
 exit();
