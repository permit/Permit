#!/usr/bin/perl
###########################################################################
#
#  CGI script to display quarterly-report statistics for the perMIT DB
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
#  Written by Jim Repa, 1/8/2008
#  Modified by Jim Repa, 12/9/2008.  Add reports 4a-d by weekday and hour
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
 $g_date_range = $formval{'date_range'};

#
#  Get set to use Oracle.
#
use DBI;

#
#  Other constants
#
 @g_color_code = ('#F0F0F0','#BBBBFF','#AAAAFF','#8888FF','#6666FF','#4444FF');
 $g_ist_org_unit = '242800';
 $g_start_gray = "<font color=\"gray\">";
 $g_end_gray = "</font>";
 $g_date_range =~ /([^-]*)-([^-]*)/;  # Parse the date range
 $start_quarter = $1;  # Start quarter is token before "-"
 $end_quarter = $2;   # End quarter is token after "-"
 chomp ($today = `date "+%m/%d/%Y"`);

#
#  Report names
#
 %g_report_code_name = 
  ('1a' => "Report 1a. Number of functions (with one or more authorizations)
            by category as of $today",
   '1b' => "Report 1b. Number of new functions added since $start_quarter",
   '2b' => "Report 2a-b. Current total number of authorizations (as of
            $today)",
   '2c' => "Report 2c. Current total number of authorizations (as of
            $today)", 
   '2d' => "Report 2d. People who have curent authorizations, by category,
            person type, and org unit (as of $today)",
   '3a' => "Report 3a. Number of authorizations created/updated/deleted
             during a quarter ($start_quarter - $end_quarter)",
   '3b' => "Report 3b. Number of authorizations created/updated/deleted
             by category during a quarter ($start_quarter - $end_quarter)", 
   '3c' => "Report 3c. People who created/updated/deleted authorizations
             during a quarter ($start_quarter - $end_quarter)",
   '3d' => "Report 3d. People who created/updated/deleted authorizations
             by category during a quarter ($start_quarter - $end_quarter)",
   '3e' => "Report 3e. People who created/updated/deleted authorizations
             by person type and org unit 
             during a quarter ($start_quarter - $end_quarter)", 
   '3f' => "Report 3f. People who created/updated/deleted auths
             by category, person type and org unit 
             during a quarter ($start_quarter - $end_quarter)", 
   '3h' => "Report 3h. People who created/updated/deleted authorizations
             within IS&T (unit $g_ist_org_unit) 
             during a quarter ($start_quarter - $end_quarter)", 
   '4a' => "Report 4a. Number of authorizations created/updated/deleted
             by day of week and hour 
             during a quarter ($start_quarter - $end_quarter)",
   '4b' => "Report 4b. Excluding changes made by IS&T employees 
             (org unit $g_ist_org_unit),<br>
             &nbsp; &nbsp; &nbsp; show 
             number of authorizations created/updated/deleted
             by day of week \& hour during a quarter
             ($start_quarter - $end_quarter)",
   '4c' => "Report 4c. Number of people who did authorization 
             maintenance by day of week and hour 
             during a quarter ($start_quarter - $end_quarter)",
   '4d' => "Report 4d. Excluding changes made by IS&T employees 
             (org unit $g_ist_org_unit),<br>
             &nbsp; &nbsp; &nbsp; show 
             number of people who did authorization maintenance
             by day of week \& hour during a quarter
             ($start_quarter - $end_quarter)",

  );


#
# Login into the database
# 
 $lda = login_dbi_sql('roles') 
      || die $DBI::errstr . "<BR>";

#
#  Make sure the user has a meta-authorization to view all authorizations.
#
if (!(&verify_special_report_auth($lda, $k_principal, 'ALL'))) {
  print "Sorry.  You do not have the required perMIT system authorization",
  " to run administrative reports. (Your username is '$k_principal')";
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
 my $doc_title 
    = "perMIT system Quarterly Statistics ($start_quarter - $end_quarter)";
 print "<HTML>", "\n";
 print "<HEAD>"
  . "<TITLE>$doc_title</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 &print_header ($doc_title, 'https');
 print "<p /><hr /><p />";

#
#  Print table of contents
#
 &print_table_of_contents(\%g_report_code_name);
 print "<p /><hr /><p />\n";

#
#  Run the first report:
#  Show number of functions (with one or more auths) by category
#
 &report_1a($lda);
 print "<p /><hr /><p />\n";

#
#  Run more reports
#
 &report_1b($lda, $start_quarter);
 print "<p /><hr /><p />\n";
 &report_2b($lda);
 print "<p /><hr /><p />\n";
 &report_2c($lda);
 print "<p /><hr /><p />\n";
 &report_2d($lda);
 print "<p /><hr /><p />\n";
 &report_3a($lda, $start_quarter, $end_quarter);
 print "<p /><hr /><p />\n";
 &report_3b($lda, $start_quarter, $end_quarter);
 print "<p /><hr /><p />\n";
 &report_3c($lda, $start_quarter, $end_quarter);
 print "<p /><hr /><p />\n";
 &report_3d($lda, $start_quarter, $end_quarter);
 print "<p /><hr /><p />\n";
 &report_3e($lda, $start_quarter, $end_quarter);
 print "<p /><hr /><p />\n";
 &report_3f($lda, $start_quarter, $end_quarter);
 print "<p /><hr /><p />\n";
 &report_3h($lda, $start_quarter, $end_quarter);
 print "<p /><hr /><p />\n";
 &report_4a($lda, $start_quarter, $end_quarter);
 print "<p /><hr /><p />\n";
 &report_4b($lda, $start_quarter, $end_quarter);
 print "<p /><hr /><p />\n";
 &report_4c($lda, $start_quarter, $end_quarter);
 print "<p /><hr /><p />\n";
 &report_4d($lda, $start_quarter, $end_quarter);
 print "<p /><hr /><p />\n";
 $dbi->disconnect();
 exit();

###########################################################################
#
#  Subroutine print_table_of_contents
#
###########################################################################
sub print_table_of_contents {
  my ($rreport_hash) = @_;
  
  print "<h4>Table of contents</h4>\n";
  print "<blockquote>\n";
  foreach $key (sort keys %$rreport_hash) {
      print "<a href=\"#$key\">$$rreport_hash{$key}</a><BR>\n";
  }
  print "</blockquote>\n";  

}

###########################################################################
#
#  Report 1a.
#
#  Show number of functions (with one or more auths) by category
#
###########################################################################
sub report_1a {
  my ($lda) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select f.function_category, c.function_category_desc,
         count(distinct f.function_id) function_count,
         count(a.authorization_id) auth_count
    from function f, authorization a, category c
    where a.function_id = f.function_id
    and c.function_category = f.function_category
    group by f.function_category, c.function_category_desc";
  #print "stmt 1a = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 1a: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement 1a: " . $DBI::errstr . "<BR>";
  }

  #
  #  Print table header
  #
  print "<h4><a name=\"1a\">$g_report_code_name{'1a'}</a></h4>";
  print "<table border>\n";
  print "<tr><th colspan=2>Function category</th>"
        . "<th rowspan=2>Number of<br>functions</th>"
        . "<th rowspan=2>Number of<br>authorizations</th></tr>\n";
  print "<tr><th>Code</th><th>Description</th></tr>\n";

  #
  #  Print each row of the table
  #    Row contains ($cat, $cat_desc, $function_count, $auth_count)
  #
  my @row;
  while ( @row = $csr1->fetchrow_array ) {
    print "<tr>";
    my $item;
    foreach $item ( @row ) {
      print "<td>$item</td>";
    }
    print "</tr>\n";
  }

  #
  #  Print end of table
  #
  print "</table>\n";

}

