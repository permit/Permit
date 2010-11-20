#!/usr/bin/perl
###########################################################################
#
#  CGI script for maintenance of Functions in the Roles Database (perMIT).
#
#
#  Copyright (C) 2010 Massachusetts Institute of Technology
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
#  Jim Repa - 1/22/2010
#
###########################################################################
##++++++++++++
#
#  Possibly add these later:
#
#  Add functionality for qualifier_subtype
#  Add functionality for maintaining categories
#  Add functionality for maintaining qualifier types
#
##++++++++++++
#
# Get packages
#
use rolesweb('login_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
use rolesweb('parse_ssl_info'); #Use sub. parse_ssl_info in rolesweb.pm
use rolesweb('check_cert_source'); #Use sub. check_cert_source in rolesweb.pm
use rolesweb('verify_metaauth_category'); #Use sub. verify_metaauth_category
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm
use rolesweb('strip'); #Use sub. strip in rolesweb.pm
use DBI;
#use Oraperl;

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
# Get specific form variables
#
 $g_cgi_step = $formval{'cgi_step'};
 unless ($g_cgi_step) {$g_cgi_step = 'category_list';}
 $g_category = $formval{'category'};
 $g_function_id = $formval{'function_id'};
 $g_function_name = &strip($formval{'function_name'});  # Modified 2/19/2010
 $g_function_desc = $formval{'function_desc'};
 $g_qualifier_type = $formval{'qualifier_type'};
 $g_implied_function = $formval{'implied_function'};
 $g_pass_number = $formval{'pass_number'};
 $g_pa_option = $formval{'pa_option'};
 $g_pa_group = $formval{'pa_group'};
 $g_parent_id = $formval{'parent_id'};
 $g_child_id = $formval{'child_id'};
 $g_return_id = $formval{'return_id'};
 $g_regular_or_implied = $formval{'regular_or_implied'};
 $g_function_group_id = $formval{'function_group_id'};
 $g_group_name = $formval{'function_group_name'};
 $g_group_desc = $formval{'function_group_desc'};

#
#  Set variables and constants
#
 $gray = "bgcolor=\"#C0C0C0\"";
 $g_bg_yellow = "bgcolor=\"#FFFF88\"";
 $g_server_user = 'ROLEWWW9';  # username for server username field
 %step2title = ('function_list' => 'Display function list', 
                'category_list' 
                  => 'Main category list for Function maintenance', 
                'create_function' => 'Function creation', 
                'create_function_group' => 'Function group creation', 
                'pre_delete_function' => 'Are you sure?', 
                'pre_delete_group' => 'Are you sure?', 
                'pre_remove_parent_child' => 'Are you sure?', 
                'pre_remove_group_link' => 'Are you sure?', 
                'delete_function' => 'Delete a function', 
                'delete_group' => 'Delete a function group', 
                'delete_ext_function' => 'Delete an implied/external function',
                'pre_create_function' => 'Create a new function', 
                'edit_function' => 'Updating a function', 
                'pre_edit_function' => 'Edit an existing function',
                'pre_edit_group' => 'Edit a function group',
                'edit_function_group' => 'Updating a function group',
                'pre_create_group' => 'Create a new function group',
                'tree_view_cat_function' 
                     => 'Display tree of categories, functions, and child
                         functions',
                'display_function_groups' 
                     => 'Display function groups and their linked functions',
                'pre_edit_parent_child' 
                   => 'Edit parent/child pairs for a function', 
                'pre_edit_function_group_link' 
                   => 'Edit list of functions linked to a function group', 
                'remove_parent_child' 
                   => 'Edit parent/child pairs for a function', 
                'add_parent_child' 
                   => 'Edit parent/child pairs for a function', 
                'add_function_group_link' 
                   => 'Edit list of functions linked to a function group', 
                'remove_group_link' 
                   => 'Edit list of functions linked to a function group', 
               );
 #$g_cgi_step = 'function_list';
 #$g_cgi_step = 'category_list';
 #$g_category = 'META';


#
#  Print out top of the http document.  
#
 print "Content-type: text/html\n\n";  # Start generating HTML document
 $header = $step2title{$g_cgi_step};
 unless ($header) {$header = "Error - invalid process step specified";}
 print "<head><title>$header</title></head>\n<body>";
 print '<BODY bgcolor="#fafafa">';
 &print_header
    ($header, 'https');
 print "<P>";

#
#  Print some diagnostic messages
#
 #print "g_cgi_step = '$g_cgi_step' function_id = '$function_id' <BR>";

#
#  Parse certificate information
#
$info = $ENV{"SSL_CLIENT_DN"};  # Get certificate information
#print $info;
%ssl_info = &parse_ssl_info($info);  # Parse certificate into a Perl "hash"
$email = $ssl_info{'Email'};    # Get Email address from cert. 'Email' field
$full_name = $ssl_info{'CN'};   # Get full name from cert. 'CN' field
($k_principal, $domain) = split("\@", $email);
#print $k_principal;
if (!$k_principal) {
    print "<br><b>No certificate sent.  Use https:// , not http://</b>\n";
    exit();
}
$k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase

#
#  Check the other fields in the certificate
#
$result = &check_cert_source(\%ssl_info);
if ($result ne 'OK') {
    print "<br><b>Your certificate cannot be accepted: $result";
    exit();
}

#
#  Web stem constants
#
 $host = $ENV{'HTTP_HOST'};
 $main_url = "https://$host/webroles.html";
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 $url_stem = "https://$host/cgi-bin/$progname?";  # URL for this CGI script
 $groups_url = 
   "https://$host/cgi-bin/$progname?cgi_step=display_function_groups";

#
#  Open connection to oracle
#
 $dbh = &login_sql('rolesw') 
      || &web_error($ora_errstr);

#
#  Call the appropriate subroutine
#
 if ($g_cgi_step eq 'function_list') {
   &display_function_list($dbh, $g_category, $k_principal);
 }
 elsif ($g_cgi_step eq 'category_list') {
   &display_category_list($dbh, $k_principal);
 }
 elsif ($g_cgi_step eq 'pre_create_function') {
   &pre_create_function($dbh, $g_category, $k_principal);
 }
 elsif ($g_cgi_step eq 'edit_function') {
   &edit_function($dbh, $g_function_id, $k_principal, $g_category,
                  $g_function_name, $g_function_desc, $g_qualifier_type,
                  $g_pa_option, $g_pa_group, $g_implied_function,
                  $g_pass_number);
 }
 elsif ($g_cgi_step eq 'pre_edit_function') {
   &pre_edit_function($dbh, $g_function_id, $k_principal);
 }
 elsif ($g_cgi_step eq 'pre_edit_group') {
   &pre_edit_group($dbh, $g_function_group_id, $k_principal);
 }
 elsif ($g_cgi_step eq 'edit_function_group') {
   &edit_function_group($dbh, $g_function_group_id, $k_principal, $g_category,
			$g_group_name, $g_group_desc, $g_qualifier_type);
 }
 elsif ($g_cgi_step eq 'pre_create_group') {
   &pre_create_group($dbh, $k_principal);
 }
 elsif ($g_cgi_step eq 'tree_view_cat_function') {
   &tree_view_cat_function($dbh, $k_principal, $g_category, '');
 }
 elsif ($g_cgi_step eq 'display_function_groups') {
   &display_function_groups($dbh, $k_principal);
 }
 elsif ($g_cgi_step eq 'pre_edit_parent_child') {
   &pre_edit_parent_child($dbh, $g_function_id, $k_principal, '');
 }
 elsif ($g_cgi_step eq 'pre_edit_function_group_link') {
   &pre_edit_function_group_link($dbh, $g_function_group_id, $k_principal, '');
 }
 elsif ($g_cgi_step eq 'create_function') {
   &create_function($dbh, $g_category, $k_principal, $g_function_name, 
      $g_function_desc, $g_qualifier_type, $g_pa_option, $g_pa_group, 
      $g_regular_or_implied, $g_pass_number);
 }
 elsif ($g_cgi_step eq 'create_function_group') {
   &create_function_group($dbh, $g_category, $k_principal, $g_group_name, 
      $g_group_desc, $g_qualifier_type);
 }
 elsif ($g_cgi_step eq 'pre_delete_function') {
   &pre_delete_function($dbh, $k_principal, $g_function_id);
 }
 elsif ($g_cgi_step eq 'pre_delete_group') {
   &pre_delete_group($dbh, $k_principal, $g_function_group_id);
 }
 elsif ($g_cgi_step eq 'pre_remove_parent_child') {
   &pre_remove_parent_child($dbh, $k_principal, $g_return_id, $g_parent_id, 
                        $g_child_id);
 }
 elsif ($g_cgi_step eq 'pre_remove_group_link') {
   &pre_remove_group_link($dbh, $k_principal, $g_parent_id, $g_child_id);
 }
 elsif ($g_cgi_step eq 'remove_parent_child') {
   &remove_parent_child($dbh, $k_principal, $g_return_id, $g_parent_id, 
                        $g_child_id);
 }
 elsif ($g_cgi_step eq 'add_parent_child') {
   &add_parent_child($dbh, $k_principal, $g_return_id, $g_parent_id, 
                        $g_child_id);
 }
 elsif ($g_cgi_step eq 'add_function_group_link') {
   &add_function_group_link($dbh, $k_principal, $g_parent_id, $g_child_id);
 }
 elsif ($g_cgi_step eq 'remove_group_link') {
   &remove_function_group_link($dbh, $k_principal, $g_parent_id, $g_child_id);
 }
 elsif ($g_cgi_step eq 'delete_function') {
   &delete_function($dbh, $k_principal, $g_function_id);
 }
 elsif ($g_cgi_step eq 'delete_group') {
   &delete_group($dbh, $k_principal, $g_function_group_id);
 }
 elsif ($g_cgi_step eq 'delete_ext_function') {
   &delete_ext_function($dbh, $k_principal, $g_function_id);
 }
 else {
   &bad_step_error($g_cgi_step);
 }

 #
 #  Print end of document, and drop connection to Oracle.
 #
 print "<HR>", "\n";
 print "<A HREF=\"$main_url\">"
  . "<small>Back to main Roles web interface page</small></A>";
 print "</BODY></HTML>", "\n";
 ($lda->disconnect) || die "can't log off Oracle";

 exit();


###########################################################################
#
# Subroutine display_category_list ($dbh, $end_user)
#
###########################################################################
sub display_category_list {
  my ($lda, $end_user) = @_;

 #
 #  Show navigation bar
 #
  &print_menu('main');  

 #
 #  Get hashes of info for display
 #
  my %cat2desc;
  my %cat2function_count;
  my %cat2group_count;
  my %cat2imp_function_count;
  my %cat2can_maint_function;
  &get_categories ($lda, $end_user, '', \%cat2desc, 
                   \%cat2function_count, \%cat2imp_function_count, 
                   \%cat2can_maint_function, \%cat2group_count);


 #
 #  Print out a table of categories
 #
  my $function_group_link =
      "<a href=\"$groups_url\">function<br>groups</a>";
  print "<table border>\n";
  print "<tr><th>Category</th><th>Description</th>
         <th>No. of<br>(regular)<br>functions</th>
         <th>No. of<br>\"implied\"<br>functions</th>
         <th>User $end_user<br>can maintain<br>functions
             <br>in this category</th>
         <th>View/edit<br>functions in<br>this category
         <th>No. of<br>$function_group_link</th></tr>\n";
  my $cat;
  foreach $cat (sort keys %cat2desc) {
    my $url_for_cat = $url_stem . "cgi_step=function_list&category=$cat";
    my ($can_maint_string, $view_edit_string);
    if ($cat2can_maint_function{$cat} eq 'Y') {
	$can_maint_string = 'Yes';
        $view_edit_string = 'View/Edit';
    }
    else {
	$can_maint_string = 'no';
        $view_edit_string = 'View';
    }
    print "<tr><td><a href=\"$url_for_cat\">$cat</td></td>
               <td>$cat2desc{$cat}</td>
               <td align=right>$cat2function_count{$cat}</td>
               <td align=right>$cat2imp_function_count{$cat}</td>
               <td align=center>$can_maint_string</td>
               <td align=center>
                  <a href=\"$url_for_cat\">$view_edit_string</a></td>
               <td align=right>$cat2group_count{$cat}</td>
           </tr>";
  }
  print "</table>\n";  ;

}

###########################################################################
#
# Subroutine tree_view_cat_function ($dbh, $end_user, $category, $show_all)
#
###########################################################################
sub tree_view_cat_function {
  my ($lda, $end_user, $category, $show_all) = @_;

 #
 #  Show navigation bar
 #
  &print_menu('tree');  

 #
 #  Get a list of functions, and a hash of function_ids and their 
 #   parent function_ids.
 #
  &get_functions($lda, $category, '');
 
 #
 # Get information about the specified category.  We use the same 
 # subroutine as the one used for getting information about all categories,
 # but in this case, we specify only one category of interest.
 #
  my %cat2desc;
  my %cat2function_count;
  my %cat2group_count;
  my %cat2imp_function_count;
  my %cat2can_maint_function;
  if ($category) {
    $category 
    = substr($category . "    ", 0, 4);  # Make sure category is 4 characters
  }
  &get_categories ($lda, $end_user, $category, \%cat2desc, 
                   \%cat2function_count, \%cat2imp_function_count, 
                   \%cat2can_maint_function, \%cat2group_count);

 #
 #  Print navigation bar for category list
 #
  my $cat_nospace;
  print "<small>Go to category:";
  foreach $cat (sort keys %cat2desc) {
      $cat_nospace = &strip($cat);
      print "&nbsp; <a href=\"#$cat_nospace\">$cat_nospace</a>";
  }
  print "</small><p />";

 #
 # Print legend
 #
  my $red_bg = "bgcolor=\"#FF7777\"";
  my $green_bg = "bgcolor=\"#44FF44\"";
  my $blue_bg = "bgcolor=\"#9999FF\"";
  my $yellow_bg = "bgcolor=\"#C0FF40\"";
  print "<table border width=\"100%\">
         <tr><th $gray>Legend<p />";
    print "<table border width=\"50%\">
           <tr $red_bg><td width=\"14%\">Category</td>
             <td width=\"86%\">Category description
               <small><i>[function list link]</i></small></td>
           </tr></table>\n";
      print "<blockquote>";
      print "<table border width=\"70%\">
           <tr $green_bg><td width=\"14%\">Category</td>
           <td width=\"52%\">Function name</td>
           <td width=\"17%\">Function ID*</td>
           <td width=\"17%\">Qual. type</td>
           </tr>
           <tr $yellow_bg><td width=\"14%\">Category</td>
           <td width=\"52%\">External/Implied Function name</td>
           <td width=\"17%\">Function ID*</td>
           <td width=\"17%\">Qual. type</td>
           </tr>
           </table>\n";
      print "<blockquote>";
      print "<table border width=\"80%\">
           <tr $blue_bg><td width=\"14%\">Category</td>
           <td width=\"52%\">Child Function name</td>
           <td width=\"17%\">Function ID*</td>
           <td width=\"17%\">Qual. type</td>
           </tr></table>\n";
      print "<table width=\"80%\"><tr><td align=center><br>
                <small><i>* click the 
                Function ID to view/edit function details</i></small></td></tr>
             </table>";
      print "</blockquote>";
      print "</blockquote>";
  print "</th></tr></table>\n";
  print "<p />&nbsp;<br>";

 #
 # Print out a list of categories.  Under each category, print a 
 # list of functions
 #
  my $i = 0;
  foreach $key (sort keys %cat2desc) {  # Print out each category
    $cat_nospace = &strip($key);
    my $cat_url = $cat2desc{$key} . 
                  " <a href=${url_stem}cgi_step=function_list&category=$key>"
                 . " <small>[to function list...]</small></a>";
    my $cat_anchor = "<a name=\"$cat_nospace\">$key</a>";
    print "<table border width=\"50%\">
           <tr $red_bg><td width=\"10%\">$cat_anchor</td>
               <td width=\"90%\">$cat_url</td>
           </tr></table>\n";
    print "<blockquote>";
    while ($fcategory[$i] eq $key) {  # Print each function within the category
      my $fid_url =
       "<a href=${url_stem}cgi_step=pre_edit_function&function_id=$fid[$i]>"
       . $fid[$i] . "</a>";
      my $fid_url2 =
       "<a href=${url_stem}cgi_step=pre_edit_function&function_id=$fid[$i]>"
       . "<small>[function details...]</a>";
      my $bg_color = ($f_implied[$i] eq 'Yes') ? $yellow_bg : $green_bg;
      print "<table border width=\"70%\">
           <tr $bg_color><td width=\"12%\">$fcategory[$i]</td>
           <td width=\"64%\">$fname[$i]</td>
           <td width=\"12%\">$fid_url</td>
           <td width=\"12%\">$fqualtype[$i]</td>
           </tr></table>\n";
      my @child_list = split("!", $fid2child_id{$fid[$i]});
      my @sort_child_list = &sort_function_ids_by_name(\@child_list);
      my $n_children = @child_list;
      if ($n_children) {
	  #print $fid2child_id{$fid[$i]} . "<br>";
          print "<blockquote>";
          my $j;
          foreach $j (@sort_child_list) {  # Print each child function
	    $idx = $fid2index{$j};  # Get the index within the arrays
            $fid_url =
             "<a href=${url_stem}cgi_step=pre_edit_function"
             . "&function_id=$j>$j</a>";
            print "<table border width=\"80%\">
                <tr $blue_bg>
                <td width=\"12%\">$fcategory[$idx]</td>
                <td width=\"64%\">$fname[$idx]</td>
                <td width=\"12%\">$fid_url</td>
                <td width=\"12%\">$fqualtype[$idx]</td>
                </tr></table>\n";
             
          }
          print "</blockquote>";
      }
      $i++;
    }
    print "</blockquote>";
  }
  my $n = @fname;
  my $oldcat;
  print "<blockquote>";

}

###########################################################################
#
# Subroutine create_function($lda, $cat, $end_user, $function_name,
#   $function_desc, $qualifier_type, $pa_option, $pa_group, 
#   $regular_or_implied)
#
###########################################################################
sub create_function {
  my ($lda, $cat, $end_user, $function_name, $function_desc, 
      $qualifier_type, $pa_option, $pa_group, $regular_or_implied, 
      $pass_number) = @_;

  #print "category='$cat'<br>end_user='$end_user'<br>
  #       function_name='$function_name'<br>
  #       function_desc='$function_desc'<br>
  #       qualifier_type='$qualifier_type'<br>
  #       pa_option='$pa_option'<br>
  #       pa_group='$pa_group'<br>
  #       regular_or_implied='$regular_or_implied'<BR>
  #       <BR>\n";
  if ($regular_or_implied eq 'I') {
     #my $pass_number = 'A';
     &create_ext_function($lda, $cat, $end_user, $function_name,
                      $function_desc, $qualifier_type, $pa_option, $pa_group, 
                      $regular_or_implied, $pass_number);
     return();
  }

  #
  #  We'll need to supply arguments ai_primary_authorizable and 
  #  ai_is_primary_auth_parent to the stored procedure.  Determine these
  #  from the $pa_option CGI variable.
  #
   #print "pa_option='$pa_option'<BR>";
   my ($primary_authorizable, $is_pa_parent);
   if ($pa_option eq 'pa_authorizable') {
       $primary_authorizable = 'Y';
       $is_pa_parent = 'N';
   }
   elsif ($pa_option eq 'pa_authorizable_dlc') {
       $primary_authorizable = 'D';
       $is_pa_parent = 'N';
   }
   elsif ($pa_option eq 'pa_parent') {
       $primary_authorizable = 'N';
       $is_pa_parent = 'Y';
   }
   else {
       $primary_authorizable = 'N';
       $is_pa_parent = 'N';
   }

  #
  #  If $pa_group is 'NONE', set it to null.
  #
   if ($pa_group eq 'NONE') {
       $pa_group = '';
   }

  #
  #  Diagnostics
  #
   #print "pa_group = '$pa_group'<BR>";
   #print "primary_authorizable = '$primary_authorizable'<BR>";

  #
  #  Call the stored procedure to create a new function
  #
    my @stmt = 
	q{
	    BEGIN
               rolesapi_create_function2 (
                  :server_user, -- ai_server_user
                  :proxy_user,  -- ai_proxy_user
                  :function_name,  -- ai_function_name
                  :function_desc,  -- ai_function_description
                  :category,       -- ai_function_category
                  :qualifier_type, -- ai_qualifier_type
                  :primary_authorizable,    -- ai_primary_authorizable
                  :primary_auth_group,      -- ai_primary_auth_group
                  :is_primary_auth_parent,  -- ai_is_primary_auth_parent
		  :new_function_id -- new_function_id
               );
	    END;
	};

    #print @stmt;
    #print "<BR>";
   
    my $csr = $lda->prepare(@stmt)
	 || &web_error("Error preparing statement (rolesapi_create_function2)."
            . "<BR>" . $lda->errstr . "<BR>");
   
    my ($error_no, $error_msg, $sql_statement);

    $csr->bind_param(":server_user", $g_server_user);
    $csr->bind_param(":proxy_user", $end_user);
    $csr->bind_param(":function_name", $function_name);
    $csr->bind_param(":function_desc", $function_desc);
    $csr->bind_param(":category", $cat);
    $csr->bind_param(":qualifier_type", $qualifier_type);
    $csr->bind_param(":primary_authorizable", $primary_authorizable);
    $csr->bind_param(":primary_auth_group", $pa_group);
    $csr->bind_param(":is_primary_auth_parent", $is_pa_parent);
    #print "Before inout bind<BR>";
    my $new_function_id;
    $csr->bind_param_inout(":new_function_id", \$new_function_id, 20);

    #print "After last bind_param_inout...<BR>";
    $csr->execute;
    #print "After execute...<BR>";

    my $err = $lda->err;
    my $errstr = $lda->errstr;
    if ($g_show_tech_notes) { print "errstr='$errstr'<BR>"; }
  
    $errstr =~ /\: ([^\n]*)/;
  
    my $shorterr = $1;
 
    $csr->finish;
    #print "After finish (err='$err')...<BR>";

    if ($err) {
	# Error. Display the error message and put the form back up.
	print "$shorterr Error Number $err";
        die;
    }
    else {
      if ($lda->commit) {
        print "Function '$function_name' was successfully created
               in category $cat.  Function_id='$new_function_id'<p />";
        print "<center>";
        &print_function_list_button($cat);
        print "</center>";
      }
      else {
        print "Error in \"commit\" step when trying to create the function "
            . $lda->errstr . "<BR>";
      }
    }
}

###########################################################################
#
# Subroutine create_function_group($lda, $cat, $end_user, $group_name,
#   $group_desc, $qualifier_type)
#
###########################################################################
sub create_function_group {
  my ($lda, $cat, $end_user, $group_name, $group_desc, $qualifier_type) = @_;

  #print "In create_function_group<BR>";
  #print "category='$cat'<br>end_user='$end_user'<br>
  #       group_name='$group_name'<br>
  #       group_desc='$group_desc'<br>
  #       qualifier_type='$qualifier_type'
  #       <BR>\n";

  #
  #  Call the stored procedure to create a new function
  #
    my @stmt = 
	q{
	    BEGIN
               rolesapi_create_func_group (
                  :server_user, -- ai_server_user
                  :proxy_user,  -- ai_proxy_user
                  :group_name,  -- ai_group_name
                  :group_desc,  -- ai_group_description
                  :category,       -- ai_function_category
                  :matches_function, -- ai_matches_function
                  :qualifier_type, -- ai_qualifier_type
		  :new_group_id -- new_group_id
               );
	    END;
	};

    #print @stmt;
    #print "<BR>";
   
    my $csr = $lda->prepare(@stmt)
	 || &web_error("Error preparing statement"
            . " (rolesapi_create_function_group)."
            . "<BR>" . $lda->errstr . "<BR>");
   
    my ($error_no, $error_msg, $sql_statement);

    $csr->bind_param(":server_user", $g_server_user);
    $csr->bind_param(":proxy_user", $end_user);
    $csr->bind_param(":group_name", $group_name);
    $csr->bind_param(":group_desc", $group_desc);
    $csr->bind_param(":category", $cat);
    my $matches_function = 'N';
    $csr->bind_param(":matches_function", $matches_function);
    $csr->bind_param(":qualifier_type", $qualifier_type);
    #print "Before inout bind<BR>";
    my $new_group_id;
    $csr->bind_param_inout(":new_group_id", \$new_group_id, 20);

    #print "After last bind_param_inout...<BR>";
    $csr->execute;
    #print "After execute...<BR>";

    my $err = $lda->err;
    my $errstr = $lda->errstr;
    if ($g_show_tech_notes) { print "errstr='$errstr'<BR>"; }
  
    $errstr =~ /\: ([^\n]*)/;
  
    my $shorterr = $1;
 
    $csr->finish;
    #print "After finish (err='$err')...<BR>";

    if ($err) {
	# Error. Display the error message and put the form back up.
	print "$shorterr Error Number $err";
        die;
    }
    else {
      if ($lda->commit) {
        print "Function group '$group_name' was successfully created
               in category $cat.  Function_group_id='$new_group_id'<p />";
        print "<center>";
        print "<form>
           <input type=hidden name=\"cgi_step\" 
                              value=\"display_function_groups\">
           <input type=submit value=\"Display function groups\">
         </form>";

        print "</center>";
      }
      else {
        print "Error in \"commit\" step when trying to create function group "
            . $lda->errstr . "<BR>";
      }
    }
}

###########################################################################
#
# Subroutine create_ext_function($lda, $cat, $end_user, $function_name,
#   $function_desc, $qualifier_type, $pa_option, $pa_group)
#
###########################################################################
sub create_ext_function {
  my ($lda, $cat, $end_user, $function_name, $function_desc, 
      $qualifier_type, $pa_option, $pa_group, $regular_or_implied,
      $pass_number) = @_;

  #
  # Diagnostics
  #
   #print "In create_ext_function<BR>";
   #print "category='$cat'<br>end_user='$end_user'<br>
   #       function_name='$function_name'<br>
   #       function_desc='$function_desc'<br>
   #       qualifier_type='$qualifier_type'<br>
   #       pa_option='$pa_option'<br>
   #       pa_group='$pa_group'<br>
   #       regular_or_implied='$regular_or_implied'<BR>
   #       pass_number='$pass_number'<BR>
   #       <BR>\n";

  #
  #  If pa_option is not 'pa_neither' or pa_group is not 'NONE', then print 
  #  an error message.
  #
   if ($pa_option ne 'pa_neither' ||  $pa_group ne 'NONE') {
       print "<big><font color=red>Error: Implied/external functions cannot be 
              assignable by a primary authorizer and must not have a primary 
              auth group.</font></big><BR>";
       return();
   }

  #
  #  If function_name does not start with an asterisk, add one
  #
   if (substr($function_name, 0, 1) ne '*') {
       $function_name = '*' . $function_name;
   }

  #
  #  If pass_number is not specified, set it to '1'
  #
   unless ($pass_number) {
       $pass_number = '1';
   }

  #
  #  Call the stored procedure to create a new function
  #
    my @stmt = 
	q{
	    BEGIN
               rolesapi_create_ext_function (
                  :server_user, -- ai_server_user
                  :proxy_user,  -- ai_proxy_user
                  :function_name,  -- ai_function_name
                  :function_desc,  -- ai_function_description
                  :category,       -- ai_function_category
                  :qualifier_type, -- ai_qualifier_type
                  :pass_number,    -- ai_function_load_pass
		  :new_function_id -- new_function_id
               );
	    END;
	};

    #print @stmt;
    #print "<BR>";
   
    my $csr = $lda->prepare(@stmt)
	 || &web_error("Error preparing statement (rolesapi_create_function2)."
            . "<BR>" . $lda->errstr . "<BR>");
   
    my ($error_no, $error_msg, $sql_statement);

    $csr->bind_param(":server_user", $g_server_user);
    $csr->bind_param(":proxy_user", $end_user);
    $csr->bind_param(":function_name", $function_name);
    $csr->bind_param(":function_desc", $function_desc);
    $csr->bind_param(":category", $cat);
    $csr->bind_param(":qualifier_type", $qualifier_type);
    $csr->bind_param(":pass_number", $pass_number);
    #print "Before inout bind<BR>";
    my $new_function_id;
    $csr->bind_param_inout(":new_function_id", \$new_function_id, 20);

    #print "After last bind_param_inout...<BR>";
    $csr->execute;
    #print "After execute...<BR>";

    my $err = $lda->err;
    my $errstr = $lda->errstr;
    if ($g_show_tech_notes) { print "errstr='$errstr'<BR>"; }
  
    $errstr =~ /\: ([^\n]*)/;
  
    my $shorterr = $1;
 
    $csr->finish;
    #print "After finish (err='$err')...<BR>";

    if ($err) {
	# Error. Display the error message and put the form back up.
	print "$shorterr Error Number $err";
        die;
    }
    else {
      if ($lda->commit) {
        print "External/implied function '$function_name' was successfully 
               created in category $cat.  Function_id='$new_function_id'<p />";
        print "<center>";
        &print_function_list_button($cat);
        print "</center>";
      }
      else {
        print "Error in \"commit\" step when trying to create external/implied"
            . " function " . $lda->errstr . "<BR>";
      }
    }
}

###########################################################################
#
# Subroutine edit_function($lda, $function_id, $end_user, $category,
#    $function_name, $function_desc, $quailfier_type, $pa_option, $pa_group,
#    $implied_function)
#
###########################################################################
sub edit_function {
  my ($lda, $function_id, $end_user,  $cat, $function_name, 
      $function_desc, $qualifier_type, $pa_option, $pa_group,
      $implied_function, $load_pass) = @_;

  #print "Ready to update function ID='$function_id'<BR>";
  #print "category='$cat'<br>end_user='$end_user'<br>
  #       function_name='$function_name'<br>
  #       function_desc='$function_desc'<br>
  #       qualifier_type='$qualifier_type'<br>
  #       pa_option='$pa_option'<br>
  #       pa_group='$pa_group'<br>
  #       load_pass='$load_pass'<br>
  #       <BR>\n";

  #
  #  If this is an implied function, then call the subroutine 
  #  edit_implied_function
  #
  if ($implied_function eq 'Yes') {
    &edit_implied_function($lda, $function_id, $end_user, $cat,
        $function_name, $function_desc, $qualifier_type, $load_pass);
    return;
  }

  #
  #  We'll need to supply arguments ai_primary_authorizable and 
  #  ai_is_primary_auth_parent to the stored procedure.  Determine these
  #  from the $pa_option CGI variable.
  #
   my ($primary_authorizable, $is_pa_parent);
   if ($pa_option eq 'pa_authorizable') {
       $primary_authorizable = 'Y';
       $is_pa_parent = 'N';
   }
   elsif ($pa_option eq 'pa_authorizable_dlc') {
       $primary_authorizable = 'D';
       $is_pa_parent = 'N';
   }
   elsif ($pa_option eq 'pa_parent') {
       $primary_authorizable = 'N';
       $is_pa_parent = 'Y';
   }
   else {
       $primary_authorizable = 'N';
       $is_pa_parent = 'N';
   }

  #
  #  If $pa_group is 'NONE', set it to null.
  #
   if ($pa_group eq 'NONE') {
       $pa_group = '';
   }

  #
  #  Diagnostics
  #
   #print "pa_group = '$pa_group'<BR>";
   #print "primary_authorizable = '$primary_authorizable'<BR>";

  #
  #  Call the stored procedure to update the function
  #
    my @stmt = 
	q{
	    BEGIN
               rolesapi_update_function2 (
                  :server_user, -- ai_server_user
                  :proxy_user,  -- ai_proxy_user
                  :function_id,  -- ai_function_id
                  :function_name,  -- ai_function_name
                  :function_desc,  -- ai_function_description
                  :category,       -- ai_function_category
                  :qualifier_type, -- ai_qualifier_type
                  :primary_authorizable,    -- ai_primary_authorizable
                  :primary_auth_group,      -- ai_primary_auth_group
                  :is_primary_auth_parent   -- ai_is_primary_auth_parent
               );
	    END;
	};

    #print @stmt;
    #print "<BR>";
   
    my $csr = $lda->prepare(@stmt)
	 || &web_error("Error preparing statement (rolesapi_update_function2)."
            . "<BR>" . $lda->errstr . "<BR>");
   
    my ($error_no, $error_msg, $sql_statement);

    $csr->bind_param(":server_user", $g_server_user);
    $csr->bind_param(":proxy_user", $end_user);
    $csr->bind_param(":function_id", $function_id);
    $csr->bind_param(":function_name", $function_name);
    $csr->bind_param(":function_desc", $function_desc);
    $csr->bind_param(":category", $cat);
    $csr->bind_param(":qualifier_type", $qualifier_type);
    $csr->bind_param(":primary_authorizable", $primary_authorizable);
    $csr->bind_param(":primary_auth_group", $pa_group);
    $csr->bind_param(":is_primary_auth_parent", $is_pa_parent);

    $csr->execute;

    my $err = $lda->err;
    my $errstr = $lda->errstr;
    if ($g_show_tech_notes) { print "errstr='$errstr'<BR>"; }
  
    $errstr =~ /\: ([^\n]*)/;
  
    my $shorterr = $1;
 
    $csr->finish;
    #print "After finish (err='$err')...<BR>";

    if ($err) {
	# Error. Display the error message and put the form back up.
	print "$shorterr Error Number $err";
        &print_view_function_button($function_id);
    }
    else {
      if ($lda->commit) {
        print "Function '$function_name' was successfully updated
               in category $cat.<p />";
        print "<table width=\"100%\">\n";
        print "<tr><td>";
        &print_view_function_button($function_id);
        print "</td><td>";
        &print_function_list_button($cat);
        print "</td></tr></table>\n";
      }
      else {
        print "Error in \"commit\" step when trying to update the function "
            . $lda->errstr . "<BR>";
      }
    }
}

###########################################################################
#
# Subroutine edit_function_group($lda, $function_id, $end_user, $category,
#    $function_name, $function_desc, $quailfier_type, $pa_option, $pa_group,
#    $implied_function)
#
###########################################################################
sub edit_function_group {
  my ($lda, $function_group_id, $end_user,  $cat, $group_name, 
      $group_desc, $qualifier_type, $pa_option, $pa_group,
      $implied_function) = @_;

  #print "Ready to update function group ID='$function_group_id'<BR>";
  #print "category='$cat'<br>end_user='$end_user'<br>
  #       group_name='$group_name'<br>
  #       group_desc='$group_desc'<br>
  #       qualifier_type='$qualifier_type'<BR>\n";

  #
  #  Call the stored procedure to update the function_group
  #
    my @stmt = 
	q{
	    BEGIN
               rolesapi_update_func_group (
                  :server_user, -- ai_server_user
                  :proxy_user,  -- ai_proxy_user
                  :group_id,  -- ai_group_id
                  :group_name,  -- ai_group_name
                  :group_desc,  -- ai_group_description
                  :category,       -- ai_function_category
                  :matches_function,    -- ai_matches_function
                  :qualifier_type -- ai_qualifier_type
               );
	    END;
	};

    #print @stmt;
    #print "<BR>";
   
    my $csr = $lda->prepare(@stmt)
	 || &web_error("Error preparing statement (rolesapi_update_func_group)."
            . "<BR>" . $lda->errstr . "<BR>");
   
    my ($error_no, $error_msg, $sql_statement);

    $csr->bind_param(":server_user", $g_server_user);
    $csr->bind_param(":proxy_user", $end_user);
    $csr->bind_param(":group_id", $function_group_id);
    $csr->bind_param(":group_name", $group_name);
    $csr->bind_param(":group_desc", $group_desc);
    $csr->bind_param(":category", $cat);
    $csr->bind_param(":qualifier_type", $qualifier_type);
    my $matches_a_function = 'N';
    $csr->bind_param(":matches_function", $matches_a_function);

    $csr->execute;

    my $err = $lda->err;
    my $errstr = $lda->errstr;
    if ($g_show_tech_notes) { print "errstr='$errstr'<BR>"; }
  
    $errstr =~ /\: ([^\n]*)/;
  
    my $shorterr = $1;
 
    $csr->finish;
    #print "After finish (err='$err')...<BR>";

    if ($err) {
	# Error. Display the error message and put the form back up.
	print "$shorterr Error Number $err";
        &print_view_group_button($function_group_id);
    }
    else {
      if ($lda->commit) {
        print "Function group '$group_name' was successfully updated
               in category $cat.<p />";
        print "<table width=\"100%\">\n";
        print "<tr><td>";
        &print_view_group_button($function_group_id);
        print "</td><td>";
        &print_group_list_button();
        print "</td></tr></table>\n";
      }
      else {
        print "Error in \"commit\" step when trying to update function group "
            . $lda->errstr . "<BR>";
        &print_view_group_button($function_group_id);
      }
    }

}

###########################################################################
#
# Subroutine edit_implied_function($lda, $function_id, $end_user, $category,
#    $function_name, $function_desc, $quailfier_type, $pa_option, $pa_group,
#    $implied_function)
#
###########################################################################
sub edit_implied_function {
  my ($lda, $function_id, $end_user,  $cat, $function_name, 
      $function_desc, $qualifier_type, $load_pass) = @_;

 #
 #  Print diagnostic messages for debugging.
 #
  #print "In edit_implied_function - ready to update an implied function.<BR>";
  #print "Ready to update function ID='$function_id'<BR>";
  #print "category='$cat'<br>end_user='$end_user'<br>
  #       function_name='$function_name'<br>
  #       function_desc='$function_desc'<br>
  #       qualifier_type='$qualifier_type'<br>
  #       load_pass='$load_pass'\n";

  #
  #  Call the stored procedure to update the function
  #
    my @stmt = 
	q{
	    BEGIN
               rolesapi_update_ext_function (
                  :server_user, -- ai_server_user
                  :proxy_user,  -- ai_proxy_user
                  :function_id,  -- ai_function_id
                  :function_name,  -- ai_function_name
                  :function_desc,  -- ai_function_description
                  :category,       -- ai_function_category
                  :qualifier_type, -- ai_qualifier_type
                  :load_pass       -- ai_load_pass
               );
	    END;
	};

    #print @stmt;
    #print "<BR>";
   
    my $csr = $lda->prepare(@stmt)
	 || &web_error("Error preparing statement (rolesapi_create_function2)."
            . "<BR>" . $lda->errstr . "<BR>");
   
    my ($error_no, $error_msg, $sql_statement);

    $csr->bind_param(":server_user", $g_server_user);
    $csr->bind_param(":proxy_user", $end_user);
    $csr->bind_param(":function_id", $function_id);
    $csr->bind_param(":function_name", $function_name);
    $csr->bind_param(":function_desc", $function_desc);
    $csr->bind_param(":category", $cat);
    $csr->bind_param(":qualifier_type", $qualifier_type);
    $csr->bind_param(":load_pass", $load_pass);

    $csr->execute;

    my $err = $lda->err;
    my $errstr = $lda->errstr;
    if ($g_show_tech_notes) { print "errstr='$errstr'<BR>"; }
  
    $errstr =~ /\: ([^\n]*)/;
  
    my $shorterr = $1;
 
    $csr->finish;
    #print "After finish (err='$err')...<BR>";

    if ($err) {
	# Error. Display the error message and put the form back up.
	print "$shorterr Error Number $err";
        die;
    }
    else {
      if ($lda->commit) {
        print "External/implied function '$function_name' was successfully 
               updated in category $cat.<p />";
        print "<table width=\"100%\">\n";
        print "<tr><td>";
        &print_view_function_button($function_id);
        print "</td><td>";
        &print_function_list_button($cat);
        print "</td></tr></table>\n";
      }
      else {
        print "Error in \"commit\" step when trying to update the function "
            . $lda->errstr . "<BR>";
      }
    }
}

###########################################################################
#
# Subroutine pre_delete_function($lda, $end_user, $function_id)
#
# Before deleting a function, ask "Are you sure?"
#
###########################################################################
sub pre_delete_function {
  my ($lda, $end_user, $function_id) = @_;

  #
  #  Get information about this function, and a hash of function_ids and their 
  #   parent function_ids.
  #
   &get_functions($lda, '', $function_id);
   my $cat = $fcategory[0];

   my $implied_external = ($f_implied[0] eq 'Yes') ? 'implied/external' : '';

   print "Are you sure you want to delete $implied_external function"
       . "<blockquote>$fname[0]<br>function_id=$function_id</blockquote>"
       . "in category $cat?<P />\n";
 
   print "<table width=\"50%\"><tr><td align=left>";
   &print_delete_function_button2($function_id, $f_implied[0]);
   print "</td><td align=left>";
   print "<form><input type=\"submit\" value=\"Cancel\" name=\"EditFunction\">
         <input type=\"hidden\" name=\"cgi_step\" value=\"pre_edit_function\">
         <input type=\"hidden\" name=\"category\" value=\"$cat\">
         <input type=\"hidden\" name=\"function_id\" value=\"$function_id\">
         </form>\n";
   print "</td></tr></table>";

}

###########################################################################
#
# Subroutine pre_delete_group($lda, $end_user, $function_group_id)
#
# Before deleting a function group, ask "Are you sure?"
#
###########################################################################
sub pre_delete_group {
  my ($lda, $end_user, $function_group_id) = @_;

 #
 #  Get information about this function group
 #
  my ($function_category, $fgname, $child_count) =
       &get_function_group_info($lda, $function_group_id);

 #
 #  Print "Are you sure?" message
 #

   print "Are you sure you want to delete function group"
       . "<blockquote>$fgname"
       . "<br>function_group_id=$function_group_id</blockquote>"
       . "in category $function_category?<br>\n";
   if ($child_count) {
     print "Warning: This function group is linked to $child_count 
            child functions.  Child function links will be lost.<BR>";

   }
   print "<p />";
 
   print "<table width=\"50%\"><tr><td align=left>";
   &print_delete_group_button2($function_group_id);
   print "</td><td align=left>";
   print "<form><input type=\"submit\" value=\"Cancel\" name=\"EditGroup\">
         <input type=\"hidden\" name=\"cgi_step\" value=\"pre_edit_group\">
         <input type=\"hidden\" name=\"category\" value=\"$category\">
         <input type=\"hidden\" name=\"function_group_id\" 
                value=\"$function_group_id\">
         </form>\n";
   print "</td></tr></table>";

}

###########################################################################
#
# Subroutine pre_remove_parent_child($lda, $end_user, 
#               $return_to_function_id, $parent_id, $child_id)
#
# Before removing a function parent/child pair, ask "Are you sure?"
# The argument $return_to_function_id indicates which function was being
# edited when the user requested this transaction - after removing 
# the parent/child pair, we'll return to the pre_edit_parent_child screen 
# for this function_id.
#
###########################################################################
sub pre_remove_parent_child {
  my ($lda, $end_user, $return_to_function_id, $parent_id, $child_id) = @_;

  #
  #  Get information about parent and child functions, 
  #  and a hash of function_ids and their parent function_ids.
  #
   &get_functions($lda, '', $parent_id);
   my $parent_function_name = $fname[0];
   my $parent_category = $fcategory[0];
   &get_functions($lda, '', $child_id);
   my $child_function_name = $fname[0];
   my $child_category = $fcategory[0];
   #print "parent ID='$parent_id' function='$parent_function_name'
   #       category='$parent_category'<BR>";
   #print "child ID='$child_id' function='$child_function_name'
   #       category='$child_category'<BR>";

  #
  #  Print a warning message
  #
   if ($parent_id eq $return_to_function_id) {
      print "Are you sure you want to remove child function 
          <blockquote>$child_function_name (ID=$child_id)
          in category $child_category
          </blockquote>
          from parent function
          <blockquote>$parent_function_name (ID=$parent_id)
          in category $parent_category ?
          </blockquote>\n";
   }
   else {  # $child_id should be equal to $return_to_function_id
      print "Are you sure you want to remove parent function 
          <blockquote>$parent_function_name (ID=$parent_id)
          in category $parent_category
          </blockquote>
          from child function
          <blockquote>$child_function_name (ID=$child_id)
          in category $child_category ?
          </blockquote>\n";
   }

   my $remove_parent_child_button =
       &gen_remove_parent_child_button2($return_to_function_id, $parent_id,
                                        $child_id);
   print "<table width=\"50%\"><tr><td align=left>";
   print "$remove_parent_child_button";
   print "</td><td align=left>";
   print "<form><input type=\"submit\" value=\"Cancel\">
         <input type=\"hidden\" name=\"cgi_step\" 
          value=\"pre_edit_parent_child\">
         <input type=\"hidden\" name=\"function_id\" 
              value=\"$return_to_function_id\">
         </form>\n";
   print "</td></tr></table>";

}

###########################################################################
#
# Subroutine pre_remove_group_link($lda, $end_user, $parent_id, $child_id)
#
# Before removing a (function_group, function) link, ask "Are you sure?"
# After removing the link, we'll return to the pre_edit_group screen 
# for the parent function_group.
#
###########################################################################
sub pre_remove_group_link {
  my ($lda, $end_user, $parent_id, $child_id) = @_;

  #
  #  Get information about the parent function_group
  #
   my ($fgcategory, $fgid, $fgname, $fgdesc, $matches_function, $qualtype,
         $fid, $fname, $fgmodified_by, $fgmodified_date, $child_function_list)
     = &get_detailed_group_info ($lda, $parent_id);

  #
  #  Get information about child functions.
  #
   &get_functions($lda, '', $child_id);
   my $child_function_name = $fname[0];
   my $child_category = $fcategory[0];
   #print "parent ID='$parent_id' function_group='$fgname'
   #       category='$fgcategory'<BR>";
   #print "child ID='$child_id' function='$child_function_name'
   #       category='$child_category'<BR>";

  #
  #  Print a warning message
  #
   print "Are you sure you want to remove child function 
          <blockquote>$child_function_name (ID=$child_id)
          in category $child_category
          </blockquote>
          from function group
          <blockquote>$fgname (ID=$parent_id)
          in category $fgcategory ?
          </blockquote>\n";

  #
  #  Print the buttons to go ahead or cancel
  #

   my $remove_parent_child_button =
       &gen_remove_group_link_button2($parent_id, $child_id);
   print "<table width=\"50%\"><tr><td align=left>";
   print "$remove_parent_child_button";
   print "</td><td align=left>";
   print "<form><input type=\"submit\" value=\"Cancel\">
        <input type=\"hidden\" name=\"cgi_step\" 
          value=\"pre_edit_function_group_link\">
        <input type=\"hidden\" name=\"function_group_id\" value=\"$parent_id\">
        </form>\n";
   print "</td></tr></table>";

}

###########################################################################
#
# Subroutine delete_function($lda, $end_user, $function_id)
#
###########################################################################
sub delete_function {
  my ($lda, $end_user, $function_id) = @_;

  #
  #  Get information about this function, and a hash of function_ids and their 
  #   parent function_ids.
  #
   &get_functions($lda, '', $function_id);
   my $cat = $fcategory[0]; 
   my $auth_count = $fauth_count[0];

   print "You have requested deletion of Function \"$fname[0]\""
       . " (ID=$function_id) in category $fcategory[0]<P />\n";
 
  #
  #  Call the stored procedure to delete a function
  #
    my @stmt = 
	q{
	    BEGIN
               rolesapi_delete_function2 (
                  :server_user, -- ai_server_user
                  :proxy_user,  -- ai_proxy_user
                  :function_id  -- ai_function_id
               );
	    END;
	};

    #print @stmt;
    #print "<BR>";
   
    my $csr = $lda->prepare(@stmt)
	 || &web_error("Error preparing statement (rolesapi_delete_function2)."
            . "<BR>" . $lda->errstr . "<BR>");
   
    my ($error_no, $error_msg, $sql_statement);

    $csr->bind_param(":server_user", $g_server_user);
    $csr->bind_param(":proxy_user", $end_user);
    $csr->bind_param(":function_id", $function_id);

    #print "After last bind_param...<BR>";
    $csr->execute;
    #print "After execute...<BR>";

    my $err = $lda->err;
    my $errstr = $lda->errstr;
    if ($g_show_tech_notes) { print "errstr='$errstr'<BR>"; }
  
    $errstr =~ /\: ([^\n]*)/;
  
    my $shorterr = $1;
 
    $csr->finish;
    #print "After finish (err='$err')...<BR>";

    if ($err) {
	# Error. Display the error message and put the form back up.
	print "$shorterr Error Number $err";
        die;
    }
    else {
      if ($lda->commit) {
        print "Function ID '$function_id' has been successfully deleted.<p />";
        print "<center>";
        &print_function_list_button($cat);
        print "</center>";
      }
      else {
        print "Error in \"commit\" step when trying to delete the function "
            . $lda->errstr . "<BR>";
      }
    }
}

###########################################################################
#
# Subroutine delete_group($lda, $end_user, $function_group_id)
#
###########################################################################
sub delete_group {
  my ($lda, $end_user, $function_group_id) = @_;

  #print "In delete_group.  End_user='$end_user' 
  #       group_id='$function_group_id'<br>";

  #
  #  Get information about this function group
  #
   my ($function_category, $fgname, $child_count) =
       &get_function_group_info($lda, $function_group_id);

  #
  #  Call the stored procedure to delete a group
  #
    my @stmt = 
	q{
	    BEGIN
               rolesapi_delete_func_group (
                  :server_user, -- ai_server_user
                  :proxy_user,  -- ai_proxy_user
                  :function_group_id  -- ai_function_group_id
               );
	    END;
	};

    #print @stmt;
    #print "<BR>";
   
    my $csr = $lda->prepare(@stmt)
	|| &web_error("Error preparing statement (rolesapi_delete_func_group)."
           . "<BR>" . $lda->errstr . "<BR>");
   
    my ($error_no, $error_msg, $sql_statement);

    $csr->bind_param(":server_user", $g_server_user);
    $csr->bind_param(":proxy_user", $end_user);
    $csr->bind_param(":function_group_id", $function_group_id);

    #print "After last bind_param...<BR>";
    $csr->execute;
    #print "After execute...<BR>";

    my $err = $lda->err;
    my $errstr = $lda->errstr;
    if ($g_show_tech_notes) { print "errstr='$errstr'<BR>"; }
  
    $errstr =~ /\: ([^\n]*)/;
  
    my $shorterr = $1;
 
    $csr->finish;
    #print "After finish (err='$err')...<BR>";

    if ($err) {
	# Error. Display the error message and put the form back up.
	print "$shorterr Error Number $err";
        die;
    }
    else {
      if ($lda->commit) {
        print "Function group '$fgname' (ID=$function_group_id) 
               has been successfully deleted in category $function_category.
               <p />";
        print "<center>";
        &print_group_list_button();
        print "</center>";
      }
      else {
        print "Error in \"commit\" step when trying to delete the "
            . " function group" . $lda->errstr . "<BR>";
      }
    }
}

###########################################################################
#
# Subroutine delete_ext_function($lda, $end_user, $function_id)
#
###########################################################################
sub delete_ext_function {
  my ($lda, $end_user, $function_id) = @_;

  #
  #  Get information about this function, and a hash of function_ids and their 
  #   parent function_ids.
  #
   &get_functions($lda, '', $function_id);
   my $cat = $fcategory[0]; 
   my $auth_count = $fauth_count[0];

   print "You have requested deletion of Function \"$fname[0]\""
       . " (ID=$function_id) in category $fcategory[0]<P />\n";
 
  #
  #  Call the stored procedure to delete an external function
  #
    my @stmt = 
	q{
	    BEGIN
               rolesapi_delete_ext_function (
                  :server_user, -- ai_server_user
                  :proxy_user,  -- ai_proxy_user
                  :function_id  -- ai_function_id
               );
	    END;
	};

    #print @stmt;
    #print "<BR>";
   
    my $csr = $lda->prepare(@stmt)
	 || &web_error("Error preparing statement"
            . " (rolesapi_delete_ext_function)."
            . "<BR>" . $lda->errstr . "<BR>");
   
    my ($error_no, $error_msg, $sql_statement);

    $csr->bind_param(":server_user", $g_server_user);
    $csr->bind_param(":proxy_user", $end_user);
    $csr->bind_param(":function_id", $function_id);

    #print "After last bind_param...<BR>";
    $csr->execute;
    #print "After execute...<BR>";

    my $err = $lda->err;
    my $errstr = $lda->errstr;
    if ($g_show_tech_notes) { print "errstr='$errstr'<BR>"; }
  
    $errstr =~ /\: ([^\n]*)/;
  
    my $shorterr = $1;
 
    $csr->finish;
    #print "After finish (err='$err')...<BR>";

    if ($err) {
	# Error. Display the error message and put the form back up.
	print "$shorterr Error Number $err";
        die;
    }
    else {
      if ($lda->commit) {
        print "Implied/external function ID '$function_id' has been
           successfully deleted.<p />";
        print "<center>";
        &print_function_list_button($cat);
        print "</center>";
      }
      else {
        print "Error in \"commit\" step when trying to delete "
            . " implied/external function "
            . $lda->errstr . "<BR>";
      }
    }
}

###########################################################################
#
# Subroutine remove_parent_child($lda, $end_user, $return_tofunction_id,
#                             $parent_id, $child_id)
#
###########################################################################
sub remove_parent_child {
  my ($lda, $end_user, $return_to_function_id, $parent_id, $child_id) = @_;

  #
  #  Call the stored procedure to remove a parent/child link
  #
  unless ($msg) {
    my @stmt = 
	q{
	    BEGIN
               rolesapi_delete_function_child (
                  :server_user, -- ai_server_user
                  :proxy_user,  -- ai_proxy_user
                  :parent_id,  -- ai_parent_id
                  :child_id  -- ai_child_id
               );
	    END;
	};

    #print @stmt;
    #print "<BR>";
   
    my $csr = $lda->prepare(@stmt)
	 || &web_error("Error preparing statement"
            . " (rolesapi_remove_function_child)."
            . "<BR>" . $lda->errstr . "<BR>");
   
    my ($error_no, $error_msg, $sql_statement);

    $csr->bind_param(":server_user", $g_server_user);
    $csr->bind_param(":proxy_user", $end_user);
    $csr->bind_param(":parent_id", $parent_id);
    $csr->bind_param(":child_id", $child_id);
    #print "Before inout bind<BR>";

    #print "After last bind_param_inout...<BR>";
    $csr->execute;
    #print "After execute...<BR>";

    my $err = $lda->err;
    my $errstr = $lda->errstr;
    if ($g_show_tech_notes) { print "errstr='$errstr'<BR>"; }
  
    $errstr =~ /\: ([^\n]*)/;
  
    my $shorterr = $1;
 
    $csr->finish;
    #print "After finish (err='$err')...<BR>";

    if ($err) {
	# Error. Display the error message and put the form back up.
	$msg = "$shorterr Error Number $err";
    }
    else {
      if ($lda->commit) {
        $msg = "Function parent/child pair ($parent_id, $child_id)
                was successfully removed.<p />";
      }
      else {
        $msg = "Error in \"commit\" step when trying to remove function "
            . " parent/child pair "
            . $lda->errstr . "<BR>";
      }
    }
  }

  #
  #  Display the edit parent/child screen
  #
   &pre_edit_parent_child($lda, $return_to_function_id, $end_user, $msg);

}

###########################################################################
#
# Subroutine add_parent_child($lda, $end_user, $return_tofunction_id,
#                             $parent_id, $child_id)
#
###########################################################################
sub add_parent_child {
  my ($lda, $end_user, $return_to_function_id, $parent_id, $child_id) = @_;


  #
  #  Make sure the user has picked a parent or child function.
  #
  my $msg;
  if ($parent_id eq '0') {
    $msg = "Error trying to add a new parent function: "
         . "You did not pick a parent function.<BR>";
  }
  if ($child_id eq '0') {
    $msg = "Error trying to add a new child function: "
         . "You did not pick a child function.<BR>";
  }

  #
  #  Call the stored procedure to create a new function parent/child link
  #
  unless ($msg) {
    my @stmt = 
	q{
	    BEGIN
               rolesapi_add_function_child (
                  :server_user, -- ai_server_user
                  :proxy_user,  -- ai_proxy_user
                  :parent_id,  -- ai_parent_id
                  :child_id  -- ai_child_id
               );
	    END;
	};

    #print @stmt;
    #print "<BR>";
   
    my $csr = $lda->prepare(@stmt)
	 || &web_error("Error preparing statement"
            . " (rolesapi_add_function_child)."
            . "<BR>" . $lda->errstr . "<BR>");
   
    my ($error_no, $error_msg, $sql_statement);

    $csr->bind_param(":server_user", $g_server_user);
    $csr->bind_param(":proxy_user", $end_user);
    $csr->bind_param(":parent_id", $parent_id);
    $csr->bind_param(":child_id", $child_id);
    #print "Before inout bind<BR>";

    #print "After last bind_param_inout...<BR>";
    $csr->execute;
    #print "After execute...<BR>";

    my $err = $lda->err;
    my $errstr = $lda->errstr;
    if ($g_show_tech_notes) { print "errstr='$errstr'<BR>"; }
  
    $errstr =~ /\: ([^\n]*)/;
  
    my $shorterr = $1;
 
    $csr->finish;
    #print "After finish (err='$err')...<BR>";

    if ($err) {
	# Error. Display the error message and put the form back up.
	$msg = "$shorterr Error Number $err";
    }
    else {
      if ($lda->commit) {
        $msg = "Function parent/child pair ($parent_id, $child_id)
                was successfully added.<p />";
      }
      else {
        $msg = "Error in \"commit\" step when trying to add function "
            . "parent/child pair "
            . $lda->errstr . "<BR>";
      }
    }
  }

  #
  #  Display the edit parent/child screen
  #
   &pre_edit_parent_child($lda, $return_to_function_id, $end_user, $msg);

}

###########################################################################
#
# Subroutine add_function_group_link($lda, $end_user, $parent_id, $child_id)
#
###########################################################################
sub add_function_group_link {
  my ($lda, $end_user, $parent_id, $child_id) = @_;

  #
  #  Make sure the user has picked a parent or child function.
  #
  my $msg;
  if ($parent_id eq '0') {
    $msg = "Error - function_group_id is blank.<BR>";
  }
  if ($child_id eq '0') {
    $msg = "Error trying to link a new function to a function group: "
         . "You did not pick a child function.<BR>";
  }

  #
  #  Call the stored procedure to create a new function parent/child link
  #
  unless ($msg) {
    my @stmt = 
	q{
	    BEGIN
               rolesapi_add_func_group_link (
                  :server_user, -- ai_server_user
                  :proxy_user,  -- ai_proxy_user
                  :parent_id,  -- ai_parent_id
                  :child_id  -- ai_child_id
               );
	    END;
	};

    #print @stmt;
    #print "<BR>";
   
    my $csr = $lda->prepare(@stmt)
	 || &web_error("Error preparing statement"
            . " (rolesapi_add_func_group_link)."
            . "<BR>" . $lda->errstr . "<BR>");
   
    my ($error_no, $error_msg, $sql_statement);

    $csr->bind_param(":server_user", $g_server_user);
    $csr->bind_param(":proxy_user", $end_user);
    $csr->bind_param(":parent_id", $parent_id);
    $csr->bind_param(":child_id", $child_id);
    #print "Before inout bind<BR>";

    #print "After last bind_param_inout...<BR>";
    $csr->execute;
    #print "After execute...<BR>";

    my $err = $lda->err;
    my $errstr = $lda->errstr;
    if ($g_show_tech_notes) { print "errstr='$errstr'<BR>"; }
  
    $errstr =~ /\: ([^\n]*)/;
  
    my $shorterr = $1;
 
    $csr->finish;
    #print "After finish (err='$err')...<BR>";

    if ($err) {
	# Error. Display the error message and put the form back up.
	$msg = "$shorterr Error Number $err";
    }
    else {
      if ($lda->commit) {
        $msg = "Function id $child_id was successfully linked to
                function group id $parent_id.<p />";
      }
      else {
        $msg = "Error in \"commit\" step when trying to link a new function "
            . "to a function group "
            . $lda->errstr . "<BR>";
      }
    }
  }

  #
  #  Display the edit parent/child screen
  #
   &pre_edit_function_group_link($lda, $parent_id, $end_user, $msg);

}

###########################################################################
#
# Subroutine remove_function_group_link($lda, $end_user, $parent_id, $child_id)
#
###########################################################################
sub remove_function_group_link {
  my ($lda, $end_user, $parent_id, $child_id) = @_;

  #
  #  Call the stored procedure to create a new function parent/child link
  #
  unless ($msg) {
    my @stmt = 
	q{
	    BEGIN
               rolesapi_del_func_group_link (
                  :server_user, -- ai_server_user
                  :proxy_user,  -- ai_proxy_user
                  :parent_id,  -- ai_parent_id
                  :child_id  -- ai_child_id
               );
	    END;
	};

    #print @stmt;
    #print "<BR>";
   
    my $csr = $lda->prepare(@stmt)
	 || &web_error("Error preparing statement"
            . " (rolesapi_del_func_group_link)."
            . "<BR>" . $lda->errstr . "<BR>");
   
    my ($error_no, $error_msg, $sql_statement);

    $csr->bind_param(":server_user", $g_server_user);
    $csr->bind_param(":proxy_user", $end_user);
    $csr->bind_param(":parent_id", $parent_id);
    $csr->bind_param(":child_id", $child_id);

    #print "After last bind_param_inout...<BR>";
    $csr->execute;
    #print "After execute...<BR>";

    my $err = $lda->err;
    my $errstr = $lda->errstr;
    if ($g_show_tech_notes) { print "errstr='$errstr'<BR>"; }
  
    $errstr =~ /\: ([^\n]*)/;
  
    my $shorterr = $1;
 
    $csr->finish;
    #print "After finish (err='$err')...<BR>";

    if ($err) {
	# Error. Display the error message and put the form back up.
	$msg = "$shorterr Error Number $err";
    }
    else {
      if ($lda->commit) {
        $msg = "Function id $child_id link was successfully removed from
                function group id $parent_id.<p />";
      }
      else {
        $msg = "Error in \"commit\" step when trying to delink a function "
            . "from a function group "
            . $lda->errstr . "<BR>";
      }
    }
  }

  #
  #  Display the edit parent/child screen
  #
   &pre_edit_function_group_link($lda, $parent_id, $end_user, $msg);

}

###########################################################################
#
# Subroutine pre_create_function($lda, $cat, $end_user)
#
###########################################################################
sub pre_create_function {
  my ($lda, $cat, $end_user) = @_;

 #
 #  Get a list of qualifier_types
 #
  my %qualtype2desc;
  &get_qualifier_types($lda, \%qualtype2desc);

 #
 #  Find out if the end user is authorized to maintain PA Functions
 #
  my $can_maint_pa_functions = &can_user_maint_pa_functions ($lda, $end_user);
  #$can_maint_pa_functions = 0;

 #
 #  Print the CGI form
 #
  print 
  "<form method=\"post\">
   <table>
   <tr><th $gray>Category:</th><td>$cat</td></tr>
   <tr><th $gray>Regular or<br>implied:</th>
       <td><input type=\"radio\" name=\"regular_or_implied\" value=\"R\"
            checked>Regular<br>
           <input type=\"radio\" name=\"regular_or_implied\" 
            value=\"I\">Implied/external
       </td></tr>
   <tr><th $gray>Function name:</th>
       <td><input type=\"text\" name=\"function_name\" size=30></td></tr>
   <tr><th $gray>Description:</th>
       <td><input type=\"text\" name=\"function_desc\" size=50></td></tr>
   <tr><th $gray>Qualifier type:</th>
   <td>
     <select name=\"qualifier_type\">";
  my $key;
  foreach $key (sort keys %qualtype2desc) {
      print "<option value=\"$key\">$key $qualtype2desc{$key}\n";
  }
  print
  " </select>
  </td></tr>";
  #$can_maint_pa_functions=0; # uncomment for testing
  if ($can_maint_pa_functions) {
    print 
    "<tr><th $gray>PA Function option:
          <br><small>(regular functions only)</small></th>
        <td>
          <input type=\"radio\" name=\"pa_option\" value=\"pa_authorizable\"> 
          Assignable by Primary Authorizer<br>";
    if ($cat eq 'SAP ') {
      print
          "<input type=\"radio\" name=\"pa_option\" 
            value=\"pa_authorizable_dlc\"> 
           DLC-limited assignable by Primary Authorizer Parent Function
           (for Approval functions for the Spending Group hierarchy)<br>";
    }
    if ($cat eq 'META') {
      print
          "<input type=\"radio\" name=\"pa_option\" value=\"pa_parent\"> 
           Primary Authorizer Parent Function (category must be META)<br>";
    }
    print 
          "<input type=\"radio\" name=\"pa_option\" value=\"pa_neither\" 
           checked> Neither a Primary Authorizer function nor assignable by
                   a Primary Authorizer
        </td></tr>
    <tr><th $gray>Primary Auth Group:
          <br><small>(regular functions only)</small></th>
        <td>
      <select name=\"pa_group\">
           <option selected value=\"NONE\">NONE None
           <option value=\"FIN\">FIN Grantable by financial Primary Authorizer
           <option value=\"HR\">HR  Grantable by HR Primary Authorizer
         </select></td></tr>";
  }
  else {
    print
    "<tr $gray>
     <td align=center colspan=2>You are not authorized to edit 
        primary-authorizer related fields. <small>To do so, you would need<br>
        an Authorization for the 
        function 'MAINT PRIMARY AUTH FUNCTION' in category META</small></td>
     </tr>";
    print 
    "<tr bgcolor=\"#AFAFAF\"><th>PA Function Option:</th>
        <td>
          <input type=\"hidden\" name=\"pa_option\" value=\"pa_neither\" 
           checked>Neither a Primary Authorizer function nor assignable by
                   a Primary Authorizer
        </td></tr>
    <tr $gray><th>Primary Auth Group:</th>
        <td>
          <input type=\"hidden\" name=\"pa_group\" value=\"NONE\" 
           checked> None
        </td></tr>";
  }
  print "<tr><th $gray>Function will be used in:<br>
                       <small>(implied/external functions only)</small></th>
         <td>
          <input type=\"radio\" name=\"pass_number\" value=\"1\" checked> 
          External authorizations fed 
          from Warehouse or other source (load pass = 1)<br>
          <input type=\"radio\" name=\"pass_number\" value=\"2\"> 
          Implied authorizations derived from rules (load pass = 2)";
  print "</td><tr>";

  print "</table>\n";
  print "<input type=\"hidden\" name=\"category\" value=\"$cat\">";
  print "<input type=\"hidden\" name=\"cgi_step\" value=\"create_function\">";
  print "<p /><input type=\"submit\" value=\"Create new Function\" 
          name=\"CreateFunction\">\n";
  print "</form>\n";
  print "&nbsp; &nbsp; &nbsp;";
  print "<form><input type=\"submit\" value=\"Cancel\" name=\"FunctionList\">
         <input type=\"hidden\" name=\"cgi_step\" value=\"function_list\">
         <input type=\"hidden\" name=\"category\" value=\"$cat\">
         </form>\n";
}

###########################################################################
#
#  Function get_detailed_group_info ($lda, $function_group_id)
#
#  Returns an array of fields related to the function group:
#   ($category, $fgid, $fgname, $fgdesc, $matches_function, $qualtype,
#      $fgmodified_by, $fgmodified_date, $child_function_list)
#  where $child_function_list is a comma-delimited list of child function
#    IDs
#
###########################################################################
sub get_detailed_group_info {
  my ($lda, $group_id) = @_;

 #
 #  Make sure $group_id is not used as a "hack" for SQL injection.
 #
  if (length($group_id) > 10) {
      $group_id = substr($group_id, 0, 10);
  }

 #
 #  Open a select statement
 #
  my $stmt1 = 
  "select fg.function_category, fg.function_group_id, function_group_name, 
     fg.function_group_desc, fg.matches_a_function, fg.qualifier_type,
     l.child_id, f.function_name, fg.modified_by, 
     to_char(fg.modified_date, 'Mon dd, yyyy')
    from function_group fg 
         left outer join function_group_link l
           on l.parent_id = fg.function_group_id
         left outer join function2 f
           on f.function_id = l.child_id
    where fg.function_group_id = $group_id
  order by fg.function_category, fg.function_group_id, fg.function_group_name";
  #print "stmt 1 = '$stmt1'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt1)) {
      print "Error preparing pre_edit_group select: " . $DBI::errstr . "<BR>";
  }

  unless ($csr1->execute) {
      print "Error executing pre_edit_group select: " . $DBI::errstr . "<BR>";
  }

 #
 #  Get results from the SELECT statement
 #
  my ($tcategory, $tfgid, $tfgname, $tfgdesc, $tmatches_function, $tqualtype,
      $tfid, $tfname, $tfgmodified_by, $tfgmodified_date);
  my ($category, $fgid, $fgname, $fgdesc, $matches_function, $qualtype,
      $fid, $fname, $fgmodified_by, $fgmodified_date);
  my @fid_list;
  my $first_time = 1;
  my $link_count = 0;  
  while 
   ( ($tcategory, $tfgid, $tfgname, $tfgdesc, $tmatches_function, $tqualtype,
      $tfid, $tfname, $tfgmodified_by, $tfgmodified_date)
      = $csr1->fetchrow_array )
  {
    if ($tfid) {
      push(@fid_list, $tfid);
      $link_count++;
    }
    if ($first_time) {
      $first_time = 0;
      ($category, $fgid, $fgname, $fgdesc, $matches_function, $qualtype,
       $fid, $fname, $fgmodified_by, $fgmodified_date) =
      ($tcategory, $tfgid, $tfgname, $tfgdesc, $tmatches_function, $tqualtype,
       $tfid, $tfname, $tfgmodified_by, $tfgmodified_date);
    }
  }

  #
  #  Join the child function IDs to create a comma-delimited list
  #
  my $child_function_list = join(',', @fid_list);

  #
  #  Return the array of info about the function_group
  #
  return ($category, $fgid, $fgname, $fgdesc, $matches_function, $qualtype,
    $fid, $fname, $fgmodified_by, $fgmodified_date, $child_function_list);

}

