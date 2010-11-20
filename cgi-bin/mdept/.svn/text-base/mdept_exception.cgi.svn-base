#!/usr/bin/perl
###########################################################################
#
#  CGI script to display some miscellaneous reports.  These reports
#  require certificates and meta-authorizations to display category SAP
#  authorizations for others
#
#
#  Copyright (C) 2007-2010 Massachusetts Institute of Technology
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
#  Modified 1/25/2007.  Added PBM
#  Modified 2/7/2007.   Added report 7: PC vs 6-digit HR org unit links
#  Modified 2/13/2007.  Minor improvement to report 7 (for unlinked objects)
#  Modified 2/20/2007.  Change text description for report 7
#  Modified 2/27/2007.  Add report 8: erroneous or obsolete linked objects
#  Modified 11/9/2007.  Add report 9, which shows mappings between any
#                       two object types
#  Modified 1/223/2009. Adjust SQL statements in report2 and report4 for
#                       improved performance under Oracle 10g
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
use mdeptweb('print_mdept_header'); #Use sub. print_mdept_header in mdeptweb.pm
use MDept('get_object_names');  #Use sub. get_object_names in MDept.pm

#
#  Constants
#
 $g_owner = 'mdept$owner';
 $host = $ENV{'HTTP_HOST'};
 $link_url1 = "http://$host/cgi-bin/mdept/view_qual_tree.cgi?"
    . "code_position=LEFT&levels=3&path_from_root=1&";
 #$link_url2 = "http://rolesweb.mit.edu/cgi-bin/qualauth.pl?";
 $link_url2 = "http://$host/cgi-bin/qualauth.pl?";

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
#  Set some constants.
#
@title = (
   'DLCs or nodes linked to multiple parent nodes',
   'Objects linked to more than one DLC within the same view type', 
   'Profit Centers linked to different DLCs in the PCMIT-0 and standard hierarchies', 
   'Objects that are not linked to any DLC',
   'HR org units linked to different DLCs in the new (8-digit) and old (6-digit) hierarchies',
   'History of changes to DLCs, nodes, and object links',
   'Profit Centers and 6-digit HR org units with mismatched DLC links',
   'Obsolete or erroneous objects linked to a DLC',
   'Mapping between two different types of objects'
 );
$host = $ENV{'HTTP_HOST'};

#
#  Get form variables
#
$report_num = $formval{'report_num'};
if (! $report_num) {$report_num = 1;}
$g_obj_type1 = $formval{'obj_type1'};
$g_obj_type2 = $formval{'obj_type2'};

#
#  Print out top of the http document.  
#
 print "Content-type: text/html\n\n";  # Start generating HTML document
 $header = $title[$report_num - 1];
 print "<head><title>$header</title></head>\n<body>";
 print '<BODY bgcolor="#fafafa">';
 &print_mdept_header
    ($header, 'https');
 print "<P>";

#
#  Parse certificate information
#
$info = $ENV{"REMOTE_USER"};  # Get certificate information
#print "INFO:'$info'";
%ssl_info = &parse_authentication_info($info);  # Parse certificate into a Perl "hash"
#print "SSL INFO:'$ssl_info'";
$full_name = $ssl_info{'CN'};   # Get full name from cert. 'CN' field
($k_principal, $domain) = split("\@", $info);
#print "PRINCIPAL INFO:'$k_principal'";
if (!$k_principal) {
    print "<br><b>No certificate sent.  Use https:// , not http://</b>\n";
    exit();
}
$k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase

#  Get set to use Oracle.
#
use DBI;

#
#  Open connection to oracle
#
$lda = &login_dbi_sql('mdept') 
      || &web_error($DBI::errstr);

#
#  Print out the header
#
 #$header = $title[$report_num - 1];
 #print "<HTML>", "\n";
 #print "<HEAD><TITLE>$header",
 #      "</TITLE></HEAD>", "\n";
 #print "<BODY><H1>$header</H1>","\n";

#
#  Call the appropriate report
#
 if ($report_num == 1) {
   &report1($lda);
 }
 elsif ($report_num == 2) {
   &report2($lda);
 }
 elsif ($report_num == 3) {
   &report3($lda);
 }
 elsif ($report_num == 4) {
   &report4($lda);
 }
 elsif ($report_num == 5) {
   &report5($lda);
 }
 elsif ($report_num == 6) {
   &report6($lda);
 }
 elsif ($report_num == 7) {
   &report7($lda);
 }
 elsif ($report_num == 8) {
   &report8($lda);
 }
 elsif ($report_num == 9) {
   &report9($lda);
 }
 else {
     print "Report number '$report_num' does not exist<BR>\n";
 }

#
#  Drop connection to Oracle.
#
$lda->disconnect() || &web_error("can't log off Oracle");

#
#  Print end of the HTML document.
#
 print "</BODY></HTML>", "\n";
 exit(0);



sub cert_check {

    my $info = $ENV{"REMOTE_USER"};  # Get certificate information
    my %ssl_info = &parse_ssl_info($info);  # Parse certificate

    my $full_name = $ssl_info{'CN'};   # Get full name from cert. 'CN' field

    my ($k_principal, $domain) = split("\@", $info);
    $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase

#    print "Email: $email<br>\n";
#    print "Full name $full_name<br>\n";

    if (!$k_principal) {
        print "<HTML>", "\n";
        print "<br><b>No certificate sent.  Use https:// , not http://</b>\n";
        print "</HTML>", "\n";
        exit();
    }

#
#  Check the other fields in the certificate
#
    my $result = &check_cert_source($info);
    if ($result ne 'OK') {
        print "<br><b>Your certificate cannot be accepted: $result";
        exit();
    }

    return $k_principal;
}


###########################################################################
#
#  Subroutine report1.
#
#  Generate list of DLCs that have multiple parents in the same view
#
###########################################################################
sub report1 {

  my ($lda) = @_;  # Get Oracle login handle.

  #
  #  Open a cursor for select statement.
  #
  my $stmt = 
   "select vt.view_type_code view_type_code, vt.view_type_desc view_type_desc, d0.d_code child, 
         d1.d_code parent1, d2.d_code parent2
    from $g_owner.view_type vt, $g_owner.view_type_to_subtype vtst1, 
         $g_owner.view_type_to_subtype vtst2, 
         $g_owner.department_child dc1, $g_owner.department_child dc2,
         $g_owner.department d0, $g_owner.department d1, $g_owner.department d2
    where dc1.child_id = dc2.child_id
    and vtst1.view_type_code = vt.view_type_code
    and vtst2.view_type_code = vt.view_type_code
    and dc1.view_subtype_id = vtst1.view_subtype_id
    and dc2.view_subtype_id = vtst2.view_subtype_id
    and dc2.parent_id > dc1.parent_id
    and d0.dept_id = dc1.child_id
    and d1.dept_id = dc1.parent_id
    and d2.dept_id = dc2.parent_id
    order by view_type_code, view_type_desc, child, parent1";

  $csr = $lda->prepare( $stmt)
        || &web_error($DBI::errstr);

  $csr->execute();
  #
  #  Print text
  #
print << 'ENDOFTEXT';
Below is a list of DLCs or nodes that have more than one parent node 
within the same View Type.
<BR><BR>
<HR>
ENDOFTEXT
 
  #
  #  Start printing a table
  #
  print "<TABLE border>\n";
  print "<tr bgcolor=\"#D0D0D0\"><th>View Type</th>
         <th>DLC or Node</th><th>First parent</th><th>Second parent</th>
         </tr>\n";

  #
  #  Process lines from the select statement
  #
  my $count = 0;
  my ($view_type_code, $view_type_desc, 
      $child_code, $parent_code1, $parent_code2);
  while ( ($view_type_code, $view_type_desc, $child_code, 
           $parent_code1, $parent_code2)
         = $csr->fetchrow_array()) 
  {
      print "<tr><td>${view_type_code}. $view_type_desc</td>
             <td>$child_code</td>
             <td>$parent_code1</td><td>$parent_code2</td></tr>\n";
      $count++;
  }
  print "</TABLE>", "\n";
  print "<P>$count lines displayed<BR>";

  $csr->finish() || &web_error("can't close cursor");

}

