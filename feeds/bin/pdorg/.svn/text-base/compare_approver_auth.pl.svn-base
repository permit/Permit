#!/usr/bin/perl
########################################################################
#
#  Extract approver-related authorizations from the Roles DB and compare
#  them to approver-related authorizations extracted from the PD Org.
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
#  Modified by Jim Repa, 8/23/1999
#  Modified by Jim Repa, 7/11/2000.  Add position_code column.
#  Modified by Jim Repa, 10/2/2000.  Removed dependency on rolesweb.pm
#  Modified by Jim Repa, 3/12/2001.  Suppress "Roles only" diffs where
#                                    user does not have CAN USE SAP
#  Modified by Jim Repa, 1/10/2003.  Do not suppress diffs where user
#                                    does not have CAN USE SAP
#
########################################################################
$datafile_dir = $ENV{'PDORG_DATADIR'};
$roles_auth_file = $datafile_dir . 'approver_auth.roles';
$roles_auth_sort = $datafile_dir . 'approver_auth_roles.sort';
$pdorg_auth_file = $datafile_dir . 'approver_auth2';
$pdorg_auth_sort = $datafile_dir . 'approver_auth_pdorg.sort';
$compare_file = $datafile_dir . 'pdorg_roles.compare';
$compare_file2 = $datafile_dir . 'pdorg_roles.compare2';
$ftp_date_file = $datafile_dir . 'pdorg_ftp.date';
$pdorg_file = $datafile_dir . 'pdorg2';
$task_file = $datafile_dir . "pdorg_position";

#
# Packages not needed
#
 #use rolesweb('login_sql');   #Use sub. login_sql in rolesweb.pm


#
#   Open output file.
#
  $outf = ">" . $roles_auth_file;
  if( !open(F2, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }

#
#  Make sure we are set up to use Oraperl.
#
 use Oraperl;
 if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}
 
#
#  Open connection to oracle
#
my $lda = &login_sql('roles') 
      || die "Oracle error in login. "
          . "The database may be shut down temporarily for backups." 
          . "\n " . $ora_errstr;

#
#  Get a list of users who CAN USE SAP.
#
 %sap_user = ();
 &get_sap_users(\%sap_user, $lda);

#
#  Get mapping of org_code/fund -> task_code
#
 %org_func_to_task_code = ();
 &get_position_codes(\%org_func_to_task, $task_file);

#
#  Look in the pdorg file to find which Spending Groups are in the PD Org.
#  (Numeric spending groups, those that are PD Org only are flagged
#  as $sg_existence_code{$sg_code} = 2.  Alphabetic ones, which should
#  match Spending Groups in Roles, are flagged as
#  $sg_existence_code{$sg_code} = 1.
#  Also, build a hash %sg_to_org that maps the spending group name to
#    the 5nnnnnnn number from the PD Org.
#
 %sg_existence_code = ();
 %sg_to_org = ();
 &find_sg_in_pdorg(\%sg_existence_code, \%sg_to_org, $pdorg_file);
 #foreach $key (sort keys %sg_to_org) {
 #  print F2 "$key -> $sg_to_org{$key}\n";
 #}

#
#  Look in Roles DB to find which Spending Groups are in Roles.
#
 &find_sg_in_roles(\%sg_existence_code, $lda);
 #foreach $key (sort keys %sg_existence_code) {
 #  print F2 "$key => $sg_existence_code{$key}\n";
 #}

