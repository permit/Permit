#!/usr/bin/perl
##############################################################################
#
# CGI script to display function categories in which a person either
#   -- has current authorizations
#   -- has a history of authorizations
#   -- has made authorization changes
#
#
#  Copyright (C) 2001-2010 Massachusetts Institute of Technology
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
# Changes that should be made:
#   > Allow user to run this if he/she has RUN ADMIN REPORTS auth. or
#     view auths. in all categories
#   > Determine which authorization categories the person is allowed to
#     view.  Use this to determine whether to link the '*' for various
#     categories to URLs that let the user see additional information. 
#   > Add target user's first_name, last_name, primary_person_type, and
#     department.
#
# Written by Jim Repa, 7/2/2001
#
##############################################################################
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

#
#  Set constants
#
$host = $ENV{'HTTP_HOST'};
# Stem for a url for a users's authorizations
$url_stem1 = "https://$host/cgi-bin/my-auth.cgi?FORM_LEVEL=1&";
$url_stem2 = "https://$host/cgi-bin/audit_trail.pl?";
$url_stem3 = "https://$host/cgi-bin/audit_trail.pl?time_period=All&";

#
# Get start time
#
 $epoch = time();

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
$picked_user = $formval{'kerbname'};
$picked_user =~ tr/a-z/A-Z/;

#
#  Print beginning of the document
#    
print "Content-type: text/html\n\n";  # Start generating HTML document
print "<head><title>Authorizations by Category for a Person</title>"
      . "</head>\n<body>";
print '<BODY bgcolor="#fafafa">';
&print_header
   ("Authorizations by Category for $picked_user", 'https');

#
#  Check parameters
#
if (!$picked_user) {
  print "Error: No Kerberos username was specified.<BR>";
  die;
}

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
 
$lda = login_dbi_sql('roles') || die "$DBI::errstr . \n";

#
#  Make sure the user has a meta-authorization to view all authorizations
#  in the given category.
#
$cat = 'ALL';  ###<<<<<<<<<<<<<<<<<<<####
if (!(&verify_metaauth_category($lda, $k_principal, $cat))) {
  print "Sorry.  You do not have the required perMIT DB 'meta-authorization'",
  " to view other people's category '$cat' authorizations.";
  exit();
}

#
#  Print categories in which the user has authorizations
#
print "<P>";
&print_user_auth_categories($lda, $picked_user);

#
#  Drop connection to Oracle and write trailer of document.
#
 $lda->disconnect;

 print "<HR>";
 $seconds = time() - $epoch;
 print "<small>Run time = $seconds seconds.</small><br>";
 print "<A HREF=\"$main_url\"><small>Back to main perMIT web interface page</small></A>";
 print "</BODY></HTML>", "\n";
 exit();

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

