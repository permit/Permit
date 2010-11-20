#!/usr/bin/perl
###########################################################################
#
#  CGI script to find the CO supervisors associated with a Department.
#
#
#  Copyright (C) 2001-2010 Massachusetts Institute of Technology
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
#  Jim Repa 7/12/2001
#  Modified 1/28/2002  New parameters admin_fc_only and show_mitid.
#  Modified 12/4/2002  Change spelling of Authorizer
#
###########################################################################
#
# Get packages
#
 #use rolesweb('login_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('login_dbi_sql'); 
 use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
 use rolesweb('parse_authentication_info'); #Use sub. parse_authentication_info in rolesweb.pm
 use rolesweb('check_auth_source'); #Use sub. check_auth_source in rolesweb.pm
 use rolesweb('verify_metaauth_category'); #Use sub. verify_metaauth_category
 use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm

#
#  Web documents definitions
#
 $host = $ENV{'HTTP_HOST'};
 $url_stem = "http://$host/cgi-bin/rolequal1.pl?";
 $url_stem2 = "http://$host/cgi-bin/rolecc_info.pl?cost_object=";
 $main_url = "http://$host/webroles.html";

#
#  HTML files read by this program to build output
#
 $html_file = "../htdocs/req_auth.html";

#
#  More constants
#
 $0 =~ /([^\/]*)$/;  # Find string past the last / in full prog. path
 $progname = $1;    # Set $progname to this string.
 $cat = 'SAP';  # Category for which to check meta-authorization
 $cat2 = 'META';  # 2nd category (if first check fails).

#
#  Print out top of the http document.  
#
 print "Content-type: text/html", "\n\n";
 print "<HTML>", "\n";
 print "<HEAD><TITLE>Cost Object Supervisors for a Dept.</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';

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
#  Get department code and other variables from CGI parameters
#
 $deptcode = $formval{'deptcode'};  # Get dept code
 $deptcode = &strip($deptcode);
 $deptcode =~ tr/a-z/A-Z/; # Upper case
 if (substr($deptcode, 0, 2) ne 'D_') {
   $deptcode = 'D_' . $deptcode;
 }
 $admin_fc_only = ($formval{'admin_fc_only'}) ? $formval{'admin_fc_only'}
                                              : 0;
 $show_mitid = ($formval{'show_mitid'}) ? $formval{'show_mitid'}
                                        : 0;

#
#  Parse certificate information
#


($info,$k_principal, $domain)  = &parse_authentication_info();  # Parse certificate into a Perl "hash"

  $full_name = $k_principal;
  $result = &check_auth_source($info); # Check other certificate fields
  if ($result ne 'OK') {
      print "<br><b>Your authentication cannot be accepted: $result";
      exit();
  }
 $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase

use DBI;

#
#  Open connection to oracle
#
my $lda = login_dbi_sql('roles')
	   || &web_error("Oracle error in login. "
          . "The database may be shut down temporarily for backups."
          . "<BR><BR>" .  $DBI::errstr);

#
# Prepare a statement to find all the cost objects associated with a 
# cost object supervisor.
#
 if ($admin_fc_only) {
   $sql_frag = " and w.admin_flag = 'FC'";
 }
 else {
   $sql_frag = "";
 }
 $stmt1 = "select /*+ ORDERED */ w.cost_collector_id_with_type,"
   . " w.cost_collector_name,"
   . " w.admin_flag, q2.qualifier_code"
   . " from wh_cost_collector w, qualifier q, "
   . "  primary_auth_descendent pad,"
   . "  qualifier q2"
   . " where w.supervisor_mit_id = ?"
   . " and q.qualifier_type = 'COST'"
   . " and q.qualifier_code = w.cost_collector_id_with_type"
   . " and w.cost_collector_id = substr(q.qualifier_code, 2)"
   . $sql_frag
   . " and pad.child_id(+) = q.qualifier_id"
   . " and pad.is_dlc(+) = 'Y'"
   . " and q2.qualifier_id(+) = pad.parent_id"
   . " and q2.qualifier_type(+) = 'DEPT'"
   . " order by w.cost_collector_id_with_type";
 #print $stmt1 . "<BR>";
 unless ($gcsr1 = $lda->prepare($stmt1)) 
 {
    print "Error preparing statement 1.<BR>";
    die;
 }

