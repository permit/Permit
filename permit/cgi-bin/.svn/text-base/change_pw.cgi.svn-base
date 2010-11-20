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
#
#  Written 4/9/1999, Jim Repa
#  Modified 4/29/1999, Jim Repa (Slight change in retry URL)
#
###########################################################################
#
# Get packages
#
use rolesweb('login_dbi_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
use rolesweb('parse_authentication_info'); #Use sub. parse_authentication_info in rolesweb.pm
use rolesweb('check_auth_source'); #Use sub. check_auth_source in rolesweb.pm
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm

#
#  Set constants
#
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 $host = $ENV{'HTTP_HOST'};
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
$database = $formval{'database'};  # Get value set in &parse_forms()
$pw1 = $formval{'pw1'};  # Get value set in &parse_forms()
$pw2 = $formval{'pw2'};  # Get value set in &parse_forms()
$database =~ tr/a-z/A-Z/;
$pw1 =~ tr/a-z/A-Z/;
$pw2 =~ tr/a-z/A-Z/;

#
#  Set the URL for retries if the password is not accepted by Oracle.
#
 $try_again_string =
   "<br><FORM METHOD=POST ACTION=\"https://$host/cgi-bin/$progname\">"
   . "<INPUT TYPE=HIDDEN NAME=database VALUE=\"$database\">"
   . '<INPUT TYPE="SUBMIT" VALUE="Try again">'
   . '</FORM>';

#
#  Start printing HTML document
#
 $title = "Change password in $database database";
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
#  Comment out, except for testing...
#
 #$k_principal = 'JIVES';  # For testing
 #$k_principal = 'BLEAH';  # For testing

#
#  Print out the header
#
 print '<BODY bgcolor="#fafafa">';
 $title =~ s/ my / /;
 $title =~ s/password/password for $k_principal/;
 &print_header($title, 'https');
 print "<HR><P>";

#
#  Make sure the user's browser supports 128-bit keys
#
 if ($ENV{'HTTPS_SECRETKEYSIZE'} < 128) {
   &web_error("You cannot use this password-change service because your"
              . " browser uses a weak (" . $ENV{'HTTPS_SECRETKEYSIZE'} 
              . "-bit) encryption key.<BR>\n"
              . " Install the US-only version of Netscape and try again.");
 }

#
#  Check the parameters sent.
#
 if ($pw1 eq '' && $pw2 eq '') {
   $which_time = 1;  # This is the first time through -- prompt for PW later
 }
 else {
   $which_time = 2;
   unless ($pw1 eq $pw2) {
     &web_error("Error. The two passwords you entered were not the same."
                . " $try_again_string");
   }
   unless (length($pw1) >= 5) {
     &web_error("Error. Password must be at least 5 characters."
                . " $try_again_string");
   }
   unless ($pw1  =~ /^[A-Z][A-Z0-9\_\$\#]{0,29}$/) {
     &web_error("Error. Password contains an invalid character or does not"
       . " start with a letter.  $try_again_string");
   }
 }

#
#  Get set to use Oracle.
#
use DBI;
#use Oraperl;  # Point to library of Oracle-related subroutines for Perl
#if (!(defined(&ora_login))) {&web_error("Use oraperl, not perl\n");}

#
# Login into the database
# 
$dbstring = $database . 'w';
$dbstring =~ tr/A-Z/a-z/;
#$lda = login_dbi_sql('roles')
$lda = login_dbi_sql('roles') || die "DBI::errstr . \n";|| &web_error($DBI::errstr."\n");
 
#
#  Go call the stored procedure to change the password
#
 &do_change_pw($lda, $which_time, $database, $k_principal, $pw1);

#
#  Drop connection to Oracle.
#
$lda>disconnect() || &web_error("can't log off Oracle");    

#
# Print bottom of web page.
#
 print "<P><HR>";
 print "<A HREF=\"$main_url\"><small>Back to main perMIT web interface page"
       . "</small></A>";

 print "</BODY></HTML>", "\n";
 exit(0);

###########################################################################
#
#  Function do_change_pw($lda, $which_time, $database, $username, $pw);
#  (If $which_time = 1, then we're just checking parameters.)
#  Returns the error code from the SQL stored procedure.
#
###########################################################################
sub do_change_pw {
 my ($dbh, $which_time, $database, $username, $pw) = @_;
 my ($sp_message, $sp_code, $csr);

 my @stmt = q{
  BEGIN
    web_sp_change_pw(:username, :pw, :v_message, :v_code);
  END;
 };

 unless ($csr = $dbh->prepare(@stmt)) {
   &web_error("CGI script error in prepare step, subroutine do_change_pw");
 }
 
 unless ($csr->bind_param(":username", $username)) {
   &web_error("CGI script error in bind_param. " . $dbh->errstr);
 }

 $csr->bind_param(":pw", $pw);
 $csr->bind_param_inout(":v_message", \$sp_message, 255);
 $csr->bind_param_inout(":v_code", \$sp_code, { TYPE => SQL_NUMBER });
 $csr->execute;
 unless ($csr->execute()) {
   &web_error("CGI script error in stored procedure execute. " . $dbh->errstr);
 }

 #
 #  Did we get an unexpected error from the stored procedure?
 #
 #$err = $dbh->errstr;
 if ($err) {
   print "Unexpected error from stored procedure call<BR>";
   print "err='$err'<BR>";
   print "errstr='$errstr'<BR>";
   $csr->finish;
 }
 $csr->finish();
 if ($sp_code != 100) {print "$sp_message<BR>";}
 if (!$sp_code && ($sp_message =~ /success/)) {
   print "<BR>You can now use your new password to connect to the"
         . " database.<BR>";
 }
 elsif ($which_time == 1 && $sp_code == 100) {  # First check is done.
   &pw_change_phase2($database, $username, $password);
 }
 elsif ($sp_code == -988) {
   print "Your new password was not acceptable as an Oracle database password."
         . " $try_again_string<BR>";
 }
 elsif ($sp_code < 0) {
   print "Unexpected Oracle database error encountered while trying"
         . " to change password for '$username'<BR>";
 }
}

########################################################################
#
#  Subroutine pw_change_phase2($database, $username, $pw)
#  Prints a form that allows the user to change his password through
#    a 2nd call to this CGI script.
#
###########################################################################
sub pw_change_phase2 {
  my ($db, $username, $pw) = @_;
  print << 'ENDOFTEXT';
You will be choosing a password for an Oracle database.  It will not be
case-sensitive.  It must
<ul>
<li>begin with a letter
<li>contain only the characters A-Z, 0-9, _, $, and #.
<li>be no longer than 30 characters
<li>not match common words that are used by Oracle databases, such as
TABLE, SELECT, INSERT, UPDATE, DELETE, ORDER, etc..
</ul>
Avoid easily guessable passwords.  Don't use
<ul>
<li>your first name, middle name, last name, nickname, initials, name of 
a friend, relative, or pet
<li>any word in a dictionary
<li>fewer than 5 characters
<li>your phone number, office number, anniversary, birthday 
</ul>
<HR>
ENDOFTEXT

  print "Enter your <strong>new</strong> password for user $username below.";
  print << 'ENDOFTEXT';
Then, enter the same <strong>new</strong> password again.
Finally, click the "Change password" button.
ENDOFTEXT

  $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
  my $progname = $1;    # Set $progname to this string.
  my $host = $ENV{'HTTP_HOST'};
  my $url_stem = "https://$host/cgi-bin/$progname";  # URL for subtree view
  print "<FORM METHOD=POST ACTION=\"$url_stem\">";

  print << 'ENDOFTEXT';
<table>
<tr><td>Enter new password:</td>
<td><input type=password size=30 name="pw1"></td></tr>
<td>Enter new password again:</td>
<td><input type=password size=30 name="pw2"></td></tr>
</table>
ENDOFTEXT

  print "<INPUT type=hidden name=database value=\"$database\">";
  print << 'ENDOFTEXT';
<INPUT TYPE="SUBMIT" VALUE="Change password">
</FORM>
<HR>
ENDOFTEXT
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

