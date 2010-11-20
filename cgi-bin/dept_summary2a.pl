#!/usr/bin/perl
###########################################################################
#
#  CGI script to produce a summary table for DLCs in the DEPT hierarchy.
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
#  Written 5/31/2000, Jim Repa
#  Modified 6/12/2000
#  Modified 3/9/2001 (Handle SIS_* for SISO links)
#  Modified 8/30/2005 (Support PCMIT-0 hierarchy)
#
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
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 $url_stem = "http://$host/cgi-bin/$progname";  # this URL

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
#  Print out the top of the HTML document.  
#
 print "<HTML>", "\n";
 print "<HEAD><TITLE>Summary of DEPT hierarchy</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 &print_header("Summary of DEPT hierarchy", 'http');
 print "<HR>", "\n";


#
#  Get form variables.  (None needed)
#
$fontsize = $formval{'fontsize'};
if (!$fontsize) {$fontsize = 'bigger'};
$fontsize =~ tr/A-Z/a-z/;  # Change to lower case
$format = $formval{'format'};
if (!$format) {$format = 1};
$option = $formval{'option'};
if (!$option) {$option = 1};

#
#  Make sure we are set up to use Oraperl.
#

#
# Login into the database
# 
use DBI;
$lda = login_dbi_sql('roles')
      || die ($DBI::errstr . "\n");
 
#
#  Get a list of Departments
#
%dept_parent = ();  # This hash contains parent_dept -> child1!child2!child3
%dept_name = ();  # This hash contains dept -> dept_name
%dept_sg = ();  # This hash contains dept -> spending_group_code
%dept_sg_name = ();  # This hash contains dept -> spending_group_name
%dept_cust_fc = ();  # This hash contains dept -> cust_fc_code
%dept_std_fc = ();  # This hash contains dept -> std_fc_code
%dept_pc = ();  # This hash contains dept -> pc_node
%dept_pcmit0 = ();  # This hash contains dept -> pcmit0_node
%dept_bag = ();  # This hash contains dept -> nimbus_bag
%dept_siso = ();  # This hash contains dept -> sis_org
%dept_org = ();   # This hash contains dept -> 6-digit org unit
%dept_org2 = ();  # This hash contains dept -> 8-digit org unit
&get_dept_info($lda);

#
#  Get a list of custom and standard FCs where the custom and
#  standard FCs are equivalent.
#
 %std_equal_cust_fc = ();
 %std_equal_cust_fc_name = ();
 &get_std_equal_cust_fc($lda, \%std_equal_cust_fc, \%std_equal_cust_fc_name);

#
#  Get a list of "missing links" in the DEPT hierarchy.
#
 %missing_qcode = ();
 &get_missing_links($lda);

#
#  Drop connection to Oracle.
#
$lda->disconnect() 
  || die "can't log off Oracle";

#
#  Print out the http document.  
#
 # Format 2 is compact format (one line per department)
 if ($format eq 2) {
   &print_table2($fontsize, $url_stem, $option);
 }
 # Format 1 is detailed format
 else {
   &print_table1($fontsize, $url_stem, $option);
 }

#
#
#
 print "<P>";
 print "<HR>", "\n";
 print "<A HREF=\"$main_url\">"
  . "<small>Back to main perMIT web interface page</small></A>";
 print "</BODY></HTML>", "\n";
 exit(0);

