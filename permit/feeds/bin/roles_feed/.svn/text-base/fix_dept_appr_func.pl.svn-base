#!/usr/bin/perl  -I/home/www/permit/feeds/lib/cpa
##############################################################################
#
#  For each department, find a list of approver functions that can be
#  granted by Primary Authorizors.
#
#
#  - The $approver_function_file maps SAP Release Strategy codes (2-5 & A)
#    to APPROVER functions (e.g. APPROVER MOD 2 LEV 1).
#  - Build a hash containing a list of Release Strategies associated with
#    each Department. 
#  - Build a hash containing the FUNCTION_ID number associated with each
#    SAP FUNCTION_NAME.
#  - Print out a file with records of the format $dept_code!$func_id!$func_name
#    which shows the allowable APPROVER authorizations within each department.
#  - Build an array (@new_dept_func_id) with elements of the form 
#    $dept_code!$func_id showing the desired list of APPROVER function_ids
#    for each department
#  - Read from the table DEPT_APPROVER_FUNCTION to build @old_dept_func_id
#  . . .
#  - Compare @old_dept_func_id and @new_dept_func_id.  Do inserts and
#    deletes to DEPT_APPROVER_FUNCTION table where appropriate.
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
#  Modified to run as part of nightly batch feeds, 8/21/2001, Jim Repa.
#  Modified 8/27/2001 to fix handling of optional parameter (DB instance)
#
###############################################################################
#
# Get packages
#
use config('GetValue');  # Use the subroutine GetValue in ~/lib/cpa/config.pm
use roles_base ( 'login_dbi_sql' );

#
#  Set some constants
#
 $tempdir = $ENV{'ROLES_HOMEDIR'} . "/data/";
 $approver_function_file = $tempdir . 'pa.approver_functions';
 $out_file = $tempdir . 'dept_approver.functions';

#
#  Read in a file of approver functions associated with Primary Authorizors
#
 %approver_function = ();
 &get_approver_function_list(\%approver_function, $approver_function_file);
 #foreach $key (sort keys %approver_function) {
 #  print "$key -> $approver_function{$key}\n";
 #}
 print "Found " . scalar(keys %approver_function) 
        . " release strategies in approver_functions file\n";

#
#  Get set to use Oracle.
#
use DBI;

#
#  Get database name
#
 if ($#ARGV >= 0) {
   $db_name = $ARGV[0];
 }
 else {
   $db_name = 'roles';
 }

#
#  Get username and password.
#
 $db_parm = GetValue($db_name);
 $db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
 $user = $1;
 $pw = $2;
 $db = $3;
 print "db=$db user=$user\n";

#
#  Open connection to oracle
#
 #print "Ready to do &ora_login...";
 my %connect_parm;
 $connect_parm{'AutoCommit'} = 0;  # Turn off AutoCommit.
$lda =  login_dbi_sql($db, $user, $pw)
        || die $DBI::errstr;

# $lda = DBI->connect("DBI:Oracle:$db",$user,$pw, \%connect_parm)
#             || die "Unable to connect to $db: $DBI::errstr\n";
 #
 # Define a global statement handle for reading the contents of the existing
 # table DEPT_APPROVER_FUNCTION
 #
 my $stmt1 = 
   "select dept_code, function_id from dept_approver_function
    order by dept_code, function_id";
 unless ($gcsr1 = $lda->prepare($stmt1)) 
 {
    die "Error preparing statement 1.\n";
 }

 #
 # Define a global statement handle for deleting rows from 
 #  DEPT_APPROVER_FUNCTION
 #
 my $stmt2 = 
     " delete from dept_approver_function where dept_code = ? 
       and function_id = ? "; 
 unless ($gcsr2 = $lda->prepare($stmt2)) 
 {
    die "Error preparing statement 2.\n";
 }

 #
 # Define a global statement handle for inserting rows into
 #  DEPT_APPROVER_FUNCTION
 #
 my $stmt3 =
      " insert into dept_approver_function (dept_code, function_id)
       values (?, ?)";
 unless ($gcsr3 = $lda->prepare($stmt3)) 
 {
    die "Error preparing statement 3.\n";
 }

 #
 # Define a global statement handle for getting a list of SAP functions
 # with their function_name and function_id
 #
 my $stmt5 = 
   " select function_name, function_id from function
    where function_category = 'SAP'
    order by function_name ";
 
 unless ($gcsr5 = $lda->prepare($stmt5)) 
 {
    die "Error preparing statement 5.\n";
 }

 #
 # Define a global statement handle for finding Release Strategies
 # associated with a Department
 #
 #   and cc.fund_center_id = ltrim(q2.qualifier_code,'FC')
 my $stmt6 = 
   " select q.qualifier_code, cc.release_strategy, count(*)
    from qualifier q, primary_auth_descendent qd, qualifier q2, 
         wh_cost_collector cc
    where q.qualifier_type = 'DEPT'
    and substr(q.qualifier_code, 1, 2) = 'D_'
    and qd.parent_id = q.qualifier_id
    and q2.qualifier_id = qd.child_id
    and q2.qualifier_code like 'FC%'
    and substr(q2.qualifier_code, 3, 1) <> '_'
    and cc.fund_center_id = CASE substr(q2.qualifier_code,1,2) WHEN 'FC' THEN substr(q2.qualifier_code FROM 3) ELSE q2.qualifier_code END 
    and cc.release_strategy not in ('1', ' ')
    group by q.qualifier_code, cc.release_strategy";
 unless ($gcsr6 = $lda->prepare($stmt6)) 
 {
    die "Error preparing statement 6.\n";
 }

