#!/usr/bin/perl -I/usr/users/rolesdb/lib/cpa/
########################################################################
#
#  Extract approver-related authorizations from the Roles DB and compare
#  them to approver-related authorizations extracted from the PD Org.
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
#  Created by Jim Repa, 8/5/2004.
#  Modified by Jim Repa, 8/30/2004.  (Change to comments only)
#  Modified by Jim Repa, 6/30/2006.  (Allow authorizations for D_ALL)
#
########################################################################
#
# Get packages
#
use config('GetValue');  # Use the subroutine GetValue in ~/lib/cpa/config.pm

#
#  Make sure we are set up to use Oraperl.
#
use DBI;
use Oraperl;
if (!(defined(&ora_login))) {die "Cannot find ora_login in Oraperl/DBI"
                             . "modules\n";}

#
#  Set some variables
#
 $dbname = @ARGV[0];
 print "dbname='$dbname'\n";
 $datafile_dir = $ENV{'EHS_DATADIR'};
 $program_dir = $ENV{'EHS_PROGDIR'};
 $mapping_file = "saprole2function.mapping";
 $inputmap = $program_dir . "/" . $mapping_file;
 $file1001 = "wh-hrp1001";
 $filecciht = "wh-cciht_wah";
 $dlc_work_area_file = $datafile_dir . "/" . "dlc_to_workarea.dat";
 $delim = "!!"; # Internal delimiter for use within this program
 $delim2 = '\|';  # External delimiter for output file
 $delim2a = '|';  # External delimiter for output file

 $roles_ehs_role_file = $datafile_dir . '/' . 'ehs_dlc_role.roles';
 $roles_ehs_role_sort = $datafile_dir . '/' . 'ehs_dlc_role_sort.roles';
 $sap_ehs_role_file = $datafile_dir . "/" . "ehs_dlc_role.sap";
 $sap_ehs_role_sort = $datafile_dir . "/" . "ehs_dlc_role_sort.sap";
 $compare_file = $datafile_dir . '/' . 'ehs_roles.compare';
 $compare_dlc_file = $datafile_dir . '/' . 'ehs_dlc.compare';

#
#   Open output file. Do not do it here. It is done in a subroutine.
#
  #$outf = ">" . $roles_ehs_role_file;
  #if( !open(F2, $outf) ) {
  #  die "$0: can't open ($outf) - $!\n";
  #}

#
#  Open connection to oracle (Warehouse)
#
 my $lda2 = &login_sql('warehouse') 
       || die "Oracle error in login to Warehouse database. "
           . "\n " . $ora_errstr;

#
#  Get mapping of dlc_code -> work-area-code (from SAP)
#
 %dlc2work_area = ();
 %dlc2dlc_name = ();
 %work_area2dlc = ();
 %work_area2name = ();
 &get_dlc2work_area_mapping(\%dlc2work_area, $dlc_work_area_file, 
                            \%dlc2dlc_name, \%work_area2dlc, \%work_area2name);
 #foreach $key (keys %dlc2work_area) {
 #  print "DLC '$key' -> '" . $dlc2work_area{$key} . "'\n";
 #}

#
#  Read rolecode-to-function mapping file
#
 %function_to_rolecode = ();
 &read_roles_mapping_file(\%function_to_rolecode, $input_map);
 foreach $key (keys %function_to_rolecode) {
   print "function '$key' -> role code '$function_to_rolecode{$key}'\n";
 }

#
#  Get a hash that maps Kerberos username to pernr (Personnel Number)
#
 print "Getting mapping of Kerberos usernames to PERNRs...\n";
 &get_kerbname_to_pernr_mapping($lda2, \%kerbname2pernr);
 #print "Testing: 'REPA' -> " . $kerbname2pernr{'REPA'} . "\n";

#
#  Open another connection to oracle
#
 $lda2->disconnect;
 my $lda = &login_sql($dbname) 
      || die "Oracle error in login to '$dbname' database. "
          . "\n " . $ora_errstr;

#
#  Get a hash that maps DLC codes to DLC names
#
 my %dlc_code2name = ();
 &get_dlc_code_to_name($lda, \%dlc_code2name);

