
=head1 NAME

RolesError - report errors to avoid use of cgi-lib

=head1 SYNOPSIS
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

use RolesError;

###############
# subroutines #
###############

RolesError::page_started(); # any HTTP output yet?
RolesError::death($msg);    # generate message and die

=head1 DESCRIPTION

The RolesError package reproduced the error-reporting functionality
of cgi-lib to work around some wierd compile-time errors caused by
requiring cgi-lib.pl from within various packages.  You must invoke
page_started as soon as the HTTP and HTML header information has
been output; this allows the package to know if a page is already
in midst of being generated when the error was generated.

=cut

# ------------------------------------------------------

package RolesError;

use strict;

my $header_printed=0;

sub page_started {
  $header_printed=1;
}

sub death {
  my $msg=shift;
  if (!$header_printed) {
    print "Content-type: text/html\n\n";
    print "<html>\n<head>\n<title>INTERNAL ERROR</title>\n</head>\n<body>\n";
    $header_printed=1;
  } else {
    print "<br><br>\n"; # try to break free of any html generation in progress
  }
  print "<h1>Internal Error</h1>\n";
  print "<b>$msg</b>\n";
  print "</body>\n";
  die $msg;
}

1;

