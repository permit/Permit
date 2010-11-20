#!/usr/bin/perl
###########################################################################
#
#  CGI script to list perMIT DB authorizations such that
#    User can do Function $func_name for Qualifier $qual_code
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
#  Modified 1/15/99, Jim Repa
#  Modified 2/11/99, Jim Repa - Add last_name, first_name to display
#  Modified 1/17/02, Jim Repa - Add "click for details", gray inactive auths.
#  Modified 1/28/02, Jim Repa - For reporting, add DEPT. HEAD REPORTING
#  >>>> Changes to be made:  
#       - Add link to my-auth.cgi for Kerberos name.
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
#  Set constants
#
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 $host = $ENV{'HTTP_HOST'};
 $url_stem = "http://$host/cgi-bin/qualauth.pl?"; # URL for qualifiers 1/2002
 $url_stem2 = "https://$host/cgi-bin/$progname?";  # URL for auth detail
 $url_stem3 = "https://$host/cgi-bin/auth-detail.pl?";  # URL for auth detail
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
 %formval = ();  # Hash of reformatted key->variables populated by &parse_forms
 %rawval = ();  # Hash of unformatted key->variables populated by &parse_forms
 &parse_forms($input_string, \%formval, \%rawval); # Call sub. to parse input

#
#  Get form variables
#
$func_name = $formval{'func_name'};  # Get value set in &parse_forms()
$qual_code = $formval{'qual_code'};  # Get value set in &parse_forms()
$skip_root = $formval{'skip_root'};  # Get value set in &parse_forms()
$show_all = $formval{'show_all'};  # Get value set in &parse_forms()
$category = $formval{'category'};  # Get value set in &parse_forms()
$raw_category = $rawval{'category'};  # Get value set in &parse_forms()
$raw_funcname = $rawval{'func_name'};  # Get value set in &parse_forms()
#$category = 'SAP';
#$func_name = 'APPROVER';
#$skip_root = 'Y';
#$qual_code = 'I2520200';
if (!$skip_root) {$skip_root = 'Y';}  # Set default
$cat = $category;
$cat =~ s/\W.*//;  # Keep only the first word.
$cat =~ tr/a-z/A-Z/;  # Change to upper case
$category =~ s/\w*\s//;  # Throw out first word.
$category =~ tr/A-Z/a-z/;  # Change to lower case

#
#  Set the title and header based on the requested function name and
#  qualifier code.
#
 if ($func_name eq 'CAN SPEND OR COMMIT FUNDS') {
   $title = "perMIT DB Spend/commit funds auths. for $qual_code";
   $header = "Who can spend or commit on fund $qual_code\?";
 }
 elsif ($func_name =~ /^REPORT BY CO\/PC/) {
   $title = "perMIT DB Reporting auths. on $qual_code";
   $header = "Who can report on $qual_code\?";
 }
 elsif ($func_name =~ /^APPROVER/) {
   $title = "perMIT DB Approver auths. on $qual_code";
   $header = "Who can approve on $qual_code\?";
 }
 else {
   $title = "perMIT DB Special Authorization List";
   $header = "Who can do function '$func_name' for qualifier '$qual_code'\?";
 }

#
#  Start printing HTML document
#
 print "Content-type: text/html", "\n\n";
 print "<HTML>", "\n";
 print "<HEAD><TITLE>$title</TITLE></HEAD>", "\n";

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
#  Log something
#
 $remote_host = $ENV{'REMOTE_HOST'};
 chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
 print STDERR "***$time $remote_host $k_principal $progname $input_string\n";


#
#  Get set to use Oracle.
#
use DBI;

#
# Login into the database
# 
$lda = login_dbi_sql('roles')
      || &web_error($DBI::errstr);

#
# Make sure the user has a meta-authorization to view $cat4 authorizations.
#
 if (!(&verify_metaauth_category($lda, $k_principal, $cat))) {
   print "Sorry.  You do not have the required perMIT DB 'meta-authorization'",
   " to view other people's $cat authorizations.";
   exit();
 }

#
#  If this is an SAP reporting authorization, then find the complementary
#  Fund for the given qualifier.  Also, set the alternate $func_name2.
#
if ($func_name eq 'REPORT BY CO/PC') {
 $func_name2 = $func_name;
 $func_name2 =~ s/CO\/PC/FUND\/FC/;
 $qual_code2 = $qual_code;
 $qual_code2 =~ s/[CIP]/F/;
}
else {
 $func_name2 = '';
 $qual_code2 = '';
}

