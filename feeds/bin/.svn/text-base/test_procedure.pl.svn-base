#!/usr/bin/perl
##############################################################################
#  Test new stuff.
#
#  Pick a procedure from a list of procedures and run it.  Then
#  display the list of files in the "data" and "log" directories.
#
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
##############################################################################
$dir = '/home/www/permit/feeds/bin/';
@proc_name = ('Roles: Extract old 6-digit org units from Warehouse files',
              'Roles: Compare old org units from WH and Roles Qual table',
              'Roles: Load old org units into Qualifier-related tables',

              'Roles: Budget PBM1 objects from Warehouse files',
              'Roles: Compare PBMs from Warehouse and Roles Qualifier table',
              'Roles: Load PBM1 data into Qualifier-related tables',

              'Roles: Extract EHST data, EHS Training Triggers, from EHS',
              'Roles: Compare data from EHS with EHST qualifiers in Roles DB',
              'Roles: Load EHST data into Qualifier-related tables',

              'Roles: Extract PBUD PC-budget data from the Warehouse',
              'Roles: Compare PBUD data from Roles DB and the Warehouse',
              'Roles: Load PBUD data into Qualifier-related tables',

              'Roles: Extract New Org Units from warehouse',
              'Roles: Compare New Org Units from warehouse w/ ORG2 recs.',
              'Roles: Load ORG2 data into Qualifier-related tables',

              'Roles: Extract Person History from current Person, etc. tables',
              'Roles: Compare Warehouse and person_history table',
              'Roles: Load updates into person_history table',

              'Roles: Extract WH cost_collector data from Warehouse table',
              'Roles: Compare WH cost_coll. data fr. Warehouse & Roles tables',
              'Roles: Load WH cost_collector data into Roles table',

              'Roles: Extract EHS PIs, Room Sets, and Rooms from Warehouse tables',
              'Roles: Compare PI and Room Set data from Warehouse and Roles Qualifier table',
              'Roles: Load RSET data into Qualifier-related tables',

              'Roles: Extract Funds and Fund centers from Warehouse files',
              'Roles: Compare Funds and Fund centers from Warehouse and Roles Qualifier table',
              'Roles: Load Funds and Fund centers data into Qualifier-related tables',

              'Roles: Extract Cybersource Merchants from Warehouse files',
              'Roles: Compare Cybersource Merchants from Warehouse and Roles Qualifier table',
              'Roles: Load Cybersource Merchant data into Qualifier-related tables',

              'New roles: Extract Princ. Inv. by Dept. from COST Qual. records',
              'New roles: Compare pr. inv. from COST extract and PRIN records',
              'New roles: Load PRIN data into Qualifier-related tables',

              'New roles: Extract LD Org. Units fr. HRP1000 table & COST records',
              'New roles: Compare LD Org. Units from HRP1000 table & LORG recs.',
              'New roles: Load LORG data into Qualifier-related tables',

              'New roles: Extract Person History data from current tables',
              'New roles: Compare People History from old and new tables',
              'New roles: Load PERSON_HISTORY updates into Person_history table',

              'New roles: Extract WH cost_collector data from Warehouse table',
              'New roles: Compare WH cost_coll. data fr Warehouse & Roles tables',
              'New roles: Load WH cost_collector data into Roles table');

@proc_cmd  = ($dir . 'roles_feed.pl roles_extract oldorg warehouse',
              $dir . 'roles_feed.pl roles_prepare oldorg roles',
              $dir . 'roles_feed.pl roles_load oldorg roles',

              $dir . 'roles_feed2.pl roles_extract pbm1 warehouse',
              $dir . 'roles_feed2.pl roles_prepare pbm1 roles',
              $dir . 'roles_feed2.pl roles_load pbm1 roles',

              $dir . 'roles_feed.pl roles_extract ehst ehs',
              $dir . 'roles_feed.pl roles_prepare ehst roles',
              $dir . 'roles_feed.pl roles_load ehst roles',

              $dir . 'roles_feed.pl roles_extract pbud warehouse',
              $dir . 'roles_feed.pl roles_prepare pbud roles',
              $dir . 'roles_feed.pl roles_load pbud roles',

              $dir . 'roles_feed.pl roles_extract org2 warehouse',
              $dir . 'roles_feed.pl roles_prepare org2 roles',
              $dir . 'roles_feed.pl roles_load org2 roles',

              $dir . 'roles_feed.pl roles_extract phist roles',
              $dir . 'roles_feed.pl roles_prepare phist roles',
              $dir . 'roles_feed.pl roles_load phist roles',

              $dir . 'roles_feed.pl roles_extract whcost warehouse',
              $dir . 'roles_feed.pl roles_prepare whcost roles',
              $dir . 'roles_feed.pl roles_load whcost roles',

              $dir . 'roles_feed.pl roles_extract rset warehouse',
              $dir . 'roles_feed.pl roles_prepare rset roles',
              $dir . 'roles_feed.pl roles_load rset roles',

              $dir . 'roles_feed.pl roles_extract fund ftpwarehouse',
              $dir . 'roles_feed.pl roles_prepare fund newroles',
              $dir . 'roles_feed.pl roles_load fund newroles',

              $dir . 'roles_feed.pl roles_extract cybm warehouse',
              $dir . 'roles_feed.pl roles_prepare cybm roles',
              $dir . 'roles_feed.pl roles_load cybm roles',

              $dir . 'roles_feed.pl roles_extract prin newroles',
              $dir . 'roles_feed.pl roles_prepare prin newroles',
              $dir . 'roles_feed.pl roles_load prin newroles',

              $dir . 'roles_feed.pl roles_extract lorg ftpwarehouse',
              $dir . 'roles_feed.pl roles_prepare lorg newroles',
              $dir . 'roles_feed.pl roles_load lorg newroles',

              $dir . 'roles_feed.pl roles_extract phist newroles',
              $dir . 'roles_feed.pl roles_prepare phist newroles',
              $dir . 'roles_feed.pl roles_load phist newroles',

              $dir . 'roles_feed.pl roles_extract whcost warehouse',
              $dir . 'roles_feed.pl roles_prepare whcost newroles',
              $dir . 'roles_feed.pl roles_load whcost newroles');

$n = @proc_name;
&list_selections();
$nn = 1;
while ($nn > 0) {
  $nn = -1;
  until ($nn >=0 && $nn <= $n && $nn =~ /^\d+$/) {
    print "To execute a procedure, enter a number from 1 to $n\n"
          . " enter 999 to redisplay procedure list, or 0 to stop\n";
    chop($nn = <STDIN>);   # Make the user pick a number from 0 to 28.
    if ($nn == 999) {
      list_selections();
      $nn = -1;
    }
  }
  if ($nn == 0) {last;}
  $picked_proc = $proc_cmd[$nn-1];
  print "\n'$picked_proc'\nExecuting...\n";
  system($picked_proc);
  print "\nDone ($nn).\n";
}
exit();

#############################################################################
#
#  Print list of options
#
#############################################################################
sub list_selections {
  my $n = @proc_name;  # How many choices?
  for (my $i = 0; $i < $n; $i++) {
    if (($i)%3 == 0) {print "\n";}
    printf "%5d %-70.70s\n", $i+1, $proc_name[$i];
  }
}
