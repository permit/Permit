###############################################################################
## NAME: roles_person.pm
##
## DESCRIPTION: 
## This module contains the 'roles_person' package which defines the
## routines to update the 'rdb_t_person' table in the Roles Database.
## It utilizes some come routines in the 'roles_base.pm' module
## and is callable via the 'roles_feed.pl' script.
##
## ENHANCEMENT TODO LIST:
## REQUIRED:
## - Make consistant use of script exit.
## - Improve status check: report on most recent changes
##
## OPTIONAL
## - Consider puting a distinct modifer on warehouse extract... accounts
## 	often inserts a second record rather than updating an existing one.
## - Separate Out generic database oraperl code into separate package
## - Separate generic diff logic into roles_base.pm
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
##
## 10/31/1997 Jonathan Ives. -Created.
## 11/13/1997 JIVES. -Modified:
## - Implemented: ExistingExtract, CompareExtract, InsertRecords, PurgeRecords
## 12/15/1997 JIVES. -Modified:
## - Moved Processing logic into this package (formally in base package)
## 1/14/1998  JIVES. -Modified:
## - Split loading functionality into two steps (prepare/load)
## 1/23/1998  JIVES. -Modified:
## -Added logic to handle delete records with authorizations that re-appear
## -Debuged Deletion Problems
## 2/10/1998 JIVES	-Added ability to incorporate test accounts
##			-Now using the wareuser.krb_person view
## 2/23/1998 JIVES	-Added CheckStatus Routine
## 3/26/1998 REPA       -Added "sanity check" for > 1000 changes in a day
## 4/06/1998 JIVES      -Removed typo in "sanity check" which was initializing
##				filename rather than line counting variables 
## 7/1/1998  REPA       -Fixed another problem in "sanity check"
## 1/14/2000 REPA       -Changed DELETE SQL statement to speed it up
## 06/23/2003 REPA      -Delete old DELETE, UPDATE, and INSERT files
## 06/13/2007 M.Korobko
##   --  use table roles_parameters to find MAX_ACTIONS allowed
## 02/12/2008 REPA      -Circumvent WH KRB_PERSON problem with TYPE field
## 03/06/2008 REPA      -Truncate last-names > 30 characters
###############################################################################

package roles_person;
$VERSION = 1.0; 
$package_name = 'roles_person';

## Standard Roles Database Feed Package
use roles_base qw(UsageExit ScriptExit RolesLog RolesNotification ArchiveFile
                  find_max_actions_value login_dbi_sql find_max_actions_value2  ExecuteSQLCommands);
## Set Test Mode
$TEST_MODE = 0;		## Test Mode (1 == ON, 0 == OFF)
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
	my($user_id, $user_pw, $db_id) = @_;

	## Step 1: Log Into Source Database
	$source_lda = login_dbi_sql($db_id, $user_id, $user_pw)
			|| (
			&RolesLog("FATAL_MSG",
				$DBI::errstr) &&
			&ScriptExit(-1, "Unable to Log into Source Database: $DBI::errstr")
			);

	## Step 2: Make sure output directory is writable
	unless (-w $datafile_dir)
	{
		&RolesLog("FATAL_MSG",
			"Datafile Directory is not writable: $datafile_dir");
		ScriptExit("Unable write to directory $datafile_dir.");
	}

	## Step 3: Extract data to output file
	&FullExtract($source_lda, $extract_filename);

	## Step 4: Log off Source Database
	$source_lda->disconnect();

	## Step 5: Add Tester/Developers file
	if (-r $extraperson_filename)
	{
	my($append_cmd) = "cat $extraperson_filename >> $extract_filename";
	if (system($append_cmd)) #Non-Zero would be an error
	{
		&RolesLog("WARNING_MSG",
			"Unable to append tester/developer file to extract");
		return -1
	}


	## Determine number of records appended (simply count the rows)
	my($count_cmd) = "wc -l $extraperson_filename";

	my($count) = `$count_cmd`;
	$count =~ /^ *(\d+) .*$/;  ## Just get the number
	print "Tester/Developer Records added: " . $1 . "\n";

	}

	return;
}

