#!/usr/bin/perl
###########################################################################
#
#  CGI script to demonstrate how implied authorization rules will look
#  and how they can be created
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
#  Written by Jim Repa, 2/11/2008
#  Modified 5/28/2008
#  Modified by Vlad Sluchak on 07/14/2008 - added "edit" and "insert" links. 
#  Modified by Jim Repa 8/2008. Fix bugs
############################################################################
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
use imprule('get_user_categories'); #Use sub get_user_categories
use imprule('get_rule_type_hashes'); #Use sub get_rule_type_hashes

#
#  Print out the first line of the document
#
 print "Content-type: text/html", "\n\n";

#
#  Set some constants
#
 $g_gray_bg = "bgcolor=\"#E0E0E0\"";
 $g_not_prefix = "<i>NOT IN EFFECT:</i>";

#
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


#
#  Process form information
#
 $request_method = $ENV{'REQUEST_METHOD'};
 if ($request_method eq "GET") {
   $input_string = $ENV{'QUERY_STRING'};
 } 
 elsif ($request_method eq "POST") {
   read (STDIN, $input_string, $ENV{'CONTENT_LENGTH'});  # Read input string
 }
 else {
   $input_string = '';  # Error condition 
 }
 #$input_string = $ARGV[0];
 %formval = ();  # Hash of reformatted key->variables populated by &parse_forms
 %rawval = ();  # Hash of unformatted key->variables populated by &parse_forms
 &parse_forms($input_string, \%formval, \%rawval); # Call sub. to parse input

#
# Get specific form variables
#
 $g_lookup_number = $formval{'lookup_number'};
 $g_kerbname = $formval{'kerbname'};
 $g_function_name = $formval{'function_name'};
 $g_qualcode = $formval{'qualcode'};
 $g_show_nodes = $formval{'show_nodes'};
 $g_expand_qual = $formval{'expand_qual'};

#
#  Get set to use Oracle.
#
use DBI;
#use Oraperl;  # Point to library of Oracle-related subroutines for Perl

#
#  Other constants
#
 $g_start_gray = "<font color=\"gray\">";
 $g_end_gray = "</font>";
 $g_bg_yellow = "bgcolor=\"#FFFF88\"";
 $g_bg_green = "bgcolor=\"#88FF88\"";
 chomp ($today = `date "+%m/%d/%Y"`);
 $g_new_rule_label = "[add a new rule]";
 $g_edit_label = "[edit]";

#
#  Report names
#
 %g_report_code_name = 
  ('1' => "Show implied authorization rules",
   );


#
# Login into the database
# 
 $lda = &login_dbi_sql('roles') 
      || die $DBI::errstr . "<BR>";

#
#  Checking meta-authorization to view all authorizations.
#  If we do not need authorization checks - turn them off with (1 == 0 ).
#
if (1 == 0) {  
#-- debug
   print "Authorizations Verification is on!","<br>";
 if (!(&verify_special_report_auth($lda, $k_principal, 'LIBP'))) {
   print "Sorry.  You do not have the required perMIT system authorization to ",
   "view authorizations in category LIBP. (Your username is '$k_principal')";
   exit();
 }
}

#
# Get hash of categories accessible by current user for rules creation
#
 my %categories;
  
&get_user_categories($lda,$k_principal,\%categories);

my $count_categories = scalar keys %categories;

########local debug 1

#$count_categories = 0;
  
#if ($count_categories) {print "Categories hash has ",$count_categories," entries","<br>";};
  
#foreach $key (sort keys %categories) {
 #     print "$key -> $categories{$key}<br>\n";
 # }

### end local debug

#######################
#  Web stem constants
#######################
 
 $host = $ENV{'HTTP_HOST'};
 #$main_url = "https://$host/webroles.html";
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 #$url_stem = "https://$host/cgi-bin/$progname?";  # URL for subtree view


