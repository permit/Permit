#!/usr/bin/perl
##############################################################################
#
#  Pick a procedure from a list of procedures and run it.  Then
#  display the list of files in the "data" and "log" directories.
#
##############################################################################
$dir = '/home/www/permit/feeds/bin/';
@proc_name = ('Roles: Extract Prof. Ctrs/Cost Coll. from Warehouse files',
              'Roles: Compare PC/CO from Warehouse and Roles Qualifier table',
              'Roles: Load COST data into Qualifier-related tables',

              'Roles: Extract Funds/Fund Centers from Warehouse files',
              'Roles: Compare Funds from Warehouse and Roles Qualifier table',
              'Roles: Load FUND data into Qualifier-related tables',

              'Roles: Extract Spending Groups from FUND Qualifier records',
              'Roles: Compare sp. groups from FUND extract and SPGP records',
              'Roles: Load SPGP data into Qualifier-related tables',

              'Roles: Extract Princ. Inv. by Dept. from COST Qual. records',
              'Roles: Compare pr. inv. from COST extract and PRIN records',
              'Roles: Load PRIN data into Qualifier-related tables',

              'Roles: Extract LD Org. Units fr. HRP1000 table & COST records',
              'Roles: Compare LD Org. Units from HRP1000 table & LORG recs.',
              'Roles: Load LORG data into Qualifier-related tables',

              'Roles: Extract People from Warehouse files',
              'Roles: Compare People from Warehouse and Person table',
              'Roles: Load PERSON data into Person tables',

              'Roles: Extract PCMIT-0 objects from Warehouse files',
              'Roles: Compare PCMIT-0 objects from WH & Roles Qualifier table',
              'Roles: Load PCMIT-0 objects into Qualifier-related tables',

              'Roles: Extract Payroll Time Groups from (test) Warehouse files',
              'Roles: Compare PYTG objects from WH and Roles Qualifier table',
              'Roles: Load PYTG objects into Qualifier-related tables',

              'Roles: Extract PCs, Supervisors, COs from Warehouse files',
              'Roles: Compare PCCS qualifiers from Warehouse & Roles table',
              'Roles: Load PCCS data into Qualifier-related tables',

              'Roles: Extract old 6-digit org units from Warehouse files',
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

              'Roles: Extract Cybersource Merchants from Warehouse files',
              'Roles: Compare Cybersource Merchants from Warehouse and Roles Qualifier table',
              'Roles: Load Cybersource Merchant data into Qualifier-related tables',

              'Roles: Extract expanded MDEPT object link data from Roles',
              'Roles: Compare expanded object link data with MDH tables',
              'Roles: Load expanded MDEPT object link data into MDH table',

              'Roles: Extract MDEPT descendent pairs from dept_child table',
              'Roles: Compare pairs with dept_descendent table',
              'Roles: Load MDH department_descendent table',

              'Roles: Extract external authorizations from Warehouse',
              'Roles: Compare external auths from WH and Roles DB tables',
              'Roles: Load external auth changes to Roles DB tables',

              'Roles: Extract Department information from MDH ',
              'Roles: Compare Department Information from MDH and Roles DB tables',
              'Roles: Load Department Information changes to Roles DB tables',

              'Roles: Extract academic subject information from Warehouse ',
              'Roles: Compare academic subject information from Warehouse and Roles DB tables',
              'Roles: Load academic subject changes to Roles DB tables');

@proc_cmd  = ($dir . 'roles_feed.pl roles_extract cost ftpwarehouse',
              $dir . 'roles_feed.pl roles_prepare cost roles',
              $dir . 'roles_feed.pl roles_load cost roles',

              $dir . 'roles_feed.pl roles_extract fund ftpwarehouse',
              $dir . 'roles_feed.pl roles_prepare fund roles',
              $dir . 'roles_feed.pl roles_load fund roles',

              $dir . 'roles_feed.pl roles_extract spgp roles',
              $dir . 'roles_feed.pl roles_prepare spgp roles',
              $dir . 'roles_feed.pl roles_load spgp roles',

              $dir . 'roles_feed.pl roles_extract prin roles',
              $dir . 'roles_feed.pl roles_prepare prin roles',
              $dir . 'roles_feed.pl roles_load prin roles',

              $dir . 'roles_feed.pl roles_extract lorg ftpwarehouse',
              $dir . 'roles_feed.pl roles_prepare lorg roles',
              $dir . 'roles_feed.pl roles_load lorg roles',

              $dir . 'roles_feed.pl roles_extract person warehouse',
              $dir . 'roles_feed.pl roles_prepare person roles',
              $dir . 'roles_feed.pl roles_load person roles',

              $dir . 'roles_feed.pl roles_extract pmit warehouse',
              $dir . 'roles_feed.pl roles_prepare pmit roles',
              $dir . 'roles_feed.pl roles_load pmit roles',

              $dir . 'roles_feed.pl roles_extract pytg warehouse',
              $dir . 'roles_feed.pl roles_prepare pytg roles',
              $dir . 'roles_feed.pl roles_load pytg roles',

              $dir . 'roles_feed.pl roles_extract pccs warehouse',
              $dir . 'roles_feed.pl roles_prepare pccs roles',
              $dir . 'roles_feed.pl roles_load pccs roles',
         
              $dir . 'roles_feed.pl roles_extract oldorg warehouse',
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

              $dir . 'roles_feed.pl roles_extract cybm warehouse',
              $dir . 'roles_feed.pl roles_prepare cybm roles',
              $dir . 'roles_feed.pl roles_load cybm roles',

              $dir . 'roles_feed.pl roles_extract mdeptlink mdept',
              $dir . 'roles_feed.pl roles_prepare mdeptlink mdept',
              $dir . 'roles_feed.pl roles_load mdeptlink mdept',

              $dir . 'roles_feed.pl roles_extract mdeptdesc mdept', 
              $dir . 'roles_feed.pl roles_prepare mdeptdesc mdept', 
              $dir . 'roles_feed.pl roles_load mdeptdesc mdept',

              $dir . 'roles_feed.pl roles_extract extauth warehouse', 
              $dir . 'roles_feed.pl roles_prepare extauth roles', 
              $dir . 'roles_feed.pl roles_load extauth roles',

              $dir . 'roles_feed.pl roles_extract dept mdept', 
              $dir . 'roles_feed.pl roles_prepare dept roles', 
              $dir . 'roles_feed.pl roles_load dept roles',

              $dir . 'roles_feed.pl roles_extract subj warehouse', 
              $dir . 'roles_feed.pl roles_prepare subj roles', 
              $dir . 'roles_feed.pl roles_load subj roles');


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
