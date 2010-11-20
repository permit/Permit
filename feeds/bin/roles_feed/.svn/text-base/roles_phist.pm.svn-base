##############################################################################
## NAME: roles_phist.pm
##
## DESCRIPTION: Subroutines related to maintaining the table 
##              person_history, which tracks department, person_type, and
##              other changes for people who have at one point had
##              an authorization.
##
#
#  Copyright (C) 2002-2010 Massachusetts Institute of Technology
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
## Written  8/19/2002 by J. Repa
## Modified 6/28/2007 by M. Korobko (get max transactions value from table)
##
###############################################################################

package roles_phist;
$VERSION = 1.0; 
$package_name = 'roles_phist';

## Standard Roles Database Feed Package
#use roles_base qw(UsageExit ScriptExit RolesLog RolesNotification ArchiveFile);
use roles_base qw(UsageExit ScriptExit RolesLog RolesNotification ArchiveFile
                    find_max_actions_value login_dbi_sql find_max_actions_value2  ExecuteSQLCommands);
#use roles_qual 
# qw(strip ProcessActions FixDescendents sort_actions fix_haschild);

## Set Test Mode
$TEST_MODE = 1;		## Test Mode (1 == ON, 0 == OFF)
if ($TEST_MODE) {print "TEST_MODE is ON for $package_name.pm\n";}


## Initialize Constants 
$datafile_dir = $ENV{'ROLES_HOMEDIR'} . "/data/";
#$datafile_dir = "/tmp/rolesdb/";
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
use config('GetValue');


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
        $outfile = $datafile_dir . "phist.warehouse";

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

  my $db_parm =  GetValue('warehouse'); # Info about database from config file
  $db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
  my $wh_user_id = $1;
  my $wh_user_pw = $2;
  my $wh_db_id = $3;

  my $wh_dbh =  DBI->connect( $wh_db_id, $wh_user_id, $wh_user_pw, {RaiseError =>1})
                                || die "Couldn't connect to database:" . $DBI->errstr;


  print "Warehouse: '$wh_db_id'  User: '$wh_user_id'\n"; 

#
#  Open connection to oracle
#
 #print "db_id='$db_id' user_id='$user_id'\n";
 my($lda) = login_dbi_sql($db_id, $user_id, $user_pw)
 	|| die $DBI::errstr;
 my $stmt = "select distinct kerberos_name from auth_audit";
 my $csr = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";
 $csr->execute();

my %kerblist;
 while (($kerbname )
        = $csr->fetchrow_array() )
 {
		$kerblist{$kerbname} = 1;
 }
 $csr->finish();

	    # CASE type WHEN 'STUDENT' THEN NULL ELSE unit_id END CASE,
	    # CASE type WHEN 'STUDENT' THEN NULL ELSE UPPER(unit_name) END CASE,
 $stmt1 = "select mit_id, krb_name_uppercase, upper(last_name), 
             upper(first_name), 
             upper(middle_name), 
	     decode(type,'STUDENT',NULL,unit_id) ,
	     decode(type,'STUDENT',NULL,upper(unit_name)) ,
             type
             from krb_person
             order by krb_name_uppercase"; 
             #where krb_name_uppercase in ( $kerblist ) order by krb_name_uppercase"; 
 my $csr1 = $wh_dbh->prepare($stmt1)
      || die "$DBI::errstr . \n";
 
 $csr1->execute();
