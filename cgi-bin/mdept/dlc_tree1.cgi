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
#  Modified 2/10/2004
#  Modified 2/23/2005 (Add another summary table)
#  Modified 9/23/2005 (Fix some bugs)
#  Modified 1/4/2006  (Change links display for unusual objects)
#  Modified 2/15/2006 (Allow a tree-only display)
#  Modified 11/14/2006 (Fix a minor formatting problem)
#  Modified 1/26/2007 (Get object types and qualifier types from DB table)
#
###########################################################################
#
# Get packages
#
use rolesweb('login_dbi_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
use mdeptweb('print_mdept_header'); #Use sub. print_mdept_header in mdeptweb.pm

#
#  Constants
#
 $g_owner = 'MDEPT$OWNER';

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
$g_view_type =~ s/\.//;    # Remove '.'
#$g_show_link_name = $formval{'show_link_name'};
#$g_show_link_name =~ tr/a-z/A-Z/;
$g_format_option = $formval{'format_option'};
$g_format_option =~ tr/a-z/A-Z/;
$g_include_option = $formval{'include_option'};
$g_include_option =~ tr/a-z/A-Z/;
if ($g_include_option eq 'TREE_ONLY') {
  $g_include_detail = '';
  $g_show_link_name = '';
}
elsif ($g_include_option eq 'TREE_TABLE_AND_OBJ_NAMES') {
  $g_include_detail = 1;
  $g_show_link_name = 'Y';
}
else { # $g_include_option eq 'TREE_AND_TABLE'
  $g_include_detail = 1;
  $g_show_link_name = '';
}

#
# Login into the database
# 
$lda = &login_dbi_sql('mdept') 
      || die $DBI::errstr . "<BR>";

#
#  Print out the http document header
#
 my $doc_title = ($g_format_option eq 'SIMPLE_TABLE') 
             ? 'Table of DLCs and object links'
             : 'Master Department Hierarchy - Tree of DLCs';
 print "<HTML>", "\n";
 print "<HEAD>"
  . "<TITLE>$doc_title</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 &print_mdept_header($doc_title, 'http');
 #print "g_include_option = '$g_include_option'
 #      <br>g_include_detail = '$g_include_detail'
 #      <br>g_show_link_name = '$g_show_link_name'<br>";


#
# Get information about the view_type
#
 my $view_type_code = ($g_view_type) ? $g_view_type : 'A';
 $g_view_type_code = $view_type_code;  # Put this in a global variable, also.
 my ($view_type_desc, $root_id) = &get_view_info($lda, $view_type_code);
 print "&nbsp; &nbsp; View type $view_type_code : $view_type_desc";
 print "<HR>", "\n";

# Add department button 
 if (0 == 1) {  # Don't print this
   print "<form action=\"EditDept.cgi\" method=\"post\">\n";
   print "<input type=\"submit\" name=\"add_dlc\" value=\"Add DLC\"><br>\n";
   print "</form>\n";
 }

#
# Open a cursor for getting details about a DLC or node in the hierarchy
#
 $gcsr1 = &open_cursor1($lda);
 #&print_dlc_detail_in_tree($lda, $gcsr1, 10791);

#
# Open a cursor for getting children of a node in the hierarchy
#
 $gcsr2 = &open_cursor2($lda);
 #&print_child_test($lda, $gcsr2, 10000, 'A');

#
# Set up a global array @g_dept_id to get an ordered list of dept_id numbers.
# Put dlc_id's in this array in the order that they appear in the tree.
# This will be used to display detailed information on each DLC in a table,
# shown on the web document after the tree view.
#
# Also, save the level of indentation in the tree for each DLC_ID.
# Note that we use a 
# parallel array (@g_dept_level) rather than a hash to store the levels,
# since a DLC_ID may appear twice in the same tree at different levels.
#
 @g_dept_id_list = ();
 @g_dept_level = ();

#
# Print tree, using a fixed font, and populate some arrays and hashes.
#
 my $level = 0;
 my $prefix_string = '';
 my $is_last_sibling = 1;
 print "<tt>\n";
 &print_tree($lda, $gcsr1, $gcsr2, $root_id, $level, $view_type_code, 
             $prefix_string, $is_last_sibling);
 print "</tt>\n";
 $gcsr1->finish();
 $gcsr2->finish();

if ($g_include_detail) {
 #
 # Print a legend of DLC types
 #
  print "<P />&nbsp;<P />";
  &print_dlc_type_table($lda); 

 #
 # Print department information in a flat list
 #
  print "<P />&nbsp;<P />";
  if ($g_format_option eq 'SIMPLE_TABLE') {
    &print_simple_table($lda);
  }
  else {
    &print_departments($lda);
  }
}

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
           . " from department d"  
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
       from department_child dc, view_type_to_subtype s, 
       department d
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
#  Subroutine print_dlc_type_table
#
#  Prints a little table of DLC types
#
###########################################################################
sub print_dlc_type_table {
  my ($lda) = @_;

  #
  #  Open cursor
  #
  #my $stmt = "select t.dept_type_id, t.dept_type_desc
  #             from $g_owner.dept_node_type t
  #             order by t.dept_type_id";
  my $stmt = "select t.dept_type_id, t.dept_type_desc, vtdt.view_type_code, 
                  vt.view_type_desc
               from view_to_dept_type vtdt left outer join dept_node_type t ON (vtdt.leaf_dept_type_id = t.dept_type_id)  
               right outer join  view_type vt ON (vt.view_type_code = vtdt.view_type_code)
               order by t.dept_type_id, vtdt.view_type_code";
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  
  #
  #  Get a list of dept_types
  #
  my @type_id = ();
  %type_desc = ();
  %type_views = ();
  my ($ttid, $ttdesc, $ttview_type, $ttview_desc);
  my $last_ttid = '';
  while ( ($ttid, $ttdesc, $ttview_type, $ttview_desc) = $csr->fetchrow_array)
  {
        unless ($last_ttid eq $ttid) {
          push(@type_id, $ttid);
          $type_desc{$ttid} = $ttdesc;
          $last_ttid = $ttid;
        }
        if ($type_views{$ttid} && $ttview_type) {
	    $type_views{$ttid} .= "<br>${ttview_type}. $ttview_desc";
        }
        elsif ($ttview_type) {
	    $type_views{$ttid} = "${ttview_type}. $ttview_desc";
        }
  }

 #
 #  Print list of department types
 #
  print "<blockquote>";
  print "<TABLE border>\n";
  print "<caption align=type>List of DLC types</caption>\n";
  print "<tr><th>Type*</th><th>Description</th>"
        . "<th>Is a DLC in these View Types</th></tr>\n";
  foreach $ttid (@type_id) {
     my $temp_views = $type_views{$ttid};
     unless ($temp_views) {$temp_views = "&nbsp;"}
     print "<tr><td>$ttid</td><td>$type_desc{$ttid}</td>"
           . "<td>$temp_views</td>"
           . "</tr>\n";
  }
  print "</TABLE>", "\n";
  print "</blockquote>";

}

###########################################################################
#
#  Subroutine print_departments
#
#  Prints a table of departments with details on each department and 
#  links to other object types.
#
###########################################################################
sub print_departments {
  my ($lda) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = "select d.dept_id, d.d_code, d.long_name, d.short_name,"
           . " t.dept_type_id"
           . " from department d, dept_node_type t"  
           . " where t.dept_type_id = d.dept_type_id"
           . " order by d_code";
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  
  #
  #  Get a list of departments
  #
  my @did = ();
  %dcode = ();
  %dname = ();
  %dsname = ();
  %dtype = ();
  my ($ddid, $ddcode, $ddname, $ddsname, $ddtype);
  while ( ($ddid, $ddcode, $ddname, $ddsname, $ddtype) = $csr->fetchrow_array)
  {
        push(@did, $ddid);
        $dcode{$ddid} = $ddcode;
        $dname{$ddid} = $ddname;
        $dsname{$ddid} = $ddsname;
        $dtype{$ddid} = $ddtype;
  }
 $csr->finish();

 #
 #  Get a list of object types
 #
  my @object_type = ();
  my %object_type_desc = ();
  &get_object_types($lda, \@object_type, \%object_type_desc);

 #
 #  Get a list of the links of each DLC to other objects
 #
  my $delim1 = '!';
  my %dlc_object_link = ();
  &get_dlc_object_link($lda, $delim1, $g_view_type, \%dlc_object_link);

 #
 #  If the user has requested a display of object names (which slows down
 #  the script, and therefore is an option for the user), then
 #  go build a hash of object_codes and object_names.
 #
  my %object_code2name = ();
  if ($g_show_link_name eq 'Y') {
    &get_object_names($lda, $delim1, \%object_code2name);
  }

 #
 #  Print list of departments
 #
  my $obj_type;
  my $temp_object_link;
  print "<TABLE border width=\"100%\">", "\n";
  print "<caption align=type>Table of DLCs with detailed information"
        . "</caption>\n";
  print "<tr><td width=\"1%\"></td><td width=\"10%\"></td>"
        . "<td width=\"1%\"></td><td width=\"1%\"></td>"
        . "<td width=\"20%\"></td><td></td></tr>\n";
  #print "<tr><td width=\"18%\">18</td><td width=\"10%\">10</td>"
  #      . "<td width=\"7%\">7</td><td width=\"13%\">13</td>"
  #      . "<td width=\"22%\">28</td><td width=\"30%\">30</td></tr>\n";
  print "<tr bgcolor=\"#E0E0E0\">"
        . "<th>DLC Code</th>"
        . "<th>DLC ID</th>"
        . "<th>Type*</th>"
        . "<th colspan=2>Long Name</th>"
        . "<th>Short Name</tr>\n";
  print "<tr><th>&nbsp;</th>"
        . "<th colspan=2>Linked object type</th>"
        . "<th>Object code</th>"
        . "<th colspan=2>Object name</th></tr>\n";
  print "<tr><th colspan=6></th></tr>\n";
  my $i;
  my $ddlevel;
  my $indent_string;
  my $dlc_string;
  my $n = @g_dept_id_list;  # How many departments?
  #$n = 50;
  for ($i=0; $i<$n; $i++) {
     $ddid = $g_dept_id_list[$i];
     $ddlevel = $g_dept_level[$i];
     $indent_string = '-' x $ddlevel;
     $dlc_string = "$indent_string<a name=\"$ddid\">$dcode{$ddid}</a>";
     my $name_list;
     print "<tr bgcolor=\"#E0E0E0\">"
           . "<td><tt>"
           . " $dlc_string</tt></td>"
           . "<td>$ddid</td>"
           . "<td align=center>$dtype{$ddid}</td>"
           . "<td colspan=2>$dname{$ddid}</td><td>$dsname{$ddid}</td>"
           ." </tr>\n";
     foreach $obj_type (@object_type) {
       $temp_object_link = $dlc_object_link{"$ddid$delim1$obj_type"};
       $name_list = '&nbsp;';
       if ( ($temp_object_link) || ($dtype{$ddid} eq '2') ) {
         if ($g_show_link_name eq 'Y' && ($temp_object_link)) {
           #$temp_object_link = 
	   # &add_name_to_code($temp_object_link, $obj_type, 
           #                   $delim1, \%object_code2name);
           $name_list = 
	     &get_name_from_code($temp_object_link, $obj_type, 
                              $delim1, \%object_code2name);
	 }
         my @code_array = split($delim1, $temp_object_link);
         my @name_array = split($delim1, $name_list);
         my $j;
         my $m = @code_array;
         my $rowspan = ($m > 1) ? "rowspan=$m" : "";
         for ($j=0; $j<$m; $j++) {
	    my $name_item = $name_array[$j];
            unless ($name_item) {$name_item = '&nbsp;';}
            if ($j == 0) {
              print "<tr><td $rowspan>&nbsp;</td>"
                 . "<td colspan=2 rowspan=$m>$object_type_desc{$obj_type}</td>"
                 . "<td>$code_array[$j]</td>"
                 . "<td colspan=2>$name_item</td></tr>\n";
           
            }
            else {
              print "<tr><td>$code_array[$j]</td>"
                 . "<td colspan=2>$name_item</td></tr>\n";
           
            }
         }
         if ($m == 0) {
            print "<tr><td $rowspan>&nbsp;</td>"
               . "<td colspan=2 $rowspan>$object_type_desc{$obj_type}</td>"
               . "<td>&nbsp;</td>"
               . "<td colspan=2>&nbsp;</td></tr>\n";
         }
       }
     }
     print "<tr><td colspan=6></td></tr>\n";
  }
  print "</TABLE>", "\n";

}

###########################################################################
#
#  Subroutine print_simple_table
#
#  Print a simple table of departments, suitable for downloading to Excel
#
###########################################################################
sub print_simple_table {
  my ($lda) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = "select d.dept_id, d.d_code, d.long_name, d.short_name,"
           . " t.dept_type_id"
           . " from department d, dept_node_type t"  
           . " where t.dept_type_id = d.dept_type_id"
           . " order by d_code";
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  
  #
  #  Get a list of departments
  #
  my @did = ();
  %dcode = ();
  %dname = ();
  %dsname = ();
  %dtype = ();
  my ($ddid, $ddcode, $ddname, $ddsname, $ddtype);
  while ( ($ddid, $ddcode, $ddname, $ddsname, $ddtype) = $csr->fetchrow_array)
  {
        push(@did, $ddid);
        $dcode{$ddid} = $ddcode;
        $dname{$ddid} = $ddname;
        $dsname{$ddid} = $ddsname;
        $dtype{$ddid} = $ddtype;
  }

  $csr->finish();
 #
 #  Get a list of object types
 #
  my @object_type = ();
  my %object_type_desc = ();
  &get_object_types($lda, \@object_type, \%object_type_desc);

 #
 #  Get a list of the links of each DLC to other objects
 #
  my $delim1 = '!';
  my %dlc_object_link = ();
  &get_dlc_object_link($lda, $delim1, $g_view_type, \%dlc_object_link);

 #
 #  If the user has requested a display of object names (which slows down
 #  the script, and therefore is an option for the user), then
 #  go build a hash of object_codes and object_names.
 #
  my %object_code2name = ();
  if ($g_show_link_name eq 'Y') {
    &get_object_names($lda, $delim1, \%object_code2name);
  }

 #
 # Get a parent node for each DLC
 #
  my %dlc_to_parent;
  &get_dlc_parent($lda, \%dlc_to_parent);

 #
 #  Print table header
 #
  my $temp_object_link;
  my ($obj_type, $obj_type_desc);
  print "<TABLE border width=\"100%\">", "\n";
  print "<caption align=type>Simple Table of DLCs and object links"
        . "<br>type 1 (root) and type 3 (nodes) are not shown"
        . "</caption>\n";
  print "<tr><th width=\"10%\">Parent</th>"
        . "<th width=\"10%\">DLC Code</th><th width=\"5%\">Type*</th>"
        . "<th>Long Name</th>";
  foreach $obj_type (@object_type) {
      print "<th width=\"7%\">" . $object_type_desc{$obj_type} . "</th>";
  }
  print "</tr>";

 #
 #
 #
  print "<tr><td width=\"1%\"></td><td width=\"10%\"></td>"
        . "<td width=\"1%\"></td><td width=\"1%\"></td>"
        . "<td width=\"20%\"></td><td></td></tr>\n";
  #print "<tr bgcolor=\"#E0E0E0\">"
  #      . "<th>DLC Code</th>"
  #      . "<th>DLC ID</th>"
  #      . "<th>Type*</th>"
  #      . "<th colspan=2>Long Name</th>"
  #      . "<th>Short Name</tr>\n";
  #print "<tr><th>&nbsp;</th>"
  #      . "<th colspan=2>Linked object type</th>"
  #      . "<th>Object code</th>"
  #      . "<th colspan=2>Object name</th></tr>\n";
  #print "<tr><th colspan=6></th></tr>\n";
  my $i;
  my $ddlevel;
  my $indent_string;
  my $dlc_string;
  my $ddcode;
  my $n = @g_dept_id_list;  # How many departments?
  #$n = 50;
  for ($i=0; $i<$n; $i++) {
     $ddid = $g_dept_id_list[$i];
     $ddlevel = $g_dept_level[$i];
     $indent_string = '-' x $ddlevel;
     $ddcode = $dcode{$ddid};
     $dlc_string = "$indent_string<a name=\"$ddid\">$dcode{$ddid}</a>";
     my $name_list;
     unless ($dtype{$ddid} eq '1' || $dtype{$ddid} eq '3') {
       my $parent_id = $dlc_to_parent{$ddid};
       my $parent_code = $dcode{$parent_id};
       print "<tr><td>$parent_code</td><td>$ddcode</td><td>$dtype{$ddid}</td>"
           . "<td>$dname{$ddid}</td>";
       foreach $obj_type (@object_type) {
         $temp_object_link = $dlc_object_link{"$ddid$delim1$obj_type"};
         $temp_object_link =~ s/!/, /g;
         print "<td>" . $temp_object_link . "</td>";
       }
       print "</tr>";
     }
    if (1 == 0) {
     print "<tr bgcolor=\"#E0E0E0\">"
           . "<td><tt>"
           . " $dlc_string</tt></td>"
           . "<td>$ddid</td>"
           . "<td align=center>$dtype{$ddid}</td>"
           . "<td colspan=2>$dname{$ddid}</td><td>$dsname{$ddid}</td>"
           ." </tr>\n";
     foreach $obj_type (@object_type) {
       $temp_object_link = $dlc_object_link{"$ddid$delim1$obj_type"};
       $name_list = '&nbsp;';
       if ( ($temp_object_link) || ($dtype{$ddid} eq '2') ) {
         if ($g_show_link_name eq 'Y' && ($temp_object_link)) {
           #$temp_object_link = 
	   # &add_name_to_code($temp_object_link, $obj_type, 
           #                   $delim1, \%object_code2name);
           $name_list = 
	     &get_name_from_code($temp_object_link, $obj_type, 
                              $delim1, \%object_code2name);
	 }
         my @code_array = split($delim1, $temp_object_link);
         my @name_array = split($delim1, $name_list);
         my $j;
         my $m = @code_array;
         my $rowspan = ($m > 1) ? "rowspan=$m" : "";
         for ($j=0; $j<$m; $j++) {
	    my $name_item = $name_array[$j];
            unless ($name_item) {$name_item = '&nbsp;';}
            if ($j == 0) {
              print "<tr><td $rowspan>&nbsp;</td>"
                 . "<td colspan=2 rowspan=$m>$object_type_desc{$obj_type}</td>"
                 . "<td>$code_array[$j]</td>"
                 . "<td colspan=2>$name_item</td></tr>\n";
           
            }
            else {
              print "<tr><td>$code_array[$j]</td>"
                 . "<td colspan=2>$name_item</td></tr>\n";
           
            }
         }
         if ($m == 0) {
            print "<tr><td $rowspan>&nbsp;</td>"
               . "<td colspan=2 $rowspan>$object_type_desc{$obj_type}</td>"
               . "<td>&nbsp;</td>"
               . "<td colspan=2>&nbsp;</td></tr>\n";
         }
       }
     }
     print "<tr><td colspan=6></td></tr>\n";
    }
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
           . " from view_type"  
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

  $csr->finish();
  #
  #  Print info
  #
  return ($view_desc, $root_id);

}

###########################################################################
#
#  Subroutine get_dlc_parent($lda, \%dlc_to_parent);
#
#  For each DLC ID, finds its parent DLC ID.  If there is more than 
#  one parent, it picks only one of them.
#
###########################################################################
sub get_dlc_parent {
  my ($lda, $rdlc_to_parent) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = 
      "select dc.child_id, dc.parent_id
       from department_child dc, view_type_to_subtype s, 
       department d
       where s.view_subtype_id = dc.view_subtype_id
       and s.view_type_code = '$g_view_type_code'
       and d.dept_id = dc.child_id
       order by d.d_code";
  #print $stmt . "<br>";
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  
  #
  #  Get info about a DLC
  #
  my ($child_id, $parent_id);
  while ( ($child_id, $parent_id) = $csr->fetchrow_array) {
      $$rdlc_to_parent{$child_id} = $parent_id;
  }
  $csr->finish;

}

###########################################################################
#
#  Subroutine get_object_types($lda, \@object_type, \%object_type_desc)
#
#  Gets an array of object_types (@object_type) and a hash %object_type_desc
#  where $object_type_desc{$object_type} = <description of this object type>
#
###########################################################################
sub get_object_types {
  my ($lda, $robject_type, $robject_type_desc) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = "select object_type_code, obj_type_desc"
           . " from object_type"  
           . " order by obj_type_desc";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  
  #
  #  Get object types and their descriptions
  #
  my ($object_type, $object_type_desc);
  @$robject_type = ();
  %$robject_type_desc = ();
  while ( ($object_type, $object_type_desc) = $csr->fetchrow_array ) {
    push(@$robject_type, $object_type);
    $$robject_type_desc{$object_type} = $object_type_desc;
  }

  $csr->finish();
}

###########################################################################
#
#  Subroutine get_object_names($lda, $delim, \%object_code2name)
#
#  Gets a hash of object_codes and their names, where 
#     $object_code2name{"$object_type$delim$object_code} = $object_name
#
###########################################################################
sub get_object_names {
  my ($lda, $delim, $robject_code2name) = @_;

  #
  #  Build some SQL fragments from the MDEPT object_type table
  #
  my $object_type_list;
  #   = "'ORGU', 'ORG2', 'BAG', 'FC', 'SPGP', 'LORG', 'SIS', 'PMIT', 'PBM'";
  my $obj_type_qualtype_pairs_list;
  #  = "'ORGU', 'ORGU', 'ORG2', 'ORG2', 'BAG', 'BAGS', "
  #    . "'FC', 'FUND', 'SPGP', 'SPGP', 'LORG', 'LORG', 'SIS', 'SISO',"
  #    . "'PMIT', 'PMIT', 'PBM', 'PBM1'";
  my $object_type2qualtype;
  &get_object_type_info ($lda, \%object_type2qualtype);
  foreach $key (keys %object_type2qualtype) {
      if ($object_type_list) {
	  $object_type_list .= ", '$key'";
          $obj_type_qualtype_pairs_list .= 
              ", '$key', '$object_type2qualtype{$key}'";
      }
      else {
	  $object_type_list = "'$key'";
          $obj_type_qualtype_pairs_list = 
              "'$key', '$object_type2qualtype{$key}'";
      }
  }
  
  my $qual_case = " CASE l.object_type_code ";
  my $i = 0;
  my @arr = split(/\,/,$obj_type_qualtype_pairs_list);
  my $count=@arr;

  my $val1, $val2 ,$when_str;
  foreach (@arr) {
        if ($i % 2 == 0)
	{
		 $val1 = $_;
		 $val2 = "";
		$when_var = " ";	
	}
	else
	{
		 $val2 = $_;
		$when_var = " WHEN $val1 THEN $val2 ";	
		$qual_case = $qual_case . $when_var;
	}
        $i++;
  }
   
  $qual_case = $qual_case .  " END ";

  #
  #  Open connection to oracle
  #
  #
  #  Define and open a cursor to a select statement for object names
  #
  my $stmt = 
   "select l.object_type_code, l.object_code, q.qualifier_name
    from object_link l, rolesbb.qualifier q
    where l.object_type_code 
        in ($object_type_list)
    $sql_frag
    and q.qualifier_code = l.object_code
    and q.qualifier_type = ($qual_case)
    and (l.object_type_code <> 'PMIT' 
         or substr(replace(l.object_code, 'PC', 'P'),1,2)
                   not between 'P000000' and 'P999999')
    union select l.object_type_code, l.object_code, q.qualifier_name
    from object_link l, rolesbb.qualifier q
    where l.object_type_code in ('PC', 'PMIT')
    $sql_frag
    and q.qualifier_code = 
      replace(replace(l.object_code, '0P', '0HP'), 'P', 'PC')
    and q.qualifier_type = (CASE l.object_type_code WHEN  'PC' THEN  'COST' 
                                  WHEN 'PMIT' THEN 'PMIT' END)";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  
  #
  #  Get object codes and their names
  #
  my ($object_type, $object_code, $object_name);
  %$robject_code2name = ();
  while ( ($object_type, $object_code, $object_name) = $csr->fetchrow_array ) {
    $$robject_code2name{"$object_type$delim$object_code"} = $object_name;
  }

  $csr->finish();
}


###########################################################################
#
#  Subroutine get_dlc_object_link($lda, $delim, $view_type_code, 
#                                 \%dlc_object_link);
#
#  Finds object links for each DLC.  
#  Builds hash %dlc_object_link, setting
#    $dlc_object_link{$dlc_id . $delim . $object_type} = 
#         $object1 . $delim . $object2 . $delim ...
#
###########################################################################
sub get_dlc_object_link {
  my ($lda, $delim, $view_type_code, $rdlc_object_link) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = "select dept_id, object_type_code, object_code
              from object_link
              union
              select /*+ ORDERED */ distinct dd.parent_id, 
                     ol.object_type_code, ol.object_code
              from dept_descendent dd, object_link ol
              where dd.parent_id in
              ( select distinct d.dept_id
                from view_type vt, view_to_dept_type vtdt, 
                     department d, dept_descendent dd2, 
                     department_child dc
                where vt.view_type_code = '$view_type_code'
                and vtdt.view_type_code = vt.view_type_code
                and d.dept_type_id = vtdt.leaf_dept_type_id 
                and dd2.view_type_code = vt.view_type_code
                and dd2.parent_id = vt.root_dept_id
                and d.dept_id = dd2.child_id
                and dc.parent_id = d.dept_id  )
              and ol.dept_id = dd.child_id
              order by 1, 2, 3";
  my $csr;
  #print "'$stmt'<BR>";
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  
  #
  #  Get object links
  #
  my ($dept_id, $object_type, $object_code);
  my ($current_key, $prev_key) = '';
  while ( ($dept_id, $object_type, $object_code) = $csr->fetchrow_array ) {
    $current_key = $dept_id . $delim . $object_type;
    if ($current_key eq $prev_key) {
      $$rdlc_object_link{"$dept_id$delim$object_type"} .= "$delim$object_code";
    }
    else {
      $$rdlc_object_link{"$dept_id$delim$object_type"} = $object_code;
    }
    $prev_key = $current_key;
  }

  $csr->finish();
}

###########################################################################
#
#  Subroutine get_object_type_info($lda, \%object_type2qualtype);
#
#  Builds a hash of object_type codes to Roles qualifier types.
#
###########################################################################
sub get_object_type_info {
  my ($lda, $robject_type2qualtype) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = "select object_type_code, roles_qualifier_type
              from object_type
              order by object_type_code";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  
  #
  #  Get object type -> qualifier type pairs
  #
  my ($object_type, $qualtype);
  while ( ($object_type, $qualtype) = $csr->fetchrow_array ) {
      $$robject_type2qualtype{$object_type} = $qualtype;
  }
  $csr->finish;

}

###########################################################################
#
#  Subroutine print_dlc_detail_in_tree
#
###########################################################################
sub print_dlc_detail_in_tree {
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
   #print "<b><a href=\"dlc_tree1.cgi#$ddid\">"
   #      ." $ddcode</a></b> $ddname ($ddid)<BR>\n";
   if ($g_include_detail) {
     print "<b><a href=\"#$ddid\">"
           ."$ddcode</a></b> $ddname ($ddid)<BR>\n";
   }
   else {
     print "<b>$ddcode</b> $ddname ($ddid)<BR>\n";
   }
}

###########################################################################
#
#  Function add_name_to_code($temp_object_link, $object_type, 
#                            $delim, \%object_code2name)
#
#  Splits up object_link string into individual object_codes, 
#  adds names after each object_code,
#  and puts the string back together.
#
###########################################################################
sub add_name_to_code {
  my ($old_object_string, $object_type, $delim, $robject_code2name) = @_;

  my @object_array = split($delim, $old_object_string);
  my $new_object_string = '';
  my ($object_item, $object_name);
  $first_time = 1;
  foreach $object_item (@object_array) {
    $object_name = $$robject_code2name{"$object_type$delim$object_item"};
    unless ($object_name) {
      $object_name = "<font color=red>not found</font>";
    }
    $object_item = "<b>$object_item</b> $object_name";
    if ($first_time) {
      $new_object_item = $object_item;
      $first_time = 0;
    }
    else {
      $new_object_item .= "$delim$object_item";
    }
  }
  return $new_object_item;

}

###########################################################################
#
#  Function get_name_from_code($temp_object_link, $object_type, 
#                              $delim, \%object_code2name)
#
#  Splits up object_link string into individual object_codes, 
#  gets a list of names associated with each object_code,
#  and puts the string back together.
#
###########################################################################
sub get_name_from_code {
  my ($temp_object_string, $object_type, $delim, $robject_code2name) = @_;

  my @object_array = split($delim, $temp_object_string);
  my $name_string = '';
  my ($object_item, $object_name);
  $first_time = 1;
  foreach $object_item (@object_array) {
    $object_name = $$robject_code2name{"$object_type$delim$object_item"};
    unless ($object_name) {
      $object_name = "<font color=red>not found</font>";
    }
    if ($first_time) {
      $name_string = $object_name;
      $first_time = 0;
    }
    else {
      $name_string .= "$delim$object_name";
    }
  }
  return $name_string;

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
#  Print a tree of DLCs.
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
   unless ($g_format_option eq 'SIMPLE_TABLE') {
     print "$indent_string+--";
     &print_dlc_detail_in_tree($lda, $csr1, $root_id);
   }
   push(@g_dept_id_list, $root_id);
   push(@g_dept_level, $level);

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
    &print_tree($lda, $csr1, $csr2, $child_id, $levelplus1, $view_type_code,
                $new_prefix_string, $new_last_sibling);
  }

}