#
#  Get a list of authorizations
#
&get_auths($lda, $cat, $func_name, $qual_code, $skip_root, 
           $func_name2, $qual_code2);

#
#  Drop connection to Oracle.
#
&ora_logoff($lda) || &web_error("can't log off Oracle");    

#
#  Print out the http document.  
#
 print '<BODY bgcolor="#fafafa">';
 &print_header("perMIT DB List of Authorizations", 'https');
 print "<HR>", "\n";
 print "<H2>$header</H2>\n\n";
 $n = @akerb;  # How many authorizations?
 print "<TABLE>", "\n";
 printf "<TR><TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH>"
        . "<TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH>"
        . "<TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH>"
        . "</TR>\n",
        'Last, First<BR>Name', 'Kerberos<BR>Username', 'Function Name', 
        'Qualifier<BR>Code', 
        'Do<BR>func-<BR>tion', 'Grant', 'Effec-<BR>tive<BR>Today',
        'Click<br>for<br>details';
 for ($i = 0; $i < $n; $i++) {
   if ($adf[$i] eq 'N' || $acurrent[$i] eq 'N') {
      $fcolor1 = "<FONT COLOR=GRAY>";
      $fcolor2 = "<\FONT>";
   }
   else {
      $fcolor1 = '';
      $fcolor2 = '';
   }
   if ($func_name eq 'APPROVER' && $i > 0 && $afn[$i] ne $afn[$i-1]) {
     # Mark different APPROVER function
     print "<TR><TD></TD><TD ALIGN=CENTER>* * *</TD></TR>\n";
   }
   $qcode_string = ($aqc[$i] ne 'NULL')
              ? '<A HREF="' . $url_stem . "qualtype=" 
                . &web_string("$aqt[$i] ($aqtd[$i])")
                . '&rootnode=' . $aqid[$i] . '">' 
                . $aqc[$i] . '</A>'
              : $aqc[$i];
   my $temp_cat = ($afn[$i] eq 'DEPT. HEAD REPORTING') ? 'WRHS' : $cat;
   $link_string = "<A HREF='" . $url_stem3 . "kerbname="
         . $akerb[$i] . "&category=" . $temp_cat
         . "&funcname=" . &web_string($afn[$i]) 
         . "&qualcode=" . &web_string($aqc[$i]) . "'>*</A>"; # 1/17/2001
   printf "<TR><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TD>"
        . "<TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TD>"
        . "<TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TD>"
        . "</TR>\n",
            $aname[$i], $akerb[$i], $fcolor1 . $afn[$i] . $fcolor2,
            $qcode_string, $adf[$i], $agandv[$i], $acurrent[$i],
            $link_string;
   printf "<TR><TD>%s</TD></TR>\n",
            ' ';
 }
 print "</TABLE>", "\n";
 print "<HR>", "\n";
 if ($show_all) {
   print "The report includes all authorizations, even those that are not"
         . " in effect because of the do-function flag, effective-date,"
         . " or expiration-date. ";
   print '<A HREF="' . $url_stem2 . 'show_all=0&category=' . $raw_category
          . '&func_name=' . $raw_funcname . '&skip_root=Y&qual_code='
          . $qual_code . '">'
          . 'Exclude them.</A>';
 }
 else {
   print "The report excludes authorizations that are not"
         . " in effect because of the do-function flag, effective-date,"
         . " or expiration-date. ";
   print '<A HREF="' . $url_stem2 . 'show_all=1&category=' . $raw_category
          . '&func_name=' . $raw_funcname . '&skip_root=Y&qual_code='
          . $qual_code . '">'
          . 'Include them.</A>';
 }
 
#
# Print bottom of web page
#
 print "<P>";
 print "<A HREF=\"$main_url\"><small>Back to main perMIT web interface page"
       . "</small></A>";

 print "</BODY></HTML>", "\n";

 chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
 print STDERR "***$time $remote_host $k_principal $progname Done.\n";

 exit(0);