#
#  Read EHS authorizations from the Roles DB. For those that have a 
#  function in the rolecode-to-function mapping file, write an 
#  output record.  (Ignore EHS authorizations in the Roles DB that 
#  are not found in the mapping file; they are not relevant for the
#  feed to SAP.)
#
 print "Processing authorizations from the Roles DB...\n";
 &process_rolesdb_auths($lda, $roles_ehs_role_file,
                        \%function_to_rolecode, \%dlc2work_area,
                        \%kerbname2pernr);

#
#  Sort the two input files, the one from SAP and the one from the Roles DB.
#
 print "Sorting '$sap_ehs_role_file' -> '$sap_ehs_role_sort'\n";
 system("sort -o $sap_ehs_role_sort $sap_ehs_role_file\n");
 print "Sorting '$roles_ehs_role_file' -> '$roles_ehs_role_sort'\n";
 system("sort -o $roles_ehs_role_sort $roles_ehs_role_file\n");

#
#  Run Unix 'comm' command to find differences.  Reformat the output 
#  and put a label on each line
#  indicating '<--SAP WA only   '
#  or         '    Roles only-->'
# 
 my $difference_phrase;
 if( !open(F3, ">$compare_file") ) {
   die "$0: can't open ($compare_file) - $!\n";
 }
 chomp (my $today = `date '+%Y-%m-%d'`);
 print F3 "==== "
          . "EHS DLC-level roles - Differences between Roles DB & SAP, "
          . $today
          . " ====\n";
 print F3 "-----"
          . "----------------------------------------------------------"
          . "----------"
          . "-----\n";
 printf F3 "   Difference     Role %-20s %-8s %-15s %-8s %-50s\n",
                    'Work Area code', 'Pernr', 'DLC Code', 'Kerbname', 
                    'DLC Name';
 printf F3 "----------------   %-3s %-20s %-8s %-15s %8s %50s\n",
            '---', '--------------------', '--------', '---------------', 
            '--------', '--------------------------------------------------';
 open(COMM, "comm -3 $sap_ehs_role_sort $roles_ehs_role_sort |");
 my ($rolecode, $wa_code, $pernr, $dept_code, $kerbname);
 while (chomp($line = <COMM>)) {
   #print "line='$line'\n";
   if ($line =~ /^\t/) {
     $line = substr($line, 1);
     ($rolecode, $wa_code, $pernr, $dept_code, $kerbname) 
       = split($delim2, $line);
     $difference_phrase = "   Roles only-->";   # Not in SAP
     printf F3 "$difference_phrase : %-3s %-20s %-8s %-15s %-8s %-50s\n",
                $rolecode, $wa_code, $pernr, $dept_code, $kerbname,
                $dlc_code2name{$dept_code};
   }  
   else {      			  
     ($rolecode, $wa_code, $pernr, $dept_code, $kerbname) 
       = split($delim2, $line);
     $difference_phrase = "<--SAP only     ";   # Not in Roles
     printf F3 "$difference_phrase : %-3s %-20s %-8s %-15s %-8s %-50s\n",
                $rolecode, $wa_code, $pernr, $dept_code, $kerbname,
                $dlc_code2name{$dept_code};
   }
 }
 close(COMM);

#
# Call &get_roles_sap_dlc_diffs
# to find DLCs in SAP but not in Roles, and DLCs in Roles but not SAP.
# Builds %dlc_roles_not_sap and %dlc_sap_not_roles.
#
 my %dlc_roles_not_sap = ();
 my %dlc_sap_not_roles = ();
 &get_roles_sap_dlc_diffs($lda, \%dlc2work_area, \%dlc2dlc_name,
                        \%dlc_roles_not_sap, \%dlc_sap_not_roles,
                        \%sap_dlc_name_change);

