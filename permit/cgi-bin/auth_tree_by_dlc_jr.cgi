#!/usr/bin/perl
###########################################################################
#
#  CGI script to find tree branches associated with a given DLC
#  within a category.
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
#  Written 5/12/2006 Jim Repa
#  Modified 9/26/2006, Jim Repa. Improve auth counts. Allow for reporting
#                                at higher level (e.g., D_DSL)
#
###########################################################################
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
#  Web stem constants
#
 $host = $ENV{'HTTP_HOST'};
 $main_url = "http://$host/webroles.html";
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 $self_url = "/cgi-bin/$progname";
 $url_stem = "/cgi-bin/qualauth.pl?detail=2&levels=20&";
 
#
#  Other constants
#
 $g_delim = "!#";

#
#  Print out the first line of the document
#
  print "Content-type: text/html", "\n\n";

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
 #$input_string = $ARGV[0];
 %formval = ();  # Hash of reformatted key->variables populated by &parse_forms
 %rawval = ();  # Hash of unformatted key->variables populated by &parse_forms
 &parse_forms($input_string, \%formval, \%rawval); # Call sub. to parse input

#
#  Check certificate
#
($info,$k_principal, $domain)  = &parse_authentication_info();  # Parse certificate into a Perl "hash"

  $full_name = $k_principal;
  $result = &check_auth_source($info); # Check other certificate fields
  if ($result ne 'OK') {
      print "<br><b>Your authentication cannot be accepted: $result";
      exit();
  }
 $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase


#
#  Get set to use Oracle.
#
#use Oraperl;  # Point to library of Oracle-related subroutines for Perl
#if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}
use DBI;

#
#  Get form variables
#
$category = $formval{'category'};  # Get value set in &parse_forms()
$category =~ tr/a-z/A-Z/;  # Raise to upper case
$category =~ s/\W.*//;  # Keep only the first word.
$dept_code = $formval{'dept_code'}; # Get value set in &parse_forms()
$dept_code =~ tr/a-z/A-Z/;  # Raise to upper case
my $x = ''; $x =~ /(.*)/;   # Make sure there is nothing in $1
$dept_code =~ /([^ ]*) (.*)/;
$dept_code = $1;  # Keep only the first word.
#$dept_code =~ s/\W.*//;  # Old: Keep only the first word. Breaks on D_IS&T.
$action = $formval{'action'};  # Get value set in &parse_forms()

#
#  Make sure we are set up to use Oraperl.
#

#
# Login into the database
# 
$lda = login_dbi_sql('roles') 
      || die ($DBI::errstr . "\n");

#
#  Print out the http document.  
#
 print "<HTML>", "\n";
 print "<HEAD><TITLE>Links to authorization reports</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 $title = ($action eq 'first_page') 
   ? "Choose a category and DLC"
   : "Links to authorization reports in category $category"
               . " under DLC $dept_code";
 &print_header($title , 
               'https');
 print "<HR>", "\n";

#
#  Call subroutine to print out the table
#
 if ($action eq "first_page") {
   &category_and_dlc_list($lda);
 }
 else {
   #print "dept_code='$dept_code'<BR>";
   &tree_branch_list($lda, $category, $dept_code);
 }

 #
 #  Print end of document, and drop connection to Oracle.
 #
 print "<HR>", "\n";
 print "<A HREF=\"$main_url\">"
  . "<small>Back to main perMIT web interface page</small></A>";
 print "</BODY></HTML>", "\n";
$lda->disconnect();

 exit(0);

