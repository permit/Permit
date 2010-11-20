#!/usr/bin/perl
###########################################################################
#
#  CGI script for one-step lookup of people authorized to do
#  (1) requisition creation, (2) credit card approval, (3) approval of
#  requisitions, (4) invoice approval, or (5) travel documents approval.
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
#  Jim Repa 4/02/1999
#  Modified 4/12/1999 (accommodate P or W as WBS prefix)
#  Modified 4/21/1999 Use local table wh_cost_collector
#  Modified 7/21/1999 Add a link to "Tell me about a cost object"
#  Modified 8/17/1999 Add address of supervisor, addressee
#  Modified 10/13/1999 Fix mispelling of 'CRED' key word
#  Modified 5/24/2001 Show department and ability to find Primary Auth.
#  Modified 12/4/2002 Change spelling of Authorizer.
#
###########################################################################
#
# Get packages
#
 use rolesweb('login_sql');   #Use sub. login_sql in rolesweb.pm
 use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
 use rolesweb('parse_ssl_info'); #Use sub. parse_ssl_info in rolesweb.pm
 use rolesweb('check_cert_source'); #Use sub. check_cert_source in rolesweb.pm
 use rolesweb('verify_metaauth_category'); #Use sub. verify_metaauth_category
 use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm

#
#  Web documents definitions
#
 $host = $ENV{'HTTP_HOST'};
 $url_stem = "http://$host/cgi-bin/rolequal1.pl?";
 $url_stem2 = "http://$host/cgi-bin/rolecc_info.pl?cost_object=";
 $url_stem3 = "https://$host/cgi-bin/find_dept_pa.pl?qualtype=FUND&qualcode=";
 $main_url = "http://$host/webroles.html";

#
#  HTML files read by this program to build output
#
 $doc_fragment_file = "../htdocs/doc_fragment.html";
 $html_file = "../htdocs/req_auth.html";

#
#  More constants
#
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 $cat = 'SAP';  # Category for which to check meta-authorization

#
#  Print out top of the http document.  
#
 print "Content-type: text/html", "\n\n";
 print "<HTML>", "\n";
 print "<HEAD><TITLE>One-step authorization lookup</TITLE></HEAD>", "\n";
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
#  Get cost object
#
 $cost_object = $formval{'cost_object'};  # Get value set in &parse_forms()
 $cost_object = &strip($cost_object);
 $cost_object =~ tr/a-z/A-Z/; # Upper case
 $co_prefix = substr($cost_object, 0, 1);  # Get leading C, I, P, W, or F
 if ($co_prefix =~ /^[CIPW]$/) {;} else {$co_prefix = ''};
 $cost_object =~ s/^[CIPWF]//;  # Strip off leading C, I, P, W, or F
 #$cost_object = '1357300';

#
#  Get abbreviated function name.  Look for hide_cc_info and rel_strategy
#  fields.  Get other fields.
#
 $func_code = $formval{'func_code'};
 $func_code =~ tr/a-z/A-Z/;  # Raise to upper-case
 #$func_desc = $function_description{$func_code};
 $hide_cc_info = $formval{'hide_cc_info'};
 $hide_cc_info =~ tr/a-z/A-Z/;  # Raise to upper case
 $rel_strategy = $formval{'rel_strategy'};

#
#  Parse certificate information
#
 $info = $ENV{"SSL_CLIENT_DN"};  # Get certificate information
 %ssl_info = &parse_ssl_info($info);  # Parse certificate into a Perl "hash"
 $email = $ssl_info{'Email'};    # Get Email address from cert. 'Email' field
 $full_name = $ssl_info{'CN'};   # Get full name from cert. 'CN' field
 ($k_principal, $domain) = split("\@", $email);
 if (!$k_principal) {
     print "<br><b>No certificate sent.  Use https:// , not http://</b>\n";
     exit();
 }
 $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase

#
#  Log something
#
 $remote_host = $ENV{'REMOTE_HOST'};
 chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
 #print STDERR "***$time $remote_host $k_principal $progname $input_string\n";

#
#  Check the other fields in the certificate
#
 $result = &check_cert_source(\%ssl_info);
 if ($result ne 'OK') {
     print "<br><b>Your certificate cannot be accepted: $result";
     exit();
 }

