#!/usr/bin/perl
##############################################################################
#
# CGI script to list a person's perMIT system authorizations, both
# explicitly-granted and implied.
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
# Written by Jim Repa, 9/4/2008
# Modified 9/16/2008
# Modified 9/19/2008.  Add missing lookup condition in report3
#
##############################################################################
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
#  Set constants
#
$host = $ENV{'HTTP_HOST'};
$url_stem = "https://$host/cgi-bin/qualauth.pl?"; # URL for qualifiers
$0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
$progname = $1;    # Set $progname to this string.
$url_stem1 = "https://$host/cgi-bin/$progname?report=1"; # URL for auth detail
$url_stem2 = "https://$host/cgi-bin/$progname?report=2&"; # URL for auth detail
$url_stem3 = "https://$host/cgi-bin/$progname?report=3&"; # URL for rule detail
$url_f_grp_stem = 
   "https://$host/cgi-bin/implied_auth_rules1.cgi?lookup_number=2&function_group_name="; # URL for details about a function group
$help_url = "http://$host/auth_by_user_help.html";
$main_url = "http://$host/webroles.html";
$g_rule_string = 'Rule';
$g_bg_yellow = "bgcolor=\"#FFFF88\"";
$g_bg_green = "bgcolor=\"#88FF88\"";

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
#  Print beginning of the document
#    
print "Content-type: text/html\n\n";  # Start generating HTML document
print "<head><title>Authorizations List</title><head>";
#print "<head><title>Authorizations List</title></head>\n<body><center>";
print '<BODY bgcolor="#fafafa">';

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
#  Determine the username and category for which to list authorizations.
#
 $g_viewuser = $formval{'username'};
 unless ($g_viewuser) {$g_viewuser = $k_principal;}
 $g_viewuser =~ tr/a-z/A-Z/;
 $g_category = $formval{'category'};
 unless ($g_category) {$g_category = 'ALL';}
 $g_category =~ s/\W.*//;  # Keep only the first word.
 $g_category =~ tr/a-z/A-Z/;
 $g_report = $formval{'report'};
 if ($g_report eq '') {$g_report = 1;}
 $g_authid = $formval{'authid'};

#
#  Determine title and print header  
#
 my $title;
 if ($g_report == 0) {
   $title = "perMIT system List authorizations for a user";
   $title .= "<br><small>(includes implied authorizations)</small>";
 }
 if ($g_report == 1) {
   $title = "perMIT system Authorizations for $g_viewuser";
   if ($g_category && $g_category ne 'ALL') {
     $title .= " in category $g_category";
   }
   $title .= "<br><small>(includes implied authorizations)</small>";
 }
 elsif ($g_report == 2) {
   $title = "perMIT system Authorization Detail";
 }
 elsif ($g_report == 3) {
   $title = "perMIT system - Source of an implied authorization";
 }
 if ($g_report == 1) {
   &print_header($title, 'https', $help_url);
 }
 else {
   &print_header($title, 'https', '');
 }

#
#  Get set to use Oracle.
#
use DBI;

#
# Login into the database
# 
 $lda = login_dbi_sql('roles') 
      || die $DBI::errstr;

#
#  If this is Report 0, then print a form for displaying authorizations
#
 if ($g_report == 0) {
   &report0($lda, $k_principal);
 }

#
#  If this is Report 1, then print user authorizations.
#
 if ($g_report == 1) {
   &report1($lda, $g_category, $g_viewuser, $k_principal);
 }

#
#  If this is Report 2, then print details about a single authorization
#
 elsif ($g_report == 2) {
   &report2($lda, $g_authid, $k_principal);
 }

#
#  If this is Report 3, then find rule(s) that generated a given
#  implied authorization.
#
 elsif ($g_report == 3) {
   &report3($lda, $g_authid, $k_principal);
 }

 print "</body></html>";


