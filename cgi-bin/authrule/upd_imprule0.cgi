#!/usr/bin/perl
###########################################################################
#
#  Intermediate page for update procedure call - collecting arguments. 
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
#  Modifications history
#  Who	When		What
#  VSL  07/17/2008	Created	
###########################################################################
#
# Get packages
#
use rolesweb('login_dbi_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
#use CGI;
#use CGI::Pretty ":standard";
use CGI qw/:standard :html3/;
use rolesweb('parse_authentication_info'); #Use sub. parse_authentication_info in rolesweb.pm
use rolesweb('check_auth_source'); #Use sub. check_auth_source in rolesweb.pm
use rolesweb('verify_metaauth_category'); #Use sub. verify_metaauth_category
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm
use rolesweb('strip'); #Use sub. strip in rolesweb.pm
use DBI;

#
#  Print out the first line of the document
#
print "Content-type: text/html", "\n\n";

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
#  Print out the http document header
#
 my $doc_title = 'Update or delete an implied authorization rule';
#.'<a class=info href="#">This is a tooltip <span> an aiding text that appears just when you roll on with the mouse</span></a>';
 my $instructions ='
  <ul>
    <li>To delete this rule, click "Delete Rule" button.<br>&nbsp;
    <li>To update this rule, change the Short Name, Description and/or 
        "Is In Effect"<br> 
        and click "Update Rule" button.<br>&nbsp;
    <li>(To change other fields you must delete the rule and 
         create a new one.)
  </ul>'; 

print start_html(-title => $doc_title, 
                 -style => { -src => '/imprulestyle.css' },
                 -bgcolor=>"#fafafa");
 
&print_header ($doc_title, 'https');

print "<p /><hr />";
print $instructions,"<br>";

#
# Login into the database
#
 $lda = &login_dbi_sql('roles')
      || die $DBI::errstr . "<BR>";
 
#
#  Process form information
#
$request_method = $ENV{'REQUEST_METHOD'};
 if ($request_method eq "GET") {
    #print "Inside request method = GET <br>";
   $input_string = $ENV{'QUERY_STRING'};
 } 
 elsif ($request_method eq "POST") {
   read (STDIN, $input_string, $ENV{'CONTENT_LENGTH'});  # Read input string
 }
 else {
   $input_string = '';  # Error condition 
 }

##########################
# Web stem constants
##########################

 $host = $ENV{'HTTP_HOST'};
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 ($mysubdir=$0) =~ s/^\S*cgi-bin// ; 
 $mysubdir =~ s!/?[^/]*/*$!!; #remove basename
 $url_stem = "https://$host/cgi-bin$mysubdir"; #implied rules url with sub-dir

 %formval = ();  # Hash of reformatted key->variables populated by &parse_forms
 %rawval = ();  # Hash of unformatted key->variables populated by &parse_forms
 &parse_forms($input_string, \%formval, \%rawval); # Call sub. to parse input
 $g_red_star = "<font color=red>*</font>";

#
# Get form variable for rule_id.  (Other information about the rule
# will be read from the database table.)
#
 $rid = $formval{'rid_in'};

#
# Get other info about the rule from the database table
#
  my ($rsn, $rd, $rie, $modified_by, $modified_date) 
     = &get_rule_details($lda, $rid);
  #print "short_name='$rsn' description='$rd', is_in_effect='$rie'<BR>";

### Attention please !  - commented below is a css code for dynamic help, 
### it is now included in the imprulestyle.css (see above call of start_html().
#print '<style>
#a.info{
#position:relative; 
#z-index:24; background-color:#ccc;    color:#000;    text-decoration:none}
#a.info:hover{z-index:25; background-color:#ff0}
#a.info span{display: none}
#a.info:hover span{
 #   display:block;
 #  position:absolute;
 #  top:2em; left:2em; width:15em;
 #  border:1px solid #0cf;
 #  background-color:#cff; color:#000;
 # text-align: center}
#</style>';
#print '<a class=info href="#">Test of tooltip <span> text that appears on mouse hover</span></a>';

print "<form name=\"update\" method=\"post\""
      . " action=\"$url_stem/update_imprule.cgi\">";

print "<input type=\"hidden\" name=\"rid_in\" value=$rid>";

print "<table frame>"
      ."<tr>";
print "<td>&nbsp;</td><td><strong>Rule ID:</strong></td><td>$rid</td></tr>"; 
print "<td><i>User who last modified the rule, with date and time</i></td>"
      . "<td><strong>Last modified:</strong><br>&nbsp;</td>"
      . "<td>" . lc($modified_by) . " ($modified_date)<br>&nbsp;</td></tr>"; 

print "<tr>"
    . "<td><i>Optionally, change the short description for this rule</i></td>"
    . "<td><a class=info href=\"#\">$g_red_star<strong>Short Name:</strong>"
    . "<span>Rule Short Name maximum length is 60 characters</span></a></td>"
    . "<td><input type=\"text\" maxlength=\"60\" size=\"60\" name=\"rsn\" "
    . "value=\"$rsn\"></td></tr>";
print "<tr>"
    . "<td><i>Optionally, change the longer description for the rule</i></td>"
    . "<td><a class=info href=\"#\">$g_red_star<strong>Description:</strong>"
    . "<span>Description maximum length is 2000 characters</span></a></td>"
    . "<td><textarea cols=\"60\" rows=\"4\" name=\"rd\">$rd</textarea></td>"
    . "</tr>";
my $check_yes = ($rie eq 'Y') ? 'CHECKED' : '';
my $check_no = ($rie eq 'Y') ? '' : 'CHECKED';
#print "rie='$rie' check_yes='$check_yes' check_no='$check_no'<br>";
print "<tr>
    <td><i>Should this rule be in effect, or<br>temporarily deactivated
           for testing?</i></td>
    <td>$g_red_star<strong>Is In Effect:</strong></td>
    <td><input type=\"radio\" name=\"rie\" value=\"Y\" $check_yes>Y &nbsp;
        <input type=\"radio\" name=\"rie\" value=\"N\" $check_no>N</td></tr>";

print "</table>";

print "<p /><input type=\"submit\" value=\"Update Rule\"></form>";
print "<hr/><form method=\"post\" action=\"$url_stem/delete_imprule.cgi\">
<input type=\"hidden\" name=\"rid_in\" value=$rid>
<input type=\"submit\" value=\"Delete Rule\"></form>";

print "<br><form><input type=\"button\" value=\"Previous Step \" onclick=\"history\.go(-1)\;return false\;\" /></form>";  
 
 print "</body></html>", "\n";
 exit(0);

###############################################################################
#   Subroutine get_rule_details($lda, $rule_id)
#
#   Returns an array with details for the rule 
#     ($short_name, $description, $is_in_effect, $modified_by, $modified_date)
###############################################################################
sub get_rule_details {
    my ($lda, $rule_id) = @_;
    
  my ($short_name, $description, $is_in_effect);
  my $cat;
  my $first_time = 1;
  my $stmt = 
   "select rule_short_name, rule_description, rule_is_in_effect,
           modified_by,DATE_FORMAT(modified_date, '%b %d, %Y, %h:%i:%s %p')
    from implied_auth_rule
    where rule_id = ?";
  #print "stmt 1 = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->bind_param(1, $rule_id)) {
        print "Error binding param 1: " . $DBI::errstr . "<BR>";  
  }
  unless ($csr1->execute) {
      print "Error executing select statement: " . $DBI::errstr . "<BR>";
  }

 #
 #  Get list of functions
 #
  ($short_name, $description, $is_in_effect,
   $modified_by, $modified_date) = $csr1->fetchrow_array;

  return ($short_name, $description, $is_in_effect, 
          $modified_by, $modified_date);
}
