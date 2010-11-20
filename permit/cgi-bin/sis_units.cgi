#!/usr/bin/perl
###########################################################################
#
#  CGI script to display differences between AORG, SISO, and Warehouse
#  SIS_DEPARTMENT units.  
#
#
#  Copyright (C) 2006-2010 Massachusetts Institute of Technology
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
#  Written 3/10/2006 Jim Repa
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
#  Web stem constants
#
 $host = $ENV{'HTTP_HOST'};
 $main_url = "http://$host/webroles.html";
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 $url_stem = "/cgi-bin/qualauth.pl?qualtype=PCCS&rootcode=";

#
#  Print out the first line of the document
#
  print "Content-type: text/html", "\n\n";

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
#  Check certificate
#
  $info = $ENV{"SSL_CLIENT_S_DN"};  # Get certificate information
  %ssl_info = &parse_authentication_info($info);  # Parse certificate into a Perl "hash"
  $email = $ssl_info{'Email'};    # Get Email address from cert. 'Email' field
  $full_name = $ssl_info{'CN'};   # Get full name from cert. 'CN' field
  ($k_principal, $domain) = split("\@", $email);
  if (!$k_principal) {
      print "<br><b>No certificate sent.  Use https:// , not http://</b>\n";
      exit();
  }
  $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase
  $result = &check_auth_source(\%ssl_info); # Check other certificate fields
  if ($result ne 'OK') {
      print "<br><b>Your certificate cannot be accepted: $result";
      exit();
  }

#
#  Get set to use Oracle.
#
use DBI;

#
#  Get form variables
#
$letter = $formval{'letter'};  # Get value set in &parse_forms()
$letter =~ tr/a-z/A-Z/;  # Raise to upper case
unless($letter) {$letter = 'A';}

#
# Login into the database
# 
$lda = login_dbi_sql('roles') 
      || die $DBI::errstr;

#
#  Print out the http document.  
#
 print "<HTML>", "\n";
 print "<HEAD><TITLE>SIS Units Comparison</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 &print_header("SIS Units Comparison", 'http');
 print "<HR>", "\n";
 my $gray_gray = &make_gray('gray');
 print "<p />The following table compares records from three sources:
       <ul>
        <li>The SIS_DEPARTMENT table in the Warehouse
        <li>The AORG qualifiers in the perMIT DB
        <li>The SISO qualifiers in the perMIT system (shown in $gray_gray
            if it is a subject rather than a course number)
       </ul>
       <p />";

#
#  Call subroutine to print out the table
#
 &sis_units_report($lda);

 #
 #  Print end of document, and drop connection to Oracle.
 #
 print "<HR>", "\n";
 print "<A HREF=\"$main_url\">"
  . "<small>Back to main perMIT web interface page</small></A>";
 print "</BODY></HTML>", "\n";
 $lda->disconnect() || die "can't log off Oracle";

 exit(0);

###########################################################################
#
#  Run SIS units report
#
###########################################################################
sub sis_units_report {
  my ($lda, $letter) = @_;

  #
  #  Open a cursor for a select statement
  #
  my $stmt = 
  "select w.department_code dept_code, w.department_code wh, 
                              q1.qualifier_code aorg,
                              q2.qualifier_code siso,
           w.department_name
      from sis_department\@warehouse w, qualifier q1, qualifier q2
      where q1.qualifier_code(+) = w.department_code
      and q1.qualifier_type(+) = 'AORG'
      and q2.qualifier_code(+) = w.department_code
      and q2.qualifier_type(+) = 'SISO'
    union select q1.qualifier_code, w.department_code wh, 
                              q1.qualifier_code aorg,
                              q2.qualifier_code siso,
                 q1.qualifier_name
      from sis_department\@warehouse w, qualifier q1, qualifier q2
      where q1.qualifier_code = w.department_code(+)
      and q1.qualifier_type = 'AORG'
      and w.department_code is null
      and q2.qualifier_code(+) = w.department_code
      and q2.qualifier_type(+) = 'SISO'
    union select q2.qualifier_code, w.department_code wh, 
                              q1.qualifier_code aorg,
                              q2.qualifier_code siso,
                 q2.qualifier_name
      from sis_department\@warehouse w, qualifier q1, qualifier q2
      where q2.qualifier_code = w.department_code(+)
      and q2.qualifier_type = 'SISO'
      --and q2.qualifier_code not like '%.%'
      and w.department_code is null
      and q1.qualifier_code(+) = q2.qualifier_code
      and q1.qualifier_type(+) = 'AORG'
      and q1.qualifier_code is null
    order by 1";
  my $csr = $lda->prepare("$stmt")
	|| die $DBI::errstr;
  $csr->execute();

  #
  # Start the table
  # 
   print "<table border>", "\n";
   print "<tr align=left>"
         . "<th>WH SIS Dept.</th><th>AORG qualifier</th>"
         . "<th>SISO qualifier</th><th>Unit name</th></tr>";
  
  #
  #  Get a list of SIS Units found in 3 different places:
  #  (1) Warehouse SIS_DEPARTMENT table, (2) perMIT system AORG hierarchy,
  #  (3) perMIT system SISO hierarchy
  #
  my ($dept_code, $wh_dept_code, $aorg_code, $siso_code, $unit_name);
  
  while (  ($dept_code, $wh_dept_code, $aorg_code, $siso_code, $unit_name)
           = $csr->fetchrow_array() )
  {
    grep(defined || 
          ($_ = '&nbsp;'),
	   $wh_dept_code, $aorg_code, $siso_code);
    $siso_code = ($siso_code =~ /\./) ? &make_gray($siso_code) : $siso_code;
    $unit_name = ($siso_code =~ /\./) ? &make_gray($unit_name) : $unit_name;
    print "<tr align=left>"
        . "<td>$wh_dept_code</td>"
        . "<td>$aorg_code</td>"
        . "<td>$siso_code</td>"
        . "<td>$unit_name</td>"
        . "</tr>\n";
  }
   $csr->finish() || die "can't close cursor";
  print "</TABLE>", "\n";


}

###########################################################################
#
#  Function &make_gray($astring)
#
#  Wraps HTML around a string to make it appear gray
#
###########################################################################
sub make_gray {
    my ($astring) = @_;
    return "<font color=\"gray\">$astring</font>";
}


