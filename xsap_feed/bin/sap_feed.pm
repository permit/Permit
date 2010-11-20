###############################################################################
## NAME: sap_feed.pm
##
## DESCRIPTION: 
## This Perl package contains common routines for use by Perl scripts that
## perform the Roles -> SAP feed.
## 
## PRECONDITIONS:
##
## 1.)  use 'sap_feed';
##	 or
##	use 'sap_feed' 1.0;  #This will specify a minimum version number
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
## MODIFICATION HISTORY:
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
## 11/03/1998 Jim Repa. -Created.
## 05/06/1999 Jim Repa. -Added &TransformFilename function
##
###############################################################################

package sap_feed;
$VERSION = 1.0;
$package_name = 'sap_feed';


#Specify routines to be directly callable via the calling module without
#specifying the name of this package
use Exporter;				#Standard Perl Module
@ISA = ('Exporter');			#Inherit from Exporter	
@EXPORT_OK = qw(GetSequence IncrSequence TransformFilename);

$TEST_MODE = 0;            ## Test Mode (1 == ON, 0 == OFF)
if ($TEST_MODE) {print "TEST_MODE is ON for sap_feed.pm\n";}

$sequence_file 
 = $ENV{'ROLES_HOMEDIR'} . '/xsap_feed/data/sap_feed.sequence_number';


###############################################################################
sub GetSequence	#Read in the next sequence number
###############################################################################
{
  my($seqno);
  if ($TEST_MODE) {print "In $package_name:GetSequence.\n";}
      
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
sub IncrSequence # Increment and write out the next sequence number
###############################################################################
{
  my($seqno, $rc);
  if ($TEST_MODE) {print "In $package_name:GetSequence.\n";}
      
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
sub TransformFilename # Adjust filenames to fit SAP request.
###############################################################################
{
  my ($old_filename) = @_;
  my $suffix = '.ROLESP';
  my $new_filename;
  if ($TEST_MODE) {print "In $package_name:TransformFilename.\n";}

  $new_filename = $old_filename . $suffix;  # Add suffix
  $new_filename =~ tr/a-z/A-Z/;             # Translate to uppercase

  return $new_filename;

}

###############################################################################
sub PackageTest	#Callable Package Test Routine 
###############################################################################
{
	if ($TEST_MODE) {print "In $package_name:PackageTest.\n";}

	print &GetSequence . "\n";

	return;
}


return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################
