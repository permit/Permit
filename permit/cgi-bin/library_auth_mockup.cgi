#!/usr/bin/perl
###########################################################################
#
#  CGI script to demonstrate how look-ups of Library authorizations
#  might work within a web service
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
#  Written by Jim Repa, 2/4/2008
#
###########################################################################
#
# Get packages
#
use rolesweb('login_sql');   #Use sub. login_sql in rolesweb.pm
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

#
#  Get set to use Oracle.
#
use DBI;

#
#  Other constants
#
 $g_start_gray = "<font color=\"gray\">";
 $g_end_gray = "</font>";
 chomp ($today = `date "+%m/%d/%Y"`);

#
#  Report names
#
 %g_report_code_name = 
  ('0' => "Library authorizations mock-up",
   '1' => "Library Demo 1. Check an auth for a (person, function, qualifier)",
   '2' => "Library Demo 2. Given a person and function, list qualifiers"
          . " for which the person has authorizations",
   '3' => "Library Demo 3. Given a person and category, list authorizations",
  );


#
# Login into the database
# 
$lda = login_dbi_sql('roles') || die "$DBI::errstr . '<BR>'";

#
#  Make sure the user has a meta-authorization to view all authorizations.
#
if (!(&verify_special_report_auth($lda, $k_principal, 'LIBP'))) {
  print "Sorry.  You do not have the required perMIT system authorization to ",
  "view authorizations in category LIBP. (Your username is '$k_principal')";
  exit();
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
   &report_0($lda);
 }
 elsif ($g_lookup_number eq '1') {
   &report_1($lda, $g_kerbname, $g_function_name, $g_qualcode);
 }
 elsif ($g_lookup_number eq '2') {
   &report_2($lda, $g_kerbname, $g_function_name, $g_show_nodes);
 }
 elsif ($g_lookup_number eq '3') {
   &report_3($lda, $g_kerbname, $g_expand_qual);
 }

 exit();

###########################################################################
#
#  Report 1.
#
#  Look up authorization by (person, function, qualifier).
#  Display TRUE or FALSE
#
###########################################################################
sub report_1 {
  my ($lda, $kerbname, $function_name, $qualcode) = @_;

  $kerbname =~ tr/a-z/A-Z/;
  $function_name =~ tr/a-z/A-Z/;
  $qualcode =~ tr/a-z/A-Z/;

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
  #  Open connection to oracle
  #
  my $stmt = 
 "select count(*) from dual where exists 
  (select kerberos_name, function_name, qualifier_code
    from authorization2 a
    where kerberos_name = ?
    and function_name in (?, ?)
    and function_category = 'LIBP'
    and qualifier_code = ?
    and a.do_function = 'Y'
    and sysdate between a.effective_date and nvl(a.expiration_date, sysdate)
   union select a.kerberos_name, a.function_name, q.qualifier_code
    from authorization2 a, qualifier_descendent qd, qualifier q
    where a.kerberos_name = ?
    and a.function_category = 'LIBP'
    and qd.parent_id = a.qualifier_id
    and q.qualifier_id = qd.child_id
    --and (q.qualifier_type <> 'DEPT' or substr(q.qualifier_code, 1, 2) = 'D_')
    and a.function_name in (?, ?)
    and q.qualifier_code = ?
    and a.do_function = 'Y'
    and sysdate between a.effective_date and nvl(a.expiration_date, sysdate))";
  #print "stmt 1 = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 1: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->bind_param(1, $kerbname)) {
        print "Error binding param 1-1: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(2, $function_name)) {
        print "Error binding param 1-2: " . $DBI::errstr . "<BR>";  
  }
  my $star_function_name = '*' . $function_name;
  unless ($csr1->bind_param(3, $star_function_name)) {
        print "Error binding param 1-3: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(4, $qualcode)) {
        print "Error binding param 1-5: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(5, $kerbname)) {
        print "Error binding param 1-1: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(6, $function_name)) {
        print "Error binding param 1-2: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(7, $star_function_name)) {
        print "Error binding param 1-3: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(8, $qualcode)) {
        print "Error binding param 1-5: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 1: " . $DBI::errstr . "<BR>";
  }

  #
  #  Get result from the SELECT statement - should be 1 or 0
  #
  my $result;
  ($result) = $csr1->fetchrow_array;
  $result_string = ($result) ? 'TRUE' : 'FALSE';
  print "Checking existence of authorization for:
        <br />&nbsp;&nbsp;Kerberos_name = '$kerbname'
        <br />&nbsp;&nbsp;Function_name = '$function_name'
        <br />&nbsp;&nbsp;Qualifier_code = '$qualcode'<p />\n";
  print "Result is $result_string<br />\n";
  &run_another_report();

}