#
# Write out a differences file indicating which DLCs are in the Roles DB 
# and not SAP, and vice versa.
#
 if( !open(F4, ">$compare_dlc_file") ) {
   die "$0: can't open ($compare_dlc_file) - $!\n";
 }
 print F4 "==== "
          . "DLCs - Differences between Roles DB & SAP, "
          . $today
          . " ====\n";
 print F4 "-----"
          . "----------------------------------------------------------"
          . "----------"
          . "-----\n";
 printf F4 "   Difference      %-15s %-20s %-50s\n",
            'DLC Code', 'Work Area Code', 'DLC Name';
 printf F4 "----------------   %-15s %-20s %-50s\n",
            '---------------', '--------------------',
            '--------------------------------------------------';
 my $temp_wa_code;
 foreach $dept_code (sort keys %dlc_sap_not_roles) {
     $difference_phrase = "<--SAP only     ";   # Not in Roles
     $temp_wa_code = $dlc_sap_not_roles{$dept_code};
     if ($dlc_code) {  # Only print WAs with a DLC_CODE here
       printf F4 "$difference_phrase : %-15s %-20s %-50s\n",
                 $dept_code, $temp_wa_code,
                 $work_area2name{$temp_wa_code};
     }
 }
 foreach $temp_wa_code (sort keys %work_area2dlc) {
     $dept_code = $work_area2dlc{$temp_wa_code};
     unless ($dept_code) {
       printf F4 "$difference_phrase : %-15s %-20s %-50s\n",
                 $dept_code, $temp_wa_code,
                 $work_area2name{$temp_wa_code};
     }
 }
 foreach $dept_code (sort keys %dlc_roles_not_sap) {
     $difference_phrase = "   Roles only-->";   # Not in SAP
     printf F4 "$difference_phrase : %-15s %-20s %-50s\n",
               $dept_code, ' ', 
               $dlc_code2name{$dept_code};
 }
 foreach $dept_code (sort keys %sap_dlc_name_change) {
     $difference_phrase = "<---DLC name--->";   # Change of name
     printf F3 "$difference_phrase : %-3s %-20s %-8s %-15s %-8s %-50s\n",
                ' ', $dlc2work_area{$dept_code}, ' ', $dept_code, ' ',
                $dlc_code2name{$dept_code};
     #$difference_phrase = "<--Name change->"; # Do not change the text
     printf F4 "$difference_phrase : %-15s %-20s %-50s\n",
               $dept_code, $dlc2work_area{$dept_code},
               $dlc_code2name{$dept_code};
 }
 close(F3);
 close(F4);


 $lda->disconnect;
 exit();

##############################################################################
#
#  Subroutine &get_dlc2work_area_mapping(\%dlc2work_area, $dlc_work_area_file,
#                \%dlc2dlc_name, \%work_area2dlc, \%work_area2name)
#
#  Updates a hash, setting 
#    $dlc2work_area($dlc_code) = $work_area_code;
#  by reading each line in the $dlc_work_area_file file.  
#
##############################################################################
sub get_dlc2work_area_mapping {
  my ($rdlc2work_area, $dlc_work_area_file, $rdlc2dlc_name,
      $rwork_area2dlc, $rwork_area2name) = @_;

 #
 #   Open the $dlc_work_area_file.
 #   Read each record.  Build hash %dlc2work_area.
 #   Also build hashes %work_area2dlc and %work_area2name.
 #
  unless (open(MAPDLC,$dlc_work_area_file)) {
    die "Cannot open $dlc_work_area_file for reading\n"
  }
  my $line;
  my ($dlc_code, $wa_code, $dlc_name);
  #print "delim2 = '$delim2'\n";
  print "Reading DLC to work area mapping file...\n";
  while (chop($line = <MAPDLC>)) {
    ($dlc_code, $wa_code, $dlc_name) = split($delim2, $line);
    $$rdlc2work_area{$dlc_code} = $wa_code;
    $$rdlc2dlc_name{$dlc_code} = $dlc_name;
    $$rwork_area2dlc{$wa_code} = $dlc_code;
    $$rwork_area2name{$wa_code} = $dlc_name;
  }
  close(MAPDLC);

}