#
# Look up the qualifier
#
 ($qualid, $qualname, $qt_description) 
      = &get_qualifier($lda, 'DEPT', $deptcode);
 #print "deptcode=$deptcode "
 #      . "qualid=$qualid qualname=$qualname qt_desc = $qt_description<br>\n";

#
#  Build the header based on the business function and cost object
#
 
 &print_header("Cost Object Supervisors related to $deptcode", 
               'https');

#
# Make sure the user has a meta-authorization to view $cat authorizations.
# It is also OK if the person has a meta-authorization to view $cat2 
# category authorizations.  (e.g., META or SAP).
#
 if (!(&verify_metaauth_category($lda, $k_principal, $cat))) { # try 1st cat
   if (!(&verify_metaauth_category($lda, $k_principal, $cat2))) { # 2nd cat
     print "<HR><P>";
     print "Sorry. You cannot view the list of Primary Authorizers"
     . " because you do not have the required perMIT DB 'meta-authorization'"
     . " to view other people's $cat authorizations.";
     exit();
   }
 }
#
#  Print out introductory paragraph
# 
 print << 'ENDOFTEXT';
<p>
<small>
This report does the following:
<ol>
<li>Finds all people who are a Cost Object supervisor for at least one
Cost Object (with Admin Flag = 'FC' [faculty controlled]) linked to the 
given department.  (In this case, we only consider
the direct links between a Cost Object and its Profit Center to the department;
we do not consider additional departments linked via a parent WBS Element.)
<li>Finds all Cost Objects supervised by those CO Supervisors, whether they
are in the original department or not.
</ol>
</small>
ENDOFTEXT
 #print 'Note that the "Cost Collector Dept." shown is the one associated '
 #. 'with the Cost Objects's Profit Center. We do not show additional '
 #. 'departments linked to a Cost Object via a parent WBS Element.';
 if ($admin_fc_only) {
   print "<small>For each CO Supervisor, the report shows only"
         . " cost objects with an Admin flag of FC (faculty controlled)."
         . " People with a \"DEPT. HEAD REPORTING\" authorization for"
         . " $deptcode can report on these cost objects.</small>";
 }
 else {
   print "<blockquote>";
   print "<TABLE border>";
   print "<CAPTION><small>Key to ADMIN_FLAG values</small></CAPTION>";
   %admin_flag_desc = ();
   &set_admin_flag_hash(\%admin_flag_desc);
   foreach $key (sort keys %admin_flag_desc) {
   print "<TR><TD><small>" . $key 
         . "</small></TD><TD><small>"
         . $admin_flag_desc{$key}
         . "</small></TD></TR>";
   }
   print "</TABLE>"
         . "</small>"
         . "</blockquote>";
 }
 print "<p>";
 print "<HR><P>";

#
#  Call subroutine &print_supervisor_list to print out list of 
#  CO supervisors for COs within the given department, and then
#  print out a list of COs (in and out of the given department)
#  supervised by each of the CO supervisors.
#
 $gsuper_count = 0; # Global counter for CO supervisors
 $gtotal_co_count = 0; # Counter for Cost Objects
 $gflagged_co_count = 0; # Counter for COs with appropriate ADMIN_FLAG
 &print_supervisor_list($lda, $deptcode, $qualname);
 print "<P>";
 
#
#  
#
 print "<HR>";
 print "<p><small>$gsuper_count CO supervisors displayed.</small><BR>";
 print "<small>$gtotal_co_count total cost objects displayed.</small><BR>";
 print "<small>$gflagged_co_count cost objects displayed with ADMIN_FLAG='FC'"
       . ".</small><BR>";

 exit(0);

