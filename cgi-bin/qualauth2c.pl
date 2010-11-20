#!/usr/bin/perl
###########################################################################
#
#  ** This is a test version of qualauth.pl used to try different 
#  ** spacing.  It will probably not go into production.
#
#  CGI script to find all authorizations within a given category for each 
#  qualifier of a certain qualifier type.  Display a qualifier hierarchy
#  and show pertinent authorizations under each qualifier.
#
#
#  Copyright (C) 1999-2010 Massachusetts Institute of Technology
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
#  Last modified by Jim Repa, 2/24/99, 4/12/99, 7/16/99 (addition formats)
#       8/10/99 (option to find parents of qc), 9/23/99 (fix < problem),
#       10/13/99 (add support for ..)
#       01/20/00 (Display of auths. is optional, + flag inactive users in red)
#       03/10/00 (Another display option; optional username)
#       06/08/00 (Suppress leaf nodes for DEPT display with authorizations)
#       07/07/00 (Add RPAD; fix trailing blank problem in bind variable)
#       11/14/00 (Suppress authorizations for root)
#       12/12/00 (Show DEPT from PRIMARY_AUTH_DESCENDENT table, plus
#                 optionally hide Funds/Cost Collectors with term. code 3)
#       01/04/01 (Minor wording changes)
#       03/02/01 (Remember hideterm3 setting)
#       03/06/01 (Remember childqc setting)
#       03/09/01 (Support SIS organizations in DEPT hierarchy)
#       06/20/01 (In no-leaf display for DEPT, hide all but D_ nodes)
#       06/28/01 (Allow people with SAP viewing authority to see PAs)
#       08/29/01 (Add '(r)' next to username if he/she has a perMIT username)
#       03/12/02 (Added default setting for no_leaf.)
#       05/23/02 (Add &escape_string function)
#
#  >>> More planned changes:
#      3. Offer hints when the user has not specified an appropriate
#         qualifier.  (SG_ <-> FC_, start at top of tree, see prefixes
#         for various qualifier types)
#      4. For other qualifier types, recognize when you've reached the
#         bottom of the tree, and indicate that to the user.  (Allow
#         fewer levels, also.)
#      6. Give option of seeing only nodes with authorizations
#
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
#  Define "big branches", nodes in the hierarchies that have so many
#  children that we cannot allow multiple-level expansion until the
#  user picks something more specific.
#
 @big_branch = qw(0HPC00_MIT 0HPC0 0HPC00 0HPC000 0HPC001 
                  0HPC00002 0HPC00005 0HPC00006
                  FCMIT FC100000 FC_CUSTOM FC100001 FC100002
                  FC100012 FC100015 FC100017
                  FC_CENTRAL FC_SCHOOL_ENG FC_SCHOOL_SCI FC_VPRES
                 );
 $secret_password = 'abracadabra';  # Used to bypass big-branch checking

#
#  Set constant:  How many levels is considered "all" levels?
#
 $all_levels = 20;

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
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 $host = $ENV{'HTTP_HOST'};
 $url_stem = "https://$host/cgi-bin/$progname?";  # URL for subtree view
 $url_stem3 = "http://$host/cgi-bin/rolecc_info.pl?";
 $url_stem4 = "http://$host/cgi-bin/rolequal1.pl?";
 $main_url = "http://$host";
 # Set $http_https according to whether there is certificate info available.
 $http_https = ($ENV{"SSL_CLIENT_S_DN"}) ? 'https' : 'http';

#
#  Print out top of the http document.  
#
 print "Content-type: text/html", "\n\n";

#
#  Get form variables
#
$raw_category = $rawval{'category'};  # Get category in URL-ese.
$category = $formval{'category'};   # Get value set in &parse_forms()
$qualtype = $formval{'qualtype'};  # Get value set in &parse_forms()
$raw_qualtype = $rawval{'qualtype'};  # Get unedited value
$rootnode = $formval{'rootnode'};
if ($rootnode eq 'ROOT') {$rootnode = '';}  # Transition from old notation
$show_all = $formval{'show_all'};  # Get opt. parm. (Show nodes with no auths?)
if ($show_all eq '') {$show_all = 0};  # Default
$rootqcode = $formval{'rootcode'};  # Get the root node (a qualifier_code)
$rootqcode =~ tr/a-z/A-Z/;  # Raise to uppercase
$levels = $formval{'levels'};  # Get the number of levels (if any)
$cat_qt = $formval{'cat_qt'};  # Get category/qualtype combination
$display_detail = $formval{'detail'};  # Show auth. grant, modifier details?
$child_code = $formval{'childqc'};  # Get the child qualcode (for parent list)
$child_code =~ tr/a-z/A-Z/; # Raise to uppercase
$sort_option = $formval{'sort'};  # Get sort option
$sort_option =~ tr/a-z/A-Z/;
$pkerbname = &strip($formval{'kerbname'});
$pkerbname =~ tr/a-z/A-Z/;
$no_leaf = &strip($formval{'noleaf'});
if ($no_leaf eq '') {$no_leaf = 'D';} # Set default
$secret = &strip($formval{'secret'});  # Used to bypass big-branch checks
$showrootauths = &strip($formval{'showrootauths'});  # Show root-level auths?
if ($showrootauths eq '') {$showrootauths = 'N';}  # Default is N
$showrootauths =~ tr/a-z/A-Z/;
$showdeptname = $formval{'showdeptname'};
if ($showdeptname eq '') {$showdeptname = 'N'};  # Default is N
$hide_term3 = $formval{'hide_term3'};
if ($hide_term3 eq '') {$hide_term3 = 'Y'};  # Default is Y
$rolesflag = $formval{'rolesflag'};
$rolesflag =~ tr/a-z/A-Z/;
if ($rolesflag eq '') {$rolesflag = 'N'};  # Default is N
$group_option = $formval{'group_option'};
if ($group_option eq '') {$group_option = 1;}  # Default is 1

#
#  If category/qualtype combination was specified, set $category and
#  $qualtype.
#
if ($cat_qt) {
  $cat_qt =~ /^([^\/]*)\/([^ ]*) (.*)/;
  $category = $raw_category = $1;
  $qualtype = $raw_qualtype = $2;
  $description = $3;
  #print "cat='$category' qualtype='$qualtype' desc='$description'<BR>";
}

#
#  Make some modifications to form variables
#
$cat = $category;
$cat =~ s/\W.*//;  # Keep only the first word.
$cat4 = substr($cat . '    ', 0, 4); # We need this PLUS rpad for bind!
$qt = $qualtype;
$qt =~ s/\W.*//;  # Keep only the first word.
$qualtype =~ s/\w*\s//;  # Throw out first word.

