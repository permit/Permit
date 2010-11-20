#!/loc/bin/perl
########################################################################
#  
#  Read in Fund Center Text and Hierarchy tables, plus FM Acct Assignment
#  file, and produce a file of qualifiers with their parents.
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
#
#  Fund text file has the following format:
#    cc.  0-2   (3)  Client 
#         3-3   (1)  Language key (Look for 'E')
#         4-7   (4)  Financial management area ('MIT ')
#         8-23  (16) Funds center
#        24-31  (8)  FIFM: Valid to date
#        32-51  (20) Name
#        52-91  (40) Description
#
#  Hierarchy file has the following format:
#    cc.  0-2   (3)  Client 
#         3-12  (10) FIFM: Hierarchy Version
#        13-34  (22) Object number          
#        35-35  (1)  Type for identifying objects
#        36-57  (22) Parent object
#        58-79  (22) Left sibling object
#        80-101 (22) Right sibling object
#       102-123 (22) Child object
#       124-127 (4)  FIFM: Level within hierarchy
#       128-135 (8)  Entry date   
#       136-147 (12) Entered by
#       148-155 (8)  FIFM: Change date
#       156-167 (12) FIFM: Name of person making last change
#       168-189 (22) Root object number                     
#
#  FM Acct Assignment file has the following format:
#    cc.  0-2   (3)  Client 
#         3-24  (22) Object number
#        25-34  (10) Cost element
#        35-46  (12) Cost element group
#        47-49  (3)  Period from which this entry is valid
#        50-53  (4)  Fiscal year from which this entry is valid
#        54-57  (4)  Controlling area
#        58-61  (4)  Financial management area
#        62-75  (14) Commitment item
#        76-91  (16) Funds center
#        92-101 (10) Fund
#       102-113 (12) Group name
#       114-123 (10) Field name
#       124-135	(12) Cost element group
#	       
#  1.  Read in the Fund Text file.  Build arrays for qualifier_id,
#      qualifier_code, qualifier_name, has_child, and qualifier_level
#      Build a hash mapping qualifier_code into qualifier_id.
#  2.  Read in the Fund Hierarchy file.  Set $haschild[] for child
#      funds.  Build a hash (%parent_of).
#  3.  Read in the Fund Acct Assignment table.  For each record
#      a.  Add to qualifier_id, qualifier_code, qualifier_name, has_child,
#          and qualifier_level arrays.
#      b.  Add a record to %parent_of hash.  Set has_child = 'Y'
#          for the parent.
#  4.  Use the parent_id/child_id arrays to set
#      qualifier_level for the fund centers.
#  5.  Print out the output (data) file.
#
#  Make up a new level of the tree between qual_code '200000'
#  and its children.  Make up 26 children of '200000', one for each
#  letter A-Z, and make each of the children of '200000' a child
#  of the appropriate letter code instead.
#
########################################################################
$hierfile = "/warehouse/transfers/sapuser/wh-fmhictr";
$fundtfile = "/warehouse/transfers/sapuser/wh-fmfctrt";
$fmassign = "/warehouse/transfers/sapuser/wh-fmzuob";
$outfile = "fund.warehouse";
$log_file = "fundwh.log";
$desired_root = 'FSMIT MIT';    # Accept only records with this root
$desired_version = 'SAP';       # Accept only records with this hier. version 
$desired_language = 'E';        # Accept only records with this lang. code
$seq0 = 700000;
$spons_no = '200000';
$fc_prefix = 'FC';
 
 
#
#   Open output files.
#
  $outf = "|cat >" . $outfile;
  if( !open(F2, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }
  $outf2 = "|cat >" . $log_file;
  if( !open(LOG, $outf2) ) {
    die "$0: can't open ($outf2) - $!\n";
  }
 
#
#   Read each line in $fundtfile
#
 unless (open(IN,$fundtfile)) {
   die "Cannot open $fundtfile for reading\n"
 }
 $i = -1;
 $j = 0;
 @qualid = ();
 @qualcode = ();
 @qualname = ();
 @qualparid = ();
 @quallev = ();
 @haschild = ();
 print "Reading $fundtfile\n";
 while (chop($line = <IN>)) {
   if (($i++)%100 == 0) {print $i . "\n";}
   $flanguage = substr($line, 3, 1 );
   $fund_code = &strip(substr($line, 8, 16));
   $fname = &strip(substr($line, 32, 20));
   $fdesc = &strip(substr($line, 52, 40));
   if ($flanguage eq $desired_language)
   {
     push(@quallev, 0);
     push(@haschild, 'N');
     push(@qualcode, $fc_prefix . $fund_code);
     if ($fdesc ne '') {push(@qualname, $fdesc);}
     else {push(@qualname, $fname);}
     $qqid = $seq0 + ($j++);
     push(@qualid, $qqid);
     $rquid{$fund_code} = $qqid; 
   } 
 }
 close(IN);
 
#
#   Add 26 new qualifiers (200000A - 200000Z). 
#   Make them children of 200000.
#
 %parent_of = ();   # Start setting up hierarchy hash
 $qpar_id = $rquid{$spons_no};  # Get the qual ID of '200000'.
 @letters = qw(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z);
 $n = @letters;  # Count the letters
 for ($i = 0; $i < $n; $i++) {
     push(@quallev, 0);
     push(@haschild, 'N');
     $fund_code = $spons_no . $letters[$i];
     push(@qualcode, $fc_prefix . $fund_code);
     push(@qualname, 'Sponsored Fund Centers: ' . $letters[$i]);
     $qqid = $seq0 + ($j++);
     push(@qualid, $qqid);
     $rquid{$fund_code} = $qqid;
     $parent_of{$qqid} = $qpar_id; # Make 200000c a child of 200000.  
     $idx = $qpar_id - $seq0;  # Calculate the array index
     $haschild[$idx] = 'Y';
 }
 
#
#   Read each line in $hierfile
#
 unless (open(IN,$hierfile)) {
   die "Cannot open $hierfile for reading\n"
 }
 $i = -1;
 print "Reading $hierfile\n";
 while (chop($line = <IN>)) {
   if (($i++)%100 == 0) {print $i . "\n";}
   $hversion = &strip(substr($line, 3, 10));
   $fund_code = &strip(substr($line, 13, 22));
   $fund_code = substr($fund_code, 6);  # Just take the numeric part
   $par_code = &strip(substr($line, 36, 22));
   $par_code = substr($par_code, 6);    # Just take the numeric part
   $flevel = &strip(substr($line, 124, 4));
   $froot = &strip(substr($line, 168, 22));
   if ($hversion eq $desired_version & $froot eq $desired_root)
   {
     $qqid = '';
     $qqid = $rquid{$fund_code};
     $qpar_id = '';
     $qpar_id = $rquid{$par_code};
     #print "Fund code = '$fund_code' ID = '$qqid' Par code = '$par_code'"
     #      . " ID = '$qpar_id'\n";
     #
     #  If the fund center was not found in the fund text file, then put 
     #  an 'Unknown' fund center into the arrays.
     #
     if (($qqid eq '') & ($qpar_id ne '')) {
       push(@quallev, 0);
       push(@haschild, 'N');
       push(@qualcode, $fc_prefix . $fund_code);
       push(@qualname, 'Unknown');
       $qqid = $seq0 + ($j++);
       push(@qualid, $qqid);
       $rquid{$fund_code} = $qqid;
     }
     #
     #  Now, update the arrays. 
     #
     if ( ($qqid ne '') & (($qpar_id ne '') | ($fund_code eq 'MIT')) )
     {
       # If $par_code is '200000', then put in intermediate level between
       # '200000' and this qualifier based on first letter of qual_name.
       if ($par_code eq $spons_no) {
         $idx2 = $qqid - $seq0;
         $byte1 = substr($qualname[$idx2],0,1); # Get 1st byte of qual name
         $byte1 =~ tr/a-z/A-Z/;      # Translate it to upper case
         if (($byte1 ge 'A') & ($byte1 le 'Z')) {
           $qpar_id  
              = $rquid{$spons_no . $byte1};  # Parent is 200000c
           #print "old PAR_CODE=$par_code new PAR_CODE=" . $spons_no . $byte1 
           #   . " new QPAR_ID = $qpar_id QQID=$qqid\n";
         }
       }  
       $idx = $qpar_id - $seq0;  # Calculate the array index
       if ($idx >= 0) {
         $haschild[$idx] = 'Y';
         $parent_of{$qqid} = $qpar_id;
       }
      }
     else
     {
       if ($qqid eq '') {
         print LOG "Error:  Fund '$fund_code' ignored - not found.\n";
       }
       else {
         print LOG "Error:  Fund '$fund_code' ignored - Parent '$par_code'"
           . " not found.\n";
       }
     }
   } 
 }
 close(IN);
 
#
#  Read in FM Acct. Assignment file
#
 unless (open(IN,$fmassign)) {
   die "Cannot open $fmassign for reading\n"
 }
 $i = -1;
 print "Reading $fmassign...\n";
 while (chop($line = <IN>)) {
   if (($i++)%1000 == 0) {print $i . "\n";}
   $fund_code = &strip(substr($line, 92, 10));
   $par_code = &strip(substr($line, 76, 16));
   $qpar_id = '';
   $qpar_id = $rquid{$par_code};
   $qdup_id = '';
   $qdup_id = $rquid{$fund_code};
   #
   # If the parent_id was found and fund code was not already found, 
   # then add this fund to the
   # table of funds/fund centers and set up parent/child relation.
   #
   if (($qpar_id ne '') & ($qdup_id eq '')) {
     $qqid = $seq0 + ($j++);  # Get new qualifier ID
     push(@quallev, 0);
     push(@haschild, 'N');
     push(@qualcode, 'F' . $fund_code);
     push(@qualname, 'Unknown');
     push(@qualid, $qqid);
     $rquid{$fund_code} = $qqid; 
     $parent_of{$qqid} = $qpar_id;
     $idx = $qpar_id - $seq0;  # Calculate the array index of parent
     $haschild[$idx] = 'Y';    # Flag the fact that parent has a child
   }
   else {
     if ($qpar_id eq '') {
       print LOG "Error:  Fund '$fund_code' ignored.  Parent fund '$par_code'"
           . " not found.\n";
     }
     else {
       print LOG "Error:  Duplicate '$fund_code' ignored.\n";
     }
   }
 }
 close(IN);
 
#
#  Get username and password for database connection.
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
#  Make sure we are set up to use Oraperl.
#
 use Oraperl;
 if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}
 
