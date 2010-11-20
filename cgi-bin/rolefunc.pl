#!/usr/bin/perl
###########################################################################
#
#  CGI script to list perMIT DB functions.
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
#  This CGI script is being phased out.  Along with rolepick.pl, it will
#  be replaced by rolefunc2.pl.  (JR - 7/24/2000)
#
###########################################################################
#
# Get packages
#
use rolesweb('login_dbi_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm

#
#  Web stem constants
#
 $host = $ENV{'HTTP_HOST'};
 $main_url = "http://$host/webroles.html";

#
#  Print out the first line of the document
#
 print "Content-type: text/html", "\n\n";

#
#  Process form information
#
 #read (STDIN, $input_string, $ENV{'CONTENT_LENGTH'});  # Read input string
 $input_string = $ARGV[0];
 %formval = ();  # Hash of reformatted key->variables populated by &parse_forms
 %rawval = ();  # Hash of unformatted key->variables populated by &parse_forms
 &parse_forms($input_string, \%formval, \%rawval); # Call sub. to parse input

#
#  Get set to use Oracle.
#
use DBI;

#
#  Get form variables
#
$category = $formval{'category'};  # Get value set in &parse_forms()
$cat = $category;
$cat =~ s/\W.*//;  # Keep only the first word.
$category =~ s/\w*\s//;  # Throw out first word.
$category =~ tr/A-Z/a-z/;  # Change to lower case 

#
# Login into the database
# 
$lda = login_dbi_sql('roles') 
      || die $DBI::errstr;

#
#  Get a list of functions
#
&get_functions($lda, $cat);

#
#  Print out the http document.  
#
 print "<HTML>", "\n";
 print "<HEAD><TITLE>perMIT DB List of Functions</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 &print_header("perMIT DB List of Functions", 'http');
 print "<HR>", "\n";
 print "<H2>Functions within category $cat ($category) </H2>\n\n";
 $n = @fid;  # How many functions?
 print "<TABLE>", "\n";
 printf "<TR><TH ALIGN=LEFT>%10s</TH><TH ALIGN=LEFT>%-30s</TH><TH ALIGN=LEFT>%-9s</TH><TH ALIGN=LEFT>%-8s</TH>"
        . "<TH ALIGN=LEFT>%s</TH></TR>\n",
        'Func. ID', 'Function Name', 'Qual Type', 'Mod by', 'Mod date';
 for ($i = 0; $i < $n; $i++) {
    $fdesc[$i] =~ tr/[A-Z]/[a-z]/;
    printf "<TR><TH ALIGN=LEFT>%10s</TH><TH ALIGN=LEFT>%-30s</TH><TH ALIGN=LEFT>%-9s</TH><TH ALIGN=LEFT>%-8s</TH>"
        . "<TH ALIGN=LEFT>%s</TH></TR>\n",
            $fid[$i], $fname[$i], $fqualtype[$i], $fmodby[$i], 
            $fmoddate[$i];
#    printf "<TR><TH ALIGN=LEFT>%10s</TH><TH ALIGN=LEFT>%-30s</TH><TH ALIGN=LEFT>%-9s</TH><TH ALIGN=LEFT>%-8s</TH>"
#        . "<TH ALIGN=LEFT>%s</TH></TR>\n",
#            ' ', '<SMALL>' . $fdesc[$i] . '</SMALL>' , ' ', ' ', ' ';
    printf "<TR><TH>%10s</TH><TH ALIGN=LEFT COLSPAN=4>%-30s</TH></TR>\n",
            ' ', '<SMALL>' . $fdesc[$i] . '</SMALL>' ;
    printf "<TR><TH>%10s</TH></TR>\n",
            ' ';
 }
 print "</TABLE>", "\n";
 print "<HR>", "\n";
 print "<A HREF=\"$main_url\">"
  . "<small>Back to main perMIT web interface page</small></A>";
 print "</BODY></HTML>", "\n";
 exit(0);

###########################################################################
#
#  Subroutine get_functions.
#
###########################################################################
sub get_functions {
  my ($lda, $picked_cat) = @_;

  #
  #  Open connection to oracle
  #
  @stmt = ("select function_id, function_name, function_description,"
           . " qualifier_type, modified_by, modified_date"
           . " from function"  
           . " where function_category = '$picked_cat'"
           . " order by function_name");
  $csr = $lda->prepare("$stmt")
	|| die $DBI::errstr;
  
 unless ($csr->execute) {
      print "Error executing select statement 1: '$stmt' " . $DBI::errstr . "<BR>";
  }

  #
  #  Get a list of functions
  #
  @fid = ();
  @fname = ();
  @fdesc = ();
  @fqualtype = ();
  @fmodby = ();
  @fmoddate = ();
  while ((($ffid, $ffname, $ffdesc, $ffqualtype, $ffmodby, $ffmoddate) 
         = $csr->fetchrow_array())) 
  {
  	# mark any NULL fields found
	grep(defined || 
          ($_ = '<NULL>'), 
           $ffid, $ffname, $ffdesc, $ffqualtype, $ffmodby, $ffmoddate);
        push(@fid, $ffid);
        push(@fname, $ffname);
        push(@fdesc, $ffdesc);
        push(@fqualtype, $ffqualtype);
        push(@fmodby, $ffmodby);
        push(@fmoddate, $ffmoddate);
        #print "$ffid, $ffname, $ffqualtype, $ffmodby, $ffmoddate \n";
  }
  $csr->finish() || die "can't close cursor";

  #
  #  Drop connection to Oracle.
  #
  $lda->disconnect() || die "can't log off DB";
}

