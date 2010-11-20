#!/usr/bin/perl -I/home/www/permit/feeds/lib/cpa ###########################################################################
#
#  CGI script to display some miscellaneous reports.  These reports #  require certificates and an authorization to 'RUN ADMIN REPORTS'.
#
#
#  Copyright (C) 2007-2010 Massachusetts Institute of Technology
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
#  Written by Jim Repa, May, 9, 2007.
#  Modified from select_criteria.cgi 11/20/2008 - nowrap in auths table
#    to allow for downloading to Excel
#
###########################################################################
#use DBI;
# Get packages
#
use rolesweb('login_dbi_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_authentication_info');   #Use sub. login_sql in rolesweb.pm
use rolesweb('check_auth_source');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm use rolesweb('parse_ssl_info'); #Use sub. parse_ssl_info in rolesweb.pm 
use rolesweb('check_cert_source'); #Use sub. check_cert_source in rolesweb.pm 
use rolesweb('verify_metaauth_category'); #Use sub. verify_metaauth_category 
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm 
use rolesweb('strip'); #Use sub. strip in rolesweb.pm # #  Process form information #  
$request_method = $ENV{'REQUEST_METHOD'};  if ($request_method eq "GET") {
   $input_string = $ENV{'QUERY_STRING'};  }  elsif ($request_method eq "POST") {
   read (STDIN, $input_string, $ENV{'CONTENT_LENGTH'});  # Read input string  
}  else {
   $input_string = '';  # Error condition  
}  #$input_string = $ARGV[0];  
%formval = ();  # Hash of reformatted key->variables populated by &parse_forms  
%rawval = ();  # Hash of unformatted key->variables populated by &parse_forms  
&parse_forms($input_string, \%formval, \%rawval); # Call sub. to parse input

#
#  Set some constants
#
$g_delim = '!';
$g_server_user = 'ROLEWWW9';
$g_default_show_tech_notes = 0;
@title = (
   'Selection sets and criteria',
   'Choose a selection set',
   'Specify criteria and values',
   'Show criteria/value pairs to be used for constructing SELECT statement', 
   '5', '6', '7', '8', '9', '10',
   'New Selection sets and criteria',
   'Choose a selection set (new tables)',
   'Specify criteria and values (new tables)',
   'Show criteria/value pairs, and construct an SQL statement (new tables)'
 );
$host = $ENV{'HTTP_HOST'};
$url_stem = "https://$host/cgi-bin/qualauth.pl?";
$url_stem2 = "http://$host/cgi-bin/rolequal1.pl?";
$url_stem3 = "http://$host/cgi-bin/roleparent.pl?";
$url_stem4 = "https://$host/cgi-bin/qualauth.pl?detail=2&";

#
#  Get form variables
#
$web_page = $formval{'web_page'};
if (! $web_page) {$web_page = 1;}
$kerbname = $formval{'kerbname'};
$kerbname =~ tr/a-z/A-Z/;   # Raise $kerbname to upper-case
$selection_id = $formval{'selection_id'};
$show_tech_notes = $formval{'show_tech_notes'};
$g_show_tech_notes = ($show_tech_notes ne '') ? $show_tech_notes 
                                              : $g_default_show_tech_notes;
$g_show_tech_notes =~ s/y/1/;
$g_show_tech_notes =~ s/Y/1/;
$g_show_tech_notes =~ s/n/0/;
$g_show_tech_notes =~ s/N/0/;


#
#  Print out top of the http document.  
#
 print "Content-type: text/html\n\n";  # Start generating HTML document
 $header = $title[$web_page - 1];
 print "<head><title>$header</title></head>\n<body>";
 print '<BODY bgcolor="#fafafa">';
 &print_header
    ($header, 'https');
 print "<P>";

#
#  Parse certificate information
#

 my $info = $ENV{"REMOTE_USER"};  # Get certificate information
  #%ssl_info = &parse_authentication_info($info);  # Parse certificate into a Perl "hash"
  ($k_principal, $domain) = split("\@", $info);
  if (!$k_principal) {
      print "<br><b>No certificate sent.  Use https:// , not http://</b>\n";
      exit();
  }
  $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase
  $result = &check_auth_source($info); # Check other certificate fields
  if ($result ne 'OK') {
      print "<br><b>Your certificate cannot be accepted: $result";
      exit();
  }

#
#  Get set to use DB.
#
use DBI;

#
#  Open connection to DB
#
$lda = &login_dbi_sql('roles') 
      || &web_error($DBI::errstr);
#
#  Make sure the user has a meta-authorization to view special reports.
#
if (!(&verify_special_report_auth($lda, $k_principal))) {
  print "Sorry.  You do not have the required Roles DB 'meta-authorization'",
  " to view special reports.";
  exit();
}

#
#  Print out the header
#
 #$header = $title[$web_page - 1];
 #print "<HTML>", "\n";
 #print "<HEAD><TITLE>$header",
 #      "</TITLE></HEAD>", "\n";
 #print "<BODY><H1>$header</H1>","\n";

#
#  Call the appropriate report
#
 if ($web_page == 1) {
   &report1($lda);
 }
 elsif ($web_page == 2) {
   &report2($lda);
 }
 elsif ($web_page == 3) {
   &report3($lda, $selection_id);
 }
 elsif ($web_page == 4) {
   &report4($lda);
 }
 elsif ($web_page == 11) {
   &report11($lda);
 }
 elsif ($web_page == 12) {
   &report12($lda);
 }
 elsif ($web_page == 13) {
   &report13($lda, $selection_id);
 }
 elsif ($web_page == 14) {
   &report14($lda, $selection_id);
 }
 else {
     print "Web-page '$web_page' was not found.<BR>";
 }