###########################################################################
#
#  Subroutine get_dept_info($lda);
#
#  Uses global hashes %dept_parent, %dept_sg, %dept_cust_fc, %dept_std_fc,
#    ...
#  plus global hashes %dept_sg_name, %dept_cust_fc_name, %dept_std_fc_name,
#    ...
#
###########################################################################
sub get_dept_info {
  my ($lda) = @_;

  #
  #  Open a cursor to a select statement
  #
  my $stmt = q{
      select /*+ ORDERED */ 
       q1.qualifier_code, q2.qualifier_code, q2.qualifier_name,
       q3.qualifier_code, q3.qualifier_name
       from qualifier q1, qualifier_child qc, qualifier q2, 
            qualifier_child qc2, qualifier q3
       where q1.qualifier_type = 'DEPT'
       and qc.parent_id = q1.qualifier_id
       and q2.qualifier_id = qc.child_id
       and q2.qualifier_code like 'D%'
       and substr(q2.qualifier_code, 1, 2) = 'D_'
       and qc2.parent_id = q2.qualifier_id
       and q3.qualifier_id = qc2.child_id
       and substr(q3.qualifier_code, 1, 2) <> 'D_'
      union select /*+ ORDERED */ 
       q1.qualifier_code, q2.qualifier_code, q2.qualifier_name,
       '', ''
       from qualifier q1, qualifier_child qc, qualifier q2
       where q1.qualifier_type = 'DEPT'
       and qc.parent_id = q1.qualifier_id
       and q2.qualifier_id = qc.child_id
       and q2.qualifier_code like 'D%'
       and substr(q2.qualifier_code, 1, 2) = 'D_'
       and q2.has_child = 'N'
       order by 1, 2, 3
  };
  #print "stmt='$stmt'<BR>";
  my $csr = $lda->prepare("$stmt") or die( $DBI::errstr . "\n");
  $csr->execute();
  
  #
  #  Read in rows from the query.  Fill in values for the hashes.
  #
  my $prev_code = '';
  while (my @row  =  $csr->fetchrow_array())
  {
    my ($ddparent, $ddcode, $ddname, $ddchild, $ddcname) = @row;
    # First, fill in %dept_parent and %dept_name
    if ($ddcode ne $prev_code) {
      if ($dept_parent{$ddparent}) {
        $dept_parent{$ddparent} .= "!$ddcode";
      }
      else {
        $dept_parent{$ddparent} = $ddcode;
      }
      $dept_name{$ddcode} = $ddname;
      $prev_code = $ddcode;
    }
    # Next, fill in %dept_sg, %dept_cust_fc, %dept_std_fc, etc.,  
    # where appropriate
    if ($ddchild =~ /^SG_/) {
      if ($dept_sg{$ddcode}) {
        $dept_sg{$ddcode} .= "<BR>$ddchild";
        $dept_sg_name{$ddcode} .= "<BR>$ddcname";
      }
      else {
        $dept_sg{$ddcode} = $ddchild;
        $dept_sg_name{$ddcode} = $ddcname;
      }
    }
    elsif ($ddchild =~ /^FC[0-9]/) {
      if ($dept_std_fc{$ddcode}) {
        $dept_std_fc{$ddcode} .= "<BR>$ddchild";
        $dept_std_fc_name{$ddcode} .= "<BR>$ddcname";
      }
      else {
        $dept_std_fc{$ddcode} = $ddchild;
        $dept_std_fc_name{$ddcode} = $ddcname;
      }
    }
    elsif ($ddchild =~ /^FC_/) {
      if ($dept_cust_fc{$ddcode}) {
        $dept_cust_fc{$ddcode} .= "<BR>$ddchild";
        $dept_cust_fc_name{$ddcode} .= "<BR>$ddcname";
      }
      else {
        $dept_cust_fc{$ddcode} = $ddchild;
        $dept_cust_fc_name{$ddcode} = $ddcname;
      }
    }
    elsif ($ddchild =~ /^PC[0-9]{6}$/) {
      if ($dept_pc{$ddcode}) {
        $dept_pc{$ddcode} .= "<BR>$ddchild";
        $dept_pc_name{$ddcode} .= "<BR>$ddcname";
      }
      else {
        $dept_pc{$ddcode} = $ddchild;
        $dept_pc_name{$ddcode} = $ddcname;
      }
      if ($dept_pcmit0{$ddcode}) {
        $dept_pcmit0{$ddcode} .= "<BR>$ddchild";
        $dept_pcmit0_name{$ddcode} .= "<BR>$ddcname";
      }
      else {
        $dept_pcmit0{$ddcode} = $ddchild;
        $dept_pcmit0_name{$ddcode} = $ddcname;
      }
    }
    elsif ($ddchild =~ /^0HPC/) {
      if ($dept_pc{$ddcode}) {
        $dept_pc{$ddcode} .= "<BR>$ddchild";
        $dept_pc_name{$ddcode} .= "<BR>$ddcname";
      }
      else {
        $dept_pc{$ddcode} = $ddchild;
        $dept_pc_name{$ddcode} = $ddcname;
      }
    }
    elsif ($ddchild =~ /^PCMIT-/) {
      if ($dept_pcmit0{$ddcode}) {
        $dept_pcmit0{$ddcode} .= "<BR>$ddchild";
        $dept_pcmit0_name{$ddcode} .= "<BR>$ddcname";
      }
      else {
        $dept_pcmit0{$ddcode} = $ddchild;
        $dept_pcmit0_name{$ddcode} = $ddcname;
      }
    }
    elsif ($ddchild =~ /^[0-9]{6}$/) {
      if ($dept_org{$ddcode}) {
        $dept_org{$ddcode} .= "<BR>$ddchild";
        $dept_org_name{$ddcode} .= "<BR>$ddcname";
      }
      else {
        $dept_org{$ddcode} = $ddchild;
        $dept_org_name{$ddcode} = $ddcname;
      }
    }
    elsif ($ddchild =~ /^7[0-9]{7}$/ || $ddchild =~ /^(0HL|LDS)/) {
      if ($dept_lds{$ddcode}) {
        $dept_lds{$ddcode} .= "<BR>$ddchild";
        $dept_lds_name{$ddcode} .= "<BR>$ddcname";
      }
      else {
        $dept_lds{$ddcode} = $ddchild;
        $dept_lds_name{$ddcode} = $ddcname;
      }
    }
    elsif ($ddchild =~ /^[0-9][0-9][0-9]$/ || $ddchild =~ /^BAG/) {
      if ($dept_bag{$ddcode}) {
        $dept_bag{$ddcode} .= "<BR>$ddchild";
        $dept_bag_name{$ddcode} .= "<BR>$ddcname";
      }
      else {
        $dept_bag{$ddcode} = $ddchild;
        $dept_bag_name{$ddcode} = $ddcname;
      }
    }
    elsif ($ddchild =~ /^1[0-9]{7}$/) {
      if ($dept_org2{$ddcode}) {
        $dept_org2{$ddcode} .= "<BR>$ddchild";
        $dept_org2_name{$ddcode} .= "<BR>$ddcname";
      }
      else {
        $dept_org2{$ddcode} = $ddchild;
        $dept_org2_name{$ddcode} = $ddcname;
      }
    }
    elsif ($ddchild =~ /^SIS/ || $ddchild =~ /^[0-9]{1,2}$/) {
      if ($dept_siso{$ddcode}) {
        $dept_siso{$ddcode} .= "<BR>$ddchild";
        $dept_siso_name{$ddcode} .= "<BR>$ddcname";
      }
      else {
        $dept_siso{$ddcode} = $ddchild;
        $dept_siso_name{$ddcode} = $ddcname;
      }
    }
  }
  $csr->finish();
}

