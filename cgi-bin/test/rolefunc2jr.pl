#!/usr/bin/perl
###########################################################################
#
#  CGI script to list Roles DB functions.
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
#  Written 5/30/2000 to replace old scripts rolecat.pl and rolefunc.pl.
#  Modified 2/3/2004 to handle HR PRIMARY AUTHORIZERs as well as financial
#                     PRMIARY AUTHORIZERS.
#  Modified 8/12/2004 display implied functions
#
###########################################################################
#
# Get packages
#
use rolesweb('login_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm

#
#  Web stem constants
#
 $host = $ENV{'HTTP_HOST'};
 $main_url = "http://$host/webroles.html";

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
#  Get set to use Oracle.
#
use Oraperl;  # Point to library of Oracle-related subroutines for Perl
if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}

#
#  Get form variables
#
$category = $formval{'category'};  # Get value set in &parse_forms()
$cat = $category;
$cat =~ s/\W.*//;  # Keep only the first word.
$cat =~ tr/a-z/A-Z/;  # Raise to upper case
$category =~ s/\w*\s//;  # Throw out first word.
$category =~ tr/A-Z/a-z/;  # Change to lower case 

#
#  Make sure we are set up to use Oraperl.
#
use Oraperl;
if (!(defined(&ora_login))) {die "Use oraperl, not perl\n";}

#
# Login into the database
# 
$lda = &login_sql('newroles') 
      || die $ora_errstr;

#
#  Get a list of Primary Auth groups
#
 my @pa_group = ();
 my %pa_group2web_desc = ();
 &get_pa_groups($lda, \@pa_group, \%pa_group2web_desc);

#
#  Get a list of functions, and a hash of function_ids and their 
#   parent function_ids.
#
 &get_functions($lda, $cat);

#
# Get PA group titles by calling 
#  &get_pa_group_columns(\@pa_group, \%pa_group2web_desc, 'TITLE');
#
 my $last_columns = 
   &get_pa_group_columns(\@pa_group, \%pa_group2web_desc, 'TITLE', '', '');

#
#  Print out the http document.  
#
 print "<HTML>", "\n";
 print "<HEAD><TITLE>Roles DB List of Functions</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 &print_header("Roles DB List of Functions", 'http');
 print "<HR>", "\n";
 print "<H2>Functions within category $cat ($category) </H2>\n\n";
 $n = @fid;  # How many functions?
 print "<table border>", "\n";
 print "<tr align=left><th>Func. ID</th><th>Function Name</th>"
       . "<th>Qualifier Type</th><th>Child<br>Func.<br>IDs <sup>1</sup></th>"
       . "<th>Parent<br>Func.<br>IDs <sup>2</sup></th>"
       . "$last_columns</tr>";
 for ($i = 0; $i < $n; $i++) {
    my $last_columns = 
      &get_pa_group_columns(\@pa_group, \%pa_group2web_desc, 'LINE', 
                            $fpauthable[$i], $fpagroup[$i]);
    my $child_id_list = $fid2child_id{$fid[$i]};
    my $parent_id_list = $fid2parent_id{$fid[$i]};
    #print "child fid = $fid[$i]  parent_id_list = $parent_id_list<BR>";
    if ($child_id_list) {
        $child_id_list =~ s/\!/<BR>/g;
    }
    else {
	$child_id_list = "&nbsp;";
    }
    if ($parent_id_list) {
        $parent_id_list =~ s/\!/<BR>/g;
    }
    else {
	$parent_id_list = "&nbsp;";
    }
    printf "<tr align=left><td>$fid[$i]</td>"
        . "<td>$fname[$i]<br><small>$fdesc[$i]</small></td>"
        . "<td>$fqualtype[$i]<br><small>$fqtdesc[$i]</small></td>"
        . "<td>$child_id_list</td><td>$parent_id_list</td>"
	. "$last_columns</tr>\n";
    #printf "<tr><td> </td></tr>\n",
 }
 print "</TABLE>", "\n";

 #
 #  Print the first 2 footnotes.
 #
 print "<blockquote><small>";
 print "<b>1</b>."
       . " This column lists <i>child</i> function IDs for the given"
       . " function.  If you have an authorization for a given"
       . " function <i>F</i>"
       . " with qualifier <i>Q</i>,"
       . " then you have an <i>implied</i> authorization"
       . " for all of function <i>F</i>'s child functions with "
       . " qualifier <i>Q</i>.<br>";
 print "<b>2</b>."
       . " This column lists <i>parent</i> function IDs for the given"
       . " function.  If you have an authorization for a given"
       . " function <i>F1</i> with qualifier <i>Q</i>, and if"
       . " function <i>F1</i>"
       . " is a parent of function <i>F2</i>,"
       . " then you have an <i>implied</i> authorization"
       . " for function <i>F2</i> with qualifier <i>Q</i>.<br>";

 #
 #  Get info about which functions allow you to grant various types of
 #  primary-authorizable functions.  Display notes about these.
 #
 my %pa_group2function = ();
 &get_pa_granting_function($lda, \%pa_group2function);
 my $counter = 2;
 my $temp_pa_group;
 foreach $temp_pa_group (@pa_group) {
   $counter++;
   my $temp_function = $pa_group2function{$temp_pa_group};
   print "<b>$counter</b>."
         . " This column indicates which functions can be granted"
         . " by people who have one or more $temp_function"
         . " authorizations<br>";
 }
 print "</small></blockquote>";
 
 #
 #  Print end of document, and drop connection to Oracle.
 #
 print "<HR>", "\n";
 print "<A HREF=\"$main_url\">"
  . "<small>Back to main Roles web interface page</small></A>";
 print "</BODY></HTML>", "\n";
 &ora_logoff($lda) || die "can't log off Oracle";

 exit(0);