#
#  Adjust the URL stem that points back to this CGI script
#
 if (!($cat)) {  # If no category is specified, change https -> http
   $url_stem =~ s/^https/http/;
 }
 $url_stem .= "category=$raw_category&qualtype=$raw_qualtype&show_all=1&"
              . "detail=$display_detail&";
 if ($levels) {
   $url_stem .= "levels=$levels&";
 }
 if ($sort_option) {
   $url_stem .= "sort=$sort_option&";
 }
 if ($pkerbname) {
   $url_stem .= "kerbname=$pkerbname&";
 }
 if ($no_leaf ne 'D') {
   $url_stem .= "noleaf=$no_leaf&";
 }
 if ($showdeptname) {
   $url_stem .= "showdeptname=$showdeptname&";
 }
 if ($hide_term3) {
   $url_stem .= "hide_term3=$hide_term3&";
 }
 if ($rolesflag) {
   $url_stem .= "rolesflag=$rolesflag&";
 }
 if ($group_option) {
   $url_stem .= "group_option=$group_option&";
 }

#
#  If we're going to display authorizations in a category, 
#  parse certificate information.  Otherwise, skip it.
#
if ($cat) {  # Is there a category?
 # authentication checks
  ($info,$k_principal, $domain)  = &parse_authentication_info();  # Parse authentication info
  $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase
  $full_name = $k_principal;
  $result = &check_auth_source($info); # Check other certificate fields
  if ($result ne 'OK') {
      print "<br><b>Your authentication cannot be accepted: $result";
      exit();
  }
}

#
#  Get set to use DB.
#
use DBI;

#
#  Open connection to DB
#
$lda = login_dbi_sql('roles') || die "$DBI::errstr . \n";

#
# Get start time
#
 $epoch = time();

#
#  Make sure the user has a meta-authorization to view auths. in the given 
#  category.  (Skip it if there is no category for displaying auths.)
#
if ($cat) {
  # Multiple categories?
  if ($category =~ /,/) {
    @cat_list = split(',', $category);
    foreach $cat_item (@cat_list) {
      if (! &verify_metaauth_category($lda, $k_principal, $cat)) {
        # Exception
        if ( ($cat eq 'META') && ($qt eq 'DEPT') 
             && (&verify_metaauth_category($lda, $k_principal, 'SAP')) ) {
          ## It's OK.  The person is authorized.
        }
        else {
          print 
          "Sorry.  You do not have the required perMIT DB 'meta-authorization'",
          " to view other people's $cat_item authorizations.";
          exit();
        }
      }
    }
  }
  else {
    if (! &verify_metaauth_category($lda, $k_principal, $cat)) {
      #
      # Exception: 
      # Allow people with SAP viewing authority to see Primary Authorizors,
      # which would normally require viewing authority for category META.
      #
      if ( ($cat eq 'META') && ($qt eq 'DEPT') 
           && (&verify_metaauth_category($lda, $k_principal, 'SAP')) ) {
        ## It's OK.  The person is authorized.
      }
      else {
        print 
        "Sorry.  You do not have the required perMIT DB 'meta-authorization'",
        " to view other people's $cat authorizations.";
        exit();
      }
    }
  }
}

#
#  Set font parameters for printing FUNCTION names
#
 $funcfont = '<font color=green><i><b>';  #****
 $endfuncfont = '</b></i></font>';  #****

#
#  Make sure $rootnode is set to the qualifier_id for the branch of the
#  tree we want to display.  (If necessary, convert from qualifier_code
#  or qualifier_type & qualifier_level to qualifier_id.)
#
 ($rootnode, $rootqcode, $rootlevel) 
     = &get_rootnode2($lda, $qt, $rootnode, $rootqcode);
 if ($rootnode eq '') {
   #print "Invalid or mismatched qualifier type ($qt) or code ($rootqcode)."
   #. "<BR>";
   print "Qualifier code '$rootqcode' is incomplete, invalid, or does not"
    . " match qualifier type '$qt'<BR>";
   chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
   print STDERR "***$time $remote_host $k_principal $progname $input_string\n";
   print STDERR "***$time $remote_host $k_principal $progname Error.\n";
   die "Invalid or mismatched qualifier type ($qt) or code ($rootqcode)."
   . "<BR>";
 }

#
#  Figure out if the rootnode specified is a "big branch" of the qualifier
#  tree.
#
 $is_big_branch = 0;  # Default -- not a big branch
 foreach $node (@big_branch) {
   if ($rootqcode eq $node) {
     $is_big_branch = 1;
     last;
   }
 }

#
#  If childqc was specified, then set number of levels to all_levels.
#  Set number of levels:  2 for "big branches", 
#  levels from parameter if specified, 2 if SG_ALL, otherwise 3.
#
 if ($child_code) {
   $num_levels = $all_levels;
 }
 elsif ($is_big_branch && (!$levels)) {
   $num_levels = 2;
 }
 elsif ($is_big_branch && ($levels)) {
   if ($secret eq $secret_password) {
     $num_levels = $levels;
   }
   elsif ($qt eq 'COST' && ($no_leaf eq '1')) {
       $num_levels = $levels;
   }
   else {
     $num_levels = ($levels > 3) ? 2 : $levels;
   }
 }
 elsif ($levels) {
   $num_levels = $levels;
 }
 elsif ($rootqcode eq 'SG_ALL') {
   $num_levels = 2; 
 }
 elsif ($rootqcode eq 'D_ALL') { # 4 levels for DEPT hierarchy
   $num_levels = 4; 
 }
 else {
   $num_levels = 3;
 }

#
#  Find a list of qualifier_id's for which there is at least one 
#  authorization in the branch of the tree being displayed.  Don't
#  bother to do this if we're looking at a big branch, because we're
#  going to limit the number of levels deep we can look and
#  %qualid_list, a hash to aid performance by cutting down on the
#  number of qualifiers for which we do a SELECT from the authorization
#  table, is not needed.
#
 %qualid_list = ();
 if (!$is_big_branch) {
   &get_qualid_list($lda, $qt, $rootnode, \%qualid_list);
 }

#
#  Get a list of inactive Kerberos usernames.  We will flag these
#  users in red.
#
 %inactive_user = ();
 if ($cat) {  # Don't bother if we're not displaying auths. in a category
   &get_inactive_users($lda, \%inactive_user);
 }

#
#  If the "rolesflag" parameter is 'Y' (i.e., user wants to see which
#  users have a perMIT username/password), then go get a list of 
#  people who have perMIT usernames.
#
 %rdb_user = ();
 if ($rolesflag eq 'Y') {
   &get_roles_users($lda, \%rdb_user);
 }

#
# Make $no_leaf = 1 the default if the qualifier_type is 'DEPT' and 
# we are displaying authorizations.
#
 if ( ($no_leaf eq 'D') && ($cat) && ($qt eq 'DEPT') ) {
   $no_leaf = 1;
 }

#
# Define "global" cursors for 3 select statements.  We'll later bind
# specific values to the parameters.
#
# The first statement finds the
# qualifier_code, _name, and has_child for a given qualifier_id.
# (It is used in the initial call to get_descendents.)
#

 $stmt1 = "select q1.qualifier_id, q1.qualifier_code," 
          . " q1.qualifier_name, q1.has_child, q1.qualifier_level,"
          . " q2.qualifier_code"
          . " from qualifier q1, primary_auth_descendent pad, qualifier q2"
          . " where q1.qualifier_id = ?"
          . " and pad.child_id(+) = q1.qualifier_id"
          . " and pad.is_dlc(+) = 'Y'"
          . " and q2.qualifier_id(+) = pad.parent_id"
          . " order by q1.qualifier_code, q2.qualifier_code";
 #print $stmt1 . "<BR>";
 unless ($gcsr1 = $lda->prepare($stmt1)) 
 {
    print "Error preparing statement 1.<BR>";
    die;
 }

