#!/usr/bin/perl
###########################################################################
#
#  CGI script to display records in the table rdb_t_funds_cntr_release_str,
#  and also insert or delete records.
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
#  Marina Korobko - 7/31/2007
#  Modified by Marina Korobko, 8/7/2007 (adjusted format)
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
use CGI;
use CGI::Pretty qw/ :standard /;
#use CGI::Carp qw/ fatalToBrowser /;
use CGI qw/startfom button textfield endform -nosticky/;
use DBI;
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
   'Fund Centers - Model 1 Release Strategy',
   'Report is not available',
   'Report is not available',
   'Report is not available' 
 );
$host = $ENV{'HTTP_HOST'};
$url_stem = "http://$host/cgi-bin/qualauth.pl?";
$url_stem = "http://$host/cgi-bin/qualauth.pl?";
$url_stem2 = "http://$host/cgi-bin/rolequal1.pl?";
$url_stem3 = "http://$host/cgi-bin/roleparent.pl?";
$url_stem4 = "https://$host/cgi-bin/qualauth.pl?";
$url_stem5 = "https://$host/cgi-bin/rel_str.cgi?";
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

# authentication checks
  ($info,$k_principal, $domain)  = &parse_authentication_info();  # Parse authentication info
  $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase
  $full_name = $k_principal;
  $result = &check_auth_source(\$info); # Check other certificate fields
  if ($result ne 'OK') {
      print "<br><b>Your authentication cannot be accepted: $result";
      exit();
  }


#
#  Get set to use DB.
#
use DBI;

