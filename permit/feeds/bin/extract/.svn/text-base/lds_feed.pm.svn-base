##############################################################################
## NAME: lds_feed.pm
##
## DESCRIPTION: 
## This Perl package contains common routines for use by Perl scripts that
## perform the Roles -> LDS feed.
## 
## PRECONDITIONS:
##
## 1.)  use 'lds_feed';
##	 or
##	use 'lds_feed' 1.0;  #This will specify a minimum version number
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
##
## 7/9/1999 Jim Repa. -Created.
## 9/7/1999 Jim Repa. -Modified for different directory; put into production
##
###############################################################################

package lds_feed;
$VERSION = 1.0;
$package_name = 'lds_feed';


#Specify routines to be directly callable via the calling module without
#specifying the name of this package
use Exporter;				#Standard Perl Module
@ISA = ('Exporter');			#Inherit from Exporter	
@EXPORT_OK = 
 qw(GetSequenceLDS IncrSequenceLDS GetLDSFilename GenControlFile);

$TEST_MODE = 0;            ## Test Mode (1 == ON, 0 == OFF)
if ($TEST_MODE) {print "TEST_MODE is ON for lds_feed.pm\n";}

$sequence_file 
 = $ENV{'ROLES_HOMEDIR'} . '/data/lds_feed.sequence_number';

###############################################################################
sub GetLDSFilename	#Get filename of the LDS extract file for SAP dropbox
###############################################################################
{
  my($date, $seqno, $filename);
  if ($TEST_MODE) {print "In $package_name:GetLDSFilename.\n";}
      
  chomp($date = `date '+%Y%m%d%H%M%S'`);
  $seqno = &GetSequenceLDS();
  $seqno = substr($seqno, -3, 3);  # Get last 3 digits
  $filename = "dpayrrdb.$seqno.$date";
  return $filename;

}

###############################################################################
sub GetSequenceLDS	#Read in the next sequence number
###############################################################################
{
  my($seqno);
  if ($TEST_MODE) {print "In $package_name:GetSequenceLDS.\n";}
      
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
sub IncrSequenceLDS # Increment and write out the next sequence number
###############################################################################
{
  my($seqno, $rc);
  if ($TEST_MODE) {print "In $package_name:GetSequenceLDS.\n";}
      
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
  if ($name eq 'no') {
    die "File $in_file not found\n";
  }

  my ($records, $words, $bytes, $name) = split(' ', $wc_line);
  
  $bytes = substr('0000000000000000' . $bytes, -16, 16);
  $records = substr('0000000000000000' . $records, -16, 16);
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

	print &GetSequenceLDS . "\n";

	return;
}


return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################