###########################################################################
#
#  Subroutine get_qualifier(
#  Given a qualifier_type and qualifier_code, looks in the qualifier
#  table and returns the qualifier_id and qualifier_name.
#
###########################################################################
sub get_qualifier {
  my ($lda, $qtype, $qcode) = @_;

  #
  #  Do query against the qualifier table
  #
 my @stmt = ("select q.qualifier_id, q.qualifier_name, qt.qualifier_type_desc"
   . " from qualifier q, qualifier_type qt"
   . " where q.qualifier_type = '$qtype'"
   . " and q.qualifier_code = '$qcode'"
   . " and qt.qualifier_type = q.qualifier_type");
 my ($qualid, $qualname, $qt_description) = &ora_fetch($csr);

 my $csr = $lda->prepare("$stmt") or die( $DBI::errstr . "\n");

 $csr->execute();

 my ($qualid, $qualname, $qt_description)  =  $csr->fetchrow_array();

 $csr->finish();

  #
  #  Return the values.
  #
  
  return ($qualid, $qualname, $qt_description);
}

###########################################################################
#
#  Subroutine print_supervisor_list
#
###########################################################################
sub print_supervisor_list {
  my ($lda, $dept_code) = @_;

  #
  #  Build a select statement to find CO supervisors associated with 
  #  a given department.
  #
  my $stmt = "select /*+ ORDERED */ distinct w.supervisor, w.supervisor_mit_id"
   . " from qualifier q1, primary_auth_descendent pad, qualifier q2,"
   . "      wh_cost_collector w0, wh_cost_collector w"
   . " where q1.qualifier_type = 'DEPT'"
   . " and q1.qualifier_code = '$dept_code'"
   . " and pad.parent_id = q1.qualifier_id"
   . " and q2.qualifier_id = pad.child_id"
   . " and q2.qualifier_type = 'COST'"
   . " and q2.qualifier_code like 'PC%'"
   . " and w0.profit_center_id = replace(q2.qualifier_code, 'PC', 'P')"
   . " and w0.admin_flag = 'FC'"  # Added 10/9/2001
   . " and w.supervisor_mit_id = w0.supervisor_mit_id";

  #
  #  Hide or show supervisors' MIT IDs depending on URL parameter.
  #
   if ($show_mitid) {
     $mitid_header = 'Supervisor<br>MIT ID';
   }
   else {
     $mitid_header = '&nbsp;';
   }

  #
  #  Print a list of supervisors and their cost objects
  #
  #print $stmt . "<BR>\n";
  my $csr = $lda->prepare("$stmt") or die( $DBI::errstr . "\n");
  my $n = 0;
  my $old_aaqc = '';

  $csr->execute();

  while (($cosuper_name, $cosuper_id)  =  $csr->fetchrow_array())
  {
    $n++;
    if ($n == 1) {
      print "<TABLE>", "\n";
      printf "<TR><TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH>"
             . "<TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH>"
             . "<TH ALIGN=LEFT>%s</TH><TH ALIGN=LEFT>%s</TH></TR>\n",
             'Supervisor<BR>Name', $mitid_header,
             'Cost<br>Collector<br>Code', 'Admin<br>Flag',
             'Cost<br>Collector<br>Name', 
             'Cost<br>Collector<br>Dept.';
    }
    $csr->finish();
    $print_super_id = ($show_mitid) ? $cosuper_id : '&nbsp;';
    printf "<TR><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT><small>%s</small></TD>"
           . "</TR>\n",
	$cosuper_name, $print_super_id;
    $gsuper_count++;
    &print_co_list($lda, $cosuper_name, $cosuper_id);
  }
  if (!$n) {
    print "<P><I>There are no cost object supervisors for $dept_code</I><BR>";
  }
  else {
    print "</TABLE>", "\n";
  }

}

