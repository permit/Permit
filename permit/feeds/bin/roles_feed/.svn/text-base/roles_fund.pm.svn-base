###############################################################################
## NAME: roles_fund.pm
##
## DESCRIPTION: Subroutines related to qualifier feed for 'COST' qualifiers
##
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
## MODIFICATION HISTORY:
## Modified 5/11/1998 to call &fix_haschild - J. Repa
## Modified 7/26/1998 to ignore blank Fund Centers and Funds
## Modified 8/28/1998 to mail fund.actions to Ormin - J. Repa
## Modified 9/15/1999 to accommodate change in SAP rel 4.5 - J. Repa
## Modified 12/29/2000 to stop mailing fund.actions to Ormin
## Modified 02/26/2007 to accomodate changes in SAP  -J. Repa, M. Korobko
##                              use wh-fmfctr in new format,
##                              wh-fmhisv instead of wh-fmhictr,
##                              wh-cc_fund_map instead of wh-fmzuob.
## Modified 7/13/2007 M.Korobko
##   --  use table roles_parameters to find MAX_ACTIONS allowed 
## Modified 9/29/2009 J. Repa - filter out "DELETED" 7-digit Funds Centers
###############################################################################

package roles_fund;   
$VERSION = 1.0; 
$package_name = 'roles_fund';  

## Standard Roles Database Feed Package
use roles_base qw(UsageExit ScriptExit login_dbi_sql RolesLog RolesNotification ArchiveFile
                  find_max_actions_value find_max_actions_value2  ExecuteSQLCommands);
use roles_qual 
  qw(strip ProcessActions FixDescendents sort_actions fix_haschild);

## Set Test Mode
$TEST_MODE = 1;		## Test Mode (1 == ON, 0 == OFF)
if ($TEST_MODE) {print "TEST_MODE is ON for $package_name.pm\n";}

use DBI;

## Initialize Constants 
$datafile_dir = $ENV{'ROLES_HOMEDIR'} . "/data/";
$archive_dir = $ENV{'ROLES_HOMEDIR'} . "/archive/";

$extract_filename = $datafile_dir . $package_name . "_extract.dat";
$existing_filename = $datafile_dir . $package_name . "_existing.dat";

$extraperson_filename = $datafile_dir . $package_name . "_extra.dat";

# Diff File Prefix used during Compare Routine
$diff_file_prefix = $datafile_dir . $package_name;

# Diff File Suffix/Tags used by the 'diff' package during the file compare
$diff_tag_insert = ".INSERT";
$diff_tag_update = ".UPDATE";
$diff_tag_delete = ".DELETE";

# The actual file names that the 'diff' package will write 
$update_file= $diff_file_prefix . $diff_tag_update;
$insert_file= $diff_file_prefix . $diff_tag_insert;
$delete_file= $diff_file_prefix . $diff_tag_delete;



###############################################################################
###############################################################################
##
## Subroutines - Public Routines. (Called by 'roles_feed.pl')
##
###############################################################################
###############################################################################

