###############################################################################
## NAME: roles_rset.pm
##
## DESCRIPTION: Subroutines related to qualifier feed for 'RSET' qualifiers
##              (EHS DLCs, Room Sets, and Rooms)
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
## Created 04/20/2005, Jim Repa
###############################################################################

package roles_rset;
$VERSION = 1.0; 
$package_name = 'roles_rset';

## Standard Roles Database Feed Package
use roles_base qw(UsageExit ScriptExit RolesLog RolesNotification ArchiveFile login_dbi_sql find_max_actions_value2  ExecuteSQLCommands);
use roles_qual 
  qw(strip ProcessActions FixDescendents sort_actions fix_haschild);
use config('GetValue');

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
        $outfile = $datafile_dir . "rset.warehouse";

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
#  Open the first connection to Oracle, to the Roles DB itself to get
#  the DEPT hierarchy records.
#
 my $db_parm = GetValue("roles"); # Get info about Roles DB from config file
 $db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
 my $roles_id  = $1;
 my $roles_pw  = $2;
 my $roles_db  = $3;
 print "Logging into Oracle (Roles DB)...\n";
 my($roles_lda) = login_dbi_sql($roles_db, $roles_id, $roles_pw)
  	|| die $DBI::errstr;
 print "Done logging into Oracle (Roles DB)\n";
 my $roles_stmt = 
  "select q2.qualifier_code as qcode1, q1.qualifier_code as qcode2, q1.qualifier_name, 
          q1.qualifier_id
   from qualifier q1, qualifier_child qc, qualifier q2
   where q1.qualifier_type = 'DEPT'
   and substr(q1.qualifier_code, 1, 2) = 'D_'
   and qc.child_id = q1.qualifier_id
   and q2.qualifier_id = qc.parent_id
   order by qcode1, qcode2";
 $roles_csr = $roles_lda->prepare($roles_stmt)
      || die "$DBI::errstr . \n";

 $roles_csr->execute();

#
#  Write out a made-up record for the root of the RSET tree
#
   printf F2 "%s!%s!%s!%s\n",
           'RSET', 'D_ALL', '', 
           'All EHS Room Sets and Rooms';

#
#  Read in records from the Roles DB and print out DLC records to flat file.
#  Save a mapping from DLC code to qualifier_id to be used later for
#  PI-DLC code numbers.
#
 print "Reading in DLC data from the Roles DB...\n";
 $i = -1;
 my %d_code2id = ();
 my ($qqparcode, $qqcode, $qqname, $qqid);
 while (($qqparcode, $qqcode, $qqname, $qqid) = $roles_csr->fetchrow_array()) {
   printf F2 "%s!%s!%s!%s\n",
           'RSET', $qqcode, $qqparcode, $qqname;
   $d_code2id{$qqcode} = $qqid;
 }
 ($roles_csr->finish()) || die "can't close DB cursor";
 ($roles_lda->disconnect()) || die "can't log off DB";

#
#  Open the second connection to oracle, this time to the Warehouse.
#
 print "Logging into Oracle (Warehouse)...\n";
 my($lda) = &login_dbi_sql($db_id, $user_id, $user_pw)
  	|| die $DBI::errstr;
 print "Done logging into Oracle (Warehouse)\n";

#
#  Open a cursor to get PI information from Warehouse tables of Room Set
#  data.
#
#  We will pull the DLC_code, PI's MIT ID number, fullname, and
#  the work area number.  The work area number will be used
#  as the qualifier code.
# We need a unique PI-DLC combination code.
# We will use the Work Area ID for this, where available.  
# Otherwise, use nnnnnnnnn_mmmm where mmmm is a 4-digit ID for the
# DLC, gotten from the Roles DEPT table (qualifier_id-650000)
# 
# We'll put in the appropriate qualifier code for the DLC/PI in the next
# step.
#

 my $pi_stmt = "select distinct wa.dlc_code, pi_mit_id, 
      substr(wa.pi_full_name, 1, 39) 
          || ' (' || p.krb_name_uppercase || ')' full_name, 
          substr(wa.pi_work_area_id, 13, 8)
      from wareuser.whehsta_pi_work_area wa, wareuser.krb_person p
      where wa.work_area_type = 'PI'
      and substr(wa.dlc_code, 1, 2) = 'D_'
      and wa.work_area_status_code = 'AC'
      and nvl(wa.pi_mit_id, ' ') <> ' '
      and p.mit_id(+) = wa.pi_mit_id
      order by 1, 2";
 #print "'$pi_stmt'\n";
 my $pi_csr = $lda->prepare($pi_stmt)
      || die "$DBI::errstr . \n";

 $pi_csr->execute();