###########################################################################
#
# Subroutine pre_edit_group($lda, $group_id, $end_user)
#
###########################################################################
sub pre_edit_group {
  my ($lda, $group_id, $end_user) = @_;

  #
  #  Show navigation bar
  #
   &print_menu('');  

  #
  #  Get information about this function_group
  #
  my ($category, $fgid, $fgname, $fgdesc, $matches_function, $qualtype,
        $fid, $fname, $fgmodified_by, $fgmodified_date, $child_function_list)
    = &get_detailed_group_info ($lda, $group_id);
  my @fid_list = split(',', $child_function_list);
  my $link_count = @fid_list;

  #
  #  Get a hash of categories indicating where the end user can
  #  maintain rules (and function groups)
  #
  my %ruleable_category;
  &get_ruleable_categories($lda, $end_user, \%ruleable_category);

  #
  #  Get a list of qualifier_types
  #
  my %qualtype2desc;
  &get_qualifier_types($lda, \%qualtype2desc);

  #
  #  Indicate whether the user can maintain this function group
  #
  my $can_maintain = ($ruleable_category{$category}) ? 1 : 0;
  my $are_are_not = ($can_maintain) ? "are"
                                    : "are not";
  my $are_auth_message = 
   "<small>You ($end_user)<br>$are_are_not<br>authorized<br>to 
    edit<br>this function group.</small>";

  #
  #  Build a string for displaying an "Update Function" button.  If 
  #  the user is not authorized to do updates, then make it a 
  #  non-breaking space rather than a button.
  #
  my $update_button;
  if ($can_maintain) {
    $update_button = 
      "<input type=hidden name=\"cgi_step\" value=\"edit_function_group\">
       <input type=submit value=\"Update function group\">";
  }
  else {
      $update_button = $are_auth_message;
  }

  #
  #  Start displaying information about this function group
  #
  my $rows_to_span = 5;
  print "<table border>\n";
  print "<form>\n";
  print "<tr><th $gray>Function Group ID</th>
         <td>$fgid
         <input type=\"hidden\" name=\"function_group_id\" 
          value=\"$fgid\"></td>
         <td align=center rowspan=$rows_to_span>$update_button</td>
         </tr>\n";

  #
  #  Get no. of referenced rules
  #
  my %fgid2rule_count;
  &get_group_to_rule_count($lda, \%fgid2rule_count, $fgid);
  my $rule_count = $fgid2rule_count{$fgid};

  #
  #  If the user is authorized to edit Functions Groups in this category
  #  and there are no linked Functions
  #  and there are no rules referencing this function group, then
  #  show a list of other categories to which the Function Group
  #  could be reassigned.
  #
  #
  #$link_count = 0;
  if ($can_maintain && $link_count == 0 && $rule_count == 0) {
    print "<tr><th $gray>Category</th><td><select name=\"category\">";
    foreach $key (sort keys %ruleable_category) {
       my $is_selected = ($key eq $category) ? "selected" : "";
       print "<option $is_selected 
               value=\"$key\">$key ($ruleable_category{$key})";
    }
    print "</select></td></tr>\n";
  }

  #
  #  Else (user is not authorized to edit Functions in this category) show
  #  category, function_name, and function_decription as non-editable fields.
  #
  else {
    print "<tr><th $gray>Category</th>
           <td>$category  <input type=\"hidden\" name=\"category\" 
                   value=\"$category\"></td></tr>\n";
  }

  #
  #  Allow the user to edit the Function_name and Function_description
  #  fields.
  #
  print "<tr><th $gray>Function group name</th>"
          . "<td><input type=\"text\" name=\"function_group_name\" 
                   value=\"$fgname\"  size=30></td>\n";
  print "<tr><th $gray>Function group description</th>"
          . "<td><input type=\"text\" name=\"function_group_desc\" 
                   value=\"$fgdesc\"  size=70></td>\n";

  #
  #  If there are no linked functions for this function_group, then display a 
  #  list of Qualifier types
  #
  if ($can_maintain && $link_count == 0 && $rule_count == 0) {
    print "<tr><th $gray>Qualifier type</th>
           <td><select name=\"qualifier_type\">";
    foreach $key (sort keys %qualtype2desc) {
	my $is_selected = ($key eq $qualtype) ? "selected" : "";
        print "<option $is_selected 
                value=\"$key\">$key ($qualtype2desc{$key})";
    }
    print "</select></td></tr>\n";
  }

  #
  #  Else show qualifier_type as a non-editable field
  #
  else {
    print "<tr><th $gray>Qualifier type</th>
               <td>$qualtype <input type=\"hidden\" 
                   name=\"qualifier_type\" 
                   value=\"$qualtype\"></td></tr>\n";
  }

  #
  #  Show count of referenced rules, modified_by, modified_date
  #
  print "<tr $gray><th colspan=2>&nbsp;</th>
             <td $gray rowspan=5>&nbsp;</td></tr>\n";
  print "<tr><th $gray># rules referenced</th><td>$rule_count</td></tr>\n";
  print "<tr><th $gray>Modified date</th><td>$fgmodified_date</td></tr>\n";
  print "<tr><th $gray>Modified by</th><td>$fgmodified_by</td></tr>\n";

  #
  #  Build a string for displaying an "Edit Parent/Child Pairs..." button.  
  #  If the user is not authorized to do updates, then make it a 
  #  non-breaking space rather than a button.
  #
  my $edit_child_button = 
      "<form>
       <input type=hidden name=\"cgi_step\" 
              value=\"pre_edit_function_group_link\">
       <input type=hidden name=\"function_group_id\" value=\"$fgid\">
       <input type=submit value=\"Edit linked functions...\">
       </form>";

  #
  #  Close out the first form
  #
  print "</form>";


  #
  # Show linked functions
  #
   my $total_rows = ($link_count) ? $link_count + 1 : 1;
   print 
     "<tr><th colspan=2 $gray>&nbsp;</th></tr>\n";
   print "<tr><th $gray>Linked functions</th>";
   if ($link_count > 0) {
       print "<td><table border>
                         <tr><th>Category</th><th>Function ID</th>
                         <th>Function name</th><tr>";
       for ($i=0; $i<$link_count; $i++) {
         my ($function_cat, $function_name) 
	     = &get_function_cat_and_name($lda, $fid_list[$i]);
         print "<tr><td>$function_cat</td><td>$fid_list[$i]</td>
                <td>$function_name</td>";
         print "</tr>";
       }
       print "</table></td>";
       print "<td rowspan=2>&nbsp;<BR>$edit_child_button</td>";
       print "</tr>";
   }
   else {
       print "<td>(none)</td>
              <td rowspan=2>&nbsp;<BR>$edit_child_button</td>";
       print "</tr>";
   }

  #
  #  Print end of the table
  #
  print "</table>\n";
  print "</form>\n";


  #
  # If there are no existing Authorizations for this function, and if
  #   user is authorized to edit functions in this category, show a 
  #   "delete" button.
  #
  if ($rule_count == 0 && $can_maintain) {
      print "<center>";
      #print "fgid='$fgid'<BR>";
      &print_delete_group_button($fgid);
      print "</center>";
  }
  elsif ($can_maintain) {
      print "<center><small>";
      print "Function group cannot be deleted &#150;<br>";
      if ($rule_count) {
	  print "It is referenced by $rule_count rule(s).<BR>";
      }
      print "</small></center>";
  }

  #
  # Print a button to get back to the function group display
  #
    &print_group_list_button();

}