###########################################################################
#
#  Report 1b.
#
#  Number of new functions added since the beginning of the quarter
#
###########################################################################
sub report_1b {
  my ($lda, $start_quarter) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select f.function_category,
         count(distinct f.function_id) new_function_count, 
         count(a.authorization_id) related_auth_count
    from function f, authorization a
    where a.function_id(+) = f.function_id
    and f.modified_date > to_date(?, 'MM/DD/YYYY')
    group by f.function_category";
  #print "stmt 1b = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 1b: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->bind_param(1, $start_quarter)) {
        print "Error binding param 1b: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 1b: " . $DBI::errstr . "<BR>";
  }

  #
  #  Print table header
  #
  print "<h4><a name=\"1b\">$g_report_code_name{'1b'}</a></h4>";
  print "<table border>\n";
  print "<tr><th>Function category</th>"
        . "<th>Number of<br>new functions</th>"
        . "<th>Number of<br>related<br>authorizations</th></tr>\n";

  #
  #  Print each row of the table
  #    Row contains ($cat, $function_count, $auth_count)
  #
  my @row;
  while ( @row = $csr1->fetchrow_array ) {
    print "<tr>";
    my $item;
    foreach $item ( @row ) {
      print "<td>$item</td>";
    }
    print "</tr>\n";
  }

  #
  #  Print end of table
  #
  print "</table>\n";

}

###########################################################################
#
#  Report 2b.
#
#  Total number of authorizations by category (as of today)
#
###########################################################################
sub report_2b {
  my ($lda) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select a.function_category, c.function_category_desc, count(*) 
    from authorization a, category c
    where c.function_category = a.function_category
    group by a.function_category, c.function_category_desc";
  #print "stmt 2b = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 2b: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement 2b: " . $DBI::errstr . "<BR>";
  }

  #
  #  Print table header
  #
  print "<h4><a name=\"2b\">$g_report_code_name{'2b'}</a></h4>";
  #print "<h4>Report 2a-b. Current total number of authorizations (as of
  #       $today)</h4>";
  print "<table border>\n";
  print "<tr><th>Category</th><th>Category description</th>
         <th>No. of auths.</th></tr>\n";

  #
  #  Print each row of the table
  #    Row contains ($cat, $cat_desc, $auth_count)
  #
  my @row;
  my $auth_count = 0;
  while ( @row = $csr1->fetchrow_array ) {
    $auth_count += $row[2];
    print "<tr>";
    my $item;
    foreach $item ( @row ) {
      print "<td>$item</td>";
    }
    print "</tr>\n";
  }

  #
  #  Print end of table
  #
  print "<tr><td colspan=3>&nbsp;</td></tr>\n";
  print "<tr><td colspan=2>Total</td><td>$auth_count</td><tr>\n";
  print "</table>\n";

}

###########################################################################
#
#  Report 2c.
#
#  People who have current auths, by person type and org unit
#
###########################################################################
sub report_2c {
  my ($lda) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select p.primary_person_type, nvl(p.dept_code, 'unknown') org_unit,
         nvl(q.qualifier_name, 'n/a') dept_name, 
         count(distinct authorization_id) auths, 
         count(distinct a.kerberos_name) people
   from authorization a, person p, qualifier q
   where p.kerberos_name = a.kerberos_name
   and q.qualifier_type(+) = 'ORGU'
   and q.qualifier_code(+) = p.dept_code
   group by p.primary_person_type, nvl(p.dept_code, 'unknown'),
         nvl(q.qualifier_name, 'n/a')";
  #print "stmt 2c = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 2c: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement 2c: " . $DBI::errstr . "<BR>";
  }

  #
  #  Print table header
  #
  print "<h4><a name=\"2c\">$g_report_code_name{'2c'}</a></h4>";
  #print "<h4>Report 2c. Current total number of authorizations (as of
  #       $today)</h4>";
  print "Here we look at people who HAVE the authorizations, rather than
         people who granted them.<br />
         In the first column, E=Employee, S=Student, and O=Other<p />\n";
  print "<table border>\n";
  print "<tr><th>Primary<br>person<br>type</th><th>Org unit code</th>
         <th>Org unit name</th>
         <th>No. of auths.</th><th>No. of people</th></tr>\n";

  #
  #  Print each row of the table
  #    Row contains ($primary_person_type, $org_code, $org_name, 
  #                  $auth_count, $person_count)
  #
  my @row;
  my $auth_count = 0;
  my $person_count = 0;
  while ( @row = $csr1->fetchrow_array ) {
    $auth_count += $row[3];
    $person_count += $row[4];
    print "<tr>";
    my $item;
    foreach $item ( @row ) {
      print "<td>$item</td>";
    }
    print "</tr>\n";
  }

  #
  #  Print end of table
  #
  print "<tr><td colspan=5>&nbsp;</td></tr>\n";
  print "<tr><td colspan=3>Total</td><td>$auth_count</td>"
        . "<td>$person_count</td><tr>\n";
  print "</table>\n";

}

