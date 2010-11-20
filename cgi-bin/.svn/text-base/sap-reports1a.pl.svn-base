#!/usr/bin/perl
###########################################################################
#
#  CGI script to display some miscellaneous reports.  These reports
#  require certificates and meta-authorizations to display category SAP
#  authorizations for others.
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
#  Modified 9/20/2000 by Varun -- added reports 5 and 6.
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
#  Set some constants.
#
$category = 'SAP';
@title = (
   'People with SAP authorizations but no CAN USE SAP auth.',
   'Fund Centers that break the "one kind of children" rule',
   'Fund Centers that belong to more than one Spending Group',
   'People missing REQUISITIONER or CREDIT CARD VERIFIER auth.',
   'People missing CAN SPEND OR COMMIT FUNDS auth.',
   'People with APPROVER auths. but no CAN SPEND OR COMMIT FUNDS or '
   . 'REQUISITIONER auth.'
 );
$host = $ENV{'HTTP_HOST'};
$url_stem = "https://$host/cgi-bin/my-auth.cgi?category=SAP+SAP&FORM_LEVEL=1&";
$url_stem2 = "http://$host/cgi-bin/rolequal1.pl?";
$url_stem3 = "http://$host/cgi-bin/roleparent.pl?";
$url_stem4 = "https://$host/cgi-bin/audit_trail.pl?category=SAP+SAP&";

#
#  Get form variables
#
$report_num = $formval{'report_num'};
if (! $report_num) {$report_num = 1;}
$show_all = $formval{'show_all'};
if (! $show_all) {$show_all = 'Y';};
$show_all =~ tr/a-z/A-Z/;

#
#  Print out top of the http document.  
#
 print "Content-type: text/html\n\n";  # Start generating HTML document
 $header = $title[$report_num - 1];
 print "<head><title>$header</title></head>\n<body>";
 print '<BODY bgcolor="#fafafa">';
 &print_header
    ($header, 'https');
 print "<P>";

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
#  Get set to use Oracle.
#
use DBI;

#
#  Open connection to oracle
#
$lda = login_dbi_sql('roles') 
      || &web_error($DBI::errstr);

#
#  Make sure the user has a meta-authorization to view all WRHS authorizations.
#
if (!(&verify_metaauth_category($lda, $k_principal, $category))) {
  print "Sorry.  You do not have the required perMIT DB 'meta-authorization'",
  " to view other people's $category authorizations.";
  exit();
}

#
#  Print out the header
#
 #$header = $title[$report_num - 1];
 #print "<HTML>", "\n";
 #print "<HEAD><TITLE>$header",
 #      "</TITLE></HEAD>", "\n";
 #print "<BODY><H1>$header</H1>","\n";

#
#  Call the appropriate report
#
 if ($report_num == 1) {
   &report1($lda);
 }
 elsif ($report_num == 2) {
   &report2($lda);
 }
 elsif ($report_num == 3) {
   &report3($lda);
 }
 elsif ($report_num == 4) {
   &report4($lda);
 }
 elsif ($report_num == 5) {
   &report5($lda);
 }
 elsif ($report_num == 6) {
   &report6($lda);
 }

#
#  Drop connection to Oracle.
#
$lda->disconnect() || &web_error("can't log off Oracle");

#
#  Print end of the HTML document.
#
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
  my ($kerbname, $modified_by, $max_date, $kerbstring, $report_only,
      $count);

  #
  #  Open a cursor for select statement.
  #
  my @stmt = ("select kerberos_name, modified_by,"
              . " to_char(max(modified_date), 'DD-MON-YYYY'),"
              . " min(function_name), max(function_name)"
              . " from authorization"
              . " where function_category = 'SAP'"
              . " and function_name not in ('INVOICE APPROVAL UNLIMITED',"
              . " 'TRAVEL DOCUMENTS APPROVAL')"
              . " and kerberos_name in"
              . " (select distinct kerberos_name from authorization"
              . " where function_category = 'SAP'"
              . " minus select distinct kerberos_name from authorization"
              . " where function_category = 'SAP'"
              . " and function_name = 'CAN USE SAP'"
              . " and do_function = 'Y')" 
              ##. " and sysdate between effective_date"
              ##. " and nvl(expiration_date,sysdate))"
              . " group by kerberos_name, modified_by");

  $csr = $lda->prepare("$stmt")
        || &web_error($DBI::errstr);
   $csr->execute();
  #
  #  Print text
  #