###########################################################################
#
# Subroutine pre_create_group($lda, $end_user)
#
###########################################################################
sub pre_create_group {
  my ($lda, $group_id, $end_user) = @_;

  print "In pre_create_group<BR>";

  #
  #  Get a hash of categories indicating where the end user can
  #  maintain rules (and function groups)
  #
  my %ruleable_category;
  &get_ruleable_categories($lda, $end_user, \%ruleable_category);

  #
  #  Get a list of qualifier_types
  #
  my %qualtype2desc;
  &get_qualifier_types($lda, \%qualtype2desc);

  #
  #  Start displaying the form
  #
  print "<form>\n";
  print "<input type=\"hidden\" name=\"cgi_step\" 
          value=\"create_function_group\">";
  print "<table border>\n";

  #
  #  Show a list of categories the user is authorized to choose
  #
  print "<tr><th $gray>Category</th><td><select name=\"category\">";
  foreach $key (sort keys %ruleable_category) {
       my $is_selected = ($key eq $category) ? "selected" : "";
       print "<option $is_selected 
               value=\"$key\">$key ($ruleable_category{$key})";
  }
  print "</select></td></tr>\n";

  #
  #  Allow the user to edit the Function_name and Function_description
  #  fields.
  #
  print "<tr><th $gray>Function group name</th>"
          . "<td><input type=\"text\" name=\"function_group_name\" 
                   value=\"$fgname\"  size=30></td>\n";
  print "<tr><th $gray>Function group description</th>"
          . "<td><input type=\"text\" name=\"function_group_desc\" 
                   value=\"$fgdesc\"  size=70></td>\n";

  #
  #  If there are no linked functions for this function_group, then display a 
  #  list of Qualifier types
  #
  print "<tr><th $gray>Qualifier type</th>
         <td><select name=\"qualifier_type\">";
  foreach $key (sort keys %qualtype2desc) {
      my $is_selected = ($key eq $qualtype) ? "selected" : "";
      print "<option $is_selected 
              value=\"$key\">$key ($qualtype2desc{$key})";
  }
  print "</select></td></tr>\n";
  
  #
  #  Close out the form
  #
  print "</form>";

  #
  #  Print end of the table
  #
  print "</table>\n";

  #
  #  Print the "Create function group" button and close the form.
  #
  print "<p /><table width=\"70%\"><tr><td width=\"30%\">&nbsp;</td>
         <td>
         <input type=\"submit\" value=\"Create new Function Group\" 
          name=\"CreateGroup\"></td></tr></table>\n";
  
  print "</form>\n";

  #
  # Print a button to get back to the function group display
  #
  print "<p />";
  &print_group_list_button();

}

