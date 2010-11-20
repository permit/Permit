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
#  Modified 8/20/2008 Formatting changes made 
#  Modified 9/16/2008 In Function_group list, allow for only one FG
#
###########################################################################
#
# Get packages
#
use rolesweb('login_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('login_dbi_sql');
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
#  Set some constants
#
 $g_gray_bg = "bgcolor=\"#E0E0E0\"";
 $g_not_prefix = "<i>NOT IN EFFECT:</i>";

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
 $g_function_group_name = $formval{'function_group_name'};

#
# Table of rule types
#
 # Put these into the database table
 %g_rule_type_name = ('1a', 'Simple transfer',
                      '1b', 'Expansion', 
                      '2a', 'Narrow mapping',
                      '2b', 'Broad mapping');
 $g_separator_color = "gray";

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

#
#  Report names
#
 %g_report_code_name = 
  ('0' => "Implied authorizations mock-up",
   '1' => "Show implied authorization rules",
   '2' => "Show function groups and their child functions",
  );


#
# Login into the database
# 
# $lda = &login_sql('roles') 
$lda = login_dbi_sql('roles') 
      || die $DBI::errstr . "<BR>";

#
#  Make sure the user has a meta-authorization to view all authorizations.
#  ***** We do not need any authorization checks for this mock-up. 
#  ***** Turn them off.
#
if (1 == 0) {  # Ignore the authorization check
 if (!(&verify_special_report_auth($lda, $k_principal, 'LIBP'))) {
   print "Sorry.  You do not have the required perMIT system authorization to ",
   "view authorizations in category LIBP. (Your username is '$k_principal')";
   exit();
 }
}

#
#  Web stem constants
#
 $host = $ENV{'HTTP_HOST'};
 $main_url = "https://$host/webroles.html";
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 $url_stem = "https://$host/cgi-bin/$progname?";  # URL for subtree view

#
#  Print out the http document header
#
 print "<HTML>", "\n";

#
#  Run the appropriate report:
#
 unless ($g_lookup_number) {$g_lookup_number = '0';}
 #print "lookup_number is '$g_lookup_number'<BR>";
 if ($g_lookup_number eq '0') {
   &report_1($lda);
 }
 elsif ($g_lookup_number eq '1') {
   &report_1($lda, $g_kerbname, $g_expand_qual);
 }
 elsif ($g_lookup_number eq '2') {
   &report_2($lda, $g_function_group_name);
 }

 $lda->disconnect;
 print "</HTML>\n";
 exit();

###########################################################################
#
#  Report 1.
#
#  Display the existing implied authorization rules along with 
#  a mock-up for creating new ones
#
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
    #and iar.rule_is_in_effect = 'Y'
  my $stmt1 = 
 "select iar.rule_id as ruleid, iar.rule_type_code as ruletypecode, iar.rule_short_name, 
     iar.condition_function_or_group, 
     iar.condition_function_category, iar.condition_function_name,
     iar.condition_obj_type, iar.condition_qual_code,
     iar.result_function_category, iar.result_function_name,
     iar.auth_parent_obj_type, iar.result_qualifier_code,
     iar.rule_is_in_effect
    from implied_auth_rule iar
    where iar.rule_type_code = ?
    order by ruletypecode, ruleid";
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
  my $rows_in_table = $rule_type_count{$limit_rule_type_code} + 3;
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
  print "<tr><th colspan=13>$rule_type_name</th>"
      . "</tr>"
      . "<tr><th rowspan=2>Rule<br>ID</th>"
      . "<th rowspan=2>Rule name</th>"
      . "<td $g_bg_yellow rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_yellow colspan=4 align=center><big><b>If...</b></big><br>"
      . "<i>(condition)</i></td>"
      #. "<td $g_bg_yellow colspan=4><i>Where a person has a role/relation"
      #. " for the function and object type shown below...</i></td>"
      . "<td $g_bg_yellow rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_green rowspan=$rows_in_table>&nbsp;</td>"
      #. "<td $g_bg_green colspan=2><i>...give the person an implied"
      #. " authorization for the function shown below"
      #. "(and the qualifier will be the object from role/relation on the"
      #. " left).</i></td>"
      . "<td $g_bg_green colspan=2 align=center><big><b>...then</b></big>"
      . "<br><i>(result)</i></td>"
      . "<td $g_bg_green rowspan=$rows_in_table>&nbsp;</td>"
      . "</tr>"
      . "<tr>"
      . "<th $g_bg_yellow>Func<br>or<br>grp</th>"
      . "<th $g_bg_yellow>Cat-<br>egory</th>"
      . "<th $g_bg_yellow>Function</th>"
      . "<th $g_bg_yellow>Obj<br>type</th>"
      . "<th $g_bg_green>Cat-<br>egory</th>"
      . "<th $g_bg_green>Function</th>"
      . "</tr>\n";

 #
 #  Get results from the SELECT statement
 #
  my ($rule_id, $rule_type_code, $rule_short_name, $function_or_group,
      $cond_cat, $cond_func, $cond_obj_type_code, $cond_qualcode,
      $result_cat, $result_func, $result_obj_type_code, $result_qualcode,
      $is_in_effect);
  while 
   ( ($rule_id, $rule_type_code, $rule_short_name, $function_or_group,
      $cond_cat, $cond_func, $cond_obj_type_code, $cond_qualcode,
      $result_cat, $result_func, $result_obj_type_code, $result_qualcode,
      $is_in_effect)
      = $csr1->fetchrow_array )
  {
    my $bgcolor = ($is_in_effect eq 'N') ? " $g_gray_bg" : "";
    my $temp_rule_name = ($is_in_effect eq 'N') 
         ? "$g_not_prefix $rule_short_name" : $rule_short_name;
    print "<tr $bgcolor><td>$rule_id</td>"
        . "<td>$temp_rule_name</td><td>$function_or_group</td>"
        . "<td>$cond_cat</td><td>$cond_func</td><td>$cond_obj_type_code</td>"
        . "<td>$result_cat</td><td>$result_func</td>"
        . "</tr>\n";
  }
  my @catlist = ('EHS');
  my @qualtypes = ('RSET');
  print "<tr><td><small><i>new</i></small></td>"
        . "<td><input name=rule_name type=text></input></td>"
        . "<td colspan=3>" 
        . &get_function_list_cond($lda, \@catlist, ':', "cond_function")
        . "</td>"
        . "<td>" 
        . &get_qual_subtype_list($lda, \@qualtypes, $delim, ':','cond_subtype')
        . "</td>"
        . "<td colspan=2>"
        . &get_function_list_result($lda, \@catlist, ':', "result_function")
        . "</td>"
        . "</tr>\n";
  print "</table><p /><hr /><p />\n";
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
  $rows_in_table = $rule_type_count{$limit_rule_type_code} + 3;
  $rule_type_name = $rule_code2name{$limit_rule_type_code};
  if ($rule_type_name =~ /^$limit_rule_type_code/) {
      $len_string = length($limit_rule_type_code) + 2;
      $rule_type_name = substr($rule_type_name, $len_string);
  }
  print "<h3>$rule_code2name{$limit_rule_type_code}</h3><p />\n";
  print "<i>$rule_code2desc{$limit_rule_type_code}</i><p />\n";
  print "<table border>\n";
  print "<tr><th colspan=13>$rule_type_name</th>"
      . "</tr>"
      . "<tr><th rowspan=2>Rule<br>ID</th>"
      . "<th rowspan=2>Rule name</th>"
      . "<td $g_bg_yellow rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_yellow colspan=4 align=center><big><b>If...</b></big>"
      . "<br><i>(condition)</i></td>"
      . "<td $g_bg_yellow rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_green rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_green colspan=3 align=center><big><b>...then</b></big><br>"
      . "<i>(result)</i></td>"
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
   ( ($rule_id, $rule_type_code, $rule_short_name, $function_or_group,
      $cond_cat, $cond_func, $cond_obj_type_code, $cond_qualcode,
      $result_cat, $result_func, $result_obj_type_code, $result_qualcode,
      $is_in_effect)
      = $csr1->fetchrow_array )
  {
    my $bgcolor = ($is_in_effect eq 'N') ? " $g_gray_bg" : "";
    my $temp_rule_name = ($is_in_effect eq 'N') 
         ? "$g_not_prefix $rule_short_name" : $rule_short_name;
    print "<tr $bgcolor><td>$rule_id</td>"
        . "<td>$temp_rule_name</td>"
        . "<td>$function_or_group</td>"
        . "<td>$cond_cat</td><td>$cond_func</td><td>$cond_obj_type_code</td>"
        . "<td>$result_cat</td><td>$result_func</td>"
        . "<td>$result_obj_type_code</td>"
        . "</tr>\n";
  }
  @catlist = ('EHS');
  @qualtypes = ('RSET');
  print "<tr><td><small><i>new</i></small></td>"
        . "<td><input name=rule_name type=text></input></td>"
        . "<td colspan=3>" 
        . &get_function_list_cond($lda, \@catlist, ':', "cond_function")
        . "</td>"
        . "<td>" 
        . &get_qual_subtype_list($lda, \@qualtypes, $delim, ':','cond_subtype')
        . "</td>"
        . "<td colspan=2>"
        . &get_function_list_result($lda, \@catlist, ':', "result_function")
        . "</td>"
        . "<td>" 
        . &get_qual_subtype_list($lda, \@qualtypes, 
                                 $delim, ':','result_subtype')
        . "</td>"
        . "</tr>\n";
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
  my $rows_in_table = $rule_type_count{$limit_rule_type_code} + 3;
  $rule_type_name = $rule_code2name{$limit_rule_type_code};
  if ($rule_type_name =~ /^$limit_rule_type_code/) {
      $len_string = length($limit_rule_type_code) + 2;
      $rule_type_name = substr($rule_type_name, $len_string);
  }
  print "<h3>$rule_code2name{$limit_rule_type_code}</h3><p />\n";
  print "<i>$rule_code2desc{$limit_rule_type_code}</i><p />\n";
  print "<table border>\n";
  print "<tr><th colspan=15>$rule_type_name</th>"
      . "</tr>"
      . "<tr><th rowspan=2>Rule<br>ID</th>"
      . "<th rowspan=2>Rule name</th>"
      . "<td $g_bg_yellow rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_yellow colspan=5 align=center><big><b>If...</b></big><br>"
      . "<i>(condition)</i></td>"
      . "<td $g_bg_yellow rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_green rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_green colspan=4 align=center><big><b>...then</b></big><br>"
      . "<i>(result)</i></td>"
      . "<td $g_bg_green rowspan=$rows_in_table>&nbsp;</td>"
      . "</tr>"
      . "<tr><th $g_bg_yellow>Func<br>or<br>grp</th>"
      . "<th $g_bg_yellow>Cat-<br>egory</th>"
      . "<th $g_bg_yellow>Function</th>"
      . "<th $g_bg_yellow>Obj<br>type</th>"
      . "<th $g_bg_yellow>Cond<br>obj<br>code</th>"
      . "<th $g_bg_green>Cat-<br>egory</th>"
      . "<th $g_bg_green>Function</th>"
      . "<th $g_bg_green>Obj<br>type</th>"
      . "<th $g_bg_green>Obj<br>code</th>"
      . "</tr>\n";

 #
 #  Get results from the SELECT statement
 #
  while 
   ( ($rule_id, $rule_type_code, $rule_short_name, $function_or_group,
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
    print "<tr $bgcolor><td>$rule_id</td>"
        . "<td>$temp_rule_name</td><td>$function_or_group</td>"
        . "<td>$cond_cat</td><td>$cond_func</td>"
        . "<td>$cond_obj_type_code</td><td>$cond_qualcode</td>"
        . "<td>$result_cat</td><td>$result_func</td>"
        . "<td>$result_obj_type_code</td><td>$result_qualcode</td>"
        . "</tr>\n";
  }
  @catlist = ('LIBP');
  @qualtypes = ('DEPT');
  my @qualtypes2 = ('LIBM');
  print "<tr><td><small><i>new</i></small></td>"
        . "<td><input name=rule_name type=text></input></td>"
        . "<td colspan=3>" 
        . &get_function_list_cond($lda, \@catlist, ':', "cond_function")
        . "</td>"
        . "<td colspan=2>" 
        . &get_qualcode_list($lda, \@qualtypes, ':','cond_qualcode')
        . "</td>"
        . "<td colspan=2>"
        . &get_function_list_result($lda, \@catlist, ':', "result_function")
        . "</td>"
        . "<td colspan=2>" 
        . &get_qualcode_list($lda, \@qualtypes2, 
                                 ':','result_qualcode')
        . "</td>"
        . "</tr>\n";
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
  my $rows_in_table = $rule_type_count{$limit_rule_type_code} + 3;
  $rule_type_name = $rule_code2name{$limit_rule_type_code};
  if ($rule_type_name =~ /^$limit_rule_type_code/) {
      $len_string = length($limit_rule_type_code) + 2;
      $rule_type_name = substr($rule_type_name, $len_string);
  }
  print "<h3>$rule_code2name{$limit_rule_type_code}</h3><p />\n";
  print "<i>$rule_code2desc{$limit_rule_type_code}</i><p />\n";
  print "<table border>\n";
  print "<tr><th colspan=15>$rule_type_name</th>"
      . "</tr>"
      . "<tr><th rowspan=2>Rule<br>ID</th>"
      . "<th rowspan=2>Rule name</th>"
      . "<td $g_bg_yellow rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_yellow colspan=5 align=center><big><b>If...</b></big><br>"
      . "<i>(condition)</i></td>"
      . "<td $g_bg_yellow rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_green rowspan=$rows_in_table>&nbsp;</td>"
      . "<td $g_bg_green colspan=4 align=center><big><b>...then</b></big><br>"
      . "<i>(result)</i></td>"
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
      . "<th $g_bg_green>Qual<br>code</th>"
      . "</tr>\n";

 #
 #  Get results from the SELECT statement
 #
  while 
   ( ($rule_id, $rule_type_code, $rule_short_name, $function_or_group,
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
    print "<tr $bgcolor><td>$rule_id</td>"
        . "<td>$temp_rule_name</td><td>$function_or_group</td>"
        . "<td>$cond_cat</td><td>$cond_func</td>"
        . "<td>$cond_obj_type_code</td><td>$cond_qualcode</td>"
        . "<td>$result_cat</td><td>$result_func</td>"
        . "<td>$result_obj_type_code</td><td>$result_qualcode</td>"
        . "</tr>\n";
  }
  @catlist = ('LIBP');
  @qualtypes = ('DEPT');
  my @qualtypes2 = ('LIBM');
  print "<tr><td><small><i>new</i></small></td>"
        . "<td><input name=rule_name type=text></input></td>"
        . "<td colspan=3>" 
        . &get_function_list_cond($lda, \@catlist, ':', "cond_function")
        . "</td>"
        . "<td colspan=2>" 
        . &get_qualcode_list($lda, \@qualtypes, ':','cond_qualcode')
        . "</td>"
        . "<td colspan=2>"
        . &get_function_list_result($lda, \@catlist, ':', "result_function")
        . "</td>"
        . "<td colspan=2>" 
        . &get_qualcode_list($lda, \@qualtypes2, 
                                 ':','result_qualcode')
        . "</td>"
        . "</tr>\n";
  print "</table><p /><hr /><p />\n";

}

###########################################################################
#
#  Report 2.
#
#  Display a list of Function Groups and child Functions.
#  If the argument $function_group_name is given, then list only functions
#   related to that function_group.
#
###########################################################################
sub report_2 {
  my ($lda, $function_group_name) = @_;

  $kerbname =~ tr/a-z/A-Z/;
  $function_name =~ tr/a-z/A-Z/;

 #
 #  Print the document header
 #
  my $doc_title = $g_report_code_name{'2'};
  print "<HEAD>"
   . "<TITLE>$doc_title</TITLE></HEAD>", "\n";
  print '<BODY bgcolor="#fafafa">';
  &print_header ($doc_title, 'https');
  print "<p /><hr /><p />"; 

 #
 #  Open a select statement
 #
  my $sql_frag = "";
  if ($function_group_name) {
      $sql_frag = " and fg.function_group_name = '$function_group_name'";
  }
    #where l.parent_id(+) = fg.function_group_id
    #and f.function_id(+) = l.child_id
  my $stmt1 = 
 "select fg.function_category, fg.function_group_id, fg.function_group_name, 
     fg.function_group_desc, fg.matches_a_function, fg.qualifier_type,
     l.child_id, f.function_name 
    from  function_group_link l left outer join function_group fg  ON (l.parent_id = fg.function_group_id) , 
	  function2 f left outer join function_group_link l2 on (f.function_id = l2.child_id)
    $sql_frag
    order by fg.function_category,fg.function_group_name,f.function_name";
  #print "stmt 3 = '$stmt1'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt1)) {
      print "Error preparing select statement 3: " . $DBI::errstr . "<BR>";
  }

  unless ($csr1->execute) {
      print "Error executing select statement 1: " . $DBI::errstr . "<BR>";
  }

 #
 #  Get results from the SELECT statement
 #
  my ($category, $fgid, $fgname, $fgdesc, $matches_function, $qualtype,
      $fid, $fname);
  my ($previous_fgid);
  my @fgid_list;
  my %fgid2category;
  my %fgid2name;
  my %fgid2desc;
  my %fgid2matches_function;
  my %fgid2qualtype;
  my %fgid2function_list;
  my $delim = ',';
  my $function_id2name;
  
  while 
   ( ($category, $fgid, $fgname, $fgdesc, $matches_function, $qualtype,
      $fid, $fname)
      = $csr1->fetchrow_array )
  {
    if ($previous_fgid ne $fgid) {
      push(@fgid_list, $fgid);
      $fgid2category{$fgid} = $category;
      $fgid2name{$fgid} = $fgname;
      $fgid2desc{$fgid} = $fgdesc;
      $fgid2matches_function{$fgid} = $matches_function;
      $fgid2qualtype{$fgid} = $qualtype;
    }
    if ($fgid2function_list{$fgid}) {
	$fgid2function_list{$fgid} .= ",$fid";
    }
    else {
	$fgid2function_list{$fgid} = $fid;
    }
    $function_id2name{$fid} = $fname;
    $previous_fgid = $fgid;
  }

 #
 #  Print a header
 #
  print "The following table shows details for one or more Function Groups.
         Under the column \"Linked Function name\", see a list of all
         Functions associated with the given Function Group.
         <p />(Within implied authorization rules, if a condition for 
         a rule specifies a Function Group, then the condition 
         applies to all linked Functions.)<p />";
  print "<table border>\n";
  print "<tr><th>Category</th><th>Function<br>Group<br>ID</th>
         <th>Function Group Name</th>
         <th width=\"15%\">Description</th><th>Matches<br>a<br>function</th>
         <th>Qual<br>type</th><th>Function<br>ID</th>
         <th>Linked Function name</th></tr>\n";
  my $id, $id2;
  foreach $id (@fgid_list) {
    my @fid_list = split($delim, $fgid2function_list{$id});
    my $num_fid = @fid_list;
    unless ($num_fid) {$num_fid = 1;}
    my $first_fid = shift(@fid_list); # Take off first element
    my $first_fname = $function_id2name{$first_fid};
    print "<tr><td rowspan=$num_fid>$fgid2category{$id}</td>"
        . "<td rowspan=$num_fid>$id</td>"
        . "<td rowspan=$num_fid>$fgid2name{$id}</td>"
        . "<td rowspan=$num_fid>$fgid2desc{$id}</td>"
        . "<td rowspan=$num_fid>$fgid2matches_function{$id}</td>"
        . "<td rowspan=$num_fid>$fgid2qualtype{$id}</td>"
        . "<td>$first_fid</td><td>$first_fname</td>"
        . "</tr>\n";
    foreach $id2 (@fid_list) {
	print "<tr><td>$id2</td><td>$function_id2name{$id2}</td></tr>\n";
    }
  }
  print "</table><p /><hr /><p />\n";

}

###########################################################################
#
#  Report 0
#
#  Initial page: Show forms for requesting authorizations information
#
###########################################################################
sub report_0 {
  my ($lda) = @_;

 #
 #  Print the document header
 #
  my $doc_title = $g_report_code_name{'0'};
  print "<HEAD>"
   . "<TITLE>$doc_title</TITLE></HEAD>", "\n";
  print '<BODY bgcolor="#fafafa">';
  &print_header ($doc_title, 'https');
  print "<p /><hr /><p />";

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select q.qualifier_code, q.qualifier_level
           from qualifier q
           where qualifier_type = 'LIBM'
           and has_child = 'N'
           order by q.qualifier_level,q.qualifier_code";
  #print "stmt 1 = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare("$stmt")) {
      print "Error preparing select statement 1: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement 1: " . $DBI::errstr . "<BR>";
  }

 #
 #  Get list of leaf-level qualifiers in the LIBM hierarchy
 #
  my @lib_qualcode;
  my $temp_qualcode;
  while ( ($temp_qualcode) = $csr1->fetchrow_array ) {
      push(@lib_qualcode, $temp_qualcode);
  }

 #
 #  First form: Does user X have an implied or explicit authorization
 #                for a given function and qualifier?
 #
  print "Demo 1: Does a given user have an authorization for a given
         function and qualifier?<p />\n";
  print "<FORM METHOD=\"GET\" ACTION=\"$url_stem\">\n";
  print "<input type=\"hidden\" name=\"lookup_number\" value=\"1\">\n";
  print "<table>\n";
  print "<tr><td>Kerberos username</td>"
        . "<td><INPUT TYPE=\"TEXT\" NAME=\"kerbname\"></td></tr>\n";
  print "<tr><td>Function name</td>";
  print "<td><select name=\"function_name\">\n";
  print "<option>ACCESS LIBRARY MATERIALS\n";
  print "</select></td></tr>\n";
  print "<tr><td>Qualifier code</td>\n";
  print "<td><select name=\"qualcode\">\n";
  foreach $temp_qualcode (@lib_qualcode) {
     print "<option>${temp_qualcode}\n"
  }
  print "</select></td></tr>\n";
  print "</table>\n";
  print "<p /><input type=submit value=\"Submit\">\n";
  print "</form>\n";

 #
 #  2nd form: For what qualifiers (e.g., sets of library materials) 
 #            does user X have an implied or explicit authorization
 #            for a given function?
 #
  print "<p /><hr /><p />\n";
  print "Demo 2: For what sets of library materials does user X have
                 access?<p />\n";
  print "<FORM METHOD=\"GET\" ACTION=\"$url_stem\">\n";
  print "<input type=\"hidden\" name=\"lookup_number\" value=\"2\">\n";
  print "<table>\n";
  print "<tr><td>Kerberos username</td>"
        . "<td><INPUT TYPE=\"TEXT\" NAME=\"kerbname\"></td></tr>\n";
  print "<tr><td>Function name</td>";
  print "<td><select name=\"function_name\">\n";
  print "<option>ACCESS LIBRARY MATERIALS\n";
  print "</select></td></tr>\n";
  print "<tr><td>Show which qualifiers?</td>"
        . "<td><input type=radio name=show_nodes value=0 checked>Leaf-level"
        . " objects only"
        . "<br /><input type=radio name=show_nodes value=1>All"
        . "</td></tr>\n";
  print "</table>\n";
  print "<p /><input type=submit value=\"Submit\">\n";
  print "</form>\n";

 #
 #  3rd form: Show authorizations for a person within category 'LIBP'
 #
  print "<p /><hr /><p />\n";
  print "Demo 3: What authorizations does a given person have within category"
        . " LIBP?<p />\n";
  print "<FORM METHOD=\"GET\" ACTION=\"$url_stem\">\n";
  print "<input type=\"hidden\" name=\"lookup_number\" value=\"3\">\n";
  print "<table>\n";
  print "<tr><td>Kerberos username</td>"
        . "<td><INPUT TYPE=\"TEXT\" NAME=\"kerbname\"></td></tr>\n";
  print "<tr><td>Expand qualifiers?</td>"
        . "<td><input type=radio name=expand_qual value=1 checked>Yes"
        . "<br /><input type=radio name=expand_qual value=0>No"
        . "</td></tr>\n";
  print "</table>\n";
  print "<p /><input type=submit value=\"Submit\">\n";
  print "</form>\n";

}