###########################################################################
#
#  Subroutine report1 ($lda, $pick_cat, $picked_user, $login_user)
#
#  Prints out the authorizations for $picked_user in the category
#  $picked_cat
#
###########################################################################
sub report1 {
    my ($lda, $picked_cat, $picked_user, $login_user) = @_;
    my (@afc, @afn, @aqc, @adf, @agandv, @adescend, $aafc, $aafn, $aaqc, 
        $aadf, $aagandv, $aadescend, $csr, $n, $stmt, $rc);

    $picked_user = &strip($picked_user);
    $picked_cat = &strip($picked_cat);

   #
   #  Print information about the person.  Quit if person not found.
   #
    if (!($rc = &print_user_info($lda, $picked_user))) {
      return;
    }

   #
   #  Check to make sure the user is authorized to view auths in the
   #  selected category.
   #
    my %viewable_cat;
    &get_viewable_categories($lda, $k_principal, \%viewable_cat);
    #print "List of viewable categories...<BR>";
    #foreach $key (sort keys %viewable_cat) {
    #  print "$key -> $viewable_cat{$key}<BR>";
    #}

   #
   #  From the hash of viewable categories, build a string to represent
   #  an SQL fragment.
   #
    $catlist_string = &get_sql_frag_cat_list(\%viewable_cat);

   #
   #  Build a SQL fragment to filter the set of categories that this person
   #  can see
   #
    $sql_frag1 = '';
    my $cat_string;
    ## If the user has asked for a specific category, then make sure
    ## either that the user is looking at his own authorizations or the
    ## user is authorized to see auths in the selected category.  If
    ## so, build the string; otherwise, stop with an error message.
    if ( ($picked_cat && ($picked_cat ne 'ALL')) 
         && ( ($picked_user eq $login_user) || ($viewable_cat{$picked_cat}) )
       )
    {
      $sql_frag1 = "function_category = '$picked_cat'";
      $cat_string = "category $picked_cat";
    }
    ## If the user asked for all categories and the user is authorized to
    ## see them all, then the sql fragment is null
    elsif ( ($picked_cat eq 'ALL') 
             && ( ($picked_user eq $login_user)
                  || ($viewable_cat{$picked_cat}) )
          )
    {
      $sql_frag1 = '';
      $cat_string = 'any category';
    }
    ## Otherwise, the user asked for all categories but is not authorized
    ## to see them all.  Build a SQL fragment to limit the user to
    ## just those categories he can see
    else {
      $sql_frag1 = "function_category in $catlist_string";
      $cat_string = 'any of categories you are authorized to view';
    }
    #print "sql_frag1='$sql_frag1'<BR>";

   #
   #  Now, build the SQL select statement
   #
             #. " decode(auth_type, 'E', 'n/a',"
             #.         " decode(grant_and_view, 'GD', 'Y', 'N')), "
             #. " decode(a.auth_type, 'R', 'user ' || a.modified_by,"
             #.      " decode(nvl(flp.pass_number, 2), 1, 'Data Warehouse',"
             #.      "        '$g_rule_string')),"
    if ($sql_frag1) {$sql_frag1 = " and $sql_frag1";}
    $stmt = "select function_category, function_name,"
	     . " q.qualifier_code, do_function,"
             . " CASE auth_type WHEN  'E' THEN 'n/a'"
             .         " ELSE CASE grant_and_view WHEN 'GD' THEN 'Y' ELSE 'N' END END, "
             . " descend,"
             . " a.qualifier_id, q.qualifier_type, q.has_child,"
             . " qt.qualifier_type_desc,"
             . " AUTH_SF_IS_AUTH_CURRENT(a.effective_date, a.expiration_date),"
             . " CASE a.auth_type WHEN 'R' THEN CONCAT('user ' , a.modified_by)"
             .      " ELSE CASE IFNULL(flp.pass_number, 2) WHEN 1 THEN 'Data Warehouse'"
             .      "     ELSE    '$g_rule_string' END END,"
             . " a.authorization_id"
	     . " from qualifier q, qualifier_type qt,"  
	     . "   function_load_pass flp left outer join authorization2 a ON (flp.function_id = a.function_id) "
	     . " where a.kerberos_name = ?"
             . " and q.qualifier_id = a.qualifier_id"
             . "$sql_frag1"
             . " and qt.qualifier_type = q.qualifier_type"
	     . " order by function_category, function_name, qualifier_code";
    #print "stmt='$stmt'<BR>";
    unless ($csr=$lda->prepare($stmt)){
      print "Error preparing select statement (list auths): " 
      . $DBI::errstr . "<br>";
    }
    $csr->bind_param(1, $picked_user);
    unless ($csr->execute) {
      print "Error executing select statement (list auths): " 
      . $DBI::errstr . "<br>";
    }

    #
    #  If the user has asked for all categories but is limited to which
    #  categories he can view, then list those that the user has access
    #  to.
    #
    if ($picked_cat eq 'ALL' && !($viewable_cat{'ALL'}) ) {
      print "<p />You have requested a list of authorizations for 
             '$picked_user' in all categories.  The report will include 
             only authorizations in the following categories which you 
             are authorized to view:";
     print "<ul>"; 
     foreach $key (sort keys %viewable_cat) {
       print "<li>$key - $viewable_cat{$key}";
     }
     print "</ul>"; 
    }    

    #
    #  Get a list of authorizations
    #
    @afc = ();
    @afn = ();
    @aqc = ();
    @adf = ();
    @agandv = ();
    @adescend = ();
    @aqid = ();
    @aqt = ();
    @ahc = ();
    @aqtd = ();
    @acurrent = ();
    @asource = ();
    @aauthid = ();
    while (($aafc, $aafn, $aaqc, $aadf, $aagandv, $aadescend, $aaqid, 
            $aaqt, $aahc, $aaqtd, $aacurrent, $aasource, $aaauthid) 
	    = $csr->fetchrow_array )
    {
  	# mark any NULL fields found
	grep(defined || 
	     ($_ = '<NULL>'),
	     $aafc, $aafn, $aaqc, $aadf, $aagandv, $aadescend, $aaqt);
        $aafc =~ s/\s+$//;  # Strip off trailing blanks
        push(@afc, $aafc);
        push(@afn, $aafn);
        push(@aqc, $aaqc);
        push(@adf, $aadf);
        push(@agandv, $aagandv);
        push(@adescend, $aadescend);
        push(@aqid, $aaqid);
        push(@aqt, $aaqt);
        push(@ahc, $aahc);
        push(@aqtd, $aaqtd);
        push(@acurrent, $aacurrent);
        push(@asource, $aasource);
        push(@aauthid, $aaauthid);
        #print "$aakerb, $aafn, $aaqc, $aadf, $aagandv, $aadescend \n";
    }
    $csr->finish() || die "can't close cursor";
    
    # 
    #  Print out the http document.
    #
 
    $n = @afc;  # How many authorizations?
    print "<P>";
    if ($n != 0) {
	print "<TABLE border>", "\n";
        print "<tr><th>Function<br>Category</th><th>Function<br>Name</th>"
              . "<th>Qualifier<br>Code</th><th>Do<br>function</th>"
              . "<th>Grant</th><th>Effective<br>Today</th>"
              . "<th>Source of<br>Authorization</th>"
              . "<th>Click for<br>Details</th></tr>";
	for ($i = 0; $i < $n; $i++) {
	    if ($adf[$i] eq 'N' || $acurrent[$i] eq 'N') {
		$fcolor1 = "<FONT COLOR=GRAY>";
		$fcolor2 = "<\FONT>";
	    }
	    else {
		$fcolor1 = '';
		$fcolor2 = '';
	    }
            $qcode_string = ($aqc[$i] ne 'NULL')
              ? '<A HREF="' . $url_stem . "qualtype=" 
                . &web_string("$aqt[$i] ($aqtd[$i])")
                . '&rootcode=' . &web_string($aqc[$i]) . '">' 
                . $aqc[$i] . '</A>'
              : $aqc[$i];
            $link_string = "<A HREF='" . $url_stem2 
               . "authid=" . $aauthid[$i]
               . "'>*</A>";
            if ($i > 0 && $afc[$i] ne $afc[$i-1]) {
		print "<tr><td colspan=8>&nbsp;</td></tr>";
            }
	    print "<TR><TD>$afc[$i]</TD>"
                . "<TD>${fcolor1}$afn[$i]${fcolor2}</TD>"
                . "<TD>$qcode_string</TD>"
                . "<TD ALIGN=CENTER>$adf[$i]</TD>"
	        . "<TD ALIGN=CENTER>$agandv[$i]</TD>"
                . "<TD ALIGN=CENTER>$acurrent[$i]</TD>"
                . "<TD>$asource[$i]</TD>"
                . "<TD ALIGN=CENTER>$link_string</TD></TR>\n",
	}
	print "</TABLE>", "\n";
    } 
    else {
	#
	# $picked_user has no authorizations in $picked_cat
	#
         print "No authorizations found for $picked_user in ${cat_string}.";
    }

   #
   #  If the end user is authorized to view authorizations for others,
   #  print a form allowing him/her to run another report.
   #
    $n = (keys %viewable_cat);
    if ($n) {
      print "&nbsp;<p /><hr><p />\n";
      print "To run another report, ";
      &print_new_report_form($lda, \%viewable_cat, 
                           $picked_user, $picked_cat);
    }

}

###########################################################################
#
#  Function print_user_info($lda, $user)
#
#  Returns 1 if the person is found, 0 if not.
#
#  Prints first_name, last_name, etc. for the given user.
#
###########################################################################
sub print_user_info {
    my ($lda, $picked_user) = @_;

    $picked_user = &strip($picked_user);
    $picked_user =~ tr/a-z/A-Z/;
    
             #. " decode(status_code, 'A', '', 'I', 'inactive'),"
             #. " decode(primary_person_type, 'S', 'student', 'E', 'employee',"
             #. " and q.qualifier_type(+) = 'ORGU'";
    my $stmt = "select initcap(first_name), initcap(last_name),"
             . " CASE status_code WHEN  'A' THEN '' WHEN  'I' THEN 'inactive' END,"
             . " CASE primary_person_type WHEN 'S' THEN 'student' WHEN 'E' THEN 'employee'"
             . "      ELSE  'other' END ,"
             . " dept_code , q.qualifier_name"
             . " from qualifier q left outer join  person p ON ( p.dept_code = q.qualifier_code)"
             . " where kerberos_name = ?"
             . " and q.qualifier_type = 'ORGU'";
    my $csr;
    unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select stmt user_info: " . $DBI::errstr . "<BR>";
      exit();
    }
    unless ($csr->bind_param(1, $picked_user)) {
        print "Error binding param 1 in user_info: " 
        . $DBI::errstr . "<BR>";  
        exit();
    }
    unless ($csr->execute) {
      print "Error executing user_info select stmt: " . $DBI::errstr . "<BR>";
      exit();
    }

    #
    #  Get info on the person
    #
    my ($first_name, $last_name, $status, $person_type, $dept_code,
        $dept_name) = $csr->fetchrow_array;
    $csr->finish() || die "can't close cursor";
    
    # 
    #  Print out info on the person
    #
    if (!($first_name)) {
	print "Username '$picked_user' not found<BR>";
        return 0;
    }
    else {
      $dept_name = ($dept_name) ? ', ' . $dept_name : '';
      print "<P><small>$first_name $last_name, $status"
            . " ${person_type}$dept_name</small><br>";
      return 1;
    }

}