print << 'ENDOFTEXT';
Below is a list of Kerberos names for people who have one or more
SAP authorizations but do not have a 'CAN USE SAP' authorization.
(For this report, 'INVOICE APPROVAL UNLIMITED' and 'TRAVEL'
DOCUMENTS APPROVAL' authorizations are not counted as SAP
ENDOFTEXT
   if ($show_all ne 'Y') {
     print "authorizations. 'REPORT BY...' and 'SEE SALARY SUBTOTAL IN"
           . " REPORTS' authorizations are also ignored.) ";
   }
   else {print "authorizations.) ";}
print << 'ENDOFTEXT';
Without a 'CAN USE SAP' authorization, the other 
SAP-related authorizations are meaningless in the SAP GUI, although
reporting authorizations will still be in effect for the
Warehouse.<BR><BR>
For each Kerberos name in the report, the person (or people) who
maintained SAP authorizations is shown, 
as well as the last modified date for SAP authorizations.
The 'modified by' and 'last modified date' fields come from the
most recent existing authorization for the person;  if
authorizations were deleted after this date/time, their date/time
will not be reflected in these fields.
ENDOFTEXT
   if ($show_all eq 'Y') {
     print "The 'reporting auths. only'"
     . " field contains '*' if the only SAP authorizations for the given"
     . " user and modified_by person are reporting-related"
     . " (i.e., 'REPORT BY...' or 'SEE SALARY SUBTOTAL IN REPORTS').";
   }
print << 'ENDOFTEXT';
<BR><BR>
Click on the Kerberos name to see a list of all SAP authorizations
for that person.<BR><BR>
<HR>
ENDOFTEXT
 
  #
  #  Start printing a table
  #
  print "<TABLE>\n";
  my $report_header = ($show_all eq 'Y') ? 'Reporting Auths. Only' : ' ';
  printf "<TR><TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH>"
         . "<TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TR>\n",
        'Kerberos name', 'Modified by', 'Last mod. date',
        $report_header;

  #
  #  Process lines from the select statement
  #
  $count = 0;
  while (($kerbname, $modified_by, $max_date, $min_function, $max_function)
         = $csr->fetchrow_array()) 
  {
    $kerbstring = '<A HREF="' . $url_stem . 'username=' . $kerbname
                   . '">' . $kerbname . "</A>";
    if ($min_function =~ '^(REPORT BY|SEE SALARY)'
        && $max_function =~ '^(REPORT BY|SEE SALARY)') {
      $report_only = '*';
    }
    else {
      $report_only = ' ';
    } 
    if ($show_all eq 'Y' || $report_only eq ' ') {
      $count++;
      printf "<TR><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TD>"
             . "<TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TR>\n",
         $kerbstring, $modified_by, $max_date, $report_only;
    }
  }
  print "</TABLE>", "\n";
  print "<P>$count lines displayed<BR>";

  $lda->disconnect() || &web_error("can't close cursor");

}

###########################################################################
#
#  Subroutine report2.
#
#  Generate list of Fund Centers whose children are a mixture of Funds and
#  other Fund Centers.
#
###########################################################################
sub report2 {

  my ($lda) = @_;  # Get Oracle login handle.
  my ($qualcode, $qualid, $qualname, $minchild, $maxchild, $qualstring);
  my $rowcount = 0;

  #
  #  Open a cursor for select statement.
  #
  my @stmt = ("select q.qualifier_code, q.qualifier_id,"
              . " q.qualifier_name,"
              . " min(q2.qualifier_code), max(q2.qualifier_code)"
              . " from qualifier q, qualifier_child qc, qualifier q2"
              . " where"
              . " q.qualifier_type = 'FUND'"
              . " and q.qualifier_code like 'FC%'"
              . " and q.qualifier_id = qc.parent_id"
              . " and qc.child_id = q2.qualifier_id"
              . " group by q.qualifier_code, q.qualifier_id, q.qualifier_name"
              . " having min(q2.qualifier_code) not like 'FC%'"
              . " and max(q2.qualifier_code) like 'FC%'");
  $csr = $lda->prepare("$stmt") 
        || &web_error($DBI::errstr);
  $csr->execute();

  #
  #  Print text
  #
print << 'ENDOFTEXT';
Each Fund Center in SAP's standard hierarchy of Fund Centers should have
as its immediate children either all Funds or all Fund Centers, not a 
combination of the two. This rule makes the Fund Center hierarchy
and the authorizations based on its elements simpler and easier to understand.
<BR><BR>
Below is a list of Fund Centers that break the rule.  Each Fund Center below
has both Funds and Fund Centers as its immediate children.
Click on a Fund Center to see its children in the hierarchy.
<HR>
ENDOFTEXT
 
  #
  #  Process lines from the select statement
  #
  while (($qualcode, $qualid, $qualname, $minchild, $maxchild)
         =  $csr->fetchrow_array() ) 
  {
    $qualstring = '<A HREF="' . $url_stem2 
            . 'qualtype=FUND+%28Fund+Centers+and+Funds%29'
            . '&rootnode=' . $qualid . '">' 
            . $qualcode . '</A> ' . $qualname;
    print $qualstring . "<BR>\n";
    $rowcount++;
  }

  $csr->finish() || &web_error("can't close cursor");
  print "<BR>There are $rowcount Fund Centers that break the rule.<BR>";

}