###########################################################################
#
#  Subroutine get_functions.
#
###########################################################################
sub get_functions {
  my ($lda, $picked_cat) = @_;

  #
  #  Open a cursor for a 1st select statement
  #
  my $stmt = "select function_id, function_name, function_description,"
           . " f.qualifier_type, modified_by, modified_date,"
           . " qt.qualifier_type_desc,"
           . " f.primary_auth_group, "
           . " decode(nvl(f.primary_authorizable,'N'),"
           . "        'Y', 'Yes', 'D', 'DLC-based', 'N', 'no', 'no')"
           . " from function f, qualifier_type qt"  
           . " where function_category = '$picked_cat'"
           . " and qt.qualifier_type = f.qualifier_type"
           . " order by function_name";
  #print "'$stmt'<BR>";
  my $csr = &ora_open($lda, "$stmt")
	|| die $ora_errstr;
  
  #
  #  Get a list of functions
  #
  @fid = ();
  @fname = ();
  @fdesc = ();
  @fqualtype = ();
  @fmodby = ();
  @fmoddate = ();
  @fpagroup = ();
  @fpauthable = ();
  my ($ffid, $ffname, $ffdesc, $ffqualtype, $ffmodby, $ffmoddate, 
      $ffqtdesc, $ffpagroup, $ffpauthable);
  while (($ffid, $ffname, $ffdesc, $ffqualtype, $ffmodby, $ffmoddate, 
          $ffqtdesc, $ffpagroup, $ffpauthable) = &ora_fetch($csr))
  {
        push(@fid, $ffid);
        push(@fname, $ffname);
        push(@fdesc, $ffdesc);
        push(@fqualtype, $ffqualtype);
        push(@fmodby, $ffmodby);
        push(@fmoddate, $ffmoddate);
        push(@fqtdesc, $ffqtdesc);
        push(@fpagroup, $ffpagroup);
        push(@fpauthable, $ffpauthable);
        #print "$ffid, $ffname, $ffpauthable<BR>\n";
  }
  &ora_close($csr) || die "can't close cursor";

  #
  #  Open a cursor for a 2nd select statement, to get 
  #  parent/child function_id pairs
  #
  my $stmt2 = "select fc.parent_id, fc.child_id"
            . " from function f1, function_child fc, function f2"
            . " where fc.child_id = f1.function_id"
            . " and f2.function_id = fc.parent_id"
            . " and (f1.function_category = '$picked_cat'"
            . " or f2.function_category = '$picked_cat')"
            . " order by 1, 2";
  #print "'$stmt2'<BR>";
  my $csr2 = &ora_open($lda, "$stmt2")
	|| die $ora_errstr;
  
  #
  #  Get a list of parent/child pairs for functions
  #
  %fid2parent_id = ();
  %fid2child_id = ();
  my ($ffparent_id, $ffchild_id);
  while ( ($ffparent_id, $ffchild_id) = &ora_fetch($csr2))
  {
      #print "parent_id = '$ffparent_id' child_id = '$ffchild_id'<BR>";
      if ($fid2parent_id{$ffchild_id}) {
	  $fid2parent_id{$ffchild_id} .= "!$ffparent_id";
      }
      else {
	  $fid2parent_id{$ffchild_id} = $ffparent_id;
      }
      if ($fid2child_id{$ffparent_id}) {
	  $fid2child_id{$ffparent_id} .= "!$ffchild_id";
      }
      else {
	  $fid2child_id{$ffparent_id} = $ffchild_id;
      }
  }
  #print "test... parents of 1681: " . $fid2parent_id{'1681'} . "<BR>";
  &ora_close($csr2) || die "can't close cursor";

}