#
#  Build a hash containing a list of Release Strategies associated with
#  each Department. 
#
 %dept_to_rs = ();
 &dept_release_strategy($lda, \%dept_to_rs);
 #foreach $key (sort keys %dept_to_rs) {
 #  print "$key -> $dept_to_rs{$key}\n";
 #}

#
#  Build a hash containing the FUNCTION_ID number associated with each
#  SAP FUNCTION_NAME.
#
 %func_name_to_id = ();
 &get_func_name_to_id($lda, \%func_name_to_id);
 #foreach $key (sort keys %func_name_to_id) {
 #  print "$key -> $func_name_to_id{$key}\n";
 #}

#
#  Build an array @new_dept_func_id with elements of the form 
#    $dept_code!$func_id, showing the desired list of APPROVER function_ids
#    for each department.
#  For testing purposes, 
#    print out a file with records of the format $dept_code!$func_id!$func_name
#    which shows the allowable APPROVER authorizations within each department.
#
 @new_dept_func_id = ();
 my $outf = ">$out_file";
 if( !open(F1, $outf) ) {
   die "$0: can't open ($outf) - $!\n";
 }
 foreach $dept_code (sort keys %dept_to_rs) {
   @dept_rs = split('!', $dept_to_rs{$dept_code});
   foreach $rs (@dept_rs) {
     @fn_list = split('!',$approver_function{$rs});
     foreach $fn (@fn_list) {
       if ($fn) {
         $fid = $func_name_to_id{$fn};
         push(@new_dept_func_id, "$dept_code!$fid"); # Another array element
         print F1 "$dept_code!$fid!$fn\n";
       }
     }
   }
 } 
 close(F1);

#
#  Read from the table DEPT_APPROVER_FUNCTION to build @old_dept_func_id
#
 @old_dept_func_id = ();
 &get_old_dept_func_id($lda, \@old_dept_func_id);
 $n = @old_dept_func_id;
 print "Number of elements in \@old_dept_func_id = $n\n";
 
#
#  Find elements in @new_dept_func_id that are not in @old_dept_func_id.
#  Delete them from the DEPT_APPROVER_FUNCTION table.
#
  my %mark1 = ();  # A hash that will mark each row found in @new_dept_func_id
  grep($mark1{$_}++, @new_dept_func_id);   # Each item -> mark 
  @old_not_new = grep(!$mark1{$_},@old_dept_func_id); # In old array, not new
  %mark1 = ();  # Clear the hash so we can use it again later.
  $n = @old_not_new;
  print "$n rows to be deleted.\n";
  foreach $line (sort @old_not_new) {
    ($dept_code, $fid) = split('!', $line);
    print "Delete ($dept_code, $fid)\n";
    $gcsr2->bind_param(1, $dept_code);
    $gcsr2->bind_param(2, $fid);
    $gcsr2->execute;
  }
  $gcsr2->finish;