###########################################################################
#
#  Subroutine report2.
#
#  Display objects linked to more than one DLC within the same view type.
#
###########################################################################
sub report2 {

  my ($lda) = @_;  # Get Oracle login handle.

  #
  #  Get hashes that map object_type_codes into perMIT system qualifier_types
  #  and vice versa.
  #
  my %objtype2qualtype = ();
  my %qualtype2objtype = ();
  &get_objtype2qualtype($lda, \%objtype2qualtype, \%qualtype2objtype);

  #
  #  Open a cursor for select statement.
  #
  my $stmt = 
   "select vt.view_type_code code1, vt.view_type_desc code2,
    ol1.object_type_code code3, ol1.object_code code4, 
    d1.d_code code5, ol1.link_by_object_code code6, d2.d_code code7, ol2.link_by_object_code code8
    from $g_owner.view_type vt, $g_owner.dept_descendent dd1, 
         $g_owner.dept_descendent dd2, 
         $g_owner.expanded_object_link ol1, 
         $g_owner.expanded_object_link ol2, 
         $g_owner.department d1, $g_owner.department d2
    where ol1.object_type_code = ol2.object_type_code
    and ol1.object_code = ol2.object_code
    and d1.dept_id = ol1.dept_id
    and d2.dept_id = ol2.dept_id
    and d2.d_code > d1.d_code
    and dd1.parent_id = vt.root_dept_id
    and dd1.view_type_code = vt.view_type_code
    and dd1.child_id = ol1.dept_id
    and dd2.parent_id = vt.root_dept_id
    and dd2.view_type_code = vt.view_type_code
    and dd2.child_id = ol2.dept_id
    and exists (select vtdt1.leaf_dept_type_id 
                from $g_owner.view_to_dept_type vtdt1
                where vtdt1.view_type_code = vt.view_type_code
                and vtdt1.leaf_dept_type_id = d1.dept_type_id)
    and exists (select vtdt2.leaf_dept_type_id 
                from $g_owner.view_to_dept_type vtdt2
                where vtdt2.view_type_code = vt.view_type_code
                and vtdt2.leaf_dept_type_id = d2.dept_type_id)
    order by code3, code4, code5, code7, code6, code8, code2";

 $csr = $lda->prepare( $stmt)
        || &web_error($DBI::errstr);

  $csr->execute();

  #
  #  Print text
  #
print << 'ENDOFTEXT';
Below is a list of objects linked to more than one DLC within the same 
View Type.
<BR><BR>
ENDOFTEXT
 
  #
  #  Start printing a table
  #
  print "<TABLE border>\n";
  print "<tr bgcolor=\"#D0D0D0\"><th rowspan=2>View Type</th>
         <th rowspan=2>Object type</th><th rowspan=2>Object code</th>
         <th colspan=2>First DLC</th>
         <th colspan=2>Second DLC</th>
         </tr>\n";
  print "<tr bgcolor=\"#D0D0D0\"><th>DLC code</th><th>Linked by</th>
         <th>DLC code</th><th>Linked by</th>
         </tr>\n";

  #
  #  Process lines from the select statement
  #
  my $count = 0;
  my ($view_type_code, $view_type_desc, $object_type_code, $object_code,
      $d_code1, $link_by_code1, $d_code2, $link_by_code2);
  my ($prev_type, $prev_code) = ('', '');
  while ( ($view_type_code, $view_type_desc, $object_type_code, $object_code,
           $d_code1, $link_by_code1, $d_code2, $link_by_code2)
         = $csr->fetchrow_array()) 
  {
      if ($object_type_code ne $prev_type || $object_code ne $prev_code) {
	  print "<tr><td colspan=7>&nbsp;</td></tr>\n";
      }
      my $qualtype = $objtype2qualtype{$object_type_code};
      #print 
      #"object_type_code='$object_type_code' object_code='$object_code'<BR>";
      my $adjusted_obj_code 
          = &adjust_obj_code($object_type_code, $object_code);
      #print "adjusted_obj_code = '$adjusted_obj_code'<br>";
      my $qualstring = 
       "<a href=\"${link_url1}qualcode=${adjusted_obj_code}"
       . "&qualtype=$qualtype\""
       . " target=\"new\">$object_code</a>";
      print "<tr><td>${view_type_code}</td>
             <td>$object_type_code</td><td>$qualstring</td>
             <td>$d_code1</td><td>$link_by_code1</td>
             <td>$d_code2</td><td>$link_by_code2</td></tr>\n";
      $count++;
      ($prev_type, $prev_code) = ($object_type_code, $object_code);
  }
  print "</TABLE>", "\n";
  print "<P>$count lines displayed<BR>";

  $csr->finish() || &web_error("can't close cursor");
}