###########################################################################
#
# Subroutine pre_edit_parent_child($lda, $function_id, $end_user, $msg)
#
###########################################################################
sub pre_edit_parent_child {
  my ($lda, $function_id, $end_user, $msg) = @_;

 #
 #  Get information about this function, and a hash of function_ids and their 
 #   parent function_ids.
 #
  &get_functions($lda, '', $function_id);
  my $cat = $fcategory[0];
  my $auth_count = $fauth_count[0];

 #
 #  If there is a message, print it
 #
  if ($msg) {
      print "<big><font color=\"red\">$msg</font></big><BR>\n";
  }

 #
 #  Start displaying information about this function
 #
  print "<table border>\n";
  print "<tr $gray><th>Function<br>ID</th><th>Category</th>
                   <th>Function name</th><th>Description</th>
                   <th>Qualifier<br>type</th></tr>";
  print "<tr><td>$function_id</td><td>$cat</td>
             <td>$fname[0]</td><td>$fdesc[0]</td>
             <td align=center>$fqualtype[0]</td></tr>";
  print "</table>";
  print "<p />&nbsp;<p />";
  print "<table border>";

 #
 # Get eligible parent functions
 #
  my @eligible_parent_fid;
  my %pfid2cat;
  my %pfid2name;
  &get_eligible_parent_functions($lda, $end_user, $fqualtype[0], $function_id, 
                           \@eligible_parent_fid, \%pfid2cat, \%pfid2name);

 #
 # Get eligible child functions
 #
  my @eligible_child_fid;
  my %cfid2cat;
  my %cfid2name;
  &get_eligible_child_functions($lda, $end_user, $fqualtype[0], $function_id, 
                           \@eligible_child_fid, \%cfid2cat, \%cfid2name);

  #
  # Show parent functions
  #
   my $p_add_button = "<input type=\"submit\" value=\"Add\" 
          name=\"AddParent\">";
   my $function_id = $fid[0];
   #print "parent_list = $fid2parent_id{$function_id}<BR>";
   my @parent_function_id = split("!", $fid2parent_id{$function_id});
   my $num_parents = @parent_function_id;
   my @child_function_id = split("!", $fid2child_id{$function_id});
   my $num_children = @child_function_id;
   my $total_columns = ($num_children) ? $num_children : 1;
   $total_columns += ($num_parents) ? $num_parents : 1;
   $total_columns++;
   print "<tr><th $gray>Parent functions</th>";
   print "<td><table border width=\"100%\">
               <tr><th>Category</th><th>Function name</th>
                                <th>Function ID</th><th>&nbsp;</th><tr>";
   for ($i=0; $i<$num_parents; $i++) {
     my ($parent_cat, $parent_name) 
         = &get_function_cat_and_name($lda, $parent_function_id[$i]);
     my $p_remove_string = 
	 &gen_remove_parent_button($parent_function_id[$i], $function_id);
     print "<tr><td>$parent_cat</td><td>$parent_name</td>
                <td>$parent_function_id[$i]</td><td>$p_remove_string</td>";
     print "</tr>";
   }
   print "<tr><td colspan=4>";
   print "<form>
          <input type=hidden name=\"cgi_step\" value=\"add_parent_child\">
          <input type=hidden name=\"child_id\" value=\"$function_id\">
          <input type=hidden name=\"return_id\" value=\"$function_id\">";
   print "<select name=\"parent_id\">";
   my $pfid;
   print "<option value=\"0\" selected>Pick an additional parent function";
   foreach $pfid (@eligible_parent_fid) {
     print "<option value=\"$pfid\">$pfid2cat{$pfid}: $pfid2name{$pfid}"
           . " ($pfid)";
   }
   print "</select> &nbsp; &nbsp; $p_add_button </form></td></tr>";
   print "</table></td></tr>";


  #
  # Show child functions
  #
   my $c_add_button = "<input type=\"submit\" value=\"Add\" 
          name=\"AddChild\">";
   #print "child_list = $fid2child_id{$function_id}<BR>";
   print "<tr><th $gray>Child functions</th>";
   print "<td><table border width=\"100%\"><tr><th>Category</th>
                         <th>Function name</th>
                         <th>Function ID</th><th>&nbsp;</th><tr>";
   for ($i=0; $i<$num_children; $i++) {
         my ($child_cat, $child_name) 
	     = &get_function_cat_and_name($lda, $child_function_id[$i]);
         my $c_remove_string = 
	   &gen_remove_child_button($function_id, 
                       $function_id, $child_function_id[$i]);
         print "<tr><td>$child_cat</td>
                <td>$child_name</td><td>$child_function_id[$i]</td>
                <td>$c_remove_string</td></tr>";
   }
   print "<tr><td colspan=4>";
   print "<form>
          <input type=hidden name=\"cgi_step\" value=\"add_parent_child\">
          <input type=hidden name=\"parent_id\" value=\"$function_id\">
          <input type=hidden name=\"return_id\" value=\"$function_id\">";
   print "<select name=\"child_id\">";
   my $cfid;
   print "<option value=\"0\" selected>Pick an additional child function";
   foreach $cfid (@eligible_child_fid) {
       print "<option value=\"$cfid\">$cfid2cat{$cfid}: $cfid2name{$cfid} 
              ($cfid)";
   }
   print "</select> &nbsp; &nbsp; $c_add_button </form></td></tr>";
   print "</table></td></tr>";

  #
  #  Print end of the table
  #
  print "</table>\n";
  print "</form>\n";


  #
  # Print navigation buttons
  #
  print "<p />";
  print "<table width=\"50%\">";
  print "<tr>";
  print "</td><td>";
  print "<form><input type=\"submit\" value=\"Done\" 
                 name=\"EditParentChild\">
         <input type=\"hidden\" name=\"cgi_step\" 
          value=\"pre_edit_function\">
         <input type=\"hidden\" name=\"function_id\" 
              value=\"$function_id\">
         </form>\n";
  print "</td>";
  print "<td>";
  &print_function_list_button($cat);
  print "</td></tr>";
  print "</table>\n";

}

