#!/usr/bin/perl  -I../../bin/roles_feed -I../../lib/cpa
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

$infile = "/usr/users/rolesdb/data/fund.actions";
$MAX_ACTIONS = 10;

$actions_count = `grep -c . $infile`;

 print "Actions to be performed: $actions_count \n";	

if ($actions_count > $MAX_ACTIONS)
{print "too many\n";}
else
{print "it fits\n";}


