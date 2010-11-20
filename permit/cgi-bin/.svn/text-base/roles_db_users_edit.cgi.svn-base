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
# Modified 11/22/2004, Mike Moretti (allow administrators to add/delete users)
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
use CGI qw/:cgi/;

my $script = $ENV{'SCRIPT_NAME'};

#
#  Print beginning of the document
#    
 print "Content-type: text/html", "\n\n";
 print "<HTML>", "\n";
 print "<HEAD><TITLE>Users of the perMIT Database",
       "</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 $header = "View or Maintain Users of the perMIT Database";
 &print_header ($header, 'https');
 print "<P>";

#
#  Parse certificate information
#

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
# Login into the database
# 
#&login_sql('rolesw') 
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
#  Find a list of users who can create authorizations
#
 %can_create_auths = ();
 &who_can_create_auths($lda, \%can_create_auths);
 #foreach $key (sort keys %can_create_auths) {
 #  print "$key -> $can_create_auths{$key}<BR>";
 #}
 #exit();

# Does this user have permission to add/drop other users?
my $canAddDrop = can_add_drop_users($lda, $k_principal);

# If they can, get the list of non-deletable users
my $nonDeletableUsers = undef;
if ($canAddDrop) {
    $nonDeletableUsers = get_nondeletable_users($lda);
}

#
# Handle add/delete user
#
my $cgi = new CGI;
if ($cgi->param('drop') ne '') {
    drop_user($lda, $cgi, $canAddDrop, $k_principal);
}
elsif ($cgi->param('add') ne '') {
    add_user($lda, $cgi, $canAddDrop, $k_principal);
}

#
#  Read username->create_date and username->notes 
#  info from roles_users table
#
 %user_create_date = ();
 %user_note = ();
 &read_roles_users_table($lda, \%user_create_date, \%user_note);
 #foreach $key (sort keys %user_create_date) {
 #  print "$key -> $user_create_date{$key} '$user_note{$key}'<BR>";
 #}
 #exit();

#
# Let them add a user (if allowed)
#
display_add_user_form($canAddDrop);

#
#  Print list of users
#
&print_roles_users($lda, \%user_create_date, \%user_note, \%can_create_auths, 
                   $canAddDrop, $nonDeletableUsers);

#
#  Drop connection to Oracle.
#
&ora_logoff($lda) || die "can't log off Oracle";    

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
    my ($lda, $ruser_create_date, $ruser_note,
        $rcan_create_auths, $canAddDrop, 
        $nonDeletableUsers) = @_;
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
     
     while (($aaruname,$pafirname,$palasname,$uacre,$aacdate,$aacver,$aacplat) = $csr->fetchrow_array() )
     {
        push(@aruname, $aaruname);
        push(@afirname, $pafirname);
        push(@alasname, $palasname);
        push(@acre, $uacre);
        push(@acdate, $aacdate);
        push(@acver, $aacver);
        push(@acplat, $aacplat);  
    }
    $csr->finish();

     #
     #  If there is at least one record found, print the table.
     #
     if ($n = @aruname) {
       print "Below is a list of perMIT system users and the" 
	   . " last time they connected via the perMIT application.";
       print "<P>";
       if ($canAddDrop) {
	   print qq{<form action="$script" method="POST">\n};
       }
       print "<TABLE BORDER>", "\n";
       print "<TR><TH ALIGN=LEFT><I>perMIT Username</I></TH>"
         . "<TH ALIGN=LEFT><I>Date Created</I></TH>" 
         . "<TH ALIGN=LEFT><I>First<br>Name</I></TH>"
         . "<TH ALIGN=LEFT><I>Last<br>Name</I></TH>"
         . "<TH ALIGN=LEFT><I>Last<br>Connect</I></TH>"
         . "<TH ALIGN=LEFT><I>Client<br>Version</I></TH>"
	 . "<TH ALIGN=LEFT><I>Client<br>Platform</I></TH>"
	 . "<TH ALIGN=LEFT><i>Can<br>Create<br>Auths</i></TH>";
       print qq{<th align="left"><i>Delete</i></th>} if ($canAddDrop);
       print "</TR>\n";
       my $user_display;
       my $rustring;
       my $temp;
       my $cr_date;
       my $can_create;
       my $ndeletable = 0;
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
	  my $deleteUserCBox = "&nbsp;";
	  if ($canAddDrop) {
	      if (!exists($nonDeletableUsers->{$aruname[$i]}) && $canAddDrop) {
		  $deleteUserCBox = qq{<td align="left"><input type="checkbox" name="dropuser" value="$aruname[$i]"></td>};
		  $ndeletable++;
	      }
	      else {
		  $deleteUserCBox = qq{<td align="left">&nbsp;</td>};
	      }
	  }
	  my $bgcolor = ($i % 2 == 0) ? "" : qq{ bgcolor="#e0e0e0"};
          my $note_for_user = $$ruser_note{$aruname[$i]};
          my $rowspan = ($note_for_user) ? 2 : 1;
          print "<TR$bgcolor><TD ALIGN=LEFT rowspan=$rowspan>$rustring</TD>"
                 . "<TD ALIGN=LEFT>$cr_date</TD>"
                 . "<TD ALIGN=LEFT>$afirname[$i]</TD>"
                 . "<TD ALIGN=LEFT>$alasname[$i]</TD>"
                 . "<TD ALIGN=LEFT>$acdate[$i]</TD>"
                 . "<TD ALIGN=CENTER>$acver[$i]</TD>"
        	 . "<TD ALIGN=LEFT>$acplat[$i]</TD>"
        	 . "<TD ALIGN=LEFT>$can_create</TD>"
		 . $deleteUserCBox
		 . "</TR>\n";

          if ($$ruser_note{$aruname[$i]}) {
	    print "<TR$bgcolor><td colspan=8 align=left>"
                  . "notes: $$ruser_note{$aruname[$i]}</td>"
                  . "</tr>";
	  }
       } 
       if ($canAddDrop && $ndeletable > 0) {
	   print qq{
	       <tr><td align="right" colspan="9"><input type="submit" name="drop" value="Delete Selected Users"></td></tr>
	   };
       }
       print "</TABLE>","\n";
       if ($canAddDrop) {
	   print qq{</form>\n};
       }
       print "<p><small>*Usernames created in the perMIT system prior to"
             . " July 22, 1999 show a 'When Created' date of"
             . " 'before July 22, 1999*'. This date was reset in"
             . " July,&nbsp;1999"
             . " when the database was moved to a new server.</small>"
             . " <BR><small>**The <i>Can Create Auths</i> column"
             . " in the table is marked 'Y'"
             . " for users who are authorized to create authorizations"
             . " in the perMIT Database.</small>";

     }
     else {
	print "No perMIT users at this time.<BR>";
     }

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
    if ($result eq 'Y') {
        return 1;
    } else {
        return 0;
    }
  $csr->finish();
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
    my ($lda, $ruser_create_date, $ruser_note) = @_;

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

    my ($username, $action_date, $action_user, $notes);
    while (($username, $action_date, $action_user, $notes)
            = $csr->fetchrow_array()) {
      $$ruser_create_date{$username} = $action_date;
      $$ruser_note{$username} = $notes;
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

    my ($username);
    while (($username) = $csr->fetchrow_array()) {
      $$rcan_create_auths{$username} = 1;
    }
    $csr->finish();
}

