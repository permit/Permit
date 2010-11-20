#!/usr/bin/perl
###########################################################################
#
#  CGI script to find the Department Code and any associated Primary
#  Authorizors for a given qualifier (usually a fund or cost object).
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
#  Jim Repa 5/24/2001
#  Modified, 7/4/2001, to sort PAs for the leaf-level department before
#                      PAs for parent department. Code also cleaned up.
#  Modified 3/20/2004, adjust for new Financial Primary Authorizer
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
#  Web documents definitions
#
 $host = $ENV{'HTTP_HOST'};
 $url_stem = "http://$host/cgi-bin/rolequal1.pl?";
 $url_stem2 = "http://$host/cgi-bin/rolecc_info.pl?cost_object=";
 $main_url = "http://$host/webroles.html";

#
#  HTML files read by this program to build output
#
 $html_file = "../htdocs/req_auth.html";

#
#  More constants
#
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 $cat = 'SAP';  # Category for which to check meta-authorization
 $cat2 = 'META';  # 2nd category (if first check fails).

#
#  Print out top of the http document.  
#
 print "Content-type: text/html", "\n\n";
 print "<HTML>", "\n";
 print "<HEAD><TITLE>Departments and PAs for a Fund</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';

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
 %formval = ();  # Hash of reformatted key->variables populated by &parse_forms
 %rawval = ();  # Hash of unformatted key->variables populated by &parse_forms
 &parse_forms($input_string, \%formval, \%rawval); # Call sub. to parse input

#
#  Get qualifier_code or qualifier_id
#
 $qcode = $formval{'qualcode'};  # Get qualifier_code
 $qualtype = $formval{'qualtype'};  # Get qualifier_type
 $qualcode = &strip($qualcode);
 $qualcode =~ tr/a-z/A-Z/; # Upper case
 $qualtype = &strip($qualtype);
 $qualtype =~ tr/a-z/A-Z/; # Upper case


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
#  Log something
#
 $remote_host = $ENV{'REMOTE_HOST'};
 chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
 print STDERR "***$time $remote_host $k_principal $progname $info\n";

#
#  Open connection to DBI
#
use DBI;
my $lda = login_dbi_sql('roles')   
      || &web_error("DB error in login. "
          . "The database may be shut down temporarily for backups." 
          . "<BR><BR>" . $DBI::errstr);

#
# Look up the qualifier
#
 ($qualid, $qualname, $qt_description) 
      = &get_qualifier($lda, $qualtype, $qcode);

#
#  Set up '*' link to "Tell me about a cost object"
#
 $qcode_string = $qcode;
 $qcode_string .= ' <A HREF="' . $url_stem2 . $qcode . '">*</A>'; 

#
#  Build the header based on the business function and cost object
#
 
 &print_header("Financial Primary Authorizers for the department(s) related to $qcode", 
               'https');

#
#  Get department code(s)
#
 @dept_list = ();
 @dept_name_list = ();
 &get_department($lda, $qualid, \@dept_list, \@dept_name_list);

#
#  Print out information about the qualifier
#
 print "<HR>", "\n";
 if (!($qualid)) {
   &web_error("Error looking up $qcode (type $qualtype) - not found<br>");
 }
 print "<table>";
 print "<tr><td>Object:</td><td>$qcode</td></tr>";
 print "<tr><td>Type:</td><td>$qt_description</td></tr>";
 print "<tr><td>Name:</td><td>$qualname</td></tr>";
 #print "<tr><td>Qualifier ID:</td><td>$qualid</td></tr>";
 $num_departments = @dept_list;
 if ($num_departments == 1) {
   $dept_string = "$dept_list[0] ($dept_name_list[0])";
 }
 elsif ($num_departments == 0) {
   $dept_string = "<i>Not linked to a department</i>";
 }
 else {
   $dept_string = 
     "<i>linked to $num_departments different departments - see below</i>";
 }
 print "<tr><td>Department:</td><td>$dept_string</td></tr>";
 print "</TABLE>";