###############################################################################
sub FeedExtract	#Externally Callable Extract Routine for this Package
###############################################################################
{
	if ($TEST_MODE) {print "In $package_name:FeedExtract.\n";}

	shift; #Get rid of calling package name

	## Step 0: Check Arguments
	if ($#_ != 2)	{&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
	my($user_id, $user_pw, $ftp_machine) = @_;



	## FTP the Data: get four files

	&FTPFromWarehouse($user_id, $user_pw, $ftp_machine, $datafile_dir);

	## Create single file of fund centers and funds

	&CombineFundInfo($datafile_dir);

	return;
}

###############################################################################
sub FeedPrepare 	#Externally Callable Feed Prepare Routine
###############################################################################
{
	if ($TEST_MODE) {print "In $package_name:FeedPrepare.\n";}

	shift; #Get rid of calling package name

	## Step 0: Check Arguments
	if ($#_ != 2)	{&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
	my($user_id, $user_pw, $db_id) = @_;

	## Step 2: Log Into Destination Database
	my($destination_lda) = login_dbi_sql($db_id, $user_id, $user_pw)
			|| (
			&RolesLog("FATAL_MSG",
				$DBI::errstr) &&
			ScriptExit("Unable to Log into Destination Database: $db_id.")		);

	## Step 3: Get Extract from Destination Database
	unless (-w $datafile_dir)
	{
		&RolesLog("FATAL_MSG",
			"Datafile Directory is not writable: $datafile_dir");
		ScriptExit("Unable write to directory $datafile_dir.");
	}

	## Get data from roles
	&ExistingExtract($destination_lda, $datafile_dir);


	## Step 4: Log off Destination Database
	$destination_lda->disconnect();


	## compare data
	&CompareExtract($datafile_dir);

	return;
}

###############################################################################
sub FeedLoad 	#Externally Callable Feed Load Routine for this Package
###############################################################################
{
	if ($TEST_MODE) {print "In $package_name:FeedLoad.\n";}

	shift; #Get rid of calling package name

	my($infile) = $datafile_dir . "fund.actions";
	my($sqlfile) = $datafile_dir . "fundchange.sql";
	my($sqlfile2) = $datafile_dir . "funddesc.sql";
	my($mail_subject_file) = $datafile_dir . "mail.subject1";
	my($qualtype) = "FUND";

	## Step 0: Check Arguments
	if ($#_ != 2){&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
	my($user_id, $user_pw, $db_id) = @_;


	## Check number of actions to be preformed
        $MAX_ACTIONS = &find_max_actions_value2($db_id,$user_id,$user_pw, "MAX_FUND");
	if (-r $infile) {
	  $actions_count = `grep -c . $infile`;
	  chomp($actions_count);
        }
        else {
          die "Missing actions file '$infile'\n";
        }

	if ($actions_count > $MAX_ACTIONS)
	{
 	 $msg = "Number of Actions ($actions_count) exceeds threshold ($MAX_ACTIONS).\n";
	 print $msg;
	 &RolesNotification("Number of actions exceeds threshold", $msg);
	 return -1; # send email
	}
        elsif ($actions_count == 0) {
         $msg = "No actions to process today.\n";
         print $msg;
	 #&RolesNotification("No actions to process today.", $msg);
         return -1;
        }
	else
	{
	 print "$actions_count actions to be performed.\n";
	}

	## Step 1: Log Into Destination Database
	my($destination_lda) = &login_dbi_sql($db_id, $user_id, $user_pw)
			|| (
			&RolesLog("FATAL_MSG",
				"Unable to log into destination database $DBI::errstr") &&
			ScriptExit("Unable to Log into Destination Database: $db_id.")		);

	## Step 2: Update, Insert and Delete Records

	if (-r $infile) {&ProcessActions($destination_lda, $qualtype, $infile, $sqlfile);}

        # Run the first .sql file
 	ExecuteSQLCommands($sqlfile,$destination_lda);

	#my($cmd) = "sqlplus $user_id/$user_pw\@$db_id \@$sqlfile";

	#$rc = system($cmd);
	#$rc >>= 8;
	#unless ($rc == 0) {
        #  print "Error return code $rc from first sqlplus\n";
        #  die;
        #}

        # Run &fix_haschild to make sure haschild field is right for 'COST'
        # records in the qualifier table.
        &fix_haschild($destination_lda, $qualtype);

        # Create 2nd .sql file, to fix the qualifier_descendents table.
	if (-r $infile) {&FixDescendents($destination_lda, $qualtype, $infile, $sqlfile2);}
        # Run the 2nd .sql file
	 ExecuteSQLCommands($sqlfile2,$destination_lda);

	#$cmd = "sqlplus $user_id/$user_pw\@$db_id \@$sqlfile2";
        #print "cmd = '$cmd'\n";
	#$rc = system($cmd);
	#$rc >>= 8;
	#unless ($rc == 0) {
        #  print "Error return code $rc from 2nd sqlplus\n";
        #  die;
        #}

        ## Quick-and-dirty E-mail to ormin.  If database is "roles",
        ## then send out E-mail.
        if (1 == 0) {  # Don't do it!
          if ($db_id eq 'roles') {
            system("cat $mail_subject_file $infile \|"
                   . " mail ormin\@mit.edu repa\@mit.edu");  
          }
        }

	## Step 3: Archive Files
&ArchiveFile($infile, $archive_dir);
#	&ArchiveFile($extract_filename, $archive_dir);
#	&ArchiveFile($existing_filename, $archive_dir);
#	if (-r $update_file) {&ArchiveFile($update_file, $archive_dir);}
#	if (-r $insert_file) {&ArchiveFile($insert_file, $archive_dir);}
#	if (-r $delete_file) {&ArchiveFile($delete_file, $archive_dir);}
	
	## Step 5: Log off Destination Database
	$destination_lda->disconnect();

	return;
}

###############################################################################
sub FeedExternalExtract	#Externally Callable External Extract Routine
###############################################################################
{
	if ($TEST_MODE) {print "In $package_name:FeedExternalExtract.\n";}

	shift; #Get rid of calling package name

	## Not Defined
	return -1;
}

###############################################################################
sub CheckStatus	#Externally Callable Status Routine to for this Package
###############################################################################
{
	if ($TEST_MODE) {print "In $package_name:CheckStatus.\n";}

	shift; #Get rid of calling package name

	return;
}


###############################################################################
sub PackageTest	#Externally Callable Package Test Routine 
###############################################################################
{
	if ($TEST_MODE) {print "In $package_name:PackageTest.\n";}

	return;
}


###############################################################################
###############################################################################
##
## Subroutines - Private Common Routines.
##
###############################################################################
###############################################################################

#############################################################################
#
#  Use FTP to get fund-related files from the Warehouse
#
#############################################################################

sub FTPFromWarehouse
{

 my($user_id, $user_pw, $ftp_machine, $data_dir) = @_;

  my(@files) = ('wh-fmfctrt', 'wh-fmhisv', 'wh-cc_fund_map', 'wh-fmfint');

#  Get the username for the Warehouse FTP connection
#
# print "Enter username for FTP connection to Warehouse: ";
# chop($user = <STDIN>);


#print "using variables: $user_id, $user_pw, $ftp_machine, $data_dir";

#
#  Run FTP
#
 open (FTP, "|ftp -n -v $ftp_machine\n");
 #open (FTP, "|cat > ftp.log\n");
 print FTP "user $user_id $user_pw\n";

 print FTP "lcd $data_dir\n";
 print FTP "ls -l\n";
 for ($i = 0; $i < @files; $i++) {
   print FTP "get $files[$i]\n";
 }
 print FTP "quit\n";
 close (FTP);
 print "\nFTP completed.\n";

}

########################################################################
#  
#  Read in Fund Center Text and Hierarchy tables, plus FM Acct Assignment
#  file, and produce a file of qualifiers with their parents.  This 
#  version looks for Fund names in both the wh-fmfint file and in
#  the Roles Qualifiers (qualifier_type = 'COST').
#
#  Fund text file (fmfctrt) has the following format:
#    cc.  0-2   (3)  Client 
#         3-3   (1)  Language key (Look for 'E')
#         4-7   (4)  Financial management area ('MIT ')
#         8-23  (16) Funds center
#        24-31  (8)  FIFM: Valid to date
#        32-39  (8)  FM: Valid from data --- new field 
#        40-59  (20) Name
#        60-99  (40) Description
#
#
#  Hierarchy file (fmhisv) has the following format: 
#    cc.  0-2  (3)  MANDT            MANDT            Client 
#         3-6  (4)  FIRKS            FIRKS            Financial Management Area
#         7-10 (4)  HIVARNT          FM_HIVARNT       Hierarchy Varant of Funds Center    
#        11-26 (16) FISTL            FISTL            Funds Center 
#        27-42 (16) HIROOT_ST        FM_FICTR_T       Top Funds Center in a Subtree
#        43-58 (16) PARENT_ST        FM_FICTR_P       Superior funds center
#        59-74 (16) NEXT_ST          FM_FICTR_N       Next Funds Center on Same Hierarchy Level
#        75-90 (16) CHILD_ST         FM_FICTR_C       Subordinate Funds Center       
#        91-94 (4)  HILEVEL          FM_HILEVEL FIRM: Level within a hierarchy    
#
#  FM Acct Assignment (fmfzuob) file has the following format:
#    cc.  0-2   (3)  Client 
#         3-24  (22) Object number
#        25-34  (10) Cost object
#        35-46  (12) Cost object group
#        47-49  (3)  Period from which this entry is valid
#        50-53  (4)  Fiscal year from which this entry is valid
#        54-57  (4)  Controlling area
#        58-61  (4)  Financial management area
#        62-75  (14) Commitment item
#        76-91  (16) Funds center       **** Becomes 64-79 in rel 4.5
#        92-101 (10) Fund               **** Becomes 80-89 in rel 4.5
#       102-113 (12) Group name
#       114-123 (10) Field name
#       124-135	(12) Cost object group
#
#   File wh_cc_fund_map  (created by the ABAP  Program: ZWHCOST_OBJECT_FUND_MAP) 
#         has the following format: 
#      cc.    0-21 (22) Object_number
#            22-33 (12) Cost Object
#            34-37 (4)  Company Code
#            38-38 (1)  Cost Object type (C,I,W) 
#            39-39 (1)  Cost Object Status
#            40-44 (5)  Cost Collector Category Code
#            45-54 (10) Fund Code
#            55-70 (16) Fund Center Code
#            71-72 (2) Admin Flag
#
#  Fund text file (fmfint) has the following format:
#    cc.  0-2   (3)  Client 
#         3-3   (1)  Language key (Look for 'E')
#         4-7   (4)  Financial management area ('MIT ')
#         8-17  (10) Fund
#        18-37  (20) Short name
#        38-77  (40) Long Name
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

sub CombineFundInfo
{
my($data_dir) = @_;

$hierfile = $data_dir . "wh-fmhisv"; 
$fundtfile = $data_dir . "wh-fmfctrt";
#$fmassign = $data_dir . "wh-fmzuob";
$fmassign = $data_dir . "wh-cc_fund_map";
$fmftxt = $data_dir . "wh-fmfint";
$outfile = $data_dir . "fund.warehouse";
$log_file = $data_dir . "fundwh.log";
$desired_root = 'MIT';
#$desired_root = 'FSMIT MIT';    # Accept only records with this root
#$desired_version = 'SAP';       # Accept only records with this hier. version 
$desired_language = 'E';        # Accept only records with this lang. code
$seq0 = 700000;			# Starting QUALIFIER_ID Number for funds
$spons_no = '200000';		# This fund center has special processing
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
 my $i = -1;
 my $j = 0;
 my @qualid = ();
 my @qualcode = ();
 my @qualname = ();
 my @qualparid = ();
 my @quallev = ();
 my @haschild = ();
 if ($TEST_MODE) { print "Reading $fundtfile\n"};
 while (chop($line = <IN>)) {
   if ($TEST_MODE) {if (($i++)%1000 == 0) {print $i . "\n";}}  #Check Progress
   my $flanguage = substr($line, 3, 1 );
   my $fund_code = &strip(substr($line, 8, 16));
    my $fname = &strip(substr($line, 40, 20));  
    my $fdesc = &strip(substr($line, 60, 40));
    my $is_deleted = 'N';
    if ( ($fname eq 'DELETED' || $fname eq 'DELTED') && length($fund_code) == 7)
   {
       $is_deleted = 'Y';
   }

   if (($flanguage eq $desired_language) && ($fund_code ne '') && ($is_deleted eq 'N') )
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
   #if (($i++)%1000 == 0) {print $i . "\n";}
   $fund_code = &strip(substr($line, 11,6));
   $par_code = &strip(substr($line, 43,6));
   $flevel = &strip(substr($line, 91, 4));
   $froot = &strip(substr($line, 27,6));
###   if ($hversion eq $desired_version & $froot eq $desired_root)
      if ($froot eq $desired_root) 
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
######### NEW USING Warehouse table whcost_object_work ##########
#
## #Make sure we are set up to use Oraperl.
##  use Oraperl;
## if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}
### Get parameters needed to open an Oracle connection to the Warehouse
###
##   $db_parm =  GetValue("testwarehouse"); # Info about testwarehouse from config file
##   $db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
##   $user_id = $1;
##   $user_pw = $2;
##   $db_id = $3;
#
### Open connection to oracle
###
### print "db_id='$db_id' user_id='$user_id'\n";
##  my ($lda) = &ora_login($db_id, $user_id, $user_pw)
##          || die $ora_errstr;
##
##my $stmtm = " select fund_id fund_code, fund_center_id par_code from wareuser.whcost_object_work"; 
##my $csr1 = ora_open($lda,$stmtm)
##       || die $ora_errstr; 
##while ( ( $fund_code, $par_code) =  &ora_fetch($csr1) )
##  {
##    $qpar_id = '';
##    $qpar_id = $rquid{$par_code};
##    $qdup_id = '';
##    $qdup_id = $rquid{$fund_code};  
###
##   # If the parent_id was found and fund code was not already found,
##   # and fund code not blank, then add this fund to the
##   # table of funds/fund centers and set up parent/child relation.
##   #
##   if (($qpar_id ne '') && ($qdup_id eq '') && ($fund_code ne '')) {
##     $qqid = $seq0 + ($j++);  # Get new qualifier ID
##     push(@quallev, 0);
##     push(@haschild, 'N');
##     push(@qualcode, 'F' . $fund_code);
##     push(@qualname, 'Unknown');
##     push(@qualid, $qqid);
##     $rquid{$fund_code} = $qqid;
##     $parent_of{$qqid} = $qpar_id;
##     $idx = $qpar_id - $seq0;  # Calculate the array index of parent
##     $haschild[$idx] = 'Y';    # Flag the fact that parent has a child
##   }
##   else {
##     if ($qpar_id eq '') {
##       print LOG "Error:  Fund '$fund_code' ignored.  Parent fund '$par_code'"
##           . " not found.\n";
##     }
##     else {
##       print LOG "Error:  Duplicate '$fund_code' ignored.\n";
##     }
##   }
## }
## close(IN);
############## OLD #######
 unless (open(IN,$fmassign)) {
   die "Cannot open $fmassign for reading\n"
 }
 $i = -1;
 print "Reading $fmassign...\n";
 while (chop($line = <IN>)) {
   #if (($i++)%5000 == 0) {print $i . "\n";}
##   if (substr($line, 92, 1) ne ' ') {  # Pre-release-4.5
##     $fund_code = &strip(substr($line, 92, 10));
##     $par_code = &strip(substr($line, 76, 16));
##   }
##   else {  # Post-release-4.5
##     $fund_code = &strip(substr($line, 80, 10));
##     $par_code = &strip(substr($line, 64, 16));
      $fund_code = &strip(substr($line, 45, 10));
      $par_code = &strip(substr($line, 55, 16)); 
#}
   $qpar_id = '';
   $qpar_id = $rquid{$par_code};
   $qdup_id = '';
   $qdup_id = $rquid{$fund_code};
   #
   # If the parent_id was found and fund code was not already found, 
   # and fund code not blank, then add this fund to the
   # table of funds/fund centers and set up parent/child relation.
   #
   if (($qpar_id ne '') && ($qdup_id eq '') && ($fund_code ne '')) {
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
#  Read in Fund text file (fmfint)
#
 unless (open(IN,$fmftxt)) {
   die "Cannot open $fmftxt for reading\n"
 }
 $i = -1;
 print "Reading $fmftxt...\n";
 while (chop($line = <IN>)) {
   #if (($i++)%5000 == 0) {print $i . "\n";}
   $fund_code = &strip(substr($line, 8, 7));
   $fund_name = &strip(substr($line, 38, 40));
   $qqid = '';
   $qqid = $rquid{$fund_code};
   if ($qqid ne '') {
     $idx = $qqid - $seq0;   # Calculate index number in array
     $qualname[$idx] = $fund_name;  # Set qualifier name
   }
 }
 close(IN);
 
#
#  Get username and password for database connection.
#
	use config('GetValue');
        $db_parm = GetValue("roles");
  	$db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
	#$userpw  = $1 . "/" . $2;
	#$db  = $3;
    my $user  = $1;
    my $pw  = $2;
    my $db  = $3;

#
#  Make sure we are set up to use Oraperl.
#
 
#
#  Open connection to oracle
#
 my $lda = &login_dbi_sql($db, $user, $pw)
 	|| die $DBI::errstr;
 my $stmt = "select qualifier_code, qualifier_name from qualifier"
          . " where qualifier_type = 'COST' and has_child = 'N'";
 my $csr = $lda->prepare( $stmt)
 	|| die $DBI::errstr;
$csr->execute();
 
#
#  For each Cost Object from the Qualifier table, look for a matching
#  fund (stored in arrays).  Set the qualifier name from the table, and
#  also add a prefix (C, I, or W) to the qualifier code.
#
 print "Reading in Cost Objects from Oracle table...\n";
 $i = -1;
 while ((($qqcode, $qqname) = $csr->fetchrow_array())) {
   #if (($i++)%5000 == 0) {print $i . "\n";}
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
 $csr->finish() ;
 
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
 $lda->disconnect() ;
} 




########################################################################
#
#  Extract FUND data from qualifier table of Roles DB.
#  Do it with two separate select statements for performance.  
#
########################################################################
sub ExistingExtract
{
my($lda, $data_dir) = @_;

$outfile = $data_dir . "fund.roles";
$qqualtype = 'FUND';
 
#
#   Open output file.
#
  $outf = "|cat >" . $outfile;
  if( !open(F2, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }


#
#  Open first cursor
#
 $time0 = time();
 my $stmt = "select c.parent_id, q.qualifier_id, q.qualifier_code qcode," 
          . " q.qualifier_name, q.has_child" 
          . " from qualifier q, qualifier_child c"
          . " where q.qualifier_id = c.child_id"
          . " and q.qualifier_type = '$qqualtype'"
          . " union"
          . " select -1, qualifier_id, qualifier_code qcode,"
          . " qualifier_name, has_child"
          . " from qualifier"
          . " where qualifier_level = 1 and qualifier_type = '$qqualtype'"
          . " order by  qcode";
 my $csr = $lda->prepare( $stmt)
        || die $DBI::errstr;
$csr->execute();
 %qid_to_code = ();
 print "Reading in Qualifiers (type = '$qqualtype') from Oracle table...\n";
 $i = -1;
 while ((($qparentid, $qqid, $qqcode, $qqname, $qhaschild) 
        = $csr->fetchrow_array())) 
 {
   #if (($i++)%5000 == 0) {print $i . "\n";}
   push(@parentid, $qparentid);
   push(@qualcode, $qqcode);
   push(@qualname, $qqname);
   push(@haschild, $qhaschild);
   $qid_to_code{$qqid} = $qqcode;  # Build hash mapping qual_id to qual_code.
 }
 $csr->finish() ;
 $elapsed_sec = time() - $time0;
 print "Elapsed time of first query = $elapsed_sec seconds.\n";
 
#
#  Print out file of cost collectors
#
 $time0 = time();
 print "Getting parent qualifier_codes and writing out file...\n";
 for ($i = 0; $i < @parentid; $i++) {
   #if ($i%5000 == 0) {print $i . "\n";}
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
 
}



##############################################################################
#
#  Find the differences in two files of cost collectors.
#  Process the differences to make it easier to do adds, deletes, and
#  updates to qualifier table in Roles DB.
#
##############################################################################
sub CompareExtract
{

my($data_dir) = @_;

my $file1 = $data_dir . "fund.roles";
my $file2 = $data_dir . "fund.warehouse";
my $diff_file = $data_dir . "fund.diffs";
my $tempactions = $data_dir . "fund.actions.temp";
my $actionsfile = $data_dir . "fund.actions";
my $temp1 = $data_dir . "fund1.temp";
my $temp2 = $data_dir . "fund2.temp";
 

#For Linux, sort command, this env setting will make the sorting based on ASCII instead of Dictionary.
$ENV{'LANG'}='C';
$ENV{'LC-COLLATE'}='C';

print "Sorting first file...\n";
system("sort -t '!' -k 1,2 -o $temp1 $file1\n");
print "Sorting 2nd file...\n";
system("sort -t '!' -k 1,2 -o $temp2 $file2\n");
 
 
print "Comparing files $file1 and $file2...\n";
system("diff $temp1 $temp2 |"            # Find differences in two files
       . " grep '^[><]' |"               # Select only added/deleted lines
       . " sed 's/< FUND/<\!FUND/' |"    # Add ! field marker
       . " sed 's/> FUND/>\!FUND/' |"    # Add ! field marker
       . " sort -t '!' -k 2,3 -k 1,1 |"  # Sort on type, qualcode, [<>]
       . " grep -v 'FC_'"             # Omit custom fund groups
       . " > $diff_file");
 
##############################################################################
#
#  Now read in the differences file. 
# 
#  Read '<' records from $diff_file into (@old_code, @old_parent, @old_name)
#  Read '>' records from $diff_file into (@new_code, @new_parent, @new_name)
#
##############################################################################
 unless (open(IN,$diff_file)) {
   die "Cannot open $diff_file for reading\n"
 }
 @old_code = ();
 @old_parent = ();
 @old_name = ();
 @new_code = ();
 @new_parent = ();
 @new_name = ();
 $i = 0;
 print "Reading records from differences file...\n";
 while (chop($line = <IN>)) {
   if (($i++)%1000 == 0) {print $i . "\n";}
   ($oldnew, $qualtype, $qualcode, $parentcode, $qname) = split('!', $line);
   #print "$oldnew - $qualtype - $qualcode - $parentcode - $qname\n";
   if ($oldnew eq '<') {
     push(@old_code, $qualcode);
     push(@old_parent, $parentcode);
     push(@old_name, &strip($qname));
   }
   else {
     push(@new_code, $qualcode);
     push(@new_parent, $parentcode);
     push(@new_name, &strip($qname));
   }
 }
 system("rm $temp1\n");  # Remove temporary files
 system("rm $temp2\n");  # Remove temporary files
 
#
#   Open output file.
#
  $outf = "|cat >" . $tempactions;
  if( !open(F2, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }
#
#  Now compare lines from the old and new arrays.
#  Print out "Delete", "Update", and "Add" records depending on
#  how things match up.
#
 print "Comparing lines from old and new arrays...\n";  
 $old_p = 0;  # Set pointers
 $new_p = 0;  # Set pointers   
 $old_max = @old_code;
 $new_max = @new_code;
 while (($old_p < $old_max) & ($new_p < $new_max)) {
   #print "$old_p $new_p \n";
   if ($old_code[$old_p] lt $new_code[$new_p]) {
     print F2 "DELETE!$old_code[$old_p]\n";
     $old_p++;
   }
   elsif ($old_code[$old_p] eq $new_code[$new_p]) {
     if ($old_parent[$old_p] ne $new_parent[$new_p]) {
       print F2 "UPDATE!$old_code[$old_p]!PARENT"
                . "!$old_parent[$old_p]!$new_parent[$new_p]\n";
     }
     if ($old_name[$old_p] ne $new_name[$new_p]) {
       print F2 "UPDATE!$old_code[$old_p]!NAME"
                . "!$old_name[$old_p]!$new_name[$new_p]\n";
     }
     $old_p++;
     $new_p++;
   }
   else { # $old_code gt $new_code
     print F2 "ADD!$new_code[$new_p]!$new_parent[$new_p]!$new_name[$new_p]\n";
     $new_p++;
   }
 }
 
#
#  Handle left-over lines.
#
 while ($old_p < $old_max) {
   print F2 "DELETE!$old_code[$old_p]\n";
   $old_p++;
 }
 
 while ($new_p < $new_max) {
   print F2 "ADD!$new_code[$new_p]!$new_parent[$new_p]!$new_name[$new_p]\n";
   $new_p++;
 }
 
 close (F2);



#
#   Process Fund Center Records First (reorder fund centers)
#	
#

 unless(open(INFILE, "<" . $tempactions) ) {
    die "$0: can't open ($tempactions) - $!\n";
  }
 while ( chop($line = <INFILE>)) {
	push(@actions, $line);
 }
 close INFILE;

#	@actions1 = grep {/^ADD!FC/}  @actions;
#	@actions2 = grep {!/^ADD!FC/}  @actions;
#	@actions = @actions1;
#	push(@actions, @actions2);

 sort_actions(\@actions);


 unless(open(ACTIONSFILE, ">" . $actionsfile) ) {
    die "$0: can't open ($actionsfile) - $!\n";
  }

 for ($i = 0; $i < @actions; $i++) {
   print ACTIONSFILE $actions[$i] . "\n";
 }

close ACTIONSFILE;

}

return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################