###########################################################################
#
#  Subroutine report3.
#
#  Generate list of Fund Centers that belong to more than one spending
#  group.
#
###########################################################################
sub report3 {

  my ($lda) = @_;  # Get Oracle login handle.
  my ($childname, $childcode, $minparent, $maxparent, $count);
  my $rowcount = 0;

  #
  #  Open a cursor for select statement.
  #
  my @stmt = (
    "select /*+ ORDERED */"
    . " q1.qualifier_name, q1.qualifier_code, min(q2.qualifier_code),"
    . " max(q2.qualifier_code), count(*)"
    . " from qualifier q1, qualifier_descendent qd, qualifier q2,qualifier qsg"
    . " where q1.qualifier_type = 'FUND'"
    . " and q1.qualifier_code between 'FC000000' and 'FC999999'"
    . " and q1.qualifier_id = qd.child_id"
    . " and qd.parent_id = q2.qualifier_id"
    . " and q2.qualifier_type = 'FUND'"
    . " and substr(q2.qualifier_code,1,3) = 'FC_'"
    . " and q2.qualifier_code != 'FC_CUSTOM'"
    . " and replace(q2.qualifier_code, 'FC_', 'SG_') = qsg.qualifier_code"
    . " and qsg.qualifier_type = 'SPGP'"
    . " and qsg.has_child = 'N'"
    . " group by q1.qualifier_code, q1.qualifier_name"
    . " having count(*) > 1");
  $csr = $lda->prepare("$stmt")
        || &web_error($DBI::errstr);
  $csr->execute();

  #
  #  Print text
  #
print << 'ENDOFTEXT';
In most cases, a Fund Center should belong to only one Spending Group.
Below is a list of Fund Centers that break the rule.  Each Fund Center below
belongs to 2 or more Spending Groups. Two of its Spending Groups are
shown, but in some cases there may be more than two.
<P>
Click on a Fund Center to see its position in the Fund Center hierarchy.
By doing so, you will see all of its parents
in the Custom Fund Center Hierarchy, which are associated with Spending
Groups. (Remember that
each Custom Fund Center Group, FC_xxxxxxxx, is associated with a 
Spending Group, SG_xxxxxxxx, and the Spending Group hierarchy mirrors the
custom branch of the Fund Center hierarchy.)
<P>
<HR>
ENDOFTEXT

  #
  #  Start printing a table
  #
  print "<TABLE>\n";
  printf "<TR><TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH>"
         . "<TH ALIGN=LEFT>%s</TH>"
         . "<TH ALIGN=LEFT>%s</TH></TR>\n",
        'Child<BR>Fund<BR>Center', 'Child<BR>Fund Center Name', 
        'First<BR>Spending<BR>Group', 'Last<BR>Spending<BR>Group';
 
  #
  #  Process lines from the select statement
  #
  while (($childname, $childcode, $minparent, $maxparent, $count) 
         = $csr->fetchrow_array())
  {
    $qualstring = '<A HREF="' . $url_stem3 
            . 'qualtype=FUND+%28Fund+Centers+and+Funds%29'
            . '&qualcode=' . $childcode . '">' 
            . $childcode . '</A> ';
    $minparent =~ s/^FC_/SG_/;
    $maxparent =~ s/^FC_/SG_/;
    printf "<TR><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TD>"
         . "<TD ALIGN=LEFT>%s</TD>"
         . "<TD ALIGN=LEFT>%s</TD></TR>\n",
        $qualstring, $childname, $minparent, $maxparent;
    $rowcount++;
  }
  print "</TABLE>\n";

   $csr->finish() || &web_error("can't close cursor");
  print "<BR>There are $rowcount Fund Centers that break the rule.<BR>";

}

