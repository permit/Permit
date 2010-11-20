#!/usr/bin/perl
###########################################################################
#
#  CGI script to display a hierarchy of qualifiers from the perMIT system,
#    showing the linked D_xxxxx dept code from the Master Dept. Hierarchy
#    for each object
#
#
#  Copyright (C) 2005-2010 Massachusetts Institute of Technology
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
#  Written 10/4/2005
#  Revised 1/09/2006
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
 $g_all_levels = 20;  # How many levels in hierarchy is considered "all"

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
$g_qualtype = $formval{'qualtype'};  # Get value set in &parse_forms()
$g_qualtype =~ s/\W.*//;  # Keep only the first word.
$g_format_option = $formval{'format_option'};
$g_format_option =~ tr/a-z/A-Z/;
$g_maxlevel = $formval{'levels'};  # How many levels to show in tree?
$g_maxlevel =~ tr/a-z/A-Z/;
unless ($g_maxlevel) {$g_maxlevel = 3;}
if ($g_maxlevel eq 'ALL') {$g_maxlevel = $g_all_levels;}
$g_code_position = $formval{'code_position'};
$g_code_position =~ tr/a-z/A-Z/;
$g_root_id = $formval{'root_id'};
$g_start_qualcode = $formval{'qualcode'};
$g_start_qualcode =~ tr/a-z/A-Z/;
$g_path_from_root = $formval{'path_from_root'};
$g_end_qualid = $formval{'end_qualid'};

#
#  Web stem constants
#
 $host = $ENV{'HTTP_HOST'};
 $main_url = "http://$host/webroles.html";
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 $url_stem = "http://$host/cgi-bin/mdept/$progname?";  # URL for subtree view
 $url_stem .= 
   "qualtype=$g_qualtype&levels=$g_maxlevel&code_position=$g_code_position";

#
# Login into the database
# 
$lda = &login_dbi_sql('mdept') 
      || die $DBI::errstr . "<BR>";

#
#  Print out the http document header
#
 my $doc_title = ($g_path_from_root)
        ? "Path(s) from the root to a given qualifier of type $g_qualtype"
        : "Hierarchy of Qualifiers of type $g_qualtype";
 print "<HTML>", "\n";
 print "<HEAD>"
  . "<TITLE>$doc_title</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 &print_header($doc_title, 'http');

#
# Make sure no one is trying to hack with $qualtype variable.
#
 if (length($g_qualtype) > 5) {
   print "Error - qualtype '$g_qualtype' is invalid<BR>";
   die;
 }

#
# If a qualifier_code is given as a root value, but no qualifier_id, then
# go look up the qualifier_id.
#
 if ($g_start_qualcode) {
     my $temp_qualid 
       = &lookup_a_qualcode($lda, $g_qualtype, $g_start_qualcode);
     #print "$g_start_qualcode -> $temp_qualid<BR>\n";
     if ($g_path_from_root) {
       $g_end_qualid = $temp_qualid;
     }
     elsif ($g_root_id) {
       # Do nothing.  Ignore the found root_id.
     }
     else {
       $g_root_id = $temp_qualid;
     }
 }

#
# Build a hash of dept_id's -> dept_code's
#
 %g_dept_id2code = ();
 &get_dept_id2code_hash($lda, \%g_dept_id2code);

#
# Get the maximum length of combined D_codes for objects that are linked
# to more than one D_code.
#
 $g_max_code_length = &get_max_dept_code_length($lda, $g_qualtype);
 #print "Max dept code length = $g_max_code_length<BR>";

#
# Open a cursor to get details about the root first item in the tree
#
 $gcsr1a = &open_cursor1a($lda);

#
# Open a cursor for getting info about any node or leaf in the tree
#
 $gcsr1 = &open_cursor1($lda);

#
# Open a cursor for getting children of a node in the hierarchy
#
 $gcsr2 = &open_cursor2($lda, $g_qualtype);

#
# Get info about the root node
#
 my $qualtype = $g_qualtype;
 my ($qid, $qcode, $qname, $qdept, $qhaschild) = 
    &get_details_about_a_node($gcsr1, $gcsr1a, $g_root_id, $qualtype);
 #print "root_id=$g_root_id qid=$qid qcode=$qcode qdept=$qdept<BR>";

