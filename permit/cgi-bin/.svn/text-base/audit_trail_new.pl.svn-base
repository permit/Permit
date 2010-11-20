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
# Modified by Jim Repa, 2/13/2009 (Add server user to display)
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
$cost_collector = $formval{'cost_collector'};
if ($cost_collector =~ /^[CIPF]/) {
    $cost_collector = substr($cost_collector, 1);
}
$g_show_server_user = $formval{'show_server_user'};

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
     && (!$approver_only) && (!$cost_collector) ) {
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
#  Parse certificate information
#
$info = $ENV{"SSL_CLIENT_S_DN"};  # Get certificate information
%ssl_info = &parse_authentication_info($info);  # Parse certificate into a Perl "hash"
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
$result = &check_auth_source(\%ssl_info);
if ($result ne 'OK') {
    print "<br><b>Your certificate cannot be accepted: $result";
    exit();
}
 
#
#  Get set to use Oracle.
#
#use Oraperl;  # Point to library of Oracle-related subroutines for Perl
#if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}
use DBI;
 
#
# Login into the database
# 
#$lda = &login_sql('roles') 
#      || die $ora_errstr;
$lda = login_dbi_sql('roles') || die "$DBI::errstr . \n";

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
                   $cat, $cost_collector);
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
  my ($lda, $picked_user, $modify_user, $days, $approver_only, $cat,
      $cost_collector) = @_;
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
      $where .= "and action_date > trunc(sysdate - $days)";
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
                . "(select auth_audit_id from auth_audit"
                . " where kerberos_name = '$picked_user')";
      print " (username = $picked_user)<BR>";
    }
    else {
      print "<BR>";
    }
  }
  elsif ($picked_user) {
    #$where = "where kerberos_name = '$picked_user'";
    $where = "where auth_audit_id in "
             . "(select auth_audit_id from auth_audit"
             . " where kerberos_name = '$picked_user')";
    print " for Authorizations for the user '$picked_user'"
          . " for actions from $previous_day to $today<BR>";
  }
  elsif ($modify_user) {
    $where = "where roles_username = '$modify_user'";
    if ($days < 10000) {
      $where .= "and action_date > trunc(sysdate - $days)";
    }
    print " for Authorizations modified by '$modify_user'"
          . " for actions from $previous_day to $today<BR>";
  } 
  elsif ($cost_collector) {
    $where = 
    "where qualifier_code in 
    (select q2.qualifier_code from 
     qualifier q1, qualifier_descendent qd, qualifier q2
     where q1.qualifier_type in ('COST', 'FUND')
     and q1.qualifier_code in ('C$cost_collector', 'I$cost_collector',
                               'P$cost_collector', 'F$cost_collector')
     and qd.child_id = q1.qualifier_id
     and q2.qualifier_id = qd.parent_id
     and q2.qualifier_code not in ('0HPC00_MIT', 'FCMIT')
     union select 'C$cost_collector' from dual
     union select 'I$cost_collector' from dual
     union select 'P$cost_collector' from dual
     union select 'F$cost_collector' from dual)";
    print " for Authorizations related to Cost Collector or Fund
            ID '$cost_collector'.  The look-up is based on two sources:
            (i) historical
            data for Authorizations and (ii) current data about the Profit 
            Center
            and Funds Center hierarchies.  The report may be inaccurate if
            cost_collector '$cost_collector' has been moved within 
            financial hierarchies.<BR>";
  }
  elsif ($days) {
    $where = "where action_date > trunc(sysdate - $days)";
    print " for actions from $previous_day to $today<BR>";
  }

  if ($cat eq 'ALL') {
    $cat_phrase = '';
  }
  else {
    $cat_phrase = "and a.function_category = '$cat'";
  }

  @stmt = ("select roles_username, to_char(action_date, 'mm/dd/yy hh24:mi'),"
          . " decode(action_type, 'I', 'Insert', 'D', 'Delete', 'Update'),"
          . " old_new, kerberos_name, function_name,"
 	  . " qualifier_code, do_function,"
          . " decode(grant_and_view, 'GD', 'Y', 'N'), descend,"
          . " to_char(a.effective_date, 'mm/dd/yy'),"
          . " to_char(a.expiration_date, 'mm/dd/yy'),"
          . " to_char(a.modified_date, 'mm/dd/yy'),"
          . " a.function_category,"
      . " replace(nvl(server_username,roles_username),roles_username,'n/a')"
          . " from auth_audit a"
 	  . " $where"
          . " $cat_phrase"
 	  . " order by auth_audit_id, old_new");
  #print @stmt;
  #print "<BR>";
 # unless($csr = &ora_open($lda, "@stmt")) {
 #   print "$ora_errstr<BR>";
 #   die;
 # }
  $csr = $lda->prepare("$stmt") or die( $DBI::errstr . "\n");
  $csr->execute();

    
 #
 #  Get a list of audit trail records and print them
 #
 print "<pre>";
 if ($g_show_server_user eq 'Y') {
 print << 'ENDOFTEXT';
-------------------------------------------------------------------------------------------------------------------------------
Modified            Modified             Kerberos Cate- Function                       Qualifier      Do,  Effective Expiration
By       Server   Date     Time  Action  Username gory  Name                           Code          Grant Date      Date
-------------------------------------------------------------------------------------------------------------------------------
ENDOFTEXT
 }
 else {
 print << 'ENDOFTEXT';
----------------------------------------------------------------------------------------------------------------------
Modified   Modified             Kerberos Cate- Function                       Qualifier      Do,  Effective Expiration
By       Date     Time  Action  Username gory  Name                           Code          Grant Date      Date
----------------------------------------------------------------------------------------------------------------------
ENDOFTEXT
 }


 my ($count) = 0;
 $last_oldnew = '';
 my @save_record;
 my ($aaroles_user, $aadate, $aatype, $aaoldnew,
         $aakerbname, $aafn, $aaqc, $aadf, $aagandv, $aadescend,
         $aaeff, $aaexp, $aamoddate, $aacat, $aaserver_user);
 while (($aaroles_user, $aadate, $aatype, $aaoldnew,
         $aakerbname, $aafn, $aaqc, $aadf, $aagandv, $aadescend,
         $aaeff, $aaexp, $aamoddate, $aacat, $aaserver_user)
  = $csr->fetchrow_array())
