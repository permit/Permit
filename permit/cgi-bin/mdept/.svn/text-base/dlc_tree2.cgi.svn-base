#!/usr/bin/perl
###########################################################################
#
#  CGI script to print a tree of DLCs
#
#
#  Copyright (C) 2003-2010 Massachusetts Institute of Technology
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
#  Written 12/18/2003
#
###########################################################################
#
# Get packages
#
use rolesweb('login_dbi_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm

#
#  Constants
#
 $g_owner = 'mdept$owner';

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
use DBI;

#
#  Get form variables
#
$g_view_type = $formval{'view_type'};  # Get value set in &parse_forms()
$g_view_type =~ s/\W.*//;  # Keep only the first word.

#
# Login into the database
# 
$lda = &login_dbi_sql('mdept') 
      || die $DBI::errstr . "<BR>";

#
#  Print out the http document header
#
 print "<HTML>", "\n";
 print "<HEAD>"
  . "<TITLE>Master Department Hierarchy - Tree of DLCs</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 &print_header("Tree of DLCs", 'http');

#
# Get information about the view_type
#
 my $view_type_code = ($g_view_type) ? $g_view_type : 'A';
 my ($view_type_desc, $root_id) = &get_view_info($lda, $view_type_code);
 print "&nbsp; &nbsp; View type $view_type_code: $view_type_desc";
 print "<HR>", "\n";

#
# Open a cursor for getting details about a DLC or node in the hierarchy
#
 $gcsr1 = &open_cursor1($lda);
 #&print_dlc_test($lda, $gcsr1, 10791);

#
# Open a cursor for getting children of a node in the hierarchy
#
 $gcsr2 = &open_cursor2($lda);
 #&print_child_test($lda, $gcsr2, 10000, 'A');

#
# Print tree, using a fixed font.
#
 #my $root_id = 10000;
 #my $root_id = 1;
 my $level = 0;
 my $prefix_string = '';
 my $is_last_sibling = 1;
 print "<tt>\n";
 &print_tree($lda, $gcsr1, $gcsr2, $root_id, $level, $view_type_code, 
             $prefix_string, $is_last_sibling);
 print "</tt>\n";

#
# For testing purposes only, call subroutine to print departments
# as a flat list.
#
 print "<P />&nbsp;<P />";
# &print_departments($lda);

#
# Disconnect from the database and print end of document
#
 $lda->disconnect;
 print "<HR>", "\n";
 print "</BODY></HTML>", "\n";
 exit(0);

###########################################################################
#
#  Function open_cursor1
#
#  Opens a cursor to a select statement to return details about a 
#  node or DLC in the hierarchy.
#
###########################################################################
sub open_cursor1 {
  my ($lda) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = "select d.dept_id, d.d_code, d.long_name"
           . " from $g_owner.department d"  
           . " where dept_id = ?"
           . " order by d_code";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }

  return $csr1;
}

###########################################################################
#
#  Function open_cursor2
#
#  Opens a cursor to a select statement to return a list of child nodes
#  under a given node
#
###########################################################################
sub open_cursor2 {
  my ($lda) = @_;

  #
  #  Open connection to oracle
  #
   my $stmt = 
      "select dc.child_id
       from $g_owner.department_child dc, $g_owner.view_type_to_subtype s, 
       $g_owner.department d
       where dc.parent_id = ?
       and s.view_subtype_id = dc.view_subtype_id
       and s.view_type_code = ?
       and d.dept_id = dc.child_id
       order by d.d_code";
   my $csr2;
   unless ($csr2 = $lda->prepare($stmt)) {
       print "Error preparing select statement: " . $DBI::errstr . "<BR>";
   }

   return $csr2;
}

###########################################################################
#
#  Subroutine print_departments
#
#  For testing purposes, prints a flat list of departments
#
###########################################################################
sub print_departments {
  my ($lda) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = "select d.dept_id, d.d_code, d.long_name"
           . " from $g_owner.department d"  
           . " order by d_code";
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  
  #
  #  Get a list of departments
  #
  my @did = ();
  @dcode = ();
  @dname = ();
  my ($ddid, $ddcode, $ddname);
  while ( ($ddid, $ddcode, $ddname) = $csr->fetchrow_array)
  {
        push(@did, $ddid);
        push(@dcode, $ddcode);
        push(@dname, $ddname);
  }

#
#  Print list of departments
#
 my $n = @did;  # How many functions?
 print "<TABLE>", "\n";
 print "<tr><th>DLC ID</th><th>DLC Code</th><th>Name</th></tr>";
 for ($i = 0; $i < $n; $i++) {
    print "<tr><td>$did[$i]</td><td>$dcode[$i]</td><td>$dname[$i]</td></tr>";
 }
 print "</TABLE>", "\n";

}

