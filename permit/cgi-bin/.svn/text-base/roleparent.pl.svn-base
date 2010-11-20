#!/usr/bin/perl
###########################################################################
#
#  CGI script to list perMIT DB qualifiers that are ancestors of a 
#  given node.
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
#  Modified 5/7/1999 -- Add a hint to speed up lookup of root node.
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
#  Set stem for URLs
#
$url_stem = "/cgi-bin/rolequal1.pl?";
$url_stem2 = "/cgi-bin/roleparent.pl?";
$url_stem3 = "/cgi-bin/rolecc_info.pl?";

#
#  Get form variables
#
$qualtype = $formval{'qualtype'};  # Get value set in &parse_forms()
$raw_qualtype = $rawval{'qualtype'};  # Get unedited value
$qt = $qualtype;
$qt =~ s/\W.*//;  # Keep only the first word.
$qualtype =~ s/\w*\s//;  # Throw out first word.
$rootnode = 'ROOT';
$qc = $formval{'qualcode'};  # Get the child qualcode.

#
#  Set number of levels to 20, so we'll always see everything.
#
$num_levels = 20;

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
#  Get the qualifier_id associated with the qualifier_code of the child node.
#
$qc =~ tr/a-z/A-Z/;
$stmt = "select qualifier_id, qualifier_name from qualifier"  
         . " where qualifier_type = '$qt' and qualifier_code = '$qc'";
$csr = $lda->prepare("$stmt")
      || die $DBI::errstr;
$csr->execute();
$child_id = 0;
while (($c_id, $c_name) = $csr->fetchrow_array() ) {
  $child_id = $c_id;
  $child_name = $c_name;
}
$csr->finish() || die "can't close cursor";


#
#  Get a list of qualifiers
#
@qid = ();
@qcode = ();
@qname = ();
@qdisplay = ();
@qhaschild = ();
&get_ancestors($qt, $rootnode, 1, $num_levels, '', $child_id);

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
#  Print out the http document.  
#
 print "<HTML>", "\n";
 print "<HEAD><TITLE>perMIT DB Tree position of $qualtype Qualifier $qc",
       "</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 &print_header("Position of $qualtype $qc in the Qualifier tree", 'http');
 #print "<P>";
 print "<HR>";
 $n = @qid;  # How many qualifiers?
 if (!$n) {
   print "Qualifier $qc of type $qt not found.\n";
 }
 printf "<TT>", "\n";
 if ($rootnode != 'ROOT' & $rootnode != '') {
   print "..<BR>\n";
 }
 for ($i = 0; $i < $n; $i++) {
   if ($qhaschild[$i] eq 'Y') {  # If has child, point to URL
     $qcode_string = '<A HREF="' . $url_stem . "qualtype=" . $raw_qualtype
            . '&rootnode=' . $qid[$i] . '">' 
            . $qcode[$i] . '</A>';
   }
   else {  # Otherwise, this is a leaf node.
     $qcode_string = $qcode[$i];
   } 
   print $qdisplay[$i] . $qcode_string . '  ' . $qname[$i];
   if (($qt eq 'COST' || $qt eq 'FUND') &&
       $qcode[$i] =~ /^[CIPWF][0-9]/) {  # Cost object or Fund -- C.O. Detail
     print ' <A HREF="' . $url_stem3
            . '&cost_object=' . $qcode[$i] . '">'
            . "*</A>";
   }
   elsif ($qt eq 'SPGP' && $qcode[$i] ne 'SG_ALL') {  # Spend. grp.--Link to FC
     $fc_code = $qcode[$i];
     $fc_code =~ s/SG_/FC_/;
     print ' <A HREF="' . $url_stem 
            . 'qualtype=FUND+%28Fund+Centers+and+Funds%29'
            . '&rootcode=' . $fc_code . '&levels=3">'
            . "*</A>";
   }
   print "<BR>\n",
 }

 printf "</TT>", "\n";
 print "<HR>", "\n";
 print "<A HREF=\"$main_url\">"
  . "<small>Back to main perMIT web interface page</small></A>";
 print "</BODY></HTML>", "\n";
 exit(0);

###########################################################################
#
#  Recursive subroutine get_ancestors.
#
###########################################################################
sub get_ancestors {
  my $qualtype = $_[0];
  my $rootnode = $_[1];
  my $lev = $_[2];
  my $maxlev = $_[3];
  my $prefix = $_[4];
  my $childnode = $_[5];
  my $i = 0;
  my $new_prefix = '';
  #print "QUALTYPE=$qualtype ROOTNODE=$rootnode LEV=$lev MAXLEV=$maxlev\n";

  #
  #  Open a cursor for select statement.
  #
  if (($rootnode eq 'ROOT') | ($rootnode eq ''))
  {
    @stmt = ("select /*+ INDEX(qualifier rdb_i_q_qualifier_level */"
             . " qualifier_id, qualifier_code," 
             . " qualifier_name, has_child"
             . " from qualifier"  
             . " where qualifier_type = '$qualtype' and qualifier_level = 1"
             . " and (qualifier_id = '$childnode' or qualifier_id in"
             . " (select parent_id from qualifier_descendent"
             . " where child_id = '$childnode'))" 
             . " order by qualifier_code");
  }
  elsif ($lev == 1) {  # Not used here -- borrowed from another routine
    @stmt = ("select qualifier_id, qualifier_code," 
             . " qualifier_name, has_child"
             . " from qualifier"  
             . " where qualifier_id = '$rootnode'");
  }
  else 
  {
    @stmt = ("select qualifier_id, qualifier_code,"
             . " qualifier_name, has_child"
             . " from qualifier"
             . " where qualifier_id in"
             . " (select child_id from qualifier_child"
             . " where parent_id = '$rootnode')"
             . " and (qualifier_id = '$childnode' or qualifier_id in"
             . " (select parent_id from qualifier_descendent"
             . " where child_id = '$childnode'))" 
             . " order by replace(qualifier_code,'FC','F')");
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
  while (($qqid, $qqcode, $qqname, $qqhaschild) 
         = $csr->fetchrow_array() ) 
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
      &get_ancestors($qt, $mqid[$i], $lev+1, $maxlev, $new_prefix, $childnode);
    }
  }

}
