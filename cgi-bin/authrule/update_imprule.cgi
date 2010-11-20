#!/usr/bin/perl
###########################################################################
#
#  CGI script to call implied_auth_rule update procedure 
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
#  Modifications
#  Who     When       What
#  VSL     07/11/2008 Created
#  REPA    08/26/2008 Reformat the screen
###########################################################################
#
# Get packages
#
use rolesweb('login_dbi_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm

use rolesweb('parse_authentication_info'); #Use sub. parse_authentication_info in rolesweb.pm
use rolesweb('check_auth_source'); #Use sub. check_auth_source in rolesweb.pm
use rolesweb('verify_metaauth_category'); #Use sub. verify_metaauth_category
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm
use rolesweb('strip'); #Use sub. strip in rolesweb.pm


#
#  Print out the first line of the document
#
 print "Content-type: text/html", "\n\n";

#
#  Print out the http document header
#
 my $doc_title = 'Update a rule';
 print "<HTML>", "\n";
 print "<HEAD>"
  . "<TITLE>$doc_title</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 &print_header ($doc_title, 'https');
 print "<p /><hr /><p />";

#
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


#
#  Process form information
#
$request_method = $ENV{'REQUEST_METHOD'};
 if ($request_method eq "GET") {
    #print "Inside request method = GET <br>";
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
# Get specific form variables
#
 $fu = $k_principal;
 #$su = $formval{'s_usr'};
 $rid_in = $formval{'rid_in'};
 $rsn = $formval{'rsn'};
 $rd = $formval{'rd'};
 $rie = $formval{'rie'};

#
#  Hard-code server-user
#
 $su = 'rolewww9';

#
#  Diagnostic information
#
 #print "The update procedure is being called with following arguments: $fu, $
 #  su, $rid_in, $rsn, $rd, $rie <br>";

#
#  Get set to use DB.
#
use DBI;

#
# Login into the database
# 
 $lda = &login_dbi_sql('roles') 
      || die $DBI::errstr . "<BR>";

#
#  Web stem constants 
#
 $host = $ENV{'HTTP_HOST'};
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 ($mysubdir=$0) =~ s/^\S*cgi-bin// ; 
 $mysubdir =~ s!/?[^/]*/*$!!; #remove basename
 $url_stem = "https://$host/cgi-bin$mysubdir"; #implied rules url sub-directory 
 $main_progname="implied_auth_rules0.cgi";

#
#  Run the procedure and print out the results
#

 &do_update ($lda, $fu, $su, $rid_in, $rsn, $rd, $rie);


#
# Disconnect from the database and print end of document
#
 $lda->disconnect;

print "<form><input type=\"button\" value=\"Previous Step\" onclick=\"history\.go(-1)\;return false\;\" /></form>","\n";  

#print "<form><input type=\"button\" value=\"Main Page\" onclick=\"history\.go(-2)\;return false\;\" /></form>","\n";
 print "<a href=\"$main_progname\"><- To Main Page </a>"; 
 print "</BODY></HTML>", "\n";
 exit(0);

########### End of main block ############################################

sub do_update {

my ($lda, $fu, $su, $rid_in, $rsn, $rd, $rie ) = @_;


#print "<br>For User = $fu<br>";
#print "Server User = $su<br>";
my $rid_out = "";
# my $stmt = 
# qq{begin 
# 	rolesapi_update_imprule(
# 		:fu,
# 		:su,
# 		:in,
# 		:rsn,
# 		:rd,
# 		:rie,
# 		:out); 
# 	end;};
# my $crs = $lda->prepare($stmt);
# $crs->bind_param(":fu",$fu);
# $crs->bind_param(":su",$su);
# $crs->bind_param(":in",$rid_in);
# $crs->bind_param(":rsn",$rsn);
# $crs->bind_param(":rd",$rd);
# $crs->bind_param(":rie",$rie);
# $crs->bind_param_inout(":out",\$rid_out,10);
# $crs->execute;

my $cursor = $lda->prepare('CALL rolesapi_update_imprule(?,?,?,?,?,?,@ao_message)')
    || RolesError::death("Can't prepare database statement ($DBI::errstr)");
    # a failure to prepare the statement is probably an internal error,
    # hence handling by death
  $cursor->bind_param(1, $fu);
  $cursor->bind_param(2, $su);
  $cursor->bind_param(3, $rid_in);
  $cursor->bind_param(4, $rsn);
  $cursor->bind_param(5, $rd);
  $cursor->bind_param(6, $rie);
  $cursor->execute
    or return 0; # failed change

$error = get_db_error_msg($lda);
$message = "Rule number $rid_in ('$rsn') has been updated.";

if ($error){print "<p> <b><font color=red> $error \n</font></b>";}
  elsif (!$error){print "<p> <font color=green> $message \n</font>";}      
  $cursor-> finish;
  $lda -> commit;
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
      return "Error: $shorterr Error Number $err";
#       return "Error: $shorterr ";
    }

    return undef;
}
####################################################################




