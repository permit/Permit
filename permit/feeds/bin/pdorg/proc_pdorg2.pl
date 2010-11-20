#!/usr/bin/perl -I/usr/users/rolesdb/lib/cpa 
##############################################################################
#
#  Get Spending Group, Fund Center and Approval Authorization information
#  out of HRP1000, and HRP1208 files from SAP.
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
#  Modified 7/11/2000, Jim Repa.  Produce new file pdorg_position.
#  Modified 10/02/2000, Jim Repa.  Change location of directories
#  Modified 01/29/2007, Marina Korobko. Use Oracle table instead of file HRP1001
##############################################################################
#
#  Set some variables
#
 $datafile_dir = $ENV{'PDORG_DATADIR'};
 $program_dir = $ENV{'PDORG_PROGDIR'};
 $file1000 = "wh-hrp1000";
 $file1208 = "wh-hrp1208";
 $mapping_file = "task2function.mapping";

#
#
#
 &process_hrp1xxx_files();
 exit();

##############################################################################
#
#  Subroutine to process the files of (PDOrg) Organizations, WF Tasks, 
#  Fund Centers, and People from SAP.
#
##############################################################################
sub process_hrp1xxx_files {

 my $inputfile = $datafile_dir . $file1000;
 my $inputfile3 = $datafile_dir . $file1208;
 my $inputmap = $program_dir . $mapping_file;
 my $org_outfile = $datafile_dir . "pdorg2";
 my $fc_outfile = $datafile_dir . "org_fund_center2";
 my $auth_outfile = $datafile_dir . "approver_auth2";
 my $task_outfile = $datafile_dir . "pdorg_position";
 my $prefix = '03001O ';  # For orgs within HRP1000
 my $prefix_len = length($prefix);
 my $template5 = '^03001S .{76}-';  # For WF tasks in HRP1000
 my $root_code = '50000819';
 use config('GetValue');
 #
 #   Open output files.
 #
   my $outf = ">$org_outfile";
   if( !open(F1, $outf) ) {
     die "$0: can't open ($outf) - $!\n";
   }

   my $outf2 = ">$fc_outfile";
   if( !open(F2, $outf2) ) {
     die "$0: can't open ($outf2) - $!\n";
   }

   my $outf3 = ">$auth_outfile";
   if( !open(F3, $outf3) ) {
     die "$0: can't open ($outf3) - $!\n";
   }

   my $outf4 = ">$task_outfile";
   if( !open(F4, $outf4) ) {
     die "$0: can't open ($outf4) - $!\n";
   }

 #
 #   Open the task-to-function mapping file.
 #   Read each record.  Build hash %taskname_to_function (Maps a task name
 #     in the PD Org to the Roles DB Function name for each approver task)
 #
  unless (open(MAP,$inputmap)) {
    die "Cannot open $inputmap for reading\n"
  }
  my $line;
  my %taskname_to_function;
  my ($task1, $func1);
  while (chop($line = <MAP>)) {
    ($task1, $func1) = split('!', $line);
    $taskname_to_function{$task1} = $func1;
  }
  close(MAP);

 #Make sure we are set up to use Oraperl.
  use Oraperl;
 if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}
# Get parameters needed to open an Oracle connection to the Warehouse
#
   $db_parm =  GetValue("warehouse"); # Info about warehouse from config file
   $db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
   $user_id = $1;
   $user_pw = $2;
   $db_id = $3;
#
# Open connection to oracle
#
# print "db_id='$db_id' user_id='$user_id'\n";
  my ($lda) = &ora_login($db_id, $user_id, $user_pw)
          || die $ora_errstr;

# *** This is not yet used ***
# for 1208 file. Mapping the Fund center to a spending group (Aka ORG)- F2
  my $stmt1 = " SELECT 'SG_'||object_code||'!'||related_object_with_type org_to_fund "
            . " FROM wareuser.WHOBJECT_RELATIONSHIP_ADDL"
            . " WHERE object_relationship_code = 'SGFC'";
#print "stmt1='$stmt1'\n";
# *** 

#
# for 1001 file. Mapping Spending group parent/child
  my $stmt2 = " SELECT object_code parent_code,"
            . " related_object_code  child_code"
            . " FROM wareuser.WHOBJECT_RELATIONSHIP_ADDL"
            . " WHERE object_relationship_code =  'B002'"
            . " AND object_type_code = 'O'"
            . " AND related_object_type_code = 'O'";

# for 1001 file. Mapping WF tasks (Positions) to Org Units.
  my $stmt3 = " SELECT DISTINCT object_code parent_code,related_object_code child_code"
             . " FROM wareuser.WHOBJECT_RELATIONSHIP_ADDL"
             . " WHERE object_relationship_code = 'B003'"
             . " AND object_type_code = 'O'"
             . " AND related_object_type_code = 'S'"
             . " AND SUBSTR(object_CODE,1,1) ='5'";