###########################################################################
#
#  Subroutine report3.
#
#  Display Profit Centers linked to different DLCs via 
#  PC (standard PC hierarchy) and PMIT (PCMIT-0) object types.
#
###########################################################################
sub report3 {

  my ($lda) = @_;  # Get Oracle login handle.

  #
  #  Get hashes that map object_type_codes into perMIT system qualifier_types
  #  and vice versa.
  #
  my %objtype2qualtype = ();
  my %qualtype2objtype = ();
  &get_objtype2qualtype($lda, \%objtype2qualtype, \%qualtype2objtype);

  #
  #  Open a cursor for select statement.
  #
    #where x1.object_type_code(+) = 'PMIT'
  my $stmt = 
   "select distinct x1.object_code code1, 
         x1.d_code code2, x1.link_by_object_code code3,
         x2.d_code code4, x2.link_by_object_code code5
    from ${g_owner}.wh_expanded_object_link x1, 
         ${g_owner}.wh_expanded_object_link x2
    where x1.object_type_code = 'PMIT'
    and x2.object_type_code = 'PC'
    and x2.object_code = x1.object_code
    and x2.view_type_code = x1.view_type_code
    and x1.d_code < x2.d_code
    union select distinct x1.object_code code1, 
         x1.d_code code2, x1.link_by_object_code code3,
         'none' as code4, '&nbsp;' as code5
    from ${g_owner}.wh_expanded_object_link x2 
         left outer join ${g_owner}.wh_expanded_object_link x1
    ON ( x2.object_code = x1.object_code and
    x2.view_type_code = x1.view_type_code)
    where x1.object_type_code = 'PMIT'
    and x1.object_code between 'P000000' and 'P999999'
    and x2.object_type_code = 'PC'
    and x2.d_code is null
    union select distinct x2.object_code code1, 'none' as code2, '&nbsp;' as code3, 
         x2.d_code as code4, x2.link_by_object_code as code5
    from ${g_owner}.wh_expanded_object_link x1 left outer join
         ${g_owner}.wh_expanded_object_link x2 ON (x1.object_code = x2.object_code and x1.view_type_code = x2.view_type_code)
    where x1.object_type_code = 'PMIT'
    and x2.object_code between 'P000000' and 'P999999'
    and x2.object_type_code = 'PC'
    and x1.d_code is null
    order by code1, code2, code3, code4, code5";
  #print "'$stmt'<BR>\n";
 $csr = $lda->prepare( $stmt)
        || &web_error($DBI::errstr);

  $csr->execute();

  #
  #  Print text
  #
print << 'ENDOFTEXT';
Below is a list of Profit Centers linked to different DLCs via 
PC (standard PC hierarchy) and PMIT (PCMIT-0) object types.
<BR><BR>
ENDOFTEXT
 
  #
  #  Start printing a table
  #
  print "<TABLE border>\n";
  print "<tr bgcolor=\"#D0D0D0\">
         <th colspan=3>PCMIT-0 link</th><th>&nbsp;</th>
         <th colspan=3>Standard PC link</th>
         </tr>\n";
  print "<tr bgcolor=\"#D0D0D0\">
         <th>Profit Center</th><th>DLC code</th><th>Linked by</th>
         <th>&nbsp;</th>
         <th>Profit Center</th><th>DLC code</th><th>Linked by</th>
         </tr>\n";

  #
  #  Process lines from the select statement
  #
  my $count = 0;
  my ($object_code,
      $d_code1, $link_by_code1, $d_code2, $link_by_code2);
  my ($prev_type, $prev_code) = ('', '');
  my $qualtype1 = $objtype2qualtype{'PMIT'};
  my $qualtype2 = $objtype2qualtype{'PC'};
  while ( ($object_code,
           $d_code1, $link_by_code1, $d_code2, $link_by_code2)
         = $csr->fetchrow_array()) 
  {
      #print "'$view_type_code', '$object_code', '$d_code1', '$d_code2'<BR>";
      #if ($object_type_code ne $prev_type || $object_code ne $prev_code) {
      #   print "<tr><td colspan=6>&nbsp;</td></tr>\n";
      #}
      my $temp_pc = $object_code;
      $temp_pc =~ s/P/PC/;
      $temp_pc =~ s/0PC/0HPC/;
      my $pmit_link = 
       "<a href=\"${link_url1}qualcode=${temp_pc}&qualtype=$qualtype1\""
       . " target=\"new\">$object_code</a>";
      my $pc_link = 
       "<a href=\"${link_url1}qualcode=${temp_pc}&qualtype=$qualtype2\""
       . " target=\"new\">$object_code</a>";

      print "<tr><td>$pmit_link</td><td>$d_code1</td><td>$link_by_code1</td>
             <td>&nbsp;</td>
             <td>$pc_link</td><td>$d_code2</td><td>$link_by_code2</td></tr>\n";
      $count++;
      ($prev_type, $prev_code) = ($object_type_code, $object_code);
  }
  print "</TABLE>", "\n";
  print "<P>$count lines displayed<BR>";

  $csr->finish() || &web_error("can't close cursor");
}

