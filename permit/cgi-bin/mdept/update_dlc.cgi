#!/usr/bin/perl
###########################################################################
#
#  CGI script to print a tree of DLCs
#
#
#  Copyright (C) 2004-2010 Massachusetts Institute of Technology
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
#  Written 2/1/2004
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
 $g_delim1 = '!';

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

$gl_ddid = $formval{'ddid'};
$gl_add_dlc = $formval{'add_dept'};
#
# Login into the database
# 
$lda = &login_dbi_sql('mdepto') 
      || die $DBI::errstr . "<BR>";

if($gl_add_dlc){
    print_add_dlc_screen($lda);
}elsif($gl_ddid){
    print_update_dlc_screen($lda, $gl_ddid);
}else{
    print "Fatal Error: one of the parameters "
          ."add_dept = $gl_add_dlc or department id = $gl_ddid should be defined.<br>\n";
}

#
# Disconnect from the database and print end of document
#
 $lda->disconnect;
 print "<HR>", "\n";
 print "</BODY></HTML>", "\n";
 exit(0);
####
sub print_add_dlc_screen{
    my($lda);
#
#  Print out the http document header
#
 print "<HTML>", "\n";
 print "<HEAD>"
  . "<TITLE>Add a DLC or Node</TITLE></HEAD>", "\n";
 print "<BODY bgcolor=\"#fafafa\">";
 &print_header("Add a DLC or Node", 'http');
 print "<HR>", "\n";
#
# Get information about the view_type
#
# my $view_type_code = ($g_view_type) ? $g_view_type : 'A';
# my ($view_type_desc, $root_id) = &get_view_info($lda, $view_type_code);

 print "Add screen<br>\n";

 print_update_dlc_page($lda, $g_ddid); 

 print "<HR>", "\n";

 print_summary_of_parent_link_types($lda);

#
# Disconnect from the database and print end of document
#
 $lda->disconnect;
 print "<HR>", "\n";
 print "</BODY></HTML>", "\n";
 exit(0);
}
####
sub print_update_dlc_screen{
    my($lda, $g_ddid) = @_;
#
#  Print out the http document header
#
 print "<HTML>", "\n";
 print "<HEAD>"
  . "<TITLE>Update a DLC or Node</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 &print_header("Update a DLC or Node", 'http');
 print "<HR>", "\n";
#
# Get information about the view_type
#
 my $view_type_code = ($g_view_type) ? $g_view_type : 'A';
 my ($view_type_desc, $root_id) = &get_view_info($lda, $view_type_code);

 print_update_dlc_page($lda, $g_ddid); 

 print "<HR>", "\n";

 print_summary_of_parent_link_types($lda);
 print "<HR>", "\n";
 print "</BODY></HTML>", "\n";
 
#
# Disconnect from the database and print end of document
#
 $lda->disconnect;
 print "<HR>", "\n";
 print "</BODY></HTML>", "\n";
 exit(0);
}

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
###
sub get_dept_node_types{
    my ($lda) = @_;

    my $stmt = qq{select DEPT_TYPE_ID, 
                DEPT_TYPE_DESC
           from $g_owner.DEPT_NODE_TYPE
           order by DEPT_TYPE_DESC};
    my $csr;
  unless ($csr = $lda->prepare($stmt)) {
       print "Error preparing select statement: $stmt" . $DBI::errstr . "<BR>";
  }
  $csr->execute;
    my ($dept_type_id, $dept_type_desc);
    my $dept_node_types = [];
    
    while(($dept_type_id, $dept_type_desc) = $csr->fetchrow_array){
	my @dept_node_type = ($dept_type_id, $dept_type_desc);
        push @{$dept_node_types}, \@dept_node_type;
    }
    return $dept_node_types;
}
###
sub print_complete_dlc_info{
    my($dlc_info) = @_;
#    print "Printing complete dlc info<br>\n";
    print_dlc_info($dlc_info);
    print_dlc_parents($dlc_info);
    print_dlc_linked_objects($dlc_info);
}
###
sub get_complete_dlc_info{
    my($lda, $ddid, $dlc_info) = @_;

 #   print "ddid = $ddid<br>\n";

    ## Assume that no ddid implies add dlc situation
    if(!$ddid){return;}

    ## Pure dept info
    my ($dept_id, $d_code, $short_name, $long_name, 
      $dept_type_id, $dept_type_desc) = get_dlc_info($lda, $ddid);

  #  print "d_code = $d_code<br>\n";

    $dlc_info->{'dept_id'}=$dept_id;
    $dlc_info->{'d_code'}=$d_code;
    $dlc_info->{'short_name'}=$short_name;
    $dlc_info->{'long_name'}=$long_name;
    $dlc_info->{'dept_type_id'}=$dept_type_id;
    $dlc_info->{'dept_type_desc'}=$dept_type_desc;

    ## Parents
    my $dlc_parents = get_dlc_parents($lda, $ddid);
    $dlc_info->{'dlc_parents'} = $dlc_parents;
    ## Linked Objects
    my $dlc_linked_objects = get_dlc_linked_objects($lda, $ddid);
    $dlc_info->{'dlc_linked_objects'} = $dlc_linked_objects;
}
###
sub get_dlc_info{
    my ($lda, $ddid) = @_;

  my $stmt = qq{select d.dept_id, d.d_code, d.short_name, d.long_name,
                d.DEPT_TYPE_ID, 
                dnt.DEPT_TYPE_DESC
           from $g_owner.department d, $g_owner.DEPT_NODE_TYPE dnt 
	   where dept_id = $ddid
           and d.DEPT_TYPE_ID = dnt.DEPT_TYPE_ID};
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
       print "Error preparing select statement: $stmt" . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  my ($dept_id, $d_code, $short_name, $long_name, 
      $dept_type_id, $dept_type_desc) = $csr->fetchrow_array;

  return ($dept_id, $d_code, $short_name, $long_name, 
	  $dept_type_id, $dept_type_desc);
}
###
sub print_dlc_info{
  my ($dlc_info) = @_;                                                         
  my $dept_id = $dlc_info->{'dept_id'};
  my $d_code = $dlc_info->{'d_code'};
  my $short_name = $dlc_info->{'short_name'};
  my $long_name = $dlc_info->{'long_name'};
  my $dept_type_id = $dlc_info->{'dept_type_id'};
  my $dept_type_desc = $dlc_info->{'dept_type_desc'};

#  print "Printing dlc info<br>\n";
#  print "dept_id = $dept_id<br>\n";
    print "<table>\n";
      print "<tr align=left>\n";
        print "<th>DLC ID Number:</th>";
        print "<td>$dept_id</td>";
      print "</tr>\n";
      print "<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>";

      print "<tr align=left>\n";
        print "<th>DLC Code:</th>\n";
        print "<td>";
        print "<input type=\"text\" name=\"dlc_code\" value=\"$d_code\"";
          print "size=15 maxlength=15>";
        print "</td>\n";
      print "</tr>\n";

      print "<tr align=left>\n";
        print "<th>Short Name:</th>";
        print "<td>";
        print 
          "<input type=\"text\" name=\"dlc_short_name\" value=\"$short_name\""
          . " size=35 maxlength=25>";
        print "</td>\n";
      print "</tr>\n";

      print "<tr align=left>\n";
        print "<th>Long Name:</th>";
        print "<td>";
        print "<input type=\"text\" name=\"dlc_long_name\" "
            . "value=\"$long_name\" size=70 maxlength=70>";
        print "</td>\n";
      print "</tr>\n";

    my $dept_node_types = get_dept_node_types($lda);
    print "<tr align=left>\n";
        print "<th>DLC/Node Type:</th>";
        print "<td>";
        print "<select name=dept_type_id>";
        my $dept_node_type;
        foreach $dept_node_type (@{$dept_node_types}){
	    my($dt_id, $dt_desc)=@{$dept_node_type};
            if($dt_id eq $dept_type_id){
		print "<option value=\"$dt_id\" selected>$dt_desc</option>";
            } else {
                print "<option value=\"$dt_id\">$dt_desc</option>";
            }
        }
        print "</select>";
        print "</td>\n";
      print "</tr>\n";

    print "<tr align=left>";
    print "<th>Sort order:</th><td><small><i>Not supported yet"
	. "</i></small></td></tr>";
    print "</table><br>\n";
}

