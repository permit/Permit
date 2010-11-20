#!/usr/bin/perl
##############################################################################
#
# CGI script to list people who can create authorizations.
# 
# The requestor must have certificates and must have a meta-authorization
# allowing him to view other people's authorizations within category SAP.
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
# Written by Jim Repa, 3/29/2000 (borrowing code from dlc-auth.cgi)
# Modified by Jim Repa, 3/16/2001 - Give count of users found
# Modified by Jim Repa, 2/19/2004 - Handle HR PRIMARY AUTHORIZERs
#
# Changes:
#   2. Add a link to show audit trail of auths changed by a given
#      person.  Can the history trail work if no category is specified?
#   3. Add an optional filter - see only one category (as shown in item 1)
#   4. In audit trail, maybe there should be the option of only seeing
#      changes to meta-authorizations.
#
##############################################################################
#
# Get packages
#
use rolesweb('login_dbi_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
use rolesweb('parse_authentication_info'); #Use sub. parse_authentication_info in rolesweb.pm
use rolesweb('check_auth_source'); #Use sub. check_auth_source in rolesweb.pm
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm

#
#  Set constants
#
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 $host = $ENV{'HTTP_HOST'};
 $url_stem = "https://$host/cgi-bin/$progname?";  # this URL
# Stem for a url for a users's authorizations
 $url_stem3 = "/cgi-bin/my-auth.cgi?category=SAP+SAP&FORM_LEVEL=1&";  


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
$format = $formval{'format'};
$format = ($format) ? $format : '1';
$filter_opt = $formval{'filter'};
$filter_opt = ($filter_opt) ? $filter_opt : '2';
$sort_opt = $formval{'sort'};
$sort_opt = ($sort_opt) ? $sort_opt : '1';
$picked_category = $formval{'category'};
$picked_cat = ($picked_category) ? $picked_category : 'ALL';
$picked_cat =~ s/\W.*//;  # Keep only the first word.
$picked_cat =~ tr/a-z/A-Z/;  # Raise to upper case

#
#  Adjust $url_stem3 to fill in requested category.
#
if ($picked_category) {
  $category_webstring = &web_string($picked_category);
  $url_stem3 =~ s/SAP\+SAP/$category_webstring/;
}

#
#  Print beginning of the document
#    
 print "Content-type: text/html", "\n\n";
 print "<HTML>", "\n";
 print "<HEAD><TITLE>People who can create authorizations in the perMIT DB",
       "</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 $header = "People who can create authorizations in the perMIT DB";
 if ($picked_cat ne 'ALL') {
   $header .= "<BR>for category $picked_cat";
 }
 &print_header ($header, 'https');
 print "<P>";
 #print "picked_category = '$picked_category'<BR>";

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
$lda = &login_dbi_sql('roles') 
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
&print_roles_user_auths($lda);

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
#  Subroutine print_roles_user_auths.
#
#  Prints out all authorizations that allow people to create authorizations.
#  There are three kinds:
#    1. Function=CREATE AUTHORIZATIONS (create any auth in a category)
#    2. Function=PRIMARY AUTHORIZOR (create a suite of auths. for a DLC)
#    3. Something else (create limited functions and qualifiers)
#
###########################################################################
sub print_roles_user_auths {
    my ($lda) = @_;
    my (@akerbname, @afn, @aqc, @adf, @agandv, @adescend, @amoddate, @modby,
        @acat, $aacat,
        $aafc, $aafn, $aaqc, $aadf, $aagandv, $aadescend, $aamoddate, $modby,
        $csr, $n, @stmt, $prev_kerbname, $kerbstring);

    #
    #  Print out introductory paragraph.
    #
print "<small>";
print << 'ENDOFTEXT';
Below is a list of people who have the authority to create authorizations
for others.  There are three kinds of meta-authorizations that allow a 
person to create authorizations for others:
<ul>
<li>Function = CREATE AUTHORIZATIONS
<br>The person can create any authorization in a given category.
<li>Function = FINANCIAL PRIMARY AUTHORIZER <i>or</i> HR PRIMARY AUTHORIZER
<br>The person can create authorizations for a given department's resources.
<li>Other
<br>The person has one or more specific authorizations with Grant=Y.  They
can create an authorization with the specified function and qualifier (or
other qualifiers that are a subset).
</ul>
Displayed meta-authorizations are grouped by user and by category (e.g., 
SAP, Warehouse, NIMBUS, etc.).
To keep the display fast, the only field with links to other web pages is the
Kerberos username field.
Click on a Kerberos name to see a different display of that user's 
SAP authorizations, complete with links to
web pages about qualifiers and authorization details.<P>
ENDOFTEXT
&print_options_desc($format, $sort_opt, $picked_cat);
print "</small>";
print "<P><HR>";

    #
    # Get a list of all categories
    #
     @stmt = ("select function_category, function_category_desc"
              . " from category");
     $csr = $lda->prepare("$stmt") 
            || die $DBI::errstr;
     $csr->execute();
     my ($ccat, $cdesc);
     my %category_list = ();  # Hash of categories and descriptions
     while (($ccat, $cdesc) = $csr->fetchrow_array()) {
       $category_list{&strip($ccat)} = $cdesc;
     }
     $csr->finish() || die "can't close cursor";    
     $category_list{'ALL'} = 'All categories';  # Add "ALL"

    #
    #  Set up the complex query to display the authorizations.
    #
    my $stmt1 = &get_select_stmt($filter_opt, $sort_opt, $picked_cat);
    #print "$stmt1<BR>";
    unless($csr = $lda->prepare("$stmt")) {
       print $DBI::errstr;
       die;
    }
    $csr->execute();
   
    #
    #  Get a list of authorizations
    #
    @akerbname = ();
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
    @amoddate = ();
    @amodby = ();
    @aqualname = ();
    @afullname = ();
    @adept = ();
    @acat = ();
    my ($old_kerbname, $old_fn, $oldqc);
    while (($aakerbname, $aafn, $aaqc, $aadf, $aagandv, $aadescend, $aaqid, 
       $aaqt, $aahc, $aaqtd, $aacurrent, $aamoddate, $aamodby, $aaqualname,
       $aafullname, $aadept, $aacat) 
	    = $csr->fetchrow_array() )
    {
       $aadept = substr($aadept, 2); #Chop off 'D_'
       if ($aakerbname ne $old_kerbname || $aafn ne $old_fn
           || $old_qc ne $aaqc) {
         push(@akerbname, $aakerbname);
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
         push(@amoddate, $aamoddate);
         push(@amodby, $aamodby);
         push(@adept, $aadept);
         if ($format eq '1') {push(@aqualname, $aaqualname);}
         $aafullname =~ s/ Ii,/ II,/;  $aafullname =~ s/ Iii,/ III,/;
         $aafullname =~ s/ Iv,/ IV,/;
         if ($aafullname =~ /^Mc/) {substr($aafullname, 2, 1) =~ tr/a-z/A-Z/;}
         push(@afullname, $aafullname);
         push(@acat, &strip($aacat));
       }
       else {
         my $old_adept = pop(@adept);
         push(@adept, "$old_adept,$aadept");
       }
       $old_kerbname = $aakerbname;
       $old_fn = $aafn;
       $old_qc = $aaqc;
       #print "$aakerb, $aafn, $aaqc, $aadf, $aagandv, $aadescend \n";
    }
    $csr->finish() || die "can't close cursor";

    #
    #  Before printing out the table, get some constants ready.
    #
     $n = @akerbname;  # How many authorizations?
     $dwidth = &maxlength(\@adept);  # What's longest DEPT string?
     if ($dwidth < 13) {$dwidth = 13;} # Leave enough room for the header
     if ($format eq '2') {
       $fmt_string =
       "%-2s %-30s %-15s %-${dwidth}s %-4s %-4s %-3s %-8s %11s\n",
     }
     else { # ($format must be '1')
       $fmt_string = "%-2s %-30s %-15s %-${dwidth}s %s\n";
     }
    # 
    #  Print out the http document.
    #
    my $prev_cat = '';
    my $kerbname_count = 0;
    if ($n != 0) {
        print "<pre>\n";
        &print_column_header($format, $dwidth);
         $prev_kerbname = '????????';
        for ($i = 0; $i < $n; $i++) {
            if ($prev_kerbname ne $akerbname[$i]) {  # Kerb name break
              $kerbstring = '<A HREF="' . $url_stem3 
                   . 'username=' . $akerbname[$i]
        	   . '">' . $akerbname[$i] . "</A>";
              $kerbstring .= ' <small>' . $afullname[$i] . '</small>';
              print "</pre>$kerbstring<pre>";
              $kerbname_count++;
              $prev_kerbname = $akerbname[$i];
              $prev_cat = '';
            }
            # Label group of authorizations for a new category
            if ($acat[$i] ne $prev_cat) {
              print "\n  <b>$acat[$i] - $category_list{$acat[$i]}</b>\n";
              $prev_cat = $acat[$i];
            }
            if ($adf[$i] eq 'N' || $acurrent[$i] eq 'N') {
              $gray = 1;
              #print "adf=$adf[$i] acurrent=$accurent[$i]<BR>";
            }
            else {$gray = 0;};
            if ($gray) {print '<font color="#909090">';}
            if ($format eq '2') {
              if ($i > 0 && $akerbname[$i] eq $akerbname[$i-1]
                  && $afn[$i] eq $afn[$i-1]
                  && $aqc[$i] eq $aqc[$i-1]) {
                printf $fmt_string,
                ' ', ' ', ' ', $adept[$i], ' ', ' ',
                ' ', ' ', ' ';
              }
              else {
                printf $fmt_string,
                ' ', $afn[$i], $aqc[$i], $adept[$i], $adf[$i], $agandv[$i],
                $acurrent[$i], $amodby[$i], $amoddate[$i];
              }
            }
            else {
              printf $fmt_string,
                ' ', $afn[$i], $aqc[$i], $adept[$i], $aqualname[$i];
            }
            if ($gray) {print "</font>";}
        }
        printf "</pre>\n";
        print "<p><small>Number of users displayed:",
              " $kerbname_count</small><BR>";
    } 
    else {
        #
        # No authorizations found
        #
        print "No users found with meta-authorizations"
              . " to create authorizations<BR>\n";
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
    $astring;
}

###########################################################################
#
#  Subroutine &print_column_header($format, $dwidth)
#
#  Prints a header for columns.  The first parameter should be 1 (display
#  qualifier names on report) or 2 (display authorization flags).
#  The 2nd parameter should be the length of the longest DEPT item.
#
###########################################################################
sub print_column_header {
    my ($format, $dwidth) = @_;
    if ($format eq '2') {
         $dwidth -= 3;  # Steal 3 bytes from DEPT col. for next field name
         printf "%-2s %-30s %-15s %-${dwidth}s %s\n",
           ' ', '', '', 'Qualifier',
           '  Do        In';
         printf "%-2s %-30s %-15s %-${dwidth}s %s\n",
           ' ', 'Function', 'Qualifier', 'is in',
           'func-      Effect Modified  Modified';
         printf "%-2s %-30s %-15s %-${dwidth}s %-4s %-s\n",
           ' ', 'Name', 'Code', 'Dept.',
           ' tion Grant Today By        Date';
     }
    else {
         printf "%-2s %-30s %-15s %-${dwidth}s %s\n",
           ' ', '', '', 'Qualifier',
           '';
         printf "%-2s %-30s %-15s %-${dwidth}s %s\n",
           ' ', 'Function', 'Qualifier', 'is in',
           'Qualifier';
         printf "%-2s %-30s %-15s %-${dwidth}s %-s\n",
           ' ', 'Name', 'Code', 'Dept.',
           'Name';
    }
}

###########################################################################
#
#  Subroutine &print_options_desc($format, $sort_opt, $picked_cat)
#
#  Prints a description of the selected format option and filter option.
#
###########################################################################
sub print_options_desc {
    my ($format, $sort_opt, $picked_cat) = @_;
    if ($format eq '1') {
      print "You selected format option 1, which displays the qualifier name"
        . " for each authorization. "
        . "To see alternate fields (Do_function, Grant, In_effect_today,"
        . " Modified_by, and modified_date) select"
        . " <A HREF=\"$url_stem" . "format=2&sort=$sort_opt"
        . "&category=$picked_cat"
        . "&sort=$sort_opt\">format option 2</A>.";
     }
    else {
      print "You selected format option 2, which displays Do_function, Grant,"
        . " etc. fields for each authorization. "
        . "To see the qualifier name field, select"
        . " <A HREF=\"$url_stem" . "format=1"
        . "&category=$picked_cat"
        . "&sort=$sort_opt\">format option 1</A>.";
    }
    if ($sort_opt eq '2') {
      print " You also selected sort option 2, sorting people"
        . " by last name. "
        . "To sort by Kerberos username, choose"
        . " <A HREF=\"$url_stem" . "format=$format&sort=1"
        . "&category=$picked_cat"
        . "\">sort option 1</A>.";
     }
    else {
      print " You also selected sort option 1,"
        . " sorting people by Kerberos username."
        . " To sort by last name, choose"
        . " <A HREF=\"$url_stem" . "format=$format&sort=2"
        . "&category=$picked_cat"
        . "\">sort option 2</A>.";
    }
}

###########################################################################
#
#  Subroutine &get_select_stmt($filter_opt, $sort_opt)
#
#  Returns the main select statement.
#
###########################################################################
sub get_select_stmt {
    my ($filter_opt, $sort_opt, $picked_cat) = @_;
    my ($sql_frag1, $sql_frag2, $sql_frag3, $sql_frag4);

    $sql_frag1 = "initcap(p.last_name) || ', ' || initcap(p.first_name)"
                 . " || ' (' || decode(p.primary_person_type,"
                 . "'E','Employee: ', 'S', 'Student', 'Other')"
                 . " || q2.qualifier_name || ')'";
    if ($sort_opt eq '1') {
      $sql_frag3 = "";
      $sql_frag4 = "a.kerberos_name, 17, a.function_name, a.qualifier_code";
    }
    else {
      $sql_frag3 = "";
      $sql_frag4 = "15, 17, a.function_name, a.qualifier_code";
    }
    if ($picked_cat ne 'ALL') {
      my $pa_cat = ($picked_cat eq 'SAP') ? 'SAP' : 'META';
      my $pa_cat2 = ($picked_cat eq 'HR') ? 'HR' : 'META';
      $sql_frag3 = " and decode(a.function_category, 'META',"
           . "           decode(substr(a.qualifier_code, 1, 3), 'CAT', "
           . "                  substr(a.qualifier_code, 4), "
           #. "     decode(a.function_name, 'PRIMARY AUTHORIZOR', '$pa_cat',"
           #. "           'META')), "
           . "     decode(f.primary_auth_group, 'FIN', '$pa_cat',"
           . "            'HR', '$pa_cat2',"
           . "            'META')), "
           . "  rtrim(a.function_category, ' ')) = '$picked_cat'";
    }
    return "select a.kerberos_name, a.function_name,"
           . " a.qualifier_code, a.do_function,"
           . " decode(grant_and_view, 'GD', 'Y', 'N'), a.descend,"
           . " a.qualifier_id, 'QT', q.has_child,"
           . " 'QT Desc',"
           . " AUTH_SF_IS_AUTH_CURRENT(a.effective_date,a.expiration_date),"
           . " to_char(a.modified_date, 'DD-MON-YYYY'), a.modified_by,"
           . " q.qualifier_name, $sql_frag1,"
           . " q3.qualifier_code,"
           . " decode(a.function_category,"
           . "  'META', decode(a.function_name,"
           . "          'CREATE AUTHORIZATIONS', substr(a.qualifier_code, 4),"
           . "          'FINANCIAL PRIMARY AUTHORIZER', 'META',"
           . "          'PRIMARY AUTHORIZOR', 'META',"
           . "          'HR PRIMARY AUTHORIZER', 'META',"
           . "          'META'),"
           . "   rtrim(a.function_category, ' '))"
           . " from authorization a, function f,"
           . " primary_auth_descendent pa, person p, qualifier q2,"
           . " qualifier q3, qualifier q"
           . " where f.function_id = a.function_id"
           . " and (f.function_name = 'CREATE AUTHORIZATIONS'"
           . "  or nvl(f.is_primary_auth_parent, 'N') = 'Y'"
           . "  or a.grant_and_view = 'GD')"
           . " and q.qualifier_id = a.qualifier_id"
           . " and pa.child_id(+) = a.qualifier_id"
           . " and pa.is_dlc(+) = 'Y'"
           . " and q3.qualifier_id(+) = pa.parent_id"
           . " and p.kerberos_name = a.kerberos_name"
           . " and q2.qualifier_code(+) = p.dept_code"
           . " and q2.qualifier_type(+) = 'ORGU'"
           . " $sql_frag3"
           . " order by $sql_frag4";

}

##############################################################################
#
#  Function maxlength(\@list)
#
#  Returns the length of the longest element of the list.
#
##############################################################################
sub maxlength {
  my ($rlist) = @_;
  my $maxlength = 0;
  my $item;
  foreach $item (@$rlist) {
    if (length($item) > $maxlength) {
      $maxlength = length($item);
    }
  }
  return $maxlength;
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
 
    ($result) = $csr->fetchrow_array();
    $csr->finish();
    if ($result eq 'Y') {
        return 1;
    } else {
        return 0;
    }
}