#
#  Find elements in @new_dept_func_id that are not in @old_dept_func_id.
#  Insert them into the DEPT_APPROVER_FUNCTION table.
#
  %mark1 = ();  # A hash that will mark each row found in @old_dept_func_id
  grep($mark1{$_}++, @old_dept_func_id);   # Each item -> mark 
  @new_not_old = grep(!$mark1{$_},@new_dept_func_id); # In new array, not old
  %mark1 = ();  # Clear the hash so we can use it again later.
  $n = @new_not_old;
  print "$n rows to be inserted.\n";
  foreach $line (sort @new_not_old) {
    ($dept_code, $fid) = split('!', $line);
    print "Insert ($dept_code, $fid)\n";
    $gcsr3->bind_param(1, $dept_code);
    $gcsr3->bind_param(2, $fid);
    $gcsr3->execute;
  } 
  $gcsr3->finish;

#
#  Disconnect from Oracle and we're done.
#
 $lda->commit;
 $lda->disconnect;
 exit();

##############################################################################
#
#  Subroutine get_approver_function_list(\%approver_function, $filename)
#
#  Read from a file and generate a hash mapping release strategy -> 
#  a list of approver functions for that RS.
#
##############################################################################
sub get_approver_function_list {
  my ($rapprover_function, $approver_function_file) = @_;
  my ($rec, $temp, $function);
  my $rs, @token, @function_list;

 #
 #  Open function file
 #
  unless (open(AF, $approver_function_file)) {
    die "$0: can't open ($approver_function_file) for input - $!\n";
  }

  while (chomp($rec = <AF>)) { 
    $temp = &strip($rec);
    unless ($temp =~ /^[ ]*#/) {  # Ignore comments
      ($rs, $function) = split('!', $temp);
      $$rapprover_function{$rs} .= "!$function";
    }
  }
  close(AF);
}

##############################################################################
#
#  Function get_old_dept_func_id($lda, \@old_dept_func_id);
#
#  Builds an array from the table DEPT_APPROVER_FUNCTION containing
#  elements of the form $dept_code!$function_id.  Each element contains
#  department code (e.g. D_CHEM) and one of the approver function_id
#  numbers grantable by PAs in the department.
#
##############################################################################
sub get_old_dept_func_id {
  my ($lda, $rold_dept_func_id) = @_;
  my ($dept_code, $func_id);

 #
 # Execute select statement
 #
  $gcsr1->execute;

 #
 # Read each row
 #
  while (($dept_code, $func_id) = $gcsr1->fetchrow_array) {
   push(@$rold_dept_func_id, "$dept_code!$func_id"); # Another array element
  }
 
  $gcsr1->finish;
  return;

}

##############################################################################
#
#  Function get_func_name_to_id($lda, \%func_name_to_id);
#
#  Builds a hash %dept_to_rs where $func_name_to_id{$func_name} is the
#  function_id associated with a given function_name.
#
##############################################################################
sub get_func_name_to_id {
  my ($lda, $rfunc_name_to_id) = @_;
  my ($func_name, $func_id);
  #print "Here I am in get_func_name_to_id.  sg_code='$sg_code'\n";

 #
 # Execute select statement
 #
   $gcsr5->execute;

 #
 # Read each row
 #
  while (($func_name, $func_id) = $gcsr5->fetchrow_array) {
    $$rfunc_name_to_id{$func_name} = $func_id;
  }
 
 $gcsr5->finish;
 return;

}

##############################################################################
#
#  Function dept_release_strategy($lda, \%dept_to_rs);
#
#  Builds a hash %dept_to_rs where $dept_to_rs{$dept} is a 
#  !-delimited list of release strategy numbers for a given department.
#
##############################################################################
sub dept_release_strategy {
  my ($lda, $rdept_to_rs) = @_;
  my ($dept, $rel_strat, $count);
  #print "Here I am in dept_release_strategy.  sg_code='$sg_code'\n";

 #
 # Execute select statement
 #
   $gcsr6->execute;

 #
 # Read each row
 #
  while (($dept, $rel_strat, $count) = $gcsr6->fetchrow_array) {
    #print "$dept has release strategy '$rel_strat' (count=$count)\n";
    if ($rel_strat) {
      if ($$rdept_to_rs{$dept}) {
         $$rdept_to_rs{$dept} .= "!$rel_strat";
      }
      else {
         $$rdept_to_rs{$dept} = $rel_strat;
      }
    }
  }
 
 $gcsr6->finish;
 return;

}

########################################################################
#
#  Strips off trailing <cr> and leading and trailing blanks.
#
###########################################################################
sub strip {
  my($s);  #temporary string
  $s = $_[0];
  while ($s =~ /[\s\n]$/) {   # Remove trailing <cr> or space
    chop($s);
  }
  while (substr($s,0,1) =~ /^\s/) {
    $s = substr($s,1);
  }
 
  $s;
}