###########################################################################
#
#  Subroutine get_viewable_categories($lda, $login_user, \%viewable_cat)
#  
#  Gets a list of Categories for which the end-user is authorized to
#  view authorizations.
#  Fills in the hash %viewable_cat (which maps category to its name),
#  with an entry for each category the login_user is authorized for.
#
###########################################################################
sub get_viewable_categories {
    my ($lda, $login_user, $rviewable_cat) = @_;
    my ($stmt, $csr, $viewable_category, $category_d);
    
    #
    # Statement used in the query
    #
    $stmt = "select function_category, function_category_desc 
             from category 
              where ROLESAPI_IS_USER_AUTHORIZED('$login_user',
                   'VIEW AUTH BY CATEGORY',CONCAT('CAT' 
                   , rtrim(function_category))) = 'Y'
             union select substr(a.qualifier_code, 4), 'All categories'
              from authorization a 
              where a.kerberos_name = '$login_user'
              and a.function_name = 'VIEW AUTH BY CATEGORY'
              and a.qualifier_code = 'CATALL'
              and a.do_function = 'Y'
              and NOW() between 
                a.effective_date and IFNULL(a.expiration_date, NOW())
             union select c.function_category, c.function_category_desc
              from category c
              where c.function_category in ('SAP','META', 'ADMN', 'LABD', 'HR')
              and exists 
              (select authorization_id from authorization
               where kerberos_name = '$login_user'
               and function_category in ('SAP', 'HR')
               and do_function = 'Y'
               and NOW() between effective_date
               and IFNULL(expiration_date,NOW()))";
    #print "<br>stmt='$stmt'<BR>";
    my $csr;
    unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select stmt viewable cat: " . $DBI::errstr 
            . "<BR>";
      exit();
    }
    unless ($csr->execute) {
      print "Error executing select stmt viewable_cat: " . $DBI::errstr 
         . "<BR>";
      exit();
    }
    
    #
    #  Get a list of function categories
    #
    while ( (($viewable_category,$category_d) = $csr->fetchrow_array) ) {
        unless ($category_d) {$category_d = 'null';}
        $$rviewable_cat{$viewable_category} = $category_d;
    }
    $csr->finish();
}

###########################################################################
#
#  Subroutine get_sql_frag_cat_list(\%viewable_cat)
#  
#  Returns a string in the form "('cat1', 'cat2', ...)"
#  containing categories the end-user is allows to view authorizations for.
#
###########################################################################
sub get_sql_frag_cat_list {
    my ($rviewable_cat) = @_;
    my ($sql_frag);
    foreach $key (sort keys %$rviewable_cat) {    
      if ($sql_frag) {
        $sql_frag .= ", '$key'";
      }
      else {
        $sql_frag = "'$key'";
      }
    }
    if ($sql_frag) {
      $sql_frag = "(${sql_frag})";
    }
}

###########################################################################
#
#  Subroutine report0($lda, $login_user)
#
#  Display a form that the user will fill in to view authorizations
#
###########################################################################
sub report0 {
  my ($lda, $login_user) = @_;  # Get Oracle login handle.

   #
   #  Check to make sure the user is authorized to view auths in the
   #  selected category.
   #
    my %viewable_cat;
    &get_viewable_categories($lda, $k_principal, \%viewable_cat);

   #
   #  If the end user is authorized to view authorizations for others,
   #  print a form allowing him/her to run another report.
   #
    $n = (keys %viewable_cat);
    if ($n) {
       print "<hr><p />\n";
       print "To list authorizations for a person, ";
       &print_new_report_form($lda, \%viewable_cat, 
                              $picked_user, $picked_cat);
    }
    else {
        print "<hr><p />\n";
	print "You are only authorized to view your own authorizations.<p />";
        print "<a href=\"$url_stem1\">View my authorizations</a>\n";
    }
}