###########################################################################
#
# Function get_nondeletable_users($lda)
#
# Get a list of all users that can't be deleted
# (based on if they own any objects in Oracle).
#
# Returns a handle $ndu to a hash where $ndu->{$username} = 1 for
#   users that cannot be deleted.
#
###########################################################################
sub get_nondeletable_users {
# tbd -- MM
    my ($lda) = @_;
    my $ndu = {};
#    my $ndu_s = ora_open($lda, "select distinct owner from all_objects union select username from dba_users where default_tablespace = 'SYSTEM'");
    # the web client oracle user doesn't have access to dba_users unfortunately; I need to find another way to get that info -- MM
#    my $ndu_s = ora_open($lda, "select distinct owner from all_objects");
#    my $ndu_s = ora_open($lda, "select owner from all_objects union select username from special_username");
    my $ndu_s = $lda->prepare("select owner from dba_objects union select username from special_username");
    $indu_s->execute();
    while (my ($u) = $indu_s->fetchrow_array() ) {
	$ndu->{$u} = 1;
    }
    $ndu_s->finish();
    return($ndu);
}

###########################################################################
#
# Function can_add_drop_users($lda, $user)
#
# Determine if the user has authorization to add/drop users.
# Returns 0 or 1.
#
###########################################################################
sub can_add_drop_users {
    my ($lda, $user) = @_;
    my $stmt = qq{
	select rolesapi_is_user_authorized(?, 'MAINTAIN ROLES DB USERS', 'NULL') from dual
    };
    my $csr = $lda->prepare("$stmt");
    
    $csr->bind_param(1, $user);
    $csr->execute();
    my ($canAddDrop) = $csr->fetchrow_array();
    $csr->finish();
    return($canAddDrop eq 'Y');
}