#
#  Make sure we are set up to use Oraperl.
#
use Oraperl;
if (!(defined(&ora_login))) {&web_error("Oraperl not found by Web server\n");}

#
#  Open connection to oracle
#
my $lda = &login_sql('roles') 
      || &web_error("Oracle error in login. "
          . "The database may be shut down temporarily for backups." 
          . "<BR><BR>" . $ora_errstr);

#
# Make sure the user has a meta-authorization to view $cat4 authorizations.
#
 if (!(&verify_metaauth_category($lda, $k_principal, $cat))) {
   print "Sorry.  You do not have the required Roles DB 'meta-authorization'",
   " to view other people's $cat authorizations.";
   exit();
 }

#
#  If we don't know the release strategy from the parameters, or if
#  we are not suppressing cost object info, then
#  get cost object info from cost_collector_fund table.
#
 if ($hide_cc_info ne 'Y' || (!$rel_strategy)) {
   ($qcode, $qtype, $qname, $org_id, $org_name, $cc_closed,
    $pc_code, $pc_name, $fund_code, $fc_code, $resp_person,
    $pr_begin_date, $pr_end_date, $cc_begin_date, $cc_end_date, 
    $cc_term_code, $days_before_expire, 
    $cc_supervisor_room, $cc_addressee, $cc_addressee_room,
    $has_child_id, $rel_strategy)
     = &get_cc_info($lda, $cost_object, $co_prefix);
   $pc_code =~ s/P/PC/;
   #$qtype =~ s/Project/WBS (project)/;
   $begin_date = &max($pr_begin_date, $cc_begin_date, " ");
   $end_date = &max($pr_end_date, $cc_end_date, " ");
 }
 else {
   $qcode = 'F' . $cost_object;
   $fund_code = $cost_object;
 }

#
#  Did we find anything?
#
 if (length($qcode) < 2) {
   $co_prefix =~ s/^F//; # Show prefixes CIPW, but not F
   &web_error("Cost object '$co_prefix$cost_object' not found.");
  }

#
#  Get department code
#
 #$dept_code = &get_department($lda, $qcode);
 $url_for_pa = 
        '<A HREF="' . $url_stem3 . "F$fund_code" . '">'
        . '<small><i>Find the departmental Primary Authorizers'
        . " related to F$fund_code</i></small></A>";

#
#  If this is a WBS ([PW]nnnnnnn), then find out if it has children.
#  If so, allow user to display children.
#  No matter what, add * link to "Tell me about a cost object"
#
 $qcode_string = $qcode;
 if ($has_child_id) {
   $qcode_string = 
        '<A HREF="' . $url_stem . 'qualtype=COST+%28Cost+Object%29'
        . '&rootnode=' . $has_child_id . '">' 
        . "$qcode" 
        . '</A>';
 }
 $qcode_string .= ' <A HREF="' . $url_stem2 . $qcode . '">*</A>'; 

#
#  Get descriptions from doc_fragment.html.
#
 ($func_desc, $long_desc) = 
   &get_doc_fragments($doc_fragment_file, $func_code, $rel_strategy, 
   \%term_code_desc);
 substr($func_desc, 0, 1) =~ tr/A-Z/a-z/; # De-capitalize
 if (!$func_desc) {
   $func_desc = $func_code;
 } 
 if (!$long_desc) {
    $long_desc = "Unknown abbreviated function code '$func_code'";
 }


#
#  Build the header based on the business function and cost object
#
 
 &print_header("Who can do $func_desc for cost object $cost_object\?", 
               'https');