##########################################################################
#
#  Subroutine report2.
#
#  Display details on an authorization
#
###########################################################################
sub report2 {

  my ($lda, $authorization_id, $login_user) = @_;  # Get Oracle login handle.
  my ($auth_id, $func_id, $qual_id, $qual_name, $modified_by,
          $modified_date, $do_function, $grant, $descend,
          $effective_date, $expiration_date, $func_desc);
  my $auth_found = 0;

  #
  #  Open a cursor for select statement.
  #
              #. " decode(a.auth_type, 'R', 'individually granted by a person',"
             # .      " decode(nvl(flp.pass_number, 2), 1, "
             # .      " 'auto loaded from Data Warehouse', 'Rule')),"
              #. " and flp.function_id(+) = a.function_id"
              #. " and q.qualifier_id(+) = a.qualifier_id";
              #. " and q.qualifier_id(+) = a.qualifier_id";
  my $stmt = "select a.authorization_id, a.function_id, a.qualifier_id,"
              . " a.qualifier_name, a.modified_by,"
              . " DATE_FORMAT(a.modified_date,'%b %d, %Y %r'),"
              . " a.do_function,"
              . " CASE a.grant_and_view WHEN 'GD' THEN 'Y' ELSE 'N' END,"
              . " a.descend,"
              . " DATE_FORMAT(a.effective_date,'%b %d, %Y'),"
              . " DATE_FORMAT(a.expiration_date,'%b %d, %Y'),"
              . " f.function_description, a.kerberos_name,"
              . " a.function_category, a.function_name, a.qualifier_code,"
              . " CASE a.auth_type WHEN  'R' THEN 'individually granted by a person'"
              .      " ELSE CASE IFNULL(flp.pass_number, 2) WHEN 1 "
              .      " THEN 'auto loaded from Data Warehouse' ELSE 'Rule' END END,"
              . " f.qualifier_type, IFNULL(q.qualifier_name, a.qualifier_name)"
              . " from function2 f, function_load_pass flp left outer join authorization2 a ON (flp.function_id = a.function_id) ,"
              . " qualifier2 q left outer join authorization2 a2 ON (q.qualifier_id = a2.qualifier_id)"
              . " where a.authorization_id = ?"
              . " and a.function_id = f.function_id ";
    my $csr;
    unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select stmt report2: " . $DBI::errstr . "<BR>";
      exit();
    }
    unless ($csr->bind_param(1, $authorization_id)) {
        print "Error binding param 1 in select stmt report2: " 
        . $DBI::errstr . "<BR>";  
        exit();
    }
    unless ($csr->execute) {
      print "Error executing select stmt report2" . $DBI::errstr . "<BR>";
      exit();
    }

  #
  #  Read a line from the select statement
  #
  ($auth_id, $func_id, $qual_id, $qual_name, $modified_by,
          $modified_date, $do_function, $grant, $descend,
          $effective_date, $expiration_date, $func_desc, $kerbname,
          $category, $funcname, $qualcode, $source, 
          $qualifier_type, $alt_qualname)
         = $csr->fetchrow_array;

  #
  # If no authorization was found, then print an error message.
  #
  if (! $auth_id) {
    print "Authorization not found."
          . " Authorization_id='$authorization_id'<BR><BR>\n";
    return;
  }

  #
  #  Check to make sure the user is authorized to get details about
  #  this authorization
  #
  my $can_view_auth = 0;
  $category = &strip($category);
  if ($login_user eq $kerbname) {
    $can_view_auth = 1;
  }
  elsif ( &verify_metaauth_category($lda, $login_user, $category) ) {
    $can_view_auth = 1;
  }
  unless ($can_view_auth) {
    print "You are not authorized to view this authorization in "
          . " category '$category'<BR>\n";
    return;
  }

  #
  #  If the qualifier type is sensitive and the end user is
  #  authorized to view qualifier names for this qualifier type,
  #  then use $alt_qualname for the qualifier_name field.
  #
   my $qualtype_is_sensitive = &is_qualtype_sensitive($lda, $qualifier_type);
   if ($qualtype_is_sensitive eq 'Y') {
     my $can_view_qualtype 
           = &check_auth_for_qualtype($lda, $qualifier_type, $login_user);
     if ($can_view_qualtype eq 'Y') {
	 $qual_name = $alt_qualname;
     }
   }

  #
  #  Print out details about this authorization
  #
    print "<HR>", "\n";

    my $stmt2 = "select first_name, last_name, dept_code,"
       . " decode(primary_person_type, 'E', 'Employee', 'S', 'Student',"
       . " 'Other'), decode(status_code, 'A', 'Active', 'I', 'Inactive'),"
       . " q.qualifier_name"
       . " from person p, qualifier q"
       . " where p.kerberos_name = ?"
       . " and p.dept_code = q.qualifier_code(+)"
       . " and q.qualifier_type(+) = 'ORGU'";
    unless ($csr2 = $lda->prepare($stmt2)) {
      print "Error preparing select stmt 2: " . $DBI::errstr . "<BR>";
      exit();
    }
    unless ($csr2->bind_param(1, $kerbname)) {
        print "Error binding param 1 in stmt 2: " 
        . $DBI::errstr . "<BR>";  
        exit();
    }
    unless ($csr2->execute) {
      print "Error executing select stmt 2: " . $DBI::errstr . "<BR>";
      exit();
    }

    my ($first_name, $last_name, $dept_code, $person_type, $status, $dept_name)
        = $csr2->fetchrow_array;
    $csr2->finish();

    print "\n<TABLE>", "\n";
    print "<TR><TH ALIGN=LEFT>Source of Authorization</TH>"
          . "<TH> </TH>"
	  . "<TD> </TD></TR>\n";
    my $source_string = $source;
    if ($source_string eq $g_rule_string) {
      $source_string .= " &nbsp; &nbsp; <a href=\"$url_stem3"
                      . "authid=" . $auth_id . "\">"
                      . "<i>Show rule details...</i></a>";
    }
    print "<TR><TD ALIGN=RIGHT><small>Source:&nbsp&nbsp</small></TD>"
            . "<TD ALIGN=LEFT>$source_string</TD></tr>\n";
    print "<TR><TD></TD></TR>\n";
    print "<TR><TD></TD></TR>\n";
    print "<TR><TH ALIGN=LEFT>Person</TH><TH ALIGN=LEFT> </TH>"
         . "<TD ALIGN=LEFT> </TD></TR>\n";
    print "<TR>"
          . "<TD ALIGN=RIGHT><small>Kerberos username:&nbsp&nbsp</small></TD>"
	  . "<TD ALIGN=LEFT>$kerbname</TD></TR>\n";
    print "<TR><TD ALIGN=RIGHT><small>Name:&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>$first_name $last_name</TD>"
           . "</TR>\n";
    print "<TR><TD ALIGN=RIGHT><small>Status/type:&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>${status}/$person_type</TD>"
	   . "</TR>\n";
    print "<TR><TD ALIGN=RIGHT><small>Department code:&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>$dept_code</TD></TR>\n";
    print "<TR><TD ALIGN=RIGHT><small>Department name:&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>$dept_name</TD></TR>\n";
    print "<TR><TD></TD></TR>\n";
    print "<TR><TD></TD></TR>\n";

    print "<TR><TH ALIGN=LEFT>Function</TH><TH ALIGN=LEFT></TH>"
           . "</TR>\n";
    print "<TR><TD ALIGN=RIGHT><small>Category:&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>$category</TD>"
           . "</TR>\n";
    print "<TR><TD ALIGN=RIGHT><small>Function name:&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>$funcname</TD>"
           . "</TR>\n";
    print "<TR><TD ALIGN=RIGHT><small>Function description&nbsp&nbsp</small>"
           . "</TD>"
           . "<TD ALIGN=LEFT>$func_desc</TD></TR>\n";
    print "<TR><TD ALIGN=RIGHT><small>Function ID:&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>$func_id</TD></TR>\n";
    print "<TR><TD></TD></TR>\n";
    print "<TR><TD></TD></TR>\n";

    print "<TR><TH ALIGN=LEFT>Qualifier</TH><TH></TH></TR>\n";
    print "<TR><TD ALIGN=RIGHT><small>Qualifier code:&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>$qualcode</TD></TR>\n";
    print "<TR><TD ALIGN=RIGHT><small>Qualifier name:&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>$qual_name</TD></TR>\n";
    print "<TR><TD ALIGN=RIGHT><small>Qualifier hierarchy:&nbsp&nbsp</small>"
           . "</TD>"
           . "<TD ALIGN=LEFT>$qualifier_type</TD></TR>\n";
    print "<TR><TD></TD></TR>\n";
    print "<TR><TD></TD></TR>\n";

    print "<TR><TH ALIGN=LEFT>Flags</TH><TH></TH>"
           . "<TH ALIGN=LEFT>Miscellaneous</TH><TH></TH></TR>\n";
    print "<TR><TD ALIGN=RIGHT><small>Do function:&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>$do_function</TD>"
           . "<TD ALIGN=RIGHT><small>Internal auth. ID:&nbsp&nbsp</small>"
           . "</TD>"
           . "<TD ALIGN=LEFT>$auth_id</TD></TR>\n";
    print "<TR><TD ALIGN=RIGHT><small>Grant:&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>$grant</TD>"
           . "<TD ALIGN=RIGHT><small>Modified by:&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>$modified_by</TD></TR>\n";
    print "<TR><TD ALIGN=RIGHT><small>Descend:&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>$descend</TD>"
           . "<TD ALIGN=RIGHT><small>Modified date:&nbsp&nbsp</small></TD>"
           . "<TD ALIGN=LEFT>$modified_date</TD></TR>\n";
    print "<TR><TD ALIGN=RIGHT><small>Effective from - to:&nbsp&nbsp</small>"
           . "</TD>"
           . "<TD ALIGN=LEFT>$effective_date - $expiration_date</TD>"
           . "</TR>\n";
  
  print "</TABLE>", "\n";
  
  #
  #
  #
   &ora_close($csr) || die "can't close cursor";

}

