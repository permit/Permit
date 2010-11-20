#!/usr/bin/perl
###########################################################################
#
#  CGI script to look up information about a person or people matching
#  a given last_name or kerberos_name.
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
#  Written 2/11/99, Jim Repa
#  Modified 9/29/99, Jim Repa (hide non 9* MIT ID numbers for Other people)
#  Modified 3/15/00, Jim Repa (don't require meta-auth; improve auth links)
#  Modified 3/16/01, Hide MIT ID numbers.
#  Modified 8/21/2001, Use rolesweb.pm instead of rolesweb2.pm
#  Modified 2/22/2002, Change rolesweb2.pm back to rolesweb.pm, show list
#                      of categories a person has auths. in, add showid
#                      option for displaying MIT ID numbers.
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
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm
use rolesweb('get_viewable_categories'); #Use sub. in rolesweb.pm
use rolesweb('web_error'); #Use sub. in rolesweb.pm
use rolesweb('strip'); #Use sub. in rolesweb.pm
 
#
#  Set constants
#
 $host = $ENV{'HTTP_HOST'};
 # URL to look up org unit
 $url_stem2 
  = "http://$host/cgi-bin/roleparent.pl?qualtype=ORGU+Org.+Unit+-+Personnel&";
 # URL to look up student organization
 $url_stem2a 
  = "http://$host/cgi-bin/roleparent.pl?qualtype=SISO+&";
 # Stem for a url for a users's authorizations
 $url_stem3 = "/cgi-bin/my-auth.cgi?&FORM_LEVEL=1&";  
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
$kerb_last_name = $formval{'name'};  # Get value set in &parse_forms()
$kerb_last_name =~ tr/a-z/A-Z/;
$show_mitid = $formval{'showid'};
$secret = $formval{'secret'};  # Get secret word. (To show MIT ID for 'other')
 
#
#  Start printing HTML document
#
 $title = "Look up person information for $kerb_last_name";
 print "Content-type: text/html", "\n\n";
 print "<HTML>", "\n";
 print "<HEAD><TITLE>$title</TITLE></HEAD>", "\n";
 
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
#  Get set to use DB.
#
use DBI;
$lda = login_dbi_sql('roles') || &web_error("$DBI::errstr");
 
#
# Login into the database
# 
 
#
#  Get a list of categories for which the requestor is allowed to view
#  authorizations
#
 &get_viewable_categories($lda, $k_principal, \%gviewable_cat);
 
#
#  Print out beginning of the header
#
 print '<BODY bgcolor="#fafafa">';
 &print_header($title, 'https');
 
#
#  Make sure the requestor is allowed to view at least some authorizations.
#  If not, print error message and stop.
#
 if (scalar(keys %gviewable_cat) < 1) {
   $lda->disconnect();
   &web_error('You must be an MIT employee or have perMIT viewing'
              . ' authorizations to look up people using this'
              . ' facility.<BR>');
 } 
 
 print "<P><small>",
       "Below is a list of people whose last name or Kerberos username",
       " matches $kerb_last_name. ";
 if ($gviewable_cat{'ALL'}) {
   print "Click on a Kerberos username to see",
       " a list of authorizations for that person in all",
       " categories.";
 }
 elsif ($gviewable_cat{'ALLNS'}) {
   print "Click on a Kerberos username to see",
       " a list of authorizations for that person in all non-sensitive",
       " categories.";
 }
 print " Click on a department name to see where the department fits",
       " in the Organization Unit hierarchy.";
 if (scalar(keys %gviewable_cat)) {
   print " You can view authorizations in any highlighted category for a user",
       " by clicking on the category code.";
 }
 print "</small><HR>", "\n";
 #print "Viewable categories ($k_principal):<BR>\n";
 #foreach $vcat (sort keys %gviewable_cat) {
 #  print "$vcat<BR>\n";
 #}
 
#
#  Get person information. 
#  This routine fills in the arrays @gname, @gkerbname, @gemail, @gperson_type,
#    @gdept_code, @gdept_name, @gmitid, and @gauthcat
#
 &get_person_info($lda, $kerb_last_name);
 #$n = @gname;
 #for ($i = 0; $i < $n; $i++) {
 #  print "$gname[$i] $gkerbname[$i]<BR>\n";
 #}
 
#
#  Print out person information.
#  This routine uses arrays @gname, @gkerbname, etc.
#
 &print_person_info($kerb_last_name);
 
#
#  Drop connection to Oracle.
#
   $lda->disconnect()
		 || &web_error("can't log off Oracle");    
 
#
# Print bottom of web page.
#
 print "<HR>";
 print "<A HREF=\"$main_url\"><small>Back to main perMIT web interface page"
       . "</small></A>";
 
 print "</BODY></HTML>", "\n";
 exit(0);
 