#
#  Open connection to oracle
#
 $lda = &ora_login($db, $userpw, '')
 	|| die $ora_errstr;
 @stmt = ("select qualifier_code, qualifier_name from qualifier"
          . " where qualifier_type = 'COST' and has_child = 'N'");
 $csr = &ora_open($lda, "@stmt")
 	|| die $ora_errstr;
 
#
#  For each Cost Element from the Qualifier table, look for a matching
#  fund (stored in arrays).  Set the qualifier name from the table, and
#  also add a prefix (C, I, or W) to the qualifier code.
#
 print "Reading in Cost Elements from Oracle table...\n";
 $i = -1;
 while ((($qqcode, $qqname) = &ora_fetch($csr))) {
   if (($i++)%1000 == 0) {print $i . "\n";}
   $fund_code = substr($qqcode,1);   # Chop off 'C', 'I', or 'W'
   $qqid = '';
   $qqid = $rquid{$fund_code};
   if ($qqid ne '') {
     $idx = $qqid - $seq0;   # Calculate index number in array
     $qualname[$idx] = $qqname;  # Set qualifier name
     #$qualcode[$idx] = $qqcode;  # Set qualifier code (old way)
     $qualcode[$idx] = 'F' . $fund_code;  # Set qualifier code (preferred)
   }
 }
 do ora_close($csr) || die "can't close cursor";
 
#
#  Print out qualifiers
#
 print "Writing out file...\n";
 for ($i = 0; $i < @qualcode; $i++) {
   $qqid = $i + $seq0;
   $parent_idx = $parent_of{$qqid} - $seq0;
   $parent_code = $qualcode[$parent_idx];
   #if (($qualname[$i] ne 'Unknown') | ($haschild[$i] eq 'Y')
   #    | (substr($qualcode[$i],0,2) ne 'FC'))
   if (1)
   {
     # TYPE, CODE, PARENT, NAME
     printf F2 "%s!%s!%s!%s\n",
             'FUND', $qualcode[$i], $parent_code, $qualname[$i];
   }
 }
 
 close (F2);
 
 close (LOG);
 do ora_logoff($lda) || die "can't log off Oracle";
 
exit();
###########################################################################
#
#  Function &strip(string)
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
 
###########################################################################
#
#  Recursive function &count_parents($qqid)
#  Counts the parents of a given qualifier by traversing the %parent_of
#    hash
#
###########################################################################
sub count_parents {
  my($n, $qid);
  $qid = $_[0];
  if (exists $parent_of{$qid}) {
    $n = 1 + &count_parents($parent_of{$qid});
  }
  else {
    $n = 0;
  }
 
  $n;
}
