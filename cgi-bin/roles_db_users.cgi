#!/usr/bin/perl
##############################################################################
#
# CGI script to list, list of perMIT users when they last time login and 
# made changes.
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
# Written by Varun Uppaluri, 08/29/2000 (uses some code from a script
#                                        by Dwaine Clarke, spring 1998)
# Modified 8/24/2001, Jim Repa (different URL for users + use ROLES_USERS)
# Modified 9/4/2001, Jim Repa (split up those annoying AURORA... users)
# Modified 1/27/2004, Jim Repa (handle new HR primary auths; performance mod)
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
#  Print beginning of the document
#    
 print "Content-type: text/html", "\n\n";
 print "<HTML>", "\n";
 print "<HEAD><TITLE>Users of the perMIT Database",
       "</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 $header = "Users of the perMIT Database";
 &print_header ($header, 'https');
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
#  Get set to use Oracle.
#
use DBI; 

#
# Login into the database
# 
$lda = login_dbi_sql('roles') 
      || die $DBI::errstr;

#
#  Make sure the user has a meta-authorization to view all authorizations.
#
if (!(&verify_special_report_auth($lda, $k_principal, 'ALL'))) {
  print "Sorry.  You do not have the required perMIT system authorization",
  " to run administrative reports.";
  exit();
}

#
#  Read username->create_date info from roles_users table
#
 %user_create_date = ();
 &read_roles_users_table($lda, \%user_create_date);
 #foreach $key (sort keys %user_create_date) {
 #  print "$key -> $user_create_date{$key}<BR>";
 #}
 #exit();

#
#  Find a list of users who can create authorizations
#
 %can_create_auths = ();
 &who_can_create_auths($lda, \%can_create_auths);
 #foreach $key (sort keys %can_create_auths) {
 #  print "$key -> $can_create_auths{$key}<BR>";
 #}
 #exit();

#
#  Print list of users
#
&print_roles_users($lda, \%user_create_date, \%can_create_auths);

#
#  Drop connection to Oracle.
#
$lda->disconnect() || die "can't log off Oracle";    

