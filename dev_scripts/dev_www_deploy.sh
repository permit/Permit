#!/bin/bash
#
#
#  Copyright (C) 2009-2010 Massachusetts Institute of Technology
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

DT=`date +%Y%m%d-%H%M%S`
_prefix='/var'

_bakdir="${_prefix}/bak"
_webroot="${_prefix}/www"
_permit_bak="${_bakdir}/permit-${DT}"
_svn_prefix="svn+ssh://${USER}@svn.mit.edu/permit"

_dev_group='www'

function die () {
	echo $1
	exit 255
}

cd ~/
[ -d "${_bakdir}" ] || die 'Backup directory does not exist'

mkdir "${_permit_bak}" || die "Unable to create backup directory"
mv "${_webroot}/html" "${_permit_bak}/html" || die "'html' backup failed"
mv "${_webroot}/cgi-bin" "${_permit_bak}/cgi-bin" || die "'cgi-bin' backup failed"
cp -Ra "${_webroot}/permit" "${_permit_bak}/permit" || die "'permit' backup failed"


# Restore the directories under SVN control
svn export "${_svn_prefix}/html" "${_webroot}/html" || die "Subversion export failed: 'html'"
svn export "${_svn_prefix}/cgi-bin" "${_webroot}/cgi-bin" || die "Subversion export failed: 'cgi-bin'"


chgrp -R "${_dev_group}" "${_webroot}/html" || die "'html' group change failed"
chgrp -R "${_dev_group}" "${_webroot}/cgi-bin" || die "'cgi-bin' group change failed"


# These are not used at the moment - 05/10/2010
#find "${_webroot}/html" -type "d" -exec chmod 750 "{}" \;
#find "${_webroot}/html" -type "f" -exec chmod 640 "{}" \;

#find "${_webroot}/cgi-bin" -type "d" -exec chmod 750 "{}" \;
#find "${_webroot}/cgi-bin" -type "f" -exec chmod 640 "{}" \;
#find "${_webroot}/cgi-bin" -and \( -iname "*.pl" -or -iname "*.cgi" \) -type "f" -exec chmod 750 "{}" \;

#find "${_webroot}/permit" -type "d" -exec chmod 750 "{}" \;
#find "${_webroot}/permit" -type "f" -exec chmod 640 "{}" \;

if [ -f '/usr/local/bin/restart-httpd' ]; then
	# Restart apache for good measure
	sudo '/usr/local/bin/restart-httpd' || die 'Apache restart failed'
fi

# check if this script has been updated
_local_script="$0"
_script_name=$(basename "${_local_script}")
_temp_script="/tmp/${_script_name}"
_svn_script="${_svn_prefix}/dev_scripts/${_script_name}"

#LOCALMTIME=$(stat -c %Y ${_local_script})

#svn export "${_svn_script}" "${_temp_script}"
#SVNMTIME=$(stat -c %Y ${_temp_script})

#if [ "${LOCALMTIME}" -lt "${SVNMTIME}" ]; then
#	echo 'The deployment script has modifications, updating...'
#	sudo mv "${_temp_script}" "${_local_script}"
#else
#	echo 'The deployment script is up to date'
#	rm "${_temp_script}"
#fi

echo 'Deploy script completed successfully'