###############################################################################
sub FeedPrepare 	#Externally Callable Feed Prepare Routine
###############################################################################
{
	if ($TEST_MODE) {print "In $package_name:FeedPrepare.\n";}

	shift; #Get rid of calling package name

	## Step 0: Check Arguments
	if ($#_ != 2) {&UsageExit("Command Parameters: <dest_id> <dest_pw> <dest_db>\nInsufficient Arguments");}
	my($user_id, $user_pw, $db_id) = @_;

	## Step 1: Check for Extract file from Source Database
	unless (-r $extract_filename)
	{
		&RolesLog("FATAL_MSG",
			"Datafile not readable: $extract_filename");
		ScriptExit("Unable to read datafile $extract_filename.");
	}

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

	&ExistingExtract($destination_lda, $existing_filename);

	## Step 4: Log off Destination Database
	$destination_lda->disconnect();

	## Step 5: Compare Extract Files
	&CompareExtract($extract_filename, $existing_filename,
			$diff_file_prefix);
	return;
}

###############################################################################
sub FeedLoad 	#Externally Callable Feed Load Routine for this Package
###############################################################################
{
	if ($TEST_MODE) {print "In $package_name:FeedLoad.\n";}

	shift; #Get rid of calling package name

	## Step 0: Check Arguments
	if ($#_ != 2) {&UsageExit("Command Parameters: <dest_id> <dest_pw> <dest_db>\nInsufficient Arguments");}
	my($user_id, $user_pw, $db_id) = @_;

	## Step 1: Log Into Destination Database
	my($destination_lda) = login_dbi_sql($db_id, $user_id, $user_pw)
			|| (
			&RolesLog("FATAL_MSG",
				"Unable to log into destination database $DBI::errstr") &&
			ScriptExit("Unable to Log into Destination Database: $db_id.")		);

        ## Step 1a: Make sure there are not more than 1000 total changes
        ($update_lines, $insert_lines, $delete_lines) = (0,0,0);
        $MAX_ACTIONS = &find_max_actions_value2($db_id,$user_id,$user_pw, "MAX_PERSON");
        if (-r $update_file) {chomp($update_lines=`grep -c . $update_file`);}
        if (-r $insert_file) {chomp($insert_lines=`grep -c . $insert_file`);}
        if (-r $delete_file) {chomp($delete_lines=`grep -c . $delete_file`);}

	my($actions_count) = $update_lines + $insert_lines + $delete_lines;
	if ($actions_count > $MAX_ACTIONS)
	{
 	 $msg = "Number of Actions ($actions_count) exceeds threshold ($MAX_ACTIONS).\n" . 
		"updates=$update_lines\n" .	
		"inserts=$insert_lines\n" .
		"deletes=$delete_lines";

	 print $msg;
         #print "delete_file='$delete_file'\n";
         #exit;
	 &RolesNotification("Number of actions exceeds threshold", $msg);
	 return -1; # send email
	}
        elsif ($actions_count == 0) {
          $msg = "No actions to process today.\n";
          #&RolesNotification("No actions to process today.", $msg);
	  &ScriptExit("Halting: No person changes.");
        }
	else
	{
	 print "$actions_count actions to be performed.\n" .
		"updates=$update_lines\n" .	
		"inserts=$insert_lines\n" .
		"deletes=$delete_lines";
	}



        if ($update_lines + $insert_lines + $delete_lines > $MAX_ACTIONS) {
                print "Too many person changes.  updates=$update_lines"
			. " inserts=$insert_lines deletes=$delete_lines\n";
        }

	## Step 2: Update, Insert and Delete Records
	if (-r $update_file) {&UpdateRecords($destination_lda, $update_file);}
	if (-r $insert_file) {&InsertRecords($destination_lda, $insert_file);}
	if (-r $delete_file) {&DeleteRecords($destination_lda, $delete_file);}

	## Step 3: Archive Files
##	&ArchiveFile($extract_filename, $archive_dir);
	&ArchiveFile($existing_filename, $archive_dir);
	if (-r $update_file) {&ArchiveFile($update_file, $archive_dir);}
	if (-r $insert_file) {&ArchiveFile($insert_file, $archive_dir);}
	if (-r $delete_file) {&ArchiveFile($delete_file, $archive_dir);}

	## Step 4: Check for Inactive Authorizations
##	Let Status Check do this for now - 2/23/1998 
##	&CheckAuthorizations($destination_lda);

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

	## Step 0: Check Arguments
	if ($#_ != 2) {&UsageExit("Command Parameters: <dest_id> <dest_pw> <dest_db>\nInsufficient Arguments");}
	my($user_id, $user_pw, $db_id) = @_;

	## Step 1: Log Into Destination Database
	my($destination_lda) = login_dbi_sql($db_id, $user_id, $user_pw)
			|| (
			&RolesLog("FATAL_MSG",
				"Unable to log into destination database $DBI::errstr") &&
			ScriptExit("Unable to Log into Destination Database: $db_id.")		);

	## Step 2: Send for Inactive Authorizations
	&CheckAuthorizations($destination_lda);

	## Step 3: Log off Destination Database
	$destination_lda->disconnect();

	return;
}


###############################################################################
sub PackageTest	#Externally Callable Package Test Routine 
###############################################################################
{
	if ($TEST_MODE) {print "In $package_name:PackageTest.\n";}

#	&FeedExtract($package_name, roles, rfeed, warehouse); 
#	&FeedLoad($package_name, rolesbb, zzrolesbbzz, troles); 

	return;
}


###############################################################################
###############################################################################
##
## Subroutines - Private Common Routines.
##
###############################################################################
###############################################################################

###############################################################################
sub FullExtract  #Routine for performing a full source extract
###############################################################################
{
	if ($TEST_MODE) {print "In $package_name:FullExtract.\n";}

	## Get Arguments
	my($lda_db, $db_out) = @_;


	if (not $lda_db)      ## If we logged in ok
	{	
		&RolesLog("FATAL_MSG",
			"Not Logged into source database");
	}


	unless (open(OUTFILE, "> $db_out"))
	{
		&ScriptExit(1, "Cannot open $db_out for writing");
	}

	## Define Cursor to select records
	$select_sql_old =  "SELECT
                       mit_id,
                       last_name,
                       first_name,
                       upper(kerberos_name),
                       email_address,
                       department_number,
                       decode (person_type, 'EMPLOYEE', 'E',
                                            'STUDENT', 'S',
                                            'O'),
			'A'
		FROM wareuser.test
		WHERE kerberos_name IS NOT NULL
		AND mit_id IS NOT NULL
		ORDER BY kerberos_name";

        #$input_char_set = 'US7ASCII';
        $input_char_set = 'WE8ISO8859P1';
        $output_char_set = 'WE8ISO8859P1';

	#$select_sql =  "SELECT
        #               mit_id,
        #               upper(translate(last_name, 
        #                chr(232) || chr(233) || chr(252) ||chr(241), 'eeun')),
        #               nvl(upper(translate(first_name, 
        #                chr(232) || chr(233) || chr(252) ||chr(241), 'eeun')),
        #                'no-first-name'),
	$select_sql =  "SELECT
                       mit_id,
                       upper(convert(last_name, '$input_char_set', 
                                     '$output_char_set')),
                       nvl(upper(convert(first_name, '$input_char_set',
                                     '$output_char_set')),
                         'no-first-name'),
                       krb_name_uppercase,
                       upper(email_address),
                       unit_id,
                       decode (person_type, 'Current Employee', 'E',
                                            'Current Student', 'S',
                                            'O'),
                       --decode (type, 'EMPLOYEE', 'E',
                       --              'STUDENT', 'S',
                       --              'O'),
		       'A'
		FROM wareuser.krb_person
		WHERE krb_name_uppercase IS NOT NULL
		ORDER BY krb_name_uppercase";



	unless ($csr_extract =	$lda_db->prepare( $select_sql))
	{
		&ScriptExit(1, $DBI::errstr);
	}
 	$csr_extract->execute();

	## Process Each Row
	$record_cnt = 0;
	&RolesLog("INFO_MSG", "Starting Extract");

	while(($mit_id,$last_name, $first_name, $kerberos_name, $email_address,
	    $department_number, $person_type, $status_code) = $csr_extract->fetchrow_array())
	{
	    if (length($last_name) > 30) {  # Truncate too-long last names
		$last_name = substr($last_name, 0, 27) . '...';
            }
	    $record = join (":", $mit_id,$last_name, $first_name, 
                  $kerberos_name, $email_address, $department_number, 
                  $person_type, $status_code, "\n");
	    print (OUTFILE $record);
	    $record_cnt++;
	}

	print("Records Extracted = $record_cnt\n");

	$csr_extract->finish();
	close(OUTFILE);

	return;
}

###############################################################################
sub ExistingExtract  #Routine for performing an existing dest. extract
###############################################################################
{
	if ($TEST_MODE){print "In $package_name:ExistingExtract.\n";}

	## Get Arguments
	my($lda_db, $db_out) = @_;

	if (not $lda_db)      ## If we logged in ok
	{	
		&RolesLog("FATAL_MSG",
			"Not Logged into destination database");
	}

	unless (open(OUTFILE, "> $db_out"))
	{
		&ScriptExit(1, "Cannot open $db_out for writing");
	}

	## Define Cursor to select records
	$select_sql =  "SELECT
                       	mit_id,
                      	last_name,
                      	first_name,
                      	upper(kerberos_name),
                      	email_addr,
                      	dept_code,
			primary_person_type,
			status_code
	             	FROM rdb_t_person
			order by kerberos_name";

	unless ($csr_extract =	$lda_db->prepare( $select_sql))
	{
		&ScriptExit(1, $DBI::errstr);
	}
 	$csr_extract->execute();

	## Process Each Row
	$record_cnt = 0;
	&RolesLog("INFO_MSG", "Starting Existing Extract");

	while(($mit_id,$last_name, $first_name, $kerberos_name, $email_address,
	    $department_number, $person_type, $status_code) = $csr_extract->fetchrow_array())
	{
		$mit_id =~ s/ //g; #Remove trailing blanks

		$record = join (":", $mit_id,$last_name, $first_name, $kerberos_name, $email_address, $department_number, $person_type, $status_code, "\n");

		print (OUTFILE $record);
		$record_cnt++;
	}

	&RolesLog("INFO_MSG",
		"Existing Records Extracted = $record_cnt");

	print("Existing Records Extracted = $record_cnt\n");

	$csr_extract->finish();
	close(OUTFILE);
	return;
}

###############################################################################
sub CompareExtract  #Routine to compare new and existing extracts
###############################################################################
{
	if ($TEST_MODE) {print "In $package_name:CompareExtract.\n";}

	## Get Arguments
	my($file1, $file2, $diff_file_prefix) = @_;

	unless ($file1 && $file2 && $diff_file_prefix)
	{	
		&RolesLog("FATAL_MSG",
			"Incorrect Arguments Passed");
		return -1;
	}

	use diff ('DiffInit', 'DiffClose');  

	my($diff_object) = DiffInit($file1, $file2,
				$diff_file_prefix);


	unless ($diff_object)
	{
		&ScriptExit(1, "Cannot Initialize Diff mechanism");
	}

	#Initially we'll just use the Unix's diff command, capturing
	#the output and parsing it to determine what has updated,
	#deleted or inserted.

	$insert_cnt = $delete_cnt = $update_cnt = $dup_cnt = $compare_cnt = 0;


foreach $_ (`diff $diff_object->{'FILE1'} $diff_object->{'FILE2'} 2>&1`)
	{
	$line = $_;

        #print "diff line='$line'\n";


	## Parse the line, skipping it if is not an insert or update
	## line with one or more characters (blank lines are skipped)
	unless ($line =~ m/^([><]) (..*)$/) {next;}

	$compare_cnt++;

	$insert_delete = $1;
	$record = $2;
	$insert_delete =~ s/>/DELETE/;
	$insert_delete =~ s/</INSERT/;

	## Parse out the primary key from the records
	($mit_id,$last_name, $first_name, $kerberos_name,
		 $email_address, $department_number, $person_type, $status_code) =
	          split (":", $record);

	## Get Inserts/Deletes from Diff
	if ($insert_delete =~ m/INSERT/)
	{
		if (defined $insert_record{$kerberos_name})
		{
			#New Record Appears Twice, Use second value
			$insert_cnt--; 
			$dup_cnt++; 
		&RolesLog("WARNING_MSG",
			"Duplicate Insert Record for Kerberos ID ($kerberos_name) Found, using new record $record");

		}

		$insert_record{$kerberos_name} = $record;		
		$insert_cnt++; 
	}
	elsif($insert_delete =~ m/DELETE/)
	{
		$delete_record{$kerberos_name} = $record;		
		$delete_cnt++; 
	}

	}

	## Determine Updates from Insert/Deletes
	## Look for any Insert that is also a delete
	while (($kerberos_name, $record) = each (%insert_record))
	{
		if (defined $delete_record{$kerberos_name})
		{
		
			## Make sure the record acutally changed
			## (While the record may not have changed,
			## its position in the file may have)

			unless  ($delete_record{$kerberos_name} eq 
				$insert_record{$kerberos_name})
			{
				$update_record{$kerberos_name} = $record;
				$update_cnt++;
			}
				
			delete $delete_record{$kerberos_name};
			delete $insert_record{$kerberos_name};
			$insert_cnt--;
			$delete_cnt--;

		}
	}

	
##	print "($compare_cnt) Records Compared.\n";
	print "($dup_cnt) Duplicate Records Found in source.\n";
	print "($insert_cnt) Insert Records Found.\n";
	print "($delete_cnt) Delete Records Found.\n";
	print "($update_cnt) Update Records Found.\n";


	## Write Insert Results to file
        my ($temp_rc, $temp_cmd);
        $temp_cmd = "rm " . 
                 "$diff_object->{'FILEDIFF'}\.$diff_object->{'INSERT_TAG'}";
        $temp_rc = system($temp_cmd);
        #print "rc from '$temp_cmd' is $temp_rc\n";
	if ($insert_cnt > 0)
	{
		unless (open(INSERTFILE, ">$diff_object->{'FILEDIFF'}\.$diff_object->{'INSERT_TAG'}")) {return 0;}

		while (($kerberos_name, $record) = each (%insert_record))
		{print (INSERTFILE "$record\n");}

		close (INSERTFILE);
	}

	## Write Delete Results to file
        $temp_cmd = "rm " . 
                 "$diff_object->{'FILEDIFF'}\.$diff_object->{'DELETE_TAG'}";
        $temp_rc = system($temp_cmd);
        #print "rc from '$temp_cmd' is $temp_rc\n";
	unless (open(DELETEFILE, 
                ">$diff_object->{'FILEDIFF'}\.$diff_object->{'DELETE_TAG'}")) 
          {return 0;}
	if ($delete_cnt > 0)
	{
		while (($kerberos_name, $record) = each (%delete_record))
		{print (DELETEFILE "$record\n");}
	}
	close (DELETEFILE);

	## Write Delete Results to file
        $temp_cmd = "rm " . 
                 "$diff_object->{'FILEDIFF'}\.$diff_object->{'UPDATE_TAG'}";
        $temp_rc = system($temp_cmd);
        #print "rc from '$temp_cmd' is $temp_rc\n";
	if ($update_cnt > 0)
	{
		unless (open(UPDATEFILE, ">$diff_object->{'FILEDIFF'}\.$diff_object->{'UPDATE_TAG'}")) {return 0;}

		while (($kerberos_name, $record) = each (%update_record))
		{print (UPDATEFILE "$record\n");}

		close (UPDATEFILE);
	}



	## Test DiffClose
	DiffClose($diff_object);


	return;
}

###############################################################################
sub DeleteRecords  #Routine for deleting destination records
###############################################################################
{
	if ($TEST_MODE) {print "In $package_name:DeleteRecords.\n";}

	## Step 1: Check Parameters	
	my($lda_db, $filename) = @_;

	if (not $lda_db)      ## Check if we are logged in ok
	{	
		&RolesLog("FATAL_MSG",
			"Not Logged into destination database");
	}

	unless (open(INFILE, "< $filename"))
	{
		&ScriptExit(1, "Cannot open deletion file $filename for reading");
	}

	## Step 2: Initial Record Counters
	$read_cnt = $mark_cnt = $error_cnt = 0;

	## Step 3: Mark Records as Inactive-As Identified in DELETE file
	if ($TEST_MODE) {print "Marking Records for Deletion.\n";}

	#Define Mark Inactive Cursor
	$mark_sql = 	"UPDATE rdb_t_person
		     	SET status_code = 'I'
                          ,status_date =  NOW()		
	                WHERE kerberos_name = ? 
                        AND IFNULL(status_code,'T') <> 'I'" ;  
                        
##	 AND
##			last_name = :2 AND
##			first_name = :3 AND
##			email_addr = :4 AND
##			to_char(dept_code) = to_char(:5) AND
##			primary_person_type = :6 AND
##			to_char(mit_id) = to_char(:7) AND
##			status_code = :8";


	unless ($csr_mark = $lda_db->prepare($mark_sql))
	    {
		&RolesLog("FATAL_MSG", "Unable to create cursor $DBI::errstr");
		&ScriptExit();
	    }


	# Process Each Record
	while (<INFILE>)
	{
		## Read Record
		$record = $_;
		chomp($record); 

		## Parse Record
		($mit_id, $last_name, $first_name, $kerberos_name, 
		 $email_address, $department_number, $person_type, $status_code) =
	          split (":", $record);
		  $read_cnt++;

		## Mark Record as Inactive
		unless ($csr_mark->bind_param(1, $kerberos_name))
##, $last_name,
##		     $first_name, $email_address, $department_number,
##		     $person_type, $mit_id, $status_code))
	        {
	            &RolesLog("WARNING_MSG", "Unable to mark record for Kerberos_id ($kerberos_name) as inactive  $record $DBI::errstr");
			$error_cnt++;
			$mark_cnt--;	
##		print "$record\n";
##		    &ScriptExit(-1);
	        }
		$mark_cnt++;

		$csr_mark->execute();
	}

	$csr_mark->finish();
	$lda_db->commit();
	close (INFILE);

	## Step 4: Count number of records before delete
	if ($TEST_MODE) {print "Counting Total Records Prior to Deletion.\n";}
	my($pre_delete_cnt) = 0;
	$delete_cnt_sql = "SELECT count(*) FROM rdb_t_person";

	unless ($csr_delete_cnt = $lda_db->prepare($delete_cnt_sql))
	    {
		&RolesLog("FATAL_MSG", "Unable to create delete count cursor $DBI::errstr");
		&ScriptExit();
	    }
	$csr_delete_cnt->execute();

	($pre_delete_cnt) = $csr_delete_cnt->fetchrow_array();

        &RolesLog("INFO_MSG",
		"$pre_delete_cnt Record Prior to deletion");
	$csr_delete_cnt->finish();


	## Step 4: Delete ALL Inactive Records having no Autorizations
	if ($TEST_MODE) {print "Deleteing Records.\n";}
	#Define Delete Cursor
	#$delete_sql = 	"DELETE from rdb_t_person a
	#		WHERE
	#		upper(kerberos_name) NOT IN (select
        #               upper(b.kerberos_name) from rdb_t_authorization b where
        #               upper(a.kerberos_name) = upper(b.kerberos_name))
	#		AND status_code = 'I'";
        # Faster select statement
	$update_sql = 	"UPDATE person a SET status_code='X'
			WHERE
			kerberos_name NOT IN (select
                        b.kerberos_name from authorization b where
                        b.kerberos_name = a.kerberos_name)
			AND status_code = 'I'";

	$delete_sql = 	"DELETE FROM person 
			WHERE
			status_code = 'X'";
	unless ($csr_delete = $lda_db->prepare( $update_sql))
	    {
		&RolesLog("FATAL_MSG", "Unable to create delete cursor $DBI::errstr");
		&ScriptExit();
	    }


	## Delete Inactive

        &RolesLog("INFO_MSG",
		"Deleting Inactive Records that do not have authorizations");
	unless ($csr_delete->execute())
        {
            &RolesLog("WARNING_MSG", "Unable to delete inactive records $DBI::errstr");
        }

	unless ($csr_delete = $lda_db->prepare( $delete_sql))
	    {
		&RolesLog("FATAL_MSG", "Unable to create delete cursor $DBI::errstr");
		&ScriptExit();
	    }

	unless ($csr_delete->execute())
        {
            &RolesLog("WARNING_MSG", "Unable to delete inactive records $DBI::errstr");
        }

	$lda_db->commit();
	$csr_delete->finish();

	## Step 4: Count number of records after delete
	if ($TEST_MODE) {print "Counting Total Records After Deletion.\n";}
	my($post_delete_cnt) = 0;

	unless ($csr_delete_cnt = $lda_db->prepare( $delete_cnt_sql))
	{
		&RolesLog("FATAL_MSG", "Unable to create delete count cursor again $DBI::errstr");
		&ScriptExit();
	}

	$csr_delete_cnt->execute();
	($post_delete_cnt) = $csr_delete_cnt->fetchrow_array();

        &RolesLog("INFO_MSG",
		"$post_delete_cnt Record After deletion");
	$csr_delete_cnt->finish();


	# Determine total number of records deleted
	my($delete_cnt) = ($pre_delete_cnt - $post_delete_cnt);

	## Step 5 Summarize Results
	print "($read_cnt) Person Delete Records Read.\n";
	print "($dup_cnt) Skipped Duplicate Records in Source Files.\n";
	print "($mark_cnt) Person Records Marked Inactive.\n";
	print "($error_cnt) Mark as Inactive Errors.\n";
	print "($delete_cnt) Inactive Records without Authorizations Deleted.\n";

	return;
}

###############################################################################
sub UpdateRecords  #Routine for updating destination records
###############################################################################
{
	if ($TEST_MODE) {print "In $package_name:UpdateRecords.\n";}

	print "Updating Records\n";

	my($lda_db, $filename) = @_;

	if (not $lda_db)      ## If we logged in ok
	{	
		&RolesLog("FATAL_MSG",
			"Not Logged into destination database");
	}

	unless (open(INFILE, "< $filename"))
	{
		&ScriptExit(1, "Cannot open update file $filename for reading");
	}

	#Define Update Cursor - To update existing records
	$update_sql = "UPDATE rdb_t_person
			SET
			mit_id = ?,
			last_name = ?,
			first_name = ?,
			kerberos_name = ?,
			email_addr = ?,
			dept_code = ?,
			primary_person_type = ?,
			status_code = 'A',
                        status_date = null                          
                        WHERE kerberos_name = ?";
        #print $update_sql;
	unless ($csr_update = $lda_db->prepare( $update_sql))
	    {
		&RolesLog("FATAL_MSG", "Unable to create update cursor $DBI::errstr");
		&ScriptExit();
	    }

	#Initial Record Counters
	$read_cnt = $dup_cnt = $update_cnt = $error_cnt = 0;

	## Process Each Record
	while (<INFILE>)
	{
		## Read Record
		$record = $_;
		chomp($record); 

		## Parse Record
		($mit_id,$last_name, $first_name, $kerberos_name,
		 $email_address, $department_number, $person_type, $status_code,$status_date) =
	          split (":", $record);
		  $read_cnt++;

		## UpdateRecord
		if ($dup_check[$kerberos_name]  eq $kerberos_name) # Check for duplicates
		{
		&RolesLog("WARNING_MSG",
			"Duplicate Update Record for Kerberos ID ($kerberos_name) $record");
		$dup_cnt++;
		}
		else	
		{
		$dup_check[$kerberos_name] = $kerberos_name;

		unless ($csr_update->bind_param(1,$mit_id) && 
		$csr_update->bind_param(2,$last_name)  &&
		$csr_update->bind_param(3,$first_name)  &&
		$csr_update->bind_param(4,$kerberos_name) &&
		$csr_update->bind_param(5,$email_address) &&
		$csr_update->bind_param(6,$department_number) &&
		$csr_update->bind_param(7,$person_type) &&
		$csr_update->bind_param(8,$kerberos_name)) 
	        {
	            &RolesLog("WARNING_MSG", "Update Error for Kerberos Id ($kerberos_name) $record $DBI::errstr");
			$error_cnt++;
			$update_cnt--;	
##		print "$record\n";
##		    &ScriptExit(-1);
	        }
		unless ($csr_update->execute())
		{
	            &RolesLog("WARNING_MSG", "Update Error for Kerberos Id ($kerberos_name) $record $DBI::errstr");
			$error_cnt++;
			$update_cnt--;	
		}
		$update_cnt++;
		}
	}

	$lda_db->commit();
	$csr_update->finish();
	close (INFILE);

	print "($read_cnt) Person Update Records Read.\n";
	print "($dup_cnt) Skipped Duplicate Records in Source Files.\n";
	print "($update_cnt) Person Records updated.\n";
	print "($error_cnt) Update Errors.\n";


	return;
}

###############################################################################
sub InsertRecords  #Routine for inserting destination records from a file
###############################################################################
{
	if ($TEST_MODE) {print "In $package_name:InsertRecords.\n";}

	my($lda_db, $filename) = @_;

	print "Inserting Records\n";

	if (not $lda_db)      ## If we logged in ok
	{	
		&RolesLog("FATAL_MSG",
			"Not Logged into destination database");
	}

	unless (open(INFILE, "< $filename"))
	{
		&ScriptExit(1, "Cannot open insert file $filename for reading");
	}

	#Define Insert Cursor - To insert new records
	$insert_sql =  "insert into rdb_t_person
                       (mit_id,
                       last_name,
                       first_name,
                       kerberos_name,
                       email_addr,
                       dept_code,
                       primary_person_type,
		       status_code)
                       values (?, ?, ?, ?, ?, ?, ?, ?)";

	unless ($csr_insert = $lda_db->prepare($insert_sql))
	    {
		&RolesLog("FATAL_MSG", "Unable to create insert cursor $DBI::errstr");
		&ScriptExit(1);
	    }





	#Initial Record Counters
	$read_cnt = $dup_cnt = $insert_cnt = $error_cnt = 0;

	## Process Each Record
	while (<INFILE>)
	{
		## Read Record
		$record = $_;
		chomp($record); 

		## Parse Record
		($mit_id,$last_name, $first_name, $kerberos_name,
		 $email_address, $department_number, $person_type, $status_code) =
	          split (":", $record);
		  $read_cnt++;

		## Insert Record
		if ($dup_check[$kerberos_name]  eq $kerberos_name) # Check for duplicates
		{
		&RolesLog("WARNING_MSG",
			"Duplicate Record for Kerberose ID ($kerberos_name) $record");
		$dup_cnt++;
		}
		else	
		{
		$dup_check[$kerberos_name] = $kerberos_name;

  		unless ($csr_insert->bind_param(1,$mit_id) &&
                	$csr_insert->bind_param(2,$last_name)  &&
                	$csr_insert->bind_param(3,$first_name)  &&
                	$csr_insert->bind_param(4,$kerberos_name) &&
                	$csr_insert->bind_param(5,$email_address) &&
                	$csr_insert->bind_param(6,$department_number) &&
                	$csr_insert->bind_param(7,$person_type) &&
                	$csr_insert->bind_param(8,$status_code))
	        {
	            &RolesLog("WARNING_MSG", "Insert Error for Kerberos ID ($kerberos_name) $record $DBI::errstr");
			$error_cnt++;
			$insert_cnt--;	
##		print "$record\n";
##		    &ScriptExit(-1);
	        }
                unless ($csr_insert->execute())
                {
                    &RolesLog("WARNING_MSG", "Update Error for Kerberos Id ($kerberos_name) $record $DBI::errstr");
                        $error_cnt++;
                        $nsert_cnt--;
                }
		$insert_cnt++;
                if ($insert_cnt%1000 == 0) {
                   $lda_db->commit();
                   print "Insert count = $insert_cnt\n";
                 }
		}
	}

	$lda_db->commit();
	$csr_insert->finish();
	close (INFILE);

	print "($read_cnt) Person Records Read.\n";
	print "($dup_cnt) Skipped Duplicate Records in Source Files.\n";
	print "($insert_cnt) Person Records Inserted.\n";
	print "($error_cnt) Insert Errors.\n";

	return;
}

###############################################################################
#sub PurgeRecords  #Routine for purging all destination records
###############################################################################
#{
#	if ($TEST_MODE) {print "In $package_name:PurgeRecords.\n";}
#
#	## Get Arguements
#	my($lda_db) = @_;
#
#	if (not $lda_db)      ## If we logged in ok
#	{	
#		&RolesLog("FATAL_MSG",
#			"Not Logged into destination database");
#	}
#
#	$purge_sql = "DELETE FROM rdb_t_person";
#
#	#Define Delete Cursor - Used to delete obsolete records
#	unless ($csr_purge = &ora_open($lda_db, $purge_sql))
#	{
#	&RolesLog("FATAL_MSG", $ora_errstr);
#	&ScriptExit();
#	}
#
#	#Perform the Delete
#	unless (&ora_bind($csr_purge))
#	{
#	&RolesLog("FATAL_MSG", $ora_errstr);
#	&ScriptExit();
#	}
#
#	&ora_commit($lda_db);
#	&ora_close($csr_purge);
#
#	return;
#}


###############################################################################
sub CheckAuthorizations  #Routine to check for Inactive Authorizations
###############################################################################
{
	if ($TEST_MODE) {print "In $package_name:CheckAuthorizations.\n";}

	my($lda_db) = @_;

	my($msg, $inactive_list) = "";
	my($active_cnt) = CountActive($lda_db);

	## Send Notification for In-Active records with Authorizations
	## 1.) Find Inactive Records
	## 2.) Use roles_base routine to send notification

	print "Looking for in-active records with authorizations\n";

	if (not $lda_db)      ## If we logged in ok
	{	
		&RolesLog("FATAL_MSG",
			"Not Logged into database");
	}


	#Define Notify Cursor
	unless ($csr_notify =
	    $lda_db->prepare(
	      "select kerberos_name, last_name, first_name
	       from rdb_t_person
	       where status_code = 'I'
	       order by kerberos_name"))
	{
		&RolesLog("FATAL_MSG", "Unable to create notify cursor $DBI::errstr");
		&ScriptExit(-1);
	}
	$csr_notify->execute();

	#Get list
	$inactive_cnt = 0;
	while (($kerberos_name, $last_name, $first_name) = $csr_notify->fetchrow_array())
	{
	$inactive_list .= join (":", $kerberos_name, $last_name, $first_name) . "\n";
	$inactive_cnt++;
	}
	$csr_notify->finish();

	## Send Notification
	$sub = " $inactive_cnt Inactive Kerberos ID(s) with Roles <Authorizations";
	$msg .= "\nDatabase: @ENV{db_name}\n"; ##Hack
	$msg .= "Active Person Records: " . $active_cnt . "\n";

	$msg .= "Inactive Person Records: " . $inactive_cnt . "\n\n";
	$msg .= "KerberosID:LastName:FirstName\n";
	$msg .= "______________________________________________\n";
	$msg .= $inactive_list;
	$msg .= "______________________________________________\n";

	## Include the results from the load file
	my($log_filename) = $ENV{'HOME'} . "/log/cron_roles_feed.load.person." . @ENV{db_name} . ".log";
	if (-r $log_filename)
	{
		open (LOGFILE, $log_filename) ||
                   die "Can't open logfile %s.\n", $log_filename;
             $msg .= "Log from last load:\n";
             $msg .= "Begin Log->\n";
       	while (<LOGFILE>) {
                $msg .= $_;
	        } # while
		close(LOGFILE);
            $msg .= "<- End Log\n";
	}
 
	print $sub . "\n";
	print $msg . "\n";

	if (($inactive_cnt > 0) || $TEST_MODE)
	{
		RolesNotification($sub, $msg);
	}

	return;
}

###############################################################################
sub CountActive  #Routine to count number of non-deleted active person records 
###############################################################################
{
	if ($TEST_MODE) {print "Counting Total Active Records.\n";}

	my($lda_db) = @_;

	if (not $lda_db)      ## If we logged in ok
	{	
		&RolesLog("FATAL_MSG",
			"Not Logged into database");
	}

	my($active_cnt) = 0;
	$active_cnt_sql = "SELECT count(*) FROM rdb_t_person where status_code = 'A'";

	unless ($csr_active_cnt = $lda_db->prepare( $active_cnt_sql))
	    {
		&RolesLog("FATAL_MSG", "Unable to create count cursor $DBI::errstr");
		&ScriptExit();
	    }
	$csr_active_cnt->execute();

	($active_cnt) = $csr_active_cnt->fetchrow_array();

        &RolesLog("INFO_MSG",
		"$active_cnt Active Person Records Found");
	$csr_active_cnt->finish();

	return $active_cnt;
}


return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################