# 
# The second select statement varies depending on whether the URL
# specifies a child_qc.  Also, vary the sort order according to the
# sort parameter on the URL.  Basically, it finds children of the
# given qualifier.
#
 $gcsr2_parms = 1;  # For most cases, there is 1 parameter to bind.
 if ($child_code) {
   ($child_id) = &get_child_id($lda, $qt, $child_code);
   $sql_fragment = " and (q1.qualifier_id = '$child_id' or q1.qualifier_id in"
             . " (select parent_id from qualifier_descendent"
             . " where child_id = '$child_id'))";
 }
 else {$sql_fragment = '';}
 if (($qt eq 'FUND' || $qt eq 'COST') && ($hide_term3 eq 'Y')) {
   $hide_term3_sql_frag1 = ", wh_cost_collector w";
   $hide_term3_sql_frag2 = 
      " and w.cost_collector_id(+) = substr(q1.qualifier_code, 2)"
    . " and nvl(w.term_code, '0') <> '3'";
 }
 else {
   $hide_term3_sql_frag1 = "";
   $hide_term3_sql_frag2 = "";
 }
 $sort_order = ($sort_option eq 'NAME')
        ? "q1.qualifier_name, q2.qualifier_code"
        : "replace(replace(q1.qualifier_code,'FC_','E_'),"   #FC before F
          . "'D_', 'Z_'),"     # D_ after everything else
          . "q2.qualifier_code";
 $stmt2 = "select q1.qualifier_id, q1.qualifier_code,"
          . " q1.qualifier_name, q1.has_child, q1.qualifier_level,"
          . " q2.qualifier_code"
          . " from qualifier_child qc,"
          . " qualifier q1, primary_auth_descendent pad, qualifier q2"
          . $hide_term3_sql_frag1
          . " where qc.parent_id = ?"
          . " and q1.qualifier_id = qc.child_id"
          . $hide_term3_sql_frag2
          . " and pad.child_id(+) = q1.qualifier_id"
          . " and pad.is_dlc(+) = 'Y'"
          . " and q2.qualifier_id(+) = pad.parent_id"
          . $sql_fragment
          . " order by $sort_order";
 ## The following is a fix 03/07/01
 if ($no_leaf eq '1' && (!$child_code)) { # Special case for no_leaf display
   $stmt2 = &get_special_select($qt);
   $gcsr2_parms = 2;
 }
 #print $stmt2 . "<BR>";
 unless ($gcsr2 = $lda->prepare($stmt2)) 
 {
    print "Error preparing statement 2.<BR>";
    die;
 }

#
# The third select statement is used to find authorizations associated
# with qualifiers in the hierarchy.  It varies depending on whether the URL 
# specifies detail=0, 1, or 2.
#
 #print "cat='$cat'<BR>";
 #print "category='$category'<BR>";
 if ($cat) {  # We only need this SELECT if viewing auths. in a category
   if ($display_detail == 1) {
     $sql_fragment3 = "a.kerberos_name || ' (' || function_name || ')' "
                      . "|| ' grant=' || decode(grant_and_view, 'GD', 'y','n')"
                      . " || ' mod. ' || modified_by"
                      . " || ', ' || to_char(modified_date,"
                      . "'MM/DD/YY')";
     $sql_fragment3a = ' where';
   }
   elsif ($display_detail == 2) {
     $sql_fragment3 = "a.kerberos_name || ' ' || initcap(p.first_name) || ' '"
                      . " || initcap(p.last_name)"
                      . " || ' (' || function_name || ')'";
     $sql_fragment3a = ", person p"
                       . "  where p.kerberos_name = a.kerberos_name and";
   }
   elsif ($display_detail == 3) {
     $sql_fragment3 = "a.kerberos_name || ' ' || initcap(p.first_name) || ' '"
        . " || initcap(p.last_name) || ' - '"
        . " || decode(p.primary_person_type, 'E', 'employee', 'S', 'student',"
        . " 'other')"
        . " || ' ' || p.dept_code"
        . " || ' (' || function_name || ')'";
     $sql_fragment3a = ", person p"
                       . "  where p.kerberos_name = a.kerberos_name and";
   }
   else {
     $sql_fragment3 = "a.kerberos_name || ' (' || function_name || ')'";
     $sql_fragment3a = ' where';
   }
   $sql_fragment4 = ($pkerbname) ? "and a.kerberos_name = '$pkerbname'"
                                 : "";
   my $sql_fragment5;
   if ($category =~ /,/) {  # Multiple categories?
     my @cat_list = split(',', $category);
     my $cat_item;
     my $ii;
     $sql_fragment5 = "function_category in (";
     for ($ii=0; $ii<@cat_list; $ii++) {
       $cat_item = substr($cat_list[$ii] . '   ', 0, 4);
       if ($ii > 0) {$sql_fragment5 .= ",";}
       $sql_fragment5 .= "'$cat_item'";
     }
     $sql_fragment5 .= ")";
   }
   else {
     $sql_fragment5 = "function_category = rpad('$cat4', 4)";
   }
   #print "sql_fragment5 = '$sql_fragment5'<BR>";

   $sort_order = ($group_option eq '2') ? "a.function_name, a.kerberos_name"
                                        : "a.kerberos_name, a.function_name";

   $stmt3 = "select "
          . "$sql_fragment3 ,"
          . " do_function,"
          . " AUTH_SF_IS_AUTH_CURRENT(effective_date, expiration_date),"
          . " a.function_name"
          . " from authorization a"
          . $sql_fragment3a
          . " qualifier_id = ?"
          . " and $sql_fragment5"
          . " $sql_fragment4"
          . " order by $sort_order";
   #print $stmt3 . "<br>";
   unless ($gcsr3 = $lda->prepare($stmt3)) 
   {
      print "Error preparing statement 3.<BR>";
      die;
   }
 }

#
#  Get a list of qualifiers.  (Also include authorizations interleaved
#  with qualifiers.)
#
@qid = ();     # Qualifier_ID (0 for authorization lines)
@qcode = ();   # Qualifier_code ('' for authorization lines)
@qname = ();   # Qualifier_name (also used to hold authorization info)
@qdisplay = (); # Holds display stuff, vertical lines and indentations
@qhaschild = (); # 'Y' if qualifier has children (always 'N' for auths.)
@qdept = ();   # Dept code for the qualifier from primary_auth_descendent table
@itemtype = ();  # 'A' for authorizations, 'Q' for qualifiers
&get_descendents($qt, $rootnode, 1, $num_levels, '', '');

#
#  Drop connection to Oracle.
#
$lda->rollback;
$lda->disconnect;

