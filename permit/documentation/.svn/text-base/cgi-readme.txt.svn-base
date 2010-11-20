Author: bskinner
Created On: 04-27-2010

=====================
General Configuration
=====================
The production and development environments are currently using RHEL 5.2
(Tikanga). The absolute minimum set of installed software is:
	Apache >= 2.2
	MySQL >= 5.4, with InnoDB support
	Perl 5.8 with DBI and DBD::MySQL modules
	Subversion 1.5 or higher
	
Existing Servers:
    auth-dev-permit1.mit.edu
    auth-dev-permit2.mit.edu

Apache user/group: apache/apache
SSH: www@<server> (Ask AMIT to add your MIT ID)

Required databases:
    rolesbb
    rolessrv (not actually accessed in client, referred to in stored procs)
    mdept$owner



====================
Apache Configuration
====================
When using the standard MIT VM template, the DocumentRoot is in '/var/www/html'
and the '/var/www/cgi-bin' directory is already setup for running CGI scripts.
The only change needed is to edit the 'shib.conf' in '/etc/httpd/conf.d' and
change the line '<Location /secure>' to '<Location />'.

If you are setting up an Apache server from scratch, you will need to force
client cert authentication. There are no requirements on where the 'html' and
'cgi-bin' directories need to go on the host machine but the 'html' folder MUST
be your DocumentRoot and the 'cgi-bin' directory must be ScriptAliased to
'/cgi-bin'. See the example configuration in 'sample-cgi-confs' for an idea on
how to configure your server.



===================
MySQL Configuration
===================
The MySQL server MUST be at least version 5.4 or higher with InnoDB support
enabled. So far this has been tested on 5.4.1-beta (14.14). As of this moment,
a installation must be cloned from another functional system or bootstrapped
from the feeds (ToDo: Figure out how to bootstrap...); a set of empty database
with the stored procedures will work but you will be unable to do anything other
than admire how pretty the HTML looks. If you still wish to setup a base set of
databases, cd into the 'dbscripts/permit_schema' folder and run the
'mysql-setup.bash' script in the 'sample-cgi-confs' directory. Be sure to change
the value of the variable 'mysql_root_pw' along with the 'db_pw' before running
the script (you will need root access to the database server). You may can
change the other 'db_*' variables but you do so at your own peril.



=================
CGI Configuration
=================
All access to the databases is defined through the file
"${PERMIT_CONFIG_HOME}/dbweb.config" (See the Issues section, there is a bug
here). The file is a basic CSV file using colons as delimiters. The format is
the file is:

Database-symbolic-name:database-name:username:pw:host
<database>
<database>
...

The parser used is very dumb; it simply splits each line using the ':' character
and searches the first field for the name of the database than the scripts are
looking for. Once it finds it, it simply returns an array containing the rest of
the information. There is no syntax checking so make sure you have all the
fields filled out and do not use colons anywhere except in the delimiters!

For the scripts to function there must be entries for at least the 'roles' and
'mdept' internal databases (Database-symbolic-name). As of 04/27/2010, the
current file used in production is located at '/var/www/permit/dbweb.config'.
Any of the 'dbweb.config' files located in the 'cgi-bin' folder are not used.

The current production dbweb.config is below:
Database-symbolic-name:database-name:username:pw:host
roles:rolesbb:rolesbb:yyrolesbbyy:auth-dev-permit1.mit.edu
mdept:mdept$owner:rolesbb:yyrolesbbyy:auth-dev-permit1.mit.edu



===============
CGI Issues/Bugs
===============
* There are two potential issues with the current dbweb.config (aside from the
    entire parsing subroutine).
    * Does not support non-standard ports
    * Does not explicitly parse out comments

* The value of PERMIT_CONFIG_HOME is ignored by the CGI scripts. It is accessed
    but immediately prior to the access it is overwritten by the hardcoded value
    '/var/www/permit'. Grep for "$ENV{'PERMIT_CONFIG_HOME'} = '/var/www/permit'"
    to find all the relevant locations.

* Client certificate authentication is required by the script and the scripts
    will break if you do not use it.

* The client certificate authentication will not work with any non-MIT
    certificates. The rolesweb module currently performs the following checks on
    any incoming certs/principal IDs in the below subroutines:
    
	*check_cert_source:
		C == 'US'
		ST == 'Massachusetts'
		O == 'Massachusetts Institute of Technology'
		emailAddress =~ *@mit.edu
	*check_auth_source:
		emailAddress =~ *@mit.edu
		

=================
MySQL Issues/Bugs
=================	
* The MySQL database must either be cloned from a functional installation or
    bootstrapped from the feeds. The scripts will work with an empty database but
    all it will do is look pretty as no users will actually exist

* The 'rolesbb' user must have access from the wildcard host ('rolesbb'@'%') as
the stored procedures will not execute otherwise. In addition, the 'rolesbb'
must also have the below GRANTS:
    SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER,
    CREATE TEMPORARY TABLES, LOCK TABLES, CREATE VIEW, SHOW VIEW, CREATE ROUTINE,
    ALTER ROUTINE, EXECUTE
    
* In `rolessrv`.`get_auth_general_sql`:
    Using uninitialized 'crit_id' on line 114
    Why 'crit_id' instead of 'ai_id7' on line 114?
    Why 'ai_id7' instead of 'ai_id8' on line 121?
    Unused parameter: ai_id8