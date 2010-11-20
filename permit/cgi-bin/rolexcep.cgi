#!/usr/bin/perl
##############################################################################
#
# CGI script to list, list of users who are authorize to create authorizations,
# but they don't have a perMIT system username / password.
# 
# The requestor must have certificates and must have a meta-authorization
# allowing him to view other people's authorizations within categories.
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
# Written by Varun and Jim Repa, 08/25/2000 (uses some code from a script
#   written by Dwaine Clarke, spring 1998)
# Modified 6/18/2000, Jim Repa.  Add date of latest authorization
#   that permits the user to create other authorizations
# Modified 1/27/2004, Jim Repa.  Handle new HR Primary Authorizers.
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
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm


#
#  Print beginning of the document
#    
 print "Content-type: text/html", "\n\n";
 print "<HTML>", "\n";
 print "<HEAD><TITLE>Exception Report for perMIT Users",
       "</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 $header = "Exception Report for perMIT Users";
 &print_header ($header, 'https');
 print "<P>";

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

#
# Get sort option from CGI parameter
#
 $sort_option = $formval{'sort_option'}; # 1=username 2=granted-date
 unless($sort_option) {$sort_option = '2';}  # Default=2 (granted_date)

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
$lda = &login_dbi_sql('roles') # Let's point to the production database
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
#  Print authorization list
#
 &print_list_of_auths($lda, $sort_option);

#
#  Drop connection to Oracle.
#
$lda->disconnect() || die "can't log off Oracle";    

print "<hr>";
print 
 "For questions about this service, please send E-mail to rolesdb\@mit.edu";

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
#  Subroutine print_list_of_auths.
#
#  Prints out the SAP authorizations for users having
#  authorizations where the qualifier_code equals or is a descendent
#  of the given Fund Center.
#
###########################################################################
sub print_list_of_auths {
    my ($lda, $sort_option) = @_;
    my (@akerbname, @afn, @aqc, @adf, @agandv, @adescend, @amoddate, @modby,
        $aafc, $aafn, $aaqc, $aadf, $aagandv, $aadescend, $aamoddate, $modby,
        $csr, $n, @stmt, $last_kerbname, $kerbstring);

    #
    #  Set up a cursor to get details about the most recent authorization
    #  for a specific user who can create authorizations.
    #
    my $detail_csr = get_granting_auth_stmt ($lda);

    #
    #  Set up the complex query to display the authorizations.
    #
     my $sql_frag1 = "initcap(b.first_name), initcap(b.last_name)";
     my $sql_frag2 = "and not exists (select u.username from all_users u"
                   . " where u.username = a.kerberos_name)";
     @stmt = (" select distinct a.kerberos_name, $sql_frag1"
              . " from authorization a, function f, person b"
              . " where f.function_id = a.function_id"
              . " and f.is_primary_auth_parent = 'Y'"
              . " and a.do_function = 'Y'"
              . " and sysdate between a.effective_date "
              . "                     and nvl(a.expiration_date, sysdate)"
              . " and a.kerberos_name = b.kerberos_name"
              . " $sql_frag2"
              . " union"
              . " select distinct a.kerberos_name, $sql_frag1"
              . " from authorization a, person b"
              . " where a.function_name = 'CREATE AUTHORIZATIONS'"
              . " and a.do_function = 'Y'"
              . " and sysdate between a.effective_date"
              . "                     and nvl(a.expiration_date, sysdate)"
              . " and a.kerberos_name = b.kerberos_name"
              . " $sql_frag2 "
              . " union"
              . " select distinct a.kerberos_name, $sql_frag1"
              . " from authorization a, person b"
              . " where"
              . " a.grant_and_view = 'GD'"
              . " and sysdate between a.effective_date"
              . "     and nvl(a.expiration_date, sysdate)"
              . " and a.kerberos_name = b.kerberos_name"
              . " $sql_frag2");
    #print @stmt;
    #print "<BR>";
    unless($csr = $lda->prepare("$stmt")) {
       print $DBI::errstr;
       die;
    }
    $csr->execute();
    #print "After CSR open<BR>";

    #
    #  Get a list of authorizations
    #
    my @akerbname = ();
    my @afirname = ();
    my @alasname = ();
    my @amoddate = ();
    my @amodby = ();
    my ($amodified_date, $amodified_by);
    while (($aakerbname,$bafirname,$balasname) = &ora_fetch($csr))
    {
       push(@akerbname, $aakerbname);
       push(@afirname, $bafirname);
       push(@alasname, $balasname);
       ($amodified_date, $amodified_by) 
           = &get_granting_auth_detail ($lda, $detail_csr, $aakerbname);
       push(@amoddate, $amodified_date);
       push(@amodby, $amodified_by);
    }

    #
    #  From @amoddate, build a new array (@sortmod) with elements of the form
    #    yyyy/mm/dd kerbname:nnnnn where nnnnn is the index number from the 
    #    @amoddate array.  Sort the array @sortmod.  Then, we'll be able
    #    to use this array as an index to @akerbname, @afirname, @alasname,
    #    @amoddate, and @amodby, sorted by modified_date.
    #
    my @sortmod = ();
    my $tempdate;
    my %month_number = ('Jan' => '01',
                        'Feb' => '02',
                        'Mar' => '03',
                        'Apr' => '04',
                        'May' => '05',
                        'Jun' => '06',
                        'Jul' => '07',
                        'Aug' => '08',
                        'Sep' => '09',
                        'Oct' => '10',
                        'Nov' => '11',
                        'Dec' => '12',);
    $n = @amoddate;
    my $idx;
    for ($i=0; $i<$n; $i++) {
      @amoddate[$i] =~ /^(.{3}) (.{2}), (.{4})$/;   # "Mon dd, yyyy"
      $tempdate = "$3 $month_number{$1} $2";
      $idx = substr("00000$i", -5, 5);  # convert $i to nnnnn format
      #print "@amoddate[$i] -> $tempdate $idx<BR>";
      push(@sortmod, "$tempdate $akerbname[$i]:$idx");
    }
    if ($sort_option eq '2') {
      @sortmod = sort @sortmod;
    }

    #
    #  If there is at least one record found, print the table.
    #
    print "<P><HR>";
    $sorted_by = ($sort_option eq '1') ? "Kerberos name"
                                       : "date and Kerberos name";
    if ($n = @akerbname) {
      print "Below is a list of users, sorted by $sorted_by,"
            . " who are authorized to create"
            . " authorizations,"
	    . " but do not have a perMIT system username / password.<P>";
      print "<TABLE>", "\n";
      print "<TR ALIGN=LEFT><TH>Kerberos<br>Name</TH>"
       . "<TH>First<br>Name</TH>"
       . "<TH>Last<br>Name</TH>"
       . "<TH>Latest<br>authorization<br>for granting</TH>"
       . "<TH>Modified by</TH></TR>\n";
      my $kerbstring;
      my $j;
      my $temp;
      for ($i=0; $i<$n; $i++)
      {
         ($temp, $j) = split(':', $sortmod[$i]);
         $kerbstring = 
                '<A HREF="/cgi-bin/my-auth.cgi?category=ALL+All+Categories'
                . '&FORM_LEVEL=1&username=' . $akerbname[$j] . '">'
                . $akerbname[$j] . '</A>';
         print "<TR><TD ALIGN=LEFT>$kerbstring</TD>"
               . "<TD ALIGN=LEFT>$afirname[$j]</TD>"
               . "<TD ALIGN=LEFT>$alasname[$j]</TD>"
               . "<TD ALIGN=LEFT>$amoddate[$j]</TD>"
               . "<TD ALIGN=LEFT>$amodby[$j]</TD></TR>\n";
      } 
      print "</TABLE>","\n";
   }   else {
    print "All users who are authorized to create authorizations already"
             . " have a perMIT system username/password.<BR>";
   }
   $csr->finish() || die "can't close cursor";
}

