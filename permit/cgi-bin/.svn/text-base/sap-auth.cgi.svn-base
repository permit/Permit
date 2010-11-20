#!/usr/bin/perl
##############################################################################
#
# CGI script to list SAP-related Authorizations for people "within a
# department."  An input parameter contains a Fund Center that is the
# top node, FC_X, of a branch of the FC hierarchy representing a given 
# department.  A person is considered to be "within the department" if 
# s/he has one or more authorizations where Qualifier_code is equal 
# to or a descendent of FC_X.
# 
# The requestor must have certificates and must have a meta-authorization
# allowing him to view other people's authorizations within category SAP.
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
# Written by Jim Repa, 12/15/1998 (uses some code from a script
#  written by Dwaine Clarke, spring 1998)
# Modified by Jim Repa, 1/6/1999 - Improve the format
# Modified by Jim Repa, 2/8/1999 - Remove description about SPEND/COMMIT only
# Modified by Jim Repa, 2/24/1999 - Gray out auths that are not in effect
# Modified by Jim Repa, 3/1/1999, 3/3/1999 - Add more format options
# Modified by Jim Repa, 4/8/1999 - Make format option 1 the default
# Modified by Jim Repa, 4/29/1999 - Swap filter options 1 and 2
# Modified by Jim Repa, 1/18/2000 - Add option to sort by last name
# Modified by Jim Repa, 2/1/2000 - Improve format for new report form
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
$picked_qual = $formval{'qualcode'};
$picked_qual =~ tr/a-z/A-Z/;
$format = $formval{'format'};
$format = ($format) ? $format : '1';
$filter_opt = $formval{'filter'};
$filter_opt = ($filter_opt) ? $filter_opt : '2';
$sort_opt = $formval{'sort'};
$sort_opt = ($sort_opt) ? $sort_opt : '2';

#
#  Print beginning of the document
#    
 print "Content-type: text/html", "\n\n";
 print "<HTML>", "\n";
 print "<HEAD><TITLE>SAP Authorizations List",
       "</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 $header = "SAP Authorizations for people authorized on Funds or Fund Centers"
      . " within $picked_qual";
 &print_header ($header, 'https');
 print "<P>";

#
#  Print an error message if user did not specify a qualifier.
#
if (!$picked_qual) {
  print "Error: No Fund Center group was specified.<BR>";
  die;
}


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
#  Log something
#
 $remote_host = $ENV{'REMOTE_HOST'};
 chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
 print STDERR "***$time $remote_host $k_principal $progname $input_string\n";

 
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
#  Make sure the user has a meta-authorization to view all WRHS authorizations.
#
if (!(&verify_metaauth_category($lda, $k_principal, 'SAP'))) {
  print "Sorry.  You do not have the required perMIT system 'meta-authorization'",
  " to view other people's SAP authorizations.";
  exit();
}

#
#  Print authorization list
#
&print_sap_auths($lda, $picked_qual);
print "<HR>";

#
# Print form allowing user to run another report
#
&allow_another_report($format, $picked_qual);

#
#  Drop connection to Oracle.
#
$lda->disconnect() || die "can't log off Oracle";    

print "<hr>";
print "For questions on this service, please send E-mail to rolesdb\@mit.edu";

chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
print STDERR "***$time $remote_host $k_principal $progname Done.\n";
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
    my ($format, $picked_qual) = @_;
    
    #
    # Check the format option that is already in effect
    #
    my $check1 = ($format eq '1') ? 'CHECKED' : '';
    my $check2 = ($check1) ? '' : 'CHECKED';
    my $checkb1 = ($filter_opt eq '1') ? 'CHECKED' : '';
    my $checkb2 = ($checkb1) ? '' : 'CHECKED';
    my $checks1 = ($sort_opt eq '1') ? 'CHECKED' : '';
    my $checks2 = ($checks1) ? '' : 'CHECKED';

    #
    # Print out FORM stuff to allow a call for a different qualifier
    #    
    print "<FORM METHOD=\"GET\" ACTION=\"$url_stem\">";
    print "Specify another Fund Center or"
     . " Fund Center group (e.g., FC_SLOAN01), pick format, filter, and sort"
     . " options, and then click SUBMIT to display another report.<BR>";
    print "<table>",
    "<tr><td><strong>Fund Center<br>or FC group: </strong></td>",
    "<td><INPUT TYPE=TEXT NAME=qualcode value=\"$picked_qual\"></td></tr>",
    "<tr><td><strong>Format option:</strong></td>",
    "<td><INPUT TYPE=RADIO NAME=format VALUE=1 $check1>",
    "1. Display qualifier name",
    "<BR>",
    "<INPUT TYPE=RADIO NAME=format VALUE=2 $check2>",
    "2. Display flags (do_function, grant, in_effect_today, modified_by,",
    " date) </td></tr>",
    "<tr><td><strong>Filter option:</strong></td>",
    "<td><INPUT TYPE=RADIO NAME=filter VALUE=1 $checkb1>",
    "1. Show only authorizations for funds and FCs within the FC group",
    "<BR>",
    "<INPUT TYPE=RADIO NAME=filter VALUE=2 $checkb2>",
    "2. Show all authorizations for selected people</td></tr>",
    "<tr><td><strong>Sort option:</strong></td>",
    "<td><INPUT TYPE=RADIO NAME=sort VALUE=1 $checks1>",
    "1. Sort by Kerberos username",
    "<BR>",
    "<INPUT TYPE=RADIO NAME=sort VALUE=2 $checks2>",
    "2. Sort by last name and first name</td></tr></table>",
    '<center><INPUT TYPE="SUBMIT" VALUE="Submit"></center></FORM>';
}