($mysubdir=$0) =~ s/^\S*cgi-bin// ; 
$mysubdir =~ s!/?[^/]*/*$!!; #remove basename
$url_stem = "https://$host/cgi-bin$mysubdir"; #implied rules url sub-directory 

## debug
#print "Host: ",$host,"<br>";
#print "Full path: ",$0,"<br>";
#print "Program name: ",$progname,"<br>";
#print "mysubdir: ",$mysubdir,"<br>";
#print "URL stem: ",$url_stem,"<br>";


#
#  Print out the http document header
#
 print "<HTML>", "\n";

#
#  Run the appropriate report:
#
 
 &report_1($lda);
 
 
 $lda->disconnect;
 print "</HTML>\n";
 exit();

###########################################################################
#  Report 1.
#  Listing of existing implied authorization rules with access to  
#  editing and creating new rules.
###########################################################################
sub report_1 {
  my ($lda) = @_;

  $kerbname =~ tr/a-z/A-Z/;
  $function_name =~ tr/a-z/A-Z/;

 #
 #  Print the document header
 #
  my $doc_title = $g_report_code_name{'1'};
  print "<HEAD>"
   . "<TITLE>$doc_title</TITLE></HEAD>", "\n";
  print '<BODY bgcolor="#fafafa">';
  &print_header ($doc_title, 'https');
  print "<p /><hr /><p />"; 

 #
 #  Get two hashes mapping rule type codes to their names and descriptions.
 #
  my %rule_code2name, %rule_code2desc;
  &get_rule_type_hashes($lda, \%rule_code2name, \%rule_code2desc);
  #foreach $key (sort keys %rule_code2name) {
  #    print "$key -> $rule_code2name{$key} .. $rule_code2desc{$key}<br>\n";
  #}

 #
 #  Get counts of each rule type.
 #
  my %rule_type_count;
  &get_rule_count_hash($lda, \%rule_type_count);

 #
 #  Open a select statement
 #
    # and iar.rule_is_in_effect = 'Y'
  my $stmt1 = 
 "select iar.rule_id, iar.rule_type_code, iar.rule_short_name,iar.rule_description, 
     iar.condition_function_or_group, 
     iar.condition_function_category, iar.condition_function_name,
     iar.condition_obj_type, iar.condition_qual_code,
     iar.result_function_category, iar.result_function_name,
     iar.auth_parent_obj_type, iar.result_qualifier_code,
     iar.rule_is_in_effect
    from implied_auth_rule iar
    where iar.rule_type_code = ?
    order by  iar.rule_type_code,  iar.rule_id";
  #print "stmt 1 = '$stmt1'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt1)) {
      print "Error preparing select statement 1: " . $DBI::errstr . "<BR>";
  }
  my $limit_rule_type_code;

 #
 #  Bind a variable for rule_type_code = '1a'
 #
  $limit_rule_type_code = '1a';
  unless ($csr1->bind_param(1, $limit_rule_type_code)) {
        print "Error binding param 1-1: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 1: " . $DBI::errstr . "<BR>";
  }

 #
 #  Print a header for rule type 1a.
 #
  my $rows_in_table = $rule_type_count{$limit_rule_type_code} + 2;
  my ($rule_type_name, $len_string);
  $rule_type_name = $rule_code2name{$limit_rule_type_code};
  if ($rule_type_name =~ /^$limit_rule_type_code/) {
      $len_string = length($limit_rule_type_code) + 2;
      $rule_type_name = substr($rule_type_name, $len_string);
  }
  print "<h3>$rule_code2name{$limit_rule_type_code}</h3><p />\n";
  print "<i>$rule_code2desc{$limit_rule_type_code}</i><p />\n";
  print "<form>\n";
  print "<table border>\n";

  my $total_span = 13;
  print "<tr><th colspan=$total_span>$rule_type_name";
 
  if ($count_categories) {
    print " <A href=\"$url_stem\/imprule1.cgi?rt=$limit_rule_type_code\">$g_new_rule_label</A>"
  };

print "</th>"
      . "</tr>"
      . "<tr><th rowspan=2>Rule<br>ID</th>"
      . "<th rowspan=2>Rule name</th>"
      . "<td $g_bg_yellow rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_yellow colspan=4 align=center><big><b>If...</b></big><br>"
      . "<i>(condition)</i></td>"
      . "<td $g_bg_yellow rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_green rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_green colspan=2 align=center><big><b>...then</b></big>"
      . "<br><i>(result)</i></td>"
      . "<td $g_bg_green rowspan=$rows_in_table>&nbsp;</td>"
      . "</tr>"
      . "<tr><th $g_bg_yellow>Func<br>or<br>grp</th>"
      . "<th $g_bg_yellow>Cat-<br>egory</th>"
      . "<th $g_bg_yellow>Function</th>"
      . "<th $g_bg_yellow>Obj<br>type</th>"
      . "<th $g_bg_green>Cat-<br>egory</th>"
      . "<th $g_bg_green>Function</th>"
      . "</tr>\n";

 #
 #  Get results from the SELECT statement
 #
  my ($rule_id, $rule_type_code, $rule_short_name,$rule_description, $function_or_group,
      $cond_cat, $cond_func, $cond_obj_type_code, $cond_qualcode,
      $result_cat, $result_func, $result_obj_type_code, $result_qualcode,
      $is_in_effect);
  while 
   ( ($rule_id, $rule_type_code, $rule_short_name, $rule_description, $function_or_group,
      $cond_cat, $cond_func, $cond_obj_type_code, $cond_qualcode,
      $result_cat, $result_func, $result_obj_type_code, $result_qualcode,
      $is_in_effect)
      = $csr1->fetchrow_array )
  {
    my $bgcolor = ($is_in_effect eq 'N') ? " $g_gray_bg" : "";
    my $temp_rule_name = ($is_in_effect eq 'N') 
         ? "$g_not_prefix $rule_short_name" : $rule_short_name;
    print "<tr $bgcolor><td>$rule_id";
    #stripping blanks
    $result_cat =~ s/^\s+//;
    $result_cat =~ s/\s+$//;    
    #local debug
    #print "rule_id=$rule_id, result_cat='$result_cat' -> '" . 
    #      $categories{$result_cat} . "'<BR>";
    if ($categories{$result_cat}) {
	#print "Category: " . $result_cat;
	print " <A href=\"$url_stem/upd_imprule0.cgi\?rid_in=$rule_id\">$g_edit_label</A>";
    }
    print"</td>";
    print "<td>$temp_rule_name</td><td>$function_or_group</td>"
        . "<td>$cond_cat</td><td>$cond_func</td><td>$cond_obj_type_code</td>"
        . "<td>$result_cat</td><td>$result_func</td>"
        . "</tr>\n";
  }
 
  unless ($rule_type_count{$limit_rule_type_code}) {
    print "<tr><td align=center colspan=$total_span>"
        . "There are currently no defined rules of this type."
	. "</td></tr>";
  }
  print "</table>\n";
  print "<p /><hr /><p />\n";
  print "</form>\n";

 #
 #  Bind a variable for rule_type_code = '1b'
 #
  $limit_rule_type_code = '1b';
  unless ($csr1->bind_param(1, $limit_rule_type_code)) {
        print "Error binding param 1-1: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 1: " . $DBI::errstr . "<BR>";
  }

 #
 #  Print a header for rule type 1b.
 #
  $rows_in_table = $rule_type_count{$limit_rule_type_code} + 2;
  $rule_type_name = $rule_code2name{$limit_rule_type_code};
  if ($rule_type_name =~ /^$limit_rule_type_code/) {
      $len_string = length($limit_rule_type_code) + 2;
      $rule_type_name = substr($rule_type_name, $len_string);
  }
  print "<h3>$rule_code2name{$limit_rule_type_code}</h3><p />\n";
  print "<i>$rule_code2desc{$limit_rule_type_code}</i><p />\n";
  print "<table border>\n";

  $total_span = 13;
  print "<tr><th colspan=$total_span>$rule_type_name";
  if ($count_categories) {
    print " <a href=\"$url_stem/imprule1.cgi?rt=$limit_rule_type_code\">"
         . "$g_new_rule_label</a>";
  }
  print "</th>"
      . "</tr>"
      . "<tr><th rowspan=2>Rule<br>ID</th>"
      . "<th rowspan=2>Rule name</th>"
      . "<td $g_bg_yellow rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_yellow colspan=4 align=center><big><b>If...</b></big><br>"
      . "<i>(condition)</i></td>"
      . "<td $g_bg_yellow rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_green rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_green colspan=3 align=center><big><b>...then</b></big>"
      . "<br><i>(result)</i></td>"
      . "<td $g_bg_green rowspan=$rows_in_table>&nbsp;</td>"
      . "</tr>"
      . "<tr><th $g_bg_yellow>Func<br>or<br>grp</th>"
      . "<th $g_bg_yellow>Cat-<br>egory</th>"
      . "<th $g_bg_yellow>Function</th>"
      . "<th $g_bg_yellow>Obj<br>type</th>"
      . "<th $g_bg_green>Cat-<br>egory</th>"
      . "<th $g_bg_green>Function</th>"
      . "<th $g_bg_green>Obj<br>type</th>"
      . "</tr>\n";

 #
 #  Get results from the SELECT statement
 #
  while 
   ( ($rule_id, $rule_type_code, $rule_short_name, $rule_description, 
      $function_or_group,
      $cond_cat, $cond_func, $cond_obj_type_code, $cond_qualcode,
      $result_cat, $result_func, $result_obj_type_code, $result_qualcode,
      $is_in_effect)
      = $csr1->fetchrow_array )
  {
    my $bgcolor = ($is_in_effect eq 'N') ? " $g_gray_bg" : "";
    my $temp_rule_name = ($is_in_effect eq 'N') 
         ? "$g_not_prefix $rule_short_name" : $rule_short_name;
    print "<tr $bgcolor><td>$rule_id";
    #stripping blanks
    $result_cat =~ s/^\s+//;
    $result_cat =~ s/\s+$//;    
    if ($categories{$result_cat}) {
	#print "Category: " . $result_cat;
	print " <A href=\"$url_stem/upd_imprule0.cgi\?rid_in=$rule_id\">$g_edit_label</A>";
    }
    print "</td>";
    print "<td>$temp_rule_name</td><td>$function_or_group</td>"
        . "<td>$cond_cat</td><td>$cond_func</td><td>$cond_obj_type_code</td>"
        . "<td>$result_cat</td><td>$result_func</td>"
        . "<td>$result_obj_type_code</td>"
        . "</tr>\n";
  }
  unless ($rule_type_count{$limit_rule_type_code}) {
    print "<tr><td align=center colspan=$total_span>"
        . "There are currently no defined rules of this type."
	. "</td></tr>";
  }
  print "</table><p /><hr /><p />\n";

 #
 #  Bind a variable for rule_type_code = '2a'
 #
  $limit_rule_type_code = '2a';
  unless ($csr1->bind_param(1, $limit_rule_type_code)) {
        print "Error binding param 1-1: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 1: " . $DBI::errstr . "<BR>";
  }

 #
 #  Print a header for rule type 2a. 
 #
  $rows_in_table = $rule_type_count{$limit_rule_type_code} + 2;
  $rule_type_name = $rule_code2name{$limit_rule_type_code};
  if ($rule_type_name =~ /^$limit_rule_type_code/) {
      $len_string = length($limit_rule_type_code) + 2;
      $rule_type_name = substr($rule_type_name, $len_string);
  }
  print "<h3>$rule_code2name{$limit_rule_type_code}</h3><p />\n";
  print "<i>$rule_code2desc{$limit_rule_type_code}</i><p />\n";
  print "<table border>\n";
  $total_span = 15;
  print "<tr><th colspan=$total_span>$rule_type_name";
  if ($count_categories) {
    print " <a href=\"$url_stem/imprule2.cgi?rt=$limit_rule_type_code\">"
         . "$g_new_rule_label</a>";
  }
  print "</tr>"
      . "<tr><th rowspan=2>Rule<br>ID</th>"
      . "<th rowspan=2>Rule name</th>"
      . "<td $g_bg_yellow rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_yellow colspan=5 align=center><big><b>If...</b></big><br>"
      . "<i>(condition)</i></td>"
      . "<td $g_bg_yellow rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_green rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_green colspan=4 align=center><big><b>...then</b></big>"
      . "<br><i>(result)</i></td>"
      . "<td $g_bg_green rowspan=$rows_in_table>&nbsp;</td>"
      . "</tr>"
      . "<tr><th $g_bg_yellow>Func<br>or<br>grp</th>"
      . "<th $g_bg_yellow>Cat-<br>egory</th>"
      . "<th $g_bg_yellow>Function</th>"
      . "<th $g_bg_yellow>Obj<br>type</th>"
      . "<th $g_bg_yellow>Obj<br>code</th>"
      . "<th $g_bg_green>Cat-<br>egory</th>"
      . "<th $g_bg_green>Function</th>"
      . "<th $g_bg_green>Obj<br>type</th>"
      . "<th $g_bg_green>Obj<br>code</th>"
      . "</tr>\n";

 #
 #  Get results from the SELECT statement
 #
  while 
   ( ($rule_id, $rule_type_code, $rule_short_name, $rule_description, $function_or_group,
      $cond_cat, $cond_func, $cond_obj_type_code, $cond_qualcode,
      $result_cat, $result_func, $result_obj_type_code, $result_qualcode,
      $is_in_effect)
      = $csr1->fetchrow_array )
  {
    grep(defined || ($_ = '&nbsp;'), 
	 $cond_qualcode, $result_qualcode);
    my $bgcolor = ($is_in_effect eq 'N') ? " $g_gray_bg" : "";
    my $temp_rule_name = ($is_in_effect eq 'N') 
         ? "$g_not_prefix $rule_short_name" : $rule_short_name;
    print "<tr $bgcolor><td>$rule_id";
#stripping blanks
$result_cat =~ s/^\s+//;
$result_cat =~ s/\s+$//;    
#local debug
#print "rule_id=$rule_id, result_cat='$result_cat' -> '" . $categories{$result_cat} . "'<BR>";
    if ($categories{$result_cat}) {
	#print "Category: " . $result_cat;
	print " <A href=\"$url_stem/upd_imprule0.cgi\?rid_in=$rule_id\">$g_edit_label</A>";
    }
    print"</td>";
        print "<td>$temp_rule_name</td><td>$function_or_group</td>"
        . "<td>$cond_cat</td><td>$cond_func</td>"
        . "<td>$cond_obj_type_code</td><td>$cond_qualcode</td>"
        . "<td>$result_cat</td><td>$result_func</td>"
        . "<td>$result_obj_type_code</td><td>$result_qualcode</td>"
        . "</tr>\n";
  }
 
  unless ($rule_type_count{$limit_rule_type_code}) {
     print "<tr><td align=center colspan=$total_span>"
         . "There are currently no defined rules of this type."
 	. "</td></tr>";
  }
  print "</table><p /><hr /><p />\n";

 #
 #  Bind a variable for rule_type_code = '2b'
 #
  $limit_rule_type_code = '2b';
  unless ($csr1->bind_param(1, $limit_rule_type_code)) {
        print "Error binding param 1-1: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 1: " . $DBI::errstr . "<BR>";
  }

 #
 #  Print a header for rule type 2b.
 #
  $rows_in_table = $rule_type_count{$limit_rule_type_code} + 3;
  $rule_type_name = $rule_code2name{$limit_rule_type_code};
  if ($rule_type_name =~ /^$limit_rule_type_code/) {
      $len_string = length($limit_rule_type_code) + 2;
      $rule_type_name = substr($rule_type_name, $len_string);
  }
  print "<h3>$rule_code2name{$limit_rule_type_code}</h3><p />\n";
  print "<i>$rule_code2desc{$limit_rule_type_code}</i><p />\n";
  print "<table border>\n";
  $total_span = 15;
  print "<tr><th colspan=$total_span>$rule_type_name";
  if ($count_categories) {
    print " <a href=\"$url_stem/imprule2.cgi?rt=$limit_rule_type_code\">"
         . "$g_new_rule_label</a>";
  }
  print "</tr>"
      . "<tr><th rowspan=2>Rule<br>ID</th>"
      . "<th rowspan=2>Rule name</th>"
      . "<td $g_bg_yellow rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_yellow colspan=5 align=center><big><b>If...</b></big><br>"
      . "<i>(condition)</i></td>"
      . "<td $g_bg_yellow rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_green rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_green colspan=4 align=center><big><b>...then</b></big>"
      . "<br><i>(result)</i></td>"
      . "<td $g_bg_green rowspan=$rows_in_table>&nbsp;</td>"
      . "</tr>"
      . "<tr><th $g_bg_yellow>Func<br>or<br>grp</th>"
      . "<th $g_bg_yellow>Cond<br>cat-<br>egory</th>"
      . "<th $g_bg_yellow>Cond<br>Function</th>"
      . "<th $g_bg_yellow>Cond<br>obj<br>type</th>"
      . "<th $g_bg_yellow>Cond<br>obj<br>code</th>"
      . "<th $g_bg_green>Result<br>cat-<br>egory</th>"
      . "<th $g_bg_green>Result<br>function</th>"
      . "<th $g_bg_green>Result<br>obj<br>type</th>"
      . "<th $g_bg_green>Result<br>obj<br>code</th>"
      . "</tr>\n";

 #
 #  Get results from the SELECT statement
 #
  while 
   ( ($rule_id, $rule_type_code, $rule_short_name, $rule_description, $function_or_group,
      $cond_cat, $cond_func, $cond_obj_type_code, $cond_qualcode,
      $result_cat, $result_func, $result_obj_type_code, $result_qualcode,
      $is_in_effect)
      = $csr1->fetchrow_array )
  {
    grep(defined || ($_ = '&nbsp;'), 
	 $cond_qualcode, $result_qualcode);
    my $bgcolor = ($is_in_effect eq 'N') ? " $g_gray_bg" : "";
    my $temp_rule_name = ($is_in_effect eq 'N') 
         ? "$g_not_prefix $rule_short_name" : $rule_short_name;
    print "<tr $bgcolor><td>$rule_id";
#stripping blanks
$result_cat =~ s/^\s+//;
$result_cat =~ s/\s+$//;    
#local debug
#print "rule_id=$rule_id, result_cat='$result_cat' -> '" . $categories{$result_cat} . "'<BR>";
    if ($categories{$result_cat}) {
	#print "Category: " . $result_cat;
	print " <A href=\"$url_stem/upd_imprule0.cgi\?rid_in=$rule_id\">$g_edit_label</A>";
    }
    print"</td>";       
 print "<td>$temp_rule_name</td><td>$function_or_group</td>"
        . "<td>$cond_cat</td><td>$cond_func</td>"
        . "<td>$cond_obj_type_code</td><td>$cond_qualcode</td>"
        . "<td>$result_cat</td><td>$result_func</td>"
        . "<td>$result_obj_type_code</td><td>$result_qualcode</td>"
        . "</tr>\n";
  }
  unless ($rule_type_count{$limit_rule_type_code}) {
    print "<tr><td align=center colspan=$total_span>"
        . "There are currently no defined rules of this type."
	. "</td></tr>";
  }
  print "</table><p /><hr /><p />\n";

}

###########################################################################
#
#  Subroutine get_rule_count_hash($lda, \%rule_type_count)
#
#  Return a hash
#   %rule_type_count maps a rule_type to the number of rules found
#
###########################################################################
sub get_rule_count_hash {
    my ($lda, $rrule_type_count) = @_;
    my ($csr, $stmt);
    $stmt = "select rule_type_code, count(*) 
             from implied_auth_rule
             group by rule_type_code";
#    $csr = &ora_open($lda, $stmt)
#        || die $ora_errstr;
     $csr = $lda->prepare("$stmt")
        || die $DBI::errstr;

    unless ($csr->execute) {
      print "Error executing select statement 1: " . $DBI::errstr . "<BR>";
    }

    my ($rule_code, $count);

    while ((($rule_code, $count)
         = $csr->fetchrow_array()))
    {
	$$rrule_type_count{$rule_code} = $count;
    }
    $csr->finish();
}

###########################################################################
#
#  Subroutine get_function_list_cond($lda, \@categories, $delim, $name)
#
#  Return an HTML fragment containing a <select> array of items of format 
#      "$category$delim$function_or_group$delim$function_name"
#
###########################################################################
sub get_function_list_cond {
    my ($lda, $rcategories, $delim) = @_;
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
   #ltrim(function_name,'*')
   "select 'F', function_category, replace(function_name, '*','') 
    from external_function f
    where function_category in $catlist
      and function_id not in 
      (select flp.function_id from function_load_pass flp
       where flp.function_id = f.function_id
       and pass_number = 2)
    union select 'G', function_category, function_group_name
    from function_group 
    where function_category in $catlist
    and IFNULL(matches_a_function, 'N') = 'N'
    order by function_category,function_name"; # order by 2 ,1,3
  #print "stmt 1 = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 1: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement 1: " . $DBI::errstr . "<BR>";
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

###########################################################################
#
#  Subroutine get_function_list_result($lda, \@categories, $delim, $name)
#
#  Return an HTML fragment containing a <select> array of items of format 
#      "$category$delim$function_or_group$delim$function_name"
#
###########################################################################
sub get_function_list_result {
    my ($lda, $rcategories, $delim) = @_;
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
  # ltrim(function_name, '*')
   "select 'F', function_category, replace(function_name, '*','')
    from external_function f
    where function_category in $catlist
      and function_id not in 
      (select flp.function_id from function_load_pass flp
       where flp.function_id = f.function_id
       and pass_number = 1)
    order by  function_category, function_name";  # order by 2, 1, 3
  #print "stmt 1 = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 1: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement 1: " . $DBI::errstr . "<BR>";
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

###########################################################################
#
#  Subroutine get_qual_subtype_list($lda, \@qualtypes, $delim, $name)
#
#  Return an HTML fragment containing a <select> array of qualifier_subtype
#      codes
#
###########################################################################
sub get_qual_subtype_list {
    my ($lda, $rqualtypes, $delim) = @_;
    my ($csr1, $stmt);

  my $qualtype_list = '(';
  my $qtype;
  my $first_time = 1;
  foreach $qtype (@$rqualtypes) {
    if ($first_time) {
	$qualtype_list .= "'$qtype'";
        $first_time = 0;
    }
    else {
	$qualtype_list .= ", '$qtype'";
    }
  }
  $qualtype_list .= ')';

  my $stmt = 
   "select qualifier_subtype_code
    from qualifier_subtype
    where parent_qualifier_type in $qualtype_list
    order by qualifier_subtype_code";
  #print "stmt 1 = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 1: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement 1: " . $DBI::errstr . "<BR>";
  }

 #
 #  Get list of functions
 #
  my $qual_subtype;
  my $select_list = "<select name=\"$name\">";
  $select_list .= "<option selected>obj type?";
  while ( ($qual_subtype) = $csr1->fetchrow_array ) {
    $select_list .= "<option>$qual_subtype";
  }
  $select_list .= "</select>";

  return $select_list;
}

###########################################################################
#
#  Subroutine get_qualcode_list($lda, \@qualtypes, $delim, $name)
#
#  Return an HTML fragment containing a <select> array of qualifier
#      codes, with each item in the format "$qualtype:$qualcode"
#
###########################################################################
sub get_qualcode_list {
    my ($lda, $rqualtypes, $delim) = @_;
    my ($csr1, $stmt);

  my $qualtype_list = '(';
  my $qtype;
  my $first_time = 1;
  foreach $qtype (@$rqualtypes) {
    if ($first_time) {
	$qualtype_list .= "'$qtype'";
        $first_time = 0;
    }
    else {
	$qualtype_list .= ", '$qtype'";
    }
  }
  $qualtype_list .= ')';

  my $stmt = 
   "select qualifier_type, qualifier_code, qualifier_level
    from qualifier
    where qualifier_type in $qualtype_list
    and (qualifier_type <> 'DEPT' or substr(qualifier_code, 1, 2) = 'D_')
    order by qualifier_type, qualifier_level,qualifier_code"; # order by 1 , 3, 2
  #print "stmt 1 = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 1: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement 1: " . $DBI::errstr . "<BR>";
  }

 #
 #  Get list of qualifiers
 #
  my $qualtype, $qualcode;
  my $select_list = "<select name=\"$name\">";
  $select_list .= "<option selected>choose a qualifier";
  while ( ($qualtype, $qualcode) = $csr1->fetchrow_array ) {
    $select_list .= "<option>$qualtype$delim$qualcode";
  }
  $select_list .= "</select>";

  return $select_list;
}