#
#  Drop connection to Oracle.
#
$lda->disconnect() || &web_error("can't log off DB");

#
#  Print end of the HTML document.
#
 print "</BODY></HTML>", "\n";
 exit(0);


###########################################################################
#
#  Subroutine report1.
#
#  Display a report on Selection Sets, Criteria, etc. related to the
#  Roles DB PowerBuilder application.
#
###########################################################################
sub report1 {

  my ($lda) = @_;  # Get Oracle login handle.

  my ($kerberos_name);

 #
 # Start a SELECT statement
 #
     my $stmt = "select ss.selection_id as selectionId, ss.selection_name, ss.screen_id as screenId,
                        sn.screen_name, ci.criteria_id, c.criteria_name,
                        ci.apply, ci.next_scrn_selection_id,
                        ci.value, ci.no_change, c.sql_fragment, ci.sequence as sequenceId
                 from selection_set ss, screen sn, criteria_instance ci,
                      criteria c
                 where sn.screen_id = ss.screen_id
                 and ci.selection_id = ss.selection_id
                 and ci.username = 'SYSTEM'
                 and ss.selection_id <> 0
                 and c.criteria_id = ci.criteria_id
                 order by screenId,selectionId,sequenceId"; 
         
     my $csr = $lda->prepare($stmt); 

     #$csr->bind_param(":start_date", $start_date);
     #$csr->bind_param(":end_date", $end_date); 
     $csr->execute; 

 #
 #  Explain what is displayed
 #
  print "Below are displays of data related to the Selection Set and
         Criteria feature for the PowerBuilder application for the
         Roles Database.  The data are all maintained in the Roles DB 
         tables SELECTION_SET, CRITERIA, CRITERIA_INSTANCE, and SCREEN.<p />";
  print "There are two tables displayed below:   
         <ol>
           <li>Table of selection sets
           <li>Table of criteria with associated SQL fragments
         </ol><p /><hr /><p />";

 #
 #  Start a table
 #  
     print "<h3>1. Table of selection sets</h3>";
     print "<table border>\n";
     print "<tr>"
         . "<th>Selection ID</th><th>Selection Name</th>"
         . "<th>Criteria ID</th><th>Criteria Name</th>"
         . "<th>Default<br>Apply</th><th>Default<br>Value</th>"
         . "<th>No Change</th><th>Pick-list<br>Selec-<br>tion ID</th>"
         . "</tr>\n";

 #
 #  Print special selection sets.
 #
  print "<tr><td bgcolor=\"#E0E0E0\" colspan=8 align=center>"
           . "Screen 0. Dummy screen</td></tr>";
  print "<tr><td>50</td><td>Function category</td><td>0</td>
             <td>Use to pick a function category</td><td>Y</td><td>n/a</td>
             <td>N</td><td>n/a</td></tr>";
  print "<tr><td>51</td><td>Person type</td><td>0</td>
             <td>Use to pick a person type (Employee, Student, Other)</td>
             <td>Y</td><td>n/a</td>
             <td>N</td><td>n/a</td></tr>";

 #
 #  Print rows of the table
 #
  my ($selection_id, $selection_name, $screen_id, $screen_name,
      $criteria_id, $criteria_name, $apply, $pick_screen,
      $value, $no_change, $sql_frag);
  my $prev_screen_id = '';
  my $prev_selection_id = '';
  my %criteria2sql_frag;
  while ( ($selection_id, $selection_name, $screen_id, $screen_name, 
           $criteria_id, $criteria_name, $apply, $pick_screen,
           $value, $no_change, $sql_frag)  
           = $csr->fetchrow_array() )
  {
     unless ($criteria_id eq '0') {
       $criteria2sql_frag{$criteria_id} = $sql_frag;
     }
     if ($value eq '' || $value eq ' ') {$value = '&nbsp;';}
     $value =~ s/</&lt;/g;
     $value =~ s/>/&gt;/g;
     $screen_name =~ s/Authorization Type/Authorization Type (aka Function)/;
     if ($prev_screen_id ne $screen_id) {
       print "<tr><td bgcolor=\"#E0E0E0\" colspan=8 align=center>"
           . "Screen ${screen_id}. $screen_name</td></tr>";
       $prev_screen_id = $screen_id;
     }
     my $temp_selection_id = $selection_id;
     my $temp_selection_name = $selection_name;
     if ($prev_selection_id eq $selection_id) {
       $temp_selection_id = '&nbsp;';
       $temp_selection_name = '&nbsp;';
     }
     if ($prev_selection_id ne $selection_id) {
       print "<tr><td colspan=8>&nbsp;</td></tr>";
       $prev_selection_id = $selection_id;
     }
     print "<tr>"
         . "<td>$temp_selection_id</td>"
         . "<td>$temp_selection_name</td>"
         . "<td><a href=\"#$criteria_id\">$criteria_id</a></td>"
         . "<td>$criteria_name</td>"
         . "<td>$apply</td>"
         . "<td>$value</td>"
         . "<td>$no_change</td>"
         . "<td>$pick_screen</td>"
         . "</tr>\n";
   }

 #
 #  End of table
 #
  print "</table>\n";

 #
 #  Print another table
 #
  print "<p />&nbsp;<p />";
  print "<h3>2. Table of criteria with associated SQL fragments</h3>";
  print "<table border>";
  print "<tr><th>Criteria ID</td><td>SQL fragment</td></tr>";
  foreach $key (sort keys %criteria2sql_frag) {
    print "<tr>"
        . "<td><a name=\"$key\">$key</a></td>"
        . "<td>$criteria2sql_frag{$key}</td></tr>";
  }
  print "</table>";

  $csr->finish(); 

}