###########################################################################
#
#  Subroutine print_table1($fontsize, $url_stem)
#
#  Print table, format 1.
#
###########################################################################
sub print_table1 {
  my ($fontsize, $url_stem, $option) = @_;

 #
 #  Set some variables for table headings and data, dependent on font size.
 #
  my ($font1, $font2);
  if ($fontsize eq 'smaller') {
    $font1 = "<font size=\"-1\">";
    $font2 = "</font>";
  }
  else {
    $font1 = "";
    $font2 = "";
  }
  my $td1 = "<td>$font1";
  my $td2 = "$font2</td>";
  my $th1 = "<th>$font1";
  my $th2 = "$font2</th>";

  #
  # Print out the header.
  #
  &print_explanation('1');
  if ($fontsize eq 'smaller') {
    print "<small>(Redisplay the table using a <a href=\"$url_stem?"
          . "fontsize=bigger\">bigger</a> font.)</small>";
    print "<P><BR>";
  }
  else {
    print "<small>(Redisplay the table using a <a href=\"$url_stem?"
          . "fontsize=smaller\">smaller</a> font.)</small>";
    print "<P><BR>";
  }

  #
  # Start printing out the table.  Choose a different header depending
  # on the option chosen:  Option 1 means all link types, Option 2 means
  # just PC Node, Org. Unit, NIMBUS BAG, and SIS Org..
  #
  print "<table border>";
  my $cols;  # Number of columns
  if ($option eq '1') {
      print "<tr>${th1}Parent<br>Dept$th2${th1}Department code$th2"
        . "${th1}Spending Group /<br>Cust. FC$th2"
        . "${th1}Std. FC$th2"
        . "${th1}Standard<br>PC Node$th2"
        . "${th1}PCMIT0<br>Node$th2"
        . "${th1}Old<br>Org.<br>Unit$th2"
        . "${th1}New HR<br>Org. Unit$th2"
        . "${th1}LDS<br>Org.$th2"
        . "${th1}NIM-<BR>BUS<br>B.A.G.$th2"
        . "${th1}SIS<br>Org.$th2"
        . "</tr>";
      $cols = 11;
  }
  else {
      print "<tr>${th1}Parent<br>Dept$th2${th1}Department code$th2"
        . "${th1}Std. PC Node$th2"
        . "${th1}Org.<br>Unit$th2"
        . "${th1}NIM-<BR>BUS<br>B.A.G.$th2"
        . "${th1}SIS<br>Org.$th2</tr>";
      $cols = 6;
  }
  
  my ($child_str, $parent, @child_list, $first_time, $child_link);
  my ($sg, $cust_fc, $std_fc, $pc_node, $org_unit, $lds_org, $bag, $siso,
      $org2_unit);
  foreach $parent (sort keys %dept_parent) {
    @child_list = split('!', $dept_parent{$parent});
    $first_time = 1;
    foreach $child (sort @child_list) {
      $child_str = &web_string($child);
      $child_link = 
        "<a href=\"qualauth.pl?qualtype=DEPT+%28MIT+departments%29"
        . "&rootcode=$child_str&noleaf=N\">$child</a>";
      if ($first_time) {
        print "<tr BGCOLOR=\"#cfcfcf\"><td colspan=$cols>$font1$parent$td2"
              . "</tr>";
        print "<tr>${td1}&nbsp;$td2$td1$child_link$td2";
        $first_time = 0;
      }
      else {
        print "<tr>${td1}&nbsp;$td2$td1$child_link$td2";
      }
      $sg = &process_child_qualifier($dept_sg{$child});
      $cust_fc = &process_child_qualifier($dept_cust_fc{$child});
      $std_fc = &process_child_qualifier($dept_std_fc{$child});
      if ($std_fc eq '&nbsp;') {
        if ($std_equal_cust_fc{$cust_fc}) {
          $std_fc = "\($std_equal_cust_fc{$cust_fc}\)";
        }
      }
      $pc_node = &process_child_qualifier($dept_pc{$child});
      $pcmit0_node = &process_child_qualifier($dept_pcmit0{$child});
      $org_unit = &process_child_qualifier($dept_org{$child});
      $org2_unit = &process_child_qualifier($dept_org2{$child});
      $lds_org = &process_child_qualifier($dept_lds{$child});
      $bag = &process_child_qualifier($dept_bag{$child});
      $siso = &process_child_qualifier($dept_siso{$child});
      if ($option eq '1') {
        print "$td1$sg$td2$td1$std_fc$td2$td1$pc_node$td2$td1$pcmit0_node$td2"
            . "$td1$org_unit$td2$td1$org2_unit$td2$td1$lds_org$td2$td1$bag$td2"
            . "$td1$siso$td2</tr>\n";
      }
      else {
        print "$td1$pc_node$td2"
            . "$td1$org_unit$td2$td1$bag$td2"
            . "$td1$siso$td2</tr>\n";
      }
    }
  }
  print "</table>";
 
}