###########################################################################
#
#  Subroutine report3.
#
#  Given a specific implied authorization, find the rule(s) that 
#  generated it.
#
###########################################################################
sub report3 {

  my ($lda, $authorization_id, $login_user) = @_;  # Get Oracle login handle.
  my ($auth_id, $func_id, $qual_id, $qual_name, $modified_by,
          $modified_date, $do_function, $grant, $descend,
          $effective_date, $expiration_date, $func_desc);
  my $auth_found = 0;

  #
  #  Open a cursor for select statement.
  #
  my $stmt = "select a.authorization_id, a.function_category"
              . " from authorization2 a"
              . " where a.authorization_id = ?";

  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select stmt report3: " . $DBI::errstr . "<BR>";
      exit();
  }
  unless ($csr->bind_param(1, $authorization_id)) {
        print "Error binding param 1 in stmt report3: " 
        . $DBI::errstr . "<BR>";  
        exit();
  }
  unless ($csr->execute) {
      print "Error executing select stmt report3: " . $DBI::errstr . "<BR>";
      exit();
  }

  #
  #  Read a line from the select statement
  #
  ($auth_id, $category) = $csr->fetchrow_array;
  $csr->finish();

  #
  # If no authorization was found, then print an error message.
  #
  if (! $auth_id) {
    print "Authorization not found."
          . " Authorization_id='$authorization_id'<BR><BR>\n";
    return;
  }

  #
  #  Check to make sure the user is authorized to get details about
  #  this authorization
  #
  my $can_view_auth = 0;
  $category = &strip($category);
  if ($login_user eq $kerbname) {
    $can_view_auth = 1;
  }
  elsif ( &verify_metaauth_category($lda, $login_user, $category) ) {
    $can_view_auth = 1;
  }
  unless ($can_view_auth) {
    print "You are not authorized to view details about this authorization in "
          . " category '$category'<BR>\n";
    return;
  }

  #
  #  Get information about what rule(s) generated this authorization.
  #
   #print "Ready to look up rule information about auth ID $authorization_id"
   #      . "<BR>";

   my @rule_id, @rule_type, @kerbname, @cond_category, @cond_function,
      @cond_qualcode, @result_function, @result_qualcode;
   &get_rule_info_for_auth($lda, $auth_id, 
           \@rule_id, \@rule_type, \@kerbname,
           \@cond_category, \@cond_function, \@cond_qualcode,
           \@result_function, \@result_qualcode);
   my $n = @rule_id;
   unless ($n) {
     print "No matching rules found.  This could happen because
            <ul>
              <li>The rule that created the Authorization was deleted 
                  today, and the Authorization will be deleted during
                  the next application of the rules.
              <li>The Authorization was generated by a custom data feed 
                  program, rather than a defined rule.
            </ul>";
     return;
   }

   print "<p />What rule was applied to generate an implied authorization
          for user=$kerbname[0], function='$result_function[0]', and
          qualifier=$result_qualcode[0]&nbsp;?";
   if ($n > 1) {
     print "<blockquote>(For this implied authorization, more than one 
            evaluation of the rules applies. Any one of the cases 
            shown below would have been sufficient for the person
            to be assigned the implied authorization.)</blockquote>";
   }
   print "<p />";
   print "<table border>";
   print "<tr><th>&nbsp;</th>"
        . "<th colspan=2 $g_bg_yellow>Person started with"
        . " a role/relation<br>for this function and qualifier</th>"
        . "<th>The system<br>applied the rule</th>"
        . "<th colspan=2 $g_bg_green>After applying the rule, "
        . "the person got an<br>implied authorization"
        . " for this function and qualifier</th>"
        . "</tr>\n";
   print "<tr><th>Kerberos<br>name</th>"
        . "<th $g_bg_yellow>Condition<br>function</th>"
        . "<th $g_bg_yellow>Condition<br>qual code</th>"
        . "<th>Rule ID</th>"
        . "<th $g_bg_green>Result<br>function</th>"
        . "<th $g_bg_green>Result<br>qual code</th></tr>\n";
   # Keep track of which rule IDs the person can view; we'll hide them if
   # they refer to an implied auth for which the person cannot view the 
   # condition
   my %rule_id_is_viewable;  
   for ($i=0; $i<$n; $i++) {
    # Make sure the user is authorized to view auths related to the
    # category for the condition authorization.
     my $auth_for_cond_category = 0;
     # If condition auth's category is the same as the result, user can see it.
     if ($cond_category[$i] eq $category) {
	 $auth_for_cond_category = 1;
     }
     elsif ($kerbname eq $login_user) {
         $auth_for_cond_category = 1;
     }
     else {
	    $auth_for_cond_category 
            = &verify_metaauth_category($lda, $login_user, $cond_category[$i]);
     }
     if ($auth_for_cond_category) {
       print "<tr><td>$kerbname[$i]</td><td>$cond_function[$i]</td>"
           . "<td>$cond_qualcode[$i]</td>"
           . "<td align=center>$rule_id[$i]</td>"
           . "<td>$result_function[$i]</td>"
           . "<td>$result_qualcode[$i]</td></tr>\n";
       $rule_id_is_viewable{$rule_id[$i]} = 1;
     }
     else {
       print "<tr>
              <td colspan=6>You are not authorized to see the role/relation
                            that was the condition for generating this 
                            implied authorization</td></tr>";
       $rule_id_is_viewable{$rule_id[$i]} = 0;
     }
   }
   print "</table>\n";

  #
  #  Remove duplicates from @rule_id and form @rule_id_no_dups
  #
   my %rule_id_hash;
   foreach $rid (@rule_id) {
     if ($rule_id_is_viewable{$rule_id[$id]}) {
        $rule_id_hash{$rid} = 1;
     }
   }
   my @rule_id_no_dups = (sort keys %rule_id_hash);  

  #
  #  Print rule information for relevant rules
  #
   &print_rule_info($lda, \@rule_id_no_dups);

}

