#!/usr/bin/perl
##############################################################################
#
# CGI script to display records from the Authorizations audit trail
#  Copyright (C) 2000-2010 Massachusetts Institute of Technology
#  For contact and other information see: http://mit.edu/permit/
#
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General 
# Public License as published by the Free Software Foundation; either version 2 of the License.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even 
# the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public 
# License for more details.
#
# You should have received a copy of the GNU General Public License along with this program; if not, write 
# to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#
# Written by Jim Repa, 2/4/1999
# Modified by Jim Repa, 7/26/1999
# Modified by Jim Repa, 8/31/1999
# Modified by Jim Repa, 2/25/2000 (Prevent list of all SAP history records)
# Modified by Jim Repa, 7/26/2004 (Improved select stmt; show both old and new
#                                  update record if a username is changed)
#
##############################################################################
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
#  Set constants
#
$host = $ENV{'HTTP_HOST'};
$url_stem = "/cgi-bin/rolequal1.pl?";  # Stem for a url for qualifier info
$url_stem2 = "/cgi-bin/auth-detail.pl?";  # Stem for a url for auth detail
# Stem for a url for a users's authorizations
$url_stem3 = "/cgi-bin/my-auth.cgi?category=SAP+SAP&FORM_LEVEL=1&";  
$help_url = "http://$host/authaudit_help.html";


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
unless ($picked_user) {$picked_user = $formval{'username'};} #alternative
$picked_user =~ tr/a-z/A-Z/;
$modify_user = $formval{'modname'};
$modify_user =~ tr/a-z/A-Z/;
$category = $formval{'category'};
$cat = $category;
&strip($cat);
$cat =~ s/\W.*//;  # Keep only the first word.
$cat =~ tr/a-z/A-Z/; # Raise to upper case
$time_period = $formval{'time_period'};
$time_period =~ tr/a-z/A-Z/;
$approver_only = $formval{'approver_only'};

#
#  Define time periods
#
 %time_interval = ('SINCE YESTERDAY' => 1,
                   'LAST 3 DAYS' => 3,
                   'LAST 7 DAYS' => 7,
                   'LAST 30 DAYS' => 30,
                   'ALL' => 10956,);

#
#  Print beginning of the document
#    
print "Content-type: text/html\n\n";  # Start generating HTML document
print "<head><title>Audit Trail listing</title></head>\n<body>";
print '<BODY bgcolor="#fafafa">';
&print_header
   ("perMIT DB History of Authorizations Changes", 'https', $help_url);

#
#  Check parameters
#
$days = $time_interval{$time_period};
if (($time_period) && (!$days)) {
  print "Unrecognized time period '$time_period'<BR>";
  die;
}
if ($approver_only ne '1') { # Only one acceptable value
  $approver_only = '';
}
if ( (!$picked_user) && (!$modify_user) && (!$days) 
     && (!$approver_only) ) {
  print "Error: No Kerberos username, modify username, or time period"
        . " was specified.<BR>";
  die;
}
if (($time_interval) && !($time_interval{$time_period})) {
  print "Unrecognized time interval: '$time_period'.<BR>";
  die;
}
if (!$category) {
  print "Error: No category was specified.<BR>";
  die;
}
if (($cat =~ /^SAP/ || $cat =~ /ALL/) && (!$picked_user) && (!$modify_user)
    & (!$approver_only) && ($days > 180)) {
  print "<BR><B>Do not select category = $cat and time-period = ALL with"
      . " no other limiters. <BR>There are too many records!<B>\n";
  die;
}

#
#  Parse auth information
#
($info,$k_principal, $domain)  = &parse_authentication_info();  # Parse certificate into a Perl "hash"
$full_name=$k_principal;

  $result = &check_auth_source($info); # Check other certificate fields
  if ($result ne 'OK') {
      print "<br><b>Your authentication cannot be accepted: $result";
      exit();
  }
 $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase
 
use DBI;  # Point to library of DBI for Perl
#
# Login into the database
# 
my $lda = &login_dbi_sql('roles')
      || die ($DBI::errstr . "\n");


#
#  Make sure the user is requesting information only about his own
#    authorizations, OR
#  Make sure the user has a meta-authorization to view all authorizations
#  in the given category.
#
if ( ($k_principal ne $picked_user) &&
     ( !(&verify_metaauth_category($lda, $k_principal, $cat)) ) 
   ) {
  print "Sorry.  You do not have the required perMIT DB 'meta-authorization'",
  " to view other people's category '$cat' authorizations.";
  exit();
}

