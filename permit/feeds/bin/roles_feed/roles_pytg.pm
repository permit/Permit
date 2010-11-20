###############################################################################
## NAME: roles_pytg.pm
##
## DESCRIPTION: Subroutines related to qualifier feed for 'PYTG' qualifiers
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
## Created 6/6/2005, Jim Repa.
## Modifed 2/12/2007 use warehouse tables instead of hrp1001 & hrp1000,
##          Jim Repa, Marina Korobko  
###############################################################################

package roles_pytg;
$VERSION = 1.0; 
$package_name = 'roles_pytg';

## Standard Roles Database Feed Package
use roles_base qw(UsageExit login_dbi_sql ScriptExit RolesLog RolesNotification ArchiveFile  find_max_actions_value2 ExecuteSQLCommands);
use roles_qual 
  qw(strip ProcessActions FixDescendents sort_actions fix_haschild);
use config('GetValue');

## Set Test Mode
$TEST_MODE = 1;		## Test Mode (1 == ON, 0 == OFF)
if ($TEST_MODE) {print "TEST_MODE is ON for $package_name.pm\n";}

## Initialize Oraperl Emulation Package
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
        $outfile = $datafile_dir . "pytg.warehouse";

	if ($TEST_MODE) {print "In $package_name:FeedExtract.\n";}

	shift; #Get rid of calling package name

	## Step 0: Check Arguments
	if ($#_ != 2) {&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
	#my($ftp_user, $ftp_pw, $ftp_machine) = @_;
	my ($user_id, $user_pw, $db_id) = @_;

#
#   Open output file.
#
  $outf = ">" . $outfile;
  if( !open(F2, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }

# 
   my  %orgid_has_tg = ();  # $orgid_has_tg{$org_id} is 1 if org has a Time Group

#
#  Make sure we are set up to use Oraperl.
#

#
#  No longer needed -- these parameters are passed to the program at run time.
#  Get parameters needed to open an Oracle connection to the Warehouse
#
 #my $db_parm = GetValue("warehouse"); # Info about Warehouse from config file
 #$db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
 #my $user_id  = $1;
 #my $user_pw  = $2;
 #my $db_id  = $3;
 
#
#  Open connection to oracle
#
 #print "db_id='$db_id' user_id='$user_id'\n";
$lda = login_dbi_sql($db_id,$user_id,$user_pw)
      || die "$DBI::errstr . \n";


#
# Get mapping of subdepartment (hr_org_unit_id) to its parent department
#  (hr_department_id)
#
 my $stmt2 = "select hr_org_unit_id, hr_department_id
              from wareuser.hr_org_unit
              where hr_org_unit_id <> hr_department_id";
 #print "stmt2= '" . $stmt2 . "'\n";
$csr2 = $lda->prepare($stmt2)
      || die "$DBI::errstr . \n";
$csr2->execute();


 my ($org_id, $dept_id);
 my %sub_org2dept_id = ();
 while ( ($org_id, $dept_id) = $csr2->fetchrow_array()  )
 {
   $sub_org2dept_id{$org_id} = $dept_id;
 }
 #foreach $org_id (keys %sub_org2dept_id) {
 #  print "sub_org $org_id -> $sub_org2dept_id{$org_id}\n";
 #}

 $csr2->finish();

#######################################################################################
# Get information on HR Org units
#
 my $stmt = "select o.node_id, o.parent_node_id,"
          . " substr(o.title, 1, 50),"
          . " o.node_level, rownum\n"
          . " from wareuser.whorg_unit_parent_child o\n" ## 1 ##
          . " where node_level <> '01'\n"
          . " and "
          . " (length(o.abbr) <> 9"
          . " or translate(o.abbr,'0123456789','**********') <> 'HR-******')\n"
          . " union"
          . " select o.node_id, o.parent_node_id, \n"
          . " substr(o.title, 1, 41) || ' (' || substr(o.abbr, 4, 6) || ')', "
          . " o.node_level, rownum\n"
          . " from wareuser.whorg_unit_parent_child o\n" ## 2 ##
          . " where length(o.abbr) = 9\n"
          . "and translate(o.abbr, '0123456789', '**********') = 'HR-******'\n"
          . " order by 1, 2";
 #print "stmt= '" . $stmt . "'\n";
 #exit();
  my $stmtm =" SELECT c.tg_code,a.hr_object_code tg_parent_object_code,b.tg_name1||' ('||b.tg_id||')' tg_name"
           ." FROM wareuser.whhr_object_relationship a,"
           ." (SELECT code tg_id, description tg_name1"
           ." FROM wareuser.hr_lookup"
           ." WHERE lookup_type = 'TGOBJ') b,"
           ." (SELECT code tg_id, description tg_code"
           ." FROM wareuser.hr_lookup"
           ." WHERE lookup_type = 'TGABBR') c"
           ." WHERE b.tg_id = c.tg_id"
           ." AND a.hr_object_relationship_code = 'AZD1'"
           ." AND a.hr_object_type = 'Organizational unit'"
           ." AND a.hr_related_object_type = 'Time Group'"
           ." AND a.hr_related_object_code = b.tg_id"
           ." AND SYSDATE BETWEEN a.hr_object_relation_start_date -30"
           ." AND a.hr_object_relation_end_date";


#  Write out a made-up record for the root of the PYTG tree
#
   printf F2 "%s!%s!%s!%s\n",
           'PYTG', '10000000', '', 'MIT-All';
#########
# Print out records for the Time Groups
#
my $qqualtype = 'PYTG';
 $csr1 = $lda->prepare($stmtm)
      || die "$DBI::errstr . \n";

 $csr1->execute();

while ( ($qqcode, $qparentcode, $qqname)
        = $csr1->fetchrow_array()  )
{
   ### Print out results only if the time group has a parent org unit
   if ($qparentcode) {
     # TYPE, CODE, PARCODE, NAME
     $orgid_has_tg{$qparentcode} = 1; 
     printf F2 "%s!%s!%s!%s\n",
             $qqualtype, $qqcode, $qparentcode, $qqname;
   }
 }
 $csr1->finish();

##########
#  Write out the records for the HR Org units.
#
#  If a unit is a sub-dept and it does not have a matching Time Group, then
#  do not include it in the output file.  This is an error situation, and we
#  want to make sure that the sub-dept is not shown in the Roles DB qualifier
#  hierarchy until it has been assigned a Time Group in SAP.
#
# my $qqualtype = 'PYTG';
 my $hide_org_unit = 0;
 $csr = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";

 $csr->execute();

 while ( ($qqcode, $qparentcode, $qqname, $qqsortorder, $qqrownum)
        =  $csr->fetchrow_array() )
 {
   #if (($i++)%5000 == 0) {print $i . "\n";}
   $hide_org_unit = 0;
   if ($sub_org2dept_id{$qqcode}) {
       $qqname =  substr('(sub-dept) ' . $qqname, 0, 50);
       if ($orgid_has_tg{$qqcode}) {
         $hide_org_unit = 0;
       }
       else {  # If sub-dept has no Time Group, then hide it.
         $hide_org_unit = 1;
       }
   }
   unless ($hide_org_unit == 1) {
     # TYPE, CODE, PARCODE, NAME
     printf F2 "%s!%s!%s!%s\n",
             $qqualtype, $qqcode, $qparentcode, $qqname;
   }
 }
 $csr->finish() || die "can't close cursor";

#

 close (F2);

 $lda->disconnect() || die "can't log off Oracle";

}

###############################################################################
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
	my($destination_lda) =  &login_dbi_sql($db_id, $user_id, $user_pw)
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

	my($infile) = $datafile_dir . "pytg.actions";
	my($sqlfile) = $datafile_dir . "pytgchange.sql";
	my($sqlfile2) = $datafile_dir . "pytgdesc.sql";
	my($qualtype) = "PYTG";

	## Step 0: Check Arguments
	if ($#_ != 2){&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
	my($user_id, $user_pw, $db_id) = @_;


	## Check number of actions to be preformed
      $MAX_ACTIONS = &find_max_actions_value2( $db_id, $user_id, $user_pw, "MAX_PYTG");


	#$MAX_ACTIONS = 200;  #This should be configurable
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
	#my($cmd) = "sqlplus $user_id/$user_pw\@$db_id \@$sqlfile";
	ExecuteSQLCommands($sqlfile,$destination_lda);


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
	#cmd = "sqlplus $user_id/$user_pw\@$db_id \@$sqlfile2";
        #print "cmd = '$cmd'\n";
	#$rc = system($cmd);
	#$rc >>= 8;
	#unless ($rc == 0) {
        #  print "Error return code $rc from 2nd sqlplus\n";
        #  die;
        #}
	ExecuteSQLCommands($sqlfile2,$destination_lda);


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
#  Use FTP to get wh-hrp1000 and wh-hrp1001 files from the Warehouse
#
#############################################################################

sub FTPFromWarehouse
{

 my($user_id, $user_pw, $ftp_machine, $data_dir) = @_;

 my(@files) = ('wh-hrp1000', 'wh-hrp1001');
 
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
#  Extract PYTG data from qualifier table of Roles DB.
#
########################################################################
sub ExistingExtract
{
my($lda, $data_dir) = @_;

$outfile = $data_dir . "pytg.roles";
$qqualtype = 'PYTG';
 
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
 my $stmt = ("select q2.qualifier_code, q.qualifier_id, q.qualifier_code as qcode," 
          . " q.qualifier_name, q.has_child" 
          . " from qualifier q, qualifier_child c, qualifier q2"
          . " where q.qualifier_id = c.child_id"
          . " and c.parent_id = q2.qualifier_id"
          . " and q.qualifier_type = '$qqualtype'"
          . " union"
          . " select '', qualifier_id, qualifier_code as qcode,"
          . " qualifier_name, has_child"
          . " from qualifier"
          . " where qualifier_level = 1 and qualifier_type = '$qqualtype'"
          . " order by qcode");
 $csr = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";
 $csr->execute();


 print "Reading in Qualifiers (type = '$qqualtype') from Oracle table...\n";
 $i = -1;
 while ((($qparentcode, $qqid, $qqcode, $qqname, $qhaschild) 
        =  $csr->fetchrow_array())) 
 {
   #if (($i++)%5000 == 0) {print $i . "\n";}
   push(@parentid, $qparentid);
   push(@qualcode, $qqcode);
   push(@qualname, $qqname);
   push(@haschild, $qhaschild);
   # TYPE, CODE, PARCODE, NAME
   printf F2 "%s!%s!%s!%s\n",
           $qqualtype, $qqcode, $qparentcode, $qqname;
 }
 $csr->finish()
	|| die "can't close cursor";
 
 close (F2);
 
}



##############################################################################
#
#  Find the differences in two files of new Org Units.
#  Process the differences to make it easier to do adds, deletes, and
#  updates to qualifier table in Roles DB.
#
##############################################################################
sub CompareExtract
{

my($data_dir) = @_;

my $file1 = $data_dir . "pytg.roles";
my $file2 = $data_dir . "pytg.warehouse";
my $diff_file = $data_dir . "pytg.diffs";
my $tempactions = $data_dir . "pytg.actions.temp";
my $actionsfile = $data_dir . "pytg.actions";
my $temp1 = $data_dir . "pytg1.temp";
my $temp2 = $data_dir . "pytg2.temp";
 
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
       . " sed 's/< PYTG/<\!PYTG/' |"    # Add ! field marker
       . " sed 's/> PYTG/>\!PYTG/' |"    # Add ! field marker
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
#   Reorder spending group actions
#

 unless(open(INFILE, "<" . $tempactions) ) {
    die "$0: can't open ($tempactions) - $!\n";
  }
 while ( chop($line = <INFILE>)) {
	push(@actions, $line);
 }
 close INFILE;

 sort_actions(\@actions);


 unless(open(ACTIONSFILE, ">" . $actionsfile) ) {
    die "$0: can't open ($actionsfile) - $!\n";
  }

 for ($i = 0; $i < @actions; $i++) {
   print ACTIONSFILE $actions[$i] . "\n";
 }

close ACTIONSFILE;

}

#########################################################################
#
# Subroutine read_from_hrp_files
#
#########################################################################

#########################################################################
#
# Function &add_a_month($yyyymmdd) 
#
# Returns a new date where either the month is incremented by 1 (if
# beginning month was 01 - 11) or with year incremented by 1.  
# We will only use this date to compare it with a date in HRP1000 or 1001.
# It is not important to count the number of days per month -- for comparison
# purposes, 20060231 is OK, even though February does not have 31 days.
#
#########################################################################
sub add_a_month {
 my ($yyyymmdd) = @_;
 my $yyyy = substr($yyyymmdd, 0, 4);
 my $mm = substr($yyyymmdd, 4, 2);
 my $dd = substr($yyyymmdd, 6, 2);
 if ($mm == 12) {
   $yyyy++;
 }
 else {
   $mm++;
 }
 my $new_yyyymmdd = $yyyy . substr("00$mm", -2, 2) . substr("00$dd", -2, 2);
 return $new_yyyymmdd;

}

return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################