#
#  Print out information about the cost object
#
 unless ($hide_cc_info eq 'Y') {
   print "<HR>", "\n";
   print "<h4>Information about $qtype $qcode_string</h4>\n";
   $data_fmt = "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
          . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
   print "<TABLE>", "\n";
   printf $data_fmt,
          'Name:', $qname, '';
   printf $data_fmt,
          'Supervisor:', 
          "$resp_person &nbsp;&nbsp;<small>$cc_supervisor_room</small>", 
          '';
   printf $data_fmt,
          'Addressee:', 
          "$cc_addressee &nbsp;&nbsp;<small>$cc_addressee_room</small>", 
          '';
   #printf $data_fmt,
   #       'Dept. code:', $dept_code, '';
   printf $data_fmt,
          'Release strategy:', $rel_strategy, '';
   if ($days_before_expire < 0) {
     $fcolor1 = '<FONT COLOR=RED>';  $fcolor2 = '</FONT>';
   }
   else {$fcolor1 = $fcolor2 = '';}
   printf $data_fmt,
    'Start/end date:', $begin_date . ' - ' . $fcolor1 . $end_date . $fcolor2, 
    '';
   if ($cc_term_code ne '(none)') {
       $term_code_desc{$cc_term_code} = "($term_code_desc{$cc_term_code})";
     $fcolor1 = '<FONT COLOR=RED>';  $fcolor2 = '</FONT>';
   }
   else {$fcolor1 = $fcolor2 = '';}
   printf $data_fmt,
          'Term. code:', $fcolor1 
          . "$cc_term_code $term_code_desc{$cc_term_code}$fcolor2", '';
   print "</TABLE>", "\n";
 }

#
#  Allow the user to find the Department and its Primary Authorizers
#
 print $url_for_pa . "<BR>";

#
#  Print out explanatory information about authorizations for the
#  given function and cost object
#
 print "<HR>", "\n";
 substr($func_desc, 0, 1) =~ tr/a-z/A-Z/;
 print "<h4>$func_desc for fund F$fund_code (related authorizations)</h4>";
 #&print_auth_header($func_code, $rel_strategy, $cost_object);
 print $long_desc . '<BR>';
 #print "<P>";

#
#  Call subroutine &print_auths to print out the related authorizations
#
 print "<P>";
 &print_auths($lda, 'SAP', $func_code, $fund_code, $rel_strategy);

#
#  Call subroutine &print_request_form to print out a form to do another
#  lookup.
#
 print "<HR>";
 if ($hide_cc_info ne 'Y') {
   &print_request_form($html_file, $cost_object, $func_code);
 }
 print "<A HREF=\"$main_url\">"
  . "<small>Back to main Roles web interface page</small></A>";
 print "</BODY></HTML>", "\n";

 chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
 #print STDERR "***$time $remote_host $k_principal $progname Done.\n";

 exit(0);

###########################################################################
#
#  Subroutine get_cc_info
#  Gets detailed information on a cost collector from the local table
#  wh_cost_collector (extracted daily from warehouse cost_collector table).
#
###########################################################################
sub get_cc_info {
  my ($lda, $cc_number) = @_;

  #
  #  Do query against the Warehouse table
  #
  my @stmt = ("select w.cost_collector_id_with_type,"
           . " w.cost_collector_type_desc,"
           . " w.cost_collector_name, w.organization_id, w.organization_name,"
           . " w.is_closed_cost_collector,"            
           . " w.profit_center_id, w.profit_center_name,"            
           . " w.fund_id, w.fund_center_id, w.supervisor,"
           . " to_char(w.cost_collector_effective_date,'MM/DD/YYYY'),"
           . " to_char(w.cost_collector_expiration_date,'MM/DD/YYYY'),"
           . " to_char(w.cost_collector_effective_date,'MM/DD/YYYY'),"
           . " to_char(w.cost_collector_expiration_date,'MM/DD/YYYY'),"
           . " nvl(w.term_code, '(none)'),"
           . " w.cost_collector_expiration_date - round(sysdate),"
           . " w.supervisor_room, w.addressee, w.addressee_room,"
           . " decode(w.release_strategy, '1', 'Model 1', '2', 'Model 2',"
           . " '3', 'Model 3', '4', 'Model 4', '5', 'Bates Model',"
           . " 'A', 'Sloan Model', 'Unknown')"
           . " from wh_cost_collector w"
           . " where w.cost_collector_id  = '$cc_number' and"
           . " substr(w.cost_collector_id_with_type,1,1) like '$co_prefix%'"
           . " order by w.cost_collector_expiration_date desc");
  my $csr = &ora_open($lda, "@stmt")
	|| &web_error("Oracle error in open. "
           . "The database may be temporarily shut down for backups."
           . "<BR><BR>" . $ora_errstr);
  my @ora_results = &ora_fetch($csr);
  &ora_close($csr) || &web_error("Oracle error. can't close cursor");

  #
  #  Pop the last element (release_strategy) off the array.
  #
  my $rel_strat = pop(@ora_results);

  #
  #  If this is a WBS (Pnnnnnnn), then find out if it has children. 
  #
   $has_child_id = 0;
   if ($ora_results[1] eq 'Project WBS') {
     $has_child_id = &get_has_child_id($lda, 'P' . $cc_number);
   }
   push(@ora_results, $has_child_id);

  #
  #  Push the release strategy back onto the end of the array
  #
   #my $rel_stat = &get_release_strategy($lda, 'FC' . $ora_results[9]);
   push(@ora_results, $rel_strat); 

  #
  #  Return the values.
  #
  
  return @ora_results;
}