###########################################################################
#
#  Subroutine print_table2($fontsize, $url_stem, $option)
#
#  Print table - format 2.
#
###########################################################################
sub print_table2 {
  my ($fontsize, $url_stem, $option) = @_;

 #
 #  Set some variables for table headings and data, dependent on font size.
 #
  my ($font1, $font2);
  if ($fontsize eq 'smaller') {
    $font1 = "<font size=\"-1\">";
    $font2 = "</font>";
  }
  else {
    $font1 = "";
    $font2 = "";
  }
  my $td1 = "<td>$font1";
  my $td2 = "$font2</td>";
  my $th1 = "<th>$font1";
  my $th2 = "$font2</th>";

  #
  # Set the list of link types based on the option chosen.
  #
  my @type_list;
  if ($option eq 1) {
    @type_list = ('Spending Group', 'Cust. FC', 'Std. FC',
                  'Std. PC Node', 'PCMIT-0 Node',
                  'Old Org. Unit', 'New Org. Unit', 
                  'LDS Org.', 
                  'NIMBUS B.A.G.', 'SIS Org.')
  }
  else {
    @type_list = ('Std. PC Node', 'Old Org. Unit', 
                  'NIMBUS B.A.G.', 'SIS Org.')
  }
  $rows = @type_list + 1;  # How many rows per dept, including DEPT?

  #
  # Print out the header and the table
  #
  &print_explanation('2');
  if ($fontsize eq 'smaller') {
    print "<small>(Redisplay the table using a <a href=\"$url_stem?"
          . "fontsize=bigger\">bigger</a> font.)</small>";
    print "<P><BR>";
  }
  else {
    print "<small>(Redisplay the table using a <a href=\"$url_stem?"
          . "fontsize=smaller\">smaller</a> font.)</small>";
    print "<P><BR>";
  }
  print "<table border>";
  print "<tr>${th1}Department code$th2"
        . "${th1}Link<br>Type$th2"
        . "${th1}Linked<br>Code$th2${th1}Name$th2</tr>";
  
  my ($child_str, $parent, @child_list, $child_link,
      $this_dept_name, $link_type, $link_code, $link_name);
  my ($sg, $cust_fc, $std_fc, $pc_node, $org_unit, $lds_org, $bag, $siso);
  foreach $parent (sort keys %dept_parent) {
    print "<tr BGCOLOR=\"#cfcfcf\"><td colspan=4>$font1$parent$td2</tr>";
    print "<tr><td colspan=4>$font1&nbsp;$td2</tr>";
    @child_list = split('!', $dept_parent{$parent});
    foreach $child (sort @child_list) {
      $child_str = &web_string($child);
      $child_link = 
        "<a href=\"qualauth.pl?qualtype=DEPT+%28MIT+departments%29"
        . "&rootcode=$child_str&noleaf=N\">$child</a>";
      $this_dept_name = $dept_name{$child};
      print "</tr><td rowspan=$rows valign=\"top\">$font1$child_link$td2"
            . "<td colspan=3>$font1<strong>$this_dept_name</strong>$td2</tr>";
      foreach $link_type (@type_list) {
        $link_code = '&nbsp;';
        $link_name = '&nbsp;';
        SWITCH: {
          if ($link_type eq 'Spending Group') {
            $link_code = &process_child_qualifier($dept_sg{$child});
            $link_name = &process_child_qualifier($dept_sg_name{$child});
            last SWITCH;
          }
          if ($link_type eq 'Cust. FC') {
            $link_code = &process_child_qualifier($dept_cust_fc{$child});
            $link_name = &process_child_qualifier($dept_cust_fc_name{$child});
            last SWITCH;
          }
          if ($link_type eq 'Std. FC') {
            $link_code = &process_child_qualifier($dept_std_fc{$child});
            $link_name = &process_child_qualifier($dept_std_fc_name{$child});
            if ($link_code eq '&nbsp;') {
              #print "link_code for $dept_cust_fc{$child} is blank<BR>";
              if ($std_equal_cust_fc{$dept_cust_fc{$child}}) {
                $link_code = "\($std_equal_cust_fc{$dept_cust_fc{$child}}\)";
                $link_name 
                 = "\($std_equal_cust_fc_name{$dept_cust_fc{$child}}\)";
              }
            }
            last SWITCH;
          }
          if ($link_type eq 'Std. PC Node') {
            $link_code = &process_child_qualifier($dept_pc{$child});
            $link_name = &process_child_qualifier($dept_pc_name{$child});
            last SWITCH;
          }
          if ($link_type eq 'PCMIT-0 Node') {
            $link_code = &process_child_qualifier($dept_pcmit0{$child});
            $link_name = &process_child_qualifier($dept_pcmit0_name{$child});
            last SWITCH;
          }
          if ($link_type eq 'Old Org. Unit') {
            $link_code = &process_child_qualifier($dept_org{$child});
            $link_name = &process_child_qualifier($dept_org_name{$child});
            last SWITCH;
          }
          if ($link_type eq 'New Org. Unit') {
            $link_code = &process_child_qualifier($dept_org2{$child});
            $link_name = &process_child_qualifier($dept_org2_name{$child});
            last SWITCH;
          }
          if ($link_type eq 'LDS Org.') {
            $link_code = &process_child_qualifier($dept_lds{$child});
            $link_name = &process_child_qualifier($dept_lds_name{$child});
            last SWITCH;
          }
          if ($link_type eq 'NIMBUS B.A.G.') {
            $link_code = &process_child_qualifier($dept_bag{$child});
            $link_name = &process_child_qualifier($dept_bag_name{$child});
            last SWITCH;
          }
          if ($link_type eq 'SIS Org.') {
            $link_code = &process_child_qualifier($dept_siso{$child});
            $link_name = &process_child_qualifier($dept_siso_name{$child});
            last SWITCH;
          }
        }
        print "<tr>$td1$link_type$td2$td1$link_code$td2"
              . "$td1$link_name$td2</tr>\n";
      }
      print "<tr><td colspan=4>$font1&nbsp;$td2</tr>";
    }
  }
  print "</table>";
 
}

