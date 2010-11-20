#!/usr/bin/perl -I/usr/users/rolesdb/lib/cpa
##############################################################################
#
#  Create authorization and profile records for input into 
#  Robie Gould's program (which inserts SAP authorization-related data
#  into appropriate tables in SAP).
#
#  This version handles new ENTER BUDGETS authorizations that use
#  distinct Budget Plan Version numbers.
#
#
#  Authorization file format
# (c.c. 1-12 is the name of an SAP authorization)
# c.c. 1-2      'Z:'
# c.c. 3-12     e.g. 'Pnnnnnn   '                       (PC Prof. Center)
#                    'nnnnn00-99'   or    'nnnnnnn   '  (CC, IO, or WB)
#                    'nnnnnn    '                       (FC Fund Center)
#                    'nnnnnnn   '                       (FN Fund)
#                    'nnnnnnn   '                       (BC Budget Cost Ctr.) 
#                    'Pnnnnnn   '                       (BP Budget Prof. Ctr.)
# c.c. 13-72    description of authorization (Required)
# c.c. 73-82    authorization object short name
# c.c. 83-92    field name (to which values will be assigned)
# c.c. 93-110   "from" value
# c.c. 111-128  "to" value (or 18 spaces)
#
#
#  Profile file format
#   c.c. 1-2      usually 'Z#' (Collect authorizations for a user) 
#                   (Rarely, 'Z!' used to collect all auth. regardless of user)
#                   'Z$' used to collect 'Z!' profiles for transport,
#                   'Z%' used to collect 'Z#' profiles for transport)
#                  
#   c.c. 3-3      'R', 'S', or 'B'  (Reporting, Spending, or Budget planning)
#   c.c. 4-4      ':' or [0-9A-Z]   (Now just : or 0)
#   c.c. 5-12     userid (Kerberos name)
#   
#   c.c. 13-72    profile description
#   c.c. 73-73    profile type: 'C' or 'S'   (composite or simple)
#   c.c. 74-85    authorization name (c.c. 1-12 of authorization above)
#     -or-        profile name
#   c.c. 86-95    authorization object applying to authorization name above
#
#  User-map file intermediate format
#   c.c. 1-8      username
#   c.c. 9-10     blank
#   c.c. 11-22    SAP profile name
#
#  User-map file final format
#   c.c. 1-12     username
#   c.c. 13-288   blank
#   c.c. 289-296  effective date (always 00000000)
#   c.c. 297-304  expiration date (mmddyyyy or 00000000)
#   c.c. 305-316  department no. (nnnnnn followed by 6 blanks)
#   c.c. 317-2116 series of 150 12-byte profile names (blanks when we run
#                 out of names)
#   c.c. 2117-2131  blank
#   c.c. 2132-2161  first name [and middle initial, in future] left justified
#   c.c. 2162-2191  last name (left justified)
#   c.c. 2192-2385  blank
#   c.c. 2386-2401  telephone number (left justified)
#   c.c. 2402-4629  blank
#
#
#  Copyright (C) 1998-2010 Massachusetts Institute of Technology
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
# Modified by Jim Repa, 7/7/1998
# Modified by Jim Repa, 7/28/1998  Change sort order of Profile file
# Modified by Jim Repa, 7/30/1998  Add user1.lock and umap1.delete files
# Modified by Jim Repa, 8/10/1998  Remove some diagnostic chatter
# Modified by Jim Repa, 11/04/1998 Use seqno. instead of date in filenames
# Modified by Jim Repa, 12/31/1998 Fix problem (See 'Note 123198')
# Modified by Jim Repa, 4/13/1999  Add more user data to usermap file
# Modified by Jim Repa, 12/02/1999 Support "global" category LABD auths
# Modified by Jim Repa, 08/05/2003 Add support for HR auths
# Modified by George P, 04/13/2004 Add support for HR-C auths
# Modified by George P, 05/18/2004 Put initial line in profiles file
# Modified by Jim Repa, 07/19/2004 Improve counting of profiles per user
# Modified by Jim Repa, 09/14/2005 Add support for PAYR timesheet auths
# Modified by Jim Repa, 09/21/2005 Add more support for PAYR timesheet auths,
#                                  also add "-u" sort option for user prof recs
# Modified by Jim Repa, 10/19/2005 Fix problem with -u sort option.
#
##############################################################################
#
#  Set some constants
#
#$datadir = $ENV{"ROLES_HOMEDIR"} . "/sap_feed/data/";
#$configdir = $ENV{"ROLES_HOMEDIR"} . "/sap_feed/config/";
$datadir = $ENV{"ROLES_HOMEDIR"} . "/xsap_feed/data/";
$configdir = $ENV{"ROLES_HOMEDIR"} . "/xsap_feed/config/";
$infile1 = $datadir . 'sap1.changes';
$userfile = $datadir . 'user1.out';
$aoutfile = $datadir . 'r2sauth';    # SAP authorizations input to ZAUTHIMP
$pouttemp = $datadir . 'prof1.temp';
$poutfile = $datadir . 'r2sprof';    # SAP profiles input to ZPROFIMP 
$mouttemp = $datadir . 'umap1.temp';
$routtemp = $datadir . 'role1.temp';
#$moutstem = $datadir . 'umap1.temp';  #not needed
$moutfile = $datadir . 'r2sumap';    # SAP user->prof assign. input to ZUSERIMP
$mdeltfile = $datadir . 'umap1.deltemp';
$mdelfile = $datadir . 'r2sdmapl';   # list of profiles to delete from users
$mlockfile = $datadir . 'r2slock';   # list of users to lock in SAP
$difffile = $datadir . 'sap1.diffs';
$auth_map_file = $configdir . 'sap_auth.mapping';
$prof_map_file = $configdir . 'sap_prof.mapping';
$umap_map_file = $configdir . 'sap_func.mapping';
$role_map_file = $configdir . 'sap_role.mapping';
$qtype_map_file = $configdir . 'sap_qualtype.mapping';
#$auth_map_file = $configdir . 'sap_auth.mapping_new_20030724';
#$prof_map_file = $configdir . 'sap_prof.mapping_new_20030724';
#$role_map_file = $configdir . 'sap_role.mapping_new_20030724';
$umap_map_file = $configdir . 'sap_func.mapping';
$delim = '\|';
$db_parm = 'roles';
$spare_profiles = 5; # Max. no. of "fixed" profiles (start count to 150)

#
# Get packages
#
use config('GetValue');  # Use the subroutine GetValue in ~/lib/cpa/config.pm
use sap_feed('GetSequence');  # Use the subroutine GetSequence in sap_feed.pm

#
#  Get new sequence number.
#
$seqno = &GetSequence();

#
#  Append the seqno to the input files.  Make sure they exist.
#
$userfile .= ".$seqno";
unless (-r $userfile) {
  die "Cannot find file $userfile\n";
}
print "Userfile = $userfile\n";
$infile1 .= ".$seqno";
unless (-r $infile1) {
  die "Cannot find file $infile1\n";
}

#
#  Append the seqno to the various output file names
#   for this program.
#
$aoutfile .= ".$seqno";  # Append the seqno to $aoutfile 
$poutfile .= ".$seqno";  # Append the seqno to $poutfile 
$mouttemp .= ".$seqno";  # Append the seqno to $mouttemp 
$moutfile .= ".$seqno";  # Append the seqno to $moutfile 
$mdelfile .= ".$seqno";  # Append the seqno to $mdelfile 
$mdeltfile .= ".$seqno"; # Append the seqno to $mdelfile 
$mlockfile .= ".$seqno"; # Append the seqno to $mdelfile 
$routtemp .= ".$seqno";  # Append the seqno to $routtemp 

