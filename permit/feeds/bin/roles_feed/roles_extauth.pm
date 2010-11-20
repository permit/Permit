###############################################################################
## NAME: roles_extauth.pm
##
## DESCRIPTION: Subroutines related to feed of "external" authorizations
##              into the Roles DB tables
##
#
#  Copyright (C) 2005-2010 Massachusetts Institute of Technology
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
## Created 6/14/2005, Jim Repa.
## Modified 5/6/2008, Jim Repa.
## Modified 5/21/2008, Vlad Sluchak. Added Implied Authorization block.
## Modified 8/12/2008, Jim Repa. Use 'Compact DLC Hierarchy' for DLC links
## Modified 9/19/2008, Jim Repa. Fix rules-related select statements 3 and 4 
## Modified 10/06/2008, Jim Repa. Add Lincoln Lab employees to LIBP data
###############################################################################
package roles_extauth;
$VERSION = 1.0; 
$package_name = 'roles_extauth';

## Standard Roles Database Feed Package
#use roles_base qw(UsageExit ScriptExit RolesLog RolesNotification ArchiveFile);
use roles_base qw(UsageExit login_dbi_sql ScriptExit RolesLog RolesNotification ArchiveFile
                    find_max_actions_value find_max_actions_value2  ExecuteSQLCommands);
use config('GetValue');

## Set Test Mode
$TEST_MODE = 1;		## Test Mode (1 == ON, 0 == OFF)
if ($TEST_MODE) {print "TEST_MODE is ON for $package_name.pm\n";}


## Initialize Constants 
$datafile_dir = $ENV{'ROLES_HOMEDIR'} . "/data/";
$archive_dir = $ENV{'ROLES_HOMEDIR'} . "/archive/";

$extract_filename = $datafile_dir . $package_name . "_extract.dat";
$existing_filename = $datafile_dir . $package_name . "_existing.dat";

# Diff File Prefix used during Compare Routine
$diff_file_prefix = $datafile_dir . $package_name;

# Diff File Suffix/Tags used by the 'diff' package during the file compare
$diff_tag_insert = ".INSERT";
$diff_tag_update = ".UPDATE";
$diff_tag_delete = ".DELETE";

# Delimiter for intermediate files
$g_delim = '!';

# The actual file names that the 'diff' package will write 
$update_file= $diff_file_prefix . $diff_tag_update;
$insert_file= $diff_file_prefix . $diff_tag_insert;
$delete_file= $diff_file_prefix . $diff_tag_delete;

use DBI;


###############################################################################
###############################################################################
##
## Subroutines - Public Routines. (Called by 'roles_feed.pl')
##
###############################################################################
###############################################################################