###########################################################################
#
#  Subroutine report11.
#
#  Display a report on Selection Sets, Criteria, etc. related to the
#  Roles DB PowerBuilder application.
#
###########################################################################
sub report11 {

  my ($lda) = @_;  # Get Oracle login handle.

  my ($kerberos_name);

 #
 # Start a SELECT statement
 #
     my $stmt = "
       select ss.selection_id selectionid, ss.selection_name , ss.screen_id screenid,
                        sn.screen_name , sc.criteria_id, c.criteria_name,
                        sc.default_apply, sc.next_scrn_selection_id,
                        sc.default_value, sc.no_change, 
                        c.sql_fragment, sc.sequence sequence1, ss.sequence sequence2
                 from selection_set2 ss, screen2 sn, selection_criteria2 sc,
                      criteria2 c
                 where sn.screen_id = ss.screen_id
                 and sc.selection_id = ss.selection_id
                 and ss.selection_id <> 0
                 and c.criteria_id = sc.criteria_id
        union select ss.selection_id selectionid, ss.selection_name, ss.screen_id screenid,
                        sn.screen_name, 0, 'n/a', 
                        'n/a', 0,
                        ' ', 'n/a',
                        ' ', 1 as sequence1, ss.sequence sequence2
                 from selection_set2 ss left outer join selection_criteria2 sc ON (sc.selection_id = ss.selection_id),screen2 sn
                 where sn.screen_id = ss.screen_id
                 and sc.selection_id is null   
                 order by  screenid, sequence2,   selectionid, sequence1
       "; 
         
     my $csr = $lda->prepare($stmt); 

     $csr->execute; 

 #
 #  Explain what is displayed
 #
  print "Below are displays of data related to the Selection Set and
         Criteria feature for the PowerBuilder application for the
         Roles Database.  The data are all maintained in the Roles DB 
         tables SELECTION_SET2, CRITERIA2, SELECTION_CRITERIA2, 
         and SCREEN2.<p />";
  print "There are two tables displayed below:   
         <ol>
           <li>Table of selection sets
           <li>Table of criteria with associated SQL fragments
         </ol><p /><hr /><p />";

 #
 #  Start a table
 #  
     print "<h3>1. Table of selection sets</h3>";
     print "<table border>\n";
     print "<tr>"
         . "<th>Selection ID</th><th>Selection Name</th>"
         . "<th>Criteria ID</th><th>Criteria Name</th>"
         . "<th>Default<br>Apply</th><th>Default<br>Value</th>"
         . "<th>No Change</th><th>Pick-list<br>Selec-<br>tion ID</th>"
         . "</tr>\n";

 #
 #  Print rows of the table
 #
  my ($selection_id, $selection_name, $screen_id, $screen_name,
      $criteria_id, $criteria_name, $apply, $pick_screen,
      $value, $no_change, $sql_frag);
  my $prev_screen_id = '';
  my $prev_selection_id = '';
  my %criteria2sql_frag;
  while ( ($selection_id, $selection_name, $screen_id, $screen_name, 
           $criteria_id, $criteria_name, $apply, $pick_screen,
           $value, $no_change, $sql_frag)  
           = $csr->fetchrow_array() )
  {
     unless ($criteria_id eq '0') {
       $criteria2sql_frag{$criteria_id} = $sql_frag;
     }
     if ($value eq '' || $value eq ' ') {$value = '&nbsp;';}
     $value =~ s/</&lt;/g;
     $value =~ s/>/&gt;/g;
     if ($prev_screen_id ne $screen_id) {
       print "<tr><td bgcolor=\"#E0E0E0\" colspan=8 align=center>"
           . "Screen ${screen_id}. $screen_name</td></tr>";
       $prev_screen_id = $screen_id;
     }
     my $temp_selection_id = $selection_id;
     my $temp_selection_name = $selection_name;
     if ($prev_selection_id eq $selection_id) {
       $temp_selection_id = '&nbsp;';
       $temp_selection_name = '&nbsp;';
     }
     if ($prev_selection_id ne $selection_id) {
       print "<tr><td colspan=8>&nbsp;</td></tr>";
       $prev_selection_id = $selection_id;
     }
     my $criteria_string = ($criteria_id eq '0') ? $criteria_id
	 : "<a href=\"#$criteria_id\">$criteria_id</a>";
     print "<tr>"
         . "<td>$temp_selection_id</td>"
         . "<td>$temp_selection_name</td>"
         . "<td>$criteria_string</td>"
         . "<td>$criteria_name</td>"
         . "<td>$apply</td>"
         . "<td>$value</td>"
         . "<td>$no_change</td>"
         . "<td>$pick_screen</td>"
         . "</tr>\n";
   }

 #
 #  End of table
 #
  print "</table>\n";

 #
 #  Print another table
 #
  print "<p />&nbsp;<p />";
  print "<h3>2. Table of criteria with associated SQL fragments</h3>";
  print "<table border>";
  print "<tr><th>Criteria ID</td><td>SQL fragment</td></tr>";
  foreach $key (sort keys %criteria2sql_frag) {
    print "<tr>"
        . "<td><a name=\"$key\">$key</a></td>"
        . "<td>$criteria2sql_frag{$key}</td></tr>";
  }
  print "</table>";

  $csr->finish(); 

}