#
#  Get the qualifier_code of the root node
#
$rootcode = ($rootnode eq 'ROOT') ? 'ROOT' : $qcode[0];
$root_description = ($rootnode eq 'ROOT') ?
   'the root node of the tree' : 
   'code ' . $rootcode . ' in the tree';

#
#  Print out headers for the http document.  
#
 print "<HTML>", "\n";
 if ($cat) {  # Headers for displays with authorizations in a category
   $list_cat = ($category =~ /,/) ? $category : $cat;
   if (!$child_code) {
     $header = 
      "perMIT Database: $list_cat Authorizations within the $qt hierarchy";
   }
   else {
     $header = 
      "Position of $child_code in the $qt hierarchy, with authorizations";
   }
 }
 else {  # Headers for qualifier displays without authorizations
   if (!$child_code) {
     $header = "perMIT Database: Display of $qt hierarchy";
   }
   else {
     $header = "Position of $child_code in the $qt hierarchy";
   }
 }
 print "<HEAD><TITLE>$header",
       "</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 &print_header ("$header", $http_https);
 $n = @qid;  # How many qualifiers?
 if (!$n) {
   print "Qualifier '$rootqcode' ('$rootcode') of type $qt not found.\n";
   exit();
 }

#
#  Print out more headers for the HTML document
#
 # Describe the meaning of "red" if there are inactive users (which
 # we only find if we are displaying auths. in a category)
 $header_fragment = (scalar(%inactive_user))  # If there are inactive users
   ? 'Usernames shown in <font color="red">red</font> are deactivated'
     . '  Kerberos usernames whose authorizations should be deleted. '
    : '';
 # Describe the meaning of "(r)" if the user has set the "rolesflag"
 # parameter in the URL.
 $header_fragment2 = ($rolesflag eq 'Y')  # If rolesflag parm is set
    ? ' Users flagged with (r) have a username/password in the Roles'
      . '  Database that allows them to maintain authorizations.'
    : '';
 print "<P>";
 if ($cat) {
   if (!$child_code) {
     print "This is a hierarchical display of qualifiers of type $qt"
           . " starting from $root_description, along with authorizations"
           . " of category $cat.  Authorizations shown in"
           . ' <font color="#909090">gray</font> are'
           . " expired or inactive. $header_fragment $header_fragment2"
           . "  To move down in the tree"
           . " (i.e., view a branch of the tree in more detail)"
           . " click on a qualifier code below.  To move up in"
           . " the tree (closer to the root) click the two dots (..)"
           . " above the first displayed qualifier.", "\n";
   }
   else {
     print "This is a display of all paths within the $qt hierarchy"
           . " between the root node and $child_code, along with"
           . " authorizations of category $cat.  Authorizations shown in"
           . ' <font color="#909090">gray</font> are'
           . " expired or inactive. $header_fragment", "\n";
   }
 }
 else {
   if (!$child_code) {
     print "This is a hierarchical display of qualifiers of type $qt"
           . " starting from $root_description. To move down in the tree"
           . " (i.e., view a branch of the tree in more detail)"
           . " click on a qualifier code below.  To move up in"
           . " the tree (closer to the root) click the two dots (..)"
           . " above the first displayed qualifier.", "\n";
   }
   else {
     print "This is a display of all paths within the $qt hierarchy"
           . " between the root node and $child_code.", "\n";
   }
 }

#
#  If this is a FUND or COST display, then print instructions about hiding
#  or showing qualifiers with TERM_CODE = '3'.
#
 if ($qt eq 'COST' || $qt eq 'FUND') {
   $term_hide_show_text = ($hide_term3 eq 'Y') ? 'hidden.' : 'shown.';
   $qcode_start = '<A HREF="' . $url_stem . 'rootnode=' . $rootnode
                  . '&levels=' . $num_levels;
   if ($child_code) {$qcode_start .= "&childqc=$child_code";} # 3/6/01
   $term_hide_show_link = ($hide_term3 eq 'Y') ?
     $qcode_start . '&hide_term3=N">(Show them.)</A>'
     : $qcode_start . '&hide_term3=Y">(Hide them.)</A>';     
   print "If any terminated funds or cost collectors exist within the"
         . " chosen branch and detail level of the hierarchy, they are"
         . " $term_hide_show_text $term_hide_show_link";
 }

#
#  If this is not a "big branch" of one of the trees, 
#  allow the person to select a different number of levels to display.
#  Suppress this choice if qualifier_type is BAGS or BUDG.
#
 $suppress = ($qt eq 'BAGS' || $qt eq 'BUDG') ? 1 : 0;
 $display_levels = ($num_levels == $all_levels) ? 'all' : $num_levels;
 print " The current display shows $display_levels levels of the hierarchy.";
 #print "is_big_branch = $is_big_branch suppress=$suppress<BR>";
 if ( ((!$is_big_branch) && (!$suppress)) 
      || (($no_leaf eq '1') && $qt eq 'COST') ) {
   print " You can redisplay with: \n";
   $qcode_start = '<A HREF="' . $url_stem . 'rootnode=' . $rootnode;
   $max_level = ($num_levels == 5) ? 4 : 5;
   for ($i = 2; $i <= $max_level; $i++) {
     if ($i != $num_levels) {
       if (($i < $max_level) || ($num_levels < $all_levels)) {
         print $qcode_start . '&levels=' . $i . '">'
             . "$i&nbsp;levels</A>, \n";
       }
       else {
         print 'or ' . $qcode_start . '&levels=' . $i . '">'
             . "$i&nbsp;levels</A>.\n";
       }
     }
   }
   if ($num_levels != $all_levels) {
     print 'or ' . $qcode_start . '&levels=' . $all_levels . '">'
           . "all&nbsp;levels</A>.\n";
   }
 }
 print "<P>";
 print "<HR>", "\n";

#
#  If we're going to display authorizations, then print qualifier codes
#  and names in bold-face.  Otherwise, do not print them in bold-face.
#  (Also, set the $deptfont directives to the opposite.)
#
 if ($cat) {
   $bold = '<b>';
   $endbold = '</b>';
   $deptfont = '<font color="orange">';
   $enddeptfont = '</font>';
 }
 else {
   $bold = '';
   $endbold = '';
   $deptfont = '<b>';
   $enddeptfont = '</b>';
 }

