#!/usr/bin/perl
###############################################################################
#  Collecting rules 1a and 1b  parameters and calling implied_auth_rule 
#    insertion procedure.  
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
#  Modifcation history
#  Who When        What
#  VSL 07/18/2008  Created
#  VSL 07/28/2008  1a and 1b combined , subroutines for pull-down lists, 
#                  2 form passes.
#  Modified by Jim Repa 8/25/2008  Reformat for readability
###############################################################################
#
# Get packages
#
 use rolesweb('login_sql');   #Use sub. login_sql in rolesweb.pm
 use rolesweb('login_dbi_sql');   #Use sub. login_sql in rolesweb.pm
 use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
 use CGI qw/:standard :html3/;
 use rolesweb('parse_authentication_info'); #Use sub. parse_authentication_info in rolesweb.pm
 use rolesweb('check_auth_source'); #Use sub. check_auth_source in rolesweb.pm
 use rolesweb('verify_metaauth_category'); #Use sub. verify_metaauth_category
 use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm
 use rolesweb('strip'); #Use sub. strip in rolesweb.pm
 use imprule('get_rule_type_hashes'); #Use sub get_rule_type_hashes
 use imprule('user_categories_list'); #Use sub user_categories_list

#
#  Print out the first line of the document
#
 print "Content-type: text/html", "\n\n";

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

##########################
# Constants
##########################
 $g_next_step_label = "Continue...";
 $g_red_star = "<font color=red>*</font>";
 $g_bg_yellow = "bgcolor=\"#FFFF88\"";
 $g_bg_green = "bgcolor=\"#88FF88\"";
 $g_new_rule_label = "Create New Rule";
 $g_choose_function_row = "Choose a function (result)";