# for 1001 file. Mapping users to WF tasks (Positions)
  my $stmt4 = " SELECT object_code parent_code, related_object_code child_code"
            . " FROM wareuser.WHOBJECT_RELATIONSHIP_ADDL "
            . " WHERE object_relationship_code = 'A008'"
            . " AND object_type_code = 'S'"
            . " AND related_object_type_code = 'US'"
            . " AND object_relation_end_date >= SYSDATE";

# Build hash %m_org_parent_table(parents of Orgs)
# Build hash %m_task_to_org (Task items and associated org or SG)
# Build hash %m_task_to_user_list
#
  my %m_org_parent_table;
  my %m_task_to_org;
  my %m_task_to_user_list;
  my ($parent_code, $child_code);
  my $crs2 = &ora_open($lda, $stmt2) || die $ora_errstr;
  while ( ($parent_code, $child_code) =  &ora_fetch($crs2) )
  {
    $m_org_parent_table{$child_code} = $parent_code;
  }
&ora_close($crs2) ||die "can't close cursor";
# foreach $key (sort keys %m_org_parent_table)
#  {
# print "$key -> $m_org_parent_table{$key}\n";
#  }
#
  my $crs3 = &ora_open($lda, $stmt3) || die $ora_errstr;
  while ( ($parent_code, $child_code) =  &ora_fetch($crs3) )
  {
    $m_task_to_org{$child_code} = $parent_code;
  }
 &ora_close($crs3) || die "can't close cursor";
# foreach $key (sort keys %m_task_to_org)
#  {
# print "$key -> $m_task_to_org{$key}\n";
#  }
#
  my $crs4 = &ora_open($lda, $stmt4) || die $ora_errstr;
  while ( ($parent_code, $child_code) =  &ora_fetch($crs4) )
 { 
  $m_task_to_user_list{$parent_code} .= ' '. $child_code; 

#print "$parent_code -> $m_task_to_user_list{$parent_code}\n"; 
} 
&ora_close($crs4) || die "can't close cursor";
#foreach $key (sort keys %m_task_to_org) {
  #  print F3 "task='$key' org='$task_to_org{$key}'\n";
  #}
#  foreach $key (keys %task_to_user_list) {
#  print F3 "task='$key' user='$m_task_to_user_list{$key}'\n";
#}
  
 #
 #   Some nodes are "orphans", i.e., their parent, or parent's parent,
 #   etc. is missing.  Call &find_orphan_nodes to find these nodes.
 #   When an orphan node is found, undefine the corresponding
 #   entries in %org_parent_table.
 #
  &find_orphan_nodes(\%m_org_parent_table, $root_code);

 #
 #   Open input file (hrp1000)
 #
  unless (open(IN,$inputfile)) {
    die "Cannot open $inputfile for reading\n"
  }
 
 #
 #   Read each line from the input file.  (hrp1000)
 #   First pass builds %org_to_sg hash (to convert PD Org 5nnnnnnn code
 #     to SG_.... code)
 #
 my $org_code;  # Current org code
 my $sg_code;   # Spending group code
 my $org_name;  # Current org name
 my $org_parent;  # Parent of current org
 my $fund_center; # Fund center (child of an org)
 my $approver_function;  # Name of an approver function
 my $task_code;   # Code of a WF task
 my $userlist; # Blank-delimited list of users for an approver authorization
 my @username; # Array of users for an approver function
 my $user;     # A single user for an approver function
 my $include_this_node = 0;
 my %org_to_sg;
 my %org_func_to_task;  # Hash maps $org_code!$function -> $task_code

 while (chop($line = <IN>)) {
   ### Organization (AKA Spending Group)?
   if (substr($line, 0, $prefix_len) eq $prefix) {
     $org_code = substr($line, 7, 8);
     $org_name = &strip(substr($line, 93, 40));
     if ($org_name =~ /\[.*\]/) {  # Line contains [sg_code]
       $org_name =~ /([^\[]*)\[([^\]]*)\](.*)/;
       $org_to_sg{$org_code} = $2;
       #print "org_code='$org_code' sg='$2'\n";
     }
   }
 }
 close(IN);

 #
 #   Open the "1208" file.
 #   Read each record.  When a Fund Center is found, write out a record
 #    FC file mapping the FC to a Spending Group (aka Org)
 #
 unless (open(IN3,$inputfile3)) {
   die "Cannot open $inputfile3 for reading\n"
  }
  while (chop($line = <IN3>)) {
    if ($line =~ /BUS0028/) {  # Fund Center -> Org link
       $org_code = substr($line, 7, 8);
       $fund_center = substr($line, 108, 6);
       if ($org_to_sg{$org_code}) {
         $org_code = $org_to_sg{$org_code};
       }
       print F2 'SG_' . $org_code . "!FC" . $fund_center . "\n";
    }
  }
 close(IN3);