#
#  Print the rest of the document
#
 printf "<TT>", "\n";
 if ($rootlevel != 1) {
   #print "..<BR>\n";
   $xqcode = $qcode[0];
   $xqcode =~ s/&/%26/;
   print '<A HREF="' . $url_stem . 'childqc=' . $xqcode . '"> '
            . "..</A><BR>\n";
 }
 for ($i = 0; $i < $n; $i++) {
   if ($qhaschild[$i] eq 'Y') {  # If has child, point to URL
     $qcode_string = '<A HREF="' . $url_stem
            . 'rootnode=' . $qid[$i] . '">' 
            . $bold . $qcode[$i] . $endbold . '</A>';
   }
   # Special case - message about Root-level auths being suppressed
   elsif ($qname[$i] =~ /^Authorizations for root/ && $itemtype[$i] eq 'A') {
     $qname[$i] = '<i>' . $qname[$i] . '</i> (<A HREF="' . $url_stem
         . 'rootnode=' . $qid[$i-1] . '&showrootauths=Y';
     if ($child_code) {$qname[$i] .= "&childqc=$child_code";} # 3/7/01
     $qname[$i] .= '">Show them</A>)';
     $qcode_string = $bold . $qcode[$i] . $endbold;
   }
   else {  # Qualifier leaf or auth.
     $qcode_string = $bold . $qcode[$i] . $endbold;
   }
   # If this is for DEPT hierarchy, label the type of qualifier
   if ($qt eq 'DEPT' && substr($qcode[$i], 0, 2) ne 'D_'
       && $itemtype[$i] eq 'Q') {
     $qname_subtype = &subtype_desc($qcode[$i]);
   }
   else {$qname_subtype = ' ';}
   # Make qualifiers bold if there are authorizations
   $qname_string = ($itemtype[$i] eq 'Q')
                   ? $bold . $qname[$i] . $endbold
#???                ? $bold . "<small>" . $qname[$i] . "</small>" . $endbold
                   : $qname[$i];
   if ($showdeptname eq 'Y' && $qdept[$i]) {  # Add dept name if found
     $qname_string .= " $deptfont" . $qdept[$i]
                      . "$enddeptfont";
   }
   my $padstring; #???
   if ($itemtype[$i] eq 'Q') {
      $root_finder++;  # Count qualifiers.
      my $padlen = 14 - length($qcode[$i]);  #???
      $padstring = ($padlen > 0) ? "&nbsp;" x $padlen  #???
                                 : '';                 #???
   }
   if ($itemtype[$i] eq 'A' && $group_option eq '2') {  # Adjust person/auth
     $qcode_string = "&nbsp;&nbsp;$qcode_string";
   }
   #$qcode_string = $qcode_string . $padstring;  #?????
   unless ($itemtype[$i] eq 'F' && $group_option eq '1') {
     ### <<<
     if ($itemtype[$i] eq 'Q') {
       print "$qdisplay[$i]$qname_string $qname_subtype"
             . "($qcode_string)";
     }
     else {
       print $qdisplay[$i] . $qcode_string . $qname_string;
     }
     ### >>>
   }
   if (($qt eq 'COST' || $qt eq 'FUND') && $itemtype[$i] eq 'Q' &&
       $qcode[$i] =~ /^[CIPWF][0-9]/) {  # Cost object or Fund -- C.O. Detail
     print ' <A HREF="' . $url_stem3
            . 'cost_object=' . $qcode[$i] . '">'
            . "*</A>";
   }
   elsif ($qt eq 'SPGP' 
          && $qcode[$i] ne 'SG_ALL'
          && $itemtype[$i] eq 'Q') {  # Spend. grp.--Link to FC
     $fc_code = $qcode[$i];
     $fc_code =~ s/SG_/FC_/;
     print ' <A HREF="' . $url_stem4 
            . 'qualtype=FUND+%28Fund+Centers+and+Funds%29'
            . '&rootcode=' . $fc_code . '&levels=3">'
            . "*</A>";
   }
   elsif ($qt eq 'DEPT' && $itemtype[$i] eq 'Q') { #Various links fr DEPT hier.
     $l_code = $qcode[$i];
     $l_code =~ s/&/%26/;
     if ($l_code =~ /^FC/) {
       print ' <A HREF="' . $url_stem 
            . 'qualtype=FUND+%28Fund+Centers+and+Funds%29'
            . '&rootcode=' . $l_code . '&levels=3">'
            . "*</A>";
     }
     elsif ($l_code =~ /^SG/) {
       print ' <A HREF="' . $url_stem 
            . 'qualtype=SPGP+%28Spending+Groups%29'
            . '&rootcode=' . $l_code . '&levels=2">'
            . "*</A>";
     }
     elsif ($l_code =~ /^(0HPC|PC)/) {
       print ' <A HREF="' . $url_stem 
            . 'qualtype=COST+%28Cost+Object+and+PC%29'
            . '&rootcode=' . $l_code . '&levels=2">'
            . "*</A>";
     }
     elsif ($l_code =~ /^[0-9]{6}$/) {
       print ' <A HREF="' . $url_stem 
            . 'qualtype=ORGU+%28Org.+Unit+(Personnel)&29'
            . '&rootcode=' . $l_code . '&levels=2">'
            . "*</A>";
     }
     elsif ($l_code =~ /^7[0-9]{7}$/ || $l_code =~ /^(0HL|LDS)/) {
       $l_code =~ s/^LDS_//;  # If there is LDS prefix, remove it.
       print ' <A HREF="' . $url_stem 
            . 'qualtype=LORG+%28LDS+Org.+Unit&29'
            . '&rootcode=' . $l_code . '&levels=2">'
            . "*</A>";
     }
     elsif ($l_code =~ /^SIS_/) {
       $l_code =~ s/^SIS_//;  # If there is SIS prefix, remove it.
       print ' <A HREF="' . $url_stem 
            . 'qualtype=SISO+%28SIS+Org.+Unit&29'
            . '&rootcode=' . $l_code . '&levels=2">'
            . "*</A>";
     }
     elsif ($l_code =~ /^[0-9]{3}$/) {
       print ' <A HREF="' . $url_stem 
            . 'qualtype=BAGS+%28NIMBUS+Budget+Area+Groups%29'
            . '&rootcode=' . $l_code . '&levels=2">'
            . "*</A>";
     }
   }
   unless ($itemtype[$i] eq 'F' && $group_option eq '1') {
     print "<BR>\n";
   }
 }

 printf "</TT>", "\n";
 print "<HR>", "\n";
 $seconds = time() - $epoch;
 #print "<small>Run time = $seconds seconds.</small><br>";
 print "<A HREF=\"$main_url\"><small>Back to main perMIT web interface page</small></A>";
 print "</BODY></HTML>", "\n";
 exit(0);