###########################################################################
#
#  Subroutine get_pa_groups($lda, \@pa_group, \%pa_group2web_desc);
#
###########################################################################
sub get_pa_groups {
  my ($lda, $rpa_group, $rpa_group2web_desc) = @_;

  #
  #  Open cursor to select statement
  #
  my $stmt = "select primary_auth_group, web_description"
           . " from pa_group pag"
           . " order by sort_order";
  #print "'$stmt'<BR>";
  my $csr = &ora_open($lda, $stmt)
	|| die $ora_errstr;
  
  #
  #  Get a list of pa_groups
  #
  @$rpa_group = ();
  my ($pa_group, $pag_desc);
  while ( ($pa_group, $pag_desc) = &ora_fetch($csr) ) {
        push(@$rpa_group, $pa_group);
        $$rpa_group2web_desc{$pa_group} = $pag_desc;
  }
  &ora_close($csr) || die "can't close cursor";

}

###########################################################################
#
#  Subroutine get_pa_granting_function($lda, \%pa_group2function);
#
###########################################################################
sub get_pa_granting_function {
  my ($lda, $rpa_group2function) = @_;

  #
  #  Open cursor to select statement
  #
  my $stmt = "select f.primary_auth_group, f.function_name"
           . " from function f"
           . " where is_primary_auth_parent = 'Y'"
           . " order by primary_auth_group, function_name";
  #print "'$stmt'<BR>";
  my $csr = &ora_open($lda, $stmt)
	|| die $ora_errstr;
  
  #
  #  Get a list of pa_groups
  #
  my ($pa_group, $function_name);
  while ( ($pa_group, $function_name) = &ora_fetch($csr) ) {
      $function_name =~ s/ /&nbsp;/g;
      if ($$rpa_group2function{$pa_group}) {
        $$rpa_group2function{$pa_group} .= " <i>or</i> $function_name";
      }
      else {
        $$rpa_group2function{$pa_group} = $function_name;
      }
  }
  &ora_close($csr) || die "can't close cursor";

}

###########################################################################
#
#  Subroutine get_pa_group_columns(\@pa_group, \%pa_group2web_desc,
#                                  $title_or_line, 
#                                  $primary_authorizable, $function_pa_group);
#
###########################################################################
sub get_pa_group_columns {
  my ($rpa_group, $rpa_group2web_desc, $title_or_line, 
      $primary_authorizable, $function_pa_group) = @_;

  #print "primary_authorizable='$primary_authorizable'<BR>";  
  my $out_string = '';
  my $temp_pa_group;
  my $counter = 2;
  if ($title_or_line eq 'TITLE') {
    foreach $temp_pa_group (@$rpa_group) {
      $counter++;
      $out_string .= "<th>" . $$rpa_group2web_desc{$temp_pa_group}
                            . "<sup>$counter</sup></th>";
    }
    return $out_string;
  }
  else {
    foreach $temp_pa_group (@$rpa_group) {
      if ($function_pa_group eq $temp_pa_group) {
        $out_string .= "<td align=center>$primary_authorizable</td>";
      }
      else {
        $out_string .= "<td align=center>no</td>";
      }
    }
    return $out_string;
  }

}