###########################################################################
#
#  Subroutine report2.
#
#  Mockup of list of selection sets
#
###########################################################################
sub report2 {

  my ($lda) = @_;  # Get arguments
  my $screen_id = 1;  # Authorizations list
  my $kerberos_name = $k_principal;

 # print "Here we are in Report 2...<BR>";

 #
 # Start a SELECT statement
 #
     my $stmt = "select ss.selection_id selectionId, ss.selection_name name, ss.screen_id screenId,
                       sn.screen_name
                 from selection_set ss, screen sn
                 where sn.screen_id = ss.screen_id
                 and ss.screen_id = '$screen_id'
                 and ss.selection_id <> 0
                 order by screenId, selectionId"; 
     #print "stmt = '$stmt'<BR>";
     my $csr = $lda->prepare($stmt); 

     $csr->execute; 

 #
 #  Print the list of selection sets
 #  
     print "<form action=\"\">\n";
     print "<input type=hidden name=web_page value=\"3\">\n";
     print "<select name=selection_id>\n";

 #
 #  Print rows of the table
 #
  my ($selection_id, $selection_name, $screen_id, $screen_name);
  while ( ($selection_id, $selection_name, $screen_id, $screen_name)  
           = $csr->fetchrow_array )
  {
     print "<option value=$selection_id>"
         . "$selection_name</option>\n";
  }

 #
 #  End of drop-down menu
 #
  print "</select>\n";
  print "<p /><input type=submit value=\"Show criteria\">\n";
  print "</form>\n";

  $csr->finish(); 

}

###########################################################################
#
#  Subroutine report12.
#
#  Mockup of list of selection sets - New
#
###########################################################################
sub report12 {

  my ($lda) = @_;  # Get arguments
  my $screen_id = 1;  # Authorizations list
  my $kerberos_name = $k_principal;

  if ($g_show_tech_notes) {
      print "Here we are in subroutine 'report12'...<BR>\n";
  }

 #
 # Start a SELECT statement
 #
     my $stmt = "select distinct ss.selection_id, ss.selection_name, 
                        ss.screen_id, sn.screen_name, ss.sequence,
                        IFNULL(uss.default_flag, 'N')
                 from screen2 sn, selection_set2 ss left outer join user_selection_set2 uss ON ( uss.selection_id = ss.selection_id and  uss.apply_username = '$kerberos_name')
                 where sn.screen_id = ss.screen_id
                 and ss.screen_id = '$screen_id'
                 and not exists (select u2.selection_id 
                        from user_selection_set2 u2
                        where u2.selection_id = ss.selection_id
                        and u2.apply_username = '$kerberos_name'
                        and u2.hide_flag = 'Y')
                 order by ss.sequence, ss.selection_id";
     if ($g_show_tech_notes)
 	{print "stmt = '$stmt'<BR>";}
     my $csr = $lda->prepare($stmt); 

     $csr->execute; 


 #
 #  Print a table showing the results.  Save selection_id's and selection
 #  names so we can build a pull-down menu
 #
  my ($selection_id, $selection_name, $screen_id, $screen_name, $sort_order,
      $is_default);
  my @s_id_list, @s_name_list;
  if ($g_show_tech_notes) {
    print "<p /><table border>\n";
    print "<tr><th>selection_id</th><th>selection_name</th>"
        . "<th>sort order</th><th>is default</th></tr>";
  }
  while ( ($selection_id, $selection_name, $screen_id, $screen_name,
           $sort_order, $is_default)  
           = $csr->fetchrow_array )
  {
      push(@s_id_list, $selection_id);
      push(@s_name_list, $selection_name);
      if ($g_show_tech_notes) {
          print "<tr><td>$selection_id</td><td>$selection_name</td>"
	      . "<td>$sort_order</td><td>$is_default</td></tr>\n";
      }
  }
  if ($g_show_tech_notes) {  print "</table>\n"; }

 #
 #  Print the list of selection sets
 #  
  print "<form action=\"\">\n";
  print "<input type=hidden name=web_page value=\"13\">\n";
  print 
   "<input type=hidden name=\"show_tech_notes\" value=\"$show_tech_notes\">\n";
  print "<select name=selection_id>\n";
  my $n = @s_id_list;
  for ($i=0; $i < $n; $i++) {
      print "<option value=$s_id_list[$i]>"
         . "$s_name_list[$i]</option>\n";
  }
  print "</select>\n";
  print "<p /><input type=submit value=\"Show criteria\">\n";
  print "</form>\n";

  $csr->finish(); 

}