###########################################################################
#
#  Subroutine get_std_equal_cust_fc($lda, \%std_equal_cust_fc,
#                                   \%std_equal_cust_fc_name);
#
#  Build the hash %std_equal_cust_fc, with $cust_fc -> $std_fc
#    for each custom fund center that has only one child which is
#    a standard FC.  (Also, only include custom fund centers that
#    are directly attached to a department in the DEPT hierarchy).
#
###########################################################################
sub get_std_equal_cust_fc {
  my ($lda, $rstd_equal_cust_fc, $rstd_equal_cust_fc_name) = @_;

  #
  #  Open a cursor to a select statement
  #
  my $stmt = q{
       select /*+ ORDERED */
        q1.qualifier_code, min(q2.qualifier_code), min(q2.qualifier_name)
        from qualifier q1, qualifier q0, qualifier_child qc, qualifier q2
        where q1.qualifier_type = 'FUND'
        and q1.qualifier_code like 'FC%'
        and substr(q1.qualifier_code, 1, 3) = 'FC_'
        and q1.qualifier_code = q0.qualifier_code
        and q0.qualifier_type = 'DEPT'
        and qc.parent_id = q1.qualifier_id
        and q2.qualifier_id = qc.child_id
        and q2.qualifier_code between 'FC000000' and 'FC999999'
        group by q1.qualifier_code
        having count(q2.qualifier_code) = 1
  };
  #print "stmt='$stmt'<BR>";
  my $csr = $lda->prepare("$stmt") or die( $DBI::errstr . "\n"); 
  $csr->execute();
  
  #
  #  Read in rows from the query.  Fill in %std_equal_cust_fc
  #
  my ($cust_fc, $std_fc, $std_fc_name);
  while (($cust_fc, $std_fc, $std_fc_name) =  $csr->fetchrow_array())
  {
    $$rstd_equal_cust_fc{$cust_fc} = $std_fc;
    $$rstd_equal_cust_fc_name{$cust_fc} = $std_fc_name;
  }
  $csr->finish();

}

