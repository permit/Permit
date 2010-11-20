###############################################################################
## NAME: roles_pccs.pm
##
## DESCRIPTION: Subroutines related to qualifier feed for 'PCCS' qualifiers
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
## Created 07/18/2005, Jim Repa
## Modified 06/28/2007, Marina Korobko (fix character-set problem)
## Modified 07/13/2007 M.Korobko
##   --  use table roles_parameters to find MAX_ACTIONS allowed
###############################################################################

package roles_pccs;
$VERSION = 1.0; 
$package_name = 'roles_pccs';

## Standard Roles Database Feed Package
#use roles_base qw(UsageExit ScriptExit RolesLog RolesNotification ArchiveFile);
use roles_base qw(UsageExit ScriptExit RolesLog RolesNotification ArchiveFile
                    find_max_actions_value  login_dbi_sql find_max_actions_value2  ExecuteSQLCommands);
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
        $outfile = $datafile_dir . "pccs.warehouse";

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
 
#
#  Open connection to oracle.  Prepare a select statement to get 
#  profit center nodes and provit centers.
#
 my($lda) = login_dbi_sql($db_id, $user_id, $user_pw)
  	|| die $DBI::errstr;
 my $stmt = "select l1.parent_setid, l1.setid, l1.title, node_level
             from wareuser.whpc_parent_child l1
             union all select profit_center_hi, 
                     replace(profit_center_id, 'P', 'PC'), 
                     profit_center_name, '9 ' node_level
                     from wareuser.whpc_hier_values_work
             order by 4, 1, 2";
my $csr = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";

 $csr->execute();

 
#
#  Write out a made-up record for the root of the PCCS tree.
#  (Not necessary)
#
   #printf F2 "%s!%s!%s!%s\n",
   #        'PCCS', 'PCMIT-0', '', 
   #        'MIT-All (Four Levels)';

#
#  Look in the Warehouse tables whpc_parent_child and whpc_hier_values_work
#  for PCMIT nodes and Profit Centers
#
 print "Reading in PC nodes, supervisors, and COs from Warehouse table...\n";
 $i = -1;
 my ($qqparcode, $qqcode, $qqname, $node_level);
 while (($qqparcode, $qqcode, $qqname, $node_level) = $csr->fetchrow_array()) {
   printf F2 "%s!%s!%s!%s\n",
           'PCCS', $qqcode, $qqparcode, $qqname;
 }
 $csr->finish() || die "can't close cursor";
 
#
#  Run a second select statement to get CO Supervisors
#
 my $stmt2 = "select distinct replace(profit_center_id, 'P', 'PC'),
              substr(profit_center_id, 2, 6) || supervisor_mit_id, 
              upper(substr(supervisor, 1, 39) 
                 || ' (PC' || substr(profit_center_id, 2, 6) || ')')
  from wareuser.cost_collector
  where profit_center_id is not null
  and supervisor_mit_id is not null
  and supervisor is not null
  union select distinct replace(profit_center_id, 'P', 'PC'),
              substr(profit_center_id, 2, 6) || 'xxxxxxxxx', 
              'Missing supervisor MIT ID or name'
                 || ' (PC' || substr(profit_center_id, 2, 6) || ')'
  from wareuser.cost_collector
  where profit_center_id is not null
  and (supervisor_mit_id is null or supervisor is null)
  order by 1, 2";
 my $csr2 = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";

 $csr2->execute();

 my $csr2 = $lda->prepare( $stmt2)
 	|| die $DBI::errstr;
  $csr2->execute();
 ### If we find the same PC-supervisor_MITID code twice, with different
 ### spellings of the supervisor name, ignore all but the first record.
 my %found_code = ();
 while (($qqparcode, $qqcode, $qqname) = $csr2->fetchrow_array()) {
   unless ($found_code{$qqcode}) {
     printf F2 "%s!%s!%s!%s\n",
           'PCCS', $qqcode, $qqparcode, $qqname;
     $found_code{$qqcode} = 1;
   }
 }
 $csr2->finish() || die "can't close cursor";
 