###############################################################################
sub FeedExtract	#Externally Callable Extract Routine for this Package
###############################################################################
{
    $outfile = $datafile_dir . "extauth.warehouse";

    if ($TEST_MODE) {print "In $package_name:FeedExtract.\n";}

    shift; #Get rid of calling package name
    

    ## Step 0: Check Arguments
    if ($#_ != 2) {&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
    my($user_id, $user_pw, $db_id,$pass_num) = @_;
    
#
#   Open output file.
#
    $outf = ">" . $outfile;
    if( !open(F2, $outf) ) {
	die "$0: can't open ($outf) - $!\n";
    }

#
#  Make sure we are set up to use Oraperl.
#

#
#  Open a connection to Oracle, to the Roles DB itself to get
#  the DEPT hierarchy records.
#
    my $db_parm = GetValue("roles"); # Get info about Roles DB from config file
    $db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
    my $roles_id  = $1;
    my $roles_pw  = $2;
    my $roles_db  = $3;
    print "Logging into Roles DB...\n";
    my($roles_lda) = login_dbi_sql($roles_db, $roles_id, $roles_pw)
  	|| die $DBI::errstr;

#
#  Get mapping of D_xxxxxxx DLC codes to related qualifier_id numbers, 
#  to be used for constructing qualifier_codes for PIs.
#
    my %dlc_code2id = ();
    &get_dlc_code2id($roles_lda, \%dlc_code2id);

# Do not logoff yet from roles_lda


#
#  Open connection to oracle (Warehouse)
#
    #print "db_id='$db_id' user_id='$user_id'\n";
    my($lda) = login_dbi_sql($db_id, $user_id, $user_pw)
 	|| die $DBI::errstr;

#
# Get mapping to DLC/PI work areas and use the wa_number for
# the qualifier rather than supervisor MIT ID number
#
    my %dlc_mit_id2wa_code;
    &get_dlc_pi2wa_code($lda, \%dlc_mit_id2wa_code);

#
# Get external authorizations for PIs for Room Sets
#
    $stmt = "select p.krb_name_uppercase, wa.ehs_rep_mit_id, '*EHS REP',
      'RS_' || substr(wa.work_area_id, 13, 8) room_set_code
      from wareuser.whehss_work_area wa, wareuser.krb_person p
      where wa.work_area_type = 'RS'
      and substr(wa.dlc_code, 1, 2) = 'D_'
      and p.mit_id(+) = wa.ehs_rep_mit_id
      and wa.work_area_status_code = 'AC'
      and ehs_rep_mit_id is not null 
      -- View Room Set auth for EHS Reps (skip if EHS Rep = the PI)
      union select p.krb_name_uppercase, wa.ehs_rep_mit_id, 
      '*VIEW ROOM SET INFO',
      'RS_' || substr(wa.work_area_id, 13, 8) room_set_code
      from wareuser.whehss_work_area wa, wareuser.krb_person p
      where wa.work_area_type = 'RS'
      and substr(wa.dlc_code, 1, 2) = 'D_'
      and p.mit_id(+) = wa.ehs_rep_mit_id
      and wa.work_area_status_code = 'AC'
      and wa.ehs_rep_mit_id is not null 
      and wa.ehs_rep_mit_id <> wa.pi_mit_id
      -- EHS Reps access to training records for related PI
      union select distinct p.krb_name_uppercase, wa.ehs_rep_mit_id, 
            '*VIEW EHS TRAINING REPORT',
      wa.pi_mit_id || '-' || wa.dlc_code
      from wareuser.whehss_work_area wa, wareuser.krb_person p
      where wa.work_area_type = 'RS'
      and substr(wa.dlc_code, 1, 2) = 'D_'
      and p.mit_id(+) = wa.ehs_rep_mit_id
      and wa.work_area_status_code = 'AC'
      and ehs_rep_mit_id is not null 
      -- Secondary PI by room
      union select distinct p.krb_name_uppercase, fd.mit_id,
      '*SECONDARY PI',
      decode(rm.is_subroom, 'Y', 'SubR_', 'N', 'R_') 
        || substr(rm.work_area_id, 13, 8) room_set_id
      from wareuser.whehss_work_area rm, 
           wareuser.whehss_work_area rs,
           wareuser.whehss_function_detail fd,
           wareuser.whehss_function f, 
           wareuser.krb_person p
      where f.ehss_function_key = fd.ehss_function_key
      and f.ehss_function_code = 'ERP'
      and rm.ehss_work_area_key = fd.ehss_work_area_key
      and rm.work_area_type = 'RM'
      and rs.ehss_work_area_key = rm.work_area_parent_id
      and rm.work_area_status_code = 'AC'
      and rs.work_area_type = 'RS'
      and rm.work_area_name is not null
      and rm.room_status = 'Active'
      and p.mit_id(+) = fd.mit_id
      -- Secondary PI by room set
      union select distinct p.krb_name_uppercase, fd.mit_id,
      '*SECONDARY PI',
      'RS_' || substr(rs.work_area_id, 13, 8) room_set_id
      from wareuser.whehss_work_area rs,
           wareuser.whehss_function_detail fd,
           wareuser.whehss_function f, 
           wareuser.krb_person p
      where f.ehss_function_key = fd.ehss_function_key
      and f.ehss_function_code = 'ESS'
      and rs.ehss_work_area_key = fd.ehss_work_area_key
      and rs.work_area_status_code = 'AC'
      and rs.work_area_type = 'RS'
      and p.mit_id = fd.mit_id
      -- Secondary PI by room set: View Room Set Data
      union select distinct p.krb_name_uppercase, fd.mit_id,
      '*VIEW ROOM SET INFO',
      'RS_' || substr(rs.work_area_id, 13, 8) room_set_id
      from wareuser.whehss_work_area rs,
           wareuser.whehss_function_detail fd,
           wareuser.whehss_function f, 
           wareuser.krb_person p
      where f.ehss_function_key = fd.ehss_function_key
      and f.ehss_function_code = 'ESS'
      and rs.ehss_work_area_key = fd.ehss_work_area_key
      and rs.work_area_status_code = 'AC'
      and rs.work_area_type = 'RS'
      and p.mit_id = fd.mit_id
      -- Room Rep by room
      union select distinct p.krb_name_uppercase, fd.mit_id,
      '*ROOM REP',
      decode(rm.is_subroom, 'Y', 'SubR_', 'N', 'R_') 
        || substr(rm.work_area_id, 13, 8) room_set_id
      from wareuser.whehss_work_area rm, 
           wareuser.whehss_work_area rs,
           wareuser.whehss_function_detail fd,
           wareuser.whehss_function f, 
           wareuser.krb_person p
      where f.ehss_function_key = fd.ehss_function_key
      and f.ehss_function_code = 'ERR'
      and rm.ehss_work_area_key = fd.ehss_work_area_key
      and rm.work_area_type = 'RM'
      and rs.ehss_work_area_key = rm.work_area_parent_id
      and rm.work_area_status_code = 'AC'
      and rs.work_area_type = 'RS'
      and rm.work_area_name is not null
      and rm.room_status = 'Active'
      and p.mit_id(+) = fd.mit_id
      and rs.ehs_rep_mit_id <> fd.mit_id -- Skip it if Room Rep = EHS Rep
      -- Emergency contact by room
      union select distinct p.krb_name_uppercase, fd.mit_id,
      '*EHS EMERGENCY CONTACT',
      'RS_' || substr(rs.work_area_id, 13, 8) room_set_code
      from wareuser.whehss_work_area rm, 
           wareuser.whehss_work_area rs,
           wareuser.whehss_function_detail fd,
           wareuser.whehss_function f, 
           wareuser.krb_person p
      where f.ehss_function_key = fd.ehss_function_key
      and f.ehss_function_code = 'ERC'
      and rm.ehss_work_area_key = fd.ehss_work_area_key
      and rm.work_area_type = 'RM'
      and rs.ehss_work_area_key = rm.work_area_parent_id
      and rm.work_area_status_code = 'AC'
      and rs.work_area_type = 'RS'
      and rm.work_area_name is not null
      and rm.room_status = 'Active'
      and p.mit_id(+) = fd.mit_id
      -- Room Rep, Emergency Contact access to view Room Set info
      union select distinct p.krb_name_uppercase, fd.mit_id,
      '*VIEW ROOM SET INFO',
      'RS_' || substr(rs.work_area_id, 13, 8) room_set_code
      from wareuser.whehss_work_area rm, 
           wareuser.whehss_work_area rs,
           wareuser.whehss_function_detail fd,
           wareuser.whehss_function f, 
           wareuser.krb_person p
      where f.ehss_function_key = fd.ehss_function_key
      and f.ehss_function_code in ('ERR', 'ERC')
      and rm.ehss_work_area_key = fd.ehss_work_area_key
      and rm.work_area_type = 'RM'
      and rs.ehss_work_area_key = rm.work_area_parent_id
      and rm.work_area_status_code = 'AC'
      and rs.work_area_type = 'RS'
      and rm.work_area_name is not null
      and rm.room_status = 'Active'
      and p.mit_id(+) = fd.mit_id
      and rs.ehs_rep_mit_id <> fd.mit_id -- Skip it if Room Rep = EHS Rep
      and rs.pi_mit_id <> fd.mit_id -- Skip it if Room Rep = PI
      -- Secondary PI (by room set) access to training by PI
      union select distinct p.krb_name_uppercase, fd.mit_id,
      '*VIEW EHS TRAINING REPORT', 
      rs.pi_mit_id || '-' || rs.dlc_code
      from wareuser.whehsta_pi_work_area piwa, 
           wareuser.whehss_work_area rs,
           wareuser.whehss_function_detail fd,
           wareuser.whehss_function f, 
           wareuser.krb_person p
      where f.ehss_function_key = fd.ehss_function_key
      and f.ehss_function_code = 'ESS'
      and rs.ehss_work_area_key = fd.ehss_work_area_key
      and rs.work_area_type = 'RS'
      and rs.work_area_status_code = 'AC'
      and piwa.pi_mit_id = rs.pi_mit_id
      and piwa.dlc_code = rs.dlc_code
      and piwa.work_area_type = 'PI'
      and p.mit_id = fd.mit_id
      -- Secondary PI and Room Rep access to training by PI
      union select distinct p.krb_name_uppercase, fd.mit_id,
      '*VIEW EHS TRAINING REPORT', 
      rs.pi_mit_id || '-' || rs.dlc_code
      from wareuser.whehss_work_area rm, 
           wareuser.whehss_work_area rs,
           wareuser.whehss_function_detail fd,
           wareuser.whehss_function f, 
           wareuser.krb_person p
      where f.ehss_function_key = fd.ehss_function_key
      and f.ehss_function_code in ('ERP', 'ERR')
      and rm.ehss_work_area_key = fd.ehss_work_area_key
      and rm.work_area_type = 'RM'
      and rs.ehss_work_area_key = rm.work_area_parent_id
      and rm.work_area_status_code = 'AC'
      and rs.work_area_type = 'RS'
      and rm.work_area_name is not null
      and rm.room_status = 'Active'
      and p.mit_id(+) = fd.mit_id
      -- Reconciler for a PI
      union select distinct p.krb_name_uppercase, fd.mit_id,
      '*EHS RECONCILER', 
      piwa.pi_mit_id || '-' || piwa.dlc_code
      from wareuser.whehsta_pi_work_area piwa, 
           wareuser.whehsta_reconciler_detail fd,
           wareuser.krb_person p
      where piwa.pi_work_area_id = fd.ehsta_pi_work_area_key
      and fd.ehsta_recon_assign_type_key = 'BEPT'
      and piwa.work_area_status_code = 'AC'
      and piwa.work_area_type = 'PI'
      and p.mit_id = fd.mit_id
      -- View EHS Training by PI for a Reconciler
      union select distinct p.krb_name_uppercase, fd.mit_id,
      '*EHS RECONCILER', 
      piwa.pi_mit_id || '-' || piwa.dlc_code
      from wareuser.whehsta_pi_work_area piwa, 
           wareuser.whehsta_reconciler_detail fd,
           wareuser.krb_person p
      where piwa.pi_work_area_id = fd.ehsta_pi_work_area_key
      and fd.ehsta_recon_assign_type_key = 'BEPT'
      and piwa.work_area_status_code = 'AC'
      and piwa.work_area_type = 'PI'
      and p.mit_id = fd.mit_id
      -- Reconciler for a PI
      union select distinct p.krb_name_uppercase, fd.mit_id,
      '*EHS RECONCILER', 
      piwa.pi_mit_id || '-' || piwa.dlc_code
      from wareuser.whehsta_pi_work_area piwa, 
           wareuser.whehsta_reconciler_detail fd,
           wareuser.krb_person p
      where piwa.pi_work_area_id = fd.ehsta_pi_work_area_key
      and fd.ehsta_recon_assign_type_key = 'BEPT'
      and piwa.work_area_status_code = 'AC'
      and piwa.work_area_type = 'PI'
      and p.mit_id = fd.mit_id
      union select distinct p.krb_name_uppercase, fd.mit_id,
      '*VIEW EHS TRAINING REPORT', 
      piwa.pi_mit_id || '-' || piwa.dlc_code
      from wareuser.whehsta_pi_work_area piwa, 
           wareuser.whehsta_reconciler_detail fd,
           wareuser.krb_person p
      where piwa.pi_work_area_id = fd.ehsta_pi_work_area_key
      and fd.ehsta_recon_assign_type_key = 'BEPT'
      and piwa.work_area_status_code = 'AC'
      and piwa.work_area_type = 'PI'
      and p.mit_id = fd.mit_id
      order by 4, 1, 2";
    #print "stmt= '" . $stmt . "'\n";

 $csr = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";

 $csr->execute();

#
#  Write out the records for the external authorizations
#
#
    my $i = 0;
    my ($temp_dlc_code, $temp_pi_mit_id);
    while ( ($xkerbname, $xmit_id, $xfunction, $xqualifier)
	    = $csr->fetchrow_array() )
    {
	if (($i++)%1000 == 0) {print $i . "\n";}
	if ($xkerbname) {
	    # Modify qualifier_codes that represent a PI within a DLC
	    my $temp_qual_code = $xqualifier;
	    if (substr($xqualifier, 9,3) eq '-D_') {
		$temp_dlc_code = substr($xqualifier, 10);
		$temp_pi_mit_id = substr($xqualifier, 0, 9);
		#$temp_qual_code = 
		#   $temp_pi_mit_id . '-' . $dlc_code2id{$temp_dlc_code}
		$temp_qual_code = $dlc_mit_id2wa_code{"$temp_dlc_code$temp_pi_mit_id"};
		if ($temp_qual_code) {
		    print F2 "$xkerbname$g_delim$xfunction$g_delim$temp_qual_code\n";
		}
		else {
		    print "Warning.  No DLC/PI work area code found for DLC"
			. " '$temp_dlc_code' and PI MIT ID '$temp_ip_mit_id'"
			    . " (xqualifier='$xqualifier')\n";
		}
	    }
	    else {
		print F2 "$xkerbname$g_delim$xfunction$g_delim$temp_qual_code\n";
	    }
	}
    }
     $csr->finish() || die "can't close cursor";

#
# Get more external authorizations -- for SARA reporters within Room Sets
#
    $stmt = "select p.krb_name_uppercase, wa.sara_reporter_mit_id, 
      '*SARA REPORTER',
      'RS_' || substr(wa.work_area_id, 13, 8) room_set_code
      from wareuser.whehss_work_area wa, wareuser.krb_person p
      where wa.work_area_type = 'RS'
      and substr(wa.dlc_code, 1, 2) = 'D_'
      and p.mit_id(+) = wa.sara_reporter_mit_id
      and wa.work_area_status_code = 'AC'
      and sara_reporter_mit_id is not null 
      -- View Room Set auth for EHS Reps (skip if EHS Rep = the PI)
      union select p.krb_name_uppercase, rs.sara_reporter_mit_id, 
      '*VIEW ROOM SET LIMITED',
      'RS_' || substr(rs.work_area_id, 13, 8) room_set_code
      from wareuser.whehss_work_area rs, wareuser.krb_person p
      where rs.work_area_type = 'RS'
      and substr(rs.dlc_code, 1, 2) = 'D_'
      and p.mit_id(+) = rs.sara_reporter_mit_id
      and rs.work_area_status_code = 'AC'
      and rs.sara_reporter_mit_id is not null 
      and rs.sara_reporter_mit_id <> nvl(rs.pi_mit_id, ' ')
      and rs.sara_reporter_mit_id <> nvl(rs.ehs_rep_mit_id, ' ')
      and not exists (select fd.mit_id 
        from wareuser.whehss_function_detail fd, 
             wareuser.whehss_function f,
             wareuser.whehss_work_area rm
             where fd.mit_id = rs.sara_reporter_mit_id
             and f.ehss_function_key = fd.ehss_function_key
             and f.ehss_function_code in ('ERP', 'ERR', 'ERC')
             and rm.ehss_work_area_key = fd.ehss_work_area_key
             and rm.work_area_type = 'RM'
             and rs.ehss_work_area_key = rm.work_area_parent_id
             and rm.work_area_status_code = 'AC'
             and rs.work_area_type = 'RS'
             and rm.work_area_name is not null
             and rm.room_status = 'Active')
      order by 4, 2, 1";
    #print "stmt= '" . $stmt . "'\n";
 $csr = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";
 $csr->execute();

#
#  Write out more records for external authorizations
#
#
    $i = 0;
    while ( ($xkerbname, $xmit_id, $xfunction, $xqualifier)
	    = $csr->fetchrow_array() )
    {
	if (($i++)%1000 == 0) {print $i . "\n";}
	

	if ($xkerbname) {
	    $temp_qual_code = $xqualifier;
	    print F2 "$xkerbname$g_delim$xfunction$g_delim$temp_qual_code\n";
	}
    }
    $csr->finish() || die "can't close cursor";

#
# Get still more external authorizations -- for Library patrons
#  **** This part extracts student/faculty/staff data  ****
#
  #my $hierarchy = 'Standard Hierarchy';
  my $hierarchy = 'Compact DLC Hierarchy';
  $stmt = "select e.krb_name_uppercase, e.mit_id,
    '*' || upper(library_person_type), 
    nvl(m.dlc_code, 'D_UNDEF')
  from library_employee e, master_dept_hierarchy_links m
  where m.linked_object_code(+) = e.org_unit_id
  and m.hierarchy_type(+) = '$hierarchy'
  and m.link_type_code(+) = 'ORG2'
  --and e.krb_name_uppercase like 'R%'
  union select s.krb_name_uppercase, s.mit_id,
      decode(greatest(is_year_confidential, is_course_confidential), 'N',  
             decode(s.student_year, 'G', '*STUDENT - GRADUATE', 
                                         '*STUDENT - UNDERGRADUATE'),
             decode(s.student_year, 'G', '*STUDENT - GRAD (CONF)', 
                                         '*STUDENT - UNDERGRAD (CONF)')
            ) library_person_type,
      nvl(m.dlc_code, 'D_UNDEF')
  from library_student s, master_dept_hierarchy_links m
  where m.linked_object_code(+) = s.home_department
   and m.hierarchy_type(+) = '$hierarchy'
   and m.link_type_code(+) = 'SIS'
   and nvl(m.dlc_code, 'D_UNDEF') <> 'D_CROSS_REG'
   --and s.krb_name_uppercase like 'R%'
  union select s.krb_name_uppercase, s.mit_id,
      decode(greatest(is_year_confidential, is_course_confidential), 'N', 
             '*NON-MIT CROSS-REGISTERED',
             '*NON-MIT CROSS-REG (CONF)'
            ) library_person_type,
      nvl(m.dlc_code, 'D_UNDEF')
  from library_student s, master_dept_hierarchy_links m
  where m.linked_object_code(+) = s.home_department
   and m.hierarchy_type(+) = '$hierarchy'
   and m.link_type_code(+) = 'SIS'
   and nvl(m.dlc_code, 'D_UNDEF') = 'D_CROSS_REG'
   --and s.krb_name_uppercase like 'R%'
  union select k.krb_name_uppercase, l.mit_id, 
    '*' || replace(upper(b.library_borrower_status), ' (SEE NOTES)', '') func,
    'D_UNDEF'
  from wareuser.xwhlib_patron l, library_borrower_status b, krb_person k
  where k.mit_id = l.mit_id
  and b.library_borrower_status_code = l.library_borrower_status_code
  and b.library_borrower_type_code = l.library_borrower_type_code
  and k.person_type not in ('Current Employee', 'Current Student')
  and upper(b.library_borrower_status) not like '%*DO NOT USE*%' 
  union select e.krb_name_uppercase, e.mit_id,
    '*STAFF - LINCOLN LAB' func, m.dlc_code
  from employee_directory e, master_dept_hierarchy_links m
  where m.linked_object_code = e.department_number
  and m.hierarchy_type = '$hierarchy'
  and m.link_type_code = 'ORGU'
  and m.dlc_code = 'D_LINCOLN'
  order by 1, 3, 4";

  $csr = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";

  $csr->execute();

#
#  Write out Library patron related records for external authorizations
#
#
    $i = 0;
    while ( ($xkerbname, $xmit_id, $xfunction, $xqualifier)
	    = $csr->fetchrow_array() )
    {
	if (($i++)%1000 == 0) {print $i . "\n";}
	if ($xkerbname) {
	    $temp_qual_code = $xqualifier;
	    print F2 "$xkerbname$g_delim$xfunction$g_delim$temp_qual_code\n";
	}
    }
    $csr->finish() || die "can't close cursor";


#
# Get still more external authorizations -- for student access to AMPS content
#  **** This part extracts student data  ****
#
  #my $hierarchy = 'Standard Hierarchy';
  my $hierarchy = 'Compact DLC Hierarchy';
  # $stmt = "select s.krb_name_uppercase, s.mit_id, ...
  # ...
  # --and s.krb_name_uppercase like 'R%'
  #  order by 1, 3, 4";
  
  
  $stmt = "select k.krb_name_uppercase,'*IS REGISTERED', master_subject_id||'-'||substr(e.term_code,3,2)||decode(substr(e.term_code,5,2),'FA','F','SP','S','SU','M','JA','J')||decode(e.section_id,'000',null,('-'||e.section_id)) 
from krb_mapping k,
     whsubject_enrollment e,
     whsubject_reg_status s
     where k.mit_id = e.mit_id
       and e.reg_status_code = s.subject_reg_status_key
       and s.is_registered = 'Y'
       and e.term_code between '2010FA' and '2010SU'
       and e.master_subject_id in ('18.03','15.012')
";
  

  $csr = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";

  $csr->execute();

#
#  Write out AMPS/ Student registration related records for external authorizations
#
#
    $i = 0;
    while ( ($xkerbname, $xmit_id, $xfunction, $xqualifier)
	    = $csr->fetchrow_array() )
    {
	if (($i++)%1000 == 0) {print $i . "\n";}
	if ($xkerbname) {
	    $temp_qual_code = $xqualifier;
	    print F2 "$xkerbname$g_delim$xfunction$g_delim$temp_qual_code\n";
	}
    }
    $csr->finish() || die "can't close cursor";





#
# Apply rules for external authorizations records.
# This block consists of 4 select statements applied to Roles database.
# If the pass number is more then 1 - lookup  function_id from  function_load_pass 
# table for which pass_number is equal to the actual pass number.   

#if ($pass_num > 1)

#{
$stmt1="SELECT EA.KERBEROS_NAME,CONCAT('*',IAR.RESULT_FUNCTION_NAME),IAR.RESULT_QUALIFIER_CODE
FROM implied_auth_rule IAR, function_group_link FGL, function_group FG, external_auth EA
WHERE
IAR.condition_function_name=FG.function_group_name 
AND FG.FUNCTION_GROUP_ID=FGL.PARENT_ID 
AND EA.FUNCTION_ID=FGL.CHILD_ID
AND EA.qualifier_code=IAR.condition_qual_code
and IAR.rule_type_code in ('2a', '2b')
AND IAR.RULE_IS_IN_EFFECT='Y'";


    $stmt2="SELECT EA.KERBEROS_NAME, CONCAT('*',IAR.RESULT_FUNCTION_NAME), IAR.RESULT_QUALIFIER_CODE,
IAR.RULE_ID, IAR.CONDITION_FUNCTION_OR_GROUP, 
IAR.CONDITION_FUNCTION_CATEGORY, IAR.CONDITION_FUNCTION_NAME, IAR.CONDITION_QUAL_CODE, 
FG.FUNCTION_GROUP_ID, FGL.CHILD_ID, EA.FUNCTION_NAME, 
EA.QUALIFIER_CODE 
FROM 
implied_auth_rule IAR, function_group_link FGL, function_group FG, external_auth EA, qualifier_descendent QD, qualifier Q WHERE
 (IAR.CONDITION_FUNCTION_NAME=FG.FUNCTION_GROUP_NAME 
 AND FG.FUNCTION_GROUP_ID=FGL.PARENT_ID 
 AND EA.FUNCTION_ID=FGL.CHILD_ID 
 AND IAR.CONDITION_QUAL_CODE=Q.QUALIFIER_CODE 
 AND Q.QUALIFIER_ID=QD.PARENT_ID 
 AND QD.CHILD_ID=EA.QUALIFIER_ID 
 AND IAR.RULE_IS_IN_EFFECT='Y' 
 and IAR.rule_type_code = '2b'
 AND Q.QUALIFIER_TYPE= (case IAR.condition_obj_type when 'DLC' THEN 'DEPT' ELSE IAR.condition_obj_type END ))"; 
 #AND Q.QUALIFIER_TYPE=  decode(IAR.condition_obj_type, 'DLC', 'DEPT', IAR.condition_obj_type))"; 


$stmt3 = "SELECT EA.KERBEROS_NAME,CONCAT('*',IAR.RESULT_FUNCTION_NAME), 
          IAR.RESULT_QUALIFIER_CODE, IAR.CONDITION_FUNCTION_NAME,
          IAR.CONDITION_QUAL_CODE,
          IAR.RULE_ID, IAR.RULE_TYPE_CODE, IAR.CONDITION_FUNCTION_OR_GROUP, 
          EA.QUALIFIER_CODE
    FROM 
    implied_auth_rule IAR, external_auth EA 
    WHERE 
    EA.function_name in
      (IAR.condition_function_name, CONCAT('*' , IAR.condition_function_name))
    AND IAR.CONDITION_QUAL_CODE=EA.QUALIFIER_CODE
    AND IAR.RULE_TYPE_CODE in ('2a', '2b')
    AND IAR.RULE_IS_IN_EFFECT='Y'";

$stmt4 = "SELECT EA.KERBEROS_NAME,CONCAT('*',IAR.RESULT_FUNCTION_NAME), 
          IAR.RESULT_QUALIFIER_CODE, 
          IAR.RULE_ID, IAR.CONDITION_FUNCTION_OR_GROUP, 
          IAR.CONDITION_FUNCTION_CATEGORY, IAR.CONDITION_FUNCTION_NAME, 
          IAR.CONDITION_QUAL_CODE, EA.QUALIFIER_CODE, QD.CHILD_ID, 
          EA.FUNCTION_NAME 
    FROM implied_auth_rule IAR, external_auth EA, qualifier Q, 
         qualifier_descendent QD 
    WHERE 
     EA.function_name in
      (IAR.condition_function_name, CONCAT('*' , IAR.condition_function_name))
     AND QD.CHILD_ID=EA.QUALIFIER_ID 
     AND IAR.CONDITION_QUAL_CODE=Q.QUALIFIER_CODE 
     AND Q.QUALIFIER_ID=QD.PARENT_ID  
     AND IAR.RULE_IS_IN_EFFECT='Y' 
     AND IAR.RULE_TYPE_CODE = '2b'";

#
#  Write out Library patron related records for external authorizations
#

 $roles_csr = $roles_lda->prepare($stmt1)
      || die "$DBI::errstr . \n";
 $roles_csr->execute();


&fetch_and_write_iar($roles_csr, F2);
 $roles_csr->finish()
	|| die "can't close cursor";

 $roles_csr = $roles_lda->prepare($stmt2)
      || die "$DBI::errstr . \n";
 $roles_csr->execute();
&fetch_and_write_iar($roles_csr,F2);
 $roles_csr->finish()
	|| die "can't close cursor";

 $roles_csr = $roles_lda->prepare($stmt3)
      || die "$DBI::errstr . \n";
 $roles_csr->execute();
&fetch_and_write_iar($roles_csr,F2);
 $roles_csr->finish()
	|| die "can't close cursor";

 $roles_csr = $roles_lda->prepare($stmt4)
      || die "$DBI::errstr . \n";
 $roles_csr->execute();
 &fetch_and_write_iar($roles_csr,F2); 
 $roles_csr->finish()
	|| die "can't close cursor";

#} #end of extract rules block

$roles_lda->disconnect() || die "can't log off DB";

#
#  Log into Roles
#
# $db_parm = GetValue("troles"); # Get info about Roles DB from config file
# $db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
# $roles_id  = $1;
# $roles_pw  = $2;
# $roles_db  = $3;
# print "Logging into Oracle (TRoles DB)...\n";
# $roles_lda = &ora_login($roles_db, $roles_id, $roles_pw)
#  	|| die $ora_errstr;
# print "Done logging into Oracle (TRoles DB)\n";

#
#  Get a list of PI-DLC qualifiers that have Room Sets
#
###### Use the Warehouse to get this info.
#my $stmt0 = "select q.qualifier_code from qualifier q 
#             where q.qualifier_type = 'RSET'
#             and length(qualifier_code) = 14
#             and substr(qualifier_code, 10, 1) = '-'
#             and translate(qualifier_code, '0123456789-', '-----------') 
#                 = '--------------'
#             and q.has_child = 'Y'
#             order by 1";
#my $roles_csr0 = &ora_open($roles_lda, $stmt0)
#	|| die $ora_errstr;
#my $pi_qualcode;
#my %pi_has_room_set = ();  # Remember which PIs have Room Sets
#while ( ($pi_qualcode) = &ora_fetch($roles_csr0) )
#{
#   $pi_has_room_set{$pi_qualcode} = 1;
#}
#&ora_close($roles_csr0) || die "can't close cursor";
my $stmt0 = "select distinct substr(piwa.pi_work_area_id, 13, 8)
      --, distinct piwa.dlc_code, piwa.pi_mit_id,
      --substr(piwa.pi_full_name, 1, 39) 
      --    || ' (' || p.krb_name_uppercase || ')' full_name, 
      from wareuser.whehsta_pi_work_area piwa, wareuser.krb_person p,
           wareuser.whehss_work_area rswa
      where piwa.work_area_type = 'PI'
      and substr(piwa.dlc_code, 1, 2) = 'D_'
      and piwa.work_area_status_code = 'AC'
      and nvl(piwa.pi_mit_id, ' ') <> ' '
      and p.mit_id(+) = piwa.pi_mit_id
      and rswa.pi_mit_id = piwa.pi_mit_id
      and rswa.work_area_type = 'RS'
      and rswa.work_area_status_code = 'AC'
      order by 1";
#print "'$stmt0'\n";
 $csr0 = $lda->prepare($stmt0)
      || die "$DBI::errstr . \n";

 $csr0->execute();

my ($pi_qualcode);
my %pi_has_room_set = ();  # Remember which PIs have Room Sets
while ( ($pi_qualcode) = $csr0->fetchrow_array() )
{
    $pi_has_room_set{"PI_$pi_qualcode"} = 1;
}
$csr0->finish() || die "can't close cursor";


#
#  Get implied PI roles by looking at PI work areas in the Warehouse.
#
my $stmt = "select distinct p.krb_name_uppercase,
          '*PRIMARY PI', 'PI_' || substr(piwa.pi_work_area_id, 13, 8)
      from wareuser.whehsta_pi_work_area piwa, wareuser.krb_person p
      where piwa.work_area_type = 'PI'
      and substr(piwa.dlc_code, 1, 2) = 'D_'
      and piwa.work_area_status_code = 'AC'
      and p.mit_id = piwa.pi_mit_id
    union select distinct p.krb_name_uppercase,
          '*VIEW EHS TRAINING REPORT', 'PI_' || substr(piwa.pi_work_area_id, 13, 8)
      from wareuser.whehsta_pi_work_area piwa, wareuser.krb_person p
      where piwa.work_area_type = 'PI'
      and substr(piwa.dlc_code, 1, 2) = 'D_'
      and piwa.work_area_status_code = 'AC'
      and p.mit_id = piwa.pi_mit_id
    union select distinct p.krb_name_uppercase,
          '*VIEW ROOM SET INFO', 'PI_' || substr(piwa.pi_work_area_id, 13, 8)
      from wareuser.whehsta_pi_work_area piwa, wareuser.krb_person p
      where piwa.work_area_type = 'PI'
      and substr(piwa.dlc_code, 1, 2) = 'D_'
      and piwa.work_area_status_code = 'AC'
      and p.mit_id = piwa.pi_mit_id
      order by 1, 2";
 my $pi_csr = $lda->prepare($stmt)
      || die "$DBI::errstr . \n";

 $pi_csr->execute();

my ($xkerbname, $xmit_id, $xfunction, $xqualifier, $temp_qual_code);
while ( ($xkerbname, $xfunction, $xqualifier)
        = $pi_csr->fetchrow_array() )
{
    if ($xkerbname) {
	if ($xfunction eq '*VIEW ROOM SET INFO' 
	    && (!$pi_has_room_set{$xqualifier}) ) {
	    # Skip this authorization.  There are no room sets for this PI.
	}
	else {
	    print F2 "$xkerbname$g_delim$xfunction$g_delim$xqualifier\n";
	}
    }
}
$pi_csr->finish() || die "can't close cursor";
$lda->disconnect() || die "can't log off Oracle";

close (F2);

}

###############################################################################
sub FeedPrepare 	#Externally Callable Feed Prepare Routine
###############################################################################
{
    if ($TEST_MODE) {print "In $package_name:FeedPrepare.\n";}

    shift; #Get rid of calling package name

    ## Step 0: Check Arguments
    if ($#_ != 2)	{&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
    my($user_id, $user_pw, $db_id) = @_;

    ## Step 2: Log Into Destination Database
    my($destination_lda) = &login_dbi_sql($db_id, $user_id, $user_pw)
	|| (
	    &RolesLog("FATAL_MSG",
		      $DBI::errstr) &&
	    ScriptExit("Unable to Log into Destination Database: $db_id.")		);

    ## Step 3: Get Extract from Destination Database
    unless (-w $datafile_dir)
    {
	&RolesLog("FATAL_MSG",
		  "Datafile Directory is not writable: $datafile_dir");
	ScriptExit("Unable write to directory $datafile_dir.");
    }

    ## Get data from roles
    &ExistingExtract($destination_lda, $datafile_dir);

    ## Step 4: Log off Destination Database
    $destination_lda->disconnect();

    ## compare data
    &CompareExtract($datafile_dir);

    return;
}

###############################################################################
sub FeedLoad 	#Externally Callable Feed Load Routine for this Package
###############################################################################
{
    if ($TEST_MODE) {print "In $package_name:FeedLoad.\n";}

    shift; #Get rid of calling package name

    my($infile) = $datafile_dir . "extauth.actions";
    my($sqlfile) = $datafile_dir . "extauthchange.sql";

    ## Step 0: Check Arguments
    if ($#_ != 2){&UsageExit("Command Parameters: <user_id> <user_pw> <db_id>\nInsufficient Arguments");}
    my($user_id, $user_pw, $db_id) = @_;


    ## Check number of actions to be preformed
    $MAX_ACTIONS = &find_max_actions_value2( $db_id,$user_id, $user_pw, "MAX_EXTAUTH");
    if (-r $infile) {
	$actions_count = `grep -c . $infile`;
	chomp($actions_count);
    }
    else {
	die "Missing actions file '$infile'\n";
    }

    if ($actions_count > $MAX_ACTIONS)
    {
	$msg = "Number of Actions ($actions_count) exceeds threshold ($MAX_ACTIONS).\n";
	print $msg;
	&RolesNotification("Number of actions exceeds threshold", $msg);
	return -1; # send email
    }
    elsif ($actions_count == 0) {
	$msg = "No actions to process today.\n";
	print $msg;
	#&RolesNotification("No actions to process today.", $msg);
	return -1;
    }
    else
    {
	print "$actions_count actions to be performed.\n";
    }

    ## Step 1: Log Into Destination Database
    my($destination_lda) = login_dbi_sql($db_id, $user_id, $user_pw)
	|| (
	    &RolesLog("FATAL_MSG",
		      "Unable to log into destination database $DBI::errstr") &&
	    ScriptExit("Unable to Log into Destination Database: $db_id.")		);

    ## Step 2: Update, Insert and Delete Records

    if (-r $infile) {&ProcessAuthActions($destination_lda, $infile, $sqlfile);}

    # Run the first .sql file
    ExecuteSQLCommands($sqlfile,$destination_lda);

    #my($cmd) = "sqlplus $user_id/$user_pw\@$db_id \@$sqlfile";

    #$rc = system($cmd);
    #$rc >>= 8;
    #unless ($rc == 0) {
#	print "Error return code $rc from first sqlplus\n";
#	die;
#    }

    ## Step 3: Archive Files
    &ArchiveFile($infile, $archive_dir);
#	&ArchiveFile($extract_filename, $archive_dir);
#	&ArchiveFile($existing_filename, $archive_dir);
#	if (-r $update_file) {&ArchiveFile($update_file, $archive_dir);}
#	if (-r $insert_file) {&ArchiveFile($insert_file, $archive_dir);}
#	if (-r $delete_file) {&ArchiveFile($delete_file, $archive_dir);}
    
    ## Step 5: Log off Destination Database
    $destination_lda->disconnect();

    return;
}

###############################################################################
sub FeedExternalExtract	#Externally Callable External Extract Routine
###############################################################################
{
    if ($TEST_MODE) {print "In $package_name:FeedExternalExtract.\n";}

    shift; #Get rid of calling package name

    ## Not Defined
    return -1;
}

###############################################################################
sub CheckStatus	#Externally Callable Status Routine to for this Package
###############################################################################
{
    if ($TEST_MODE) {print "In $package_name:CheckStatus.\n";}

    shift; #Get rid of calling package name

    return;
}


###############################################################################
sub PackageTest	#Externally Callable Package Test Routine 
###############################################################################
{
    if ($TEST_MODE) {print "In $package_name:PackageTest.\n";}

    return;
}


###############################################################################
###############################################################################
##
## Subroutines - Private Common Routines.
##
###############################################################################
###############################################################################

########################################################################
#
#  Extract EXTAUTH data from EXTERNAL_AUTH table of Roles DB.
#
########################################################################
sub ExistingExtract
{
    my($lda, $data_dir) = @_;

    $outfile = $data_dir . "extauth.roles";
    $qqualtype = 'EXTAUTH';
    
#
#   Open output file.
#
    $outf = "|cat >" . $outfile;
    if( !open(F2, $outf) ) {
	die "$0: can't open ($outf) - $!\n";
    }

#
#  Open first cursor
#
    $stmt = "select a.kerberos_name, a.function_name, a.qualifier_code"
	. " from external_auth a"
	    . " order by 3, 2, 1";
 $csr = $lda->prepare($stmt)
        || die $DBI::errstr;
 $csr->execute()
        || die $DBI::errstr;

    print "Reading in External authorizations from Roles DB table...\n";
    $i = -1;
    my ($xkerbname, $xfunction, $xqualifier);
    while ( ($xkerbname, $xfunction, $xqualifier) = $csr->fetchrow_array() )
    {
	#if (($i++)%5000 == 0) {print $i . "\n";}
	print F2 "$xkerbname$g_delim$xfunction$g_delim$xqualifier\n";
    }
    $csr->finish() || die "can't close cursor";
    
    close (F2);
    
}

########################################################################
#
#  Subroutine &get_dlc_code2id{$lda, \%dlc_code2id}
#
#  Get mapping of DLC codes D_xxxxxx to the qualifier_id number from
#  the DEPT qualifiers in the QUALIFIER table.
#
########################################################################
sub get_dlc_code2id
{
    my($roles_lda, $rdlc_code2id) = @_;

    %$rdlc_code2id = ();   # Clear the hash

#
#  Open cursor
#
    my $stmt = "select qualifier_code, qualifier_id
             from qualifier
             where qualifier_type = 'DEPT'
             order by qualifier_code";
    my $roles_csr = $roles_lda->prepare($stmt)
        || die $DBI::errstr;
    $roles_csr->execute();
    print "Reading in dept records from the Roles qualifier table...\n";
    my $i = -1;
    while ( ($qqcode, $qqid) = $roles_csr->fetchrow_array() )
    {
	#if (($i++)%5000 == 0) {print $i . "\n";}
	$$rdlc_code2id{$qqcode} = substr($qqid, 2, 4);
    }

    $roles_csr->finish() || die "can't close cursor";
    
}

########################################################################
#
#  Subroutine &get_dlc_pi2wa_code{$lda, \%dlc_mit_id2wa_code}
#
#  Get mapping of "$dlc_code$pi_mit_id" to the SAP work-area code for
#  the DLC/PI pair.  This will be used as the qualifier_code for 
#  identifying each PI under a DLC.
#
########################################################################
sub get_dlc_pi2wa_code
{
    my ($wh_lda, $rdlc_mit_id2wa_code) = @_;

    %$rdlc_mit_id2wa_code = ();   # Clear the hash

#
#  Open cursor
#
    my $stmt = "select distinct wa.dlc_code, pi_mit_id, 
          substr(wa.pi_work_area_id, 13, 8)
      from wareuser.whehsta_pi_work_area wa
      where wa.work_area_type = 'PI'
      and substr(wa.dlc_code, 1, 2) = 'D_'
      and wa.work_area_status_code = 'AC'
      and nvl(wa.pi_mit_id, ' ') <> ' '
      order by 1, 2";

    my $wh_csr = $wh_lda->prepare($stmt)
        || die $DBI::errstr;
    $wh_csr->execute();

    print "Reading in DLC/PI work area records from Warehouse table...\n";
    my $i = -1;
    my ($dlc_code, $pi_mit_id, $wa_code);
    while ( ($dlc_code, $pi_mit_id, $wa_code) = $wh_csr->fetchrow_array() )
    {
	$$rdlc_mit_id2wa_code{"$dlc_code$pi_mit_id"} = "PI_$wa_code";
    }

   $wh_csr->finish() || die "can't close cursor";
    
}

##############################################################################
#
#  Subroutine CompareExtract($data_dir)
#
#  Find the differences in two files of new Org Units.
#  Process the differences to make it easier to do adds, deletes, and
#  updates to qualifier table in Roles DB.
#
##############################################################################
sub CompareExtract
{

    my($data_dir) = @_;

    my $file1 = $data_dir . "extauth.roles";
    my $file2 = $data_dir . "extauth.warehouse";
    my $diff_file = $data_dir . "extauth.diffs";
    my $actionsfile = $data_dir . "extauth.actions";
    my $temp1 = $data_dir . "extauth1.temp";
    my $temp2 = $data_dir . "extauth2.temp";
    
#For Linux, sort command, this env setting will make the sorting based on ASCII instead of Dictionary.
$ENV{'LANG'}='C';
$ENV{'LC-COLLATE'}='C';

    print "Sorting first file...\n";
    system("sort -o $temp1 $file1\n");
    print "Sorting 2nd file...\n";
    system("sort -u -o $temp2 $file2\n");
    
    
    print "Comparing files $file1 and $file2...\n";
    system("diff $temp1 $temp2 |"            # Find differences in two files
	   . " grep '^[><]' |"               # Select only added/deleted lines
	   . " sed 's/< /<\!/' |"    # Add ! field marker
	   . " sed 's/> />\!/' |"    # Add ! field marker
	   . " sort -t '!' -k 2,3 -k 1,1"    # Sort on kerbname, func, qual, [<>]
	   . " > $diff_file");
    
##############################################################################
#
#  Now read in the differences file and generate ADD and DELETE
#  records.
# 
#  Read '<' records from $diff_file into (@old_code, @old_parent, @old_name)
#  Read '>' records from $diff_file into (@new_code, @new_parent, @new_name)
#
##############################################################################
#
#   Open output file.
#
    $outf = "|cat >" . $actionsfile;
    if( !open(F2, $outf) ) {
	die "$0: can't open ($outf) - $!\n";
    }

#
#  Open the input differences file and read each record.
#
    unless (open(IN,$diff_file)) {
	die "Cannot open $diff_file for reading\n"
	}
    $i = 0;
    print "Reading records from differences file...\n";
    while (chop($line = <IN>)) {
	if (($i++)%1000 == 0) {print $i . "\n";}
	my ($oldnew, $kerb, $func, $qualcode) = split('!', $line);
	if ($oldnew eq '<') {
	    print F2 "DELETE!$kerb!$func!$qualcode\n";
	}
	else {
	    print F2 "ADD!$kerb!$func!$qualcode\n";
	}
    }
    #system("rm $temp1\n");  # Remove temporary files
    #system("rm $temp2\n");  # Remove temporary files
    
    
    close (F2);

}

###############################################################################
sub ProcessAuthActions
###############################################################################
{ 

    my($lda, $infile, $sqlfile) = @_;

    if (not $lda)      ## If we logged in ok
{	
    &RolesLog("FATAL_MSG",
	      "Not Logged into source database");
}

#
#  Go get hashes mapping function_name into function_category, function_id, 
#    and qualifier_type for each function_name in external_function table.
#  Also get hashes mapping "$qualifier_type!$qualifier_code" into 
#    qualifier_id and qualifier_name for each qualifier_type related to
#    functions in the table EXTERNAL_FUNCTION.
#
my %funcname2category = (); 
my %funcname2id = (); 
my %funcname2qualtype = (); 
my %qualtype_and_code2id = ();
my %qualtype_and_code2name = ();
&get_func_and_qual_hashes($lda, \%funcname2category, \%funcname2id,
			  \%funcname2qualtype, \%qualtype_and_code2id, \%qualtype_and_code2name);

#
#   Open output files.
#
$outf3 = ">" . $sqlfile;
if( !open(F3, $outf3) ) {
    die "$0: can't open ($outf3) - $!\n";
}
chop($today = `date`);
print F3 "/* Updates generated " . $today . " */\n";
#print F3 "set define off;\n";
#print F3 "whenever sqlerror exit -1 rollback;\n";  # Halt on errors.

#
#  Read the input file.  Generate INSERT and DELETE records.
#  
unless (open(IN,$infile)) {
    die "Cannot open $infile for reading\n"
    }
$i = 0;
print "Reading in the file $infile...\n";
while ( (chop($line = <IN>)) && ($i++ < 999999) ) {
    #print "$i $line\n";
    my ($action, $kerbname, $funcname, $qualcode) 
	= split("!", $line);   # Split into 4 fields
    if ($action eq 'ADD') {
	my $func_id = $funcname2id{$funcname};
	my $func_cat = $funcname2category{$funcname};
	my $qualtype = $funcname2qualtype{$funcname};
	my $qual_id = $qualtype_and_code2id{"$qualtype$g_delim$qualcode"};
	my $qualname = $qualtype_and_code2name{"$qualtype$g_delim$qualcode"};
	$qualname =~ s/'/''/g;  # Handle quotes within a SQL insert statement
      if ($func_id && $qual_id) {  # Make sure we have valid function and qual
        print F3 "insert into external_auth"
            . " ( FUNCTION_ID, QUALIFIER_ID, KERBEROS_NAME,"
            . " QUALIFIER_CODE, FUNCTION_NAME, FUNCTION_CATEGORY,"
            . " QUALIFIER_NAME, MODIFIED_BY, MODIFIED_DATE, DO_FUNCTION," 
            . " GRANT_AND_VIEW, DESCEND, EFFECTIVE_DATE, EXPIRATION_DATE)"
            . " values( "
            . " $func_id, $qual_id, '$kerbname',"
            . " '$qualcode', '$funcname', '$func_cat', "
            . " '$qualname', 'SYSTEM', NOW(), 'Y',"
            . " 'N', 'Y', NOW(), null);\n"; 
      }
      else {
        print "**Warning.  Missing function_id or qualifier_id for"
              . " function '$funcname' and qualcode '$qualcode'\n";
      }
   }
   elsif ($action eq 'DELETE') {
     print F3 "delete from external_auth"
              . " where kerberos_name = '$kerbname'"
              . " and function_name = '$funcname'"
              . " and qualifier_code = '$qualcode';\n";
   }
   else {
       print "Unrecognizable action type: '$action'\n";
   }
 }

 #print F3 "commit;\n";  # If no errors, commit work.
 #print F3 "quit;\n";    # Exit from SQLPLUS

 close(IN);
 close(F3);
 
}  ## End of Process Actions

#######################################################################
# Subroutine fetch_and_write_iar.
#######################################################################

sub fetch_and_write_iar {
    my ($cursor, $fh) = @_ ;
    my $i=0;
    while ( ($xkerbname, $xfunction, $xqualifier) = $cursor->fetchrow_array() )
{
    if (($i++)%1000 == 0) {print $i ."Implied Rules Block". "\n";}
    if ($xkerbname) {
	$temp_qual_code = $xqualifier;
	#print "$xkerbname$g_delim$xfunction$g_delim$temp_qual_code\n";
	print $fh "$xkerbname$g_delim$xfunction$g_delim$temp_qual_code\n";
    }
    
}
}
########################################################################
#
#  Subroutine &get_func_and_qual_hashes($lda, \%funcname2category, 
#      \%funcname2id, \%funcname2qualtype, \%qualtype_and_code2id, 
#      \%qualtype_and_code2name);
#
#  Go get hashes mapping function_name into function_category, function_id, 
#    and qualifier_type for each function_name in external_function table.
#  Also get hashes mapping "$qualifier_type!$qualifier_code" into 
#    qualifier_id and qualifier_name for each qualifier_type related to
#    functions in the table EXTERNAL_FUNCTION.
#
########################################################################
sub get_func_and_qual_hashes
{
    my($roles_lda, $rfuncname2category, 
       $rfuncname2id, $rfuncname2qualtype, $rqualtype_and_code2id, 
       $rqualtype_and_code2name) = @_;

    %$rfuncname2category = ();       # Clear the hash
    %$rfuncname2id = ();             # Clear the hash
    %$rfuncname2qualtype = ();       # Clear the hash
    %$rqualtype_and_code2id = ();    # Clear the hash
    %$rqualtype_and_code2name = ();  # Clear the hash

#
#  Open first cursor
#
    my $stmt = "select function_name, function_category, function_id, 
              qualifier_type 
             from external_function
             order by function_name";
    my $roles_csr = $roles_lda->prepare($stmt)
        || die $DBI::errstr;
 $roles_csr->execute()
        || die $DBI::errstr;

    print "Reading in records from the Roles external_function table...\n";
    my $i = -1;
    my ($funcname, $funccat, $func_id, $qualtype);
    while ( ($funcname, $funccat, $func_id, $qualtype) = $roles_csr->fetchrow_array() )
    {
	#if (($i++)%5000 == 0) {print $i . "\n";}
	$$rfuncname2category{$funcname} = $funccat;
	$$rfuncname2id{$funcname} = $func_id;
	$$rfuncname2qualtype{$funcname} = $qualtype;
    }

    $roles_csr->finish() || die "can't close cursor";
    
#
#  Open 2nd cursor
#
    my $stmt2 = "select qualifier_type, qualifier_code, qualifier_id, 
                     qualifier_name 
              from qualifier
              where qualifier_type in 
                (select distinct qualifier_type from external_function)
              order by qualifier_type,qualifier_code";

    my $roles_csr = $roles_lda->prepare($stmt2)
        || die $DBI::errstr;
    $roles_csr->execute()
        || die $DBI::errstr; 


    print "Reading in records from the Roles qualifier table...\n";
    $i = -1;
    my ($qualcode, $qualid, $qualname);
    while ( ($qualtype, $qualcode, $qualid, $qualname) = $roles_csr->fetchrow_array() )
    {
	#if (($i++)%5000 == 0) {print $i . "\n";}
	$$rqualtype_and_code2id{"$qualtype$g_delim$qualcode"} = $qualid;
	$$rqualtype_and_code2name{"$qualtype$g_delim$qualcode"} = $qualname;
    }

    $roles_csr->finish() || die "can't close cursor";
    
}

return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################