#
# Print tree, using a fixed font, and populate some arrays and hashes.
#
 my $level = 1;
 my $prefix_string = '';
 my $is_last_sibling = 1;
 print "<tt>\n";
 if ($g_root_id && !$g_path_from_root) {
     my $indent_string = '&nbsp;' x ($g_max_code_length+2);
     my $path_to_root_href =
        "<a href=\"${url_stem}\&path_from_root=1\&end_qualid=$g_root_id\">";

     print "$indent_string${path_to_root_href}..</a><BR>";
 }
 &print_qual_tree($lda, $gcsr1, $gcsr2, 
             $qid, $qcode, $qname, $qdept, $qhaschild,
             $level, $qualtype, 
             $prefix_string, $is_last_sibling);
 print "</tt>\n";

#
# Disconnect from the database and print end of document
#
 $lda->disconnect;
 print "<HR>", "\n";
 print "</BODY></HTML>", "\n";
 exit(0);

###########################################################################
#
#  Subroutine print_qual_tree
#
###########################################################################
sub print_qual_tree {
  my ($lda, $csr1, $csr2, 
      $root_id, $root_code, $root_name, $root_dept, $root_hc,
      $level, $qualtype, 
      $prefix_string, $is_last_sibling) = @_;

  unless ($csr2->bind_param(1, $root_id)) {
      print "Error binding param: " . $DBI::errstr . "<BR>";
      exit();
  }
  unless ($csr2->execute) {
      print "Error executing select statement 2: " . $DBI::errstr . "<BR>";
      exit();
  }
  
  #
  #  Print information about the current node
  #
   my $indent_string = $prefix_string;
   #print "$indent_string+--";
   ## Kluge to prevent ".." display if this is the root node:
   ## do not specify the root in the URL if this is the root level
   ## of a path_from_root display.
   my $override_root = ($g_path_from_root && $level == 1) ? 1 : 0;
   &print_qual_detail("$indent_string+--",
     $root_id, $root_code, $root_name, $root_dept, $root_hc, $override_root);

  #
  #  If this node does not have any child nodes, then stop.
  #  If we have reached the max number of levels, then stop
  #
  #print "comparing level $level to maxlevel $g_maxlevel<BR>";
  my $temp_maxlevel = ($g_path_from_root) ? $g_all_levels : $g_maxlevel;
  if ($level >= $temp_maxlevel || $root_hc eq 'N') {
      return();
  }

  #
  #  Get child nodes
  #
  my ($child_id, $child_code, $child_name, $child_dept, $child_hc);
  my @child_id_list = ();
  my @child_code_list = ();
  my @child_name_list = ();
  my @child_dept_list = ();
  my @child_hc_list = ();
  my $prev_child_code;
  while (($child_id, $child_code, $child_name, $child_dept, $child_hc) 
          = $csr2->fetchrow_array) {
    #print "('$child_id', '$child_code', '$child_dept') ";
    if ($child_code ne $prev_child_code) {
      push(@child_id_list, $child_id);
      push(@child_code_list, $child_code);
      push(@child_name_list, $child_name);
      push(@child_dept_list, $child_dept);
      push(@child_hc_list, $child_hc);
      #print "Simple<br>";
    }
    else {  # Another row for the same qual_code? Concatenate the dept_code. 
      my $prev_child_dept = pop(@child_dept_list);
      push(@child_dept_list, "$prev_child_dept,$child_dept");
      #print "Pop-push<br>";
    }
    $prev_child_code = $child_code;
  }

  #
  #  Print child nodes
  #
  my $levelplus1 = $level + 1;
  my $n = @child_id_list;
  my $i = 0;
  my $new_last_sibling = 0;
  my $new_prefix_string;
  #print "n=$n<BR>";
  while ($i < $n) {
    if (($i+1) == $n) {$new_last_sibling = 1;}
    if ($is_last_sibling) {
      $new_prefix_string = $prefix_string . "&nbsp;&nbsp;&nbsp;";
    }
    else {
      $new_prefix_string = $prefix_string . "|&nbsp;&nbsp;";
    }
    #print "('$child_id_list[$i]', '$child_code_list[$i]', 
    #        '$child_name_list[$i]', '$child_dept_list[$i]')<BR>";
    &print_qual_tree($lda, $csr1, $csr2, 
               $child_id_list[$i], $child_code_list[$i], 
               $child_name_list[$i], $child_dept_list[$i], $child_hc_list[$i], 
               $levelplus1, $qualtype,
               $new_prefix_string, $new_last_sibling);
    $i++;
  }

}

