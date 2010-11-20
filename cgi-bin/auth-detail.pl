#!/usr/bin/perl
###########################################################################
#
#  CGI script to display some miscellaneous reports.  These reports
#  require certificates and meta-authorizations to display category SAP
#  authorizations for others.
#
#
#  Copyright (C) 2001-2010 Massachusetts Institute of Technology
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
#  Modified, Jim Repa, 3/30/2001  Fix to_date format conversion string
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
use rolesweb('print_header'); #Use sub. print_header

#
#  Web stem constants
#
 $host = $ENV{'HTTP_HOST'};
 $main_url = "http://$host/webroles.html";

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
#  Set stem for URLs
#
$url_stem = "/cgi-bin/rolequal1.pl?";
$url_stem2 = "/cgi-bin/roleparent.pl?";
$url_stem3 = "/cgi-bin/rolecc_info.pl?";

#
#  Set some constants.
#

#
#  Get form variables
#
$category = $formval{'category'};
$kerbname = $formval{'kerbname'};
$funcname = $formval{'funcname'};
$qualcode = $formval{'qualcode'};
$category =~ tr/a-z/A-Z/;
$kerbname =~ tr/a-z/A-Z/;
$funcname =~ tr/a-z/A-Z/;
$qualcode =~ tr/a-z/A-Z/;

#
#  Print out top of the http document.  
#
 print "Content-type: text/html", "\n\n";

#
#  Parse auth information
#
($info,$k_principal, $domain)  = &parse_authentication_info();  # Parse certificate into a Perl "hash"

  $full_name = $k_principal; 
  $result = &check_auth_source($info); # Check other certificate fields
  if ($result ne 'OK') {
      print "<br><b>Your authentication cannot be accepted: $result";
      exit();
  }
 $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase


use DBI;

#
#  Open connection to oracle
#
#$lda = &login_sql('roles') 
#      || die $ora_errstr;
my $lda = &login_dbi_sql('roles')
      || die ($DBI::errstr . "\n");

#
#  Make sure either:
#     (a) the requestor has a meta-authorization to view all authorizations
#         in the given category
#  or (b) the requested authorization is for the same Kerberos username
#         as the requestor.
#
if ( ($k_principal ne $kerbname)
      && (!(&verify_metaauth_category($lda, $k_principal, $category))) ) {
  print "Sorry.  You do not have the required perMIT DB 'meta-authorization'",
  " to view other people's category '$category' authorizations.";
  exit();
}

#
#  Print out the header
#
 print "<HTML>", "\n";
 print "<HEAD><TITLE>Authorization detail",
       "</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 &print_header("Authorization detail", 'https');
 #print "category='$category' kerbname='$kerbname' funcname='$funcname'"
 #   . " qualcode='$qualcode'\n<BR>";

#
#  Print out details
#
 &report1($lda);
  
#
#  Drop connection to Oracle.
#
# &ora_logoff($lda) || die "can't log off Oracle";
$lda->disconnect;

#
#  Print end of the HTML document.
#
 print "<HR>";
 print "<A HREF=\"$main_url\">"
  . "<small>Back to main perMIT web interface page</small></A>";
 print "</BODY></HTML>", "\n";
 exit(0);