#
#  Print out a list of PIs derived from Room Set data in the Warehouse
# 
 print "Reading in list of PIs from the Warehouse data...\n";
 $i = -1;
 my %dlc_mit_id2wa_code;
 my $dlc_mit_id;
 my ($dlc_code, $pi_mit_id, $pi_name, $qqcode);
 my %pi_dept_list = ();  # Remember PI/DEPT pairs so we do not duplicate them
 while ( ($dlc_code, $pi_mit_id, $pi_name, $qqcode) = $pi_csr->fetchrow_array()) {
   #print "DLC '$qqparcode' ID $d_code2id{$qqparcode}\n";
   #my $new_qcode = $qqcode . '-' . substr($d_code2id{$qqparcode}, 2, 4);
   $qqcode = 'PI_' . $qqcode;
   printf F2 "%s!%s!%s!%s\n",
           'RSET', $qqcode, $dlc_code, $pi_name;
   my $dlc_mit_id = $dlc_code . $pi_mit_id;
   $pi_dept_list{$dlc_mit_id} = 1;
   $dlc_mit_id2wa_code{$dlc_mit_id} = $qqcode;
 }
 $pi_csr->finish()
 	|| die "can't close cursor";

#
#  Now, to get the "extra" PIs (those who are not registered in PI Space
#  Registration, but who are included in the short list pickable on the
#  TNA), we need to connect to the EHS database.  In the future, it would 
#  be preferable if the data were available from the Warehouse.
#
 #my $db_parm = GetValue("ehs"); # Get info about EHS DB from config file
 #$db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
 #my $ehs_id  = $1;
 #my $ehs_pw  = $2;
 #my $ehs_db  = $3;
 #print "Logging into Oracle ($ehs_id $ehs_db)...\n";
 #my($ehs_lda) = &ora_login($ehs_db, $ehs_id, $ehs_pw)
 # 	|| die $ora_errstr;
 #print "Done logging into Oracle (EHS DB)\n";

#
#  Print out a list of PIs derived from EHS_EXTRA_PI table in EHS
# 
 #my $ehs_stmt = 
 #"select d.dept_code, p.mit_id,
 #        rtrim(substr(initcap(p.last_name || ', ' || p.first_name 
 #        || ' ' || p.middle_name), 1, 39), ' ') || ' (' 
 #        || decode(substr(e.kerberos_name,1,1), '\$', '', e.kerberos_name)
 #        || ')' full_name
 # from ehs\$user.ehs_extra_pi e, ehs\$user.person2 p, ehs\$user.dept d
 # where p.kerberos_name = e.kerberos_name
 # and d.dept_id = e.dept_id
 # order by 1, 2";
 #my $ehs_csr = &ora_open($ehs_lda, $ehs_stmt)
 #	|| die $ora_errstr;
 #print "Reading in list of PIs from the EHS Extra PIs...\n";
 #$i = -1;
 #while (($qqparcode, $qqcode, $qqname) = &ora_fetch($ehs_csr)) {
 #  unless ($pi_dept_list{"$qqcode!$qqparcode"}) {  # Avoid duplicates
 #    my $new_qcode = $qqcode . '-' . substr($d_code2id{$qqparcode}, 2, 4);
 #    printf F2 "%s!%s!%s!%s\n",
 #          'RSET', $new_qcode, $qqparcode, $qqname;
 #  }
 #}
 #&ora_close($ehs_csr) || die "can't close cursor";
 #&ora_logoff($ehs_lda) || die "can't log off Oracle";