###########################################################################
#
#  Subroutine get_person_info
#
###########################################################################
sub get_person_info {
  my ($lda, $kerb_last_name) = @_;
  my (@stmt, $lookname, $csr, $dept_string,
      $name, $kerbname, $email, $person_type, 
      $dept_code, $dept_name, $mitid, $authcat,
      $temp_authcat);
  
  #
  #  Open a cursor for a select statement
  #
  $lookname = $kerb_last_name;
  $lookname =~ s/'/''/g;   # Fix for Ted Ts'o
  @stmt = ("select distinct initcap(last_name) || ', ' || initcap(first_name),"
    . " p.kerberos_name, email_addr,"
    . " decode(status_code, 'A', '', 'inactive ')"
    . " || decode(primary_person_type,'E','employee','S','student','other'),"
    . " dept_code, initcap(q.qualifier_name), p.mit_id, a.function_category"
    . " from person p, qualifier q, authorization a"
    . " where p.kerberos_name = '$lookname'"
    . " and p.primary_person_type <> 'S'"
    . " and p.dept_code = q.qualifier_code(+)"
    . " and q.qualifier_type(+) = 'ORGU'"
    . " and a.kerberos_name(+) = p.kerberos_name"
    . " union select distinct initcap(last_name)||', ' || initcap(first_name),"
    . " p.kerberos_name, email_addr,"
    . " decode(status_code, 'A', '', 'inactive ')"
    . " || decode(primary_person_type,'E','employee','S','student','other'),"
    . " dept_code, initcap(q.qualifier_name), p.mit_id, a.function_category"
    . " from person p, qualifier q, authorization a"
    . " where last_name = '$lookname'"
    . " and p.primary_person_type <> 'S'"
    . " and p.dept_code = q.qualifier_code(+)"
    . " and q.qualifier_type(+) = 'ORGU'"
    . " and a.kerberos_name(+) = p.kerberos_name"
    . " union"
    . " select distinct initcap(last_name) || ', ' || initcap(first_name),"
    . " p.kerberos_name, email_addr,"
    . " decode(status_code, 'A', '', 'inactive ')"
    . " || decode(primary_person_type,'E','employee','S','student','other'),"
    . " dept_code, initcap(q.qualifier_name), p.mit_id, a.function_category"
    . " from person p, qualifier q, authorization a"
    . " where p.kerberos_name = '$lookname'"
    . " and p.primary_person_type = 'S'"
    . " and p.dept_code = q.qualifier_code(+)"
    . " and q.qualifier_type(+) = 'SISO'"
    . " and a.kerberos_name(+) = p.kerberos_name"
    . " union select distinct initcap(last_name)||', ' || initcap(first_name),"
    . " p.kerberos_name, email_addr,"
    . " decode(status_code, 'A', '', 'inactive ')"
    . " || decode(primary_person_type,'E','employee','S','student','other'),"
    . " dept_code, initcap(q.qualifier_name), p.mit_id, a.function_category"
    . " from person p, qualifier q, authorization a"
    . " where last_name = '$lookname'"
    . " and p.primary_person_type = 'S'"
    . " and p.dept_code = q.qualifier_code(+)"
    . " and q.qualifier_type(+) = 'SISO'"
    . " and a.kerberos_name(+) = p.kerberos_name"
    . " order by 1, 2");
 
  #print @stmt;
  #print "<P>";
  $csr = &ora_open($lda, "@stmt")
  	|| &web_error($ora_errstr);
  $csr = $lda->prepare("$stmt") or &web_error( "$DBI::errstr");
  $csr->execute();
   
  my $prev_kerbname = '';
  while ( ($name, $kerbname, $email, $person_type, $dept_code, $dept_name, 
           $mitid, $authcat) = $csr->fetchrow_array()  ) {
    if ($prev_kerbname ne $kerbname) {
      $email =~ tr/A-Z/a-z/;
      $dept_name = &fix_name($dept_name);
      $name =~ s/ Ii,/ II,/;  $name =~ s/ Iii,/ III,/;
      $name =~ s/ Iv,/ IV,/;
      if ($name =~ /^Mc/) {substr($name, 2, 1) =~ tr/a-z/A-Z/;}
      if (($person_type =~ /other$/) && (substr($mitid,0,1) ne '9')
           && (substr($mitid,0,3) ne '777') #Hide SSNs
           && ($secret ne 'abracadabra')) { $mitid = '*********'; }
      push(@gname, $name);
      push(@gkerbname, $kerbname);
      push(@gemail, $email);
      push(@gperson_type, $person_type);
      push(@gdept_code, $dept_code);
      #unless ($dept_name) {
      #  $dept_name = $dept_code;
      #}
      push(@gdept_name, $dept_name);
      push(@gmitid, $mitid);
      push(@gauthcat, &strip($authcat));
      $prev_kerbname = $kerbname;
    }
    else {
      $temp_authcat = pop(@gauthcat);
      push(@gauthcat, $temp_authcat . ' ' . $authcat);
    }
  }
  $csr->finish() || &web_error("can't close cursor");
 
}
 
