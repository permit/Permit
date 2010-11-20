#!/usr/bin/perl
###########################################################################
#
#  CGI script calling  implied_auth_rule insertion procedure 
#
#  Copyright (C) 2008-2010 Massachusetts Institute of Technology
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
#  Modifications
#  Who    When          What
#  VSL    07/11/2008    Created
#  REPA   08/26/2007    Made screen formatting changes
#
###########################################################################
#
# Get packages
#
use rolesweb('login_dbi_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm

use rolesweb('parse_authentication_info'); #Use sub. parse_authentication_info in rolesweb.pm
use rolesweb('check_auth_source'); #Use sub. check_auth_source in rolesweb.pm
use rolesweb('verify_metaauth_category'); #Use sub. verify_metaauth_category
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm
use rolesweb('strip'); #Use sub. strip in rolesweb.pm


#
#  Print out the first line of the document
#
 print "Content-type: text/html", "\n\n";

#
#  Print out the http document header
#
 my $doc_title = 'Create a new rule - last step.';
 print "<HTML>", "\n";
 print "<HEAD>"
  . "<TITLE>$doc_title</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 &print_header ($doc_title, 'https');
 print "<p /><hr /><p />";

#
#  Constants
#
 $g_previous_step = 
  "<form><input type=\"button\" value=\"Previous Step \""
  . " onclick=\"history\.go(-1)\;return false\;\" /></form>","\n";
 $default_cond_function = 'choose a function';
 $default_cond_obj_type = 'choose a condition object type';
 $default_cond_qual_code = 'choose qualifier code';
 $default_result_obj_type = 'choose result object type';
 $default_result_qual_code = 'choose qualifier code';

#
#  Web stem constants 
#

$host = $ENV{'HTTP_HOST'};
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 ($mysubdir=$0) =~ s/^\S*cgi-bin// ; 
 $mysubdir =~ s!/?[^/]*/*$!!; #remove basename
 $url_stem = "https://$host/cgi-bin$mysubdir"; #implied rules url sub-directory
 $main_progname = "implied_auth_rules0.cgi";

#
#  Parse certificate information
#
 $info = $ENV{'REMOTE_USER'};  # Get certificate information
 %ssl_info = &parse_authentication_info($info);  # Parse certificate into a Perl "hash"
 $full_name = $ENV{'REMOTE_USER'};   # Get full name from cert. 'CN' field
 ($k_principal, $domain) = split("\@", $info);
 if (!$k_principal) {
     print "<br><b>No certificate sent.  Use https:// , not http://</b>\n";
     exit();
 }
 $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase
 #if ($k_principal eq 'REPA') {$k_principal = 'JIVES';} # For testing

#
#  Check the other fields in the certificate
#
 $result = &check_auth_source($info);
 if ($result ne 'OK') {
     print "<br><b>Your certificate cannot be accepted: $result";
     exit();
 }

#
#  Process form information
#
$request_method = $ENV{'REQUEST_METHOD'};
 if ($request_method eq "GET") {
    #print "Inside request method = GET <br>";
   $input_string = $ENV{'QUERY_STRING'};
 } 
 elsif ($request_method eq "POST") {
   read (STDIN, $input_string, $ENV{'CONTENT_LENGTH'});  # Read input string
 }
 else {
   $input_string = '';  # Error condition 
 }
 
 %formval = ();  # Hash of reformatted key->variables populated by &parse_forms
 %rawval = ();  # Hash of unformatted key->variables populated by &parse_forms
 &parse_forms($input_string, \%formval, \%rawval); # Call sub. to parse input


#
# Get specific form variables
#
 #$fu  = 'ROLESBB';
 $fu = $k_principal;
 #$fu = $formval{'f_usr'};
 $rt = $formval{'rt'};
 $cfn = $formval{'cfn'};
 ($cfg,$cfc,$cfn) = split(/:/,$cfn); 
 $cot = $formval{'cot'};
 $cqc = $formval{'cqc'};
 $rfn =$formval{'rfn'};
 ($rfg,$rfc,$rfn)= split(/:/,$rfn); 
 $rqt = $formval{'rqt'};
 $rqc = $formval{'rqc'};
 $rsn = $formval{'rsn'};
 $rd = $formval{'rd'};
 $rie = $formval{'rie'};

#
# Hard-code $su (server-user)
#
 $su = 'rolewww9';

#print "The procedure is being called with following arguments: <br> 
#       $fu, $su, $rt, $cfg, $cfc, $cfn, $cot, $cqc, $rfc, $rfn, 
#       $rqt, $rqc, $rsn, $rd, $rie\n";

#
#  Get set to use Oracle.
#
 use DBI;

#
# Login into the database
# 
$lda = &login_dbi_sql('roles')
      || die $DBI::errstr . "<BR>";

#$lda = &login_sql('rolesbb') 
#      || die $DBI::errstr . "<BR>";

#
# Check to make sure the user filled in all the appropriate fields
#
 my $found_condition_function = 1;
 my $found_cond_object_type = 1;
 my $found_cond_qual_code = 1;
 my $found_result_function = 1;
 my $found_result_obj_type = 1;
 my $found_result_qual_code = 1;
 my $found_short_name = 1;
 my $found_description = 1;
 my $error_fragment = '';
#print "RSN:'$rsn'";
 if (!($rsn)) {
   $found_short_name = 0;
   $error_fragment .= ', short_name';
 }
#print "CFN:'$cfn'";
 if (!($cfn) || ($cfn eq $default_cond_function)) {
   $found_condition_function = 0;
   $error_fragment .= ', condition function';
 }
#print "COT:'$cot'";
 if ( ($rt eq '1a' || $rt eq '1b')
       && ( !($cot) || ($cot eq $default_cond_obj_type) ) ) {
   $found_cond_object_type = 0;
   $error_fragment .= ', condition object type';
 }
#print "RQT:'$rqt'";
 if ( ($rt eq '1b')
       && ( !($rqt) || ($rqt eq $default_result_obj_type) ) ) {
   $found_result_object_type = 0;
   $error_fragment .= ', result object type';
 }
#print "CQC:'$cqc'";
 if ( ($rt eq '2a' || $rt eq '2b')
       && ( !($cqc) || ($cqc eq $default_cond_qual_code) ) ) {
   $found_cond_qual_code = 0;
   $error_fragment .= ', condition object code';
 }
#print "RT:'$rt'";
 if ( ($rt eq '2a' || $rt eq '2b')
       && ( !($rqc) || ($rqc eq $default_result_qual_code) ) ) {
   $found_result_qual_code = 0;
   $error_fragment .= ', result qualifier code';
 }
 if ($error_fragment) {
   $error_fragment = substr($error_fragment, 2);
   print "<br><font color=red><b>Error - you have not filled in all the"
         . " required fields."
         . "<br>Missing field(s): ${error_fragment}.</b><p />";

   print $g_previous_step;
   exit();
 }

#
# If this is a rule type '2a' or '2b', then fill in the condition_obj_type
# and result_obj_type fields based (condition_function, condition_qual_code)
# and (result_function, result_qual_code).
#
 my ($cond_qual_subtype, $result_qual_subtype);
 if ($rt eq '2a' || $rt eq '2b') {
   $cond_qual_subtype 
      = &get_obj_type_from_qual_code($lda, $cfc, $cfn, $cqc);
   $result_qual_subtype 
      = &get_obj_type_from_qual_code($lda, $rfc, $rfn, $rqc);
 }
 else {  
     # If rule type is 1a or 1b, get obj types from form variables
     $cond_qual_subtype = $cot;
     $result_qual_subtype = $rqt;
 }
 #print "cond obj type = '$cond_qual_subtype' cot='$cot'
 #       result obj type = '$result_qual_subtype'<BR>";

#
#  Run the procedure and print out the results
#
#print "call do_insert details:'$fu':'$su':'$rt':'$cfg':'$cfc':'$cfn':'$cqc'";
&do_insert($lda, $fu, $su, $rt, 
           $cfg, $cfc, $cfn, $cond_qual_subtype, $cqc, 
           $rfc, $rfn, $result_qual_subtype, $rqc, $rsn, $rd, $rie);

#
# Disconnect from the database and print end of document
#
 $lda->disconnect;

print $g_previous_step;
#print "<form><input type=\"button\" value=\"Main Page\" onclick=\"history\.go(-3)\;return false\;\" /></form>","\n";  
#print "<form><input type=\"button\" value=\"Main Page\" onclick=\"$main_progname\"/></form>","\n";  
print "<a href=\"$main_progname\"> <- To Main Page</a>"; 
 print "</BODY></HTML>", "\n";
 exit(0);

########### End of main block ############################################

sub do_insert {

my ($lda, $fu, $su, $rt, $cfg, $cfc, $cfn, $cot, $cqc, $rfc, $rfn, $rqt, $rqc, $rsn, $rd, $rie) = @_;

#print "<br>For User = $fu<br>";
#print "Server User = $su<br>";
my $rid="" ;
my $save_rsn = $rsn;
	       
my $crs = $lda->prepare(' CALL  rolesapi_create_imprule(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,@modified_by,@modified_date,@ruleId) '  );
$crs->bind_param(1,$fu);
$crs->bind_param(2,$su);
$crs->bind_param(3,$rt);
$crs->bind_param(4,$cfg);
$crs->bind_param(5,$cfc);
$crs->bind_param(6,$cfn);
$crs->bind_param(7,$cot);
$crs->bind_param(8,$cqc);
$crs->bind_param(9,$rfc);
$crs->bind_param(10,$rfn);
$crs->bind_param(11,$rqt);
$crs->bind_param(12,$rqc);
$crs->bind_param(13,$rsn);
$crs->bind_param(14,$rd); 
$crs->bind_param(15,$rie);

$crs->execute || die 'Error in creating new imprule. Please check the name. A rule with that name might already exist';

$error = get_db_error_msg($lda);
$message = "New rule has been created";
#$message = "New rule '$save_rsn' has been created.  Rule ID = ${rid}.";
if ($error){print "<p> <b><font color=red> $error \n</font></b>";}
  elsif (!$error){print "<p> <font color=green> $message \n</font>";}      
  $crs -> finish;
  $lda -> commit;
}

############################################################################

#######################################
sub get_db_error_msg {
    my($lda) = @_;
    my $err = $lda->err;
    my $errstr = $lda->errstr;
    $errstr =~ /\: ([^\n]*)/;
    my $shorterr = $1;
    $shorterr =~ s/ORA.*?://g;
    if($err) {
      return "Error: $shorterr Error Number $err";
#       return "Error: $shorterr ";
    }

    return undef;
}
####################################################################

##########################################################################
# Function get_obj_type_from_qual_code($lda, $function_category, 
#                                      $function_name, $qual_code);
# Used for rule types 2a and 2b to determine the qualifier_subtype_code
# based on the qualifier_type (from the function) and qualifier 
# (pattern matching with the qualifier_subtype table).
#
# Returns a qualifier_subtype_code
##########################################################################
sub get_obj_type_from_qual_code {
   my ($lda, $function_category, $function_name, $qual_code) = @_;

  #
  # First, get the qualifier_type associated with the function or
  # function group.
  #
   my $star_function_name = '*' . $function_name;
   my $stmt1 = 
        "select f.qualifier_type
           from function2 f 
           where function_category = ? 
           and function_name in (?, ?)
         union select g.qualifier_type
           from function_group g
           where function_category = ?
           and function_group_name = ?";
   #print "stmt1='$stmt1'<BR>";
   unless ($csr1=$lda->prepare($stmt1)){
	print "Error preparing select statement"
              . " (1st in get_obt_type_from_qual_code): " 
              . $DBI::errstr . "<br>";
   }
   unless ($csr1->bind_param(1, $function_category)) {
     print "Error binding :fc1 in select statement: " . $DBI::errstr . "<br>";
   }
   $csr1->bind_param(2, $function_name);
   $csr1->bind_param(3, $star_function_name);
   $csr1->bind_param(4, $function_category);
   $csr1->bind_param(5, $function_name);
   unless ($csr1->execute) {
      print "Error executing select statement: " . $DBI::errstr . "<br>";
   }
   my $qualifier_type;
   ($qualifier_type) = $csr1->fetchrow_array;
   $csr1->finish();
   #print "qualifier_type = '$qualifier_type'<BR>";
   unless ($qualifier_type) {return '????';}

  #
  # Look for a match with the qualifier code.  If more than one, take the
  # first one. 
  #
   my $stmt2 = 
      "select qs.qualifier_subtype_code
         from qualifier_subtype qs
         where parent_qualifier_type = '$qualifier_type'
         and instr(?, IFNULL(qs.contains_string, ?)) > 0
         and ? >= IFNULL(min_allowable_qualifier_code, ?)
         and ? <= IFNULL(max_allowable_qualifier_code, ?)";
   #print "stmt2='$stmt2'<BR>";
   unless ($csr2=$lda->prepare($stmt2)){
	print "Error preparing select statement"
              . " (2nd in get_obt_type_from_qual_code): " 
              . $DBI::errstr . "<br>";
   }
   unless ($csr2->bind_param(1, $qual_code)) {
     print "Error binding :qc1 in select statement: " . $DBI::errstr . "<br>";
   }
   $csr2->bind_param(2, $qual_code);
   $csr2->bind_param(3, $qual_code);
   $csr2->bind_param(4, $qual_code);
   $csr2->bind_param(5, $qual_code);
   $csr2->bind_param(6, $qual_code);
   unless ($csr2->execute) {
      print "Error executing select statement: " . $DBI::errstr . "<br>";
   }
   my $qualifier_subtype_code;
   ($qualifier_subtype_code) = $csr2->fetchrow_array;
   $csr2->finish();
   #print "qualifier_subtype_code = '$qualifier_subtype_code'<BR>";
   if ($qualifier_subtype_code) {
     return $qualifier_subtype_code;
   }

  #
  #  If there were no results, look for any qualifier_subtype_code
  #  for this qualifier_type.
  #
   my $stmt3 = 
      "select qs.qualifier_subtype_code
         from qualifier_subtype qs
         where parent_qualifier_type = '$qualifier_type'";
   #print "stmt3='$stmt3'<BR>";
   unless ($csr3=$lda->prepare($stmt3)){
	print "Error preparing select statement"
              . " (3rd in get_obt_type_from_qual_code): " 
              . $DBI::errstr . "<br>";
   }
   unless ($csr3->execute) {
      print "Error executing select statement: " . $DBI::errstr . "<br>";
   }
   ($qualifier_subtype_code) = $csr3->fetchrow_array;
   $csr3->finish();
   #print "qualifier_subtype_code = '$qualifier_subtype_code'<BR>";
   if ($qualifier_subtype_code) {
     return $qualifier_subtype_code;
   }
   else {
     return $qualifier_type;
   }

}