###########################################################################
#
#  Subroutine allow_another_report
#
#  Prints a form that allows the user to run another report
#
###########################################################################
sub run_another_report {
  print "<p /><form>\n"
        . "<input type=hidden name=\"lookup_number\" value=\"0\">\n"
	. "<input type=submit value=\"Run another test\">\n"
        . "</form>\n";
}

###########################################################################
#
#  Subroutine verify_special_report_auth.
#
#  Verify's that $k_principal is allowed to run special administrative
#  reports for the perMIT DB. Return's 1 if $k_principal is allowed,
#  0 otherwise.
#
###########################################################################
sub verify_special_report_auth {
    my ($lda, $k_principal, $category) = @_;
    my ($csr, $stmt, $result);
    if ((!$k_principal) | (!$category)) {
        return 0;
    }
    $stmt = "select ROLESAPI_IS_USER_AUTHORIZED('$k_principal',"
             . "'VIEW AUTH BY CATEGORY', 'CAT$category') from dual";
    $csr = $lda->prepare($stmt) or die( $DBI::errstr . "\n");
    $csr->execute();


    ($result) = $csr->fetchrow_array() ;
    if ($result eq 'Y') {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################
#
#  Subroutine get_rule_type_hashes($lda, \%rule_code2name, \%rule_code2desc)
#
#  Returns two hashes
#   %rule_id2name maps a rule_code to its short name
#   %rule_id2desc maps a rule_code to its long description
#
###########################################################################
sub get_rule_type_hashes {
    my ($lda, $rrule_code2name, $rrule_code2desc) = @_;
    my ($csr, $stmt);
    $stmt = "select rule_type_code, rule_type_short_name, rule_type_description
             from auth_rule_type
             order by rule_type_code";
    $csr = $lda->prepare("$stmt") or die( $DBI::errstr . "\n");
    $csr->execute();
#    $csr = &ora_open($lda, $stmt)
#        || die $ora_errstr;

    my ($rule_code, $rule_name, $rule_desc);
    while ( ($rule_code, $rule_name, $rule_desc) = $csr->fetchrow_array()  )
    {
	$$rrule_code2name{$rule_code} = $rule_name;
	$$rrule_code2desc{$rule_code} = $rule_desc;
    }
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
    #$csr = &ora_open($lda, $stmt)
   #     || die $ora_errstr;
    $csr = $lda->prepare("$stmt") or die( $DBI::errstr . "\n");
    $csr->execute();

    my ($rule_code, $count);
    while ( ($rule_code, $count) = $csr->fetchrow_array()  )
    {
	$$rrule_type_count{$rule_code} = $count;
    }
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
   "select 'F' as type, function_category, trim(LEADING '*' FROM function_name) as function_group_name
    from external_function f
    where function_category in $catlist
      and function_id not in 
      (select flp.function_id from function_load_pass flp
       where flp.function_id = f.function_id
       and pass_number = 2)
    union select 'G' as type, function_category, function_group_name
    from function_group 
    where function_category in $catlist
    and IFNULL(matches_a_function, 'N') = 'N'
    order by function_category, type,function_group_name";
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
 $csr1->finish();

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
   "select 'F' as type, function_category, trim(LEADING '*' FROM function_name) as name
    from external_function f
    where function_category in $catlist
      and function_id not in 
      (select flp.function_id from function_load_pass flp
       where flp.function_id = f.function_id
       and pass_number = 1)
    order by function_category,type, name";
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
    order by qualifier_type, qualifier_level,qualifier_code";
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
