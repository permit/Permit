#!/usr/bin/perl
##############################################################################
#
# CGI script to display redundant Authorizations for a person
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
# Written by Jim Repa, 3/9/1999
# Modified by Jim Repa, 3/11/1999 (add option of looking at a branch of tree)
# Mod. by Jim Repa, 7/7/00.  Changed select '' to ' '. Oracle 8 difference?
#
##############################################################################
#
# Get packages
#
use rolesweb('login_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
use rolesweb('parse_ssl_info'); #Use sub. parse_ssl_info in rolesweb.pm
use rolesweb('check_cert_source'); #Use sub. check_cert_source in rolesweb.pm
use rolesweb('verify_metaauth_category'); #Use sub. verify_metaauth_category
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm

#
#  Define "big branches", nodes in the hierarchies that have so many
#  children that we cannot allow multiple-level expansion until the
#  user picks something more specific.
#
 @big_branch = qw(0HPC00_MIT 0HPC0 0HPC00 0HPC000 0HPC001
                  0HPC00002 0HPC00005 0HPC00006
                  FCMIT FC100000 FC_CUSTOM FC100001
                  FC100012 FC100015 FC100017
                  FC_CENTRAL FC_SCHOOL_SCI FC_VPRES
                 );

#
#  Set constants
#
$host = $ENV{'HTTP_HOST'};
# Stem for a url for a users's authorizations
$url_stem = "https://$host/cgi-bin/my-auth.cgi?category=SAP+SAP&FORM_LEVEL=1&";

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
$modify_user = $formval{'modname'};
$modify_user =~ tr/a-z/A-Z/;
$qual_branch = $formval{'qualbranch'};
$qual_branch =~ tr/a-z/A-Z/;
$category = $formval{'category'};
$cat = $category;
$cat = &strip($cat);
($cat, $junk) = split(' ', $cat);
$cat =~ tr/a-z/A-Z/; # Raise to upper case

#
#  Print beginning of the document
#    
print "Content-type: text/html\n\n";  # Start generating HTML document
print "<head><title>Redundant Authorizations</title></head>\n<body>";
print '<BODY bgcolor="#fafafa">';
&print_header
   ("Redundant authorizations", 'https');

#
#  Check parameters
#
if ( (!$picked_user) && (!$modify_user) && (!$qual_branch)) {
  print "Error: No Kerberos username, qualifier branch, or modify username"
        . " was specified.<BR>";
  die;
}
if (!$category) {
  print "Error: No category was specified.<BR>";
  die;
}

#
#  If qual_branch was specified, make sure it's not one of the big branches.
#
 $is_big_branch = 0;  # Default -- not a big branch
 foreach $node (@big_branch) {
   if ($qual_branch eq $node) {
     $is_big_branch = 1;
     last;
   }
 }
 if ($is_big_branch) {
   print "You picked '$qual_branch', but this branch of the hierarchy has"
       . " too many qualifiers.  You must pick a smaller branch.<BR>";
   die;
 }

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
#  Get set to use Oracle.
#
use DBI;
use Oraperl;  # Point to library of Oracle-related subroutines for Perl
if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}
 
#
# Login into the database
# 
unless($lda = &login_sql('roles')) {
   print $ora_errstr;
   die $ora_errstr;
}

#
#  Make sure the user has a meta-authorization to view all authorizations
#  in the given category.
#
if (!(&verify_metaauth_category($lda, $k_principal, $cat))) {
  print "Sorry.  You do not have the required Roles DB 'meta-authorization'",
  " to view other people's category '$cat' authorizations.";
  exit();
}

#
#  Print redundant authorizations
#
print "<P>";
&print_redundant_auths($lda, $picked_user, $modify_user, $qual_branch, $cat);
print "<HR>";
exit();

#
# Print form allowing user to run another report
#
#&allow_another_report($lda, $k_principal);

#
#  Drop connection to Oracle.
#
$lda->disconnect;