###########################################################################
#
#  Function get_granting_auth_stmt ($lda);
#
#  Generates a statement for getting detailed information about the
#  most recent authorization that allows a person to create authorizations
#  for others.  Returns a handle to the statement.
#
###########################################################################
sub get_granting_auth_stmt {
 my ($lda) = @_;
 #
 #  Set up the SELECT statement
 #
 my $stmt = 
  "select to_char(a.modified_date, 'Mon DD, YYYY')," 
  . " a.modified_by from authorization a"
  . " where a.kerberos_name = ?"
  . " and a.modified_date = "
  . " (select max(b.modified_date) from authorization b, function f"
  . "  where b.kerberos_name = a.kerberos_name"
  . "  and f.function_id = b.function_id"
  . "  and ( "
  . "  (f.is_primary_auth_parent = 'Y'"
  . "    and b.do_function = 'Y' and"
  . "    sysdate between b.effective_date and nvl(b.expiration_date, sysdate))"
  . "   or (b.function_name = 'CREATE AUTHORIZATIONS'"
  . "    and b.do_function = 'Y' and"
  . "    sysdate between b.effective_date and nvl(b.expiration_date, sysdate))"
  . "   or (b.grant_and_view = 'GD')"
  . "  )"
  . " )";
 #print $stmt;
 #print "<BR>";
 my $sth;
 unless ($sth = $lda->prepare($stmt)) {
    print "<br><b>Error preparing statement:</b><br>$stmt<br>";
    exit();
 }
 return $sth;
}

###########################################################################
#
#  Function get_granting_auth_detail ($csr, $kerbname);
#
#  Finds the most recent authorization that allows a person
#  to create other authorizations, and returns the modify_date and
#  the modified_by person for that authorization.
#
###########################################################################
sub get_granting_auth_detail {
 my ($lda, $csr, $kerbname) = @_;

 #
 #  Bind variable for the select statement
 #
 unless ($csr->bind_param(1, $kerbname)) {  # Bind 1st (and only) parameter
    print "<br><b>Error binding parameter</b><br>";
    exit();
 }
 unless ($csr->execute) {  # Execute the statement
    print "<br><b>Error executing statement</b><br>";
    exit();
 }

 #
 #  Get modified_date and modified_by for most recent authorization
 #  for the given user that allows him to create authorizations.
 #
 my ($modified_date, $modified_by);
 unless ( ($modified_date, $modified_by) = $csr->fetchrow_array ) {
    print "<br><b>Error in fetchrow_array</b><br>";
    print "code=" . $lda->err . " msg=" . $lda->errstr . "<br>";
    exit();
 }
 $csr->finish;

 #
 #  Return the pair of values.
 #
 return ($modified_date, $modified_by);
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
        || die $ora_errstr;
    $csr->execute();
 
    ($result) = $csr->fetchrow_array() ;
    $csr->finish();
    if ($result eq 'Y') {
        return 1;
    } else {
        return 0;
    }
}