###########################################################################
#
#  Subroutine report4.
#
#  Find leaf-level objects not linked to any DLC.
#
###########################################################################
sub report4 {

  my ($lda) = @_;  # Get Oracle login handle.

  #
  #  Get hashes that map object_type_codes into perMIT system qualifier_types
  #  and vice versa.
  #
  my %objtype2qualtype = ();
  my %qualtype2objtype = ();
  &get_objtype2qualtype($lda, \%objtype2qualtype, \%qualtype2objtype);

  #
  #  Get hash that maps object_type_codes to their descriptions
  #
  my %objtype2description = ();
  &get_objtype2description($lda, \%objtype2description);

  #
  #  Get a list of qualifiers that are not linked to any DLC
  #
   my @non_dlc_id_list = ();
   &get_non_dlc_dept_id_list($lda, \@non_dlc_id_list);  
   my $n = @non_dlc_id_list;
   my $sql_non_dlc_frag = '';
   if ($n) {
       $sql_non_dlc_frag = 'and dept_id not in ('
           . join(',', @non_dlc_id_list)
           . ')';
   }
   #print "sql frag = '$sql_non_dlc_frag'<BR>";

  #
  #  Open a cursor for select statement.
  #
         #decode(substr(q.qualifier_code, 1, 2), 'PC', 
         #       decode(substr(q.qualifier_code, 1, 3), 'PCM', q.qualifier_code,
         #          replace(q.qualifier_code, 'PC', 'P')),
         #       q.qualifier_code)
       #or ( (translate(q.qualifier_code, '0123456789', '0000000000') = '000000'
  my $stmt = 
    "select ot.object_type_code code1, ot.roles_qualifier_type code2, 
         q.qualifier_code as code3, q.qualifier_name
     from ${g_owner}.object_type ot, rolesbb.qualifier q
     where ot.object_type_code in ('BAG', 'ORGU', 'ORG2', 'PBM', 'PMIT', 
                                   'SPGP', 'SIS', 'LORG')
     and 
     (ot.object_type_code <> 'LORG' 
       or ( q.qualifier_code REGEXP '^[0-9]{6}\$' 
            or q.qualifier_code REGEXP '^7[0-9]{7}\$') 
     )
     and q.qualifier_type = ot.roles_qualifier_type
     and q.has_child = 'N'
     and not exists (select xl.dept_id from ${g_owner}.expanded_object_link xl
       where xl.object_type_code = ot.object_type_code
       and xl.object_code = 
	 CASE substr(q.qualifier_code, 1, 2) 
		WHEN 'PC' THEN CASE substr(q.qualifier_code, 1, 3) WHEN 'PCM' THEN q.qualifier_code ELSE replace(q.qualifier_code, 'PC','P') END
                ELSE q.qualifier_code END 
       and q.qualifier_type = ot.roles_qualifier_type
       $sql_non_dlc_frag)
    union 
    select 'FC' as code1, 'FUND' as code2, q1.qualifier_code as code3, q1.qualifier_name
       from rolesbb.qualifier q1
     where q1.qualifier_type = 'FUND'
     and q1.qualifier_code in
    (select  distinct q.qualifier_code 
     from rolesbb.qualifier q, rolesbb.qualifier_child qc, rolesbb.qualifier q2
     where q.qualifier_type = 'FUND'
     and q.qualifier_code like 'FC%'
     and q.qualifier_code between 'FC000000' and 'FC999999'
     and q.has_child = 'Y'
     and qc.parent_id = q.qualifier_id
     and q2.qualifier_id = qc.child_id
     and q2.qualifier_code REGEXP '^F[0-9]{7}\$'
     and q.qualifier_code not in ( 
     select distinct xl.object_code
      from ${g_owner}.expanded_object_link xl
      where xl.object_type_code = 'FC'
      and xl.object_code between 'FC000000' and 'FC999999'
      $sql_non_dlc_frag))
    union select 'PC' as code1, 'COST' as code2, q1.qualifier_code as code3, q1.qualifier_name
       from rolesbb.qualifier q1
     where q1.qualifier_type = 'COST'
     and q1.qualifier_code in 
     (select q1.qualifier_code
       from rolesbb.qualifier q1
     where q1.qualifier_type = 'COST'
     and q1.qualifier_code like 'PC%'
     and q1.qualifier_code not in (
     select code from (select distinct replace(xl.object_code, 'P', 'PC') as code
      from ${g_owner}.expanded_object_link xl
      where xl.object_type_code = 'PC'
      and xl.object_code between 'P000000' and 'P999999'
      $sql_non_dlc_frag) as x ))
    order by code1, code3";
  #print "'$stmt'<BR>\n";
 $csr = $lda->prepare( $stmt)
        || &web_error($DBI::errstr);

  $csr->execute();

  #
  #  Print text
  #
print << 'ENDOFTEXT';
The following table shows a list of objects from applicable 
perMIT system hierarchies that are not linked to any DLC in the Master 
Department Hierarchy.  At the bottom of this document, there is a 
table of <a href="#summary">summary information</a> about these 
exceptions.
<blockquote>
<i>The objects shown are either at the leaf level of the hieararchy, or they 
are the lowest level objects in the hierarchy that you would link
to a DLC (e.g., Profit Centers and Funds Centers).  Even though the 
problematic object is shown at the lowest level, it may be appropriate
to link a parent or grandparent object to a DLC to fix the problem.
<P />
Note that only Funds Centers that are directly connected to Funds are shown
below.  When there is an error in SAP master data and a Funds Center
has both Funds Centers and Funds as child objects, then the parent Funds 
Center may also appear below.</i>
</blockquote>
<BR><BR>
ENDOFTEXT
 
  #
  #  Start printing a table
  #
  print "<TABLE border>\n";
  #print "<tr bgcolor=\"#D0D0D0\">
  #       <th colspan=3>PCMIT-0 link</th><th>&nbsp;</th>
  #       <th colspan=3>Standard PC link</th>
  #       </tr>\n";
  #print "<tr bgcolor=\"#D0D0D0\">
  #       <th>Profit Center</th><th>DLC code</th><th>Linked by</th>
  #       <th>&nbsp;</th>
  #       <th>Profit Center</th><th>DLC code</th><th>Linked by</th>
  #       </tr>\n";
  print "<tr><th>Object Type</th><th>perMIT system<br>Qualifier Type</th>
         <th>Qualifier code</th><th>Qualifier name</th></tr>\n";

  #
  #  Process lines from the select statement
  #
  my $count = 0;
  my ($objtype, $qualtype);
  my %obj_type_count = ();
  my $prev_objtype = '';
  while ( ($objtype, $qualtype, $qualcode, $qualname)
         = $csr->fetchrow_array()) 
  {
      $count++;
      my $qualstring = 
       "<a href=\"${link_url1}qualcode=${qualcode}"
       . "&qualtype=$qualtype\""
       . " target=\"new\">$qualcode</a>";
      my $objtype_string = ($objtype eq $prev_objtype) 
                           ? $objtype
			   : "<a name=\"$objtype\">$objtype</a>";
      #my $qualstring = 
      # "<a href=\"${link_url2}rootcode=${qualcode}"
      # . "&qualtype=$qualtype\""
      # . " target=\"new\">$qualcode</a>";
      print "<tr><td>$objtype_string</td><td>$qualtype</td>
             <td>$qualstring</td><td>$qualname</td></tr>\n";
      $obj_type_count{$objtype}++;
      $prev_objtype = $objtype;
  }
  print "</TABLE>", "\n";
  print "<p />\n";
  print "<TABLE border>\n";
  print "<caption><a name=\"summary\">Summary</a></caption>\n";
  print "<tr><th>Object Type</th><th>Description</th>"
        . "<th>No. of unlinked<br>objects</th>"
        . "</tr>\n";
  foreach $key (sort keys %obj_type_count) {
    my $objtype_string = "<a href=\"#$key\">$key</a>";
    print "<tr><td align=left>$objtype_string</td>"
        . "<td>$objtype2description{$key}"
        . "<td align=right>$obj_type_count{$key}"
	. "</td></tr>\n";
  }
  print "</table>\n";
  print "<P />Total number of unlinked objects: $count<BR>";

  $csr->finish() || &web_error("can't close cursor");
}

###########################################################################
#
#  Subroutine report5.
#
#  Display HR org units where 8-digit links and 6-digit links are 
#  inconsistent.
#
###########################################################################
sub report5 {

  my ($lda) = @_;  # Get Oracle login handle.

  #
  #  Get hashes that map object_type_codes into perMIT system qualifier_types
  #  and vice versa.
  #
  my %objtype2qualtype = ();
  my %qualtype2objtype = ();
  &get_objtype2qualtype($lda, \%objtype2qualtype, \%qualtype2objtype);

  #
  #  Open a cursor for select statement.
  #
  my $stmt = 
   "select distinct CONCAT(x1.object_code , ' (' , 
                substr(q.qualifier_name, length(qualifier_name)-6,6) , ')') as code1, 
         x1.d_code as code2, x1.link_by_object_code as code3,
         x2.d_code as code4, x2.link_by_object_code as code5
    from ${g_owner}.wh_expanded_object_link x1, 
         ${g_owner}.wh_expanded_object_link x2,
         rolesbb.qualifier q
    where x1.object_type_code = 'ORG2'
    and x2.object_type_code = 'ORGU'
    and q.qualifier_type = 'ORG2'
    and q.qualifier_code = x1.object_code
    and x2.object_code = substr(q.qualifier_name, length(qualifier_name)-6,6)
    and x2.view_type_code = x1.view_type_code
    and x1.d_code <> x2.d_code
    union select distinct CONCAT(x1.object_code , ' (' , 
               substr(q1.qualifier_name,length(q1.qualifier_name)-6,6) , ')') as code1, 
         x1.d_code as code2, x1.link_by_object_code as code3,
         'none' as code4, '&nbsp;' as code5
    from ${g_owner}.wh_expanded_object_link x1, rolesbb.qualifier q1
    where x1.object_type_code = 'ORG2'
    and q1.qualifier_type = 'ORG2'
    and q1.qualifier_code = x1.object_code
    and substr(q1.qualifier_name, length(q1.qualifier_name), 1) = ')'
    and not exists (select x2.object_code 
                    from rolesbb.qualifier q, 
                         ${g_owner}.wh_expanded_object_link x2
                    where q.qualifier_type = 'ORG2'
                    and q.qualifier_code = x1.object_code
                    and x2.object_type_code = 'ORGU'
                    and x2.d_code = x1.d_code
                    and x2.object_code
                     = substr(q.qualifier_name,length(qualifier_name)-6,6)
                    and x2.view_type_code = x1.view_type_code)
    order by code1, code2, code3, code4, code5";
  #print "'$stmt'<BR>\n";

  $csr = $lda->prepare( $stmt)
        || &web_error($DBI::errstr);

  $csr->execute();

  #
  #  Print text
  #