#
#  Print audit trail listing
#
print "<P>";
&print_audit_auths($lda, $picked_user, $modify_user, $days, $approver_only, 
                   $cat);
print "<HR>";
exit();

#
# Print form allowing user to run another report
#
#&allow_another_report($lda, $k_principal);

#
#  Drop connection to Oracle.
#
#&ora_logoff($lda) || die "can't log off Oracle";    
$lda->disconnect();

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
#  Subroutine print_audit_auths.
#
#  Prints out records from the audit trail.
#
###########################################################################
sub print_audit_auths {
  my ($lda, $picked_user, $modify_user, $days, $approver_only, $cat) = @_;
  my ($csr, $n, @stmt, $last_kerbname, $kerbstring, $where, $cat_phrase);

 #
 #  Print out introductory paragraph.
 #
  print "Below is a list of records from the Authorization audit trail";
  if ($cat eq 'ALL') {
    print " in all categories";
  }
  else {
    print " in category '$cat'";
  }

 #
 #  Set up the select statement
 #
  if (!($days)) { $days = 10956; }
  my ($today, $previous_day) = &get_dates($lda, $days);
  if ($approver_only) {
    $where = "where function_name like '%APPROVER%'";
    if ($days < 10000) {
      $where .= "and action_date > DATE_SUB(sysdate() , INTERVAL $days DAY)";
      print " for Approver authorizations, actions from"
            . " $previous_day to $today";
    }
    else {
      print " for Approver authorizations, actions from"
            . " $previous_day to $today";
      #print " for Approver authorizations";
    }
    if ($picked_user) {
      #$where .= " and kerberos_name = '$picked_user'";
      $where .= "and auth_audit_id in "
                . "(select * from (select auth_audit_id from auth_audit"
                . " where kerberos_name = '$picked_user') as t)";
      print " (username = $picked_user)<BR>";
    }
    else {
      print "<BR>";
    }
  }
  elsif ($picked_user) {
    #$where = "where kerberos_name = '$picked_user'";
    $where = "where auth_audit_id in "
             . "( select * from (select auth_audit_id from auth_audit"
             . " where kerberos_name = '$picked_user') as t )";
    print " for Authorizations for the user '$picked_user'"
          . " for actions from $previous_day to $today<BR>";
  }
  elsif ($modify_user) {
    $where = "where roles_username = '$modify_user'";
    if ($days < 10000) {
      $where .= "and action_date > DATE_SUB(sysdate() , INTERVAL $days DAY)";
    }
    print " for Authorizations modified by '$modify_user'"
          . " for actions from $previous_day to $today<BR>";
  } 
  elsif ($days) {
    $where = "where action_date > DATE_SUB(sysdate() , INTERVAL $days DAY)";
    print " for actions from $previous_day to $today<BR>";
  }

  if ($cat eq 'ALL') {
    $cat_phrase = '';
  }
  else {
    $cat_phrase = "and a.function_category = '$cat'";
  }

  my $stmt = "select roles_username, DATE_FORMAT(action_date, '%m/%d/%Y %H:%i'),"
          . " CASE action_type WHEN 'I' THEN 'Insert' WHEN 'D' THEN 'Delete' ELSE 'Update' END,"
          . " old_new, kerberos_name, function_name,"
 	  . " qualifier_code, do_function,"
          . " CASE grant_and_view WHEN 'GD' THEN 'Y' ELSE 'N' END,"
          . " descend,"
          . " DATE_FORMAT(a.effective_date, '%m/%d/%y'),"
          . " DATE_FORMAT(a.expiration_date, '%m/%d/%y'),"
          . " DATE_FORMAT(a.modified_date, '%m/%d/%y'),"
          . " a.function_category"
          . " from auth_audit a"
 	  . " $where"
          . " $cat_phrase"
 	  . " order by auth_audit_id, old_new";
  #print $stmt;
  #print "<BR>";

 my $csr = $lda->prepare($stmt) or die( $DBI::errstr . "\n");
 $csr->execute();

 #
 #  Get a list of audit trail records and print them
 #
 print "<pre>";
 print << 'ENDOFTEXT';
----------------------------------------------------------------------------------------------------------------------
Modified   Modified             Kerberos Cate- Function                       Qualifier      Do,  Effective Expiration
By       Date     Time  Action  Username gory  Name                           Code          Grant Date      Date
----------------------------------------------------------------------------------------------------------------------
ENDOFTEXT

 my ($count) = 0;
 $last_oldnew = '';
 my @save_record;
 while (my @row = $csr->fetchrow_array())
 {
 my ($aaroles_user, $aadate, $aatype, $aaoldnew,
         $aakerbname, $aafn, $aaqc, $aadf, $aagandv, $aadescend,
         $aaeff, $aaexp, $aamoddate, $aacat) = @row;
   if ($aatype ne 'Update') {  # If Insert or Delete, just print it.
     $count++;
     print "\n";
     $aaoldnew = ' ';
     printf "%-8s %-14s %-6s%1s %-8s %-5s %-30s %-15s %1s,%1s %-9s %-9s\n",
        $aaroles_user, $aadate, $aatype, $aaoldnew, $aakerbname, $aacat, 
        $aafn, $aaqc, $aadf, $aagandv, $aaeff, $aaexp;
   }
   else { # Suppress printing of update records if nothing changed.
     if ($aaoldnew eq '<') {  # First half of Update?
       if ($last_oldnew ne '<') {  # Save this for later.
         @save_record = ($aaroles_user, $aadate, $aatype, $aaoldnew,
           $aakerbname, $aafn, $aaqc, $aadf, $aagandv, $aadescend,
           $aaeff, $aaexp, $aamoddate, $aacat);
       }
       else {  # Two consecutive '<' records
         my ($ttroles_user, $ttdate, $tttype, $ttoldnew,
           $ttkerbname, $ttfn, $ttqc, $ttdf, $ttgandv, $ttdescend,
           $tteff, $ttexp, $ttmoddate) = @save_record;
         printf "%-8s %-14s %-6s%1s %-8s %-5s %-30s %-15s %1s,%1s %-9s %-9s\n",
           $ttroles_user, $ttdate, $tttype, $ttoldnew, $ttkerbname, $ttcat, 
           $ttfn, $ttqc, $ttdf, $ttgandv, $tteff, $ttexp;
         $count++;
         @save_record = ($aaroles_user, $aadate, $aatype, $aaoldnew,
           $aakerbname, $aafn, $aaqc, $aadf, $aagandv, $aadescend,
           $aaeff, $aaexp, $aamoddate, $aacat);
       }
     }
     else {  # Second half of Update.
       if ($last_oldnew eq '<') {  # Print both old and new.
         my ($ttroles_user, $ttdate, $tttype, $ttoldnew,
           $ttkerbname, $ttfn, $ttqc, $ttdf, $ttgandv, $ttdescend,
           $tteff, $ttexp, $ttmoddate, $ttcat) = @save_record;
         if ($ttroles_user eq $aaroles_user && $ttdate eq $aadate
             && $tttype eq $aatype && $ttkerbname eq $aakerbname
             && $ttfn eq $aafn && $ttqc eq $aaqc && $ttdf eq $aadf
             && $ttgandv eq $aagandv && $ttdescend eq $aadescend
             && $tteff eq $aaeff && $ttexp eq $aaexp
             && $ttmoddate eq $aamoddate) {
           # Suppress printing. Nothing changed.
         }
         else {  # Something changed.  Print both records.
           print "\n";
           printf "%-8s %-14s %-6s%1s %-8s %-5s %-30s %-15s %1s,%1s %-9s"
                  . " %-9s\n",
             $ttroles_user, $ttdate, $tttype, $ttoldnew, $ttkerbname, $ttcat, 
             $ttfn, $ttqc, $ttdf, $ttgandv, $tteff, $ttexp;
           printf "%-8s %-14s %-6s%1s %-8s %-5s %-30s %-15s %1s,%1s %-9s"
                  . " %-9s\n",
              $aaroles_user, $aadate, $aatype, $aaoldnew, $aakerbname, $aacat, 
              $aafn, $aaqc, $aadf, $aagandv, $aaeff, $aaexp;
           $count += 2;
         }
       }
     }
   }
   $last_oldnew = $aaoldnew;
 }
 print "\n$count lines displayed\n";
 print "</pre>";
$csr->finish();
 return;

}

###########################################################################
#
#  Function get_dates($database_pointer, $days)
#
#  Returns dates ($today, $previous_day), i.e., today's date and the
#  date $days days before today.
#
###########################################################################
sub get_dates {
  my ($lda, $days) = @_;
  my ($csr);

  my $stmt = "select date_format(sysdate(), '%b %d, %Y'),"
          . " date_format(greatest(DATE_SUB(sysdate(), INTERVAL $days DAY),str_to_date('04021998','%m%d%Y')),"
          . " '%b %d, %Y')"
 	  . " from dual";
 my $csr = $lda->prepare($stmt) or die( $DBI::errstr . "\n");
 $csr->execute();

 my ($today, $previous_day) =  $csr->fetchrow_array();
$csr->finish();
 return ($today, $previous_day);

}

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

