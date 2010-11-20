###############################################################################
## NAME: roles_cost.pm
##
## DESCRIPTION: Subroutines related to qualifier feed for 'COST' qualifiers
##
#
#  Copyright (C) 1997-2010 Massachusetts Institute of Technology
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
## Modified 6/10/1998 to handle Project hierarchy - J. Repa
## Modified 9/15/1999 to new format of wh-profhier for SAP 4.5 - J. Repa
## Modified 7/6/2001  Profit Center name should only be 40 columns long
## Modified 7/13/2007 M.Korobko
##   --  use table roles_parameters to find MAX_ACTIONS allowed
###############################################################################

package roles_cost;
$VERSION = 1.0; 
$package_name = 'roles_cost';

## Standard Roles Database Feed Package
use roles_base qw(UsageExit login_dbi_sql ScriptExit RolesLog RolesNotification ArchiveFile
                  find_max_actions_value  find_max_actions_value2  ExecuteSQLCommands);
use roles_qual 
 qw(strip ProcessActions FixDescendents sort_actions fix_haschild);

## Set Test Mode
$TEST_MODE = 1;		## Test Mode (1 == ON, 0 == OFF)
if ($TEST_MODE) {print "TEST_MODE is ON for $package_name.pm\n";}


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

use DBI;


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



	## FTP the Data: get two files

	&FTPFromWarehouse($user_id, $user_pw, $ftp_machine, $datafile_dir);

	## Create single file of PC hierarchy, Profit Ctrs., & Cost Objects

	&CombineCostInfo($datafile_dir);

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

	my($infile) = $datafile_dir . "cost.actions";
	my($sqlfile) = $datafile_dir . "costchange.sql";
	my($sqlfile2) = $datafile_dir . "costdesc.sql";
	my($qualtype) = "COST";

	## Step 0: Check Arguments
	if ($#_ != 2){&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
	my($user_id, $user_pw, $db_id) = @_;

	## Check number of actions to be preformed
        $MAX_ACTIONS = &find_max_actions_value2($db_id,$user_id,$user_pw, "MAX_COST");
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
#  Use FTP to get PC/Cost-related files from the Warehouse
#
#############################################################################

sub FTPFromWarehouse
{

 my($user_id, $user_pw, $ftp_machine, $data_dir) = @_;

 my(@files) = ('wh-profhier', 'wh-profctr', 'wh-projhier'); # projhier 6/98
 
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
#  Read in Profit Center Hierarchy file and Profit Center file, and
#  read in Cost Objects from a Warehouse table,
#  and produce a file of qualifiers with their parents.
#
#  1. Read in profit center hierarchy table.  Reformat data so that
#     it can be compared to the COST hierarchy in the Roles DB.
#
#  The first input file (wh-profhier) has the following format:
#    cc.  1- 5 (5)  ?
#         6-11 (6)  Level
#        12-45 (34) Qualifier code for the profit center
#        46-*  (50) Qualifier name for profit center
#    After SAP 4.5, this format changes to
#    cc.  1- 5 (5)  ?
#         6-11 (6)  Level
#        12-35 (24) Qualifier code for the profit center
#        36-*  (40) Qualifier name for profit center
#  
#  2. Then read in profit center file and add profit centers to the internal
#     arrays.
#
#  2nd file (wh-profctr) has the following format:
#    cc.  0-9   (10) PC code
#        10-17  (8)  Effective date
#        18-25  (8)  Expiration date
#        26-26  (1)  Version
#        27-34  (8)  Valid do
#        35-42  (8)  Valid from
#        43-50  (8)  create date
#        51-62  (12) created by
#        63-74  (12) dept
#        75-94  (20) person in charge
#        95-106 (12) group hier
#       107-146 (40) name
#
#  3. Then, read in cost objects from warehouse table.  
#
#  4. Read in records from wh-projhier.  Find places where a WBS has
#     child WBSs.  Before this point in the script, the parent of each
#     WBS (in @parentcode) is a Profit Center.  Compare the PC associated
#     with the child WBS and parent WBS.  If they agree, then change the
#     $parentcode[$x] for the child WBS to be the parent WBS.  If they
#     don't agree, then add a new qualifier as a child of the parent
#     WBS.  Derive the new qualifier code from the parent WBS code,
#     where changing Pnnnnnnn to P_nnnnnnn.  Set the new qualifier name
#     to "Children of Pnnnnnnn in other profit centers"
# 
#  3rd file (wh-projhier) has the following format:
#    cc.  0-6   (7)  Higher-level parent project (WBS) code
#         7-23  (14) Filler
#        24-63  (40) Parent project name
#        64-70   (7) Child project (WBS) code
#        71-87  (14) Filler
#        88-127 (40) Child project name
#       128-134 (7)  Parent project (WBS) code
#       135-192 (58) Ignored
#
########################################################################

sub CombineCostInfo
{
my($data_dir) = @_;

$hierfile = $data_dir . "wh-profhier";
$pcfile = $data_dir . "wh-profctr";
$projfile = $data_dir . "wh-projhier";
$wrhs_outfile = $data_dir . "cost.warehouse";
$wrhs_xpc_child = $data_dir . "cost.w_xpc_child";  # Cross-PC WBS parent/child
$qqualtype = 'COST';

#
#  Initialize array of elements at various levels in the hierarchy.  This
#  will be used for parsing the hierarchy file.
#
for ($i = 0; $i < 9; $i++) {  # Initialize array of previous elements
  $levelcount[$i] = 0;
}

#
#   Read each line in $hierfile
#
 unless (open(IN,$hierfile)) {
   die "Cannot open $hierfile for reading\n"
 }
 $i = 0;
 @lev = ();
 @qualcode = ();
 @qualname = ();
 @parentcode = ();
 %qcode_to_idx = ();  # Hash to convert qualifier_code to array index 
 print "Reading $hierfile...\n";
 while (chop($line = <IN>)) {
   #if (($i++)%100 == 0) {print $i . "\n";}
   $junk = &strip(substr($line, 0, 5));
   $level = &strip(substr($line, 5, 6));
   $qcode = &strip(substr($line, 11,34));
   if ($qcode =~ /^0HP/) {  # Pre-SAP-release 4.5
     $qcode =~ s/P/PC/;  # Change profit center prefix
     $qname = &strip(substr($line,45));
   }
   else {  # Post-SAP-release 4.5
     $qcode = &strip(substr($line, 11,24));
     $qcode =~ s/P/0HPC/;  # Change profit center prefix
     $qname = &strip(substr($line,35));
   }
   push(@lev, &strip($level));
   push(@qualcode, $qcode);
   push(@qualname, $qname);
   $qcode_to_idx{$qcode} = @qualcode - 1;
 }
 close(IN);

#
#  Run through each line of $hierfile.  Do the following:
#   If qualname is the same as previous qualname then
#       append '(A)' to previous qualname
#       append '(B)' to current qualname
#   If level > 0, build a parent/child record.
#
 $n = @lev;  # How many elements?
 for ($i = 0; $i < $n; $i++) {
   ($levelcount[$lev[$i]])++;  # Count the no. of elements at each level
   for ($j = $lev[$i]+1; $j < 9; $j++) {   # Reset lower level counters
     $levelcount[$j] = 0;
   }
   $lastidx[$lev[$i]] = $i;  # Save this number, last idx. no. at this level
   $newqname[$i] = $qualname[$i];
   if ($qualname[$i] eq $qualname[$i-1]) {
     $qualname[$i-1] = $qualname[$i-1] . ' (A)';
     $qualname[$i] = $qualname[$i] . ' (B)';
   }
   if ($lev[$i] != 0) {
     $parentcode[$i] = $qualcode[$lastidx[$lev[$i]-1]];
   }
 }

#
#  Read in the file of profit centers
#
 unless (open(IN,$pcfile)) {
   die "Cannot open $pcfile for reading\n"
 }
 $i = -1;
 print "Reading $pcfile...\n";
 while (chop($line = <IN>)) {
   #if (($i++)%100 == 0) {print $i . "\n";}
   $qcode = &strip(substr($line, 0, 10));
   $qcode =~ s/P/PC/;  # Change profit center prefix
   $qname = &strip(substr($line,107,40));
   $qpar = '0H' . &strip(substr($line,95,12));
   $qpar =~ s/P/PC/;  # Change profit center prefix
   $qparidx = $qcode_to_idx{$qpar};   # Find index of parent
   $qlevel = $lev[$qparidx] + 1;      # Set the level based on parent's level
   push(@lev, $qlevel);
   push(@qualcode, &strip($qcode));
   push(@qualname, &strip($qname));
   push(@parentcode, $qpar);
   $qcode_to_idx{$qcode} = @qualcode - 1;
 }
 close(IN);
 

#
#   Open output files.
#
  $outf = ">" . $wrhs_outfile;   # Standard COST hierarchy
  if( !open(F2, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }
  $outf2 = ">" . $wrhs_xpc_child;  # Parent/child pairs for cross-PC WBSs
  if( !open(F3, $outf2) ) {
    die "$0: can't open ($outf2) - $!\n";
  }

#
#  Get username and password for Warehouse database connection.
#
	use config('GetValue');
        $db_parm = GetValue("warehouse");
  	$db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
	$userpw  = $1 . "/" . $2;
	$db  = $3;

#
#  Open a connection to the warehouse table
#

 my $lda = &login_dbi_sql($db, $userpw, '')
        || die $DBI::errstr;

#
#  Open cursor for warehouse table
#
 my $stmt = "select cost_collector_id_with_type,"
          . " cost_collector_name,"
          . " profit_center_id"
          . " from wareuser.cost_collector"
          . " order by cost_collector_id_with_type";
 my $csr = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";

 $csr->execute();

 
#
#  Read in rows from the cost_collector table
#
 @wparentcode = ();
 @wparentpc = ();  # Added 1/15/2001
 @wqualcode = ();
 @wqualname = ();
 print "Reading in cost collectors from Warehouse table...\n";
 my $i = -1;
 while (($qqcode, $qqname, $qqparent) = $csr->fetchrow_array()) {
   #if (($i++)%5000 == 0) {print $i . "\n";}
   $qqparent =~ s/P/PC/;   # Change Profit Center Prefix to PC.
   push(@wparentcode, &strip($qqparent));
   push(@wparentpc, &strip($qqparent));  # Added 1/15/2001
   push(@wqualcode, &strip($qqcode));
   push(@wqualname, &strip($qqname));
   $wqcode_to_idx{$qqcode} = @wqualcode - 1;
 }
 $csr->finish() || die "can't close cursor"; # Close cursor
  
 $lda->disconnect() || die "can't log off Oracle"; # Cl. Warehouse connection

#
#  Read in the project hierarchy file
#
 unless (open(IN,$projfile)) {
   die "Cannot open $projfile for reading\n"
 }
 $i = -1;
 print "Reading $projfile...\n";
 %proj_parent_of = ();  # Build a hash of WBS parents of each WBS
 while (chop($line = <IN>)) {
   #if (($i++)%100 == 0) {print $i . "\n";}
   #$qpar = 'P' . &strip(substr($line, 0, 7));
   $qpar = 'P' . &strip(substr($line, 128, 7));  # Changed 1/15/2001
   $qcode = 'P' . &strip(substr($line, 64, 7));
   if (($qpar ne 'P') && ($qpar ne $qcode)) {  # Changed 1/15/2001
     $proj_parent_of{$qcode} = $qpar;
   }
 }
 close(IN);

#
#  Now, run through each WBS parent/child pair.
#  Find the profit center associated with the parent and with the child.
#  If they are the same, then change the parent of the child from the 
#    profit center to the parent WBS
#  If they are different then add a child P_nnnnnnn to the parent WBS,
#    that will later be used to point to WBSs from other profit centers,
#    and also write a record to the cross-PC-parent/child file.
#
 %has_diff_pc_child = ();   # Keep track of WBSs with a P_nnnnnnn child
 foreach $qcode (keys %proj_parent_of) { 
   $qpar = $proj_parent_of{$qcode};       # Get WBS parent of qcode
   $qcode_idx = $wqcode_to_idx{$qcode};   # Get matching index no. of child
   if ($qcode_idx eq '') {                # If we can't find it...
     $qcode_pc = '';                      # ...set PC of child to null.
   }
   else {
     #$qcode_pc = $wparentcode[$qcode_idx];  # Get PC of child WBS
     $qcode_pc = $wparentpc[$qcode_idx]; # Get PC of child WBS (changed 1/15)
   }
   $qpar_idx = $wqcode_to_idx{$qpar};     # Get matching index no. of parent
   if ($qpar_idx eq '') {                 # If we can't find it...  
     $qpar_pc = '';                       # ...set PC of parent to null.
   }
   else {
     #$qpar_pc = $wparentcode[$qpar_idx];  # Get PC of parent WBS
     $qpar_pc = $wparentpc[$qpar_idx]; # Get PC of parent WBS (changed 1/15/01)
   }
   if ($qcode_pc eq '') {
     print "Error.  WBS '$qcode' found as child in wh-projhier",
           " but not in cost_collector table\n";
   }
   elsif ($qpar_pc eq '') {
     print "Error.  WBS '$qpar' found as parent in wh-projhier",
           " but not in cost_collector table\n";
   }
   elsif ($qcode_pc eq $qpar_pc) { # Parent and child have same PC
     $wparentcode[$qcode_idx] = $qpar;  # Make par. of child WBS the par. WBS 
   }
   else {   # parent profit center different than child profit center
     $new_qc = $qpar;
     $new_qc =~ s/P/P\_/;
     $new_name = "Children of $qpar in other profit centers";
     if ($has_diff_pc_child{$qpar} ne 'Y') {  # New P_nnnnnnn record
       push(@wqualcode,$new_qc);
       push(@wparentcode,$qpar);
       push(@wqualname,$new_name); 
       $has_diff_pc_child{$qpar} = 'Y';
     }
     print F3 "$qcode!$new_qc\n";  # Write to cost.w_xpc_child file
   }
 } 

#
#  Add the Cost Object data to the existing arrays.
#
 push(@qualcode, @wqualcode);
 push(@parentcode, @wparentcode);
 push(@qualname, @wqualname);


#
#  Print out qualifiers 
#
 print "Writing out file...\n";
 for ($i = 0; $i < @parentcode; $i++) {
   #if ($i%5000 == 0) {print $i . "\n";}
   #print "qparentid = $qparentid qparentcode = $qparentcode\n";
   # TYPE, CODE, PARCODE, NAME
   if ($parentcode[$i] ne '') {
     printf F2 "%s!%s!%s!%s\n",
             $qqualtype, $qualcode[$i],
             $parentcode[$i], $qualname[$i];
   }
   else {
     if ($qualcode[$i] != '0HP00_MIT' && $qualcode[$i] != 'I') {
       print "Error.  Null parent for '$qualcode[$i]' '$qualname[$i]'\n";
     }
   }
 }
 
 close (F2);
 close (F3);
} 

###########################################################################
#
#  Function &is_sloan_co($qcode)
#  Returns 1 if the qualifier code is part of the Sloan School,
#          0 if not.
#
###########################################################################
sub is_sloan_co {
  my $qcode = $_[0];
  my $idx = $wqcode_to_idx{$qcode};   # Find index of this qcode
  my $parent_qualcode = $wparentcode[$idx];  # Find parent code
  my $result;
  #
  #  Follow the chain of parents until we find $sloan_branch qualifier_code
  #  or ''.
  #
  while (($parent_qualcode ne '') && ($parent_qualcode ne $sloan_branch)) {
    $idx = $qcode_to_idx{$parent_qualcode};
    $parent_qualcode = $parentcode[$idx];
  }
  if ($parent_qualcode eq $sloan_branch) {
    $result = 1;
  }
  else {
    $result = 0;
  }
  $result;
}

########################################################################
#
#  Extract COST data from qualifier table of Roles DB.
#  Do it with two separate select statements for performance.  
#  Write the "standard hierarchy" stuff to cost.roles.
#  Write parent/child pairs of WBSs, where the parent and child 
#  belong to different Profit Centers, to the file cost.r_xpc_child.
#  
#
#    Note, this is the similar as ExistingExtract in roles_fund.pm
#    except for substituting s/fund/cost/ and a few other subtle
#    differences.
########################################################################
sub ExistingExtract
{
my($lda, $data_dir) = @_;


$outfile = $data_dir . "cost.roles";
$xpcfile = $data_dir . "cost.r_xpc_child";
$qqualtype = 'COST';
 
#
#   Open output file.
#
  $outf = ">" . $outfile;
  if( !open(F2, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }
  $outf2 = ">" . $xpcfile;
  if( !open(F3, $outf2) ) {
    die "$0: can't open ($outf2) - $!\n";
  }


#
#  Open first cursor
#
 $time0 = time();
 my $stmt = "select  c.parent_id, q.qualifier_id, q.qualifier_code qcode," 
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
$csr = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";

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
 $csr->finish() || die "can't close cursor";
 $elapsed_sec = time() - $time0;
 print "Elapsed time of first query = $elapsed_sec seconds.\n";
 
#
#  Print out file of cost collectors
#
 $time0 = time();
 print "Getting parent qualifier_codes and writing out file...\n";
 for ($i = 0; $i < @parentid; $i++) {
   #if ($i%5000 == 0) {print $i . "\n";}
   $qparentid = $parentid[$i];
   $qparentcode = $qid_to_code{$qparentid};
   #print "qparentid = $qparentid qparentcode = $qparentcode\n";
   #### Skip the root, plus project hierarchy additions
   if ( ($qualcode[$i] ne '0HPC00_MIT')       # Skip the root
#        && (!($qualcode[$i] =~ /^P_/))        # Ignore P_nnnnnnn qualifiers
        && (!($qparentcode =~ /^P_/)) ) {    # Ignore P_nnnnnnn parents
   # TYPE, CODE, PARCODE, NAME
     printf F2 "%s!%s!%s!%s\n", # Write to cost.roles	
             $qqualtype, $qualcode[$i], $qparentcode, $qualname[$i];
   }
   elsif ($qparentcode =~ /^P_/)  {    # Look for children of P_nnnnnnn
     printf F3 "%s!%s\n",  # Write to cost.r_xpc_child
             $qualcode[$i], $qparentcode;
   }
 }
 $elapsed_sec = time() - $time0;
 print "Elapsed time of 2nd stage = $elapsed_sec seconds.\n";
 
 close (F2);
 close (F3);
 
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

my $file1 = $data_dir . "cost.roles";
my $file2 = $data_dir . "cost.warehouse";
my $diff_file = $data_dir . "cost.diffs";
my $tempactions = $data_dir . "cost.actions.temp";
my $actionsfile = $data_dir . "cost.actions";
my $temp1 = $data_dir . "cost1.temp";
my $temp2 = $data_dir . "cost2.temp";

#For Linux, sort command, this env setting will make the sorting based on ASCII instead of Dictionary.
$ENV{'LANG'}='C';
$ENV{'LC-COLLATE'}='C';

my $logfile = $data_dir . "cost.log";

print "data_dir = '$data_dir'\n";
print "file1='$file1' file2='$file2'\n";
print "diff_file='$diff_file' temp1='$temp1' temp2='$temp2'\n";
print "Sorting first file...\n";
system("sort -t '!' -k 1,2 -o $temp1 $file1\n");
print "Sorting 2nd file...\n";
system("sort -t '!' -k 1,2 -o $temp2 $file2\n");
 
 
print "Comparing files $file1 and $file2...\n";
system("diff $temp1 $temp2 |"            # Find differences in two files
       . " grep '^[><]' |"               # Select only added/deleted lines
       . " sed 's/< COST/<\!COST/' |"    # Add ! field marker
       . " sed 's/> COST/>\!COST/' |"    # Add ! field marker
       . " sort -t '!' -k 2,3 -k 1,1"    # Sort on type, qualcode, [<>]
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
  $logf = ">" . $logfile;
  if( !open(F4, $logf) ) {
    die "$0: can't open ($logf) - $!\n";
  }

  $outf = ">" . $tempactions;
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
	#if ($old_p > 50000 || $new_p > 50000)
	#{
		print F4 "OLD - '$old_p $old_code[$old_p]' NEW -  '$new_p $new_code[$new_p]' \n";
	#}
   if ($old_code[$old_p] lt $new_code[$new_p]) {
     print F2 "DELETE!$old_code[$old_p]\n";
	print F4 "DELETE \n";
     $old_p++;
   }
   elsif ($old_code[$old_p] eq $new_code[$new_p]) {
     if ($old_parent[$old_p] ne $new_parent[$new_p]) {
       print F2 "UPDATE!$old_code[$old_p]!PARENT"
                . "!$old_parent[$old_p]!$new_parent[$new_p]\n";
	print F4 "UPDATE PARENT \n";
     }
     if ($old_name[$old_p] ne $new_name[$new_p]) {
       if ($new_name[$new_p] ne '') {
          print F2 "UPDATE!$old_code[$old_p]!NAME"
                 . "!$old_name[$old_p]!$new_name[$new_p]\n";
	print F4 "UPDATE NEW \n";
       }
     }
     $old_p++;
     $new_p++;
   }
   else { # $old_code gt $new_code
     print F2 "ADD!$new_code[$new_p]!$new_parent[$new_p]!$new_name[$new_p]\n";
	print F4 "ADD  \n";
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

#
# Now handle the special parent/child pairs for WBSs, specifically where
# a WBS is a child of another WBS and the child WBS has a different Profit
# Center than the parent WBS.
#
 &CompareCrossPCProj($data_dir);
 
 close (F2);
 close (F4);

#
#   Reorder lines to put ADDs for hierarchical stuff and Profit Centers first,
#   followed by ADDs for [CIP]nnnnnXX, 
#   followed by everything else.
#	

 unless(open(INFILE, "<" . $tempactions) ) {
   die "$0: can't open ($tempactions) - $!\n";
 }
 while ( chop($line = <INFILE>)) {
   push(@actions, $line);
 }

 close INFILE;


# @actions1 = grep {/^ADD!(0H|PC)/}  @actions;  # Put ADDs for 0H.., PC.. first
# @actions2 = grep {!/^ADD!(0H|PC)/}  @actions; 
# @actions2a = grep {/^ADD![CIP][0-9]{5}XX/} @actions2; # Then ADD [CIP]nnnnnXX
# @actions2b = grep {!/^ADD![CIP][0-9]{5}XX/} @actions2; # Everything else
	
# @actions = @actions1;
# push(@actions, @actions2a);
# push(@actions, @actions2b);

### The sort_actions step can be very time-consuming, running for many
### hours if there are too many actions in one day.  If there are more
### than 20000 actions, we skip this step.  We may end up with some
### rejected transactions, as inserts of parent objects must occur
### before inserts of their child objects.  However, at least the job
### will run, and things should get fixed during the next execution
### of the data feed program where presumably the number of actions
### will be below the threshhold.
 my $n = @actions;
 if ($n < 20000) {
   sort_actions(\@actions);
 }

 unless(open(ACTIONSFILE, ">" . $actionsfile) ) {
    die "$0: can't open ($actionsfile) - $!\n";
  }

 for ($i = 0; $i < @actions; $i++) {
   print ACTIONSFILE $actions[$i] . "\n";
 }

 close ACTIONSFILE;

}

##############################################################################
#
#  Subroutine CompareCrossPCProj
#  Compare cost.w_xpc_child and cost.r_xpc_child.  Generate ADDCHILD
#  and DELCHILD records for Actions file to update the qualifier_child
#  records for WBSs that are children of P_nnnnnnn qualifiers.  (That is,
#  WBSs that are children of another WBS where the child WBS and parent
#  WBS are in different Profit Centers.)
#
##############################################################################
sub CompareCrossPCProj
{
 my($data_dir) = @_;
 my $wrhs_xpc_child = $data_dir . "cost.w_xpc_child";  # Cross-PC WBS pairs
 my $xpcfile = $data_dir . "cost.r_xpc_child";
 my ($line);
 
 #
 #  Read in the Warehouse cross-PC WBS parent/child pairs
 #
  unless (open(IN,$wrhs_xpc_child)) {
    die "Cannot open $wrhs_xpc_child for reading\n"
  }
  print "Reading $wrhs_xpc_child...\n";
  my @newpc = ();
  while (chop($line = <IN>)) {
    push(@newpc, $line);
  }
  close(IN);

 #
 #  Read in the Roles cross-PC WBS parent/child pairs
 #
  unless (open(IN,$xpcfile)) {
    die "Cannot open $xpcfile for reading\n"
  }
  print "Reading $xpcfile\n";
  my @oldpc = ();
  while (chop($line = <IN>)) {
    push(@oldpc, $line);
  }
  close(IN);
 
 #
 #  Find differences between @oldpc (Roles) and @newpc (Warehouse)
 #
  print "Comparing Roles and Warehouse cross-Profit-Center WBS parent/child"
        . " pairs...\n";
  my @old_not_new = ();  # Find pairs in Roles but not Warehouse
  my @new_not_old = ();  # Find pairs in Warehouse but not Roles
  my %mark1 = ();  # Use for a hash of counts of each array element
  grep($mark1{$_}++, @newpc);  # Each item -> mark 
  @old_not_new = grep(!$mark1{$_},@oldpc); # Items in Roles, not Warehouse
  %mark1 = ();     # Clear the hash to use it again.
  grep($mark1{$_}++, @oldpc);  # Each item -> mark
  @new_not_old = grep(!$mark1{$_},@newpc);   # Items in Warehouse, not Roles
  print "Cross-PC WBSs: no. of qualifier_child records to be deleted = " 
        . @old_not_new . "\n";
  print "Cross-PC WBSs: no. of qualifier_child records to be inserted = "
        . @new_not_old . "\n";
  
 #
 #  Generate ADDCHILD records.
 #
  for ($i = 0; $i < @new_not_old; $i++) {
   print F2 "ADDCHILD!$new_not_old[$i]\n";
  }   

 #
 #  Generate DELCHILD records.
 #
  for ($i = 0; $i < @old_not_new; $i++) {
   print F2 "DELCHILD!$old_not_new[$i]\n";
  }   

}

return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################
