#!/usr/bin/perl
##############################################################################
#
# CGI script to list SAP-related Authorizations for people "within a
# department."  An input parameter contains a department code, D_xxxx.
# A person's authorizations are included if
# s/he has one or more authorizations where Qualifier_code is a descendent
# of D_xxxx in the PRIMARY_AUTH_DESCENDENT table.
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
# Modified by Jim Repa, 2/29/2000 - Use PRIMARY_AUTH_DESCENDENT table
# Modified by Jim Repa, 3/09/2001 - Improve error message
# Modified by Jim Repa, 8/17/2001 - Find people with auths. for super-dept.
#                                   level when looking at a sub-department
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
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 $host = $ENV{'HTTP_HOST'};
 $url_stem = "https://$host/cgi-bin/$progname?";  # this URL
# Stem for a url for a users's authorizations
 $url_stem3 = "/cgi-bin/my-auth.cgi?category=SAP+SAP&FORM_LEVEL=1&";  
 $url_list_dept = "http://$host/cgi-bin/qualauth.pl?"
            . "qualtype=DEPT+%28MIT+departments+%28unofficial%29%29"
            . "&noleaf=1&levels=20";

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
$inc_supdept = $formval{'inc_supdept'};
$inc_supdept = ($inc_supdept) ? $inc_supdept : 'Y';
$inc_supdept =~ tr/a-z/A-Z/;
$url_stem .= "inc_supdept=$inc_supdept&";

#
#  If the qualifier does not begin with a D_, add one.
#
$picked_qual =~ s/^FC_/D_/;
if (substr($picked_qual, 0, 2) ne 'D_') {
  $picked_qual = 'D_' . $picked_qual;
}

#
#  Print beginning of the document
#    
 print "Content-type: text/html", "\n\n";
 print "<HTML>", "\n";
 print "<HEAD><TITLE>SAP Authorizations List",
       "</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 $header = "SAP Authorizations for people authorized on qualifiers"
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


 # authentication checks
  ($info,$k_principal, $domain)  = &parse_authentication_info();  # Parse certificate into a Perl "hash"
  $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase
  $full_name = $k_principal;
  $result = &check_auth_source(\$info); # Check other certificate fields
  if ($result ne 'OK') {
      print "<br><b>Your authentication cannot be accepted: $result";
      exit();
  }

#
#  Log something
#
 $remote_host = $ENV{'REMOTE_HOST'};
 chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
 print STDERR "***$time $remote_host $k_principal $progname $info\n";

 
#
#  Get set to use DBI.
#
use DBI;
 
