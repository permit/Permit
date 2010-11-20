###############################################################################
## NAME: rmdeptweb.pm
##
## DESCRIPTION: 
## This Perl package contains common routines used by CGI scripts for
## the Master Department Hierarchy Web interface
## 
## PRECONDITIONS:
##
## 1.)  use 'mdeptweb';
##	 or
##	use 'mdeptweb' 1.0;  #This will specify a minimum version number
##
## POSTCONDITIONS:   
##
## 1.) None.
##
#
#  Copyright (C) 2006-2010 Massachusetts Institute of Technology
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
## 9/25/2006 Jim Repa. -created
##
###############################################################################

package mdeptweb;
$VERSION = 1.0;
$package_name = 'mdeptweb';

#Specify routines to be directly callable via the calling module without
#specifying the name of this package
use Exporter;				#Standard Perl Module
@ISA = ('Exporter');			#Inherit from Exporter	
@EXPORT_OK = qw(print_mdept_header);

$TEST_MODE = 0;            ## Test Mode (1 == ON, 0 == OFF)

if ($TEST_MODE) {print "TEST_MODE is ON for mdeptweb.pm\n";}

#
###########################################################################
#
#  Subroutine &print_mdept_header($header, $http_https, $help_url)
#
#  Prints a header, including the MDH logo. The variable $http_https
#  specifies 'http' or 'https', used for the URL for the Roles logo.
#  (Use https if the CGI script uses certificates;  otherwise, use http.)
#  If the 3rd parameter is specified, it is used as a URL to a help page;
#  a question mark is printed at the upper right corner of the current Web
#  page linking to the help page.
#
###########################################################################
sub print_mdept_header {
    my ($header, $http_https, $help_url) = @_;
    my $host = $ENV{'HTTP_HOST'};
    $host = ($host eq 'blue-goose.mit.edu') ? 'rolesweb.mit.edu' : $host;
    if ($help_url) {
      print '<table width=100%>'
          . '<tr><td><a href="http://' . $host . '/mdept">'
          . '<img width=105 height=88 src="' . $http_https . '://' . $host 
          . '/images/mdept_logo.jpeg" no border></a></td>'
          . "<td><H2>$header</H2></td>"
          . '<td align=right valign=top><A HREF="' . $help_url . '">'
          . '<h1><i>?</i></h1></A></td></tr></table>';
    }
    else {
      print '<table>'
          . '<tr><td><a href="http://' . $host . '/mdept">'
          . '<img width=105 height=88 src="' . $http_https . '://' . $host 
          . '/images/mdept_logo.jpeg" no border></a></td>'
          . "<td><H2>$header</H2></td>"
          . '</tr></table>';
    }
}

return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################