#
#  Get username and password for database connection.
#
 $temp = &GetValue($db_parm);
 $temp =~ m/^(.*)\/(.*)\@(.*)$/;
 $user  = $1;
 $pw = $2;
 $db = $3; 
 
#
#  Make sure we are set up to use Oraperl.
#
 use DBI;
 use Oraperl;
 if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}
 
#
#  Open connection to oracle
#
 $lda = &ora_login($db, $user, $pw)
        || die $ora_errstr;

#
#  Get function information from the Roles DB FUNCTION table.
#
$function_category = 'SAP';
$function_category2 = 'LABD';
$function_category3 = 'HR';
$function_category4 = 'ADMN';
$function_category5 = 'HR_C';
$function_category6 = 'EHS';
$function_category7 = 'PAYR';
@function_cat_list 
  = ($function_category, $function_category2, $function_category3, 
     $function_category4, $function_category5, $function_category6,
     $function_category7);
%fid_to_name = (); # Hash for function_id => function_name
%fname_to_id = (); # Hash for function_name => function_id
&get_function_info($lda, \@function_cat_list, 
                   \%fid_to_name, \%fname_to_id);


#
#  Read in the auth mapping file.
#
 unless (open(IN,$auth_map_file)) {
   die "Cannot open $auth_map_file for reading\n"
 }
 print "Reading in mapping file $auth_map_file...\n";
 @a_function_name = ();
 @a_qtyp = ();
 @a_seq = ();
 @a_auth_name = ();
 @a_desc = ();
 @a_obj = ();
 @a_field = ();
 @a_from = ();
 @a_to = ();
 $i = 0;  # Count lines (for error messages)
 while (chop($line = <IN>)) {
   $i++;
   ($function_name, $qtyp, $seq, $auth_name, $desc, $obj, $field,
    $from, $to) = split($delim, $line);
   grep($_ = &strip($_),   # Strip leading & trailing blanks
    $function_name, $qtyp, $seq, $auth_name, $desc, $obj, $field,
    $from, $to);
   if (substr($function_name, 0, 2) eq '--') {} # Skip delimiter lines
   elsif ($function_name eq '') {}  # Skip blank lines
   elsif ($function_name eq '*field_size') {
     $sizea_auth_name = $auth_name;
     $sizea_desc = $desc;
     $sizea_obj = $obj;
     $sizea_field = $field;
     $sizea_from = $from;
     $sizea_to = $to;
   }
   else {
     if (($fname_to_id{$function_name} eq '') 
         && ($function_name ne '*one per run'))
     {
       die "**Error in line $i of $auth_map_file:\n"
            . "**Invalid function name '$function_name'\n";
     }
     push(@a_function_name, $function_name);
     push(@a_qtyp, $qtyp);
     push(@a_seq, $seq);
     push(@a_auth_name, $auth_name);
     push(@a_desc, $desc);
     push(@a_obj, $obj);
     push(@a_field, $field);
     push(@a_from, $from);
     push(@a_to, $to);     
   }
 }
 close(IN);

#
#  Read in the user-map mapping file.
#
 unless (open(IN,$umap_map_file)) {
   die "Cannot open $umap_map_file for reading\n"
 }
 $i = 0;
 print "Reading in mapping file $umap_map_file...\n";
 @m_function_name = ();
 @m_user = ();
 @m_prof_name = ();
 while (chop($line = <IN>)) {
   $i++;  # Increment line counter (for error messages)
   #print "$i. $line\n";
   ($function_name, $username, $prof_name) = split($delim, $line);
   grep($_ = &strip($_),   # Strip leading & trailing blanks
    $function_name, $username, $prof_name);
   if (substr($function_name, 0, 2) eq '--') {} # Skip delimiter lines
   elsif ($function_name eq '*field_size') {
     $sizem_user = $username;
     $sizem_prof_name = $prof_name;
   }
   else {
     if ($fname_to_id{$function_name} eq '') {
       die "**Error in line $i of $umap_map_file:\n"
            . "**Invalid function name '$function_name'\n";
     }
     push(@m_function_name, $function_name);
     push(@m_user, $username);
     push(@m_prof_name, $prof_name);
   }
 }
 close(IN);

#
#  Read in the role mapping file.
#
 unless (open(IN,$role_map_file)) {
   die "Cannot open $role_map_file for reading\n"
 }
 $i = 0;
 print "Reading in mapping file $role_map_file...\n";
 @r_function_name = ();
 @r_user = ();
 @r_role_name = ();
 while (chop($line = <IN>)) {
   $i++;  # Increment line counter (for error messages)
   #print "$i. $line\n";
   ($function_name, $username, $role_name) = split($delim, $line);
   grep($_ = &strip($_),   # Strip leading & trailing blanks
    $function_name, $username, $role_name);
   if (substr($function_name, 0, 2) eq '--') {} # Skip delimiter lines
   elsif ($function_name eq '*field_size') {
     $sizer_user = $username;
     $sizer_role_name = $role_name;
   }
   else {
     if ($fname_to_id{$function_name} eq '') {
       die "**Error in line $i of $role_map_file:\n"
            . "**Invalid function name '$function_name'\n";
     }
     push(@r_function_name, $function_name);
     push(@r_user, $username);
     push(@r_role_name, $role_name);
   }
 }
 close(IN);

#
#  Read in the profile mapping file.
#
 unless (open(IN,$prof_map_file)) {
   die "Cannot open $prof_map_file for reading\n"
 }
 $i = 0;
 print "Reading in mapping file $prof_map_file...\n";
 @p_function_name = ();
 @p_qtyp = ();
 @p_prof_name = ();
 @p_desc = ();
 @p_cs = ();
 @p_field = ();
 @p_from = ();
 @p_to = ();
 %func_id2prof = ();
 while (chop($line = <IN>)) {
   $i++;  # Increment line counter (for error messages)
   #print "$i. $line\n";
   ($function_name, $qtyp, $seq, $prof_name,
    $desc, $cs, $ap_name, $obj) = split($delim, $line);
   grep($_ = &strip($_),   # Strip leading & trailing blanks
    $function_name, $qtyp, $seq, $prof_name,
    $desc, $cs, $ap_name, $obj);
   if (substr($function_name, 0, 2) eq '--') {} # Skip delimiter lines
   elsif ($function_name eq '*field_size') {
     $sizep_prof_name = $prof_name;
     $sizep_desc = $desc;
     $sizep_cs = $cs;
     $sizep_ap_name = $ap_name;
     $sizep_obj = $obj;
   }
   else {
     if ($fname_to_id{$function_name} eq '') {
       die "**Error in line $i of $prof_map_file:\n"
            . "**Invalid function name '$function_name'\n";
     }
     push(@p_function_name, $function_name);
     push(@p_qtyp, $qtyp);
     push(@p_seq, $seq);
     push(@p_prof_name, $prof_name);
     push(@p_desc, $desc);
     push(@p_cs, $cs);
     push(@p_ap_name, $ap_name);
     push(@p_obj, $obj);
     ## Save func_id -> profile template (e.g., 'Z#H:$usr') in a hash
     my $temp_func_id = $fname_to_id{$function_name};
     if ( !($func_id2prof{$temp_func_id}) || !($prof_name =~ /bbbyynnn/) ) {
       $func_id2prof{$temp_func_id} = $prof_name;
     }
     #print "function_name='$function_name' func_id='$temp_func_id' "
     #      . "prof='$func_id2prof{$temp_func_id}'\n";
   }
 }
 close(IN);

