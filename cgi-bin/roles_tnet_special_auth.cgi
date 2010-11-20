#!/usr/bin/perl
###########################################################################
#
#  CGI script to handle a special case for creating authorizations, 
#  i.e., where we want to simultaneously create a Qualifier Code and
#  and Authorization that uses it.  The initial use for this is for
#  authorizations for managing telephone preferences by 12-hex-digit
#  network IDs.
#  
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
#  Created by Dave Cohen, May 14, 2008.
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
use rolesweb('verify_metaauth_category'); #Use sub. verify_metaauth_category
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm
use rolesweb('strip'); #Use sub. strip in rolesweb.pm
use CGI;
use CGI::Pretty qw/ :standard /;
use CGI qw/startfom button textfield endform -nosticky/;
use DBI;
use Time::localtime;

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
$legend = 
"To create special network ID authorizations, <br>
 enter a Kerberos username, pick a function, and enter a qualifier_code 
 (e.g., a 12-digit hex Network ID), then click \"Add Authorization\".
 <p />
 <small>(To use this interface you need (1) a CREATE AUTHORIZATIONS
 authorization for category TNET and (2) a MAINTAIN QUALIFIERS authorization 
 for qualifier type NETI.)</small>
 <p />\n";

 #@function_names = ("ADMIN PHONE PREF BY NET ID");

#
#  Get form variables
#
$page =  $formval{'page'};
$kerberos_name = $formval{'kerbname'};
$function_name = $formval{'funcname'};
$qualifier_code = $formval{'qualcode'};
 print "Content-type: text/html\n\n";  # Start generating HTML document
 print "<head><title>$header</title></head>\n<body>";
 print '<BODY bgcolor="#fafafa">';
 &print_header
    ("Special Create Authorizations Interface - for Network IDs", 'https');
 print "<P>";


# authentication checks
  ($info,$k_principal, $domain)  = &parse_authentication_info();  # Parse authentication info
  $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase
  $full_name = $k_principal;
  $result = &check_auth_source($info); # Check other certificate fields
  if ($result ne 'OK') {
      print "<br><b>Your authentication cannot be accepted: $result";
      exit();
  }


if ($page eq '') {
 
#
#  Get set to use Oracle.
#
use DBI;

#
#  Open connection to oracle
#
$lda = &login_dbi_sql('roles')
      || &web_error($DBI::errstr);

#
#  Make sure the user has a meta-authorization to view special reports.
#
if (!(&verify_auths($lda, $k_principal))) {
  print "Sorry.  You do not have the required perMIT system authorizations",
  " to view this page.";
  exit();
}

#
#  Get a list of Function names for category TNET having qualifier type NETI
# 
 &get_function_names($lda, 'TNET', 'NETI', \@function_names);

#
#  Print the form
#

	form_print(0);

}

if ($page eq "process") {
	#
	#  Get set to use Oracle.
	#
        use DBI;

	#
	#  Open connection to oracle
	#
	$lda = &login_dbi_sql('roles')
      		|| &web_error($DBI::errstr);
        &get_function_names($lda, 'TNET', 'NETI', \@function_names);


	$year = localtime->year() + 1900;
	$month = localtime->mon() + 1;
	if (length($month) < 2) {
  		$month = "0" . $month;
	}
	$day = localtime->mday();
	if (length($day) < 2) {
  		$day = "0" . $day;
	}

	$ctime = $month . $day . $year;
	&do_create_qual($lda, $k_principal, $function_name, $qualifier_code, $ctime);

}

#
#  Drop connection to Oracle.
#
$lda->disconnect() || &web_error("can't log off Oracle");

#
#  Print end of the HTML document.
#
 print "</BODY></HTML>", "\n";
 exit(0);

