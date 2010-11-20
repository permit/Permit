#!/usr/bin/perl -I/usr/users/rolesdb/bin/extract/
###########################################################################
#
#  Call GenControlFile to generate a control file line.
#
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
###########################################################################
#
# Get packages
#
use zevent_feed('GenControlFile');  # Use subroutine GenControlFile

#
# Set some constants to be used by &GenControlFile routine.
#
$data_file = "drldb2pdo.001.200000801184000";
$ctl_file = "control_file.test";

#
# Call &GenControlFile.
#
 print "Before subroutine call\n";
 &GenControlFile($data_file, $ctl_file);
 print "After subroutine call\n";