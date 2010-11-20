###############################################################################
## NAME: ehsweb.pm
##
## DESCRIPTION: 
## This Perl package contains common routines used by CGI scripts for
## the EH&S Web interface
## 
## PRECONDITIONS:
##
## 1.)  use 'ehsweb';
##	 or
##	use 'ehsweb' 1.0;  #This will specify a minimum version number
##
## POSTCONDITIONS:   
##
## 1.) None.
##
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
## MODIFICATION HISTORY:
##
## 9/17/2001 Jim Repa. -created, copied from rolesweb.pm
## 9/11/2003 Steve Landry -added UI widgets for new look and feel
##
###############################################################################

package Web;
$VERSION = 1.0;
$package_name = 'Web';

#Specify routines to be directly callable via the calling module without
#specifying the name of this package
use Oraperl;                            #Oracle interface (wrapper for DBI)
use Exporter;				#Standard Perl Module
@ISA = ('Exporter');			#Inherit from Exporter	
@EXPORT_OK = qw(parse_forms parse_ssl_info
                check_cert_source verify_metaauth_category print_header2
                print_training_header print_training_header_ess 
                get_dept_info get_dept_info2 
                web_error strip get_floorplan_url gen_train_admin_nav_bar
                gen_train_hdr_nav_bar ess_xhtml_header ess_page_header
                ess_page_footer ess_table_formats ess_paths);

$TEST_MODE = 0;            ## Test Mode (1 == ON, 0 == OFF)

if ($TEST_MODE) {print "TEST_MODE is ON for ehsweb.pm\n";}


##############################################################################
#
# Subroutine get_floorplan_url($bldg_number)
#
# Return a URL for getting a floorplan for a given building
#
##############################################################################
sub get_floorplan_url {
    my($bldg_number) = @_;  # Get first argument (building number)
    my $floorplan_addr = "http://floorplans.mit.edu/ListPDF.Asp";
    my $url = $floorplan_addr;
    if ($bldg_number) {
      $url .= "?Bldg=$bldg_number";
    }
    return ($url);  # Return the URL
}


#############################################################################
#
#  Subroutine parse_forms(input_string, \%formval, \%rawval)
#
#  Parses a line of the form (parameter string from a URL)
#     var1=value1&var2=value2&...
#  Builds a hash %formval where 
#     $formval{var1} = 'value1'
#     $formval{var2} = 'value2'
#     ...
#  The hash %rawval is similar to %formval except special characters
#  have not been converted.
#
#############################################################################
sub parse_forms{
  my ($form_info, @line, $n, $i, $key, $value);
  ($form_info, $rformval, $rrawval) = @_;
  @line = split(/&/, $form_info);
  $n = @line;   # How many lines?
  for ($i = 0; $i < $n; $i++) {
    ($key, $value) = split(/=/, $line[$i]);  # Split line into var. and value
    $$rrawval{$key} = $value;  # Save value before making adjustments
    $value =~ tr/+/ /;  # Restore spaces
    $value =~ s/%([\dA-Fa-f][\dA-Fa-f])/pack ("C", hex($1))/eg; # Hex strings
    $$rformval{$key} = $value;
  }
}

