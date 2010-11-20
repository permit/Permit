###############################################################################
## NAME: rolesweb.pm
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
## 3/9/2000   Jim Repa. -Add get_viewable_categories, web_error
##
###############################################################################
 
package rolesweb2;
$VERSION = 1.1;
$package_name = 'rolesweb2';
 
#Specify routines to be directly callable via the calling module without
#specifying the name of this package
use Oraperl;                            #Oracle interface (wrapper for DBI)
use Exporter;				#Standard Perl Module
@ISA = ('Exporter');			#Inherit from Exporter	
@EXPORT_OK = qw(get_database_info login_sql parse_forms parse_ssl_info
                check_cert_source verify_metaauth_category print_header
                get_viewable_categories web_error strip);
 
$TEST_MODE = 0;            ## Test Mode (1 == ON, 0 == OFF)
 
if ($TEST_MODE) {print "TEST_MODE is ON for rolesweb.pm\n";}
 
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
    my $fullpath = '/var/https/cgi-bin/' . $filename;
    my ($sym_db, $db, $user, $pw);
 
    unless (open(CONF,$fullpath)) {  # Open the config file
       print "<br><b>Cannot open the configuration file. <br>"
         . " The configuration file should be $fullpath<b>";
       exit();
    }
 
    while (chop($line = <CONF>)) {
      if ($line =~ /^$db_symbol\:/) {  # Look for the right line
        ($sym_db, $db, $user, $pw) = split(':',$line); # Parse db, user, pw
      }
    }
    close(CONF);  # Close the config file
    return ($db, $user, $pw);  # Return triplet of db, user, pw
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
 
        $ENV{'ORACLE_HOME'} = '/dbmsu001/app/oracle/product/8.1.6';

        for ($i = 0; $i < 3; $i++) {  # Retry 3 times
	    if ($lda = &ora_login($db, $user, $pw)) {
               return $lda;
	   }
        }
        print "Oracle connect to database '$db' failed after 3 tries.<BR>\n";
        print "$ora_errstr<BR>\n";
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
    my ($key, $value, $junk);
    my(@junk) = split(/\//,$info);   # Split up the pieces
    my(%SSL_INFO);  # Make a hash of the pieces
    foreach $junk (@junk)
    {
	($key, $value) = split(/=/,$junk);
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
    # Do we have both parameters?
    if ((!$k_principal) || (!$view_category)) { # Missing parameters
        return 0;
    }
    # Is the person an Employee and the category Non-sensitive?
    @stmt = ("select count(*)"
             . " from person p"
             . " where p.kerberos_name = '$k_principal'"
             . " and p.primary_person_type = 'E'"
             . " and"
             . " ((exists (select c.function_category from category c"
             . " where c.function_category = '$view_category'"
             . " and nvl(c.auths_are_sensitive,'N') = 'N'))"
             . " or ('$view_category' = 'ALLNS'))");
    $csr = &ora_open($lda, "@stmt")
        || &web_error($ora_errstr);
    ($result) = &ora_fetch($csr);
    &ora_close($csr);
    if ($result > 0) {
        return 1;
    }    
 
    # Is the person specifically authorized to view this category?
    $stmt = "select ROLESAPI_IS_USER_AUTHORIZED('$k_principal',"
      . "'VIEW AUTH BY CATEGORY', CONCAT('CAT' , '$view_category')) from dual";
    $csr = &ora_open($lda, "@stmt")
        || &web_error($ora_errstr);
     ($result) = &ora_fetch($csr);
    if ($result eq 'Y') {
        return 1;
    } else {
        return 0;
    }
    &ora_close($csr);
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
    if ($host =~ /cannonball/) {
      $header="THIS IS THE WRONG SERVER!  Go to the"
              . ' <a href="http://rolesweb.mit.edu">right server</a>'
              . "<BR>" . $header;  
    }
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
#  If the user is allowed to view all non-sensitive
#  categories, then sets $viewable_cat{'ALLNS'} to 'All non-sens. cat.'.
#  If the user is allowed to view all categories, including 
#  sensitive categories, then sets viewable_cat{'ALL'} also.
#
#  Any EMPLOYEE is automatically allowed to view all non-sensitive
#  categories.
#
###########################################################################
sub get_viewable_categories {
    my ($lda, $kerbname, $rviewable_cat) = @_;
    my ($vcat, $vcat_desc);
 
 #
 # Build select statement used in the query
 #
  my @stmt = ("select function_category, function_category_desc"
           . " from category"
           . " where ROLESAPI_IS_USER_AUTHORIZED"
           . " ('$kerbname','VIEW AUTH BY CATEGORY',"
           . " 'CAT' || rtrim(function_category,' ')) = 'Y'"
           . " union select function_category, function_category_desc"
           . " from category c, person p"  # Where non-sensitive
           . " where p.kerberos_name = '$kerbname'"
           . " and p.primary_person_type = 'E'"
           . " and nvl(c.auths_are_sensitive, 'N') = 'N'"
           . " union select 'ALLNS', 'All non-sens. cat.'"
           . " from person p"
           . " where p.kerberos_name = '$kerbname'"
           . " and p.primary_person_type = 'E'"
           . " union select 'ALL', 'All categories'"
           . " from dual"
           . " where ROLESAPI_IS_USER_AUTHORIZED"
           . " ('$kerbname','VIEW AUTH BY CATEGORY','CATALL') = 'Y'");
  my $csr = &ora_open($lda, "@stmt")
        || &web_error($ora_errstr);
    
 #
 #  Get a list of function categories
 #
  %$rviewable_cat = ();
  while (($vcat, $vcat_desc) = &ora_fetch($csr)) {
    $$rviewable_cat{&strip($vcat)} = $vcat_desc;
  }
 
  &ora_close($csr) || &web_error("can't close cursor");
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
 