###########################################################################
#
#  Report 2d.
#
#  People who have current auths, by person type and org unit
#
###########################################################################
sub report_2d {
  my ($lda) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select a.function_category, 
         p.primary_person_type, nvl(p.dept_code, 'unknown') org_unit,
         nvl(q.qualifier_name, 'n/a') dept_name, 
         count(distinct authorization_id) auths, 
         count(distinct a.kerberos_name) people
   from authorization a, person p, qualifier q
   where p.kerberos_name = a.kerberos_name
   and q.qualifier_type(+) = 'ORGU'
   and q.qualifier_code(+) = p.dept_code
   group by a.function_category, p.primary_person_type, 
         nvl(p.dept_code, 'unknown'), nvl(q.qualifier_name, 'n/a')";
  #print "stmt 2d = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 2d: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement 2d: " . $DBI::errstr . "<BR>";
  }

  #
  #  Print table header
  #
  print "<h4><a name=\"2d\">$g_report_code_name{'2d'}</a></h4>";
  #print "<h4>Report 2d. People who have curent authorizations, by category,
  #        person type, and org unit (as of $today)</h4>";
  print "Here we look at people who HAVE the authorizations, rather than
         people who granted them.<br />
         In the 2nd column, E=Employee, S=Student, and O=Other<p />\n";
  print "<table border>\n";
  print "<tr><th>Function<br>category</th>
         <th>Primary<br>person<br>type</th><th>Org unit code</th>
         <th>Org unit name</th>
         <th>No. of auths.</th><th>No. of people</th></tr>\n";

  #
  #  Print each row of the table
  #    Row contains ($cat, $primary_person_type, $org_code, $org_name,
  #                  $auth_count, $person_count)
  #
  my @row;
  my $auth_count = 0;
  my $person_count = 0;
  while ( @row = $csr1->fetchrow_array ) {
    $auth_count += $row[4];
    $person_count += $row[5];
    print "<tr>";
    my $item;
    foreach $item ( @row ) {
      print "<td>$item</td>";
    }
    print "</tr>\n";
  }

  #
  #  Print end of table
  #
  print "<tr><td colspan=6>&nbsp;</td></tr>\n";
  print "<tr><td colspan=4>Total</td><td>$auth_count</td>"
        . "<td>&nbsp;</td><tr>\n";
  print "</table>\n";

}

###########################################################################
#
#  Report 3a
#
#  Number of authorizations created/updated/deleted during a quarter
#
###########################################################################
sub report_3a {
  my ($lda, $start_quarter, $end_quarter) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select decode(action_type,'I','Insert','U','Update','D','Delete') Action,
     count(distinct authorization_id) auths
     from auth_audit
    where action_date between to_date(?, 'MM/DD/YYYY')
     and to_date(?, 'MM/DD/YYYY')
    group by action_type";
  #print "stmt 3a = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 3a: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->bind_param(1, $start_quarter)) {
        print "Error binding param 3a (1): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(2, $end_quarter)) {
        print "Error binding param 3a (2): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 3a: " . $DBI::errstr . "<BR>";
  }

  #
  #  Print table header
  #
  print "<h4><a name=\"3a\">$g_report_code_name{'3a'}</a></h4>";
  #print "<h4>Report 3a. Number of authorizations created/updated/deleted
  #           during a quarter ($start_quarter - $end_quarter)</h4>";
  print "<table border>\n";
  print "<tr><th>Action</th>
         <th>No. of auths.</th></tr>\n";

  #
  #  Print each row of the table
  #    Row contains ($action, $auth_count)
  #
  my @row;
  while ( @row = $csr1->fetchrow_array ) {
    print "<tr>";
    my $item;
    foreach $item ( @row ) {
      print "<td>$item</td>";
    }
    print "</tr>\n";
  }

  #
  #  Print end of table
  #
  print "</table>\n";

}

