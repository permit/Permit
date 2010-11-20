###############################################################################
## NAME: config.pm
##
## DESCRIPTION: 
## This Perl package contains common routines for reading strings from a
## simple configuration file of the following format:
##
##	VARIABLENAME:VALUE
##
## 
## PRECONDITIONS:
##
## 1.)  use 'config';
##	 or
##	use 'config' 1.0;  #This will specify a minimum version number
##
## 2.)	$ROLES_CONFIG environment variable must be set
##
## POSTCONDITIONS:   
##
## 1.) None.
##
## ENHANCEMENT TODO LIST:
## REQUIRED:
## -
##
## OPTIONAL
## -Use log instead of 'die' ? 
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
## MODIFICATION HISTORY:
##
## 2/23/1998 Jonathan Ives. -Created.
##
###############################################################################

package config;
$VERSION = 1.0;
$package_name = 'config';


#Specify routines to be directly callable via the calling module without
#specifying the name of this package
use Exporter;				#Standard Perl Module
@ISA = ('Exporter');			#Inherit from Exporter	
@EXPORT_OK = qw(GetValue);

$TEST_MODE = 0;            ## Test Mode (1 == ON, 0 == OFF)

if ($TEST_MODE) {print "TEST_MODE is ON for log.pm\n";}

###############################################################################
sub GetValue # Gets a single value string from the configuration file
###############################################################################
{
	my($VNameRequested) = @_;

	unless (open (CFILE, $ENV{'ROLES_CONFIG'}))
	       {
		my($err_str) = "Can't open configuration file" . $ENV{'ROLES_CONFIG'} . ".\n";
		die $err_str;
	}

      	while (<CFILE>) {
		chomp;		
	        ($VariableName, $Value) = split (":", $_);

	   	if ($VariableName eq $VNameRequested)
			{last;}
		else
			{$Value = "";}
	} # while

	close CFILE;	
	return $Value;

}


###############################################################################
sub PackageTest	#Callable Package Test Routine 
###############################################################################
{
	if ($TEST_MODE) {print "In $package_name:PackageTest.\n";}

	print &GetValue("WAREHOUSE") . "\n"; 
	print &GetValue("ROLES") . "\n"; 
	print &GetValue("TROLES") . "\n";


	return;
}


return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################
