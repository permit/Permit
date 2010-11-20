#!/usr/bin/perl
##############################################################################
#
# CGI script to display records from the Person_history table
#
#
#  Copyright (C) 2002-2010 Massachusetts Institute of Technology
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
# Written by Jim Repa, 8/22/2002
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
# Stem for a url for a user's current, past, and created auths.
#$g_url_stem2 = "/cgi-bin/pick_user_display.pl?";
# Stem for a url for a user's current auths. in a category
#$g_url_stem3 = "/cgi-bin/my-auth.cgi?FORM_LEVEL=1&";
$g_url_stem3 = "/cgi-bin/audit_trail.pl?&";
#$help_url = "http://$host/authaudit_help.html";


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
$picked_user =~ tr/a-z/A-Z/;
$category = $formval{'category'};
$cat = $category;
&strip($cat);
$cat =~ s/\W.*//;  # Keep only the first word.
$cat =~ tr/a-z/A-Z/; # Raise to upper case
$time_period = $formval{'time_period'};
$time_period =~ tr/a-z/A-Z/;
$find_name_change = $formval{'find_name_change'};
$skip_name_change = ($find_name_change eq '1') 
                    ? '0' 
                    : ( ($picked_user) ? '0' : '1' );
$sort_option = $formval{'sort_option'};

#
#  Define time periods
#
 %time_interval = ('SINCE YESTERDAY' => 1,
                   'LAST 7 DAYS' => 7,
                   'LAST 30 DAYS' => 30,
                   'LAST 90 DAYS' => 90,
                   'LAST 365 DAYS' => 365,
                   'ALL' => 10956,);

#
#  Print beginning of the document
#    
print "Content-type: text/html\n\n";  # Start generating HTML document
print "<head><title>perMIT DB Person Changes</title></head>\n<body>";
print '<BODY bgcolor="#fafafa">';
&print_header
   ("perMIT DB Person Changes", 'https', $help_url);

#
#  Check parameters
#
$days = $time_interval{$time_period};
if (($time_period) && (!$days)) {
  print "Unrecognized time period '$time_period'<BR>";
  die;
}
if ( (!$picked_user) && (!$days) ) {
  print "Error: No Kerberos username or time period"
        . " was specified.<BR>";
  die;
}
if (($time_interval) && !($time_interval{$time_period})) {
  print "Unrecognized time interval: '$time_period'.<BR>";
  die;
}
#if (!$category) {
#  print "Error: No category was specified.<BR>";
#  die;
#}


  # authentication checks
  ($info,$k_principal, $domain)  = &parse_authentication_info();  # Parse authentication info
  $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase
  $full_name = $k_principal;
  $result = &check_auth_source($info); # Check other certificate fields
  if ($result ne 'OK') {
      print "<br><b>Your authentication cannot be accepted: $result";
      exit();
  }

use DBI;
 
#
# Login into the database
# 
#$lda = &login_sql('roles') 
#      || die $ora_errstr;
$lda = login_dbi_sql('roles') || die "$DBI::errstr . \n";

#
#  Make sure the user has a meta-authorization to view all authorizations.
#
# >>>>> Change this <<<<<
if (!(&verify_special_report_auth($lda, $k_principal, 'ALL'))) {
  print "Sorry.  You do not have the required perMIT DB authorization",
  " to run administrative reports.";
  exit();
}

#
# Define a "global" cursors for a select statements.  We'll later bind
# specific values to the parameters.
#
# The statement finds a list of categories for which a given user
# has one or more authorizations.
#

 $stmt1 = "select distinct a.function_category"
          . " from authorization a"
          . " where a.kerberos_name = ?"
          . " order by a.function_category";
 #print $stmt1 . "<BR>";
 unless ($gcsr1 = $lda->prepare($stmt1)) 
 {
    print "Error preparing statement 1.<BR>";
    die;
 }

#
#  Print person history listing
#
print "<P>";
&print_person_history($lda, $picked_user, $days, $cat);
print "<HR>";
exit();

#
# Print form allowing user to run another report
#
#&allow_another_report($lda, $k_principal);