###########################################################################
#
#  Subroutine get_rule_info_for_auth($lda, $auth_id, 
#   \@rule_id, \@rule_type, \@kerbname, 
#   \@cond_category, \@cond_function, \@cond_qualcode,
#   \@result_function, \@result_qualcode)
#  
#  Fills in some parallel arrays containing information about which
#  rule(s) generated a given implied authorization
#
###########################################################################
sub get_rule_info_for_auth {
    my ($lda, $auth_id, $rrule_id, $rrule_type, 
        $rkerbname, $rcond_category, $rcond_function, $rcond_qualcode, 
        $rresult_function, $rresult_qualcode) = @_;
    
    #
    # Statement used in the query
    #

     #### Find rules of type 1a for functions
     my $stmt1af =
     "select iar.rule_type_code, iar.rule_id, a1.kerberos_name, 
          a.function_category cond_category,
          a.function_name cond_function, a.qualifier_code cond_qual,
          a1.function_name result_function, a1.qualifier_code result_qual
     from authorization2 a1, implied_auth_rule iar,
          qualifier_subtype qst, qualifier q, authorization2 a
     where a1.authorization_id = ?
     and a1.function_name in 
          (iar.result_function_name, '*' || iar.result_function_name)
     and iar.rule_type_code = '1a'
     and qst.qualifier_subtype_code = iar.condition_obj_type
     and q.qualifier_id = a1.qualifier_id
     and instr(q.qualifier_code, nvl(qst.contains_string, q.qualifier_code)) >0
     and a1.qualifier_code between 
           nvl(qst.min_allowable_qualifier_code, a1.qualifier_code)
           and nvl(qst.max_allowable_qualifier_code, a1.qualifier_code)
     and a.kerberos_name = a1.kerberos_name
     and a.qualifier_code = a1.qualifier_code
     and iar.condition_function_category = rtrim(a.function_category)
     and a.function_name in 
          (iar.condition_function_name, '*' || iar.condition_function_name)
     order by 1, 2, 3, 4, 5";

    #### Find rules of type 1b for functions
    my $stmt1bf = 
    "select iar.rule_type_code, iar.rule_id, a1.kerberos_name, 
         a.function_category cond_category, 
         a.function_name cond_function, a.qualifier_code cond_qual,
         a1.function_name result_function, a1.qualifier_code result_qual
       from authorization2 a1, implied_auth_rule iar, qualifier_subtype qst1,
         authorization2 a, qualifier_subtype qst
       where a1.authorization_id = ?
         and a1.function_name in 
          (iar.result_function_name, '*' || iar.result_function_name)
         and iar.rule_type_code = '1b'
         and qst1.qualifier_subtype_code = iar.auth_parent_obj_type
         and instr(a1.qualifier_code, qst1.contains_string) > 0
         and a1.qualifier_code between 
           nvl(qst1.min_allowable_qualifier_code, a1.qualifier_code)
           and nvl(qst1.max_allowable_qualifier_code, a1.qualifier_code)
         and a.kerberos_name = a1.kerberos_name
         and a.function_name in 
            ('*' || iar.condition_function_name, iar.condition_function_name)
         and qst.qualifier_subtype_code = iar.condition_obj_type
         and instr(a.qualifier_code, qst.contains_string) > 0
         and a.qualifier_code between 
           nvl(qst.min_allowable_qualifier_code, a.qualifier_code)
           and nvl(qst.max_allowable_qualifier_code, a.qualifier_code)
         order by 1, 2, 3, 4, 5";

   ### Find rules of type 2b for function groups and qualifier descendants
    my $stmt2bgd =
    "select iar.rule_type_code, iar.rule_id,  a1.kerberos_name,
         a.function_category cond_category, 
           a.function_name cond_function, a.qualifier_code cond_qual,
           a1.function_name result_function, a1.qualifier_code result_qual
    from implied_auth_rule iar, authorization2 a, 
         authorization2 a1, function_group fg, function_group_link fgl,
             qualifier_descendent qd, qualifier q
    where a1.authorization_id = ?
    and iar.rule_type_code = '2b'
    and '*' || iar.result_function_name = a1.function_name
    and iar.result_function_category = rtrim(a1.function_category)
    and iar.condition_function_or_group = 'G'
    and iar.result_qualifier_code = a1.qualifier_code
    and iar.rule_is_in_effect = 'Y'
    and a1.kerberos_name = a.kerberos_name
    and a.function_category = iar.condition_function_category
    and fg.function_group_name = iar.condition_function_name
    and fgl.parent_id = fg.function_group_id
    and a.function_id = fgl.child_id
    and a.qualifier_id = qd.child_id
    and q.qualifier_id = qd.parent_id
    and iar.condition_qual_code = q.qualifier_code
    and a.do_function = 'Y'
    and sysdate 
           between a.effective_date and nvl(a.expiration_date, sysdate)
    order by 1, 2, 3, 4, 5";

   ### Find rules of type 2b for functions and qualifier descendants
    my $stmt2bfd =
    "select iar.rule_type_code, iar.rule_id,  a1.kerberos_name,
         a.function_category cond_category, 
           a.function_name cond_function, a.qualifier_code cond_qual,
           a1.function_name result_function, a1.qualifier_code result_qual
    from implied_auth_rule iar, authorization2 a, 
         authorization2 a1, qualifier_descendent qd, qualifier q
    where a1.authorization_id = ?
    and iar.rule_type_code = '2b'
    and '*' || iar.result_function_name = a1.function_name
    and iar.result_function_category = rtrim(a1.function_category)
    and iar.condition_function_or_group = 'F'
    and iar.result_qualifier_code = a1.qualifier_code
    and iar.rule_is_in_effect = 'Y'
    and a1.kerberos_name = a.kerberos_name
    and a.function_category = iar.condition_function_category
    and a.function_name in 
        (iar.condition_function_name, '*' || iar.condition_function_name)
    and a.qualifier_id = qd.child_id
    and q.qualifier_id = qd.parent_id
    and iar.condition_qual_code = q.qualifier_code
    and a.do_function = 'Y'
    and sysdate 
           between a.effective_date and nvl(a.expiration_date, sysdate)
    order by 1, 2, 3, 4, 5";

   ### Find rules of type 2a and 2b for functions and exact qualifier matches
    my $stmt2abfq =
    "select iar.rule_type_code, iar.rule_id, a.kerberos_name,
         a.function_category cond_category, 
           a.function_name cond_function, a.qualifier_code cond_qual,
           a1.function_name result_func, a1.qualifier_code result_qual
     from implied_auth_rule iar, authorization2 a, 
         authorization2 a1
     where a1.authorization_id = ?
     and iar.rule_type_code in ('2a', '2b')
     and a1.function_name in 
        ('*' || iar.result_function_name, iar.result_function_name)
     and iar.result_function_category = rtrim(a1.function_category)
     and iar.condition_function_or_group = 'F'
     and iar.result_qualifier_code = a1.qualifier_code
     and iar.rule_is_in_effect = 'Y'
     and a1.kerberos_name = a.kerberos_name
     and a.function_category = iar.condition_function_category
     and a.function_name 
         in (iar.condition_function_name, '*' || iar.condition_function_name)
     and a.qualifier_code = iar.condition_qual_code
     and a.do_function = 'Y'
     and sysdate 
           between a.effective_date and nvl(a.expiration_date, sysdate)
     order by 1, 2, 3, 4, 5";

   ### Find rules of type 2a & 2b for function groups and exact qual matches
    my $stmt2abgq =
    "select iar.rule_type_code, iar.rule_id, a.kerberos_name, 
           a.function_category cond_category, 
           a.function_name cond_function, a.qualifier_code cond_qual,
           a1.function_name result_function, a1.qualifier_code result_qual
     from implied_auth_rule iar, authorization2 a, 
         authorization2 a1, function_group fg, function_group_link fgl
     where a1.authorization_id = ?
     and iar.rule_type_code in ('2a', '2b')
     and '*' || iar.result_function_name = a1.function_name
     and iar.result_function_category = rtrim(a1.function_category)
     and iar.condition_function_or_group = 'G'
     and iar.result_qualifier_code = a1.qualifier_code
     and iar.rule_is_in_effect = 'Y'
     and a1.kerberos_name = a.kerberos_name
     and rtrim(a.function_category) = iar.condition_function_category
     and fg.function_group_name = iar.condition_function_name
     and fgl.parent_id = fg.function_group_id
     and a.function_id = fgl.child_id
     and a.qualifier_code = iar.condition_qual_code
     and a.do_function = 'Y'
     and sysdate 
           between a.effective_date and nvl(a.expiration_date, sysdate)
     order by 1, 2, 3, 4, 5";


   #
   #  Null out the arrays
   #
     @$rrule_id = (); 
     @$rrule_type = ();
     @$rkerbname = ();
     @$rcond_category = ();
     @$rcond_function = ();
     @$rcond_qualcode = ();
     @$rresult_function = ();
     @$rresult_qualcode = ();

   #
   #  Loop through each of the Select statements, adding to the arrays
   #
 my $step = 0;
 foreach $stmt ($stmt1af, $stmt1bf, $stmt2abfq, $stmt2abgq, $stmt2bgd, 
                $stmt2bfd) 
 {
    $step++;
    #print "<br>stmt='$stmt'<BR>";
    unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select stmt step $step: " . $DBI::errstr . "<BR>";
      exit();
    }
    unless ($csr1->bind_param(1, $auth_id)) {
        print "Error binding param 1 in rule step $step: " 
        . $DBI::errstr . "<BR>";  
        exit();
    }
    unless ($csr1->execute) {
      print "Error executing select statement 1: " . $DBI::errstr . "<BR>";
      exit();
    }
    my ($rule_type, $rule_id, $kerberos_name, 
         $cond_category, $cond_function, $cond_qualcode, 
         $result_function, $result_qualcode);
    while ( ($rule_type, $rule_id, $kerberos_name, 
             $cond_category, $cond_function, $cond_qualcode, 
             $result_function, $result_qualcode) 
            = $csr1->fetchrow_array 
          )
    {
       push(@$rrule_id, $rule_id);
       push(@$rrule_type, $rule_type);
       push(@$rkerbname, $kerberos_name);
       push(@$rcond_category, &strip($cond_category));
       push(@$rcond_function, $cond_function);
       push(@$rcond_qualcode, $cond_qualcode);
       push(@$rresult_function, $result_function);
       push(@$rresult_qualcode, $result_qualcode);
    }
    $csr1->finish();
 }
}

###########################################################################
#
#  Subroutine print_new_report_form($lda, \%viewable_cat, 
#                     $default_kerbname, $default_category);
#   
#  Prints out the categories from which the superuser, $k_prinicipal,
#  is allowed to choose, if he wants to view another user's authorizations.
#
###########################################################################
sub print_new_report_form {
    my ($lda, $rviewable_cat, $default_kerbname, $default_category) = @_;
    
    #
    # print out the categories retrieved
    #
    print "</center>\n";
    print "enter a <strong>username</strong>, select a <strong>category",
          "</strong> and click the button ",
          "<strong>\"Display authorizations\"</strong>.<BR><BR>";
    print '<FORM METHOD="GET" ACTION="' . $progname . '">';
    print '<TABLE><TR><TD VALIGN=TOP>';
    print "<strong>Username: </strong><INPUT TYPE=TEXT "
          . "NAME=username VALUE=\"$default_kerbname\">",
          " &nbsp;&nbsp;<strong>Category:</strong>";
    print '</TD><TD VALIGN=TOP>';
    
    #print "picked_cat='$default_category'<BR>";
    #foreach $cat (sort keys %$rviewable_cat) {
    #  my $opt = ($default_category eq &strip($cat))
    #                ? "OPTION SELECTED"
    #                : "OPTION";
    #  print "picked_cat='$default_category' cat='$cat' opt='$opt'<BR>";
    #}

    print '<SELECT NAME="category">', "\n";
    
   #
   #  Print a pick list of categories
   #
    my $cat_desc;
    my $select_option;
    ### Print "ALL" first, if applicable
    if ($$rviewable_cat{'ALL'}) {
        $cat_desc = $$rviewable_cat{'ALL'};
        $select_option = ($default_category eq 'ALL')
                    ? "<OPTION SELECTED>"
                    : "<OPTION>";
        print "$select_option$cat $cat_desc\n";
    }
    foreach $cat (sort keys %$rviewable_cat) { 
      if ($cat ne 'ALL') {
        $cat_desc = $$rviewable_cat{$cat};
        $select_option = ($default_category eq &strip($cat))
                    ? "<OPTION SELECTED>"
                    : "<OPTION>";
        print "$select_option$cat $cat_desc\n";
      }
    }

    print "</SELECT>", "\n";
    print "</TD></TR></TABLE>\n";
    print "<P>", "\n";
    print '<INPUT TYPE="SUBMIT" VALUE="Display authorizations">',"\n";
    print "</FORM>", "\n";    
}

