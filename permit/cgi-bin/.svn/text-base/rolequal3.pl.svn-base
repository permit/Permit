#!/usr/bin/perl
###########################################################################
#
#  CGI script to list qualifiers for which a given user is
#  authorized for a given function.
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
#  From the form, get the kerbname and function_id.
#  From the database, get function_name and related qualifier_type.
#  Select a.Qualifier_id, q.qualifier_code, q.Qualifier_name
#    from Authorization A, QUALIFIER Q 
#    where kerberos_name = $kerbname 
#    and function_id = '$functionid'
#    and A.qualifier_id = Q.qualifier_id
#    and a.do_function = 'Y' and a.effective_date <= sysdate
#    and nvl(expiration_date,sysdate) >= sysdate
#    order by q.qualifier_code;
#  Remove elements from the list if they are children of other items in
#    the list.
#  Call get_quals for each of these qualifiers.
#
#
###########################################################################
#
# Get packages
#
use rolesweb('login_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('login_dbi_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
use rolesweb('parse_authentication_info'); #Use sub. parse_authentication_info in rolesweb.pm
use rolesweb('check_auth_source'); #Use sub. check_auth_source in rolesweb.pm
use rolesweb('verify_metaauth_category'); #Use sub. verify_metaauth_category
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm

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
#  Set stem for URLs
#
 $host = $ENV{'HTTP_HOST'};
 $url_stem = "http://$host/cgi-bin/rolequal1.pl?";
 $url_stem2 = "https://$host/cgi-bin/rolequal3.pl?";
 $url_stem3 = "http://$host/cgi-bin/rolecc_info.pl?";
 $main_url = "http://$host/webroles.html";

#
#  Print out beginning of document
#
 print "Content-type: text/html", "\n\n";
 print "<HTML>", "\n";

#
#  Get variables from form
#
$kerbname = $formval{'kerbname'};  # Get value set in &parse_forms()
$kerbname =~ tr/a-z/A-Z/;
$function_id = $formval{'functionid'};
$orig_function_id = $function_id;
$levels = $formval{'levels'};  # Get the number of levels (if any)
#$kerbname = 'AAFONSO';
#$function_id = 731;

#
# authentication checks
  ($info,$k_principal, $domain)  = &parse_authentication_info();  # Parse authentication info
  $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase
  $full_name = $k_principal;
  $result = &check_auth_source($info); # Check other certificate fields
  if ($result ne 'OK') {
      print "<br><b>Your authentication cannot be accepted: $result";
      exit();
  }
#


#
#  Print out beginning of document
#
 print "<TITLE>$qt qualifiers for which $kerbname can do function_id '$function_id'",
       "</TITLE>", "\n";
 print '<BODY bgcolor="#fafafa">';

#
#  Get set to use Oracle.
#
use DBI;

#
# Login into the database
# 
$lda = login_dbi_sql('roles') 
      || die $DBI::errstr;

#
#  If the user is requesting information for someone other than himself, 
# make sure he has a meta-authorization to view all SAP authorizations.
#
if ($k_principal ne $kerbname) {
  if (!(&verify_metaauth_category($lda, $k_principal, 'SAP'))) {
    print "Sorry.  You do not have the required perMIT DB 'meta-authorization'",
    " to view other people's SAP authorizations.";
    exit();
  }
}

####
#  Get and display list of qualifiers for which the user can do the
#  function.  If the function is 731 (REPORT BY FUND/FC) or 705 (REPORT BY
#  CO/PC) then do the loop twice, once for each type of reporting.
####
$count = 0;
while (($function_id) && ($count++ < 2)) {

 #
 #  Get the function_name and qualifier_type from the perMIT DB function
 #  table.
 #
 $function_name = '';
 $qt = '';
 &get_function_info($lda, $function_id, \$function_name, \$qt);

 #
 #  Set number of levels.
 #
 if ($levels ne '') {  # If 'levels' variable was set in URL, use it
  $num_levels = $levels;
 }
 else {
  $num_levels = 2;
 }

 #
 #  Get a list of authorized qualifiers.
 #
 &get_authorized_qualifiers2($kerbname, $function_id, $qt, $num_levels);

 #
 #  Process each qualifier
 #
 $n = @aq_id;
 #print "N=$n\n";
 @qid = ();
 @qcode = ();
 @qname = ();
 @qdisplay = ();
 @qhaschild = ();
 for ($i = 0; $i < $n; $i++) {
   &get_quals($qt, $aq_id[$i], 1, $num_levels, '');
 }

 #
 #  Print out the http document.  
 #
  $header =  "<H2>$qt qualifiers for which $kerbname"
       . " can do function '$function_name'</H2>";
  if ($count == 1) {
    &print_header($header, 'https');
    print "<P>";
  }
  else {
    print $header;
  }
  print "This is a hierarchical display of $qt qualifiers for which"
        . " user $kerbname is authorized for '$function_name'."
        . "<BR><BR>", "\n";

 #
 #  If this is not the root (or the qualifier type is not FUND or COST), 
 #  allow the person to select a different number of levels to display.
 #
  if ($n) {
    $lev_word = ($num_levels == 1) ? 'level' : 'levels';
    print " The current display shows $num_levels $lev_word of expansion"
          . " in the hierarchy for each qualifier displayed."
          . " You can redisplay with: \n";
    $qcode_start = '<A HREF="' . $url_stem2 . "kerbname=" . $kerbname
             . '&functionid=' . $orig_function_id;
    $max_level = ($num_levels == 5) ? 4 : 5;
    for ($i = 1; $i <= $max_level; $i++) {
      if ($i != $num_levels) {
	if ($i == 1) {
          print $qcode_start . '&levels=' . $i . '">'
              . "$i&nbsp;level</A>, \n";
        }
        elsif ($i < $max_level) {
          print $qcode_start . '&levels=' . $i . '">'
              . "$i&nbsp;levels</A>, \n";
        }
        else {
          print 'or ' . $qcode_start . '&levels=' . $i . '">'
              . "$i levels</A>.\n";
        }
      }
    }
  }


  print "<HR>", "\n";
  $n = @qid;  # How many qualifiers?
  if ($n) {
    print "<TT>", "\n";
    if ($rootnode != 'ROOT' & $rootnode != '') {
      print ".. ", "<BR>\n";
    }
    for ($i = 0; $i < $n; $i++) {
      if ($qhaschild[$i] eq 'Y') {  # If has child, point to URL
        $qcode_string = '<A HREF="' . $url_stem . "qualtype=" . $qt
               . '&rootnode=' . $qid[$i] . '">' 
               . $qcode[$i] . '</A>';
      }
      else {  # Otherwise, this is a dead end.
        $qcode_string = $qcode[$i];
      } 
      print $qdisplay[$i] . $qcode_string . '  ' . $qname[$i];
      if (($qt eq 'COST' || $qt eq 'FUND') &&
          $qcode[$i] =~ /^[CIPF][0-9]/) {  # Cost object or Fund -- C.O. Detail
        print ' <A HREF="' . $url_stem3
               . '&cost_object=' . $qcode[$i] . '">'
               . "*</A>";
      }
      print "<BR>\n";
    } 

    printf "</TT>", "\n";
  }
  else {
    print "No authorizations for '$function_name' for user $kerbname<BR>";
  }
  print "<HR>", "\n";

 #
 #  If $function_id was 705, then set it to 731 and continue
 #  Else if $function_id was 731, then set it to 705 and continue
 #  Else set $function_id = 0.
 #
  if ($function_id == 705) {$function_id = 731;}
  elsif ($function_id == 731) {$function_id = 705;}
  else {$function_id = 0;}

}

#
#  Print the end of the document
#
 #print "<P>";
 print "<A HREF=\"$main_url\"><small>Back to main perMIT web interface page"
       . "</small></A>";
 print "</BODY></HTML>", "\n";

#
#  Drop connection to Oracle.
#
 $lda->disconnect() || die "can't log off database";

 exit(0);

###########################################################################
#
#  Subroutine to get a list of qualifiers for which a person is allowed
#  to perform a given function in the perMIT DB.
#
#  GET_AUTHORIZED_QUALIFIERS2($kerbname, $function_id, $qt)
#
#  Sets arrays   @aq_id           List of qualifier_id fields
#                @aq_code         List of qualifier_code fields
#                @aq_name         List of qualifier_name fields 
#                @aq_has_child    List of 'Y' or 'N' values
#
###########################################################################
sub get_authorized_qualifiers2 {
  my ($kerbname, $function_id, $qt, $maxlev) = @_;  # Parse out parameters
  $prefix = '';
  my $i = 0;
  #print "KERBNAME=$kerbname FUNCTION_ID=$function_id QT=$qt\n";
  @aq_id = ();
  @aq_code = ();
  @aq_name = ();
  @aq_has_child = ();

#
#  Open a cursor for the select statement.
#
  $stmt = "select a.qualifier_id, q.qualifier_code," 
           . " q.qualifier_name, least(q.has_child, a.descend)"
           . " from authorization a, qualifier q"  
           . " where a.kerberos_name = '$kerbname'"
           . " and a.function_id = '$function_id'"
           . " and a.qualifier_id = q.qualifier_id"
           . " and a.do_function = 'Y' and a.effective_date <= NOW()"
           . " and IFNULL(expiration_date,NOW()) >= NOW()"
           . " order by q.qualifier_code";
  $csr = $lda->prepare("$stmt")
        || die $DBI::errstr;
 
  $csr->execute();
  #
  #  Get a list of qualifiers
  #
  @qqid = ();
  @qqcode = ();
  @aqname = ();
  @aqhaschild = ();
  #print "Before ora_fetch\n";
  while ((($qqid, $qqcode, $qqname, $qqhaschild) 
         = $csr->fetchrow_array())) 
  {
        #print "ID=$qqid CODE=$qqcode NAME=$qqname HASCHILD=$qqhaschild\n";
  	# mark any NULL fields found
	grep(defined || 
          ($_ = '<NULL>'),
	   $qqid, $qqcode, $qqname, $qqhaschild);
        push(@aq_id, $qqid);
        push(@aq_code, $qqcode);
        push(@aq_name, $qqname);
        
        push(@aq_has_child, $qqhaschild);
  }

  $csr->finish() || die "can't close cursor";

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
    #print "I=$i QID=$mqid[$i], QNAME=$mqname[$i], HASCHILD=$mqhaschild[$i]\n";
    if (($lev != $maxlev) & ($mqhaschild[$i] eq 'Y')) {
      $new_prefix 
       = ($i < $n-1) ? $prefix . '|&nbsp&nbsp' : $prefix . '&nbsp&nbsp&nbsp';
      &get_quals($qt, $mqid[$i], $lev+1, $maxlev, $new_prefix);
    }
  }

}
###########################################################################
#
#  Recursive subroutine get_quals.
#
###########################################################################
sub get_quals {
  my $qualtype = $_[0];
  my $rootnode = $_[1];
  my $lev = $_[2];
  my $maxlev = $_[3];
  my $prefix = $_[4];
  my $i = 0;
  my $new_prefix = '';
  #print "QUALTYPE=$qualtype ROOTNODE=$rootnode LEV=$lev MAXLEV=$maxlev\n";

  #
  #  Open a cursor for select statement.
  #
  if (($rootnode eq 'ROOT') | ($rootnode eq ''))
  {
    $stmt = "select qualifier_id, qualifier_code," 
             . " qualifier_name, has_child"
             . " from qualifier"  
             . " where qualifier_type = '$qualtype' and qualifier_level = 1"
             . " order by qualifier_code";
  }
  elsif ($lev == 1) {
    $stmt = "select qualifier_id, qualifier_code," 
             . " qualifier_name, has_child"
             . " from qualifier"  
             . " where qualifier_id = '$rootnode'";
  }
  else 
  {
    $stmt = "select qualifier_id, qualifier_code,"
             . " qualifier_name, has_child"
             . " from qualifier"
             . " where qualifier_id in"
             . " (select child_id from qualifier_child"
             . " where parent_id = '$rootnode')" 
             . " order by qualifier_code";
  }
  $csr = $lda->prepare("$stmt")
        || die $DBI::errstr;
  $csr->execute(); 
  #
  #  Get a list of qualifiers
  #
  my @mqid = ();
  my @mqcode = ();
  my @mqname = ();
  my @mqhaschild = ();
  #print "Before ora_fetch\n";
  while ((($qqid, $qqcode, $qqname, $qqhaschild) 
         = $csr->fetchrow_array())) 
  {
  	# mark any NULL fields found
	grep(defined || 
          ($_ = '<NULL>'),
	   $qqid, $qqcode, $qqname, $qqhaschild);
        push(@mqid, $qqid);
        push(@mqcode, $qqcode);
        push(@mqname, $qqname);
        
        push(@mqdisplay, '..' x ($lev-1) . $qqname);
        push(@mqhaschild, $qqhaschild);
  }

  $csr->finish() || die "can't close cursor";

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
    #print "I=$i QID=$mqid[$i], QNAME=$mqname[$i], HASCHILD=$mqhaschild[$i]\n";
    if (($lev != $maxlev) & ($mqhaschild[$i] eq 'Y')) {
      $new_prefix 
       = ($i < $n-1) ? $prefix . '|&nbsp&nbsp' : $prefix . '&nbsp&nbsp&nbsp';
      &get_quals($qt, $mqid[$i], $lev+1, $maxlev, $new_prefix);
    }
  }

}

###########################################################################
#
#  Subroutine to get information from the Function table of the perMIT DB.
#  Sets $function_name and $qt (qualifier_type).
#
#  GET_FUNCTION_INFO($lda, $function_id, \$function_name, \$qt)
#
###########################################################################
sub get_function_info {
  my($lda, $function_id, $rfunction_name, $rqt) = @_;

#
#  Open a cursor for the select statement.
#
  my $stmt = "select function_name, qualifier_type"
           . " from function"
           . " where function_id = '$function_id'";
  my $csr = $lda->prepare("$stmt") 
        || die $DBI::errstr;
  $csr->execute();
 
  #
  #  Read in function_name and qualifier_type
  #
  ($$rfunction_name, $$rqt) = $csr->fetchrow_array();
  $csr->finish() || die "can't close cursor";

}