print << 'ENDOFTEXT';
Below is a list of HR Org units that are linked to different DLCs 
via their 8-digit org units and 6-digit org units.
<BR><BR>
ENDOFTEXT
 
  #
  #  Start printing a table
  #
  print "<TABLE border>\n";
  print "<tr bgcolor=\"#D0D0D0\">
         <th colspan=3>8-digit link</th><th>&nbsp;</th>
         <th colspan=3>6-digit</th>
         </tr>\n";
  print "<tr bgcolor=\"#D0D0D0\">
         <th>HR Org Unit</th><th>DLC code</th><th>Linked by</th>
         <th>&nbsp;</th>
         <th>HR Org Unit</th><th>DLC code</th><th>Linked by</th>
         </tr>\n";

  #
  #  Process lines from the select statement
  #
  my $count = 0;
  my ($object_code,
      $d_code1, $link_by_code1, $d_code2, $link_by_code2);
  my ($prev_type, $prev_code) = ('', '');
  my $qualtype1 = $objtype2qualtype{'ORG2'};
  my $qualtype2 = $objtype2qualtype{'ORGU'};
  while ( ($object_code,
           $d_code1, $link_by_code1, $d_code2, $link_by_code2)
         = $csr->fetchrow_array()) 
  {
      #print "'$view_type_code', '$object_code', '$d_code1', '$d_code2'<BR>";
      #if ($object_type_code ne $prev_type || $object_code ne $prev_code) {
      #   print "<tr><td colspan=6>&nbsp;</td></tr>\n";
      #}
      my $temp_unit8 = substr($object_code, 0, 8);
      my $temp_unit6 = substr($object_code, 10, 6);
      my $org8_link = 
       "<a href=\"${link_url1}qualcode=${temp_unit8}&qualtype=$qualtype1\""
       . " target=\"new\">$temp_unit8</a>";
      my $org6_link = 
       "<a href=\"${link_url1}qualcode=${temp_unit6}&qualtype=$qualtype2\""
       . " target=\"new\">$temp_unit6</a>";

      print "<tr><td>$org8_link</td><td>$d_code1</td><td>$link_by_code1</td>
             <td>&nbsp;</td>
             <td>$org6_link</td><td>$d_code2</td><td>$link_by_code2</td></tr>\n";
      $count++;
      ($prev_type, $prev_code) = ($object_type_code, $object_code);
  }
  print "</TABLE>", "\n";
  print "<P>$count lines displayed<BR>";

  $csr->finish() || &web_error("can't close cursor");
}


###########################################################################
#
#  Subroutine report6.
#
#  Display a history of changes.
#
###########################################################################
sub report6 {

  my ($lda) = @_;  # Get Oracle login handle.

  #
  #  Get a hash of audit_id -> count_of_records.  This will be used
  #  for formatting the report.
  #
   my %audit_id2count;
   &get_audit_id2count($lda, \%audit_id2count);

  #
  #  Open a cursor for select statement.
  #
  my $stmt = 
   "select audit_id as audit_id, mod_by_username, action_date,
       3 as code4, DATE_FORMAT(action_date,'%m/%d/%y %H:%i:%s'),
       CASE action_type WHEN 'I' THEN 'Add' WHEN 'D' THEN 'Delete' WHEN 'U' THEN CONCAT('Update ',old_new) END,
       dept_id, d_code, 'Dept definition',
       short_name, long_name, 
       CONCAT(CAST(dept_type_id AS CHAR) , ' (' , dept_type_desc , ')'), 
       ' ', ' ', ' '
      from $g_owner.department_audit 
    union select audit_id as audit_id, mod_by_username, action_date,
       2 as code4, DATE_FORMAT(action_date,'%m/%d/%y %H:%i:%s'),
       CASE action_type WHEN 'I' THEN 'Add' WHEN 'D' THEN 'Delete' WHEN 'U' THEN CONCAT('Update ',old_new) END,
       child_id, child_d_code, 'Parent link', 
       ' ', ' ', 
       ' ', 
       parent_d_code, CAST(view_subtype_id AS CHAR), ' '
      from $g_owner.dept_child_audit 
    union select audit_id as audit_id, mod_by_username, action_date, 
       1 as code4,  DATE_FORMAT(action_date,'%m/%d/%y %H:%i:%s'),
       CASE action_type WHEN 'I' THEN 'Add' WHEN 'D' THEN 'Delete' WHEN 'U' THEN CONCAT('Update ',old_new) END,
       dept_id, d_code, 'Object link', 
       ' ', ' ', 
       ' ', 
       ' ', ' ',
       CONCAT(object_type_code , ' : ' , object_code)
      from $g_owner.object_link_audit
    order by audit_id, code4";
  #print "'$stmt'<BR>\n";

  $csr = $lda->prepare( $stmt)
        || &web_error($DBI::errstr);

  $csr->execute();

  #
  #  Print text
  #
print << 'ENDOFTEXT';
Below is a table of changes to DLCs.
<BR><BR>
ENDOFTEXT
 
  #
  #  Start printing a table
  #
  print "<TABLE border>\n";
  print "<tr bgcolor=\"#D0D0D0\">
         <th>Modified<br>by</th><th>Modified date</th>
         <th>Type of change</th>
         <th>Action</th>
         <th>Dept ID</th><th>Dept Code</th>
         <th>Long name<br>/Short name</th><th>Dept type</th>
         <th>Parent code</th><th>Parent<br>link type</th>
         <th>Linked object</th>
         </tr>\n";

  #
  #  Process lines from the select statement
  #
  my $count = 0;
  my ($audit_id, $mod_by, $sort_date, $action_date, $sort_action, $action, 
      $dept_id, $dept_code, $change_type, 
      $short_name, $long_name, $dept_type, 
      $parent_code, $parent_link_type, $obj_link);
  my $prev_audit_id = 0;
  my @bgcolor_list = (' bgcolor="#E0E0E0"', '');
  my $bgcolor_switch = 0;
  my $bgcolor;
  my $suppess_modified_field;
  while ( ($audit_id, $mod_by, $sort_date, $sort_action, $action_date, $action,
           $dept_id, $dept_code, $change_type, 
           $short_name, $long_name, $dept_type, 
           $parent_code, $parent_link_type, $obj_link)
         = $csr->fetchrow_array()) 
  {
      #print "'$view_type_code', '$object_code', '$d_code1', '$d_code2'<BR>";
      $action =~ s/</&lt;/;
      $action =~ s/>/&gt;/;
      $action =~ s/ /&nbsp;/;
      if ($audit_id != $prev_audit_id) {
        $bgcolor_switch = ($bgcolor_switch) ? 0 : 1;
        $bgcolor = $bgcolor_list[$bgcolor_switch];
        $prev_audit_id = $audit_id;
        $suppress_modified_field = 0;
      }
      else {$suppress_modified_field = 1;}
      my $xname = ($change_type eq 'Dept definition') 
                  ? "$long_name<BR>/$short_name"
                  : ' ';
      # The next line replaces blanks with '&nbsp;'.
      grep { s/^ $/&nbsp;/ } ($audit_id, $mod_by, $action_date, $action,
                        $dept_id, $dept_code, $change_type, 
                        $xname, $dept_type, 
                        $parent_code, $parent_link_type, $obj_link);
      my $mod_columns = ($suppress_modified_field) 
              ? ""
              : "<td rowspan=$audit_id2count{$audit_id}>$mod_by</td>
                 <td rowspan=$audit_id2count{$audit_id}>$action_date</td>";
      print "<tr $bgcolor>
             $mod_columns
             <td>$change_type</td>
             <td>$action</td><td>$dept_id</td><td>$dept_code</td>
             <td>$xname</td>
             <td>$dept_type</td>
             <td>$parent_code</td>
             <td align=center>$parent_link_type</td>
             <td>$obj_link</td></tr>";
      unless ($action eq 'U' && $old_new eq '>') {$count++;}
  }
  print "</TABLE>", "\n";
  print "<P>$count changes displayed<BR>";

  $csr->finish() || &web_error("can't close cursor");
}