###########################################################################
#
#  Subroutine do_create_qual
#
#  Attempts to create the specified qualifier, if necessary
#
###########################################################################
sub do_create_qual {

  my ($lda, $kerbname, $function_name, $qualifier_code, $effective_date) = @_;

    my $qual_name = "Network ID " . lc($qualifier_code);
    my $expiration_date = "";
    my $hexcheck =  &check_qual_hex($qualifier_code);
    my $result = &check_qual_code_exists($lda, $qualifier_code);

    if ($hexcheck == 1) {
    if ($result <= 0) {

       my $out_message;

       my $stmt1 = qq{begin
                     auth_sp_insert_qual(
                            :qual_type,
			    :qualifier_code,
                            :parent_code,
                            :qual_name,
			    :user_id,
			    :out_message
                            );
                  end;};

       my $csr = $lda->prepare($stmt1);
       $csr->bind_param(":qual_type", "NETI");
       $csr->bind_param(":qualifier_code", $qualifier_code);
       $csr->bind_param(":parent_code", "ALL_NET_ID");
       $csr->bind_param(":qual_name", $qual_name);
       $csr->bind_param(":user_id", $kerbname);
       $csr->bind_param_inout(":out_message", \$out_message, 255);

       $csr->execute;
       $error = get_db_error_msg($lda);
       if ($error) 
       {	
	   print "<p> <b><font color=red> $error \n</font></b>";
  	   $csr -> finish;
  	   $lda -> rollback;
       }
       elsif (!$error)
       {
  	   $csr -> finish;
    	   &do_create_auth($lda, $kerbname, $kerberos_name, $function_name, $qualifier_code, $effective_date, $expiration_date);
       }
    }
    else {
    	   &do_create_auth($lda, $kerbname, $kerberos_name, $function_name, $qualifier_code, $effective_date, $expiration_date);
    }
    }
    else {
	form_print(1);
    }
   $csr->finish();
}

#########################################################################################
#######################################
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


###########################################################################
#
# verify_auths
#
#  Verify's that $k_principal is allowed to use the application
#
###########################################################################
sub verify_auths {
    my ($lda, $k_principal) = @_;
    my ($csr, @stmt, $result);
    if (!$k_principal) {
        return 0;
    }
    @stmt = ("select ROLESAPI_IS_USER_AUTHORIZED('$k_principal',"
             . "'CREATE AUTHORIZATIONS', 'CATTNET') from dual");
    $csr = $lda->prepare("$stmt")
        || die $DBI::errstr;

    $csr->execute();
    ($result) = $csr->fetchrow_array() ;
    if ($result eq 'Y') {
    	@stmt = ("select ROLESAPI_IS_USER_AUTHORIZED('$k_principal',"
    	         . "'MAINTAIN QUALIFIERS', 'QUAL_NETI') from dual");
    	$csr = $lda->prepare("$stmt")
        	|| die $DBI::errstr;

    	($result) = $csr->fetchrow_array();
        $csr->finish();

	if ($result eq 'Y') {
		return 1;
	}
	else {
		return 0;
	}
    } 
    else {
        return 0;
    }
}

###########################################################################
#
#  check_qual_code_exists
#
#  Checks to see if a qualifier code already exists in the database
#
###########################################################################
sub check_qual_code_exists {
    my ($lda, $qualifier_code) = @_;
    my ($csr, @stmt, $result);
	
    $qualifier_code =  uc($qualifier_code);

    @stmt = ("select count(*) from qualifier where qualifier_type='NETI' AND qualifier_code='$qualifier_code'");
    $csr = $lda->prepare("$stmt")
        || die $DBI::errstr;

    $csr->execute();
    ($result) = $csr->fetchrow_array();
    $csr->finish();
    return $result;
}


###########################################################################
#
#  check_qual_hex
#
#  Checks to see if a qualifier code is a hex value
#
###########################################################################
sub check_qual_hex {
    my ($qualifier_code) = @_;
    my ($result, $len);
	
    $len = length($qualifier_code);
    
    if ($len == 12) {
	if ($qualifier_code =~ /^[0-9A-Fa-f]+$/) {
		$result = 1;
	}
	else {
		$result = 0;
	}
    }
    else {
	$result = 0;
    }

    return $result;
}