###########################################################################
#
#  Subroutine get_missing_links($lda);
#
#  Build the hash %missing_qcode, with $qcode -> 1
#    for each PC node, FC, SG, Org. Unit, etc. in the DEPT hierarchy
#    that is no longer associated with an existing qualifier_code 
#    in the COST, FUND, SPGP, ORGU, etc. hierarchies.
#
###########################################################################
sub get_missing_links {
  my ($lda) = @_;

  #
  #  Open a cursor to a select statement
  #
  my $stmt = q{
       select q1.qualifier_code
        from qualifier q1, qualifier q2
        where q1.qualifier_type = 'DEPT'
        and substr(q1.qualifier_code, 1, 2) <> 'D_'
        and q2.qualifier_code(+) = q1.qualifier_code
        and substr(q1.qualifier_code, 1, 4) <> 'LDS_'
        and substr(q1.qualifier_code, 1, 4) <> 'BAG_'
        and substr(q1.qualifier_code, 1, 4) <> 'SIS_'
        and q2.qualifier_type(+) <> 'DEPT'
        and q2.qualifier_code is NULL
       union select q1.qualifier_code
        from qualifier q1, qualifier q2
        where q1.qualifier_type = 'DEPT'
        and substr(q1.qualifier_code, 1, 4) = 'LDS_'
        and q2.qualifier_code(+) = substr(q1.qualifier_code, 5)
        and q2.qualifier_type(+) = 'LORG'
        and q2.qualifier_code is NULL
       union select q1.qualifier_code
        from qualifier q1, qualifier q2
        where q1.qualifier_type = 'DEPT'
        and substr(q1.qualifier_code, 1, 4) = 'SIS_'
        and q2.qualifier_code(+) = substr(q1.qualifier_code, 5)
        and q2.qualifier_type(+) = 'SISO'
        and q2.qualifier_code is NULL
       union select q1.qualifier_code
        from qualifier q1, qualifier q2
        where q1.qualifier_type = 'DEPT'
        and substr(q1.qualifier_code, 1, 4) = 'BAG_'
        and q2.qualifier_code(+) = substr(q1.qualifier_code, 5)
        and q2.qualifier_type(+) = 'BAGS'
        and q2.qualifier_code is NULL
        order by 1
  };
  #print "stmt='$stmt'<BR>";
  my $csr = $lda->prepare("$stmt") or die( $DBI::errstr . "\n");
 $csr->execute();
  
  #
  #  Read in rows from the query.  Fill in %missing_qcode
  #
  my $qcode;
  while (($qcode) = $csr->fetchrow_array() )
  {
    $missing_qcode{$qcode} = 1;
  }
  $csr->finish();

}