#
#  Write out the records.
#
 my ($mit_id, $kerbname, $lastname, $firstname, $middlename, $unitid,
     $unitname, $perstype);
 while ( ($mit_id, $kerbname, $lastname, $firstname, $middlename, $unitid,
          $unitname, $perstype)
        = $csr1->fetchrow_array() )
 {
   if (($i++)%1000 == 0) {print $i . "\n";}
   if ($kerblist{$kerbname})
   {
   printf F2 "%s\|%s\|%s\|%s\|%s\|%s\|%s\|%s\n",
           $kerbname, $mit_id, $lastname, $firstname, $middlename, $unitid,
           $unitname, $perstype;
  }
 }

 $csr1->finish();
 
 close (F2);
 
 $wh_dbh->disconnect() || die "can't log off DB";
 $lda->disconnect() || die "can't log off DB";

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

	my($infile) = $datafile_dir . "phist.actions";
	my($sqlfile) = $datafile_dir . "phistchange.sql";

	## Step 0: Check Arguments
	if ($#_ != 2){&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
	my($user_id, $user_pw, $db_id) = @_;

	## Check number of actions to be performed
        $MAX_ACTIONS = &find_max_actions_value2( $db_id, $user_id, $user_pw, "MAX_PHIST");
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

        #
	# Step 1: Log Into Destination Database
        #
	my($destination_lda) = login_dbi_sql($db_id, $user_id, $user_pw)
	  || ( &RolesLog("FATAL_MSG",
	       "Unable to log into destination database $DBI::errstr") &&
		ScriptExit("Unable to Log into Destination Database: $db_id.")
             );

        #
        #  Define the SQL statements for inserting, deleting and updating
        #  records.
        #
        ### INSERT ###
        my $insert_stmt = q{
           insert into person_history
             (KERBEROS_NAME,
              MIT_ID,
              LAST_NAME,
              FIRST_NAME,
              MIDDLE_NAME,
              UNIT_CODE,
              UNIT_NAME,
              PERSON_TYPE,
              BEGIN_DATE)
            values (?, ?, ?, ?, ?, ?, ?, ?, NOW())
           };
        #print "insert_stmt='$insert_stmt'\n";
        my $add_csr;
        unless ($add_csr = $destination_lda->prepare($insert_stmt)) 
        {
          print $destination_lda->errstr . "\n";
          die "Error preparing insert_stmt.\n";
        }
        ### DELETE ###
        my $delete_stmt = q{
           update person_history 
             set end_date = NOW() 
             where kerberos_name = ? 
             and end_date is null
           };
        #print "delete_stmt='$delete_stmt'\n";
        my $del_csr;
        unless ($del_csr = $destination_lda->prepare($delete_stmt)) 
        {
          print $destination_lda->errstr . "\n";
          die "Error preparing delete_stmt.\n";
        }

        #
        #  Read through the action records, performing insert or delete
        #  statements.  For UPDATE, perform insert and delete statements
        #  in succession.
        #

	## Step 2: Update, Insert and Delete Records
	#if (-r $infile) {&ProcessActions($destination_lda, $qualtype, $infile, $sqlfile);}

        print "Opening file '$infile'\n";
        unless (open(IN,$infile)) {
          die "Cannot open $infile for reading\n"
        }
        my $i = 0;
        my $n;
        my $delim = '\|';
        while (chomp($line = <IN>)) {
          if (($i++)%1000 == 0) {print $i . "\n";}
          #print "line='$line'\n";
          @token = split($delim, $line);
          $token[8] = ($token[8]) ? $token[8] : '';  # Check for last token
          if ($token[0] eq 'ADD') {
            $n = @token;
            &add_cc($destination_lda, $add_csr, @token[1..$n-1]);
          }
          elsif ($token[0] eq 'DELETE') {
            &delete_cc($destination_lda, $del_csr, $token[1]);
          }
          if ($token[0] eq 'UPDATE') {
            &update_cc($destination_lda, $del_csr, $add_csr, 
                       @token[1..$#token]);
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
        # Close cursors
        $add_csr->finish;
        $del_csr->finish;
        $destination_lda->commit();
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

##########################################################################
#
#  Strips off trailing <cr> and leading and trailing blanks.
#
##########################################################################
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

########################################################################
#
#  Extract data from the person_history table in
#  the Roles DB.
########################################################################
sub ExistingExtract
{
my($lda, $data_dir) = @_;


$outfile = $data_dir . "phist.roles";
 
#
#   Open output file.
#
  $outf = ">" . $outfile;
  if( !open(F2, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }


#
#  Open cursor
#
 $time0 = time();
	     #CASE first_name WHEN 'no-first-name' THEN '' ELSE first_name END ,
	     # CASE substr(person_type,1,1) WHEN 'E' THEN 'EMPLOYEE' WHEN 'S' THEN 'STUDENT' ELSE 'OTHER' END ,
 my $stmt = "select kerberos_name, mit_id, last_name, 
		first_name,
              middle_name, unit_code, unit_name, 
		person_type
              from person_history
              where end_date is null
              order by kerberos_name";
 my $csr = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";

 $csr->execute();

#
#  Read in rows from the person_history table
#
 print "Reading in yesterday's person_history data from Roles table...\n";
 my $i = -1;
 my ($kname, $mitid, $lname, $fname, $mname, $ucode, $uname, $ptype);
 while ( ($kname, $mitid, $lname, $fname, $mname, $ucode, $uname, $ptype) 
   = $csr->fetchrow_array() ) {
   if (($i++)%5000 == 0) {print $i . "\n";}
	if ($fname eq 'no-first-name')
	{ 
		 $fname="";
	}
	my $pt  = substr ($ptype, 0, 1);
	if ($pt eq 'E') 
	{
		 $ptype="EMPLOYEE";
	}
	elsif ($pt eq 'S') 
	{
	 $ptype="STUDENT";
	}
	else
	{
		$ptype = "OTHER";
	}
   printf F2 "%s\|%s\|%s\|%s\|%s\|%s\|%s\|%s\n",
     $kname, $mitid, $lname, $fname, $mname, $ucode, $uname, $ptype;  
 }
  $csr->finish() || die "can't close cursor"; # Close cursor
  
 close (F2);

}

##############################################################################
#
#  Find the differences in two files of person_history data
#  
#  Process the differences to make it easier to do adds, deletes, and
#  updates to person_history table in Roles DB.
#
##############################################################################
sub CompareExtract
{

my($data_dir) = @_;

my $file1 = $data_dir . "phist.roles";
my $file2 = $data_dir . "phist.warehouse";
my $diff_file = $data_dir . "phist.diffs";
my $actionsfile = $data_dir . "phist.actions";
my $temp1 = $data_dir . "phist1.temp";
my $temp2 = $data_dir . "phist2.temp";

#For Linux, sort command, this env setting will make the sorting based on ASCII instead of Dictionary.
$ENV{'LANG'}='C';
$ENV{'LC-COLLATE'}='C';

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
       . " sed 's/^< /<\|/' |"           # Add | field marker
       . " sed 's/^> />\|/' |"           # Add | field marker
       . " sort -t '\|' -k 2,2 -k 1,1"    # Sort on qualcode, [<>]
       . " > $diff_file");

##############################################################################
#
#  Now read in the differences file. 
# 
#  Read '<' records from $diff_file into (@old_code, @old_the_rest)
#  Read '>' records from $diff_file into (@new_code, @new_the_rest)
#
##############################################################################
 unless (open(IN,$diff_file)) {
   die "Cannot open $diff_file for reading\n"
 }
 @old_code = ();
 @old_the_rest = ();
 @new_code = ();
 @new_the_rest = ();
 $i = 0;
 print "Reading records from differences file...\n";
 while (chop($line = <IN>)) {
   $line =~ /^([^\|]*)\|([^\|]*)\|(.*)$/;
   $oldnew = $1;
   $code = $2;
   $the_rest = $3;
   #print "$oldnew - $code - $the_rest\n";
   if ($oldnew eq '<') {
     push(@old_code, $code);
     push(@old_the_rest, $the_rest);
   }
   else {
     push(@new_code, $code);
     push(@new_the_rest, $the_rest);
   }
 }
 system("rm $temp1\n");  # Remove temporary files
 system("rm $temp2\n");  # Remove temporary files
 
#
#   Open output file.
#
  $outf = ">" . $actionsfile;
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
   if ($old_code[$old_p] lt $new_code[$new_p]) {
     print F2 "DELETE\|$old_code[$old_p]\n";
     $old_p++;
   }
   elsif ($old_code[$old_p] eq $new_code[$new_p]) {
     print F2 "UPDATE\|$new_code[$new_p]\|$new_the_rest[$new_p]\n";
     $old_p++;
     $new_p++;
   }
   else { # $old_code gt $new_code
     print F2 "ADD\|$new_code[$new_p]\|$new_the_rest[$new_p]\n";
     $new_p++;
   }
 }
 
#
#  Handle left-over lines.
#
 while ($old_p < $old_max) {
   print F2 "DELETE\|$old_code[$old_p]\n";
   $old_p++;
 }
 
 while ($new_p < $new_max) {
   print F2 "ADD\|$new_code[$new_p]\|$new_the_rest[$new_p]\n";
   $new_p++;
 }

 close (F2);


 #unless(open(ACTIONSFILE, ">" . $actionsfile) ) {
 #   die "$0: can't open ($actionsfile) - $!\n";
 # }
 #
 #for ($i = 0; $i < @actions; $i++) {
 #  print ACTIONSFILE $actions[$i] . "\n";
 #}
 #close ACTIONSFILE;

}

########################################################################
#
#  Subroutine to add records to table
#
###########################################################################
sub add_cc {
  my $lda = shift;
  my $csr = shift;
  my @token = @_;  # Get the remaining

  unless ($csr->execute(@token)) {
    for ($i=0; $i<@token; $i++) {
      print "$i $token[$i]\n";
    }
    die $lda->errstr;
  }
}  

########################################################################
#
#  Subroutine to delete records from the table
#
###########################################################################
sub delete_cc {
  my ($lda, $csr, $kerbname) = @_;

  unless ($csr->execute( ($kerbname) )) {
    print "Deleting $kerbname\n";
    die $lda->errstr;
  }
}  

########################################################################
#
#  Subroutine to update records in person_history table
#
###########################################################################
sub update_cc {
  my $lda = shift;
  my $del_csr = shift;
  my $add_csr = shift;
  my @token = @_;  # Get the remaining
  my $i;

  unless ($del_csr->execute($token[0])) {
    print "Update csr1 error - $token[0]\n";
    die $lda->errstr;
  }
  unless ($add_csr->execute(@token)) {
    for ($i=0; $i<@token; $i++) {
      print "$i $token[$i]\n";
    }
    die $lda->errstr;
  }
}  

return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################
