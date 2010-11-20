#!/usr/bin/perl
###########################################################################
#
#  CGI script to display some miscellaneous reports.  These reports
#  require certificates and meta-authorizations to display category SAP
#  authorizations for others.
#
#
#  Copyright (C) 2007-2010 Massachusetts Institute of Technology
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
#  Written by Marina Korobko based on other scripts,  fall 2007
#  Modified by Jim Repa, 2/5/2007.  Tweak formatting of inactive qual table
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
#  Set some constants
#
$g_delim = '!';
$category = 'SAP';
@title = (
   'Qualifiers with inactive status',
   'Report is not available',
   'Report is not available',
   'Report is not available' 
 );
$host = $ENV{'HTTP_HOST'};
$url_stem = "https://$host/cgi-bin/qualauth.pl?";
$url_stem2 = "http://$host/cgi-bin/rolequal1.pl?";
$url_stem3 = "http://$host/cgi-bin/roleparent.pl?";
$url_stem4 = "https://$host/cgi-bin/qualauth.pl?detail=2&";
#
#  Get form variables
#
$report_num = $formval{'report_num'};
if (! $report_num) {$report_num = 1;}
$show_all = $formval{'show_all'};
if (! $show_all) {$show_all = 'Y';};
$show_all =~ tr/a-z/A-Z/;

#
#  Print out top of the http document.  
#
 print "Content-type: text/html\n\n";  # Start generating HTML document
 $header = $title[$report_num - 1];
 print "<head><title>$header</title></head>\n<body>";
 print '<BODY bgcolor="#fafafa">';
 &print_header
    ($header, 'https');
 print "<P>";

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
if (!(defined(&login_dbi_sql))) {&web_error("Use perlDBI, not perl\n");}

#
#  Open connection to oracle
#
$lda = login_dbi_sql('roles') 
      || &web_error($DBI::errstr);
#
#  Make sure the user has a meta-authorization to view special reports.
#
if (!(&verify_special_report_auth($lda, $k_principal))) {
  print "Sorry.  You do not have the required perMIT system 'meta-authorization'",
  " to view special reports.";
  exit();
}

#
#  Print out the header
#
 #$header = $title[$report_num - 1];
 #print "<HTML>", "\n";
 #print "<HEAD><TITLE>$header",
 #      "</TITLE></HEAD>", "\n";
 #print "<BODY><H1>$header</H1>","\n";