//&ora_fetch($csr))
 {
   if ($aatype ne 'Update') {  # If Insert or Delete, just print it.
     $count++;
     print "\n";
     $aaoldnew = ' ';
     &print_a_line($g_show_server_user, 
        $aaroles_user, $aaserver_user, $aadate, $aatype, $aaoldnew,  
        $aakerbname, $aacat, 
	$aafn, $aaqc, $aadf, $aagandv, $aaeff, $aaexp);
   }
   else { # Suppress printing of update records if nothing changed.
     if ($aaoldnew eq '<') {  # First half of Update?
       if ($last_oldnew ne '<') {  # Save this for later.
         @save_record = ($aaroles_user, $aadate, $aatype, $aaoldnew,
           $aakerbname, $aafn, $aaqc, $aadf, $aagandv, $aadescend,
           $aaeff, $aaexp, $aamoddate, $aacat, $aaserver_user);
       }
       else {  # Two consecutive '<' records
         my ($ttroles_user, $ttdate, $tttype, $ttoldnew,
           $ttkerbname, $ttfn, $ttqc, $ttdf, $ttgandv, $ttdescend,
           $tteff, $ttexp, $ttmoddate, $ttserver_user) = @save_record;
       ##printf "%-8s %-14s %-6s%1s %-8s %-5s %-30s %-15s %1s,%1s %-9s %-9s\n",
       ##  $ttroles_user, $ttdate, $tttype, $ttoldnew, $ttkerbname, $ttcat, 
       ##  $ttfn, $ttqc, $ttdf, $ttgandv, $tteff, $ttexp;
         &print_a_line($g_show_server_user, 
           $ttroles_user, $ttserver_user, $ttdate, $tttype, $ttoldnew,  
           $ttkerbname, $ttcat, 
	   $ttfn, $ttqc, $ttdf, $ttgandv, $tteff, $ttexp);
       ##printf 
       ##  "%-8s %-8s %-14s %-6s%1s %-8s %-5s %-30s %-15s %1s,%1s %-9s %-9s\n",
       ##  $ttroles_user, $ttserver_user,
       ##  $ttdate, $tttype, $ttoldnew, $ttkerbname, $ttcat, 
       ##  $ttfn, $ttqc, $ttdf, $ttgandv, $tteff, $ttexp;
         $count++;
         @save_record = ($aaroles_user, $aadate, $aatype, $aaoldnew,
           $aakerbname, $aafn, $aaqc, $aadf, $aagandv, $aadescend,
           $aaeff, $aaexp, $aamoddate, $aacat, $aaserver_user);
       }
     }
     else {  # Second half of Update.
       if ($last_oldnew eq '<') {  # Print both old and new.
         my ($ttroles_user, $ttdate, $tttype, $ttoldnew,
           $ttkerbname, $ttfn, $ttqc, $ttdf, $ttgandv, $ttdescend,
           $tteff, $ttexp, $ttmoddate, $ttcat, $ttserver_user) = @save_record;
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
         ##printf 
         ##"%-8s %-8s %-14s %-6s%1s %-8s %-5s %-30s %-15s %1s,%1s %-9s %-9s\n",
         ##$ttroles_user, $ttserver_user,
         ##$ttdate, $tttype, $ttoldnew, $ttkerbname, $ttcat, 
         ##$ttfn, $ttqc, $ttdf, $ttgandv, $tteff, $ttexp;
         &print_a_line ($g_show_server_user,
           $ttroles_user, $ttserver_user,
           $ttdate, $tttype, $ttoldnew, $ttkerbname, $ttcat, 
           $ttfn, $ttqc, $ttdf, $ttgandv, $tteff, $ttexp);;
         ##printf 
         ##"%-8s %-8s %-14s %-6s%1s %-8s %-5s %-30s %-15s %1s,%1s %-9s %-9s\n",
         ##$aaroles_user, $aaserver_user, $aadate, $aatype, $aaoldnew,  
         ##$aakerbname, $aacat, 
         ##$aafn, $aaqc, $aadf, $aagandv, $aaeff, $aaexp;
           &print_a_line(
             $g_show_server_user,
             $aaroles_user, $aaserver_user, $aadate, $aatype, $aaoldnew,  
             $aakerbname, $aacat, 
             $aafn, $aaqc, $aadf, $aagandv, $aaeff, $aaexp);
           $count += 2;
         }
       }
     }
   }
   $last_oldnew = $aaoldnew;
 }
 print "\n$count lines displayed\n";
 print "</pre>";