###########################################################################
#
#  Subroutine report7.
#
#  Display 6-digit HR org units where 6-digit links and Profit Center links
#  (for same 6-digit number) are inconsistent.
#
###########################################################################
sub report7 {

  my ($lda) = @_;  # Get Oracle login handle.

  #
  #  Get hashes that map object_type_codes into perMIT system qualifier_types
  #  and vice versa.
  #
  my %objtype2qualtype = ();
  my %qualtype2objtype = ();
   &get_objtype2qualtype($lda, \%objtype2qualtype, \%qualtype2objtype);

  #
  #  Open a cursor for select statement.
  #
  my $stmt = 
   "select distinct x1.object_code as code1,
         x1.d_code as code2, x1.link_by_object_code as code3,
         x2.d_code as code4, x2.link_by_object_code as code5
    from ${g_owner}.wh_expanded_object_link x1, 
         ${g_owner}.wh_expanded_object_link x2
    where x1.object_type_code = 'PMIT'
    and x2.object_type_code = 'ORGU'
    and x2.object_code = substr(x1.object_code, 2)
    and x2.view_type_code = x1.view_type_code
    and x1.d_code <> x2.d_code
    union select distinct replace(q1.qualifier_code, 'PC', 'P') as code1,
       'none' as code2, '&nbsp;' as code3,
       x2.d_code as code4, x2.link_by_object_code as code5
    from rolesbb.qualifier q1, rolesbb.qualifier q2,
         ${g_owner}.wh_expanded_object_link x2
    where q1.qualifier_type = 'PMIT'
    and q2.qualifier_type = 'ORGU'
    and q2.qualifier_code = substr(q1.qualifier_code, 3)
    and x2.object_type_code = 'ORGU'
    and x2.object_code = q2.qualifier_code
    and not exists 
     (select 1 from ${g_owner}.wh_expanded_object_link x1
      where x1.object_type_code = 'PMIT'
      and x1.object_code = CONCAT('P' , q2.qualifier_code))
    union select distinct replace(q1.qualifier_code, 'PC', 'P') as code1,
       x1.d_code as code2, x1.link_by_object_code as code3,
       'none' as code4, '&nbsp;' as code5
    from rolesbb.qualifier q1, rolesbb.qualifier q2,
         ${g_owner}.wh_expanded_object_link x1
    where q1.qualifier_type = 'PMIT'
    and q2.qualifier_type = 'ORGU'
    and q2.qualifier_code = substr(q1.qualifier_code, 3)
    and x1.object_type_code = 'PMIT'
    and x1.object_code = CONCAT('P' , q2.qualifier_code)
    and not exists 
     (select 1 from ${g_owner}.wh_expanded_object_link x2
      where x2.object_type_code = 'ORGU'
      and x2.object_code = q2.qualifier_code)              
    order by code1, code2, code3, code4, code5";
  #print "'$stmt'<BR>\n";
 $csr = $lda->prepare( $stmt)
        || &web_error($DBI::errstr);

  $csr->execute();


  #
  #  Print text
  #
print << 'ENDOFTEXT';
Below is a list of Profit Centers (under the PCMIT-0 hierarchy) 
and 6-digit HR Org units that are linked to different DLCs.
<BR><BR>
ENDOFTEXT
 
  #
  #  Start printing a table
  #
  print "<TABLE border>\n";
  print "<tr bgcolor=\"#D0D0D0\">
         <th colspan=3>Profit Center link</th><th>&nbsp;</th>
         <th colspan=3>Org Unit link</th>
         </tr>\n";
  print "<tr bgcolor=\"#D0D0D0\">
         <th>Profit Center</th><th>DLC code</th><th>Linked by</th>
         <th>&nbsp;</th>
         <th>HR Org Unit</th><th>DLC code</th><th>Linked by</th>
         </tr>\n";

  #
  #  Process lines from the select statement
  #
  my $count = 0;
  my ($object_code,
      $d_code1, $link_by_code1, $d_code2, $link_by_code2);
  my ($prev_type, $prev_code) = ('', '');
  my $qualtype1 = $objtype2qualtype{'PMIT'};
  my $qualtype2 = $objtype2qualtype{'ORGU'};
  while ( ($object_code,
           $d_code1, $link_by_code1, $d_code2, $link_by_code2)
         = $csr->fetchrow_array()) 
  {
      #print "'$view_type_code', '$object_code', '$d_code1', '$d_code2'<BR>";
      #if ($object_type_code ne $prev_type || $object_code ne $prev_code) {
      #   print "<tr><td colspan=6>&nbsp;</td></tr>\n";
      #}
      my $temp_pc = $object_code;
      $temp_pc =~ s/P/PC/;
      my $temp_unit6 = substr($object_code, 1);
      my $pc_link = 
       "<a href=\"${link_url1}qualcode=${temp_pc}&qualtype=$qualtype1\""
       . " target=\"new\">$temp_pc</a>";
      my $org6_link = 
       "<a href=\"${link_url1}qualcode=${temp_unit6}&qualtype=$qualtype2\""
       . " target=\"new\">$temp_unit6</a>";

      print "<tr><td>$pc_link</td><td>$d_code1</td><td>$link_by_code1</td>
             <td>&nbsp;</td>
             <td>$org6_link</td><td>$d_code2</td><td>$link_by_code2</td></tr>\n";
      $count++;
      ($prev_type, $prev_code) = ($object_type_code, $object_code);
  }
  print "</TABLE>", "\n";
  print "<P>$count lines displayed<BR>";

  $csr->finish() || &web_error("can't close cursor");
}

