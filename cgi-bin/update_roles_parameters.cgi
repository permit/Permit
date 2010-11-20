#!/usr/bin/perl
###########################################################################
#
#  CGI script to display records in the table rdb_t_roles_parameters ,
#  and also update the fields for the choosen parameter field.
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
#  Marina Korobko - 8/23/2007
#  Modified by Jim Repa, 10/3/2008.  Fix URL links for sorting action.
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
use CGI qw/startfom button textfield endform -nosticky/;
use DBI;

#
#  
#
 $param_names = {
   'parameter'     => 'parameter',
   'value'         => 'value',
   'action'        => 'action',
   'report_num'    => 'report_num',     
   'default_value' => 'default_value',
   'description'   => 'description', 
   'is_number'     => 'is_number' 
};

#  Create new CGI object
#
 $query = new CGI;

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
@title = (
   'Update ROLES PARAMETERS record ',
   'Update ROLES PARAMETERS record ',
   'Update ROLES PARAMETERS record ',
   'Update Parameter Value', 
   'Results of Update of Parameter Value' 
 );
#
 $host = $ENV{'HTTP_HOST'};
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 $url_stem7 = "https://$host/cgi-bin/${progname}?";

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

#
#  Open connection to oracle
#
$lda = login_dbi_sql('roles') 
      || &web_error($DBI::errstr);
#
#  Make sure the user has a meta-authorization to view special reports.
#
#if ($k_principal eq 'MKOROBKO')
#{$k_principal = 'ROLETEST';}

if (!(&verify_special_report_auth($lda, $k_principal))) {
  print "Sorry.  You do not have the required perMIT system 'meta-authorization'",
  " to view special reports.";
  exit();
}

#
#  Call the appropriate report
#
#print "parameter = '$parameter'<BR>";
#    print "value = '$value'<BR>";
#    print "k_principal =' $k_principal'<BR>";
#    print "lda='$lda'<BR>"; 
if ($report_num == 1) {
&report1($lda, $k_principal); 
}
 elsif ($report_num == 2) {
   &report2($lda, $query->param('parameter'), $k_principal);
 }
 elsif ($report_num == 3) {
   &report3($k_principal, $query->param('parameter'), $query->param('value'),  $query->param('description'),
           $query->param('default_value'), $query->param('is_number'), $lda);
}
elsif ($report_num == 5) {
   &report5($k_principal, $query->param('parameter'), $query->param('value'), $lda);
 }