#
#  Open cursor
#
 @stmt = ("select a.kerberos_name, a.function_name, a.qualifier_code",
           " from authorization a",
           " where a.function_name like '%APPROV%'",
           " and a.function_category = 'SAP'",
           " and a.qualifier_code like 'SG%'",
           " and a.do_function = 'Y'",
           " and sysdate between a.effective_date",
           " and nvl(a.expiration_date, sysdate)",
#           " and exists (select b.kerberos_name from authorization b",
#           " where b.kerberos_name = a.kerberos_name",
#           " and b.function_name = 'CAN USE SAP'",
#           " and b.do_function = 'Y'",
#           " and sysdate between b.effective_date ",
#           " and nvl(b.expiration_date,sysdate))",
         " union",
           " select /*+ ORDERED */ a.kerberos_name, a.function_name,",
           " q.qualifier_code",
           " from authorization a, qualifier_child qc1, qualifier_child qc2,",
           "     qualifier q, qualifier_child qc3",
           " where a.function_name like '%APPROV%'",
           " and a.function_category = 'SAP'",
           " and a.qualifier_code like 'SG%'",
           " and a.do_function = 'Y'",
           " and sysdate between a.effective_date",
           " and nvl(a.expiration_date, sysdate)",
           " and qc1.parent_id = a.qualifier_id",
           " and qc2.parent_id = qc1.child_id",
           " and qc3.parent_id(+) = qc2.child_id",
           " and qc3.child_id is NULL",
           " and q.qualifier_id = qc1.child_id",
#           " and exists (select b.kerberos_name from authorization b",
#           " where b.kerberos_name = a.kerberos_name",
#           " and b.function_name = 'CAN USE SAP'",
#           " and b.do_function = 'Y'",
#           " and sysdate between b.effective_date ",
#           " and nvl(b.expiration_date,sysdate))",
         " union",
           " select /*+ ORDERED */ a.kerberos_name, a.function_name,",
           " q.qualifier_code",
           " from authorization a, qualifier_child qc1, qualifier_child qc2,",
           "     qualifier q, qualifier_child qc3",
           " where a.function_name like '%APPROV%'",
           " and a.function_category = 'SAP'",
           " and a.qualifier_code like 'SG%'",
           " and a.do_function = 'Y'",
           " and sysdate between a.effective_date",
           " and nvl(a.expiration_date, sysdate)",
           " and qc1.parent_id = a.qualifier_id",
           " and qc2.parent_id = qc1.child_id",
           " and qc3.parent_id = qc2.child_id",
           " and q.qualifier_id = qc2.child_id",
#           " and exists (select b.kerberos_name from authorization b",
#           " where b.kerberos_name = a.kerberos_name",
#           " and b.function_name = 'CAN USE SAP'",
#           " and b.do_function = 'Y'",
#           " and sysdate between b.effective_date ",
#           " and nvl(b.expiration_date,sysdate))",
           " order by 3,2,1");
 $csr = &ora_open($lda, "@stmt")
        || die $ora_errstr;

#
#  Read in rows from the authorization table
#
 print "Processing in Authorizations from Oracle table...\n";
 $i = -1;
 while ( ($kerbname, $funcname, $qualcode) = &ora_fetch($csr) ) 
 {
   if (($i++)%1000 == 0) {print $i . "\n";}
   print F2 "$qualcode!$funcname!$kerbname\n";
 }
 &ora_close($csr) || die "can't close cursor";
 
 close (F2);
 
 &ora_logoff($lda) || die "can't log off Oracle";

#
#  Sort the two input files, "pdorg2" and "approver_auth.roles".
#
 system("sort -o $pdorg_auth_sort $pdorg_auth_file\n");
 system("sort -o $roles_auth_sort $roles_auth_file\n");

#
#  Get date from FTP date file.  Get current date.
#
 chomp($ftp_date = `cat $ftp_date_file`);
 chomp($current_date = `date '+%Y%m%d%H%M'`);
 $ftp_date = &fmt_date($ftp_date);
 $current_date = &fmt_date($current_date);