###########################################################################
#
#  Subroutine print_user_auth_categories
#
#  Prints out categories in which the given user has current authorizations,
#  has a history of authorizations, or has updated authorizations.
#
###########################################################################
sub print_user_auth_categories {
  my ($lda, $picked_user) = @_;
  my ($where, $csr, $stmt, 
      $aamodby1, $aamodby2, $aakerbname, $aafn, $aaqc1, $aaqc2);

 #
 #  Print out introductory paragraph.
 #
  #print "Below is information about $picked_user<br>";

 #
 #  Get a hash of all categories and their descriptions.  We'll use
 #  the descriptions for displaying the information about the user's
 #  authorizations and authorization history.
 #
  my %cat_desc;
  &get_all_categories($lda, \%cat_desc);
  
 #
 #  Get a list of categories in which the person has current 
 #   authorizations.
 #
  my @current_cat;
  my @current_cat_desc;
  &list_current_auth_categories ($lda, $picked_user, \@current_cat);
  my $n = @current_cat;
  my $link_string;
  my $temp_cat;
  if ($n) {
    print "<p>$picked_user currently has authorizations in the"
          . " following categories:<BR>";
    print "<blockquote>";  # Indent
    print "<table border>\n";
    print "<tr><th>Category</th><th>Description</th>"
          . "<th>Show current<br>authorizations</th></tr>\n";
    for ($i = 0; $i < $n; $i++) {
      unless ($temp_cat = $cat_desc{$current_cat[$i]}) {$temp_cat="unknown";}
      $link_string = "<A HREF=\"${url_stem1}category=" 
                . &web_string("$current_cat[$i] $temp_cat")
                . "&username=$picked_user"
                . "\">*</A>";
      print "<tr><td>$current_cat[$i]</td><td>$temp_cat"
            . "</td><td>$link_string</td></tr>\n";
    }
    print "</table>\n";
    print "</blockquote>";  # Unindent
  }
  else {
    print "<p>$picked_user does not currently have any authorizations.<BR>";
  }

 #
 #  Get a list of categories in which the person has a history of
 #  authorizations or has modified authorizations.
 #
  my @history_cat;
  my @history_cat_desc;
  my @modified_cat;
  my @modified_cat_desc;
  &list_history_auth_categories2 ($lda, $picked_user, 
                                  \@history_cat, \@modified_cat);

 #
 #  Print a list of categories in which the person has a history of having
 #  authorizations.
 #
  $n = @history_cat;
  if ($n) {
    print "<p>The audit trail has a record of authorizations for $picked_user"
          . " in following categories:<BR>";
    print "<blockquote>";  # Indent
    print "<table border>\n";
    print "<tr><th>Category</th><th>Description</th>"
          . "<th>Show history of<br>${picked_user}'s"
          . "<br>authorizations</th></tr>\n";
    for ($i = 0; $i < $n; $i++) {
      $link_string = "<A HREF=\"${url_stem2}category=" 
                . &web_string("$history_cat[$i] $history_cat_desc[$i]")
                . "&kerbname=$picked_user"
                . "\">*</A>";
      unless ($temp_cat = $cat_desc{$history_cat[$i]}) {$temp_cat="obsolete";}
      print "<tr><td>$history_cat[$i]</td><td>$temp_cat"
            . "</td><td>$link_string</td></tr>\n";
    }
    print "</table>\n";
    print "</blockquote>";  # Unindent
  }
  else {
    print "<p>There is no history of past authorizations for $picked_user."
          . "<BR>";
  }

 #
 #  Print a list of categories in which the person has modified authorizations.
 #
  $n = @modified_cat;
  if ($n) {
    print "<p>$picked_user has maintained authorizations in the"
          . " following categories:<BR>";
    print "<blockquote>";  # Indent
    print "<table border>\n";
    print "<tr><th>Category</th><th>Description</th>"
          . "<th>Show authorization<br>changes made by"
          . "<br>$picked_user</th></tr>\n";
    for ($i = 0; $i < $n; $i++) {
      $link_string = "<A HREF=\"${url_stem3}category=" 
                . &web_string("$modified_cat[$i] $modified_cat_desc[$i]")
                . "&modname=$picked_user"
                . "\">*</A>";
      unless ($temp_cat = $cat_desc{$modified_cat[$i]}) {$temp_cat="obsolete";}
      print "<tr><td>$modified_cat[$i]</td><td>$temp_cat"
            . "</td><td>$link_string</td></tr>\n";
    }
    print "</table>\n";
    print "</blockquote>";  # Unindent
  }
  else {
    print "<p>$picked_user has not created, deleted, or updated any"
          . " authorizations.<BR>";
  }
}