##########################
# Web stem constants
##########################

 $host = $ENV{'HTTP_HOST'};
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 ($mysubdir=$0) =~ s/^\S*cgi-bin// ; 
 $mysubdir =~ s!/?[^/]*/*$!!; #remove basename
 $url_stem = "https://$host/cgi-bin$mysubdir"; #implied rules url sub-directory 
 
 %formval = ();  # Hash of reformatted key->variables populated by &parse_forms
 %rawval = ();  # Hash of unformatted key->variables populated by &parse_forms
 &parse_forms($input_string, \%formval, \%rawval); # Call sub. to parse input

 #get rule type variable from the calling page
 $rt = $formval{'rt'};
 #get form pass number
 $formlevel = $formval{"FORM_LEVEL"};
 unless ($formlevel) {$formlevel = 0;}
 $formpass = $formval{"FORM_LEVEL"}+1;
 # Get result function name and split it into function_or_group,
 # function_category, and function_name variables.
 $rfn = $formval{'rfn'};
 ($rfg0,$rfc0,$rfn0) = split(/:/,$rfn);


#####################################################################
# Process certificate information (needed to generate appropriate 
# selection lists)
#####################################################################


 # authentication checks
  ($info,$k_principal, $domain)  = &parse_authentication_info();  # Parse authentication info
  $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase
  $full_name = $k_principal;
  $result = &check_auth_source($info); # Check other certificate fields
  if ($result ne 'OK') {
      print "<br><b>Your authentication cannot be accepted: $result";
      exit();
  }

#
#  If this is first pass and we are missing the input parameter, set an
#  an error message and return the user to the first page.
#
 $error_message = "";
 if ( ($formpass == 2) && ($rfn eq $g_choose_function_row) ) { 
   $error_message = "Error. You did not choose a Result Function.";
   $formpass = 1;
 }

#
#  Print out the http document header
#
 my $doc_title = 'Create a rule - step ' . $formpass;

 print start_html(-title=>$doc_title, 
       -style=>{ -src => '/imprulestyle.css' },
       -bgcolor=>"#fafafa");

 &print_header ($doc_title, 'https');
 #print "formlevel='$formlevel' formpass='$formpass' rfn='$rfn'
 #       constant='$g_choose_function_row'<BR>";
 print "<p /><hr />";
 if ($error_message) {
   print "<font color=red><b>$error_message</b></font><p />";
 }

#------ Oracle connection. ------------#
 use DBI;
 $lda = &login_dbi_sql('roles')
      || die $DBI::errstr . "<BR>";


#
#  Get two hashes mapping rule type codes to their names and descriptions.
#
 my %rule_code2name, %rule_code2desc;
 &get_rule_type_hashes($lda, \%rule_code2name, \%rule_code2desc);
 my ($rule_type_name, $len_string);

#
#  Get appropriate instructions for this pass number and rule type, and
#  print them.
#
 $rule_type_name = $rule_code2name{$rt};
 if ($rule_type_name =~ /^$limit_rule_type_code/) {
     $len_string = length($limit_rule_type_code) + 2;
     $rule_type_name = substr($rule_type_name, $len_string);
     if (substr($rule_type_name, 0, 2) eq '. ') {
       $rule_type_name = substr($rule_type_name, 2);
     }
 }
 my $step_instructions="";
 if ($rt eq "1a" and $formpass == 2 ) {
     $step_instructions = 'Implied authorization rules of type '
     . $rt .
     ' specify a Condition Function or Function Group, Condition Object Type 
       and a Result Function. 
       When the rule is in effect, and a person has an authorization for the 
       specified Condition Function or Function-Group with a qualifier of a 
       type matching  the Condition Object Type, this person will get an 
       implied authorization for the Result Function and the same qualifier.';
 }
 if ($rt eq "1b" and $formpass == 2 ) {
   $step_instructions = 
   'When a rule of this type is in effect, and a person has an authorization 
    for the specified Condition Function or Function-Group with a 
    qualifier (Q) of a type matching the Condition Object Type, this person 
    will get an implied authorization for the Result Function and a qualifier 
    of the appropriate type related to the qualifier Q.';
 }
 if ($formpass == 1) {
  $step_instructions = "To create a new rule ($rule_type_name - type $rt), 
    start with the Result function, the function 
    you want to grant in an implied authorization.
    (You will be asked to specify the Condition function in a later step.)
    <p />";
 }

 print "$step_instructions<p />";


############################################################ 
# Generate HTML page
########################################################### 

#------ Get selection list of categories accessible by current user. 

@catlist = &user_categories_list($lda, $k_principal);

#----- Prepare drop-down list of result function categories 

 my $cat_list ="<select name=\"rfc\">";
  $cat_list .= "<option selected>choose category for $user\n";
  foreach $cat  (@catlist) {
   $cat_list .= "<option \"value=\"$cat\">$cat</option>";
   }
  $cat_list .= "</select>";
#foreach $cat (@catlist) 
#{print	$cat, "<br>";};

#----- Get drop-down list  of function names according to generated catlist 
#----- for current user 
 
@f_list = &get_function_list_result($lda,\@catlist,":",$k_principal,"rfn");

# What is the name of this program?
  $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
  $progname = $1;    # Set $progname to this string.

if ($formpass == '2') { #after 1st submit - this block is visited
  #get result function name parameter from previous pass of the form

  #+++++ Check to make sure we've got values from the previous step +++++#

  #get html list of condition  object types restricted by result function name
  ($qt_list, $qlist_ref, $rq_list) 
       = &get_obj_type_lists($lda,$rfn0,"cot","rqt");

  #$cfn = $formval{'cfn'};
  #($cfg0,$cfc0,$cfn0) = split(/:/,$cfn);
  @fc_list = &get_function_list_cond1a($lda,\@catlist,$qlist_ref,":","cfn");
  print"<form method=\"post\" action=\"$url_stem/insert_imprule.cgi\">";
  print "<strong>Fill in the fields marked with a red asterisk 
        ($g_red_star) and click the \"$g_new_rule_label\" button.</strong>
        <p />";
  print "<table frame>";
  $rule_type_name = $rule_code2name{$rt};
  print "<tr>
	<td>&nbsp;</td>
        <td><strong>Rule Type:</strong>
            <input type=\"hidden\" name=\"rt\" value=$rt ></td>
        <td>$rule_type_name</td>
     </tr>
     <tr>
        <td><i>Enter a short description for this rule</i></td>
        <td>${g_red_star}<a class=info href=#><strong>Short Name:</strong><span>Rule Short Name max length is 60</span></a></td>
        <td><input type=\"text\" maxlength=\"60\" size=\"60\" name=\"rsn\" > 
        </td>
     </tr>
     <tr>
        <td><i>Enter a longer description for the rule</i></td>
        <td>${g_red_star}<a class=info href=#><strong>Description:</strong><span>Rule Description max length is 2000</span></a></td> 
        <td><textarea cols=\"60\" rows=4 name=\"rd\"></textarea></td>
     </tr>";
 print "<tr>
       <td><i>Should this rule go into effect immediately?
              (If not, you can activate it later.)</i></td>
       <td>${g_red_star}<strong>Is in Effect: </strong></td>
       <td>
        <input type=\"radio\" name=\"rie\" value=\"Y\">Y &nbsp .
        <input type=\"radio\" name=\"rie\" value=\"N\" checked>N
       </td>
     </tr>";
 print 
   "<tr><td align=center colspan=3 $g_bg_yellow><big><b>If...</b></big>
                               <br><i>(condition)</i></td></tr>
     <tr>
      <td $g_bg_yellow><i>What Function is a condition for this rule?</i></td>
      <td>${g_red_star}<strong>Condition<br>&nbsp;&nbsp;Function:</td>
      <td>@fc_list</strong> <a class=info href=#><i>Explain...</i>
        <span>The pull-down list shows functions and function 
         groups that you can choose as a Condition Function.<br>
         Each entry shows 3 items separated by a colon:
         <br>&nbsp;&nbsp;(1) F or G - function or function-group, 
         <br>&nbsp;&nbsp;(2) function category and 
         <br>&nbsp;&nbsp;(3) function or function-group name.
         <br>Choose a select function and click 
         the \"$g_next_step_label\" button.
        </span></a>
      </td>
     </tr>
     <tr>
      <td $g_bg_yellow><i>What object type will we find<br>
             in the condition authorization/role?</i></td>
      <td>${g_red_star}<strong>Condition<br>&nbsp;&nbsp;Object Type:</td><td>$qt_list </strong> </td>
     </tr>
     <tr>
       <td align=center colspan=3 $g_bg_green><big><b>...then</b></big>
              <br><i>(result)</i></td>
     </tr>";
print 
    "<tr>
      <td $g_bg_green rowspan=2><i>What function will be granted in the 
         implied authorizations?</i></td>
      <td><strong>Category:</strong></td><td>$rfc0</td>
     </tr>
     <tr>
      <td><strong>Result Function:</strong></td><td>$rfn0</td>
      <input type=\"hidden\" name=\"rfn\" value=\"$rfn\">
     </tr>";
if ($rt eq "1b" ) {
    print "<tr>
	      <td $g_bg_green><i>What object type will be selected when 
                  the implied
                  authorization is generated? (This should be a \"larger\"
                  object type than the condition object.)</i></td>
              <td>${g_red_star}<strong>Result<br>&nbsp;&nbsp;Object Type:</td>
              <td>$rq_list </strong></td>
           </tr>";
}
print "</table>";
print "<p />";
print "<input type=\"submit\" value=\"$g_new_rule_label\"></FORM><hr/>";

print "<form><input type=\"button\" value=\"Previous Step \" onclick=\"history\.go(-1)\;return false\;\" /></form>","\n";      

}
else
{ #------- first pass - this form

 print "<strong>Fill in the Result Function (marked with a red asterisk 
        ($g_red_star)) and click the \"$g_next_step_label\" button.</strong>
        <p />";
 print "<form method=\"post\" action=\"#\">
  <input type=\"hidden\" name=\"rt\" value=$rt>";
 print "<table frame>";
 print 
   "<tr><td align=center colspan=3 $g_bg_yellow><big><b>If...</b></big>
                               <br><i>(condition)</i></td></tr>
    <tr><td colspan=3><i>You'll fill in this part in a later step.</i></td>
    </tr>
    <tr><td align=center colspan=3 $g_bg_green><big><b>then...</b></big>
                               <br><i>(result)</i></td></tr>";
 print "<tr>
      <td><i>What do you want to grant<br> an implied authorization for?</td> 
      <td>$g_red_star<strong>Result Function:</strong></td>
      <td>@f_list
     <a class=info href=#><i>Explain...</i>
     <span>The pull-down list shows functions and function 
      groups that you are authorized to choose as a Result Function.<br>
      Each entry shows 3 items separated by a colon:
      <br>&nbsp;&nbsp;(1) F or G - function or function-group, 
      <br>&nbsp;&nbsp;(2) function category and 
      <br>&nbsp;&nbsp;(3) function or function-group name.
      <br>Choose a select function and click the \"$g_next_step_label\" button.
     </span></a>
     </td></tr></table>";
 print "<input type=\"hidden\" name=\"FORM_LEVEL\" value=\"1\">";
 print "<p /><input type=\"submit\" value=\"$g_next_step_label\">";
 print "</form><hr/>";

 print "<form><input type=\"button\" value=\"Previous Step \""
      . "onclick=\"history\.go(-1)\;return false\;\" /></form>","\n";  
}
#print "<hr/>";

#print "By the way look at this: <br>";
#print "<script type=\"text/javascript\"src=\"http://www.gas-cost.net/widget.php\"></script>
#<noscript> 
#<a href=\"http://gas-cost.net/dashboard.php?lang=en\">To get gasoline price, please enable Javascript.</a>
#</noscript>";

print "</body></html>", "\n";
$lda->disconnect;
exit(0);

#----------------------------  SUBROUTINES  -------------------------------- #
##############################################################################
# Subroutine get_obj_type_lists($lda,$rfn,$namec,$namer)
# For rules 1a,1b this subroutine restricted by result function name ($rfn) returns:
# - reference to an array of condition_object_types
# - HTML fragment with <select> list of condition object types
# - HTML fragment with a <select> list of result object types - parents of condition object types. 
##############################################################################
sub get_obj_type_lists {
    my ($lda,$rfn,$namec,$namer) = @_;
    my  $csr1 ;
    
    #print  "RFN:'$rfn'";
    my  $stmt = "select distinct qualifier_subtype_code, qualifier_subtype_name
                 from qualifier_subtype qs,function2 f2 
                 where qs.parent_qualifier_type=f2.qualifier_type 
                 and f2.function_name in (CONCAT('*','$rfn'), '$rfn')";    
  unless ($csr1=$lda->prepare($stmt)){
      print "Error preparing select statement (get_obj_type_lists): " 
      . $DBI::errstr . "<br>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement (get_obj_type_lists): " 
      . $DBI::errstr . "<br>";
  }

  #########################################################
  #  Get 2 lists and one array of condition qualifier types
  #########################################################
  
    my $qual_type, $qual_type_name;
  
    my @qualist = (); #an array of condition qualifier types 

    my $condqualist = '('; #start of comma-separated list of qaulifiers
    my $first_time =1;
    my $select_list ="<select name=\"$namec\">"; # start of an html fragment
    $select_list .= "<option selected>choose a condition object type\n";
    
    while ( ($qual_type,$qual_type_name) = $csr1->fetchrow_array ) {
      push (@qualist, $qual_type);
      if ($first_time) {$condqualist .= "'$qual_type'"; $first_time = 0;}
      else {$condqualist .= ",'$qual_type'";}
      $select_list .= 
        "<option \"value=\"$qual_type\">$qual_type - $qual_type_name</option>";
    }
    $select_list .= "</select>";
    $condqualist .= ')';

 #++++++++++++ Check to make sure there is at least one item in the list

   ###########################################################################
   # Get HTML list of result qualifier types according to 
   # subtype_descendent_subtype relations
   ###########################################################################

    $stmt = "select distinct sds.parent_subtype_code, qs.qualifier_subtype_name 
             from subtype_descendent_subtype sds, qualifier_subtype qs 
             where sds.child_subtype_code in $condqualist 
             and sds.parent_subtype_code=qs.qualifier_subtype_code";
    #print "stmt='$stmt'<BR>";
    unless ($csr1=$lda->prepare($stmt)){
	print "Error preparing select statement 2: " . $DBI::errstr . "<br>";
    }
    unless ($csr1->execute) {
      print "Error executing select statement 2: " . $DBI::errstr . "<br>";
    }
    my $res_select_list = "<select name=\"$namer\">";
    $res_select_list .= "<option selected>choose result object type\n";
    while ( ($qual_type,$qual_type_name) = $csr1->fetchrow_array ) {
      $res_select_list .=
        "<option \"value=\"$qual_type\">$qual_type - $qual_type_name</option>";
    }
    $res_select_list .= "</select>";
    $csr1->finish();
    return $select_list , \@qualist , $res_select_list;

} # End of subroutine get_obj_type_lists


###############################################################################
#  Subroutine get_function_list_result($lda, \@categories, $delim, $name)
#
#   Return an HTML fragment containing a <select> list of items 
#   in "$fg$delim$cat$delim$name" format.
###############################################################################
sub get_function_list_result {
    my ($lda, $rcategories, $delim, $user, $name) = @_;
    
  my $catlist = '(';
  my $cat;
  my $first_time = 1;
  foreach $cat (@$rcategories) {
    if ($first_time) {
	$catlist .= "'$cat'";
        $first_time = 0;
    }
    else {
	$catlist .= ", '$cat'";
    }
  }
  $catlist .= ')';
  #print "Category list:'$catlist'";
 #
 # Here, we find Functions in the external_function table that 
 # (1) can be chosen by the person as result functions based on their
 # category, (2) are not flagged as "pass 1" in the functino_load_pass table,
 # and (3) have a qualifier_type that matches another function in the
 # external_function table that not flagged as "pass 2".
  my $stmt = 
   "select 'F' as type, function_category as category, REPLACE(function_name, '*','') as name
    from external_function f
    where function_category in $catlist
      and function_id not in 
      (select flp.function_id from function_load_pass flp
       where flp.function_id = f.function_id
       and pass_number = 1)
    and exists
      (select 1 from external_function f2 left outer join function_load_pass flp
        on f2.function_id = flp.function_id
       where qualifier_type = f.qualifier_type
       and IFNULL(flp.pass_number, 1) = 1
      )
    order by category, type, name";
  #print "stmt 1 = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 3: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement 3: " . $DBI::errstr . "<BR>";
  }

 #
 #  Get list of functions
 #
  my $func_or_group, $function_name;
  my $select_list ="<select name=\"$name\">";
  $select_list .= "<option selected>$g_choose_function_row";
  while ( ($func_or_group, $cat, $function_name) = $csr1->fetchrow_array ) {
   $select_list .= "<option \"value=\"$func_or_group$delim$cat$delim$function_name\">$func_or_group$delim$cat$delim$function_name</option>";
    #$select_list .= "<option value=\"$function_name\">$cat</option><br/>";
  }
$csr1->finish();
  $select_list .= "</select>";
  return $select_list;
}

###########################################################################
# Subroutine get_function_list_cond($lda, \@categories, $delim, $name)
# Return an HTML <select> list in "$fORg$delim$category$delim$function_name"
############################################################################
sub get_function_list_cond {
    my ($lda, $rcategories,$delim, $name) = @_;
    my ($csr1, $stmt);

  my $catlist = '(';
  my $cat;
  my $first_time = 1;
  foreach $cat (@$rcategories) {
    if ($first_time) {
	$catlist .= "'$cat'";
        $first_time = 0;
    }
    else {
	$catlist .= ", '$cat'";
    }
  }
  $catlist .= ')';

  my $stmt = 
   "select 'F' as type, function_category as category, REPLACE(function_name, '*','') as name
    from external_function f
    where function_category in $catlist
      and function_id not in 
      (select flp.function_id from function_load_pass flp
       where flp.function_id = f.function_id
       and pass_number = 2)
    union select 'G' as type , function_category as category, function_group_name as name
    from function_group 
    where function_category in $catlist
    and IFNULL(matches_a_function, 'N') = 'N'
    order by category, type, name";
  #print "stmt 1 = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 4: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement 4: " . $DBI::errstr . "<BR>";
  }

 #
 #  Get list of functions
 #
  my $func_or_group, $function_name;
  my $select_list = "<select name=\"$name\">";
  $select_list .= "<option selected>choose a function\n";
  while ( ($func_or_group, $cat, $function_name) = $csr1->fetchrow_array ) {
    $select_list .= "<option>$func_or_group$delim$cat$delim$function_name";
  }
  $select_list .= "</select>";

$csr1->finish();
  return $select_list;
}
###########################################################################
# Subroutine get_function_list_cond1a($lda, \@categories, \@qualifiers,$delim, $name)
# Return an HTML <select> list in "$fORg$delim$category$delim$function_name"
############################################################################
sub get_function_list_cond1a {
    my ($lda, $rcategories,$qualifiers,$delim, $name) = @_;
    my ($csr1, $stmt);

  my $catlist = '(';
  my $cat;
  my $first_time = 1;
  foreach $cat (@$rcategories) {
    if ($first_time) {
	$catlist .= "'$cat'";
        $first_time = 0;
    }
    else {
	$catlist .= ", '$cat'";
    }
  }
  $catlist .= ')';
    
    my $qualist = '(';
    my $qual;
    $first_time = 1; #using this flag again - this  time for qualifiers list
    foreach $qual (@$qualifiers) {
	if ($first_time) {
	    $qualist .= "'$qual'";
	    $first_time = 0;
	}
	else {
	    $qualist .= ",'$qual'";
	}
    }
    $qualist .= ')';
	    


  my $stmt = 
   "select 'F' as type, function_category as category, REPLACE(function_name, '*','') as name
    from external_function f
    where function_category in $catlist
      and function_id not in 
      (select flp.function_id from function_load_pass flp
       where flp.function_id = f.function_id
       and pass_number = 2)
and qualifier_type in (select parent_qualifier_type from qualifier_subtype where qualifier_subtype_code in $qualist)
    union select 'G' as type, function_category as category, function_group_name as name 
    from function_group 
    where function_category in $catlist
    and IFNULL(matches_a_function, 'N') = 'N'
and qualifier_type in (select parent_qualifier_type from qualifier_subtype where qualifier_subtype_code in $qualist) 
    order by category, type, name";
  #print "stmt 1 = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 5: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement 5: " . $DBI::errstr . "<BR>";
  }

 #
 #  Get list of functions
 #
  my $func_or_group, $function_name;
  my $select_list = "<select name=\"$name\">";
  $select_list .= "<option selected>choose a function\n";
  while ( ($func_or_group, $cat, $function_name) = $csr1->fetchrow_array ) {
    $select_list .= "<option>$func_or_group$delim$cat$delim$function_name";
  }
  $select_list .= "</select>";

$csr1->finish();
  return $select_list;
}

