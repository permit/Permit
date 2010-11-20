
###############################################################################
## NAME: roles_mdeptlink.pm
##
## DESCRIPTION: Subroutines related to the table 
##                    mdept$owner.expanded_object_link
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
## Created 10/03/2005, Jim Repa
## Modified 12/15/2005.  Fix the SELECT statement for ORGU.
## Modified 1/11/2006. Add another column to the table, linked_by_object_code
## Modified 6/14/2006. Fix statement that included REPLACE(x, 'SG', 'FC') 
##                      to REPLACE(x, 'SG_', 'FC_') so that it could handle
##                      a spending group code containing SG (e.g., SG_ESG).
## Modified 1/25/2007. Add PBM -> PBM1 (object_type and qualifier_type)
###############################################################################

package roles_mdeptlink;
$VERSION = 1.0; 
$package_name = 'roles_mdeptlink';

## Standard Roles Database Feed Package
use roles_base qw(UsageExit ScriptExit RolesLog RolesNotification ArchiveFile  login_dbi_sql find_max_actions_value2  ExecuteSQLCommands);
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
        $outfile = $datafile_dir . "mdeptlink.warehouse";

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


##
#  1. First, get the special DLC parent/child links and put the results
#     into a hash.
#  2. Define an array of SELECT statements for the various object link types.
#  3. Loop through each of the SELECT statements, preparing each statement
#     and reading in records,  writing the results to a flat file.
##

#
#  Open connection to oracle.  Prepare a select statement to get 
#  parent-child pairs for "limited" DLCs.
#
print "roles_mdeptlink DB:'$db_id' User:'$user_id'";

 my($lda) = login_dbi_sql($db_id, $user_id, $user_pw)
  	|| die $DBI::errstr;
 my $stmt0 = "select d1.dept_id, d2.dept_id
             from department d1, department_child dc, department d2
             where d1.dept_type_id in (2, 4, 5)
             and dc.parent_id = d1.dept_id
             and d2.dept_id = dc.child_id
             and d2.dept_type_id in (2, 4, 5)";
 my $csr0 = $lda->prepare($stmt0)
      || die "$DBI::errstr . \n";

 $csr0->execute();

#
#  Read in limited DLC parent-child pairs and build a hash 
#  %dlc_child2parent 
#    where $dlc_child_2parent{$child_dept_id}
#          = "$parent_dept_id1!$parent_dept_id2!..."  
#
 print "Reading in limited DLC parent-child pairs...\n";
 my %dlc_child2parent = ();
 my $delim1 = "!";
 my ($parent_id, $child_id);
 while ( ($parent_id, $child_id) = $csr0->fetchrow_array()) {
    if ($dlc_child2parent{$child_id}) {
       $dlc_child2parent{$child_id} .= "$delim1$parent_id";
    }
    else {
       $dlc_child2parent{$child_id} = $parent_id;
    }
    print "$child_id -> $dlc_child2parent{$child_id}\n";
 }
 $csr0->finish() || die "can't close cursor";

