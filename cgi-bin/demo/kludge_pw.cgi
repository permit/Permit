#!/usr/bin/perl
###########################################################################
#
#  CGI script to generate a random password for a database connection,
#  set the password, and return it as part of an html document.
#
#  It also writes files to a temporary directory signalling that the
#  password should be changed by the changepwd daemon, 2 minutes later.
#  This gives the person time to log onto the database, but not
#  a lot of time for a hacker to steal the password and log onto the DB.
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
#  Jim Repa, 9/10/1999
#
###########################################################################
#
# Get packages
#
use rolesweb('login_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
use rolesweb('parse_ssl_info'); #Use sub. parse_ssl_info in rolesweb.pm
use rolesweb('check_cert_source'); #Use sub. check_cert_source in rolesweb.pm
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm

#
#  Set constants
#
 $temp_dir = "/tmp/pwsched/";  # Directory to write pw change notices
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
if (!($database)) {$database = 'troles';}  ###### For testing
$database =~ tr/a-z/A-Z/;

#
#  Start printing HTML document
#
 $title = "Set a random password for $database database";
 print "Content-type: text/html", "\n\n";
 print "<HTML>", "\n";
 print "<HEAD><TITLE>$title</TITLE></HEAD>", "\n";

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
#  Check the other fields in the certificate
#
 $result = &check_cert_source(\%ssl_info);
 if ($result ne 'OK') {
     print "<br><b>Your certificate cannot be accepted: $result";
     exit();
 }

#
#  Allow tests for username REPA
#
 $testuser = 'JIVES';
 #$testuser = 'WCARLONI';
 $k_principal = ($k_principal eq 'REPA') ? $testuser : $k_principal;

#
#  Print out the header
#
 print '<BODY bgcolor="#fafafa">';
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
#  Generate a random password
#
 $rand_pw = &gen_rand_pw();
 print "New password for $k_principal will be $rand_pw<P>";

#
#  Get set to use Oracle.
#
use DBI;
use Oraperl;  # Point to library of Oracle-related subroutines for Perl
if (!(defined(&ora_login))) {&web_error("Use oraperl, not perl\n");}

#
# Login into the database
# 
$dbstring = $database . 'w';
$dbstring =~ tr/A-Z/a-z/;
$lda = &login_sql($dbstring)
      || &web_error($ora_errstr);

#
#  Go call the stored procedure to change the password
#
 &set_rand_pw($lda, $database, $k_principal, $rand_pw);

#
#  Drop connection to Oracle.
#
 &ora_logoff($lda) || &web_error("can't log off Oracle");    

#
# Print bottom of web page.
#
 print "<P><HR>";
 print "</BODY></HTML>", "\n";
 exit(0);

###########################################################################
#
#  Function set_rand_pw($lda, $database, $username, $pw);
#  (If $which_time = 1, then we're just checking parameters.)
#  Returns the error code from the SQL stored procedure.
#
###########################################################################
sub set_rand_pw {
 my ($dbh, $database, $username, $pw) = @_;
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
 unless ($csr->execute) {
   &web_error("CGI script error in stored procedure execute. " . $dbh->errstr);
 }

 #
 #  Did we get an unexpected error from the stored procedure?
 #
 if ($err) {
   print "Unexpected error from stored procedure call<BR>";
   print "err='$err'<BR>";
   print "errstr='$errstr'<BR>";
   $csr->finish;
 }
 $csr->finish;
 if ($sp_code != 100) {print "$sp_message<BR>";}
 if (!$sp_code && ($sp_message =~ /success/)) {
   print "You can now use your new password to connect to the"
         . " database.<BR>";
   &write_pw_change_note($database, $username, $temp_dir);
 }
 elsif ($sp_code == -988) {
   print "Your new password was not acceptable as an Oracle database password."
         . "<BR>";
 }
 elsif ($sp_code < 0) {
   print "Unexpected Oracle database error encountered while trying"
         . " to change password for '$username'<BR>";
 }
}

###########################################################################
#
#  Function &gen_rand_pw() returns a new random password.
#
#  ***** This is a simpler and cryptographically weaker version of
#  ***** the random password generator routine.  Keep it commented
#  ***** out unless the C routine randpass_oracle is unavailable.
#
###########################################################################
#sub gen_rand_pw {
#
# my @char = ("A" .. "Z", 0 .. 9);
# my $pw_length = 24;
# srand();  # Initialize random seed
# my $password = join("", @char[ map {rand @char} (1 .. $pw_length) ]);
# if (substr($password, 0, 1) =~ /[0-9]/) {
#   substr($password, 0, 1) =~ tr/0-9/A-J/;
# }
# $password;  # Return the result.
#}

###########################################################################
#
#  Function &gen_rand_pw() returns a new random password.
#
#  Uses C program randpass_oracle, which uses MD5 algorithm for
#  random numbers.  (It also gets a seed from /tmp/secret)
#
###########################################################################
sub gen_rand_pw {
 chomp($password = `./randpass_oracle`);
 $password; 
}

###########################################################################
#
#  Subroutine &write_pw_change_note($db, $username, $temp_dir);
#
#  Generates a file in the directory $temp_dir noting that the database
#  password for $username@$db should be changed in 2 minutes.
#
############################################################################
sub write_pw_change_note {
  my ($db, $username, $temp_dir) = @_;
  
  my $pid = $$;  # Get PID for this process
  my $epoch = time();  # Get no. of seconds since 1/1/1970
  my $outfile = "${temp_dir}pw.$db.$username.$epoch.$pid";

  unless ( open(OUT,">$outfile") ) {
    &web_error("Cannot open output file $outfile<BR>");
  }

  #
  #  Get the current time.  Get each component (sec, min, hour, etc.)
  #  as a 2-digit number (padded on the left with 0 if needed)
  #
  my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst)
      = localtime($epoch);
  $mday++;  $mon++;  # Unix programmers learn at age 3 to count from 0.
  # Pad each value on the left with 0
  grep {$_ = substr('0' . $_, -2, 2)} ($sec, $min, $hour, $mday, $mon, $year);

  print OUT "Change pw for $username\@$db at $mon/$mday/$year"
            . " $hour:$min:$sec + 2 minutes\n";
  close(OUT);
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