###########################################################################
#
#  Subroutine print_rule_info($lda,  \@rule_id);
#   
#  Given an array of rule_id's relevant to the Authorization lookup,
#  display information about each of the listed rules.
#
###########################################################################
sub print_rule_info {
  my ($lda, $rrule_id) = @_;

 #
 #  Get a set of hashes containing information about relevant rules
 #
  my @rule_id = @$rrule_id;
  my $n = @rule_id;
  unless ($n) {
      # If there are no rule IDs listed, stop here.
      return;
  }
  my (%rule_type_code, %rule_type, %cond_f_or_g, %cond_cat, 
      %cond_function, %cond_obj_type, %cond_qual_code, 
      %result_cat, %result_function, %result_obj_type, %result_qual_code);
  &get_info_for_rule_array($lda, \@rule_id,
      \%rule_type_code, \%rule_type, \%rule_name, 
      \%cond_f_or_g, \%cond_cat, 
      \%cond_function, \%cond_obj_type, \%cond_qual_code, 
      \%result_cat, \%result_function, \%result_obj_type, \%result_qual_code,
      \%mod_by, \%mod_date);
  #foreach $rid (@rule_id) {
  #    print "rule_id=$rid rule_type_code=$rule_type_code{$rid} "
  #          . "rule_name=$rule_name{$rid} "
  #          . "result_obj_type=$result_obj_type{$rid} "
  #          . "rule_type=$rule_type{$rid}<BR>";
  #

 #
 #  Find out what rule types we have
 #
  my %found_rule_type;
  foreach $rid (@rule_id) {
      $found_rule_type{ $rule_type_code{$rid} }++;
  }
  my %rule_code2name;
  my %rule_code2desc;
  &get_rule_type_hashes($lda, \%rule_code2name, \%rule_code2desc);

 #
 #  Print a header
 #
  print "<HR><P />";
  print "<h3>Descriptions of relevant rules<h3>";
  print "<P />";

 #
 #  Print a header for rule type 1a.
 #
  if ($found_rule_type{'1a'}) {
    $rows_in_table = $found_rule_type{'1a'} + 2;
    print "<h4>Rules of type $rule_code2name{'1a'}"
          . "</h4><p />\n";
    print "<blockquote><i>$rule_code2desc{'1a'}</i></blockquote><p />\n";
    print "<table border>\n";
    print "<tr><th rowspan=2>Rule<br>ID</th>"
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
      . "<tr>"
      . "<th $g_bg_yellow>Func<br>or<br>grp</th>"
      . "<th $g_bg_yellow>Cat-<br>egory</th>"
      . "<th $g_bg_yellow>Function</th>"
      . "<th $g_bg_yellow>Obj<br>type</th>"
      . "<th $g_bg_green>Cat-<br>egory</th>"
      . "<th $g_bg_green>Function</th>"
      . "</tr>\n";

   #
   #  Print details for rules of type 1a
   #
    foreach $rid (@rule_id) {
      if ($rule_type_code{$rid} eq '1a') {
	if ($cond_f_or_g{$rid} eq 'G') {
          $cond_func_string = 
             "<a href=\"${url_f_grp_stem}$cond_function{$rid}\" "
             . "target=new>$cond_function{$rid}</a>";
        }
        else {
          $cond_func_string = 
             "<a href=\"$url_f_grp_stem"
             . $cond_function{$rid} . "\">$cond_function{$rid}</a>";
          $cond_func_string = $cond_function{$rid};
        }
        print "<tr><td>$rid</td>"
          . "<td>$rule_name{$rid}</td><td>$cond_f_or_g{$rid}</td>"
          . "<td>$cond_cat{$rid}</td><td>$cond_func_string</td>"
          . "<td>$cond_obj_type{$rid}</td>"
          . "<td>$result_cat{$rid}</td><td>$result_function{$rid}</td>"
          . "</tr>\n";
      }
    }
    print "</table><p />\n";
  }

 #
 #  Print a header for rule type 1b.
 #
  if ($found_rule_type{'1b'}) {
    $rows_in_table = $found_rule_type{'1b'} + 2;
    print "<h4>Rules of type $rule_code2name{'1b'}"
          . "</h4><p />\n";
    print "<blockquote><i>$rule_code2desc{'1b'}</i></blockquote><p />\n";
    print "<table border>\n";
    print "<tr><tr><th rowspan=2>Rule<br>ID</th>"
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
   #  Print details for rules of type 1b
   #
    foreach $rid (@rule_id) {
      if ($rule_type_code{$rid} eq '1b') {
	if ($cond_f_or_g{$rid} eq 'G') {
          $cond_func_string = 
             "<a href=\"${url_f_grp_stem}$cond_function{$rid}\" "
             . "target=new>$cond_function{$rid}</a>";
        }
        else {
          $cond_func_string = 
             "<a href=\"$url_f_grp_stem"
             . $cond_function{$rid} . "\">$cond_function{$rid}</a>";
          $cond_func_string = $cond_function{$rid};
        }
        print "<tr><td>$rid</td>"
          . "<td>$rule_name{$rid}</td><td>$cond_f_or_g{$rid}</td>"
          . "<td>$cond_cat{$rid}</td><td>$cond_func_string</td>"
          . "<td>$cond_obj_type{$rid}</td>"
          . "<td>$result_cat{$rid}</td><td>$result_function{$rid}</td>"
          . "<td>$result_obj_type{$rid}</td>"
          . "</tr>\n";
      }
    }
    print "</table><p />\n";
  }

 #
 #  Print a header for rule type 2a.
 #
  if ($found_rule_type{'2a'}) {
    $rows_in_table = $found_rule_type{'2a'} + 2;
    print "<h4>Rules of type $rule_code2name{'2a'}"
          . "</h4><p />\n";
    print "<blockquote><i>$rule_code2desc{'2a'}</i></blockquote><p />\n";
    print "<table border>\n";
    print "<tr><tr><th rowspan=2>Rule<br>ID</th>"
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
   #  Print details for rules of type 2a
   #
    foreach $rid (@rule_id) {
      if ($rule_type_code{$rid} eq '2a') {
	if ($cond_f_or_g{$rid} eq 'G') {
          $cond_func_string = 
             "<a href=\"${url_f_grp_stem}$cond_function{$rid}\" "
             . "target=new>$cond_function{$rid}</a>";
        }
        else {
          $cond_func_string = 
             "<a href=\"$url_f_grp_stem"
             . $cond_function{$rid} . "\">$cond_function{$rid}</a>";
          $cond_func_string = $cond_function{$rid};
        }
        print "<tr><td>$rid</td>"
          . "<td>$rule_name{$rid}</td><td>$cond_f_or_g{$rid}</td>"
          . "<td>$cond_cat{$rid}</td><td>$cond_func_string</td>"
          . "<td>$cond_obj_type{$rid}</td>"
          . "<td>$cond_qual_code{$rid}</td>"
          . "<td>$result_cat{$rid}</td><td>$result_function{$rid}</td>"
          . "<td>$result_obj_type{$rid}</td>"
          . "<td>$result_qual_code{$rid}</td>"
          . "</tr>\n";
      }
    }
    print "</table><p />\n";
  }

 #
 #  Print a header for rule type 2b.
 #
  if ($found_rule_type{'2b'}) {
    $rows_in_table = $found_rule_type{'2b'} + 2;
    print "<h4>Rules of type $rule_code2name{'2b'}"
          . "</h4><p />\n";
    print "<blockquote><i>$rule_code2desc{'2b'}</i></blockquote><p />\n";
    print "<table border>\n";
    print "<tr><tr><th rowspan=2>Rule<br>ID</th>"
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
   #  Print details for rules of type 2b
   #
    foreach $rid (@rule_id) {
      if ($rule_type_code{$rid} eq '2b') {
	if ($cond_f_or_g{$rid} eq 'G') {
          $cond_func_string = 
             "<a href=\"${url_f_grp_stem}$cond_function{$rid}\" "
             . "target=new>$cond_function{$rid}</a>";
        }
        else {
          $cond_func_string = 
             "<a href=\"$url_f_grp_stem"
             . $cond_function{$rid} . "\">$cond_function{$rid}</a>";
          $cond_func_string = $cond_function{$rid};
        }
        print "<tr><td>$rid</td>"
          . "<td>$rule_name{$rid}</td><td>$cond_f_or_g{$rid}</td>"
          . "<td>$cond_cat{$rid}</td><td>$cond_func_string</td>"
          . "<td>$cond_obj_type{$rid}</td>"
          . "<td>$cond_qual_code{$rid}</td>"
          . "<td>$result_cat{$rid}</td><td>$result_function{$rid}</td>"
          . "<td>$result_obj_type{$rid}</td>"
          . "<td>$result_qual_code{$rid}</td>"
          . "</tr>\n";
      }
    }
    print "</table><p />\n";
  }

}