###########################################################################
#
#  Subroutine get_auths.
#
###########################################################################
sub get_auths {
  my ($lda, $picked_cat, $func_name, $qual_code, $skip_root,
      $func_name2, $qual_code2) = @_;
  @akerb = ();
  @aname = ();
  @afn = ();
  @aqc = ();
  @adf = ();
  @agandv = ();
  @aqt = ();
  @aqtd = ();
  @aqid = ();
  @acurrent = ();
  @aname = ();

  #
  #  If $show_all == 0, then set a fragment of SQL code to exclude
  #  authorizations that are not in effect because of the do_function, 
  #  effective_date, or expiration_date.
  #
  if ($show_all) {
    $sql_fragment = '';
  }
  else {
    $sql_fragment = " and a.do_function = 'Y'"
         . " and sysdate between a.effective_date"
         . " and nvl(a.expiration_date,sysdate)";
  }

  #
  #  Case 1:  Category is 'SAP' and function_name is 'APPROVER'.
  #  Construct a special select statement that uses
  #  "function_name like '%APPROVER%'" and does cross-reference between
  #  spending groups and custom fund center groups.  Handle
  #  $skip_root by either looking for SG_ALL (mapped from FC_CUSTOM) or not.
  #
  if ($func_name eq 'APPROVER') {
    #
    # Open first cursor to get qualifier_id for a FUND.
    #
    my $edit_qual_code = $qual_code;
    $edit_qual_code =~ s/[CIPF]/F/;
    @stmt = ("select q.qualifier_id, qt.qualifier_type_desc"
             . " from qualifier q, qualifier_type qt"
             . " where q.qualifier_type = 'FUND'"
             . " and qt.qualifier_type = q.qualifier_type"
             . " and q.qualifier_code = '$edit_qual_code'");
    $csr = $lda->prepare("$stmt")
  	|| &web_error($DBI::errstr);
    $csr->execute();
    ($qqid, $qqtd) = $csr->fetchrow_array();
    $csr->finish() || &web_error("can't close cursor");
    if ($qqid eq '') {return;}
    #
    # Define the select statement for listing APPROVER authorizations.
    #
    @stmt = ("select a.kerberos_name, function_name,"
             . " a.qualifier_code, do_function, "
             . " decode(grant_and_view, 'GD', 'Y', 'N'),"
             . " AUTH_SF_IS_AUTH_CURRENT(a.effective_date, a.expiration_date),"
             . " 'SPGP', '$qqtd', a.qualifier_id,"
             . " initcap(p.last_name) || ', ' || initcap(p.first_name)"
             . " from authorization a, person p"
             . " where function_name like '%APPROVER%'"
             . " and function_category = 'SAP'"
             . " and a.kerberos_name = p.kerberos_name"
             . $sql_fragment
             . " and qualifier_code in"
             . " (select replace(qualifier_code, 'FC_', 'SG_')"
             . " from qualifier q, qualifier_descendent qd"
             . " where qd.child_id = '$qqid'"
             . " and qd.parent_id = q.qualifier_id"
             . " and substr(qualifier_code, 1, 3) = 'FC_')");
    if ($skip_root eq 'N') {
      push(@stmt, "union select a.kerberos_name, function_name,"
             . " a.qualifier_code, do_function,"
             . " decode(grant_and_view, 'GD', 'Y', 'N'),"
             . " AUTH_SF_IS_AUTH_CURRENT(a.effective_date, a.expiration_date),"
             . " 'SPGP', '$qqtd', a.qualifier_id,"
             . " initcap(p.last_name) || ', ' || initcap(p.first_name)"
             . " from authorization a, person p"
             . " where function_name like '%APPROVER%'"
             . " and function_category = 'SAP'"
             . " and a.kerberos_name = p.kerberos_name"
             . $sql_fragment
             . " and qualifier_code = 'SG_ALL'");
    }
    push(@stmt, " order by 2, 10, 3");
  }

  #
  #  Case 2:  function_name is not 'APPROVER'.  Look for exact match with
  #           function_name, and do simple search for qualifier_code and its
  #           parents.
  #
  #  Open first cursor, to get qualifier_id, function_id, and qualifier_type.
  #
  else {
    @stmt = ("select q.qualifier_id, f.function_id, f.qualifier_type,"
             . " qt.qualifier_type_desc"
             . " from qualifier q, function f, qualifier_type qt"
             . " where f.function_name = '$func_name'"
             . " and f.function_category = '$picked_cat'"
             . " and q.qualifier_type = f.qualifier_type"
             . " and q.qualifier_type = qt.qualifier_type"
             . " and q.qualifier_code = '$qual_code'");
    $csr = &ora_open($lda, "@stmt")
  	|| &web_error($ora_errstr);
    ($qqid, $ffid, $fqt, $qqtd) = &ora_fetch($csr);
    &ora_close($csr) || &web_error("can't close cursor");
    if ($qqid eq '') {return;}
    if ($qual_code2) {
      @stmt = ("select q.qualifier_id, f.function_id, f.qualifier_type,"
               . " qt.qualifier_type_desc"
               . " from qualifier q, function f, qualifier_type qt"
               . " where f.function_name = '$func_name2'"
               . " and f.function_category = '$picked_cat'"
               . " and q.qualifier_type = f.qualifier_type"
               . " and q.qualifier_type = qt.qualifier_type"
               . " and q.qualifier_code = '$qual_code2'");
      $csr = &ora_open($lda, "@stmt")
    	|| &web_error($ora_errstr);
      ($qqid2, $ffid2, $fqt2, $qqtd2) = &ora_fetch($csr);
      &ora_close($csr) || &web_error("can't close cursor");
      if ($qqid2 eq '') {$qual_code2 = '';}
    }
    $qqtd3 = 'Departments';
  
    #
    #  Open cursor for select
    #
    @stmt = ("select a.kerberos_name, function_name,"
             . " a.qualifier_code, do_function,"
             . " decode(grant_and_view, 'GD', 'Y', 'N'),"
             . " AUTH_SF_IS_AUTH_CURRENT(a.effective_date, a.expiration_date),"
             . " q.qualifier_type, '$qqtd', a.qualifier_id,"
             . " initcap(p.last_name) || ', ' || initcap(p.first_name)"
             . " from authorization a, qualifier q, person p"
             . " where function_id = '$ffid'"
             . " and a.kerberos_name = p.kerberos_name"
             . $sql_fragment
             . " and q.qualifier_id = a.qualifier_id"
             . " and a.qualifier_id = '$qqid'"
             . " union select a.kerberos_name, function_name,"
             . " a.qualifier_code, do_function,"
             . " decode(grant_and_view, 'GD', 'Y', 'N'),"
             . " AUTH_SF_IS_AUTH_CURRENT(a.effective_date, a.expiration_date),"
             . " q.qualifier_type, '$qqtd', a.qualifier_id,"
             . " initcap(p.last_name) || ', ' || initcap(p.first_name)"
             . " from authorization a, qualifier q, qualifier_descendent qd,"
             . " person p"
             . " where function_id = '$ffid'"
             . " and a.kerberos_name = p.kerberos_name"
             . $sql_fragment
             . " and q.qualifier_id = a.qualifier_id"
             . " and a.qualifier_id = qd.parent_id"
             . " and qd.child_id = '$qqid'"
             . " and descend='Y'");
    if ($skip_root eq 'Y') {
      push(@stmt, " and a.qualifier_code not in ('0HPC00_MIT','FCMIT')");
    }
    if ($qual_code2) {
      push(@stmt,
           " union"
           . " select a.kerberos_name, function_name,"
             . " a.qualifier_code, do_function,"
             . " decode(grant_and_view, 'GD', 'Y', 'N'),"
             . " AUTH_SF_IS_AUTH_CURRENT(a.effective_date, a.expiration_date),"
             . " q.qualifier_type, '$qqtd2', a.qualifier_id,"
             . " initcap(p.last_name) || ', ' || initcap(p.first_name)"
             . " from authorization a, qualifier q, person p"
             . " where function_id = '$ffid2'"
             . " and a.kerberos_name = p.kerberos_name"
             . $sql_fragment
             . " and q.qualifier_id = a.qualifier_id"
             . " and a.qualifier_id = '$qqid2'"
             . " union select a.kerberos_name, function_name,"
             . " a.qualifier_code, do_function,"
             . " decode(grant_and_view, 'GD', 'Y', 'N'),"
             . " AUTH_SF_IS_AUTH_CURRENT(a.effective_date, a.expiration_date),"
             . " q.qualifier_type, '$qqtd2', a.qualifier_id,"
             . " initcap(p.last_name) || ', ' || initcap(p.first_name)"
             . " from authorization a, qualifier q, qualifier_descendent qd,"
             . " person p"
             . " where function_id = '$ffid2'"
             . " and a.kerberos_name = p.kerberos_name"
             . $sql_fragment
             . " and q.qualifier_id = a.qualifier_id"
             . " and a.qualifier_id = qd.parent_id"
             . " and qd.child_id = '$qqid2'"
             . " and descend='Y'");
      if ($skip_root eq 'Y') {
        push(@stmt, " and a.qualifier_code != 'FCMIT'");
      }
    }  # if ($qual_code2)...
    #
    #  To see who can report on a cost object, also check 
    #  DEPT. HEAD REPORTING authorizations.  Do the following:
    #   1. See if the Admin flag for the cost object is FC.  If not, stop.
    #   2. Find the Profit Centers for all other cost objects that have
    #      the same supervisor mit_id and also have an Admin flag of FC.
    #   3. Find the D_xxxx department codes (and their ancestors) 
    #      associated with these profit centers.  (This is the subquery 
    #      below.)
    #   4. Find all DEPT. HEAD REPORTING authorizations for these
    #      D_xxxxx department codes.
    #
    #
    if ($func_name eq 'REPORT BY CO/PC') {
      #### Also check Admin flag
      my $ffid3 = 1650;  # DEPT. HEAD REPORTING
      push(@stmt,
           " union"
           . " select a.kerberos_name, function_name,"
             . " a.qualifier_code, a.do_function,"
             . " decode(a.grant_and_view, 'GD', 'Y', 'N'),"
             . " AUTH_SF_IS_AUTH_CURRENT(a.effective_date, a.expiration_date),"
             . " q.qualifier_type, '$qqtd3', a.qualifier_id,"
             . " initcap(p.last_name) || ', ' || initcap(p.first_name)"
             . " from authorization a, qualifier q, person p"
             . " where function_id = '$ffid3'"
             . " and a.kerberos_name = p.kerberos_name"
             . $sql_fragment
             . " and q.qualifier_id = a.qualifier_id"
             . " and a.qualifier_code in "
             . " (select /*+ ORDERED */ distinct q2.qualifier_code"
             . " from wh_cost_collector w1, wh_cost_collector w2,qualifier q1,"
             . " primary_auth_descendent pad, qualifier q2"
             . " where w1.cost_collector_id_with_type = '$qual_code'"
             . " and w1.admin_flag = 'FC'"
             . " and w2.supervisor_mit_id = w1.supervisor_mit_id"
             . " and w2.admin_flag = 'FC'"
             . " and q1.qualifier_type = 'COST'"
             . " and q1.qualifier_code = replace(w2.profit_center_id,'P','PC')"
             . " and pad.child_id = q1.qualifier_id"
             . " and q2.qualifier_id = pad.parent_id)"
           . " and a.qualifier_code <> 'D_ALL'");
           #print "qual_code is $qual_code<BR>";
    }
    
    #
    #  Finish select statement.
    #
    push(@stmt, " order by 10, 3");
  }

  #
  #  Get a list of authorizations
  #
  #print @stmt;
  $csr = $lda->prepare("$stmt")
	|| &web_error($DBI::errstr);  
  $csr->execute();
  while (($aakerb, $aafn, $aaqc, $aadf, $aagandv, $aacurrent, $aaqt, 
          $aaqtd, $aaqid, $aaname) 
         = $csr->fetchrow_array() )
  {
  	# mark any NULL fields found
	grep(defined || 
          ($_ = '<NULL>'),
	   $aakerb, $aafn, $aaqc, $aadf, $aagandv, $aacurrent);
        push(@akerb, $aakerb);
        push(@afn, $aafn);
        push(@aqc, $aaqc);
        push(@adf, $aadf);
        push(@agandv, $aagandv);
        push(@aqt, $aaqt);
        push(@aqtd, $aaqtd);
        push(@aqid, $aaqid);
        push(@acurrent, $aacurrent);
        push(@aname, $aaname);
        #print "$aakerb, $aafn, $aaqc, $aadf, $aagandv, $aacurrent \n";
  }
  $csr->finish() || &web_error("can't close cursor");

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
    $astring;
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
  exit(0);
}

