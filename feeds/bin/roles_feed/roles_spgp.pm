###############################################################################
## NAME: roles_spgp.pm
##
## DESCRIPTION: Subroutines related to qualifier feed for 'SPGP' qualifiers
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
## MODIFICATIO HISTORY:
## Created 6/30/1998
## Modified 8/25/1998, Jim Repa.  Handle 3 levels in custom FC hierarchy
## Modified 9/1/1998, Jim Repa. Handle upper case or mixed case names
## Modified 10/28/1998, Jim Repa. Handle 4 levels in custom FC hierarchy
## Modified 5/7/1999, Jim Repa. Increase MAXACTIONS limit from 150 to 300
## Modified 11/15/1999, Jim Repa. Handle 5 levels in custom FC hierarchy
## Modified 7/13/2007 M.Korobko
##   --  use table roles_parameters to find MAX_ACTIONS allowed
## Modified 11/13/2008, Jim Repa. Handle 2 more levels in custom FC hier
###############################################################################

package roles_spgp;
$VERSION = 1.0; 
$package_name = 'roles_spgp';

## Standard Roles Database Feed Package
#use roles_base qw(UsageExit ScriptExit RolesLog RolesNotification ArchiveFile);
use roles_base qw(UsageExit ScriptExit RolesLog RolesNotification ArchiveFile
                    find_max_actions_value login_dbi_sql find_max_actions_value2  ExecuteSQLCommands);
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
        $outfile = $datafile_dir . "spgp.warehouse";

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
#  Open connection to oracle
#
 my($lda) = login_dbi_sql($db_id, $user_id, $user_pw)
 	|| die $DBI::errstr;
 my $stmt = "select q2.qualifier_code qcode1, q3.qualifier_code qcode2, q3.qualifier_name"
          . " from qualifier q1, qualifier_child qc1, qualifier q2," ## 3rd level
          . " qualifier_child qc2, qualifier q3"
          . " where q1.qualifier_code = 'FC_CUSTOM'"
          . " and q1.qualifier_type = 'FUND'"
          . " and q1.qualifier_id = qc1.parent_id "
          . " and qc1.child_id = q2.qualifier_id"
          . " and q2.qualifier_id = qc2.parent_id"
          . " and q3.qualifier_id = qc2.child_id"
          . " and substr(q3.qualifier_code,1,3) = 'FC_'"
          . " union"
          . " select q3.qualifier_code qcode1, q4.qualifier_code qcode2, q4.qualifier_name"
          . " from qualifier q1, qualifier_child qc1,"  ## 4th level
          . " qualifier_child qc2, qualifier q3, qualifier_child qc3,"
          . " qualifier q4"
          . " where q1.qualifier_code = 'FC_CUSTOM'"
          . " and q1.qualifier_type = 'FUND'"
          . " and q1.qualifier_id = qc1.parent_id "
          . " and qc1.child_id = qc2.parent_id"
          . " and q3.qualifier_id = qc2.child_id"
          . " and q3.qualifier_id = qc3.parent_id"
          . " and q4.qualifier_id = qc3.child_id"
          . " and substr(q4.qualifier_code,1,3) = 'FC_'"
          . " union"
          . " select q4.qualifier_code qcode1, q5.qualifier_code qcode2, q5.qualifier_name"
          . " from qualifier q1, qualifier_child qc1,"  ## 5th level
          . " qualifier_child qc2, qualifier_child qc3,"
          . " qualifier q4, qualifier_child qc4, qualifier q5"
          . " where q1.qualifier_code = 'FC_CUSTOM'"
          . " and q1.qualifier_type = 'FUND'"
          . " and q1.qualifier_id = qc1.parent_id "
          . " and qc1.child_id = qc2.parent_id"
          . " and qc2.child_id = qc3.parent_id"
          . " and q4.qualifier_id = qc3.child_id"
          . " and q4.qualifier_id = qc4.parent_id"
          . " and q5.qualifier_id = qc4.child_id"
          . " and substr(q5.qualifier_code,1,3) = 'FC_'"
          . " union"
          . " select q5.qualifier_code qcode1, q6.qualifier_code qcode2, q6.qualifier_name"
          . " from qualifier q1, qualifier_child qc1,"  ## 6th level
          . " qualifier_child qc2, qualifier_child qc3, qualifier_child qc4,"
          . " qualifier q5, qualifier_child qc5, qualifier q6"
          . " where q1.qualifier_code = 'FC_CUSTOM'"
          . " and q1.qualifier_type = 'FUND'"
          . " and qc1.parent_id = q1.qualifier_id"
          . " and qc2.parent_id = qc1.child_id"
          . " and qc3.parent_id = qc2.child_id"
          . " and qc4.parent_id = qc3.child_id"
          . " and q5.qualifier_id = qc4.child_id"
          . " and qc5.parent_id = q5.qualifier_id"
          . " and q6.qualifier_id = qc5.child_id"
          . " and substr(q6.qualifier_code,1,3) = 'FC_'"
          . " union"
          . " select q6.qualifier_code qcode1, q7.qualifier_code qcode2, q7.qualifier_name"
          . " from qualifier q1, qualifier_child qc1,"  ## 7th level
          . " qualifier_child qc2, qualifier_child qc3, qualifier_child qc4,"
          . " qualifier_child qc5, qualifier q6,"
          . " qualifier_child qc6, qualifier q7"
          . " where q1.qualifier_code = 'FC_CUSTOM'"
          . " and q1.qualifier_type = 'FUND'"
          . " and qc1.parent_id = q1.qualifier_id"
          . " and qc2.parent_id = qc1.child_id"
          . " and qc3.parent_id = qc2.child_id"
          . " and qc4.parent_id = qc3.child_id"
          . " and qc5.parent_id = qc4.child_id"
          . " and q6.qualifier_id = qc5.child_id"
          . " and qc6.parent_id = q6.qualifier_id"
          . " and q7.qualifier_id = qc6.child_id"
          . " and substr(q7.qualifier_code,1,3) = 'FC_'"
          . " union"
          . " select q7.qualifier_code qcode1, q8.qualifier_code qcode2, q8.qualifier_name"
          . " from qualifier q1, qualifier_child qc1,"  ## 8th level
          . " qualifier_child qc2, qualifier_child qc3, qualifier_child qc4,"
          . " qualifier_child qc5,"
          . " qualifier_child qc6, qualifier q7,"
          . " qualifier_child qc7, qualifier q8"
          . " where q1.qualifier_code = 'FC_CUSTOM'"
          . " and q1.qualifier_type = 'FUND'"
          . " and qc1.parent_id = q1.qualifier_id"
          . " and qc2.parent_id = qc1.child_id"
          . " and qc3.parent_id = qc2.child_id"
          . " and qc4.parent_id = qc3.child_id"
          . " and qc5.parent_id = qc4.child_id"
          . " and qc6.parent_id = qc5.child_id"
          . " and q7.qualifier_id = qc6.child_id"
          . " and qc7.parent_id = q7.qualifier_id"
          . " and q8.qualifier_id = qc7.child_id"
          . " and substr(q8.qualifier_code,1,3) = 'FC_'"
          . " union"
          . " select q1.qualifier_code qcode1, q2.qualifier_code qcode2, q2.qualifier_name"
          . " from qualifier q1, qualifier_child qc1, qualifier q2" ## 2nd level
          . " where q1.qualifier_code = 'FC_CUSTOM'"
          . " and q1.qualifier_type = 'FUND'"
          . " and q1.qualifier_id = qc1.parent_id"
          . " and qc1.child_id = q2.qualifier_id"
          . " order by qcode1, qcode2";
 $csr = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";

 $csr->execute();