###
sub get_dlc_parents{
    my ($lda, $ddid) = @_;
    my $stmt = qq{select dc.PARENT_ID, d.D_CODE, 
                  dc.VIEW_SUBTYPE_ID, vst.VIEW_SUBTYPE_DESC
           from $g_owner.DEPARTMENT_CHILD dc, $g_owner.DEPARTMENT d,
           $g_owner.view_subtype vst
           where dc.CHILD_ID = $ddid
           and vst.VIEW_SUBTYPE_ID = dc.VIEW_SUBTYPE_ID
           and d.DEPT_ID = dc.PARENT_ID
           order by d.D_CODE};
    my $csr;
  unless ($csr = $lda->prepare($stmt)) {
       print "Error preparing select statement: $stmt" . $DBI::errstr . "<BR>";
  }
  $csr->execute;
    my @dlc_parents =();
  while (my ($p_d_id, $p_d_code, $p_view_subtype_id, $p_view_subtype_desc) =
	 $csr->fetchrow_array){
      my $r_dlc_par = [];
      push @{$r_dlc_par}, ($p_d_id, $p_d_code, $p_view_subtype_id, $p_view_subtype_desc);
    push @dlc_parents, $r_dlc_par;
  }
  return \@dlc_parents;
}

###
sub get_view_subtypes{
    my ($lda) = @_;
  my $stmt = qq{select VIEW_SUBTYPE_ID, VIEW_SUBTYPE_DESC
           from $g_owner.view_subtype
           order by VIEW_SUBTYPE_ID};
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
       print "Error preparing select statement: $stmt" . $DBI::errstr . "<BR>";
  }
  $csr->execute;
    my @view_subtypes = ();
    while(my @view_subtype = $csr->fetchrow_array){
	push @view_subtypes, \@view_subtype;
    }
    return \@view_subtypes;
}