#my $crs1 = &ora_open($lda, $stmt1) || die $ora_errstr;
#  while ( ($org_to_fund) =  &ora_fetch($crs1) )
#  {
# print F2 $org_to_fund . "\n";
#  }
# &ora_close($crs1) || die "can't close cursor" ; 


 #
 #   Read each line from the input file.  (hrp1000)
 #   2nd pass reads writes out a record for each line, including parent.
 #
  unless (open(IN,$inputfile)) {
    die "Cannot open $inputfile for reading\n"
  }

  while (chop($line = <IN>)) {

   ### Organization (AKA Spending Group)?
   if (substr($line, 0, $prefix_len) eq $prefix) {
     $org_code = substr($line, 7, 8);
     $org_name = &strip(substr($line, 93, 40));
     if ($org_name =~ /\[.*\]/) {  # Line contains [sg_code]
       $org_name =~ /([^\[]*)\[([^\]]*)\](.*)/;
       $org_to_sg{$org_code} = $2;
       $org_name = $1 . $3;
       $org_name =~ s/  / /g;  # Get rid of '  ' left when [.*] is removed
       $org_name = &strip($org_name);  # Get rid of leading/trailing blanks
     }
     $org_parent = $m_org_parent_table{$org_code};
     # Eliminate "orphan" nodes that do not have a valid parent node.
     # If parent is non-existent (for non-root nodes) then skip this node.
     if ($org_code eq $root_code) {$include_this_node = 1;}
     elsif ($org_parent eq '') {$include_this_node = 0;}
     else {$include_this_node = 1;}
     #
     if ($include_this_node) {
       if ($org_to_sg{$org_parent}) {
         $org_parent = $org_to_sg{$org_parent};
       }
       $sg_code = $org_code;
       if ($org_to_sg{$org_code}) {
         $sg_code = $org_to_sg{$org_code};
       }
       if ($org_parent ne '') {$org_parent = 'SG_' . $org_parent;}
       printf F1 "SPGP!SG_%s!%s!%s!%s\n",
              $sg_code, $org_parent, $org_name, $org_code;
     }
   }

   ### Fund Center?
   #elsif ( substr($line, 0, $prefix3_len) eq $prefix3) {
   #  $fund_center = $1;
   #  print F2 "SG_$org_code!FC$fund_center\n";
   #}

   ### Task (position)?
   elsif ( $line =~ $template5) {
     $task_code = substr($line, 7, 8);
     $approver_function = &strip(substr($line, 93, 40));
     $org_code = $m_task_to_org{$task_code};
     if ( ($org_code) # Skip it if task is not matched to an org code
          && ($m_org_parent_table{$org_code}) ) # Skip it if org code not found
     {
       $userlist = $m_task_to_user_list{$task_code};
      #print  "task='$task_code' userlist='$m_task_to_user_list{$task_code}'\n";
       @username = split(' ', $userlist);
       if ($org_to_sg{$org_code}) {
         $org_code = $org_to_sg{$org_code};
       }
       if ($taskname_to_function{$approver_function}) {
         $approver_function = $taskname_to_function{$approver_function};
       }
       # Fill in hash entry for "$qual!$function" -> $task_code
       $org_func_to_task{"$org_code!$approver_function"} = $task_code;
       foreach $user (@username) {
         print F3 "SG_$org_code!$approver_function!$user\n";
       }
     }
   }
   
 }

 #
 # Write out org/function -> task_code (position code) combinations.
 #
 foreach $key (sort keys %org_func_to_task) {
   print F4 "SG_$key!$org_func_to_task{$key}\n";
 }

 close(F1);
 close(F2);
 close(F3);
 close(F4);
 close(IN);

}

##############################################################################
#
#  &find_orphan_nodes(\%org_parent_table, $root_code);
#
#  For each key in %org_parent_table, run up the chain to the rootnode
#  to see the chain is complete.  If not, we've found an orphan node.
#  Undefine it and all of its ancestors.
#
##############################################################################
sub find_orphan_nodes {
  my ($r_org_parent_table, $root_code) = @_;
  my @chain;
  my $chain_index;
  my ($key, $org_code, $parent, $i, $j);

  foreach $key (keys %$r_org_parent_table) {
    @chain = ();
    $org_code = $key;
    $i = 0;
    $parent = $$r_org_parent_table{$org_code};
    #print "code='$org_code' parent='$parent'\n";
    while ( ($i++ < 20) && ($parent ne $root_code) && ($parent ne '') ) {
      #print "code=$org_code i=$i parent=$parent\n";
      $chain[$i] = $org_code;
      $org_code = $parent;
      $parent = $$r_org_parent_table{$org_code};
    }
    #print "parent=$parent root_code=$root_code\n";
    if ($parent ne $root_code) {
      for ($j = 1; $j < @chain; $j++) {
          #print "undef $chain[$j]\n";
          undef($$r_org_parent_table{$chain[$j]});
      }
    }
  }  
}

########################################################################
#
#  Strips off trailing <cr> and leading and trailing blanks.
#
###########################################################################
sub strip {
  local($s);  #temporary string
  $s = $_[0];
  while ($s =~ /[\s\n]$/) {   # Remove trailing <cr> or space
    chop($s);
  }
  while (substr($s,0,1) =~ /^\s/) {
    $s = substr($s,1);
  }
 
  $s;
}