###########################################################################
#
#  Recursive subroutine get_descendents.
#
###########################################################################
sub get_descendents {
  my ($qualtype, $rootnode, $lev, $maxlev, $prefix, $rootqcode) = @_;
  my ($csr);
  my $i = 0;
  my $new_prefix = '';
  #print "QUALTYPE=$qualtype ROOTNODE=$rootnode LEV=$lev MAXLEV=$maxlev\n<BR>";

  #
  #  Open a cursor for select statement.  (If lev == 1, then find the 
  #    qualifier_code, etc. for the given qualifier_id.  Otherwise, 
  #    find the children of the given qualifier.)
  #
  if ($lev == 1) {
    $gcsr1->bind_param(1, $rootnode);
    $gcsr1->execute;
    $csr = $gcsr1;
  }
  else {
    $gcsr2->bind_param(1, $rootnode);
    if ($gcsr2_parms == 2) {
      $gcsr2->bind_param(2, $rootnode);
    }
    #print "rootnode=$rootnode<BR>";
    $gcsr2->execute;
    $csr = $gcsr2;
  }

  #
  #  Get a list of qualifiers
  #
  my ($aastring, $aadf, $aacurrent, $aafunc);
  my @mqid = ();
  my @mqcode = ();
  my @mqname = ();
  my @mqhaschild = ();
  my @mqdept = ();
  my $lastqcode = '';
  my $lastdept = '';
  my $lastquallevel = 0;
  my $rdb_user_flag = '';
  my $kerbname = '';
  my $tempfunc;
  while (($qqid, $qqcode, $qqname, $qqhaschild, $qquallevel, $qqdept) 
         = $csr->fetchrow_array) 
  {
        # If this is a repeat of the previous qualifier code, then
        # we've got a qualifier with two departments, and we should just
        # append the new department to @mqdept.  Otherwise, add a new
        # item to the arrays.
        if (($lastqcode eq $qqcode) && ($lastdept)) {
          $qqdept = $lastdept . "," . substr($qqdept,2);
          pop(@mqdept);
          push(@mqdept, $qqdept);
        }
        else {
          $qqname =~ s/</&lt;/g;  # Handle < in qualifier name
          push(@mqid, $qqid);
          push(@mqcode, $qqcode);
          push(@mqname, $qqname);
          push(@mqdisplay, '..' x ($lev-1) . $qqname);
          push(@mqhaschild, $qqhaschild);
          $qqdept = substr($qqdept, 2);
          push(@mqdept, $qqdept);
        }
        $lastqcode = $qqcode;
        $lastdept = $qqdept;
        if ($lastquallevel==0) {$lastquallevel = $qquallevel;} #Save quallevel
  }

  #
  #  Now, put each record, from local arrays, into the global array variables.
  #  Where there is a child record and we haven't reached the desired level,
  #  call this routine recursively to get the children.
  #

  my $n = @mqid;  # How many qualifiers?
  my $expander = '';
  my ($len_qualifier, $lenminus3, $extra_spacing); #****

  #
  # Set extra spacing for functions and authorizations under the 
  # root qualifier.
  #
  $len_qualifier = length($rootqcode); #****
  #print "rootqcode='$rootqcode' rootnode='$rootnode'\n";
  $lenminus3 = ($len_qualifier < 3) ? 0: $len_qualifier-3; #****
  #$extra_spacing = '&nbsp;' x $lenminus3;
  $extra_spacing = '';

  # Look for authorizations associated with $rootnode
  # Push dummy elements onto arrays -- place-holder for authorizations.
  # Note that this code is first executed when $lev==2. We process 
  # authorizations for a level n qualifier when we are at level n+1.
  # Otherwise, we wouldn't know if there are children to this node,
  # which we have to know in order to properly draw the vertical lines.
  if ($cat &&  # Skip it if there is no category
      $lev != 1 && ($is_big_branch || $qualid_list{$rootnode})) {
    $gcsr3->bind_param(1, $rootnode);
    $gcsr3->execute;
    my $authcount = 0;
    my $stacked_count = 0;
    my $prev_func = '';
    my $prev_qcode = '';
    LISTOFAUTHS: while (($aastring, $aadf, $aacurrent, $aafunc) 
                        = $gcsr3->fetchrow_array)
    {
      $authcount++;
      #####
      # If this is the rootnode and there are 10 or more authorizations,
      # then check and see if we should suppress root-level authorizations.
      # Look for $showrootauths = 'N' and $lev = $qualifier_level = 2.
      # (Note that we are already at the 2nd level when we look for 
      # authorizations for the root level.)
      #####
      if ($lev==2 && $lastquallevel==2 && $showrootauths eq 'N'
          && $authcount>=10)
      {
        for ($ii = 0; $ii < $stacked_count; $ii++) { # Pop items off stack
	  &pop_qual_row();
        }
        my $qqdisplay = ($n) ? $prefix . "\|&nbsp&nbsp;"
                             : $prefix . "&nbsp&nbsp&nbsp;";
        &push_qual_row(0, '', 
            "Authorizations for root are suppressed for navigatability\n",
            $qqdisplay . $extra_spacing, 'N', '', 'A');  #****
        $stacked_count++;
        last LISTOFAUTHS;
      }
      #####
      if ($rolesflag) {  # Flag users who have perMIT DB username/password
        $aastring = &adjust_user_string($aastring);
      }
      my $qqdisplay = ($n) ? $prefix . "\|&nbsp&nbsp;" 
                           : $prefix . "&nbsp&nbsp&nbsp;";
      if ($prev_func ne $aafunc || $prev_qcode ne 'TEMP_ROOT') {
        &push_qual_row(0, '', "${funcfont}${aafunc}${endfuncfont}", 
                       $qqdisplay . $extra_spacing, 'N', '', 'F');
        $stacked_count++;
        $prev_func = $aafunc;
        $prev_qcode = 'TEMP_ROOT';
      }
      if ($group_option eq '2') {
        $tempfunc = &escape_string($aafunc);
        $aastring =~ s/ \($tempfunc\)//;  # Remove the "(function)" string
      }
      $aastring 
         = &colorize_authstring($aastring, $aadf, $aacurrent);
      &push_qual_row(0, '', $aastring, $qqdisplay . $extra_spacing, 
                     'N', '', 'A'); #****
      $stacked_count++;
    }
  }

  # Handle qualifiers and authorizations for nodes other than $rootnode
  for ($i = 0; $i < $n; $i++) 
  {
    $expander = $prefix . '+--';
    &push_qual_row($mqid[$i], $mqcode[$i], $mqname[$i], $expander,
                   $mqhaschild[$i], $mqdept[$i], 'Q');
    $len_qualifier = length($mqcode[$i]);  #****
    if (($lev != $maxlev) && ($mqhaschild[$i] eq 'Y')) {
      $new_prefix 
       = ($i < $n-1) ? $prefix . '|&nbsp&nbsp;' : $prefix . '&nbsp&nbsp&nbsp;';
      &get_descendents($qt, $mqid[$i], $lev+1, $maxlev, $new_prefix, 
                       $mqcode[$i]);  #****
    }
    elsif (($cat) && ($is_big_branch || $qualid_list{$mqid[$i]})) {
      # We end up here only if we're at the last qualifier to be displayed
      # on the page.
      $gcsr3->bind_param(1, $mqid[$i]); # Use global select statement
      $gcsr3->execute;
      while (($aastring, $aadf, $aacurrent, $aafunc) 
             = $gcsr3->fetchrow_array) {
        if ($rolesflag) {  # Flag users who have perMIT DB username/password
          $aastring = &adjust_user_string($aastring);
        }
        $new_prefix 
         = ($i < $n-1) ? $prefix . '|&nbsp&nbsp&nbsp&nbsp&nbsp;' 
                       : $prefix . '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp;';
        if ($prev_func ne $aafunc || $prev_qcode ne $mqcode[$i]) {
          $lenminus3 = ($len_qualifier < 3) ? 0: $len_qualifier-3; #****
          #$extra_spacing = '&nbsp;' x $lenminus3;
          $extra_spacing = '';
          &push_qual_row(0, '', "${funcfont}${aafunc}${endfuncfont}", 
                         $new_prefix . $extra_spacing, 'N', '', 'F');
          $prev_func = $aafunc;
          $prev_qcode = $mqcode[$i];
        }
        if ($group_option eq '2') {
          $tempfunc = &escape_string($aafunc);
          $aastring =~ s/ \($tempfunc\)//;  # Remove the "(function)" string
        }
        $aastring 
           = &colorize_authstring($aastring, $aadf, $aacurrent);
        &push_qual_row(0, '', "$aastring\n", $new_prefix . $extra_spacing, 
                       'N', '', 'A'); #****
      }
    }
  }
}