###########################################################################
#
#  Subroutine &get_dept_id2code_hash($lda, \%$g_dept_id2code);
#
#  Creates a hash %g_dept_id2code where $g_dept_id2code{$dept_id} = $dept_code 
#
###########################################################################
sub get_dept_id2code_hash {
  my ($lda, $rdept_id2code) = @_;

  my $stmt = "select d.dept_id, d.d_code
              from ${g_owner}.department d
              order by 1";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement dept_id2code: " 
            . $DBI::errstr . "<BR>";
  }

  unless ($csr1->execute) {
      print "Error executing select statement dept_id2code: " 
            . $DBI::errstr . "<BR>";
  }
  
  #
  #  Get info about a qualifier
  #
  my ($did, $dcode);
  while ( ($did, $dcode) = $csr1->fetchrow_array ) {
    $$rdept_id2code{$did} = $dcode;
  }

}

###########################################################################
#
#  Function &get_max_dept_code_length($lda, $qualtype);
#
#  Finds the dept_code string for all objects linked to more than one
#  dept_code in expanded_object_link table for a given object type.
#  Finds the maximum length of these comma-delimited strings, and returns
#  that number.  If there are no cases where an object is linked to 
#  more than one dept_code, then return the maximum dept_code length.
#
###########################################################################
sub get_max_dept_code_length {
  my ($lda, $qualtype) = @_;

#
# Convert the qualifier type to an object type.
#
  my $object_type = &convert_qualtype_to_object_type($qualtype);
  #print "object_type = '$object_type'<BR>";

#
# Open a cursor to read through object links where a single object is
# linked to more than one dept_code.
#
  my $stmt = "select distinct l.object_code, d.d_code 
     from ${g_owner}.expanded_object_link l, ${g_owner}.department d
     where (l.object_type_code, l.object_code) in 
    (select l.object_type_code, l.object_code
     from ${g_owner}.expanded_object_link l
     where l.object_type_code = '$object_type'
     group by l.object_type_code, l.object_code
     having count(distinct l.dept_id) > 1)
    and d.dept_id = l.dept_id
    order by l.object_code, d.d_code";
  #print "stmt='$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement for multi-dept codes: " 
            . $DBI::errstr . "<BR>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement : " 
            . $DBI::errstr . "<BR>";
  }
  
  #
  #  Build a hash of object_codes and their dept_codes
  #
  my ($obj_code, $dcode);
  my %obj2dept = ();
  my $max_length = 16;  # Default max length.
  while ( ($obj_code, $dcode) = $csr1->fetchrow_array ) {
    if ($obj2dept{$obj_code}) {
      $obj2dept{$obj_code} .= ", $dcode";
    }
    else {
      $obj2dept{$obj_code} = $dcode;
    }
    if (length($obj2dept{$obj_code}) > $max_length) {
      $max_length = length($obj2dept{$obj_code});
    }
  }
  
  return $max_length;
 
}

###########################################################################
#
#  Subroutine print_qual_detail
#
#  Print a row in the tree display.
#
###########################################################################
sub print_qual_detail {
  my ($prefix_string, $qid, $qcode, $qname, $dept_id, $has_child,
      $override_root) = @_;

  #
  #  Print info
  #
   my ($start_font, $end_font) = ('', '');
   if (!$dept_id) {
      # Do not gray out the string.
      #$start_font = "<font color=\"gray\">";
      #$end_font = "</font>";
   }
   my ($start_href, $end_href) = ('', '');
   if ($has_child eq 'Y') {
      ## Kluge to prevent ".." display if this is the root node:  
      ## do not specify the root in the URL if this is the root level
      ## of a path_from_root display.
      my $temp_qid = ($override_root) ? '' : $qid;
      $start_href = "<a href=\"${url_stem}\&root_id=$temp_qid\">";
      $end_href = "</a>";
   }

   my $dept_code = &get_dept_code($dept_id); 
   my $len = length($dept_code);
   my $mod_dept_code =  ('&nbsp;' x ($g_max_code_length+1-$len)) . $dept_code;
   if ($g_code_position eq 'LEFT') {
     my $start_bold = ($dept_code) ? '<b>' : '';
     my $end_bold = ($dept_code) ? '</b>' : '';
     print $mod_dept_code 
         . " $prefix_string$start_href$start_bold$qcode$end_bold$end_href"
         . " $start_font$qname$end_font<BR>\n";
   }
   else {
    print $prefix_string
           . "$start_href$qcode$end_href"
          . " $start_font$qname$end_font <b>$dept_code</b><BR>\n";
   }

}

###########################################################################
#
#  Function get_dept_code($dept_id)
#
#  Returns the $dept_code associated with the dept_id. If $dept_id is 
#  a comma-delimited list of dept_id's, then return a comma-delimited list of 
#  department codes.
#
###########################################################################
sub get_dept_code {
  my ($dept_id) = @_;
  #print "In get_dept_code dept_id = '$dept_id'<BR>";
  my $dept_code;
  foreach $did (split(',', $dept_id)) {
    if ($dept_code) {
      $dept_code .= ", $g_dept_id2code{$did}";
    }
    else {
      $dept_code = $g_dept_id2code{$did};
    }
  }
  return $dept_code;
}


