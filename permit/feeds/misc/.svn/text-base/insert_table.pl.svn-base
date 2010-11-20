#!/usr/bin/perl
#######################################################################
#
#  Read a '!'-delimited input file and insert new records into a table
#
#######################################################################
#
#  Initialize
#
 $db = "roles";
 $user = "rolesbb";
 $tname = "person_history";
 $infile = "phist.save";
 
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
 @unit_code = ();
 @unit_name = ();
 @mit_id = ();
 @kerberos_name = ();
 @last_name = ();
 @first_name = ();
 @middle_name = ();
 @person_type = ();
 printf "Reading in the file $infile...\n";
 while (chop($line = <IN>)) {
   ($kname, $mid, $lname, $fname, $mname, $ucode, $uname, $ptype) 
     = split("!", $line);   # Split into 6 fields
   $ucode = &strip($ucode);
   $mid = &strip($mid);
   $kname = &strip($kname);
   $lname = &strip($lname);
   $fname = &strip($fname);
   $mname = &strip($mname);
   $ptype = &strip($ptype);
   #print $i . ':' . $qid . ":" . $qcode . ":" . $qname . ":"
   #         . $qtype . ":" . $qhc . ":" . $qlev . "\n";
   push(@unit_code, $ucode);
   push(@unit_name, $uname);
   push(@mit_id, $mid);
   push(@kerberos_name, $kname);
   push(@last_name, $lname);
   push(@first_name, $fname);
   push(@middle_name, $mname);
   push(@person_type, $ptype);
   $i++;
 }
 close(IN);
 
#
#  Open a connection to the database. 
#
 print "Enter database name for sqlplus connection: ";
 chop($db = <STDIN>);
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
	"insert into " . $tname .
	" (UNIT_CODE, MIT_ID, KERBEROS_NAME,
        LAST_NAME, FIRST_NAME, PERSON_TYPE, BEGIN_DATE,
        MIDDLE_NAME, UNIT_NAME) 
        values (:1, :2, :3, :4, :5, :6, to_date('07292002', 'MMDDYYYY'),
                :7, :8)")   
        || die $ora_errstr;
 $n = @unit_code;  # How many rows to insert?
 print "Before ora_bind\n";
 for $i (0 .. $n-1) {
   printf("%3d %6d %-6s %-30s %4s %1s %1d \n",
              $i, $unit_code[$i], $mit_id[$i], $kerberos_name[$i], 
              $last_name[$i], $first_name[$i], $person_type[$i]);
   &ora_bind($csr, $unit_code[$i], $mit_id[$i], $kerberos_name[$i], 
             $last_name[$i], $first_name[$i], $person_type[$i],
             $middle_name[$i], $unit_name[$i]) 
     || die "$_: $ora_errstr\n"; 
 }

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