###########################################################################
#
#  Report 4a
#
#  Number of authorizations created/updated/deleted during a quarter
#  by day of week and hour
#
###########################################################################
sub report_4a {
  my ($lda, $start_quarter, $end_quarter) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select to_char(action_date, 'DY'),
     to_char(action_date, 'HH AM'),
     count(distinct authorization_id) auths
     from auth_audit
    where action_date between to_date(?, 'MM/DD/YYYY')
     and to_date(?, 'MM/DD/YYYY')
    group by to_char(action_date, 'D'), to_char(action_date, 'DY'), 
          to_char(action_date, 'HH24'), to_char(action_date, 'HH AM')";
  #print "stmt 4a = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 4a: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->bind_param(1, $start_quarter)) {
        print "Error binding param 4a (1): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(2, $end_quarter)) {
        print "Error binding param 4a (2): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 4a: " . $DBI::errstr . "<BR>";
  }

  #
  #  Read in rows and build a hash 
  #    $hour2auth_count{"$day_of_week:&hour_of_day"} = $n
  #    for each day of the week and hour
  #
  #    Row contains ($day_of_week, $hour_of_day, $auth_count)
  #
  my @row;
  my ($day_of_week, $hour_of_day, $auth_count);
  my %hour2auth_count = ();
  while ( @row = $csr1->fetchrow_array ) {
    my $item;
    ($day_of_week, $hour_of_day, $auth_count) = @row;
    $hour2auth_count{"$day_of_week:$hour_of_day"} = $auth_count;
  }

  #
  #  Set color thresholds for system transaction rate.  The color codes
  #  associated with these thresholds is ni @g_color_code.  The first
  #  number should always be 0.  The next is the lowest threshold for
  #  the least intense color, and each additional number represents 
  #  a more intense color.
  #
  my @color_threshold = (0, 0, 25, 100, 200, 400);

  #
  #  Print table headers for a matrix
  #
  print "<h4><a name=\"4a\">$g_report_code_name{'4a'}</a></h4>";
  print "<blockquote><i>Each cell in the table below shows the total number
         of unique authorizations that were inserted, updated, or deleted
         during the period of time.  For example, the cell for 
         SUN&nbsp;12&nbsp;-&nbsp;12:59&nbsp;AM shows the total number of 
         all unique authorizations that were inserted, updated or deleted
         on all Sundays during the quarter, between midnight and 12:59 AM.</i>
         </blockquote>\n";
  print "<table border>\n";
  my @days = ('SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT');
  my %day_total = ();
  print "<tr>
         <th colspan=10>Number of auths. created/updated/deleted</th></tr>";
  print "<tr><th>Hour of the day</th>"
        . "<th colspan=7>Day of the week</th><th colspan=2>&nbsp;</th></tr>";
  print "<tr><th>&nbsp;</th>";
  foreach $day_of_week (@days) {
      print "<th>$day_of_week</th>";
  }
  print "<th>&nbsp;</th><th>Total</th></tr>\n";
  foreach $hour_of_day ('12 AM', '01 AM', '02 AM', '03 AM', '04 AM', '05 AM',
            '06 AM', '07 AM', '08 AM', '09 AM', '10 AM', '11 AM',
            '12 PM', '01 PM', '02 PM', '03 PM', '04 PM', '05 PM',
	    '06 PM', '07 PM', '08 PM', '09 PM', '10 PM', '11 PM') 
  {
      my $hour_total = 0;
      my $tweaked_hour_of_day = 
        substr($hour_of_day, 0, 2) . " - " . substr($hour_of_day, 0, 2) 
        . ":59" . substr($hour_of_day, 2, 3);
      print "<tr><td>$tweaked_hour_of_day</td>";
      foreach $day_of_week (@days) {
	my $n = $hour2auth_count{"$day_of_week:$hour_of_day"};
        unless ($n) {$n = 0;}
        $hour_total += $n;
        $day_total{$day_of_week} += $n;
        my $cell_color 
            = &get_color_code($n, \@color_threshold, \@g_color_code);
        print "<td align=right bgcolor=\"$cell_color\">$n</td>";
      }
      print "<td>&nbsp;</td><td align=right>$hour_total</td></tr>\n";
  }
  print "<tr><td colspan=10>&nbsp;</td></tr>";
  print "<tr><td>Total</td>";
  my $grand_total = 0;
  foreach $day_of_week (@days) {
      my $nn = $day_total{$day_of_week};
      print "<td align=right>$nn</td>";
      $grand_total += $nn;
  }
  print "<td>&nbsp;</td><td align=right>$grand_total*</td></tr>\n";
  print "</table>";

  print "<p /><i>* Why doesn't the grand total number 
        in report 4a match the numbers in report 3a?
        <blockquote>
        If a particular authorization is updated more than once in the same 
        day, at different hours, it will be counted more than once in 
        report 4a, but only once in report 3a.  So the grand total in 
        report 4a will generally be slightly larger.
        </blockquote></i>";

}

###########################################################################
#
#  Report 4b
#
#  Number of authorizations created/updated/deleted during a quarter
#  by day of week and hour, excluding auths changed by
#  people in the IS&T org unit
#
###########################################################################
sub report_4b {
  my ($lda, $start_quarter, $end_quarter) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select to_char(action_date, 'DY'),
     to_char(action_date, 'HH AM'),
     count(distinct authorization_id) auths
     from auth_audit
    where action_date between to_date(?, 'MM/DD/YYYY')
     and to_date(?, 'MM/DD/YYYY')
     and roles_username not in 
       (select kerberos_name from person where primary_person_type = 'E'
        and dept_code = '$g_ist_org_unit')
    group by to_char(action_date, 'D'), to_char(action_date, 'DY'), 
          to_char(action_date, 'HH24'), to_char(action_date, 'HH AM')";
  #print "stmt 4b = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 4b: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->bind_param(1, $start_quarter)) {
        print "Error binding param 4b (1): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(2, $end_quarter)) {
        print "Error binding param 4b (2): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 4b: " . $DBI::errstr . "<BR>";
  }

  #
  #  Read in rows and build a hash 
  #    $hour2auth_count{"$day_of_week:&hour_of_day"} = $n
  #    for each day of the week and hour
  #
  #    Row contains ($day_of_week, $hour_of_day, $auth_count)
  #
  my @row;
  my ($day_of_week, $hour_of_day, $auth_count);
  my %hour2auth_count = ();
  while ( @row = $csr1->fetchrow_array ) {
    my $item;
    ($day_of_week, $hour_of_day, $auth_count) = @row;
    $hour2auth_count{"$day_of_week:$hour_of_day"} = $auth_count;
  }

  #
  #  Set color thresholds for system transaction rate.  The color codes
  #  associated with these thresholds is ni @g_color_code.  The first
  #  number should always be 0.  The next is the lowest threshold for
  #  the least intense color, and each additional number represents 
  #  a more intense color.
  #
  my @color_threshold = (0, 0, 25, 100, 200, 400);

  #
  #  Print table headers for a matrix
  #
  print "<h4><a name=\"4b\">$g_report_code_name{'4b'}</a></h4>";
  print "<blockquote><i>Each cell in the table below shows the total number
         of unique authorizations that were inserted, updated, or deleted
         during the period of time, excluding those that were inserted,
         updated or deleted by IS&T employees.  For example, the cell for 
         SUN&nbsp;12&nbsp;-&nbsp;12:59&nbsp;AM shows the total number of 
         all unique authorizations that were inserted, updated or deleted
         on all Sundays during the quarter, between midnight and 12:59 AM.</i>
         </blockquote>\n";
  print "<table border>\n";
  my @days = ('SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT');
  my %day_total = ();
  print "<tr>
         <th colspan=10>Number of auths. created/updated/deleted</th></tr>";
  print "<tr><th>Hour of the day</th>"
        . "<th colspan=7>Day of the week</th><th colspan=2>&nbsp;</th></tr>";
  print "<tr><th>&nbsp;</th>";
  foreach $day_of_week (@days) {
      print "<th>$day_of_week</th>";
  }
  print "<th>&nbsp;</th><th>Total</th></tr>\n";
  foreach $hour_of_day ('12 AM', '01 AM', '02 AM', '03 AM', '04 AM', '05 AM',
            '06 AM', '07 AM', '08 AM', '09 AM', '10 AM', '11 AM',
            '12 PM', '01 PM', '02 PM', '03 PM', '04 PM', '05 PM',
	    '06 PM', '07 PM', '08 PM', '09 PM', '10 PM', '11 PM') 
  {
      my $hour_total = 0;
      my $tweaked_hour_of_day = 
        substr($hour_of_day, 0, 2) . " - " . substr($hour_of_day, 0, 2) 
        . ":59" . substr($hour_of_day, 2, 3);
      print "<tr><td>$tweaked_hour_of_day</td>";
      foreach $day_of_week (@days) {
	my $n = $hour2auth_count{"$day_of_week:$hour_of_day"};
        unless ($n) {$n = 0;}
        $hour_total += $n;
        $day_total{$day_of_week} += $n;
        my $cell_color 
            = &get_color_code($n, \@color_threshold, \@g_color_code);
        print "<td align=right bgcolor=\"$cell_color\">$n</td>";
      }
      print "<td>&nbsp;</td><td align=right>$hour_total</td></tr>";
  }
  print "<tr><td colspan=10>&nbsp;</td></tr>";
  print "<tr><td>Total</td>";
  my $grand_total = 0;
  foreach $day_of_week (@days) {
      my $nn = $day_total{$day_of_week};
      print "<td align=right>$nn</td>";
      $grand_total += $nn;
  }
  print "<td>&nbsp;</td><td>$grand_total</td></tr>\n";
  print "</table>";

}

