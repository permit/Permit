#!/usr/bin/perl
###########################################################################
#
#  CGI script to create some basic authorizations for testing.  This program
#  requires authentication and meta-authorizations to allow the user to create
#  authorizations.
#
#	This program is not intended for production deployment.
#	This program is not yet functional. It should be taking a function_category
#	as input as well, but it is not doing so. 
#
#  Copyright (C) 2000-2010 Massachusetts Institute of Technology
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
###########################################################################
#
# Get packages
#
use rolesweb('login_dbi_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
use rolesweb('parse_ssl_info'); #Use sub. parse_ssl_info in rolesweb.pm
use rolesweb('check_cert_source'); #Use sub. check_cert_source in rolesweb.pm
use rolesweb('verify_metaauth_category'); #Use sub. verify_metaauth_category
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm
use rolesweb('strip'); #Use sub. strip in rolesweb.pm
use CGI;
use CGI::Pretty qw/ :standard /;
use CGI qw/startfom button textfield endform -nosticky/;
use DBI;
use rolesweb('parse_authentication_info'); #Use sub. parse_authentication_info i
n rolesweb.pm
use rolesweb('check_auth_source'); #Use sub. check_auth_source in rolesweb.pm


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
#  Set some constants
#
$g_delim = '!';
$host = $ENV{'HTTP_HOST'};

#
#  Get form variables
#
$kerberos_name = $formval{'kerbname'};
$function_name = $formval{'funcname'};
$qualifier_code = $formval{'qualcode'};
$effective_date = $formval{'effdate'};
$expiration_date  = $formval{'expdate'};

 print "Content-type: text/html\n\n";  # Start generating HTML document
 $header = $title[$report_num - 1];
 print "<head><title>$header</title></head>\n<body>";
 print '<BODY bgcolor="#fafafa">';
 &print_header
    ($header, 'https');
 print "<P>";


#
#  Parse auth information via TOUCHSTONE
#
($info,$k_principal, $domain)  = &parse_authentication_info();  # Parse certific
ate into a Perl "hash"

  $full_name = $k_principal;
  $result = &check_auth_source($info); # Check other certificate fields
  if ($result ne 'OK') {
      print "<br><b>Your authentication cannot be accepted: $result";
      exit();
  }
 $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase


#
#  Get set to use DBI
#
use DBI;

#
#  Open connection to oracle
#
$lda = &login_dbi_sql('roles')
      || &web_error($DBI::errstr);

   &do_create($lda, $k_principal, $kerberos_name, $function_name, $qualifier_cod
e, $effective_date, $expiration_date);

if (1) {
   $authorization_id  = $formval{'authid'};
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
#  Subroutine do_create.
#
#  Attempts to create the specified authorization.
#
###########################################################################
sub do_create {

  my ($lda, $kerbname, $kerberos_name, $function_name, $qualifier_code, $effecti
ve_date, $expiration_date) = @_;

  print "For User = $kerbname<br>";
  print "Kerberos Name = $kerberos_name<br>";
  print "Function Name = $function_name<br>";
  print "Qualifier Code = $qualifier_code<br>";
  print "Effective Date With Slashes = $effective_date<br>";
  print "Expiration Date With Slashes = $expiration_date<br>";
  $effective_date =~ y/[\/]//d;
  $expiration_date =~ y/[\/]//d;
  print "Effective Date Without Slashes = $effective_date<br>";
  print "Expiration Date Without Slashes = $expiration_date<br>";
  my $modified_by;
  my $modified_date;
  my $authorization_id;

# rolesapi_create_auth param list
 # IN AI_SERVER_USER  VARCHAR(20),
 # IN AI_FOR_USER  VARCHAR(20),
 # IN AI_FUNCTION_NAME
 # IN AI_QUALIFIER_CODE
 # IN AI_KERBEROS_NAME
 # IN AI_DO_FUNCTION
 # IN AI_GRANT_AND_VIEW
 # IN AI_DESCEND
 # IN AI_EFFECTIVE_DATE
 # IN AI_EXPIRATION_DATE
 # OUT a_modified_by
 # OUT a_modified_date
 # OUT a_authorization_id
  my $csr = $lda->prepare(' CALL rolesapi_create_auth (?,?,?,?,?,?,?,?,?,?,@modi
fied_by,@modified_date,@authorization_id) ' );
  $csr->bind_param(1, '');
  $csr->bind_param(2, $kerbname);
  $csr->bind_param(3, $function_name);
  $csr->bind_param(4, $qualifier_code);
  $csr->bind_param(5, $kerberos_name);
  $csr->bind_param(6, 'Y');
  $csr->bind_param(7, 'N');
  $csr->bind_param(8, 'Y');
  $csr->bind_param(9, $effective_date);
  $csr->bind_param(10, $expiration_date);
  $csr->execute;
  $error = get_db_error_msg($lda);

 my $csr1 = $lda->prepare(' select @authorization_id  ');
    $csr1->execute ;
    $authorization_id = $csr1->fetchrow_array();
    $csr1->finish ;

  if ($error){print "<p> <b><font color=red> $error \n</font></b>";}
  elsif (!$error){print "<p> <font color=green> Auth $authorization_id created\n
</font>";}
  $csr -> finish;
  $lda -> commit;
}

##############################################################################
#  Extract a short error message from the string returned from Oracle
##############################################################################
sub get_db_error_msg {
    my($lda) = @_;
    my $err = $lda->err;
    my $errstr = $lda->errstr;
    $errstr =~ /\: ([^\n]*)/;
    my $shorterr = $1;
    $shorterr =~ s/ORA.*?://g;
    if($err) {
#      return "Error: $shorterr Error Number $err";
       return "Error: $shorterr ";
    }

    return undef;
}
####################################################################