###########################################################################
#
#  Subroutine get_has_child_id
#  Looks up the qualifier in the qualifier table to see if it has children.
#  If it does, returns the qualifier_id.  Otherwise, returns 0.
#
###########################################################################
sub get_has_child_id {
  my ($lda, $qcode) = @_;

  #
  #  Do query against the qualifier table
  #
  my @stmt = ("select qualifier_id, has_child from qualifier"
           . " where qualifier_code = '$qcode'"
           . " and qualifier_type = 'COST'");
  my $csr = &ora_open($lda, "@stmt")
	|| &web_error("Oracle error in open. "
           . "Problem with select from qualifier table."
           . "<BR><BR>" . $ora_errstr);
  my ($qid, $hc) = &ora_fetch($csr);
  &ora_close($csr) || &web_error("Oracle error. can't close cursor");

  #
  #  Return the values.
  #
  
  if ($hc eq 'Y') {return $qid;}
  else {return 0;};
}

###########################################################################
#
#  Subroutine get_department
#  Does a join between qualifier table and primary_auth_descendent table
#  to find the department associated with the fund.
#
###########################################################################
sub get_department {
  my ($lda, $qcode) = @_;

  #
  #  Do query against the qualifier table
  #
  $qcode = 'F' . substr($qcode, 1);
  my @stmt = ("select q2.qualifier_code"
   . " from qualifier q1, primary_auth_descendent pad, qualifier q2"
   . " where q1.qualifier_type = 'FUND'"
   . " and q1.qualifier_code = '$qcode'"
   . " and pad.child_id = q1.qualifier_id"
   . " and pad.is_dlc = 'Y'"
   . " and q2.qualifier_id = pad.parent_id");
  my $csr = &ora_open($lda, "@stmt")
	|| &web_error("Oracle error in open. "
           . "Problem with select from qualifier table."
           . "<BR><BR>" . $ora_errstr);
  my ($dept_code) = &ora_fetch($csr);
  &ora_close($csr) || &web_error("Oracle error. can't close cursor");

  #
  #  Return the values.
  #
  
  return ($dept_code);
}