###########################################################################
#
#  Subroutine report3.
#
#  Show criteria/value pairs
#
###########################################################################
sub report3 {

  my ($lda, $selection_id) = @_;  # Get arguments
  my $kerberos_name = 'REPA';

  print "Here we are in Report 3...<BR>";
  print "Selection_id = $selection_id<BR>";

 #
 # Start a SELECT statement to get the selection_name for the given
 # selection set
 #
     my $stmt0 = "select selection_name from selection_set 
                  where selection_id = ?";
     my $csr0 = $lda->prepare($stmt0); 
     $csr0->bind_param(1, $selection_id);
     $csr0->execute; 
     ($selection_name) = $csr0->fetchrow_array;

 #
 # Print a header
 #
     print "<h3>Criteria/value pairs for selection set"
        . " \"$selection_name\"</h3>";
     print "<form action=\"\">\n";
     print "<input type=hidden name=web_page value=\"4\">\n";

     print "<table border>\n";
     print "<tr>"
      . "<th>Criteria ID<br><small>(do not display"
      . "<br>in final version)</small></th>"
      . "<th>&nbsp; &nbsp; &nbsp; &nbsp; </th>"
      . "<th>Apply</th>"
      . "<th>Criteria Name</th>"
      . "<th>Value</th>"
      . "<th>&nbsp; &nbsp; &nbsp; &nbsp; </th>"
      . "<th>No Change"
      . "<br><small>(Do not display<br>in final version)</small></th>"
      . "<th>Pick-list<br>Selection ID<br>"
      . "<small>(Do not display<br>in final version)</small></th>"
      . "</tr>\n";

 #
 # Start a SELECT statement to get criteria info for the given selection set
 #
     my $stmt = "select ss.selection_id selectionId, ss.selection_name, ss.screen_id screenId,
                        sn.screen_name, ci.criteria_id, c.criteria_name,
                        ci.apply, ci.next_scrn_selection_id,
                        ci.value, ci.no_change, c.sql_fragment, ci.sequence sequence
                 from selection_set ss, screen sn, criteria_instance ci,
                      criteria c
                 where sn.screen_id = ss.screen_id
                 and ci.selection_id = ss.selection_id
                 and ci.username = 'SYSTEM'
                 and ss.selection_id = ?
                 and c.criteria_id = ci.criteria_id
                 order by screenId, selectionId, sequence"; 
         
     my $csr = $lda->prepare($stmt); 

     $csr->bind_param(1, $selection_id);
     #$csr->bind_param(":end_date", $end_date); 
     $csr->execute; 


 #
 #  Print rows of the table
 #
  my ($selection_id, $selection_name, $screen_id, $screen_name,
      $criteria_id, $criteria_name, $apply, $pick_screen,
      $value, $no_change, $sql_frag);
  my $prev_screen_id = '';
  my $prev_selection_id = '';
  my %criteria2sql_frag;
  while ( ($selection_id, $selection_name, $screen_id, $screen_name, 
           $criteria_id, $criteria_name, $apply, $pick_screen,
           $value, $no_change, $sql_frag)  
           = $csr->fetchrow_array )
  {
     unless ($criteria_id eq '0') {
       $criteria2sql_frag{$criteria_id} = $sql_frag;
     }
     my $temp_apply = &get_apply_string($criteria_id, $apply, $no_change);
     my $temp_value = &get_value_string($criteria_id, $value, $no_change, 
                                        $kerberos_name);
     if ($value eq '' || $value eq ' ') {$value = '&nbsp;';}
     $value =~ s/</&lt;/g;
     $value =~ s/>/&gt;/g;
     print "<tr>"
         . "<td>$criteria_id</td>"
         . "<td>&nbsp;</td>"
         . "<td>$temp_apply</td>"
         . "<td>$criteria_name</td>"
         . "<td>$temp_value</td>"
         . "<td>&nbsp;</td>"
         . "<td>$no_change</td>"
         . "<td>$pick_screen</td>"
         . "</tr>\n";
   }

 #
 #  End of table
 #
  print "</table>\n";
  print "<p /><input type=submit value=\"Find matching authorizations\">\n";
  print "</form>\n";

}

###########################################################################
#
#  Subroutine report13.
#
#  Show criteria/value pairs (new tables)
#
###########################################################################
sub report13 {

  my ($lda, $selection_id) = @_;  # Get arguments
  my $kerberos_name = $k_principal;

  if ($g_show_tech_notes) {
    print "Here we are in subroutine report13...<BR>";
    print "Selection_id = $selection_id<BR>";
  }

 #
 # Start a SELECT statement to get the selection_name for the given
 # selection set
 #
     my $stmt0 = "select selection_name from selection_set2 
                  where selection_id = ?";
     my $csr0 = $lda->prepare($stmt0); 
     $csr0->bind_param(1, $selection_id);
     $csr0->execute; 
     ($selection_name) = $csr0->fetchrow_array;

 #
 # Start a SELECT statement to get criteria info for the given selection set
 #
                 #and usc.username(+) = '$kerberos_name'
                 #and usc.selection_id(+) = ci.selection_id
                 #and usc.criteria_id(+) = ci.criteria_id
     my $stmt = "select ss.selection_id selectionId, ss.selection_name, ss.screen_id screenId,
                        sn.screen_name, ci.criteria_id, c.criteria_name,
                        IFNULL(usc.apply, ci.default_apply),
                        ci.next_scrn_selection_id,
                        IFNULL(usc.value, ci.default_value),
                        ci.no_change, c.sql_fragment, ci.sequence sequenceId
                 from selection_set2 ss, screen2 sn, 
                      criteria2 c, selection_criteria2 ci left outer join user_selection_criteria2 usc ON (usc.criteria_id = ci.criteria_id and  usc.selection_id= ci.selection_id and  usc.username = '$kerberos_name')
                 where sn.screen_id = ss.screen_id
                 and ci.selection_id = ss.selection_id
                 and ss.selection_id = ?
                 and c.criteria_id = ci.criteria_id
                 order by screenId, selectionId, sequenceId"; 
     if ($g_show_tech_notes) { print "SQL statement = '$stmt'<BR>\n"; }
     my $csr = $lda->prepare($stmt); 

     $csr->bind_param(1, $selection_id);
     #$csr->bind_param(":end_date", $end_date); 
     $csr->execute; 

 #
 # Print a header
 #
     print "<h3>Criteria/value pairs for selection set $selection_id:"
        . " \"$selection_name\"</h3>";
     print "<form action=\"\">\n";
     print "<input type=hidden name=web_page value=\"14\">\n";
     print 
       "<input type=hidden name=show_tech_notes value=\"$show_tech_notes\">\n";

     print "<p /><table border>\n";
     print "<tr>"
      . "<th bgcolor=\"#E0E0E0\">Criteria ID<br><small>(do not display"
      . "<br>in final version)</small></th>"
      . "<th bgcolor=\"#E0E0E0\">&nbsp; &nbsp; &nbsp; &nbsp; </th>"
      . "<th>Apply</th>"
      . "<th>Criteria Name</th>"
      . "<th>Value</th>"
      . "<th bgcolor=\"#E0E0E0\">&nbsp; &nbsp; &nbsp; &nbsp; </th>"
      . "<th bgcolor=\"#E0E0E0\">No Change"
      . "<br><small>(Do not display<br>in final version)</small></th>"
      . "<th bgcolor=\"#E0E0E0\">Pick-list<br>Selection ID<br>"
      . "<small>(Do not display<br>in final version)</small></th>"
      . "</tr>\n";

 #
 #  Print rows of the table
 #
  my ($selection_id, $selection_name, $screen_id, $screen_name,
      $criteria_id, $criteria_name, $apply, $pick_screen,
      $value, $no_change, $sql_frag);
  my $prev_screen_id = '';
  my $prev_selection_id = '';
  my %criteria2sql_frag;
  ## Here ##
  while ( ($selection_id, $selection_name, $screen_id, $screen_name, 
           $criteria_id, $criteria_name, $apply, $pick_screen,
           $value, $no_change, $sql_frag)  
           = $csr->fetchrow_array )
  {
     unless ($criteria_id eq '0') {
       $criteria2sql_frag{$criteria_id} = $sql_frag;
     }
     my $temp_apply = &get_apply_string($criteria_id, $apply, $no_change);
     #print "criteria_id=$criteria_id value='$value'<BR>";
     my $temp_value = &get_value_string($criteria_id, $value, $no_change, 
                                        $kerberos_name);
     if ($value eq '' || $value eq ' ') {$value = '&nbsp;';}
     $value =~ s/</&lt;/g;
     $value =~ s/>/&gt;/g;
     print "<tr>"
         . "<td bgcolor=\"#E0E0E0\">$criteria_id</td>"
         . "<td bgcolor=\"#E0E0E0\">&nbsp;</td>"
         . "<td>$temp_apply</td>"
         . "<td>$criteria_name</td>"
         . "<td>$temp_value</td>"
         . "<td bgcolor=\"#E0E0E0\">&nbsp;</td>"
         . "<td bgcolor=\"#E0E0E0\">$no_change</td>"
         . "<td bgcolor=\"#E0E0E0\">$pick_screen</td>"
         . "</tr>\n";
   }

 #
 #  End of table
 #
  print "</table>\n";
  print "<p /><input type=submit value=\"Find matching authorizations\">\n";
  print "</form>\n";

}