###########################################################################
#
#  Subroutine print_person_info
#
###########################################################################
sub print_person_info {
  my ($kerb_last_name) = @_;
  my ($dept_string, $name, $kerbname, $email, $person_type, 
      $dept_code, $dept_name, $mitid, $authcat, $cat_string);
  my $count = 0;
 
 #
 #  Start printing out a table
 #  
  print "<TABLE>";
  my $fmt = "<TR><TH align=left>%s</TH><TH align=left>%s</TH>"
        . "<TH align=left>%s</TH><TH align=left>%s</TH>"
        . "<TH align=left>%s</TH>"
        . "<TH align=left>%s</TH><TH align=left>%s</TH>"
        . "<TH align=left>%s</TH></TR>";
  
 #
 #  Start looping through the arrays.
 #
  $n = @gname;
  for ($i = 0; $i < $n; $i++) {
    ($name, $kerbname, $email, $person_type, 
     $dept_code, $dept_name, $mitid, $authcat)
     = ($gname[$i], $gkerbname[$i], $gemail[$i], $gperson_type[$i], 
        $gdept_code[$i], $gdept_name[$i], $gmitid[$i], $gauthcat[$i]);
    if ($i == 0) {
      if ($show_mitid eq '1') {
        printf $fmt,
               'Name', 'Kerberos<br>name', 'MIT<BR>ID',
               'Person<BR>type', 'Dept.<BR>name',  'Email<BR>address',
               'Auths. in<BR>Category';
      }
      else {
        printf $fmt,
               'Name', 'Kerberos<br>name',
               'Person<BR>type', 'Dept.<BR>name',  'Email<BR>address',
               'Auths. in<BR>Category';
      }
      $fmt =~ s/TH/TD/g;
    }
    $email =~ tr/A-Z/a-z/;
    $dept_name = &fix_name($dept_name);
    # If the found user has auths., and if requestor can view all categories...
    if ($authcat && $gviewable_cat{'ALL'}) {
      $kerb_string = "<A HREF=\"${url_stem3}category="
                       . &web_string("ALL " . $gviewable_cat{'ALL'})
                       . "&username=$kerbname\">$kerbname</A>";
    }
    elsif ($authcat && $gviewable_cat{'ALLNS'}) {
      $kerb_string = "<A HREF=\"${url_stem3}category="
                       . &web_string("ALLNS " . $gviewable_cat{'ALLNS'})
                       . "&username=$kerbname\">$kerbname</A>";
    }
    else {
      $kerb_string = $kerbname;
    }
    if ($dept_code) {
      if ($person_type eq 'student') {
        $dept_string = "<A HREF=\"${url_stem2a}qualcode=$dept_code\">"
                     . "$dept_name</A>";
      }
      else {
        $dept_string = "<A HREF=\"${url_stem2}qualcode=$dept_code\">"
                     . "$dept_name</A>";
      }
    }
    else {$dept_string = ' ';}
    $name =~ s/ Ii,/ II,/;  $name =~ s/ Iii,/ III,/;
    if ($name =~ /^Mc/) {substr($name, 2, 1) =~ tr/a-z/A-Z/;}
    $cat_string = &format_cat_string($authcat, $kerbname);
    if ($show_mitid eq '1') {
      printf $fmt,    
             $name, $kerb_string, $mitid, "<small>$person_type</small>",
             $dept_string, $email, $cat_string;
    }
    else {
      printf $fmt,    
             $name, $kerb_string, "<small>$person_type</small>",
             $dept_string, $email, $cat_string;
    }
    $count++;
  }
  print "</TABLE>";
  print "<P>";
  my $matchword = ($count == 1) ? 'match' : 'matches';
  print "$count $matchword found for $kerb_last_name<BR>";
 
}
 
###########################################################################
#
#  Function &format_cat_string($catlist, $showuser)
#
#  Replaces string of categories with a printable string for html.
#  Put ',<BR>' between subsequent categories.  If the requestor
#  is allowed to view authorizations in a category, put in a 
#  URL to show authorizations for the given $showuser.
#
###########################################################################
sub format_cat_string {
    my ($catlist, $show_user) = @_;
    my @list = split(' ', $catlist);
    my $cat_string = '';
    my $vcat;
    my $count = 0;
    foreach $vcat (@list) {
      if ($count) {$cat_string .= ',<BR>';}
      if ($gviewable_cat{$vcat}) {  # Can requestor view auths in this cat?
        $cat_string .= "<A HREF=\"$url_stem3" . "category="
                       . &web_string("$vcat $gviewable_cat{$vcat}")
                       . "&username=$show_user\">$vcat</A>";
      }
      else {
        $cat_string .= $vcat;
      }
      $count++;
    }
    return $cat_string;
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
#  Function &fix_name($string)
#
#  Fixes up department name that has been processed with
#  initcap function from Oracle.
#
###########################################################################
sub fix_name {
    my ($astring) = $_[0];
    $astring =~ s/'S/'s/g;  # Fix capitalization algorithm
    $astring =~ s/( Of | Of$)/ of /g;  # Fix capitalization algorithm
    $astring =~ s/ Mit / MIT /g;  # Fix capitalization algorithm
    $astring =~ s/^Mit /MIT /g;  # Fix capitalization algorithm
    $astring =~ s/ And / and /g;  # Fix capitalization algorithm
    $astring =~ s/ The / the /g;  # Fix capitalization algorithm
    $astring =~ s/ For / for /g;  # Fix capitalization algorithm
    $astring =~ s/ In / in /g;  # Fix capitalization algorithm
    $astring;
}
 
