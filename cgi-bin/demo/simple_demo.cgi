#!/usr/bin/perl
##############################################################################
#
#  Simple CGI script, written in Perl, to display read and display some
#  information from the roles database, based on the username extracted
#  from the certificate.
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
#  Jim Repa, 5/15/1998
#
##############################################################################

print "Content-type: text/html\n\n";  # Start generating HTML document
print "<head></head><body Text=#000000 BGCOLOR=#FFFFFF>";
print "<head></head><body>";
print "<center><h1>Output of simple_demo.cgi:<br>\n"
      . "<hr><br></center></h1>\n";


#
#  Parse certificate information
#
$info = $ENV{"SSL_CLIENT_DN"};  # Get certificate information
print "<b>Certificate info from environment variable SSL_CLIENT_DN:<BR><BR>"
      . "</b>\n$info<BR><BR><HR>\n";
%ssl_info = &parse_ssl_info($info);  # Parse certificate into a Perl "hash"
$email = $ssl_info{'Email'};    # Get Email address from cert. 'Email' field
$full_name = $ssl_info{'CN'};   # Get full name from cert. 'CN' field
($k_principal, $domain) = split("\@", $email);
if (!$k_principal) {
    print "<br><b>No certificate sent.  Use https:// , not http://</b>\n";
    exit();
}

#
#  Display something on the https output
#
print "<b>To get Kerberos principal, first start with</b><BR><BR>\n"
    . "&nbsp&nbsp Email = '$email'<BR><BR>\n"
    . "<b>and split it into</b><BR><BR>\n"
    . "&nbsp&nbsp user = '$k_principal'<BR>\n"
    . "&nbsp&nbsp and domain = '$domain'\n<BR>\n";

#
#  Check the other fields in the certificate
#
$result = &check_cert_source(\%ssl_info);
if ($result ne 'OK') {
    print "<br><b>Your certificate cannot be accepted: $result";
    exit();
}

#
#  Get set to use Oracle.
#
use Oraperl;  # Point to library of Oracle-related subroutines for Perl
$ENV{'ORACLE_HOME'} = '/opt/app/oracle/product/8.1.6';
$ENV{'PATH'} .= ':' . '/opt/app/oracle/product/8.1.6/bin';

#
#  Read database information from configuration file.
#

($db, $user, $pw) = &get_database_info('roles');  # Read conf. file for troles
print "db='$db' user='$user'<BR>";

#
#  Open connection to oracle
#
$lda = &ora_login($db, $user, $pw) 
    || die $ora_errstr;
print "after ora_login<BR>";

$k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase 
@stmt = ("select first_name, last_name, mit_id, email_addr,"
         . " decode(PRIMARY_PERSON_TYPE, 'E', 'Employee',"
         . " 'S', 'Student', 'Other'), dept_code"
         . " from person"
         . " where kerberos_name = '$k_principal'"); 
$csr = &ora_open($lda, "@stmt") || die $ora_errstr;
($first_name, $last_name, $mit_id, $email_addr, $person_type, $dept_code) 
   = &ora_fetch($csr);
&ora_close($csr);

#
#  Now display the information that we've gotten out of the database
#

print "<HR><BR><b>Now display information read from the database for"
      . " user '$k_principal'</b><BR><BR>\n";
print "<TABLE>", "\n";

printf "<TR><TD ALIGN=RIGHT>%25s&nbsp&nbsp</TD>"
        . "<TD ALIGN=LEFT>%-30s</TD>\n",
        'FIRST NAME:', $first_name;

printf "<TR><TD ALIGN=RIGHT>%25s&nbsp&nbsp</TD>"
        . "<TD ALIGN=LEFT>%-30s</TD>\n",
        'LAST NAME:', $last_name;

printf "<TR><TD ALIGN=RIGHT>%25s&nbsp&nbsp</TD>"
       . "<TD ALIGN=LEFT>%-30s</TD>\n",
        'MIT ID:', $mit_id;