###########################################################################
#
#  Subroutine &get_all_categories($lda, \%cat_desc);
#
#  Builds a hash of categories and their descriptions
#
###########################################################################
sub get_all_categories {
  my ($lda, $rcat_desc) = @_;
  my ($csr, $stmt); 

 #
 #  Define the select statement.
 #
  $stmt = "select c.function_category, c.function_category_desc"
     . " from category c";
  #print $stmt . "<br>";

 #
 #  Prepare the statement.
 #
  unless ($csr = $lda->prepare($stmt)) 
  {
     print "Error preparing statement.<BR>";
     print $lda->errstr;
     print "<BR>";
     die;
  }

 #
 #  Execute the cursor.  (No bind necessary here.)
 #
  $csr->execute;
        
 #
 #  Fetch records from the query to get a list of categories and their
 #  descriptions.
 #
 my ($category, $cat_description);
 while (($category, $cat_description) = $csr->fetchrow_array)
 {
   $$rcat_desc{$category} = $cat_description;
 }
 $csr->finish;

}

###########################################################################
#
#  Subroutine &list_current_auth_categories
#
#  Finds a list of categories in which the person has current 
#  authorizations.
#
###########################################################################
sub list_current_auth_categories {
  my ($lda, $picked_user, $rcurrent_cat) = @_;
  my ($csr, $stmt); 

 #
 #  Define the select statement.
 #
  $stmt = "select distinct a.function_category, c.function_category_desc"
     . " from authorization a, category c"
     . " where a.kerberos_name = '$picked_user'"
     . " and c.function_category = a.function_category";
  #print $stmt . "<br>";

 #
 #  Prepare the statement.
 #
  unless ($csr = $lda->prepare($stmt)) 
  {
     print "Error preparing statement.<BR>";
     print $lda->errstr;
     print "<BR>";
     die;
  }

 #
 #  Execute the cursor.  (No bind necessary here.)
 #
  $csr->execute;
        
 #
 #  Fetch records from the query to get a list of categories where
 #  the person has current authorizations.
 #
 my $count = 0;
 my ($category, $cat_description);
 while (($category, $cat_description) = $csr->fetchrow_array)
 {
   $count++;
   push (@$rcurrent_cat, $category);
   push (@$rcurrent_cat_desc, $cat_description);
 }
 $csr->finish;

}

###########################################################################
#
#  Subroutine &list_modified_auth_categories
#
#  Finds a list of categories in which the person has modified 
#  authorizations.
#
###########################################################################
sub list_modified_auth_categories {
  my ($lda, $picked_user, $rmodified_cat, $rmodified_cat_desc) = @_;
  my ($csr, $stmt); 

 #
 #  Define the select statement.
 #
  $stmt = "select distinct a.function_category, c.function_category_desc"
     . " from auth_audit a, category c"
     . " where a.roles_username = '$picked_user'"
     . " and c.function_category = a.function_category";
  #print $stmt . "<br>";

 #
 #  Prepare the statement.
 #
  unless ($csr = $lda->prepare($stmt)) 
  {
     print "Error preparing statement.<BR>";
     print $lda->errstr;
     print "<BR>";
     die;
  }

 #
 #  Execute the cursor.  (No bind necessary here.)
 #
  $csr->execute;
        
 #
 #  Fetch records from the query to get a list of categories where
 #  the person has modified authorizations.
 #
 my $count = 0;
 my ($category, $cat_description);
 while (($category, $cat_description) = $csr->fetchrow_array)
 {
   $count++;
   push (@$rmodified_cat, $category);
   push (@$rmodified_cat_desc, $cat_description);
 }
 $csr->finish;

}

