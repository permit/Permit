#!/bin/perl

#
#  Copyright (C) 2003-2010 Massachusetts Institute of Technology
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


## Generic packages
use DBI;
use CGI;

#use Web('parse_authentication_info');
#use Web('check_auth_source');
#use Web('parse_forms');
#use Web('print_header2'); #Use sub. print_header2
#use Web('gen_train_hdr_nav_bar'); #Use sub. get_dept_info in ehsweb.pm
#use Web('web_error'); 

use rolesweb('login_dbi_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
use rolesweb('print_header'); #Use sub. print_header in rolesweb.pm

### Master department package ###
use MDept;

### Calling parameters ###

# TODO - cleanup
#######################
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
#  Get form variables
#
$g_view_type = $formval{'view_type'};  # Get value set in &parse_forms()
$g_view_type =~ s/\W.*//;  # Keep only the first word.
$g_view_type =~ s/\.//;    # Remove '.'
$g_show_link_name = $formval{'show_link_name'};
$g_show_link_name =~ tr/a-z/A-Z/;
$g_ddid = $formval{'ddid'};

MDept::edit_dlc($g_ddid);
1;