#
#  Open a cursor to get Room Set data from the Warehouse
#
 #print "Logging back into Oracle (Warehouse)...\n";
 #my($lda) = &ora_login($db_id, $user_id, $user_pw)
 # 	|| die $ora_errstr;
 #print "Done logging into Oracle (Warehouse)\n";
  my $stmt = "select  pi_mit_id, 
      'RS_' || substr(wa.work_area_id, 13, 8)  room_set_code,
      substr(nvl(wa.work_area_name, 'Room Set for '|| wa.pi_full_name),
             1, 50) room_set_name, wa.dlc_code
      from wareuser.whehss_work_area wa
      where wa.work_area_type = 'RS'
      and substr(wa.dlc_code, 1, 2) = 'D_'
      and wa.work_area_status_code = 'AC' -- maybe add deactivate-in-progress
      and pi_mit_id is not null 
      order by 1, 2";
my $csr = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";

 $csr->execute();

#
#  Print out records for each of the Room Sets.
#
 print "Reading in rows from Warehouse table of Room Set data...\n";
 $i = -1;
 my $dlc_code;
 while (($pi_mit_id, $qqcode, $qqname, $dlc_code) = $csr->fetchrow_array()) {
   #my $new_parcode = $pi_mit_id . '-' . substr($d_code2id{$dlc_code}, 2, 4);
   $dlc_mit_id = "$dlc_code$pi_mit_id";
   my $new_parcode = $dlc_mit_id2wa_code{$dlc_mit_id};
   unless ($new_parcode) {
     print 
       "***Warning: no DLC/PI work area found for $dlc_code / $pi_mit_id\n";
     $new_parcode =  $pi_mit_id . '-' . substr($d_code2id{$dlc_code}, 2, 4);
     $dlc_mit_id2wa_code{$dlc_mit_id} = $new_parcode;
   }
   if ($new_parcode) {
     printf F2 "%s!%s!%s!%s\n",
           'RSET', $qqcode, $new_parcode, $qqname;
   }
 }
 $csr->finish() || die "can't close cursor";
 