#
#  Write out a made-up record for the root of the SPGP tree
#
   printf F2 "%s!%s!%s!%s\n",
           'SPGP', 'SG_ALL', '', 'All Spending Groups';

#
#  Look in qualifier table, qualifier_type='FUND', for
#  children of FC_CUSTOM, and children of those children.
#
 print "Reading in Custom Fund Groups from Oracle table...\n";
 $i = -1;
 while (($qqparcode, $qqcode, $qqname) = $csr->fetchrow_array()) {
   $qqparcode =~ s/^FC_CUSTOM/SG_ALL/;
   $qqparcode =~ s/^FC/SG/;
   $qqcode =~ s/^FC/SG/;
   $qqname =~ s/Custom Fund Center Group/Spending Group/;
   $qqname =~ s/CUSTOM FUND CENTER GROUP/SPENDING GROUP/;
   $qqname =~ s/Fund Center Group/Spending Group/;
   $qqname =~ s/FUND CENTER GROUP/SPENDING GROUP/;
   printf F2 "%s!%s!%s!%s\n",
           'SPGP', $qqcode, $qqparcode, $qqname;
 }
 $csr->finish() || die "can't close cursor";
 
 close (F2);
 
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

	my($infile) = $datafile_dir . "spgp.actions";
	my($sqlfile) = $datafile_dir . "spgpchange.sql";
	my($sqlfile2) = $datafile_dir . "spgpdesc.sql";
	my($qualtype) = "SPGP";

	## Step 0: Check Arguments
	if ($#_ != 2){&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
	my($user_id, $user_pw, $db_id) = @_;


	## Check number of actions to be preformed
        $MAX_ACTIONS = &find_max_actions_value2( $db_id,$user_id, $user_pw, "MAX_SPGP");
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




########################################################################
#
#  Extract SPGP data from qualifier table of Roles DB.
#
########################################################################
sub ExistingExtract
{
my($lda, $data_dir) = @_;

$outfile = $data_dir . "spgp.roles";
$qqualtype = 'SPGP';
 
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
 my $stmt = "select q2.qualifier_code, q.qualifier_id, q.qualifier_code qcode," 
          . " q.qualifier_name, q.has_child" 
          . " from qualifier q, qualifier_child c, qualifier q2"
          . " where q.qualifier_id = c.child_id"
          . " and c.parent_id = q2.qualifier_id"
          . " and q.qualifier_type = '$qqualtype'"
          . " union"
          . " select '', qualifier_id, qualifier_code qcode,"
          . " qualifier_name, has_child"
          . " from qualifier"
          . " where qualifier_level = 1 and qualifier_type = '$qqualtype'"
          . " order by  qcode";
 my $csr = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";

 $csr->execute();

 print "Reading in Qualifiers (type = '$qqualtype') from Oracle table...\n";
 $i = -1;
 while ((($qparentcode, $qqid, $qqcode, $qqname, $qhaschild) 
        = $csr->fetchrow_array())) 
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
 $csr->finish() || die "can't close cursor";
 
 close (F2);
 
}



##############################################################################
#
#  Find the differences in two files of spending groups.
#  Process the differences to make it easier to do adds, deletes, and
#  updates to qualifier table in Roles DB.
#
##############################################################################
sub CompareExtract
{

my($data_dir) = @_;

my $file1 = $data_dir . "spgp.roles";
my $file2 = $data_dir . "spgp.warehouse";
my $diff_file = $data_dir . "spgp.diffs";
my $tempactions = $data_dir . "spgp.actions.temp";
my $actionsfile = $data_dir . "spgp.actions";
my $temp1 = $data_dir . "spgp1.temp";
my $temp2 = $data_dir . "spgp2.temp";
 
$ENV{'LANG'}='C';
$ENV{'LC-COLLATE'}='C';

print "Sorting first file...\n";
system("sort -t '!' -k 1,2 -o $temp1 $file1\n");
print "Sorting 2nd file...\n";
system("sort -t '!' -k 1,2 -o $temp2 $file2\n");
 
 
print "Comparing files $file1 and $file2...\n";
system("diff $temp1 $temp2 |"            # Find differences in two files
       . " grep '^[><]' |"               # Select only added/deleted lines
       . " sed 's/< SPGP/<\!SPGP/' |"    # Add ! field marker
       . " sed 's/> SPGP/>\!SPGP/' |"    # Add ! field marker
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

return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################