###########################################################################
#
#  Subroutine report4.
#
#  Generate list of people with a CAN SPEND OR COMMIT FUNDS authorization
#  but no REQUISITIONER or CREDIT CARD VERIFIER authorization.
#
###########################################################################
sub report4 {

  my ($lda) = @_;  # Get Oracle login handle.
  my ($kerbname, $modified_by, $kerbstring, $person_type, $person_dept,
      $count);

  #
  #  Open a cursor for select statement.
  #
  my @stmt = ("select distinct a.kerberos_name,"
              . " decode(p.primary_person_type,'S', 'Student',"
              . " 'E','Employee','O','Other'),"
              . " q.qualifier_name, a.modified_by"
              . " from authorization a, person p, qualifier q"
              . " where a.function_name = 'CAN SPEND OR COMMIT FUNDS'"
              . " and not exists"
              . " (select aa.kerberos_name from authorization aa"
              . " where aa.kerberos_name = a.kerberos_name"
              . " and aa.function_name in"
              . " ('REQUISITIONER', 'CREDIT CARD VERIFIER'))"
              . " and a.kerberos_name = p.kerberos_name"
              . " and q.qualifier_code(+) = p.dept_code"
              . " and q.qualifier_type(+) = 'ORGU'");

  $csr = $lda->prepare("$stmt")
        || &web_error($DBI::errstr);
  $csr->execute();

  #
  #  Print text
  #
print << 'ENDOFTEXT';
Below is a list of Kerberos names for people who have one or more
CAN SPEND OR COMMIT FUNDS authorizations but do not have either a
REQUISITIONER or a CREDIT CARD VERIFIER authorization.
(Without one of these latter authorizations, a CAN SPEND OR COMMIT
FUNDS authorization is meaningless.)
<P>
To see a list of all SAP authorizations for the person, click on the
Kerberos name.
For each Kerberos name in the report, the person's type (Employee, Student, or
Other) is shown, plus the person's department (if s/he is an employee).  Also,
the person (or people) who created
or modified the CAN SPEND OR COMMIT FUNDS authorizations are shown.
<HR>
ENDOFTEXT
 
  #
  #  Start printing a table
  #
    print "<TABLE>\n";
  printf "<TR><TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH>"
         . "<TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TR>\n",
        'Kerberos name', 'Person type', "Person's department",
        'Modified by';

  #
  #  Process lines from the select statement
  #
  $count = 0;
  while (($kerbname, $person_type, $person_dept, $modified_by)
         = $csr->fetchrow_array())
  {
    $kerbstring = '<A HREF="' . $url_stem . 'username=' . $kerbname
		   . '">' . $kerbname . "</A>";
    $count++;
    printf "<TR><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TD>"
           . "<TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TR>\n",
	$kerbstring, $person_type, $person_dept, $modified_by;
  }
  print "</TABLE>", "\n";
  print "<P>$count lines displayed<BR>";

  $csr->finish() || &web_error("can't close cursor");

}

###########################################################################
#
#  Subroutine report5.
#
#  Generate list of people with REQUISITIONER or CREDIT CARD VERIFIER authorization
#  but no CAN SPEND OR COMMIT FUNDS authorization.
#
###########################################################################
sub report5 {

  my ($lda) = @_;  # Get Oracle login handle.
  my ($kerbname, $modified_by, $kerbstring, $person_type, $person_dept,
      $count);

  #
  #  Open a cursor for select statement.
  #
  my @stmt = ("select distinct a.kerberos_name,"
              . " decode(p.primary_person_type,'S', 'Student',"
              . " 'E','Employee','O','Other'),"
              . " q.qualifier_name, a.modified_by"
              . " from authorization a, person p, qualifier q"
              . " where a.function_name in('REQUISITIONER','CREDIT CARD VERIFIER')"
              . " and not exists"
              . " (select aa.kerberos_name from authorization aa"
              . " where aa.kerberos_name = a.kerberos_name"
              . " and aa.function_name = 'CAN SPEND OR COMMIT FUNDS')"
              . " and a.kerberos_name = p.kerberos_name"
              . " and q.qualifier_code(+) = p.dept_code"
              . " and q.qualifier_type(+) = 'ORGU'");

  $csr = $lda->prepare("$stmt")
      || &web_error($DBI::errstr);
   $csr->execute();
  #
  #  Print text
  #
    print << 'ENDOFTEXT';
Below is a list of Kerberos names for people who have a REQUISITIONER 
or a CREDIT CARD VERIFIER authorizations but do not have a
CAN SPEND OR COMMIT FUNDS authorization.
(Without a CAN SPEND OR COMMIT FUNDS authorization, a REQUISITIONER or 
CREDIT CARD VERIFIER authorization is meaningless.)
<P>
To see a list of all SAP authorizations for the person, click on the
Kerberos name.
For each Kerberos name in the report, the person's type (Employee, Student, or
Other) is shown, plus the person's department (if s/he is an employee).  Also,
the person (or people) who created
or modified the REQUISITIONER or CREDIT CARD VERIFIER authorizations are shown.
<HR>
ENDOFTEXT

  #
  #  Start printing a table
  #
    print "<TABLE>\n";
    printf "<TR><TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH>"
         . "<TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TR>\n",
        'Kerbname', 'Type', "Dept",
    'Mod-by';

  #
  #  Process lines from the select statement
  #
  $count = 0;
  while (($kerbname, $person_type, $person_dept, $modified_by)
         =  $csr->fetchrow_array())
  {
    $kerbstring = '<A HREF="' . $url_stem4 . 'username=' . $kerbname
        . '">' . $kerbname . "</A>";
    $count++;
    printf "<TR><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TD>"
           . "<TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TR>\n",
        $kerbstring, $person_type, $person_dept, $modified_by;
  }
  print "</TABLE>", "\n";
  print "<P>$count lines displayed<BR>";

  $csr->finish() || &web_error("can't close cursor");

}