###########################################################################
#
# Subroutine pre_edit_function_group_link($lda, $group_id, $end_user, $msg)
#
###########################################################################
sub pre_edit_function_group_link {
  my ($lda, $group_id, $end_user, $msg) = @_;

  #print "In pre_edit_function_group_link<BR>";

 #
 #  Get information about this function_group
 #
  my ($category, $fgid, $fgname, $fgdesc, $matches_function, $qualtype,
        $fid, $fname, $fgmodified_by, $fgmodified_date, $child_function_list)
    = &get_detailed_group_info ($lda, $group_id);
  my @fid_list = split(',', $child_function_list);
  my $link_count = @fid_list;

 #
 #  If there is a message, print it
 #
  if ($msg) {
      print "<big><font color=\"red\">$msg</font></big><BR>\n";
  }

 #
 #  Start displaying information about this function group
 #
  print "<table border>\n";
  print "<tr $gray><th>Function<br>Group<br>ID</th>
                   <th>Category</th>
                   <th>Function group name</th>
                   <th>Description</th>
                   <th>Qualifier<br>type</th></tr>";
  print "<tr><td>$group_id</td>
             <td>$category</td>
             <td>$fgname</td>
             <td>$fgdesc</td>
             <td align=center>$qualtype</td></tr>";
  print "</table>";
  print "<p />&nbsp;<p />";
  print "<table border>";

 #
 # Get eligible child functions for this function group
 #
  my @eligible_child_fid;
  my %cfid2cat;
  my %cfid2name;
  &get_eligible_group_child_functions($lda, $end_user, $qualtype, $group_id,
                           \@eligible_child_fid, \%cfid2cat, \%cfid2name);

  #
  # Show child functions
  #
   my $c_add_button = "<input type=\"submit\" value=\"Add\" 
          name=\"AddGroupLink\">";
   #print "child_list = $child_function_list<BR>";
   print "<tr><th $gray>Linked functions</th>";
   print "<td><table border width=\"100%\"><tr><th>Category</th>
                         <th>Function name</th>
                         <th>Function ID</th><th>&nbsp;</th><tr>";
   for ($i=0; $i<$link_count; $i++) {
         #print "i='$i' fid='$fid_list[$i]'<BR>";
         my ($child_cat, $child_name) 
	     = &get_function_cat_and_name($lda, $fid_list[$i]);
         my $c_remove_string = 
	   &gen_remove_group_link_button($group_id, $fid_list[$i]);
         print "<tr><td>$child_cat</td>
                <td>$child_name</td><td>$fid_list[$i]</td>
                <td>$c_remove_string</td></tr>";
   }
   print "<tr><td colspan=4>";
   print "<form>
          <input type=hidden name=\"cgi_step\" 
           value=\"add_function_group_link\">
          <input type=hidden name=\"parent_id\" value=\"$group_id\">";
   print "<select name=\"child_id\">";
   my $cfid;
   print "<option value=\"0\" selected>Pick an additional child function";
   foreach $cfid (@eligible_child_fid) {
       print "<option value=\"$cfid\">$cfid2cat{$cfid}: $cfid2name{$cfid} 
              ($cfid)";
   }
   print "</select> &nbsp; &nbsp; $c_add_button </form></td></tr>";
   print "</table></td></tr>";

  #
  #  Print end of the table
  #
  print "</table>\n";
  print "</form>\n";


  #
  # Print navigation buttons
  #
  print "<p />";
  print "<table width=\"50%\">";
  print "<tr>";
  print "</td><td>";
  print "<form><input type=\"submit\" value=\"Done\">
         <input type=\"hidden\" name=\"cgi_step\" 
          value=\"pre_edit_group\">
         <input type=\"hidden\" name=\"function_group_id\" 
              value=\"$group_id\">
         </form>\n";
  print "</td>";
  print "<td>";
  &print_group_list_button();
  print "</td></tr>";
  print "</table>\n";

}


###########################################################################
#
# Subroutine display_function_list ($dbh, $category, $end_user)
#
###########################################################################
sub display_function_list {
  ($lda, $cat, $end_user) = @_;

 #
 #  Show navigation bar
 #
  &print_menu('');  

 #
 #  Get a list of functions, and a hash of function_ids and their 
 #   parent function_ids.
 #
  &get_functions($lda, $cat, '');
 
 #
 # Get information about categories.  
 #
  my %cat2desc;
  my %cat2function_count;
  my %cat2group_count;
  my %cat2imp_function_count;
  my %cat2can_maint_function;
  $cat = substr($cat . "    ", 0, 4);  # Make sure category is 4 characters
  &get_categories ($lda, $end_user, '', \%cat2desc, 
                   \%cat2function_count, 
                   \%cat2imp_function_count, 
                   \%cat2can_maint_function,
                   \%cat2group_count);

 #
 #  Print navigation bar for category list
 #
  my $cat_nospace;
  print "<small>Go to category:";
  my $url_for_cat;
  foreach $temp_cat (sort keys %cat2desc) {
      $url_for_cat = $url_stem . "cgi_step=function_list&category=$temp_cat";
      $cat_nospace = &strip($temp_cat);
      if ($temp_cat eq $cat) {
        print "&nbsp;<font color=gray>$cat_nospace</font>";
      }
      else {
        print "&nbsp; <a href=\"$url_for_cat\">$cat_nospace</a>";
      }
  }
  print "</small><p />";

 #
 #  Start printing the web page
 #
  my $category = $cat2desc{$cat};
  if ($cat eq 'ALL') {
    print "<H3>Functions</H3>";
  }
  else {
    print "<H3>Functions within category $cat ($category)</H3>\n";
  }
  print "<p />\n";

 #
 #  Indicate whether or not the user can create new Functions in this
 #  category.  If so, show a link for creating a new Function.
 #
  my $can_maint_functions = $cat2can_maint_function{$cat};
  if ($can_maint_functions eq 'Y') {
    print "<center>You (user $end_user) are authorized to create new Functions
           in category $cat.</center><p />";
    &print_new_function_button($cat);
  }
  else {
    print "<center>You (user $end_user) are <i>not</i> authorized to 
           create new Functions in category $cat.</center><p />";
  }
  

 #
 #  Get a list of Primary Auth groups
 #
  my @pa_group = ();
  my %pa_group2web_desc = ();
  &get_pa_groups($lda, \@pa_group, \%pa_group2web_desc); 


 #
 # Get PA group titles by calling 
 #  &get_pa_group_columns(\@pa_group, \%pa_group2web_desc, 'TITLE');
 #
  my $last_columns = 
    &get_pa_group_columns(\@pa_group, \%pa_group2web_desc, 'TITLE', '', '');

 #
 #  Print a table of functions
 #
 $n = @fid;  # How many functions?
 print "<table border>", "\n";
 print "<tr align=left>";
 if ($cat eq 'ALL') {
     print "<th rowspan=2>Category</th>";
 }
 print "<th rowspan=2>&nbsp;</th>"
       . "<th rowspan=2>Func.<br>ID</th>"
       . "<th rowspan=2 $g_bg_yellow>Imp-<br>lied</th>"
       . "<th rowspan=2>Function Name</th>"
       . "<th rowspan=2>Qualifier Type</th>"
       . "<th rowspan=2>Child<br>Func.<br>IDs <sup>1</sup></th>"
       . "<th rowspan=2>Parent<br>Func.<br>IDs <sup>2</sup></th>"
       . "<th rowspan=2>Modified date/<br>Modified by</th>"
       . "<th rowspan=2>Curr-<br>ent<br># of<br>auths.</th>"
       . "<th rowspan=2># of<br>ref'd<br>rules /<br>groups</th>"
       . "<th colspan=3>Primary Authorizer related</th></tr>";
 print "<tr><th>Is<br>PA<br>function</th><th>Grant-<br>able by<br>PA</th>"
       . "<th>PA Group</th></tr>";
 #      . "$last_columns</tr>";

 my $edit_button;
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
    if ($can_maint_functions eq 'Y') {
	$edit_button = 
           "<form action=\"$url_stem\">
           <input type=hidden name=\"cgi_step\" value=\"pre_edit_function\">
           <input type=hidden name=\"function_id\" value=\"$fid[$i]\">
           <input type=submit value=\"Edit\">
         </form>";
    }
    else {
        $edit_button = "&nbsp;";
    }
    my $color = ($f_implied[$i] eq 'Yes') ? $g_bg_yellow : '';
    print "<tr align=left>";
    if ($cat eq 'ALL') {
	print "<td>$fcategory[$i]</td>";
    }
    my $pa_group = $fpagroup[$i];
    unless ($pa_group) {$pa_group = "&nbsp;";}
    my $pa_parent = $fpa_parent[$i];
    unless ($pa_parent eq 'Yes') {$pa_parent = "&nbsp;";}
    my $rule_count = ($frule_count[$i]) ? $frule_count[$i] : 0;
    my $group_count = ( $fid2group_count{$fid[$i]} )
                       ? $fid2group_count{$fid[$i]} : 0;
    print "<td valign=bottom>$edit_button</td>"
        . "<td>$fid[$i]</td>"
        . "<td $color>$f_implied[$i]</td>"
        . "<td $color>$fname[$i]<br><small>$fdesc[$i]</small></td>"
        . "<td>$fqualtype[$i]<br><small>$fqtdesc[$i]</small></td>"
        . "<td>$child_id_list</td><td>$parent_id_list</td>"
        . "<td>$fmoddate[$i]<br>$fmodby[$i]</td>"
	. "<td align=right>$fauth_count[$i]</td>"
	. "<td align=right>$rule_count / $group_count</td>"
        . "<td>$pa_parent</td><td>$fpauthable[$i]</td>"
        . "<td>$pa_group</td></tr>\n";
    #    . "$last_columns</tr>\n";
    #printf "<tr><td> </td></tr>\n",
 }
 print "</TABLE>", "\n";

 #
 #  If user is authorized to create new functions in this category, 
 #  show a link for creating a new Function.
 #
  if ($can_maint_functions eq 'Y') {
    print "<p />";
    &print_new_function_button($cat);
  }

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
 #  If the category was 'ALL', then also print a table of functions
 #  and their related department codes
 #
 if ($cat eq 'ALL') {
    my %function2dept_list;
    &get_dept_based_function($lda, \%function2dept_list);
    print "<p /><h3>Table 2: List of DLC-based Functions and the DLCs
                to which they apply</h3><p />\n";
    print "<table border>\n";
    print "<tr><th>Function name</th><th>DLCs to which it applies</th></tr>\n";
    foreach $key (sort keys %function2dept_list) {
	my @dlc_list = split(",", $function2dept_list{$key});
        $rows = @dlc_list;
        print "<tr><td colspan=2>&nbsp;</td></tr>\n";
        print "<tr><td rowspan=$rows valign=top>$key</td>
               <td>$dlc_list[0]</td></tr>\n";
        for ($i=1; $i < $rows; $i++) {
            print "<tr><td>$dlc_list[$i]</td></tr>\n";
        }
    }
    print "</table>";
 }

}

###########################################################################
#
# Subroutine display_auths_for_a_function ($dbh, $function_id, $end_user)
#
# Not implemented yet.
#
###########################################################################
sub display_auths_for_a_function {
  ($lda, $function_id, $end_user) = @_;

 #
 #  Show navigation bar
 #
  &print_menu('');  

 #
 #  Get function_category for this function
 #

 #
 #  Check user's authority to view authorizations in this category
 # 

 #
 #  Get authorizations information and display it
 #

 #
 #  Display a button to get to a list of functions in this category
 #
  return();
}

###########################################################################
#
# Subroutine bad_step_error ($cgi_step)
#
###########################################################################
sub bad_step_error {
  my ($cgi_step) = @_;
  print "Error - invalid cgi_step parameter: '$cgi_step'<br>"
        . "Contact the help desk.<br>";
}

###########################################################################
#
# Function &sort_function_ids_by_name(\@fid_list)
#
# Sorts the function IDs by corresponding categories and function_names.
# Before running this, you must run &get_functions to populate the hash
# %fid2index and the arrays @fcategory and @fname.
#
###########################################################################
sub sort_function_ids_by_name {
  my ($rfid_list) = @_;
  my $delim = "!";
  my @cat_name_id;
  my $fid;
  my $item;
  foreach $fid (@$rfid_list) {
    $idx = $fid2index{$fid};  # Get the index within the arrays
    $item = $fcategory[$idx] . $delim . $fname[$idx] . $delim
	. $fid;
    push(@cat_name_id, $item);
  }
  my @sort_cat_name_id = sort @cat_name_id;
  my $ntest = @sort_cat_name_id;
  my @sort_fid;
  foreach $item (@sort_cat_name_id) {
      my ($ffcat, $ffname, $ffid) = split($delim, $item);
      push(@sort_fid, $ffid);
  }
  return @sort_fid;
}

###########################################################################
#
# Subroutine print_new_function_button($cat)
#
###########################################################################
sub print_new_function_button {
  my ($cat) = @_;
  #my $url_for_new_function 
  #         = $url_stem . "cgi_step=pre_create_function&category=$cat";

  print "<form action=\"$url_stem\">
           <input type=hidden name=\"cgi_step\" value=\"pre_create_function\">
           <input type=hidden name=\"category\" value=\"$cat\">
           <center>
           <input type=submit value=\"Create a new function\">
           </center>
         </form>";
}

###########################################################################
#
# Subroutine print_new_function_group_button($cat)
#
###########################################################################
sub print_new_function_group_button {
  my ($cat) = @_;

  print "<form action=\"$url_stem\">
           <input type=hidden name=\"cgi_step\" value=\"pre_create_group\">
           <center>
           <input type=submit value=\"Create a new function group\">
           </center>
         </form>";
}

###########################################################################
#
# Function gen_remove_child_button($parent_id, $child_id)
#  returns a string containing a form with submit button to remove
#  a parent/child function pair.
#
###########################################################################
sub gen_remove_child_button {
  my ($return_id, $parent_id, $child_id) = @_;
  my $string =
        "<form action=\"$url_stem\">
           <input type=hidden name=\"cgi_step\" 
            value=\"pre_remove_parent_child\">
           <input type=hidden name=\"parent_id\" value=\"$parent_id\">
           <input type=hidden name=\"return_id\" value=\"$parent_id\">
           <input type=hidden name=\"child_id\" value=\"$child_id\">
           <input type=submit value=\"Remove\">
         </form>";
  return $string;
}

###########################################################################
#
# Function gen_remove_group_link_button($parent_id, $child_id)
#  returns a string containing a form with submit button to remove
#  a parent/child function pair.
#
###########################################################################
sub gen_remove_group_link_button {
  my ($parent_id, $child_id) = @_;
  my $string =
        "<form action=\"$url_stem\">
           <input type=hidden name=\"cgi_step\" 
            value=\"pre_remove_group_link\">
           <input type=hidden name=\"parent_id\" value=\"$parent_id\">
           <input type=hidden name=\"child_id\" value=\"$child_id\">
           <input type=submit value=\"Remove\">
         </form>";
  return $string;
}

###########################################################################
#
# Function gen_remove_parent_child_button2($return_id, $parent_id, $child_id)
#  returns a string containing a form with submit button to remove
#  a parent/child function pair.
#
###########################################################################
sub gen_remove_parent_child_button2 {
  my ($return_id, $parent_id, $child_id) = @_;
  my $string =
        "<form action=\"$url_stem\">
           <input type=hidden name=\"cgi_step\" 
            value=\"remove_parent_child\">
           <input type=hidden name=\"parent_id\" value=\"$parent_id\">
           <input type=hidden name=\"return_id\" value=\"$return_id\">
           <input type=hidden name=\"child_id\" value=\"$child_id\">
           <input type=submit value=\"Remove parent/child link\">
         </form>";
  return $string;
}

###########################################################################
#
# Function gen_remove_group_link_button2($parent_id, $child_id)
#  returns a string containing a form with submit button to remove
#  a function_group/function link.
#
###########################################################################
sub gen_remove_group_link_button2 {
  my ($parent_id, $child_id) = @_;
  my $string =
        "<form action=\"$url_stem\">
           <input type=hidden name=\"cgi_step\" 
            value=\"remove_group_link\">
           <input type=hidden name=\"parent_id\" value=\"$parent_id\">
           <input type=hidden name=\"child_id\" value=\"$child_id\">
           <input type=submit value=\"Remove (function_group, function) link\">
         </form>";
  return $string;
}

###########################################################################
#
# Subroutine gen_remove_parent_button($parent_id, $child_id)
#
###########################################################################
sub gen_remove_parent_button {
  my ($parent_id, $child_id) = @_;
  my $string = 
       "<form action=\"$url_stem\">
           <input type=hidden name=\"cgi_step\" 
            value=\"pre_remove_parent_child\">
           <input type=hidden name=\"parent_id\" value=\"$parent_id\">
           <input type=hidden name=\"child_id\" value=\"$child_id\">
           <input type=hidden name=\"return_id\" value=\"$child_id\">
           <input type=submit value=\"Remove\">
         </form>";
  return $string;
}

###########################################################################
#
# Subroutine print_function_list_button($cat)
#
###########################################################################
sub print_function_list_button {
  my ($cat) = @_;
  #my $url_for_new_function 
  #         = $url_stem . "cgi_step=pre_create_function&category=$cat";

  print "<form>
           <input type=hidden name=\"cgi_step\" value=\"function_list\">
           <input type=hidden name=\"category\" value=\"$cat\">
           <input type=submit value=\"Function list\">
         </form>";
}

###########################################################################
#
# Subroutine print_group_list_button
#
###########################################################################
sub print_group_list_button {

  print "<form>
           <input type=hidden name=\"cgi_step\" 
                  value=\"display_function_groups\"\>
           <input type=submit value=\"Display all function groups\">
         </form>";
}

###########################################################################
#
# Subroutine print_category_list_button($cat)
#
###########################################################################
sub print_category_list_button {

  print "<form action=\"$url_stem\">
           <input type=hidden name=\"cgi_step\" value=\"category_list\">
           <input type=submit value=\"Show table of categories\">
         </form>";
}