elsif ($report_num == 4){
&report4($lda, $query->param('parameter'), $k_principal);
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
#  Display records from roles_parameters table.
#  
#
###########################################################################
sub report1 {

  my ($lda, $kerbname) = @_;  # Get Oracle login handle.

  #  Print explanatory information
  #
    if ( ((&maintain_parameter_data($lda, $k_principal)) eq '0')  && ((&maintain_all_parameter_data($lda, $k_principal)) eq '0'))

       
{
    print "<br><b> $k_principal Not authorized to Maintain Parameters Data";
    exit();
   }
 print "<small>  
  <p />  
   The following table lists &quot parameters &quot for perMIT system data feed programs and other automated processes.
  </p> 
   To change the sort order, click the column headings &quot Parameter Value &quot or &quot Update Date. &quot
  </p>  
   For each &quot parameter &quot, you may see one or two buttons, depending on your
   authority to maintain parameter values.
  <ul>
  <li>The &quot Change Parameter Value &quot button allows you to change the single
      value (usually numeric) associated with the parameter, for example, the
      representing the maximum number of changes for COST qualifiers in one
      day.
  <li>The &quot Change Any Paramer &quot allows you to change not only the Parameter Value
      field, but also the Default Value (to which the Parameter Value will
      return a day after adjusting it), the description, or even the
      numeric/non-numeric setting for the Parameter Value.  Use this only in
      rare cases that you want to adjust something other than the simple
      value.
</ul>

</small>"; 
 print "<p/>"; 
#
#
     my $sort_by_date = "order by update_timestamp desc"; 
     my $sort_by_parameter = "order by parameter"; 
     my $sort_clause = ($query->param('sort_code') eq '1')            
                       ? $sort_by_date
                       : $sort_by_parameter;    


    my $stmt = "SELECT 
                      parameter,
                      VALUE,
                      description,
                      default_value, 
                      is_number, 
                      update_user,
                      update_timestamp
                   FROM rolesbb.rdb_t_roles_parameters
                     $sort_clause"; 
 #                 order by parameter";


      $csr = $lda->prepare("$stmt") 
        || &web_error($ora_errstr);
     $csr->execute();
    
#  
#  Start printing a table
  #
###   $par = '<A HREF="' . $url_stem7 . 'parameter=' .  $parameter . '&' . 'value=' . $value . '&' .  'report_n
###um=2' .  '">' . "Show detail" . "</A>";
###
   $by_par = '<A HREF="' . $url_stem7 . 'sort_code=2' . '">' . "Parameter Code" . "</A>";
   $by_time = '<A HREF="' . $url_stem7 . 'sort_code=1' . '">' ."Update Date" . "</A>";  


         print "<TABLE border>\n";
           print "
                 <TH>&nbsp;</TH>
                 <TH ALIGN=LEFT>$by_par</TH>
                 <TH ALIGN=LEFT>Parameter Value</TH>
                 <TH ALIGN=LEFT>Parameter Description</TH>
                 <TH ALIGN=LEFT>Default Value</TH>
                 <TH ALIGN=LEFT>Is Parameter Value Numeric</TH>  
                 <TH ALIGN=LEFT>Update User</TH>
                 <TH ALIGN=LEFT>$by_time</TH>                  
                </TR>\n"; 
                    

  #
  #  Process lines from the select statement
  #
   while (($parameter, $value, $description, $default_value, $is_number, $update_user, $update_timestamp)
         = $csr->fetchrow_array() )
{
###   $par = '<A HREF="' . $url_stem7 . 'parameter=' .  $parameter . '&' . 'value=' . $value . '&' .  'report_n###um=2' .  '">' . "Show detail" . "</A>"; 
###
if ((&maintain_parameter_data($lda, $k_principal)) eq '1')
{

      $button_string1 = $query->startform(-method=>'get');
      $button_string1 .= $query->hidden(-name=>$param_names->{'parameter'},
                       -default=>$parameter,
                      -override=>1);
      $button_string1 .= ' ' . $query->hidden(-name=>$param_names->{'value'},
                              -default=>$value,
                              -override=>1);
      $button_string1 .= ' ' . $query->hidden(-name=>$param_names->{'report_num'},
                              -default=>'4',
                              -override=>1);
     $button_string1 .= ' ' . $query->submit(-name => 'Change Parameter Value');
     $button_string1 .= ' ' . $query->endform();
     $button_all = $button_string1;
}
else
{$button_all = '&nbsp'};
if  ((&maintain_all_parameter_data($lda, $k_principal)) eq '1')

{
      $button_string = $query->startform(-method=>'get');
      $button_string .= $query->hidden(-name=>$param_names->{'parameter'},
                       -default=>$parameter,
                      -override=>1);
      $button_string .= ' ' . $query->hidden(-name=>$param_names->{'value'},
                              -default=>$value,
                              -override=>1);
      $button_string .= ' ' . $query->hidden(-name=>$param_names->{'description'},
                              -default=>$description,
                              -override=>1);
      $button_string .= ' ' . $query->hidden(-name=>$param_names->{'default_value'},
                              -default=>$default_value,
                              -override=>1); 
      $button_string .= ' ' . $query->hidden(-name=>$param_names->{'is_number'},
                              -default=>$is_number,
                              -override=>1);

      $button_string .= ' ' . $query->hidden(-name=>$param_names->{'report_num'},
                              -default=>'2',                      
                              -override=>1);
      $button_string .= ' ' . $query->submit(-name=> 'Change Any Parameter');
      $button_string .= ' ' . $query->endform();
     
      $button_string2 = $query->startform(-method=>'get');
      $button_string2 .= $query->hidden(-name=>$param_names->{'parameter'},
                       -default=>$parameter,
                      -override=>1);
      $button_string2 .= ' ' . $query->hidden(-name=>$param_names->{'value'},
                              -default=>$value,
                              -override=>1);
      $button_string2 .= ' ' . $query->hidden(-name=>$param_names->{'report_num'},
                              -default=>'4',
                              -override=>1);
      $button_string2 .= ' ' . $query->submit(-name => 'Change Parameter Value');
      $button_string2 .= ' ' . $query->endform();  
   
    $button_all = $button_string2 . $button_string; 
#
}
#else
#{$button_all ='&nbsp';}
printf    "<TR><TD ALIGN=LEFT>%s</TD>"
             . "<TD ALIGN=LEFT>%s</TD>"
             . "<TD ALIGN=LEFT>%s</TD>"
             . "<TD ALIGN=LEFT>%s</TD>"
             . "<TD ALIGN=LEFT>%s</TD>"
             . "<TD ALIGN=LEFT>%s</TD>" 
             . "<TD ALIGN=LEFT>%s</TD>"
             . "<TD ALIGN=LEFT>%s</TD>"  
             . "</TR>\n",
$button_all, $parameter, $value, $description, $default_value, $is_number,$update_user, $update_timestamp; 
 }

  print "</TABLE>", "\n";
  $csr->finish() || &web_error("can't close cursor");
}


###########################################################################
#
#  Subroutine report2.
#
#  Create a form to change the parameter value.   
#  
#
###########################################################################
sub report2 {

  my ($lda, $parameter, $kerbname) = @_;  
   
$buttons= {
   'update_parameter_value' => 'Update Parameter Value',
   'cancel' =>' Back to List'

             };

#    Open a cusror for select statement.

      my $stmt1  = "SELECT
                      value, description, default_value, is_number
                   FROM rolesbb.rdb_t_roles_parameters
                   where parameter ='$parameter'";

      $cursor = $lda->prepare("$stmt1") 
        || &web_error($DBI::errstr);

      while (($value, $description, $default_value, $is_number)
         = $csr->fetchrow_array() ){};
      $csr->finish() || &web_error("can't close cursor");
#
    print $value, $description, $default_value, $is_number;   
      print "\n", $query->startform(-method=>'get');
        my $parameter     = $query->param('parameter');
        my $value         = $query->param('value');        
        my $description   = $query->param('description');
        my $default_value = $query->param('default_value');
        my $is_number     = $query->param('is_number');     
    print "<small>
       <p />
      To Update fields from Roles_Parameters table, fill in the displayed fields with new values and click the Update Record button.
      <p />
      </small>";
     print "<p>", $query->hidden(-name=>$param_names->{'parameter'},
                       -default=>$parameter,
                      -override=>1
                             );
     print "<p>", 'Parameter Code:  '  . "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"  
                                       .  $parameter; 
     print "<p>", 'Parameter Value: ' . "&nbsp" . "&nbsp" . "&nbsp" . "&nbsp" . "&nbsp" .  "&nbsp" . "&nbsp" . 
                  "&nbsp" . "&nbsp" . "&nbsp" . 
                  $query->textfield(-name=>$param_names->{'value'},
                       -default=>$value,
                      -override=>1
                      );   
   print "<p>", 'Parameter Description: ' . "&nbsp" .
                $query->textfield(-name=>$param_names->{'description'},
                      -default=>$description,
                      -size=>60,                      
                      -override=>1
                  );     
   
   print "<p>", 'Default Value: ' . "&nbsp" ."&nbsp" . "&nbsp" . "&nbsp" . "&nbsp" . "&nbsp" .  "&nbsp" . 
                  "&nbsp" . "&nbsp" . "&nbsp" . "&nbsp" . "&nbsp" . "&nbsp" . "&nbsp" .  
                $query->textfield(-name=>$param_names->{'default_value'},
                      -default=>$default_value); 

   print "<p>", 'Is Number: ' . "&nbsp" .  "&nbsp" . "&nbsp" . "&nbsp" . "&nbsp" . "&nbsp" .  "&nbsp" .  
                                "&nbsp" .  "&nbsp" . "&nbsp" . "&nbsp" . "&nbsp" . "&nbsp" .  "&nbsp" .
                                "&nbsp" . "&nbsp"  . "&nbsp" . "&nbsp" .  
                $query->scrolling_list(-name=>$param_names->{'is_number'},
                                    -default=>$is_number,
                                    -values=>['Y','N'],                                     
                                    -size=>2,
                                    -multiple=>'true',      
                                    -override=>1); 
   print "<p>",
                 $query->hidden(-name=>$param_names->{'report_num'},
                        -default=>'3',
                      -override=>1
                      );   



  # print $query->hidden(-name=>$param_names->{'action'},-default=>'update_db');

    print $query->submit(-name => 'Update Record', -value=>$update_record_button);

#    print $query->endform(), "\n";
     print $query->endform(); 
#    print "<br><br>\n";

#
     print  "\n", $query->startform(-method=>'get');
#       my $cancel_button =$buttons->{'cancel'};

     print "<p>",
                  $query->hidden(-name=>$param_names->{'report_num'},
                       -default=>'1',
                      -override=>1
                      );


#     print $query->submit(-name=> 'Back to list', -value=>$cancel_button);
     print $query->submit(-name=> 'Back to List');  
     print $query->endform(), "\n";
     print "<br><br>\n";
}


###########################################################################
#
#  Subroutine report3.
#
#  Call the stored procedure  to update fields of roles_parameters table 
#  using subroutine &update_all_roles_parameters.
#
###########################################################################
sub report3 {
  my ($kerbname,
        $parameter,
        $value,
        $description,
        $default_value,
        $is_number,   
        $lda) = @_ ;  # Get Oracle login handle.

#if ($k_principal eq 'MKOROBKO')
#{$k_principal = 'ROLETEST';}
  if (!(&verify_special_report_auth($lda, $k_principal))) {
  print "Sorry.  You do not have the required perMIT system 'meta-authorization'",
  " to view special reports.";
  exit();  
  }
#
  #  Call the stored procedure to update the value in the database
  #
 #    print "parameter ='$parameter'<BR>";
 #    print "value = '$value'<BR>";
 #    print "Kerb =' $kerbname'<BR>";
 #    print "Desc=' $description'<BR>";
 #    print "Default=' $default_value'<BR>";
 #    print "is_number=' $is_number'<BR>";
 #    print "lda='$lda'<BR>"; 
 #    print "principal=' $k_principal'<BR>";

     &update_all_roles_parameters($k_principal, $parameter, $value, $description, $default_value, $is_number, $lda);
     &report2($lda, $parameter, $kerbname);
}
######################################################################################### 
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

    ($result) = $csr->fetchrow_array() ;
    $csr->finish();
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
sub update_parameter_value{
    my( $user,
        $parameter,
        $value,         
        $lda) = @_;
    my $message;
    my $stmt1 = 
                  ' CALL update_parameter_value(
                            ?,
                            ?,                             
                            ?,
                            @message
                             ) ';
    my $csr = $lda->prepare($stmt1);
    $csr->bind_param(1, $parameter);
    $csr->bind_param(2,$value);     
    $csr->bind_param(3, $k_principal);
    $csr->execute;
    
    $error = get_db_error_msg($lda);
      if ($error){print "<p> <font color=red> $error \n</font>";} 
     elsif (!$error)
		{
			 my $csr1 = $lda->prepare(' select @message');
    			$csr1->execute();
    			$message = $csr1->fetchrow_array();
			print "<p> <font color=green> $message \n</font>";
			$csr1->finish();
		} 
   $lda->commit;   
 $csr -> finish;
}
#########################################################################################
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
###########################################################################
#
#  Subroutine maintain_parameter_data.
#
#  Verify's that $k_principal is allowed to change  value field in roles_parameters table.  
#  Return's 0 if $k_principal is allowed,
#  1 otherwise.
#
###########################################################################
sub maintain_parameter_data
{
my ($lda, $k_principal) = @_;
my ($csr, @stmt, $result);

@stmt = "select AUTH_SF_CHECK_AUTH2('MAINTAIN PARAMETER VALUES', 'NULL','$k_principal',
         'PROXY FOR ROLES ADMIN FUNC','NULL') from DUAL";
   $csr = $lda->prepare("$stmt")
        || die $DBI::errstr; 
   $csr->execute();
  ($result) = $csr->fetchrow_array() ;
