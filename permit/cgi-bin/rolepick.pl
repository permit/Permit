#!/usr/bin/perl
###########################################################################
#
#  CGI script to pick between List-function or list-authorization.
#
#  Deal with path better.  (Take the path of this script and mess
#    with it to run the next one.
#    Use $ENV{'SCRIPT_FILENAME'})
#  Read from <STDIN>.  Parse the forms stuff. Write it back to <STDOUT>
#    for the next script.
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
#  This CGI script is being phased out.  It, along with rolefunc.pl,
#  will be replaced by rolefunc2.pl. (JR, 7/24/2000)
#
###########################################################################
#
#  Where are we running from?  Figure out the path.
#
 $full_path = $ENV{'SCRIPT_FILENAME'};
 $full_path =~ /^(.*\/)[^\/]*$/;  # Find the part up to last / 
 $script_path = $1;

#
#  Process form information
#
 read (STDIN, $input_string, $ENV{'CONTENT_LENGTH'});  # Read input string
 &parse_forms($input_string);  # Call subroutine to parse it


#
#  Now run the next script.
#
 if ($formval{'request_type'} eq 'LIST_AUTH') {
    system($script_path . "roleauth1.pl $input_string\n");
 }
 else {
    system($script_path . "rolefunc.pl $input_string\n");
 }
 exit();

#############################################################################
#
#  Subroutine parse_forms(input_string)
#
#  Parses a line of the form 
#     var1=value1&var2=value2&...
#  Builds a hash %formval where 
#     $formval{var1} = 'value1'
#     $formval{var2} = 'value2'
#     ...
#
#############################################################################
sub parse_forms{
  local ($form_info, @line, $n, $i, $key, $value);
  $form_info = $_[0];
  @line = split(/&/, $form_info);
  $n = @line;   # How many lines?
  for ($i = 0; $i < $n; $i++) {
    ($key, $value) = split(/=/, $line[$i]);  # Split line into var. and value
    $value =~ tr/+/ /;  # Restore spaces
    $value =~ s/%([\dA-Fa-f][\dA-Fa-f])/pack ("C", hex($1))/eg; # Hex strings
    $formval{$key} = $value;
  }
}