###########################################################################
#
#  Subroutine print_co_list($lda, $supervisor_name, $supervisor_id)
#
#  Prints the list of Cost Objects for a supervisor.
#
###########################################################################
sub print_co_list {
  my ($lda, $supervisor_name, $supervisor_id) = @_;

  #
  #  Bind the supervisor's MIT ID with the parameter in $gcsr1.
  #
  $gcsr1->bind_param(1, $supervisor_id);
  $gcsr1->execute;
  my $csr = $gcsr1;

  #
  #  Print a list of supervisors and their cost objects
  #
  #print $stmt . "<BR>\n";
  my ($co_code, $co_name, $admin_flag, $co_dept) = ('', '', '', '');
  my ($prev_co_code, $prev_co_name, $prev_admin_flag, $prev_co_dept)
     = ('', '', '', '');
  while ( ($co_code, $co_name, $admin_flag, $co_dept) = $csr->fetchrow_array()) 
  {
    $co_dept = substr($co_dept, 2);
    if ( ($prev_co_code) && ($prev_co_code ne $co_code) ) {
      printf "<TR><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT><small>%s</small></TD>"
             . "<TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TD>"
             . "<TD ALIGN=LEFT><small>%s</small></TD>"
             . "<TD ALIGN=LEFT>%s</TD></TR>\n",
             '&nbsp;', '&nbsp', $prev_co_code, $prev_admin_flag, 
             $prev_co_name, $prev_co_dept;
      $gtotal_co_count++;
      if ($prev_admin_flag eq 'FC') { $gflagged_co_count++; }
    }
    elsif ($prev_co_code) {
      $co_dept = $prev_co_dept . ', ' . $co_dept;
    }
    ($prev_co_code, $prev_co_name, $prev_admin_flag, $prev_co_dept)
      = ($co_code, $co_name, $admin_flag, $co_dept);
  }
  $csr->finish;

  #
  #  Print last CO.
  #
  printf "<TR><TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT><small>%s</small></TD>"
         . "<TD ALIGN=LEFT>%s</TD><TD ALIGN=LEFT>%s</TD>"
         . "<TD ALIGN=LEFT><small>%s</small></TD>"
         . "<TD ALIGN=LEFT>%s</TD></TR>\n",
         '&nbsp;', '&nbsp', $prev_co_code, $prev_admin_flag, 
         $prev_co_name, $prev_co_dept;
  $gtotal_co_count++;
  if ($prev_admin_flag eq 'FC') { $gflagged_co_count++; }

}

########################################################################
#
#  Strips off trailing <cr> and leading and trailing blanks.
#
###########################################################################
sub strip {
  local($s);  #temporary string
  $s = $_[0];
  $s =~ s/\'/\"/;  # Change back-tick to double quote to foil hackers.
  while ($s =~ /[\s\n]$/) {   # Remove trailing <cr> or space
    chop($s);
  }
  while (substr($s,0,1) =~ /^\s/) {
    $s = substr($s,1);
  }
 
  $s;
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
  chomp($time = `date +'%y/%m/%d %H:%M:%S'`);
  #print STDERR "***$time $remote_host $k_principal $progname Error.\n";
  exit(0);
}

###########################################################################
#
#  Subroutine set_admin_flag_hash(\%admin_flag_desc)
#  Prints an error message and exits.
#
###########################################################################
sub set_admin_flag_hash {
  my ($r_admin_flag_desc) = @_;
  %$r_admin_flag_desc = 
      ('AL' => 'Allocation cost object',
       'CG' => 'Core grant',
       'CR' => 'Custodial Responsibility',
       'DP' => 'DLC administered',
       'FC' => 'Faculty administered',
       'NS' => 'NSF Shortfall',
       'RA' => 'Research assistant support', 
       'RT' => 'Research Telephone',
       'SP' => 'Service provider (facility)',
      );
}