printf "<TR><TD ALIGN=RIGHT>%25s&nbsp&nbsp</TD>"
       . "<TD ALIGN=LEFT>%-30s</TD>\n",
        'EMAIL ADDR:', $email_addr;

printf "<TR><TD ALIGN=RIGHT>%25s&nbsp&nbsp</TD>"
       . "<TD ALIGN=LEFT>%-30s</TD>\n",
        'PERSON TYPE:', $person_type;

print "</TABLE>", "\n";

#
#  Let the user view the source code (this file)
#
print "<HR>\n";
print "<A HREF=http://web.mit.edu/~repa/www/simple_demo.text>View the"
      . " Perl source code for the CGI script</A><BR>\n";
print "</body>";

#
#  Logoff and exit.
#
do ora_logoff($lda) || die "can't log off Oracle";

exit();

##############################################################################
#
# Subroutine get_database_info($symbolic_db_name)
#
# Parse client SSL information into a hash.
#
##############################################################################
sub get_database_info {
    my($db_symbol) = $_[0];  # Get first argument (symbolic_database_name)
    my $filename = "dbweb.config";
    my $fullpath = '/var/https/cgi-bin/' . $filename;
    my ($sym_db, $db, $user, $pw);

    unless (open(CONF,$fullpath)) {  # Open the config file
       print "<br><b>Cannot open the configuration file. <br>"
         . " The configuration file should be $fullpath<b>";
       exit();
    }
	     
    while (chop($line = <CONF>)) {
      if ($line =~ /^$db_symbol/) {  # Look for the right line
        ($sym_db, $db, $user, $pw) = split(':',$line); # Parse db, user, pw
      }
    }
    close(CONF);  # Close the config file 
    return ($db, $user, $pw);  # Return triplet of db, user, pw
}

##############################################################################
#
# Subroutine parse_ssl_info 
#
# Parse client SSL information into a hash.
#
##############################################################################
sub parse_ssl_info {
    local($info) = $_[0];  # Get first argument
    $info =~ tr/\n//;      # Get rid of newline(s)
    local(@junk) = split(/\//,$info);   # Split up the pieces
    local(%SSL_INFO);  # Make a hash of the pieces
    foreach $junk (@junk)
    {
	local($key, $value) = split(/=/,$junk);
	$SSL_INFO{$key} = $value;
    }
    return %SSL_INFO;
}

##############################################################################
#
# Function &check_cert_source(\%ssl_info)
#
# Looks at parameters in the %ssl_info hash to make sure the certificate
# came from Country=US, State=Massachusetts, 
# Org=Massachusetts Institute of Technology
# Also checks to make sure the email address is in the domain MIT.EDU
# 
# If everything is OK, return 'OK'.  If not, return an error message.
#
##############################################################################
sub check_cert_source {
    my $rssl_info = $_[0];  # Get reference to a hash
    my $result = 'OK';  # Default result
    
    if ($$rssl_info{'C'} ne 'US') {
	$result = "Wrong certificate authority.  Country='$$rssl_info{'C'}'"
	    . " (should be 'US')";
    }
    elsif ($$rssl_info{'ST'} ne 'Massachusetts') {
	$result = "Wrong certificate authority.  State='$$rssl_info{'ST'}'"
	    . " (should be 'Massachusetts')";
    }
    elsif ($$rssl_info{'O'} ne 'Massachusetts Institute of Technology') {
	$result = "Wrong certificate authority.  Org='$$rssl_info{'O'}'"
	    . " (should be 'Massachusetts Institute of Technology')";
    }
    
    my ($username, $domain) = split('@', $$rssl_info{'Email'}); 
    if ($domain ne 'MIT.EDU') {
	$result = "Wrong Email domain in certificate.  domain='$domain'"
	    . " (should be 'MIT.EDU')";
    }
    
    $result;
}

########################################################################
#
#  Strips off trailing <cr> and leading and trailing blanks.
#
###########################################################################
sub strip {
    my($s);  #temporary string
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