###########################################################################
#
# Subroutine print_category_hierarchy_button($cat)
#
###########################################################################
sub print_category_hierarchy_button {

  print "<form action=\"$url_stem\">
           <input type=hidden name=\"cgi_step\" 
            value=\"tree_view_cat_function\">
           <input type=submit value=\"Tree view of categories and functions\">
         </form>";
}

###########################################################################
#
# Subroutine print_delete_group_button($function_group_id)
#
###########################################################################
sub print_delete_group_button {
  my ($function_group_id) = @_;

  print "<form action=\"$url_stem\">
          <input type=hidden name=\"cgi_step\" value=\"pre_delete_group\">
          <input type=hidden name=\"function_group_id\" 
                                   value=\"$function_group_id\">
          <input type=submit value=\"Delete this function group\">
         </form>";
}

###########################################################################
#
# Subroutine print_delete_function_button($function_id)
#
###########################################################################
sub print_delete_function_button {
  my ($function_id) = @_;

  print "<form action=\"$url_stem\">
           <input type=hidden name=\"cgi_step\" value=\"pre_delete_function\">
           <input type=hidden name=\"function_id\" value=\"$function_id\">
           <input type=submit value=\"Delete this function\">
         </form>";
}

###########################################################################
#
# Subroutine print_delete_function_button2($function_id)
#
###########################################################################
sub print_delete_function_button2 {
  my ($function_id, $implied_function) = @_;

  my $cgi_step = ($implied_function eq 'Yes') ? "delete_ext_function"
                                              : "delete_function";

  print "<form action=\"$url_stem\">
           <input type=hidden name=\"cgi_step\" value=\"$cgi_step\">
           <input type=hidden name=\"function_id\" value=\"$function_id\">
           <input type=submit value=\"Delete it!\">
         </form>";
  #print "implied_function='$implied_function'<BR>";
}

###########################################################################
#
# Subroutine print_delete_group_button2($function_group_id)
#
###########################################################################
sub print_delete_group_button2 {
  my ($function_group_id) = @_;

  print "<form action=\"$url_stem\">
           <input type=hidden name=\"cgi_step\" value=\"delete_group\">
           <input type=hidden name=\"function_group_id\" 
                  value=\"$function_group_id\">
           <input type=submit value=\"Delete it!\">
         </form>";
}

###########################################################################
#
# Subroutine print_delete_function_button2($function_id)
#
###########################################################################
sub print_delete_function_button2 {
  my ($function_id, $implied_function) = @_;

  my $cgi_step = ($implied_function eq 'Yes') ? "delete_ext_function"
                                              : "delete_function";

  print "<form action=\"$url_stem\">
           <input type=hidden name=\"cgi_step\" value=\"$cgi_step\">
           <input type=hidden name=\"function_id\" value=\"$function_id\">
           <input type=submit value=\"Delete it!\">
         </form>";
  #print "implied_function='$implied_function'<BR>";
}

###########################################################################
#
# Subroutine print_view_function_button($function_id)
#
###########################################################################
sub print_view_function_button {
  my ($function_id) = @_;

  print "<form action=\"$url_stem\">
           <input type=hidden name=\"cgi_step\" value=\"pre_edit_function\">
           <input type=hidden name=\"function_id\" value=\"$function_id\">
           <input type=submit value=\"View/Edit the Function\">
         </form>";
}

###########################################################################
#
# Subroutine print_edit_group_button($group_id)
#
###########################################################################
sub print_edit_group_button {
  my ($group_id) = @_;

  print "<form action=\"$url_stem\">
           <input type=hidden name=\"cgi_step\" value=\"pre_edit_group\">
           <input type=hidden name=\"function_group_id\" value=\"$group_id\">
           <input type=submit value=\"Edit\">
         </form>";
}

###########################################################################
#
# Subroutine print_view_group_button($group_id)
#
###########################################################################
sub print_view_group_button {
  my ($group_id) = @_;

  print "<form action=\"$url_stem\">
           <input type=hidden name=\"cgi_step\" value=\"pre_edit_group\">
           <input type=hidden name=\"function_group_id\" value=\"$group_id\">
           <input type=submit value=\"View/Edit Function Group\">
         </form>";
}

###########################################################################
#
# Subroutine print_menu($gray_out_option, $cat)
#
###########################################################################
sub print_menu {
  my ($gray_out_option, $cat) = @_;

  my $menu_bg_color = "bgcolor=\"#C0C0C0\"";
  my $gray_font = "<font color=gray>";
  my $end_font = "</font>";

  my $main_link = "<a href=\"${url_stem}cgi_step=category_list\">"
                 . "Main category list</a>";
  my $tree_url = "${url_stem}cgi_step=tree_view_cat_function";
  if ($cat) {
      $tree_url .= "#" . &strip($cat);
  }
  my $tree_link = "<a href=\"$tree_url\">"
                 . "Tree view of categories and functions</a>";
  my $group_link = "<a href=\"${url_stem}cgi_step=display_function_groups\">"
                 . "Function groups</a>";

  if ($gray_out_option eq "main") {
    $main_link = "${gray_font}Main category list$end_font";
  }
  elsif ($gray_out_option eq "tree") {
    $tree_link = "${gray_font}Tree view of categories and functions$end_font";
  }
  elsif ($gray_out_option eq "group") {
    $group_link = "${gray_font}Function groups$end_font";
  } 

  print "<table width=\"100%\">
         <tr $menu_bg_color>
             <td align=center width=\"33%\">$main_link</td>
             <td align=center width=\"33%\">$tree_link</td>
             <td align=center>$group_link</td>
         </tr></table><br>\n";
}

###########################################################################
#
# Subroutine pre_edit_function($lda, $function_id)
#
###########################################################################
sub pre_edit_function {
  my ($lda, $function_id, $end_user) = @_;

 #
 #  Get information about this function, and a hash of function_ids and their 
 #   parent function_ids.
 #
  &get_functions($lda, '', $function_id);
  my $cat = $fcategory[0];
  my $auth_count = $fauth_count[0];
  my $rule_count = $frule_count[0];

 #
 #  Show navigation bar
 #
  &print_menu('', $cat);  

 #
 #  Print button to get back to list of functions in this category
 #
  &print_function_list_button($cat);

 #
 # Get information about the specified category.  We use the same 
 # subroutine as the one used for getting information about all categories,
 # but in this case, we specify only one category of interest.
 #
  my %cat2desc;
  my %cat2function_count;
  my %cat2group_count;
  my %cat2imp_function_count;
  my %cat2can_maint_function;
  $cat = substr($cat . "    ", 0, 4);  # Make sure category is 4 characters
  &get_categories ($lda, $end_user, $cat, \%cat2desc, 
                   \%cat2function_count, \%cat2imp_function_count, 
                   \%cat2can_maint_function, \%cat2group_count);

  my $can_maintain = $cat2can_maint_function{$cat};
  #$can_maintain = 'N';

  #
  #  Get a list of categories in which this user can maintain functions.
  #  Get it in the form of a hash %editable_cat2desc mapping the 
  #  category code to the category description.
  #
  my %editable_cat2desc;
  &get_editable_categories($lda, $end_user, \%editable_cat2desc);
  #foreach $key (sort keys %editable_cat2desc) {
  #  print "User $end_user can maintain functions in category $key"
  #	. " ( $editable_cat2desc{$key} ) <BR>";
  #}

  #
  #  Get a list of qualifier_types
  #
  my %qualtype2desc;
  &get_qualifier_types($lda, \%qualtype2desc);

  #
  #  Find out if the end user is authorized to maintain PA Functions
  #
  my $can_maint_pa_functions = &can_user_maint_pa_functions ($lda, $end_user);
  #$can_maint_pa_functions = 0;

  #
  #  We'll need to show primary_authorizable and is_primary_auth_parent 
  #  field options within a group of radio buttons.
  #
  my $old_pa_option;
  # $fpa_parent[0]   $fpauthable[0]
  if ($fpa_parent[0] eq 'Yes') {
      $old_pa_option = 'pa_parent';
  }
  elsif ($fpauthable[0] eq 'Yes') {
      $old_pa_option = 'pa_authorizable';
  }
  elsif ($fpauthable[0] eq 'DLC-based') {
      $old_pa_option = 'pa_authorizable_dlc';
  }
  else {
      $old_pa_option = 'pa_neither';
  }

  #
  #  Indicate whether the user can maintain this function 
  #
  my $are_are_not = ($can_maintain eq 'Y') ? "are"
                                           : "are not";
  my $are_auth_message = 
   "<small>You ($end_user)<br>$are_are_not<br>authorized<br>to 
    edit<br>this function.</small>";

  #
  #  Build a string for displaying an "Update Function" button.  If 
  #  the user is not authorized to do updates, then make it a 
  #  non-breaking space rather than a button.
  #
  my $update_button;
  if ($can_maintain eq 'Y') {
    $update_button = 
      "<input type=hidden name=\"cgi_step\" value=\"edit_function\">
       <input type=submit value=\"Update function\">";
  }
  else {
      $update_button = $are_auth_message;
  }

  #
  #  Start displaying information about this function
  #
  my $temp_pa_group = ($fpagroup[0]) ? $fpagroup[0] : 'NONE';
  my $rows_to_span = 
     ($can_maintain eq 'Y' && $f_implied[0] eq 'no' && $can_maint_pa_functions)
       ? 9 : 10;
  print "<table border>\n";
  print "<form>\n";
  print "<tr><th $gray>Function ID</th>
         <td>$fid[0]
         <input type=\"hidden\" name=\"function_id\" value=\"$fid[0]\"></td>
         <td align=center rowspan=$rows_to_span>$update_button</td>
         </tr>\n";
  print "<tr><th $gray>Implied function?</th>
        <td>$f_implied[0]  <input type=\"hidden\" 
                   name=\"implied_function\" 
                   value=\"$f_implied[0]\"></td></tr>\n";

  #
  #  If the user is authorized to edit Functions in this category
  #  and the Function is not a primary_auth_parent function and there
  #  are no rules referencing this function, then
  #  show a list of other categories to which the Function could be reassigned.
  #
  #
  if ($can_maintain eq 'Y' && $fpa_parent[0] ne 'Yes' 
      && $frule_count[0] == 0) {
    print "<tr><th $gray>Category</th><td><select name=\"category\">";
    foreach $key (sort keys %editable_cat2desc) {
	my $is_selected = ($key eq $fcategory[0]) ? "selected" : "";
        print "<option $is_selected 
                value=\"$key\">$key ($editable_cat2desc{$key})";
    }
    print "</select></td></tr>\n";
  }

  #
  #  Else (user is not authorized to edit Functions in this category) show
  #  category, function_name, and function_decription as non-editable fields.
  #
  else {
    print "<tr><th $gray>Category</th>
           <td>$cat  <input type=\"hidden\" name=\"category\" 
                   value=\"$cat\"></td></tr>\n";
  }

  #
  #  If the user is authorized to edit Functions in this category, then
  #  allow the user to edit the Function_name and Function_description
  #  fields.
  #
  if ($can_maintain eq 'Y') {
    print "<tr><th $gray>Function name</th>"
          . "<td><input type=\"text\" name=\"function_name\" 
                   value=\"$fname[0]\"  size=30></td>\n";
    print "<tr><th $gray>Function description</th>"
          . "<td><input type=\"text\" name=\"function_desc\" 
                   value=\"$fdesc[0]\"  size=50></td>\n";
  }

  #
  #  Else (user is not authorized to edit Functions in this category) show
  #  function_name and function_decription as non-editable fields.
  #
  else {
    print "<tr><th $gray>Function name</th>
           <td>$fname[0]</td></tr>\n";
    print "<tr><th $gray>Function description</th>
               <td>$fdesc[0]</td></tr>\n";
  }

  #
  #  If the user is authorized to edit Functions in this category and
  #  if there are no existing Authorizations for this Function, then 
  #  display a list of Qualifier types
  #
  if ( ($can_maintain eq 'Y') && ($auth_count == 0) && ($auth_count == 0) 
        && ($rule_count == 0) ) {
    print "<tr><th $gray>Qualifier type</th>
           <td><select name=\"qualifier_type\">";
    foreach $key (sort keys %qualtype2desc) {
	my $is_selected = ($key eq $fqualtype[0]) ? "selected" : "";
        print "<option $is_selected 
                value=\"$key\">$key ($qualtype2desc{$key})";
    }
    print "</select></td></tr>\n";
  }

  #
  #  Else show qualifier_type as a non-editable field
  #
  else {
    print "<tr><th $gray>Qualifier type</th>
               <td>$fqualtype[0] <input type=\"hidden\" 
                   name=\"qualifier_type\" 
                   value=\"$fqualtype[0]\"></td></tr>\n";
  }

  #
  #  Set some variables that will be used for displaying Primary Authorizer
  #  related options
  #
  my ($selected_none, $selected_fin, $selected_hr);
   #print "temp_pa_group = '$temp_pa_group' old_pa_option='$old_pa_option'
   #       fpa_parent='$fpa_parent[0]' fpauthable='$fpauthable[0]'<BR>";
  if ($temp_pa_group eq 'NONE') {$selected_none = 'selected';}
  if ($temp_pa_group eq 'FIN') {$selected_fin = 'selected';}
  if ($temp_pa_group eq 'HR') {$selected_hr = 'selected';}
  my ($checked_pa_assignable, $checked_pa_dept, $checked_pa_parent, 
      $checked_pa_neither);
  if ($old_pa_option eq 'pa_parent') {$checked_pa_parent = 'checked';}
  elsif ($old_pa_option eq 'pa_authorizable') {
     $checked_pa_assignable = 'checked';
  }
  elsif ($old_pa_option eq 'pa_authorizable_dlc') {
     $checked_pa_dept = 'checked';
  }
  else {   # $old_pa_option eq 'pa_neither' 
     $checked_pa_neither = 'checked';
  }
   #print "checked_pa_assignable='$checked_pa_assignable'
   #       checked_pa_dept='$checked_pa_dept'
   #       checked_pa_parent='$checked_pa_parent'
   #       checked_pa_neither='$checked_pa_neither'<BR>";

  #
  #  If the user is authorized to maintain primary authorizer functions
  #  and the user is authorized to maintain functions in this category
  #  and this is not an implied function, 
  #  then allow the user to set fields related to Primary Authorizers
  #
   #print "can_maint_pa_functions='$can_maint_pa_functions' 
   #      'imp='$f_implied[0]<BR>";
  if ($can_maintain eq 'Y' && ($can_maint_pa_functions) 
      && ($f_implied[0] eq 'no') ) {

    if ($can_maint_pa_functions) {
      print 
      "<tr><th $gray>PA Function option:</th>
          <td>
            <input type=\"radio\" name=\"pa_option\" value=\"pa_authorizable\"
             $checked_pa_assignable> 
            Assignable by Primary Authorizer<br>";
      if ($cat eq 'SAP ' || $old_pa_option eq 'pa_authorizable_dlc') {
        print
            "<input type=\"radio\" name=\"pa_option\" 
              value=\"pa_authorizable_dlc\" $checked_pa_dept> 
             DLC-limited assignable by Primary Authorizer Parent Function
             (for Approval functions for the Spending Group hierarchy)<br>";
      }
      if ($cat eq 'META') {
        print
            "<input type=\"radio\" name=\"pa_option\" value=\"pa_parent\"
                $checked_pa_parent> 
             Primary Authorizer Parent Function (category must be META)<br>";
      }
      print 
        "<input type=\"radio\" name=\"pa_option\" value=\"pa_neither\" 
             $checked_pa_neither> Neither a Primary Authorizer function 
                     nor assignable by a Primary Authorizer
        </td></tr>
        <tr><th $gray>Primary Auth Group:</th>
        <td>
        <select name=\"pa_group\">
             <option $selected_none value=\"NONE\">NONE None
             <option $selected_fin 
                 value=\"FIN\">FIN Grantable by financial Primary Authorizer
             <option $selected_hr
                 value=\"HR\">HR  Grantable by HR Primary Authorizer
           </select></td></tr>";
    }
  }
 
  #
  #  Else show PA-related fields as non-editable fields
  #
  else {
    print "<tr><th $gray>Is a<br>primary authorizer<br>function</th>
         <td>$fpa_parent[0]</td></tr>\n";
    print "<tr><th $gray>Grantable by<br>primary authorizers?</th>
           <td>$fpauthable[0] 
               <input type=\"hidden\" name=\"pa_option\" 
                value=\"$old_pa_option\">
               <input type=\"hidden\" name=\"pa_group\" 
                value=\"$temp_pa_group\"></td></tr>\n";
    print "<tr><th $gray>PA group</th><td>$temp_pa_group</td></tr>\n";
  }

  #
  #  Show load pass number if this is an external function
  #
  my $function_id = $fid[0];
  if ($f_implied[0] eq 'Yes') {
    my $load_pass = $fid2load_pass{$function_id};
    my $checked1 = ($load_pass == 1) ? 'checked' : '';
    my $checked2 = ($load_pass == 2) ? 'checked' : '';
    my $checked3 = ($load_pass == 1 || $load_pass == 2) ? '' : 'checked';
    print "<tr><th $gray>Function will be used in:<br>
                         <small>(implied/external functions only)</small></th>
           <td>
            <input type=\"radio\" name=\"pass_number\" value=\"1\" $checked1> 
            External authorizations fed 
            from Warehouse or other source (load pass = 1)<br>
            <input type=\"radio\" name=\"pass_number\" value=\"2\" $checked2> 
            Implied authorizations derived from rules (load pass = 2)";
    if ($checked3) {
       print "<br><input type=\"radio\" name=\"pass_number\" 
               value=\"$load_pass\" $checked3> 
            Other (load pass = $load_pass)";
    }
    print "</td><tr>";
  }
  else {
      print "<tr><th $gray>Function load pass</th><td>n/a</td></tr>";
  }

  #
  #  Show modified_by, modified_date, authorization count, and rule count
  #

  $rows_to_span = ($f_implied[0] eq 'Yes') ? 7 : 5;
  print "<tr $gray><th colspan=2>&nbsp;</th>
         <td rowspan=$rows_to_span>&nbsp;</td></tr>\n";
  print "<tr><th $gray>Modified date</th><td>$fmoddate[0]</td></tr>\n";
  print "<tr><th $gray>Modified by</th><td>$fmodby[0]</td></tr>\n";
  print "<tr><th $gray>Current # of auths.</th>
         <td align=center>$fauth_count[0]</td></tr>\n";
  if ($f_implied[0] eq 'Yes') {
    my $rule_count = ($frule_count[0]) ? $frule_count[0] : '0';
    print "<tr><th $gray># of rules ref'd</th>
         <td align=center>$rule_count</td></tr>\n";
    my $group_count = ($fid2group_count{$fid[0]}) 
                       ? $fid2group_count{$fid[0]} : 0;
    print "<tr><th $gray># of groups ref'd</th>
         <td align=center>$group_count</td></tr>\n";
  }

  #
  #  Build a string for displaying an "Edit Parent/Child Pairs..." button.  
  #  If the user is not authorized to do updates, then make it a 
  #  non-breaking space rather than a button.
  #
  my $edit_parent_child_button;
  if ($can_maintain eq 'Y' && $f_implied[0] eq 'no') {
    $edit_parent_child_button = 
      "<form>
       <input type=hidden name=\"cgi_step\" value=\"pre_edit_parent_child\">
       <input type=hidden name=\"function_id\" value=\"$fid[0]\">
       <input type=submit value=\"Edit parent/child pairs...\">
       </form>";
  }
  else {
      $edit_parent_child_button = "&nbsp;";
  }

  #
  #  Close out the first form
  #
  print "</form>";

  #
  # Show parent functions
  #
   #print "parent_list = $fid2parent_id{$function_id}<BR>";
   my @parent_function_id = split("!", $fid2parent_id{$function_id});
   my $num_parents = @parent_function_id;
   my @child_function_id = split("!", $fid2child_id{$function_id});
   my $num_children = @child_function_id;
   my $total_columns = ($num_children) ? $num_children : 1;
   $total_columns += ($num_parents) ? $num_parents : 1;
   $total_columns++;
   print 
     "<tr><th colspan=2 $gray>&nbsp;</th>
      </tr>\n";
   print "<tr><th $gray>Parent functions</th>";
   if ($num_parents > 0) {
       print "<td><table border><tr><th>Category</th><th>Function ID</th>
                         <th>Function name</th><tr>";
       for ($i=0; $i<$num_parents; $i++) {
         my ($parent_cat, $parent_name) 
	     = &get_function_cat_and_name($lda, $parent_function_id[$i]);
         print "<tr><td>$parent_cat</td><td>$parent_function_id[$i]</td>
                <td>$parent_name</td>";
         print "</tr>";
       }
       print "</table></td>";
       print "<td rowspan=2>&nbsp;<BR>$edit_parent_child_button</td>";
       print "</tr>";
   }
   else {
       print "<td>(none)</td>
              <td rowspan=2>&nbsp;<BR>$edit_parent_child_button</td>";
       print "</tr>";
   }

  #
  # Show child functions
  #
   #print "child_list = $fid2child_id{$function_id}<BR>";
   print "<tr><th $gray>Child functions</th>";
   if ($num_children > 0) {
       print "<td><table border><tr><th>Category</th><th>Function ID</th>
                         <th>Function name</th><tr>";
       for ($i=0; $i<$num_children; $i++) {
         my ($child_cat, $child_name) 
	     = &get_function_cat_and_name($lda, $child_function_id[$i]);
         print "<tr><td>$child_cat</td><td>$child_function_id[$i]</td>
                <td>$child_name</td></tr>";
       }
       print "</table></td></tr>";
   }
   else {
       print "<td>(none)</td></tr>";
   }

  #
  #  Print end of the table
  #
  print "</table>\n";
  print "</form>\n";


  #
  # If there are no existing Authorizations for this function, and if
  #   user is authorized to edit functions in this category, show a 
  #   "delete" button.
  #
  if ($auth_count == 0 && $rule_count == 0 && $can_maintain eq 'Y') {
      print "<p /><center>";
      &print_delete_function_button($function_id);
      print "</center>";
  }
  elsif ($can_maintain eq 'Y') {
      print "<center><small>";
      print "Function cannot be deleted &#150;<br>";
      if ($auth_count) {
	  print "It is used in $auth_count Authorizations.<BR>";
      }
      if ($rule_count) {
	  print "It is directly referenced by $rule_count rule(s).<BR>";
      }
      print "</small></center>";
  }     

}