###########################################################################
#
#  Function lookup_a_qualcode($lda, $qualtype, $qualcode);
#
#  Returns $qual_id for the given $qualcode within the $qualtype.
#
###########################################################################
sub lookup_a_qualcode {
  my ($lda, $qualtype, $qualcode) = @_;

  #
  # First, look to see if the qualtype/qualcode exists.
  #
  my $stmt1 = "select count(*)
               from qualifier\@roles 
               where qualifier_type = '$qualtype'
               and qualifier_code = '$qualcode'";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt1)) {
      print "Error preparing 1st select statement in lookup_a_qualcode: " 
            . $DBI::errstr . "<BR>";
  }

  unless ($csr1->execute) {
      print "Error executing select 1st statement in lookup_a_qualcode: " 
            . $DBI::errstr . "<BR>";
  }
  
  #
  #  Go see if the qualifier_type/qualifier_code exists.
  #
  my ($counter) = $csr1->fetchrow_array;
  unless ($counter) {
    print "Error: Qualifier code '$qualcode' qualifier_type '$qualtype'
           was not found.<BR>\n";
  }

  #
  #  Now that we know that the qualifier_type/qualifier_code exists,
  #  go find the matching qualifier_id.
  #
  my $stmt2 = "select qualifier_id 
               from qualifier\@roles 
               where qualifier_type = '$qualtype'
               and qualifier_code = '$qualcode'";
  my $csr2;
  unless ($csr2 = $lda->prepare($stmt2)) {
      print "Error preparing 2nd select statement in lookup_a_qualcode: " 
            . $DBI::errstr . "<BR>";
  }

  unless ($csr2->execute) {
      print "Error executing select 2nd statement in lookup_a_qualcode: " 
            . $DBI::errstr . "<BR>";
  }
  my ($qualid) = $csr2->fetchrow_array;
  
  #print "qualtype='$qualtype' qualcode='$qualcode' qualid='$qualid'<br>";
  return $qualid;
}

###########################################################################
#
#  Function get_details_about_a_node($gcsr1, $gcsr1a, $qual_id, $qualtype);
#
#  Returns ($qual_id, $qualcode, $qualname, $dept_id, $has_child) 
#   for the given $qual_id.
#
###########################################################################
sub get_details_about_a_node {
  my ($csr1, $csr1a, $qual_id, $qualtype) = @_;
  #print "Here in get_details A qual_id='$qual_id' qualtype='$qualtype'<BR>";

  my $csr;
  if ($qual_id) {
    $csr = $csr1;
    my $object_type = &convert_qualtype_to_object_type($qualtype);
    unless ($csr->bind_param(1, $qual_id)) {
        print "Error binding param: " . $DBI::errstr . "<BR>";  
    }
    unless ($csr->bind_param(2, $object_type)) {
        print "Error binding param: " . $DBI::errstr . "<BR>";
    }
  }
  else {
    $csr = $csr1a;
    unless ($csr->bind_param(1, $qualtype)) {
        print "Error binding param: " . $DBI::errstr . "<BR>";
    }
  }

  unless ($csr->execute) {
      print "Error executing select statement: " . $DBI::errstr . "<BR>";
  }
  
  #
  #  Get info about a qualifier
  #
  my ($qid, $qcode, $qname, $dept_id, $has_child);
  my ($temp_qid, $temp_qcode, $temp_qname, $temp_dept_id, $temp_has_child);
  while (($temp_qid, $temp_qcode, $temp_qname, $temp_dept_id, $temp_has_child) 
           = $csr->fetchrow_array) {
      if ($dept_id) {
          $dept_id .= ",$temp_dept_id";
      }
      else {
       ($qid, $qcode, $qname, $dept_id, $has_child) 
         = ($temp_qid,$temp_qcode,$temp_qname,$temp_dept_id,$temp_has_child);
      }
  }
  #print "qid=$qid qcode=$qcode dept_id=$dept_id<BR>";

  return ($qid, $qcode, $qname, $dept_id, $has_child);
}

