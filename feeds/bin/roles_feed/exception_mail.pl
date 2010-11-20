#!/usr/bin/perl -I../../lib/cpa
###############################################################################
#
#  Find a list of exceptions and send notification to appropriate people.
#  This is a quick-and-dirty script that should be rewritten to make it
#  more versatile and maintainable in the future.
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
#  Jim Repa 2/25/00
#
###############################################################################
#
# Get packages
#
use config('GetValue');  # Use the subroutine GetValue in /home/www/permit/feeds/lib/cpa/config.pm

#
# Set some variables and constants
#
$datadir = $ENV{"ROLES_HOMEDIR"} . "/data/";
$db_parm = 'roles';

# Get a list of users with inactive usernames who have authorizations:
#  function_category, kerberos_name, first_name, last_name, 
#  count(authorization_id)

#
#  Get username and password for database connection.
#
 $temp = &GetValue($db_parm);
 $temp =~ m/^(.*)\/(.*)\@(.*)$/;
 $user  = $1;
 $pw = $2;
 $db = $3; 

#
#  Make sure we are set up to use Oraperl.
#
 use Oraperl;
 if (!(defined(&ora_login))) {
   die "Oraperl routine \&ora_login not found.  Missing library?\n";
 }
 
#
#  Open connection to oracle
#
 $lda = &ora_login($db, $user, $pw)
        || die "ora_login failed. $ora_errstr\n";

#
#  Get list of inactive Kerberos usernames who still have authorizations
#  in the Roles DB.
#  We'll build a hash and an array:
#    %category_with_old_user
#      (A list of categories for which there are authorizations for inactive
#       Kerberos names)
#    @cat_user_authcount
#      A list of items of the form
#        $cat!$kerbname!$first_name!$last_name!$auth_count
#
 %category_with_old_user = (); # Array of categories for whom these auths exist
 @cat_user_authcount = (); # Array of category/user items        
 print "Getting list of inactive Kerberos users who still have auths...\n";
 &get_old_users_with_auths($lda,\%category_with_old_user,\@cat_user_authcount);

#
#  Send E-mail to the appropriate people with a list of inactive users
#  who still have authorizations within a given category.
#
 foreach $cat (keys %category_with_old_user) {
   print "$cat....\n";
   #@send_to = ('repa@mitvma.mit.edu');
   #if ($cat eq 'GRAD') {
   #  push(@send_to, 'nwright@mit.edu');
   #}
   @send_to = &notify_who($lda, 'INACTIVE_PERSON', $cat);
   @subset = grep(/^$cat!/, @cat_user_authcount);  # Lines for this category
   if (scalar(@send_to)) {
     &send_inactive_person_email(\@send_to, $cat, \@subset);
   }
 }
 
 &ora_logoff($lda) || die "can't log off Oracle";

 exit();

##############################################################################
#
#  Subroutine 
#    &get_old_users_with_auths($lda,
#                              \%category_with_old_user,
#                              \@cat_user_authcount);
#
#  Finds inactive Kerberos usernames that still have authorizations.
#  
#  %category_with_old_user has a list of categories with old auths. for
#     inactive usernames.
#  @cat_user_authcount has a list of elements of the form
#    $cat!$kerbname!$first_name!$last_name!$auth_count
#
##############################################################################
sub get_old_users_with_auths {

 my ($lda, $rcat_hash, $rdetail_array) = @_; # Get parms.

 #
 #  Open a cursor to read in authorization information for inactive
 #  Kerberos names.
 #
  my @stmt = ("select a.function_category, p.kerberos_name, p.first_name,"
              . " p.last_name, count(a.authorization_id)"
              . " from person p, authorization a"
              . " where p.status_code = 'I'"
              . " and a.kerberos_name = p.kerberos_name"
              . " group by a.function_category, p.kerberos_name,"
              . " p.first_name, p.last_name");
  my $csr = &ora_open($lda, "@stmt")
         || die $ora_errstr;

  #
  #  Read a list of category,kerb_name,first_name,last_name,count
  #
  my ($cat, $kerbname, $first_name, $last_name, $auth_count);
  while (($cat, $kerbname, $first_name, $last_name, $auth_count) 
         = &ora_fetch($csr))
  {
    #print "cat=$cat kerbname=$kerbname auth_count=$auth_count\n";
    $cat = &strip($cat); 
    $$rcat_hash{$cat} = 1;
    push(@$rdetail_array,
          "$cat!$kerbname!$first_name!$last_name!$auth_count");
  }
  &ora_close($csr) || die "can't close cursor";

}

##############################################################################
# In the future, where we send a set of exception lists to each person,
# write a new subroutine to:
# Send mail to a person
# 
# $exception_count = 0;
# @msg = ();
# Put header stuff in @msg
# Get list of exceptions for the person from Roles auths.
# foreach $exc_type (@person_exceptions_types) {
#   $exception_count += &get_exception_message($exc_type, \@msg);
# }
# if ($exception_count > 0) {
#   &send_email($email_address, @msg)
# }
#
#
##############################################################################