###########################################################################
#
#  Subroutine tree_branch_list.
#
###########################################################################
sub tree_branch_list {
  my ($lda, $category, $dept_code) = @_;

  #
  #  Get a list of functions per qualifier_type.
  #
  my %qt2func_list = ();
  &get_function_by_qualtype($lda, $category, \%qt2func_list);

  #
  #  Open a cursor for a select statement
  #
  my $stmt = 
  "select distinct f.function_category, f.qualifier_type, 
                  qt.qualifier_type_desc,
                  q3.qualifier_code, q3.qualifier_name
    from function f, qualifier q1, qualifier_descendent qc, qualifier q2,
         qualifier q3, qualifier_type qt
    where f.qualifier_type <> 'NULL'
    and qt.qualifier_type = f.qualifier_type
    and f.qualifier_type <> 'DEPT'
    and f.function_category = '$category'
    and exists (select 1 from authorization a
                where a.function_id = f.function_id)
    and q1.qualifier_type = 'DEPT'
    and q1.qualifier_code = '$dept_code'
    and qc.parent_id = q1.qualifier_id
    and q2.qualifier_id = qc.child_id
    and q3.qualifier_type = f.qualifier_type
    and q3.qualifier_code = q2.qualifier_code
   union select distinct f.function_category, f.qualifier_type, 
                  qt.qualifier_type_desc,
                  q1.qualifier_code, q1.qualifier_name
    from function f, qualifier q1, qualifier_type qt
    where f.qualifier_type = 'DEPT'
    and qt.qualifier_type = f.qualifier_type
    and f.function_category = '$category'
    and exists (select 1 from authorization a
                where a.function_id = f.function_id)
    and q1.qualifier_type = 'DEPT'
    and q1.qualifier_code = '$dept_code'
    order by 1, 2, 3";
  #print "'$stmt'<BR>";
  my $csr = $lda->prepare("$stmt") or die( $DBI::errstr . "\n");
  $csr->execute();

  #
  # Start the table
  # 
   print "<table border>", "\n";
   print "<tr align=left><th>See authorizations</th>"
         . "<th>Qualifier<br>Code</th>"
         . "<th>Qualifier<br>Name</th>"
         . "<th>Function<br>Names</th>"
         . "<th>Number of<br>authorizations</th></tr>";
  
  #
  #  Get a list of qualifier_types and qualifier_codes
  #
  my @qualifier_type = ();
  my @qualifier_type_desc = ();
  my @qualifier_code = ();
  my @qualifier_name = ();
  
  while (my @row  =  $csr->fetchrow_array())
  {
    my ($qcategory, $qqtype, $qqcode, $qqname)= @row;
    push(@qualifier_type, $qqtype);
    push(@qualifier_type_desc, $qtype_desc);
    push(@qualifier_code, $qqcode);
    push(@qualifier_name, $qqname);
  }
  $csr->finish();
  
  #
  #  Print a list of Qualifier Types and Qualifiers related to the
  #  given Dept_code
  #
   my $n = @qualifier_type;
   my $prev_qualtype = '';
   for ($i=0; $i < $n; $i++) {
      my $temp_qual_code = $qualifier_code[$i];
      $temp_qual_code =~ s/&/\%26/g;  # Fix problem with ampersand
      #print "temp_qual_code = '$temp_qual_code'<br>";
      my $tree_url = $url_stem . "category=$category"
                               . "&qualtype=$qualifier_type[$i]"
                               . "&rootcode=$temp_qual_code";
      my $tree_link = "<a href=\"$tree_url\" target=\"new\">Go</a>";
      ##my $pc_code_string 
      ##     = "<a href=\"$pc_url\" target=\"new\">$pc[$i]</a>";
      ##my $sup_url = $url_stem . $sup_code[$i];
      ##my $sup_code_string 
      ##     = "<a href=\"$sup_url\" target=\"new\">$sup_code[$i]</a>";
      if ($prev_qualtype ne $qualifier_type[$i]) {
         print "<tr><td colspan=5 bgcolor=\"#E0E0E0\">"
               . "$qualifier_type[$i] hierarchy "
               . " ($qualifier_type_desc[$i])</td></tr>\n";
         $prev_qualtype = $qualifier_type[$i];
      }
      my $func_list = $qt2func_list{$qualifier_type[$i]};
      my $count_list = "";
      my $func_list2 = "";
      my $total_auth_count = 0;
      foreach $func_name (split($g_delim, $func_list)) {
        my $temp_count = 
          &get_auth_count_by_qual_func($lda, $qualifier_code[$i], $func_name);
        unless ($temp_count > 0) {$temp_count = 0;}
        $total_auth_count += $temp_count;
        if ($func_list2) {
           $func_list2 .= "<BR>$func_name";
           $count_list .= "<BR>$temp_count";
        }
        else {
           $func_list2 = $func_name;
           $count_list = $temp_count;
        }
      }
      #$func_list =~ s/$g_delim/<br>/g;
      unless ($total_auth_count > 0) {$tree_link = "(no auths.)";}
      print "<tr align=left>"
          . "<td align=center>$tree_link</td>"
          . "<td>$qualifier_code[$i]</td>"
          . "<td>$qualifier_name[$i]</td>"
          . "<td nowrap>$func_list2</td>"
          . "<td align=center>$count_list</td>"
          . "</tr>\n";
   }
   $csr->finish();

 print "</TABLE>", "\n";

}