$lda = login_dbi_sql('roles') || die "$DBI::errstr . \n";

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
#&ora_logoff($lda) || die "can't log off Oracle";    
$lda->disconnect();

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
    my $checksp1 = ($inc_supdept eq 'Y') ? 'CHECKED' : '';
    my $checksp2 = ($checksp1) ? '' : 'CHECKED';

    #
    # Print out FORM stuff to allow a call for a different qualifier
    #    
    print "<FORM METHOD=\"GET\" ACTION=\"$url_stem\">";
    print "Specify another Department code"
     . " (e.g., D_SLOAN, D_RLE, etc.), pick format, filter, and sort"
     . " options, and then click SUBMIT to display another report.<BR>";
    print "<table>",
    "<tr><td><strong>Department<br>code: </strong></td>",
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
    "1. Show only authorizations for qualifiers directly related to the",
    " department<BR>",
    "<INPUT TYPE=RADIO NAME=filter VALUE=2 $checkb2>",
    "2. Show all authorizations for selected people</td></tr>",
    "<tr><td><strong>Sort option:</strong></td>",
    "<td><INPUT TYPE=RADIO NAME=sort VALUE=1 $checks1>",
    "1. Sort by Kerberos username",
    "<BR>",
    "<INPUT TYPE=RADIO NAME=sort VALUE=2 $checks2>",
    "2. Sort by last name and first name</td></tr>",
    "<tr><td><strong>Special option:</strong></td>",
    "<td><INPUT TYPE=RADIO NAME=inc_supdept VALUE=Y $checksp1>",
    "1. Also look for auths. with qualifiers attached to parent department",
    "<BR><INPUT TYPE=RADIO NAME=inc_supdept VALUE=N $checksp2>",
    "2. Do not do special lookup of qualifiers for parent department</td>",
    "</tr>",
    "</table>",
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
authorizations for qualifiers under department
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
             . " where qualifier_type = 'DEPT'"
             . " and qualifier_code = '$picked_qual'");
    $csr = &ora_open($lda, "@stmt")
           || die $ora_errstr;
    ($n) = &ora_fetch($csr);
    &ora_close($csr) || die "can't close cursor";    
    if ($n == 0) {
      print "Department '$picked_qual'"
            . " <strong>does not exist</strong>.<BR>";
      print "<p>Would you like to see a list of "
            . '<a href="' . $url_list_dept 
            . '">valid department codes</a>?<BR>';
    }

    else {  #### Beginning of big ELSE group
     #
     #  Set up the complex query to display the authorizations.
     #
     @stmt = &get_select_stmt($lda, $picked_qual, $filter_opt, 
                              $sort_opt, $inc_supdept);
     #print @stmt;
     #print "<BR>";
     #exit();
#     unless($csr = &ora_open($lda, "@stmt")) {
#        print $ora_errstr;
#        die;
#     }
     $csr = $lda->prepare("$stmt") or die( $DBI::errstr . "\n");
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
     my ($old_kerbname, $old_fn, $oldqc);
     while (($aakerbname, $aafn, $aaqc, $aadf, $aagandv, $aadescend, $aaqid, 
        $aaqt, $aahc, $aaqtd, $aacurrent, $aamoddate, $aamodby, $aaqualname,
        $aafullname, $aadept) 
 	    = $csr->fetchrow_array())
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
#     &ora_close($csr) || die "can't close cursor";
$csr->finish();

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
     if ($n != 0) {
         print "<pre>\n";
         &print_column_header($format, $dwidth);

         $last_kerbname = '????????';
	 for ($i = 0; $i < $n; $i++) {
             if ($last_kerbname ne $akerbname[$i]) {  # Kerb name break
               $kerbstring = '<A HREF="' . $url_stem3 
                    . 'username=' . $akerbname[$i]
	 	   . '">' . $akerbname[$i] . "</A>";
               #if ($sort_opt eq '2') {
               $kerbstring .= ' <small>' . $afullname[$i] 
                           . &get_dept_for_a_person($lda, $akerbname[$i])
                           . '</small>';
               #}
               print "</pre>$kerbstring<pre>";
               $last_kerbname = $akerbname[$i];
             }
             if ($adf[$i] eq 'N' || $acurrent[$i] eq 'N') {
               $gray = 1;
               #print "adf=$adf[$i] acurrent=$accurent[$i]<BR>";
             }
             else {$gray = 0;};
             if ($gray) {print '<font color="#909090">';}
             if ($format eq '2') {
               if ($akerbname[$i] eq $akerbname[$i-1]
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
        . " qualifiers under $picked_qual, choose"
        . " <A HREF=\"$url_stem" . "format=$format&filter=1"
        . "&sort=$sort_opt"
        . "&qualcode=$picked_qual\">filter option 1</A>.";
     }
    else {
      print " You also selected filter option 1,"
        . " which only shows authorizations for qualifiers"
        . " under department $picked_qual."
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
#  Subroutine &get_select_stmt($lda, $picked_qual, $filter_opt, 
#                              $sort_opt, $inc_supdept)
#
#  Returns the main select statement (as an array)
#
###########################################################################
sub get_select_stmt {
    my ($lda, $picked_qual, $filter_opt, $sort_opt, $inc_supdept) = @_;
    my ($sql_frag1, $sql_frag2, $sql_frag3, $sql_frag4);
    my ($sql_frag5, $sql_frag6);
    #
    #  If $inc_supdept eq 'Y', then
    #  call a subroutine to
    #  find out if this is a sub-department.  (Look at the parent
    #  department node and see if it has non-department children.)
    #  If so, then 
    #  generate SQL fragments to add a union of people or auths.
    #  related to the super-department.
    #
    #
    my $super_dept;
    if ($inc_supdept eq 'Y') {
      $super_dept = &find_super_dept($lda, $picked_qual);
      if ($super_dept) {
        $sql_frag5 = " union select distinct a2.authorization_id "
             . " from qualifier q,primary_auth_descendent pa,authorization a2"
             . "  where q.qualifier_type = 'DEPT'"
             . "  and q.qualifier_code = '$super_dept'"
             . "  and pa.parent_id = q.qualifier_id"
             . "  and pa.is_dlc = 'Y'"
             . "  and a2.qualifier_id = pa.child_id"
             . "  and a2.function_category = 'SAP'";
        $sql_frag6 = 
               " union select distinct a.kerberos_name "
             . " from qualifier q,primary_auth_descendent pa,authorization a"
             . "  where q.qualifier_type = 'DEPT'"
             . "  and q.qualifier_code = '$super_dept'"
             . "  and pa.parent_id = q.qualifier_id"
             . "  and pa.is_dlc = 'Y'"
             . "  and a.qualifier_id = pa.child_id"
             . "  and a.function_category = 'SAP'";
      }
    }
    if ($sort_opt eq '1') {
      #$sql_frag1 = "' '";
      $sql_frag1 = "initcap(p.last_name) || ', ' || initcap(p.first_name)";
      $sql_frag3 = "";
      $sql_frag4 = "a.kerberos_name, a.function_name, a.qualifier_code,"
                 . "q3.qualifier_code";
    }
    else {
      $sql_frag1 = "initcap(p.last_name) || ', ' || initcap(p.first_name)";
      #$sql_frag1 = "initcap(p.last_name) || ', ' || initcap(p.first_name)"
      #   . " || ' (' || decode(p.primary_person_type, 'E', 'Employee',"
      #   . " 'S', 'Student', 'Other') || ' '"
      #   . " || q2.qualifier_name || ')'";
      $sql_frag3 = " and p.kerberos_name = a.kerberos_name";
      $sql_frag4 = "15, a.function_name, a.qualifier_code, q3.qualifier_code";
    }
    if ($filter_opt eq '1') {  # Show only auths. with qualcodes for the DLC
      return ("select a.kerberos_name, a.function_name,"
             . " a.qualifier_code, a.do_function,"
             . " decode(grant_and_view, 'GD', 'Y', 'N'), a.descend,"
             . " a.qualifier_id, 'QT', q.has_child,"
             . " 'QT Desc',"
             . " AUTH_SF_IS_AUTH_CURRENT(a.effective_date,a.expiration_date),"
             . " to_char(modified_date, 'DD-MON-YYYY'), modified_by,"
             . " q.qualifier_name, $sql_frag1,"
             . " q3.qualifier_code"
             . " from authorization a,"
             . " primary_auth_descendent pa, person p, qualifier q2,"
             . " qualifier q3, qualifier q"
             . " where a.authorization_id in"
             . " (select distinct a2.authorization_id "
             . "  from qualifier q,primary_auth_descendent pa,authorization a2"
             . "   where q.qualifier_type = 'DEPT'"
             . "   and q.qualifier_code = '$picked_qual'"
             . "   and pa.parent_id = q.qualifier_id"
             . "   and a2.qualifier_id = pa.child_id"
             . "  and a2.function_category = 'SAP'"
             . $sql_frag5
             . "  union"
             . "  select distinct a2.authorization_id"
             . "   from authorization a2"
             . "   where a2.qualifier_code = '$picked_qual')"
             . " and a.function_category = 'SAP'"
             . " and q.qualifier_id = a.qualifier_id"
             . " and pa.child_id(+) = a.qualifier_id"
             . " and pa.is_dlc(+) = 'Y'"
             . " and q3.qualifier_id(+) = pa.parent_id"
             . " and p.kerberos_name = a.kerberos_name"
             . " and q2.qualifier_code(+) = p.dept_code"
             . " and q2.qualifier_type(+) = 'ORGU'"
             . " order by $sql_frag4");
  }
  else {
      return ("select a.kerberos_name, a.function_name,"
             . " a.qualifier_code, a.do_function,"
             . " decode(grant_and_view, 'GD', 'Y', 'N'), a.descend,"
             . " a.qualifier_id, 'QT', q.has_child,"
             . " 'QT Desc',"
             . " AUTH_SF_IS_AUTH_CURRENT(a.effective_date,a.expiration_date),"
             . " to_char(modified_date, 'DD-MON-YYYY'), modified_by,"
             . " q.qualifier_name, $sql_frag1,"
             . " q3.qualifier_code"
             . " from authorization a,"
             . " primary_auth_descendent pa, person p, qualifier q2,"
             . " qualifier q3, qualifier q"
             . " where a.kerberos_name in"
             . " (select distinct a.kerberos_name "
             . "  from qualifier q,primary_auth_descendent pa,authorization a"
             . "   where q.qualifier_type = 'DEPT'"
             . "   and q.qualifier_code = '$picked_qual'"
             . "   and pa.parent_id = q.qualifier_id"
             . "   and a.qualifier_id = pa.child_id"
             . "  and a.function_category = 'SAP'"
             . $sql_frag6
             . "  union"
             . "  select distinct a.kerberos_name"
             . "   from authorization a"
             . "   where a.qualifier_code = '$picked_qual')"
             . " and a.function_category = 'SAP'"
             . " and q.qualifier_id = a.qualifier_id"
             . " and pa.child_id(+) = a.qualifier_id"
             . " and pa.is_dlc(+) = 'Y'"
             . " and q3.qualifier_id(+) = pa.parent_id"
             . " and p.kerberos_name = a.kerberos_name"
             . " and q2.qualifier_code(+) = p.dept_code"
             . " and q2.qualifier_type(+) = 'ORGU'"
             . " order by $sql_frag4");
  }
}

###########################################################################
#
#  Function find_super_dept($lda, $dept_code)
#  Given a qualifier in the DEPT hierarchy, see if there is a parent 
#  department that has direct links to non-department qualifiers (e.g., 
#  a Funds Center, Profit Center Node, etc.)  If so, return that
#  qualifier_code (D_????).  Otherwise, return ''.
#
###########################################################################
sub find_super_dept {
  my ($lda, $dept_code) = @_;

  #
  #  Do query against the qualifier table
  #
  my @stmt = ("select /*+ ORDERED */ q2.qualifier_code"
              . " from qualifier q1, qualifier_child qc, qualifier q2"
              . " where q1.qualifier_type = 'DEPT'"
              . " and q1.qualifier_code = '$dept_code'"
              . " and qc.child_id = q1.qualifier_id"
              . " and q2.qualifier_id = qc.parent_id"
              . " and exists "
              . " (select pad.child_id"
              . "  from primary_auth_descendent pad"
              . "  where pad.parent_id = q2.qualifier_id"
              . "  and pad.is_dlc = 'Y')");
  #print @stmt;
  my $csr = $lda->prepare("$stmt") 
	|| &web_error("DB error in open. "
           . "Problem with select from qualifier table."
           . "<BR><BR>" . $DBI::errstr);
$csr->execute();
  my ($super_dept) = $csr->fetchrow_array() ;
  $csr->finish() || &web_error("DB error. can't close cursor");

  #
  #  Return the values.
  #
  
  return ($super_dept);
}

###########################################################################
#
#  Function get_dept_for_a_person($lda, $kerbname)
#
#  Given a Kerberos username, find the person in the person table
#  and return a string of the form
#      (Employee|Student|Other, department-name)
#
###########################################################################
sub get_dept_for_a_person {
  my ($lda, $kerbname) = @_;

  #
  #  Define a global cursor for selecting from the person and qualifier
  #  tables.
  #
   if (!$gcsr1) {
     my $stmt = ("select"
       . " decode(p.primary_person_type, 'E', 'Employee', 'S', 'Student',"
       . "  'Other'), q.qualifier_name"
       . " from person p, qualifier q"
       . " where p.kerberos_name = ?"
       . " and q.qualifier_type(+) = 'ORGU'"
       . " and q.qualifier_code(+) = p.dept_code");
     #print @stmt;
     unless ($gcsr1 = $lda->prepare($stmt)) {
        &web_error("Oracle error preparing statement"
           . " for select from person/qualifier table join."
           . "<BR><BR>" . $ora_errstr);
     }
   }
  
  #
  #  Bind the variable and do the select.
  #
   $gcsr1->bind_param(1, $kerbname);
   $gcsr1->execute;
   my ($person_type, $dept_name) = $gcsr1->fetchrow_array;
   $gcsr1->finish;

  #
  #  Return the values.
  #
   my $dept_string = " (" . $person_type;
   if ($dept_name) {
      $dept_string .= ": " . $dept_name;
   }
   $dept_string .= ")";
   return ($dept_string);
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