###########################################################################
#
#  Function process_child_qualifier($qcode)
#
#  Return the html fragment to be displayed in a table for the
#  given qualifier_code (a child link from a department).
#  If it is null, return '&nbsp;'.
#  Otherwise, return the $qcode, but 
#   if it is a missing link, first wrap <font color="red">...</font>
#   around it.
#
#  Uses the hash %missing_qcode to find missing links.
#
###########################################################################
sub process_child_qualifier {
  my ($qcode) = @_;
  if (!($qcode)) {
    return '&nbsp;';
  }
  if ($qcode =~ /<BR>/) {
    my @qcode_list = split('<BR>', $qcode);
    my $i;
    my $n = @qcode_list;
    for ($i = 0; $i < $n; $i++) {
      if ($missing_qcode{$qcode_list[$i]}) {  # Mark missing links in red
        $qcode_list[$i] = "<font color=\"red\">$qcode_list[$i]</font>";
      }
      $qcode = join('<BR>', @qcode_list);
    }
  }
  else {
    if ($missing_qcode{$qcode}) {  # Mark missing links in red
      $qcode = "<font color=\"red\">$qcode</font>";
    }
  }
  return $qcode;
}

###########################################################################
#
#  Subroutine print_explanation($option);
#
#  Prints explanatory text at the top of the html document.
#
###########################################################################
sub print_explanation {
 my ($option) = @_;

 if ($option eq '1') {
print << 'ENDOFTEXT';
<small>
Below is a tabular display of DLCs in the DEPT hierarchy. Note the following:
<ul>
<li>The gray bands represent "parent" nodes within the DEPT hierarchy.  
Department codes below a gray band are children of the parent node.
<li>Each column shows the Spending Groups, Custom Fund Centers,
Standard Fund Centers, Profit Center nodes, etc., associated with each
DLC.  If a cell is blank, it means that there is no link from
a given DLC to that qualifier type.
<li>Parenthesized Fund Centers in the "Std. FC" column (Standard Fund 
Center) are not explicitly included in the DEPT hierarchy, but are implied by 
a specified Custom Fund Center. 
A Standard Fund Center 
is implied when the Custom Fund Center has only one child and that child 
is a standard Fund Center.
<li>Qualifiers marked in <font color="red">red</font> are obsolete links
that should be changed.
<li>To follow the child links for a given department, click on the department 
code. From the DEPT hierarchy display, you 
can click on an asterisk following each child node for more information.
</ul>
</small>
ENDOFTEXT
 }
 else {
print << 'ENDOFTEXT';
<small>
Below is a tabular display of DLCs in the DEPT hierarchy. Note the following:
<ul>
<li>The gray bands represent "parent" nodes within the DEPT hierarchy.  
Department codes below a gray band are children of the parent node.
<li>Each row shows a Spending Group, Custom Fund Center,
Standard Fund Center, Profit Center node, etc., associated with a
DLC.  If a cell is blank, it means that there is no link from
a given DLC to that qualifier type.
<li>Parenthesized Fund Centers in the "Std. FC" column (Standard Fund 
Center) are not explicitly included in the DEPT hierarchy, but are implied by 
a specified Custom Fund Center. 
A Standard Fund Center 
is implied when the Custom Fund Center has only one child and that child 
is a standard Fund Center.
<li>Qualifiers marked in <font color="red">red</font> are obsolete links
that should be changed.
<li>To follow the child links for a given department, click on the department 
code. From the DEPT hierarchy display, you 
can click on an asterisk following each child node for more information.
</ul>
</small>
ENDOFTEXT
 }
}


###########################################################################
#
#  Function &web_string($astring)
#
#  Converts spaces to '+', left parentheses to %28, 
#   right parentheses to %29, and '&' to %26.
#
###########################################################################
sub web_string {
    my ($astring) = $_[0];
    $astring =~ s/ /+/g;
    $astring =~ s/\(/%28/g;
    $astring =~ s/\)/%29/g;
    $astring =~ s/\&/%26/g;
    $astring;
}


