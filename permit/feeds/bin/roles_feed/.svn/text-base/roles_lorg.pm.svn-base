##############################################################################
## NAME: roles_lorg.pm
##
## DESCRIPTION: Subroutines related to qualifier feed for 'LORG' qualifiers
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
## Created 01/21/1999, Jim Repa
## Modified 03/15/1999, Jim Repa - Use FTP to get wh-hrp1000 from warehouse.
## Modified 06/12/1999, Jim Repa - Change and change back.
## Modified 12/04/2001, Jim Repa - Use only first 40 chars. of name
## Modified 07/13/2007 M.Korobko
##   --  use table roles_parameters to find MAX_ACTIONS allowed
###############################################################################

package roles_lorg;
$VERSION = 1.0; 
$package_name = 'roles_lorg';

## Standard Roles Database Feed Package
#use roles_base qw(UsageExit ScriptExit RolesLog RolesNotification ArchiveFile);
use roles_base qw(UsageExit login_dbi_sql ScriptExit RolesLog RolesNotification ArchiveFile
                  find_max_actions_value find_max_actions_value2  ExecuteSQLCommands);
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

#############################################################################
#
#  Use FTP to get hrp1000 file from the Warehouse
#
#############################################################################

sub FTPFromWarehouse
{

 my($user_id, $user_pw, $ftp_machine, $data_dir) = @_;

 my(@files) = ('wh-hrp1000'); 
 
#
#  Run FTP
#
 open (FTP, "|ftp -n -v $ftp_machine\n");
 ### The following line was uncommented, 7/1/2004. Difference on Solaris?
 print FTP "user $user_id $user_pw\n";

 print FTP "lcd $data_dir\n";
 print FTP "ls -l\n";
 for ($i = 0; $i < @files; $i++) {
   print FTP "get $files[$i]\n";
 }
 print FTP "quit\n";
 close (FTP);
 print "\nFTP completed.\n";

#
#  Write out an empty file.
#
  #$empty_file = $datafile_dir . 'wh-hrp1000';
  #unless (open(F3, ">$empty_file")) {
  #  die "$0: can't open output file ($empty_file) - $!\n";
  #}
  #close(F3);

}

