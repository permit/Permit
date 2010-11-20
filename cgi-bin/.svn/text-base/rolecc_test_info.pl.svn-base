#!/usr/bin/perl
###########################################################################
#
#  CGI script to get information on a cost collector
#
#
#  Copyright (C) 1998-2010 Massachusetts Institute of Technology
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
#  Modified 4/13/1998, 10/6/1998, 10/13/1998, 2/2/1999, 3/24/1999
#  Modified 4/20/1999 to use new local table wh_cost_collector
#  Modified 7/29/1999 to handle < in qualifier name
#  Modified 8/17/1999 to add supervisor room and addressee information
#  Modified 5/15/2000 to add a link to the Warehouse cost object info page
#  Modified 3/07/2001 use rolequal.pl instead of roleparent.pl.
#  Modified 6/19/2001 add a link to show Primary Authorizer(s)
#  Modified 7/9/2001  show company code and admin flag
#  Modified 10/16/2002 update warehouse-www link
#  Modified 12/4/2002 change spelling of Authorizer
#  Modified 09/25/2003 update warehouse-web link
#  Modified 02/24/2005 report "bad master data" when no Fund found.
#  Modified 12/16/2005 update explanation for term code 2.
#
###########################################################################
#
# Get packages
#
use rolesweb('login_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('login_dbi_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm

#
#  Web stem constants
#
 $host = $ENV{'HTTP_HOST'};
 $url_stem = "http://$host/cgi-bin/qualauth.pl?";
 $url_stem2 = $url_stem;
 $url_stem3 = "https://$host/cgi-bin/roleauth2.pl?";
 $url_stem4 = "https://$host/cgi-bin/req_auth.pl?";
 $url_stem5 = 
  "https://warehouse-web.mit.edu/cgi-bin/cost_collector_lookup.cgi";
 $url_stem6 = "https://$host/cgi-bin/find_dept_pa.pl?";
 $metaauth_url = "http://$host/metaauth_help.html#viewing+authorizations";
 $main_url = "http://$host/webroles.html";

#
#  Print out top of the http document.  
#
 print "Content-type: text/html", "\n\n";
 print "<HTML>", "\n";
 print "<HEAD><TITLE>perMIT DB Info on Cost Object</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 #print "<BODY><H1>perMIT DB Info on Cost Object</H1>", "\n";
 &print_header("perMIT DB Info on Cost Object", 'http');
 print "<HR>", "\n";

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
$co_prefix = substr($cost_object, 0, 1);  # Get leading C, I, P, or F
if ($co_prefix =~ /^[CIP]$/) {;} else {$co_prefix = ''};
$cost_object =~ s/^[CIPF]//;  # Strip off leading C, I, or P, or F
$cost_object = '1357300';

#
#  Set termination code explanations
#
%term_code_desc = (
  '1' => '(Closed. Pre-end date charges allowed)',
  '2' => '(Open. Charges not allowed)',
  '3' => '(Terminated. Charges not allowed)',
  '4' => '(Invalid cost object [without charges])',
  '5' => '(Invalid cost object [with charges])');

#
#  Make sure we are set up to use Oraperl.
#

#
#  Open connection to oracle
#
my $lda = login_dbi_sql('roles') 
      || &web_error("Wrror in login. "
          . "The database may be shut down temporarily for backups." 
          . "<BR><BR>" . $DBI::errstr);

#
#  Get cost object info from cost_collector_fund table.
#
 ($qcode, $qtype, $qname, $org_id, $org_name, $cc_closed,
  $pc_code, $pc_name, $fund_code, $fc_code, $resp_person,
  $pr_begin_date, $pr_end_date, $cc_begin_date, $cc_end_date, 
  $cc_term_code, $days_before_expire,
  $cc_supervisor_room, $cc_addressee, $cc_addressee_room,
  $cc_company_code, $cc_admin_flag, $has_child_id, $rel_strategy)
   = &get_cc_info($lda, $cost_object);
 $pc_code =~ s/P/PC/;
 $begin_date = &max($pr_begin_date, $cc_begin_date, " ");
 $end_date = &max($pr_end_date, $cc_end_date, " ");
 $start_end = "$begin_date - $end_date";
 $qname =~ s/</&lt;/g;  # Handle < in qualifier name
 $fund_code =~ s/       /_undefined/;

#
#  Did we find anything?
#
 if (length($qcode) < 2) {
   &web_error("Cost object '$cost_object' not found.");
  }

#
#  If this is a WBS (Pnnnnnnn), then find out if it has children.
#
 $qcode_string = $qcode;
 if ($has_child_id) {
   $qcode_string = 
        '<A HREF="' . $url_stem . 'qualtype=COST+%28Cost+Object%29'
        . '&rootnode=' . $has_child_id . '">' 
        . "$qcode" 
        . '</A>';
 }

#
#  Set some webby stuff
#
 $cost_parent_string = 
        '<A HREF="' . $url_stem2 . 'qualtype=COST+%28Cost+Object%29'
        . '&childqc=' . $qcode . '">' 
        . "(Show position in Prof. Center/Cost hierarchy)" 
        . '</A>';
 $dept_pa_string = 
        '<A HREF="' . $url_stem6 . "qualtype=FUND&qualcode=F$fund_code"
        . '">' 
        . "(Show department and Primary Authorizers)" 
        . '</A>';
 $fund_parent_string = 
        '<A HREF="' . $url_stem2 . "qualtype=FUND+%28Fund%29"
        . '&childqc=F' . $fund_code . '">' 
        . "(Show position in Fund Center/Fund hierarchy)" 
        . '</A>';
 $who_auth_spend_url = 
        '<A HREF="' . $url_stem3 . "category=SAP+SAP-related"
        . '&func_name=CAN+SPEND+OR+COMMIT+FUNDS&qual_code=F' . $fund_code 
        . '&skip_root=Y">' 
        . "spend or commit" 
        . '</A>';
 $warehouse_info_url = 
  '<A HREF="' . $url_stem5 . '?'
  . 'ccid=' . $cost_object . '">'
  . "(See more info. on $qcode from Warehouse)</A>";

 $who_auth_rpt_url = 
        '<A HREF="' . $url_stem3 . "category=SAP+SAP-related"
        . '&func_name=REPORT+BY+CO/PC&skip_root=Y&qual_code=' . $qcode 
        . '">' 
        . "report" 
        . '</A>';
 $who_auth_appr_url = 
        '<A HREF="' . $url_stem4 . "category=SAP+SAP-related"
        . '&func_code=APPROVER&cost_object=' . $fund_code 
        . '&hide_cc_info=Y&rel_strategy=' . &web_string($rel_strategy)
        . '">' 
        . "approve" 
        . '</A>';
 $who_auth_inv_url = 
        '<A HREF="' . $url_stem3 . "category=SAP+SAP-related"
        . '&func_name=INVOICE+APPROVAL+UNLIMITED&skip_root=Y&qual_code=F' 
        . $fund_code . '">' 
        . "invoice" 
        . '</A>';
 $who_auth_trav_url = 
        '<A HREF="' . $url_stem3 . "category=SAP+SAP-related"
        . '&func_name=TRAVEL+DOCUMENTS+APPROVAL&skip_root=Y&qual_code=F' 
        . $fund_code . '">' 
        . "travel-approve" 
        . '</A>';

#
#  Print out the rest of the http document.  
#
 $header_fmt = "<TR><TH ALIGN=LEFT>%25s</TH><TH ALIGN=LEFT>%-30s</TH>"
    . "<TD ALIGN=LEFT>%-15s</TD>\n";
 $data_fmt = "<TR><TD ALIGN=RIGHT><small>%25s&nbsp&nbsp</small></TD>"
        . "<TD ALIGN=LEFT>%-30s</TD><TD ALIGN=LEFT>%-15s</TD>\n",
 print "<TABLE>", "\n";

 printf $header_fmt,
        'Cost object', '', '';
 printf $data_fmt,
        'Code:', "$qcode_string <small>($qtype)</small>", $cost_parent_string;
 printf $data_fmt,
        'Name:', $qname, '';
 printf $data_fmt,
        'Supervisor:', 
        "$resp_person &nbsp;<small>$cc_supervisor_room</small>", '';
 printf $data_fmt,
        'Addressee:', 
        "$cc_addressee &nbsp;<small>$cc_addressee_room</small>", '';
 #printf "<TR><TD>  </TD></TR>\n";
 #printf "<TR><TD>  </TD></TR>\n";

 printf $header_fmt,
        'Profit Center', '', '';
 printf $data_fmt,
        'Code:', $pc_code, '';
 printf $data_fmt,
        'Name:', $pc_name, '';
 #printf "<TR><TD>  </TD></TR>\n";
 #printf "<TR><TD>  </TD></TR>\n";

 printf $header_fmt,
        'Fund', '', '';

 my $temp_fund = "F$fund_code";
 if ($fund_code eq '_undefined') {
     $temp_fund = '<font color=red>(Undefined - bad master data)</font>';
     $fund_parent_string = '&nbsp;';
 } 
 printf $data_fmt,
        'Fund:', "$temp_fund", $fund_parent_string;
 printf $data_fmt,
        'Fund Center:', "FC$fc_code", '';
 #printf "<TR><TD>  </TD></TR>\n";
 #printf "<TR><TD>  </TD></TR>\n";
 printf $header_fmt,
        'Miscellaneous', '', '';
 printf $data_fmt,
        'Rel. strategy:', $rel_strategy, $warehouse_info_url;
 if ($days_before_expire < 0) {
   $fcolor1 = '<FONT COLOR=RED>';  $fcolor2 = '</FONT>';
 }
 else {$fcolor1 = $fcolor2 = '';}
 printf $data_fmt,
  'Start/end date:', $begin_date . ' - ' . $fcolor1 . $end_date . $fcolor2, 
  '';
 if ($cc_term_code ne '(none)') {
   $fcolor1 = '<FONT COLOR=RED>';  $fcolor2 = '</FONT>';
 }
 else {$fcolor1 = $fcolor2 = '';}
 printf $data_fmt,
        'Term. code:', $fcolor1 . $cc_term_code . ' '
        . $term_code_desc{$cc_term_code} . $fcolor2, 
        $dept_pa_string;
 printf $data_fmt,
       'Company code:', $cc_company_code, ' ';
 printf $data_fmt,
        'Admin. flag:',
        "$cc_admin_flag (" . &get_admin_flag_desc($cc_admin_flag) . ")",
        ' ';
 print "</TABLE>", "\n";
 print "<HR>", "\n";
 #print "<BR>", "\n";
 print "Who can: &nbsp;&nbsp;&nbsp; $who_auth_req_url &nbsp;&nbsp;&nbsp;"
        . "$who_auth_spend_url &nbsp;&nbsp;&nbsp;"
        . "$who_auth_rpt_url &nbsp;&nbsp;&nbsp;"
        . "$who_auth_appr_url &nbsp;&nbsp;&nbsp;"
        . "$who_auth_inv_url &nbsp;&nbsp;&nbsp;"
        . "$who_auth_trav_url &nbsp;&nbsp;&nbsp;"
        . "on F$fund_code/$qcode\?* (excluding people who are authorized on"
        . " all funds/cost objects)";
 print '<p><small>*For the "Who can...?" links, you need',
       ' <a href="http://web.mit.edu/is/help/cert/">',
       'secure web certificates</a> from the MIT Certificate Server',
       ' and a special <A href="' . $metaauth_url,
       '">viewing&nbsp;authorization</A>',
       ' to view SAP authorizations.</small>';
 print "<P>";
 print "<A HREF=\"$main_url\">"
  . "<small>Back to main perMIT web interface page</small></A>";
 print "</BODY></HTML>", "\n";
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
           . " w.company_code, w.admin_flag,"
           . " decode(w.release_strategy, '1', 'Model 1', '2', 'Model 2',"
           . " '3', 'Model 3', '4', 'Model 4', '5', 'Bates Model',"
           . " 'A', 'Sloan Model', 'Unknown')"
           . " from wh_cost_collector w"
           . " where w.cost_collector_id  = '$cc_number' and"
           . " substr(w.cost_collector_id_with_type,1,1) like '$co_prefix%'"
           . " order by w.cost_collector_expiration_date desc");
  my $csr = $lda->prepare("$stmt")
	|| &web_error("Oracle error in open. "
           . "The database may be temporarily shut down for backups."
           . "<BR><BR>" . $DBI::errstr);
  $csr->execute();
  my @ora_results = $csr->fetchrow_array();
  $csr->finish() || &web_error("Oracle error. can't close cursor");

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
  my $csr = $lda->prepare("$stmt")
	|| &web_error("Oracle error in open. "
           . "Problem with select from qualifier table."
           . "<BR><BR>" . $DBI::errstr);
  $csr->execute();
  my ($qid, $hc) = $csr->fetchrow_array() ;
  $csr->finish() || &web_error("Oracle error. can't close cursor");

  #
  #  Return the values.
  #
  
  if ($hc eq 'Y') {return $qid;}
  else {return 0;};
}

