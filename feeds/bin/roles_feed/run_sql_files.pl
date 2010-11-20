#!/usr/bin/perl -I../../lib/cpa
####################################################################
#  NAME:  run_sql_files.pl 
#  DESCRIPTION: Generic Cron Job to run sql files.
#  To run : run_sql_files.pl database sqlfile 
#   $1 = database 
#   $2 = sqlfile 
#
#  Copyright (C) 2007-2010 Massachusetts Institute of Technology
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
# Created 4/9/2007, Marina Korobko 
#
#####################################################################
#Make sure we are set up to use DBI.
use DBI;
use config('GetValue');
use roles_base qw(login_dbi_sql ExecuteSQLCommands);

## Initialize Constants
 $sql_dir = $ENV{'ROLES_HOMEDIR'} . "/sql/frequently_run_scripts/";

###################################################
# Get database name
if ($#ARGV >= 0)
 {$db_name = $ARGV[0];
  $sqlfile = $ARGV[1]; 
# print $db_name; 
# print $sqlfile;
}
else {
 print  " Please, put database name and sqlfile name on command line (run_sql_files.pl database sqlfile) \n";
 exit ;
}
# print $ARGV[1];
#Get username and password
$db_parm = GetValue($db_name);
#print $db_parm;
$db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
$user = $1;
$pw = $2;
$db = $3;

 my($lda) = login_dbi_sql($db, $user, $pw)
  	|| die $DBI::errstr;
 &ExecuteSQLCommands($sql_dir.'/'.$ARGV[1],$lda);
 print "\n";