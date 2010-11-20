
###############################################################################

##
## DESCRIPTION: 
## This Perl package contains common routines used by CGI scripts for
## the Roles DB Web interface
## 
## PRECONDITIONS:
##
## 1.)  use 'rolesweb';
##	 or
##	use 'rolesweb' 1.0;  #This will specify a minimum version number
##
## POSTCONDITIONS:   
##
## 1.) None.
##
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
## MODIFICATION HISTORY:
##
## 11/11/1998 Jim Repa. -created
## 11/13/1998 Jim Repa. -Modified to add more subroutines.
## 8/21/2001  Jim Repa. -Added &web_error, &strip, &get_viewable_categories,
##                       and changed rule for viewing SAP or META auths.
## 11/14/2002 Jim Repa. -Added HR and ADMN to categories where people
##                       have default viewing authority
## 2/01/2006  Jim Repa. -Fixed ORACLE_HOME
## 6/13/2006  Jim Repa. -Add PAYR to categories where people have default
##                       viewing authority
##
###############################################################################

package rolesweb;
$VERSION = 1.0;
$package_name = 'rolesweb';

#Specify routines to be directly callable via the calling module without
#specifying the name of this package
use Exporter;				#Standard Perl Module
@ISA = ('Exporter');			#Inherit from Exporter	
@EXPORT_OK = qw(get_database_info login_sql login_dbi_sql parse_forms parse_ssl_info
                parse_authentication_info check_cert_source check_auth_source  verify_metaauth_category print_header
                get_viewable_categories web_error strip);

$TEST_MODE = 0;            ## Test Mode (1 == ON, 0 == OFF)

if ($TEST_MODE) {print "TEST_MODE is ON for rolesweb.pm\n";}
use DBI;

##############################################################################
#
# Subroutine get_database_info($symbolic_db_name)
#
# Look up the symbolic database name in dbweb.config and
# return (db, username, pw).
#
##############################################################################
sub get_database_info {
    my($db_symbol) = $_[0];  # Get first argument (symbolic_database_name)
    my $filename = "dbweb.config";
    $ENV{'PERMIT_CONFIG_HOME'} = '/var/www/permit';
    my $fullpath = $ENV{'PERMIT_CONFIG_HOME'} . "/" . $filename;
 	#print "config file: '$fullpath'"; 
    my ($sym_db, $db, $user, $pw,$host);
 
    unless (open(CONF,$fullpath)) {  # Open the config file
       print "<br><b>Cannot open the configuration file. <br>"
         . " The configuration file should be $fullpath<b>";
       exit();
    }
 
    while (chop($line = <CONF>)) {
      if ($line =~ /^$db_symbol\:/) {  # Look for the right line
        ($sym_db, $db, $user, $pw,$host) = split(':',$line); # Parse db, user, pw
      }
    }
    close(CONF);  # Close the config file
    return ($db, $user, $pw,$host);  # Return quartet of db, user, pw, host
}



 ##############################################################################
#
# Subroutine login_dbi_sql($symbolic_db_name)
#
# Look up the symbolic database name in dbweb.config and
# get (db, username, pw).  Use this to login to an Oracle database.  Try
# up to 3 times.
#
##############################################################################
sub login_dbi_sql
{
        my ($db_symbol) = @_;
        my ($db, $user, $pw,$host) = &get_database_info($db_symbol); #Read conf. file
        my $dsn = "dbi:mysql:" . $db . ":" . $host;
 	#print "DSN: '$dsn'"; 
        for (my $i = 0; $i < 3; $i++) {  # Retry 3 times
            if (my $lda = DBI->connect($dsn, $user, $pw)) {
                $lda->{AutoCommit}    = 0;
                $lda->{RaiseError}    = 1;
               return $lda;
           }
        }
        print "Connect to database '$db' failed after 3 tries.<BR>\n";
        print "$DBI::errstr . <BR>\n";
        return 0;

}


##############################################################################
#
# Subroutine login_sql($symbolic_db_name)
#
# Look up the symbolic database name in dbweb.config and
# get (db, username, pw).  Use this to login to an Oracle database.  Try
# up to 3 times.
#
##############################################################################
sub login_sql 
{
	my ($db_symbol) = @_;
        my ($db, $user, $pw) = &get_database_info($db_symbol); #Read conf. file

        #$ENV{'ORACLE_HOME'} = '/oracle/product/10.2.0/db';
       # for ($i = 0; $i < 3; $i++) {  # Retry 3 times
#	    if ($lda = &ora_login($db, $user, $pw)) {
#               return $lda;
#	   }
#        }
#        print "Oracle connect to database '$db' failed after 3 tries.<BR>\n";
#        print "$ora_errstr<BR>\n";
        return 0;

}