###########################################################################
#
#  Subroutine get_release_strategy
#  
#  Looks up the Fund Center to find the associated release strategy.
#
###########################################################################
#sub get_release_strategy {
#  my ($lda, $fc) = @_;
#
#  #
#  #  Do query against the fc_rs table
#  #
#  my @stmt = ("select decode(model,'1', 'Model 1', '2', 'Model 2',"
#              . " '3', 'Model 3', '4', 'Model 4', '5', 'Bates Model',"
#              . " 'A', 'Sloan Model', model)"
#              . " from repa.fc_rs"
#	      . " where fund_center = '$fc'");
#  my $csr = $lda->prepare("$stmt")
#	|| &web_error("Oracle error in open. "
#           . "Problem with select from qualifier table."
#           . "<BR><BR>" . $DBI::errstr);
#  my ($model) = $csr->fetchrow_array();
#  $csr->finish() || &web_error("Oracle error. can't close cursor");
#
#  #
#  #  Return the value.
#  #
#  
#  unless (defined($model)) {
#    $model = 'undefined';
#  }
#  return ($model);
#}

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
  exit(0);
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

###########################################################################
#
#  Subroutine set_admin_flag_hash(\%admin_flag_desc)
#  Prints an error message and exits.
#
###########################################################################
sub set_admin_flag_hash {
  my ($r_admin_flag_desc) = @_;
  %$r_admin_flag_desc = 
      ('AL' => 'Allocation cost object',
       'CG' => 'Core grant',
       'CR' => 'Custodial Responsibility',
       'DP' => 'DLC administered',
       'FC' => 'Faculty administered',
       'NS' => 'NSF Shortfall',
       'RA' => 'Research assistant support', 
       'RT' => 'Research Telephone',
       'SP' => 'Service provider (facility)',
      );
}

###########################################################################
#
#  Function get_admin_flag_desc($admin_flag)
#  Returns description for the given $admin_flag.
#
###########################################################################
sub get_admin_flag_desc {
  my ($admin_flag) = @_;
  my %admin_flag_desc = ();
  &set_admin_flag_hash(\%admin_flag_desc);
  return $admin_flag_desc{$admin_flag};
}