###########################################################################
#
#  Subroutine report1.
#
#  Generate list of people with SAP authorizations but no CAN USE SAP
#  authorization.
#
###########################################################################
sub report1 {

  my ($lda) = @_;  # Get Oracle login handle.
  my ($auth_id, $func_id, $qual_id, $qual_name, $modified_by,
          $modified_date, $do_function, $grant_and_view, $descend,
          $effective_date, $expiration_date, $func_desc);
  my $auth_found = 0;

  #
  #  Open a cursor for select statement.
  #
  my $stmt = "select a.authorization_id, a.function_id, a.qualifier_id,"
              . " a.qualifier_name, a.modified_by,"
              . " DATE_FORMAT(a.modified_date,'%m %d, %Y %h:%i:%s AM'),"
              . " a.do_function,"
	      . " CASE a.grant_and_view WHEN 'N ' THEN 'N (none)'"
	      . " WHEN 'V ' THEN 'V (view only)' WHEN 'GD' THEN 'GD (Grant Do)'"
	      . " ELSE a.grant_and_view END,"
              . "  a.descend,"
              . " DATE_FORMAT(a.effective_date,'%m %d %Y'),"
              . " DATE_FORMAT(a.expiration_date,'%m %d %Y'),"
              . " f.function_description"
              . " from authorization a, function f"
              . " where a.function_category = '$category'"
              . " and a.kerberos_name = '$kerbname'"
              . " and a.function_name = '$funcname'"
              . " and a.qualifier_code = '$qualcode'"
              . " and a.function_id = f.function_id";
  #print @stmt;
 my $csr = $lda->prepare("$stmt") or die( $DBI::errstr . "\n");
$csr->execute();

  #
  #  Start printing a table
  #
  print "<TABLE>", "\n";

  #
  #  Process lines from the select statement
  #
  while (my @row = $csr->fetchrow_array())
  {
 	my ($auth_id, $func_id, $qual_id, $qual_name, $modified_by,
          $modified_date, $do_function, $grant_and_view, $descend,
          $effective_date, $expiration_date, $func_desc) = @row;
    	$auth_found = 1;
    	my $stmt2 = "select first_name, last_name, dept_code,"
       . " CASE primary_person_type WHEN 'E' THEN 'Employee' "
       . " WHEN 'S'  THEN 'Student' ELSE 'Other' END,"
 	. " CASE status_code  WHEN 'A' THEN 'Active' WHEN 'I' THEN 'Inactive' END,"
	. " q.qualifier_name "
	. " from person p left outer join  qualifier q on "
	. " p.dept_code = q.qualifier_code and q.qualifier_type = 'ORGU'"
       . " where p.kerberos_name = '$kerbname'";
    	my $csr2 = $lda->prepare("$stmt2") or die( $DBI::errstr . "\n");
	$csr2->execute();
	my @row2 =  $csr2->fetchrow_array();
    my ($first_name, $last_name, $dept_code, $person_type, $status, $dept_name)
        = @row2;

    $csr2->finish();
    print "<HR>", "\n";

    printf "<TR><TH ALIGN=LEFT>%25s</TH><TH ALIGN=LEFT>%-30s</TH>"
           . "<TD ALIGN=LEFT>%-15s</TD>\n",
           'Person', '', '';
    printf "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
           'Kerberos username:', $kerbname;
    printf "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
           'Name:', $first_name . ' ' . $last_name, '';
    printf "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
           'Status/type:', $status . '/' . $person_type;
    printf "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
           'Department code:', $dept_code, '';
    printf "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
           'Department name:', $dept_name, '';
    print "<TR><TD></TD></TR>\n";
    print "<TR><TD></TD></TR>\n";
    printf "<TR><TH ALIGN=LEFT>%25s</TH><TH ALIGN=LEFT>%-30s</TH>"
           . "<TD ALIGN=LEFT>%-15s</TD>\n",
           'Function', '', '';
    printf "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
           'Category:', $category, '';
    printf "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
           'Function name:', $funcname, '';
    printf "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
           'Function description:', $func_desc, '';
    printf "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
           'Function ID:', $func_id, '';
    print "<TR><TD></TD></TR>\n";
    print "<TR><TD></TD></TR>\n";
    printf "<TR><TH ALIGN=LEFT>%25s</TH><TH ALIGN=LEFT>%-30s</TH>"
           . "<TD ALIGN=LEFT>%-15s</TD>\n",
           'Qualifier', '', '';
    printf "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
           'Qualifier code:', $qualcode, '';
    printf "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
           'Qualifier name:', $qual_name, '';
    print "<TR><TD></TD></TR>\n";
    print "<TR><TD></TD></TR>\n";
    printf "<TR><TH ALIGN=LEFT>%25s</TH><TH ALIGN=LEFT>%-30s</TH>"
           . "<TD ALIGN=LEFT>%-15s</TD>\n",
           'Flags', '', '';
    printf "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
           'Do function:', $do_function, '';
    printf "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
           'Grant-and-view:', $grant_and_view, '';
    printf "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
           'Descend:', $descend, '';
    printf "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
           'Effective from - to:', $effective_date . ' - ' . $expiration_date, 
           '';
    print "<TR><TD></TD></TR>\n";
    print "<TR><TD></TD></TR>\n";
    printf "<TR><TH ALIGN=LEFT>%25s</TH><TH ALIGN=LEFT>%-30s</TH>"
           . "<TD ALIGN=LEFT>%-15s</TD>\n",
           'Miscellaneous', '', '';
    printf "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
           'Internal auth. ID:', $auth_id, '';
    printf "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
           'Modified by:', $modified_by, '';
    printf "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
           'Modified date:', $modified_date, '';
  }
  print "</TABLE>", "\n";
  $csr->finish();
  
  #
  # If no authorization was found, then print an error message.
  #
  if (! $auth_found) {
    print "Authorization not found.<BR><BR>\n";
    print "Category='$category' Kerberos-username='$kerbname'"
          . " Function-name='$funcname' Qualifier-code='$qualcode'<BR>\n";
  }

  #
  #
  #
}