###########################################################################
#
#  Subroutine get_view_info($lda, $view_type_code);
#
#  Looks up the view_type_code and returns (<description>, <root_id>)
#
###########################################################################
sub get_view_info {
  my ($lda, $view_type_code) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = "select view_type_desc, root_dept_id"
           . " from $g_owner.view_type"  
           . " where view_type_code = '$view_type_code'";
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  
  #
  #  Get info about a DLC
  #
  my ($view_desc, $root_id);
  ($view_desc, $root_id) = $csr->fetchrow_array;

  #
  #  Print info
  #
  return ($view_desc, $root_id);

}

###########################################################################
#
#  Subroutine print_dlc_test
#
###########################################################################
sub print_dlc_test {
  my ($lda, $csr1, $dept_id) = @_;

  unless ($csr1->bind_param(1, $dept_id)) {
      print "Error binding param: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement: " . $DBI::errstr . "<BR>";
  }
  
  #
  #  Get info about a DLC
  #
  my ($ddid, $ddcode, $ddname);
  ($ddid, $ddcode, $ddname) = $csr1->fetchrow_array;

  #
  #  Print info
  #
   print "<a href=\"update_dlc.cgi?ddid=$ddid\"><b>$ddcode</b></a> $ddname ($ddid)";
   print "<br>";

}

###########################################################################
#
#  Subroutine print_child_test
#
###########################################################################
sub print_child_test {
  my ($lda, $csr2, $dept_id, $view_type_code) = @_;

  unless ($csr2->bind_param(1, $dept_id)) {
      print "Error binding param: " . $DBI::errstr . "<BR>";
  }
  unless ($csr2->bind_param(2, $view_type_code)) {
      print "Error binding param: " . $DBI::errstr . "<BR>";
  }
  unless ($csr2->execute) {
      print "Error executing select statement: " . $DBI::errstr . "<BR>";
  }
  
  #
  #  Get child nodes
  #
  my ($child_id);
  print "Child nodes of $dept_id:<BR>";
  while (($child_id) = $csr2->fetchrow_array) {
    print "&nbsp;&nbsp;$child_id<BR>";
  }

}

###########################################################################
#
#  Subroutine print_tree
#
###########################################################################
sub print_tree {
  my ($lda, $csr1, $csr2, $root_id, $level, $view_type_code, 
      $prefix_string, $is_last_sibling) = @_;

  unless ($csr2->bind_param(1, $root_id)) {
      print "Error binding param: " . $DBI::errstr . "<BR>";
  }
  unless ($csr2->bind_param(2, $view_type_code)) {
      print "Error binding param: " . $DBI::errstr . "<BR>";
  }
  unless ($csr2->execute) {
      print "Error executing select statement: " . $DBI::errstr . "<BR>";
  }
  
  #
  #  Print information about the current node
  #
   my $indent_string = $prefix_string;
   print "$indent_string+--";
   &print_dlc_test($lda, $csr1, $root_id);

  #
  #  Get child nodes
  #
  my ($child_id);
  my @child_list = ();
  while (($child_id) = $csr2->fetchrow_array) {
    push(@child_list, $child_id);
  }

  #
  #  Print child nodes
  #
  my $levelplus1 = $level + 1;
  my $n = @child_list;
  my $i = 0;
  my $new_last_sibling = 0;
  my $new_prefix_string;
  foreach $child_id (@child_list) {
    if (++$i == $n) {$new_last_sibling = 1;}
    if ($is_last_sibling) {
      $new_prefix_string = $prefix_string . "&nbsp;&nbsp;&nbsp;";
    }
    else {
      $new_prefix_string = $prefix_string . "|&nbsp;&nbsp;";
    }
    &print_tree($lda, $csr1, $csr2, $child_id, $levelplus1, 'A',
                $new_prefix_string, $new_last_sibling);
  }

}