###
sub print_dlc_parents{
    my ($dlc_info) = @_;
    print "<table>";
    my $view_subtypes = get_view_subtypes($lda);
    my $view_subtype;
    my $dlc_parents = $dlc_info->{'dlc_parents'};
    my $dlc_parent;
    my $count = 0;
    foreach $dlc_parent (@{$dlc_parents}){
	print "<tr>";
       my ($p_d_id, $p_d_code, $p_view_subtype_id, $p_view_subtype_desc) =
	   @{$dlc_parent};
        print "<th>Parent DLC Code:</th>";
        print "<td>";
	    print "<input type=text name=\"dlc_par_${count}\" value=\"$p_d_code\"";
            print "size=25 maxlength=25>&nbsp;&nbsp;&nbsp;";
        print "</td>";
        print "<th>Parent-link type:</th>";
        print "<td>";
        print "<select>\n";
        foreach $view_subtype (@{$view_subtypes}){
	    my ($vst_id, $vst_desc) = @{$view_subtype};
            if($vst_id eq $p_view_subtype_id){
		print "<option value=\"$vst_id\" selected>$vst_id\n";
            } else {
                print "<option value=\"$vst_id\">$vst_id\n";
            }
        }
        print "<option value=\"-1\">Select parent-link type\n";
	print "</select>";
        print "</td>";
	print "</tr>";
        $count++;
    }
    my $ind;
    for ($ind = 0; $ind < 2; $ind++){
         print "<tr>";
         print "<th>Parent DLC Code:</th>";
         print "<td>";
            print "<input type=text name=\"dlc_par_${count}\" value=\"\"";
            print "size=25 maxlength=25>&nbsp;&nbsp;&nbsp;";
         print "</td>";
         print "<th>Parent-link type:</th>";
         print "<td>";
         print "<select>\n";
         foreach $view_subtype (@{$view_subtypes}){
	     my ($vst_id, $vst_desc) = @{$view_subtype};
                print "<option value=\"$vst_id\">$vst_id\n";
         }
	 print "<option value=\"view_subtype_${count}\" selected>";
         print "Select parent-link type\n";
         print "</select>\n";
         print "</td>";
         print "</tr>";
         $count++;
    }
    print "</table>\n";
}