###############################################################################
sub FeedExtract	#Externally Callable Extract Routine for this Package
###############################################################################
{
        my $infile = $datafile_dir . 'wh-hrp1000';
        my $pcfile = $datafile_dir . "wh-profctr";
        $outfile = $datafile_dir . "lorg.warehouse";

	if ($TEST_MODE) {print "In $package_name:FeedExtract.\n";}

	shift; #Get rid of calling package name

	## Step 0: Check Arguments
	if ($#_ != 2) {&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
	my($user_id, $user_pw, $ftp_machine) = @_;

        #
        #  Call FTPFromWarehouse to get the hrp1000 file.
        #
        #print "*****user=$user_id node=$ftp_machine\n";
	&FTPFromWarehouse($user_id, $user_pw, $ftp_machine, $datafile_dir);
        
#
#   Read in records from the input HRP1000 file from SAP
#
  unless (open(F1, $infile)) {
    die "$0: can't open input file ($infile) - $!\n";
  }
  my %lorg6_to_8 = ();  # This hash will map org. unit fmt. nnnnnn -> 7000nnnn
  my %lorg_to_name = ();  # This hash will map org. unit no. -> name
  my ($line, $org8, $org6, $orgname);
  while (chomp($line = <F1>)) {
    $org8 = substr($line, 7, 8);  # 8-digit org unit ID 7000nnnn
    if (substr($line, 0, 5) eq '03090') {  # Take only plan 90 lines
      $org6 = substr($line, 81, 6); # 6-digit org unit ID 
      $orgname = &strip(substr($line, 93, 40)); # Org unit name
      $lorg6_to_8{$org6} = $org8;
      $lorg_to_name{$org6} = $orgname;
      #print "6-digit='$org6' 8-digit='$org8' name='$orgname'\n";
    }
  }
  close(F1);

#
#   Open output file.
#
  $outf = ">" . $outfile;
  if( !open(F2, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }

#
#  Get username and password for database connection.
#
        $db_parm = GetValue("roles");
  	$db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
        $user_id = $1;
	$user_pw  = $2;
	$db  = $3;

 
#
#  Open connection to oracle
#
 #print "db_id=$db user_id=$user_id\n";
 my($lda) = login_dbi_sql($db, $user_id, $user_pw)
  	|| die $DBI::errstr;

#
#  Open first cursor, to find all 0H nodes with their parent.  We will
#  then count the number of children of each of these nodes and skip over
#  them if there is only one child.
#
 $stmt = "select q1.qualifier_code parent_code, q2.qualifier_code child_code",
          " from qualifier_child qc, qualifier q1, qualifier q2",
          " where qc.parent_id = q1.qualifier_id",
          " and qc.child_id = q2.qualifier_id",
          " and q2.qualifier_type = 'COST'",
          " and substr(q2.qualifier_code,1,2) in ('0H','PC')";
 $csr = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";

 $csr->execute();

#
#  Build a hash of 0H nodes and their parents.  Build another hash of
#  each of these nodes to count the number of their children.
#
 my %child_to_parent = ();
 my %child_count = ();
 while (($qqparcode, $qqcode) = $csr->fetchrow_array()) {
   $qqparcode =~ s/^0HPC/0HL/;
   $qqcode =~ s/^0HPC/0HL/;
   $qqcode =~ s/^PC//;
   $child_to_parent{$qqcode} = $qqparcode;
 }
 $csr->finish() || die "can't close cursor";

#
#  Count the number of children of each of the 0H nodes
#  
 foreach $qqcode (keys %lorg6_to_8) {
   $qqparcode = $child_to_parent{$qqcode};
   if ($qqparcode) {  # Is parent found?
     $child_count{$qqparcode}++;
   }
 }

#
#  Find nodes with one child
#
 #foreach $qqcode (keys %child_count) {
 #  if ($child_count{$qqcode} == 1) {
 #    print "$qqcode has only 1 child\n";
 #  }
 #}

#
#  Open 2nd cursor, to read all 0H* and PC* records of qualtype COST
#  from the Qualifier table.
#
 $stmt = "select q1.qualifier_code, q2.qualifier_code, q2.qualifier_name,",
          " q2.qualifier_level",
          " from qualifier q1, qualifier_child qc, qualifier q2",
          " where q1.qualifier_type = 'COST'",
          " and q1.qualifier_id = qc.parent_id",
          " and qc.child_id = q2.qualifier_id",
          " and substr(q2.qualifier_code,1,2) in ('0H', 'PC')",
          " order by 4, 1, 2";
 $csr = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";

 $csr->execute();

#
#  Write out a made-up record for the root of the LORG tree.
#  Also write out a made-up record as a parent to all LD Org. Units that
#   are not valid Profit Centers.
#  ** As of 6/14/1999, do not write out 0HL00_LD_ONLY node.
#
   printf F2 "%s!%s!%s!%s\n",
           'LORG', '0HL00_MIT', '', 
           'All LDS Org. Units';
   #printf F2 "%s!%s!%s!%s\n",
   #        'LORG', '0HL00_LD_ONLY', '0HL00_MIT', 
   #        'LDS Org. Units that are not valid Profit Centers';

#
#  As we look at all the Profit Centers from the COST hierarchy, mark
#  each LD Org. Unit that we find.  Later, we'll put the leftover ones in
#  a special place in the hierarchy.
#
 my %lorg6_is_a_pc = ();  # Use this hash to mark org. units that match PC's

#
#  Look in qualifier table, qualifier_type='COST', for
#  qualifiers with a code like 0H%.
#
 print "Reading in COST qualifiers from Oracle table...\n";
 $i = -1;
 my $newparcode;
 my %lev6_parent = ();  # Store mapping of level-6+ parents to level-5 nodes
 ROW: while (($qqparcode, $qqcode, $qqname, $qqlevel) = $csr->fetchrow_array()) {
   $qqcode =~ s/^0HPC/0HL/;
   $qqcode =~ s/^PC//;
   #next ROW if ($child_count{$qqcode} == 1);  # Skip this node?
   $org6 = $qqcode;
   $qqparcode =~ s/^0HPC/0HL/;
   if (($qqcode =~ /^0HL/) && ($qqlevel > 5)) {  # Skip over level-6 nodes
     $newparcode = $qqparcode;
     while ($lev6_parent{$newparcode}) {
       $newparcode = $lev6_parent{$newparcode};
     }
     $lev6_parent{$qqcode} = $newparcode;
     next ROW;  # Don't write out this node.
   }
   #if ($child_count{$qqparcode} == 1) {  # Skip the parent node?
   #   $newparcode = $child_to_parent{$qqparcode}; # Find parent of parent
   #   if ($newparcode) {
   #     $qqparcode = $newparcode;  # Reset the parent.
   #   }
   #}
   # See if the parent code is level 6 or lower;  if so, point to its parent
   while ($lev6_parent{$qqparcode}) {
     $qqparcode = $lev6_parent{$qqparcode};
   }
   #
   if ( ($qqcode =~ /0HL/) || ($lorg6_to_8{$org6}) ) {
     if ($lorg_to_name{$org6}) {
       $lorg6_is_a_pc{$org6} = 1;  # Mark this one as found in PC list
       $org8 = $lorg6_to_8{$org6}; # Save this for a moment
       $qqname = $lorg_to_name{$org6};
       # Print out a record for the 700... qualifier node,
       # and print out a record for the nnnnnn PC
       # Skip records where $qqparcode = 0HL999999 (as of 6/14/1999)
       # Don't skip 0HL999999 (as of 9/16/1999)
       #if ($qqparcode ne '0HL999999') {
         printf F2 "%s!%s!%s!%s\n",
                 'LORG', $org8, $qqparcode, $qqname;
         printf F2 "%s!%s!%s!%s\n",
                 'LORG', $qqcode, $org8, $qqname;
       #}
     }
     else {  # Just print out one record for the 0HL node
       # Skip 0HL999999 (as of 6/14/1999)
       # Don't skip 0HL999999 (as of 9/16/1999)
       #if ($qqcode ne '0HL999999') {
         printf F2 "%s!%s!%s!%s\n",
                   'LORG', $qqcode, $qqparcode, $qqname;
       #}
     }
   }
 }
 $csr->finish() || die "can't close cursor";

#
#  Now, read in the file of profit centers (wh-profctr) to look for LDS
#  "sub-profit centers", i.e., profit centers that are children of the
#  7nnnnnnn org units.  Ignore profit centers whose parent is P999999.
#  Also, skip over profit centers that were already found in the HRP1000
#  file.  For the rest, add them as children of the appropriate 7nnnnnnn
#  org unit.
#
 unless (open(IN,$pcfile)) {
   die "Cannot open $pcfile for reading\n"
 }
 $i = -1;
 print "Reading $pcfile...\n";
 PCROW: while (chop($line = <IN>)) {
   #if (($i++)%100 == 0) {print $i . "\n";}
   $qqcode = &strip(substr($line, 0, 10));
   $qqcode =~ s/P//;  # Remove profit center prefix
   $qqname = &strip(substr($line,107,40));  # added ",40" 12/4/2001
   $qqpar = '0HL' . &strip(substr($line,95,12));
   $qqpar =~ s/P//;  # Change profit center prefix
   next PCROW if ($qqpar eq '0HL999999'); # Skip if inactive PC
   next PCROW if ($lorg6_is_a_pc{$qqcode}); #Skip if we've already got this PC
   $org8 = &strip(substr($line,63,12));  # Get the 7nnnnnnn org unit
   if ($org8) {  # Ignore PCs where parent is blank
     printf F2 "%s!%s!%s!%s\n",
             'LORG', $qqcode, $org8, $qqname;
   }
 }
 close(IN);

#
#  Now find all the LD Org. Units that did not match a PC.
#  ** As of 6/14/1999, we'll skip this.  There should not be any LD Org.
#  ** Units that do not match a PC.
#
 if (1 == 0) {  # Don't run this piece of code
 $qqparent = '0HL00_LD_ONLY';
 foreach $org6 (sort keys %lorg_to_name) {
   #print $org6 . ' ' . $lorg_to_name{$org6} . "\n";
   if (!$lorg6_is_a_pc{$org6}) {
       $qqcode = &strip($org6);
       $qqcode =~ tr/a-z/A-Z/;   # Raise code to upper case
       $qqcode =~ s/ /_/g;   # Turn each blank into an underscore
       $org8 = $lorg6_to_8{$org6};  # Get the 7nnnnnnn org unit
       $qqname = &strip($lorg_to_name{$org6});
       if (!$qqname) {$qqname = 'MISTAKE IN THE TABLE HRP1000.';}
       #if (length($qqname) > 39) {$qqname = substr($qqname, 0, 39);}
       #$qqname = $qqname . ' (' . $lorg6_to_8{$org6} . ')';
       printf F2 "%s!%s!%s!%s\n",
             'LORG', $org8, $qqparent, $qqname;
       printf F2 "%s!%s!%s!%s\n",
             'LORG', $qqcode, $org8, $qqname;
   }
 }
 } # Don't run this piece of code
 
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

	my($infile) = $datafile_dir . "lorg.actions";
	my($sqlfile) = $datafile_dir . "lorgchange.sql";
	my($sqlfile2) = $datafile_dir . "lorgdesc.sql";
	my($qualtype) = "LORG";

	## Step 0: Check Arguments
	if ($#_ != 2){&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
	my($user_id, $user_pw, $db_id) = @_;


	## Check number of actions to be preformed
        $MAX_ACTIONS = &find_max_actions_value2($db_id, "MAX_LORG");
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
	ExecuteSQLCommands($sqlfile2,$destination_lda);

        # Run the 2nd .sql file
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
#  Extract LORG data from qualifier table of Roles DB.
#
########################################################################
sub ExistingExtract
{
my($lda, $data_dir) = @_;

$outfile = $data_dir . "lorg.roles";
$qqualtype = 'LORG';
 
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
 $stmt = "select q2.qualifier_code, q.qualifier_id, q.qualifier_code," 
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
          . " order by 3";
 $csr = $lda->prepare($stmt)
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
#  Find the differences in two files of Depts. and PIs.
#  Process the differences to make it easier to do adds, deletes, and
#  updates to qualifier table in Roles DB.
#
##############################################################################
sub CompareExtract
{

my($data_dir) = @_;

my $file1 = $data_dir . "lorg.roles";
my $file2 = $data_dir . "lorg.warehouse";
my $diff_file = $data_dir . "lorg.diffs";
my $tempactions = $data_dir . "lorg.actions.temp";
my $actionsfile = $data_dir . "lorg.actions";
my $temp1 = $data_dir . "lorg1.temp";
my $temp2 = $data_dir . "lorg2.temp";
 
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
       . " sed 's/< LORG/<\!LORG/' |"    # Add ! field marker
       . " sed 's/> LORG/>\!LORG/' |"    # Add ! field marker
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
#   Reorder LORG actions
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