###########################################################################
#
#  Subroutine push_qual_row
#   ($qqid, $qqcode, $qqname, $qqdisplay, $qqhaschild, $qqdept, $iitemtype)
#  
#  Push a virtual "row" onto a "table" of qualifiers that is kept in
#  a set of arrays.  (Each array represents a column.)
#
###########################################################################
sub push_qual_row {
  my ($qqid, $qqcode, $qqname, $qqdisplay, $qqhaschild, $qqdept, $iitemtype)
      = @_;
  push(@qid, $qqid);
  push(@qcode, $qqcode);
  push(@qname, $qqname);
  push(@qdisplay, $qqdisplay);
  push(@qhaschild, $qqhaschild);
  push(@qdept, $qqdept);
  push(@itemtype, $iitemtype);
}

###########################################################################
#
#  Subroutine pop_qual_row()
#  
#  Pop a virtual "row" from a "table" of qualifiers that is kept in
#  a set of arrays.  (Each array represents a column.)
#
###########################################################################
sub pop_qual_row {
  pop(@qid);
  pop(@qcode);
  pop(@qname);
  pop(@qdisplay);
  pop(@qhaschild);
  pop(@qdept);
  pop(@itemtype);
}

###########################################################################
#
#  Subroutine 
#   get_qualid_list($lda, $qualtype, $rootnode, \%qualid_list)
#  
#  Build a hash %qualid_list setting $qualid_list{$qualid} = 1
#  for each qualifier id in the requested branch of the tree that
#  is used in an authorization.
#
###########################################################################
sub get_qualid_list {
  my ($lda, $qualtype, $rootnode, $rqualid_list) = @_;
  my ($csr, $stmt6, $auth_qual_id);
  $stmt6 = "select distinct a.qualifier_id"
     . " from authorization a, qualifier_descendent qd"
     . " where"
     . " a.qualifier_id = qd.child_id"
     . " and qd.parent_id = $rootnode"
     . " union select distinct a.qualifier_id"
     . " from authorization a"
     . " where"
     . " a.qualifier_id = $rootnode";
  
  unless ($csr = $lda->prepare($stmt6)) 
  {
     print "Error preparing statement 6.<BR>";
     die;
  }
  $csr->execute;
  while ( ($auth_qual_id) = $csr->fetchrow_array ) {
     $$rqualid_list{$auth_qual_id} = 1;
  }
  $csr->finish;
}

###########################################################################
#
#  Subroutine 
#   get_inactive_users($lda, \%inactive_user)
#  
#  Build a hash %inactive_user setting $inactive_user{$kerbname} = 1
#  for each kerberos_name marked as Inactive in the PERSON table.
#
###########################################################################
sub get_inactive_users {
  my ($lda, $rinactive_user) = @_;
  my ($csr, $stmt7, $kerbname);
  $stmt7 = "select kerberos_name"
     . " from person"
     . " where"
     . " status_code = 'I'";
  
  unless ($csr = $lda->prepare($stmt7)) 
  {
     print "Error preparing statement 7.<BR>";
     die;
  }
  $csr->execute;
  while ( ($kerbname) = $csr->fetchrow_array ) {
     $$rinactive_user{$kerbname} = 1;
  }
  $csr->finish;
}

###########################################################################
#
#  Subroutine 
#   get_roles_users($lda, \%rdb_user)
#  
#  Build a hash %rdb_user setting $rdb_user{$kerbname} = 1
#  for each kerberos_name who has a username/password for connecting
#  to the perMIT Database.
#
###########################################################################
sub get_roles_users {
  my ($lda, $rroles_user) = @_;
  my ($csr, $stmt8, $username);
  $stmt8 = "select username"
         . " from all_users";
  
  unless ($csr = $lda->prepare($stmt8)) 
  {
     print "Error preparing statement 8.<BR>";
     die;
  }
  $csr->execute;
  while ( ($username) = $csr->fetchrow_array ) {
     $$rroles_user{$username} = 1;
  }
  $csr->finish;
}

###########################################################################
#
#  Function get_rootnode2($lda, $qualtype, $rootnode, $rootqcode)
#
#  Finds the qualifier_id associated with the rootnode.
#
###########################################################################
sub get_rootnode2 {
  my ($lda, $qualtype, $rootnode, $rootqcode) = @_;
  my ($csr, $stmt4, $stmt4a, $stmt5, $rootid, $rootcode, $rootlevel);
  if ($rootnode ne 'ROOT' && $rootnode ne '') {
    $stmt4a = "select qualifier_code, qualifier_level from qualifier"
           . " where qualifier_id = '$rootnode'" 
	   . " and qualifier_type = '$qualtype'";
    unless ($csr = $lda->prepare($stmt4a)) 
    {
       print "Error preparing statement 4a.<BR>";
       die;
    }
    $csr->execute;
    ($rootcode, $rootlevel) = $csr->fetchrow_array;
    $csr->finish;
    return ($rootnode, $rootcode, $rootlevel);
  }
  elsif ($rootqcode ne '') {
    $stmt4 = "select qualifier_id, qualifier_level from qualifier"
           . " where qualifier_type = '$qualtype'"
           . " and qualifier_code = '$rootqcode'";
    unless ($csr = $lda->prepare($stmt4)) 
    {
       print "Error preparing statement 4.<BR>";
       die;
    }
    $csr->execute;
    ($rootid, $rootlevel) = $csr->fetchrow_array;
    $csr->finish;
    return ($rootid, $rootqcode, $rootlevel);
  }
  else {
    $stmt5 = "select  /*+ INDEX(qualifier rdb_i_q_qualifier_level */"
           . " qualifier_id, qualifier_code, qualifier_level"
           . " from qualifier"
           . " where qualifier_type = '$qualtype'"
           . " and qualifier_level = 1";
    unless ($csr = $lda->prepare($stmt5)) 
    {
       print "Error preparing statement 4.<BR>";
       die;
    }
    $csr->execute;
    ($rootid, $rootcode, $rootlevel) = $csr->fetchrow_array;
    $csr->finish;
    return ($rootid, $rootcode, $rootlevel);
  }
}