#
#  Read in the qualtype mapping file.
#
 unless (open(INQ,$qtype_map_file)) {
   die "Cannot open $qtype_map_file for reading\n"
 }
 $i = 0;
 print "Reading in mapping file $qtype_map_file...\n";
 %sap_qtype2roles_qtype = ();
 %qtype_index_or_not = ();
 my ($sap_qtype, $roles_qtype, $qtype_index);
 while (chop($line = <INQ>)) {
   $i++;  # Increment line counter (for error messages)
   #print "$i. $line\n";
   ($sap_qtype, $roles_qtype, $qtype_index) = split($delim, $line);
   grep($_ = &strip($_),   # Strip leading & trailing blanks
    $sap_qtype, $roles_qtype, $qtype_index);
   if (substr($sap_qtype, 0, 2) eq '--') {} # Skip delimiter lines
   else {
     $sap_qtype2roles_qtype{$sap_qtype} = $roles_qtype;
     $qtype_index_or_not{$roles_qtype} = $qtype_index;
   }
 }
 close(INQ);

#
#  Print out the mapping arrays
#
  #&print_a_map_array(\@a_function_name, \@a_qtyp, \@a_seq,
  #       \@a_auth_name, \@a_desc, \@a_obj, \@a_field, \@a_from, \@a_to);
  #&print_p_map_array(\@p_function_name, \@p_qtyp, \@p_seq,
  #       \@p_prof_name, \@p_desc, \@p_cs, \@p_ap_name, \@p_obj);
  #&print_m_map_array(\@m_function_name, \@m_user, \@m_prof_name);
  #&print_r_map_array(\@r_function_name, \@r_user, \@r_role_name);
  #&print_qt_map_array(\%sap_qtype2roles_qtype, \%qtype_index_or_not);
 
#
# Call &get_qcode_to_qid to build a hash to map each Roles DB
# qualifier_type/qualifier_code pair into a qualifier_id.
#
 %qcode2qid = ();
 &get_qcode_to_qid($lda, \%qtype_index_or_not, \%qcode2qid);

#
#  Read in the input file of authorizations ($infile1) 
#
 unless (open(IN,$infile1)) {
   die "Cannot open $infile1 for reading\n"
 }
 print "Reading in $infile1...\n";
 while (chop($line = <IN>)) {
   if ($line =~ /^\-?[0-9]/) {
     push(@authline, $line);
     ($afid, $aqc, $aqtype, $auser) = split($delim, $line);
     push(@f_qc_qt, $afid . ' ' . $aqc . ' ' . $aqtype);
     push(@f_user, $afid . ' ' . $auser);
   }
 }
 close(IN);

#
#  Remove duplicate qualifier_code/qualifier_type pairs from @f_qc_qt
#
 print 'Removing duplicates from \@f_qc_qt array...', "\n";
 &remove_duplicates(\@f_qc_qt);
 @temp = @f_qc_qt;
 @f_qc_qt = sort(@temp);

#
#  Remove duplicate (function,user) pairs from @f_user
#
 print 'Removing duplicates from \@f_user array...', "\n";
 &remove_duplicates(\@f_user);
 @temp = @f_user;
 @f_user = sort(@temp);
 undef(@temp);