###########################################################################
#
#  Report 4c
#
#  Number of people who created/updated/deleted during a quarter
#  by day of week and hour
#
###########################################################################
sub report_4c {
  my ($lda, $start_quarter, $end_quarter) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select to_char(action_date, 'DY'),
     to_char(action_date, 'HH AM'),
     count(distinct roles_username) auths
     from auth_audit
    where action_date between to_date(?, 'MM/DD/YYYY')
     and to_date(?, 'MM/DD/YYYY')
    group by to_char(action_date, 'D'), to_char(action_date, 'DY'), 
          to_char(action_date, 'HH24'), to_char(action_date, 'HH AM')";
  #print "stmt 4c = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 4c: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->bind_param(1, $start_quarter)) {
        print "Error binding param 4c (1): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(2, $end_quarter)) {
        print "Error binding param 4c (2): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 4c: " . $DBI::errstr . "<BR>";
  }

  #
  #  Read in rows and build a hash 
  #    $hour2auth_count{"$day_of_week:&hour_of_day"} = $n
  #    for each day of the week and hour
  #
  #    Row contains ($day_of_week, $hour_of_day, $auth_count)
  #
  my @row;
  my ($day_of_week, $hour_of_day, $auth_count);
  my %hour2auth_count = ();
  while ( @row = $csr1->fetchrow_array ) {
    my $item;
    ($day_of_week, $hour_of_day, $auth_count) = @row;
    $hour2auth_count{"$day_of_week:$hour_of_day"} = $auth_count;
  }

  #
  #  Set color thresholds for system transaction rate.  The color codes
  #  associated with these thresholds is ni @g_color_code.  The first
  #  number should always be 0.  The next is the lowest threshold for
  #  the least intense color, and each additional number represents 
  #  a more intense color.
  #
  my @color_threshold = (0, 0, 3, 10, 20, 30);

  #
  #  Print table headers for a matrix
  #
  print "<h4><a name=\"4c\">$g_report_code_name{'4c'}</a></h4>";
  print "<blockquote><i>Each cell in the table below shows the total number
         of people who inserted, updated, or deleted at least one authorization
         during the period of time.  For example, the cell for 
         SUN&nbsp;12&nbsp;-&nbsp;12:59&nbsp;AM shows the total number of 
         people who inserted, updated or deleted authorizations on 
         on at least one Sunday during the quarter, between midnight 
         and 12:59 AM.</i>
         </blockquote>\n";
  print "<table border>\n";
  my @days = ('SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT');
  my %day_total = ();
  print "<tr>
         <th colspan=8>Number of people who did auth. maintenance</th></tr>";
  print "<tr><th>Hour of the day</th>"
        . "<th colspan=7>Day of the week</th></tr>";
  print "<tr><th>&nbsp;</th>";
  foreach $day_of_week (@days) {
      print "<th>$day_of_week</th>";
  }
  print "</tr>\n";
  foreach $hour_of_day ('12 AM', '01 AM', '02 AM', '03 AM', '04 AM', '05 AM',
            '06 AM', '07 AM', '08 AM', '09 AM', '10 AM', '11 AM',
            '12 PM', '01 PM', '02 PM', '03 PM', '04 PM', '05 PM',
	    '06 PM', '07 PM', '08 PM', '09 PM', '10 PM', '11 PM') 
  {
      my $hour_total = 0;
      my $tweaked_hour_of_day = 
        substr($hour_of_day, 0, 2) . " - " . substr($hour_of_day, 0, 2) 
        . ":59" . substr($hour_of_day, 2, 3);
      print "<tr><td>$tweaked_hour_of_day</td>";
      foreach $day_of_week (@days) {
	my $n = $hour2auth_count{"$day_of_week:$hour_of_day"};
        unless ($n) {$n = 0;}
        $hour_total += $n;
        $day_total{$day_of_week} += $n;
        my $cell_color 
            = &get_color_code($n, \@color_threshold, \@g_color_code);
        print "<td align=right bgcolor=\"$cell_color\">$n</td>";
      }
      print "</tr>";
  }
  print "</table>";

}