#
#  Print out records for each of the rooms within the Room Sets
#
 my $stmt2 = "select 'RS_' || substr(rs.work_area_id, 13, 8)  room_set_code,
     'R_' || substr(rm.work_area_id, 13, 8) building_room,
     --rm.work_area_name building_room, 
     'Room ' || rm.work_area_coordinates room_name,
     rm.is_subroom 
     from wareuser.whehss_work_area rm, 
          wareuser.whehss_work_area rs
     where rm.work_area_type = 'RM'
     and rs.ehss_work_area_key = rm.work_area_parent_id
     and rm.work_area_status_code = 'AC'
     and rs.work_area_type = 'RS'
     and rm.work_area_name is not null
     and rm.room_status = 'Active'
     and substr(rm.work_area_id, 13, 8) <> '70001196'
     and rm.is_subroom = 'N'
    union select 'RS_' || substr(rs.work_area_id, 13, 8)  room_set_code,
     'SubR_' || substr(rm.work_area_id, 13, 8) building_room, 
     substr('(' || rm.work_area_coordinates || ' subroom) ' 
            || rm.work_area_name, 1, 50) room_name,
     rm.is_subroom 
     from wareuser.whehss_work_area rm, 
          wareuser.whehss_work_area rs
     where rm.work_area_type = 'RM'
     and rs.ehss_work_area_key = rm.work_area_parent_id
     and rm.work_area_status_code = 'AC'
     and rs.work_area_type = 'RS'
     and rm.work_area_name is not null
     and rm.room_status = 'Active'
     and substr(rm.work_area_id, 13, 8) <> '70001196'
     and rm.is_subroom = 'Y'
     order by 1, 2";

 my $csr2 = $lda->prepare($stmt2)
      || die "$DBI::errstr . \n";

 $csr2->execute();
 
 print "Reading in rows from Warehouse table of Room Set rooms...\n";
 $i = -1;
 while (($qqparcode, $qqcode, $qqname) = $csr2->fetchrow_array()) {
   printf F2 "%s!%s!%s!%s\n",
           'RSET', $qqcode, $qqparcode, $qqname;
 }
 $csr->finish() || die "can't close cursor";
 
 
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

	my($infile) = $datafile_dir . "rset.actions";
	my($sqlfile) = $datafile_dir . "rsetchange.sql";
	my($sqlfile2) = $datafile_dir . "rsetdesc.sql";
	my($qualtype) = "RSET";

	## Step 0: Check Arguments
	if ($#_ != 2){&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
	my($user_id, $user_pw, $db_id) = @_;


	## Check number of actions to be preformed

	print "DB: '$db_id' User: '$user_id'  \n";
 	$MAX_ACTIONS = &find_max_actions_value2( $db_id, $user_id, $user_pw, "MAX_RSET");
	print "MAX_ACTIONS: '$MAX_ACTIONS' \n";
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
#  Extract RSET data from qualifier table of Roles DB.
#
########################################################################
sub ExistingExtract
{
my($lda, $data_dir) = @_;

$outfile = $data_dir . "rset.roles";
$qqualtype = 'RSET';
 
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
          . " qn.qualifier_name, q.has_child" 
          . " from qualifier q, qualifier_child c, qualifier q2, "
          . " suppressed_qualname qn "
          . " where q.qualifier_id = c.child_id"
          . " and c.parent_id = q2.qualifier_id"
          . " and q.qualifier_type = '$qqualtype'"
          . " and qn.qualifier_id = q.qualifier_id"
          . " union"
          . " select '', qualifier_id, qualifier_code as qcode,"
          . " qualifier_name, has_child"
          . " from qualifier"
          . " where qualifier_level = 1 and qualifier_type = '$qqualtype'"
          . " order by qcode";
 my $csr = $lda->prepare($stmt)
        || die $DBI::errstr;
 $csr->execute()
        || die $DBI::errstr;

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
#  Find the differences in two files of Depts. and PIs.
#  Process the differences to make it easier to do adds, deletes, and
#  updates to qualifier table in Roles DB.
#
##############################################################################
sub CompareExtract
{

my($data_dir) = @_;

my $file1 = $data_dir . "rset.roles";
my $file2 = $data_dir . "rset.warehouse";
my $diff_file = $data_dir . "rset.diffs";
my $tempactions = $data_dir . "rset.actions.temp";
my $actionsfile = $data_dir . "rset.actions";
my $temp1 = $data_dir . "rset1.temp";
my $temp2 = $data_dir . "rset2.temp";
 
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
       . " sed 's/< RSET/<\!RSET/' |"    # Add ! field marker
       . " sed 's/> RSET/>\!RSET/' |"    # Add ! field marker
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
 #print "old_max index = $old_max  new_max index = $new_max\n";
 while (($old_p < $old_max) & ($new_p < $new_max)) {
   #print "$old_p $old_code[$old_p] $new_p $new_code[$new_p]\n";
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
 #print "After compare loop\n";
 
#
#  Handle left-over lines.
#
 while ($old_p < $old_max) {
   #print "delete $old_p $old_code[$old_p] ($old_max)\n";
   print F2 "DELETE!$old_code[$old_p]\n";
   $old_p++;
 }
 
 while ($new_p < $new_max) {
   #print "add $new_p $new_code[$new_p] ($new_max)\n";
   print F2 "ADD!$new_code[$new_p]!$new_parent[$new_p]!$new_name[$new_p]\n";
   $new_p++;
 }
 
 close (F2);
 #print "OK, we're ready to reorder RSET actions\n";

#
#   Reorder RSET actions
#

 unless(open(INFILE, "<" . $tempactions) ) {
    die "$0: can't open ($tempactions) - $!\n";
  }
 while ( chop($line = <INFILE>)) {
	push(@actions, $line);
 }
 close INFILE;

 #print "Reordering actions\n";
 sort_actions(\@actions);
 #print "After reordering actions\n";


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