#############################################################################
#
#  Subroutine parse_forms(input_string, \%formval, \%rawval)
#
#  Parses a line of the form (parameter string from a URL)
#     var1=value1&var2=value2&...
#  Builds a hash %formval where 
#     $formval{var1} = 'value1'
#     $formval{var2} = 'value2'
#     ...
#  The hash %rawval is similar to %formval except special characters
#  have not been converted.
#
#############################################################################
sub parse_forms{
  my ($form_info, @line, $n, $i, $key, $value);
  ($form_info, $rformval, $rrawval) = @_;
  @line = split(/&/, $form_info);
  $n = @line;   # How many lines?
  for ($i = 0; $i < $n; $i++) {
    ($key, $value) = split(/=/, $line[$i]);  # Split line into var. and value
    $$rrawval{$key} = $value;  # Save value before making adjustments
    $value =~ tr/+/ /;  # Restore spaces
    $value =~ s/%([\dA-Fa-f][\dA-Fa-f])/pack ("C", hex($1))/eg; # Hex strings
    $$rformval{$key} = $value;
  }
}

##############################################################################
#
# Subroutine parse_ssl_info 
#
# Parse client SSL information into a hash.
#
##############################################################################
sub parse_ssl_info {
    my $info = $_[0];  # Get first argument
    $info =~ tr/\n//;      # Get rid of newline(s)
   # print "Info '$info'<BR>";
    my ($key, $value, $junk);
    my(@junk) = split(/\//,$info);   # Split up the pieces
    my(%SSL_INFO);  # Make a hash of the pieces
    foreach $junk (@junk)
    {
	($key, $value) = split(/=/,$junk);
#	print "KEY='$key' value='$value' junk='$junk'<BR>";
	$SSL_INFO{$key} = $value;
    }
    return %SSL_INFO;
}


##############################################################################
#
# Subroutine parse_authentication_info 
#
# Parse client authentication information .
#
##############################################################################
sub parse_authentication_info {
	$info = $ENV{"REMOTE_USER"};
	$info =~ tr/\n//;      # Get rid of newline(s)
	my ($k_principal, $domain) = split("\@", $info);
   # print "Info '$info'<BR>";
    return ($info,$k_principal, $domain);
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
    
    my ($username, $domain) = split('@', $$rssl_info{'emailAddress'}); 
    if ($domain ne 'MIT.EDU') {
	$result = "Wrong Email domain in certificate.  domain='$domain'"
	    . " (should be 'MIT.EDU')";
    }
    
    $result;
}

##############################################################################
#
# Function &check_auth_source()
#
# Looks at parameters in the %info hash to make sure the authentication info
# Also checks to make sure the email address is in the appropriate domain 
# 
# If everything is OK, return 'OK'.  If not, return an error message.
#
##############################################################################
sub check_auth_source {
 	my $result = 'OK';  # Default result
        my $info = $_[0];  # Get reference to a hash
  	#$info = $ENV{"REMOTE_USER"};  # Get certificate information
#	#print "REMOTE_USER: '$info'";
  	($k_principal, $domain) = split("\@", $info);
  	if (!$k_principal) {
        	$result = "No Principal Id";
  	}
  	elsif (!$domain || lc($domain) != 'mit.edu' ) {
        	$result = "Not Valid Domain ";
      		exit();
  	}

    $result;
}

###########################################################################
#
#  Subroutine verify_metaauth_category($lda, $k_principal, $view_category).
#
#  Verifies that $k_principal is allowed to view authorizations for 
#  other users in category $view_category. 
#  Returns 1 if allowed, 0 if not.
#
###########################################################################
sub verify_metaauth_category {
    my ($lda, $k_principal, $view_category) = @_;
    my ($csr, @stmt, $result);
    if ((!$k_principal) | (!$view_category)) {
        return 0;
    }
    #
    #  Special rule for viewing SAP, LABD, ADMN, HR, META, or PAYR
    #  authorizations:  
    #  If you have any current SAP, HR, or PAYR authorizations, then you are 
    #  allowed to view SAP, LABD, ADMN, HR, META, or PAYR authorizations 
    #  on the web.
    #
    if ($view_category eq 'SAP' || $view_category eq 'META' 
        || $view_category eq 'LABD' || $view_category eq 'ADMN'
        || $view_category eq 'HR' || $view_category eq 'PAYR') {  
      $stmt = ("select ROLESAPI_IS_USER_AUTHORIZED('$k_principal',"
         . "'VIEW AUTH BY CATEGORY', CONCAT('CAT' ,'$view_category')) from dual"
         . " union select 'Y' from dual"
         . " where exists (select authorization_id from authorization"
         . "   where kerberos_name = '$k_principal'"
         . "   and function_category in ('SAP', 'HR', 'PAYR')"
         . "   and do_function = 'Y'"
         . "   and NOW() between effective_date"
         . "   and IFNULL(expiration_date,NOW()))"
         . " ");
    }
    else {
      $stmt = ("select ROLESAPI_IS_USER_AUTHORIZED('$k_principal',"
            . "'VIEW AUTH BY CATEGORY', CONCAT('CAT' ,'$view_category')) from dual ");
    }
    $csr = $lda->prepare("$stmt") or die( $DBI::errstr . "\n"); 
    $csr->execute();
    $result  =  $csr->fetchrow_array();
    $csr->finish();
    if ($result eq 'Y') {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################
#
#  Subroutine &print_header($header, $http_https)
#
#  Prints a header, including the Roles DB logo. The variable $http_https
#  specifies 'http' or 'https', used for the URL for the Roles logo.
#  (Use https if the CGI script uses certificates;  otherwise, use http.)
#
###########################################################################
#sub print_header {
#    my ($header, $http_https) = @_;
#    my $host = $ENV{'HTTP_HOST'};
#    $host = ($host eq 'blue-goose.mit.edu') ? 'rolesweb.mit.edu' : $host;
#    print '<table><tr><td><img src="' . $http_https . '://' . $host 
#          . '/rolesmall.GIF"></td>'
#          . "<td><H2>$header</H2></td></tr></table>";
#}

###########################################################################
#
#  Subroutine &print_header($header, $http_https, $help_url)
#
#  Prints a header, including the Roles DB logo. The variable $http_https
#  specifies 'http' or 'https', used for the URL for the Roles logo.
#  (Use https if the CGI script uses certificates;  otherwise, use http.)
#  If the 3rd parameter is specified, it is used as a URL to a help page;
#  a question mark is printed at the upper right corner of the current Web
#  page linking to the help page.
#
###########################################################################
sub print_header {
    my ($header, $http_https, $help_url) = @_;
    my $host = $ENV{'HTTP_HOST'};
    $host = ($host eq 'blue-goose.mit.edu') ? 'rolesweb.mit.edu' : $host;
    if ($help_url) {
      print '<table width=100%>'
          . '<tr><td><a href="http://' . $host . '/webroles.html">'
          . '<img src="' . $http_https . '://' . $host 
          . '/rolesmall.GIF" no border></a></td>'
          . "<td><H2>$header</H2></td>"
          . '<td align=right valign=top><A HREF="' . $help_url . '">'
          . '<h1><i>?</i></h1></A></td></tr></table>';
    }
    else {
      print '<table>'
          . '<tr><td><a href="http://' . $host . '/webroles.html">'
          . '<img src="' . $http_https . '://' . $host 
          . '/rolesmall.GIF" no border></a></td>'
          . "<td><H2>$header</H2></td>"
          . '</tr></table>';
    }
}

###########################################################################
#
#  Subroutine &get_viewable_categories($lda, $kerbname, \%viewable_cat)
#
#  Returns a list of categories for which the user is allowed to view
#  authorizations.  Sets $viewable_cat{$cat} = (description) for each category.
#  (Does not presume that any EMPLOYEE can view all non-sensitive categories.)
#
###########################################################################
sub get_viewable_categories {
    my ($lda, $kerbname, $rviewable_cat) = @_;
    my ($vcat, $vcat_desc);
 
 #
 # Build select statement used in the query
 #
  my $stmt = "select function_category, function_category_desc"
           . " from category"
           . " where ROLESAPI_IS_USER_AUTHORIZED"
           . " ('$kerbname','VIEW AUTH BY CATEGORY',"
           . " CONCAT('CAT' ,rtrim(function_category))) = 'Y'"
           . " union select function_category, function_category_desc"
           . " from category c"  # people with SAP auths. can view SAP, META
           . " where c.function_category in ('SAP', 'META', 'LABD')"
           . " and exists (select authorization_id from authorization"
           . " where kerberos_name = '$kerbname'"
           . " and function_category = 'SAP'"
           . " and do_function = 'Y'"
           . " and NOW() between effective_date"
           . " and IFNULL(expiration_date, NOW()))"
           #. " and p.primary_person_type = 'E'"
           #. " union select function_category, function_category_desc"
           #. " from category c, person p"  # Where non-sensitive
           #. " where p.kerberos_name = '$kerbname'"
           #. " and p.primary_person_type = 'E'"
           #. " and nvl(c.auths_are_sensitive, 'N') = 'N'"
           #. " union select 'ALLNS', 'All non-sens. cat.'"
           #. " from person p"
           #. " where p.kerberos_name = '$kerbname'"
           #. " and p.primary_person_type = 'E'"
           . " union select 'ALL', 'All categories'"
           . " from dual"
           . " where ROLESAPI_IS_USER_AUTHORIZED"
           . " ('$kerbname','VIEW AUTH BY CATEGORY','CATALL') = 'Y'";
  #print $stmt;
  my $csr = $lda->prepare("$stmt") or &web_error( $DBI::errstr . "\n");
   $csr->execute(); 
 #
 #  Get a list of function categories
 #
  %$rviewable_cat = ();
  while (my @row  =  $csr->fetchrow_array())
  {
	($vcat, $vcat_desc) = @row;
	$$rviewable_cat{&strip($vcat)} = $vcat_desc;
  }
 
   $csr->finish() ;
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
 
return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################

