#!/usr/bin/perl
###########################################################################
#
#  CGI script to list perMIT DB function categories.
#
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
###########################################################################
#
# Get packages
#
use rolesweb('login_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('login_dbi_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm

#
#  Print the document header
#
 print "Content-type: text/html", "\n\n";
 print "<HTML>", "\n";
 print "<HEAD><TITLE>perMIT DB List of Categories</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 &print_header("<BODY>perMIT DB List of Categories", 'http');

#
#  Make sure we are set up to use Oraperl.
#
use DBI;

#
# Login into the database
# 
$lda = login_dbi_sql('roles')  
      || die $DBI::errstr;

#
#  Get the categories and list them.
#
&get_categories($lda);

#
#  Print out the http document.  
#
 $n = @cat;  # How many categories?
 #print '<FORM METHOD="POST" ACTION="/cgi-bin/rolepick.pl">', "\n";
 print '<FORM METHOD="GET" ACTION="/cgi-bin/rolefunc2.pl">', "\n";
 print "<HR>";
 print "<BR>To see a list of functions associated with a category, select"
    . ' a category and click on "List Functions":';
 print "<PRE>";
 print "<SELECT NAME=\"category\" SIZE=$n>";

 $option_string = '<OPTION SELECTED>';   # First option string
 for ($i = 0; $i < $n; $i++) {
   printf "%s %-5s %s\n", $option_string, $cat[$i], $catdesc[$i];
   $option_string = '<OPTION>';   # Subsequent option strings
 }

 print "<PRE>";
 print "</SELECT>", "\n";
 #print "<HR>";
 #print '<INPUT TYPE="radio" name="request_type" value="LIST_AUTH" checked>'
 # . 'List authorizations', "\n";
 #print "<BR>", "\n";
 #print '<INPUT TYPE="radio" name="request_type" value="LIST_FUNC">'
 # . 'List functions', "\n";
 print "<BR>", "\n";
 print "<BR>", "\n";
 print '<INPUT TYPE="SUBMIT" VALUE="List Functions">';
 print "<HR>", "\n";
 print "</FORM>", "\n";
 print "</BODY></HTML>", "\n";

 exit(0);

exit();

###########################################################################
#
#  Subroutine get_categories.
#
###########################################################################
sub get_categories {
  my $lda = $_[0];

  #
  #  Open connection to oracle
  #
  @stmt = ("select FUNCTION_CATEGORY, FUNCTION_CATEGORY_DESC from CATEGORY"
           . " order by FUNCTION_CATEGORY");
  $csr = $lda->prepare("$stmt")
	|| die $DBI::errstr;
  $csr->execute(); 
  #
  #  Get a list of function categories
  #
  @cat = ();
  @catdesc = ();
  $i = 0;
  while ((($category,$category_d) = $csr->fetchrow_array())) {
  	# mark any NULL fields found
	grep(defined || 
          ($_ = '<NULL>'), $category,$category_d);
        push(@cat, $category);
        push(@catdesc, $category_d);
  }
  $csr->finish() || die "can't close cursor";

  #
  #  Drop connection to Oracle.
  #
  $lda->disconnect() || die "can't log off Oracle";
}

 
