 ###############################################################################
## NAME: roles_base.pm
##
## DESCRIPTION: 
## This package contains common routines for the roles database data feeds
## The following command should appear in each module that uses this
## routines:
## 	use roles_base qw(UsageExit ScriptExit RolesLog RolesNotification
##		ArchiveFile);
##
## ENHANCEMENT TODO LIST:
## REQUIRED:
## -
##
## OPTIONAL
## -
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
##
## MODIFICATION HISTORY:
## 11/05/1997 Jonathan Ives -Created.
## 12/15/1997 Jonathan Ives -Modified:
## 12/29/1997 Jonathan Ives -Moved into "rolesdb" Test environment
## 1/14/1998  Jonathan Ives -Modified ArchiveFile (Put Z after Time Stamp)
## 2/2/1998   Jonathan Ives -Added -f option to force compression
##			-Corrected message type indicator in ArchiveFile
## 3/4/1999   Jim Repa - Modified (remove jives.mit.edu)
## 6/14/2007  Jim Repa, Marina Korobko
##                      -- added the subroutine "find_max_actions_value"                  
###############################################################################

package roles_base;
$VERSION = 1.0; 

use Exporter;				#Standard Perl Module
@ISA = ('Exporter');			#Inherit from Exporter	
@EXPORT_OK =  
  qw(UsageExit login_dbi_sql ScriptExit RolesLog RolesNotification ArchiveFile find_max_actions_value find_max_actions_value2  ExecuteSQLCommands);
					#These routine names may be imported
					#into the calling modules name space
## Set Test Mode
$TEST_MODE = 0;            ## Test Mode (1 == ON, 0 == OFF)
if ($TEST_MODE) {print "TEST_MODE is ON for roles_base.pm\n";}

## Get Script Name
use config('GetValue');
use File::Basename qw(fileparse);		##Perl Distributed Module
($base,$path,$type) = fileparse($0,'\.*');
$scriptname =$base . $type;

###############################################################################
## Initialize Email Mechanism
###############################################################################
use email;
if ($TEST_MODE)	{$EMAIL_TO_DEFAULT = "repa\@mit.edu";}
else {$EMAIL_TO_DEFAULT = "repa\@mit.edu";}

$EMAIL_TO_FILE = $ENV{'ROLES_HOMEDIR'} . "/lib/roles_notify";## Email address file for notification
                                ## File format: one email address per
				## line followed by a newline.

#$EMAIL_FROM = `whoami` . "\@" . `hostname` . "\.mit\.edu"; 
my $temp_username = `who am i`;
$temp_username =~ /([^ ]*) (.*)/;
#print "temp_username = '$temp_username'\n";
$EMAIL_FROM = $1 . "\@" . `hostname` . "\.mit\.edu"; 
$EMAIL_FROM =~ s/\n//g;
#print "EMAIL_FROM = '$EMAIL_FROM'\n";
$EMAIL_REPLY = $EMAIL_TO_DEFAULT; 
$EMAIL_SUBJECT_STUB = $scriptname; ## Additional Info will be appended

if (-r $EMAIL_TO_FILE) {$to =$EMAIL_TO_FILE;}
	else  {$to =$EMAIL_TO_DEFAULT;}

$email_object = &email::EmailInit($to, $EMAIL_FROM, $EMAIL_REPLY, $EMAIL_SUBJECT_STUB);

###############################################################################
##Initialize Logging Mechanism
###############################################################################
use log;	##Custom Perl Module

$DEFAULT_MSG_MODE = 'WARNING_MSG';

if ($ENV{'ROLES_VERBOSE'} eq 'TRUE')
	{
		$DEFAULT_MSG_MODE = 'INFO_MSG';
	}

$log_object = &log::LogInit($scriptname, $DEFAULT_MSG_MODE);
        ## NOTE: Logging mode can be changed via calls to &LogMode
        ## "INFO_MSG"    - Display All
        ## "WARNING_MSG" - Display Warning & Fatal
	## "FATAL_MSG"   - Display Fatal Only
&RolesLog("INFO_MSG", "Logging Mechanism Iniated");




###############################################################################
###############################################################################
##
## Subroutines - Common Routines to be used by calling packages
##
###############################################################################
###############################################################################

###############################################################################
sub RolesLog  #Base Routine for logging messages
###############################################################################
{
	if ($TEST_MODE) {print "In RolesLog.\n";}


	my($msg_type, $msg) = @_;
	my($package_name) = caller;

	&log::LogSystem($log_object, "script $scriptname package $package_name");
	&log::LogMessage($log_object, $msg_type, $msg);

	return;
}


###############################################################################
sub RolesNotification  #Base Routine for sending notifying of problems
###############################################################################
{
	if ($TEST_MODE) {print "In RolesNotification.\n";}

	my($sub, $msg) = @_;
	($package_name) = caller;

	$sub = "$package_name:" . $sub;		## Pre-pend the calling package
	&email::EmailSend($email_object, $sub, $msg);

	return;
}