#
#  Define SELECT statements for each object type.
#
 my %sql_stmt = ();
 $sql_stmt{'ORGU'} =
   "select ol.dept_id, 'ORGU', q1.qualifier_code, q1.qualifier_code
     from object_link ol, rolesbb.qualifier q1
     where ol.object_type_code = 'ORGU'
     and q1.qualifier_code = ol.object_code 
     and q1.qualifier_type = 'ORGU'
    union select /*+ ORDERED */ ol.dept_id, 'ORGU', q2.qualifier_code, 
                                q1.qualifier_code
     from object_link ol, 
       rolesbb.qualifier q1, rolesbb.qualifier_descendent qd, rolesbb.qualifier q2
     where ol.object_type_code = 'ORGU'
     and q1.qualifier_code = ol.object_code
     and q1.qualifier_type = 'ORGU'
     and qd.parent_id = q1.qualifier_id
     and q2.qualifier_id = qd.child_id
    order by 1, 3, 4";

 $sql_stmt{'ORG2'} = 
   "select ol.dept_id, 'ORG2', q1.qualifier_code, q1.qualifier_code
     from object_link ol, rolesbb.qualifier q1
     where object_type_code = 'ORG2'
     and q1.qualifier_code = ol.object_code 
     and q1.qualifier_type = 'ORG2'
    union select /*+ ORDERED */ ol.dept_id, 'ORG2', q2.qualifier_code,
                                q1.qualifier_code
     from object_link ol, 
       rolesbb.qualifier q1, rolesbb.qualifier_descendent qd, rolesbb.qualifier q2
     where ol.object_type_code = 'ORG2'
     and q1.qualifier_code = ol.object_code
     and q1.qualifier_type = 'ORG2'
     and qd.parent_id = q1.qualifier_id
     and q2.qualifier_id = qd.child_id
    order by 1, 3, 4";

 $sql_stmt{'PBM'} = 
   "select ol.dept_id, 'PBM', q1.qualifier_code, q1.qualifier_code
     from object_link ol, rolesbb.qualifier q1
     where object_type_code = 'PBM'
     and q1.qualifier_code = ol.object_code 
     and q1.qualifier_type = 'PBM1'
    union select /*+ ORDERED */ ol.dept_id, 'PBM', q2.qualifier_code,
                                q1.qualifier_code
     from object_link ol, 
       rolesbb.qualifier q1, rolesbb.qualifier_descendent qd, rolesbb.qualifier q2
     where ol.object_type_code = 'PBM'
     and q1.qualifier_code = ol.object_code
     and q1.qualifier_type = 'PBM1'
     and qd.parent_id = q1.qualifier_id
     and q2.qualifier_id = qd.child_id
    order by 1, 3, 4";

 $sql_stmt{'LORG'} = 
   "select ol.dept_id, 'LORG', q1.qualifier_code, q1.qualifier_code
     from object_link ol, rolesbb.qualifier q1
     where ol.object_type_code = 'LORG'
     and q1.qualifier_code = ol.object_code
     and q1.qualifier_type = 'LORG'
    union /*+ ORDERED */ select ol.dept_id, 'LORG', q2.qualifier_code,
                                q1.qualifier_code
     from object_link ol, 
       rolesbb.qualifier q1, rolesbb.qualifier_descendent qd, rolesbb.qualifier q2
     where ol.object_type_code = 'LORG'
     and q1.qualifier_code = ol.object_code
     and q1.qualifier_type = 'LORG'
     and qd.parent_id = q1.qualifier_id
     and q2.qualifier_id = qd.child_id
    order by 1, 3, 4";

 $sql_stmt{'SIS'} = 
   "select ol.dept_id, 'SIS', q1.qualifier_code, q1.qualifier_code
     from object_link ol, rolesbb.qualifier q1
     where ol.object_type_code = 'SIS'
     and q1.qualifier_code = ol.object_code
     and q1.qualifier_type = 'SISO'
   union /*+ ORDERED */ select ol.dept_id, 'SIS', q2.qualifier_code,
                                q1.qualifier_code
     from object_link ol, rolesbb.qualifier q1, rolesbb.qualifier_descendent qd, 
       rolesbb.qualifier q2
     where ol.object_type_code = 'SIS'
     and q1.qualifier_code = ol.object_code
     and q1.qualifier_type = 'SISO'
     and qd.parent_id = q1.qualifier_id
     and q2.qualifier_id = qd.child_id
   order by 1, 3, 4";

 $sql_stmt{'BAG'} = 
   "select /*+ ORDERED */ ol.dept_id, 'BAG', q1.qualifier_code, 
                          q1.qualifier_code
     from object_link ol, rolesbb.qualifier q1
     where ol.object_type_code = 'BAG'
     and q1.qualifier_code = ol.object_code
     and q1.qualifier_type = 'BAGS'
   union /*+ ORDERED */ select ol.dept_id, 'BAG', q2.qualifier_code,
                                q1.qualifier_code
     from object_link ol, rolesbb.qualifier q1, rolesbb.qualifier_descendent qd, 
       rolesbb.qualifier q2
     where ol.object_type_code = 'BAG'
     and q1.qualifier_code = ol.object_code
     and q1.qualifier_type = 'BAGS'
     and qd.parent_id = q1.qualifier_id
     and q2.qualifier_id = qd.child_id
   order by 1, 3, 4";

 $sql_stmt{'PMIT'} = 
  "select ol.dept_id, 'PMIT', replace(q1.qualifier_code, 'PC', 'P'),
          replace(q1.qualifier_code, 'PC', 'P')
      from object_link ol, rolesbb.qualifier q1
      where ol.object_type_code = 'PMIT'
      and q1.qualifier_code = replace(object_code, 'P', 'PC')
      and q1.qualifier_type = 'PMIT'
      and q1.qualifier_code between 'PC000000' and 'PC999999'
      and q1.has_child = 'N'
   union select ol.dept_id, 'PMIT', q1.qualifier_code, q1.qualifier_code
      from object_link ol, rolesbb.qualifier q1
      where ol.object_type_code = 'PMIT'
      and q1.qualifier_code = ol.object_code
      and q1.qualifier_type = 'PMIT'
      and q1.qualifier_code like 'PCMIT%'
   union select /*+ ORDERED */ ol.dept_id, 
        'PMIT', replace(q2.qualifier_code, 'PC', 'P'), q1.qualifier_code
      from object_link ol, 
       rolesbb.qualifier q1, rolesbb.qualifier_descendent qd, rolesbb.qualifier q2
      where ol.object_type_code = 'PMIT' 
      and q1.qualifier_code = ol.object_code
      and q1.qualifier_type = 'PMIT'
      and qd.parent_id = q1.qualifier_id
      and q2.qualifier_id = qd.child_id
      and q2.qualifier_code between 'PC000000' and 'PC999999'
      and q2.has_child = 'N'
   union select /*+ ORDERED */ ol.dept_id, 
        'PMIT', q2.qualifier_code, q1.qualifier_code
      from object_link ol, 
       rolesbb.qualifier q1, rolesbb.qualifier_descendent qd, rolesbb.qualifier q2
      where ol.object_type_code = 'PMIT' 
      and q1.qualifier_code = ol.object_code
      and q1.qualifier_type = 'PMIT'
      and qd.parent_id = q1.qualifier_id
      and q2.qualifier_id = qd.child_id
      and q2.qualifier_code like 'PCMIT%'
   order by 1, 3, 4";

 $sql_stmt{'PC'} = 
  "select ol.dept_id, 'PC', 
          replace(replace(q1.qualifier_code, 'PC', 'P'), '0H', '0'),
          replace(replace(q1.qualifier_code, 'PC', 'P'), '0H', '0')
     from object_link ol, rolesbb.qualifier q1
     where ol.object_type_code = 'PC' 
     and q1.qualifier_code = replace(replace(object_code,'P','PC'),'0P','0HP')
     and q1.qualifier_type = 'COST'
     and (q1.qualifier_code like 'PC%' or q1.qualifier_code like '0HPC%')
   union select /*+ ORDERED */ distinct
     ol.dept_id, 'PC', 
       replace(replace(q2.qualifier_code, 'PC', 'P'), '0H', '0'),
       replace(replace(q1.qualifier_code, 'PC', 'P'), '0H', '0')
     from object_link ol,
       rolesbb.qualifier q1, rolesbb.qualifier_descendent qd, rolesbb.qualifier q2
     where q1.qualifier_code = replace(ol.object_code, '0P', '0HPC')
     and ol.object_type_code = 'PC'
     and ol.object_code like '0P%'
     and q1.qualifier_type = 'COST'
     and qd.parent_id = q1.qualifier_id
     and q2.qualifier_id = qd.child_id
     and q2.qualifier_code like 'PC%'
   union select /*+ ORDERED */ 
     ol.dept_id, 'PC', 
      replace(q2.qualifier_code, '0HPC', '0P'),
      replace(q1.qualifier_code, '0HPC', '0P')
     from object_link ol,
       rolesbb.qualifier q1, rolesbb.qualifier_descendent qd, rolesbb.qualifier q2
     where q1.qualifier_code = replace(ol.object_code, '0P', '0HPC')
     and ol.object_type_code = 'PC'
     and ol.object_code like '0P%'
     and q1.qualifier_type = 'COST'
     and qd.parent_id = q1.qualifier_id
     and q2.qualifier_id = qd.child_id
     and q2.qualifier_code like '0HPC%'
   order by 1, 3, 4";

 $sql_stmt{'FC'} = 
  "select /*+ ORDERED */ distinct ol.dept_id, 'FC', q1.qualifier_code, 
                                  q1.qualifier_code
     from object_link ol, 
       rolesbb.qualifier q1
     where ol.object_type_code = 'FC'
     and q1.qualifier_code = ol.object_code
     and q1.qualifier_type = 'FUND'
     and q1.qualifier_code between 'FC000000' and 'FC999999'
   union select /*+ ORDERED */ distinct ol.dept_id, 'FC', q2.qualifier_code,
                                  q1.qualifier_code
     from object_link ol,
      rolesbb.qualifier q1, rolesbb.qualifier_descendent qd, rolesbb.qualifier q2
     where ol.object_type_code = 'FC'
     and q1.qualifier_code = ol.object_code
     and q1.qualifier_type = 'FUND'
     and qd.parent_id = q1.qualifier_id
     and q2.qualifier_id = qd.child_id
     and q2.qualifier_code between 'FC000000' and 'FC999999'
   union select /*+ ORDERED */ distinct ol.dept_id, 'FC', q1.qualifier_code,
                               q1.qualifier_code
     from object_link ol, 
       rolesbb.qualifier q1
     where ol.object_type_code = 'SPGP'
     and q1.qualifier_code = replace(ol.object_code, 'SG_', 'FC_')
     and q1.qualifier_type = 'FUND'
     and q1.qualifier_code like 'FC%'
   union select  distinct ol.dept_id, 'FC', q2.qualifier_code,
                               q1.qualifier_code
     from object_link ol,
      rolesbb.qualifier q1, rolesbb.qualifier_descendent qd, rolesbb.qualifier q2
     where ol.object_type_code = 'SPGP'
     and q1.qualifier_code = replace(ol.object_code, 'SG_', 'FC_')
     and q1.qualifier_type = 'FUND'
     and qd.parent_id = q1.qualifier_id
     and q2.qualifier_id = qd.child_id
     and q2.qualifier_code like 'FC%'
   order by 1, 3, 4";

 $sql_stmt{'SPGP'} = 
  "select  distinct ol.dept_id, 'SPGP', q1.qualifier_code,
                                  q1.qualifier_code
     from object_link ol, rolesbb.qualifier q1
     where ol.object_type_code = 'SPGP'
     and q1.qualifier_code = ol.object_code
     and q1.qualifier_type = 'SPGP'
   union select distinct ol.dept_id, 'SPGP', q2.qualifier_code,
                                        q1.qualifier_code
     from object_link ol,
       rolesbb.qualifier q1, rolesbb.qualifier_descendent qd, rolesbb.qualifier q2
     where ol.object_type_code = 'SPGP'
     and q1.qualifier_code = ol.object_code 
     and q1.qualifier_type = 'SPGP'
     and qd.parent_id = q1.qualifier_id
     and q2.qualifier_id = qd.child_id
   order by 1, 3, 4";