print "<hr>";
print 
 "For questions on this service, please send E-mail to business-help\@mit.edu";

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
#  Subroutine print_roles_users.
#
#  Prints out a list of usernames in the perMIT Database, along with
#  the date the username was created, first and last name (if available),
#  and last time the user connected to the perMIT system application (if
#  ever).
#
###########################################################################
sub print_roles_users {
    my ($lda, $ruser_create_date, $rcan_create_auths) = @_;
    my (@akerbname, @afn, @aqc, @adf, @agandv, @adescend, @amoddate, @modby,
        $aafc, $aafn, $aaqc, $aadf, $aagandv, $aadescend, $aamoddate, $modby,
        $csr, $n, @stmt, $last_kerbname, $kerbstring);


      print "<P><HR>";
     #
     #  Set up the complex query to display the authorizations.
     #  (Note: UNION would give the same results as UNION ALL, 
     #   but UNION ALL is 150 times faster for this query in Oracle 8.1.7.)
     #
      $stmt = "select a.roles_username, initcap(p.first_name), "
             . " initcap(p.last_name),"
             . " decode(to_char(greatest(u.created,to_date"
             . " ('07221999 2359','MMDDYYYY HH24MI')), 'Mon DD, YYYY'),"
             . " 'Jul 22, 1999', 'before Jul 22, 1999*',"
             . " to_char(u.created, 'Mon DD, YYYY')),"
             . " to_char(a.connect_date, 'Mon DD, YYYY'),"
             . " a.client_version, a.client_platform"
             . " from connect_log a, all_users u, person p"
             . " where (roles_username,connect_date)in"
             . " (select roles_username,max(connect_date)"
             . " from connect_log b"
             . " group by roles_username)"
             . " and a.roles_username = u.username"
             . " and a.roles_username = p.kerberos_name(+)"
             . " union all"
             . " select u.username, initcap(p.first_name), "
             . " initcap(p.last_name),"
             . " decode(to_char(greatest(u.created,to_date"
             . " ('07221999 2359','MMDDYYYY HH24MI')), 'Mon DD, YYYY'),"
             . " 'Jul 22, 1999', 'before Jul 22, 1999*',"
             . " to_char(u.created, 'Mon DD, YYYY')),'','',''"
             . " from all_users u, connect_log c, person p"
             . " where u.username = c.roles_username(+)"
             . " and c.roles_username is null"
             . " and p.kerberos_name(+) = u.username"
	     . " order by 1";
     #print $stmt;
     #print "<BR>";
     unless($csr = $lda->prepare("$stmt")) {
        print $DBI::errstr;
        die;
     }
     $csr->execute();

     #
     #  Get a list of authorizations
     #
     @aruname = ();
     @afirname = ();
     @alasname = ();
     @acre = ();
     @acdate = ();
     @acver = ();
     @acplat = ();
     
     while (($aaruname,$pafirname,$palasname,$uacre,$aacdate,$aacver,$aacplat) =  $csr->fetchrow_array() )
     {
        push(@aruname, $aaruname);
        push(@afirname, $pafirname);
        push(@alasname, $palasname);
        push(@acre, $uacre);
        push(@acdate, $aacdate);
        push(@acver, $aacver);
        push(@acplat, $aacplat);  
    }

     #
     #  If there is at least one record found, print the table.
     #
     if ($n = @aruname) {
       print "Below is a list of perMIT system users and the" 
             . " last time they connected via the perMIT application."
             . " <P><small>*Usernames created in the perMIT system prior to"
             . " July 22, 1999 show a 'When Created' date of"
             . " 'before July 22, 1999*'. This date was reset in"
             . " July,&nbsp;1999"
             . " when the database was moved to a new server.</small>"
             . " <BR><small>**The last column in the table is marked 'Y'"
             . " for users who are authorized to create authorizations"
             . " in the perMIT Database.</small>";
       print "<P>";
       print "<TABLE BORDER>", "\n";
       print "<TR><TH ALIGN=LEFT><I>perMIT Username</I></TH>"
         . "<TH ALIGN=LEFT><I>When Created</I></TH>" 
         . "<TH ALIGN=LEFT><I>First Name</I></TH>"
         . "<TH ALIGN=LEFT><I>Last Name</I></TH>"
         . "<TH ALIGN=LEFT><I>Last Connect Date</I></TH>"
         . "<TH ALIGN=LEFT><I>Client Version</I></TH>"
	 . "<TH ALIGN=LEFT><I>Client Platform</I></TH>"
	 . "<TH ALIGN=LEFT>**</TH></TR>\n";
       my $user_display;
       my $rustring;
       my $temp;
       my $cr_date;
       my $can_create;
       for ($i=0; $i<$n; $i++)
       {
          $user_display = $aruname[$i];
          # Break up those annoying Oracle AURORA* usernames 
          if ($user_display =~ /^AURORA/) {
            # Break at '$UTILITY$'
            $user_display =~ s/\$UTILITY\$$/-<BR>\$UTILITY\$/;  
            # Break at '$UNAUTHENTICATED'
            $user_display =~ s/\$UNAUTHENTICATED$/-<BR>\$UNAUTHENTICATED/;  
          }
          $rustring = '<A HREF="/cgi-bin/pick_user_display.pl?'
                 . 'kerbname=' . $aruname[$i] . '">'
                 . $user_display . '</A>';
          foreach $temp ($afirname[$i], $alasname[$i], $acdate[$i],
                         $acver[$i], $acplat[$i]) {
	      if (!$temp) {$temp = '&nbsp;';}
          }
          $cr_date = ($$ruser_create_date{$aruname[$i]}) 
                     ? $$ruser_create_date{$aruname[$i]}
                     : $acre[$i];
          $can_create = ($$rcan_create_auths{$aruname[$i]})
                        ? "Y" : "&nbsp;";
          print "<TR><TD ALIGN=LEFT>$rustring</TD>"
                 . "<TD ALIGN=LEFT>$cr_date</TD>"
                 . "<TD ALIGN=LEFT>$afirname[$i]</TD>"
                 . "<TD ALIGN=LEFT>$alasname[$i]</TD>"
                 . "<TD ALIGN=LEFT>$acdate[$i]</TD>"
                 . "<TD ALIGN=CENTER>$acver[$i]</TD>"
        	 . "<TD ALIGN=LEFT>$acplat[$i]</TD>"
        	 . "<TD ALIGN=LEFT>$can_create</TD></TR>\n";
       } 
       print "</TABLE>","\n";
     }
     else {
	print "No perMIT users at this time.<BR>";
     }

     $csr->finish() || die "can't close cursor";
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
    my ($lda, $k_principal, $super_category) = @_;
    my ($csr, @stmt, $result);
    if ((!$k_principal) | (!$super_category)) {
        return 0;
    }
    @stmt = ("select ROLESAPI_IS_USER_AUTHORIZED('$k_principal',"
             . "'RUN ADMIN REPORTS', 'NULL') from dual");
    $csr = $lda->prepare("$stmt")
        || die $DBI::errstr;
    $csr->execute();

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
#  Subroutine read_roles_users_table($lda, \%user_create_date);
#
#  Finds all the users and matching create dates from roles_users table.
#  This information will be combined with data from all_users table.
#  (We'll use the create date from the roles_users table where available,
#   because the date in roles_users is persistent across database,
#   whereas the create date is reset at migration time in all_users.)
#
###########################################################################
sub read_roles_users_table {
    my ($lda, $ruser_create_date) = @_;

    my @stmt = ("select username, "
                . " decode(to_char(greatest("
                . " action_date, to_date('07221999 2359','MMDDYYYY HH24MI')"
                . "), "
                . "'Mon DD, YYYY'),"
                . " 'Jul 22, 1999', 'before Jul 22, 1999*',"
                . " to_char(action_date, 'Mon DD, YYYY')),"
                . " action_user, notes"
                . " from roles_users where action_type = 'I'"
                . " order by username, action_date");
    my $csr = $lda->prepare("$stmt")
        || die $DBI::errstr;
    $csr->execute();
    my ($username, $action_date, $action_user, $notes);
    while (($username, $action_date, $action_user, $notes)
            = $csr->fetchrow_array()) {
      $$ruser_create_date{$username} = $action_date;
    }
     $csr->finish();
}

###########################################################################
#
#  Subroutine who_can_create_auths($lda, \%can_create_auths);
#
#  Finds all the users who have a meta-authorization that allows them
#  to create authorizations.  Builds hash %can_create_auths.
#  $can_create_auths{$username} = 1 if the user can create auths. 
#
###########################################################################
sub who_can_create_auths {
    my ($lda, $rcan_create_auths) = @_;

    my @stmt = ("select distinct kerberos_name"
                . " from authorization a, function f"
                . " where f.function_id = a.function_id"
                . " and is_primary_auth_parent = 'Y'"
                . " and do_function = 'Y'"
                . " and sysdate between effective_date"
                . "      and nvl(expiration_date, sysdate)"
                . " union select distinct kerberos_name from authorization"
                . " where function_category = 'META'"
                . " and function_name = 'CREATE AUTHORIZATIONS'"
                . " and do_function = 'Y'"
                . " and sysdate between effective_date"
                . "      and nvl(expiration_date, sysdate)"
                . " union select distinct kerberos_name from authorization"
                . " where grant_and_view = 'GD'"
                . " and sysdate between effective_date"
                . "      and nvl(expiration_date, sysdate)");
    #print @stmt;  print "<BR>";
    my $csr = $lda->prepare("$stmt") 
        || die $DBI::errstr;
    $csr->execute();

    my ($username);
    while (($username) = $csr->fetchrow_array() ) {
      $$rcan_create_auths{$username} = 1;
    }
    $csr->finish();
}