#
#  Drop connection to Oracle.
#
$lda->disconnect() || die "can't log off Oracle";    

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
#  Subroutine print_person_history
#
#  Prints out records from the person_history table.
#
###########################################################################
sub print_person_history {
  my ($lda, $picked_user, $days, $cat) = @_;
  my ($csr, $n, @stmt, $last_kerbname, $kerbstring, $where, $cat_phrase);

 #
 #  Print out introductory paragraph.
 #
  print << 'ENDOFTEXT';
This report shows changes recorded for people's directory information.  
The perMIT system only keeps track of directory information associated 
with Kerberos names used in a current or past authorization.
The history information 
was collected beginning in August, 2002. The first <b>start date</b> for a 
Kerberos username indicates the first recorded date that the username 
had an authorization 
in the perMIT system (on or after July 29, 2002). Each date in this report 
is the date that the perMIT system first noticed a 
change for a username - the dates are <i>not</i> the official dates 
of HR or SIS transactions.
A new record is entered into 
the table for a Kerberos username any time there is a change in the 
associated name, MIT ID number, 6-digit department code, department name, 
or student/employee/other status.
<table>
<tr><td>Changed fields are highlighted in </td>
<td bgcolor=yellow>yellow.</td></tr>
</table>
<p>
ENDOFTEXT
  print "Below is a list of directory changes ";
  #if ($cat eq 'ALL') {
  #  print " in all categories";
  #}
  #else {
  #  print " in category '$cat'";
  #}

 #
 #  Set up the select statement
 #
  if (!($days)) { $days = 10956; }
  my ($today, $previous_day) = &get_dates($lda, $days);
  if ($picked_user) {
    $where = "where ph.kerberos_name = '$picked_user'";
    print " for Kerberos username '$picked_user'"
          . " for actions from $previous_day to $today<BR>";
  }
  elsif ($days) { 
    $where = "where ph.kerberos_name in "
          . " (select distinct ph2.kerberos_name"
          . "  from person_history ph2"
          . "  where IFNULL(ph2.end_date, str_to_date('07292002', '%m%d%Y')) > "
          . "  greatest(DATE_SUB(sysdate(), INTERVAL $days DAY),str_to_date('07292002','%m%d%Y'))"
          . " ) ";
    print " from $previous_day to $today for all"
          . " Kerberos usernames who have perMIT DB authorizations.";
  }
  print "<P>\n";

  $cat_phrase = '';
  if ($picked_user) {
    $cat_phrase = "";
  }
  elsif ($cat eq 'ALL' || $cat eq '') {
    $cat_phrase = " and exists (select a.kerberos_name"
                  . " from authorization a"
                  . " where a.kerberos_name = ph.kerberos_name)";
  }
  else {
    $cat_phrase = " and exists (select a.kerberos_name"
                  . " from authorization a"
                  . " where a.kerberos_name = ph.kerberos_name"
                  . " and a.function_category = '$cat')";
  }

#  my $stmt = "select ph.kerberos_name, ph.mit_id, "
#          . " rtrim(initcap(ph.last_name || ', ' || ph.first_name "
#          . "       || ' ' || ph.middle_name)),"
#          . " ph.unit_code, ph.unit_name, ph.person_type,"
#          . " to_date(ph.begin_date, '%m/%d/%y'),"
#          . " to_date(ph.end_date, '%m/%d/%y'),"
#          . " decode(sign(ph.begin_date - GREATEST(trunc(sysdate- $days ), "
#          . "             TO_DATE('07302002','MMDDYYYY'))), -1, '0', 1, '1')"
#          . " from person_history ph"
# 	  . " $where"
#          . " $cat_phrase"
# 	  . " order by ph.kerberos_name, ph.begin_date";
 my $stmt = "select ph.kerberos_name, ph.mit_id, "
          . " rtrim(initcap(CONCAT(ph.last_name , ', ' , ph.first_name "
          . "       , ' ' , ph.middle_name))),"
          . " ph.unit_code, ph.unit_name, ph.person_type,"
          . " DATE_FORMAT(ph.begin_date, '%m/%d/%y'),"
          . " DATE_FORMAT(ph.end_date, '%m/%d/%y'),"

          . " IF(sign(truncate(ph.begin_date - GREATEST(DATE_SUB(NOW(), INTERVAL $days DAY), "
          . "             STR_TO_DATE('07302002','%m%d%Y')),0)) > 0, '1','0')"
          . " from person_history ph"
          . " $where"
          . " $cat_phrase"
          . " order by ph.kerberos_name, ph.begin_date";

  #print @stmt;
  #print "<BR>";
  unless($csr = $lda->prepare($stmt)) {
    print "$DBI::errstr <BR>";
    die;
  }
$csr->execute();
    
 #
 #  Get a list of person_history records and print them
 #
 print "<table border>\n";
 print "<tr><th>Kerberos<br>Username</th>"
       . "<th>Current<br>Auth.<br>Cate-<br>gories</th>"
       . "<th>MIT ID</th><th>Name</th>"
       . "<th>Employee,<br>student, or<br>other</th>"
       . "<th>Unit<br>code</th><th>Unit Name</th><th>Start<br>Date</th>"
       . "<th>End<br>Date</th></tr>\n";

 my ($count) = 0;
 my ($pkerbname, $pmitid, $pname,
     $pucode, $puname, $ptype, $pbegin_date, $pend_date, $p_recent);
 my ($okerbname, $omitid, $oname, 
     $oucode, $ouname, $otype, $obegin_date, $oend_date, $o_recent);
 my @db_record = ();
 my %kerb_rec_count = ();
 my %kerb_index = ();
 my $demark_color;

 while ( ($pkerbname, $pmitid, $pname,
          $pucode, $puname, $ptype, $pbegin_date, $pend_date, $p_recent)
         = $csr->fetchrow_array() )
 {
   unless (defined($kerb_index{$pkerbname})) {
     $kerb_index{$pkerbname} = scalar(@db_record);
   }
   push(@db_record, join('!', $pkerbname, $pmitid, $pname, $pucode, 
                         $puname, $ptype, $pbegin_date, $pend_date, 
                         $p_recent));
   $kerb_rec_count{$pkerbname}++;
 }
 $csr->finish()
	 || die "can't close cursor";

 if ($sort_option eq '2') {
   $kerbname_to_lastdate = ();
   &reorder_records(\@db_record, \%kerb_index, \%kerb_rec_count,
                    \%kerbname_to_lastdate);
 }

 my $new_count = (keys %kerb_rec_count); # Get count, in case we skip next line
 if ($skip_name_change) {
   $new_count = &remove_name_changes(\@db_record, \%kerb_rec_count);
 }

 my ($rec, $old_rec, $col1, $col2, $auth_cat);
 foreach $rec (@db_record) {
   ($pkerbname, $pmitid, $pname, $pucode,
    $puname, $ptype, $pbegin_date, $pend_date, $p_recent) = split('!', $rec);
   grep ( ($_ ne '') || ($_ = '&nbsp;'),
	   $pkerbname, $pmitid, $pname, 
           $pucode, $puname, $ptype, $pbegin_date, $pend_date );
   print "<tr>";
   if ($pkerbname eq $okerbname) {
     #if ($p_recent) {@ccolor = &set_diff_color($rec, $old_rec);}
     @ccolor = &set_diff_color($rec, $old_rec);
     $col1 = "";
     $col2 = "";
   }
   else {
     $demark_color = ($sort_option eq '2' && $pkerbname ne $okerbname
                      && ($okerbname)
                      && $kerbname_to_lastdate{$pkerbname} ne
                         $kerbname_to_lastdate{$okerbname} ) 
                     ? ' bgcolor=gray' : '';
     print "<tr><td colspan=9 $demark_color>&nbsp;</td></tr>\n";
     $auth_cat = &get_auth_categories($gcsr1, $pkerbname);
     @ccolor = ();
     $col1 = "<td rowspan=$kerb_rec_count{$pkerbname}>"
             . "<a href=\"${g_url_stem3}username=${pkerbname}"
             . "&category=ALL+All+categories\">"
             . "$pkerbname</a></td>";
     $col2 = "<td rowspan=$kerb_rec_count{$pkerbname}>$auth_cat</td>";
   }
   print "${col1}$col2<td $ccolor[1]>$pmitid</td><td $ccolor[2]>$pname</td>"
         . "<td $ccolor[5]><small>$ptype</small></td>"
         . "<td $ccolor[3]>$pucode</td>"
         . "<td $ccolor[4]><small>$puname</small></td>"
         . "<td>$pbegin_date</td><td>$pend_date</td>";
   print "</tr>\n";
   $count++;
   $old_rec = $rec;
   ($okerbname, $omitid, $oname, 
    $oucode, $ouname, $otype, $obegin_date, $oend_date, $o_recent)
    = 
   ($pkerbname, $pmitid, $pname, 
    $pucode, $puname, $ptype, $pbegin_date, $pend_date, $p_recent);
 }
 print "</table>\n";

 print "<p>$new_count Kerberos username(s) displayed\n";
 return;

}