###########################################################################
#
#  Function get_child_id($lda, $qualtype, $child_code)
#
#  Finds the qualifier_id associated with the child qualifier_code.
#
###########################################################################
sub get_child_id {
  my ($lda, $qualtype, $child_code) = @_;
  my ($csr, $stmt6, $child_id);
  $stmt6 = "select qualifier_id from qualifier"
           . " where qualifier_code = '$child_code'" 
	   . " and qualifier_type = '$qualtype'";
  unless ($csr = $lda->prepare($stmt6)) 
  {
     print "Error preparing statement 6.<BR>";
     die;
  }
  $csr->execute;
  ($child_id) = $csr->fetchrow_array;
  $csr->finish;
  if (!($child_id)) {
    print "Error: Qualifier '$child_code' of type '$qt' not found<BR>";
    die;
  }
  return ($child_id);
}

###########################################################################
#
#  Function colorize_authstring($authstring, $do_function, $is_current)
#
#  Examines the do_function flag (Y or N) and 
#  authorization-is-current flag (Y or N), plus checks %inactive_user()
#  for the kerberos username.
#  Adds html color specifiers to the $authstring as follows:
#    1. If the Kerberos username is "inactive", make it red
#    2. If the auth. is not in effect, because $do_function = N or
#       $is_current = N, then make the whole auth string gray.
#
#  Returns the adjusted $authstring.
#
###########################################################################
sub colorize_authstring {
  my ($authstring, $do_function, $is_current) = @_;
  my $kerbname = $authstring;
  $kerbname =~ s/\W.*//;  # Keep only the first word.
  if ($inactive_user{$kerbname}) {
    # Make the first word red
    $authstring =~ s/^([^ ]+)/<font color="red">$1<\/font>/;
  }
  if ($do_function eq 'N' || $is_current eq 'N') {
    $authstring = '<font color="#909090">' . $authstring . '</font>';
  }
  return $authstring;
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

###########################################################################
#
#  Function &subtype_desc($qualcode)
#
#  Returns '(org. unit)', '(PC node)', '(LDS Org.)', 
#   '(Std. FC)', '(Cust. FC)', '(Spend. Grp)' 
#  depending on the qualifier type implied by $qualcode.
#
###########################################################################
sub subtype_desc {
  my ($qualcode) = @_;
  #my ($pfx, $postfx)  = (' (', ') ');
  my ($pfx, $postfx)  = (' <small>(', ')</small> ');
  for ($qualcode) {
    if (/^[0-9]{6}$/) {return $pfx . 'Org. unit' . $postfx;}
    elsif (/^(0HPC|PC)/) {return $pfx . 'PC node' . $postfx;}
    elsif (/^7[0-9]{7}$/) {return $pfx . 'LDS org.' . $postfx;}
    elsif (/^(0HL|LDS)/) {return $pfx . 'LDS org.' . $postfx;}
    elsif (/^SIS_/) {return $pfx . 'SIS org.' . $postfx;}
    elsif (/^FC_/) {return $pfx . 'Cust. FC' . $postfx;}
    elsif (/^FC/) {return $pfx . 'Std. FC' . $postfx;}
    elsif (/^SG_/) {return $pfx . 'Spend Grp.' . $postfx;}
    elsif (/^[0-9]{3}/) {return $pfx . 'NIMBUS B.A.G.' . $postfx;}
  }
  return $pfx . '?' . $postfx;
}

###########################################################################
#
#  Function &adjust_user_string($userstring)
#
#  Takes a string starting with a Kerberos name, looks up the Kerberos
#  name to see if it has a perMIT username/password, and if so flags it
#  with '(r)'.  (There could be additional fields in $userstring which are
#  preserved.)
#
#  Returns the modified $userstring.
#
###########################################################################
sub adjust_user_string {
  my ($userstring) = @_;
  $userstring =~ /^([^ ]*) /;
  my $kerbname = $1;
  $rdb_user_flag = ($rdb_user{$kerbname}) ? '(r)' : '';
  $userstring =~ s/ /$rdb_user_flag /;
  return $userstring;
}

###########################################################################
#
#  Function &escape_string($string)
#
#  Takes a string that may contain special characters (*, .) and puts
#  an escape character (\) before those special characters.
#
#  Returns the modified $string.
#
###########################################################################
sub escape_string {
  my ($string) = @_;
  $string =~ s/\*/\\\*/g;
  $string =~ s/\./\\\./g;
  return $string;
}

###########################################################################
#
#  Function &get_special_select($qualtype)
#
#  When we don't want to see leaves of the tree, use a special 
#  select statement.  (This is used to show only levels of the
#  tree down to D_ for DEPT, PC for COST, FC for FUND.)
#
###########################################################################
sub get_special_select {
  my ($qt) = @_;

  my $sql_frag;
  my $sql_frag2 = '';
  if ($qt eq 'DEPT') {
    $sql_frag = " and substr(q2.qualifier_code(+),1,2) = 'D_'";
    $sql_frag2 = " and substr(q1.qualifier_code,1,2) = 'D_'";
  }
  elsif ($qt eq 'FUND') {
    $sql_frag = " and q2.qualifier_code(+) like 'FC%'";
  }
  elsif ($qt eq 'COST') {
    $sql_frag = " and q2.qualifier_code(+) like '%PC%'";
  }
  else {
    $sql_frag = "";
  }
  #print "sql_frag = '$sql_frag'<BR>";
  my ($sql_dept_frag1, $sql_dept_frag2, $sql_dept_frag3);
  if ($showdeptname eq 'Y') {
    $sql_dept_frag1 = ", q3.qualifier_code";
    $sql_dept_frag2 = ", primary_auth_descendent pad, qualifier q3";
    $sql_dept_frag3 = " and pad.child_id(+) = q1.qualifier_id"
          . " and pad.is_dlc(+) = 'Y'"
          . " and q3.qualifier_id(+) = pad.parent_id";
  }
  else {
    ($sql_dept_frag1, $sql_dept_frag2, $sql_dept_frag3) = ('', '', '');
  }
  my $stmt = 
      "select q1.qualifier_id, q1.qualifier_code,"
       . " q1.qualifier_name, decode(count(q2.qualifier_id), 0, 'N', 'Y'),"
       . " q1.qualifier_level"
       . $sql_dept_frag1
       . " from qualifier_child qc0, qualifier q1, qualifier_child qc,"
       . " qualifier q2"
       . $sql_dept_frag2
       . " where qc0.parent_id = ?"
       . " and q1.qualifier_id = qc0.child_id"
       . " and q1.has_child = 'Y'"
       . " and qc.parent_id = q1.qualifier_id"
       . " and q2.qualifier_id(+) = qc.child_id"
       . $sql_dept_frag3
       . $sql_frag
       . " group by q1.qualifier_id, q1.qualifier_code, q1.qualifier_name,"
       . " q1.qualifier_level"
       . $sql_dept_frag1
       . " union select q1.qualifier_id, q1.qualifier_code,"
       . " q1.qualifier_name, 'N', q1.qualifier_level"
       . $sql_dept_frag1
       . " from qualifier_child qc0, qualifier q1"
       . $sql_dept_frag2
       . " where qc0.parent_id = ?"
       . " and q1.qualifier_id = qc0.child_id"
       . " and q1.has_child = 'N'"
       . " $sql_frag2"
       . $sql_dept_frag3
       . " order by 2, 3";
  #print "$stmt<BR>";
  return $stmt;
}