#
#  If the qualifier does not have a department, then quit now.
#
 if (!$num_departments) {
   print "<BR><B>$qcode is not linked to a department.<BR>"
         . "There are no Financial Primary Authorizers.</B><BR>";
 }

#
# Make sure the user has a meta-authorization to view $cat authorizations.
# It is also OK if the person has a meta-authorization to view $cat2 
# category authorizations.  (e.g., META or SAP).
#
 if (!(&verify_metaauth_category($lda, $k_principal, $cat))) { # try 1st cat
   if (!(&verify_metaauth_category($lda, $k_principal, $cat2))) { # 2nd cat
     print "<HR><P>";
     print "Sorry. You cannot view the list of Financial Primary Authorizers"
     . " because you do not have the required perMIT DB 'meta-authorization'"
     . " to view other people's $cat authorizations.";
     exit();
   }
 }

#
#  For each department, 
#  call subroutine &print_pa_list to print out list of PAs.
#
 print "<HR><P>";
 for ($i = 0; $i < @dept_list; $i++) {
   $dept_code = $dept_list[$i];
   $dept_name = $dept_name_list[$i];
   print "Financial Primary Authorizers for $dept_code ($dept_name):<P>";
   &print_pa_list($lda, $dept_code, $dept_name);
   print "<P>";
 }
 
#
#  
#
 print "<HR>";

 exit(0);

###########################################################################
#
#  Subroutine get_qualifier(
#  Given a qualifier_type and qualifier_code, looks in the qualifier
#  table and returns the qualifier_id and qualifier_name.
#
###########################################################################
sub get_qualifier {
  my ($lda, $qtype, $qcode) = @_;

  #
  #  Do query against the qualifier table
  #
  my @stmt = ("select q.qualifier_id, q.qualifier_name, qt.qualifier_type_desc"
   . " from qualifier q, qualifier_type qt"
   . " where q.qualifier_type = '$qtype'"
   . " and q.qualifier_code = '$qcode'"
   . " and qt.qualifier_type = q.qualifier_type");
  my $csr = $lda->prepare("$stmt")
	|| &web_error("Oracle error in open. "
           . "Problem with select from qualifier table."
           . "<BR><BR>" . $DBI::errstr);
  $csr->execute();
  my ($qualid, $qualname, $qt_description) = $csr->fetchrow_array() ;
  $csr->finish() || &web_error("DB error. can't close cursor");

  #
  #  Return the values.
  #
  
  return ($qualid, $qualname, $qt_description);
}

###########################################################################
#
#  Subroutine get_department
#  Does a join between qualifier table and primary_auth_descendent table
#  to find the department associated with the fund.
#
###########################################################################
sub get_department {
  my ($lda, $qualid, $rdept_list, $rdept_name) = @_;

  #
  #  Do query against the qualifier table
  #
  my @stmt = ("select q2.qualifier_code, q2.qualifier_name"
   . " from primary_auth_descendent pad, qualifier q2"
   . " where pad.child_id = '$qualid'"
   . " and pad.is_dlc = 'Y'"
   . " and q2.qualifier_id = pad.parent_id");
  my $csr = $lda->prepare("$stmt")
	|| &web_error("Oracle error in open. "
           . "Problem with select from qualifier table."
           . "<BR><BR>" . $DBI::errstr);
  my $i = 0;
  my ($dept_code, $dept_name);
  while (($dept_code, $dept_name) = &ora_fetch($csr)) {
    push(@$rdept_list, $dept_code);
    push(@$rdept_name, $dept_name);
  }
  $csr->finish() || &web_error("DB error. can't close cursor");

}