#
#  Open connection to oracle
#
$lda = &login_dbi_sql('roles') 
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
#  Call the appropriate report
#
 if ($report_num == 1) {
   &report1($lda, $k_principal);
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
 #### ???????  #####  $query->param{'fund_center_id_d'} = '';

#
#  Drop connection to Oracle.
#
$lda->disconnect()
       || &web_error("can't log off Oracle");

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

  my ($lda, $kerbname) = @_;  # Get Oracle login handle.

  #
  #
  #  Print explanatory information
  #
   $buttons= {
   'add_fund_center' => 'Add New Fund Center',
   'delete_fund_center' =>'Delete Existing Fund Center',
   };  
   $param_names ={
   'fund_center_id' => 'fund_center_id',
   'fund_center_id_d' => 'fund_center_id_d',
   };
#####################################################################################
 $query =new CGI;
#print "fund_center_id='" . $query->param('fund_center_id') . "'<br>"; 
#print "fund_center_id_d='" . $query->param('fund_center_id_d') . "'<br>";
#print "sort_code='" . $query->param('sort_code') . "'<br>";
#####################################################################################################
#
  if ( $query->param ('add_fund_center'))
   {add_fund_center($kerbname, $query->param('fund_center_id'), $lda);
   };
  if ($query->param('delete_fund_center')){

 delete_fund_center($kerbname, $query->param('fund_center_id_d'), $lda);

  };

###################################################################################################
      print "\n", $query->startform(-method=>'get');
        my $add_fund_center_button = $buttons->{'add_fund_center'};
        my $fund_center_id =$param_names->{'fund_center_id'}; 
      print "<small>
       <p />       
      To add a Model 1 Funds Center, enter FCxxxxxx and click the Add New Fund Center button.
      <p />  
      </small>";      
      print "<p>", $query->textfield(-name=>$param_names->{'fund_center_id'},
                       -default=>'',
                      -override=>1
                             );      
     print "  ";     
     print $query->submit(-name => 'add_fund_center', -value=>$add_fund_center_button);
     print $query->endform(), "\n";
     print "<br><br>\n";
########################################################################################
       print "\n", $query->startform(-method=>'get');
        my $delete_fund_center_button = $buttons->{'delete_fund_center'};
      print "<small>
      To remove a Model 1 Funds Center, enter FCxxxxxx and click the Delete Existing Fund Center button.
      <p />
      </small>"; 
      print  "<p>", $query->textfield(-name=>$param_names->{'fund_center_id_d'},
                           -default=>'',
                           -override=>1 );      
      print "  ";    
      print   $query->submit(-name => 'delete_fund_center', -value=>$delete_fund_center_button);
       print $query->endform(), "\n";
       print "<hr><br>\n";
########################################################################################
#
  #  Open a cursor for select statement.
  #
     my $sort_by_date = "order by modified_date desc";  

     my $sort_by_fc ="order by fund_center_id";
     #my $sort_clause = $sort_by_fc;
     my $sort_clause = ($query->param('sort_code') eq '1')
                        ? $sort_by_date
                        : $sort_by_fc;   
      

      my $stmt = "Select fund_center_id,
                  release_strategy,
                  modified_by,
                  to_char(modified_date,'MM/DD/YYYY') last_modified_date
              from funds_cntr_release_str $sort_clause";

      $csr = $lda->prepare("$stmt") 
        || &web_error($DBI::errstr);
      $csr->execute();
  #
#
#  print explanatory information
#
   print "<small>
   Below is a list of Funds Centers with a Release Strategy of Model 1.
   <p />    
   To change the sort order, click the column headings &quot; Fund center id &quot
   or  &quot; Last modified date &quot . 
   </small>";
   print "<p />"; 
#  Start printing a table
  #
 $fc = '<A HREF="' . $url_stem5 . 'sort_code=2' . '">' . "Fund center id" ."</A>"; 
 $lmd = '<A HREF="' . $url_stem5 . 'sort_code=1' . '">' . "Last modified date" . "</A>"; 


           print "<TABLE border>\n";
           print "<TR><TH>$fc</TH>
                 <TH>Release strategy</TH>
                 <TH>Modified by</TH>
                 <TH>$lmd</TH></TR>\n";

  #
  #  Process lines from the select statement
  #
   while (($fund_center_id, $release_strategy, $modified_by, $last_modified_date)
         = $csr->fetchrow_array() )
{

    printf "<TR><TD ALIGN=LEFT >%s</TD><TD ALIGN=LEFT>%s</TD>"
             . "<TD ALIGN=LEFT>%s</TD>"
             . "<TD ALIGN=LEFT >%s</TD>"
              . "</TR>\n",
    $fund_center_id,$release_strategy, $modified_by, $last_modified_date;

 }

  print "</TABLE>", "\n";
  $csr->execute() || &web_error("can't close cursor");
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
    $csr->finish();

    ($result) = $csr->fetchrow_array();
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
  my $csr = $lda->prepare("$stmt") || die( $DBI::errstr . "\n");
  $csr->execute();
  
  #
  #  Get a list of qualifier_id and related information
  #
  my ($qualifier_id, $number_of_auths, $function_category);
  while ( ($qualifier_id, $number_of_auths, $function_category) 
        = $csr->fetchrow_array() ) {
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

##################################################################################
#############################################
sub delete_fund_center{
    my( $user,
        $fund_center_id_d,
        $lda) = @_;
    my $message;
    my $stmt1 = qq{begin
                  rolesbb.delete_fund_centers_rel_str(
                            :fund_center_id,
                            :user,
                            :message
                            );
                  end;};

    my $csr = $lda->prepare($stmt1);
    $csr->bind_param(":user", $user);
    $csr->bind_param(":fund_center_id", $fund_center_id_d);
    $csr->bind_param_inout(":message", \$message, 255);
    $csr->execute;
    $error = get_db_error_msg($lda);
if ($error){print "<p> <font color=red> $error \n</font>";}
      elsif (!$error){print "<p> <font color=green> $message \n</font>";}      
 $csr -> finish;
}
######################################################################################
#############################################
sub add_fund_center{
    my( $user,
        $fund_center_id,
        $lda) = @_;
    my $message;
    my $stmt1 = qq{begin
                  rolesbb.insert_fund_centers_rel_str(
                            :fund_center_id,
                            :user,
                            :message
                            );
                 end;};
    my $csr = $lda->prepare($stmt1);
    $csr->bind_param(":user", $user);
    $csr->bind_param(":fund_center_id", $fund_center_id);
    $csr->bind_param_inout(":message", \$message, 255);
    $csr->execute;
    $error = get_db_error_msg($lda);
      if ($error){print "<p> <font color=red> $error \n</font>";} 
     elsif (!$error){print "<p> <font color=green> $message \n</font>";} 
   $csr -> finish;
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
#      return "Error: $shorterr Error Number $err";
       return "Error: $shorterr ";
    }

    return undef;
}
####################################################################