###########################################################################
#
#  Function get_auth_categories($csr, $kerbname);
#
#  Returns a list of current authorization Categories for the given
#  user.  The string is in a printable HTML format.
#
###########################################################################
sub get_auth_categories {
  my ($csr, $kerbuser) = @_;
  my ($cat, @cat_list, $n, $webified_catlist, $item, $i);

  $csr->bind_param(1, $kerbuser);
  $csr->execute;

  @cat_list = ();
  while ( ($cat) = $csr->fetchrow_array ) {
    push(@cat_list, $cat);
  }
  $csr->finish;

  $n = @cat_list;
  if ($n) {
    $i = 0;
    foreach $item (@cat_list) {
      if ($i) {$webified_catlist .= "<BR>";}
      $webified_catlist .= "<a href=\"${g_url_stem3}username=${kerbuser}"
                        . "&category=${item}+${item}\">$item</a>";
      $i++;
    }
  }
  else {
    $webified_catlist = "&nbsp;";
  }

  return $webified_catlist;
}

###########################################################################
#
#  Function set_diff_color($new_rec, $old_rec);
#
#  Looks at two !-delimited lists of items.  Returns an array
#  where the nth element of the array is
#    ''                if the corresponding items in the new and old 
#                      lists match
#    'bgcolor="yellow"'  if they don't match
#
###########################################################################
sub set_diff_color {
  my ($new_rec, $old_rec) = @_;
  
  my @new = split('!', $new_rec);
  my @old = split('!', $old_rec);
  my $n = @new;
  my @diff_array = ();
  for ($i = 0; $i < $n; $i++) {
    if ($new[$i] eq $old[$i]) {
      push(@diff_array, "");
    }
    else {
      push(@diff_array, "bgcolor=\"yellow\"");
    }
  }
  
  return @diff_array;
}