###########################################################################
#
#  Subroutine print_sap_auths.
#
#  Prints out the SAP authorizations for users having
#  authorizations where the qualifier_code equals or is a descendent
#  of the given Fund Center.
#
###########################################################################
sub print_sap_auths {
    my ($lda, $picked_qual) = @_;
    my (@akerbname, @afn, @aqc, @adf, @agandv, @adescend, @amoddate, @modby,
        $aafc, $aafn, $aaqc, $aadf, $aagandv, $aadescend, $aamoddate, $modby,
        $csr, $n, @stmt, $last_kerbname, $kerbstring);

    $picked_qual = &strip($picked_qual);

    #
    #  Print out introductory paragraph.
    #
print << 'ENDOFTEXT';
Below is a list of SAP authorizations for users who have one or more
authorizations for funds or fund centers within
ENDOFTEXT
    print "$picked_qual. ";
print << 'ENDOFTEXT';
To keep the display fast, the only field with links to other web pages is the
Kerberos username field.
Click on a Kerberos name to see a different display of that user's 
SAP authorizations, complete with links to
web pages about qualifiers and authorization details.<P>
ENDOFTEXT
&print_options_desc($picked_qual, $format, $filter_opt);
print "<P><HR>";

    #
    # Check to make sure $picked_qual exists.
    #
    @stmt = ("select count(*) from qualifier"
             . " where qualifier_type = 'FUND'"
             . " and qualifier_code = '$picked_qual'");
    $csr = $lda->prepare("$stmt") 
           || die $DBI::errstr;
    $csr->execute();
    ($n) = $csr->fetchrow_array() ;
    $csr->finish() || die "can't close cursor";    
    if ($n == 0) {
      print "Fund Center or Fund Center group '$picked_qual'"
            . " <strong>does not exist</strong><BR>";
    }

    else {  #### Beginning of big ELSE group
     #
     #  Set up the complex query to display the authorizations.
     #
     @stmt = &get_select_stmt($picked_qual, $filter_opt, $sort_opt);
     #print @stmt;
     #print "<BR>";
     unless($csr = $lda->prepare("$stmt")) {
        print $DBI::errstr;
        die;
     }
    
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
     while (($aakerbname, $aafn, $aaqc, $aadf, $aagandv, $aadescend, $aaqid, 
        $aaqt, $aahc, $aaqtd, $aacurrent, $aamoddate, $aamodby, $aaqualname,
        $aafullname) 
 	    = $csr->fetchrow_array())
     {
   	# mark any NULL fields found
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
        if ($format eq '1') {push(@aqualname, $aaqualname);}
        if ($sort_opt eq '2') {
          $aafullname =~ s/ Ii,/ II,/;  $aafullname =~ s/ Iii,/ III,/;
          $aafullname =~ s/ Iv,/ IV,/;
          if ($aafullname =~ /^Mc/) {substr($aafullname, 2, 1) =~ tr/a-z/A-Z/;}
          push(@afullname, $aafullname);
        }
        #print "$aakerb, $aafn, $aaqc, $aadf, $aagandv, $aadescend \n";
     }
     $csr->finish() || die "can't close cursor";

     # 
     #  Print out the http document.
     #
 
     $n = @akerbname;  # How many authorizations?
     if ($n != 0) {
         print "<pre>\n";
         &print_column_header($format, $sort_opt);

         $last_kerbname = '????????';
	 for ($i = 0; $i < $n; $i++) {
             if ($last_kerbname ne $akerbname[$i]) {  # Kerb name break
               $kerbstring = '<A HREF="' . $url_stem3 
                    . 'username=' . $akerbname[$i]
	 	   . '">' . $akerbname[$i] . "</A>";
               if ($sort_opt eq '2') {
                 $kerbstring .= ' <small>' . $afullname[$i] . '</small>';
               }
               print "</pre>$kerbstring<pre>";
               $last_kerbname = $akerbname[$i];
             }
             if ($adf[$i] eq 'N' || $acurrent[$i] eq 'N') {$gray = 1;}
             else {$gray = 0;};
             if ($gray) {print '<font color="#909090">';}
             if ($format eq '2') {
               printf "%-2s %-30s %-15s %-4s %-4s %-3s %-8s %11s\n",
	         ' ', $afn[$i], $aqc[$i], $adf[$i], $agandv[$i],
	         $acurrent[$i], $amodby[$i], $amoddate[$i];
             }
             else {
               printf "%-2s %-30s %-15s %s\n",
	         ' ', $afn[$i], $aqc[$i], $aqualname[$i];
             }
             if ($gray) {print "</font>";}
	 }
         printf "</pre>\n";
     } 
     else {
 	 #
	 # $picked_user has no authorizations in $picked_cat
	 #
	 print "No users found with authorizations"
               . " within '$picked_qual'<BR>\n";

     }

    }  #### End of big ELSE group
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
#  Subroutine &print_column_header($format)
#
#  Prints a header for columns.  The parameter should be 1 (display
#  qualifier names on report) or 2 (display authorization flags)
#
###########################################################################
sub print_column_header {
    my ($format, $sort_opt) = @_;
    if ($format eq '2') {
         printf "%-2s %-30s %-12s %s\n",
           ' ', '', '', 
           '  Do        In';
         printf "%-2s %-30s %-12s %s\n",
           ' ', 'Function', 'Qualifier', 
           'func-      Effect Modified  Modified';
         printf "%-2s %-30s %-12s %-4s %-s\n",
           ' ', 'Name', 'Code', ' tion Grant Today By        Date';
     }
    else {
         printf "%-2s %-30s %-12s %s\n",
           ' ', 'Function', 'Qualifier', 
           '   Qualifier';
         printf "%-2s %-30s %-12s %-4s %-s\n",
           ' ', 'Name', 'Code', 
           '   Name';
    }
}

###########################################################################
#
#  Subroutine &print_options_desc($picked_qual, $format, $filter_opt)
#
#  Prints a description of the selected format option and filter option.
#
###########################################################################
sub print_options_desc {
    my ($picked_qual, $format) = @_;
    if ($format eq '1') {
      print "You selected format option 1, which displays the qualifier name"
        . " for each authorization. "
        . "To see alternate fields (Do_function, Grant, In_effect_today,"
        . " Modified_by, and modified_date) select"
        . " <A HREF=\"$url_stem" . "format=2&filter=$filter_opt"
        . "&sort=$sort_opt"
        . "&qualcode=$picked_qual\">format option 2</A>.";
     }
    else {
      print "You selected format option 2, which displays Do_function, Grant,"
        . " etc. fields for each authorization. "
        . "To see the qualifier name field, select"
        . " <A HREF=\"$url_stem" . "format=1&filter=$filter_opt"
        . "&sort=$sort_opt"
        . "&qualcode=$picked_qual\">format option 1</A>.";
    }
    if ($filter_opt eq '2') {
      print " You also selected filter option 2, which shows"
        . " all authorizations for the selected people. "
        . "To hide authorizations not specific to"
        . " funds/fund centers within $picked_qual, choose"
        . " <A HREF=\"$url_stem" . "format=$format&filter=1"
        . "&sort=$sort_opt"
        . "&qualcode=$picked_qual\">filter option 1</A>.";
     }
    else {
      print " You also selected filter option 1,"
        . " which only shows authorizations for funds or FCs"
        . " within $picked_qual."
        . " To show <strong>all</strong> authorizations for the"
        . " selected people, choose"
        . " <A HREF=\"$url_stem" . "format=$format&filter=2"
        . "&sort=$sort_opt"
        . "&qualcode=$picked_qual\">filter option 2</A>.";
    }
    if ($sort_opt eq '2') {
      print " Finally, you selected sort option 2, sorting people"
        . " by last name. "
        . "To sort by Kerberos username, choose"
        . " <A HREF=\"$url_stem" . "format=$format&filter=$filter_opt&sort=1"
        . "&qualcode=$picked_qual\">sort option 1</A>.";
     }
    else {
      print " Finally, you selected sort option 1,"
        . " sorting people by Kerberos username."
        . " To sort by last name, choose"
        . " <A HREF=\"$url_stem" . "format=$format&filter=$filter_opt&sort=2"
        . "&qualcode=$picked_qual\">sort option 2</A>.";
    }
}

###########################################################################
#
#  Subroutine &get_select_stmt($picked_qual, $filter_opt, $sort_opt)
#
#  Returns the main select statement (as an array)
#
###########################################################################
sub get_select_stmt {
    my ($picked_qual, $filter_opt, $sort_opt) = @_;
    my ($sql_frag1, $sql_frag2, $sql_frag3, $sql_frag4);
    if ($sort_opt eq '1') {
      $sql_frag1 = "' '";
      $sql_frag2 = "";
      $sql_frag3 = "";
      $sql_frag4 = "kerberos_name, function_name, qualifier_code";
    }
    else {
      $sql_frag1 = "initcap(p.last_name) || ', ' || initcap(p.first_name)";
      $sql_frag2 = ", person p";
      $sql_frag3 = " and p.kerberos_name = a.kerberos_name";
      $sql_frag4 = "15, function_name, qualifier_code";
    }
    if ($filter_opt eq '1') {  # Show only auths. for F/FCs within FC
      return ("select a.kerberos_name, function_name,"
             . " a.qualifier_code, a.do_function,"
             . " decode(grant_and_view, 'GD', 'Y', 'N'), descend,"
             . " a.qualifier_id, q.qualifier_type, q2.has_child,"
             . " qt.qualifier_type_desc,"
             . " AUTH_SF_IS_AUTH_CURRENT(a.effective_date,a.expiration_date),"
             . " to_char(modified_date, 'DD-MON-YYYY'), modified_by,"
             . " q2.qualifier_name, $sql_frag1"
             . " from authorization a, qualifier q, qualifier_descendent qd,"
             . " qualifier_type qt, qualifier q2 $sql_frag2"
             . " where a.function_category = 'SAP'"
             . " and a.function_name = 'CAN SPEND OR COMMIT FUNDS'"
             . " and a.qualifier_id = qd.child_id"
             . " and qd.parent_id = q.qualifier_id"
             . " and q.qualifier_type = 'FUND'"
             . " and a.qualifier_id = q2.qualifier_id"
             . " and q.qualifier_code = '$picked_qual'"
             . " and qt.qualifier_type = q.qualifier_type"
             . " $sql_frag3"
             . " union select a.kerberos_name, function_name,"
             . " q.qualifier_code, do_function,"
             . " decode(grant_and_view, 'GD', 'Y', 'N'), descend,"
             . " a.qualifier_id, q.qualifier_type, q.has_child,"
             . " qt.qualifier_type_desc,"
             . " AUTH_SF_IS_AUTH_CURRENT(a.effective_date,a.expiration_date),"
             . " to_char(modified_date, 'DD-MON-YYYY'), modified_by,"
             . " q.qualifier_name, $sql_frag1"
             . " from authorization a, qualifier q, qualifier_type qt"
             . "$sql_frag2"
             . " where"
             . " a.qualifier_id = q.qualifier_id"
             . " and q.qualifier_code = '$picked_qual'"
             . " and q.qualifier_type = 'FUND'"
             . " and a.function_category = 'SAP'"
             . " and qt.qualifier_type = q.qualifier_type"
             . " $sql_frag3"
             . " order by $sql_frag4");
  }
  else {
     @stmt = ("select a.kerberos_name, function_name,"
             . " q.qualifier_code, do_function,"
             . " decode(grant_and_view, 'GD', 'Y', 'N'), descend,"
             . " a.qualifier_id, q.qualifier_type, q.has_child,"
             . " qt.qualifier_type_desc,"
             . " AUTH_SF_IS_AUTH_CURRENT(a.effective_date,a.expiration_date),"
             . " to_char(modified_date, 'DD-MON-YYYY'), modified_by,"
             . " q.qualifier_name, $sql_frag1"
             . " from authorization a, qualifier q, qualifier_type qt"  
             . "$sql_frag2"
             . " where a.kerberos_name in"
             . " (select kerberos_name from dept_sap_auth"
             . "  where dept_fc_code = '$picked_qual')"
             . " and a.function_category = 'SAP'"
             . " and q.qualifier_id = a.qualifier_id"
             . " and qt.qualifier_type = q.qualifier_type"
             . " $sql_frag3"
             . " order by $sql_frag4");
  }
}