##############################################################################
#
#  Subroutine &read_roles_mapping_file(\%function_to_rolecode, $map_infile)
#
#  Updates a hash, setting 
#    $function_to_rolecode($function_name) = $role_code;
#  by reading each line in the $map_infile file.  
#
##############################################################################
sub read_roles_mapping_file {
  my ($rfunction_to_rolecode, $map_infile) = @_;

 #
 #   Open the role-to-function mapping file.
 #   Read each record.  Build hash %function_to_rolecode (Maps a Roles DB
 #     function name to a 3-byte SAP role code)
 #
  unless (open(MAP,$inputmap)) {
    die "Cannot open $inputmap for reading\n"
  }
  my $line;
  my ($role1, $func1);
  while (chop($line = <MAP>)) {
    ($role1, $func1) = split('!', $line);
    $$rfunction_to_rolecode{$func1} = $role1;
  }
  close(MAP);

}

##############################################################################
#
# Subroutine login_sql($symbolic_db_name)
#
# Look up the symbolic database name in dbweb.config and
# get (db, username, pw).  Use this to login to an Oracle database.  Try
# up to 3 times.
#
##############################################################################
sub login_sql 
{
	my ($db_symbol) = @_;
        my $db_parm = GetValue($db_symbol);
        $db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
        my $user = $1;
        my $pw = $2;
        my $db = $3;
        print "Connecting to DB '$db' USER '$user'\n";
        for ($i = 0; $i < 3; $i++) {  # Retry 3 times
	    if ($lda = &ora_login($db, $user, $pw)) {
               return $lda;
	   }
        }
        print "Oracle connect to database '$db' failed after 3 tries.<BR>\n";
        print "$ora_errstr<BR>\n";
        return 0;
}