###########################################################################
#
#  Subroutine reorder_records(\@db_record, \%kerb_index,
#                                          \%kerb_rec_count);
#
#  Reorder the records based on the latest date associated with each
#  username.
#
#  Replaces @db_record.
#
###########################################################################
sub reorder_records {
  my ($rdb_record, $rkerb_index, $rkerb_rec_count,
      $rkerbname_to_lastdate) = @_;
  
  my @new_db_record = ();
  my $date_kerb;
  my $kerbname;
  my $idx1;
  my $n_user;
  my %found_kerbname;
  my %sort_kerb_lastdate;
  my %found_kerbname;
  my ($rec, $yymmdd, $sort_date);

 #print "In reorder_records 1<BR>";

 #
 # Find the last date associated with each Kerberos username change.
 #
  foreach $rec (reverse @$rdb_record) {
    my ($pkerbname, $pmitid, $pname, $pucode,
     $puname, $ptype, $pbegin_date, $pend_date, $p_recent) = split('!', $rec); 
    $yymmdd = ($pend_date) 
              ? substr($pend_date, 6, 2) . substr($pend_date, 0, 2)
                . substr($pend_date, 3, 2)
              : substr($pbegin_date, 6, 2) . substr($pbegin_date, 0, 2)
                . substr($pbegin_date, 3, 2);
    $sort_date = 9999999 - $yymmdd;
    #print "$pkerbname -> $pbegin_date - $pend_date, $yymmdd, $sort_date<BR>";
    unless ($found_kerbname{$pkerbname}) {
      $found_kerbname{$pkerbname} = 1;
      $sort_kerb_lastdate{"$sort_date!$pkerbname"} = $pkerbname;
      $$rkerbname_to_lastdate{$pkerbname} = $sort_date;
      #print "Setting $sort_date!$pkerbname -> $pkerbname<BR>";
    }
  }

 #print "In reorder_records 2<BR>";

 #
 # Build the new array.
 #
  foreach $date_kerb (sort keys %sort_kerb_lastdate) {
    #print "$date_kerb <BR>";
    $kerbname = $sort_kerb_lastdate{$date_kerb};
    $idx1 = $$rkerb_index{$kerbname};
    $n_user = $$rkerb_rec_count{$kerbname};
    for ($i = $idx1; $i < $idx1+$n_user; $i++) {
       push(@new_db_record, $$rdb_record[$i]);
    }
  }

 #print "In reorder_records 3<BR>";
  
 # 
 # Now, clear the old array of DB records and replace it with the new one.
 #
  @$rdb_record = @new_db_record;
}