###########################################################################
#
# Subroutine
#  get_info_for_rule_array($lda, \@rule_id,
#      \%rule_type_code, \%rule_type, \%rule_name,
#      \%cond_f_or_g, \%cond_cat, 
#      \%cond_function, \%cond_obj_type, \%cond_qual_code, 
#      \%result_cat, \%result_function, \%result_obj_type, \%result_qual_code,
#      \%rule_mod_by, \%rule_mod_date);
#
#  Fills in some hashes with information about rules whose rule_id numbers
#  are found in the @rule_id array.
#
###########################################################################
sub get_info_for_rule_array {
    my ($lda, $rrule_id,
      $rrule_type_code, $rrule_type, $rrule_name, $rcond_f_or_g, $rcond_cat, 
      $rcond_function, $rcond_obj_type, $rcond_qual_code, 
      $rresult_cat, $rresult_function, $rresult_obj_type, $rresult_qual_code,
      $rrule_mod_by, $rrule_mod_date) = @_;

   #
   #  Build a string of the list of rule_id's
   #
    my @rule_id = @$rrule_id;
    my $r_id;
    my $rule_list_string;
    foreach $r_id (@rule_id) {
	$rule_list_string .= ", $r_id";
    }
    $rule_list_string = "(" . substr($rule_list_string, 2) . ")";

   #
   # Select statement used in the query
   #
    my $stmt =
    "select iar.rule_id, iar.rule_type_code, rt.rule_type_short_name,
         iar.rule_short_name,
         iar.condition_function_or_group, iar.condition_function_category,
         iar.condition_function_name, iar.condition_obj_type,
         iar.condition_qual_code,
         iar.result_function_category, iar.result_function_name,
         iar.auth_parent_obj_type, iar.result_qualifier_code, 
         iar.modified_by, iar.modified_date
    from implied_auth_rule iar, auth_rule_type rt
    where iar.rule_id in $rule_list_string
    and rt.rule_type_code = iar.rule_type_code
    order by 2, 1";

  #
  #  Prepare and execute the select statement
  #
   #print "<br>stmt='$stmt'<BR>";
   unless ($csr1 = $lda->prepare($stmt)) {
     print "Error preparing select stmt (rule info): " . $DBI::errstr . "<BR>";
     exit();
   }
   unless ($csr1->execute) {
     print "Error executing select stmt (rule info): " . $DBI::errstr . "<BR>";
     exit();
   }

  #
  #  Fill in the hashes
  #
    my ($rule_id,
      $rule_type_code, $rule_type, $rule_name, $cond_f_or_g, $cond_cat, 
      $cond_function, $cond_obj_type, $cond_qual_code, 
      $result_cat, $result_function, $result_obj_type, $result_qual_code,
      $rule_mod_by, $rule_mod_date);
    while 
    (
     ($rule_id,
      $rule_type_code, $rule_type, $rule_name, $cond_f_or_g, $cond_cat, 
      $cond_function, $cond_obj_type, $cond_qual_code, 
      $result_cat, $result_function, $result_obj_type, $result_qual_code,
      $rule_mod_by, $rule_mod_date) = $csr1->fetchrow_array 
    ) 
    {
 	$$rrule_type_code{$rule_id} = $rule_type_code;
        $$rrule_type{$rule_id} = $rule_type; 
        $$rrule_name{$rule_id} = $rule_name; 
        $$rcond_f_or_g{$rule_id} = $cond_f_or_g; 
        $$rcond_cat{$rule_id} = $cond_cat;
        $$rcond_function{$rule_id} = $cond_function;
        $$rcond_obj_type{$rule_id} = $cond_obj_type;
        $$rcond_qual_code{$rule_id} = $cond_qual_code;
        $$rresult_cat{$rule_id} = $result_cat;
        $$rresult_function{$rule_id} = $result_function;  
        $$rresult_obj_type{$rule_id} = $result_obj_type;  
        $$rresult_qual_code{$rule_id} = $result_qual_code;
        $$rrule_mod_by{$rule_id} = $rule_mod_by;
        $$rrule_mod_date{$rule_id} = $rule_mod_date;
    }
    $csr1->finish();
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
    my $csr;
    unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select stmt rule type hashes: " . $DBI::errstr 
             . "<BR>";
      exit();
    }
    unless ($csr->execute) {
      print "Error executing select stmt rule type hashes: " . $DBI::errstr 
             . "<BR>";
      exit();
    }

    my ($rule_code, $rule_name, $rule_desc);
    while ( ($rule_code, $rule_name, $rule_desc) = $csr->fetchrow_array )
    {
	$$rrule_code2name{$rule_code} = $rule_name;
	$$rrule_code2desc{$rule_code} = $rule_desc;
    }
    $csr->finish();
}

###########################################################################
#
#  Function is_qualtype_sensitive($lda, $qualtype)
#
#  Returns 'Y' if the qualifier_type is sensitive, 'N' if not.
#
###########################################################################
sub is_qualtype_sensitive {
  my ($lda, $qualtype) = @_;
  my ($csr, $stmt10, $query_result);
  $stmt10 = "select nvl(is_sensitive, 'N') from qualifier_type"
           . " where qualifier_type = '$qualtype'";
  unless ($csr = $lda->prepare($stmt10)) 
  {
     print "Error preparing statement 10.<BR>";
     die;
  }
  $csr->execute;
  ($query_result) = $csr->fetchrow_array;
  $csr->finish;
  if (!($query_result)) {
    print "Error: Qualifier type '$qualtype' not found<BR>";
    die;
  }
  return ($query_result);
}

###########################################################################
#
#  Function check_auth_for_qualtype($lda, $qualtype, $proxy_username)
#
#  Finds the qualifier_id associated with the child qualifier_code.
#
###########################################################################
sub check_auth_for_qualtype {
  my ($lda, $qualtype, $proxy_username) = @_;
  my ($csr, $stmt9, $result);
  $stmt9 = "select ROLESAPI_IS_USER_AUTHORIZED('$proxy_username',"
            . "'VIEW RESTRICTED QUALIFIERS', "
            . "'QUAL_' || '$qualtype') from dual";
  unless ($csr = $lda->prepare($stmt9)) 
  {
     print "Error preparing statement 9.<BR>";
     die;
  }
  $csr->execute;
  ($result) = $csr->fetchrow_array;
  $csr->finish;
  return ($result);
}

###########################################################################
#
#  Function &web_string($astring)
#
#  Converts spaces to '+', left parentheses to %28, 
#   right parentheses to %29
#
###########################################################################
sub web_string {
    my ($astring) = $_[0];
    $astring =~ s/ /+/g;
    $astring =~ s/\(/%28/g;
    $astring =~ s/\)/%29/g;
    $astring =~ s/\&/%26/g; # 8/24/00
    $astring =~ s/\?/%3F/g; # 8/24/00
    $astring;
}