print "<hr>";
print "For questions on this service, please send E-mail to rolesdb\@mit.edu";


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
#  Subroutine allow_another_report
#   
#  Prints out the categories from which the superuser, $k_prinicipal,
#  is allowed to choose, if he wants to view another user's authorizations.
#
###########################################################################
sub allow_another_report {
    my ($lda, $k_principal) = @_;
    my (@stmt, $csr, @superuser_cat, @supersuer_catdesc, $superuser_category, $superuser_category_d, $i, $option_string, $n);
        
    #
    # Print out FORM stuff to allow a call for a different qualifier
    #
    
    print '<FORM METHOD="GET" ACTION="sap-auth.cgi">';
    print "Specify another Fund Center and click SUBMIT to display another"
          . " report of SAP authorizations for users who can spend/commit"
          . " within a given Fund Center or its descendents.<BR>";
    print "<CENTER>";
    print "<h4>Qualifier code: <INPUT TYPE=TEXT NAME=qualcode></h4><br>";
    
    print '<INPUT TYPE="SUBMIT" VALUE="Submit">',"\n";
    print "</CENTER>";
    print "</FORM>", "\n";
    
}

###########################################################################
#
#  Subroutine print_redundant_auths.
#
#  Prints out redundant authorizations
#
###########################################################################
sub print_redundant_auths {
  my ($lda, $picked_user, $modify_user, $qual_branch, $cat) = @_;
  my ($where, $csr, $stmt, 
      $aamodby1, $aamodby2, $aakerbname, $aafn, $aaqc1, $aaqc2);
  my ($modify_by1, $kerbstring, $old_qc1, $old_fn, $old_kerbname);

 #
 #  Print out introductory paragraph.
 #
  print "Below is a list of redundant authorizations";
  print " in category $cat";

 #
 #  Define the select statement and add a phrase to the introductory
 #  paragraph.
 #
  my $stmt;
  if ($picked_user) {
    $kerbstring = '<A HREF="' . $url_stem . 'username=' . $picked_user
		   . '">' . $picked_user . "</A>";
    print " for user $kerbstring. ";
    $csr2 = &open_another_cursor($lda);  # Open 2nd cursor
    # In the following line, changed '' to ' ' on 7/7/2000 for Oracle 8.
    $stmt = "select ' ', a1.modified_by, a1.kerberos_name,"
     . " a1.function_name, q.qualifier_code, a1.qualifier_code"
     . " from authorization a1, qualifier_descendent qd, qualifier q"
     . " where a1.kerberos_name = '$picked_user'"
     . " and a1.qualifier_id = qd.child_id"
     . " and qd.parent_id = q.qualifier_id"
     . " and sysdate between a1.effective_date"
     . " and nvl(a1.expiration_date,sysdate)"
     . " and exists (select a2.authorization_id from authorization a2"
     . " where a2.do_function = a1.do_function"
     . " and replace(a2.grant_and_view, 'V ', 'N ')"
     . "   = replace(a1.grant_and_view, 'V ', 'N ')"
     . " and a2.kerberos_name = a1.kerberos_name"
     . " and a2.function_name = a1.function_name"
     . " and a2.qualifier_id = q.qualifier_id"
     . " and sysdate between a2.effective_date"
     . " and nvl(a2.expiration_date,sysdate))"
     . " order by a1.kerberos_name, a1.function_name, q.qualifier_code";
  }
  elsif ($qual_branch) {
    print " for authorizations in the branch of the"
          . " hierarchy starting at $qual_branch. ";
    $stmt = "select /*+ ORDERED */ a1.modified_by,"
    . " a2.modified_by, a1.kerberos_name,"
    . " a1.function_name, a1.qualifier_code, a2.qualifier_code"
    . " from authorization a2, qualifier_descendent qd, authorization a1"
    . " where a2.qualifier_id in"
    . " (select child_id from qualifier_descendent"
    . " where parent_id in (select qualifier_id from qualifier where"
    . " qualifier_code = '$qual_branch')"
    . " union select qualifier_id from qualifier"
    . " where qualifier_code = '$qual_branch')"
    . " and a2.function_category = '$cat'"
    . " and a1.do_function = a2.do_function"
    . " and replace(a2.grant_and_view, 'V ', 'N ')"
    . "   = replace(a1.grant_and_view, 'V ', 'N ')"
    . " and a1.kerberos_name = a2.kerberos_name"
    . " and a1.function_id = a2.function_id"
    . " and a1.qualifier_id = qd.parent_id"
    . " and a2.qualifier_id = qd.child_id and"
    . " sysdate between a1.effective_date and nvl(a1.expiration_date,sysdate)"
    . " and"
    . " sysdate between a2.effective_date and nvl(a2.expiration_date,sysdate)"
    . " order by a1.kerberos_name, a1.function_name, a1.qualifier_code, "
    . " a2.qualifier_code";
    #print $stmt;
    #print "<BR>";
    #exit();
  }
  else {
    print " where either the redundant authorization or the"
        . " \"parent\" authorization was last modified by $modify_user. ";
    $stmt = "select a1.modified_by, a2.modified_by, a1.kerberos_name,"
    . " a1.function_name, a1.qualifier_code, a2.qualifier_code"
    . " from authorization a1, authorization a2, qualifier_descendent qd"
    . " where (a1.modified_by = '$modify_user'"
    . " or a2.modified_by = '$modify_user')"
    . " and a1.function_category = '$cat'"
    . " and a1.do_function = a2.do_function"
    . " and replace(a2.grant_and_view, 'V ', 'N ')"
    . "   = replace(a1.grant_and_view, 'V ', 'N ')"
    . " and a1.kerberos_name = a2.kerberos_name"
    . " and a1.function_id = a2.function_id"
    . " and a1.qualifier_id = qd.parent_id"
    . " and a2.qualifier_id = qd.child_id and"
    . " sysdate between a1.effective_date and nvl(a1.expiration_date,sysdate)"
    . " and"
    . " sysdate between a2.effective_date and nvl(a2.expiration_date,sysdate)"
    . " order by a1.kerberos_name, a1.function_name, "
    . " a1.qualifier_code, a2.qualifier_code";
  }
  #print $stmt . "<BR>";
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
 #  Print the header
 #
 print << 'ENDOFTEXT';
Each line beginning with a Function Name represents two authorizations: 
an authorization with the
"parent" qualifier and another one, for the same person and function, with
a qualifier that is a subset of the parent qualifier.  
The second authorization can be deleted, since it is implied by the first.
ENDOFTEXT
 print "<pre>";
 print << 'ENDOFTEXT';
-----------------------------------------------------------------------------------------
Kerberos Function                       Parent          Modified Redundant       Modified
Username Name                           Qualifier       <- By    Qualifier       <- By 
-----------------------------------------------------------------------------------------
ENDOFTEXT

 #
 #  Fetch records from the query to get redundant authorizations, 
 #  and print out the results.
 #
 my $count = 0;
 while (($aamodby1, $aamodby2, $aakerbname, $aafn, $aaqc1, $aaqc2)
  = $csr->fetchrow_array)
 {
   $count++;
   $aamodby1 = &strip($aamodby1);  # Fix made 7/7/2000
   #print $count . "<BR>";
   if ($csr2 && ($aaqc1 ne $old_qc1 || $aafn ne $old_fn)) {
     ($aaid, $modify_by1) = 
      &get_more_auth_info($lda, $csr2, $aakerbname, $aafn, $aaqc1);
     $old_qc1 = $aaqc1;
     $old_fn = $aafn;
   }
   if (!$picked_user && !$auth_branch) { # Is this report by modified_by field?
     if ($aakerbname ne $old_kerbname) {
       $kerbstring = '<A HREF="' . $url_stem . 'username=' . $aakerbname
         . '">' . $aakerbname . "</A>";
       print "</pre>$kerbstring<pre>";
       $old_kerbname = $aakerbname;
     }
     $aakerbname = '        ';  # Don't show user on each line for this report
   }
   $modify_by1 = ($aamodby1) ? $aamodby1 : $modify_by1;
   printf "%-8s %-30s %-15s %-8s %-15s %-8s\n",
        $aakerbname, $aafn, $aaqc1, $modify_by1, $aaqc2, $aamodby2;
 }
 print "\n$count lines displayed\n";
 print "</pre>";
 $csr->finish;
 if ($csr2) {$csr2->finish;}

}

###########################################################################
#
#  Function &open_another_cursor($lda)
#
#  Opens a cursor for a select statement (to get authorization_id and
#   modified_by fields for a given authorization), and returns
#   a cursor handle.
#
###########################################################################
sub open_another_cursor {
  my ($lda) = @_;
  my ($stmt2, $csr2);
  my $stmt2 = "select authorization_id, modified_by from authorization"
       . " where kerberos_name = ?"
       . " and function_name = ?"
       . " and qualifier_code = ?";
  unless ($csr2 = $lda->prepare($stmt2)) 
  {
     print "Error preparing statement.<BR>";
     print $lda->errstr;
     print "<BR>";
     die;
  }
  return $csr2;
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