###########################################################################
#
#  Report 2.
#
#  Display a list of qualifiers for which a person is authorized for a given
#  function
#
###########################################################################
sub report_2 {
  my ($lda, $kerbname, $function_name, $show_nodes) = @_;

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
  #  Open connection to oracle
  #
  my $stmt = 
 "select q.qualifier_code, q.qualifier_name, nvl(q.has_child, 'N')
    from authorization2 a, qualifier q
    where kerberos_name = ?
    and function_name in (?, ?)
    and function_category = 'LIBP'
    and q.qualifier_id = a.qualifier_id
    and a.do_function = 'Y'
    and sysdate between a.effective_date and nvl(a.expiration_date, sysdate)
   union select q.qualifier_code, q.qualifier_name, nvl(q.has_child, 'N')
    from authorization2 a, qualifier_descendent qd, qualifier q
    where a.kerberos_name = ?
    and a.function_category = 'LIBP'
    and qd.parent_id = a.qualifier_id
    and q.qualifier_id = qd.child_id
    --and (q.qualifier_type <> 'DEPT' or substr(q.qualifier_code, 1, 2) = 'D_')
    and a.function_name in (?, ?)
    and a.do_function = 'Y'
    and sysdate between a.effective_date and nvl(a.expiration_date, sysdate)";
  #print "stmt 2 = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 2: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->bind_param(1, $kerbname)) {
        print "Error binding param 2-1: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(2, $function_name)) {
        print "Error binding param 2-2: " . $DBI::errstr . "<BR>";  
  }
  my $star_function_name = '*' . $function_name;
  unless ($csr1->bind_param(3, $star_function_name)) {
        print "Error binding param 2-3: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(4, $kerbname)) {
        print "Error binding param 2-4: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(5, $function_name)) {
        print "Error binding param 2-5: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(6, $star_function_name)) {
        print "Error binding param 2-6: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 1: " . $DBI::errstr . "<BR>";
  }

  #
  #  Print a header
  #
  my $show_nodes_string = ($show_nodes) ? "include all"
                                        : "show only leaf-level";
  print "Listing qualifiers for which<br />"
        . "Kerberos_name = '$kerbname'<br />"
        . "has an authorization for function '$function_name'<br />"
	. "($show_nodes_string qualifiers)<p />\n";
  print "<table border>"
      . "<tr><th>Qualifier code</th><th>Qualifier name</th></tr>\n";

  #
  #  Get result from the SELECT statement - should be 1 or 0
  #
  my ($qualifier_code, $qualifier_name, $has_child);
  while 
   ( ($qualifier_code, $qualifier_name, $has_child) = $csr1->fetchrow_array )
  {
      if ($show_nodes || $has_child eq 'N') {
        print "<tr><td>$qualifier_code</td><td>$qualifier_name</td></tr>\n";
      }
  }
  print "</table><p />\n";
  &run_another_report();

}

###########################################################################
#
#  Report 3.
#
#  Display a list of authorizations for a person within a given category
#
###########################################################################
sub report_3 {
  my ($lda, $kerbname, $expand_qual) = @_;

  $kerbname =~ tr/a-z/A-Z/;
  $function_name =~ tr/a-z/A-Z/;

 #
 #  Print the document header
 #
  my $doc_title = $g_report_code_name{'3'};
  print "<HEAD>"
   . "<TITLE>$doc_title</TITLE></HEAD>", "\n";
  print '<BODY bgcolor="#fafafa">';
  &print_header ($doc_title, 'https');
  print "<p /><hr /><p />";

  #
  #  Open connection to oracle
  #
  my $stmt = 
 "select a.kerberos_name, a.function_name, 
       q.qualifier_code, q.qualifier_name
    from authorization2 a, qualifier q
    where kerberos_name = ?
    and function_category = 'LIBP'
    and q.qualifier_id = a.qualifier_id
    and a.do_function = 'Y'
    and sysdate between a.effective_date and nvl(a.expiration_date, sysdate)
   union select a.kerberos_name, a.function_name,
       q.qualifier_code, q.qualifier_name
    from authorization2 a, qualifier_descendent qd, qualifier q
    where a.kerberos_name = ?
    and '1' = ?
    and a.function_category = 'LIBP'
    and qd.parent_id = a.qualifier_id
    and q.qualifier_id = qd.child_id
    and (q.qualifier_type <> 'DEPT' or substr(q.qualifier_code, 1, 2) = 'D_')
    and a.do_function = 'Y'
    and sysdate between a.effective_date and nvl(a.expiration_date, sysdate)";
  #print "stmt 2 = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 2: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->bind_param(1, $kerbname)) {
        print "Error binding param 3-1: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(2, $kerbname)) {
        print "Error binding param 3-2: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(3, $expand_qual)) {
        print "Error binding param 3-3: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 1: " . $DBI::errstr . "<BR>";
  }

  #
  #  Print a header
  #
  my $expand_string = ($expand_qual eq '1') ? 'Qualifiers are expanded'
                                            : "Qualifiers are not expanded";
  print "Listing authorizations for Kerberos_name = '$kerbname'<br />"
        . "within category 'LIBP'<br />"
	. "($expand_string)<p />\n";
  print "<table border>"
      . "<tr><th>Kerberos name</th><th>Function name</th>"
      . "<th>Qualifier code</th><th>Qualifier name</th></tr>\n";

  #
  #  Get result from the SELECT statement - should be 1 or 0
  #
  my ($kerb_name, $function_name, $qualifier_code, $qualifier_name);
  while 
   ( ($kerb_name, $function_name, $qualifier_code, $qualifier_name)
      = $csr1->fetchrow_array )
  {
    #$function_name =~ s/^\*//;
    print "<tr><td>$kerb_name</td><td>$function_name</td>"
        . "<td>$qualifier_code</td><td>$qualifier_name</td></tr>\n";
  }
  print "</table><p />\n";
  &run_another_report();

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
   "select q.qualifier_code 
           from qualifier q
           where qualifier_type = 'LIBM'
           and has_child = 'N'
           order by 1";
  #print "stmt 1 = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
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
    my ($csr, @stmt, $result);
    if ((!$k_principal) | (!$category)) {
        return 0;
    }
    @stmt = ("select ROLESAPI_IS_USER_AUTHORIZED('$k_principal',"
             . "'VIEW AUTH BY CATEGORY', 'CAT$category') from dual");

    $csr = $lda->prepare("$stmt") or die( $DBI::errstr . "\n");
    $csr->execute();

    ($result) = $csr->fetchrow_array();
    if ($result eq 'Y') {
        return 1;
    } else {
        return 0;
    }
}


