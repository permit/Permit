##############################################################################
## NAME: rdb_ehs_feed.pm
##
## DESCRIPTION: 
## This Perl package contains common routines for use by Perl scripts that
## perform the Roles -> SAPBUD feed.
## 
## PRECONDITIONS:
##
## 1.)  use 'rdb_ehs_feed';
##	 or
##	use 'rdb_ehs_feed' 1.0;  #This will specify a minimum version number
##
## 2.)	$ROLES_HOMEDIR environment variable must be set
##
## POSTCONDITIONS:   
##
## 1.) None.
##
## ENHANCEMENT TODO LIST:
## REQUIRED:
## -
#
#  Copyright (C) 2004-2010 Massachusetts Institute of Technology
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
## 9/16/2004 Jim Repa. -Created.
##
###############################################################################

package rdb_ehs_feed;
$VERSION = 1.0;
$package_name = 'rdb_ehs_feed';

#
use config('GetValue');  # Use the subroutine GetValue in ~/lib/cpa/config.pm

#Specify routines to be directly callable via the calling module without
#specifying the name of this package
use Exporter;				#Standard Perl Module
@ISA = ('Exporter');			#Inherit from Exporter	
@EXPORT_OK = 
 qw(GetSequenceEHS IncrSequenceEHS GetEHSFilename GenControlFile 
    GenControlFile2 run_pgp_for_sap_dropbox);

$TEST_MODE = 0;            ## Test Mode (1 == ON, 0 == OFF)
if ($TEST_MODE) {print "TEST_MODE is ON for rdb_ehs_feed.pm\n";}

$sequence_file 
 = $ENV{'ROLES_HOMEDIR'} . '/data/ehs/rdb_ehs_feed.sequence_number';
$g_pgp_cmd = "/opt/PGP/pgp";

###############################################################################
sub GetEHSFilename	#Get filename of the EHS extract file for SAP dropbox
###############################################################################
{
  my($date, $seqno, $filename);
  if ($TEST_MODE) {print "In $package_name:GetEHSFilename.\n";}
      
  chomp($date = `date '+%Y%m%d%H%M%S'`);
  $seqno = &GetSequenceEHS();
  $seqno = substr($seqno, -3, 3);  # Get last 3 digits
  $filename = "drldberr.$seqno.$date";
  return $filename;

}

#########################################################################
# 
# Subroutine &run_pgp_for_sap_dropbox($target_file, $pgp_parm);
# 
#  Runs PGP to encrypt a file
#
#########################################################################
sub run_pgp_for_sap_dropbox {
  my ($target_file, $pgp_parm) = @_;
  
  my $input_path = $target_file;

 #
 # Get the PGP key-phrase
 #
  my $pgp_config_line = &GetValue($pgp_parm);
  $pgp_config_line =~ m/^(.*)\/(.*)\@(.*)$/;
  my $pw  = $2;

 #
 # Run PGP
 #
  my $rc = system("$g_pgp_cmd -cta $input_path -z $pw +batchmode +force");

  if ($rc) # Should get 0 return code
   {
       print "Error trying to run PGP on $input_path\n";
       die "Error trying to run PGP on $input_path\n";
   }
  
}

###############################################################################
sub GetSequenceEHS	#Read in the next sequence number
###############################################################################
{
  my($seqno);
  if ($TEST_MODE) {print "In $package_name:GetSequenceEHS.\n";}
      
  unless (open (SFILE, $sequence_file)) {
      my($err_str) = 
        "Can't open sequence no. file '$sequence_file'.\n";
      die $err_str;
  }

  chomp($seqno = <SFILE>);
  close SFILE;	

  unless ($seqno =~ /^\d{8}$/) {
      my($err_str) = 
        "Invalid number '$seqno' found in sequence file..\n";
      die $err_str;
  }

  return $seqno;

}

###############################################################################
sub IncrSequenceEHS # Increment and write out the next sequence number
###############################################################################
{
  my($seqno, $rc);
  if ($TEST_MODE) {print "In $package_name:GetSequenceEHS.\n";}
      
  unless (open (SFILE, $sequence_file)) {
      my($err_str) = 
        "Can't open sequence no. file '$sequence_file'.\n";
      die $err_str;
  }

  chomp($seqno = <SFILE>);
  close SFILE;	

  unless ($seqno =~ /^\d{8}$/) {
      my($err_str) = 
        "Invalid number '$seqno' found in sequence file..\n";
      die $err_str;
  }

  $seqno = substr(++$seqno, -8, 8);
  #print "New seqno = '$seqno'\n";
  $rc = system("echo $seqno > $sequence_file");

  unless ($rc == 0) {
      my($err_str) = 
        "Can't write incremented sequence number to '$sequence_file'.\n";
      die $err_str;
  }
    

  return $seqno;

}

###############################################################################
sub GenControlFile # Generate a control file for the SAP dropbox 
###############################################################################
{
  my ($in_file, $ctl_file) = @_;
  my ($wc_line);
  if ($TEST_MODE) {print "In $package_name:GenControlFile.\n";}

  chomp ($wc_line = `wc $in_file`);

  my ($records, $words, $bytes, $name) = split(' ', $wc_line);
  if ($name eq 'no') {
    die "File $in_file not found\n";
  }
  
  $bytes = substr('0000000000000000' . $bytes, -16, 16);
  $records = substr('0000000000000000' . $records, -16, 16);
  my $outline = "$bytes$records";
  my $rc = system("echo $outline > $ctl_file\n");

  unless ($rc == 0) {
      die "Cannot write $ctl_file\n";
  }

}

###############################################################################
sub GenControlFile2 # Generate a control file for the SAP dropbox 
###############################################################################
{
  my ($ctl_file, $byte_count, $record_count) = @_;
  my ($wc_line);
  if ($TEST_MODE) {print "In $package_name:GenControlFile2.\n";}

  $bytes = substr('0000000000000000' . $byte_count, -16, 16);
  $records = substr('0000000000000000' . $record_count, -16, 16);
  my $outline = "$bytes$records";
  my $rc = system("echo $outline > $ctl_file\n");

  unless ($rc == 0) {
      die "Cannot write $ctl_file\n";
  }

}

###############################################################################
sub PackageTest	#Callable Package Test Routine 
###############################################################################
{
	if ($TEST_MODE) {print "In $package_name:PackageTest.\n";}

	print &GetSequenceEHS . "\n";

	return;
}


return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################
