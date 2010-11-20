#!/usr/bin/perl
##############################################################################
#
# CGI script to list client's perMIT system authorizations.
#
# If the client is a "superuser" (in this context, a superuser is a person
# who is allowed to view authorizations other than his own), 
# the script also prints a form for him to use to view other user's 
# authorizations in particular categories.
#
#
#  Copyright (C) 1998-2010 Massachusetts Institute of Technology
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
# Written by Dwaine Clarke, spring 1998
# Modified by Jim Repa, 11/12/98 to use subroutines from rolesweb.pm
# Modified by Jim Repa, 2/2/99 to add first_name, last_name, etc.
# Modified by Jim Repa, 8/24/00 fix URL for auth-detail with special characters
# Modified by Jim Repa, 7/3/01 Use newer URL (qualauth.pl).  Better error msg.
#
##############################################################################
#
# Get packages
#
use rolesweb('login_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('login_dbi_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
use rolesweb('parse_authentication_info'); #Use sub. parse_ssl_info in rolesweb.pm
use rolesweb('check_auth_source'); #Use sub. check_cert_source in rolesweb.pm
use rolesweb('verify_metaauth_category'); #Use sub. verify_metaauth_category
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm

#
#  Set constants
#
$host = $ENV{'HTTP_HOST'};
$url_stem = "http://$host/cgi-bin/qualauth.pl?"; # URL for qualifiers
$url_stem2 = "https://$host/cgi-bin/auth-detail.pl?";  # URL for auth detail
$help_url = "http://$host/myauth_help.html";
$main_url = "http://$host/webroles.html";

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
#  Print beginning of the document
#    
print "Content-type: text/html\n\n";  # Start generating HTML document
print "<head><title>Authorizations List</title><head>";
#print "<head><title>Authorizations List</title></head>\n<body><center>";
print '<BODY bgcolor="#fafafa">';

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
# Login into the database
# 
use DBI;
$lda = login_dbi_sql('roles') || die "$DBI::errstr . \n";

if ($formval{'FORM_LEVEL'} == '1') {    
# LEVEL 1: the script comes here after a superuser hits the
# submit button. It processes the information submitted 
# by a superuser
 
    $username = $formval{'username'};
    &strip($username);

    if (!$username) {
	# superuser did not enter a username before hitting the submit button
	
	print "Please give a username before submitting the request";
	
	print "<HR>";
        print "<p>Whose authorizations would you like to see?<p>";
 
        &print_superuser_categories($lda, $k_principal);
    } else {
	$username =~ tr/a-z/A-Z/;  # Raise username to uppercase
	
        #
        #  Get superuser category information
        #
	$superuser_category = $formval{'superuser_category'};  # Get value set in &parse_forms()
        if (!$superuser_category) {
          $superuser_category = $formval{'category'}; # This is new var. name
        }
	&strip($superuser_category);
	$superuser_cat = $superuser_category;
	$superuser_cat =~ s/\W.*//;  # Keep only the first word.
	$superuser_category =~ s/\w*\s//;  # Throw out first word.
	$superuser_category =~ tr/A-Z/a-z/;  # Change to lower case
	
	if (!(&verify_metaauth_category($lda, $k_principal, $superuser_cat))) {
	    #
            # Something wrong! User is missing viewing authorization.
	    # Print out the first page 
	    #

            #&print_header
            # ("perMIT system Authorizations for $k_principal", 'https', $help_url);
            &print_header
              ("Not authorized to view $superuser_cat"
               . " authorizations for $username", 'https', $help_url);
 
	    print "<HR>";
	    print "<p>You do not have the necessary viewing authorizations"
                  . " to see $superuser_cat authorizations for others.";
	    
	    #&print_superuser_categories($lda, $k_principal);

	} else {
	    #
	    # everything ok. Print out the authorizations for the chosen user
	    #

	    if ($superuser_cat eq 'ALL') {
                &print_header
                  ("perMIT system Authorizations for $username",'https', $help_url);
	    } else {
                &print_header
		("perMIT system Authorizations for $username<BR>within category $superuser_cat ($superuser_category)", 'https', $help_url);
	    }

	    #
	    #  Get a list of authorizations
	    #
	    &print_auths($lda, $superuser_cat, $username);
	    
	    #
	    # print out form for superuser to select another user 
	    # and view another set of authorizations
	    #
	    print "<HR>";
	    print "<p>Whose authorizations would you like to see?<p>";
	    
	    &print_superuser_categories($lda, $k_principal);
	    
	}
    }
} else {
#
# script comes here the first time it is called
# 
  
    #
    #  Get category information
    #
    &print_header
          ("perMIT system Authorizations for $k_principal", 'https', $help_url);

    &print_auths($lda, 'ALL', $k_principal);
    
    #
    # if person is a superuser 
    #
    if (is_superuser($lda, $k_principal)) {
        print "<HR>";
        print "<p>You have the authority to",
              " view authorizations for others.<BR>",
              " Whose authorizations would you like to see?<p>";
	
	#
        # print out the categories the superuser is allowed to view
	#
        &print_superuser_categories($lda, $k_principal);
 
    }

}


#
#  Drop connection to Oracle.
#
$lda->disconnect();

#
#  Print end of document.
#
print "<hr>";
print "</center>";
print "<A HREF=\"$main_url\"><small>Back to main perMIT web interface page</small></A>";

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
#  Subroutine print_superuser_categories.
#   
#  Prints out the categories from which the superuser, $k_prinicipal,
#  is allowed to choose, if he wants to view another user's authorizations.
#
###########################################################################
sub print_superuser_categories {
    my ($lda, $k_principal) = @_;
    my (@stmt, $csr, @superuser_cat, @supersuer_catdesc, $superuser_category, $superuser_category_d, $i, $option_string, $n);
    
    #
    # form statement used in the query
    #
    $stmt ="select function_category, function_category_desc 
             from category 
             where ROLESAPI_IS_USER_AUTHORIZED('$k_principal',
                   'VIEW AUTH BY CATEGORY',CONCAT('CAT' 
                   ,rtrim(function_category))) = 'Y'
             union 
             select c.function_category, c.function_category_desc
             from category c
             where c.function_category in ('SAP','META', 'ADMN', 'LABD', 'HR')
             and exists 
              (select authorization_id from authorization
               where kerberos_name = '$k_principal'
               and function_category in ('SAP', 'HR')
               and do_function = 'Y'
               and NOW() between effective_date
               and IFNULL(expiration_date,NOW())) ";
    #print $stmt,"<BR>";
    $csr = $lda->prepare("$stmt") or die( $DBI::errstr . "\n");
    $csr->execute();
    
    #
    #  Get a list of function categories
    #
    @superuser_cat = ();
    @superuser_catdesc = ();
    $i = 0;
    while ((($superuser_category,$superuser_category_d) = $csr->fetchrow_array() )) {
        # mark any NULL fields found
        grep(defined ||
	     ($_ = '<NULL>'), $superuser_category,$superuser_category_d);
        push(@superuser_cat, $superuser_category);
        push(@superuser_catdesc, $superuser_category_d);
    }

    #
    # What is the name of this program?
    #
    $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
    $progname = $1;    # Set $progname to this string.
    
    #
    # print out the categories retrieved
    #
    print "</center>\n";
    print "Enter a <strong>username</strong>, select a <strong>category",
          "</strong> and click on the button ",
          "<strong>Show me his/her authorizations</strong>.<BR><BR>";
    print '<FORM METHOD="POST" ACTION="' . $progname . '">';
    print '<TABLE><TR><TD VALIGN=TOP>';
    #print "<h4>Username: <INPUT TYPE=TEXT NAME=username></h4><br>";
    print "<strong>Username: </strong><INPUT TYPE=TEXT NAME=username>",
          " &nbsp;&nbsp;<strong>Category:</strong>";
    print '</TD><TD VALIGN=TOP>';
    
    #print "<h4>Please pick a category:<h4>", "\n";
    print '<SELECT NAME="category" SIZE=10>', "\n";
    
    #
    # Print out the choice "ALL CATEGORIES" if $k_principal
    # is allowed to select it.
    #
    # Select the first choice in the select menu
    #
    if (&verify_metaauth_category($lda, $k_principal, 'ALL')) { 
	print "<OPTION SELECTED>ALL CATEGORIES";
	$option_string = '<OPTION>'; # Subsequent option strings
    } else {
	$option_string = '<OPTION SELECTED>'; # For first choice
    }
    
    $n = @superuser_cat;  # How many categories?
    for ($i = 0; $i < $n; $i++) {
	printf "%s %-5s %s\n", $option_string, $superuser_cat[$i], $superuser_catdesc[$i];
	$option_string = '<OPTION>';   # Subsequent option strings
    }
    $csr->finish();    
    print "</SELECT>", "\n";
    print "</TD></TR></TABLE>\n";
    print '<INPUT TYPE="HIDDEN" NAME="FORM_LEVEL" VALUE="1">', "\n";
    print "<P>", "\n";
    print '<INPUT TYPE="SUBMIT" VALUE="Show me his/her authorizations">',"\n";
    print "</FORM>", "\n";
    
}

###########################################################################
#
#  Function print_user_info($lda, $user)
#
#  Returns 1 if the person is found, 0 if not.
#
#  Prints first_name, last_name, etc. for the given user.
#
###########################################################################
sub print_user_info {
    my ($lda, $picked_user) = @_;

    $picked_user = &strip($picked_user);
    $picked_user =~ tr/a-z/A-Z/;
    
    my ($stmt) = ("select initcap(first_name), initcap(last_name),"
	      . " CASE status_code WHEN 'A' THEN '' WHEN  'I' THEN 'inactive' END AS status_code,"
	      . " CASE primary_person_type WHEN 'S' THEN  'student'  WHEN 'E' THEN  'employee'  ELSE 'other' END AS primary_person_type,"
              . " dept_code, q.qualifier_name"
              . " from person p left outer join  qualifier q on p.dept_code = q.qualifier_code "
	      . " and q.qualifier_type='ORGU' "
              . " where kerberos_name = '$picked_user'");
    my $csr = $lda->prepare("$stmt") || die( "statement: '$stmt'" . $DBI::errstr . "\n");
    $csr->execute();

    #
    #  Get info on the person
    #
    my ($first_name, $last_name, $status, $person_type, $dept_code,
        $dept_name) =   $csr->fetchrow_array();
#    &ora_close($csr) || die "can't close cursor";
     $csr->finish();    

    # 
    #  Print out info on the person
    #
    if (!($first_name)) {
	print "Username '$picked_user' not found<BR>";
        return 0;
    }
    else {
      $dept_name = ($dept_name) ? ', ' . $dept_name : '';
      print "<P><small>$first_name $last_name, $status"
            . " ${person_type}$dept_name</small>";
      return 1;
    }

}

###########################################################################
#
#  Subroutine print_auths.
#
#  Prints out the authorizations for $picked_user in the category
#  $picked_cat
#
###########################################################################
sub print_auths {
    my ($lda, $picked_cat, $picked_user) = @_;
    my (@afc, @afn, @aqc, @adf, @agandv, @adescend, $aafc, $aafn, $aaqc, $aadf, $aagandv, $aadescend, $csr, $n, @stmt, $rc);

    $picked_user = &strip($picked_user);
    $picked_cat = &strip($picked_cat);

    #
    #  Print information about the person.  Quit if person not found.
    #
    if (!($rc = &print_user_info($lda, $picked_user))) {
      return;
    }

    if ($picked_cat eq 'ALL') {$picked_cat = '';}   # Handle 'ALL'

    if ($picked_cat eq '' && $picked_user eq '') {
	$picked_cat = 'NONE_SELECTED';
    }
    my $where = " where ";
    if ($picked_cat ne '') {
	$where .= "function_category = '$picked_cat'";
    }
    if ($picked_cat ne '' && $picked_user ne '') {
	$where .= " and ";
    }
    if ($picked_user ne '') {
	$where .= " kerberos_name = '$picked_user'";
    }
    
    my $stmt = "select function_category, function_name,"
	     . " q.qualifier_code, do_function,"
	     . "  CASE grant_and_view WHEN 'GD' THEN 'Y' ELSE 'N' END AS grant_and_view,"
             . " descend,"
             . " a.qualifier_id, q.qualifier_type, q.has_child,"
             . " qt.qualifier_type_desc,"
             . " auth_sf_is_auth_current(a.effective_date, a.expiration_date)"
	     . " from authorization a, qualifier q, qualifier_type qt"  
	     . $where
             . " and q.qualifier_id = a.qualifier_id"
             . " and qt.qualifier_type = q.qualifier_type"
	     . " order by function_category, function_name, qualifier_code";
    print $stmt;
    $csr = $lda->prepare($stmt) || die( $DBI::errstr . "\n"); 
    $csr->execute();
    
    #
    #  Get a list of authorizations
    #
    @afc = ();
    @afn = ();
    @aqc = ();
    @adf = ();
    @agandv = ();
    @adescend = ();
    @aqid = ();
    @aqt = ();
    @ahc = ();
    @aqtd = ();
    @acurrent = ();
    while (($aafc, $aafn, $aaqc, $aadf, $aagandv, $aadescend, $aaqid, 
            $aaqt, $aahc, $aaqtd, $aacurrent) 
	    = $csr->fetchrow_array() )
    {
  	# mark any NULL fields found
	grep(defined || 
	     ($_ = '<NULL>'),
	     $aafc, $aafn, $aaqc, $aadf, $aagandv, $aadescend, $aaqt);
        $aafc =~ s/\s+$//;  # Strip off trailing blanks
        push(@afc, $aafc);
        push(@afn, $aafn);
        push(@aqc, $aaqc);
        push(@adf, $aadf);
        push(@agandv, $aagandv);
        push(@adescend, $aadescend);
        push(@aqid, $aaqid);
        push(@aqt, $aaqt);
        push(@ahc, $aahc);
        push(@aqtd, $aaqtd);
        push(@acurrent, $aacurrent);
        #print "$aakerb, $aafn, $aaqc, $aadf, $aagandv, $aadescend \n";
    }
   $csr->finish(); 
    # 
    #  Print out the http document.
    #
 
    $n = @afc;  # How many authorizations?
    print "<P>";
    if ($n != 0) {
	print "<TABLE>", "\n";
	printf "<TR><TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH>"
	    . "<TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH></TR>\n",
	    'Function<BR>Category', 'Function<BR>Name', 'Qualifier<BR>Code', 
            'Do<BR>function',
	    'Grant', 'Effective<BR>Today', 'Click for<BR>Details';
	for ($i = 0; $i < $n; $i++) {
	    if ($adf[$i] eq 'N' || $acurrent[$i] eq 'N') {
		$fcolor1 = "<FONT COLOR=GRAY>";
		$fcolor2 = "<\FONT>";
	    }
	    else {
		$fcolor1 = '';
		$fcolor2 = '';
	    }
            $qcode_string = ($aqc[$i] ne 'NULL')
              ? '<A HREF="' . $url_stem . "qualtype=" 
                . &web_string("$aqt[$i] ($aqtd[$i])")
                . '&rootcode=' . &web_string($aqc[$i]) . '">' 
                . $aqc[$i] . '</A>'
              : $aqc[$i];
            $link_string = "<A HREF='" . $url_stem2 . "kerbname="
               . $picked_user . "&category=" . $afc[$i]
               . "&funcname=" . &web_string($afn[$i]) 
               . "&qualcode=" . &web_string($aqc[$i]) . "'>*</A>"; # 8/24/00
            #print "funcname = $afn[$i]\n";
	    printf "<TR><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TD>"
	        . "<TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TD></TR>\n",
		$afc[$i],
		$fcolor1 . $afn[$i] . $fcolor2,
		$qcode_string, $adf[$i], $agandv[$i],
		$acurrent[$i], $link_string;
	    printf "<TR><TD>%s</TD></TR>\n",
	    ' ';
	}
	print "</TABLE>", "\n";
    } else {
	#
	# $picked_user has no authorizations in $picked_cat
	#
	if (!$picked_cat) { 
	    print "No authorizations found for $picked_user in any categories";
	} else {
	    print "No authorizations found for $picked_user in the category, $picked_cat";
	}
    }
}




###########################################################################
#
#  Subroutine is_superuser
#
#  Returns 1 if $k_principal is a superuser, false otherwise
#
###########################################################################
sub is_superuser {
    my ($lda, $k_principal) = @_;
    my (@stmt, $csr, $result);
    $stmt = "select count(*) from authorization where kerberos_name = '$k_principal' and function_name = 'VIEW AUTH BY CATEGORY' and auth_sf_is_auth_active(do_function, effective_date, expiration_date) = 'Y'";
    $csr = $lda->prepare("$stmt") || die( $DBI::errstr . "\n");
    $csr->execute();
    ($result) = $csr->fetchrow_array();
$csr->finish();
    if ($result) {
        return 1;
    } else {
        return 0;
    } 
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
    $astring =~ s/\&/%26/g; # 8/24/00
    $astring =~ s/\?/%3F/g; # 8/24/00
    $astring;
}