###
sub get_dlc_linked_objects{
    my ($lda, $ddid) = @_;

    my $stmt = qq{select ot.OBJECT_TYPE_CODE, ot.OBJ_TYPE_DESC, ol.OBJECT_CODE
           from $g_owner.OBJECT_TYPE ot, $g_owner.OBJECT_LINK ol
           where ol.DEPT_ID = $ddid
           and ot.OBJECT_TYPE_CODE = ol.OBJECT_TYPE_CODE
           order by ot.OBJ_TYPE_DESC, ol.OBJECT_CODE };
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
       print "Error preparing select statement: $stmt" . $DBI::errstr . "<BR>";
  }
  $csr->execute;
    my @dlc_linked_objects = ();
    my $prev_obj_type_code;
    my $prev_obj_type_desc;
    my @obj_codes = ();
  while (my($obj_type_code, $obj_type_desc, $obj_code) = $csr->fetchrow_array){
      if($prev_obj_type_code eq $obj_type_code){
	  push @obj_codes, $obj_code;
      } else {
	  if(scalar(@obj_codes) > 0){
	      my @old_obj_codes = @obj_codes;
              push @dlc_linked_objects, [$prev_obj_type_code, $prev_obj_type_desc,
                   \@old_obj_codes];
              $prev_obj_type_code = $obj_type_code;
              $prev_obj_type_desc = $obj_type_desc;
              @obj_codes = ();
              push @obj_codes, $obj_code;
          } else {
              $prev_obj_type_code = $obj_type_code;
              $prev_obj_type_desc = $obj_type_desc;
              push @obj_codes, $obj_code;
          }
      }
  }
  return \@dlc_linked_objects;
}
###
sub print_dlc_linked_objects{
    my ($dlc_info) = @_;
    my $dlc_linked_objects = $dlc_info->{'dlc_linked_objects'};
    print "<P>";
    print "<table border>";
    print "<tr><th>Linked Object Type</th><th>Linked Object<br>Code</th>";
    print "<th>Name</th></tr>";
    my $dlc_linked_object;
    my $ind;
    foreach $dlc_linked_object (@{$dlc_linked_objects}){
	my $obj_type_desc = $dlc_linked_object->[1];
        my $obj_codes = $dlc_linked_object->[2];
        my $rowspan = scalar(@{$obj_codes});
    ## Two empty text fields for each linked object type for the department.
        my $act_size = $rowspan + 2;
        print "<tr><th rowspan=$act_size>$obj_type_desc</th>";
        print "<td>";
        print "<input type=text name=\"obj_code_0\" value=\"$obj_codes->[0]\"";
        print "size=20 maxlength=20>";
        print "</td><td>&nbsp;</td></tr>";
	  my $obj_code;
	  for($ind=1; $ind < $rowspan; $ind++){
              $obj_code = $obj_codes->[$ind];
	      print "<tr><td>";
              print "<input type=text name=\"obj_code_$ind\" value=\"$obj_code\"";
              print "size=20 maxlength=20>";
              print "</td><td>&nbsp;</td></tr>";
          }
	  for($ind = $rowspan; $ind < $act_size; $ind++){
              print "<tr><td>";
              print "<input type=text name=\"obj_code_$ind\" value=\"\"";
              print "size=20 maxlength=20>";
              print "</td><td>&nbsp;</td></tr>";
          } 
    }
    print "</table>";
}

