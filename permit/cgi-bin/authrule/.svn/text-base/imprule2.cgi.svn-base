#!/usr/bin/perl
###############################################################################
#  Handle 1st and 2nd pass of creating rules of type 2a or 2b.  (Final 
#  insertion step is handled by insert_imprule.cgi)
#
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
#  Modification history
#  Who  When        What
#  VSL  07/18/2008  Created
#  VSL  08/03/2008  Combined 2a & 2b, added intermediate page, pull-down lists.
#  REPA 08/25/2008  Formatting changes
###############################################################################
#
# Get packages
#
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
 $g_default_cond_function_row = "choose a function or group";
 $g_default_result_function_row = "choose a function";

##########################
# Web stem constants
##########################

 $host = $ENV{'HTTP_HOST'};
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 ($mysubdir=$0) =~ s/^\S*cgi-bin// ; 
 $mysubdir =~ s!/?[^/]*/*$!!; #remove basename
 $url_stem = "https://$host/cgi-bin$mysubdir"; #implied rules url sub-directory 
 $show_qual_stem = "https://$host/cgi-bin/qualauth.pl?qualtype=";
 
 %formval = ();  # Hash of reformatted key->variables populated by &parse_forms
 %rawval = ();  # Hash of unformatted key->variables populated by &parse_forms
 &parse_forms($input_string, \%formval, \%rawval); # Call sub. to parse input


#
# Get form variables for rule_type, condition_function and result_function
#
    $rt = $formval{'rt'};
    $formpass = $formval{"FORM_LEVEL"} +1 ;
    $cfn = $formval{'cfn'};
    $rfn = $formval{'rfn'};

#
#  Print out the http document header
#
 my $doc_title = 'Create a rule, step ' . $formpass;

 print start_html(-title => $doc_title, 
                   -style => { -src => '/imprulestyle.css'},
                   -bgcolor=>"#fafafa"); 

 &print_header ($doc_title, 'https');

#---  Process certificate information (needed to generate appropriate selection lists)


 # authentication checks
  ($info,$k_principal, $domain)  = &parse_authentication_info();  # Parse authentication info
  $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase
  $full_name = $k_principal;
  $result = &check_auth_source($info); # Check other certificate fields
  if ($result ne 'OK') {
      print "<br><b>Your authentication cannot be accepted: $result";
      exit();
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


#
#  Set instructions for pass 1
#
 my $step_instructions = "";
 my $rule_type_name = $rule_code2name{$rt};
 my $len_string; 
 my $short_rule_type_name = $rule_type_name;
 if ($rule_type_name =~ /^$rt/) {
     $len_string = length($rt) + 2;
     $short_rule_type_name = substr($rule_type_name, $len_string);
     if (substr($short_rule_type_name, 0, 2) eq '. ') {
       $short_rule_type_name = substr($short_rule_type_name, 2);
     }
 }
 if ($formpass == 1) {
    $step_instructions = "The first step in creating a rule of this 
      type ($short_rule_type_name) 
      is to select  
      the Condition Function and Result Function.<br>
      Other fields will be defined in the next step.<br>";
 }
 elsif ($formpass == 2 && $rt eq '2a') {
    $step_instructions = 
     "Rules of this type ($short_rule_type_name) specify a Condition Function 
      and Qualifier (object), which get mapped into a Result Function
      and Qualifier to generate the implied Authorizations.  You have 
      already specified the Condition Function and Result Function in 
      the first step.<BR>";
 }
 elsif ($formpass == 2 && $rt eq '2b') {
    $step_instructions = "Put instructions for rule type 2b here<BR>";
 }
 #print "<p /><hr />";
 #    print $step_instructions,"<br>";


#------ Get selection list of categories accessible by current user. 

 #chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
 #print "Before getting user categories ($time)...<BR>";
 @catlist = &user_categories_list($lda, $k_principal);
 #chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
 #print "After getting user categories ($time)...<BR>";

#----- Get drop-down list  of function names according to generated catlist 
#----- for current user 

 #chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
 #print "Before get_function_list_result 'rfn' ($time)...<BR>"; 
 ($fr_list,$fr_sql_list) = &get_function_list_result($lda,\@catlist,":",$k_principal,"rfn");
# print "After get_function_list_result fr_sql_list '$fr_sql_list'...<BR>"; 
 #chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
 #print "Before get_function_list_result 'cfn' ($time)...<BR>"; 
 ($fc_list,$fc_sql_list) = &get_function_list_cond($lda,":","cfn");
 #chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
 #print "After get_function_list_result 'cfn' ($time)...<BR>"; 


# What is the name of this program?
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.

#
# If this is the 2nd pass and we're missing either the condition function
# or the result function, then print an error message and repeat pass 1.
#
 my $error_fragment = '';
 my $error_message = '';
 if ($formpass == 2) {
     if (!($cfn) || ($cfn eq $g_default_cond_function_row) ) {
        $error_fragment .= ", condition function";
     }
     if (!($rfn) || ($rfn eq $g_default_result_function_row) ) {
 	$error_fragment .= ", result function";
     }
     if ($error_fragment) {
       $error_fragment = substr($error_fragment, 2);
       $error_message = 
           "Error - you have not filled in all the required fields."
 	 . "<br>Missing field(s): ${error_fragment}.";
       $formpass = '1';
     }
 }

##################### BEGIN 2nd PASS #######################

if ($formpass == '2') { #after first submit, this block is visited
 
 print "<p /><hr />";
     print $step_instructions,"<br>";

#----- Get drop-down lists, arrays and comma-separated lists of 
#----- qualifier types (object types)

# Before calling - substitute $fr_sql_list and $fc_sql_list with selected 
# function names 
# print "rfn: '$rfn'";
($rfg,$rfc,$frn) = split(/:/,$rfn);
# print "frn: '$frn'";
$fr_sql_list = "'".$frn."'";
# print "fr_sql_list after read from frn: '$fr_sql_list'";
($cfg,$cfc,$fcn) = split(/:/,$cfn);
$fc_sql_list = "'".$fcn."'";
#------debug
#print "Here is condition function sql list: ", $fc_sql_list, "<br>";
#print "Here is result function sql list: ", $fr_sql_list,"<br>";
 
#chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
#print "Before get_obj_type_lists 'rqt' ($time)...<BR>"; 
# print "Before get_obj_type_lists 'fr_sql_list' $fr_sql_list...<BR>"; 
($rq_types,$ref_rq_types,$rq_types_sql) = &get_obj_type_lists($lda,$fr_sql_list,"rqt");
#chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
#print "Before get_obj_type_lists 'cot' ($time)...<BR>"; 
($co_types,$ref_co_types,$co_types_sql) = &get_obj_type_lists($lda,$fc_sql_list,"cot");
#chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
#print "After get_obj_type_lists 'cot' ($time)...<BR>"; 

#------ Get drop-down list of qualifier codes for condition and result blocks.

#chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
#print "Before get_qual_code_list cqc ($time)<br>";
$cqc_list = &get_qual_code_list($lda,$co_types_sql,"cqc");
#chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
#print "Before get_qual_code_list rqc ($time)<br>";
$rqc_list = &get_qual_code_list($lda,$rq_types_sql,"rqc");
#chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
#print "After get_qual_code_list rqc ($time)<br>";

#-- debug
    #($cfg,$cfc,$cfn) = split(/:/,$cfn0);
    #($rfg,$rfc,$rfn) = split(/:/,$rfn0);
    #print "Here is CFG: ", $cfg, "<br>";
    #print "Here is CFC: ", $cfc, "<br>";
    #print "Here is CFN: ", $cfn, "<br>";
    #print  "Here is RFG: ", $rfg, "<br>";
    #print "Here is RFC: ", $rfc, "<br>";
#print "Here is RFN: ", $rfn, "<br>";
#---------------------------------------

print "<form method=\"post\" action=\"$url_stem/insert_imprule.cgi\">";
print "<input type=\"hidden\" name=\"cfn\" value=\"$cfn\">";
print "<strong>Fill in the fields marked with a red asterisk 
        ($g_red_star) and click the \"$g_new_rule_label\" button.</strong>
        <p />";
$rule_type_name = $rule_code2name{$rt};
print 
"<table frame>
 <tr>
  <td>&nbsp;</td>
  <td><strong>Rule Type:</strong></td> 
  <td><input type=\"hidden\" name=\"rt\" value=\"$rt\">$rule_type_name</td> 
 </tr>
 <tr>
  <td><i>Enter a short description for this rule</i></td>
  <td>$g_red_star<strong>Short Name:</strong></td>
  <td><input type=\"text\" maxlength=\"60\" size=\"60\" name=\"rsn\" ></td>
 </tr> 
 <tr>
  <td><i>Enter a longer description for the rule</i></td>
  <td>$g_red_star<strong>Description:</strong></td> 
  <td><textarea cols=\"60\" rows=4 name=\"rd\">$rd</textarea></td> 
 </tr>
 <tr>
  <td><i>Should this rule go into effect immediately?
      (If not, you can activate it later.)</i></td>
  <td>$g_red_star<strong>Is In Effect: </strong></td>
  <td><input type=\"radio\" name=\"rie\" value=\"Y\">Y &nbsp 
     <input type=\"radio\" name=\"rie\" value=\"N\" checked>N
  </td>
 </tr>
 <tr>
  <td align=center colspan=3 $g_bg_yellow><big><b>If...</b></big>
                               <br><i>(condition)</i></td></tr>
 </tr>";
 my $cond_function_label = ($cfg eq 'F') ? "Condition Function"
                                         : "Condition Function Group";
print 
 "<tr>
 <tr>
  <td rowspan=2 $g_bg_yellow><i>This Function will be a condition for the 
     rule.</i></td>
  <td><strong>Category:</strong></td>
  <td>$cfc</td>
 </tr>
 <tr>
  <td><strong>${cond_function_label}:</strong></td>
  <td>$fcn</td>
 </tr>";
#print "<tr>
#  <td $g_bg_yellow><i>What object type will we find<br>
#             in the condition authorization/role?</i></td>
#  <td>${g_red_star}<strong>Condition<br>&nbsp;&nbsp;Object Type:</td>
#  <td>$co_types</strong></td>
# </tr>";
my $cond_qual_code_text;
if ($rt eq '2a') {
  $cond_qual_code_text = 
  "What specific object will we find in the authorization/role that will 
   trigger an implied authorization?  (Must match exactly.)";
}
elsif ($rt eq '2b') {
  $cond_qual_code_text = 
  "What object will we find in the authorization/role that will 
   trigger an implied authorization?  (Does not need to match exactly - 
   found object may be a child of this specified object)";
}
print 
 "<tr>
  <td $g_bg_yellow><i>$cond_qual_code_text</td>
  <td>$g_red_star<strong>Object Code:</strong></td>
  <td>$cqc_list";

 my $qualifier_type = 
    &get_qual_type_for_function($lda, $cfc, $fcn);

 print "<a href=\"${show_qual_stem}$qualifier_type\" 
         target=\"new\">Show&nbsp;Qualifiers...</a>";

print "</td> 
 </tr>";


 #### Need to allow for a text field and "show qualifiers" window for
 #### qualifier types that would allow more than 1000 possible qualifiers.
 #print "<input type=\"button\" 
 #   onclick=\"window.location=\'$show_qual_stem\'\" 
 #   value=\"Show Qualifiers\">";

 print 
 "<tr>
    <td align=center colspan=3 $g_bg_green><big><b>...then</b></big>
                                 <br><i>(result)</i></td></tr>
   </tr>
  <tr>
    <td rowspan=2 $g_bg_green><i>This is the Function we will create<br>
          implied authorizations for.</i></td>
    <td><strong>Category:</strong></td>
    <td>$rfc</td>
  </tr>
  <tr>
   <td><strong>Result Function:</strong></td><td>$frn</td>
   <input type=\"hidden\" name=\"rfn\" value=\"$rfn\">
  </tr>";
#print "<tr>
#   <td $g_bg_green><i>What will be the object type of the qualifier
#                       when we create an implied authorization?</i></td>
#   <td>$g_red_star<strong>Result<br>&nbsp;&nbsp;Object Type:</td>
#   <td>$rq_types</strong></td> 
#  </tr>";
print "<tr>
   <td $g_bg_green><i>What will be the qualifier when we create an
                      implied authorization?</i></td>
   <td>$g_red_star<strong>Qualifier<br>&nbsp;&nbsp;Code:</strong></td>
   <td>$rqc_list";

 $qualifier_type = 
    &get_qual_type_for_function($lda, $rfc, $frn);
 print "<a href=\"${show_qual_stem}$qualifier_type\" 
         target=\"new\">Show&nbsp;Qualifiers...</a>";

print "</td> 
  </tr>";

 #print "<!--strong>
 #  <input type=\"button\" style=\"font: bold 17px Courrier\" 
 #  onclick=\"window.location=\'https://rolesweb-test.mit.edu/qual_branch1.html\'\" value=\"Show Qualifiers\">
 #</strong-->";

 print 
   "</table>";
 print "<p />
        <input  type=\"submit\" value=\"Create New Rule\">
    </form>
    <hr/>";

  print "<form><input type=\"button\" value=\"Previous Step\" onclick=\"history\.go(-1)\;return false\;\" /></form>","\n";  
}
################# End of 2nd pass #########################
################# Begin 1st pass ##########################
else {

 if ($error_message) {
     print "<br><font color=red><b>$error_message</b></font><p />";
 }
  
 print "<p /><hr />";
     print $step_instructions,"<br>";

  print "<strong>Fill out the Condition Function and Result Function
                 fields (red asterisk ($g_red_star)) and click the
                 \"$g_next_step_label\" button.<p />";
  print "<form method=\"post\">";
  print "<input type=\"hidden\" name=\"rt\" value=$rt>";
  print "<input type=\"hidden\" name=\"FORM_LEVEL\" value=\"1\">";

  print "<p /><table frame>
    <tr><td align=center colspan=3 $g_bg_yellow><big><b>If...</b></big>
                               <br><i>(condition)</i></td></tr>
    <tr>
      <td $g_bg_yellow><i>What Function will be a condition<br>
             for an implied Authorization?</i></td>
      <td>$g_red_star<strong>Condition function:</strong></td> 
      <td>$fc_list &nbsp; 
          <a class=info href=#><i>Explain...</i>
          <span>The pull-down list shows functions 
                and groups that you can choose as a Condition for
                an implied authorization.<br>
                Each entry shows 3 items separated by a colon:<br>
                &nbsp;&nbsp;(1) F or G - function or function-group,<br>
                &nbsp;&nbsp;(2) function category,<br>
                &nbsp;&nbsp;(3) function or function-group name.
          </span>
          </a>
      </td>
    </tr> 
    <tr><td align=center colspan=3 $g_bg_green><big><b>...then</b></big>
                               <br><i>(result)</i></td></tr>
    <tr>
      <td $g_bg_green><i>What do you want to create<br>
          implied authorizations for?</i></td>
      <td>$g_red_star<strong>Result function:</strong></td>
      <td>$fr_list &nbsp; 
          <a class=info href=#><i>Explain...</i>
          <span>The pull-down list shows functions 
                that you are authorized to choose as a Result function
                for implied authorizations.<br>
                Each entry shows 3 items separated by a colon:<br>
                &nbsp;&nbsp;(1) F or G - function or function-group,<br>
                &nbsp;&nbsp;(2) function category,<br>
                &nbsp;&nbsp;(3) function or function-group name.
          </span>
          </a>
      </td>
    </tr>
   </table>";
  print "<p />";
  print "<input type=\"submit\" value=\"$g_next_step_label\">";
  print "</FORM><hr/>";
  print "<form><input type=\"button\" value=\"Previous Step \" onclick=\"history\.go(-1)\;return false\;\" /></form>","\n";  
}
######################## End 1st pass ###################################

#chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
#print "End of program ($time)<br>";
print "</body></html>", "\n";
exit(0);

#----------------------------  SUBROUTINES -----------------------------------#
##############################################################
# Subroutine get_qual_code_list($lda,$qtl,$name)
# Returns HTML fragment with <select> list of qualifier codes. 
##############################################################
sub get_qual_code_list {
    my ($lda,$qtl,$name) = @_;
    #if ($qtl == '()'){$qtl = '(\' \')'}; 
## debug
    #print " LDA: ",$lda," QTL: ".$qtl," NAME: ",$name;
    my $csr1;
### NOTE: here we hard-code an additional restriction on qualifier types !!###
   my $stmt = 
        "select qualifier_code, qualifier_name from qualifier 
         where (qualifier_type <> 'DEPT' or substr(qualifier_code,1,2) = 'D_') 
         and qualifier_type in 
         (select distinct parent_qualifier_type
          from qualifier_subtype where qualifier_subtype_code in $qtl)
         order by qualifier_code";
   #print "stmt='$stmt'<BR>";
   unless ($csr1=$lda->prepare($stmt)){
	print "Error preparing select statement get_qual_code_list: " . $DBI::errstr . "<br>";
    }
  unless ($csr1->execute) {
      print "Error executing select statement: " . $DBI::errstr . "<br>";
  }
 ###------ get a <select> HTML list of qualifier codes ------###
    my $qual_code,$qual_name;
    my $select_list ="<select name=\"$name\">"; # start of an html fragment
    $select_list .= "<option selected>choose qualifier code\n";
    
    while ( ($qual_code,$qual_name) = $csr1->fetchrow_array ) {
    $select_list .= "<option \"value=\"$qual_code\">$qual_code - $qual_name</option>";
    }
    $select_list .= "</select>";
    return $select_list;
}

############################################################################
# Subroutine 
#  get_qual_type_for_function($lda, $category, $function_name)
# Returns the qualifier_type associated with the function or function group
############################################################################
sub get_qual_type_for_function {
    my ($lda, $category, $function_name) = @_;
    my $stmt = 
        "select qualifier_type from function2
           where function_category =  ?
           and function_name in (?, ?)
         union select qualifier_type from function_group
           where function_category = ? 
           and function_group_name = ?";
   #print "stmt='$stmt'<BR>";
   unless ($csr1=$lda->prepare($stmt)){
	print "Error preparing select statement qc: " . $DBI::errstr . "<br>";
   }
   unless ($csr1->bind_param(1, $category)) {
        print "Error binding param :fc1 " . $DBI::errstr . "<BR>";  
   }
   unless ($csr1->bind_param(2, $function_name)) {
        print "Error binding param :fc1 " . $DBI::errstr . "<BR>";  
   }
   my $star_function_name = "*" . $function_name;
   unless ($csr1->bind_param(3, $star_function_name)) {
        print "Error binding param :fc1 " . $DBI::errstr . "<BR>";  
   }
   unless ($csr1->bind_param(4, $category)) {
        print "Error binding param :fc1 " . $DBI::errstr . "<BR>";  
   }
   unless ($csr1->bind_param(5, $function_name)) {
        print "Error binding param :fc1 " . $DBI::errstr . "<BR>";  
   }
   unless ($csr1->execute) {
      print "Error executing select statement: " . $DBI::errstr . "<br>";
   }
   
  my ($qualifier_type) = $csr1->fetchrow_array;
  return $qualifier_type;

}

###################################################################################################
# Subroutine get_obj_type_lists($lda,$fn,$name)
# For rules 2a,2b this subroutine restricted by function name list ($fn) returns:
# - reference to an array of object types (qualifier types)
# - HTML fragment with <select> list of object types
# - comma-separated list of object types convenient for usage in select statements
###################################################################################################
sub get_obj_type_lists {
    my ($lda,$fn,$name) = @_;
    my  $csr1 ;
    
  #  print $fn;
    unless (substr($fn,0,1) eq '(')
    {
	$fn = '('.$fn.')';
    }
    #print $fn;
    
    my  $stmt = "select distinct qualifier_subtype_code, qualifier_subtype_name from qualifier_subtype qs,function2 f2, function_group fg 
where (qs.parent_qualifier_type=f2.qualifier_type and (REPLACE(f2.function_name,'*','') in $fn)) 
or (qs.parent_qualifier_type=fg.qualifier_type and fg.function_group_name in $fn)";    
    
    #print "stmt:'$stmt'";
 unless ($csr1=$lda->prepare($stmt)){
	print "Error preparing select statement get_obj_type_lists: " . $DBI::errstr . "<br>";
    }
  unless ($csr1->execute) {
      print "Error executing select statement: " . $DBI::errstr . "<br>";
  }

  #########################################################
  #  Get 2 lists and one array of qualifier types
  #########################################################
  
    my $qual_type,$qual_type_name;  
    my @qualist = (); #an array of qualifier types 

    my $qlist = '('; #start of comma-separated list of qaulifiers
    my $first_time =1;
    my $select_list ="<select name=\"$name\">"; # start of an html fragment
    $select_list .= "<option selected>choose object type\n";
    
    while ( ($qual_type,$qual_type_name) = $csr1->fetchrow_array ) {
      push(@qualist,$qual_type);
      if ($first_time) {$qlist .= "'$qual_type'";$first_time = 0;}
      else {$qlist .= ",'$qual_type'";}
      $select_list .= "<option \"value=\"$qual_type\">$qual_type - $qual_type_name</option>";
  }
  $select_list .= "</select>";
    $qlist .= ')';

if ($qlist eq '()'){$qlist = '(\'\')'};

##debug    

#print "Here are qualifier types comma-separated list:",$qlist,"<br>";
    
return $select_list,\@qualist ,$qlist;

} # End of subroutine get_obj_type_lists

###########################################################################
#  Subroutine get_function_list_cond($lda,$delim, $name)
#  Returns a <select> list in "$FG$delim$category$delim$function_name" format.
###########################################################################
sub get_function_list_cond {
    my ($lda,$delim,$name) = @_;
    my ($csr1, $stmt);

  my $stmt = 
   "select 'F' as type , function_category as category , REPLACE(function_name, '*','') as name
    from external_function f
    -- from function2 f    
    where function_id not in 
      (select flp.function_id from function_load_pass flp
       where flp.function_id = f.function_id
       and pass_number = 2)
    union select 'G' as type, function_category as category , function_group_name as name
    from function_group 
    where IFNULL(matches_a_function, 'N') = 'N'
    order by category,type, name";
  #print "stmt 1 = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 1a: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement 1a: " . $DBI::errstr . "<BR>";
  }

 #
 #  Get 2 lists: select list of functions and comma-separated list
 #
  my $func_or_group, $function_name;
    my $sql_list = '('; #start of comma-separated list of functions
    my $first_time=1;
    my $select_list = "<select name=\"$name\">";
  $select_list .= "<option selected>$g_default_cond_function_row";
  while ( ($func_or_group, $cat, $function_name) = $csr1->fetchrow_array ) {
      if ($first_time){$sql_list .= "'$function_name'";$first_time =0;}
      else {$sql_list .=",'$function_name'";}
      $select_list .= "<option>$func_or_group$delim$cat$delim$function_name";
  }
    $sql_list .=')';
  $select_list .= "</select>";

  return $select_list, $sql_list;
}#end of subroutine get_function_list_cond

################################################################################################
#  Subroutine get_function_list_result($lda, \@categories, $delim, $name)
#  Return an HTML fragment containing a <select> list of items in "$fg$del$cat$del$name" format.
################################################################################################
sub get_function_list_result {
    my ($lda, $rcategories,$delim,$user,$name) = @_;
    
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
   "select 'F', function_category, REPLACE(function_name, '*','')
    from external_function f
    where function_category in $catlist
      and function_id not in 
      (select flp.function_id from function_load_pass flp
       where flp.function_id = f.function_id
       and pass_number = 1)
    order by function_category,function_name";
  #print "stmt 1 = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 1b: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement 1b: " . $DBI::errstr . "<BR>";
  }

 #
 #  Get 2 lists of functions: <select> list and  comma-separated list for sql 
 #
  my $func_or_group, $function_name;
    my $sql_list= '('; #start of comma-separated list of functions
    my $first_time = 1;
  my $select_list ="<select name=\"$name\">";
  $select_list .= "<option selected>choose a function\n";
  
    while ( ($func_or_group, $cat, $function_name) = $csr1->fetchrow_array ) {
   $select_list .= "<option \"value=\"$func_or_group$delim$cat$delim$function_name\">$func_or_group$delim$cat$delim$function_name</option>";
   if ($first_time){$sql_list .= "'$function_name'";$first_time = 0;}
   else {$sql_list .=",'$function_name'";}    
#$select_list .= "<option value=\"$function_name\">$cat</option><br/>";
  }
  $select_list .= "</select>";
    $sql_list .= ')';
    #$select_list .= "</input>";
 #$sel_list = "<select name=\"Vova\"><option value=\"bla\">bla1<option value=\"bla2\">bla2</select>";
#return $sel_list;
  #print 'select_list:' . $select_list;
  #print 'sql_list:' . $sql_list;
  return $select_list, $sql_list;
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
   "select 'F' as type , function_category as category, REPLACE(function_name, '*','') as name
    from external_function f
    where function_category in $catlist
      and function_id not in 
      (select flp.function_id from function_load_pass flp
       where flp.function_id = f.function_id
       and pass_number = 2)
and qualifier_type in (select parent_qualifier_type from qualifier_subtype where qualifier_subtype_code in $qualist)
    union select 'G' as type, function_category as category, function_group_nameas name
    from function_group 
    where function_category in $catlist
    and IFNULL(matches_a_function, 'N') = 'N'
and qualifier_type in (select parent_qualifier_type from qualifier_subtype where qualifier_subtype_code in $qualist) 
    order by category, type, name";
  #print "stmt 1 = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 1c: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement 1c: " . $DBI::errstr . "<BR>";
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

  return $select_list;
}