#
#  Run Unix 'comm' command to find differences.  4Put a label on each line
#  indicating '<-- PD Org only   '
#  or         '     Roles only-->'
# 
 if( !open(F3, ">$compare_file") ) {
   die "$0: can't open ($compare_file) - $!\n";
 }
 if( !open(F4, ">$compare_file2") ) {
   die "$0: can't open ($compare_file2) - $!\n";
 }
 print F3 "Comparison of approver authorizations in the PD Org and"
          . " in the Roles database\n"
          . "  Time of PD Org extract: $ftp_date\n"
          . "  Time of comparison: $current_date\n"
          . "\n Approver authorizations in the Roles DB are ignored if the"
          . " user does not have\n"
          . " a CAN USE SAP authorization.\n"
          . " Users in the PD Org without a CAN USE SAP authorization are"
          . " flagged with"
          . " a plus sign (+)"
          . "\n (Differences that are due to missing [spending group]"
          . " codes in the PD Org"
          . "\n  are flagged with *)\n\n";
 print F4 "Comparison of approver authorizations in the PD Org and"
          . " in the Roles database\n"
          . "  Time of PD Org extract: $ftp_date\n"
          . "  Time of comparison: $current_date\n"
          . "\n Approver authorizations in the Roles DB are ignored if the"
          . " user does not have\n"
          . " a CAN USE SAP authorization.\n"
          . " Users in the PD Org without a CAN USE SAP authorization are"
          . " flagged with"
          . " a plus sign (+)"
          . "\n (Differences that are due to missing [spending group]"
          . " codes in the PD Org"
          . "\n   are not shown)\n\n";
 printf F3 "     Difference      %-15s %-8s %-30s%-9s  %8s\n",
            'Spending Group', 'Org code', 'Function', 'Username', 
            'Pos code';
 printf F3 "     ----------      %-15s %-8s %-30s%-9s  %8s\n",
            '---------------', '--------', '-----------------------', 
            '--------', '--------';
 printf F4 "     Difference      %-15s %-8s %-30s%-9s  %8s\n",
            'Spending Group', 'Org code', 'Function', 'Username', 
            'Pos code';
 printf F4 "     ----------      %-15s %-8s %-30s%-9s  %8s\n",
            '---------------', '--------', '-----------------------', 
            '--------', '--------';
 open(COMM, "comm -3 $pdorg_auth_sort $roles_auth_sort |");
 $old_qc = '';
 while (chomp($line = <COMM>)) {
   if ($line =~ /^\t/) {
     $line = substr($line, 1);
     ($qc, $function, $kerbname) = split('!', $line);
     $task_code = $org_func_to_task{"$qc!$function"};
     if (!$task_code) {$task_code = '????????';}
     ## Skip the next step
     #if (!($sap_user{$kerbname})) {$kerbname .= '+';} # Mark non-SAP user
     if ($old_qc ne $qc) {print F3 "\n";}  # Blank for readability
     $difference_phrase = ($sg_existence_code{$qc} == 3)
       ? "   * Roles only-->"   # Not in PD Org, and code not found in PD Org
       : "     Roles only-->";  # Not in PD Org, but code found in PD Org
     printf F3 "$difference_phrase : %-15s %-8s %-30s%-9s  %8s\n",
               $qc, $sg_to_org{$qc}, $function, $kerbname, $task_code;
     if (!($difference_phrase =~ /\* Roles/)) {
       if ($old_qc ne $qc) {print F4 "\n";}  # Blank for readability
       printf F4 "$difference_phrase : %-15s %-8s %-30s%-9s  %8s\n",
                 $qc, $sg_to_org{$qc}, $function, $kerbname, $task_code;
     }	       
   }  
   else {      			  
     ($qc, $function, $kerbname) = split('!', $line);
     $task_code = $org_func_to_task{"$qc!$function"};
     if (!$task_code) {$task_code = '????????';}
     ## Skip the next step
     if (!($sap_user{$kerbname})) {$kerbname .= '+';} # Mark non-SAP user
     if ($old_qc ne $qc) {print F3 "\n";}  # Blank for readability
     $difference_phrase = ($sg_existence_code{$qc} == 2)
       ? "<-- PD Org only * "   # Not in Roles DB, and code doesn't match
       : "<-- PD Org only   ";  # Not in Roles DB, but code matches
     printf F3 "$difference_phrase : %-15s %-8s %-30s%-9s  %8s\n",
               $qc, $sg_to_org{$qc}, $function, $kerbname, $task_code;
     if (!($difference_phrase =~ /PD Org only \*/)) {
       if ($old_qc ne $qc) {print F4 "\n";}  # Blank for readability
       printf F4 "$difference_phrase : %-15s %-8s %-30s%-9s  %8s\n",
                 $qc, $sg_to_org{$qc}, $function, $kerbname, $task_code;
     }
   }
   $old_qc = $qc;
 }
 close(COMM);
 close(F3);
 close(F4);

 exit();

##############################################################################
#
#  Function &fmt_date(yyyymmddhhmm)
#
#  Returns date in yyyy/mm/dd hh:mm format
#
##############################################################################

sub fmt_date {
  ($yyyymmddhhmm) = @_;
  return substr($yyyymmddhhmm, 0, 4) . '/'
         . substr($yyyymmddhhmm, 4, 2) . '/'
         . substr($yyyymmddhhmm, 6, 2) . ' '
         . substr($yyyymmddhhmm, 8, 2) . ':'
         . substr($yyyymmddhhmm, 10, 2);
}

##############################################################################
#
#  Subroutine 
#    &find_sg_in_pdorg(\%sg_existence_code, \%sg_to_org, $pdorg_file)
#
#  Builds a hash where $sg_existence_code{$sg_code} is
#      1 if a matching code is found in PD Org and Roles
#      2 if a matching code is found in PD Org only
#      3 if a matching code is found in Roles only
#
#  In this step, set $sg_existence_code{$sg_code} = 2.  We'll look in Roles
#  later.
#
##############################################################################

sub find_sg_in_pdorg {
  my ($rsg_existence_code, $rsg_to_org, $pdorg_file) = @_;

 #
 # Open input file
 #
  unless (open(PDO,$pdorg_file)) {
    die "Cannot open $pdorg_file for reading\n"
  }

 #
 # Clear the hash  
 #
  %$rsg_existence_code = ();

 #
 # Read each line from the PDOrg file, and put an item in hash for each
 # Org (aka Spending Group) found there.
 #
  my $line;
  my ($qualtype, $qualcode, $qualparent, $qualname, $org);
  while (chop($line = <PDO>)) {
    ($qualtype, $qualcode, $qualparent, $qualname, $org) =
      split('!', $line);
    $$rsg_existence_code{$qualcode} = 2;
    $$rsg_to_org{$qualcode} = $org;
  }
 close(IN);

}

