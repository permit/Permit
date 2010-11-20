#!/usr/bin/perl -I/usr/users/rolesdb/lib/cpa
########################################################################
#
#  Do the PD Org extract and comparison of Roles approver authorizations
#  with PD Org workflow definitions.
#
#  1.  Check to see if there are more recent wh-hrp100x files (or 
#      CCIHT_WAH or PA0105) on the Warehouse than those 
#      available locally.  If so, go get new
#      files.  Otherwise, stop.
#  2.  Run "proc_ehs_role.pl" to process the new wh-hrp* files.
#  3.  Run "compare_ehs_auth.pl" to generate a file of differences
#      between the SAP data on EHS-related roles and the Roles DB 
#      EHS authorizations
#
#  Updated the "sanity check" number from 1000 to 2000.
#
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
########################################################################
#
#  Set environment variables
#
 $ENV{"ROLES_CONFIG"} = "/usr/users/rolesdb/lib/roles_config";
 $ENV{"EHS_DATADIR"} = "/usr/users/rolesdb/data/ehs";

#
#  Set directory for programs
#
 $prog_dir = "/usr/users/rolesdb/bin/ehs/";
 $ENV{"EHS_PROGDIR"} = $prog_dir;
 
#
#  Call proc_ehs_role2.pl to get data from the Warehouse about DLCs in 
#  the SAP EHS system and people with roles related to them.
#
 $xrc = 1;
 if ($xrc == 1) {
   $rc = system($prog_dir . "proc_ehs_role2.pl warehouse");
 }
 print "RC from proc_ehs_role2.pl is '$rc'\n";
 if ($rc != 0) {die "Error in proc_ehs_role2.pl\n";}

#
#  Call compare_approver_auth.pl
#
 $rc = system($prog_dir . "compare_ehs_role.pl roles");
 print "RC from compare_ehs_role.pl is '$rc'\n";
 if ($rc != 0) {die "Error in compare_ehs_role.pl\n";}

#
#  Do a "sanity check" on the number of records in the output files.
#
 $MAX_ROLES_DIFF_RECORDS = 2000;  # Changed from 1000 to 2000, June 1, 2007
 $MAX_DLC_DIFF_RECORDS = 100;
 $roles_file = $ENV{"EHS_DATADIR"} . "/" . "ehs_roles.compare";
 $dlc_file = $ENV{"EHS_DATADIR"} . "/" . "ehs_dlc.compare";
 $roles_records = `grep -c . $roles_file`;
 $dlc_records = `grep -c . $dlc_file`;
 print "Number of records in the roles differences file = $roles_records\n";
 print "Number of records in the DLC differences file = $dlc_records\n";
 if ($dlc_records > $MAX_DLC_DIFF_RECORDS) {
   die "Error: More than $MAX_DLC_DIFF_RECORDS records found in diff "
       . "file for DLCs: $dlc_records\n";
 }
 if ($roles_records > $MAX_ROLES_DIFF_RECORDS) {
   die "Error: More than $MAX_ROLES_DIFF_RECORDS records found in diff "
       . "file for EHS Roles: $roles_records\n";
 }

#
#  Send the Roles/SAP roles differences file to the SAP dropbox via FTP
#
 #####$rc = system($prog_dir . "ehs_ftp_to_sap2.pl");  # With encryption
 $rc = system($prog_dir . "ehs_ftp_to_sap.pl");   # Without encryption
 print "RC from ehs_ftp_to_sap2.pl is '$rc'\n";
 if ($rc != 0) {die "Error in ehs_ftp_to_sap2.pl\n";}