#
#  Run a third select statement to get Cost Objects
#
 my $stmt3 = "select substr(profit_center_id, 2, 6) || supervisor_mit_id, 
              cost_collector_id_with_type, 
              ltrim(cost_collector_name, ' ')
  from wareuser.cost_collector
  where profit_center_id is not null
  and supervisor_mit_id is not null
  and supervisor is not null
  union select substr(profit_center_id, 2, 6) || 'xxxxxxxxx', 
              cost_collector_id_with_type, 
              ltrim(cost_collector_name, ' ')
  from wareuser.cost_collector
  where profit_center_id is not null
  and (supervisor_mit_id is null or supervisor is null)
  order by 1, 2";
 my $csr3 = $lda->prepare($stmt3)
      || die "$DBI::errstr . \n";

 $csr3->execute();

 while (($qqparcode, $qqcode, $qqname) = $csr3->fetchrow_array()) {
     printf F2 "%s!%s!%s!%s\n",
             'PCCS', $qqcode, $qqparcode, $qqname;
 }
 $csr3->finish() || die "can't close cursor";
 
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

	my($infile) = $datafile_dir . "pccs.actions";
	my($sqlfile) = $datafile_dir . "pccschange.sql";
	my($sqlfile2) = $datafile_dir . "pccsdesc.sql";
	my($qualtype) = "PCCS";

	## Step 0: Check Arguments
	if ($#_ != 2){&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
	my($user_id, $user_pw, $db_id) = @_;


	## Check number of actions to be preformed
        $MAX_ACTIONS = &find_max_actions_value2( $db_id, $user_id, $user_pw, "MAX_PCCS");
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




########################################################################
#
#  Extract PCCS data from qualifier table of Roles DB.
#
########################################################################
sub ExistingExtract
{
my($lda, $data_dir) = @_;

$outfile = $data_dir . "pccs.roles";
$qqualtype = 'PCCS';
 
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
 my $stmt = "select q2.qualifier_code, q.qualifier_id, q.qualifier_code as qcode," 
          . " q.qualifier_name, q.has_child, q.qualifier_level as qlevel" 
          . " from qualifier q, qualifier_child c, qualifier q2"
          . " where q.qualifier_id = c.child_id"
          . " and c.parent_id = q2.qualifier_id"
          . " and q.qualifier_type = '$qqualtype'"
          . " union"
          . " select '', qualifier_id, qualifier_code as qcode,"
          . " qualifier_name, has_child, qualifier_level as qlevel"
          . " from qualifier"
          . " where qualifier_level = 1 and qualifier_type = '$qqualtype'"
          . " order by qlevel,qcode";
 $csr = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";

 $csr->execute();

 print "Reading in Qualifiers (type = '$qqualtype') from Oracle table...\n";
 $i = -1;
 my ($qparentcode, $qqid, $qqcode, $qqname, $qhaschild, $qlevel);
 while ( ($qparentcode, $qqid, $qqcode, $qqname, $qhaschild, $qlevel) 
          = $csr->fetchrow_array() )
 {
   #if (($i++)%5000 == 0) {print $i . "\n";}
   ### There seems to be no reason to keep these items in arrays
   #push(@parentid, $qparentid);
   #push(@qualcode, $qqcode);
   #push(@qualname, $qqname);
   #push(@haschild, $qhaschild);
   ###
   # TYPE, CODE, PARCODE, NAME
   printf F2 "%s!%s!%s!%s\n",
           $qqualtype, $qqcode, $qparentcode, $qqname;
 }
 $csr->finish() || die "can't close cursor";
 
 close (F2);
 
}



##############################################################################
#
#  Find the differences in two files of Depts. and PIs.
#  Process the differences to make it easier to do adds, deletes, and
#  updates to qualifier table in Roles DB.
#
##############################################################################
sub CompareExtract
{

my($data_dir) = @_;

my $file1 = $data_dir . "pccs.roles";
my $file2 = $data_dir . "pccs.warehouse";
my $diff_file = $data_dir . "pccs.diffs";
my $tempactions = $data_dir . "pccs.actions.temp";
my $actionsfile = $data_dir . "pccs.actions";
my $temp1 = $data_dir . "pccs1.temp";
my $temp2 = $data_dir . "pccs2.temp";
 
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
       . " sed 's/< PCCS/<\!PCCS/' |"    # Add ! field marker
       . " sed 's/> PCCS/>\!PCCS/' |"    # Add ! field marker
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
#   Reorder PCCS actions
#

 unless(open(INFILE, "<" . $tempactions) ) {
    die "$0: can't open ($tempactions) - $!\n";
  }
 while ( chop($line = <INFILE>)) {
	push(@actions, $line);
 }
 close INFILE;

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

return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################