###########################################################################
#
#  Subroutine report8.
#
#  Display erroneous linked objects, i.e., financial, HR, or student systems
#  objects that do not match current objects in the perMIT system qualifier tables
#
###########################################################################
sub report8 {

  my ($lda) = @_;  # Get Oracle login handle.

  #
  #  Get hash mapping perMIT system qualifier_codes into their related
  #  qualifier_names.  We will use this hash to check the existence of
  #  linked objects within the perMIT system qualifier tables.
  #
   my $delim1 = '!#!';
   my %object_code2name = ();
   MDept::get_object_names($lda, $delim1, \%object_code2name);
   #foreach $key (keys %object_code2name) {
   #    print "$key -> $object_code2name{$key}<BR>";
   #}

  #
  #  Open a cursor for select statement.
  #
  my $stmt = 
   "select d.d_code, l.object_type_code, l.object_code
    from ${g_owner}.object_link l, ${g_owner}.department d
    where d.dept_id = l.dept_id
    order by 1, 2, 3";
  #print "'$stmt'<BR>\n";
 $csr = $lda->prepare( $stmt)
        || &web_error($DBI::errstr);

  $csr->execute();


  #
  #  Print text
  #
print << 'ENDOFTEXT';
Below is a list of erroneous or obsolete HR, financial or student systems
objects that are linked to DLCs.
<BR><BR>
ENDOFTEXT
 
  #
  #  Start printing a table
  #
  print "<TABLE border>\n";
  print "<tr bgcolor=\"#D0D0D0\">
         <th>DLC Code</th>
         <th>Linked<br>Object Type Code</th>
         <th>Linked<br>Object Code</th>
         </tr>\n";

  #
  #  Process lines from the select statement
  #
  my $count = 0;
  my ($d_code, $ot_code, $obj_code);
  while ( ($d_code, $ot_code, $obj_code) = $csr->fetchrow_array()) 
  {
      unless ($object_code2name{"$ot_code$delim1$obj_code"}) {
        print "<tr><td>$d_code</td><td>$ot_code</td>
             <td>$obj_code</td></tr>\n";
        $count++;
      }
  }
  print "</TABLE>", "\n";
  print "<P>$count lines displayed<BR>";

  $csr->finish() || &web_error("can't close cursor");
}

###########################################################################
#
#  Subroutine report9.
#
#  Display a report of two types of objects and their links to 
#  DLC codes.
#
###########################################################################
sub report9 {

  my ($lda) = @_;  # Get Oracle login handle.

  my $obj_type1 = $g_obj_type1;
  my $obj_type2 = $g_obj_type2;

  #$obj_type1 = 'SIS';
  #$obj_type2 = 'ORG2';

  #
  #  Get hash mapping perMIT system qualifier_codes into their related
  #  qualifier_names. 
  #
   my $delim1 = '!#!';
   my %object_code2name = ();
   get_object_names_1type($lda, $delim1, $obj_type1, \%object_code2name);
   get_object_names_1type($lda, $delim1, $obj_type2, \%object_code2name);
   #MDept::get_object_names($lda, $delim1, \%object_code2name);
   #foreach $key (keys %object_code2name) {
   #    print "$key -> $object_code2name{$key}<BR>";
   #}
  #
  #  Open a cursor for select statement.
  #
  my $stmt = 
   "select ol1.d_code as code1, ol1.object_code as code2, ol2.object_code as code3
    from $g_owner.wh_expanded_object_link ol1, 
       $g_owner.wh_expanded_object_link ol2
    where ol1.object_type_code = '$obj_type1'
     and ol2.object_type_code = '$obj_type2'
     and ol2.dept_id = ol1.dept_id
     and ol1.view_type_code = 'A'
     and ol2.view_type_code = ol1.view_type_code
     and (ol1.object_type_code <> 'SIS' or ol1.object_code not like '%.%')
     and (ol2.object_type_code <> 'SIS' or ol2.object_code not like '%.%')
    union select ol1.d_code as code1, ol1.object_code as code2, 'n/a' as code3
    from $g_owner.wh_expanded_object_link ol2
     left outer join   $g_owner.wh_expanded_object_link ol1
     ON (ol2.dept_id = ol1.dept_id
     and ol2.view_type_code = ol1.view_type_code)
    where ol1.object_type_code = '$obj_type1'
     and ol2.object_type_code = '$obj_type2'
     and ol1.view_type_code = 'A'
     and ol2.dept_id is null
     and (ol1.object_type_code <> 'SIS' or ol1.object_code not like '%.%')
    order by code2, code3";
  #print "'$stmt'<BR>\n";
 $csr = $lda->prepare( $stmt)
        || &web_error($DBI::errstr);

  $csr->execute();


  #
  #  Print text
  #
  print "Below is a table showing links from objects of type '$obj_type1'", 
      " to DLC Codes",
      "<br>and links from those DLC Codes to objects of type '$obj_type2'.",
      "<BR><BR>";
 
  #
  #  Start printing a table
  #
  print "<TABLE border>\n";
  print "<tr bgcolor=\"#D0D0D0\">
         <th colspan=2>$obj_type1 objects</th>
         <th>Linked via DLC code</th>
         <th colspan=2>$obj_type2 objects</th>
         </tr>\n";
  print "<tr bgcolor=\"#D0D0D0\">
         <th>Code</th><th>Name</th>
         <th>&nbsp;</th>
         <th>Code</th><th>Name</th>
         </tr>\n";

  #
  #  Process lines from the select statement
  #
  my @color = ("#FFFFFF", "#E5E5E5");
  my $color_counter = 1;
  my $curr_color = $color[$color_counter];
  my $prev_code = "";
  my $count = 0;
  my ($dept_code, $ocode1, $ocode2);
  while ( ($dept_code, $ocode1, $ocode2) = $csr->fetchrow_array()) 
  {
      #unless ($object_code2name{"$ot_code$delim1$obj_code"}) {
      my $obj_name1 = $object_code2name{$obj_type1 . $delim1 . $ocode1};
      my $obj_name2 = $object_code2name{$obj_type2 . $delim1 . $ocode2};
      unless ($obj_name1) {$obj_name1 = '?';}
      unless ($obj_name2) {$obj_name2 = '?';}
      if ($ocode1 ne $prev_code) {
	  $color_counter = ( ($color_counter + 1) % 2);
          $curr_color = $color[$color_counter];
      }
      print "<tr bgcolor=\"$curr_color\"><td>$ocode1</td><td>$obj_name1</td>
             <td>$dept_code</td>
             <td>$ocode2</td><td>$obj_name2</td>
             </tr>\n";
      $prev_code = $ocode1;
      $count++;
  }
  print "</TABLE>", "\n";
  print "<P>$count lines displayed<BR>";

  $csr->finish() || &web_error("can't close cursor");
}