##############################################################################
#
#  Subroutine &process_rolesdb_auths($lda, $roles_ehs_role_file,
#                                    \%function_to_rolecode, \%dlc2work_area,
#                                    \%kerbname2pernr)
#
#  Reads records from the Roles Database and writes to a file
#
##############################################################################
sub process_rolesdb_auths {
  my ($lda, $roles_ehs_role_file, $rfunction_to_rolecode, $rdlc2work_area,
      $rkerbname2pernr) = @_;

 #
 #   Open output file.
 #
   my $outf = ">$roles_ehs_role_file";
   print "Opening output file '$roles_ehs_role_file'\n";
   if( !open(RDBOUT, $outf) ) {
     die "$0: can't open ($outf) - $!\n";
   }

 #
 #  Open cursor
 #    Three parts: (1) Explicit authorizations, only including those whose
 #                     qualifier is a leaf-level DLC
 #                 (2) Authorizations with child qualifiers, but only
 #                     those where the child qualifier is a leaf-level DLC
 #
  my @stmt = ("select a.kerberos_name, a.function_name, a.qualifier_code
                from authorization a
                where a.function_category = 'EHS'
                and a.do_function = 'Y'
                and sysdate+1 between a.effective_date+1
                                    and nvl(a.expiration_date, sysdate+1)
                and not exists 
                  (select q2.qualifier_code
                   from qualifier_child qc, qualifier q2
                   where qc.parent_id = a.qualifier_id
                   and q2.qualifier_id = qc.child_id
                   and substr(q2.qualifier_code,1,2) = 'D_')
               union select a.kerberos_name, a.function_name, q.qualifier_code
                from authorization a, qualifier_descendent qd, qualifier q
                where a.function_category = 'EHS'
                --and a.qualifier_code <> 'D_ALL'
                and a.do_function = 'Y'
                and sysdate+1 between a.effective_date+1
                                    and nvl(a.expiration_date, sysdate+1)
                and a.descend = 'Y'
                and qd.parent_id = a.qualifier_id
                and q.qualifier_id = qd.child_id
                and substr(q.qualifier_code,1,2) = 'D_'
                and not exists 
                  (select q2.qualifier_code
                   from qualifier_child qc, qualifier q2
                   where qc.parent_id = q.qualifier_id
                   and q2.qualifier_id = qc.child_id
                   and substr(q2.qualifier_code,1,2) = 'D_')
               order by 1, 2, 3");
  print "Opening 1st cursor...\n";
  my $csr = &ora_open($lda, "@stmt")
         || die $ora_errstr;
 
 #
 #  Read in rows.  If the function_name matches a row in the mapping 
 #  table, then print out a record.
 #
  print "Reading EHS authorizations from authorization table...\n";
  my ($kerbname, $function_name, $dept_code);
  while ( ($kerbname, $function_name, $dept_code) = &ora_fetch($csr) )
  {
    my $rolecode = $$rfunction_to_rolecode{$function_name};
    if ($rolecode) {
      #print "kerbname='$kerbname' function='$function_name':"
      #      . " dept='$dept_code'\n";
      my $wa_code = $$rdlc2work_area{$dept_code};
      my $pernr = $$rkerbname2pernr{$kerbname};
      print RDBOUT "$rolecode$delim2a$wa_code$delim2a$pernr$delim2a$dept_code"
                   . "$delim2a$kerbname\n";
    }
  }

  &ora_close($csr) || die "can't close cursor";
  close(RDBOUT);

}

##############################################################################
#
#  Subroutine &get_kerbname_to_pernr_mapping($lda, \%kerbname2pernr)
#
#  Opens a connection to the Warehouse, and reads the views
#  wareuser.pernr_mitid_mapping and wareuser.krb_mapping to 
#  get a mapping between personnel_number (pernr) and kerberos_name.
#  Builds the hash %kerbname2pernr.
#
##############################################################################
sub get_kerbname_to_pernr_mapping {
  my ($lda, $rkerbname2pernr) = @_;

 #
 #  Open cursor
 #
  my @stmt = ("select k.krb_name_uppercase, m.personnel_key
               from wareuser.krb_mapping k, 
                    wareuser.pernr_mitid_mapping m
               where m.mit_id = k.mit_id
               order by personnel_key");
  my $csr = &ora_open($lda, "@stmt")
         || die $ora_errstr;
 
 #
 #  Read in rows from the Warehouse views
 #
  print "Reading personnel_number and Kerberos name pairs"
        . " from the Warehouse...\n";
  my ($kerbname, $pernr);
  while ( ($kerbname, $pernr) = &ora_fetch($csr) ) 
  {
    $$rkerbname2pernr{$kerbname} = $pernr;
  }
  &ora_close($csr) || die "can't close cursor";
}

##############################################################################
#
#  Subroutine &get_dlc_code_to_name($lda, \%dlc_code2name)
#
#  Opens a connection to the Roles DB, and reads department codes
#  and names, building a hash where
#     $dlc_code2name{$dlc_code} = $dlc_name
#  for each $dlc_code
#
##############################################################################
sub get_dlc_code_to_name {
  my ($lda, $rdlc_code2name) = @_;

 #
 #  Open cursor
 #
  my @stmt = ("select q.qualifier_code, q.qualifier_name
               from qualifier q
               where q.qualifier_type = 'DEPT'
               and not exists 
               (select q2.qualifier_code
                from qualifier_child qc, qualifier q2
                where qc.parent_id = q.qualifier_id
                and q2.qualifier_id = qc.child_id
                and substr(q2.qualifier_code, 1, 2) = 'D_')
               union select 'NULL', 'n/a' from dual
               order by 1");
  my $csr = &ora_open($lda, "@stmt")
         || die $ora_errstr;
 
 #
 #  Read in rows from the Roles DB Qualifier table
 #
  print "Reading DLC codes and names from Roles DB table...\n";
  my ($dept_code, $dept_name);
  while ( ($dept_code, $dept_name) = &ora_fetch($csr) ) 
  {
    $$rdlc_code2name{$dept_code} = $dept_name;
  }
  &ora_close($csr) || die "can't close cursor";
}

##############################################################################
#
#  Subroutine 
#    &get_roles_sap_dlc_diffs($lda, \%dlc2work_area, \%dlc2dlc_name, 
#                             \%dlc_roles_not_sap, \%dlc_sap_not_roles,
#                             \%sap_dlc_name_change)
#
#  Reads in a list of DLCs from the Roles DB qualifier table 
#  (qualifier type DEPT) such that there are no child DLCs.
#  Compare this to the list of DLCs from SAP in the %dlc2work_area hash.
#
#  Build 3 hashes:
#  - %dlc_roles_not_sap   Set $dlc_roles_not_sap{$dlc_code} = 1 where
#                           a matching DLC_code is not found in SAP
#  - %dlc_sap_not_roles   Set $dlc_sap_not_roles{$dlc_code} = $wa_code
#                           (the SAP work area code) where a matching
#                           DLC_code is not found in the Roles DB
#  - %sap_dlc_name_change Set $sap_dlc_name_change{$dlc_code} = the 
#                           DLC name from the Roles DB if it disagrees
#                           with the DLC name from SAP.
#
##############################################################################
sub get_roles_sap_dlc_diffs {
  my ($lda, $rdlc2work_area, $rdlc2dlc_name, 
      $rdlc_roles_not_sap, $rdlc_sap_not_roles,
      $rsap_dlc_name_change) = @_;

 #
 #  Open cursor
 #
  my $stmt = "select q1.qualifier_code, q1.qualifier_name
              from qualifier q1
              where q1.qualifier_type = 'DEPT'
              and substr(q1.qualifier_code, 1, 2) = 'D_'
              and not exists 
              (select q2.qualifier_code from qualifier_child qc, qualifier q2
               where qc.parent_id = q1.qualifier_id 
               and q2.qualifier_id = qc.child_id
               and substr(q2.qualifier_code, 1, 2) = 'D_')";
  my $csr = &ora_open($lda, $stmt)
         || die $ora_errstr;
 
 #
 #  Read in a list of DLC codes from the Roles DB
 #
  print "Reading list of DLC codes from the Roles DB...\n";
  my ($dlc_code, $roles_dlc_name);
  my %roles_dlc;
  my %roles_dlc2name;
  while ( ($dlc_code, $roles_dlc_name) = &ora_fetch($csr) ) 
  {
    $roles_dlc{$dlc_code} = 1;
    $roles_dlc2name{$dlc_code} = $roles_dlc_name;
  }
  &ora_close($csr) || die "can't close cursor";

 #
 #  Testing diagnostics:  Print all the DLCs from SAP
 # 
  my $dlc_name;
  foreach $key (keys %$rdlc2work_area) {
      $dlc_name = $$rdlc2dlc_name{$key};
      #print "In SAP $key ... '" . $$rdlc2work_area{$key} . "' '$dlc_name'\n";
  }

 #
 #  Fill in %dlc_roles_not_sap for every DLC_code found in the Roles DB
 #  but not in SAP.
 #  Also, look for DLCs in both Roles and SAP with different names.
 #
  foreach $dlc_code (keys %roles_dlc) {
      if ($$rdlc2work_area{$dlc_code}) {
	  #print "DLC $dlc_code found in both SAP and Roles\n";
          if ($$rdlc2dlc_name{$dlc_code} ne $roles_dlc2name{$dlc_code}) {
              $$rsap_dlc_name_change{$dlc_code} = $roles_dlc2name{$dlc_code};
              print "Names disagree. '" . $$rdlc2dlc_name{$dlc_code} 
                   . "' '" . $roles_dlc2name{$dlc_code} . "'\n";
          }
          else {
	      #print "The DLC name agrees in Roles and SAP\n";
          }
      }
      else {
	  $$rdlc_roles_not_sap{$dlc_code} = 1;
         #print "Roles, not SAP: $dlc_code $$rdlc_roles_not_sap{$dlc_code}\n";
      }
  }

 #
 #  Fill in %dlc_sap_not_roles for every DLC_code found in SAP but
 #  not the Roles DB.  Set the value to the work area code.
 #
  foreach $dlc_code (keys %$rdlc2work_area) {
      unless ($roles_dlc{$dlc_code}) {
	  $$rdlc_sap_not_roles{$dlc_code} = $$rdlc2work_area{$dlc_code};
         #print "SAP, not Roles: $dlc_code $$rdlc_roles_not_sap{$dlc_code}\n";
      }
  }
}