#
#  Call the appropriate report
#
 if ($report_num == 1) {
   &report1($lda);
 }
 elsif ($report_num == 2) {
   &report2($lda);
 }
 elsif ($report_num == 3) {
   &report3($lda);
 }
 elsif ($report_num == 4) {
   &report4($lda);
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
#  Subroutine report1.
#
#  Generate list of people with SAP authorizations but no CAN USE SAP
#  authorization.
#
###########################################################################
sub report1 {

  my ($lda) = @_;  # Get Oracle login handle.
  my ($kerbname, $modified_by, $max_date, $kerbstring, $report_only,
      $count);
 
 #
 # Print explanatory information
 #
  print "<small>
         The following table displays Qualifiers that are marked
         &quot;inactive.&quot  Each night, automatic programs update
         records in the Qualifier table based on financial, HR or other
         source data from the
         Warehouse or other sources.  When the programs detect a record that 
         should be deleted (because it has been deleted from the 
         source tables in the Warehouse, etc.) but cannot be deleted
         because of data constraints, it marks the Qualifier record
         as &quot;inactive.&quot  
         <p />
         Qualifiers can be marked inactive for two reasons:
         <ol>
            <li>There is an Authorization on the Qualifier.  
                <br><i>(The number of authorizations shown in the table will be
                1 or more.)</i>
            <p />
            <li>The Qualifier has child Qualifiers.  
                <br><i>(The number of authorizations in the table will be
                0.)</i>
         </ol>
         For case (1), all Authorizations on the Qualifier should 
	 be manually deleted or moved to a different Qualifier, and 
         the nightly data feed programs will delete the Qualifier the 
         next morning.
         <p />
         For case (2), the reason that the Qualifier was marked inactive
         rather than being deleted is usually due to the order of 
         transactions performed in the nightly feed. The Qualifier will
         usually be deleted automatically a day later.
         <p />
         Click on the Qualifier_code to see the position of the Qualifier
         in its hierarchy.  Click on the Function Category to see 
         Authorizations for the given Qualifier in the given Category.
         </small>";
  print "<p />";

 # Build 2 hashes: 1.Maps qualifier_id with categories for which there are authorizations	 
 #                 2.Maps qualifier/category pair to count of authorizations   
  my %qual2category;
  my %qual_category2count;
  &get_qualifier_auth_info($lda, \%qual2category,
                                  \%qual_category2count);
     
  #
  #  Open a cursor for select statement.
  #

   my $stmt =  "SELECT a.qualifier_id, a.qualifier_type,a.qualifier_code,a.qualifier_name,
               TO_CHAR(a.last_modified_date,'MM/DD/YYYY') last_modified_date
               FROM qualifier a
               WHERE  status ='I'
               ORDER BY qualifier_type,qualifier_code"; 

  $csr = $lda->prepare("$stmt")
        || &web_error($DBI::errstr);
  
  #
  #  Print text
  #
 
  #
  #  Start printing a table
  #
  print "<TABLE border>\n";
  print "<TR><TH>Qualifier<br>Type</TH>
         <TH>Qualifier<br>Code</TH>
         <TH>Qualifier Name</TH>
         <TH>Number of<br>Authorizations</TH>
         <TH>Function<br>Category</TH>
	 <TH>Last<br>modified<br>date</TH></TR>\n";
   
  #
  #  Process lines from the select statement
  #
  $count = 0;

   while (($qualifier_id, $qualifier_type, $qualifier_code, $qualifier_name,$last_modified_date)
         = $csr->fetchrow_array() ) 
  {
     $qcstring = '<A HREF="' . $url_stem . 'qualtype=' . $qualifier_type
                             . '&childqc=' . &web_string($qualifier_code)
          	             . '">' . $qualifier_code . "</A>";

     if ($function_category eq ' ') 
     {
	 $qcstring2='&nbsp;';
     }
     else
     {
      $qcstring2 = '<A HREF="' . $url_stem4 . 'category=' . $function_category
                               . '&qualtype=' . $qualifier_type
                               . '&rootcode='   . &web_string($qualifier_code)
			       . '">' . $function_category. "</A>";
     }
    
     my $qstring3 = $qual2category{$qualifier_id};
     my @cat_array = split($g_delim, $qual2category{$qualifier_id});
     my $num_cat = @cat_array;
     my $num_auth =$qual_category2count{"$qualifier_id$g_delim$cat_array[0]"};
     my $qcstring4;
     $cat1 = &strip($cat_array[0]); 
#
#     print "'k_principal=' '$k_principal' 'cat_array[0]=' '$cat'<BR>";       
#          
     if ($num_auth == 0 )
     { $qcstring4 = '&nbsp'} 
     else
     {
       if ((&verify_metaauth_category($lda, $k_principal, $cat1)))   
       {  
        $qcstring4 = '<A HREF="' . $url_stem4 . 'category=' . $cat_array[0]
                               . '&qualtype=' . $qualifier_type
                               . '&rootcode=' . web_string($qualifier_code)
                               . '">' . $cat_array[0]. "</A>";
      }  
       else
      {$qcstring4 = $cat_array[0]}   
     }
     printf "<TR><TD ALIGN=LEFT rowspan=$num_cat>%s</TD><TD ALIGN=LEFT rowspan=$num_cat>%s</TD>"
             . "<TD ALIGN=LEFT rowspan=$num_cat>%s</TD>"
             . "<TD ALIGN=CENTER>%s</TD><TD ALIGN=CENTER>%s</TD><TD ALIGN=LEFT rowspan=$num_cat>%s</TD>"
             . "</TR>\n",
#     $qualifier_type, $qcstring, $qualifier_name, $num_auth, $cat_array[0], $last_modified_date;
      $qualifier_type, $qcstring, $qualifier_name, $num_auth, $qcstring4, $last_modified_date;
      my @cat_array_minus1 = @cat_array;
      shift(@cat_array_minus1);
      foreach $cat (@cat_array_minus1) {
       if ((&verify_metaauth_category($lda, $k_principal, $cat)))
       {
        $qcstring4 = '<A HREF="' . $url_stem4 . 'category=' . $cat
                               . '&qualtype=' . $qualifier_type
                               . '&rootcode='   . $qualifier_code
                               . '">' . $cat. "</A>";
      }
       else
      {$qcstring4 = $cat}

       printf "<TR><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TD></TR>\n",
          $qual_category2count{"$qualifier_id$g_delim$cat"},
          $qcstring4;      
     }     
     $count++;
  }
  print "</TABLE>", "\n";
  print "<P>$count lines displayed<BR>";

  $csr->finish() || &web_error("can't close cursor");

}

###########################################################################
#
#  Subroutine report2.
#
#  Generate list of Fund Centers whose children are a mixture of Funds and
#  other Fund Centers.
#
###########################################################################
sub report2 {

  my ($lda) = @_;  # Get Oracle login handle.

  print "<BR>Report 2 is not available.<BR>";
}

###########################################################################
#
#  Subroutine report3.
#
#  Generate list of Fund Centers that belong to more than one spending
#  group.
#
###########################################################################
sub report3 {

  my ($lda) = @_;  # Get Oracle login handle.

  print "<BR>Report 3 is not available.<BR>";
}

###########################################################################
#
#  Subroutine report4.
#
#  Generate list of people with a CAN SPEND OR COMMIT FUNDS authorization
#  but no REQUISITIONER or CREDIT CARD VERIFIER authorization.
#
###########################################################################
sub report4 {

  my ($lda) = @_;  # Get Oracle login handle.

  print "<BR>Report 3 is not available.<BR>";
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

###########################################################################
#
#  Subroutine verify_special_report_auth.
#
#  Verify's that $k_principal is allowed to run special administrative
#  reports for the perMIT DB. Return's 1 if $k_principal is allowed,
#  0 otherwise.
#
###########################################################################
sub verify_special_report_auth {
    my ($lda, $k_principal) = @_;
    my ($csr, @stmt, $result);
    if (!$k_principal) {
        return 0;
    }
    @stmt = ("select ROLESAPI_IS_USER_AUTHORIZED('$k_principal',"
             . "'RUN ADMIN REPORTS', 'NULL') from dual");
    $csr = $lda->prepare("$stmt")
        || die $DBI::errstr;

    ($result) = &ora_fetch($csr);
    if ($result eq 'Y') {
        return 1;
    } else {
        return 0;
    }
}


###########################################################################
#
#  Subroutine get_qualifier_auth_info($lda, \%qual2category, 
#                                     \%qual_category2count);
#
###########################################################################
sub get_qualifier_auth_info {
  my ($lda, $rqual2category, $rqual_category2count) = @_;
  
  #
  #  Open cursor to select statement
  #
  my $stmt = "SELECT a.qualifier_id,
               COUNT(b.qualifier_id) number_of_auths,
               NVL(b.function_category,' ') function_category
               FROM qualifier a,AUTHORIZATION b
               WHERE a.qualifier_id =NVL(b.qualifier_id(+),0)
               AND status ='I'
               GROUP BY a.qualifier_id,b.function_category";
  #print "'$stmt'<BR>";
  my $csr = $lda->prepare("$stmt") 
	|| die $DBI::errstr;
   $csr->execute();
  
  #
  #  Get a list of qualifier_id and related information
  #
  my ($qualifier_id, $number_of_auths, $function_category);
  while ( ($qualifier_id, $number_of_auths, $function_category) 
        = $csr->fetchrow_array()  ) {
      if ($$rqual2category{$qualifier_id}) {
        $$rqual2category{$qualifier_id} .= "$g_delim$function_category";
      }
      else {
        $$rqual2category{$qualifier_id} = $function_category;
      }
    $$rqual_category2count {"$qualifier_id$g_delim$function_category"} = $number_of_auths; 
  }

  $csr->finish() || die "can't close cursor";

}
###########################################################################
#
#  Function &web_string($astring)
#
#  Converts spaces to '+', left parentheses to %28,
#   right parentheses to %29, '&' to %28
#
###########################################################################
sub web_string {
    my ($astring) = $_[0];
    $astring =~ s/ /+/g;
    $astring =~ s/\(/\%28/g;
    $astring =~ s/\)/\%29/g;
    $astring =~ s/\&/\%26/g;
    $astring;
}