###########################################################################
#
#  Report 4d
#
#  Number of people created/updated/deleted during a quarter
#  by day of week and hour, excluding employees in the IS&T org unit
#
###########################################################################
sub report_4d {
  my ($lda, $start_quarter, $end_quarter) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select to_char(action_date, 'DY'),
     to_char(action_date, 'HH AM'),
     count(distinct roles_username) auths
     from auth_audit
    where action_date between to_date(?, 'MM/DD/YYYY')
     and to_date(?, 'MM/DD/YYYY')
     and roles_username not in 
       (select kerberos_name from person where primary_person_type = 'E'
        and dept_code = '$g_ist_org_unit')
    group by to_char(action_date, 'D'), to_char(action_date, 'DY'), 
          to_char(action_date, 'HH24'), to_char(action_date, 'HH AM')";
  #print "stmt 4d = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 4d: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->bind_param(1, $start_quarter)) {
        print "Error binding param 4d (1): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(2, $end_quarter)) {
        print "Error binding param 4d (2): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 4d: " . $DBI::errstr . "<BR>";
  }

  #
  #  Read in rows and build a hash 
  #    $hour2auth_count{"$day_of_week:&hour_of_day"} = $n
  #    for each day of the week and hour
  #
  #    Row contains ($day_of_week, $hour_of_day, $auth_count)
  #
  my @row;
  my ($day_of_week, $hour_of_day, $auth_count);
  my %hour2auth_count = ();
  while ( @row = $csr1->fetchrow_array ) {
    my $item;
    ($day_of_week, $hour_of_day, $auth_count) = @row;
    $hour2auth_count{"$day_of_week:$hour_of_day"} = $auth_count;
  }

  #
  #  Set color thresholds for system transaction rate.  The color codes
  #  associated with these thresholds is ni @g_color_code.  The first
  #  number should always be 0.  The next is the lowest threshold for
  #  the least intense color, and each additional number represents 
  #  a more intense color.
  #
  my @color_threshold = (0, 0, 3, 10, 20, 30);

  #
  #  Print table headers for a matrix
  #
  print "<h4><a name=\"4d\">$g_report_code_name{'4d'}</a></h4>";
  print "<blockquote><i>Each cell in the table below shows the total number
         of people, excluding IS&T employees, 
         who inserted, updated, or deleted at least one authorization
         during the period of time.  For example, the cell for 
         SUN&nbsp;12&nbsp;-&nbsp;12:59&nbsp;AM shows the total number of 
         people who inserted, updated or deleted authorizations on 
         on at least one Sunday during the quarter, between midnight 
         and 12:59 AM.</i>
         </blockquote>\n";
  print "<table border>\n";
  my @days = ('SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT');
  my %day_total = ();
  print "<tr>
         <th colspan=10>Number of people who did auth. maintenance</th></tr>";
  print "<tr><th>Hour of the day</th>"
        . "<th colspan=7>Day of the week</th><th colspan=2>&nbsp;</th></tr>";
  print "<tr><th>&nbsp;</th>";
  foreach $day_of_week (@days) {
      print "<th>$day_of_week</th>";
  }
  print "</tr>\n";
  foreach $hour_of_day ('12 AM', '01 AM', '02 AM', '03 AM', '04 AM', '05 AM',
            '06 AM', '07 AM', '08 AM', '09 AM', '10 AM', '11 AM',
            '12 PM', '01 PM', '02 PM', '03 PM', '04 PM', '05 PM',
	    '06 PM', '07 PM', '08 PM', '09 PM', '10 PM', '11 PM') 
  {
      my $hour_total = 0;
      my $tweaked_hour_of_day = 
        substr($hour_of_day, 0, 2) . " - " . substr($hour_of_day, 0, 2) 
        . ":59" . substr($hour_of_day, 2, 3);
      print "<tr><td>$tweaked_hour_of_day</td>";
      foreach $day_of_week (@days) {
	my $n = $hour2auth_count{"$day_of_week:$hour_of_day"};
        unless ($n) {$n = 0;}
        $hour_total += $n;
        $day_total{$day_of_week} += $n;
        my $cell_color 
            = &get_color_code($n, \@color_threshold, \@g_color_code);
        print "<td align=right bgcolor=\"$cell_color\">$n</td>";
      }
      print "</tr>";
  }
  print "</table>";

}

###########################################################################
#
#  Report 3b
#
#  Number of authorizations created/updated/deleted by category
#  during a quarter
#
###########################################################################
sub report_3b {
  my ($lda, $start_quarter, $end_quarter) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select function_category category,
     decode(action_type,'I','Insert','U','Update','D','Delete') Action,
     count(distinct authorization_id) auths
     from auth_audit
    where action_date between to_date(?, 'MM/DD/YYYY')
     and to_date(?, 'MM/DD/YYYY')
    group by function_category, action_type";
  #print "stmt 3b = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 3b: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->bind_param(1, $start_quarter)) {
        print "Error binding param 3b (1): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(2, $end_quarter)) {
        print "Error binding param 3b (2): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 3b: " . $DBI::errstr . "<BR>";
  }

  #
  #  Print table header
  #
  print "<h4><a name=\"3b\">$g_report_code_name{'3b'}</a></h4>";
  #print "<h4>Report 3b. Number of authorizations created/updated/deleted
  #           by category 
  #           during a quarter ($start_quarter - $end_quarter)</h4>";
  print "<table border>\n";
  print "<tr><th>Category</th><th>Action</th>
         <th>No. of auths.</th></tr>\n";

  #
  #  Print each row of the table
  #    Row contains ($cat, $action, $auth_count)
  #
  my @row;
  my $auth_count = 0;
  while ( @row = $csr1->fetchrow_array ) {
    $auth_count += $row[2];
    print "<tr>";
    my $item;
    foreach $item ( @row ) {
      print "<td>$item</td>";
    }
    print "</tr>\n";
  }

  #
  #  Print end of table
  #
  print "<tr><td colspan=2>Total</td><td>$auth_count</td><tr>\n";
  print "</table>\n";

}