##############################################################################
#
#  Subroutine 
#    &send_inactive_person_email(\@send_to, $cat, \@cat_user_authcount);
#
#  Generates E-mail to the people in @send_to about the inactive
#  users with authorizations in category $cat itemized in
#  @cat_user_authcount.
#
##############################################################################
sub send_inactive_person_email {

 my ($rsend_to, $cat, $rcat_user_authcount) = @_; # Get parms.

 #
 #  Construct recipient list
 #
  my ($recipient, $recipient_list);
  my $first_time = 1;
  foreach $recipient (@$rsend_to) {
    if ($first_time) {
      $first_time = 0;
    } 
    else {
      $recipient_list .= ", ";
    }
    $recipient_list .= $recipient;
  }

 #
 #  Open a pipe to the mail command.
 #
  open(MAIL, "|/usr/bin/mail $recipient_list");

 #
 #  Start printing out the mail text
 #
  print MAIL "To: $recipient_list";
  print MAIL "\n";

  print MAIL "Subject: Roles DB exception report - deactivated users\n";

  print MAIL "\nDo not reply to the address in this E-mail.\n";
  print MAIL "\nThis is an exception report from the Roles Database."
        . " The report will be\n"
        . "sent to you once a day whenever there are exceptions"
        . " for which you \n"
        . "are on the notification list.\n";
  print MAIL "\n" . '- ' x 37 . "\n";
  print MAIL "\nOne or more deactivated Kerberos usernames still have"
        . " authorizations in\n"
        . "the Roles DB within category $cat.\n";
  print MAIL "\nThese usernames have been marked for deletion from the"
        . " Kerberos database.\n";
  print MAIL "Their authorizations should be deleted or transferred"
        . " to other usernames.\n\n";

  printf MAIL ("%-8s %-9s %-20s %-20s %5s\n",
         "        ", "Kerberos", "First     ", "Last     ", "Auth.");
  printf MAIL ("%-8s %-9s %-20s %-20s %5s\n",
         "Category", "Username", "Name      ", "Name     ", "Count");
  printf MAIL ("%-8s %-9s %-20s %-20s %5s\n",
         "--------", "--------", "----------", "---------", "-----");

  my $line;
  foreach $line (@$rcat_user_authcount) {
    ($catt,$kerbname,$first_name, $last_name,$auth_count) = split('!',$line);
    printf MAIL ("%-8s %-9s %-20s %-20s %5s\n",
        $catt, $kerbname, $first_name, $last_name, $auth_count);
  }
  print MAIL "\n\n";
  close(MAIL);
  print "Mail sent to $recipient_list\n";

}

##############################################################################
#
#  Function &notify_who($lda, $event, $qualifier);
#
#  Returns a list of E-mail addresses for the people who have Roles 
#  authorizations to receive notification for a given event and qualifier.
#
##############################################################################
sub notify_who {

 my ($lda, $event, $qualifier) = @_; # Get parms.
 my @email_list = ();
 my ($function_name);
 
 #
 # Get function name and qualifier associated with authorizations to 
 # receive notification of this event type and input-qualifier.
 #
 if ($event eq 'INACTIVE_PERSON') {
   $function_name = 'NOTIFICATION - INACTIVE USERS';
   $qualifier = 'CAT' . $qualifier;
 }
 else {
   print "Invalid event name '$event'\n";
   return;
 }
 
 #
 # Open a cursor for a select statement to find appropriate authorizations.
 #
 my $stmt = "select a.kerberos_name,"
   . " nvl(p.email_addr, a.kerberos_name || '\@MIT.EDU')"
   . " from authorization a, person p"
   . " where function_name = '$function_name'"
   . " and function_category = 'META'"
   . " and qualifier_code = '$qualifier'"
   . " and AUTH_SF_IS_AUTH_ACTIVE(a.do_function, a.effective_date,"
   . " a.expiration_date) = 'Y'"
   . " and p.kerberos_name = a.kerberos_name"
   . " union "
   . " select a.kerberos_name,nvl(p.email_addr,a.kerberos_name || '\@MIT.EDU')"
   . " from authorization a, qualifier_descendent qd, qualifier q, person p"
   . " where function_name = '$function_name'"
   . " and qd.parent_id = a.qualifier_id"
   . " and q.qualifier_id = qd.child_id"
   . " and q.qualifier_type = 'CATE'"
   . " and q.qualifier_code = '$qualifier'"
   . " and AUTH_SF_IS_AUTH_ACTIVE(a.do_function, a.effective_date,"
   . " a.expiration_date) = 'Y'"
   . " and p.kerberos_name = a.kerberos_name"
   . " order by 2, 1";

  my $csr = &ora_open($lda, $stmt)
         || die $ora_errstr;

 #
 #  Read a list of kerberos_names and email addresses
 #
  my ($kerbname, $email);
  while (($kerbname, $email) = &ora_fetch($csr))
  {
    push(@email_list, $email);
  }
  &ora_close($csr) || die "can't close cursor";

  @email_list;
}

###########################################################################
#
#  Function &strip(string)
#  Strips off trailing <cr> and leading and trailing blanks.
#
###########################################################################
sub strip {
  local($s);  #temporary string
  $s = $_[0];
  while ($s =~ /[\s\n]$/) {   # Remove trailing <cr> or space
    chop($s);
  }
  while (substr($s,0,1) =~ /^\s/) {
    $s = substr($s,1);
  }
 
  $s;
}
