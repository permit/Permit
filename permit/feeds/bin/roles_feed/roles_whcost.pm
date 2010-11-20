###############################################################################
## NAME: roles_whcost.pm
##
## DESCRIPTION: Subroutines related to maintaining the table 
##              copy_wh_cost_collector (a modified mirror image of the
##              warehouse table cost_collector).
##
#
#  Copyright (C) 1999-2010 Massachusetts Institute of Technology
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
## Written  4/20/1999 by J. Repa
## Modified 8/18/1999 by J. Repa 
##   -- add supervisor_room addressee, addressee_room
## Modified 7/6/2001 J. Repa -- add supervisor_id, addressee_id, company_code
## Modified 7/9/2001 J. Repa -- add admin_flag (fixed 7/12/01)
## Modified 6/6/2007 M. Korobko 
##   --  use table funds_cntr_release_str instead of manually maintained file fcrs.model1   
## Modified 6/13/2007 M.Korobko  
##   --  use table roles_parameters to find MAX_ACTIONS allowed  
###############################################################################
package roles_whcost;
$VERSION = 1.0; 
$package_name = 'roles_whcost';
## Standard Roles Database Feed Package
use roles_base qw(UsageExit login_dbi_sql ScriptExit RolesLog RolesNotification ArchiveFile 
                    find_max_actions_value  login_dbi_sql find_max_actions_value2  ExecuteSQLCommands); 
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
	my($user_id, $user_pw, $db_name) = @_;

        #
        #  Get username and password for Warehouse FTP connection.
        #
	use config('GetValue');
        my $ftp_parm = GetValue("ftpwarehouse");
        $ftp_parm =~ m/^(.*)\/(.*)\@(.*)$/;
	my $user = $1;
        my $pw  = $2;
	my $ftpsite  = $3;
        
        ## Get file wh-fcrs using FTP.
        &FTPFromWarehouse($user, $pw, $ftpsite, $datafile_dir);

        ## Get a hash of Fund Centers and Release Strategies
        %fc_rs = ();
        &get_release_strategy(\%fc_rs, $datafile_dir, 'roles');

	## Get a file of cost collector data from the warehouse table
	&get_wh_cost_collector_data
            ($user_id, $user_pw, $db_name, $datafile_dir, \%fc_rs);

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

	my($infile) = $datafile_dir . "whcost.actions";
	my($sqlfile) = $datafile_dir . "costchange.sql";
	my($sqlfile2) = $datafile_dir . "costdesc.sql";

	## Step 0: Check Arguments
	if ($#_ != 2){&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
	my($user_id, $user_pw, $db_id) = @_;

	## Check number of actions to be preformed
        $MAX_ACTIONS = &find_max_actions_value2( $db_id,$user_id,$user_pw, "MAX_WHCOST");  
        #print $MAX_ACTIONS ."\n";
#	#$MAX_ACTIONS = 10000;  #This should be configurable
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
              # ?, ?, to_date(?, 'MM/DD/YYYY'), to_date(?, 'MM/DD/YYYY'), ?, ?,
        my $insert_stmt = q{
           insert into wh_cost_collector
             (COST_COLLECTOR_ID_WITH_TYPE, 
              COST_COLLECTOR_ID, 
              COST_COLLECTOR_TYPE_DESC,
              COST_COLLECTOR_NAME, ORGANIZATION_ID,
              ORGANIZATION_NAME, IS_CLOSED_COST_COLLECTOR,
              PROFIT_CENTER_ID, PROFIT_CENTER_NAME,
              FUND_ID, FUND_CENTER_ID, SUPERVISOR,
              COST_COLLECTOR_EFFECTIVE_DATE,
              COST_COLLECTOR_EXPIRATION_DATE, 
              TERM_CODE, RELEASE_STRATEGY,
              SUPERVISOR_ROOM, ADDRESSEE, ADDRESSEE_ROOM,
              SUPERVISOR_MIT_ID, ADDRESSEE_MIT_ID, COMPANY_CODE, ADMIN_FLAG)
             values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
               ?, ?, str_to_date(?, '%m/%d/%Y'), str_to_date(?, '%m/%d/%Y'), ?, ?,
               ?, ?, ?,
               ?, ?, ?, ?)
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
           delete from wh_cost_collector
             where cost_collector_id_with_type = ?
           };
        #print "delete_stmt='$delete_stmt'\n";
        my $del_csr;
        unless ($del_csr = $destination_lda->prepare($delete_stmt)) 
        {
          print $destination_lda->errstr . "\n";
          die "Error preparing delete_stmt.\n";
        }
        ### UPDATE ###
              #COST_COLLECTOR_EFFECTIVE_DATE=to_date(?,'MM/DD/YYYY'),
              #COST_COLLECTOR_EXPIRATION_DATE=to_date(?,'MM/DD/YYYY'), 
        my $update_stmt = q{
           update wh_cost_collector
             set COST_COLLECTOR_ID=?,
              COST_COLLECTOR_TYPE_DESC=?,
              COST_COLLECTOR_NAME=?, ORGANIZATION_ID=?,
              ORGANIZATION_NAME=?, IS_CLOSED_COST_COLLECTOR=?,
              PROFIT_CENTER_ID=?, PROFIT_CENTER_NAME=?,
              FUND_ID=?, FUND_CENTER_ID=?, SUPERVISOR=?,
              COST_COLLECTOR_EFFECTIVE_DATE=str_to_date(?,'%m/%d/%Y'),
              COST_COLLECTOR_EXPIRATION_DATE=str_to_date(?,'%m/%d/%Y'), 
              TERM_CODE=?, RELEASE_STRATEGY=?,
              SUPERVISOR_ROOM=?, ADDRESSEE=?, ADDRESSEE_ROOM=?,
              SUPERVISOR_MIT_ID=?, ADDRESSEE_MIT_ID=?, COMPANY_CODE=?,
              ADMIN_FLAG=?
             where COST_COLLECTOR_ID_WITH_TYPE=?
           };
        #print "update_stmt='$update_stmt'\n";
        my $upd_csr;
        unless ($upd_csr = $destination_lda->prepare($update_stmt)) 
        {
          print $destination_lda->errstr . "\n";
          die "Error preparing update_stmt.\n";
        }


        #
        #  Read through the action records, performing insert, delete, or
        #  update.
        #

	## Step 2: Update, Insert and Delete Records
	#if (-r $infile) {&ProcessActions($destination_lda, $qualtype, $infile, $sqlfile);}

        unless (open(IN,$infile)) {
          die "Cannot open $infile for reading\n"
        }
        my $i = 0;
        my $n;
        my $delim = '\|';
        while (chomp($line = <IN>)) {
          if (($i++)%1000 == 0) {print $i . "\n";}
          @token = split($delim, $line);
          #$token[15] = ($token[15]) ? $token[15] : '';  # Check for last token
          #$token[19] = ($token[19]) ? $token[19] : '';  # Check for last token
          $token[23] = ($token[23]) ? $token[23] : '';  # Check for last token
          if ($token[0] eq 'ADD') {
            $n = @token;
            &add_cc($destination_lda, $add_csr, @token[1..$n-1]);
          }
          elsif ($token[0] eq 'DELETE') {
            &delete_cc($destination_lda, $del_csr, $token[1]);
          }
          if ($token[0] eq 'UPDATE') {
            &update_cc($destination_lda, $upd_csr, @token[1..$#token]);
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
        $upd_csr->finish;
        $destination_lda->commit;
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
#  Subroutine get_wh_cost_collector_data
#
#  Read in data from the warehouse cost_collector table.
#  Write the file whcost.warehouse.
#
########################################################################

sub get_wh_cost_collector_data
{
my($user, $pw, $db, $data_dir, $rfc_rs) = @_;

$wrhs_outfile = $data_dir . "whcost.warehouse";

#
#   Open output files.
#
  $outf = ">" . $wrhs_outfile;   # cost_collector table data
  if( !open(F2, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }

#
#  Open a connection to the warehouse table
#

 my $lda = login_dbi_sql($db, $user, $pw)
        || die $DBI::errstr;

#
#  Open cursor for warehouse table
#
 my $stmt = "select w.cost_collector_id_with_type,"
             . " w.cost_collector_id,"
             . " w.cost_collector_type_desc,"
             . " w.cost_collector_name,"
             . " w.organization_id,"
             . " w.profit_center_name,"
             . " w.is_closed_cost_collector,"
             . " w.profit_center_id, w.profit_center_name,"
             . " w.fund_id, w.fund_center_id, w.supervisor,"
             . " to_char(w.cost_collector_effective_date,'MM/DD/YYYY'),"
             . " to_char(w.cost_collector_expiration_date,'MM/DD/YYYY'),"
             . " w.term_code,"
             . " w.supervisor_room, w.addressee, w.addressee_room,"
             . " w.supervisor_mit_id, w.addressee_mit_id, w.company_code,"
             . " w.admin_flag"
             . " from wareuser.cost_collector w"
             . " where w.cost_collector_id_with_type is not null"
             . " order by w.cost_collector_id_with_type";
 my $csr = $lda->prepare( $stmt)
        || die $DBI::errstr;
 
 $csr->execute();
#
#  Read in rows from the cost_collector table
#
 print "Reading in cost collector data from Warehouse table...\n";
 my $i = -1;
 my $rs;
 while ( ($ccid, $ccidt, $cctype, $ccname, $ccorg_id, $ccorg_name, $cc_closed,
   $pc_code, $pc_name, $fund_code, $fc_code, $cc_supervisor,
   $cc_begin_date, $cc_end_date, 
   $cc_term_code, $cc_supervisor_room, $cc_addressee, 
   $cc_addressee_room, $cc_supervisor_id, 
   $cc_addressee_id, $cc_company_code, $cc_admin_flag) = $csr->fetchrow_array() ) {
   if (($i++)%5000 == 0) {print $i . "\n";}
   $rs = $$rfc_rs{$fc_code};  # Get Release Strategy code from the hash
   #print "FC='$fc_code', RS='$rs'\n";
   print F2 
     "$ccid\|$ccidt\|$cctype\|$ccname\|$ccorg_id\|$ccorg_name\|$cc_closed"
     . "\|$pc_code\|$pc_name\|$fund_code\|$fc_code\|$cc_supervisor"
     . "\|$cc_begin_date\|$cc_end_date\|$cc_term_code\|$rs"
     . "\|$cc_supervisor_room\|$cc_addressee\|$cc_addressee_room"
     . "\|$cc_supervisor_id\|$cc_addressee_id\|$cc_company_code"
     . "\|$cc_admin_flag\n";
 }
 $csr->finish() || die "can't close cursor"; # Close cursor


 $lda->disconnect() || die "can't log off Oracle"; # Cl. Warehouse connection

 close (F2);

} 

########################################################################
#  
#  Subroutine get_release_strategy(\%fc_rs, $datafile_dir, $db_name)
#
#  Read in data from a file of Fund Centers and their release strategies,
#  and also get Model 1 Funds Centers from a table.
#  Save the information in a hash.
#
########################################################################

sub get_release_strategy
{
   my($rfc_rs, $datafile_dir, $db_name) = @_;
   use DBI;
   use config('GetValue');
   my $rel_str_outfile = $datafile_dir . "rel_str";
#
#   Open output file.
#
   my  $outf = ">" . $rel_str_outfile;
   if( !open(F2, $outf) ) 
   {
    die "$0: can't open ($outf) - $!\n";
   }

#### was before: my $fcrs_file_old = "$datafile_dir/fcrs.model1";  # Get old Model 1 FCs
#
#  Open a connection to the roles table (Get Model 1 Fund Centers)
#
# Get database name
    $db_parm = GetValue($db_name);
    $db_parm =~ m/^(.*)\/(.*)\@(.*)$/; 
    print $db_name ."\n";   
    $user_id = $1;
    $user_pw = $2;
    $db_id  = $3;
#print "db_id='$db_id' user_id ='$user_id' Password='$user_pw' db_parm='$db_parm' \n";
   $dbh = login_dbi_sql( $db_id,  $user_id, $user_pw )
                  || die "Couldn't connect to database:" . $DBI::errstr;
#
#  Open cursor for roles table 
#

   $csr = $dbh->prepare("Select CONCAT(substr(fund_center_id,3,6) ,' ',
                  release_strategy) 
              from funds_cntr_release_str")
       || die $DBI::errstr ; 

$csr->execute(); 
#
#  Read in rows from the funds_cntr_release_str table
#
   print "Reading in funds_cntr_release_str data from Roles table...\n";
   while ( $rel_str = $csr->fetchrow() ) 
         {
   print F2 $rel_str . "\n";
#   print $rel_str . "\n";        
         }            
  $csr->finish();
  close (F2);

###
#my($rfc_rs, $datafile_dir) =@_;
my $fcrs_file = "$datafile_dir/wh-fcrs";
my ($s_fc, $s_rellist, $model);
my $fcrs_file_1 = "$datafile_dir/rel_str";  # Get  Model 1 FCs

#
#   Open input file.
#
  my $input_command = "cat $fcrs_file_1 $fcrs_file |";
  if( !open(FCRS, $input_command) ) {
    die "$0: can't open ($fcrs_file) - $!\n";
  }

#
#  Read each line from the fc_rs file.  Add an entry to the hash
#  with Fund Center as the key and Release Strategy as the value.
#
 while (chop($line = <FCRS>)) {
   ($s_fc, $s_rellist) = split(" ", $line);
   $s_fc = &strip($s_fc);
   $model = substr(&strip($s_rellist), 0, 1);
   #if ($model eq '1' && substr($s_fc, 0, 3) eq '100') {
   #   print "fc='$s_fc' rellist='$s_rellist' model='$model'\n";
   #}
   $$rfc_rs{$s_fc} = $model;
 }
 close (FCRS);

} 

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
#  Extract cost_collector data from the wh_cost_collector table in
#  the Roles DB.
########################################################################
sub ExistingExtract
{
my($lda, $data_dir) = @_;


$outfile = $data_dir . "whcost.roles";
 
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
           #  . " to_char(w.cost_collector_effective_date,'MM/DD/YYYY'),"
           #  . " to_char(w.cost_collector_expiration_date,'MM/DD/YYYY'),"
 $time0 = time();
 my $stmt = "select w.cost_collector_id_with_type,"
             . " w.cost_collector_id,"
             . " w.cost_collector_type_desc,"
             . " w.cost_collector_name,"
             . " w.organization_id, w.organization_name,"
             . " w.is_closed_cost_collector,"
             . " w.profit_center_id, w.profit_center_name,"
             . " w.fund_id, w.fund_center_id, w.supervisor,"
             . " DATE_FORMAT(w.cost_collector_effective_date,'%m/%d/%Y'),"
             . " DATE_FORMAT(w.cost_collector_expiration_date,'%m/%d/%Y'),"
             . " w.term_code, w.release_strategy,"
             . " w.supervisor_room, w.addressee, w.addressee_room,"
             . " w.supervisor_mit_id, w.addressee_mit_id, w.company_code,"
             . " w.admin_flag"
             . " from wh_cost_collector w"
             . " order by w.cost_collector_id_with_type";
 my $csr = $lda->prepare($stmt)
        || die $DBI::errstr;

$csr->execute();
#
#  Read in rows from the cost_collector table
#
 print "Reading in cost collector data from Roles table...\n";
 my $i = -1;
 while ( ($ccid, $ccidt, $cctype, $ccname, $ccorg_id, $ccorg_name, $cc_closed,
   $pc_code, $pc_name, $fund_code, $fc_code, $cc_supervisor,
   $cc_begin_date, $cc_end_date, 
   $cc_term_code, $cc_release_strategy,
   $cc_supervisor_room, $cc_addressee, $cc_addressee_room,
   $cc_supervisor_id, $cc_addressee_id, $cc_company_code, $cc_admin_flag) 
   = $csr->fetchrow_array() ) {
	if ($cc_begin_date == '00/00/0000')
	{
		$cc_begin_date = '';	
	}
	if ($cc_end_date == '00/00/0000')
	{
		$cc_end_date = '';	
	}
   if (($i++)%5000 == 0) {print $i . "\n";}
   #print "$ccidt FC$fc_code $cc_end_date '$cc_release_strategy'\n";
   print F2 
     "$ccid\|$ccidt\|$cctype\|$ccname\|$ccorg_id\|$ccorg_name\|$cc_closed"
     . "\|$pc_code\|$pc_name\|$fund_code\|$fc_code\|$cc_supervisor"
     . "\|$cc_begin_date\|$cc_end_date\|$cc_term_code\|$cc_release_strategy"
     . "\|$cc_supervisor_room\|$cc_addressee\|$cc_addressee_room"
     . "\|$cc_supervisor_id\|$cc_addressee_id\|$cc_company_code"
     . "\|$cc_admin_flag\n";
 }
 $csr->finish() || die "can't close cursor"; # Close cursor
  
 close (F2);

}

##############################################################################
#
#  Find the differences in two files of cost collectors (for wh_cost_collector)
#  
#  Process the differences to make it easier to do adds, deletes, and
#  updates to wh_cost_collector table in Roles DB.
#
##############################################################################
sub CompareExtract
{

my($data_dir) = @_;

my $file1 = $data_dir . "whcost.roles";
my $file2 = $data_dir . "whcost.warehouse";
my $diff_file = $data_dir . "whcost.diffs";
my $actionsfile = $data_dir . "whcost.actions";
my $temp1 = $data_dir . "whcost1.temp";
my $temp2 = $data_dir . "whcost2.temp";

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
#  Subroutine to add records to wh_cost_collector table
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
#  Subroutine to delete records from the wh_cost_collector table
#
###########################################################################
sub delete_cc {
  my ($lda, $csr, $ccidt) = @_;
  unless ($csr->execute( ($ccidt) )) {
    die $lda->errstr;
  }
}  

########################################################################
#
#  Subroutine to update records in wh_cost_collector table
#
###########################################################################
sub update_cc {
  my $lda = shift;
  my $csr = shift;
  my @token = @_;  # Get the remaining
  my $i;

  #
  #  Now, take the first element in the array and move it to the end.
  #  That's so the cost_collector_id_with_type variable will be the last
  #    parameter for the UPDATE statement.
  #
  my $temp = shift(@token);
  push(@token, $temp);  

  unless ($csr->execute(@token)) {
    for ($i=0; $i<@token; $i++) {
      print "$i $token[$i]\n";
    }
    die $lda->errstr;
  }
}  

#############################################################################
#
#  Use FTP to get fund-related files from the Warehouse
#
#############################################################################

sub FTPFromWarehouse
{

 my($user_id, $user_pw, $ftp_machine, $data_dir) = @_;

 my(@files) = ('wh-fcrs');


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

return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################