###########################################################################
#
# Subroutine display_add_user_form
#
# Display a form to let the person add a user
#
###########################################################################
sub display_add_user_form {
    my ($canAddDrop) = @_;
    if (!$canAddDrop) {
      print "<small>You are authorized to view perMIT system usernames, but"
	  . " you are not authorized to add or delete them.</small><BR>";
    }
    else {
      print qq{
<form action="$script" method="POST">
<hr>
<small>You are authorized to add or delete perMIT system users.  You can 
only add a username if it matches an existing MIT Kerberos username. To add 
a username, fill in the "Username" field below and optionally fill in the 
"Notes" field with the reason why you are creating the username.  Then 
click the "Add User" button.  The new username will be created with 
a random password.<p />
To delete one or more perMIT system users, check the appropriate checkboxes
in the "Delete" column of the table below, 
and click the "Delete Selected Users" button at the
bottom of the web page.  Usernames without a delete checkbox can only be 
deleted by the perMIT system administrator.</small>
<hr>
<b>Add a user:</b><br>
<table border="0">
<tr>
<td>Username: </td><td><input type="text" name="adduser"></td>
</tr>
<tr>
<td>Notes (optional): </td><td><input type="text" name="notes" size="75"></td>
</tr>
<tr>
<td colspan="2"><input type="submit" name="add" value="Add User"></td>
</tr>
</table>
</form>
      };
    }
}

###########################################################################
#
# Subroutine message: Display an error message
#
###########################################################################
sub message {
    my ($msg) = @_;
    print "<hr>\n<b>$msg</b><br>\n";
}

###########################################################################
#
# Subroutine add_user ($lda, $cgi_handle, $canAddDrop, $foruser)
#
# Calls a stored procedure to create a new user in the perMIT DB.
#
###########################################################################
sub add_user {
    my ($lda, $cgi, $canAddDrop, $autheduser) = @_;
    unless ($canAddDrop) {
	message("You don't have authorization to add users.");
	return;
    }
    unless ($cgi->param('adduser') ne '') {
	message("You must specify a username");
	return;
    }

    # Make up an arbitrary password using an encrypted copy of username+time (prepended with 'P' because oracle requires alpha first char; also remove all nonalphanumerics because oracle pw has to be all alphanum)
    # (the user will set a real password via the "Forgot" link)
    my $password = 'P' . crypt($cgi->param('adduser') . time(), "ROLESDBWEB");
    $password =~ s/[^A-Za-z0-9]//go;

    my $qry = qq{
	begin
	    web_sp_create_user(?, ?, ?, ?, ?, ?);
	end;
    };
    my $create_s = ora_open($lda, $qry);
    # Since this script uses Oraperl, and rather than rewriting the thing to
    # use DBI, and since Oraperl is just a hack on top of DBI, ora_open returns
    # a standard DBI statement handle so we can use it that way luckily,
    # because Oraperl doesn't provide a way to bind PL/SQL output vars
    my $errmessage = undef;
    my $errcode = undef;
    my $user2add = uc($cgi->param('adduser'));
    $create_s->bind_param(1, $autheduser);
    $create_s->bind_param(2, $user2add);
    $create_s->bind_param(3, $password);
#    print "pw: $password<br>\n";
    $create_s->bind_param(4, $cgi->param('notes'));
#    $create_s->bind_param(4, 'Added via web ui, pw: ' . $password); # for debug porpoises
#    $create_s->bind_param(4, 'Added via web ui');
    $create_s->bind_param_inout(5, \$errmessage, 200);
    $create_s->bind_param_inout(6, \$errcode, 10);

    $create_s->execute();

    if ($create_s->err) {
	message("Database error: " . $create_s->errstr);
	return;
    }

    if ($errcode eq "0") {
	$errcode = "";
    }
    else {
	$errcode .= " - ";
    }
    message("$errcode$errmessage");
    return;
#    message("Added user $user2add");
}

###########################################################################
#
# Subroutine drop_user ($lda, $cgi_handle, $canAddDrop, $foruser)
#
# Calls a stored procedure to drop a perMIT system user.
#
###########################################################################
sub drop_user {
    my ($lda, $cgi, $canAddDrop, $autheduser) = @_;
    unless ($canAddDrop) {
	message("You don't have authorization to delete users.");
	return;
    }
    my @users = $cgi->param('dropuser');

    unless (@users > 0) {
	message("You must select one or more users to delete");
	return;
    }

    my $qry = qq{
	begin
	    web_sp_drop_user(?, ?, ?, ?, ?);
	end;
    };
    my $drop_s = ora_open($lda, $qry);
    my $messages = "";
    foreach my $user (@users) {
	my $errmessage;
	my $errcode;
	$drop_s->bind_param(1, $autheduser);
	$drop_s->bind_param(2, $user);
	$drop_s->bind_param(3, 'Deleted via web ui');
	$drop_s->bind_param_inout(4, \$errmessage, 200);
	$drop_s->bind_param_inout(5, \$errcode, 10);

	$drop_s->execute();
	if ($drop_s->err) {
	    message("Database error: " . $drop_s->errstr);
	    return;
	}
	if ($errcode eq "0") {
	    $errcode = "";
	}
	else {
	    $errcode .= " - ";
	}
	$messages .= "$errcode$errmessage<br>\n";
    }
    message($messages);
}