#
#   Open authorization output file.
#
  $outf = ">" . $aoutfile;
  if( !open(F1, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }

##
# 
#  Start generating records for the three output files.
# 
#  1. Use auth mapping file to generate "*one per run" authorization records
#  2. Use auth mapping file and authorizations from Roles DB to
#     build records in authorization file for each distinct function/qualifier
#     pair.
#  3. For each (function,user,qualifier) triplet, build one or more profile
#     records.
#  4. For each (function,user) pair, build one or more profile records
#     (Increment batch number every 150 lines)
#     For each (function,user) pair, generate a usermap record
#
##

#
#  1. Use auth mapping file to generate "*one per run" authorization records
#
 print 'Writing "one per run" authorization records...' . "\n";
 for ($i = 0; $i < @a_function_name; $i++) {
   if ($a_function_name[$i] eq '*one per run') {
     $auth_record = &gen_auth_record('noqc', 
         $sizea_auth_name, $sizea_desc, $sizea_obj, $sizea_field, 
         $sizea_from, $sizea_to,
         $a_function_name[$i], $a_qtyp[$i], $a_seq[$i], $a_auth_name[$i], 
         $a_desc[$i], $a_obj[$i], $a_field[$i], $a_from[$i], $a_to[$i]);
     print F1 $auth_record . "\n";
   }
 }

#
#  2. Use auth mapping file and authorizations from Roles DB to
#     build records in authorization file for each distinct function/qualifier
#     pair.
#
 print 'Writing authorization records for each function/qc...' . "\n";
 foreach $line (@f_qc_qt) {
   ($afid, $aqc, $aqtype) = split(' ', $line);
   #print "qc='$aqc' qtype='$aqtype' user='$auser'\n";
   for ($i = 0; $i < @a_function_name; $i++) {
     # Run through map_auth elements with the right function_name and qtyp.
     #print "$i a_qtyp = '$a_qtyp[$i]'\n";
     if ( ($aqtype eq $a_qtyp[$i])
         && ($fid_to_name{$afid} eq $a_function_name[$i]) ) { 
       $auth_record = &gen_auth_record($aqc, 
           $sizea_auth_name, $sizea_desc, $sizea_obj, $sizea_field, 
           $sizea_from, $sizea_to,
           $a_function_name[$i], $a_qtyp[$i], $a_seq[$i], $a_auth_name[$i], 
           $a_desc[$i], $a_obj[$i], $a_field[$i], $a_from[$i], $a_to[$i]);
       print F1 $auth_record . "\n";
     }
   }
 }

#
#  We're done with authorizations output file.  Close it.
#
 close(F1);

#
#   Open profile output file and user-map output file.
#   Also open a role output file.
#
  $outf = ">" . $pouttemp;
  if( !open(F2, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }
  $outf = ">" . $mouttemp;
  if( !open(F3, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }
  $outf = ">" . $routtemp;
  if( !open(F3A, $outf) ) {
    die "$0: can't open ($outf) - $!\n";
  }

#
#  3a. Change format of lines in @authline and
#      sort @authline by function_id, username, and qcode.
#
 @temp = @authline;
 foreach $line (@temp) {  # fid|qc|qtype|user -> fid|user|qtype|qc
   ($afid, $aqc, $aqtype, $auser) = split($delim, $line);
   $line = "$afid\|$auser\|$aqc\|$aqtype";   
 }
 @authline = sort(@temp);
 undef(@temp);

#
#  3b. For each (function,user,qualifier) triplet, generate one or more
#      records for the profile output file.
#      Also, if there are matching records in user-mapping table for
#      this function, then generate a user-map record also.
#      Finally, if there are matching records in the role-mapping table
#      for this function, then generate a role record also.
#
 print 'Writing profile records for each function/user/qc...' . "\n";
 @temp = @f_user;        # Sort..
 @f_user = sort(@temp);  # ...the array...
 undef(@temp);           # ...@f_user.
 %f_user_count = ();  # Keep profile counts for each function/user pair
 $old_f_user = '';  # Keep track of "previous" function/userid pair
 %user_prof_name = ();  # Keep track of user profile names
 foreach $line (@authline) {
   ($afid, $auser, $aqc, $aqtype) = split($delim, $line);
   $r_qt = $sap_qtype2roles_qtype{$aqtype};
   $aqid = $qcode2qid{"$r_qt:$aqc"};  # Get qualifier_id from global hash
   ## Changed 7/19/2004. %f_user_count will count the number of profiles
   ## per user and profile template (e.g., 'Z#H:$usr'). We'll use this
   ## as input to the function  &incr_char() which returns a different
   ## character every 150 elements.
    $new_f_user = $func_id2prof{$afid} . ' ' . $auser;
    unless ($f_user_count{$new_f_user}) {
      $f_user_count{$new_f_user} = $spare_profiles; # Initialize counter to 150
    }
    $afname = $fid_to_name{$afid};
   ##
   #--- Loop through profile_map elements
   for ($i = 0; $i < @p_function_name; $i++) {
     # Run through map_prof elements with the right function_name and qtyp.
     #print "$i a_qtyp = '$a_qtyp[$i]'\n";
     if ( ($aqtype eq $p_qtyp[$i])
         && ($afname eq $p_function_name[$i]) ) { 
       $f_user_count{$new_f_user}++;  # Increment the function/user counter
       $prof_name = $p_prof_name[$i];  # Get the profile name
       $diagnostic_string
         = "3b. new_f_user='$new_f_user' prof_name='$prof_name'";
       substr($prof_name,3,1) = &incr_char($f_user_count{$new_f_user}); #:01...
       # Within &gen_prof_record, we will do the following:
       # $user_prof_name{$prof_name} = $auser;   
       # This will map the profile name to its user.
       $prof_record = &gen_prof_record($auser, $aqc, 'nobatch',
         $sizep_prof_name, $sizep_desc, $sizep_cs, $sizep_ap_name,
         $sizep_obj,
         $prof_name, $p_desc[$i], $p_cs[$i], $p_ap_name[$i], 
         $p_obj[$i], $aqtype);
       print F2 $prof_record . "\n";
     }
   }
   #--- Loop through user_map elements
   for ($i = 0; $i < @m_function_name; $i++) { 
     #print "0 In for loop.  user=$auser m_function=$m_function_name[$i]"
     #      . " a_function=$fid_to_name{$afid}\n";
     if ( ($afname eq $m_function_name[$i])
        && (($m_prof_name[$i] =~ /\$qc/) || ($m_prof_name[$i] =~ /\$qid/)) ) { 
       # Generate and print a record for the user-map output file.
       #print "1 i=$i auser='$auser' afid='$afid'\n";
       $temp_prof_name = $m_prof_name[$i];
       $temp_prof_name =~ s/\$qc/$aqc/;
       $temp_prof_name =~ s/\$qid/$aqid/;
       $umap_record = &gen_umap_record($auser,
         $sizem_user, $sizem_prof_name, 
         $temp_prof_name);
       print F3 $umap_record . "\n";
     }
   }
   #--- Loop through role elements
   for ($i = 0; $i < @r_function_name; $i++) { 
     #print "0 In for loop.  user=$auser r_function=$r_function_name[$i]"
     #      . " a_function=$fid_to_name{$afid}\n";
     if ( $afname eq $r_function_name[$i] ) {
       # Generate and print a record for the role output file.
       #print "1 i=$i auser='$auser' afid='$afid'\n";
       $temp_role_name = $r_role_name[$i];
       #$temp_role_name =~ s/\$qc/$aqc/; # Not needed
       $role_record = &gen_umap_record($auser,
         $sizer_user, $sizer_role_name, 
         $temp_role_name);
       print F3A $role_record . "\n";
     }
   }
   $old_f_user = $new_f_user;
 }

#
#  Set a "batch" number to the sequence number with '00' appended.
#  The '00' will get incremented to '01' immediately.
#
 $batch = $seqno . '00';
 print "Batch number = $seqno" . "01\n";

#
#  4. For each (function,user) pair, build one or more records for the
#     profile output file.
#     Also, for each (function,user) pair, generate an output line for the
#     usermap output file.
#
 print 'Writing profile and usermap records for each function/user...' 
       . "\n";
 $batch_counter = 0;
 for ($j = 0; $j < @f_user; $j++) {   # Loop through function/user pairs
   ($afid, $auser) = split(' ', $f_user[$j]);
   #
   #  Look through profile mapping arrays and print profile records
   #
   for ($i = 0; $i < @p_function_name; $i++) {
      #print "4. function_name='$p_function_name[$i]'\n"; 
     # Look for sap_prof.mapping records where qtyp = '*', meaning
     # one record per (function,user) pair.
     if ( ($p_qtyp[$i] eq '*')
         && ($fid_to_name{$afid} eq $p_function_name[$i]) ) { 
        #print "2 i=$i auser=$auser aqc=$aqc batch=$batch\n";
       #  If we are going to use the batch number, then increment batch
       #  counter and possibly increment the batch number.
       $ap_name = $p_ap_name[$i];
       if ($p_prof_name[$i] =~ /\$bbbyynnnii/) {
         # Incr. the batch no. every 150 users.
         if (($batch_counter++)%150 == 0) {  
           $batch++; 
         }
         # Note 123198: Change $k < $f_user_count{$f_user[$j]} to
         #                     $k <= $f_user_count{$f_user[$j]}
         # so that we count profiles correctly and don't 
         # miss Z#S0 or Z#R0 profiles
         # Note 07/19/2004 - now we need to convert $f_user[$j]
         #  to profile-template for the function in order to get the count.
         my ($temp_fid, $temp_user) = split(' ', $f_user[$j]);
         my $temp_f_user = $func_id2prof{$temp_fid} . ' ' . $temp_user;
         for ($k=0; $k <= $f_user_count{$temp_f_user}; $k += 150 ) {
           $diagnostic_string = "4. user=$f_user[$j] count=$k";
           substr($ap_name,3,1) = &incr_char($k);  # :01234...
           #print "f_user=$f_user[$j] f_user_count=$f_user_count{$f_user[$j]}"
           #   . " k=$k ap_name=$ap_name\n";
           $prof_record = &gen_prof_record($auser, $aqc, $batch,
             $sizep_prof_name, $sizep_desc, $sizep_cs, $sizep_ap_name,
             $sizep_obj,
             $p_prof_name[$i], $p_desc[$i], $p_cs[$i], $ap_name, 
             $p_obj[$i], $aqtype);
           print F2 $prof_record . "\n";
         }
       }
       else {
         $prof_record = &gen_prof_record($auser, $aqc, $batch,
           $sizep_prof_name, $sizep_desc, $sizep_cs, $sizep_ap_name,
           $sizep_obj,
           $p_prof_name[$i], $p_desc[$i], $p_cs[$i], $p_ap_name[$i], 
           $p_obj[$i], $aqtype);
         print F2 $prof_record . "\n";
       }
     }
   }
   #
   #  Look through umap mapping arrays and print user-map records.
   #  Ignore umap elements where the profile_name contains a variable to
   #  be replaced with qualifier_code.  We'll handle profile_names
   #  corresponding to non-NULL qualifiers in a different part of the
   #  program.
   #
   for ($i = 0; $i < @m_function_name; $i++) { 
     #print "1 In for loop.  user=$auser m_function=$m_function_name[$i]"
     #      . " a_function=$fid_to_name{$afid}\n";
     if ( ($fid_to_name{$afid} eq $m_function_name[$i])
         && (!($m_prof_name[$i] =~ /\$qc/)) 
         && (!($m_prof_name[$i] =~ /\$qid/)) ) { 
        #if ($fid_to_name{$afid} eq $m_function_name[$i]) { 
       # Generate and print a record for the user-map output file.
        #print "3 i=$i auser='$auser' afid='$afid'"
        #      . " function='$m_function_name[$i]'"
        #      . " prof='$m_prof_name[$i]'\n"; 
        $umap_record = &gen_umap_record($auser,
         $sizem_user, $sizem_prof_name, 
         $m_prof_name[$i]);
       print F3 $umap_record . "\n";
     }
   }
 }

#
#  For each user profile name (e.g., Z#R:$usr, Z#S:$user, Z#S0$user, etc.)
#  write another record to the user map file.
#
 foreach $uprof_name (sort keys %user_prof_name) {
   $auser = $user_prof_name{$uprof_name};
   $umap_record = &gen_umap_record($auser,
    $sizem_user, $sizem_prof_name, 
    $uprof_name);
   print F3 $umap_record . "\n";
   #print "Profile name = '$uprof_name' User='$auser'\n";
 }

#
#  Close temporary files
#
 close(F2);  # Close temporary profile out file
 close(F3);  # Close user-map temporary file
 close(F3A);  # Close role temporary file

#
#  Put an initial line in the profile file (changed 5/18/2004)
#
 if( !open(FP4, ">$poutfile") ) {
   die "$0: can't open ($poutfile) - $!\n";
 }
 print FP4 " *Profiles*\n";
 close(FP4);  # Close profile file

#
#  Sort the profile out file:
#  -- Sort all records other than "transport" records by profile_name
#     (Identify transport records by finding batch number in c.c. 2-9)
#  -- Put "transport" records at the end of the file.
#
 print "Sorting file $poutfile\n";
 my $batch8 = substr($batch,0,8);  #First 8 chars of batch number
 system("egrep -v '^..$batch8' $pouttemp |"  # All non-transport records
        . " sort -u -k1.5,1.22 -k1.4,1.4 -k1.76,1.85 -k1 > $poutfile\n");# Sort
 system("egrep '^..$batch8' $pouttemp|"      # Find transport records
        . " sort >> $poutfile\n"); #Sort & append
 system("rm $pouttemp\n");

#
#  Sort the user-map out file.  Read it into an array.
#
 print "Sorting and reformating file $mouttemp...\n";
 open(SRT, "sort $mouttemp |");
 while (chomp($line = <SRT>)) {
   push(@umap, $line);
 }
 close SRT;

#
#  Sort the role out file.  Read it into an array.
#
 print "Sorting and removing duplicates from file $routtemp...\n";
 open(SRT2, "sort -u $routtemp |");
 while (chomp($line = <SRT2>)) {
   push(@urole, $line);
 }
 close SRT2;

#
#  Open the output files for the (F3) final usermap file,
#  (F4) deleted profiles file, and (F4) locked users file.
#
 if( !open(F3, ">$moutfile") ) {
   die "$0: can't open ($moutfile) - $!\n";
 }
 if( !open(F4, ">$mlockfile") ) {
   die "$0: can't open ($mlockfile) - $!\n";
 }
 print F4 "*Lock users*\n";

#
#  Get a list of users from the $userfile
#
 unless (open(IN,$userfile)) {
   die "Cannot open $userfile for reading\n"
 }
 print "Reading in $userfile...\n";
 chomp(@user = <IN>);
 print "Number of users = " .  (@user + 0) . "\n";

#
#  Build a hash where the keys are the users.  Call a subroutine to
#  get first_name:last_name:dept_no:can_use_sap_expdt for each user.
#
 %user_data = ();
 foreach $username (@user) {
   $user_data{$username} = ':::';
 }
 &get_user_data($lda, \%user_data);
 &ora_logoff($lda) || die "can't log off Oracle";

#
#  Find each distinct username in the usermap file.  For each user, build an
#  output record containing all of the profiles. (This is rather slow.)
#
 print "Writing umap1.out file...\n";
 for ($i = 0; $i < @user; $i++) {  # Write a record for each user
   ##
   @prof = grep(/^$user[$i] /, @umap);  # Find only elements for this user
   grep(s/^[^ ]+[ ]+//, @prof);    # Strip off all but profile name
   $n = @prof;
   $nprof = $n;
   #print "There are $n profiles for $user[$i]\n";
   $profile_list = '';     # Start a list of profiles for this user
   for ($j = 0; $j < @prof; $j++) {
     $profile_list .= substr($prof[$j], 0, 12);  # Add prof to list
   }
   ##
   @role = grep(/^$user[$i] /, @urole);  # Find only elements for this user
   grep(s/^[^ ]+[ ]+//, @role);    # Strip off all but profile name
   $nrole = @role;
   #print "There are $nrole SAP roles for $user[$i]\n";
   $role_list = '';     # Start a list of roles for this user
   for ($j = 0; $j < @role; $j++) {
     my $temp_role = $role[$j] . '                              ';
     $role_list .= substr($temp_role, 0, 30);  # Add role to list
   }
   ##
   ($ufirst_name, $ulast_name, $udept, $uexpdt) 
     = split(':', $user_data{$user[$i]});
   #### Add an additional 4154 bytes to end of record for SAP R/3 v. 4.5
   printf F3 "%-12s%-276s%-8s%-8s%-12s%-1800s%-15s%-30s%-30s%-4154s%-1500s\n",
             $user[$i], ' ', '00000000', $uexpdt, $udept,
             $profile_list,
             ' ', $ufirst_name, $ulast_name, ' ', $role_list;
   $n = $nprof + $nrole;
   if ($n == 0) {  # Write to "locked user" file
     printf F4 "%-12s\n",
               $user[$i];
   }
 }
 close(F3);
 close(F4);

#
#  Open the output file for the final deleted usermap profiles file.
#
 if( !open(F3, ">$mdeltfile") ) {
   die "$0: can't open ($mdeltfile) - $!\n";
 }

#######
# The remainder of the main routine processes the sap1.diffs file
# to generate a file of deleted profiles.
#######
#
#  Read through the sap1.diffs file looking for < lines.
#
 unless (open(IN,$difffile)) {
   die "Cannot open $diff for reading\n"
 }
 %deluser = ();  # Initialize a hash of users with deleted profiles
 @del_f_user = (); # Init. an array of function/user pairs
 @del_f_qc_user = (); # Init. an array of function/qc/user triplets
 while (chomp($line = <IN>)) {
   if ($line =~ /^\<.*\|NA\|/) {  # Look for null-qual profiles
     $line = substr($line, 2);  # Strip off '< '
     ($afid, $aqc, $aqtype, $auser) = split($delim, $line);
     push(@del_f_user, "$afid $auser");
     $deluser{$auser} = 1;  # Mark this user
     #print "NULL-qual line=$line afid=$afid auser=$auser\n";
   }
   elsif ($line =~ /^\<.*\|BU\|/) {  # Look for Budget profiles
     $line = substr($line, 2);  # Strip off '< '
     ($afid, $aqc, $aqtype, $auser) = split($delim, $line);
     push(@del_f_qc_user, "$afid $aqc $aqtype $auser");
     $deluser{$auser} = 1;  # Mark this user
     #print "Budg line=$line afid=$afid auser=$auser aqc=$aqc type=$aqtype\n";
   }
 }
 close(IN);
 #print @del_f_user;
 #print @m_function_name;

#
#  Read through @del_f_user and print out a line for each deleted profile  
#
 for ($j = 0; $j < @del_f_user; $j++) {   # Loop through function/user pairs
   ($afid, $auser) = split(' ', $del_f_user[$j]);
   #print "afid=$afid auser=$auser\n";
   #
   #  Look through umap mapping arrays and print user-map records.
   #  Ignore umap elements where the profile_name contains a variable to
   #  be replaced with qualifier_code.  We'll handle profile_names
   #  corresponding to non-NULL qualifiers in a different part of the
   #  program.
   #
   for ($i = 0; $i < @m_function_name; $i++) { 
     if ( ($fid_to_name{$afid} eq $m_function_name[$i])
         && (!($m_prof_name[$i] =~ /\$qc/)) 
         && (!($m_prof_name[$i] =~ /\$qid/)) ) { 
        #if ($fid_to_name{$afid} eq $m_function_name[$i]) { 
       # Generate and print a record for the user-map output file.
        $umap_record = &gen_umap_record($auser,
         $sizem_user, $sizem_prof_name, 
         $m_prof_name[$i]);
       print F3 $umap_record . "\n";
     }
   }
 }

#
#  Read through @del_f_qc_user and print out a line for each deleted Budget
#  profile (or other profiles handled in the same way)
#
 foreach $line (@del_f_qc_user) {
   ($afid, $aqc, $aqtype, $auser) = split(' ', $line);
   $r_qt = $sap_qtype2roles_qtype{$aqtype};
   $aqid = $qcode2qid{"$r_qt:$aqc"};  # Get qualifier_id from global hash
   #if ($aqtype eq 'DL') {
   #  print "qc='$aqc' qtype='$aqtype' '$r_qt' aqid='$aqid' user='$auser'\n";
   #}
   $afname = $fid_to_name{$afid};
   #print "qc='$aqc' qtype='$aqtype' user='$auser'\n";
   #--- Loop through user_map elements
   for ($i = 0; $i < @m_function_name; $i++) { 
     #print "0 In for loop.  user=$auser m_function=$m_function_name[$i]"
     #      . " a_function=$fid_to_name{$afid}\n";
     if ( ($afname eq $m_function_name[$i])
       && ( ($m_prof_name[$i] =~ /\$qc/) || ($m_prof_name[$i] =~ /\$qid/) ) ) {
       # Generate and print a record for the user-map output file.
       #print "1 i=$i auser='$auser' afid='$afid'\n";
       $temp_prof_name = $m_prof_name[$i];
       $temp_prof_name =~ s/\$qc/$aqc/;
       $temp_prof_name =~ s/\$qid/$aqid/;
       $umap_record = &gen_umap_record($auser,
         $sizem_user, $sizem_prof_name, 
         $temp_prof_name);
       print F3 $umap_record . "\n";
     }
   }
 }

#
#  Open the output file for the (F3) final usermap file
#
 close(F3); # Close the temporary file of deleted profiles.
 if( !open(F3, ">$mdelfile") ) {
   die "$0: can't open ($mdelfile) - $!\n";
 }
 printf F3 "%-12s%-304s%-1800s\n",
           '**********', 'Delete the following profiles', ' ';

#
#  For each distinct user with deleted profiles, build an
#  output record containing all of the profiles.
#
 open(SRT, "sort $mdeltfile |");
 while (chomp($line = <SRT>)) {
   push(@delprof, $line);
 }
 print "Writing umap1.delete file...\n";
 foreach $usr (sort keys %deluser) {
   @prof = grep(/^$usr /, @delprof);  # Find only elements for this user
   grep(s/^[^ ]+[ ]+//, @prof);    # Strip off all but profile name
   $n = @prof;
   # It is possible that the deleted profiles do not map into any 
   # SAP profiles (e.g., Level 0 approvals, or Invoice approvals).
   # So, it is possible at this point to have a user flagged as having
   # deleted profiles, but no actual deleted profiles.  In this case,
   # do not print out anything.
   if ($n > 0) {
     print "There are $n profiles to be removed for $usr\n";
     $profile_list = '';     # Start a list of profiles for this user
     for ($j = 0; $j < @prof; $j++) {
       $profile_list .= substr($prof[$j], 0, 12);  # Add prof to list
     }
     printf F3 "%-12s%-304s%-1800s\n",
               $usr, ' ', $profile_list;
   }
 }
 close(F3);

 exit();


###########################################################################
#
#  Function &strip(string)
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

###########################################################################
#
#  Function &setsize(string, size)
#  Expands or contracts the string to the given number of bytes
#
###########################################################################
sub setsize {
  my ($s, $size);  
  $s = $_[0];
  $size = $_[1];
  substr($s . (' ' x $size), 0, $size); 
}

###########################################################################
#
#  Subroutine &print_a_map_array(\@a_function_name, \@a_qtyp, \@a_seq,
#                   \@a_auth_name, \@a_desc, \@a_obj, \@a_field, \@a_from, 
#                   \@a_to);
#
#  Prints items from the authorization map arrays.
#
###########################################################################
sub print_a_map_array {
 ($ra_function_name, $ra_qtyp, $ra_seq, $ra_auth_name, $ra_desc, 
  $ra_obj, $ra_field, $ra_from, $ra_to) = @_;
 print "List of auth map array elements:\n";
  for ($i = 0; $i < @$ra_function_name; $i++) {
    print "$i Function_name='"  . $$ra_function_name[$i] . "'\n"
         . " qtyp='"           . $$ra_qtyp[$i] . "'"
         . " seq='"            . $$ra_seq[$i] . "'"
         . " auth_name='"      . $$ra_auth_name[$i] . "'"
         . " desc='"           . $$ra_desc[$i] . "'"
         . " obj='"            . $$ra_obj[$i] . "'\n"
         . " field='"          . $$ra_field[$i] . "'"
         . " from='"           . $$ra_from[$i] . "'"
         . " to='"             . $$ra_to[$i] . "'\n";
  }
}

###########################################################################
#
#  Subroutine &print_p_map_array(\@p_function_name, \@p_qtyp, \@p_seq,
#                   \@p_prof_name, \@p_desc, \@p_cs, \@p_ap_name, \@p_obj) 
#
#  Prints items from the profile map arrays.
#
###########################################################################
sub print_p_map_array {
 my ($ra_function_name, $ra_qtyp, $ra_seq, $ra_prof_name, $ra_desc, 
  $ra_cs, $ra_ap_name, $ra_obj);
 ($ra_function_name, $ra_qtyp, $ra_seq, $ra_prof_name, $ra_desc, 
  $ra_cs, $ra_ap_name, $ra_obj) = @_;
 print "List of profile map array elements:\n";
  for ($i = 0; $i < @$ra_function_name; $i++) {
    print "$i Function_name='" . $$ra_function_name[$i] . "'\n"
         . " qtyp='"           . $$ra_qtyp[$i] . "'"
         . " seq='"            . $$ra_seq[$i] . "'"
         . " prof_name='"      . $$ra_prof_name[$i] . "'"
         . " desc='"           . $$ra_desc[$i] . "'"
         . " cs='"             . $$ra_cs[$i] . "'\n"
         . " ap_name='"        . $$ra_ap_name[$i] . "'"
         . " obj='"            . $$ra_obj[$i] . "'\n";
  }
}

###########################################################################
#
#  Subroutine &print_m_map_array(\@m_function_name, \@m_user, 
#                   \@m_prof_name) 
#
#  Prints items from the user-map map arrays.
#
###########################################################################
sub print_m_map_array {
 my ($ra_function_name, $ra_user, $ra_prof_name);
 print "List of user-map array elements:\n";
 ($ra_function_name, $ra_user, $ra_prof_name) = @_;
  for ($i = 0; $i < @$ra_function_name; $i++) {
    print "$i Function_name='" . $$ra_function_name[$i] . "'\n"
         . " user='"           . $$ra_user[$i] . "'"
         . " prof_name='"      . $$ra_prof_name[$i] . "'\n";
  }
}

###########################################################################
#
#  Subroutine &print_r_map_array(\@r_function_name, \@r_user, 
#                   \@r_prof_name) 
#
#  Prints items from the user-map map arrays.
#
###########################################################################
sub print_r_map_array {
 my ($ra_function_name, $ra_user, $ra_role_name);
 print "List of role-map array elements:\n";
 ($ra_function_name, $ra_user, $ra_role_name) = @_;
  for ($i = 0; $i < @$ra_function_name; $i++) {
    print "$i Function_name='" . $$ra_function_name[$i] . "'\n"
         . " user='"           . $$ra_user[$i] . "'"
         . " role_name='"      . $$ra_role_name[$i] . "'\n";
  }
}

###########################################################################
#
#  Subroutine &print_qt_map_array(\%sap_qtype2roles_qtype,
#                                 \%qtype_index_or_not) 
#
#  Prints items from hashes %sap_qtype2roles_qtype and 
#                           $qtype_index_or_not.
#
###########################################################################
sub print_qt_map_array {
 my ($rsap_qtype2roles_qtype, $rqtype_index_or_not) = @_;
 print "List of qualifier types:\n";
 my $key;
 foreach $key (keys %$rsap_qtype2roles_qtype) {
   print "SAP qtype = '$key' -> Roles qtype = '" 
      . $$rsap_qtype2roles_qtype{$key}
      . "'\n";
 }
 print "Build a qualifier_code -> qualifier_id hash for"
     . " for these qualifier_types:\n";
 foreach $key (keys %$rqtype_index_or_not) {
     if ($$rqtype_index_or_not{$key} eq 'Y') {
	 print "Qualifier type: $key\n";
     }
 }
}

###########################################################################
#
#  Function &gen_auth_record($qualcode_num, 
#         $sizea_auth_name, $sizea_desc, $sizea_obj, $sizea_field, 
#         $sizea_from, $sizea_to,
#         $function_name, $qtyp, $seq, $auth_name, 
#         $desc, $obj, $field, $from, $to)
#
#  Generates an authorization record from a qualifier_code plus fields
#  from the auth mapping file.
#
###########################################################################
sub gen_auth_record {
 my($aqc, 
      $sizea_auth_name, $sizea_desc, $sizea_obj, $sizea_field, 
      $sizea_from, $sizea_to,
      $function_name, $qtyp, $seq, $auth_name, 
      $desc, $obj, $field, $from, $to) = @_;
 my $aq99 = $aqc;
 if ($aq99 =~ /00$/) {  # Set $aq99 to $aqc with last 2 bytes ch. to '99'.
   substr($aq99,-2,2) = '99';
 } 
 my $r_qt = $sap_qtype2roles_qtype{$qtyp};
 my $aqid = $qcode2qid{"$r_qt:$aqc"};  # Get qualifier_id from global hash
 #if ($qtyp eq 'DL' || $qtyp eq 'OU') {
 #  print "Qualcode = '$r_qt:$aqc' qualid = '$aqid'\n";
 #}
 $auth_name =~ s/\$qc/$aqc/;
 $auth_name =~ s/\$qid/$aqid/;
 $auth_name = &setsize($auth_name, $sizea_auth_name);
 $desc = &setsize($desc, $sizea_desc);
 $obj = &setsize($obj, $sizea_obj);
 $field = &setsize($field, $sizea_field);
 $from =~ s/\$qc/$aqc/;
 $from =~ s/\$qid/$aqid/;
 $from = &setsize($from, $sizea_from);
 $to =~ s/\$q99/$aq99/;
 $to = &setsize($to, $sizea_to);
 # Result:
 $auth_name . $desc . $obj . $field . $from . $to;
}


###########################################################################
#
#  Function &gen_prof_record($auser, $aqc, $batch,
#         $sizep_prof_name, $sizep_desc, $sizep_cs, $sizep_ap_name,
#         $sizep_obj,
#         $prof_name, $desc, $cs, $ap_name, $obj, $aqtype)
#
#  Generates a profile record from (user, qualifier_code, batch_num)
#  plus fields from the profile mapping file.
#
###########################################################################
sub gen_prof_record {
 my ($auser, $aqc, $batch,
      $sizep_prof_name, $sizep_desc, $sizep_cs, $sizep_ap_name,
      $sizep_obj,
      $prof_name, $desc, $cs, $ap_name, $obj, $qtyp) = @_;
 if ($prof_name =~ /\$usr/) {
   $prof_name =~ s/\$usr/$auser/;
   $user_prof_name{$prof_name} = $auser; 
 }
 $prof_name =~ s/\$bbbyynnnii/$batch/;
 $prof_name = &setsize($prof_name, $sizep_prof_name);
 $desc = &setsize($desc, $sizep_desc);
 $cs = &setsize($cs, $sizep_cs);

 my $r_qt = $sap_qtype2roles_qtype{$qtyp};
 my $aqid = $qcode2qid{"$r_qt:$aqc"};  # Get qualifier_id from global hash
 #if ($qtyp eq 'DL' || $qtyp eq 'OU') {
 #   print "Qualcode = '$r_qt:$aqc' qualid = '$aqid'\n";
 #}

 $ap_name =~ s/\$qc/$aqc/;
 $ap_name =~ s/\$qid/$aqid/;
 $ap_name =~ s/\$usr/$auser/;
 $ap_name = &setsize($ap_name, $sizep_ap_name);
 $obj = &setsize($obj, $sizep_obj);

 # Result:
 $prof_name . $desc . $cs . $ap_name . $obj;
}

###########################################################################
#
#  Function &gen_umap_record($auser, 
#         $sizem_user, $sizem_prof_name, 
#         $prof_name)
#
#  Generates a profile record from user
#  plus fields from the user-map mapping file.
#
###########################################################################
sub gen_umap_record {
 my ($auser,
      $sizem_user, $sizem_prof_name, 
      $prof_name) = @_;
 #print "In gen_umap_record. user='$auser' prof_name='$prof_name'\n"; 
 my $username = &setsize($auser, $sizem_user);
 $prof_name = &setsize($prof_name, $sizem_prof_name);
 # Result:
 $username . $prof_name;
}

##############################################################################
#
#  Subroutine 
#    &get_function_info($function_category, \@function_cat_list, 
#                       \%fid_to_name, \%fname_to_id)
#
#  Reads function_id and function_name info from the Roles DB FUNCTION
#  table.
#  Create some pseudo-functions also by taking the inverse (minus) of
#   each function_id and appending '*ALL' to the function name.  These
#   are used in conjunction with the sap_func.mapping table to generate
#   special lines in the umap.out file for people authorized to spend/commit
#   on any fund center or to report on any profit center.
#
##############################################################################
sub get_function_info {

 #my ($lda, $function_category, $rfid_to_name, $rfname_to_id) = @_; #Get parms.
 my ($lda, $rfunction_cat_list,
     $rfid_to_name, $rfname_to_id) = @_; # Get parms.
 my ($db, $user, $pw, $userpw);

 #
 #  Create a fragment of an SQL statement in the form
 #  "('$cat1', '$cat2', '$cat3', ...)"
 #
  my $tempcat;
  my $sql_frag = "(";
  my $first_time = 1;
  foreach $tempcat (@$rfunction_cat_list) {
    if ($first_time) {
      $first_time = 0;
    }
    else {
      $sql_frag .= ", ";
    }
    $sql_frag .= "'$tempcat'";
  }
  $sql_frag .= ")";

 #
 #  Open a cursor to read in Function information from the Function
 #  table in the Roles DB.
 #
  @stmt = ("select f.function_id, f.function_name"
           . " from function f"
           . " where f.function_category"
           . " in $sql_frag");
  $csr = &ora_open($lda, "@stmt")
         || die $ora_errstr;
  %fid_to_name = ();  # Hash for function_id => function_name
  %fname_to_id = ();  # Hash for function_name => function_id
  print "Reading in Functions (category = '$function_category') from"
        . " Oracle table...\n";
  while (($fid, $fname) = &ora_fetch($csr))
  {
    $fid_to_name{$fid} = $fname;
    $fname_to_id{$fname} = $fid;
    $fid_to_name{-$fid} = $fname . '*ALL';  # Pseudo-function
    $fname_to_id{$fname . '*ALL'} = -$fid;  # Pseudo-function
    $fid_to_name{$fid+500000} = $fname . '*ALT';  # Pseudo-function
    $fname_to_id{$fname . '*ALT'} = $fid + 500000;  # Pseudo-function
  }
  &ora_close($csr) || die "can't close cursor";

}

##############################################################################
#
#  Subroutine 
#    &get_user_data($lda, \%user_data)
#
#  Reads data from person and authorization tables to get
#     first_name:last_name:dept_no:can_use_sap_expdt for each user
#  and put this string into $user_data{$username}.
#
##############################################################################
sub get_user_data {

 my ($lda, $ruser_data) = @_; # Get parms.
 my ($csr1, $username);
 my ($first_name, $last_name, $dept_no, $can_use_sap_expdt);

 #
 #  Define and prepare a select statement to get user information
 #
  my $stmt1 = "select p.first_name, p.last_name, nvl(p.dept_code, '      '),"
       . " nvl(to_char(a.expiration_date, 'MMDDYYYY'), '00000000')"
       . " from person p, authorization a"
       . " where p.kerberos_name = ?"
       . " and a.kerberos_name(+) = p.kerberos_name"
       . " and a.function_name(+) = 'CAN USE SAP'";
  #print "stmt1 = '$stmt1'\n";
  unless ($csr1 = $lda->prepare($stmt1)) 
  {
     die "Error preparing select statement in get_user_data.\n";
  }

 #
 #  For each user in the keys of %user_data, call the select statement.
 #  Put the fields together and set up an entry in the %user_data hash.
 #
  foreach $username (keys %$ruser_data) {
    $csr1->bind_param(1, $username);
    $csr1->execute;
    ($first_name, $last_name, $dept_no, $can_use_sap_expdt) = ('','','','');
    ($first_name, $last_name, $dept_no, $can_use_sap_expdt) 
       = $csr1->fetchrow_array;
    $$ruser_data{$username} 
       = "$first_name:$last_name:$dept_no:$can_use_sap_expdt";
    #print "$username -> $$ruser_data{$username}\n";
  }

  $csr1->finish;

}

##############################################################################
#
#  Subroutine remove_duplicates(\@array)
#
#  Removes the duplicates from an array.
#
##############################################################################
sub remove_duplicates {
 my $rarray = $_[0];
 my ($i, $n);

 my @new_array = ();
 my %counta = ();
 for ($i = 0; $i < @$rarray; $i++) {
   $n = ++$counta{$$rarray[$i]};   # Count the number of occurences of each
   if ($n < 2) {
     push(@new_array, $$rarray[$i]);
   }
 }
 @$rarray = @new_array;
}

##############################################################################
#
#  Function incr_char($counter)
#
#  Returns ':' for 0-149, '0' for 150-299, '1' for 300-349, etc.
#
##############################################################################
sub incr_char {
 my $counter = $_[0];
 my $char_list = ':0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ!#$%&()*+,-./;<=>?@[\]^_`{|}~';
 my $max_counter = length($char_list) * 150;
 my $out_char = '';
 if ($counter < $max_counter) {
   $out_char = substr($char_list, int($counter/150), 1);
 }
 else {
   die "More than $max_counter profiles for a single user & function\n"
       . "Diagnostic string: $diagnostic_string \n";
 }
 $out_char;
}

###########################################################################
#
#  Subroutine &get_qcode_to_qid($lda, \%qtype_index_or_not,
#                               \%qcode2qid)
#
#  Opens a cursor to a select statement from the Roles DB.
#  Finds all roles qualifier_type codes in %qtype_index_or_not for
#    which the value is 'Y' (indicating that we want to include these
#    qualifier types in the mapping of qualifier_code to qualifier_id).
#  Builds the hash %qcode2qid, setting
#    $qcode2qid{"$qtype:$qcode"} = $qid
#   for each qualifier_type/qualifier_code pair within those qualifier_types
#   for which %qtype_index_or_not{$qtype} is 'Y'.
#
###########################################################################
sub get_qcode_to_qid {
  my ($lda, $rqtype_index_or_not, $rqcode2qid) = @_;

 #
 #  Get username and password for database connection.
 #
  $temp = &GetValue($db_parm);
  $temp =~ m/^(.*)\/(.*)\@(.*)$/;
  $user  = $1;
  $pw = $2;
  $db = $3; 

 #
 #  Build a list of qualifier_types that we want to include
 #
  my $qt;
  my $qtype_list = '';
  my $sql_fragment = '(';
  foreach $qt (keys %$rqtype_index_or_not) {
    if ($$rqtype_index_or_not{$qt} eq 'Y') {
      if ($qtype_list) {
        $qtype_list .= ", '$qt'";
      }
      else {
        $qtype_list = "'$qt'";
      }
    }
  }
  $sql_fragment = '(' . $qtype_list . ')';
  #print "sql_fragment = $sql_fragment\n";

 #
 #  Build a SELECT statement to read in all qualifiers within the 
 #  given qualifier types.
 #
  my $stmt = "select qualifier_type, qualifier_code, qualifier_id
              from qualifier
              where qualifier_type in $sql_fragment
              order by 1, 2";
  my $csr = &ora_open($lda, $stmt)
        || die "ora_open failed. $ora_errstr\n";
  
 #
 #  Read in each line from the qualifier table and set a hash value.
 #
  my ($qualtype, $qualcode, $qualid);
  while ( ($qualtype, $qualcode, $qualid) = &ora_fetch($csr) )
  {
    $$rqcode2qid{"$qualtype:$qualcode"} = $qualid;
  }
  &ora_close($csr) || die "can't close cursor";

  #print "Testing... DEPT:D_BIOLOGY -> " 
  #      . $$rqcode2qid{"DEPT:D_BIOLOGY"} . "\n";

}