###########################################################################
#
#  Subroutine report4.
#
#  Display criteria_id/criteria_value pairs from previous screen.
#
###########################################################################
sub report4 {

  my ($lda) = @_;  # Get Oracle login handle.

  print "Here we are in report 4.<BR>";

  my %criteria_value;
  &get_criteria_form_variables(\%criteria_value);
  foreach $key (keys %criteria_value) {
      print "Criteria ID '$key' -> value '$criteria_value{$key}'<BR>";
  }

}

###########################################################################
#
#  Subroutine report14.
#
#  Display criteria_id/criteria_value pairs from previous screen.
#  Then run a stored procedure to get a SELECT statement for 
#  Authorizations.
#
###########################################################################
sub report14 {

  my ($lda) = @_;  # Get Oracle login handle.

  if ($g_show_tech_notes) { 
    print "Here we are in subroutine report14.<BR>"; 
  }
 
  my %criteria_value;
  &get_criteria_form_variables(\%criteria_value);
  $g_max_criteria = 20;
  my @crit_id = ('0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 
                 '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
  my @crit_value = (' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 
                  ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ');
  my $num_criteria = 0;
  my %crit_id2sql_frag;
  &get_crit_id2sql_frag($lda, \%crit_id2sql_frag);

  foreach $key (sort keys %criteria_value) {
      if ($g_show_tech_notes) {
        print "Criteria ID '$key' -> value '$criteria_value{$key}'"
          . " -> SQL frag '$crit_id2sql_frag{$key}'<BR>";
      }
      $crit_id[$num_criteria] = $key;
      $crit_value[$num_criteria] = $criteria_value{$key};
      $num_criteria++;
  }
 
  if ($g_show_tech_notes) {
    print "There are $num_criteria criteria/value pairs in effect.<BR>\n";
  }

  #
  #  Call the stored procedure to get the SELECT statement
  #
    my $stmt = 
               'CALL rolessrv.get_auth_general_sql (
                  ?,
                  ?,
                  ?,
                  ?, ?,
		  ?,?,
                  ?, ?,
                  ?, ?,
                  ?, ?,
                  ?,?, 
                  ?, ?,
                  ?, ?,
                  ?, ?,
                  ?, ?,
                  ?, ?,
                  ?, ?,
                  ?, ?,
                  ?, ?,
                  ?, ?,
                  ?, ?,
                  ?, ?,
                  ?, ?,
                  ?, ?,
                  ?, ?,
                  @error_no, 
                  @error_msg,
                  @sql_statement)';

    #print @stmt;
    #print "<BR>";
   
    my $csr = $lda->prepare($stmt)
	 || &web_error("Error preparing statement (get_auth_general_sql).<BR>"
                . $lda->errstr . "<BR>");
   
    my ($error_no, $error_msg, $sql_statement);

    $csr->bind_param(1, $g_server_user);
    $csr->bind_param(2, $k_principal);
    $csr->bind_param(3, $num_criteria);
    $csr->bind_param(4,$crit_id[0]);
    $csr->bind_param(5, $crit_value[0]);
    $csr->bind_param(6, $crit_id[1]);
    $csr->bind_param(7, $crit_value[1]);
    $csr->bind_param(8, $crit_id[2]);
    $csr->bind_param(9, $crit_value[2]);
    $csr->bind_param(10, $crit_id[3]);
    $csr->bind_param(11, $crit_value[3]);
    $csr->bind_param(12, $crit_id[4]);
    $csr->bind_param(13, $crit_value[4]);
    $csr->bind_param(14,$crit_id[5]);
    $csr->bind_param(15, $crit_value[5]);
    $csr->bind_param(16,$crit_id[6]);
    $csr->bind_param(17, $crit_value[6]);
    $csr->bind_param(18, $crit_id[7]);
    $csr->bind_param(19,$crit_value[7]);
    $csr->bind_param(20,$crit_id[8]);
    $csr->bind_param(21,$crit_value[8]);
    $csr->bind_param(22,$crit_id[9]);
    $csr->bind_param(23,$crit_value[9]);
    $csr->bind_param(24,$crit_id[10]);
    $csr->bind_param(25,$crit_value[10]);
    $csr->bind_param(26,$crit_id[11]);
    $csr->bind_param(27,$crit_value[11]);
    $csr->bind_param(28,$crit_id[12]);
    $csr->bind_param(29,$crit_value[12]);
    $csr->bind_param(30,$crit_id[13]);
    $csr->bind_param(31,$crit_value[13]);
    $csr->bind_param(32,$crit_id[14]);
    $csr->bind_param(33,$crit_value[14]);
    $csr->bind_param(34,$crit_id[15]);
    $csr->bind_param(35,$crit_value[15]);
    $csr->bind_param(36,$crit_id[16]);
    $csr->bind_param(37,$crit_value[16]);
    $csr->bind_param(38,$crit_id[17]);
    $csr->bind_param(39,$crit_value[17]);
    $csr->bind_param(40,$crit_id[18]);
    $csr->bind_param(41,$crit_value[18]);
    $csr->bind_param(42,$crit_id[19]);
    $csr->bind_param(43,$crit_value[19]);
    #$csr->bind_param_inout(44, \$error_no, 512);
    #$csr->bind_param_inout(45, \$error_msg, 512);
    #$csr->bind_param_inout(46,\$sql_statement, 32000);
    #print "After last bind_param_inout...<BR>";
    $csr->execute;
    #print "After execute...<BR>";

    my $err = $lda->err;
    my $errstr = $lda->errstr;
    if ($g_show_tech_notes) { print "errstr='$errstr'<BR>"; }
  
    $errstr =~ /\: ([^\n]*)/;
  
    my $shorterr = $1;
 

  my $csr1 = $lda->prepare(' select @sql_statement  ');
    $csr1->execute ;
    $sql_statement = $csr1->fetchrow_array();
    $csr1->finish ;


    $csr->finish;
    #print "After finish (err='$err')...<BR>";
  
    if ($err) {
	# Error. Display the error message and put the form back up.
	print "$shorterr Error Number $err";
        die;
    }
  
    if ($g_show_tech_notes) {  
      print "SQL statement = <BR>" . $sql_statement . "<br>";
    }
    &display_auths($lda, $sql_statement);

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

###########################################################################
#
#  Subroutine verify_special_report_auth.
#
#  Verify's that $k_principal is allowed to run special administrative
#  reports for the Roles DB. Return's 1 if $k_principal is allowed,
#  0 otherwise.
#
###########################################################################
sub verify_special_report_auth {
    my ($lda, $k_principal) = @_;
    my ($csr, @stmt, $result);
    if (!$k_principal) {
        return 0;
    }
    $stmt = "select ROLESAPI_IS_USER_AUTHORIZED('$k_principal',"
             . "'RUN ADMIN REPORTS', 'NULL') from dual";
    $csr = $lda->prepare($stmt)
        || die $DBI::errstr;
     $csr->execute()
        || die $DBI::errstr;

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
#  Subroutine display_auths($lda, $sql_statement)
#
#  Runs a custom-generated SELECT statement and displays the resulting
#  authorizations.
#
###########################################################################
sub display_auths {
  my ($lda, $sql_statement) = @_;
  my ($csr, $result);

  #
  #  Adjust date format for three columns within the string
  #
  #my $fmt = "'mm\/dd\/yyyy'";
  my $fmt = "'%m\/%d\/%Y'";
  $sql_statement =~ s/a.effective_date, a.expiration_date/DATE_FORMAT(a.effective_date, $fmt), DATE_FORMAT(a.expiration_date, $fmt)/;
  $sql_statement =~ 
     s/a.modified_date from/DATE_FORMAT(a.modified_date, $fmt) from/;
  print "<p />'$sql_statement'<p />";

  unless ($csr = $lda->prepare( $sql_statement)) {
      print "DB error '$DBI::errstr'<BR>";
      die $DBI::errstr;
  }

  $csr->execute();
  my ($kerberos_name, $function_category, $function_name, $qualifier_code,
      $qualifier_name, $is_active, $grant_authorization, $auth_id, 
      $function_id, $qualifier_id, $do_function, $effective_date,
      $expiration_date, $modified_by, $modified_date);

  print "<p /><HR /><b>Here is the resulting list of authorizations:</b>\n";
  print "<p /><table border nowrap>\n";
  print "<tr><th>Kerberos name</th><th>Category</th><th>Function name</th>"
        . "<th>Qualifier code</th>"
        . "<th>Can grant</th><th>Can do</th>"
        . "<th>Effective from</th><th>Is active today</th>"
        . "<th>Modified by</th><th>Modified date</th><tr>\n";


  my $n = 0;
  while ( ($kerberos_name, $function_category, $function_name, $qualifier_code,
           $qualifier_name, $is_active, $grant_authorization, $auth_id, 
           $function_id, $qualifier_id, $do_function, $effective_date,
           $expiration_date, $modified_by, $modified_date)
          = $csr->fetchrow_array() ) 
  {
     my $dates_string = "$effective_date - $expiration_date";
     print "<tr><td>$kerberos_name</td><td>$function_category</td>"
           . "<td>$function_name</td>"
           . "<td>$qualifier_code</td>"
           . "<td>$grant_authorization</td><td>$do_function</td>"
	   . "<td>$dates_string</td><td>$is_active</td>"
           . "<td>$modified_by</td><td>$modified_date</td></tr>\n";
     $n++;
  }

  print "</table>\n";
  print "Number of authorizations displayed = $n<BR>";
  $csr->finish() || die "can't close cursor";


}


###########################################################################
#
#  Subroutine get_qualifier_auth_info($lda, \%qual2category, 
#                                     \%qual_category2count);
#
###########################################################################
sub get_qualifier_auth_info {
  my ($lda, $rqual2category, $rqual_category2count) = @_;
  
  #
  #  Open cursor to select statement
  #
  my $stmt = "SELECT a.qualifier_id,
               COUNT(b.qualifier_id) number_of_auths,
               IFNULL(b.function_category,' ') function_category
               FROM qualifier a LEFT OUTER JOIN AUTHORIZATION b
                ON (a.qualifier_id = IFNULL(b.qualifier_id,0))
               AND status ='I'
               GROUP BY a.qualifier_id,b.function_category";
  #print "'$stmt'<BR>";
  my $csr = $lda->prepare( $stmt)
	|| die $DBI::errstr;
  
  $csr->execute();
  #
  #  Get a list of qualifier_id and related information
  #
  my ($qualifier_id, $number_of_auths, $function_category);
  while ( ($qualifier_id, $number_of_auths, $function_category) 
        = $csr->fetchrow_array() ) {
      if ($$rqual2category{$qualifier_id}) {
        $$rqual2category{$qualifier_id} .= "$g_delim$function_category";
      }
      else {
        $$rqual2category{$qualifier_id} = $function_category;
      }
    $$rqual_category2count {"$qualifier_id$g_delim$function_category"} = $number_of_auths; 
  }

  $csr->finish() || die "can't close cursor";

}

###########################################################################
#
#  Subroutine get_crit_id2sql_frag($lda, \%crit_id2sql_frag);
#
#  Fill in the hash %crit_id2sql_frag (criteria_id -> sql fragment)
#
###########################################################################
sub get_crit_id2sql_frag {
  my ($lda, $rcrit_id2sql_frag) = @_;
  
  #
  #  Open cursor to select statement
  #
  my $stmt = "SELECT c.criteria_id, c.sql_fragment
               FROM criteria2 c
               order BY criteria_id";
  #print "'$stmt'<BR>";
  my $csr = $lda->prepare( $stmt);
  $csr->execute();
  unless ($csr) {
      print "Oracle error '$DBI::errstr'<BR>";
      die $DBI::errstr;
  }
  
  #
  #  Get a list of qualifier_id and related information
  #
  my ($crit_id, $sql_frag);
  while ( ($crit_id, $sql_frag) = $csr->fetchrow_array() ) {
    $$rcrit_id2sql_frag{$crit_id} = $sql_frag;
  }

  $csr->finish() || die "can't close cursor";

}

###########################################################################
#
#  Function &web_string($astring)
#
#  Converts spaces to '+', left parentheses to %28,
#   right parentheses to %29, '&' to %28
#
###########################################################################
sub web_string {
    my ($astring) = $_[0];
    $astring =~ s/ /+/g;
    $astring =~ s/\(/\%28/g;
    $astring =~ s/\)/\%29/g;
    $astring =~ s/\&/\%26/g;
    $astring;
}

###########################################################################
#
#  Function &get_apply_string($criteria_id, $apply, $no_change)
#
#  Returns either an input string of type "checkbox" or a 
#  simple text string plus a hidden input.
#
###########################################################################
sub get_apply_string {
    my ($criteria_id, $apply, $no_change) = @_;
    my $temp_string;
    if ($no_change eq 'Y') {
      my $temp_apply = ($apply eq 'Y') ? "[x]" : "[ ]";
      $temp_string = "$temp_apply<input type=hidden "
          . " name=\"apply_crit$criteria_id\" value=\"$apply\">";
    }
    else {
        my $checked = ($apply eq 'Y') ? 'checked' : '';
	$temp_string = "<input type=checkbox name=\"apply_crit$criteria_id\""
	    . " $checked>";
    }
    return $temp_string;
}

###########################################################################
#
#  Function &get_value_string($criteria_id, $value, $no_change, $kerbname)
#
#  Returns a CGI form string containing either a text field or a
#  hidden form variable.
#
###########################################################################
sub get_value_string {
    my ($criteria_id, $value, $no_change, $kerbname) = @_;
    my $temp_string;
    my $temp_value = ($value eq '<me>') ? $kerbname : $value;
    if ($no_change eq 'Y') {
      $temp_string = "&nbsp;&nbsp;$temp_value<input type=hidden "
          . " name=\"value_crit$criteria_id\" value=\"$temp_value\"> "; 
    }
    else {
	$temp_string = "&nbsp;&nbsp;"
            . "<input type=text name=\"value_crit$criteria_id\""
	    . " value=\"$temp_value\">&nbsp;&nbsp;";
    }
    return $temp_string;
}

###########################################################################
#
#  Function &get_criteria_form_variables(\%criteria_value)
#
#  Looks in form variables to find all "criteria" where apply_critNNN = 'Y'.
#  Set $criteria_value{NNN} = $value for each of these.
#
###########################################################################
sub get_criteria_form_variables {
    my ($rcriteria_value) = @_;
    foreach $key (keys %formval) {
        #print "All variables $key -> $formval{$key}<BR>";
        if ($key =~ /^apply_crit/) {
	    my $criteria_id = substr($key, 10);
            if ($formval{$key}) {
		my $form_variable = 'value_crit' . $criteria_id;
                my $value = $formval{$form_variable};
                $$rcriteria_value{$criteria_id} = $value;
            }
        }
    }
}



