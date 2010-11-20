###############################################################################
## NAME: roles_dept.pm
##
## DESCRIPTION: Subroutines related to qualifier feed for 'DEPT' qualifiers.
##              As of 2006, these qualifiers will be extracted from the
##              Master Department Hierarchy tables.
##
#
#  Copyright (C) 2006-2010 Massachusetts Institute of Technology
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
## Created 11/09/2006
## Modified 1/26/2009  Get max_actions value from a table.
###############################################################################

package roles_dept;
$VERSION = 1.0; 
$package_name = 'roles_dept';

## Standard Roles Database Feed Package
use roles_base qw(UsageExit login_dbi_sql ScriptExit RolesLog RolesNotification ArchiveFile
                     find_max_actions_value2 ExecuteSQLCommands);
use roles_qual 
    qw(strip ProcessActions FixDescendents sort_actions fix_haschild);
use config('GetValue');

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
        $outfile = $datafile_dir . "dept.warehouse";

	if ($TEST_MODE) {print "In $package_name:FeedExtract.\n";}

	shift; #Get rid of calling package name

	## Step 0: Check Arguments
	if ($#_ != 2) {&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
	my($user_id, $user_pw, $db_id) = @_;

#
#  Connect to the Roles DB, and build a hash mapping Qualifier Codes 
#  to Qualifier Names, to be used later.
#
  my %qualcode2name = ();
  &get_qualcode_names(\%qualcode2name);

#
#   Open output file.
#
  $outf = ">" . $outfile;
  if( !open(F2, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }

#
#  Open connection to MDH oracle database
#
 #print "db_id='$db_id' user_id='$user_id'\n";
 my($lda) = login_dbi_sql($db_id, $user_id, $user_pw)
 	|| die $DBI::errstr;

#
#  Open the first select statement, for DLCs
#
 my $table_owner = 'mdept$owner';
 my $view_type = 'A'; # This is the View Type code used for Roles DEPT objects
 #my $stmt = "select d2.d_code, d1.d_code, d1.long_name
 # from ${table_owner}.view_type vt, ${table_owner}.dept_descendent dd,
 #      ${table_owner}.department d1, ${table_owner}.department_child dc, 
 #      ${table_owner}.department d2, ${table_owner}.view_type_to_subtype vtst
 # where vt.view_type_code = 'A'
 # and dd.view_type_code = vt.view_type_code
 # and dd.parent_id = vt.root_dept_id
 # and d1.dept_id = dd.child_id
 # and dc.parent_id = d2.dept_id
 # and d1.dept_id = dc.child_id
 # and d1.d_code <> 'D_UNDEF'
 # and vtst.view_type_code = vt.view_type_code
 # and dc.view_subtype_id = vtst.view_subtype_id
 # order by 2, 1";
 my $stmt = "select parent_d_code, d_code, long_name
  from ${table_owner}.wh_dlc_hierarchy
  where view_type_code = '$view_type'
  /* and d_code not in ('D_UNDEF_DEFUNCT', 'D_UNDEF', 'D_DEFUNCT') */
  order by d_code, parent_d_code";
 #print "'$stmt'\n";
 my $csr = $lda->prepare($stmt)
 	|| die $DBI::errstr;
 $csr->execute();
 
#
#  Write out a made-up record for the root of the DEPT tree
#
   printf F2 "%s!%s!%s!%s\n",
           'DEPT', 'D_ALL', '', 'All Departments';

#
#  Look in Master Department Hierarchy tables for DEPT objects
#
 print "Reading in DEPT objects from Oracle table...\n";
 $i = -1;
 my ($qqparcode, $qqcode, $qqname);
 while (($qqparcode, $qqcode, $qqname) = $csr->fetchrow_array()) {
   printf F2 "%s!%s!%s!%s\n",
           'DEPT', $qqcode, $qqparcode, $qqname;
 }
 $csr->finish() || die "can't close cursor";
 
 
#
#  Open the 2nd select statement, for objects linked to DLCs
#

 #$stmt = "select distinct ot.roles_qualifier_type, 
#  decode(xl.object_type_code,
#          'PC', replace(replace(xl.link_by_object_code,'0P','0HP'), 'P', 'PC'),
#          'PMIT', replace(replace(xl.link_by_object_code,'P','PC'),'PCC','PC'),
#          'SIS', 'SIS_' || xl.link_by_object_code,  
#          'LORG', decode(length(xl.link_by_object_code), 6, 
#                         decode(substr(xl.link_by_object_code,1,3), '0HL', 
#                                xl.link_by_object_code,
#                                'LDS_' || xl.link_by_object_code), 
#                         xl.link_by_object_code),
#          xl.link_by_object_code) obj_code,
#  decode(xl.object_type_code,
#          'PC', replace(replace(xl.link_by_object_code,'0P','0HP'), 'P', 'PC'),
#          'PMIT', replace(replace(xl.link_by_object_code,'P','PC'),'PCC','PC'),
#          xl.link_by_object_code) roles_qual_code,
#  xl.d_code, 'zzzz'
#  from wh_expanded_object_link xl, object_type ot
#  where xl.view_type_code = '$view_type'
#  and ot.object_type_code = xl.object_type_code
#  /* and xl.d_code not in ('D_UNDEF_DEFUNCT', 'D_UNDEF', 'D_DEFUNCT') */
#  union select distinct ot.roles_qualifier_type, 
#  decode(ol.object_type_code,
#          'PC', replace(replace(ol.object_code,'0P','0HP'), 'P', 'PC'),
#          'PMIT', replace(replace(ol.object_code,'P','PC'),'PCC','PC'),
#          'SIS', 'SIS_' || ol.object_code,  
#          'LORG', decode(length(ol.object_code), 6, 
#                         decode(substr(ol.object_code,1,3), '0HL', 
#                                ol.object_code,
#                                'LDS_' || ol.object_code), 
#                         ol.object_code),
#          ol.object_code) obj_code,
#  decode(ol.object_type_code,
#          'PC', replace(replace(ol.object_code,'0P','0HP'), 'P', 'PC'),
#          'PMIT', replace(replace(ol.object_code,'P','PC'),'PCC','PC'),
#          ol.object_code) roles_qual_code,
#  d.d_code, 'zzzz'
# from object_link ol, department d, object_type ot
# where d.dept_id = ol.dept_id
# and ot.object_type_code = ol.object_type_code
# and d.dept_type_id in 
#  (select dept_type_id from dept_node_type
#   minus select leaf_dept_type_id from view_to_dept_type
#     where view_type_code = '$view_type')
# and exists 
#  (select dh.d_code 
#   from wh_dlc_hierarchy dh
#   where dh.d_code = d.d_code
#   and dh.view_type_code = '$view_type')
#  order by 4, 2, 5";

  #and xl.d_code not in ('D_UNDEF_DEFUNCT', 'D_UNDEF', 'D_DEFUNCT') 
 $stmt = "select distinct ot.roles_qualifier_type, 
  CASE xl.object_type_code
          WHEN 'PC' THEN  replace(replace(xl.link_by_object_code,'0P','0HP'), 'P', 'PC')
          WHEN 'PMIT' THEN replace(replace(xl.link_by_object_code,'P','PC'),'PCC','PC')
          WHEN 'SIS' THEN CONCAT('SIS_' , xl.link_by_object_code)  
          WHEN 'LORG' THEN CASE length(xl.link_by_object_code) 
                              WHEN 6 THEN CASE substr(xl.link_by_object_code,1,3) 
                            	 	      WHEN '0HL' THEN xl.link_by_object_code 
                             		      ELSE  CONCAT('LDS_' ,xl.link_by_object_code) END 
          		      ELSE  xl.link_by_object_code  END
          ELSE xl.link_by_object_code END as obj_code ,
  CASE xl.object_type_code
          WHEN 'PC' THEN replace(replace(xl.link_by_object_code,'0P','0HP'), 'P', 'PC')
          WHEN 'PMIT' THEN  replace(replace(xl.link_by_object_code,'P','PC'),'PCC','PC')
          ELSE xl.link_by_object_code END as roles_qual_code ,
  xl.d_code xl_d_code, 'zzzz' as z_code
  from wh_expanded_object_link xl, object_type ot
  where xl.view_type_code = '$view_type'
  and ot.object_type_code = xl.object_type_code
  union select distinct ot.roles_qualifier_type, 
  CASE ol.object_type_code
          WHEN 'PC' THEN replace(replace(ol.object_code,'0P','0HP'), 'P', 'PC')
          WHEN 'PMIT' THEN replace(replace(ol.object_code,'P','PC'),'PCC','PC')
          WHEN 'SIS' THEN CONCAT('SIS_' , ol.object_code)  
          WHEN 'LORG' THEN 
			CASE length(ol.object_code) 
                         WHEN 6 THEN CASE substr(ol.object_code,1,3) 
                                WHEN '0HL' THEN ol.object_code
                                ELSE CONCAT('LDS_' , ol.object_code) END 
                         ELSE ol.object_code END
          ELSE ol.object_code END as obj_code, 
  CASE ol.object_type_code
        WHEN  'PC' THEN replace(replace(ol.object_code,'0P','0HP'), 'P', 'PC')
        WHEN  'PMIT' THEN replace(replace(ol.object_code,'P','PC'),'PCC','PC')
        ELSE  ol.object_code END as roles_qual_code ,
  d.d_code, 'zzzz'
 from object_link ol, department d, object_type ot
 where d.dept_id = ol.dept_id
 and ot.object_type_code = ol.object_type_code
 and d.dept_type_id in 
  (select dept_type_id from dept_node_type
    where dept_type_id not in (select leaf_dept_type_id from view_to_dept_type
     where view_type_code = '$view_type'))
 and exists 
  (select dh.d_code 
   from wh_dlc_hierarchy dh
   where dh.d_code = d.d_code
   and dh.view_type_code = '$view_type')
  order by xl_d_code, obj_code, z_code";


 $csr = $lda->prepare($stmt)
 	 ||  die $DBI::errstr;
 $csr->execute(); 
#
#  Read in data about linked objects, and write out records
#
 print "Reading in objects linked to DLCs from Oracle table...\n";
 $i = -1;
 my ($prev_qqcode, $prev_parcode) = ('', '');
 while (($qqualtype, $qqcode, $lookup_qcode, $qqparcode, $qqname) 
      = $csr->fetchrow_array()) 
 {
   $qqname = $qualcode2name{"$qqualtype:$lookup_qcode"};
   unless ($qqname) {$qqname = "Object not found";}
   # Avoid error if a PC under PMIT hierarchy and a PC under COST 
   # hierarchy are identical except for the name field. Throw out 
   # second instance of the PC, even though the name is different.
   unless ( ($qqcode eq $prev_qqcode) && ($qqparcode eq $prev_parcode) ) {
     #
     #  Ignore FC_ objects with Object not found in name; they will be
     #  generated by related SG_ objects.
     #
     unless ((substr($qqcode, 0 , 3) eq 'FC_') 
             && ($qqname eq 'Object not found')) {
       printf F2 "%s!%s!%s!%s\n",
             'DEPT', $qqcode, $qqparcode, $qqname;
     }
     #
     # If the linked object is SG_..., then also add a matching
     # linked object for FC_... 
     # if there is a non-null qualifier name (02/12/2010)
     #
     if ((substr($qqcode, 0, 3) eq 'SG_') && ($qqname ne 'Object not found')) {
       printf F2 "%s!%s!%s!%s\n",
           'DEPT', 'FC_' . substr($qqcode,3), $qqparcode, $qqname;
     }
   }
   ($prev_qqcode, $prev_parcode) = ($qqcode, $qqparcode);
 }
 $csr->finish() || die "can't close cursor";

 close (F2);
 
 $lda->disconnect || die "can't log off Oracle";



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

	my($infile) = $datafile_dir . "dept.actions";
	my($sqlfile) = $datafile_dir . "deptchange.sql";
	my($sqlfile2) = $datafile_dir . "deptdesc.sql";
	my($qualtype) = "DEPT";

	## Step 0: Check Arguments
	if ($#_ != 2){&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
	my($user_id, $user_pw, $db_id) = @_;


	## Check number of actions to be preformed

	#$MAX_ACTIONS = 500;  #This should be configurable
        $MAX_ACTIONS = &find_max_actions_value2( $db_id,$user_id,$user_pw, "MAX_DEPT");
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
				"Unable to log into destination database $ora_errstr") &&
			ScriptExit("Unable to Log into Destination Database: $db_id.")		);

	## Step 2: Update, Insert and Delete Records

	if (-r $infile) {&ProcessActions($destination_lda, $qualtype, $infile, $sqlfile);}

	ExecuteSQLCommands($sqlfile,$destination_lda);

        # Run the first .sql file
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
	#$cmd = "sqlplus $user_id/$user_pw\@$db_id \@$sqlfile2";
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
sub get_qualcode_names
###############################################################################
{
    my ($rqualcode2name) = @_;
    my $db_parm = GetValue("roles");
    $db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
    my $user  = $1;
    my $pw  = $2;
    my $db  = $3;
    my $roles_lda = &login_dbi_sql($db, $user, $pw)
			|| (
			&RolesLog("FATAL_MSG",
				$DBI::errstr) &&
			ScriptExit("Unable to Log into Database: $db.")	);

 #
 #  Read in qualifier_type, qualifier_name, qualifier_code
 #  for all qualifiers (except leaf-level COST and FUND objects) 
 #
    my $stmt = 
     "select qualifier_type, qualifier_code, qualifier_name 
       from qualifier
       where qualifier_type in ('ORGU', 'ORG2', 'LORG', 'SISO', 'BAGS', 'PBM1',
                                'PBUD', 'PMIT', 'COST', 'FUND', 'SPGP')
       and (qualifier_type not in ('COST', 'FUND')
            or has_child = 'Y')";
    my $csr = $roles_lda->prepare( $stmt)
 	|| die $DBI::errstr;
 
  $csr->execute();
 #
 #  Read in the database records and create the hash.
 #  Set $qualcode2name{"$qualtype:$qualcode"} = $qualname;
 #
  print "Reading in qualifier names from Roles DB table...\n";
  $i = -1;
  my ($qtype, $qcode, $qname);
  while (($qtype, $qcode, $qname) = $csr->fetchrow_array()) {
      $$rqualcode2name{"$qtype:$qcode"} = $qname;
  }
  $csr->finish() || die "can't close cursor";
  $roles_lda->disconnect();

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
#  Extract DEPT data from qualifier table of Roles DB.
#
########################################################################
sub ExistingExtract
{
my($lda, $data_dir) = @_;

$outfile = $data_dir . "dept.roles";
$qqualtype = 'DEPT';
 
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
 $stmt = "select q2.qualifier_code, q.qualifier_id, q.qualifier_code qcode," 
          . " q.qualifier_name, q.has_child" 
          . " from qualifier q, qualifier_child c, qualifier q2"
          . " where q.qualifier_id = c.child_id"
          . " and c.parent_id = q2.qualifier_id"
          . " and q.qualifier_type = '$qqualtype'"
          . " union"
          . " select '', qualifier_id, qualifier_code,"
          . " qualifier_name, has_child"
          . " from qualifier"
          . " where qualifier_level = 1 and qualifier_type = '$qqualtype'"
          . " order by qcode";
 $csr = $lda->prepare( $stmt)
        || die $DBI::errstr;
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
 
# do ora_logoff($lda) || die "can't log off Oracle";
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

#For Linux, sort command, this env setting will make the sorting based on ASCII instead of Dictionary.
$ENV{'LANG'}='C';
$ENV{'LC-COLLATE'}='C';


my $file1 = $data_dir . "dept.roles";
my $file2 = $data_dir . "dept.warehouse";
my $diff_file = $data_dir . "dept.diffs";
my $tempactions = $data_dir . "dept.actions.temp";
my $actionsfile = $data_dir . "dept.actions";
my $temp1 = $data_dir . "dept1.temp";
my $temp2 = $data_dir . "dept2.temp";
 
print "Sorting first file...\n";
#system("sort -t '!' -k 1,2 -o $temp1 $file1\n");
system("sort -u -o $temp1 $file1\n");
print "Sorting 2nd file...\n";
#system("sort -t '!' -k 1,2 -o $temp2 $file2\n");
system("sort -u -o $temp2 $file2\n");
 
 
print "Comparing files $file1 and $file2...\n";
system("diff $temp1 $temp2 |"            # Find differences in two files
       . " grep '^[><]' |"               # Select only added/deleted lines
       . " sed 's/< DEPT/<\!DEPT/' |"    # Add ! field marker
       . " sed 's/> DEPT/>\!DEPT/' |"    # Add ! field marker
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
   #print "***$oldnew - $qualtype - $qualcode - $parentcode - $qname\n";
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
   #print "$old_p $old_code[$old_p] $new_p $new_code[$new_p]\n";
   if ($old_code[$old_p] lt $new_code[$new_p]) {
     print F2 "DELETE!$old_code[$old_p]\n";
     #print "DELETE!$old_code[$old_p]\n";
     $old_p++;
   }
   elsif ($old_code[$old_p] eq $new_code[$new_p]) {
     if ($old_parent[$old_p] ne $new_parent[$new_p]) {
       print F2 "UPDATE!$old_code[$old_p]!PARENT"
                . "!$old_parent[$old_p]!$new_parent[$new_p]\n";
       #print "UPDATE!$old_code[$old_p]!PARENT"
       #         . "!$old_parent[$old_p]!$new_parent[$new_p]\n";
     }
     if ($old_name[$old_p] ne $new_name[$new_p]) {
       print F2 "UPDATE!$old_code[$old_p]!NAME"
                . "!$old_name[$old_p]!$new_name[$new_p]\n";
       #print "UPDATE!$old_code[$old_p]!NAME"
       #         . "!$old_name[$old_p]!$new_name[$new_p]\n";
     }
     $old_p++;
     $new_p++;
   }
   else { # $old_code gt $new_code
     print F2 "ADD!$new_code[$new_p]!$new_parent[$new_p]!$new_name[$new_p]\n";
     #print "ADD!$new_code[$new_p]!$new_parent[$new_p]!$new_name[$new_p]\n";
     $new_p++;
   }
 }
 
#
#  Handle left-over lines.
#
 while ($old_p < $old_max) {
   print F2 "DELETE!$old_code[$old_p]\n";
   #print "DELETE!$old_code[$old_p]\n";
   $old_p++;
 }
 
 while ($new_p < $new_max) {
   print F2 "ADD!$new_code[$new_p]!$new_parent[$new_p]!$new_name[$new_p]\n";
   #print "ADD!$new_code[$new_p]!$new_parent[$new_p]!$new_name[$new_p]\n";
   $new_p++;
 }
 
 close (F2);



#
#   Reorder actions
#

 unless(open(INFILE, "<" . $tempactions) ) {
    die "$0: can't open ($tempactions) - $!\n";
  }
 while ( chop($line = <INFILE>)) {
	push(@actions, $line);
 }
 close INFILE;

 #print "Before sort...\n";
 #foreach $item (@actions) {
 #    print "'$item'\n";
 #}

 sort_actions(\@actions);

 #print "After sort...\n";
 #foreach $item (@actions) {
 #    print "'$item'\n";
 #}

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