###########################################################################
#
#  Report 3c
#
#  People who created/updated/deleted auths during a quarter
#
###########################################################################
sub report_3c {
  my ($lda, $start_quarter, $end_quarter) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select count(distinct roles_username) from auth_audit
    where action_date between to_date(?, 'MM/DD/YYYY')
    and to_date(?, 'MM/DD/YYYY') + 1";
  #print "stmt 3c = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 3c: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->bind_param(1, $start_quarter)) {
        print "Error binding param 3c (1): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(2, $end_quarter)) {
        print "Error binding param 3c (2): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 3c: " . $DBI::errstr . "<BR>";
  }

  #
  #  Print table header
  #
  print "<h4><a name=\"3c\">$g_report_code_name{'3c'}</a></h4>";
  #print "<h4>Report 3c. People who created/updated/deleted authorizations
  #           during a quarter ($start_quarter - $end_quarter)</h4>";
  print "<table border>\n";
  print "<tr><th>No. of people</th></tr>\n";

  #
  #  Print each row of the table
  #    Row contains ($person_count)
  #
  my @row;
  while ( @row = $csr1->fetchrow_array ) {
    print "<tr>";
    my $item;
    foreach $item ( @row ) {
      print "<td>$item</td>";
    }
    print "</tr>\n";
  }

  #
  #  Print end of table
  #
  print "</table>\n";

}

###########################################################################
#
#  Report 3d
#
#  People who created/updated/deleted auths by category during a quarter
#
###########################################################################
sub report_3d {
  my ($lda, $start_quarter, $end_quarter) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select function_category, count(distinct roles_username) from auth_audit
    where action_date between to_date(?, 'MM/DD/YYYY')
    and to_date(?, 'MM/DD/YYYY') + 1
    group by function_category";
  #print "stmt 3d = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 3d: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->bind_param(1, $start_quarter)) {
        print "Error binding param 3d (1): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(2, $end_quarter)) {
        print "Error binding param 3d (2): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 3d: " . $DBI::errstr . "<BR>";
  }

  #
  #  Print table header
  #
  print "<h4><a name=\"3d\">$g_report_code_name{'3d'}</a></h4>";
  #print "<h4>Report 3d. People who created/updated/deleted authorizations
  #           by category 
  #           during a quarter ($start_quarter - $end_quarter)</h4>";
  print "<table border>\n";
  print "<tr><th>Category</th><th>No. of people</th></tr>\n";

  #
  #  Print each row of the table
  #    Row contains ($cat, $person_count)
  #
  my @row;
  while ( @row = $csr1->fetchrow_array ) {
    print "<tr>";
    my $item;
    foreach $item ( @row ) {
      print "<td>$item</td>";
    }
    print "</tr>\n";
  }

  #
  #  Print end of table
  #
  print "</table>\n";

}

###########################################################################
#
#  Report 3e
#
#  People who created/updated/deleted auths by person type and org unit
#  during a quarter
#
###########################################################################
sub report_3e {
  my ($lda, $start_quarter, $end_quarter) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select nvl(p.primary_person_type, 'X'),
        nvl(p.dept_code,'unknown') org_unit, 
        nvl(q.qualifier_name, 'unknown') dept_name,
        count(distinct a.roles_username) people, 
        count(distinct a.authorization_id) auths
  from auth_audit a, person p, qualifier q
  where a.action_date between to_date(?, 'MM/DD/YYYY')
    and to_date(?, 'MM/DD/YYYY') + 1
    and p.kerberos_name = a.roles_username
    and q.qualifier_type(+) = 'ORGU'
    and q.qualifier_code(+) = p.dept_code
  group by p.primary_person_type, p.dept_code, q.qualifier_name";
  #print "stmt 3e = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 3e: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->bind_param(1, $start_quarter)) {
        print "Error binding param 3e (1): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(2, $end_quarter)) {
        print "Error binding param 3e (2): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 3e: " . $DBI::errstr . "<BR>";
  }

  #
  #  Print table header
  #
  print "<h4><a name=\"3e\">$g_report_code_name{'3e'}</a></h4>";
  #print "<h4>Report 3e. People who created/updated/deleted authorizations
  #           by person type and org unit 
  #           during a quarter ($start_quarter - $end_quarter)</h4>";
  print "Here we look at people who have MAINTAINED authorizations.<br />
         <i>Note that not all people who work within IS&T are considered
         to be part of the \"Central Authorizer\" role - a few people
         within IS&T are tied to this role, and this group changes from
         over time.</i><br />
         In the first column, E=Employee, S=Student, and O=Other<p />\n";
  print "<table border>\n";
  print "<tr><th>Primary<br>person<br>type</th>
             <th>Org unit code</th><th>Org unit name</th>
             <th>No. of people<br>making changes</th>
             <th>No. of auths changed</th></tr>\n";

  #
  #  Print each row of the table
  #    Row contains ($primary_person_type, $org_unit_code, $org_name,
  #                  $person_count, $auth_count)
  #
  my @row;
  while ( @row = $csr1->fetchrow_array ) {
    print "<tr>";
    my $item;
    foreach $item ( @row ) {
      print "<td>$item</td>";
    }
    print "</tr>\n";
  }

  #
  #  Print end of table
  #
  print "</table>\n";

}