###########################################################################
#
#  Function open_cursor1
#
#  Opens a cursor to a select statement to return details about an 
#  object in the hierarchy.
#
###########################################################################
sub open_cursor1 {
  my ($lda) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = "select distinct q.qualifier_id, q.qualifier_code, 
                     q.qualifier_name, l.dept_id, q.has_child
              from qualifier\@roles q, ${g_owner}.expanded_object_link l
              --from qualifier q, ${g_owner}.expanded_object_link l
              where q.qualifier_id = ?
              and l.object_code(+) = q.qualifier_code
              and l.object_type_code(+) = ?
              order by qualifier_code";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }

  return $csr1;
}

###########################################################################
#
#  Function open_cursor1a
#
#  Opens a cursor to a select statement to return details about the
#  root level node in the hierarchy.
#
###########################################################################
sub open_cursor1a {
  my ($lda) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = "select distinct q.qualifier_id, q.qualifier_code, 
                     q.qualifier_name, l.dept_id, q.has_child
              from qualifier\@roles q, ${g_owner}.expanded_object_link l
              where q.qualifier_type = ?
              and l.object_code(+) = q.qualifier_code
              and l.object_type_code(+) = q.qualifier_type
              and q.qualifier_level = 1
              order by qualifier_code";
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
  my ($lda, $qualtype) = @_;

  my $object_type_code;
  my $qualcode_fragment;
  my $no_leaf_fragment;
  $object_type_code = &convert_qualtype_to_object_type($qualtype);

  if ($qualtype eq 'PMIT') {
      $qualcode_fragment = 
     "replace(replace(q.qualifier_code, 'PC', 'P'), 'PMIT', 'PCMIT')";
  }
  elsif ($qualtype eq 'FUND') {
    $qualcode_fragment = "q.qualifier_code";
    $no_leaf_fragment = " and q.qualifier_code like 'FC%' ";
  }
  elsif ($qualtype eq 'COST') {
    $qualcode_fragment = 
     "replace(replace(q.qualifier_code, 'PC', 'P'), '0H', '0')";
    $no_leaf_fragment = 
       " and substr(q.qualifier_code, 1, 2) in ('0H', 'PC') ";
  }
  else {
    $qualcode_fragment = "q.qualifier_code";
  }

  #
  #  Open a cursor
  #
   my $stmt;
   #  Normal view from a given node
   if (!$g_path_from_root) {
     $stmt = 
      "select /*+ ORDERED */ distinct q.qualifier_id, q.qualifier_code, 
              q.qualifier_name,
              l.dept_id, q.has_child
       from qualifier_child\@roles qc, qualifier\@roles q, 
            ${g_owner}.expanded_object_link l
       where qc.parent_id = ?
       and q.qualifier_id = qc.child_id
       and l.object_type_code(+) = '$object_type_code'
       and l.object_code(+) = $qualcode_fragment
       $no_leaf_fragment
       order by q.qualifier_code, l.dept_id";
   }
   # Special view -- find path from the root to a final node
   else {
     $stmt = 
      "select /*+ ORDERED */ distinct q.qualifier_id, q.qualifier_code, 
              q.qualifier_name,
              l.dept_id, q.has_child
       from qualifier_child\@roles qc, qualifier\@roles q, 
            ${g_owner}.expanded_object_link l
       where qc.parent_id = ?
       and q.qualifier_id = qc.child_id
       and (q.qualifier_id = '$g_end_qualid'
            or exists (select qd.parent_id from qualifier_descendent\@roles qd
                       where qd.parent_id = q.qualifier_id
                       and qd.child_id = '$g_end_qualid') ) 
       and l.object_type_code(+) = '$object_type_code'
       and l.object_code(+) = $qualcode_fragment
       $no_leaf_fragment
       order by q.qualifier_code, l.dept_id";
   }
   my $csr2;
   #print "stmt2='$stmt'<BR>";
   unless ($csr2 = $lda->prepare($stmt)) {
       print "Error preparing select statement: " . $DBI::errstr . "<BR>";
   }

   return $csr2;
}

###########################################################################
#
#  Function convert_qualtype_to_object_type($qualtype)
#
#  Returns the object_type from the object_link table corresponding to 
#  a given perMIT system qualifier_type.
#
###########################################################################
sub convert_qualtype_to_object_type {
  my ($qualtype) = @_;

  my $object_type_code;
  if ($qualtype eq 'SISO') {
    $object_type_code = 'SIS';
  }
  elsif ($qualtype eq 'BAGS') {
    $object_type_code = 'BAG';
  }
  elsif ($qualtype eq 'FUND') {
    $object_type_code = 'FC';
  }
  elsif ($qualtype eq 'COST') {
    $object_type_code = 'PC';
  }
  else {
    $object_type_code = $qualtype;
  }

 return $object_type_code;

}