#
#  For each select statement in the hash, prepare it, read in and write 
#  out the results, and close it.
#
 my $obj_type;
 my $stmt;
 my ($dept_id, $obj_type_code, $obj_code, $link_by_code);
 foreach $obj_type (sort keys %sql_stmt) {
   print "Reading in object links for object_type $obj_type...\n";
 my $csr = $lda->prepare($sql_stmt{$obj_type})
      || die "$DBI::errstr . \n";

 $csr->execute();

   while ( ($dept_id, $obj_type_code, $obj_code, $link_by_code) 
           = $csr->fetchrow_array()) {
     printf F2 "%s!%s!%s!%s!%s\n",
           'MDEPTLINK', $dept_id, $obj_type_code, $obj_code, $link_by_code;
     #print F2 "$dept_id -> $dlc_child2parent{$dept_id} \n";
     foreach $parent_id ( split($delim1, $dlc_child2parent{$dept_id}) ) {
       printf F2 "%s!%s!%s!%s!%s\n",
           'MDEPTLINK', $parent_id, $obj_type_code, $obj_code, $link_by_code;
     }
   }
   $csr->finish() || die "can't close cursor";
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

	my($infile) = $datafile_dir . "mdeptlink.actions";
	my($sqlfile) = $datafile_dir . "mdeptlinkchange.sql";

	## Step 0: Check Arguments
	if ($#_ != 2){&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
	my($user_id, $user_pw, $db_id) = @_;


	## Check number of actions to be preformed
 	$MAX_ACTIONS = &find_max_actions_value2( $db_id, $user_id, $user_pw, "MAX_MDEPTLINK");


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
        #print "user='$user_id pw='$user_pw' db='$db_id'\n";
	ExecuteSQLCommands($sqlfile,$destination_lda);
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
#  Extract data from the table mdept$owner.expanded_object_link
#
########################################################################
sub ExistingExtract
{
my($lda, $data_dir) = @_;

$outfile = $data_dir . "mdeptlink.roles";
 
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
 my $stmt = "select dept_id, object_type_code, object_code, link_by_object_code
               from expanded_object_link
               order by 1, 2, 3, 4";
 my $csr = $lda->prepare($stmt)
        || die $DBI::errstr;
 $csr->execute()
        || die $DBI::errstr;

 print "Reading in existing records from expanded_object_link table...\n";
 $i = -1;
 my $type_constant = 'MDEPTLINK';
 my ($dept_id, $obj_type_code, $obj_code, $link_by_code);
 while ( ($dept_id, $obj_type_code, $obj_code, $link_by_code) 
         = $csr->fetchrow_array() )
 {
   #if (($i++)%5000 == 0) {print $i . "\n";}
   # CONSTANT, dept_id, obj_type_code, obj_code
   printf F2 "%s!%s!%s!%s!%s\n",
           $type_constant, $dept_id, $obj_type_code, $obj_code, $link_by_code;
 }
 $csr->finish() || die "can't close cursor";
 
 close (F2);
 
}



##############################################################################
#
#  Find the differences in two files of Depts. and linked object codes.
#  Process the differences to make it easier to do adds, deletes, and
#  updates to EXPANDED_OBJECT_LINK table within the Master Dept. Hierarchy.
#
##############################################################################
sub CompareExtract
{

my($data_dir) = @_;

my $file1 = $data_dir . "mdeptlink.roles";
my $file2 = $data_dir . "mdeptlink.warehouse";
my $diff_file = $data_dir . "mdeptlink.diffs";
my $tempactions = $data_dir . "mdeptlink.actions.temp";
my $actionsfile = $data_dir . "mdeptlink.actions";
my $temp1 = $data_dir . "mdeptlink1.temp";
my $temp2 = $data_dir . "mdeptlink2.temp";
 
#For Linux, sort command, this env setting will make the sorting based on ASCII instead of Dictionary.
$ENV{'LANG'}='C';
$ENV{'LC-COLLATE'}='C';

print "Sorting first file...\n";
system("sort -t '!' -o $temp1 $file1\n");
print "Sorting 2nd file...\n";
system("sort -t '!' -u -o $temp2 $file2\n");
 
 
print "Comparing files $file1 and $file2...\n";
system("diff $temp1 $temp2 |"            # Find differences in two files
       . " grep '^[><]' |"               # Select only added/deleted lines
       . " sed 's/< MDEPTLINK/<\!MDEPTLINK/' |"    # Add ! field marker
       . " sed 's/> MDEPTLINK/>\!MDEPTLINK/' |"    # Add ! field marker
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
 my ($junk, $dept_id, $obj_type, $obj_code, $link_by_code);
 my $i = 0;
 print "Reading records from differences file...\n";
 while (chop($line = <IN>)) {
   if (($i++)%1000 == 0) {print $i . "\n";}
   ($oldnew, $junk, $dept_id, $obj_type, $obj_code, $link_by_code) 
       = split('!', $line);
   #print "$oldnew - $junk - $dept_id - $obj_type - $obj_code\n";
   if ($oldnew eq '<') {
     print ACTIONSFILE "DELETE!$dept_id!$obj_type!$obj_code!$link_by_code\n";
   }
   else {
     print ACTIONSFILE "ADD!$dept_id!$obj_type!$obj_code!$link_by_code\n";
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
  #print F3 "/* Updates generated " . $today . " */\n";
  #print F3 "set define off;\n";
  #print F3 "whenever sqlerror exit -1 rollback;\n";  # Halt on errors.
 
#
#  Read the input file.  
#  Look for ADD and DELETE records.
#  Write SQL statements (INSERT and DELETE) to $sqlfile.
#  
 unless (open(IN,$infile)) {
   die "Cannot open $infile for reading\n"
 }
 my $i = 0;
 my ($action, $dept_id, $obj_type, $obj_code, $link_by_code);
 printf "Reading in the file $infile...\n";
 while ( (chop($line = <IN>)) && ($i++ < 999999) ) {
   #print "$i $line\n";
   ($action, $dept_id, $obj_type, $obj_code, $link_by_code) 
     = split("!", $line);   # Split into 5 fields (for ADD records)
   if ($action eq 'ADD') {
      print F3 
       "insert into expanded_object_link (DEPT_ID, OBJECT_TYPE_CODE, OBJECT_CODE, LINK_BY_OBJECT_CODE)  values ('$dept_id', '$obj_type', '$obj_code', '$link_by_code');\n"; 
   }
   elsif ($action eq 'DELETE') {
      print F3 
       "delete from expanded_object_link where dept_id = '$dept_id' and object_type_code = '$obj_type' and object_code = '$obj_code' and link_by_object_code = '$link_by_code';\n";
   }
 }

 #print F3 "commit;\n";  # If no errors, commit work.
 #print F3 "quit;\n";    # Exit from SQLPLUS

 close(IN);
 close(F3);
 
}  ## End of Process MDEPT Actions

return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################