# print $result;  
 $csr->finish();
if ($result eq 'Y' )
{
   return 1;

}
 
else {
        return 0;
    }

}

####################################
sub verify_special_report_auth {
    my ($lda, $k_principal) = @_;
    my ($csr, @stmt, $result);
    if (!$k_principal) {
        return 0;
    }
    $stmt = "select ROLESAPI_IS_USER_AUTHORIZED('$k_principal',"
             . "'RUN ADMIN REPORTS', 'NULL') from dual";
    $csr = $lda->prepare($stmt) 
        || die $DBI::errstr;
    $csr->execute();

    ($result) = $csr->fetchrow_array();
    $csr->finish();
    if ($result eq 'Y') {
        return 1;
    } else {
        return 0;
    }
}


###################################################################################
sub update_all_roles_parameters{
    my( $user,
        $parameter,
        $value,
        $description,
        $default_value,
        $is_number,    
        $lda) = @_;
    my $message;
    my $stmt1 = qq{begin
                  rolesbb.update_roles_parameters_all(
                            :parameter,
                            :value,
                            :description,
                            :default_value,
                            :is_number,                                                     
                            :user,
                            :message
                             );
              end;};
    my $csr = $lda->prepare($stmt1);
    $csr->bind_param(":user", $k_principal);
    $csr->bind_param(":parameter", $parameter);
    $csr->bind_param(":value", $value);   
    $csr->bind_param(":description", $description);
    $csr->bind_param(":default_value", $default_value);
    $csr->bind_param(":is_number", $is_number);       
    $csr->bind_param_inout(":message", \$message, 255);
    $csr->execute;
    $error = get_db_error_msg($lda);
      if ($error){print "<p> <font color=red> $error \n</font>";}
     elsif (!$error){print "<p> <font color=green> $message \n</font>";}
   $lda->commit;  
 $csr -> finish;
}
###########################################################################
#
#  Subroutine report4.
###########################################################################
sub report4 {

  my ($lda, $parameter, $kerbname) = @_;
#    print "parameter ='$parameter'<BR>";
#    print "value = '$value'<BR>";
#    print "Kerb =' $kerbname'<BR>";
#    print "lda='$lda'<BR>";
   $buttons= {
   'update_parameter_value' => 'Update Parameter Value',
   'cancel' =>' Back to List'

             };

#    Open a cusror for select statement.

      my $stmt1  = "SELECT
                      value
                   FROM rolesbb.rdb_t_roles_parameters
                   where parameter ='$parameter'";

      $csr = $lda->prepare($stmt) 
        || &web_error($DBI::errstr);
      $csr->execute();

      while (($value)
         = $csr->fetchrow_array()){};
      $csr->finish() || &web_error("can't close cursor");
#

      print "\n", $query->startform(-method=>'get');
        my $update_parameter_value_button = $buttons->{'update_parameter_value'};
        my $parameter =  $query->param('parameter');
        my $value      = $query->param('value');
    print "<small>
       <p />
      To Update a Parameter Value, fill in the new Parameter Value and click the Update Parameter Value button.
      <p />
      </small>";
    print "<p>", $query->hidden(-name=>$param_names->{'parameter'},
                       -default=>$parameter,
                      -override=>1
                             );
     print "<p>", 'Parameter Code:  ' . $parameter;
     print "<p>", 'Parameter Value: ' . "&nbsp" .
                  $query->textfield(-name=>$param_names->{'value'},
                       -default=>$value,
                      -override=>1
                      );

   print "<p>",
                  $query->hidden(-name=>$param_names->{'report_num'},
                       -default=>'5',
                      -override=>1
                      );

  # print $query->hidden(-name=>$param_names->{'action'},-default=>'update_db');

    print $query->submit(-name => 'update_parameter_value', -value=>$update_parameter_value_button);

#    print $query->endform(), "\n";
   print $query->endform();
#    print "<br><br>\n";

#
print  "\n", $query->startform(-method=>'get');
#       my $cancel_button =$buttons->{'cancel'};

   print "<p>",
                  $query->hidden(-name=>$param_names->{'report_num'},
                       -default=>'1',
                      -override=>1
                      );


#     print $query->submit(-name=> 'Back to list', -value=>$cancel_button);
     print $query->submit(-name=> 'Back to List');
     print $query->endform(), "\n";
     print "<br><br>\n";
}
###########################################################################
#
#  Subroutine report5.
#
#  Call the stored procedure  to update the value field of roles_parameters table
#  using subroutine &update_parameter_value.
#  Display the records from roles_parameter table with the updated record on the top.
#
###########################################################################
sub report5 {
  my ($kerbname,
        $parameter,
        $value,
        $lda) = @_ ;  # Get Oracle login handle.

  if (!(&verify_special_report_auth($lda, $k_principal))) {
  print "Sorry.  You do not have the required perMIT system 'meta-authorization'",
  " to view special reports.";
  exit();
  }
#
  #  Call the stored procedure to update the value in the database
  #
   &update_parameter_value($k_principal, $parameter, $value, $lda);
#
#  Display the records from roles_parameters table
#
#  &report1($lda, $k_principal);
   &report4($lda, $parameter, $kerbname);

#   &select_records($lda, $k_principal);
#
            }
###########################################################################
#
#  Subroutine maintain_all_parameter_data.
#
#  Verify's that $k_principal is allowed to change  fields in roles_parameters table.
#  Return's 0 if $k_principal is allowed,
#  1 otherwise.
#
###########################################################################
sub maintain_all_parameter_data
{
my ($lda, $k_principal) = @_;
my ($csr, @stmt, $result);
#if  (!$k_principal) { return 1 };
#if ($k_principal eq 'MKOROBKO')
#{$k_principal = 'ROLETEST';}
#print $k_principal . "\n";
@stmt = "select AUTH_SF_CHECK_AUTH2('MAINTAIN ALL PARAMETER DATA', 'NULL','$k_principal',
         'PROXY FOR ROLES ADMIN FUNC','NULL') from DUAL";
$csr = $lda->prepare("$stmt")
        || die $DBI::errstr;
$csr->execute();

    ($result) = $csr->fetchrow_array() ;
$csr->finish();
    if ($result eq 'Y') {

   return 1;
}

else {
        return 0;
    }
}

###########################################################################