###########################################################################
#
#  Subroutine get_functions ($lda, $picked_cat, $function_id)
#
#  Gets information about all functions within a category if $function_id
#  is not specified.  If it is specified, then get information about just
#  one function.
#
#  Fills in these parallel arrays and hashes:   
#      @fid  -   list of function IDs
#      @fname -  function names
#      @fdesc -  function descriptions
#      @fqualtype - qualifier_type for each function
#      @fmodby - modified_by for each function
#      @fmoddate - modified_date for each function
#      @fpagroup - pa_group for each function
#      @fpauthable - pa_authorizable setting for each function ('Y','D' or 'N')
#      @fpaparent - is_primary_auth_parent setting for each function
#      @fauth_count - no. of current authorizations for this function
#      @fcategory - function_category for this function
#      @fmodby - modified by for this function
#      @fmoddate - modified date for this function
#      @f_implied - 'Yes' if it is an implied/external function
#      %fid2index - maps the function_id into the index within the parallel
#                   arrays
#  Fills in hashes   
#      %fid2parent_id - $fid2parent_id{$id} = a "!"-delimited list of 
#                       parent function_id's linked to child function $id
#      %fid2child_id  - $fid2child_id{$id} = a "!"-delimited list of 
#                       child function_id's linked to parent function $id
#      %fid2group_count  - $fid2group_count{$id} = number of function groups
#                          to which this function is linked
#      %fid2load_pass  - $fid2load_pass{$id} = load pass number for
#                          external/implied functions
#
###########################################################################
sub get_functions {
  my ($lda, $picked_cat, $function_id) = @_;

  #
  #  Make sure the $picked_cat parameter is 4 characters or less.
  #  This will prevent SQL insertion hack.
  #
  if (length($picked_cat) > 4) {
    $picked_cat = substr($picked_cat, 0, 4);
  }

  #
  #  Make sure the $function_id is not more than 6 characters.
  #  This will prevent SQL insertion hack.
  #
  if (length($function_id) > 6) {
    $function_id = substr($function_id, 0, 4);
  }

  #
  #  Open a cursor for a select statement, to get 
  #  the number of related implied authorization rules
  #
  my $stmt0 = 
   "select f.function_id, count(distinct r.rule_id)
    from external_function f, implied_auth_rule r
    where ( (f.function_category = r.condition_function_category
             and f.function_name = '*' || r.condition_function_name
             and r.condition_function_or_group = 'F')
            or (f.function_category = r.result_function_category        
                and f.function_name = '*' || r.result_function_name) )
    group by f.function_id";
  #print "'$stmt0'<BR>";
  my $csr0;
  unless ($csr0 = $lda->prepare($stmt0)) {
    print "Error preparing select statement for count of rules by Function "
    . $DBI::errstr . "<BR>";
  }
  unless ($csr0->execute) {
    print "Error executing select statement for Function parent/child pairs"
    . $DBI::errstr . "<BR>";
  }

  #
  #  Get the number of rules related to each external function
  #
  my %fid2rule_count = ();
  my ($ffid, $ffrule_count);
  while ( ($ffid, $ffrule_count) = $csr0->fetchrow_array )
  {
      $fid2rule_count{$ffid} = $ffrule_count;
  }
  unless ($csr0->finish) { 
    print "Can't close cursor for Function rule count<br>";
    die "Can't close cursor for Function rule count";
  }
  
  #
  #  Build SQL fragment for filtering by category
  #  Build another SQL fragment for selecting only functions grantable
  #    by primary authorizers.
  #
  my ($sql_frag1, $sql_frag2);
  if ($picked_cat eq 'ALL' || (!$picked_cat)) {
    $sql_frag1 = "";
  }
  else {
    $sql_frag1 = " and f.function_category = '$picked_cat' ";
  }
  if ($function_id) {
    $sql_frag2 = " and f.function_id = '$function_id' "
  }
  else {
    $sql_frag2 = "";
  }


  #
  #  Open a cursor for a 1st select statement
  #
  my $stmt = "select f.function_id, f.function_name, f.function_description,
               f.qualifier_type, lower(f.modified_by), 
               to_char(f.modified_date, 'Mon DD, YYYY'),
               qt.qualifier_type_desc,
               f.primary_auth_group, 
               decode(nvl(f.primary_authorizable,'N'),
                      'Y', 'Yes', 'D', 'DLC-based', 'N', 'no', 'no'),
               count(a.authorization_id), f.function_category,
               decode(nvl(f.is_primary_auth_parent, 'N'), 'Y', 'Yes', 'no'),
               'no' implied_func
               from qualifier_type qt, function f
                    left outer join authorization a  
                      on a.function_id = f.function_id
               where qt.qualifier_type = f.qualifier_type
               and qt.qualifier_type = f.qualifier_type
               $sql_frag1 $sql_frag2
               group by f.function_id, f.function_name, f.function_description,
               f.qualifier_type, f.modified_by, f.modified_date,
               qt.qualifier_type_desc,
               f.primary_auth_group, 
               decode(nvl(f.primary_authorizable,'N'),
                 'Y', 'Yes', 'D', 'DLC-based', 'N', 'no', 'no'),
               f.function_category, f.modified_by, f.modified_date,
               f.is_primary_auth_parent
               union 
                select f.function_id, f.function_name, f.function_description,
                 f.qualifier_type, lower(f.modified_by), 
                 to_char(f.modified_date, 'Mon DD, YYYY'),
                 qt.qualifier_type_desc,
                 '',
                 decode(nvl(f.primary_authorizable,'N'),
                        'Y', 'Yes', 'D', 'DLC-based', 'N', 'no', 'no'),
                 count(a.authorization_id), f.function_category,
                 'No' is_primary_auth_parent, 'yes' implied_func
                 from qualifier_type qt, external_function f
                      left outer join external_auth a  
                       on a.function_id = f.function_id
                 where qt.qualifier_type = f.qualifier_type
                 and qt.qualifier_type = f.qualifier_type
                 $sql_frag1 $sql_frag2
               group by f.function_id, f.function_name, f.function_description,
                 f.qualifier_type, f.modified_by, f.modified_date,
                 qt.qualifier_type_desc,
                 '', 
                 decode(nvl(f.primary_authorizable,'N'),
                   'Y', 'Yes', 'D', 'DLC-based', 'N', 'no', 'no'),
                 f.function_category, f.modified_by, f.modified_date
               order by function_category, implied_func, function_name";
  #print "'$stmt'<BR>";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
    print "Error preparing select statement for Function list"   
    . $DBI::errstr . "<BR>";
  }
  unless ($csr->execute) {
    print "Error executing select statement for Function list"   
    . $DBI::errstr . "<BR>";
  }
  
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
  @fauth_count = ();
  @fcategory = ();
  @fpa_parent = ();
  @frule_count = ();
  %fid2index = ();
  my ($ffname, $ffdesc, $ffqualtype, $ffmodby, $ffmoddate, 
      $ffqtdesc, $ffpagroup, $ffpauthable, $ffauth_count, $ffcategory,
      $ffpa_parent, $ff_implied);
  my $idx = 0;
  while (($ffid, $ffname, $ffdesc, $ffqualtype, $ffmodby, $ffmoddate, 
          $ffqtdesc, $ffpagroup, $ffpauthable, $ffauth_count, 
          $ffcategory, $ffpa_parent, $ff_implied) = $csr->fetchrow_array)
  {
        push(@fid, $ffid);
        $fid2index{$ffid} = $idx++; 
        push(@fname, $ffname);
        push(@fdesc, $ffdesc);
        push(@fqualtype, $ffqualtype);
        push(@fmodby, $ffmodby);
        push(@fmoddate, $ffmoddate);
        push(@fqtdesc, $ffqtdesc);
        push(@fpagroup, $ffpagroup);
        push(@fpauthable, $ffpauthable);
        push(@fauth_count, $ffauth_count);
        push(@fcategory, $ffcategory);
        push(@fpa_parent, $ffpa_parent);
        push(@frule_count, $fid2rule_count{$ffid});
        $ff_implied =~ s/yes/Yes/;
        push(@f_implied, $ff_implied);
        #print "$ffid, $ffname, $ffpauthable, $ffpa_parent<BR>\n";
  }
  unless ($csr->finish) { 
    print "Can't close cursor for Function list<br>";
    die "can't close cursor for Function list"; 
  }

  #
  #  Open a cursor for a 2nd select statement, to get 
  #  parent/child function_id pairs
  #
  my $stmt2 = "select fc.parent_id, fc.child_id"
            . " from function_child fc"
            . " order by 1, 2";
  #print "'$stmt2'<BR>";
  my $csr2;
  unless ($csr2 = $lda->prepare($stmt2)) {
    print "Error preparing select statement for Function parent/child pairs "
    . $DBI::errstr . "<BR>";
  }
  unless ($csr2->execute) {
    print "Error executing select statement for Function parent/child pairs"
    . $DBI::errstr . "<BR>";
  }
  
  #
  #  Get a list of parent/child pairs for functions
  #
  %fid2parent_id = ();
  %fid2child_id = ();
  my ($ffparent_id, $ffchild_id);
  while ( ($ffparent_id, $ffchild_id) = $csr2->fetchrow_array )
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
  unless ($csr2->finish) { 
    print "Can't close cursor for Function parent/child pairs<br>";
    die "Can't close cursor for Function parent/child pairs"; 
  }
  
  #
  #  Open a cursor for a 3rd select statement, to count links
  #  between each function and any function groups
  #
  my $stmt3 = "select fgl.child_id, count(fgl.parent_id)"
            . " from function_group_link fgl"
            . " group by fgl.child_id";
  #print "'$stmt3'<BR>";
  my $csr3;
  unless ($csr3 = $lda->prepare($stmt3)) {
    print "Error preparing select statement for Function/Group link count "
    . $DBI::errstr . "<BR>";
  }
  unless ($csr3->execute) {
    print "Error executing select statement for Function/Group link count"
    . $DBI::errstr . "<BR>";
  }
  
  #
  #  Set %fid2group_count for each function
  #
  %fid2group_count = ();
  my $n;
  while ( ($ffchild_id, $n) = $csr3->fetchrow_array )
  {
      $fid2group_count{$ffchild_id} = $n;
  }
  #print "test... parents of 1681: " . $fid2parent_id{'1681'} . "<BR>";
  unless ($csr3->finish) { 
    print "Can't close cursor for Function parent/child pairs<br>";
    die "Can't close cursor for Function parent/child pairs"; 
  }
  
  #
  #  Open a cursor for a 4th select statement, for the load pass number
  #  for external functions
  #
  my $stmt4 = "select function_id, pass_number"
            . " from function_load_pass";
  #print "'$stmt5'<BR>";
  my $csr4;
  unless ($csr4 = $lda->prepare($stmt4)) {
    print "Error preparing select statement for function_load_pass "
    . $DBI::errstr . "<BR>";
  }
  unless ($csr4->execute) {
    print "Error executing select statement for function_load_pass "
    . $DBI::errstr . "<BR>";
  }
  
  #
  #  Set %fid2load_pass for each function
  #
  %fid2load_pass = ();
  my $load_pass;
  while ( ($ffid, $load_pass) = $csr4->fetchrow_array )
  {
      $fid2load_pass{$ffid} = $load_pass;
  }
  unless ($csr4->finish) { 
    print "Can't close cursor for function_load_pass<br>";
    die "Can't close cursor for function_load_pass"; 
  }
  
}

###########################################################################
#
#  Function get_function_cat_and_name ($lda, $function_id)
#
#  Returns ($category, $function_name)
#
###########################################################################
sub get_function_cat_and_name {
  my ($lda, $function_id) = @_;

  #
  #  Open a cursor for a select statement
  #
  my $stmt = "select f.function_category, f.function_name
               from function2 f
               where f.function_id = $function_id";
  #print "'$stmt'<BR>";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
    print "Error preparing select statement for Function category and name"   
    . $DBI::errstr . "<BR>";
  }
  unless ($csr->execute) {
    print "Error executing select statement for Function category and name"
    . $DBI::errstr . "<BR>";
  }
  
  #
  #  Get the data
  #
  my ($ffcategory, $ffname) = $csr->fetchrow_array;
  unless ($csr->finish) { 
    print "Can't close cursor for Function category and name<br>";
    die "can't close cursor for Function category and name"; 
  }

  #
  #  Return the category and name
  #
   #print "get_function_cat_and_name '$function_id' cat='$ffcategory' 
   #       name='$ffname'<BR>";
  return ($ffcategory, $ffname);
}

###########################################################################
#
#  Subroutine get_editable_categories ($lda, $end_user, \%editable_cat2desc)
#
#  Fills in the hash
#    %editable_cat2desc - for each category in which user $end_user can
#       edit functions, maps the category code to its description
#
###########################################################################
sub get_editable_categories {
  my ($lda, $end_user, $reditable_cat2desc) = @_;

  #
  # Get all categories by calling &get_categories
  #
  my %cat2desc;
  my %cat2function_count;
  my %cat2group_count;
  my %cat2imp_function_count;
  my %cat2can_maint_function;
  &get_categories ($lda, $end_user, '', \%cat2desc, 
                   \%cat2function_count, \%cat2imp_function_count, 
                   \%cat2can_maint_function, \%cat2group_count);

  #
  #  Now, build a new hash of only those categories for which the 
  #  $end_user can maintain functions
  #
  %$reditable_cat2desc = ();
  foreach $key (keys %cat2can_maint_function) {
      #print "**** cat $key -> $cat2can_maint_function{$key}<BR>";
      if ( $cat2can_maint_function{$key} eq 'Y') {
	  $$reditable_cat2desc{$key} = $cat2desc{$key};
      }
  }

}

###########################################################################
#
#  Subroutine get_rule_maintainable_categories ($lda, $end_user, 
#                                               \%ruleable_cateegory)
#
#  Fills in the hash
#    %ruleable_category - for each category $cat in which user $end_user can
#       maintain rules and function_groups, 
#       set $ruleable_category{$cat} = the category description
#
###########################################################################
sub get_ruleable_categories {
  my ($lda, $end_user, $rruleable_category) = @_;

  #
  # 
  #
  %$rruleable_category = ();

  #
  #  Open a cursor for a select statement, to get 
  #  authorization information - in which Categories can the
  #  end-user maintain rules (and function_groups)?
  #
  my $stmt = 
     "select function_category, function_category_desc
       from category 
       where ROLESAPI_IS_USER_AUTHORIZED('REPA', 'CREATE IMPLIED AUTH RULES',
            'CAT' || rtrim(function_category)) = 'Y'
       order by function_category";
  #print "'$stmt'<BR>";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
    print "Error preparing select statement for rule-maint auths "
    . $DBI::errstr . "<BR>";
  }
  unless ($csr->execute) {
    print "Error executing select statement for rule-maint auths "
    . $DBI::errstr . "<BR>";
  }
  
  #
  #  Fill in the hash %cat2can_maint_function
  #
  my ($ccat, $cdesc);
  while ( ($ccat, $cdesc) = $csr->fetchrow_array )
  {
      $$rruleable_category{$ccat} = $cdesc;
  }

  unless ($csr->finish) { 
    print "Can't close cursor for rule-maint auths<br>";
    die "Can't close cursor for rule-maint auths";
  }

}

###########################################################################
#
#  Subroutine get_categories ($lda, $end_user, $cat, \%cat2desc, 
#                             \%cat2function_count, \%cat2can_maint_function,
#                             \%cat2group_count)
#  Fills in these hashes:   
#      %cat2desc - maps 4-character category code to description
#      %cat2function_count - maps category code to current no. of functions
#      %cat2imp_function_count - maps category code to no. of implied functions
#      %cat2can_maint_function - 'Y' or 'N' indicating whether end-user can
#                              maintain functions in this category
#      %cat2group_count - no. of function groups in this category
#
###########################################################################
sub get_categories {
  my ($lda, $end_user, $cat, $rcat2desc, $rcat2function_count, 
      $rcat2imp_function_count, $rcat2can_maint_function,
      $rcat2group_count) = @_;

  #
  #  Make sure $cat (a category), if given, is 4 characters long
  #  This will prevent SQL insertion hack.
  #  Also, set a SQL fragment for the select statement.
  #
  my $sql_frag = '';
  if ($cat) {
      $cat = substr($cat . '    ', 0, 4);
      $sql_frag = " where c.function_category = '$cat' ";
  }

  #
  #  Open a cursor for a 1st select statement
  #
  my $stmt = 
    "select c.function_category, c.function_category_desc, 
            count(distinct f.function_id), count(distinct ef.function_id)
       from category c
            left outer join function f
              on f.function_category = c.function_category
            left outer join external_function ef
              on ef.function_category = c.function_category
       $sql_frag
       group by c.function_category, c.function_category_desc
       order by c.function_category";
  #print "'$stmt'<BR>";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
    print "Error preparing select statement for Category list"   
    . $DBI::errstr . "<BR>";
  }
  unless ($csr->execute) {
    print "Error executing select statement for Category list"   
    . $DBI::errstr . "<BR>";
  }
  
  #
  #  Get a list of Categories
  #
  #c.function_category, c.function_category_desc, count(f.function_id)
  my ($ccat, $cdesc, $ccount);
  while (($ccat, $cdesc, $ccount, $c_icount) = $csr->fetchrow_array)
  {
      $$rcat2desc{$ccat} = $cdesc;
      $$rcat2function_count{$ccat} = $ccount;
      $$rcat2imp_function_count{$ccat} = $c_icount;
  }
  unless ($csr->finish) { 
    print "Can't close cursor for Function list<br>";
    die "can't close cursor for Function list"; 
  }

  #
  #  Open a cursor for a 2nd select statement, to get 
  #  authorization information - in which Categories can the
  #  end-user maintain Functions?
  #
  my $stmt2 = "select function_category, 
              auth_sf_can_create_function('$end_user', function_category)
	      from category 
              order by function_category";
  #print "'$stmt2'<BR>";
  my $csr2;
  unless ($csr2 = $lda->prepare($stmt2)) {
    print "Error preparing select statement for Function-maint auths "
    . $DBI::errstr . "<BR>";
  }
  unless ($csr2->execute) {
    print "Error executing select statement for Function-maint auths "
    . $DBI::errstr . "<BR>";
  }
  
  #
  #  Fill in the hash %cat2can_maint_function
  #
  my $ccan_maint_function;
  while ( ($ccat, $ccan_maint_function) = $csr2->fetchrow_array )
  {
     $$rcat2can_maint_function{$ccat} = $ccan_maint_function;
  }
  unless ($csr2->finish) { 
    print "Can't close cursor for Function-maint auths<br>";
    die "Can't close cursor for Function-maint auths";
  }

  #
  #  Open a cursor for a 3rd select statement, to get 
  #  count of function groups for each category
  #
  my $stmt3 = "select c.function_category, count(g.function_group_id)
	      from category c 
                   left outer join function_group g
                     on g.function_category = c.function_category
              group by c.function_category";
  #print "'$stmt3'<BR>";
  my $csr2;
  unless ($csr3 = $lda->prepare($stmt3)) {
    print "Error preparing select statement for Function group count "
    . $DBI::errstr . "<BR>";
  }
  unless ($csr3->execute) {
    print "Error executing select statement for Function group count "
    . $DBI::errstr . "<BR>";
  }
  
  #
  #  Fill in the hash %cat2can_maint_function
  #
  my $group_count;
  while ( ($ccat, $group_count) = $csr3->fetchrow_array )
  {
     $$rcat2group_count{$ccat} = $group_count;
  }
  unless ($csr3->finish) { 
    print "Can't close cursor for Function group count<br>";
    die "Can't close cursor for Function group count";
  }

}

