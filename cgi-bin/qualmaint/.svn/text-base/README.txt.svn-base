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

How To Install the Roles Maintenance software:

1. Put all the .pm and .pl files in the cgi-bin directory
   (or some subdirectory beneath there; just be sure that
   the ownership and permissions are appropriate). for

2. Edit the BEGIN block of RolesDB.pm and set the $ENV{'ORACLE_HOME'}
   variable to a value appropriate for your server.

3. Edit the get_database_info routine in RolesDB.pm and set
   the fullpath variable to a value appropriate for your server;
   this tells the script where to find dbweb.config.

4. Edit the first line of RolesQM.pl and set the correct path
   to your perl interpreter.

5. Make sure all the files have appropriate permissions and
   ownership.  The web server needs to be able to execute
   the RolesQM.pl file; the Perl interpreter needs to be
   able to read dbweb.config, cgi-lib.pl, and the .pm files.

6. Test the results by using an https URL.

Note: if you enter in a filename, but don't specify a qualifier
type, then when the form comes back with the error you will
have to re-enter the upload filename.  There is no way to
avoid this; it is a security requirement of HTML.  Without it
people could write nasty JavaScript code that would auto-upload
anything on your computer.