###############################################################################
sub UsageExit
###############################################################################
{
	if ($TEST_MODE) {print "In UsageExit.\n";}

	my ($opt_msg) = @_;

	my ($usage_string) = "\nusage:\t $scriptname <command> <feed> <DB Parameter>\n";

	$usage_string .= "\nValid Commands:\n";
	$usage_string .= "\troles_extract\n";
	$usage_string .= "\troles_load\n";
	$usage_string .= "\texternal_extract\n";

	$usage_string .= "\nValid Feeds:\n";
	$usage_string .= "\tperson\tPerson Table Feed \n";
	$usage_string .= "\taorg*\tAdmissions Org Units Qualifier Table Feed\n";
	$usage_string .= "\tcost*\tSAP Cost Collectors Qualifier Table Feed\n";
	$usage_string .= "\torgu*\tPersonnel Org Units Qualifier Table Feed\n";
	$usage_string .= "\tprof*\tSAP Profit Center Qualifier Table Feed\n";
	$usage_string .= "\tfund*\tSAP Fund Center Qualifier Table Feed\n";
	$usage_string .= "\n\t*These feeds have not been implemented yet\n\n";

	$usage_string .= "DB Parameter:\n";
	$usage_string .= "\t<user_name>/<password>@<db name>\n";
	$usage_string .= "\tor\n";
	$usage_string .= "\t<Configuration File Variable Name>\n";

	if (defined $opt_msg) {$usage_string .= "\n$opt_msg\n";}

	print $usage_string;

	&ScriptExit(1, "Usage Exit, $opt_msg"); #Assume exit status is Bad
}


###############################################################################
sub ScriptExit
###############################################################################
{
	if ($TEST_MODE) {print "In ScriptExit.\n";}

	my ($exit_status, $opt_msg) = @_;

	## Set Defaut Exit Status
	if (not defined $exit_status)
	{
	 $exit_status = 0; #Default to Good Exit Status 
	}

	## Set Message Mode
	my($msg_mode) = "INFO_MSG";  #Default Message Mode
	if ($exit_status != 0)
	{
		$msg_mode = "WARNING_MSG";
	}

	## Handle Optional Exit Message
	if ($opt_msg) 
	{
		if ($log_object)
		{
			&RolesLog($msg_mode, "Script Exit, $opt_msg");
		}
		else
		{
			print "$opt_msg\n"; #Always print it.
		}
	}


	## Log Off Database
	if (defined $lda_db)
	{
	  &RolesLog("INFO_MSG", "Logging Off Database.");
		$lda_db->disconnect();
	  //&ora_logoff($lda_db);
	}

	## Close Email Mechanism
	if ($email_object){&email::EmailClose($log_object);}

	## Close Logging Mechanism
	if ($log_object){&log::LogClose($log_object);}

	## Exit
	if ($TEST_MODE) {
		if ($exit_status)
			{print "Bad Exit Status ($exit_status)\n";}
		else {print "Good Exit Status ($exit_status)\n";}
	}
	exit $exit_status; ## good(=0) bad(<>0) 
}

###############################################################################
sub ArchiveFile	#Move an existing file to the archive directory
###############################################################################
{
	if ($TEST_MODE) {print "In ArchiveFile.\n";}

	my($filename, $archive_directory) = @_;


	#Check Arguements
	unless (-r $filename)
		{
		&RolesLog("WARNING_MSG",
			"Can't Read File $filename");
		return -1;
		}

	unless (-w $archive_directory)
		{
		&RolesLog("WARNING_MSG",
			"Can't write to archive directory $archive_directory");
		return -1;
		}

	#Compress the File
	my($compress_cmd) = "compress -f $filename";

	if (system($compress_cmd)) #Non-Zero would be an error
	{
		&RolesLog("WARNING_MSG",
			"Unable to compress file $filename");
		return -1;
	}

	$filename .= '.Z';	#compress adds a .Z to the file name


	unless (-r $filename)
		{
		&RolesLog("WARNING_MSG",
			"Can't Read Compressed File $filename");
		return -1;
		}

	#Determine Date/Time Stamp For Archive File

	#Copy File (Move won't work if archive is on another drive/volumn)
	my($date_stamp) = ":ARCHIVE" . `date '+%Y%m%d%H%M%S'`;
	chomp($date_stamp);
	my($base,$path,$type) = fileparse($filename, '\.Z');
	my($archive_file) = $archive_directory . $base . $date_stamp . $type;
	my($copy_cmd) = "cp $filename $archive_file";

#	print "$base: $path : $type\n";
#	print "$copy_cmd\n";

	if (system($copy_cmd)) #Non-Zero would be an error
	{
		&RolesLog("WARNING_MSG",
			"Unable to copy file to archive directory");
		return -1
	}


	#Remove Original File

	my($rm_cmd) = "rm $filename";

	if (system($rm_cmd)) #Non-Zero would be an error
	{
		&RolesLog("WARNING_MSG",
			"Unable to remove original file in data directory");
		return -1
	}


	return;
}