###########################################################################
#
#  Subroutine print_auths.
#
###########################################################################
sub print_auths {
  my ($lda, $picked_cat, $func_code, $qual_code, $model) = @_;
  my (@stmt, $csr, $qqid);

  #
  #  We'll first find the qualifier_id
  #  in the qualifier table of the FUND we're looking up.
  #
  my $edit_qual_code = $qual_code;
  $edit_qual_code =~ s/[CIPWF]/F/;
  @stmt = ("select q.qualifier_id"
           . " from qualifier q"
           . " where q.qualifier_type = 'FUND'"
           . " and q.qualifier_code = 'F$edit_qual_code'");
  $csr = &ora_open($lda, "@stmt")
	|| &web_error($ora_errstr);
  ($qqid) = &ora_fetch($csr);
  &ora_close($csr) || &web_error("can't close cursor");
  if ($qqid eq '') {
     &web_error("Fund F$edit_qual_code not found.");
  }

  #
  #  Start with a sql fragment that includes only current and active
  #  authorizations.
  # 
  my $sql_fragment = " and a.do_function = 'Y'"
       . " and sysdate between a.effective_date"
       . " and nvl(a.expiration_date,sysdate)";
  
  #
  #  If func_code is REQ or CREDIT, then add a clause to include only
  #  authorizations for people who have a REQUISITIONER
  #  or CREDIT CARD VERIFIER function, respectively
  #
  if ($func_code eq 'REQ' || $func_code eq 'CRED'
      || ($func_code eq 'APPROVER' && $model eq 'Model 1') ) {
    my $func2 = ($func_code eq 'CRED') ? 'CREDIT CARD VERIFIER'
                                         : 'REQUISITIONER';
    my $sql_fragment2 = $sql_fragment;  # Grab old sql fragment
    $sql_fragment2 =~ s/a\./aa\./g;     # Change for authorization aa
    $sql_fragment .= " and a.kerberos_name in (select aa.kerberos_name"
      . " from authorization aa where aa.function_name = '$func2'"
      . " $sql_fragment2)";
  }

  #
  #  If the function code is 'APPROVER' with a release strategy other than
  #  Model 1, then call another subroutine to set up the sql statement.  
  #  Otherwise, it's simple;  set it up right here.
  #
  if ($func_code eq 'APPROVER' && $model ne 'Model 1') {
    @stmt = &get_approver_select($model, $qqid, $sql_fragment);    
  }
  else {
    if ($func_code eq 'INVOICE') {$ffname = 'INVOICE APPROVAL UNLIMITED';}
    elsif ($func_code eq 'TRAVEL') {$ffname = 'TRAVEL DOCUMENTS APPROVAL';}
    else {$ffname = 'CAN SPEND OR COMMIT FUNDS';}
    @stmt = ("select a.kerberos_name, a.function_name,"
             . " a.qualifier_code,"
             . " initcap(p.last_name) || ', ' || initcap(p.first_name),"
             . " 'A' srt"
             . " from authorization a, person p"
             . " where function_name = '$ffname'"
             . " and a.kerberos_name = p.kerberos_name"
             . $sql_fragment
             . " and a.qualifier_id = '$qqid'"
             . " union select a.kerberos_name, a.function_name,"
             . " a.qualifier_code,"
             . " initcap(p.last_name) || ', ' || initcap(p.first_name),"
             . " 'A' srt"
             . " from authorization a, qualifier_descendent qd,"
             . " person p"
             . " where function_name = '$ffname'"
             . " and a.kerberos_name = p.kerberos_name"
             . $sql_fragment
             . " and a.qualifier_id = qd.parent_id"
             . " and qd.child_id = '$qqid'"
             . " and a.descend='Y'"
             . " order by 2, 4, 1, 3");
  }

  #
  #  Start printing the table for the resulting authorizations
  #
  print "<TABLE>", "\n";
  printf "<TR><TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH>"
         . "<TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH></TR>\n",
         'Last, First<BR>Name', 'Kerberos<BR>Username', 'Function Name', 
         'Qualifier<BR>Code';

  #
  #  Print a list of authorizations
  #
  #print @stmt;
  $csr = &ora_open($lda, "@stmt")
	|| &web_error($ora_errstr);
  my $prev_fn = '';
  while (($aakerb, $aafn, $aaqc, $aaname, $aasort) = &ora_fetch($csr))
  {
    if (($prev_fn) && ($aafn ne $prev_fn)) {
      # Mark different APPROVER function
      print "<TR><TD></TD><TD ALIGN=CENTER>* * *</TD></TR>\n";
    }
    printf "<TR><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT><small>%s</small></TD>"
        . "<TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT><small>%s</small></TD></TR>\n",
             $aaname, $aakerb, $aafn, $aaqc;
    printf "<TR><TD>%s</TD></TR>\n",
            ' ';
    $prev_fn = $aafn;
  }
  print "</TABLE>", "\n";
  &ora_close($csr) || &web_error("can't close cursor");

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
#  Function &get_approver_select($model, $qqid, $sql_fragment)
#  Returns a select statement to return authorizations related to 
#  requisition approvals for the given cost object number and release
#  strategy.
#
###########################################################################
sub get_approver_select {
  my ($model, $qqid, $sql_fragment) = @_; # Get parameters
  my @stmt;
  
  #
  #  Set up a fragment of the function name for a "like" clause in
  #  the select statement.
  #
  my $fnpart = '';  # Part of function name to search for
  for ($model) {
    if (/^Model 2$/) {$fnpart = 'APPROVER MOD 2 LEV%'; last;}
    if (/^Model 3$/) {$fnpart = 'APPROVER MOD 3 LEV%'; last;}
    if (/^Model 4$/) {$fnpart = 'APPROVER MOD 4 LEV%'; last;}
    if (/^Bates Model$/) {$fnpart = 'BATES APPROVER LEV%'; last;}
    if (/^Sloan Model$/) {$fnpart = 'SLOAN LEV _ APPROVER'; last;}
    &web_error("Release strategy '$model' -- cannot find approvers.");
  }

  #
  #  Start building the select statement
  #
  @stmt = ("select a.kerberos_name, a.function_name,"
           . " a.qualifier_code,"
           . " initcap(p.last_name) || ', ' || initcap(p.first_name)," 
           . " 'B' srt"
           . " from authorization a, person p"
           . " where function_name like '$fnpart'"
           . " and function_category = 'SAP'"
           . " and a.kerberos_name = p.kerberos_name"
           . $sql_fragment
           . " and qualifier_code in"
           . " (select replace(qualifier_code, 'FC_', 'SG_')"
           . " from qualifier q, qualifier_descendent qd"
           . " where qd.child_id = '$qqid'"
           . " and qd.parent_id = q.qualifier_id"
           . " and substr(qualifier_code, 1, 3) = 'FC_')");

  #
  #  If this is a Model 3 release strategy, then also look for
  #  CAN SPEND OR COMMIT FUNDS authorizations (where user also has
  #  a REQUISITIONER authorization).
  #
  if ($model eq 'Model 3') {
     ## Look for CAN SPEND OR COMMIT FUNDS + REQUISITIONER authorizations
    my $ffname = 'CAN SPEND OR COMMIT FUNDS';
    my $func2 = 'REQUISITIONER';
    my $sql_fragment2 = $sql_fragment;  # Grab old sql fragment
    $sql_fragment2 =~ s/a\./aa\./g;     # Change for authorization aa
    $sql_fragment .= " and a.kerberos_name in (select aa.kerberos_name"
      . " from authorization aa where aa.function_name = '$func2'"
      . " $sql_fragment2)";
    push(@stmt, " union select a.kerberos_name, a.function_name,"
             . " a.qualifier_code,"
             . " initcap(p.last_name) || ', ' || initcap(p.first_name)," 
             . " 'A' srt"
             . " from authorization a, person p"
             . " where function_name = '$ffname'"
             . " and a.kerberos_name = p.kerberos_name"
             . $sql_fragment
             . " and a.qualifier_id = '$qqid'"
             . " union select a.kerberos_name, a.function_name,"
             . " a.qualifier_code,"
             . " initcap(p.last_name) || ', ' || initcap(p.first_name)," 
             . " 'A'"
             . " from authorization a, qualifier_descendent qd,"
             . " person p"
             . " where function_name = '$ffname'"
             . " and a.kerberos_name = p.kerberos_name"
             . $sql_fragment
             . " and a.qualifier_id = qd.parent_id"
             . " and qd.child_id = '$qqid'"
             . " and a.descend='Y'");
  }

  #
  #  Add "order by" clause.
  #
  push(@stmt, " order by 5, 2, 4, 1, 3");

  #print @stmt;
  #print "<BR>";

  return @stmt;
}

##############################################################################
#
# Function get_doc_fragments
#    ($doc_fragment_file, $func_code, $rel_strategy, \%term_code_desc);
#
# Looks in a specially-formatted html file for documentation fragments.
#
# Returns ($short_desc, $long_desc), 
# short and long descriptions associated
# with the $func_code and $rel_strategy, plus fills in the hash 
# %term_code_desc with descriptions for all the termination codes.
#
##############################################################################
sub get_doc_fragments {
  my ($infile, $func_code, $rel_strategy, $rterm_code_desc) = @_;
  my ($short_desc, $long_desc, @doc_file, $line);
  %$rterm_code_desc = ();  # Initialize hash of term codes
  
  unless (open(DOCFRAG,$infile)) {  # Open the config file
    print "<br><b>Cannot open the documentation fragment file.<BR>\n"
        . "Filename: $infile<br>\n";
    return ('', '');
  }
 
  @doc_file = <DOCFRAG>;
  close(DOCFRAG);


  # 
  #  To get the short description and long description (for all cases
  #  other than APPROVER), first, extract the string between
  #  <!docfrag $func_code:$rel_strategy> and </!docfrag>.
  #  Put that into $desc_string.  Then extract $short_desc from between
  #  <h4> and </h4>, and put the rest into $long_desc.
  #
  my $whole_file = join('', @doc_file);
  $whole_file =~ /<!docfrag $func_code:\*>(.*?)<\/!docfrag>/s;
  my $desc_string = $1;
  #print "desc_string='$desc_string'\n";
  $desc_string =~ /<h4>(.*)<\/h4>(.*)/s;
  $short_desc = $1;
  $long_desc = $2;

  #
  #  If we're looking for APPROVER descriptions, then look for the string
  #  between <!docfrag $func_code:$rel_strategy> and </!docfrag>.
  #  Take $long_desc as the part after </h4>.
  #
  #print "func_code is '$func_code' rel_strategy is '$rel_strategy'\n";
  if ($func_code eq 'APPROVER') {
    $whole_file 
        =~ /<!docfrag $func_code:$rel_strategy>(.*?)<\/!docfrag>/s;
    my $temp_string = $1;
    #print "temp_string='$desc_string'\n";
    $temp_string =~ /<\/h4>(.*)/s;
    $long_desc = $1;
  }

  #
  #  The doc_fragment.html document refers to something being
  #  "on the one-step lookup web page."  Simplify that to "below."
  #
  $long_desc =~ s/on the one-step lookup web page/below/;    

  #
  #  Finally, get the termination code descriptions.
  #  Get the part of the file starting with the first occurence 
  #  of '<!docfrag termcode:'.
  #  Then split it into pieces delimited by '<!docfrag term-code:'.
  #  Then, take the part before '>' as the model name, and the part after
  #   '>' and before '</!docfrag>' as the model description.  Set
  #   %term_code_desc{$model_name} = $model_desc;
  #
  $whole_file =~ /(<!docfrag term-code:.*)/s;
  $desc_string = $1;
  #print "****desc_string='$desc_string'\n";
  my @temp_array = split('<!docfrag term-code:', $desc_string);
  my ($model_name, $model_desc);
  foreach $line (@temp_array) {
    #print "****line='$line'\n";
    $line =~ /(.*?)>(.*)<\/!docfrag>/s;
    $model_name = $1;
    $model_desc = $2;
    $model_desc =~ s/\n//g;
    #print "*** model_name '$model_name' -> '$model_desc'\n";
    if ($model_desc) {
      $$rterm_code_desc{$model_name} = $model_desc;
    }
  }

  return ($short_desc, $long_desc);  # Return short and long func desc.
}

##############################################################################
#
# Subroutine print_request_form ($html_file, $cost_object)
#
# Gives user the chance to do another lookup.  Displays the part of the
# $html_file following the first occurence of <HR>.
#
##############################################################################
sub print_request_form {
  my ($infile, $cost_object, $func_code) = @_;
  my (@doc_file, $line);
  
  unless (open(HTDOC,$infile)) {  # Open the config file
    print "<br><b>Cannot open the documentation fragment file.<BR>\n"
        . "Filename: $infile<br>\n";
    return ('', '');
  }
 
  @doc_file = <HTDOC>;
  close(HTDOC);

  # 
  #  Turn the array into a single string.
  #  (Don't Insert the $cost_object into the input text string.)
  #  Mark the previously checked radio button as checked here.
  #  Find the part of the string following the first <HR>.
  #  Print it.
  #
  my $whole_file = join('', @doc_file);
  #$whole_file =~ s/NAME=cost_object>/NAME=cost_object VALUE="$cost_object">/s;
  $whole_file =~ s/ CHECKED>/>/s;
  $whole_file =~ s/VALUE="$func_code">/VALUE="$func_code" CHECKED>/s;
  $whole_file =~ /<HR>(.*?)$/s;
  print "<h4>Do another authorization lookup</h4>";
  print $1;
}

###########################################################################
#
#  Function &max(...)
#  Returns the maximum element from the argument list
###########################################################################
sub max {
  my $a;
  my $biggest = "";
  
  foreach $a (@_) {
    if ($a > $biggest) { $biggest = $a; }
  }
 
  $biggest;
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


