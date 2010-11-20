###############################################################################
## NAME: roles_mdeptdesc.pm
##
## DESCRIPTION: Subroutines related to the table 
##                    mdept$owner.dept_descendent
##
#
#  Copyright (C) 2005-2010 Massachusetts Institute of Technology
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
## Created 12/15/2005, Jim Repa
## Modified 1/10/2006, Jim Repa:  Correct some comments.
###############################################################################

package roles_mdeptdesc;
$VERSION = 1.0; 
$package_name = 'roles_mdeptdesc';

## Standard Roles Database Feed Package
use roles_base qw(UsageExit ScriptExit RolesLog RolesNotification ArchiveFile login_dbi_sql find_max_actions_value2  ExecuteSQLCommands);
use roles_qual 
  qw(strip);

## Set Test Mode
$TEST_MODE = 1;		## Test Mode (1 == ON, 0 == OFF)
if ($TEST_MODE) {print "TEST_MODE is ON for $package_name.pm\n";}


## Initialize Constants 
$datafile_dir = $ENV{'ROLES_HOMEDIR'} . "/data/";
$archive_dir = $ENV{'ROLES_HOMEDIR'} . "/archive/";

$extract_filename = $datafile_dir . $package_name . "_extract.dat";
$existing_filename = $datafile_dir . $package_name . "_existing.dat";

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
        $outfile = $datafile_dir . "mdeptdesc.warehouse";

	if ($TEST_MODE) {print "In $package_name:FeedExtract.\n";}

	shift; #Get rid of calling package name

	## Step 0: Check Arguments
	if ($#_ != 2) {&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
	my($user_id, $user_pw, $db_id) = @_;

#
#   Open output file.
#
  $outf = ">" . $outfile;
  if( !open(F2, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }

#
#  Make sure we are set up to use Oraperl.
#

##
#  1. First, get a list of view_type_code's with corresponding root_dept_id's
#     from the view_type table.
#  2. Next get a hash of all parent_child pairs, per view_type_code, from
#     the table department_child.  Build the hash
#     %g_parent2child_id 
#     setting $g_parent2child_id{"$view_type_code!$parent_id"}
#              = "$child_id0!$child_id1!...";
#  3. For each view_type_code, call a recursive subroutine starting at
#     the root_dept_id, and find all descendents 
#     for a given node.  Then, for each
#     descendent, print out a record "$view_type_code!$parent_id!$child_id".
##

#
#  Open connection to oracle.  Prepare a select statement to get a list
#  of view_type_code's and their corresponding root_dept_id's.
#
 my($lda) = &login_dbi_sql($db_id, $user_id, $user_pw)
  	|| die $DBI::errstr;
 my $stmt0 = "select view_type_code, root_dept_id 
              from view_type 
              order by view_type_code";
 my $csr0 = $lda->prepare($stmt0)
      || die "$DBI::errstr . \n";

 $csr0->execute();

#
#  Read in list of view_type_code's and their corresponding root_dept_id.
#  Build hash %view_type2root_id
#  Set $view_type2root_id{$view_type_code} = $root_dept_id
#
 print "Reading in list of view_types...\n";
 my %view_type2root_id = ();
 $g_delim = "!";
 my ($view_type_code, $root_dept_id);
 while ( ($view_type_code, $root_dept_id) = $csr0->fetchrow_array()) {
    $view_type2root_id{$view_type_code} = $root_dept_id;
    #print "$view_type_code -> $view_type2root_id{$view_type_code}\n";
 }
 $csr0->finish() || die "can't close cursor";

#
#  Define a SELECT statement to get parent/child pairs for each
#  view_type_code.
#
 my $stmt1 = 
   "select distinct vtst.view_type_code, dc.parent_id, dc.child_id
     from view_type_to_subtype vtst, department_child dc
     where dc.view_subtype_id = vtst.view_subtype_id
     order by vtst.view_type_code, dc.parent_id, dc.child_id";

#
#  Run the SELECT statement, and populate the hash %g_parent2child_id 
#     setting $g_parent2child_id{"$view_type_code!$parent_id"}
#              = "$child_id0!$child_id1!...";

 my $csr1 = $lda->prepare($stmt1)
      || die "$DBI::errstr . \n";

 $csr1->execute();

 my ($parent_id, $child_id);
 $g_parent2child = ();
 while ( ($view_type_code, $parent_id, $child_id) = $csr1->fetchrow_array()) {
     my $key = "$view_type_code$g_delim$parent_id";
     if ($g_parent2child_id{$key}) {
	 $g_parent2child_id{$key} .= "$g_delim$child_id";
     }
     else {
	 $g_parent2child_id{$key} = $child_id;
     }
     #print "$key -> $g_parent2child_id{$key} \n";
 }
 $csr1->finish() || die "can't close cursor";

#
#  Now, call a recursive subroutine to print out records for all of the
#  child/descendent pairs.
#
 my $all_objects, $dlc_id;
 foreach $view_type_code (sort keys %view_type2root_id) {
   my $root_id = $view_type2root_id{$view_type_code};
   print "view_type_code = '$view_type_code' -> '$root_id'\n";
   $all_objects = gendesc($view_type_code, $root_id, 0);
   #print "all_objects='$all_objects'\n";
   foreach $dlc_id (sort split($g_delim, $all_objects)) {
     #print "print $view_type_code : $root_id -> $dlc_id\n";
     #print F2 "0 $view_type_code : $root_id -> $dlc_id\n";
     printf F2 "%s!%s!%s!%s\n",
       'MDEPTDESC', $view_type_code, $root_id, $dlc_id;
   }
 } 
 
 close (F2);
 
 $lda->disconnect() || die "can't log off Oracle";

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

	my($infile) = $datafile_dir . "mdeptdesc.actions";
	my($sqlfile) = $datafile_dir . "mdeptdescchange.sql";

	## Step 0: Check Arguments
	if ($#_ != 2){&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
	my($user_id, $user_pw, $db_id) = @_;


	## Check number of actions to be preformed

       $MAX_ACTIONS = &find_max_actions_value2( $db_id, $user_id, $user_pw, "MAX_MDEPTDESC");

	#$MAX_ACTIONS = 5000;  #This should be configurable
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
	my($destination_lda) = login_dbi_sql($db_id, $user_id, $user_pw)
			|| (
			&RolesLog("FATAL_MSG",
				"Unable to log into destination database $DBI::errstr") &&
			ScriptExit("Unable to Log into Destination Database: $db_id.")		);

	## Step 2: Update, Insert and Delete Records

	if (-r $infile) {&ProcessMDEPTActions($destination_lda, $infile, $sqlfile);}

        # Run the first .sql file
	ExecuteSQLCommands($sqlfile,$destination_lda);
        #print "user='$user_id pw='$user_pw' db='$db_id'\n";
	#my($cmd) = "sqlplus $user_id/$user_pw\@$db_id \@$sqlfile";
        #$cmd =~ s/\$/\\\$/g;  # Fix problem with '$' in name with escape char

	#$rc = system($cmd);
	#$rc >>= 8;
	#unless ($rc == 0) {
        #  print "Error return code $rc from first sqlplus\n";
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




########################################################################
#
#  Extract data from the table mdept$owner.dept_descendent
#
########################################################################
sub ExistingExtract
{
my($lda, $data_dir) = @_;

$outfile = $data_dir . "mdeptdesc.roles";
 
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
 my $stmt = "select view_type_code, parent_id, child_id
               from dept_descendent
               order by view_type_code,parent_id,child_id";
 $csr = $lda->prepare($stmt)
        || die $DBI::errstr;
 $csr->execute()
        || die $DBI::errstr;

 print "Reading in existing records from dept_descendent table...\n";
 $i = -1;
 my $type_constant = 'MDEPTDESC';
 my ($view_type_code, $parent_id, $child_id);
 while ( ($view_type_code, $parent_id, $child_id) = $csr->fetchrow_array() )
 {
   #if (($i++)%5000 == 0) {print $i . "\n";}
   # CONSTANT, dept_id, obj_type_code, obj_code
   printf F2 "%s!%s!%s!%s\n",
      $type_constant, $view_type_code, $parent_id, $child_id;
 }
 $csr->finish() || die "can't close cursor";
 
 close (F2);
 
}



##############################################################################
#
#  Find the differences in two files of department ancestors/descendents.
#  Process the differences to make it easier to do adds, deletes, and
#  updates to DEPT_DESCENDENT table within the Master Dept. Hierarchy.
#
##############################################################################
sub CompareExtract
{

my($data_dir) = @_;

my $file1 = $data_dir . "mdeptdesc.roles";
my $file2 = $data_dir . "mdeptdesc.warehouse";
my $diff_file = $data_dir . "mdeptdesc.diffs";
my $tempactions = $data_dir . "mdeptdesc.actions.temp";
my $actionsfile = $data_dir . "mdeptdesc.actions";
my $temp1 = $data_dir . "mdeptdesc1.temp";
my $temp2 = $data_dir . "mdeptdesc2.temp";
 
#For Linux, sort command, this env setting will make the sorting based on ASCII instead of Dictionary.
$ENV{'LANG'}='C';
$ENV{'LC-COLLATE'}='C';

print "Sorting first file...  File1: $file1 Temp1: $temp1\n";
system("sort -t '!' -o $temp1 $file1\n");
print "Sorting 2nd file...  File2: $file2 Temp2: $temp2\n";
system("sort -u -t '!'  -o $temp2 $file2\n");
 
 
print "Comparing files $temp1 and $temp2...\n";
system("diff $temp1 $temp2 |"            # Find differences in two files
       . " grep '^[><]' |"               # Select only added/deleted lines
       . " sed 's/< MDEPTDESC/<\!MDEPTDESC/' |"    # Add ! field marker
       . " sed 's/> MDEPTDESC/>\!MDEPTDESC/' |"    # Add ! field marker
       . " sort -t '!' -k 2,3 -k 1,1"    # Sort on type, qualcode, [<>]
       . " > $diff_file");
 system("rm $temp1\n");  # Remove temporary files
 system("rm $temp2\n");  # Remove temporary files
 
##############################################################################
#
#  Now read in the differences file. Write out ADD and DELETE records.
#
##############################################################################
 unless (open(IN,$diff_file)) {
   die "Cannot open $diff_file for reading\n"
 }

#
#  Open output (ACTIONS) file
#
 unless(open(ACTIONSFILE, ">" . $actionsfile) ) {
    die "$0: can't open ($actionsfile) - $!\n";
  }

#
#  Read through the differences file
#
 my ($junk, $dept_id, $obj_type, $obj_code);
 my $i = 0;
 print "Reading records from differences file...\n";
 while (chop($line = <IN>)) {
   if (($i++)%1000 == 0) {print $i . "\n";}
   ($oldnew, $junk, $view_type_code, $parent_id, $child_id) = split('!', $line);
   #print "$oldnew - $junk - $view_type_code - $parent_id - $child_id\n";
   if ($oldnew eq '<') {
     print ACTIONSFILE "DELETE!$view_type_code!$parent_id!$child_id\n";
   }
   else {
     print ACTIONSFILE "ADD!$view_type_code!$parent_id!$child_id\n";
   }
 }
 
close ACTIONSFILE;

}

###############################################################################
sub ProcessMDEPTActions
###############################################################################
{ 

 my($lda, $infile, $sqlfile) = @_;

if (not $lda)      ## If we logged in ok
{	
 &RolesLog("FATAL_MSG",
	"Not Logged into source database");
}
 
#
#   Open output files.
#
  $outf3 = ">" . $sqlfile;
  if( !open(F3, $outf3) ) {
    die "$0: can't open ($outf3) - $!\n";
  }
  chop($today = `date`);
 # print F3 "/* Updates generated " . $today . " */\n";
#  print F3 "set define off;\n";
#  print F3 "whenever sqlerror exit -1 rollback;\n";  # Halt on errors.
 
#
#  Read the input file.  
#  Look for ADD and DELETE records.
#  Write SQL statements (INSERT and DELETE) to $sqlfile.
#  
 unless (open(IN,$infile)) {
   die "Cannot open $infile for reading\n"
 }
 my $i = 0;
 my ($action, $view_type_code, $parent_id, $child_id);
 printf "Reading in the file $infile...\n";
 while ( (chop($line = <IN>)) && ($i++ < 999999) ) {
   #print "$i $line\n";
   ($action, $view_type_code, $parent_id, $child_id) 
     = split("!", $line);   # Split into 4 fields (for ADD records)
   if ($action eq 'ADD') {
      print F3 
       "insert into dept_descendent (VIEW_TYPE_CODE, PARENT_ID, CHILD_ID) values  ('$view_type_code', '$parent_id', '$child_id');\n";
   }
   elsif ($action eq 'DELETE') {
      print F3 
       "delete from dept_descendent where view_type_code = '$view_type_code' and parent_id = '$parent_id'  and child_id = '$child_id';\n";
   }
 }

# print F3 "commit;\n";  # If no errors, commit work.
# print F3 "quit;\n";    # Exit from SQLPLUS

 close(IN);
 close(F3);
 
}  ## End of Process MDEPTDESC Actions

########################################################################
#
#  Recursive function
#     gendesc($view_type_code, $parent_id, $level).  
#  It finds children of $parent_id, and recursively calls itself for
#  each $child_id.  It prints a record for each $parent_id/$descendent_id
#  pair found and returns a delimited string of all descendents so that 
#  the calling routine can do the same.
#
###########################################################################
sub gendesc {
  my ($view_type_code, $parent_id, $level) = @_;
  my(@child_list);   # Local array of children for a node.
  my $child_string;  # delimited string of children
  #print "In gendesc $level view_type_code='$view_type_code' parent_id='$parent_id'\n";
  $level++;

  ## Sanity check to avoid an infinite loop.
  if ($level > 15) {exit();}

  @child_list = split($g_delim, 
                    $g_parent2child_id{"$view_type_code$g_delim$parent_id"});
  #print "$view_type_code$g_delim$parent_id -> " . $g_parent2child_id{"$view_type_code$g_delim$parent_id"} . "\n";
  my ($child_id, $grandchild_id);
  foreach $child_id (sort @child_list) {
    #print "Noprint $level $view_type_code : $parent_id -> $child_id\n"; 
    if ($child_string) {
      $child_string .= "$g_delim$child_id";
    }
    else {
      $child_string = "$child_id";
    }
    my $grandchild_string = gendesc($view_type_code, $child_id, $level);
    foreach $grandchild_id (split($g_delim, $grandchild_string)) {
      #print "print $level $view_type_code : $parent_id -> $grandchild_id\n";
      #print F2 "$level $view_type_code : $child_id -> $grandchild_id\n";
      printf F2 "%s!%s!%s!%s\n",
        'MDEPTDESC', $view_type_code, $child_id, $grandchild_id;
    }
    if ($grandchild_string) {
       $child_string .= "$g_delim$grandchild_string";
    }
  }

  #print "$level $parent_id returning $child_string\n";
  return $child_string;
 
 }  

return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################