###########################################################################
#
#  Subroutine report6.
#
#  Generate list of people with APPROVER authorization
#  but no CAN SPEND OR COMMIT FUNDS or REQUISITIONER authorization.
#
###########################################################################
sub report6 {

  my ($lda) = @_;  # Get Oracle login handle.
  my ($kerbname, $modified_by, $kerbstring, $person_type, $person_dept,
      $count);

  #
  #  Open a cursor for select statement.
  #
  my @stmt = ("select distinct a.kerberos_name,"
              . " decode(p.primary_person_type,'S', 'Student',"
              . " 'E','Employee','O','Other'),"
              . " q.qualifier_name, a.modified_by"
              . " from authorization a, person p, qualifier q"
              . " where a.function_name like '%APPROVER%'"
              . " and a.function_category = 'SAP'"
              . " and not exists"
              . " (select aa.kerberos_name from authorization aa"
              . " where aa.kerberos_name = a.kerberos_name"
              . " and aa.function_name = 'CAN SPEND OR COMMIT FUNDS')"
              . " and a.kerberos_name = p.kerberos_name"
              . " and q.qualifier_code(+) = p.dept_code"
              . " and q.qualifier_type(+) = 'ORGU'"
              . " union"
              . " select distinct a.kerberos_name,"
              . " decode(p.primary_person_type,'S', 'Student',"
              . " 'E','Employee','O','Other'),"
              . " q.qualifier_name, a.modified_by"
              . " from authorization a, person p, qualifier q"
              . " where a.function_name like '%APPROVER%'"
              . " and a.function_category = 'SAP'"
              . " and not exists"
              . " (select aa.kerberos_name from authorization aa"
              . " where aa.kerberos_name = a.kerberos_name"
              . " and aa.function_name = 'REQUISITIONER')"
              . " and a.kerberos_name = p.kerberos_name"
              . " and q.qualifier_code(+) = p.dept_code"
              . " and q.qualifier_type(+) = 'ORGU'");

  $csr = $lda->prepare("$stmt")
      || &web_error($DBI::errstr);
  $csr->execute();

  #
  #  Print text
  #
    print << 'ENDOFTEXT';
Below is a list of Kerberos names for people who have one or more
APPROVER authorizations but do not have either a
CAN SPEND OR  COMMIT FUNDS or a REQUISITIONER authorization. This is
an unusual situation, possibly a mistake.
<P>
To see a list of all SAP authorizations for the person, click on the
Kerberos name.
For each Kerberos name in the report, the person's type (Employee, Student, or
Other) is shown, plus the person's department (if s/he is an employee).  Also,
the person (or people) who created
or modified the APPROVER authorizations are shown.
<HR>
ENDOFTEXT

  #
  #  Start printing a table
  #
  print "<TABLE>\n";
  printf "<TR><TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH>"
         . "<TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TR>\n",
        'Kerbname', 'Type', "Dept",
        'Mod-by';

  #
  #  Process lines from the select statement
  #
  $count = 0;
  while (($kerbname, $person_type, $person_dept, $modified_by)
         = $csr->fetchrow_array() )
  {
    $kerbstring = '<A HREF="' . $url_stem . 'username=' . $kerbname
        . '">' . $kerbname . "</A>";
    $count++;
    printf "<TR><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TD>"
           . "<TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TR>\n",
        $kerbstring, $person_type, $person_dept, $modified_by;
  }
  print "</TABLE>", "\n";
  print "<P>$count lines displayed<BR>";

  $csr->finish() || &web_error("can't close cursor");

}


########################################################################
#
#  Subroutine web_error($msg)
#  Prints an error message and exits.
#
###########################################################################
sub web_error {
  my $s = $_[0];
  print $s . "\n";
  die $s . "\n";
}