# &ora_close($csr) || die "can't close cursor";
$csr2->finish();
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
  @stmt = ("select to_char(sysdate, 'Mon dd, yyyy'),"
          . " to_char(greatest(sysdate-$days,to_date('04021998','MMDDYYYY')),"
          . " 'Mon dd, yyyy')"
 	  . " from dual");
  $csr = $lda->prepare("$stmt") or die( $DBI::errstr . "\n");
  $csr->execute();
  #unless($csr = &ora_open($lda, "@stmt")) {
  #  print "$ora_errstr<BR>";
  #  die;
  #}
 my ($today, $previous_day)  = $csr->fetchrow_array(); 
    
 #my ($today, $previous_day) = &ora_fetch($csr);
 #&ora_close($csr);
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

###########################################################################
#
#  Subroutine print_a_line 
#     &print_a_line($g_show_server_user, 
#        $aaroles_user, $aaserver_user, $aadate, $aatype, $aaoldnew,  
#        $aakerbname, $aacat, 
#        $aafn, $aaqc, $aadf, $aagandv, $aaeff, $aaexp);
#
#  Print out a line for the audit trail report.
#  If $g_show_server_user is 'Y', then include $aaserver_user;
#  otherwise, omit it.
###########################################################################
sub print_a_line {
  my ($g_show_server_user, 
      $aaroles_user, $aaserver_user, $aadate, $aatype, $aaoldnew,  
      $aakerbname, $aacat, 
      $aafn, $aaqc, $aadf, $aagandv, $aaeff, $aaexp) = @_;
  if ($g_show_server_user eq 'Y') {
     printf 
        "%-8s %-8s %-14s %-6s%1s %-8s %-5s %-30s %-15s %1s,%1s %-9s %-9s\n",
        $aaroles_user, $aaserver_user, $aadate, $aatype, $aaoldnew,  
        $aakerbname, $aacat, 
        $aafn, $aaqc, $aadf, $aagandv, $aaeff, $aaexp;
  }
  else {
     printf 
        "%-8s %-14s %-6s%1s %-8s %-5s %-30s %-15s %1s,%1s %-9s %-9s\n",
        $aaroles_user, $aadate, $aatype, $aaoldnew,  
        $aakerbname, $aacat, 
        $aafn, $aaqc, $aadf, $aagandv, $aaeff, $aaexp;
  }

}