###########################################################################
#
#  Report 3f
#
#  People who created/updated/deleted auths by category, person type 
#  and org unit during a quarter
#
###########################################################################
sub report_3f{
  my ($lda, $start_quarter, $end_quarter) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select a.function_category category, nvl(p.primary_person_type, 'X'),
        nvl(p.dept_code,'unknown') org_unit, 
        nvl(q.qualifier_name, 'unknown') dept_name,
        count(distinct a.roles_username) people, 
        count(distinct a.authorization_id) auths
  from auth_audit a, person p, qualifier q
  where a.action_date between to_date(?, 'MM/DD/YYYY')
    and to_date(?, 'MM/DD/YYYY') + 1
    and p.kerberos_name = a.roles_username
    and q.qualifier_type(+) = 'ORGU'
    and q.qualifier_code(+) = p.dept_code
  group by a.function_category, p.primary_person_type, p.dept_code, 
           q.qualifier_name";
  #print "stmt 3f = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 3f: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->bind_param(1, $start_quarter)) {
        print "Error binding param 3f (1): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(2, $end_quarter)) {
        print "Error binding param 3f (2): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 3f: " . $DBI::errstr . "<BR>";
  }

  #
  #  Print table header
  #
  print "<h4><a name=\"3f\">$g_report_code_name{'3f'}</a></h4>";
  #print "<h4>Report 3f. People who created/updated/deleted auths
  #           by category, person type and org unit 
  #           during a quarter ($start_quarter - $end_quarter)</h4>";
  print "Here we look at people who have MAINTAINED authorizations.<br />
         <i>Note that not all people who work within IS&T are considered
         to be part of the \"Central Authorizer\" role - a few people
         within IS&T are tied to this role, and this group changes from
         over time.</i><br />
         In the first column, E=Employee, S=Student, and O=Other<p />\n";
  print "<table border>\n";
  print "<tr><th>Category</th><th>Primary<br>person<br>type</th>
             <th>Org unit code</th><th>Org unit name</th>
             <th>No. of people<br>making changes</th>
             <th>No. of auths changed</th></tr>\n";

  #
  #  Print each row of the table
  #    Row contains ($category, $primary_person_type, 
  #                  $org_unit_code, $org_name, $person_count, $auth_count)
  #
  my @row;
  while ( @row = $csr1->fetchrow_array ) {
    print "<tr>";
    my $item;
    foreach $item ( @row ) {
      print "<td>$item</td>";
    }
    print "</tr>\n";
  }

  #
  #  Print end of table
  #
  print "</table>\n";

}

###########################################################################
#
#  Report 3h
#
#  People who created/updated/deleted auths within IS&T 
#  during a quarter
#
###########################################################################
sub report_3h{
  my ($lda, $start_quarter, $end_quarter) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select nvl(p.primary_person_type, 'X'),
        nvl(p.dept_code,'unknown') org_unit, 
        p.kerberos_name, initcap(p.first_name || ' ' || p.last_name) name,
        count(distinct a.authorization_id) auths
  from auth_audit a, person p, qualifier q
  where a.action_date between to_date(?, 'MM/DD/YYYY')
    and to_date(?, 'MM/DD/YYYY') + 1
    and p.kerberos_name = a.roles_username
    and q.qualifier_type = 'ORGU'
    and q.qualifier_code = p.dept_code
    and q.qualifier_code = '$g_ist_org_unit' 
  group by p.primary_person_type, p.dept_code, p.kerberos_name,
           p.first_name || ' ' || p.last_name
  order by p.primary_person_type, p.dept_code, p.kerberos_name";
  #print "stmt 3h = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement 3h: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->bind_param(1, $start_quarter)) {
        print "Error binding param 3h (1): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->bind_param(2, $end_quarter)) {
        print "Error binding param 3h (2): " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement 3h: " . $DBI::errstr . "<BR>";
  }

  #
  #  Print table header
  #
  print "<h4><a name=\"3h\">$g_report_code_name{'3h'}</a></h4>";
  #print "<h4>Report 3h. People who created/updated/deleted authorizations
  #           within IS&T (unit $g_ist_org_unit) 
  #           during a quarter ($start_quarter - $end_quarter)</h4>";
  print "Here we look at people who have MAINTAINED authorizations.<br />
         <i>Note that not all people who work within IS&T are considered
         to be part of the \"Central Authorizer\" role - a few people
         within IS&T are tied to this role, and this group changes from
         over time.</i><br />
         In the first column, E=Employee, S=Student, and O=Other<p />\n";
  print "<table border>\n";
  print "<tr><th>Primary<br>person<br>type</th>
             <th>Org unit code</th>
             <th>Username of person<br>who made changes</th>
             <th>Name of person<br>who made changes</th>
             <th>No. of auths changed</th></tr>\n";

  #
  #  Print each row of the table
  #    Row contains ($category, $primary_person_type, 
  #                  $org_unit_code, $kerb_name, $person_name, $auth_count)
  #
  my @row;
  while ( @row = $csr1->fetchrow_array ) {
    print "<tr>";
    my $item;
    foreach $item ( @row ) {
      print "<td>$item</td>";
    }
    print "</tr>\n";
  }

  #
  #  Print end of table
  #
  print "</table>\n";

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
    my ($lda, $k_principal, $super_category) = @_;
    my ($csr, @stmt, $result);
    if ((!$k_principal) | (!$super_category)) {
        return 0;
    }
    @stmt = ("select ROLESAPI_IS_USER_AUTHORIZED('$k_principal',"
             . "'RUN ADMIN REPORTS', 'NULL') from dual");
    $csr = $lda->prepare( "@stmt")
        || die $DBI::errstr;

    $csr->execute();
    ($result) = $csr->fetchrow_array();
    $csr->finish();
    if ($result eq 'Y') {
        return 1;
    } else {
        return 0;
    }
}
###########################################################################
#
#  Function get_color_code($number, \@color_threshold, \@color_code)
#
#  Compares $number to the threshold values in @color_threshold and returns
#  the corresponding color code.
#
###########################################################################
sub get_color_code {
    my ($number, $rcolor_threshold, $rcolor_code) = @_;
    $n = @$rcolor_threshold;
    for ($i = $n-1; $i > 0; $i--) {
	if ($number > $$rcolor_threshold[$i]) {
	    return $$rcolor_code[$i];
        }
    }
    return $$rcolor_code[0];
}
