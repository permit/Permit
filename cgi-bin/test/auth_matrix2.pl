#!/usr/bin/perl
###########################################################################
#
#  CGI script to produce a matrix of DLCs and Functions, with people
#  who have authorizations for the intersection of the two.
#
#  Step 1: Display a list of functions related to a qualifier_type in 
#          categories the person can see.  Allow the person to check up 
#          to n (15?) functions.  Allow the user to specify the order.
#
#  Step 2: Read in an hierarchically-expanded 
#          list of all authorizations and stuff the names into hashes.
#          Print the table of DLCs and display the names in each cell.
#
#
#
#  Copyright (C) 2003-2010 Massachusetts Institute of Technology
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
#  Written 2/10/2003, Jim Repa
#
###########################################################################
#
# Get packages
#
use rolesweb('login_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm
use rolesweb('parse_ssl_info'); #Use sub. parse_ssl_info in rolesweb.pm
use rolesweb('check_cert_source'); #Use sub. check_cert_source in rolesweb.pm
use rolesweb('verify_metaauth_category'); #Use sub. in rolesweb.pm

#
#  Web stem constants
#
 $host = $ENV{'HTTP_HOST'};
 $main_url = "http://$host/webroles.html";
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 $url_stem = "https://$host/cgi-bin/$progname";  # this URL

#
#  Other constants
#
 $g_delim = "!";

#
#  Print out the first line of the document
#
 print "Content-type: text/html", "\n\n";

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
 #$k_principal = 'ROLETEST';
 
#
#  Check the other fields in the certificate
#
 $result = &check_cert_source(\%ssl_info);
 if ($result ne 'OK') {
     print "<br><b>Your certificate cannot be accepted: $result";
     exit();
 }
 
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
#  Print out the top of the HTML document.  
#
 print "<HTML>", "\n";
 print "<HEAD><TITLE>Authorization matrix</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 &print_header("Authorization matrix", 'https');
 print "<HR>", "\n";

#
#  Get form variables.
#
 $fontsize = $formval{'fontsize'};
 if (!$fontsize) {$fontsize = 'smaller'};
 $fontsize =~ tr/A-Z/a-z/;  # Change to lower case
 $g_show_person = $formval{'show_person'};
 if (!$g_show_person) {$g_show_person = 'NAME';}
 $g_show_person =~ tr/a-z/A-Z/; # Change to upper case
 $g_show_dlc = $formval{'show_dlc'};
 if (!$g_show_dlc) {$g_show_dlc = 'CODE';}
 $g_show_dlc =~ tr/a-z/A-Z/; # Change to upper case
 my $temp_cat = $formval{'cat'};
 $temp_cat =~ /^([^ ]*) (.*)/;
 $g_cat = $1;
 $g_cat =~ tr/a-z/A-Z/;
 unless ($g_cat) {$g_cat = 'EHS';}
 ### For now, we only support qualifier_type = 'DEPT' or 'ORG2'
 #my $temp_qtype = $formval{'qtype'};
 #$temp_qtype =~ /^([^ ]*) (.*)/;
 #$g_qtype = $1;
 #$g_qtype =~ tr/a-z/A-Z/;
 #$g_qtype = 'ORG2';
 unless ($g_qtype) {$g_qtype = 'DEPT';}
 $g_root_code = ($g_qtype eq 'ORG2') ? '10000000' : 'D_ALL';

#
#  Set global SQL fragment for identifying categories.
#
 #my $cat = 'META,ADMN';
 my $cat = $g_cat;
 my $qtype = $g_qtype;
 if ($cat =~ /,/) {
   my $temp_cat_string = $cat;
   $temp_cat_string = "('$cat')";
   $temp_cat_string =~ s/,/\',\'/g;
   $g_sql_cat_fragment = " in $temp_cat_string";
 }
 else {
   $g_sql_cat_fragment = " = '$cat'";
 }

#
#  Get set to use Oracle.
#
use Oraperl;  # Point to library of Oracle-related subroutines for Perl
if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}