###########################################################################
#
#  Subroutine &list_history_auth_categories2
#
#  Looks in the audit trail (AUTH_AUDIT).
#  Finds 
#   -- list of categories in which the person has had authorizations
#   -- list of caterories in which the person has made auth changes
#
###########################################################################
sub list_history_auth_categories2 {
  my ($lda, $picked_user, 
      $rhistory_cat, $rmodified_cat) = @_;
  my ($csr, $stmt); 

 #
 #  Define the select statement.
 #
  $stmt = "select distinct a.function_category, a.roles_username,"
     . " a.kerberos_name"
     . " from auth_audit a"
     . " where a.roles_username = '$picked_user'"
     . " or a.kerberos_name = '$picked_user'";
  #print $stmt . "<br>";

 #
 #  Prepare the statement.
 #
  unless ($csr = $lda->prepare($stmt)) 
  {
     print "Error preparing statement.<BR>";
     print $lda->errstr;
     print "<BR>";
     die;
  }

 #
 #  Execute the cursor.  (No bind necessary here.)
 #
  $csr->execute;
        
 #
 #  Fetch records from the query to get a list of categories where
 #  the person has had or has modified authorizations.
 #  Use the two hashes %history_cat and %mod_cat to build
 #  a non-redundant list of categories where the user has had authorizations
 #  (%history_cat) or has modified them (%mod_cat).
 #
 my $count = 0;
 my ($category, $roles_user, $kerb_user);
 my %mod_cat = ();
 my %history_cat = ();
 while (($category, $roles_user, $kerb_user) = $csr->fetchrow_array)
 {
   $count++;
   if ($roles_user eq $picked_user) {
     $mod_cat{$category} = 1;
   }
   if ($kerb_user eq $picked_user) {
     $history_cat{$category} = 1;
   }
 }
 $csr->finish;

 #
 #  Now put the categories from the two hashes into two arrays.
 #
 my $temp_desc;
 foreach $category (sort keys %history_cat) {
   push (@$rhistory_cat, $category);
 }
 foreach $category (sort keys %mod_cat) {
   push (@$rmodified_cat, $category);
 }

}

###########################################################################
#
#  Subroutine &list_history_auth_categories
#
#  Finds a list of categories in which the person has had authorizations
#  in the past.
#
###########################################################################
sub list_history_auth_categories {
  my ($lda, $picked_user, $rhistory_cat, $rhistory_cat_desc) = @_;
  my ($csr, $stmt); 

 #
 #  Define the select statement.
 #
  $stmt = "select distinct a.function_category, c.function_category_desc"
     . " from auth_audit a, category c"
     . " where a.kerberos_name = '$picked_user'"
     . " and c.function_category = a.function_category";
  #print $stmt . "<br>";

 #
 #  Prepare the statement.
 #
  unless ($csr = $lda->prepare($stmt)) 
  {
     print "Error preparing statement.<BR>";
     print $lda->errstr;
     print "<BR>";
     die;
  }

 #
 #  Execute the cursor.  (No bind necessary here.)
 #
  $csr->execute;
        
 #
 #  Fetch records from the query to get a list of categories where
 #  the person has a history of authorizations.
 #
 my $count = 0;
 my ($category, $cat_description);
 while (($category, $cat_description) = $csr->fetchrow_array)
 {
   $count++;
   push (@$rhistory_cat, $category);
   push (@$rhistory_cat_desc, $cat_description);
 }
 $csr->finish;

}

###########################################################################
#
#  Function
#     &get_more_auth_info($lda, $csr2, $kerbname, $funcname, $qualcode);
#
#  Returns ($authorization_id, $modified_by) from a select statement
#  on the authorization table.
#
###########################################################################
sub get_more_auth_info {
  my ($lda, $csr2, $kerbname, $funcname, $qualcode) = @_;
  $csr2->bind_param(1, $kerbname);
  $csr2->bind_param(2, $funcname);
  $csr2->bind_param(3, $qualcode);
  $csr2->execute;
  my ($auth_id, $modified_by) = $csr2->fetchrow_array;
  return ($auth_id, $modified_by);
}

###########################################################################
#
#  Function &web_string($astring)
#
#  Converts spaces to '+', left parentheses to %28, 
#   right parentheses to %29, and '&' to %26.
#
###########################################################################
sub web_string {
    my ($astring) = $_[0];
    $astring =~ s/ /+/g;
    $astring =~ s/\(/%28/g;
    $astring =~ s/\)/%29/g;
    $astring =~ s/\&/%26/g;
    $astring;
}