###########################################################################
#
#  Subroutine category_and_dlc_list
#
###########################################################################
sub category_and_dlc_list {
  my ($lda) = @_;

  #
  #  Print a header
  #
  print "This web page will help you to find authorizations related
         to resources in your DLC.<br>
         <ol>
           <li>Select a category (or area in which authorizations have been 
               granted)
           <li>Select a DLC (DLCs are sorted by the short code)
           <li>Click the \"Go\" button
         </ol>
         <p />";

  #
  #  Get a list of DLC codes and names
  #
  my @dlc_list;
  my @cat_list = ('PAYR (Payroll)', 'HR (Human Resources)', 
                  'SAP (SAP financial)',
                  'EHS (Environment, Health and Safety)',
                  'ADMN (Miscellaneous administrative)',
                  'META (Authorizations about authorizations)',
                  );
  &get_dlc_list($lda, \@dlc_list);

  #
  #  Print the form
  #
  print "<FORM METHOD=\"GET\" "
        . " ACTION=\"$self_url\">";

  print "<form>\n";
  print "<table>\n";
  print "<td>Category</td><td><select name=category>";
  foreach $item (@cat_list) {
    print "<option>$item\n";
  };
  print "</select></td></tr>";
  print "<td>DLC</td><td><select name=dept_code>";
  foreach $item (@dlc_list) {
    print "<option>$item\n";
  };
  print "</select>";
  print "</table>";
  print "<INPUT TYPE=\"SUBMIT\" VALUE=\"Go\">\n";
  print "</form>";

}

###########################################################################
#
#  Subroutine get_function_by_qualtype($lda, $category, \%qt2func_list);
#
###########################################################################
sub get_function_by_qualtype {
  my ($lda, $category, $rqt2func_list) = @_;

  #
  #  Open a cursor for a select statement
  #
  my $stmt = 
  "select distinct f.qualifier_type, f.function_name
    from function f
    where f.qualifier_type <> 'NULL'
    and f.function_category = '$category'
    and exists (select 1 from authorization a
                where a.function_id = f.function_id)
    order by 1, 2";
  #print "'$stmt'<BR>";
  my $csr = $lda->prepare("$stmt") or die( $DBI::errstr . "\n");
  $csr->execute();

  #
  #  Get a list of function_names by category
  #
  while ( ($fqualtype, $fname) = $csr->fetchrow_array() )
  {
    if ($$rqt2func_list{$fqualtype}) {
      $$rqt2func_list{$fqualtype} .= "$g_delim$fname";
    }
    else {
      $$rqt2func_list{$fqualtype} = $fname;
    }
  }
  $csr->finish();
}

###########################################################################
#
#  Subroutine get_dlc_list($lda, \@dlc_list);
#
###########################################################################
sub get_dlc_list {
  my ($lda, $rdlc_list) = @_;

  #
  #  Open a cursor for a select statement
  #
  my $stmt = 
  "select qualifier_code, qualifier_name
    from qualifier
    where qualifier_type = 'DEPT'
    and substr(qualifier_code, 1, 2) = 'D_'
    and exists (select 1 from primary_auth_descendent
                where parent_id = qualifier_id
                --and is_dlc = 'Y'
                )
    order by 1, 2";
  my $csr = $lda->prepare("$stmt") or die( $DBI::errstr . "\n"); 

  #
  #  Get a list of function_names by category
  #
  while ( ($d_code, $d_name) = $csr->fetchrow_array())
  {
    #$d_code =~ s/\&/\%26/g;
    push (@$rdlc_list, "$d_code $d_name");    
  }
  $csr->finish();
  
}

###########################################################################
#
#  Function get_auth_count_by_qual_func($lda, $qualcode, $func_name);
#
#  Given a function_name, and qualifier_code, returns the number of
#  authorizations for the same function and qualifier_code or child
#  qualifier_codes.
#
###########################################################################
sub get_auth_count_by_qual_func {
  my ($lda, $qualcode, $func_name) = @_;

  #
  #  Open a (global) cursor for a select statement
  #
  unless ($gcsr1) {
    my $stmt = 
    "select count(distinct a.authorization_id)
      from authorization a
      where a.function_name = ?
      and a.qualifier_id in 
      (select q.qualifier_id from qualifier q where qualifier_code = ?
       union select qd.child_id
             from qualifier q1, qualifier_descendent qd
             where q1.qualifier_code = ?
             and qd.parent_id = q1.qualifier_id)";
    #print "'$stmt'<BR>";
    unless ($gcsr1 = $lda->prepare($stmt))
    {
       print "Error preparing statement 1.<BR>";
       die;
     }
    }

  #
  #  Bind variables and get the authorizations couunt
  #
   $gcsr1->bind_param(1, $func_name);  
   $gcsr1->bind_param(2, $qualcode);  
   $gcsr1->bind_param(3, $qualcode);  
   $gcsr1->execute;
   my $count = $gcsr1->fetchrow_array;
   return $count;
}