###########################################################################
#
#  Subroutine &get_objtype2qualtype($lda, \%objtype2qualtype, 
#                                          \%qualtype2objtype);
#
#  Creates a hash %objtype2qualtype that maps each MDH object_type_code
#                 into a perMIT system qualifier_type.
#  Also creates a hash %qualtype2objtype that maps some perMIT system 
#                      qualifier types into an MDH object_type_code.
#
###########################################################################
sub get_objtype2qualtype {
  my ($lda, $robjtype2qualtype, $rqualtype2objtype) = @_;

  my $stmt = "select object_type_code, roles_qualifier_type
              from ${g_owner}.object_type
              order by 1";
  #print "stmt='$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement object_type: " 
            . $DBI::errstr . "<BR>";
  }

  unless ($csr1->execute) {
      print "Error executing select statement object_type: " 
            . $DBI::errstr . "<BR>";
  }
  
  #
  #  Read in the records and build the hashes
  #
  my ($objtype, $qualtype);
  while ( ($objtype, $qualtype) = $csr1->fetchrow_array ) {
    $$robjtype2qualtype{$objtype} = $qualtype;
    $$rqualtype2objtype{$qualtype} = $objtype;
  }

}

###########################################################################
#
#  Subroutine &get_objtype2description($lda, \%objtype2description);
#
#  Creates a hash %objtype2description that maps each MDH object_type_code
#                 into its description.
#
###########################################################################
sub get_objtype2description {
  my ($lda, $robjtype2description) = @_;

  my $stmt = "select object_type_code, obj_type_desc
              from ${g_owner}.object_type
              order by 1";
  #print "stmt='$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement object_type_desc: " 
            . $DBI::errstr . "<BR>";
  }

  unless ($csr1->execute) {
      print "Error executing select statement object_type_desc: " 
            . $DBI::errstr . "<BR>";
  }
  
  #
  #  Read in the records and build the hashes
  #
  my ($objtype, $desc);
  while ( ($objtype, $desc) = $csr1->fetchrow_array ) {
    $$robjtype2description{$objtype} = $desc;
  }

}

###########################################################################
#
#  Subroutine &get_non_dlc_dept_id_list($lda, \@non_dlc_id_list);
#
#  Finds a list of DEPT_IDs referenced in the object_link table
#       which are not DLCs (looking at dept_type_id).
#  Returns the list in @non_dlc_id_list.
#
###########################################################################
sub get_non_dlc_dept_id_list {
  my ($lda, $rnon_dlc_id_list) = @_;

  my $stmt = "select distinct ol.dept_id as dept_id
              from ${g_owner}.object_link ol, ${g_owner}.department d
              where d.dept_id = ol.dept_id
              and dept_type_id not in (2, 4, 5)
              order by dept_id";
  #print "stmt='$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement select distinct ol.dept_id...: " 
            . $DBI::errstr . "<BR>";
  }

  unless ($csr1->execute) {
      print "Error executing select statement select distinct ol.dept_id...: " 
            . $DBI::errstr . "<BR>";
  }
  
  #
  #  Read in the records and build the array
  #
  my ($dept_id);
  while ( ($dept_id) = $csr1->fetchrow_array ) {
      push(@$rnon_dlc_id_list, $dept_id);
  }

}

###########################################################################
#
#  Subroutine &get_audit_id2count($lda, \%audit_id2count);
#
#  Get a hash mapping an audit_id number to the number of records
#  associated with it.  This will be useful for formatting the 
#  report on DLC changes.
#
###########################################################################
sub get_audit_id2count {
  my ($lda, $raudit_id2count) = @_;

  my $stmt = "select distinct 'DEPARTMENT', audit_id, count(*)
              from ${g_owner}.department_audit 
              group by audit_id
              union select distinct 'DEPT_CHILD_AUDIT', audit_id, count(*)
              from ${g_owner}.dept_child_audit 
              group by audit_id
              union select distinct 'OBJECT_LINK', audit_id, count(*)
              from ${g_owner}.object_link_audit 
              group by audit_id
              order by 2, 1";
  #print "stmt='$stmt'<BR>";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement (counting audit records)...: " 
            . $DBI::errstr . "<BR>";
  }

  unless ($csr1->execute) {
      print "Error executing select statement (counting audit records)...: " 
            . $DBI::errstr . "<BR>";
  }
  
  #
  #  Read in the records and build the hash
  #
  my ($table, $audit_id, $count);
  while ( ($table, $audit_id, $count) = $csr1->fetchrow_array ) {
      $$raudit_id2count{$audit_id} += $count;
  }

}

###########################################################################
#
#  Function &adjust_obj_code($object_type_code, $object_code);
#
#  Returns an adjusted $object_code usable for finding objects in the
#  perMIT system hierarchy.  This will adjust Profit Centers (Pnnnnnn in the
#  MDH, but PCnnnnnn in the perMIT system), etc.
#
###########################################################################
sub adjust_obj_code {
  my ($object_type_code, $object_code) = @_;
 
  my $adjusted_obj_code = $object_code;
  if ($object_type_code eq 'PC' || $object_type_code eq 'PMIT') {
    $adjusted_obj_code =~ s/P/PC/;
    $adjusted_obj_code =~ s/0PC/0HPC/;
  }
  return $adjusted_obj_code;

}

########################################################################
#
#  Subroutine web_error($msg)
#  Prints an error message and exits.
#
###########################################################################
sub web_error {
  my $s = $_[0];
  print $s . "\n";
  die $s . "\n";
}

###########################################################################
#
#  Subroutine 
#   get_object_names_1type($lda, $delim, $object_type, \%object_code2name)
#
#  Gets a hash of object_codes and their names, for one 
#  object type, where 
#     $object_code2name{"$object_type$delim$object_code} = $object_name
#
###########################################################################
sub get_object_names_1type {
  my ($lda, $delim, $object_type, $robject_code2name, $dlc_id) = @_;

  #print "Here we are in 'get_object_names'<BR>";

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
  MDept::get_object_type_info ($lda, \%object_type2qualtype);
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
  #  Define and open a cursor to a select statement for object names
  #
  my $stmt = 
   "select l.object_type_code, l.object_code, q.qualifier_name
    from ${g_owner}.wh_expanded_object_link l, rolesbb.qualifier q
    where l.object_type_code = '$object_type'
    and q.qualifier_code = l.object_code
    and q.qualifier_type = $qual_case 
    and (l.object_type_code <> 'PMIT' 
         or substr(replace(l.object_code, 'PC', 'P'),1,2)
                   not between 'P000000' and 'P999999')
    union select l.object_type_code, l.object_code, q.qualifier_name
    from ${g_owner}.wh_expanded_object_link l, rolesbb.qualifier q
    where l.object_type_code = '$object_type'
    and l.object_type_code in ('PC', 'PMIT')
    and q.qualifier_code = 
      replace(replace(l.object_code, '0P', '0HP'), 'P', 'PC')
    and q.qualifier_type = CASE l.object_type_code WHEN  'PC' THEN  'COST' 
                                 WHEN 'PMIT' THEN  'PMIT' END";
  #print "stmt: '$stmt'<BR>";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  
  #
  #  Get object codes and their names
  #
  my ($object_type, $object_code, $object_name);
  #%$robject_code2name = ();  Do not clear the hash
  while ( ($object_type, $object_code, $object_name) = $csr->fetchrow_array ) {
    $$robject_code2name{"$object_type$delim$object_code"} = $object_name;
  }

}
