#!/usr/bin/perl  -I/home/www/permit/feeds/bin/roles_feed -I/home/www/permit/feeds/lib/cpa
###############################################################################
## NAME: roles_feed.pl <command> <module> [DB Parameter]
##
## DESCRIPTION: 
## This script is used to call functions in other modules. It provides
## a single point of entry for the Roles Feeds.  Type roles_feed.pl to see
## usage. 
## 
## ENHANCEMENT TODO LIST:
## REQUIRED:
## -
##
## OPTIONAL
## -Dynamically select packages, to avoid loading them all
## -Standard Non-positional Command Line support (use switches)
## -Specify include path in code, not on command line
##
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
## MODIFICATION HISTORY:
##
## 10/07/1997 Jonathan Ives. -Created.
## 12/29/1997 Jonathan Ives. -Moved into "rolesdb" Test environment 
## 1/13/1998 Jonathan Ives. -Add Prepare Step
## 6/20/1998 Jim Repa. -Add processing for SPGP qualifiers
## 10/28/1998 Jim Repa. -Add processing for PRIN qualifiers (PIs)
## 7/29/1999 Jim Repa. -Add processing for LORG.
## 6/27/2002 Jim Repa. -Add processing for ORG2.
## 6/9/2005 Jim Repa. -Add processing for PMIT and PYTG.
## 9/1/2005 Jim Repa. -Add processing for PCCS.
## 9/1/2006 Jim Repa. -Add processing for EHST.
## 9/27/2006 Jim Repa. -Add mdeptlink and mdeptdesc.
## 10/3/2006 Jim Repa. -Add processing for RSET.
## 1/25/2007 Jim Repa. -Add PBM1 processing.
## 05/28/2010 DSPS. -Add SUBJ processing.
###############################################################################


###############################################################################
## Main Program
###############################################################################

## Get packages
use roles_base('ScriptExit', 'UsageExit');
use config('GetValue');

$TEST_MODE = 1;            ## Test Mode (1 == ON, 0 == OFF)
if ($TEST_MODE) {print "TEST_MODE is ON for roles_feed.pl\n";}

## Initialize Perl
$| = 1;                 ## Force Perl Ouput Buffer to Flush on each write

## Process Command Line Arguments
$exit_status = &ProcessArguments();

## Cleanup and Exit (Script Exit closes database connection)
&ScriptExit($exit_status);


###############################################################################
###############################################################################
##
## Subroutines
##
###############################################################################
###############################################################################

###############################################################################
sub ProcessArguments
###############################################################################
{
        #Supported Modules

        require roles_person;    # Person Table Feed 

        require roles_fund;      # SAP Fund Center Qualifier Table Feed
        require roles_cost;      # SAP Cost Collectors Qualifier Table Feed
        require roles_spgp;      # SAP Spending Group Qualifier Table Feed
        require roles_whcost;    # Local copy of WH cost_collector data
        require roles_org2;      # New HR Org units
        require roles_cybm;      # Cybersource Merchants 
        require roles_phist;    # New person_history feed
        require roles_pbud;      # PBUD (PCs in Budget Hierarchy)
        require roles_prin;      # Principal Investigators
        require roles_pmit;      # PCMIT-0 objects
        require roles_pytg;      # Payroll time groups
        require roles_pccs;      # Profit Ctrs, CO Supervisors, COs
        require roles_ehst;      # EHS Triggers for training
        require roles_oldorg;      # Personnel Org Units Qualifier Table Feed
	require roles_rset;      # RSET (EHS Room Sets, PIs, etc.)
	require roles_extauth;   # External authorizations
	require roles_mdeptdesc; # For MDEPT dept_descendent table

	require roles_mdeptlink; # For MDEPT expanded_object_link table

	require roles_dept; # For Master Department Hierarchy information
	require roles_subj; # For Academic courses and subjects
	#not needed
        #require roles_lorg;      # Labor Distribution org unit feed
	#require roles_pbm1;      # PBM1 hierarchy (Program Budget Management)
     #Being Tested

        #Additional Modules
#        require roles_aorg;      # Admissions Org Units Qualifier Table Feed
#        require roles_prof;      # SAP Profit Center Qualifier Table Feed


	## Process Command Line Arguments
        if ($#ARGV != 2) {&UsageExit("Incorrect Usage");}

        my($cmd) = $ARGV[0]; #Get the specified Command and use that 
                             #To determine which module to call
        my($package) = $ARGV[1]; #Get Database Paramaters
        my($db_parm) = $ARGV[2]; #Get Database Paramaters

        ## Parse the Command
        $cmd =~ m/^(.*)_(.*)$/; 
	$system_name = $1;   ## "roles", "external", "package" 
	$operation_name = $2;## "extract", "load" or "test" by convention

        ## Parse Package Name
  	$package_name = "roles" . "_" . $package; ## A valid Perl Feed Module Name (Must be in Perl search path)


        ## Parse DB Parameters
        ## Arguements taken as <user_name>/<password>@<db name>
	## or as Varablename in the configuration file
        ## GetVaule reads from the configuration file.

        if ($db_parm =~ m/^(.*)\/(.*)\@(.*)$/)  ## parse login info
	{
        $db_name = $3; ##used for logging purposes
	$id  = $1;
	$pw  = $2;
	$db  = $3;

	}
        else                                    ##check config. file   
        {
        @ENV{db_name} = $db_parm; ##used for logging purposes (Hack)
        $db_parm = GetValue("$db_parm");
  	$db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
	$id  = $1;
	$pw  = $2;
	$db  = $3;
	}

	## Call Routine to Execute Command
        SWITCH: {
     if ($cmd =~ m/^roles_extract$/i) {
          $rt_status = $package_name->FeedExtract($id, $pw, $db);
	  last SWITCH; }
     if ($cmd =~ m/^roles_prepare$/i) {
          $rt_status = $package_name->FeedPrepare($id, $pw, $db);
	  last SWITCH; }
     if ($cmd =~ m/^roles_load$/i) {
          $rt_status = $package_name->FeedLoad($id, $pw, $db);
	  last SWITCH; }
     if ($cmd =~ m/^external_extract$/i) {
          $rt_status = $package_name->FeedExternalExtract($id, $pw, $db);
	  last SWITCH; }
     if ($cmd =~ m/^check_status$/i) {
          $rt_status = $package_name->CheckStatus($id, $pw, $db);
	  last SWITCH; }
     if ($cmd =~ m/^package_test$/i) {
          $rt_status = $package_name->PackageTest(@ARGV);
	  last SWITCH; }
        &UsageExit("Unknown Command Specified.");
	}

    return $rt_status;
}
#########################################################################
#######################        End Script          ######################  
#########################################################################