##########################################################################
# This will be deprecated. Do not use. Use find_max_actions_value2
sub find_max_actions_value {
##########################################################################
 my ($db_name, $parm) = @_;
 #
 #
 #
 #Make sure we are set up to use DBI.
   use DBI; 
# Get parameters needed to open an Oracle connection to the Roles database
#
# Database name is taken from global variable $db_id from roles_feed program
   my $db_parm =  GetValue($db_name); # Info about database from config file
   $db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
   my $user_id = $1;
   my $user_pw = $2;
   my $db_id = $3;
   #print "db_name='$db_name'\n"; 
# Open connection to oracle
#
   #print "db_id='$db_id' user_id='$user_id' \n";
   my $dbh =  DBI->connect( $db_id, $user_id, $user_pw, {RaiseError =>1})
                                || die "Couldn't connect to database:" . $DBI->errstr;
#   print "Connected\n";
#   print "dbh= '$dbh'\n";
#  
     my $crs1 = $dbh->prepare ("SELECT parameter, value
              FROM rolesbb.roles_parameters ") 
             || die $dbh->errstr;  
     $crs1->execute();  
    
     while (($parameter,$max_actions) = $crs1->fetchrow_array())
     {
      if ($parameter eq $parm)
      {   
          $crs1->finish();
          return $max_actions;     
      }        
     };
}

##########################################################################
sub find_max_actions_value2 {
##########################################################################
 my ($db_id, $user_id,$user_pw,$parm) = @_;
 #
 #
 #
 #Make sure we are set up to use DBI.
   use DBI;
# Get parameters needed to open an Oracle connection to the Roles database
#
# Open connection to DB
#
   #print "find_max_actions_value2- db_id='$db_id' user_id='$user_id' \n";
   my $dbh =  DBI->connect( $db_id, $user_id, $user_pw, {RaiseError =>1})
                                || die "Couldn't connect to database:" . $DBI->errstr;
   print "Connected\n";
   print "dbh= '$dbh'\n";
# 
     my $crs1 = $dbh->prepare ("SELECT parameter, value  
              FROM rolesbb.roles_parameters WHERE parameter = '$parm'")
             || die $dbh->errstr;
     $crs1->execute();
   
      ($parameter,$max_actions) = $crs1->fetchrow_array();
   	print "Results: '$parameter' '$max_actions'\n";
        $crs1->finish();
	$dbh->disconnect();
        return $max_actions;
}


###############################################################################
sub PackageTest	#Run specified tests for this package
###############################################################################
{
	if ($TEST_MODE) {print "In PackageTest base class subroutine.\n";}

#	RolesNotification();
#	UsageExit();
#	ScriptExit();

	return;
}

##############################################################################
#
# Subroutine login_dbi_sql($symbolic_db_name)
#
# Use this to login to database.  Try
# up to 3 times.
#
##############################################################################
sub login_dbi_sql
{
 	my ($db_id, $user,$pw) = @_;
        print "DB: '$db_id' User: '$user' ";
        for (my $i = 0; $i < 3; $i++) {  # Retry 3 times
            if (my $lda = DBI->connect($db_id, $user, $pw)) {
                $lda->{AutoCommit}    = 0;
                $lda->{RaiseError}    = 1;
               return $lda;
           }
        }
        print "Connect to database '$db' failed after 3 tries.<BR>\n";
        print "$DBI::errstr . <BR>\n";
        return 0;
}

###############################################################################
# Execute set if SQL Statements in a file in one transaction (Commit or Rollback on failure)
###############################################################################
sub ExecuteSQLCommands
{
        print ("In ExecuteSQLCOmmands");
        my($filename,$dbh) = @_;
	
	# cache old values
        my $errValue = $dbh -> {RaiseError} ;
        my $commitVal = dbh -> {AutoCommit};
        $dbh -> {RaiseError} = 1;
        $dbh -> {AutoCommit} = 0;

        open (INPUT, "$filename") || warn "Could not open file $filename : $!\n";
        while (<INPUT>)
        {
                print $_;
                $_ =~ s/\\/\\\\/g;
                $dbh->do($_) || die $DBI::error;
        }
        $dbh->commit();
	#restore old values
        $dbh -> {RaiseError} = $errValue;
        $dbh -> {AutoCommit} = $commitVal;
}
#################################################################################

return 1;



#########################################################################
#######################       End Package          ######################  
#########################################################################