###########################################################################
#
#  form_print
#
#  Prints the form
#
###########################################################################

sub form_print {

my ($error) = @_;

print "<p /><hr /><p />\n";
print $legend;
$array_len = @function_names;

print '<form name="authform" method="post">
        <input type="hidden" name="page" value="process">
  <table cellpadding=4>
    <tr>
      <td>Kerberos Name:</td><td><input type="text" name="kerbname"></td>
    </tr>
    <tr>
    <td>Function Name:</td><td><select name="funcname">';
	for ($i = 0; $i < $array_len; $i++) {
        	print '<option value="'; 
		print $function_names[$i];  
		print '" >';
		print $function_names[$i];
		print "</option>";
	}
      print '                          </select>
      </td>
    </tr>
    <tr>
    <tr>
      <td>Qualifier Code:</td><td><input type="text" name="qualcode">';
if ($error == 1) {
	print '<br><b><font color="red">Please enter a 12 digit hex value</font></b>';
}
print '</td>
    </tr>
    <tr>
      <td cellspan=2 align=center><input type=submit value="Add Authorization">
      <input type=reset value="Clear"></td>
    </tr>
  </table>
</form>';


}


###########################################################################
#
#  do_create_auth
#
#  Creates the authorization
#
###########################################################################
sub do_create_auth {

  my ($lda, $kerbname, $kerberos_name, $function_name, $qualifier_code, $effective_date, $expiration_date) = @_;

  $effective_date =~ y/[\/]//d;
  $expiration_date =~ y/[\/]//d;
  my $modified_by;
  my $modified_date;
  my $authorization_id;
  my $stmt1 = qq{begin
                   rolesapi_create_auth(
                          '',
                          :for_user,
                          :function_name,
                          :qualifier_code,
                          :kerberos_name,
                          'Y',
                          'N',
                          'Y',
                          :effective_date,
                          :expiration_date,
                          :modified_by,
                          :modified_date,
                          :authorization_id
                          );
                end;};

  my $csr = $lda->prepare($stmt1);
  $csr->bind_param(":for_user", $kerbname);
  $csr->bind_param(":function_name", $function_name);
  $csr->bind_param(":qualifier_code", $qualifier_code);
  $csr->bind_param(":kerberos_name", $kerberos_name);
  $csr->bind_param(":effective_date", $effective_date);
  $csr->bind_param(":expiration_date", $expiration_date);
  $csr->bind_param_inout(":modified_by", \$modified_by, 255);
  $csr->bind_param_inout(":modified_date", \$modified_date, 255);
  $csr->bind_param_inout(":authorization_id", \$authorization_id, 255);
  $csr->execute;
  $error = get_db_error_msg($lda);
  if ($error) 
  {	
	print "<p> <b><font color=red> $error \n</font></b>";
  	$csr -> finish;
  	$lda -> rollback;
	form_print(0);
  }
  elsif (!$error)
  {
        print "<p> <font color=green>Authorization successfully created for ($kerberos_name, \'$function_name\', $qualifier_code). \n</font>";
	form_print(0);
  }
  $csr->finish();
}

###########################################################################
#
#  Function get_function_names ($lda, $category, $qualtype, \@function_name)
#
#  Get a list of function_names for the given category and qualifier_type
#
###########################################################################
sub get_function_names {
  my ($lda, $category, $qualtype, $rfunction_name) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select function_name
          from function
          where function_category = ?
          and qualifier_type = ?
          order by 1";
  #print "stmt current_term = '$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "<error>Error preparing select statement current_term: " 
            . $DBI::errstr . "</error>";
  }
  $csr1->bind_param(1, $category);
  $csr1->bind_param(2, $qualtype);
  unless ($csr1->execute) {
      print "<error>Error executing select statement current_term: " 
      . $DBI::errstr . "</error>";
  }

  my $funcname;
  while ( ($funcname) = $csr1->fetchrow_array ) {
      push(@$rfunction_name, $funcname);
  }

}