##############################################################################
#
# Subroutine parse_ssl_info 
#
# Parse client SSL information into a hash.
#
##############################################################################
sub parse_ssl_info {
    my $info = $_[0];  # Get first argument
    $info =~ tr/\n//;      # Get rid of newline(s)
    my ($key, $value, $junk);
    my(@junk) = split(/\//,$info);   # Split up the pieces
    my(%SSL_INFO);  # Make a hash of the pieces
    foreach $junk (@junk)
    {
	($key, $value) = split(/=/,$junk);
	$SSL_INFO{$key} = $value;
    }
    return %SSL_INFO;
}

##############################################################################
#
# Function &check_cert_source(\%ssl_info)
#
# Looks at parameters in the %ssl_info hash to make sure the certificate
# came from Country=US, State=Massachusetts, 
# Org=Massachusetts Institute of Technology
# Also checks to make sure the email address is in the domain MIT.EDU
# 
# If everything is OK, return 'OK'.  If not, return an error message.
#
##############################################################################
sub check_cert_source {

    my $rssl_info = $_[0];  # Get reference to a hash
    my $result = 'OK';  # Default result
    
   # if ($$rssl_info{'C'} ne 'US') {
#	$result = "Wrong certificate authority.  Country='$$rssl_info{'C'}'"
#	    . " (should be 'US')";
#    }
#    elsif ($$rssl_info{'ST'} ne 'Massachusetts') {
#	$result = "Wrong certificate authority.  State='$$rssl_info{'ST'}'"
#	    . " (should be 'Massachusetts')";
#    }
#    elsif ($$rssl_info{'O'} ne 'Massachusetts Institute of Technology') {
#	$result = "Wrong certificate authority.  Org='$$rssl_info{'O'}'"
#	    . " (should be 'Massachusetts Institute of Technology')";
#    }
    
    my ($username, $domain) = split('@', $rssl_info); 
    $domain = uc($domain);
    if ($domain ne 'MIT.EDU') {
	$result = "Wrong Email domain in certificate.  domain='$domain'"
	    . " (should be 'MIT.EDU')";
    }
    
    $result;
}

###########################################################################
#
#  Subroutine verify_metaauth_category.
#
#  Verify's that $k_principal is allowed to view authorizations for 
#  another user's $super_category. Return's 1 if $k_principal is allowed,
#  0 otherwise.
#
###########################################################################
sub verify_metaauth_category {
    my ($lda, $k_principal, $super_category) = @_;
    my ($csr, @stmt, $result);
    if ((!$k_principal) | (!$super_category)) {
        return 0;
    }
    @stmt = ("select ROLESAPI_IS_USER_AUTHORIZED('$k_principal','VIEW AUTH BY CATEGORY', 'CAT' || '$super_category') from dual");
    $csr = &ora_open($lda, "@stmt")
        || die $ora_errstr;
 
    ($result) = &ora_fetch($csr);
    if ($result eq 'Y') {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################
#
#  Subroutine &print_training_header($header, $http_https, $help_url)
#
#  Prints a header, including the EHS DB logo. The variable $http_https
#  specifies 'http' or 'https', used for the URL for the EHS logo.
#  (Use https if the CGI script uses certificates;  otherwise, use http.)
#
###########################################################################
sub print_training_header {
    my ($header, $http_https, $help_url) = @_;
    my $host = $ENV{'HTTP_HOST'};
    $header =~ /^([^<]*)/;  # Look for part up to <BR>
    my $title = $1;
    my $image_dir = "https://${host}/ehs/images";
    print "<HEAD><TITLE>$title",
          "</TITLE></HEAD>", "\n";
    print '<BODY bgcolor="#FFFFFF" TOPMARGIN=0 MARGINHEIGHT=0>';
    print << 'ENDOFTEXT';

<TABLE BGCOLOR="#FFFFFF" BORDER="0" CELLPADDING="0" CELLSPACING="0"
  WIDTH="100%">
<TR>
 <TD BGCOLOR="#000066">&nbsp;</TD>
</TR>
<TR>
 <TD BGCOLOR="#000000">

ENDOFTEXT
    print "<IMG SRC=\"${image_dir}/spacer.gif\""
          . " WIDTH=\"1\""
          . " HEIGHT=\"1\" BORDER=\"0\" ALT=\"\"></TD></TR>";
    print "<TR><TD ALIGN=\"LEFT\">"
          . "<IMG SRC=\"${image_dir}/mitehs.gif\""
          . "WIDTH=\"275\" HEIGHT=\"75\" BORDER=\"0\" ALT=\"MIT - EHS\">"
          . "</TD></TR>";
    print "<TR><TD  BGCOLOR=\"#000000\">"
          . "<IMG SRC=\"${image_dir}/spacer.gif\" WIDTH=\"1\""
          . " HEIGHT=\"1\" BORDER=\"0\" ALT=\"\"></TD></TR>";
    print "<TR><TD BGCOLOR=\"#000066\">"
          . "<IMG SRC=\"${image_dir}/spacer.gif\" WIDTH=\"1\""
          . " HEIGHT=\"4\" BORDER=\"0\" ALT=\"\"></TD></TR>";
    print "<TR BGCOLOR=\"#000000\"><TD ALIGN=\"LEFT\" HEIGHT=15>"
          . "<IMG SRC=\"${image_dir}/spacer.gif\" WIDTH=\"1\" HEIGHT=\"1\""
          . " BORDER=\"0\" ALT=\"\"></TD></TR>";
    print << 'ENDOFTEXT';
</TABLE>
<P>
ENDOFTEXT
    print "<h3>$title</h3>";
}

###########################################################################
#
#  Subroutine &print_training_header_ess($header, $http_https, $help_url)
#
#  Prints a header, including the EHS DB logo. The variable $http_https
#  specifies 'http' or 'https', used for the URL for the EHS logo.
#  (Use https if the CGI script uses certificates;  otherwise, use http.)
#
###########################################################################
sub print_training_header_ess {
    my ($header, $http_https, $help_url) = @_;
    my $host = $ENV{'HTTP_HOST'};
    $header =~ /^([^<]*)/;  # Look for part up to <BR>
    my $title = $1;
    my $image_dir = "https://${host}/ehs/images";

  print << "ENDHTMLHEAD";
<head>
  <title>$title</title>
  
  <link href="../../ehs/scripts/styles.css" rel="stylesheet" type="text/css" />
</head>

<body topmargin="0" marginheight="0">

<div class="bannerBlock" style="padding: 3px">
  <div class="banner" style="float: left">MIT EHS Training</div>
  <div class="banner" align="right">
    <a href="#" onclick="window.close()" style="color: #FFFFFF">Close Window</a>
  </div>
</div>

<div style="width: 95%; text-align: left; padding-top: 10px; padding-bottom: 10px; padding-left: 2.5%; padding-right: 2.5%">
  <h1 class="pageTitle">$title</h1>
</div>

ENDHTMLHEAD

}

###########################################################################
#
#  Subroutine &print_header2($header, $http_https, $help_url)
#
#  Prints a header, including the EHS DB logo. The variable $http_https
#  specifies 'http' or 'https', used for the URL for the EHS logo.
#  (Use https if the CGI script uses certificates;  otherwise, use http.)
#  If the 3rd parameter is specified, it is used as a URL to a help page;
#  a question mark is printed at the upper right corner of the current Web
#  page linking to the help page.
#
###########################################################################
sub print_header2 {
    my ($header, $http_https, $help_url) = @_;
    my $host = $ENV{'HTTP_HOST'};
    $header =~ /^([^<]*)/;  # Look for part up to <BR>
    my $main_page = "/ehs/ehs_main.html";
    my $title = $1; 
    print "<HEAD><TITLE>$title",
          "</TITLE></HEAD>", "\n";
    print '<BODY bgcolor="#fafafa">';
    if ($help_url) {
      #print '<table width=100%>'
      #    . '<tr><td width=20% bgcolor=green>'
      #    . '<h1><i><font color=lightgreen>EHS</font></i></td>'
      #    . "<td width=70%><H2>$header</H2></td>"
      #    . '<td width=10%align=right valign=top><A HREF="' . $help_url . '">'
      #    . '<h1><i>?</i></h1></A></td></tr></table>';
      print '<table width="100%">'
          . '<tr><td width="20%">'
          . "<h1><i><a href=\"$http_https://" . $host . "$main_page\">"
          . '<font color=lightgreen>EHS'
          . '</font></a></i></h1></td>'
          . "<td width=\"70%\"><H2>$header</H2></td>"
          . '<td width=\"10%\" align=right><h1><i><A HREF="' . $help_url . '">'
          . '?</A></i></h1></td>'
          . '</tr></table>';
    }
    else {
      print '<table width="100%">'
          . '<tr><td width="20%">'
          . "<h1><i><a href=\"$http_https://" . $host . "/ehs/ehs_main.html\">"
          . '<font color=lightgreen>EHS'
          . '</font></a></i></h1></td>'
          . "<td width=\"80%\"><H2>$header</H2></td>"
          . '</tr></table>';
    }
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

########################################################################
#
#  Strips off trailing <cr> and leading and trailing blanks.
#
###########################################################################
sub strip {
    my($s);  #temporary string
    $s = $_[0];
    $s =~ s/\`/\"/;  # Change back-tick to double quote to foil hackers.
    while ($s =~ /[\s\n]$/) {   # Remove trailing <cr> or space
	chop($s);
    }
    while (substr($s,0,1) =~ /^\s/) {
	$s = substr($s,1);
    }
 
    $s;
}
###########################################################################
#
#  Subroutine
#   get_dept_info2
#    ($lda, \%dept_child, \%dept_parent, \%dept_name, 
#    \%dept_has_children, \%dept_ids);
#
#   Gets department ids as well.
###########################################################################
sub get_dept_info2 {
  my ($lda, $rdept_child, $rdept_parent, $rdept_name,
      $rdept_has_children, $dept_ids) = @_;

  #
  #  Open a cursor to a select statement
  #
  my $stmt = q{
      select /*+ ORDERED */
       d1.dept_code, d2.dept_code, d2.dept_name, d2.DEPT_ID
       from dept d1, ehs_dept_child dc, dept d2
       where dc.parent_id = d1.dept_id
       and d2.dept_id = dc.child_id
       order by d1.dept_code, d2.dept_code
  };
  #print "stmt='$stmt'<BR>";
  my $csr = &ora_open($lda, $stmt);
  unless ($csr) {
    print "Error opening cursor.  $ora_errstr <br />";
    die $ora_errstr;
  }

  #
  #  Read in rows from the query.  Fill in values for the hashes.
  #
  my $prev_code = '';
  my ($ddparent, $ddcode, $ddname, $ddid);
  while (($ddparent, $ddcode, $ddname, $ddid) = &ora_fetch($csr))
  {
    #print "$ddparent, $ddcode, $ddchild<BR>";
    # Set $dept_has_children{$ddparent} = 1.
    $$rdept_has_children{$ddparent} = 1;
    $$rdept_parent{$ddcode} = $ddparent;
    # Fill in %dept_child and %dept_name
    if ($ddcode ne $prev_code) {
      if ($$rdept_child{$ddparent}) {
        $$rdept_child{$ddparent} .= "!$ddcode";
      }
      else {
        $$rdept_child{$ddparent} = $ddcode;
      }
      $$rdept_name{$ddcode} = $ddname;
      $dept_ids->{$ddcode} = $ddid;
      $prev_code = $ddcode;
    }
  }
  &ora_close($csr) || die "can't close cursor";
}
###########################################################################
#
#  Subroutine 
#   get_dept_info
#    ($lda, \%dept_child, \%dept_parent, \%dept_name, \%dept_has_children);
#
###########################################################################
sub get_dept_info {
  my ($lda, $rdept_child, $rdept_parent, $rdept_name, 
      $rdept_has_children) = @_;

  #
  #  Open a cursor to a select statement
  #
  my $stmt = q{
      select /*+ ORDERED */ 
       d1.dept_code, d2.dept_code, d2.dept_name
       from dept d1, ehs_dept_child dc, dept d2 
       where dc.parent_id = d1.dept_id
       and d2.dept_id = dc.child_id
       order by d1.dept_code, d2.dept_code
  };
  #print "stmt='$stmt'<BR>";
  my $csr = &ora_open($lda, $stmt);
  unless ($csr) {
    print "Error opening cursor.  $ora_errstr <br />";
    die $ora_errstr;
  }
  
  #
  #  Read in rows from the query.  Fill in values for the hashes.
  #
  my $prev_code = '';
  my ($ddparent, $ddcode, $ddname);
  while (($ddparent, $ddcode, $ddname) = &ora_fetch($csr))
  {
    #print "$ddparent, $ddcode, $ddchild<BR>";
    # Set $dept_has_children{$ddparent} = 1.
    $$rdept_has_children{$ddparent} = 1;
    $$rdept_parent{$ddcode} = $ddparent;
    # Fill in %dept_child and %dept_name
    if ($ddcode ne $prev_code) {
      if ($$rdept_child{$ddparent}) {
        $$rdept_child{$ddparent} .= "!$ddcode";
      }
      else {
        $$rdept_child{$ddparent} = $ddcode;
      }
      $$rdept_name{$ddcode} = $ddname;
      $prev_code = $ddcode;
    }
  }
  &ora_close($csr) || die "can't close cursor";

}

###############################################################################
#
#  Subroutine &gen_train_admin_nav_bar($gray_out_link)
#
#  Prints a navigation bar to link to various training administrators 
#  web pages
#
##############################################################################
sub gen_train_admin_nav_bar {
    ($gray_out_link) = @_;
 #
 # List of URLs and names to be displayed
 #
  my $host = $ENV{'HTTP_HOST'};
  my @ordered_links = ('main','cert_summary','cert','course',
                       'function','function_group');
  my $urls = {
    'function'          => 'train_function_update.cgi',
    'function_group'    => 'train_function_group.cgi',
    'cert'              => 'training_rules1.cgi',
    'cert_summary'      => 'cert_summary.cgi',
    'course'            => 'course_equiv_update.cgi',
    'main'              => "https://$host/ehs/ehs_main.html"
  };

  my $link_names = {
    'function'          => 'Functions',
    'function_group'    => 'Function groups',
    'cert'              => 'Certs and rules',
    'cert_summary'      => 'Cert summary',
    'course'            => 'Courses',
    'main'              => "Main Menu"
  };

 #
 # Print the navigation bar
 #
 print "<table width=\"100%\" bgcolor=\"#E0E0E0\"><tr>"; 
 my ($key, $link_name, $url);
 foreach $key (@ordered_links) {
   $link_name = $link_names->{$key};
   $url = $urls->{$key};
   if ($key eq $gray_out_link) {
     print "<td align=center>"
           . "<font color=gray>$link_name</font></td>";
   }
   else {
     print "<td align=center>"
           . "<a href=\"$url\">$link_name</a></td>"
   }
 }
 print "</tr></table>\n";
}


###############################################################################
#
#  Subroutine &gen_train_hdr_nav_bar($title, $http_https, $help_url, 
#                                    $gray_out_link)
#
#  Generates a header plus a navigation bar for training rules
#  administration pages
#
###############################################################################
sub gen_train_hdr_nav_bar {
    ($title, $http_https, $help_url, $gray_out_link) = @_;
    &print_header2($title, $http_https, $help_url);
    print "<P>";
    &gen_train_admin_nav_bar($gray_out_link);
}


###############################################################################
#
# Style and formatting subs for the Employee Self Service look & feel.
#   These are for writing finished HTML, CSS, and JavaScript into the client side.
#   They should not operate on back end data themselves.
# 
###############################################################################

# Client-side are dynamic to the current system.

sub ess_paths {
  my $host = $ENV{'HTTP_HOST'};
  #my $base_dir = "https://${host}/ehs/";
  my $image_dir = "https://${host}/ehs/images/";
  return $image_dir;
}

sub ess_table_formats {
  $formats = "border=\"0\" width=\"95%\" align=\"center\" cellspacing=\"2\" cellpadding=\"3\"" ;
  return $formats;
}

sub ess_xhtml_header {

    print << "ENDOFTEXT";
<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- end print from ess_xhtml_header -->

ENDOFTEXT

}

sub ess_page_header {
  my ($header, $http_https, $help_url) = @_;
  my %ssl_info = &parse_ssl_info( $ENV{"REMOTE_USER"} );
  my $username = $ssl_info{'CN'};
  my $ess_table_formats = &ess_table_formats;

  #
  # The actual HTML <head>
  #

  print << "ENDOFTEXT";
<head>
  <title>$header</title>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
  <meta http-equiv="Content-Style-Type" content="text/css">
  <link href="../../ehs/scripts/styles.css" rel="stylesheet" type="text/css" />
</head>
<body topmargin="0" marginheight="0">
ENDOFTEXT

  #
  # The web page "banner" and visible title
  #


  print << "ENDOFTEXT";
<table  width="100%" border="0" cellspacing="0" cellpadding="3">
  <tr>
    <td class="bannerBlock"><span class="banner">Training Needs Assessment</span></td>
    <td class="bannerBlock" align="right">
    <!-- SYSTEM DATE NEEDS TO GO HERE <span class="subheadDim">today&quot;s date: </span> --></td></tr>
</table>
<table border="0" width="100%" cellspacing="0" cellpadding="2">
  <tr>
    <td class="navBlock" align="left" nowrap="nowrap">
      <span class="large"><strong>Name:</strong> $username</span></td>
    <td class="navBlock" align="right" nowrap="nowrap">
      <a href="http://mit.edu/environment/training"><span class="nav">Home</span></a></td>
    </tr>
</table>
<br />
<table width="95%" align="center"><tr><td class="pageTitle">$header</td></tr></table>
<!-- end print from ess_page_header -->
ENDOFTEXT

} # end ess_page_header

sub ess_page_footer {
  my $ess_table_formats = &ess_table_formats;
  print << "ENDOFTEXT";
<br />
<table $ess_table_formats><tr><td class="medium">
  <hr />
  <a href="mailto:ehstrain-bugs\@mit.edu">Report a Problem</a><br />
  <a href="mailto:environment\@mit.edu">Contact Webmaster</a><br /><br />
  &copy; 2003 Massachusetts Institute of Technology.
</td></tr></table>
ENDOFTEXT
}


return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################

