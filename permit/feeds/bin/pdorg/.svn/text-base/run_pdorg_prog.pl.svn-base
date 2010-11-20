#!/usr/bin/perl -I/usr/users/rolesdb/lib/cpa
########################################################################
#
#  Do the PD Org extract and comparison of Roles approver authorizations
#  with PD Org workflow definitions.
#
#  1.  Check to see if there are more recent wh-hrp100x files on the
#      Warehouse than those available locally.  If so, go get new
#      files.  Otherwise, stop.
#  2.  Run "proc_pdorg2.pl" to process the new wh-hrp* files.
#  3.  Run "compare_approver_auth.pl" to generate a file of differences
#      between the PD Org and Roles approver authorizations.
#
#  Copyright (C) 2000-2010 Massachusetts Institute of Technology
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
#
########################################################################
#
#  Set environment variables
#
 $ENV{"ROLES_CONFIG"} = "/usr/users/rolesdb/lib/roles_config";
 $ENV{"PDORG_DATADIR"} = "/usr/users/rolesdb/data/";

#
#  Set directory for programs
#
 $prog_dir = "/usr/users/rolesdb/bin/pdorg/";
 $ENV{"PDORG_PROGDIR"} = $prog_dir;
 
#
#  See if there are new files to process
#
 $rc = system($prog_dir . "get_wh_files.pl") >> 8;
 print "rc = $rc\n";

#
#  If so, call proc_pdorg2.pl.
#
 if ($rc == 1) {
   system($prog_dir . "proc_pdorg2.pl");
 }

#
#  No matter what, call compare_approver_auth.pl
#
 system($prog_dir . "compare_approver_auth.pl");