#############################################################################
#
#  Function get_summary_of_parent_link_types
#
#  Reads in information about view_subtypes and view_types.
#  Returns \@summary_of_types, where each element in this array
#   contains [$view_subtype_id, $view_subtype_desc, 
#             a delimited string concatenating all applicable view_desc's]
#
#############################################################################
sub get_summary_of_parent_link_types{

    my ($lda) = @_;

    my $stmt = qq{ select vst.view_subtype_id, vst.view_subtype_desc, 
                 vt.view_type_code ||'. '|| vt.view_type_desc
                 from view_subtype vst,
                 view_type_to_subtype vttst,
                 view_type vt
                 where vttst.view_subtype_id = vst.view_subtype_id
                 and vt.view_type_code = vttst.view_type_code
                 order by 1,3};

  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
       print "Error preparing select statement: $stmt" . $DBI::errstr . "<BR>";
  }

  $csr->execute;
    my ($prev_view_subtype_id, $prev_view_subtype_desc);
    my @summary_of_types = ();
  ## The following code was replaced because it doesn't handle the
  ## last row.
  #my @visible_in_views = ();
  #while(my ($view_subtype_id, $view_subtype_desc, $visible_in_views) = 
  #       $csr->fetchrow_array) {
  #    if($view_subtype_id eq $prev_view_subtype_id){
  #       push @visible_in_views, $visible_in_views;
  #   } else {
  #       if(scalar(@visible_in_views) > 0){
  #          my @save_visible_in_views = @visible_in_views;
  #          my $type = [$prev_view_subtype_id, $prev_view_subtype_desc,
  #                     \@save_visible_in_views];
  #          push @summary_of_types, $type;
  #          $prev_view_subtype_id = $view_subtype_id;
  #          $prev_view_subtype_desc = $view_subtype_desc;
  #          @visible_in_views = ();
  #      } else {
  #          $prev_view_subtype_id = $view_subtype_id;
  #          $prev_view_subtype_desc = $view_subtype_desc;
  #      }
  #   }
  #}
  my $visible_in_views_string;
  while(my ($view_subtype_id, $view_subtype_desc, $visible_in_views) = 
         $csr->fetchrow_array) {
     if ($view_subtype_id eq $prev_view_subtype_id) {
	 $visible_in_views_string .= $g_delim1 . $visible_in_views;
         pop(@summary_of_types);
     }
     else {
         $visible_in_views_string = $visible_in_views;
     }
     my $type_array = [$view_subtype_id, $view_subtype_desc, 
                       $visible_in_views_string];
     push(@summary_of_types, $type_array);
     $prev_view_subtype_id = $view_subtype_id;
  }
  return \@summary_of_types;
}

#############################################################################
#
#
#
#############################################################################
sub print_summary_of_parent_link_types{
    my ($lda) = @_;

    # Get an array of arrays.
    my $summary_of_types = get_summary_of_parent_link_types($lda);

    print "<blockquote>";
    print "<i>Summary of parent link types</i>\n";
    print "<table border bgcolor=\"#E0E0E0\">";
    print "<tr>";
    print "<th><small>Parent-link<br>type ID</small></th>";
    print "<th><small>Parent-link type<br>Description</small></th>";
    print "<th><small>Visible in these views</small></th>";
    print "</tr>";
    my ($type, $view_subtype_id, $view_subtype_desc, $visible_in_views);
    my $num_views;
    foreach $type (@{$summary_of_types}){
        $view_subtype_id = $type->[0];
        $view_subtype_desc = $type->[1];
	$visible_in_views = $type->[2];
        my @visible_in_views_lines = split($g_delim1, $visible_in_views);
        $num_views = scalar(@visible_in_views_lines);
        $num_rows = $num_views + 1;
        print "<tr><td rowspan=$num_views align=center><small>$view_subtype_id"
              . "</small></td>";
        print "<td rowspan=$num_views><small>$view_subtype_desc</small></td>";
        for ($i=0; $i<$num_views; $i++) {
          unless ($i == 0) {print "<tr>";}
          print "<td align=left><small>$visible_in_views_lines[$i]</small>"
                . "</td></tr>";
        }
    }
    print "</table></blockquote>";
}

##############################################################################
#
#
#
##############################################################################
sub print_update_dlc_page{
    my ($lda, $ddid) = @_;
    my $dlc_info = {};
    get_complete_dlc_info($lda, $ddid, $dlc_info);
#    print "Complete dlc Info<br>\n";
    my $dept_id = $dlc_info->{'dept_id'};
#    print "dept_id = $dept_id<br>\n";
    print "<form method=POST action=\"dlc_tree2.cgi?view_type=$view_type_code\">";
    print_complete_dlc_info($dlc_info);
#    print_dlc_info($lda, $dlc_info);
#    print_dlc_parents($lda, $dlc_info);
#    print_dlc_linked_objects($lda, $dlc_info);
 print "<blockquote>";
 print "<input type=submit name=\"update_button\" value=\"Update DLC\">";
 print "&nbsp;&nbsp;&nbsp;";
 print "<input type=submit name=\"delete_button\" value=\"Delete DLC\">";
 print "&nbsp;&nbsp;&nbsp;";
 print "<input type=submit name=\"cancel_button\" value=\"Cancel\">";
 print "</blockquote>";
 print "</form>";
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
   print "<b>$ddcode</b> $ddname ($ddid)<BR>";

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
