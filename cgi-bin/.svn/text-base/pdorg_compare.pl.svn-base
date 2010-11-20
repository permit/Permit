#!/usr/bin/perl
###########################################################################
#
#  CGI script to display differences between APPROVER authorizations
#  in the PD Org and in the perMIT DB.
#
#  It just checks a person's meta-authorization to view SAP authorizations,
#  and if it's OK, it displays existing comparison files.
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
#  Written 7/26/99, Jim Repa
#
###########################################################################
#
# Get packages
#
use rolesweb('login_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('login_dbi_sql');   #Use sub. login_dbi_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
use rolesweb('parse_authentication_info'); #Use sub. parse_authentication_info in rolesweb.pm
use rolesweb('check_auth_source'); #Use sub. check_auth_source in rolesweb.pm
use rolesweb('verify_metaauth_category'); #Use sub. verify_metaauth_category
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm

#
#  Set constants
#
 $host = $ENV{'HTTP_HOST'};
 # URL to look up org unit
 $url_stem2 
  = "http://$host/cgi-bin/roleparent.pl?qualtype=ORGU+Org.+Unit+-+Personnel&";
 # Stem for a url for a users's authorizations
 $url_stem3 = "/cgi-bin/my-auth.cgi?&FORM_LEVEL=1&";  
 $main_url = "http://$host/webroles.html";
 $cat = 'SAP';
 $file_dir = '/export/home/webuser/pdorg/data/';
 $complete_file = $file_dir . 'pdorg_roles.compare';
 $abridged_file = $file_dir . 'pdorg_roles.compare2';

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
$show_all = $formval{'show_all'};  # Get value set in &parse_forms()
$show_all =~ tr/a-z/A-Z/;

#
#  Start printing HTML document
#
 $title = "APPROVER authorization differences: PD Org vs. perMIT DB";
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


use DBI;
#
# Login into the database
# 
$lda = login_dbi_sql('roles')  
      || &web_error($DBI::errstr);

#
# Make sure the user has a meta-authorization to view authorizations.
#
 if (!(&verify_metaauth_category($lda, $k_principal, $cat))) {
   print "Sorry.  You do not have the required perMIT DB 'meta-authorization'",
   " to view other people's $cat authorizations.";
   exit();
 }

#
#  Drop connection to Oracle.
#
$lda->disconnect() || &web_error("can't log off Oracle");    

#
#  Print out header
#
 print '<BODY bgcolor="#fafafa">';
 &print_header($title, 'https');

#
#  Print out the file of Roles/PD Org differences
#
 $filename = ($show_all eq 'Y') ? $complete_file : $abridged_file;
 &echo_file($filename);

#
# Print bottom of web page.
#
 print "<HR>";
 print "<A HREF=\"$main_url\"><small>Back to main perMIT web interface page"
       . "</small></A>";

 print "</BODY></HTML>", "\n";
 exit(0);

###########################################################################
#
#  Function &web_string($astring)
#
#  Converts spaces to '+', left parentheses to %28, 
#   right parentheses to %29
#
###########################################################################
sub web_string {
    my ($astring) = $_[0];
    $astring =~ s/ /+/g;
    $astring =~ s/\(/%28/g;
    $astring =~ s/\)/%29/g;
    $astring;
}

###########################################################################
#
#  Subroutine &echo_file($filename)
#
#  Read in the given file.
#  Print it out as an http document.
#
#
###########################################################################
sub echo_file {
  my ($filename) = @_;
  unless (open(IN,$filename)) {
    &web_error("Cannot open file '$filename' for reading<BR>");
  }
  my $line;
  print "<PRE>";
  my $n = 0;
  while (chomp($line = <IN>)) {
    print "$line\n";
    if ($line =~ / : SG_/) {
	$n++;
    }
  }
  print "\n\n$n discrepancies found\n";
  print "</PRE>";
  close (IN);
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