###########################################################################
#
#  Subroutine print_pa_list
#
###########################################################################
sub print_pa_list {
  my ($lda, $dept_code) = @_;

  #
  #  If the function code is 'APPROVER' with a release strategy other than
  #  Model 1, then call another subroutine to set up the sql statement.  
  #  Otherwise, it's simple;  set it up right here.
  #
  my @stmt = ("select a.kerberos_name, a.function_name, a.qualifier_code,"
   . " initcap(p.last_name || ', ' ||  p.first_name), a.qualifier_name, '1'"
   . " from authorization a, person p, function f"
   . " where f.function_id = a.function_id"
   . " and f.is_primary_auth_parent = 'Y'"
   . " and f.primary_auth_group = 'FIN'"
   . " and a.qualifier_code = '$dept_code'"
   . " and sysdate between a.effective_date and nvl(a.expiration_date,sysdate)"
   . " and a.do_function = 'Y'"
   . " and p.kerberos_name = a.kerberos_name"
   . " union select a.kerberos_name, a.function_name, a.qualifier_code,"
   . " initcap(p.last_name || ', ' ||  p.first_name), a.qualifier_name, '2'"
   . " from qualifier q, qualifier_descendent qd, authorization a, person p,"
   . "  function f"
   . " where q.qualifier_type = 'DEPT'"
   . " and q.qualifier_code = '$dept_code'"
   . " and qd.child_id = q.qualifier_id"
   . " and a.qualifier_id = qd.parent_id"
   . " and f.function_id = a.function_id"
   . " and f.is_primary_auth_parent = 'Y'"
   . " and f.primary_auth_group = 'FIN'"
   . " and a.descend = 'Y'"
   . " and sysdate between a.effective_date and nvl(a.expiration_date,sysdate)"
   . " and a.do_function = 'Y'"
   . "  and p.kerberos_name = a.kerberos_name"
   . " order by 6,1");

  #
  #  Print a list of authorizations
  #
  #print @stmt;
  my $csr = $lda->prepare("$stmt")
	|| &web_error($DBI::errstr );
  $csr->execute();
  my $n = 0;
  my $old_aaqc = '';
  while (($aakerb, $aafn, $aaqc, $aaname, $aaqname) = $csr->fetchrow_array() )
  {
    $n++;
    if ($n == 1) {
      print "<TABLE>", "\n";
      printf "<TR><TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH>"
             . "<TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH>"
             . "<TH ALIGN=LEFT>%s</TH></TR>\n",
             'Last, First<BR>Name', 'Kerberos<BR>Username', 'Function Name', 
             'Dept.<BR>Code', 'Department<BR>Name';
    }
    if ( ($old_aaqc) && ($old_aaqc ne $aaqc) ) {
      printf "<TR><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT><small>%s</small></TD>"
        . "<TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT><small>%s</small></TD>"
        . "<TD ALIGN=LEFT><small>%s</small></TD></TR>\n",
	' ', ' ', ' ', '- - - -', '- - - - - - - - - -';
    }
    elsif ($old_aaqc) {
      printf "<TR><TD>%s</TD></TR>\n",
              ' ';
    }
    printf "<TR><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT><small>%s</small></TD>"
        . "<TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT><small>%s</small></TD>"
        . "<TD ALIGN=LEFT><small>%s</small></TD></TR>\n",
             $aaname, $aakerb, $aafn, $aaqc, $aaqname;
    $old_aaqc = $aaqc;
  }
  if (!$n) {
    print "<P><I>There are no Financial Primary Authorizers for $dept_code</I><BR>";
  }
  else {
    print "</TABLE>", "\n";
  }
  $csr->finish() || &web_error("can't close cursor");

}

########################################################################
#
#  Strips off trailing <cr> and leading and trailing blanks.
#
###########################################################################
sub strip {
  local($s);  #temporary string
  $s = $_[0];
  $s =~ s/\'/\"/;  # Change back-tick to double quote to foil hackers.
  while ($s =~ /[\s\n]$/) {   # Remove trailing <cr> or space
    chop($s);
  }
  while (substr($s,0,1) =~ /^\s/) {
    $s = substr($s,1);
  }
 
  $s;
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
  chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
  #print STDERR "***$time $remote_host $k_principal $progname Error.\n";
  exit(0);
}