###########################################################################
#
#  Subroutine remove_name_changes(\@db_record, \%kerb_rec_count);
#
#  Look for consecutive records where the only change is 
#  in the name of the person or the name of department
#  Where these are the only changes in "recent" records
#  (flagged in the last item of each row), then we don't want 
#  to show this Kerberos username, and we want to remove all
#  associated records.
#
#  Replaces @db_record, and returns the new count of kerberos usernames.
#
###########################################################################
sub remove_name_changes {
  my ($rdb_record,$rkerb_rec_count) = @_;
  
  my $i = 0;
  my $n = @$rdb_record;
  my $curr_rec;
  my %non_name_change = (); # Flag changes in something other than name
  my $krb_rec_count;
  my (@curr_array, @prev_array, $curr_kerbname);
  my @new_db_record = ();
  
  while ($i < $n) {
    $curr_rec = $$rdb_record[$i];
    @curr_array = split('!', $curr_rec);
    $curr_kerbname = $curr_array[0];
    $krb_rec_count = $$rkerb_rec_count{$curr_kerbname};
    #print "kerbname = '$curr_kerbname' count='$krb_rec_count'<BR>";
    for ($j=0; $j<$krb_rec_count; $j++) {
      unless ($j == 0) {
        $curr_rec = $$rdb_record[$i+$j];
        @curr_array = split('!', $curr_rec);
        $curr_kerbname = $curr_array[0];
      }
      $curr_is_recent = $curr_array[8];
      #print "j=$j recent='$curr_is_recent'<BR>";
      if ($j > 0 && $curr_is_recent == 1) {
        if ($curr_array[1] ne $prev_array[1]
            || $curr_array[3] ne $prev_array[3]
            || $curr_array[5] ne $prev_array[5])
        {
          $non_name_change{$curr_kerbname} = 1;
        }
      }
      @prev_array = @curr_array;
    }
    # If this user has non-name changes, then put records on new array.
    if ($non_name_change{$curr_kerbname}) {
      for ($j=0; $j<$krb_rec_count; $j++) {
        push(@new_db_record, $$rdb_record[$i+$j]);
      }
    }

    $i += $krb_rec_count;
  }
  
  # 
  # Now, clear the old array of DB records and replace it with the new one.
  #
   @$rdb_record = @new_db_record;
  
  #
  # Get new count of Kerberos usernames and return it.
  #
   $n = (keys %non_name_change);
   return $n;

}

###########################################################################
#
#  Function get_dates($database_pointer, $days)
#
#  Returns dates ($today, $previous_day), 
#  i.e., (1) today's date, (2) the date $days days before today (but
#  adjusted so that it is no earlier than 07/30/2002).
#
###########################################################################
sub get_dates {
  my ($lda, $days) = @_;
  my ($csr);

 #my $stmt = ("select to_char(sysdate, 'Mon dd, yyyy'),"
  #        . " to_char(greatest(sysdate-$days,"
  #        . "         to_date('07302002','MMDDYYYY')),"
  #        . " 'Mon dd, yyyy')"
 #        . " from dual");
 my $stmt = ("select DATE_FORMAT(SYSDATE(), '%M %d, %Y'),"
          . " DATE_FORMAT(GREATEST(DATE_SUB(NOW(), INTERVAL $days DAY),"
          . "         STR_TO_DATE('07302002','%m%d%Y')),"
          . " '%M %d, %Y')"
          . " from dual");

  unless($csr = $lda->prepare($stmt) ) {
    print "$DBI::errstr";
    die;
  }
$csr->execute();
    
 my ($today, $previous_day) = $csr->fetchrow_array();
$csr->finish();
 return ($today, $previous_day);

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
    my $stmt = ("select ROLESAPI_IS_USER_AUTHORIZED('$k_principal',"
	     . "'RUN ADMIN REPORTS', 'NULL') from dual");
    $csr = $lda->prepare($stmt) || die( $DBI::errstr . "\n");
$csr->execute();
 
    ($result) = $csr->fetchrow_array();
    if ($result eq 'Y') {
        return 1;
    } else {
        return 0;
    }
}
