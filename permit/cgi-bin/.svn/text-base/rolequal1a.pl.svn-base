#!/usr/bin/perl
###########################################################################
#
#  CGI script to list perMIT DB qualifiers with color-coding for release
#    strategies.
#
#
#  Copyright (C) 1999-2010 Massachusetts Institute of Technology
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
#  Modified, Jim Repa, 4/12/1999 support either W or P as prefix for WBSs.
#  Modified, Jim Repa, 4/14/1999 to use DBI interface, and to 
#                                allow "all levels" in some cases.
#  Modified, Jim Repa, 5/5/1999  raise qualifier_code to upper-case
#  Modified, Jim Repa, 6/25/1999 added color-coding for release strategies
#  Modified, Jim Repa, 7/13/1999 fixed bug in release strategy display
#  Modified, Jim Repa, 7/29/1999 Handle '<' in qualifier_name field
#  Modified, Jim Repa, 8/3/1999  Allow for RSCOLOR off. Add DEPT links.
#  Modified, Jim Repa, 1/19/2000 Add option to sort by NAME or CODE
#  Modified, Jim Repa, 2/15/2000 Fix bug in display of RS colors
###########################################################################
#
# Get packages
#
use rolesweb('login_dbi_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm

#
#  Web stem constants
#
 $host = $ENV{'HTTP_HOST'};
 $main_url = "http://$host/webroles.html";

#
#  Print out the beginning of the HTML document.  
#
 print "Content-type: text/html", "\n\n";
 print "<HTML>", "\n";

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

#
#  Get some variables from the input URL (or stacked form information)
#
$qualtype = $formval{'qualtype'};  # Get value set in &parse_forms()
$raw_qualtype = $rawval{'qualtype'};  # Get unedited value
$qt = $qualtype;
$qt =~ s/\W.*//;  # Keep only the first word.
$qualtype =~ s/\w*\s//;  # Throw out first word.
$rootnode = $formval{'rootnode'};  # Get the root node (a qualifier_id)
$rootqcode = $formval{'rootcode'};  # Get the root node (a qualifier_code)
$rootqcode =~ tr/a-z/A-Z/;
$levels = $formval{'levels'};  # Get the number of levels (if any)
$sort_option = $formval{'sort'};  # Get sort option
$sort_option =~ tr/a-z/A-Z/;
$show_rscolor = $formval{'rscolor'};  # Show colors for Release Strategies?
$show_rscolor =~ tr/a-z/A-Z/;

#
#  Make some modifications to form variables
#
$cat = $category;
$cat =~ s/\W.*//;  # Keep only the first word.
$cat4 = substr($cat . '    ', 0, 4);

#
#  Set stem for URLs
#
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 $url_stem = "/cgi-bin/$progname?";
 $url_stem2 = "/cgi-bin/roleparent.pl?";
 $url_stem3 = "/cgi-bin/rolecc_info.pl?";

#
#  Set constants.
#
 $all_levels = 20; # How many levels are considered "all" levels?
 @big_branch = ();
 &get_big_branch(\@big_branch);  # Get list of nodes with many children

#
#  Set colors for release strategies (for Fund Centers only)
#
 # Disable $show_rscolor if we are not looking at funds.
 $show_rscolor = ($qt eq 'FUND') ? $show_rscolor : 'N';
 if ($show_rscolor eq 'Y') {
   %rs_to_color = (
     '1' => 'blue',
     '2' => 'red',
     '3' => 'orange',
     '4' => 'magenta',
     '5' => 'turquoise',
     'A' => 'brown',
   );
   %rs_to_text = (
     '1' => 'Model 1',
     '2' => 'Model 2',
     '3' => 'Model 3',
     '4' => 'Model 4',
     '5' => 'Bates model',
     'A' => 'Sloan model',
   );
 }

#
#  Adjust the URL stem that points back to this CGI script
#
 $url_stem .= "&qualtype=$raw_qualtype&rscolor=$show_rscolor&";
 if ($levels) {
   $url_stem .= "levels=$levels&";
 }
 if ($sort_option) {
   $url_stem .= "sort=$sort_option&";
 }

#
#  Make sure we are set up to use Oraperl.
#
use DBI;

#
# Login into the database
# 
$lda = login_dbi_sql('roles') 
      || die $DBI::errstr;

#
#  Make sure $rootnode is set to the qualifier_id for the branch of the
#  tree we want to display.  (If necessary, convert from qualifier_code
#  or qualifier_type & qualifier_level to qualifier_id.)
#
 #print "qt=$qt rootnode=$rootnode rootqcode=$rootqcode<BR>";
 ($rootnode, $rootqcode, $rootlevel) 
     = &get_rootnode2($lda, $qt, $rootnode, $rootqcode);
 if ($rootnode eq '') {
   print "Invalid or mismatched qualifier type ($qt) or code ($rootqcode)."
   . "<BR>";
   die "Invalid or mismatched qualifier type ($qt) or code ($rootqcode)."
   . "<BR>";
 }

#
#  Figure out if the rootnode specified is a "big branch" of the qualifier
#  tree.
#
 $is_big_branch = 0;  # Default -- not a big branch
 foreach $node (@big_branch) {
   if ($rootqcode eq $node) {
     $is_big_branch = 1;
     last;
   }
 }

#
#  Set number of levels:  2 for "big branches", 
#  levels from parameter if specified, 2 if SG_ALL, otherwise 3.
#
 if ($is_big_branch && (!$levels)) {
   $num_levels = 2;
 }
 elsif ($is_big_branch && ($levels)) {
   $num_levels = ($levels > 5) ? 2 : $levels;
 }
 elsif ($levels) {
   $num_levels = $levels;
 }
 elsif ($rootqcode eq 'SG_ALL') {
   $num_levels = 2; 
 }
 elsif ($rootqcode eq 'D_ALL') { # 4 levels for DEPT hierarchy
   $num_levels = 4; 
 }
 else {
   $num_levels = 2;
 }

#
# Define "global" cursors for main select statements.  We'll later bind
# specific values to the parameters.
#

 $stmt1 = "select distinct qualifier_id, qualifier_code," 
          . " qualifier_name, has_child, cc.release_strategy"
          . " from qualifier q, wh_cost_collector cc"
          . " where qualifier_id = ?"
          . " and cc.fund_center_id(+) = ltrim(q.qualifier_code, 'FC')";
 unless ($gcsr1 = $lda->prepare($stmt1)) 
 {
    print "Error preparing statement 1.<BR>";
    die;
 }

#
# Set up a SQL fragment to sort qualifiers within a branch of the tree
# by either qualifier_code (default) or qualifier_name
#
 $sort_order = ($sort_option eq 'NAME')
               ? "qualifier_name"
               : "replace(qualifier_code,'FC','E')";  # FC before F

# 
# The second select statement varies depending on whether the URL
# specifies a child_qc.  Also, vary the sort order according to the
# sort parameter on the URL.
#
 $stmt2 = "select qualifier_id, qualifier_code," 
          . " qualifier_name, has_child, NULL"
          . " from qualifier"  
          . " where qualifier_type = '$qt'"
          . " and qualifier_id in"
          . " (select child_id from qualifier_child"
          . " where parent_id = ?)"
          . " order by $sort_order";
 unless ($gcsr2 = $lda->prepare($stmt2)) 
 {
    print "Error preparing statement 2.<BR>";
    die;
 }

#
# The third select statement includes Release Strategy information.
#
 if ($qt eq 'FUND') {
   $stmt3 = "select distinct qualifier_id, qualifier_code," 
            . " qualifier_name, has_child, cc.release_strategy"
            . " from qualifier q, wh_cost_collector cc"  
            . " where qualifier_type = 'FUND'"
            . " and qualifier_id in"
            . " (select child_id from qualifier_child"
            . " where parent_id = ? and parent_id = ?)"
            . " and cc.fund_center_id(+) = ltrim(qualifier_code,'FC')"
            . " order by $sort_order";
   unless ($gcsr3 = $lda->prepare($stmt3)) 
   {
      print "Error preparing statement 3.<BR>";
      die;
   }
 }

#
#  Get a list of qualifiers
#
@qid = ();
@qlev = ();
@qcode = ();
@qname = ();
@qdisplay = ();
@qhaschild = ();
#&get_quals($qt, $rootnode, 1, $num_levels, '', $rootqcode);
&get_quals($qt, $rootnode, 1, $num_levels, '', '');


#
#  If $rootnode was blank, fill it in with the qualifier_id
#
$rootnode = ($rootnode) ? $rootnode : $qid[0];

#
#  Drop connection to Oracle.
#
$lda->disconnect() || die "can't log off Oracle";

#
#  Get the qualifier_code of the root node
#
$rootcode = ($rootnode eq 'ROOT') ? 'ROOT' : $qcode[0];
$root_description = ($rootnode eq 'ROOT') ?
   'the root node of the tree' : 
   'code ' . $rootcode . ' in the tree';

#
#  Print out more headers for the HTML document
#
 print "<HEAD><TITLE>perMIT DB List of $qt Qualifiers from $rootcode",
       "</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa"';
 if ($show_rscolor eq 'Y') {print 'link=black alink=black vlink=black';}
 print '>';
 &print_header("Display of $qt qualifiers $qualtype", 'http');
 print "<P>";
 print "This is a hierarchical display of qualifiers of type $qt"
       . " starting from $root_description.  To move down in the tree"
       . " (i.e., view a branch of the tree in more detail)"
       . " click on a qualifier code below.";
 if ($rootlevel != 1) {
   print " To move up in"
       . " the tree (closer to the root) click the two dots (..) below"
       . " or use the Back button"
       . " in your Web browser.", "\n";
 }

#
#  Add a sentence about the * to the right of the name for Funds and Cost
#  Objects.
#
 if ($qt eq 'FUND' || $qt eq 'COST') {
   print " For details on a cost object or fund, click the asterisk (*) to"
       . " the right of the name.\n";
 }
 elsif ($qt eq 'SPGP') {
   print " To display the Fund Centers corresponding to a Spending Group,"
       . " click the asterisk (*) to the right of the name.\n";
 }

#
#  If this is not the root level of the COST or FUND hierarchy, 
#  allow the person to select a different number of levels to display.
#  Suppress this choice if qualifier_type is BAGS or BUDG.
#  Limit the max_levels to 5 if this is a big branch.
#
 $suppress = ($qt eq 'BAGS' || $qt eq 'BUDG') ? 1 : 0;
 $display_levels = ($num_levels == $all_levels) ? 'all' : $num_levels;
 #print "is_big_branch = $is_big_branch suppress=$suppress<BR>";
 if ((!$suppress) && (($rootlevel != 1) || ($qt ne 'COST' && $qt ne 'FUND'))) {
   print " The current display shows $display_levels levels of the hierarchy."
         ." You can redisplay with: \n";
   $qcode_start = '<A HREF="' . $url_stem . 'rootnode=' . $rootnode;
   $max_level = ($num_levels == 5) ? 4 : 5;
   for ($i = 2; $i <= $max_level; $i++) {
     if ($i != $num_levels) {
       if ( ($i < $max_level) || ($num_levels < $all_levels)
           && (!$is_big_branch) ) {
         print $qcode_start . '&levels=' . $i . '">'
             . "$i&nbsp;levels</A>, \n";
       }
       else {
         print 'or ' . $qcode_start . '&levels=' . $i . '">'
             . "$i&nbsp;levels</A>.\n";
       }
     }
   }
   if (($num_levels != $all_levels) && (!$is_big_branch)) {
     print 'or ' . $qcode_start . '&levels=' . $all_levels . '">'
           . "all&nbsp;levels</A>.\n";
   }
 }

#
#  If this is a FUND display, show release strategy color codes.
#
 if ($qt eq 'FUND' && $show_rscolor eq 'Y') {
   print "<P><small>The release strategy for a fund or fund center is",
         " indicated by the following color codes.",
         " (If no color code",
         " is shown for a fund or fund center, try displaying more levels",
         " in the hierarchy.)</small>",
         "<TABLE>";
   foreach $rs (keys %rs_to_color) {
     printf "<TR><TD>%s</TD><TD><font color=%s>%s</font></TD></TR>",
         $rs_to_text{$rs}, $rs_to_color{$rs}, $rs_to_color{$rs};
   }
   print "</TABLE>";
 }

 print "<P>";
 print "<HR>", "\n";

#
#  Print out the qualifier tree
#
 $n = @qid;  # How many qualifiers?
 printf "<TT>", "\n";
 if ($rootlevel != 1) {
   $xqcode = $qcode[0];
   $xqcode =~ s/&/%26/;
   print '<A HREF="' . $url_stem2 . 'qualtype=' . $raw_qualtype
            . '&qualcode=' . $xqcode . '"> '
            . "..</A><BR>\n";
 }
 %prev_rscolor = ();
 $color1 = $color2 = '';
 for ($i = 0; $i < $n; $i++) {
   if ($qhaschild[$i] eq 'Y') {  # If has child, point to URL
     $qcode_string = '<A HREF="' . $url_stem . "qualtype=" . $raw_qualtype
            . '&rootnode=' . $qid[$i] . '">' 
            . $qcode[$i] . '</A>';
   }
   else {  # Otherwise, this is a leaf node.
     $qcode_string = $qcode[$i];
   }
   # Set colors for Fund Centers based on release strategy
   if ($show_rscolor eq 'Y') {
     $rscolor = $rs_to_color{$qrelstrat[$i]};
      #print "code=$qcode[$i] rs=$qrelstrat[$i] color='$rscolor'<BR>";
     if ( (!($rscolor)) && ($qcode[$i] =~ /^F[0-9]/) ) {
       $rscolor = $prev_rscolor{$qlev[$i]-1};
     }
     $prev_rscolor{$qlev[$i]} = $rscolor;  # Save rscolor for this level
      #print "qcode=$qcode[$i] rs=$qrelstrat[$i] color=$rscolor<BR>";
     $color1 = ($rscolor) ? "<font color=$rscolor>" : '';
     $color2 = ($rscolor) ? "</font>" : '';
   }
   #
   $qname[$i] =~ s/</&lt;/g;
   print $qdisplay[$i] . $qcode_string . '  ' 
         . $color1 . $qname[$i] . $color2;
   if (($qt eq 'COST' || $qt eq 'FUND') &&
       $qcode[$i] =~ /^[CIPWF][0-9]/) {  # Cost object or Fund -- C.O. Detail
     print ' <A HREF="' . $url_stem3
            . '&cost_object=' . $qcode[$i] . '">'
            . "*</A>";
   }
   elsif ($qt eq 'SPGP' && $qcode[$i] ne 'SG_ALL') {  # Spend. grp.--Link to FC
     $fc_code = $qcode[$i];
     $fc_code =~ s/SG_/FC_/;
     $fc_code =~ s/&/%26/;
     print ' <A HREF="' . $url_stem 
            . 'qualtype=FUND+%28Fund+Centers+and+Funds%29'
            . '&rootcode=' . $fc_code . '&levels=3">'
            . "*</A>";
   }
   elsif ($qt eq 'DEPT') {  # Various links from DEPT hierarchy
     $l_code = $qcode[$i];
     $l_code =~ s/&/%26/;
     if ($l_code =~ /^FC/) {
       print ' <A HREF="' . $url_stem 
            . 'qualtype=FUND+%28Fund+Centers+and+Funds%29'
            . '&rootcode=' . $l_code . '&levels=3">'
            . "*</A>";
     }
     elsif ($l_code =~ /^SG/) {
       print ' <A HREF="' . $url_stem 
            . 'qualtype=SPGP+%28Spending+Groups%29'
            . '&rootcode=' . $l_code . '&levels=2">'
            . "*</A>";
     }
     elsif ($l_code =~ /^(0HPC|PC)/) {
       print ' <A HREF="' . $url_stem 
            . 'qualtype=COST+%28Cost+Object+and+PC%29'
            . '&rootcode=' . $l_code . '&levels=2">'
            . "*</A>";
     }
     elsif ($l_code =~ /^[0-9]{6}$/) {
       print ' <A HREF="' . $url_stem 
            . 'qualtype=ORGU+%28Org.+Unit+(Personnel)&29'
            . '&rootcode=' . $l_code . '&levels=2">'
            . "*</A>";
     }
     elsif ($l_code =~ /^7[0-9]{7}$/) {
       print ' <A HREF="' . $url_stem 
            . 'qualtype=LORG+%28LDS+Org.+Unit&29'
            . '&rootcode=' . $l_code . '&levels=2">'
            . "*</A>";
     }
   }
   print "<BR>\n",
 }

 printf "</TT>", "\n";
 print "<HR>";
 print "<A HREF=\"$main_url\">"
  . "<small>Back to main perMIT web interface page</small></A>";
 print "</BODY></HTML>", "\n";
 exit(0);

###########################################################################
#
#  Recursive subroutine get_quals.
#
###########################################################################
sub get_quals {
  my ($qualtype, $rootnode, $lev, $maxlev, $prefix, $rootqcode) = @_;
  my $csr;
  my $i = 0;
  my $new_prefix = '';
  my $rs;
  #print "QUALTYPE=$qualtype ROOTNODE=$rootnode LEV=$lev MAXLEV=$maxlev",
  #      " ROOTQCODE=$rootqcode<BR>\n";

  #
  #  Open a cursor for select statement.
  #
  if ($lev == 1) {
    $gcsr1->bind_param(1, $rootnode);
    $gcsr1->execute;
    $csr = $gcsr1;
  }
  elsif ($qualtype eq 'FUND') {
    $gcsr3->bind_param(1, $rootnode);
    $gcsr3->bind_param(2, $rootnode);
    $gcsr3->execute;
    $csr = $gcsr3;
  }
  else {
    $gcsr2->bind_param(1, $rootnode);
    $gcsr2->execute;
    $csr = $gcsr2;
  }

  #
  #  Get a list of qualifiers
  #
  my @mqid = ();
  my @mqcode = ();
  my @mqname = ();
  my @mqhaschild = ();
  my @mqrelstrat = ();
  my @mqdisplay = ();
  
  #print "Before ora_fetch\n";
  while ( ($qqid, $qqcode, $qqname, $qqhaschild, $qqrs) 
         = $csr->fetchrow_array) 
  {
  	# mark any NULL fields found
	grep(defined || 
          ($_ = '<NULL>'),
	   $aakerb, $aafn, $aaqc, $aadf, $aagandv, $aadescend);
        push(@mqid, $qqid);
        push(@mqcode, $qqcode);
        push(@mqname, $qqname);
        
        push(@mqdisplay, '..' x ($lev-1) . $qqname);
        push(@mqhaschild, $qqhaschild);
        push(@mqrelstrat, $qqrs);
  }

  $csr->finish || die "can't close cursor";

  #
  #  Now, put each record, from local arrays, into the global array variables.
  #  Where there is a child record and we haven't reached the desired level,
  #  call this routine recursively to get the children.
  #

  my $n = @mqid;  # How many qualifiers?
  my $expander = '';
  for ($i = 0; $i < $n; $i++) 
  {
    push(@qid, $mqid[$i]);
    push(@qcode, $mqcode[$i]);
    push(@qname, $mqname[$i]);
    $expander = $prefix . '+--';
    push(@qdisplay, $expander);
    push(@qhaschild, $mqhaschild[$i]);
    push(@qrelstrat, $mqrelstrat[$i]);
    push(@qlev, $lev);
    #print "I=$i QID=$mqid[$i], QNAME=$mqname[$i], RS=$mqrelstrat[$i]<BR>";
    if (($lev != $maxlev) & ($mqhaschild[$i] eq 'Y')) {
      $new_prefix 
       = ($i < $n-1) ? $prefix . '|&nbsp&nbsp' : $prefix . '&nbsp&nbsp&nbsp';
      &get_quals($qt, $mqid[$i], $lev+1, $maxlev, $new_prefix, '');
    }
  }

}

###########################################################################
#
#  Function get_rootnode2($lda, $qualtype, $rootnode, $rootqcode)
#
#  Finds the qualifier_id associated with the rootnode.
#
###########################################################################
sub get_rootnode2 {
  my ($lda, $qualtype, $rootnode, $rootqcode) = @_;
  my ($csr, $stmt4, $stmt4a, $stmt5, $rootid, $rootcode, $rootlevel);
  if ($rootnode ne 'ROOT' && $rootnode ne '') {
    $stmt4a = "select qualifier_code, qualifier_level from qualifier"
           . " where qualifier_id = '$rootnode'" 
	   . " and qualifier_type = '$qualtype'";
    unless ($csr = $lda->prepare($stmt4a)) 
    {
       print "Error preparing statement 4a.<BR>";
       die;
    }
    $csr->execute;
    ($rootcode, $rootlevel) = $csr->fetchrow_array;
    $csr->finish;
    return ($rootnode, $rootcode, $rootlevel);
  }
  elsif ($rootqcode ne '') {
    $stmt4 = "select qualifier_id, qualifier_level from qualifier"
           . " where qualifier_type = '$qualtype'"
           . " and qualifier_code = '$rootqcode'";
    unless ($csr = $lda->prepare($stmt4)) 
    {
       print "Error preparing statement 4.<BR>";
       die;
    }
    $csr->execute;
    ($rootid, $rootlevel) = $csr->fetchrow_array;
    $csr->finish;
    return ($rootid, $rootqcode, $rootlevel);
  }
  else {
    # Use qualifier_level index. There are only a few level 1 rows.
    $stmt5 = "select /*+ INDEX(qualifier rdb_i_q_qualifier_level) */"
           . " qualifier_id, qualifier_code, qualifier_level"
           . " from qualifier"
           . " where qualifier_type = '$qualtype'"
           . " and qualifier_level = 1";
    unless ($csr = $lda->prepare($stmt5)) 
    {
       print "Error preparing statement 4.<BR>";
       die;
    }
    $csr->execute;
    ($rootid, $rootcode, $rootlevel) = $csr->fetchrow_array;
    $csr->finish;
    return ($rootid, $rootcode, $rootlevel);
  }
}

###########################################################################
#
#  Subroutine get_big_branch(\@big_branch)
#
#  Gets a list of "big branches" in the qualifier hierarchies, those
#  that have so many child nodes that we will not allow the user
#  to expand them to all the levels.
#
###########################################################################
sub get_big_branch {
  my ($rbig_branch) = @_;
  @$rbig_branch = qw(0HPC00_MIT 0HPC0 0HPC00 0HPC000 0HPC001 
                     0HPC00002 0HPC00005 0HPC00006
                     FCMIT FC100000 FC_CUSTOM FC100001 FC100002
                     FC100012 FC100015 FC100017
                     FC_CENTRAL FC_SCHOOL_ENG FC_SCHOOL_SCI FC_VPRES
                    );
}