#
# Login into the database
# 
$lda = &login_sql('roles') 
      || die $ora_errstr;

#
#  Make sure the user has a meta-authorization to view auths. in the given 
#  category or categories.
#
  # Multiple categories?
  if ($cat =~ /,/) {
    my @cat_list = split(',', $cat);
    my $cat_item;
    foreach $cat_item (@cat_list) {
      if (! &verify_metaauth_category($lda, $k_principal, $cat_item)) {
        # Exception
        if ( ($cat_item eq 'META') && ($qt eq 'DEPT') 
             && (&verify_metaauth_category($lda, $k_principal, 'SAP')) ) {
          ## It's OK.  The person is authorized.
        }
        else {
          print 
          "Sorry.  You do not have the required Roles DB 'meta-authorization'",
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
        "Sorry.  You do not have the required Roles DB 'meta-authorization'",
        " to view other people's $cat authorizations.";
        exit();
      }
    }
  }

#
#  Get a list of Departments
#
 my @qual_code = ();
 my %qual_code2name = ();
 my %qual_parent_school = ();
 my %node_type = ();
 &get_dept_info2($lda, \@qual_code, \%qual_code2name, \%qual_parent_school,
                 \%node_type);

#
#  Get a list of functions
#
 my $n_function = 0;
 my @func_id = ();
 my %func_id2name = ();
 &get_function_list($lda, $cat, $g_qtype, \$n_function, \@func_id, 
                                        \%func_id2name);
 print "Number of functions found = $n_function<BR>";

#
#  Get a hash of the authorizations 
# 
 my %qual_func_to_kerb = ();
 %g_kerb_to_name = ();  #Make this global
 &get_auth_list($lda, $cat, $g_qtype, \%qual_func_to_kerb, \%g_kerb_to_name);

#
#  Drop connection to Oracle.
#
 &ora_logoff($lda) || die "can't log off Oracle";

#
#  Print out the http document.  
#
 &print_table2($fontsize, $url_stem, $n_function, \@func_id, \%func_id2name,
               \%qual_func_to_kerb, \@qual_code, \%qual_code2name, 
               \%qual_parent_school, \%node_type);

#
#
#
 print "<P>";
 print "<HR>", "\n";
 print "<A HREF=\"$main_url\">"
  . "<small>Back to main Roles web interface page</small></A>";
 print "</BODY></HTML>", "\n";
 exit(0);

###########################################################################
#
#  Subroutine get_dept_info2($lda, \@qual_code, \%qual_code2name,
#                            \%qual_parent_school, \%node_type);
#
#  Get a sorted list of DLCs codes (D_xxxx) along with their names
#  and their related school_or_area D_xxxx code.  The hash %qual_code2name
#  maps the D_xxxx code to the corresponding name for DLCs as well as
#  parent nodes.
#
###########################################################################
sub get_dept_info2 {
  my ($lda, $rqual_code, $rqual_code2name, $rqual_parent_school,
      $rnode_type) = @_;

  #
  #  Open a cursor to a select statement
  #
  my $order_fragment;
  my $order_fragment = ($g_show_dlc eq 'CODE') 
          ? "order by 1, 3, 7, 5"
          : "order by 2, 4, 7, 6";
  my $stmt = "select q1.qualifier_code school_area, q1.qualifier_name sa_name,
          'A' sort_qual, 'A' sort_qname,  
          q1.qualifier_code qual, q1.qualifier_name qual_name, 0, 'SA'
     from qualifier q0, qualifier_child qc0, qualifier q1, 
          qualifier_child qc1, qualifier q2
     where q0.qualifier_code = '$g_root_code'
     and q0.qualifier_type = '$g_qtype'
     and qc0.parent_id = q0.qualifier_id
     and q1.qualifier_id = qc0.child_id
     and qc1.parent_id = q1.qualifier_id
     and q2.qualifier_id = qc1.child_id 
     and (q2.qualifier_code like 'D%' or q0.qualifier_type = 'ORG2')
     and (substr(q2.qualifier_code, 1, 2) like 'D_%' 
          or q0.qualifier_type = 'ORG2')
   union select q1.qualifier_code school_area, q1.qualifier_name sa_name,
          q2.qualifier_code sort_qual, q2.qualifier_name sort_qname,
          q2.qualifier_code qual, q2.qualifier_name qual_name, 1, 'PAR'
     from qualifier q0, qualifier_child qc0, qualifier q1, 
          qualifier_child qc1, qualifier q2
     where q0.qualifier_code = '$g_root_code'
     and q0.qualifier_type = '$g_qtype'
     and qc0.parent_id = q0.qualifier_id
     and q1.qualifier_id = qc0.child_id
     and qc1.parent_id = q1.qualifier_id
     and q2.qualifier_id = qc1.child_id 
     and (q2.qualifier_code like 'D%' or q0.qualifier_type = 'ORG2')
     and (substr(q2.qualifier_code, 1, 2) like 'D_%' 
          or q0.qualifier_type = 'ORG2')
   union select q1.qualifier_code school_area, q1.qualifier_name sa_name,
          q2.qualifier_code sort_qual, q2.qualifier_name sort_qname,
          q3.qualifier_code qual, q3.qualifier_name qual_name, 2, 'LEAF'
     from qualifier q0, qualifier_child qc0, qualifier q1, 
          qualifier_child qc1, qualifier q2, qualifier_descendent qd, 
          qualifier q3
     where q0.qualifier_code = '$g_root_code'
     and q0.qualifier_type = '$g_qtype'
     and qc0.parent_id = q0.qualifier_id
     and q1.qualifier_id = qc0.child_id
     and qc1.parent_id = q1.qualifier_id
     and q2.qualifier_id = qc1.child_id 
     and qd.parent_id = q2.qualifier_id
     and q3.qualifier_id = qd.child_id
     and (q3.qualifier_code like 'D%' or q0.qualifier_type = 'ORG2')
     and (substr(q3.qualifier_code, 1, 2) like 'D_%' 
          or q0.qualifier_type = 'ORG2')
     $order_fragment";

  #print "stmt='$stmt'<BR>";
  my $csr = &ora_open($lda, $stmt)
	|| die $ora_errstr;
  
  #
  #  Read in rows from the query.  Fill in values for the hashes.
  #
  my $prev_code = '';
  my ($ddparent, $ddparent_name, $ddsort_code, $ddsort_qname,
      $ddcode, $ddname, $ddsort,
      $ddnode_type);
  while (($ddparent, $ddparent_name, $ddsort_code, $ddsort_qname,
          $ddcode, $ddname, $ddsort,
          $ddnode_type)
          = &ora_fetch($csr))
  {
    push(@$rqual_code, $ddcode);
    $$rqual_code2name{$ddcode} = $ddname;
    $$rqual_parent_school{$ddcode} = $ddparent;
    $$rnode_type{$ddcode} = $ddnode_type;
    unless ($$rqual_code2name{$ddparent}) {
      $$rqual_code2name{$ddparent} = $ddparent_name;
    }
  }
  &ora_close($csr) || die "can't close cursor";

}

###########################################################################
#
#  Subroutine get_function_list($lda, $cat, $qtype, \$n_function, \@func_id, 
#                               \%func_id2name);
#
#  Sets
#    $n_function to the number of functions found
#    @func_id to a list of function_ids
#    %func_id2name to a hash where $func_id2name{$func_id} = $func_name
#
###########################################################################
sub get_function_list {
  my ($lda, $cat, $qtype, $rn_function, $rfunc_id, $rfunc_id2name) = @_;

  #
  #  Open a cursor to a select statement
  #
  my $stmt = 
      "select f.function_id, f.function_name 
       from function f
       where f.function_category $g_sql_cat_fragment
       and f.qualifier_type = '$qtype'
       and exists 
         (select a.authorization_id from authorization a
          where a.function_id = f.function_id
          and a.qualifier_code <> '$g_root_code')
       order by f.function_name";
  #print "stmt='$stmt'<BR>";
  my $csr = &ora_open($lda, $stmt)
	|| die $ora_errstr;
  
  #
  #  Read in rows from the query.  Fill in values for the hashes.
  #
  $$rn_function = 0;  # Count of functions
  my ($fid, $fname);
  while (($fid, $fname) = &ora_fetch($csr))
  {
    $$rfunc_id[$$rn_function++] = $fid;
    $$rfunc_id2name{$fid} = $fname;
  }
  &ora_close($csr) || die "can't close cursor";

}

###########################################################################
#
#  Subroutine get_auth_list($lda, $cat, $qtype, \%qual_func_to_kerb,
#                           \%kerb_to_name);
#
#  Looks up expanded authorizations for functions within category $cat
#  and having qualifier_type $qtype.  (Ignore the root node, for the
#  moment presumed to be '$g_root_code'.)
#
#  Sets
#    $qual_func_to_kerb{"$qcode!$func_id"} 
#         = a comma-delimited list of Kerberos usernames
#
###########################################################################
sub get_auth_list {
  my ($lda, $cat, $qtype, $rqual_func_to_kerb, $rkerb_to_name) = @_;

  #
  #  Open a cursor to a select statement
  #
  my $root_code = $g_root_code;
  my $sql_fragment = "and q.qualifier_code like 'D%'"
                     . " and substr(q.qualifier_code, 1, 2) = 'D_'";
  my $order_fragment = ($g_show_person eq 'KERBNAME') 
                       ? "order by 1, 2, 3"
                       : "order by 1, 2, 5";
  my $stmt = 
      "select a.qualifier_code, a.function_id, a.kerberos_name, 'R', 
           initcap(p.last_name || ', ' || p.first_name)
         from authorization a, qualifier q, person p
         where a.function_category $g_sql_cat_fragment
         and q.qualifier_id = a.qualifier_id
         and q.qualifier_type = '$qtype'
         and a.qualifier_code <> '$root_code'
         and p.kerberos_name = a.kerberos_name
       union 
       select q.qualifier_code, a.function_id, a.kerberos_name, 'E',
           initcap(p.last_name || ', ' || p.first_name)
         from authorization a, function f, qualifier_descendent qd, 
              qualifier q, person p
         where a.function_category $g_sql_cat_fragment
         and a.qualifier_code <> '$root_code'
         and qd.parent_id = a.qualifier_id
         and q.qualifier_id = qd.child_id
         and q.qualifier_type = '$qtype'
         and p.kerberos_name = a.kerberos_name
         $sql_fragment 
         $order_fragment";
  #print "stmt='$stmt'<BR>";
  my $csr = &ora_open($lda, $stmt)
	|| die $ora_errstr;
  
  #
  #  Read in rows from the query.  Fill in values for the hash.
  #
  my ($qcode, $fid, $kerbname, $expand, $name);
  my ($key, $temp_kerb);
  while (($qcode, $fid, $kerbname, $expand, $name) = &ora_fetch($csr))
  { 
    $temp_kerb = ($expand eq 'E') ? "($kerbname)" : $kerbname;
    $key = "$qcode$g_delim$fid";
    if ($$rqual_func_to_kerb{$key}) {
      $$rqual_func_to_kerb{$key} .= ",$temp_kerb";
    }
    else {
      $$rqual_func_to_kerb{$key} = $temp_kerb;
    }
    unless ($$rkerb_to_name{$kerbname}) {
      $$rkerb_to_name{$kerbname} = $name;
    }
  }
  &ora_close($csr) || die "can't close cursor";

}

###########################################################################
#
#  Subroutine print_table2($fontsize, $url_stem, $n_function, 
#                          \@func_id, \%func_id2name, \%qual_func_to_kerb,
#                          \@qual_code, \%qual_code2name, 
#                          \%qual_parent_school, \%node_type)
#
#  Print table.
#
###########################################################################
sub print_table2 {
  my ($fontsize, $url_stem, $n_function, $rfunc_id, $rfunc_id2name,
      $rqual_func_to_kerb, $rqual_code, $rqual_code2name,
      $rqual_parent_school, $rnode_type) = @_;

 #
 #  Set some variables for table headings and data, dependent on font size.
 #
  my ($font1, $font2);
  if ($fontsize eq 'smaller') {
    $font1 = "<font size=\"-1\">";
    $font2 = "</font>";
  }
  else {
    $font1 = "";
    $font2 = "";
  }
  my $td1 = "<td>$font1";
  my $td1a = "<td colspan=2>$font1";
  my $td1b = "<td colspan=2 BGCOLOR=\"#CFCFCF\">$font1";
  my $td2 = "$font2</td>";
  my $th1 = "<th>$font1";
  my $th2 = "$font2</th>";

  #
  # Print out the header.
  #
  &print_explanation('1');
  if ($fontsize eq 'smaller') {
    print "<small>(Redisplay the table using a <a href=\"$url_stem?"
          . "fontsize=bigger\">bigger</a> font.)</small>";
    print "<P><BR>";
  }
  else {
    print "<small>(Redisplay the table using a <a href=\"$url_stem?"
          . "fontsize=smaller\">smaller</a> font.)</small>";
    print "<P><BR>";
  }

  #
  # Start printing out the table.
  #
  #print "<table border=1 bordercolor=black>";
  my $cols;  # Number of columns
  my $i;
  $cols = $n_function + 2;
    
  my ($child_str, $parent, @child_list, $first_time, $child_link);
  #####
  #  Change the logic.
  #  Print from an array of DLC rows.
  #  Each row is identified as either a S_OR_A, DLC_NODE, or DLC_LEAF
  #  - If it is a S_OR_A, print a gray band.
  #  - If it is a DLC_NODE, treat it like a DLC, but put it in the leftmost
  #    column.
  #  - If it is a DLC_LEAF, treat it like a DLC, and put it in the 2nd column.
  #
  #####
  #
  # An alternative is to treat the leftmost column as an area where we 
  # can change the indentation depending on the level of the object.
  #
  #
  #####

  my $qcode;
  my $parent_code;
  my $node_type;
  my $first_time = 1;
  my $display_dlc;
  ### Testing
    my $nn = @qual_code;
    print "There were $nn qualifier codes found.<BR>";
  ###
  foreach $qcode (@qual_code) {
    $parent_code = $$rqual_parent_school{$qcode};
    $node_type = $$rnode_type{$qcode};
    $display_dlc = ($g_show_dlc eq 'NAME') ? $$rqual_code2name{$qcode}
                                           : $qcode;
    if ($node_type eq 'SA') {
      if ($first_time) {
        $first_time = 0;
      }
      else {
        print "</table>\n";
        print "<P>&nbsp;<P>";
      }
      print "<table border=1 bordercolor=black>";
      print "<tr BGCOLOR=\"#cfcfcf\">"
            . "${th1}Parent<br>Dept$th2${th1}Department code$th2";
      for ($i=0; $i<$n_function; $i++) {
        print $th1 . &fmt_func_name($$rfunc_id2name{$$rfunc_id[$i]}) . $th2;
      }
      print "</tr>\n";
      print "<tr BGCOLOR=\"#cfcfcf\"><td colspan=$cols>$font1&nbsp;$td2"
            . "</tr>\n";
      print "<tr>${td1b}<b>$display_dlc</b>$td2";
    }
    elsif ($node_type eq 'PAR') {
      print "<tr>${td1a}<b>$display_dlc</b>$td2";
    }
    else {
      print "<tr>${td1}&nbsp;$td2$td1<b>$display_dlc</b>$td2";
    }
    
    for ($i=0; $i<$n_function; $i++) {
      my $key = "$qcode$g_delim$$rfunc_id[$i]";
      my $temp_kerb_list 
         = &fmt_kerb_list($$rqual_func_to_kerb{$key});
      print $td1 . $temp_kerb_list . $td2;
    }
    print "</tr>\n";
    if ($node_type eq 'SA') {
      print "<tr BGCOLOR=\"#cfcfcf\"><td colspan=$cols>$font1&nbsp;$td2"
            . "</tr>\n";
    }
  }
  print "</table>\n";
 
}

###########################################################################
#
#  Function fmt_kerb_list($kerblist)
#
#  Return the html fragment to be displayed in a table for the
#  given list of kerberos names
#  If it is null, return '&nbsp;'.
#  Otherwise, return the list delimited by <br>.
#
###########################################################################
sub fmt_kerb_list {
  my ($kerblist) = @_;
  if (!($kerblist)) {
    return '&nbsp;';
  }
  if ($g_show_person eq 'KERBNAME') {
    $kerblist =~ s/,/<BR>/g;
  }
  else {
    my $user;
    my $temp_user;
    my $new_kerblist;
    my $temp_name;
    my $left_paren;
    my $right_paren;
    foreach $user (split(',', $kerblist)) {
      if (substr($user, 0, 1) eq "(") {
        $temp_user = $user;
        $temp_user =~ s/^\(//;
        $temp_user =~ s/\)$//;
        $left_paren = '(';
        $right_paren = ')';
      }
      else {
        $temp_user = $user;
        $left_paren = '';
        $right_paren = '';
      }
      $temp_name = $g_kerb_to_name{$temp_user};
      if ($new_kerblist) {
        $new_kerblist .= "!$left_paren$temp_name$right_paren";
      }
      else {
        $new_kerblist = "$left_paren$temp_name$right_paren";
      }
      $new_kerblist =~ s/!/<LI>/g;
      $kerblist = "<UL compact><LI>$new_kerblist</UL>";
    }
  }
  return $kerblist;
}

###########################################################################
#
#  Function fmt_kerb_name($function_name)
#
#  Return an html fragment that splits certain long words (which 
#  will allow us to make the table more compact).
#
###########################################################################
sub fmt_func_name {
  my ($func_name) = @_;
  $func_name =~ s/DEPARTMENTAL/DEPART-<BR>MENTAL/;
  $func_name =~ s/COORDINATOR/COORD-<BR>INATOR/;
  $func_name =~ s/TRANSPORTATION/TRANSPOR-<BR>TATION/;
  return $func_name;
}

###########################################################################
#
#  Subroutine print_explanation($option);
#
#  Prints explanatory text at the top of the html document.
#
###########################################################################
sub print_explanation {
 my ($option) = @_;

 if ($option eq '1') {
print << 'ENDOFTEXT';
<small>
Below is a table of authorizations within the selected category 
(or categories). Note the following:
<ul>
<li>The DLCs are grouped by School or Area.
<li>Within each cell at the intersection of a DLC code (rows) and a 
Function Name (column) is a list of Kerberos usernames (or names) for 
people with an authorization for the given function within the DLC.
<li>Parenthesized Kerberos usernames represent people who are authorized 
for the function at a higher level in the hierarchy.  For example, if 
a person is authorized for a given function at the school level, e.g., 
D_SCHOOL_SCI, then an implied authorization will the person, with the 
person's Kerberos username in parentheses, will be shown for D_BIOLOGY, 
D_CHEM, etc..
</ul>
</small>
ENDOFTEXT
 }
 else {
 }
}


###########################################################################
#
#  Function &web_string($astring)
#
#  Converts spaces to '+', left parentheses to %28, 
#   right parentheses to %29, and '&' to %26.
#
###########################################################################
sub web_string {
    my ($astring) = $_[0];
    $astring =~ s/ /+/g;
    $astring =~ s/\(/%28/g;
    $astring =~ s/\)/%29/g;
    $astring =~ s/\&/%26/g;
    $astring;
}


