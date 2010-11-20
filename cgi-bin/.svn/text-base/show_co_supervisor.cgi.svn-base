#!/usr/bin/perl
###########################################################################
#
#  CGI script to display Cost Object supervisors and the list of
#  iiiiiiiiipppppp objects (supervisor/PC) related to each supervisor
#  from the PCCS hierarchy.  
#
#
#  Copyright (C) 2006-2010 Massachusetts Institute of Technology
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
#  Written 3/8/2006 Jim Repa
#
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

#
#  Web stem constants
#
 $host = $ENV{'HTTP_HOST'};
 $main_url = "http://$host/webroles.html";
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 $url_stem = "/cgi-bin/qualauth.pl?qualtype=PCCS&rootcode=";

#
#  Print out the first line of the document
#
  print "Content-type: text/html", "\n\n";

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
 #$input_string = $ARGV[0];
 %formval = ();  # Hash of reformatted key->variables populated by &parse_forms
 %rawval = ();  # Hash of unformatted key->variables populated by &parse_forms
 &parse_forms($input_string, \%formval, \%rawval); # Call sub. to parse input

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
#  Get set to use Oracle.
#
use DBI;

#
#  Get form variables
#
$letter = $formval{'letter'};  # Get value set in &parse_forms()
$letter =~ tr/a-z/A-Z/;  # Raise to upper case
unless($letter) {$letter = 'A';}

#
#  Make sure we are set up to use Oraperl.
#

#
# Login into the database
# 
$lda = login_dbi_sql('roles') 
      || die $DBI::errstr;

#
#  Print out the http document.  
#
 print "<HTML>", "\n";
 print "<HEAD><TITLE>Cost Object Supervisors</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 &print_header("Summary of Cost Object Supervisors - $letter*", 'http');
 print "<HR>", "\n";

#
#  Call subroutine to print out the table
#
 &co_supervisor_report($lda, $letter);

 #
 #  Print end of document, and drop connection to Oracle.
 #
 print "<HR>", "\n";
 print "<A HREF=\"$main_url\">"
  . "<small>Back to main perMIT web interface page</small></A>";
 print "</BODY></HTML>", "\n";
 $lda->disconnect() || die "can't log off Oracle";

 exit(0);

###########################################################################
#
#  Subroutine get_functions.
#
###########################################################################
sub co_supervisor_report {
  my ($lda, $letter) = @_;

  #
  #  Open a cursor for a select statement
  #
  my $stmt = 
  "select substr(qualifier_name, 1, instr(qualifier_name, '(')-2),
         'PC' || substr(qualifier_code, 1, 6), 
         qualifier_code   
    from qualifier
    where qualifier_type = 'PCCS'
    and length(qualifier_code) = 15
    and qualifier_name like '${letter}\%'
    order by 1, 2";
  #print "'$stmt'<BR>";
  my $csr = $lda->prepare("$stmt")
	|| die $DBI::errstr;
  $csr->execute();

  #
  # Start the table
  # 
   print "<table border>", "\n";
   print "<tr align=left><th>Supervisor Name</th>"
         . "<th>Profit Center</th><th>PC-supervisor code</th></tr>";
  
  #
  #  Get a list of supervisors and their PCs
  #
  my @sup_name = ();
  my @pc = ();
  my @pc_sup_code = ();
  my %sup_pc_count = ();
  my ($fsup_name, $fpc, $fpc_sup_code);
  
  while (  ($fsup_name, $fpc, $fpc_sup_code) = $csr->fetchrow_array() )
  {
    push(@sup_name, $fsup_name);
    push(@pc, $fpc);
    push(@sup_code, $fpc_sup_code);
    $sup_pc_count{$fsup_name}++;
  }
  $csr->finish() || die "can't close cursor";
  


  #
  #  Print a list of supervisors and their PCs
  #
   my $n = @sup_name;
   my $prev_sup_name = '';
   for ($i=0; $i < $n; $i++) {
      my $pc_url = $url_stem . $pc[$i] . "\&levels=2&sort=name";
      #print "'$pc_url'<BR>";
      my $pc_code_string 
           = "<a href=\"$pc_url\" target=\"new\">$pc[$i]</a>";
      my $sup_url = $url_stem . $sup_code[$i];
      my $sup_code_string 
           = "<a href=\"$sup_url\" target=\"new\">$sup_code[$i]</a>";
      if ($prev_sup_name eq $sup_name[$i]) {
         print "<tr align=left>"
           . "<td>$pc_code_string</td>"
           . "<td>$sup_code_string</td>"
   	   . "</tr>\n";
      }
      else {
         print "<tr align=left>"
           . "<td rowspan=\"$sup_pc_count{$sup_name[$i]}\">$sup_name[$i]</td>"
           . "<td>$pc_code_string</td>"
           . "<td>$sup_code_string</td>"
   	   . "</tr>\n";
         $prev_sup_name = $sup_name[$i];
      }
   }

 print "</TABLE>", "\n";

}