###########################################################################
#
#  Subroutine get_eligible_parent_functions ($lda, $end_user, 
#                         $child_function_id, $cat, 
#                         \@eligible_parent_fid, \%pfid2cat, \%pfid2name)
#
###########################################################################
sub get_eligible_parent_functions {
  my ($lda, $end_user, $qualtype, $child_function_id, $r_eligible_parent_fid,
      $r_pfid2cat, $r_pfid2name) = @_;

  #
  #  Open a cursor for a select statement
  #
  my $stmt = 
    "select f.function_id, f.function_category, f.function_name
       from function f
       where f.qualifier_type = '$qualtype'
       and f.function_id <> '$child_function_id'
       and not exists 
       (select fc.parent_id from function_child fc
        where fc.child_id = '$child_function_id'
        and fc.parent_id = f.function_id)
       and auth_sf_can_create_function('$end_user', f.function_category) = 'Y'
     union select f.function_id, f.function_category, f.function_name
       from related_qualifier_type rqt, function f
       where rqt.child_qualifier_type = '$qualtype'
       and f.qualifier_type = rqt.parent_qualifier_type
       and f.function_id <> '$child_function_id'
       and not exists 
       (select fc.child_id from function_child fc
        where fc.child_id = '$child_function_id'
        and fc.parent_id = f.function_id)
       and auth_sf_can_create_function('$end_user', f.function_category) = 'Y'
       order by function_category, function_name";
  #print "'$stmt'<BR>";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
    print "Error preparing select stmt for eligible function parent list"   
    . $DBI::errstr . "<BR>";
  }
  unless ($csr->execute) {
    print "Error executing select statement for eligible function parent list"
    . $DBI::errstr . "<BR>";
  }
  
  #
  #  Get a list of eligible parent functions
  #
  my ($ffid, $ffcat, $ffname);
  while ( ($ffid, $ffcat, $ffname) = $csr->fetchrow_array)
  {
      push(@$r_eligible_parent_fid, $ffid);
      $$r_pfid2cat{$ffid} = $ffcat;
      $$r_pfid2name{$ffid} = $ffname;
  }
  unless ($csr->finish) { 
    print "Can't close cursor for eligible parent function list<br>";
    die "can't close cursor for eligible parent function list"; 
  }
  return; 

}

###########################################################################
#
#  Subroutine get_eligible_child_functions ($lda, $end_user, 
#                         $parent_function_id, $cat, 
#                         \@eligible_child_fid, \%cfid2cat, \%cfid2name)
#
###########################################################################
sub get_eligible_child_functions {
  my ($lda, $end_user, $qualtype, $parent_function_id, $r_eligible_child_fid,
      $r_cfid2cat, $r_cfid2name) = @_;

  #
  #  Open a cursor for a select statement
  #
  my $stmt = 
    "select f.function_id, f.function_category, f.function_name
       from function f
       where f.qualifier_type = '$qualtype'
       and f.function_id <> '$parent_function_id'
       and not exists 
       (select fc.child_id from function_child fc
        where fc.parent_id = '$parent_function_id'
        and fc.child_id = f.function_id)
       and auth_sf_can_create_function('$end_user', f.function_category) = 'Y'
     union select f.function_id, f.function_category, f.function_name
       from related_qualifier_type rqt, function f
       where rqt.parent_qualifier_type = '$qualtype'
       and f.qualifier_type = rqt.child_qualifier_type
       and f.function_id <> '$parent_function_id'
       and not exists 
       (select fc.child_id from function_child fc
        where fc.parent_id = '$parent_function_id'
        and fc.child_id = f.function_id)
       and auth_sf_can_create_function('$end_user', f.function_category) = 'Y'
       order by function_category, function_name";
  #print "'$stmt'<BR>";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
    print "Error preparing select stmt for eligible function child list"   
    . $DBI::errstr . "<BR>";
  }
  unless ($csr->execute) {
    print "Error executing select statement for eligible function child list"
    . $DBI::errstr . "<BR>";
  }
  
  #
  #  Get a list of eligible child functions
  #
  my ($ffid, $ffcat, $ffname);
  while ( ($ffid, $ffcat, $ffname) = $csr->fetchrow_array)
  {
      push(@$r_eligible_child_fid, $ffid);
      $$r_cfid2cat{$ffid} = $ffcat;
      $$r_cfid2name{$ffid} = $ffname;
  }
  unless ($csr->finish) { 
    print "Can't close cursor for eligible child function list<br>";
    die "can't close cursor for eligible child function list"; 
  }
  return; 

}

###########################################################################
#
#  Subroutine get_eligible_group_child_functions ($lda, $end_user, 
#                         $function_group_id, $cat, 
#                         \@eligible_child_fid, \%cfid2cat, \%cfid2name)
#
###########################################################################
sub get_eligible_group_child_functions {
  my ($lda, $end_user, $qualtype, $function_group_id, $r_eligible_child_fid,
      $r_cfid2cat, $r_cfid2name) = @_;

  #
  #  Open a cursor for a select statement
  #
  my $stmt = 
    "select f.function_id, f.function_category, f.function_name
       from external_function f
       where f.qualifier_type = '$qualtype'
       and not exists 
       (select fgl.child_id from function_group_link fgl
        where fgl.parent_id = '$function_group_id'
        and fgl.child_id = f.function_id)
       order by f.function_category, f.function_name";
  #print "'$stmt'<BR>";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
    print "Error preparing select stmt for eligible function child list"   
    . $DBI::errstr . "<BR>";
  }
  unless ($csr->execute) {
    print "Error executing select statement for eligible function child list"
    . $DBI::errstr . "<BR>";
  }
  
  #
  #  Get a list of eligible function group child functions
  #
  my ($ffid, $ffcat, $ffname);
  while ( ($ffid, $ffcat, $ffname) = $csr->fetchrow_array)
  {
      #print "Eligible child function fid=$ffid cat=$ffcat name=$ffname<BR>";
      push(@$r_eligible_child_fid, $ffid);
      $$r_cfid2cat{$ffid} = $ffcat;
      $$r_cfid2name{$ffid} = $ffname;
  }
  unless ($csr->finish) { 
    print "Can't close cursor for eligible child function list<br>";
    die "can't close cursor for eligible child function list"; 
  }
  return; 

}

###########################################################################
#
#  Function can_user_maint_pa_functions ($lda, $end_user);
#
#  Checks to see if the end-user has a 'MAINT PRIMARY AUTH FUNCTIONS'
#  authorization.  If so, return 1; else return 0;
#
###########################################################################
sub can_user_maint_pa_functions {
    my ($lda, $k_principal) = @_;
    my ($csr, $stmt, $result);
    if (!$k_principal) {
        return 0;
    }
    $stmt = "select ROLESAPI_IS_USER_AUTHORIZED('$k_principal',"
	. "'MAINT PRIMARY AUTH FUNCTIONS', 'NULL') from dual";
    my $csr;
    unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement for PA Function-maint auth "
      . $DBI::errstr . "<BR>";
    }
    unless ($csr->execute) {
      print "Error executing select statement for PA Function-maint auth "
      . $DBI::errstr . "<BR>";
    }

    ($result) = $csr->fetchrow_array;
    if ($result eq 'Y') {
        return 1;
    } else {
        return 0;
    }

    unless ($csr2->finish) { 
      print "Can't close cursor for Function-maint auths<br>";
      die "Can't close cursor for Function-maint auths";
    }

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
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
    print "Error preparing select statement for pa_group table "
    . $DBI::errstr . "<BR>";
  }
  unless ($csr->execute) {
    print "Error executing select statement for pa_group table "
    . $DBI::errstr . "<BR>";
  }

  #
  #  Get a list of pa_groups
  #
  @$rpa_group = ();
  my ($pa_group, $pag_desc);
  while ( ($pa_group, $pag_desc) = $csr->fetchrow_array ) {
        push(@$rpa_group, $pa_group);
        $$rpa_group2web_desc{$pa_group} = $pag_desc;
  }
  unless ($csr->finish) { 
    print "Can't close cursor for pa_group table<br>";
    die "Can't close cursor for pa_group table"; 
  }

}

###########################################################################
#
#  Subroutine get_qualifier_types($lda, \%qualtype2desc);
#
###########################################################################
sub get_qualifier_types {
  my ($lda, $rqualtype2desc) = @_;

  #
  #  Open cursor to select statement
  #
  my $stmt = "select qualifier_type, qualifier_type_desc"
           . " from qualifier_type"
           . " order by qualifier_type";
  #print "'$stmt'<BR>";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
    print "Error preparing select statement for qualifier_types "
    . $DBI::errstr . "<BR>";
  }
  unless ($csr->execute) {
    print "Error executing select statement for qualifier_types "
    . $DBI::errstr . "<BR>";
  }

  #
  #  Get a list of qualifier_types
  #
  my ($qualtype, $qualtype_desc);
  while ( ($qualtype, $qualtype_desc) = $csr->fetchrow_array ) {
      $$rqualtype2desc{$qualtype} = $qualtype_desc;
  }
  unless ($csr->finish) { 
    print "Can't close cursor for qualifier_types<br>";
    die "Can't close cursor for qualifier_types"; 
  }

}

###########################################################################
#
#  Subroutine get_group_to_rule_count($lda, \%fgid2rule_count, $group_id);
#  
#  Get the count of referenced implied auth rules for each function_group.
#  Set &fgid2rule_count{$group_id} = the number of referenced rules.
#  If the argument $group_id is set, then only look for the specific
#  group_id.
#
###########################################################################
sub get_group_to_rule_count {
  my ($lda, $rgid2rule_count, $group_id) = @_;

  #
  #  If $group_id is not null, then build a SQL fragment to include
  #  just one group ID.
  #  
  my $sql_fragment;
  if ($group_id) {
      if (length($group_id) > 10) {  # Thwart hackers attempting SQL injection
	  $group_id = 0;
      }
      $sql_fragment = " where g.function_group_id = '$group_id' ";
  }

  #
  #  Open cursor to select statement
  #
  my $stmt = 
   "select g.function_group_id, count(r.rule_id)
    from function_group g
         left outer join implied_auth_rule r
            on r.condition_function_category = g.function_category
             and r.condition_function_name = g.function_group_name
             and r.condition_function_or_group = 'G'
         $sql_fragment
         group by g.function_group_id";
  #print "'$stmt'<BR>";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
    print "Error preparing select statement for group to rule count "
    . $DBI::errstr . "<BR>";
  }
  unless ($csr->execute) {
    print "Error executing select statement for group to rule count "
    . $DBI::errstr . "<BR>";
  }

  #
  #  Get the rule counts for each function group
  #
  my ($group_id, $rule_count);
  while ( ($group_id, $rule_count) = $csr->fetchrow_array ) {
      $$rgid2rule_count{$group_id} = $rule_count;
  }
  unless ($csr->finish) { 
    print "Can't close cursor for group to rule count<br>";
    die "Can't close cursor for group to rule count"; 
  }

}

###########################################################################
#
#  Function get_function_group_info($lda, $group_id);
#  
#  returns ($function_category, $function_group_name, $child_count)
#
###########################################################################
sub get_function_group_info {
  my ($lda, $group_id) = @_;

  #
  #  If $group_id is not null, then build a SQL fragment to include
  #  just one group ID.
  #  
  if (length($group_id) > 10) {  # Thwart hackers attempting SQL injection
       $group_id = 0;
  }

  #
  #  Open cursor to select statement
  #
  my $stmt = 
   "select g.function_category, g.function_group_name, count(l.child_id)
    from function_group g 
         left outer join function_group_link l
           on l.parent_id = g.function_group_id
         where g.function_group_id = '$group_id'
         group by g.function_category, g.function_group_name";
  #print "'$stmt'<BR>";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
    print "Error preparing select statement for group info "
    . $DBI::errstr . "<BR>";
  }
  unless ($csr->execute) {
    print "Error executing select statement for group info "
    . $DBI::errstr . "<BR>";
  }

  #
  #  Get the rule counts for each function group
  #
  my ($function_category, $function_group_name, $child_count) 
      = $csr->fetchrow_array;
  #print "cat='$function_category' name='$function_group_name'<BR>";
  unless ($csr->finish) { 
    print "Can't close cursor for group to rule count<br>";
    die "Can't close cursor for group to rule count"; 
  }
  return ($function_category, $function_group_name, $child_count);

}

###########################################################################
#
#  Subroutine get_pa_granting_function($lda, \%pa_group2function);
#
#  Get a list of pa groups to "granting" function.
#
###########################################################################
sub get_pa_granting_function {
  my ($lda, $rpa_group2function) = @_;

  #
  #  Open cursor to select statement
  #  Get a list of pa_groups used within Functions by reading the
  #  Function table.
  #
  my $stmt = "select f.primary_auth_group, f.function_name"
           . " from function f"
           . " where is_primary_auth_parent = 'Y'"
           . " order by primary_auth_group, function_name";
  #print "'$stmt'<BR>";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
    print "Error preparing select stmt for pa groups -> granting Function "
    . $DBI::errstr . "<BR>";
  }
  unless ($csr->execute) {
    print "Error executing select stmt for pa groups -> granting Function "
    . $DBI::errstr . "<BR>";
  }
  
  #
  #  Get a list of pa_groups
  #
  my ($pa_group, $function_name);
  while ( ($pa_group, $function_name) = $csr->fetchrow_array ) {
      $function_name =~ s/ /&nbsp;/g;
      if ($$rpa_group2function{$pa_group}) {
        $$rpa_group2function{$pa_group} .= " <i>or</i> $function_name";
      }
      else {
        $$rpa_group2function{$pa_group} = $function_name;
      }
  }
  unless ($csr->finish) { 
    print "Can't close cursor for pa groups -> granting function<br>";
    die "Can't close cursor for pa groups -> granting function"; 
  }

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

###########################################################################
#
#  Subroutine get_dept_based_function($lda, \%function2dept_list);
#
###########################################################################
sub get_dept_based_function {
  my ($lda, $rfunction2dept_list) = @_;

  #
  #  Open cursor to select statement
  #
  my $stmt = 
    "select f.function_name, daf.dept_code
      from dept_approver_function daf, function f
      where f.function_id = daf.function_id
      and daf.dept_code <> 'D_ALL'
      and not exists (select q1.qualifier_code
       from qualifier q0, qualifier_descendent qd, qualifier q1
       where q0.qualifier_type = 'DEPT'
       and q0.qualifier_code = daf.dept_code
       and qd.parent_id = q0.qualifier_id
       and q1.qualifier_id = qd.child_id
       and substr(q1.qualifier_code, 1, 2) = 'D_')
      order by 1, 2";
  #print "'$stmt'<BR>";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
    print "Error preparing select stmt for department-based functions "
    . $DBI::errstr . "<BR>";
  }
  unless ($csr->execute) {
    print "Error executing select stmt for department-based functions "
    . $DBI::errstr . "<BR>";
  }
  
  #
  #  Build a hash of function_names mapped to lists of DLCs
  #
  my ($function_name, $dept_code);
  while ( ($function_name, $dept_code) = $csr->fetchrow_array ) {
      if ($$rfunction2dept_list{$function_name}) {
	  $$rfunction2dept_list{$function_name} .= "," . $dept_code;
      }
      else {
	  $$rfunction2dept_list{$function_name} = $dept_code;
      }
  }
  unless ($csr->finish) { 
    print "Can't close cursor for pa groups -> granting function<br>";
    die "Can't close cursor for department-based functions"; 
  }

}

###########################################################################
#
#  Subroutine &display_function_groups($lda)
#
#  Display a list of Function Groups and child Functions
#
###########################################################################
sub display_function_groups {
  my ($lda, $end_user) = @_;

 #
 #  Show navigation bar
 #
  &print_menu('group');  

 #
 #  Get a hash of categories indicating whether or not the end_user can
 #  maintain rules in these categories
 #
  my %ruleable_category;
  &get_ruleable_categories($lda, $end_user, \%ruleable_category);
  #foreach $key (sort keys %ruleable_category) {
  #    print "'$key' -> $ruleable_category{$key}<BR>";
  #}
  my $num_categories_allowed = (keys %ruleable_category);

 #
 #  Open a select statement
 #
  my $stmt1 = 
 "select fg.function_category, fg.function_group_id, fg.function_group_name, 
     fg.function_group_desc, fg.matches_a_function, fg.qualifier_type,
     l.child_id, f.function_name 
    from function_group fg 
         left outer join function_group_link l
            on l.parent_id = fg.function_group_id
         left outer join function2 f
            on f.function_id = l.child_id
    order by fg.function_category, fg.function_group_name, f.function_name";
  #print "stmt 3 = '$stmt1'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt1)) {
      print "Error preparing select statement 3: " . $DBI::errstr . "<BR>";
  }

  unless ($csr1->execute) {
      print "Error executing select statement 1: " . $DBI::errstr . "<BR>";
  }

 #
 #  Get results from the SELECT statement
 #
  my ($category, $fgid, $fgname, $fgdesc, $matches_function, $qualtype,
      $fid, $fname);
  my ($previous_fgid);
  my @fgid_list;
  my %fgid2category;
  my %fgid2name;
  my %fgid2desc;
  my %fgid2matches_function;
  my %fgid2qualtype;
  my %fgid2function_list;
  my $delim = ',';
  my $function_id2name;
  
  while 
   ( ($category, $fgid, $fgname, $fgdesc, $matches_function, $qualtype,
      $fid, $fname)
      = $csr1->fetchrow_array )
  {
    if ($previous_fgid ne $fgid) {
      push(@fgid_list, $fgid);
      $fgid2category{$fgid} = $category;
      $fgid2name{$fgid} = $fgname;
      $fgid2desc{$fgid} = $fgdesc;
      $fgid2matches_function{$fgid} = $matches_function;
      $fgid2qualtype{$fgid} = $qualtype;
    }
    if ($fgid2function_list{$fgid}) {
	$fgid2function_list{$fgid} .= ",$fid";
    }
    else {
	$fgid2function_list{$fgid} = $fid;
    }
    $function_id2name{$fid} = $fname;
    $previous_fgid = $fgid;
  }

 #
 #  Get the number of rules referencing each function_group
 #
  my %gid2rule_count = ();
  &get_group_to_rule_count($lda, \%fgid2rule_count, '');

 #
 #  Indicate whether or not the user can create new Functions in this
 #  category.  If so, show a link for creating a new Function.
 #
  if ($num_categories_allowed > 0) {
    &print_new_function_group_button();
  }
  else {
    print "<center>You (user $end_user) are <i>not</i> authorized to 
           maintain Function Groups in any category</center><p />";
  }

 #
 #  Print a header
 #
  print "<table border>\n";
  print "<tr><th>Category</th><th>Function<br>Group<br>ID</th>
         <th>&nbsp;</th>
         <th>Function Group Name</th>
         <th width=\"15%\">Description</th><th>Matches<br>a<br>function</th>
         <th># of<br>rules<br>ref'ed</th>
         <th>Qual<br>type</th><th>Function<br>ID</th>
         <th>Linked Function name</th></tr>\n";
  my $id, $id2;
  foreach $id (@fgid_list) {
    my @fid_list = split($delim, $fgid2function_list{$id});
    my $num_fid = @fid_list;
    unless ($num_fid) {$num_fid = 1;}
    my $first_fid = shift(@fid_list); # Take off first element
    my $first_name;
    if ($first_fid) {
      $first_fname = $function_id2name{$first_fid};
    }
    else {
	$first_fid = '&nbsp;';
	$first_fname = '&nbsp;';
    }
    my $category = $fgid2category{$id};
    my $can_maint_groups = ($ruleable_category{$category}) ? 'Yes' : 'no';
    print "<tr><td rowspan=$num_fid>$fgid2category{$id}</td>"
        . "<td rowspan=$num_fid>$id</td>"
        . "<td rowspan=$num_fid>";
    if ($ruleable_category{$category}) {
      &print_edit_group_button($id);
    }
    else {
	print "&nbsp;";
    }
    print "</td>"
        . "<td rowspan=$num_fid>$fgid2name{$id}</td>"
        . "<td rowspan=$num_fid>$fgid2desc{$id}</td>"
        . "<td rowspan=$num_fid>$fgid2matches_function{$id}</td>"
        . "<td rowspan=$num_fid>$fgid2rule_count{$id}</td>"
        . "<td rowspan=$num_fid>$fgid2qualtype{$id}</td>"
        . "<td>$first_fid</td><td>$first_fname</td>"
        . "</tr>\n";
    foreach $id2 (@fid_list) {
	  print "<tr><td>$id2</td><td>$function_id2name{$id2}</td></tr>\n";
    }
  }
  print "</table><p />\n";

}