##############################################################################
#
#  Subroutine &find_sg_in_roles(\%sg_existence_code, $pdorg_file)
#
#  Updates a hash where $sg_existence_code{$sg_code} is
#      1 if a matching code is found in PD Org and Roles (i.e., code is
#        alphanumeric in PD Org)
#      2 if a matching code is found in PD Org only (i.e., code is numeric)
#      3 if a matching code is found in Roles only
#
##############################################################################

sub find_sg_in_roles {
  my ($rsg_existence_code, $lda) = @_;

 #
 #  Open cursor
 #
  my @stmt = ("select qualifier_code",
            " from qualifier",
            " where qualifier_type = 'SPGP'",
            " order by qualifier_code");
  my $csr = &ora_open($lda, "@stmt")
         || die $ora_errstr;
 
 #
 #  Read in rows from the qualifier table.
 #
  print "Reading Spending Groups from qualifier table...\n";
  my $qualcode;
  while ( ($qualcode) = &ora_fetch($csr) ) 
  {
    if ($$rsg_existence_code{$qualcode} == 2) {
      $$rsg_existence_code{$qualcode} = 1;
    }
    else {
      $$rsg_existence_code{$qualcode} = 3;
    }
  }
  &ora_close($csr) || die "can't close cursor";
}

##############################################################################
#
#  Subroutine &get_sap_users(\%sap_user, $lda)
#
#  Updates a hash, setting $sap_user{$username} = 1 where
#  a "CAN USE SAP" authorization is found for this user.
#
##############################################################################

sub get_sap_users {
  my ($rsap_user, $lda) = @_;

 #
 #  Open cursor
 #
  my @stmt = ("select kerberos_name from authorization",
            " where function_name = 'CAN USE SAP'",
            " order by kerberos_name");
  my $csr = &ora_open($lda, "@stmt")
         || die $ora_errstr;
 
 #
 #  Read in rows from the qualifier table.
 #
  print "Reading CAN USE SAP authorizations from authorization table...\n";
  my $kerbname;
  while ( ($kerbname) = &ora_fetch($csr) ) 
  {
    $$rsap_user{$kerbname} = 1;
  }
  &ora_close($csr) || die "can't close cursor";
}

##############################################################################
#
#  Subroutine &get_position_codes(\%org_func_to_task, $task_file)
#
#  Updates a hash, setting 
#    $org_func_to_task("$org_code!$func_name") = $task_code;
#  by reading each line in the $task_file file.  
#
##############################################################################

sub get_position_codes {
  my ($rorg_func_to_task, $task_file) = @_;

 #
 #   Open the $task_file.
 #   Read each record.  Build hash %org_func_to_task.
 #
  unless (open(TASK,$task_file)) {
    die "Cannot open $task_file for reading\n"
  }
  my $line;
  my ($org, $func, $task_code);
  print "Reading org_code/function -> task_code mapping...\n";
  while (chop($line = <TASK>)) {
    ($org, $func, $task_code) = split('!', $line);
    $$rorg_func_to_task{"$org!$func"} = $task_code;
  }
  close(TASK);

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
        my ($db, $user, $pw) = &get_database_info($db_symbol); #Read conf. file
        #$ENV{'ORACLE_HOME'} = '/dbmsu001/app/oracle/product/7.3.4';
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
# Subroutine get_database_info($symbolic_db_name)
#
# Look up the symbolic database name in dbweb.config and
# return (db, username, pw).
#
##############################################################################
sub get_database_info {
    my($db_symbol) = $_[0];  # Get first argument (symbolic_database_name)
    my $filename = "dbweb.config";
    my $fullpath = $ENV{"ROLES_CONFIG"};
    my ($sym_db, $db, $user, $pw);
 
    unless (open(CONF,$fullpath)) {  # Open the config file
       print "<br><b>Cannot open the configuration file. <br>"
         . " The configuration file should be $fullpath<b>";
       exit();
    }
 
    while (chop($line = <CONF>)) {
      if ($line =~ /^$db_symbol\:/) {  # Look for the right line
        $line =~ m/^(.*):(.*)\/(.*)\@(.*)$/;
	$user = $2;
	$pw   = $3;
	$db   = $4;      }
    }
    close(CONF);  # Close the config file
    return ($db, $user, $pw);  # Return triplet of db, user, pw
}

