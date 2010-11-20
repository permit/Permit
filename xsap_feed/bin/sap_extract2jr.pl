#!/usr/bin/perl -I/usr/users/rolesdb/lib/cpa
########################################################################
#
#  Extract and expand authorizations from the Authorization table
#  for SAP-related authorizations.
#
#  Create a flat file of the following format:
#    function_id | numeric part of qualifier | qual_type* |username   
#
#    *qual_type = BU, FC, FN, PC, IO, WB, CC, OU, DL, or TG
#  
#
#  Copyright (C) 1998-2010 Massachusetts Institute of Technology
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
#  Modified J. Repa, 8/31/98.  Change SYSDATE to SYSDATE+1 (generate
#                              tomorrow's auths today)
#  Modified J. Repa, 11/04/98. Use a sequence number rather than 
#                              date in filename.
#  Modified J. Repa, 11/10/98. Filter out users without CAN USE SAP auth
#  Modified J. Repa, 01/12/01. Performance change in part #3 of multi-part
#                              query.
#  Modified J. Repa, 12/30/02. Changes made to conserve memory
#  Modified J. Repa, 1/9/03.   No longer use CAN USE SAP.
#  Modified J. Repa, 7/21/03.  Add HR authorizations.
#  Modified J. Repa, 2/4/04.   Add another HR authorization.
#  Modified G. Petrowsky, 2/24/04.   Add another HR authorization.
#  Modified G. Petrowsky, 4/12/04.   Added 7 more HR authorizations.
#  Modified G. Petrowsky, 4/13/04.   Added category HR-C
#                                    and rest of HR-C functions
#  Modified G. Petrowsky, 4/14/04.   Chg'd HR-C to HR_C 
#  Modified G. Petrowsky, 4/21/04.   Added DISPLAY FACULTY CHAIR DATA
#  Modified J. Repa      11/03/04.   Added 2 EHS FUNCTIONS / ROLES   
#  Modified G. Petrowsky,11/03/04.   Added 3 ASR FUNCTIONS / ROLES   
#  Modified G. Petrowsky,11/23/04.   Added Z_HRASR_HRO role  
#  Modified G. Petrowsky,07/22/05.   Added EHS Inspection functions  
#  Modified J. Repa,     09/13/05.   Add PAYR functions
#  Modified G. Petrowsky 03/30/06.   Add PAYR functions
#  Modified G. Petrowsky 04/24/06.   Add PAYR functions
#  Modified J. Repa, Use (3nnnnnnn) string from PYTG qualifier_name instead
#                    of qualifier_code
#  Modified J. Repa 6/8/2006. Enable special handling for root PYTG qual
#  Modified J. Repa, 6/14/2006.  Change SYSDATE+1 back to SYSDATE (generate
#                              today's auths, not tomorrow's - we run the feeds
#                              in the morning, not the evening)
#  Modified G. Petrowsky 06/26/06.   Add PAYR, HR_C functions
#  Modified J. Repa, 7/3/2006.  Remove the old code to bypass people
#                               without certain SAP authorizations.
#  Modified 07/11/2006 Added two PAYR functions with PMIT qualifiers.
#                                  
########################################################################
#
# Get packages
#
use config('GetValue');  # Use the subroutine GetValue in ~/lib/cpa/config.pm
use sap_feed('GetSequence');  # Use the subroutine GetSequence in sap_feed.pm

#
# Set some variables and constants
#
#$datadir = $ENV{"ROLES_HOMEDIR"} . "/sap_feed/data/";
$datadir = $ENV{"ROLES_HOMEDIR"} . "/xsap_feed/data/";
$seqno = &GetSequence();
print "Sequence number is $seqno\n";
$outfile = $datadir . "sap1.out." . $seqno;
$tempfile = $datadir . "temp1.out." . $seqno;
$function_category = 'SAP';
$function_category2 = 'LABD';
$function_category3 = 'HR';
$function_category4 = 'ADMN';
$function_category5 = 'HR_C';
$function_category6 = 'EHS';
$function_category7 = 'PAYR';
$time0 = time();  # Keep track of time for various steps
$db_name = 'roles';
$db_parm = 'roles';

#
# Get packages
#
use config('GetValue');  # Use the subroutine GetValue in ~/lib/cpa/config.pm

#
#   Open output file.
#
 $| = 1; #Force Ouput Buffer to Flush on each write
 $outf = ">" . $outfile;
 if( !open(F2, $outf) ) {
   die "$0: can't open ($outf) - $!\n";
 }

#
#  Get username and password for database connection.
#
 $temp = &GetValue($db_parm);
 $temp =~ m/^(.*)\/(.*)\@(.*)$/;
 $user  = $1;
 $pw = $2;
 $db = $3; 
 $db = 'roles';

#
#  Make sure we are set up to use Oraperl.
#
 use Oraperl;
 if (!(defined(&ora_login))) {
   die "Oraperl routine \&ora_login not found.  Missing library?\n";
 }
 
#
#  Open connection to oracle
#
 print "db='$db' user='$user'\n";
 $lda = &ora_login($db, $user, $pw)
        || die "ora_login failed. $ora_errstr\n";

#
#  Get function information from the Roles DB FUNCTION table.
#
%fid_to_name = (); # Hash for function_id => function_name
%fname_to_id = (); # Hash for function_name => function_id
print "Getting function information...\n";
&get_function_info($lda, $function_category, \%fid_to_name, \%fname_to_id);
&get_function_info($lda, $function_category2, \%fid_to_name, \%fname_to_id);
&get_function_info($lda, $function_category3, \%fid_to_name, \%fname_to_id);
&get_function_info($lda, $function_category4, \%fid_to_name, \%fname_to_id);
&get_function_info($lda, $function_category5, \%fid_to_name, \%fname_to_id);
&get_function_info($lda, $function_category6, \%fid_to_name, \%fname_to_id);
&get_function_info($lda, $function_category7, \%fid_to_name, \%fname_to_id);
$elapsed_sec = time() - $time0;
print "Elapsed time = $elapsed_sec seconds.\n";

#
# Set Function_id numbers for the functions we'll need.
#
$use_sap_func_id = $fname_to_id{'CAN USE SAP'};
$sel_func_id1  = $fname_to_id{'CAN SPEND OR COMMIT FUNDS'};
$sel_func_id2  = $fname_to_id{'REPORT BY CO/PC'};
$sel_func_id3  = $fname_to_id{'REPORT BY FUND/FC'};
$sel_func_id4  = $fname_to_id{'ENTER BUDGETS'};
$sel_func_id5  = $fname_to_id{'LDS A: MAINT APPT, PROC VAR'};
$sel_func_id6  = $fname_to_id{'LDS E: DISPLAY APPOINTMENTS'};
$sel_func_id7  = $fname_to_id{'MAINT EMPL. ETHNIC & MILITARY'};
$sel_func_id8  = $fname_to_id{'MAINT EMPL. EDUCATION DATA'};
$sel_func_id9  = $fname_to_id{'MAINT EMPL. EMERG. CONTACT'};
$sel_func_id10 = $fname_to_id{'TEL DIR CONTACT - PRIMARY'};
$sel_func_id11 = $fname_to_id{'TEL DIR CONTACT- ALTERNATE'};
$sel_func_id12 = $fname_to_id{'MAINT FACULTY CHAIR DATA'};
$sel_func_id13 = $fname_to_id{'MAINT EMPL. TELEPHONE DIR.'};
$sel_func_id14 = $fname_to_id{'DISPLAY APPT DATA-HR EMPL.'};
$sel_func_id15 = $fname_to_id{'DISPLAY APPT DATA-LINCOLN LAB'};
$sel_func_id16 = $fname_to_id{'DISPLAY APPT DATA-NO HR EMPL.'};
$sel_func_id17 = $fname_to_id{'DISPLAY ORG MANAGEMENT DATA'};
$sel_func_id18 = $fname_to_id{'DISPLAY PERSON DATA-LMTD'};
$sel_func_id19 = $fname_to_id{'MAINT ALL ORG MGT DATA'};
$sel_func_id20 = $fname_to_id{'MAINT POSITIONS'};
$sel_func_id21 = $fname_to_id{'BENEFITS-MAINT SUBSCRIBERS'};
$sel_func_id22 = $fname_to_id{'MAINT EMPL DATA-CONFIDENT. EMP'};
$sel_func_id23 = $fname_to_id{'MAINT EMPL DATA-HR EMPL.'};
$sel_func_id24 = $fname_to_id{'MAINT EMPL DATA-NO HR EMPL.'};
$sel_func_id25 = $fname_to_id{'DISPLAY FACULTY CHAIR DATA'};
$sel_func_id26 = $fname_to_id{'MAINTAIN ROOM SET INFO'};
$sel_func_id27 = $fname_to_id{'VIEW ROOM SET INFO'};
$sel_func_id28 = $fname_to_id{'ASR - SCHOOL/AREA LEVEL'};
$sel_func_id29 = $fname_to_id{'ASR - DEPARTMENT LEVEL'};
$sel_func_id30 = $fname_to_id{'ASR - COMP OFFICE'};
$sel_func_id31 = $fname_to_id{'ASR - HUMAN RESOURCE OFFICER'};
$sel_func_id32 = $fname_to_id{'MAINTAIN INSPECTION DATA'};
$sel_func_id33 = $fname_to_id{'VIEW INSPECTION DATA BY DLC'};
$sel_func_id34 = $fname_to_id{'TIMESHEET ADMINISTRATOR'};
$sel_func_id35 = $fname_to_id{'TIMESHEET APPROVER'};
$sel_func_id36 = $fname_to_id{'TIMESHEET DISTRIBUTION ENTRY'};
$sel_func_id37 = $fname_to_id{'EDACCA CERTIFIER'};
$sel_func_id38 = $fname_to_id{'EDACCA CERTIFIER-PERCENT ONLY'};
$sel_func_id39 = $fname_to_id{'EDACCA ADMINISTRATOR'};
$sel_func_id40 = $fname_to_id{'EDACCA ADMIN-PERCENT ONLY'};
$sel_func_id41 = $fname_to_id{'DISPLAY APPT DATA-NO HR,CAO'};
$sel_func_id42 = $fname_to_id{'DISPLAY APPT DATA-CAO EMPL.'};
$sel_func_id43 = $fname_to_id{'DISPLAY PERSON DATA-LMTD-LL'};
$sel_func_id44 = $fname_to_id{'MAINT EMPL DATA-CAO EMPL.'};
$sel_func_id45 = $fname_to_id{'MAINT EMPL DATA-NO HR, CAO'};
$sel_func_id46 = $fname_to_id{'MAINT DEDUCTIONS'};
$sel_func_id47 = $fname_to_id{'MAINT GARNISHMENTS'};
$sel_func_id48 = $fname_to_id{'MAINT TAX INFOTYPES'};
$sel_func_id49 = $fname_to_id{'PROCESS PAYROLL FEEDS'};
$sel_func_id50 = $fname_to_id{'PROCESS PAYROLL'};
$sel_func_id51 = $fname_to_id{'PROCESS OFF-CYCLE PAYROLLS'};
$sel_func_id52 = $fname_to_id{'PROCESS PAYROLL POSTINGS'};
$sel_func_id53 = $fname_to_id{'DISPLAY PAYROLL POSTING SUMARY'};
$sel_func_id54 = $fname_to_id{'EDACCA CENTRAL USER-SEE SALARY'};
$sel_func_id55 = $fname_to_id{'DISPLAY PAY STUBS'};
$sel_func_id56 = $fname_to_id{'ESDS CENTRAL USER-SEE SALARY'};
$sel_func_id57 = $fname_to_id{'TIMESHEET SUPER-CENTRAL'};
$sel_func_id58 = $fname_to_id{'MAINT TIME GROUPS'};
$sel_func_id59 = $fname_to_id{'MAINT BENEFIT DEDUCTIONS'};
$sel_func_id60 = $fname_to_id{'PROCESS SIMULATED PAYR-CAMPUS'};
$sel_func_id61 = $fname_to_id{'PROCESS SIMULATED PAYR-LL'};
$sel_func_id62 = $fname_to_id{'DISPLAY PAY STUBS-LL'};
$sel_func_id63 = $fname_to_id{'TIMESHEET ADMINISTR-CENTRAL'};
$sel_func_id64 = $fname_to_id{'MAINT EMPL DATA-LL'};
$sel_func_id65 = $fname_to_id{'DISPLAY PAYROLL CHECK REGISTER'};
$sel_func_id66 = $fname_to_id{'DISPLAY SAVINGS PLANS-CAMPUS'};
$sel_func_id67 = $fname_to_id{'DISPLAY SAVINGS PLANS-LINCOLN'};
$sel_func_id68 = $fname_to_id{'MAINT IT0035-LEAVE CODES'};
$sel_func_id69 = $fname_to_id{'ESDS DISTR MAINT-NO SALARY'};
$sel_func_id70 = $fname_to_id{'ESDS DISTR MAINT-SEE SALARY'};
$sel_func_id71 = $fname_to_id{'ESDS TRSFR-IN DISTR-NO SALARY'};
$sel_func_id72 = $fname_to_id{'ESDS TRSFR-IN DISTR-SEE SALARY'};

if ($sel_func_id1  eq '' || $sel_func_id2  eq '' || $sel_func_id3  eq ''
 || $sel_func_id4  eq '' || $sel_func_id5  eq '' || $sel_func_id6  eq ''
 || $sel_func_id7  eq '' || $sel_func_id8  eq '' || $sel_func_id9  eq ''
 || $sel_func_id10 eq '' || $sel_func_id11 eq '' || $sel_func_id12 eq ''
 || $sel_func_id13 eq '' || $sel_func_id14 eq '' || $sel_func_id15 eq ''
 || $sel_func_id16 eq '' || $sel_func_id17 eq '' || $sel_func_id18 eq ''
 || $sel_func_id19 eq '' || $sel_func_id20 eq '' || $sel_func_id21 eq ''
 || $sel_func_id22 eq '' || $sel_func_id23 eq '' || $sel_func_id24 eq ''
 || $sel_func_id25 eq '' || $sel_func_id26 eq '' || $sel_func_id27 eq ''
 || $sel_func_id28 eq '' || $sel_func_id29 eq '' || $sel_func_id30 eq ''
 || $sel_func_id31 eq '' || $sel_func_id32 eq '' || $sel_func_id33 eq ''
 || $sel_func_id34 eq '' || $sel_func_id35 eq '' || $sel_func_id36 eq ''
 || $sel_func_id37 eq '' || $sel_func_id38 eq '' || $sel_func_id39 eq ''
 || $sel_func_id40 eq '' || $sel_func_id41 eq '' || $sel_func_id42 eq ''
 || $sel_func_id43 eq '' || $sel_func_id44 eq '' || $sel_func_id45 eq ''
 || $sel_func_id46 eq '' || $sel_func_id47 eq '' || $sel_func_id48 eq ''
 || $sel_func_id49 eq '' || $sel_func_id50 eq '' || $sel_func_id51 eq ''
 || $sel_func_id52 eq '' || $sel_func_id53 eq '' || $sel_func_id54 eq ''
 || $sel_func_id55 eq '' || $sel_func_id56 eq '' || $sel_func_id57 eq ''
 || $sel_func_id58 eq '' || $sel_func_id59 eq '' || $sel_func_id60 eq ''
 || $sel_func_id61 eq '' || $sel_func_id62 eq '' || $sel_func_id63 eq ''
 || $sel_func_id64 eq '' || $sel_func_id65 eq '' || $sel_func_id66 eq ''
 || $sel_func_id67 eq '' || $sel_func_id68 eq '' || $sel_func_id69 eq '' 
 || $sel_func_id70 eq '' || $sel_func_id71 eq '' || $sel_func_id72 eq '') 
{
  print "Error.  One of the function names was not found.\n";
  if ($sel_func_id1 eq '') {
    print "CAN SPEND OR COMMIT FUNDS not found in Function table\n";
  }
  if ($sel_func_id2 eq '') {
    print "REPORT BY CO/PC not found in Function table\n";
  }
  if ($sel_func_id3 eq '') {
    print "REPORT BY FUND/FC not found in Function table\n";
  }
  if ($sel_func_id4 eq '') {
    print "ENTER BUDGETS not found in Function table\n";
  }
  if ($sel_func_id5 eq '') {
    print "LDS A: MAINT APPT, PROC VAR not found in Function table\n";
  }
  if ($sel_func_id6 eq '') {
    print "LDS E: DISPLAY APPOINTMENTS not found in Function table\n";
  }
  if ($sel_func_id7 eq '') {
    print "MAINT EMPL. ETHNIC & MILITARY not found in Function table\n";
  }
  if ($sel_func_id8 eq '') {
    print "MAINT EMPL. EDUCATION DATA not found in Function table\n";
  }
  if ($sel_func_id9 eq '') {
    print "MAINT EMPL. EMERG. CONTACT not found in Function table\n";
  }
  if ($sel_func_id10 eq '') {
    print "TEL DIR CONTACT - PRIMARY not found in Function table\n";
  }
  if ($sel_func_id11 eq '') {
    print "TEL DIR CONTACT- ALTERNATE not found in Function table\n";
  }
  if ($sel_func_id12 eq '') {
    print "MAINT FACULTY CHAIR DATA not found in Function table\n";
  }
  if ($sel_func_id13 eq '') {
    print "MAINT EMPL. TELEPHONE DIR. not found in Function table\n";
  }
  if ($sel_func_id14 eq '') {
    print "DISPLAY APPT DATA-HR EMPL. not found in Function table\n";
  }
  if ($sel_func_id15 eq '') {
    print "DISPLAY APPT DATA-LINCOLN LAB not found in Function table\n";
  }
  if ($sel_func_id16 eq '') {
    print "DISPLAY APPT DATA-NO HR EMPL. not found in Function table\n";
  }
  if ($sel_func_id17 eq '') {
    print "DISPLAY ORG MANAGEMENT DATA not found in Function table\n";
  }
  if ($sel_func_id18 eq '') {
    print "DISPLAY PERSON DATA-LMTD not found in Function table\n";
  }
  if ($sel_func_id19 eq '') {
    print "MAINT ALL ORG MGT DATA not found in Function table\n";
  }
  if ($sel_func_id20 eq '') {
    print "MAINT POSITIONS not found in Function table\n";
  }
  if ($sel_func_id21 eq '') {
    print "BENEFITS-MAINT SUBSCRIBERS not found in Function table\n";
  }
  if ($sel_func_id22 eq '') {
    print "MAINT EMPL DATA-CONFIDENT. EMP not found in Function table\n";
  }
  if ($sel_func_id23 eq '') {
    print "MAINT EMPL DATA-HR EMPL. not found in Function table\n";
  }
  if ($sel_func_id24 eq '') {
    print "MAINT EMPL DATA-NO HR EMPL. not found in Function table\n";
  }
  if ($sel_func_id25 eq '') {
    print "DISPLAY FACULTY CHAIR DATA  not found in Function table\n";
  }
  if ($sel_func_id26 eq '') {
    print "MAINTAIN ROOM SET INFO not found in Function table\n";
  }
  if ($sel_func_id27 eq '') {
    print "VIEW ROOM SET INFO not found in Function table\n";
  }
  if ($sel_func_id28 eq '') {
    print "ASR - SCHOOL/AREA LEVEL not found in Function table\n";
  }
  if ($sel_func_id29 eq '') {
    print "ASR - DEPARTMENT LEVEL not found in Function table\n";
  }
  if ($sel_func_id30 eq '') {
    print "ASR - COMP OFFICE not found in Function table\n";
  }
  if ($sel_func_id31 eq '') {
    print "ASR - HUMAN RESOURCE OFFICER not found in Function table\n";
  }
  if ($sel_func_id32 eq '') {
    print "MAINTAIN INSPECTION DATA not found in Function table\n";
  }
  if ($sel_func_id33 eq '') {
    print "VIEW INSPECTION DATA BY DLC not found in Function table\n";
  }
  if ($sel_func_id34 eq '') {
    print "TIMESHEET ADMINISTRATOR not found in Function table\n";
  }
  if ($sel_func_id35 eq '') {
    print "TIMESHEET APPROVER not found in Function table\n";
  }
  if ($sel_func_id36 eq '') {
    print "TIMESHEET DISTRIBUTION ENTRY not found in Function table\n";
  }
  if ($sel_func_id37 eq '') {
    print "EDACCA CERTIFIER ENTRY not found in Function table\n";
  }
  if ($sel_func_id38 eq '') {
    print "EDACCA CERTIFIER-PERCENT ONLY not found in Function table\n";
  }
  if ($sel_func_id39 eq '') {
    print "EDACCA ADMINISTRATOR not found in Function table\n";
  }
  if ($sel_func_id40 eq '') {
    print "EDACCA ADMIN-PERCENT ONLY not found in Function table\n";
  }
  if ($sel_func_id41 eq '') {
    print "DISPLAY APPT DATA-NO HR,CAO not found in Function table\n";
  }
  if ($sel_func_id42 eq '') {
    print "DISPLAY APPT DATA-CAO EMPL. not found in Function table\n";
  }
  if ($sel_func_id43 eq '') {
    print "DISPLAY PERSON DATA-LMTD-LL not found in Function table\n";
  }
  if ($sel_func_id44 eq '') {
    print "MAINT EMPL DATA-CAO EMPL. not found in Function table\n";
  }
  if ($sel_func_id45 eq '') {
    print "MAINT EMPL DATA-NO HR, CAO not found in Function table\n";
  }
  if ($sel_func_id46 eq '') {
    print "MAINT DEDUCTIONS not found in Function table\n";
  }
  if ($sel_func_id47 eq '') {
    print "MAINT GARNISHMENTS not found in Function table\n";
  }
  if ($sel_func_id48 eq '') {
    print "MAINT TAX INFOTYPES not found in Function table\n";
  }
  if ($sel_func_id49 eq '') {
    print "PROCESS PAYROLL FEEDS not found in Function table\n";
  }
  if ($sel_func_id50 eq '') {
    print "PROCESS PAYROLL not found in Function table\n";
  }
  if ($sel_func_id51 eq '') {
    print "PROCESS OFF-CYCLE PAYROLLS not found in Function table\n";
  }
  if ($sel_func_id52 eq '') {
    print "PROCESS PAYROLL POSTINGS not found in Function table\n";
  }
  if ($sel_func_id53 eq '') {
    print "DISPLAY PAYROLL POSTING SUMARY not found in Function table\n";
  }
  if ($sel_func_id54 eq '') {
    print "EDACCA CENTRAL USER-SEE SALARY not found in Function table\n";
  }
  if ($sel_func_id55 eq '') {
    print "DISPLAY PAY STUBS not found in Function table\n";
  }
  if ($sel_func_id56 eq '') {
    print "ESDS CENTRAL USER-SEE SALARY not found in Function table\n";
  }
  if ($sel_func_id57 eq '') {
    print "TIMESHEET SUPER-CENTRAL not found in Function table\n";
  }
  if ($sel_func_id58 eq '') {
    print "MAINT TIME GROUPS not found in Function table\n";
  }
  if ($sel_func_id59 eq '') {
    print "DISPLAY PERSON DATA-LMTD-LL not found in Function table\n";
  }
  if ($sel_func_id59 eq '') {
    print "MAINT BENEFIT DEDUCTIONS not found in Function table\n";
  }
  if ($sel_func_id60 eq '') {
    print "PROCESS SIMULATED PAYR-CAMPUS not found in Function table\n";
  }
  if ($sel_func_id61 eq '') {
    print "PROCESS SIMULATED PAYR-LL not found in Function table\n";
  }
  if ($sel_func_id62 eq '') {
    print "DISPLAY PAY STUBS-LL not found in Function table\n";
  }
  if ($sel_func_id63 eq '') {
    print "TIMESHEET ADMINISTR-CENTRAL not found in Function table\n";
  }
  if ($sel_func_id64 eq '') {
    print "MAINT EMPL DATA-LL not found in Function table\n";
  }
  if ($sel_func_id65 eq '') {
    print "DISPLAY PAYROLL CHECK REGISTER not found in Function table\n";
  }
  if ($sel_func_id66 eq '') {
    print "DISPLAY SAVINGS PLANS-CAMPUS not found in Function table\n";
  }
  if ($sel_func_id67 eq '') {
    print "DISPLAY SAVINGS PLANS-LINCOLN not found in Function table\n";
  }
  if ($sel_func_id68 eq '') {
    print "MAINT IT0035-LEAVE CODES not found in Function table\n";
  }
  if ($sel_func_id69 eq '') {
    print "ESDS DISTR MAINT-NO SALARY not found in Function table\n";
  }
  if ($sel_func_id70 eq '') {
    print "ESDS DISTR MAINT-SEE SALARY not found in Function table\n";
  }
  if ($sel_func_id71 eq '') {
    print "ESDS TRSFR-IN DISTR-NO SALARY not found in Function table\n";
  }
  if ($sel_func_id72 eq '') {
    print "ESDS TRSFR-IN DISTR-SEE SALARY not found in Function table\n";
  }
  exit(10);
} 

#
#  *** The following section was removed 7/3/2006. ***
#
#  Get a list of users who have category SAP authorizations but do not
#  have either an explicit 'CAN USE SAP' authorization or an implied
#  'CAN USE SAP' authorization.  An implied 'CAN USE SAP' authorization 
#  exists if the person has any category SAP authorizations except 
#  'INVOICE APPROVAL UNLIMITED', 'TRAVEL DOCUMENTS APPROVAL', 
#  'MAINTAIN ALL NOTIFY PREFS', or 'MAINTAIN NOTIFY PREFS FOR DEPT'.
#  They will be excluded from the authorizations processed below.
#
 #@stmt = ("select distinct kerberos_name from authorization"
 #         . " where function_category = 'SAP'"
 #         . " minus"
 #         . " select kerberos_name from authorization"
 #         . " where function_id = $use_sap_func_id"
 #         . " and do_function = 'Y'"
 #         . " and sysdate between effective_date and"
 #         . " nvl(expiration_date,sysdate)"
 #         . " minus"
 #         . " select distinct kerberos_name"
 #         . " from authorization a, function f"
 #         . " where f.function_id = a.function_id"
 #         . " and f.function_category = 'SAP'"
 #         . " and f.function_name not in ('INVOICE APPROVAL UNLIMITED', "
 #         . "    'TRAVEL DOCUMENTS APPROVAL', 'MAINTAIN ALL NOTIFY PREFS',"
 #         . "    'MAINTAIN NOTIFY PREFS FOR DEPT')"
 #         . " and a.do_function = 'Y'"
 #         . " and sysdate between a.effective_date and"
 #         . " nvl(a.expiration_date,sysdate)");
 #$csr = &ora_open($lda, "@stmt")
 #       || die "ora_open failed. $ora_errstr\n";
 #print "Looking for people without an explicit or implicit"
 #      . " CAN USE SAP authorization...\n";
 #%user_no_sap = ();
 #$n = 0;
 #while ( ($akerbname) = &ora_fetch($csr) )
 #{
 #  $n++;
 #  $user_no_sap{$akerbname} = 1;
 #}
 #do ora_close($csr) || die "can't close cursor";
 #$elapsed_sec = time() - $time0;
 #print "Elapsed time = $elapsed_sec seconds.\n";
 #print "$n users found with SAP authorizations but no"
 #      . " explicit or implied 'CAN USE SAP' auth.\n";
 #foreach $usr (sort keys %user_no_sap) {
 #  print "$usr ";
 #}
 #print "\n";
 #### The following line makes sure there are no people in %user_no_sap hash.
 %user_no_sap = ();

#
#  Get the top-level (root) record from the Qualifier table for FUND 
#  and COST qualifiers.  We'll use these to identify people who are 
#  authorized for any Cost Collector or any Fund Center, which will
#  be handled as a special case.
#
 @stmt = ("select qualifier_id, qualifier_type from qualifier"
          . " where qualifier_level = 1"
          . " and qualifier_type in "
          . " ('FUND', 'COST', 'BUDG', 'LORG', 'ORG2', 'DEPT','PYTG',"
          . "  'PCCS', 'PMIT')");
 $csr = &ora_open($lda, "@stmt")
        || die "ora_open failed. $ora_errstr\n";
 print "Looking for root-level Qualifiers in Oracle table...\n";
 $i = -1;
 while ( ($qqid, $qqtype) = &ora_fetch($csr) )
 {
   if ($qqtype eq 'FUND') {
     $top_fund_id = $qqid;
   }
   elsif ($qqtype eq 'COST') {
     $top_cost_id = $qqid;
   } 
   elsif ($qqtype eq 'BUDG') {
     $top_budg_id = $qqid;
   } 
   elsif ($qqtype eq 'LORG') {
     $top_lorg_id = $qqid;
   } 
   elsif ($qqtype eq 'ORG2') {
     $top_org2_id = $qqid;
   } 
   elsif ($qqtype eq 'DEPT') {
     $top_dept_id = $qqid;
   } 
   elsif ($qqtype eq 'PYTG') {
     $top_pytg_id = $qqid;
   } 
   elsif ($qqtype eq 'PCCS') {
     $top_pccs_id = $qqid;
   } 
   elsif ($qqtype eq 'PMIT') {
     $top_pmit_id = $qqid;
   } 
 }
 do ora_close($csr) || die "can't close cursor";
 print "Root Fund ID = $top_fund_id   Root Cost ID = $top_cost_id"
       . "   Root Budg ID = $top_budg_id \nRoot LORG ID = $top_lorg_id"
       . "   Root ORG2 ID = $top_org2_id Root DEPT ID = $top_dept_id"
       . "   \nRoot PYTG ID = $top_pytg_id Root PCCS ID = $top_pccs_id" 
       . "   \nRoot PMIT ID = $top_pmit_id\n";
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";

#
#  Open a cursor, to read EHS authorizations.
#
 my $stmt = "select distinct
     a.function_id,
     decode(q.qualifier_code, 'NULL', 'NA', q.qualifier_code),
     decode(q.qualifier_type, 'NULL', 'NA', 'DL'),
     a.kerberos_name
     from exp_auth_func_qual_lim_dept a, qualifier q
     where function_id in
        ($sel_func_id26, $sel_func_id27, $sel_func_id32, $sel_func_id33)
     and q.qualifier_id = a.qualifier_id
     and a.parent_qual_id <> $top_dept_id
     and substr(q.qualifier_code, 1, 2) = 'D_'
     and a.do_function = 'Y'
     and sysdate between a.effective_date and
                           nvl(a.expiration_date, sysdate)
     and not exists (select q2.qualifier_id
      from qualifier_child qc, qualifier q2
      where qc.parent_id = q.qualifier_id
      and q2.qualifier_id = qc.child_id
      and substr(q2.qualifier_code,1,2) = 'D_')
     order by 3,2,4";
 print "Opening EHS cursor...\n";
 ###if (1 == 0) {
 #$csr = &ora_open($lda, "@stmt")
 $csr = &ora_open($lda, $stmt)
        || die $ora_errstr;
 print "Processing Authorizations in category EHS from" 
       . " Oracle table...\n";
 $i = -1;
 while (($func_id, $qc_num, $qc_type, $kerbname)
        = &ora_fetch($csr)) 
 {
   if (($i++)%5000 == 0) {print $i . "\n";}
   if (! $user_no_sap{$kerbname}) {
     print F2 "$func_id\|$qc_num\|$qc_type\|$kerbname\n";
   }
 }
 &ora_close($csr) || die "can't close cursor";
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";

#
#  Open a cursor, to read HR authorizations plus two PAYR authorizations
#  $sel_func_id69 and $sel_func_id70.
#
 @stmt = ("select",
           " a.function_id,",
           " decode(q.qualifier_code, 'NULL', 'NA', q.qualifier_code),",
           " decode(q.qualifier_type, 'NULL', 'NA', 'OU'),",
           " a.kerberos_name",
           " from authorization a, qualifier q",
           " where function_id in ($sel_func_id7, $sel_func_id8, ",
           " $sel_func_id9, $sel_func_id10, $sel_func_id11, $sel_func_id12,",
           " $sel_func_id13, $sel_func_id14, $sel_func_id15, $sel_func_id16,",
           " $sel_func_id17, $sel_func_id18, $sel_func_id19, $sel_func_id20,",
           " $sel_func_id21, $sel_func_id22, $sel_func_id23, $sel_func_id24,",
           " $sel_func_id25, $sel_func_id28, $sel_func_id29, $sel_func_id30,",
           " $sel_func_id31, $sel_func_id41, $sel_func_id42, $sel_func_id43,",
           " $sel_func_id44, $sel_func_id45, $sel_func_id57, $sel_func_id63,",
           " $sel_func_id64, $sel_func_id69, $sel_func_id70)",
           " and a.qualifier_id <> $top_org2_id",
           " and q.qualifier_id = a.qualifier_id",
           " and a.do_function = 'Y'",
           " and sysdate between a.effective_date and",
           " nvl(a.expiration_date,sysdate)",
           " union select",
           " a.function_id,",
           " decode(q.qualifier_code, 'NULL', 'NA', q.qualifier_code),",
           " decode(q.qualifier_type, 'NULL', 'NA', 'OU'),",
           " a.kerberos_name",
           " from authorization a, qualifier_descendent qd, qualifier q",
           " where function_id in ($sel_func_id7, $sel_func_id8, ",
           " $sel_func_id9, $sel_func_id10, $sel_func_id11, $sel_func_id12,",
           " $sel_func_id13, $sel_func_id14, $sel_func_id15, $sel_func_id16,",
           " $sel_func_id17, $sel_func_id18, $sel_func_id19, $sel_func_id20,",
           " $sel_func_id21, $sel_func_id22, $sel_func_id23, $sel_func_id24,",
           " $sel_func_id25, $sel_func_id28, $sel_func_id29, $sel_func_id30,",
           " $sel_func_id31, $sel_func_id41, $sel_func_id42, $sel_func_id43,",
           " $sel_func_id44, $sel_func_id45, $sel_func_id57, $sel_func_id63,",
           " $sel_func_id64, $sel_func_id69, $sel_func_id70)",
           " and a.qualifier_id <> $top_org2_id",
           " and qd.parent_id = a.qualifier_id",
           " and q.qualifier_id = qd.child_id",
           " and a.do_function = 'Y'",
           " and sysdate between a.effective_date and",
           " nvl(a.expiration_date,sysdate)",
           " order by 3,2,4");
 print "Opening cursor for HR auths plus 2 PAYR auths...\n";
 ###if (1 == 0) {
 $csr = &ora_open($lda, "@stmt")
        || die $ora_errstr;
 print "Processing Authorizations in category HR from" 
       . " Oracle table...\n";
 $i = -1;
 while (($func_id, $qc_num, $qc_type, $kerbname)
        = &ora_fetch($csr)) 
 {
   if (($i++)%5000 == 0) {print $i . "\n";}
   if (! $user_no_sap{$kerbname}) {
     print F2 "$func_id\|$qc_num\|$qc_type\|$kerbname\n";
   }
 }
 do ora_close($csr) || die "can't close cursor";
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";

#
#  Open a cursor, to read PAYR authorizations with PDED or NULL 
#  qualifiers, or with PMIT qualifiers for two specific functions.
#
 @stmt0a = ("select",
           " a.function_id,",
           " decode(q.qualifier_code, 'NULL', 'NA', q.qualifier_code),",
           " decode(q.qualifier_type, 'NULL', 'NA', 'PDED', 'DC', 'PC'),",
           " a.kerberos_name",
           " from authorization a, qualifier q ",
           " where function_category = 'PAYR'",
           " and q.qualifier_type in ('NULL', 'PDED', 'PMIT')",
           " and (q.qualifier_type in ('NULL', 'PDED') ",
           "      or (a.function_id in ($sel_func_id71, $sel_func_id72)",
           "         and q.qualifier_code between 'PC000000' and 'PC999999'))",
           " and a.qualifier_id <> $top_pmit_id",
           " and q.qualifier_id = a.qualifier_id",
           " and a.do_function = 'Y'",
           " and sysdate between a.effective_date and",
           " nvl(a.expiration_date,sysdate)",
           " union select",
           " a.function_id,",
           " decode(q.qualifier_code, 'NULL', 'NA', q.qualifier_code),",
           " decode(q.qualifier_type, 'NULL', 'NA', 'PDED', 'DC', 'PC'),",
           " a.kerberos_name",
           " from authorization a, function f, qualifier_descendent qd,", 
           " qualifier q",
           " where a.function_category = 'PAYR'",
           " and f.function_id = a.function_id",
           " and a.qualifier_id <> $top_pmit_id",
           " and q.qualifier_type in ('NULL', 'PDED', 'PMIT')",
           " and qd.parent_id = a.qualifier_id",
           " and q.qualifier_id = qd.child_id",
           " and (f.qualifier_type in ('NULL', 'PDED') ",
           "      or (a.function_id in ($sel_func_id71, $sel_func_id72)",
           "         and q.qualifier_code between 'PC000000' and 'PC999999'))",
           " and a.do_function = 'Y'",
           " and sysdate between a.effective_date and",
           " nvl(a.expiration_date,sysdate)",
           " order by 3,2,4");
 print "Opening cursor for PAYR auths with NULL and PDED qualifiers...\n";
 ###if (1 == 0) {
 $csr0a = &ora_open($lda, "@stmt0a")
        || die $ora_errstr;
 print "Processing Authorizations in category HR from" 
       . " Oracle table...\n";
 $i = -1;
 while (($func_id, $qc_num, $qc_type, $kerbname)
        = &ora_fetch($csr0a)) 
 {
   if (($i++)%5000 == 0) {print $i . "\n";}
   if (! $user_no_sap{$kerbname}) {
     print F2 "$func_id\|$qc_num\|$qc_type\|$kerbname\n";
   }
 }
 &ora_close($csr0a) || die "can't close cursor";
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";

#
#  Open a cursor, to read PAYR authorizations.
#
 $stmt1 = "select"
         .  " a.function_id,"
         .  " decode(q.qualifier_code, 'NULL', 'NA', "
         .  "      substr(q.qualifier_name, length(q.qualifier_name)-8, 8)),"
         .  " decode(q.qualifier_type, 'NULL', 'NA', 'TG'),"
         .  " a.kerberos_name"
         .  " from authorization a, qualifier q"
         .  " where function_id in ($sel_func_id34, $sel_func_id35, "
         .  " $sel_func_id36, $sel_func_id37, $sel_func_id38, $sel_func_id39, "
         .  " $sel_func_id40, $sel_func_id46, $sel_func_id47, $sel_func_id48, "
         .  " $sel_func_id49, $sel_func_id50, $sel_func_id51, $sel_func_id52, "
         .  " $sel_func_id53, $sel_func_id54, $sel_func_id55, $sel_func_id56, "
         .  " $sel_func_id58, $sel_func_id59, $sel_func_id60, $sel_func_id61, "
         .  " $sel_func_id62, $sel_func_id65, $sel_func_id66, $sel_func_id67, "
         .  " $sel_func_id68)"
         .  " and a.qualifier_id <> $top_pytg_id"
         .  " and q.qualifier_id = a.qualifier_id"
         .  " and q.qualifier_type = 'PYTG'"
         .  " and q.qualifier_code like 'TG%'"
         .  " and a.do_function = 'Y'"
         .  " and sysdate between a.effective_date and"
         .  " nvl(a.expiration_date,sysdate)"
         .  " union select"
         .  " a.function_id,"
         .  " decode(q.qualifier_code, 'NULL', 'NA', "
         .  "      substr(q.qualifier_name, length(q.qualifier_name)-8, 8)),"
         .  " decode(q.qualifier_type, 'NULL', 'NA', 'TG'),"
         .  " a.kerberos_name"
         .  " from authorization a, qualifier_descendent qd, qualifier q"
         .  " where function_id in ($sel_func_id34, $sel_func_id35, "
         .  " $sel_func_id36, $sel_func_id37, $sel_func_id38, $sel_func_id39, "
         .  " $sel_func_id40, $sel_func_id46, $sel_func_id47, $sel_func_id48, "
         .  " $sel_func_id49, $sel_func_id50, $sel_func_id51, $sel_func_id52, "
         .  " $sel_func_id53, $sel_func_id54, $sel_func_id55, $sel_func_id56, "
         .  " $sel_func_id58, $sel_func_id59, $sel_func_id60, $sel_func_id61, "
         .  " $sel_func_id62, $sel_func_id65, $sel_func_id66, $sel_func_id67, "
         .  " $sel_func_id68)"
         .  " and a.qualifier_id <> $top_pytg_id"
         .  " and qd.parent_id = a.qualifier_id"
         .  " and q.qualifier_id = qd.child_id"
         .  " and q.qualifier_type = 'PYTG'"
         .  " and q.qualifier_code like 'TG%'"
         .  " and a.do_function = 'Y'"
         .  " and sysdate between a.effective_date and"
         .  " nvl(a.expiration_date,sysdate)"
         .  " order by 3,2,4";
 print "Opening PAYR cursor...\n";
 #print "PAYR cursor:\n'$stmt1'\n";
 ###if (1 == 0) {
 $csr = &ora_open($lda, $stmt1)
        || die $ora_errstr;
 print "Processing Authorizations in category PAYR from" 
       . " Oracle table...\n";
 $i = -1;
 while (($func_id, $qc_num, $qc_type, $kerbname)
        = &ora_fetch($csr)) 
 {
   if (($i++)%5000 == 0) {print $i . "\n";}
   if (! $user_no_sap{$kerbname}) {
     print F2 "$func_id\|$qc_num\|$qc_type\|$kerbname\n";
   }
 }
 do ora_close($csr) || die "can't close cursor";
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";

#
#  Open another cursor, to read PAYR authorizations.  This time, we will
#  generate authorizations for fake TIMESHEET functions, where we add
#  500000 to each function_id.  The config files should append 
#  '*ALT' to each function name for these fake functions.  The authorization
#  lines put into the sap1.out.nnnnnnnn file will refer to the Org Unit
#  associated with each Time Group authorization generated.
#
 $stmt1 = "select distinct /* Get leaf-level Org Units above TG-level auths */
  a.function_id + 500000,  q2.qualifier_code,  'OU',  a.kerberos_name,
    a.function_name
  from authorization a, qualifier q, qualifier_child qc, qualifier q2
  where function_id in ($sel_func_id34, $sel_func_id35, $sel_func_id36, $sel_func_id37,
   $sel_func_id38, $sel_func_id39, $sel_func_id40)
  and a.qualifier_id <> $top_pytg_id
  and q.qualifier_id = a.qualifier_id
  and q.qualifier_code like 'TG%'
  and a.do_function = 'Y'
  and sysdate between a.effective_date and
  nvl(a.expiration_date,sysdate)
  and qc.child_id = q.qualifier_id
  and q2.qualifier_id = qc.parent_id
  union 
  select distinct /* Get leaf-level Org units specified in auths. */
  a.function_id + 500000,  q.qualifier_code,  'OU', a.kerberos_name,
    a.function_name
  from authorization a, qualifier q,
       qualifier_child qc, qualifier q0
  where function_id in ($sel_func_id34, $sel_func_id35, $sel_func_id36, $sel_func_id37,
   $sel_func_id38, $sel_func_id39, $sel_func_id40)
  and a.qualifier_id <> $top_pytg_id
  and q.qualifier_id = a.qualifier_id
  and a.do_function = 'Y'
  and sysdate between a.effective_date and
  nvl(a.expiration_date,sysdate)
  and qc.parent_id = q.qualifier_id
  and q0.qualifier_id = qc.child_id
  and q0.qualifier_code like 'TG%'
  union 
  select distinct /* Get leaf-level Org units under node-level auths. */
  a.function_id + 500000,  q.qualifier_code, 'OU', a.kerberos_name,
    a.function_name
  from authorization a, qualifier_descendent qd, qualifier q,
       qualifier_child qc, qualifier q0
  where function_id in ($sel_func_id34, $sel_func_id35, $sel_func_id36, $sel_func_id37,
   $sel_func_id38, $sel_func_id39, $sel_func_id40)
  and a.qualifier_id <> $top_pytg_id
  and qd.parent_id = a.qualifier_id
  and q.qualifier_id = qd.child_id
  and a.do_function = 'Y'
  and sysdate between a.effective_date and
  nvl(a.expiration_date,sysdate)
  and qc.parent_id = q.qualifier_id
  and q0.qualifier_id = qc.child_id
  and q0.qualifier_code like 'TG%'
  order by 3,2,4";
 print "Opening another PAYR cursor...\n";
 #print "Another PAYR cursor:\n'$stmt1'\n";
 ###if (1 == 0) {
 $csr = &ora_open($lda, $stmt1)
        || die $ora_errstr;
 print "Processing Authorizations in category PAYR, 2nd step, from" 
       . " Oracle table...\n";
 $i = -1;
 while (($func_id, $qc_num, $qc_type, $kerbname)
        = &ora_fetch($csr)) 
 {
   if (($i++)%5000 == 0) {print $i . "\n";}
   if (! $user_no_sap{$kerbname}) {
     print F2 "$func_id\|$qc_num\|$qc_type\|$kerbname\n";
   }
 }
 &ora_close($csr) || die "can't close cursor";
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";

#
#  Open a cursor to read Payroll authorizations with qualifiers from the 
#  PCCS hierarchy.
# 
#  The following select statement is a union of 4 parts.
#    1. Find authorizations that have a profit center (PCnnnnnn) as a 
#       qualifier, and generate a record for that function_id and specific
#       profit center.
#    2. Find authorizations that have a cost object as a qualifier, and 
#       generate a record for that function_id and specific cost object.
#    3. Find authorizations that have a CO-supervisor as a qualifier, and
#       generate a record for each child cost object.
#    4. Find authorizations that have a PCMIT-0* qualifier, and
#       generate a record for each child profit center.
#
 $stmt1 = "select a.function_id, q.qualifier_code, 'PC', -- part 1
                 a.kerberos_name
           from authorization a, qualifier q
           where function_id in (select function_id from function 
              where function_category = 'PAYR' and qualifier_type = 'PCCS')
           and q.qualifier_id = a.qualifier_id
           and q.qualifier_code between 'PC000000' and 'PC999999'
           and a.do_function = 'Y'
           and sysdate between a.effective_date and 
                               nvl(a.expiration_date,sysdate)
           union select a.function_id, q.qualifier_code, -- part 2
            decode(substr(q.qualifier_code,1,1),
                   'C','CC', 'I','IO', 'P','WB', '??'),
               a.kerberos_name
           from authorization a, qualifier q
           where function_id in (select function_id from function 
              where function_category = 'PAYR' and qualifier_type = 'PCCS')
           and q.qualifier_id = a.qualifier_id
           and length(q.qualifier_code) = 8
           and substr(q.qualifier_code, 2, 7) between '0000000' and '9999999'
           and a.do_function = 'Y'
           and sysdate between a.effective_date and 
                               nvl(a.expiration_date,sysdate)
           union select a.function_id, q.qualifier_code,  -- part 3
            decode(substr(q.qualifier_code,1,1),
                   'C','CC', 'I','IO', 'P','WB', '??'),
                        a.kerberos_name
           from authorization a, qualifier q0,
                qualifier_child qc, qualifier q
           where function_id in (select function_id from function 
              where function_category = 'PAYR' and qualifier_type = 'PCCS')
           and q0.qualifier_id = a.qualifier_id
           and length(q0.qualifier_code) = 15 and
             q0.qualifier_code between '000000000000000' and '999999999999999'
           and qc.parent_id = a.qualifier_id
           and q.qualifier_id = qc.child_id
           and length(q.qualifier_code) = 8
           and substr(q.qualifier_code, 2, 7) between '0000000' and '9999999'
           and a.do_function = 'Y'
           and sysdate between a.effective_date and
                               nvl(a.expiration_date,sysdate)
           union select a.function_id, q.qualifier_code, 'PC', -- part 4
                        a.kerberos_name
           from authorization a, qualifier q0,
                qualifier_descendent qd, qualifier q
           where function_id in (select function_id from function 
              where function_category = 'PAYR' and qualifier_type = 'PCCS')
           and a.qualifier_id <> $top_pccs_id
           and q0.qualifier_id = a.qualifier_id
           and q0.qualifier_code like 'PCMIT%'
           and qd.parent_id = a.qualifier_id
           and q.qualifier_id = qd.child_id
           and q.qualifier_code between 'PC000000' and 'PC999999'
           and a.do_function = 'Y'
           and sysdate between a.effective_date and
                               nvl(a.expiration_date,sysdate)
           order by 3,2,4";
 print "Opening a PAYR cursor for the PCCS hierarchy...\n";
 #print "PAYR cursor for PCCS hierarchy:\n'$stmt1'\n";
 ###if (1 == 0) {
 $csr = &ora_open($lda, $stmt1)
        || die $ora_errstr;
 print "Processing Authorizations in category PAYR, qualtype PCCS, from" 
       . " Oracle table...\n";
 $i = -1;
 while (($func_id, $qc_num, $qc_type, $kerbname)
        = &ora_fetch($csr)) 
 {
   if (($i++)%5000 == 0) {print $i . "\n";}
   if (! $user_no_sap{$kerbname}) {
     print F2 "$func_id\|$qc_num\|$qc_type\|$kerbname\n";
   }
 }
 do ora_close($csr) || die "can't close cursor";
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";

#
#  Open a cursor to read in COST records from qualifier table.  (We'll
#  need these to convert Funds to Cost Elements later.)
#  The select statement will be the union of 3 parts.
#  The first part finds all qualifiers except WBS elements (Pnnnnnnn) and
#  the root of the tree.  The second part finds WBS elements, using the
#  Profit Center as the parent.  The third part finds the root.
#
 $qqualtype = 'COST';
# @stmt = ("select c.parent_id, q.qualifier_id, q.qualifier_code," 
#          . " q.has_child, ltrim(q.qualifier_code,'CIP')" 
#          . " from qualifier q, qualifier_child c"
#          . " where q.qualifier_id = c.child_id"
#          . " and q.qualifier_type = '$qqualtype'"
 @stmt = ("select c.parent_id, q.qualifier_id, q.qualifier_code," 
          . " q.has_child, ltrim(q.qualifier_code,'CIP')" 
          . " from qualifier q, qualifier_child c, qualifier q2"
          . " where q.qualifier_id = c.child_id"
          . " and c.parent_id = q2.qualifier_id"
          . " and q.qualifier_code not between 'P0000000' and 'P9999999'"
          . " and q.qualifier_code not between 'P_0000000' and 'P_9999999'"
          . " and q.qualifier_type = '$qqualtype'"
          . " union"
          . " select q2.qualifier_id, q.qualifier_id, q.qualifier_code,"
          . " q.has_child, ltrim(q.qualifier_code, 'CIP')"
          . " from qualifier q, wh_cost_collector w, qualifier q2"
          . " where q.qualifier_type = '$qqualtype'"
          . " and q.qualifier_code between 'P0000000' and 'P9999999'"
          . " and w.cost_collector_id_with_type = q.qualifier_code"
          . " and q2.qualifier_type = '$qqualtype'"
          . " and q2.qualifier_code = replace(w.profit_center_id, 'P', 'PC')"
          . " union"
          . " select -1, qualifier_id, qualifier_code,"
          . " has_child, ltrim(q.qualifier_code,'CIP')"
          . " from qualifier q"
          . " where qualifier_level = 1 and qualifier_type = '$qqualtype'"
          . " order by 3");
 #print "@stmt\n";
 $csr = &ora_open($lda, "@stmt")
        || die $ora_errstr;
 %qid_to_code = ();
 print "Reading in Qualifiers (type = '$qqualtype') from Oracle table...\n";
 $i = -1;
 while ((($qparentid, $qqid, $qqcode, $qhaschild, $qqcode_num) 
        = &ora_fetch($csr))) 
 {
   if (($i++)%20000 == 0) {print $i . "\n";}
   #if ($qqcode eq '6891267') 
   #  {print "qqcode='$qqcode' parentid='$qparentid'\n";}
   push(@parentid, $qparentid);
   push(@qualcode, $qqcode);
   #push(@qualcode_num, $qqcode_num);  # 12/30/2002
   push(@haschild, $qhaschild);
   #push(@qualtype, $prefix_to_type{ substr($qqcode,0,1) } );  # 12/30/2002
   $qid_to_code{$qqid} = $qqcode;  # Build hash mapping qual_id to qual_code.
   $qcodenum_to_idx{$qqcode_num} = @qualcode - 1;
 }
 do ora_close($csr) || die "can't close cursor";
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";

#
#  Open a cursor to get 'CAN SPEND AND COMMIT FUNDS' authorizations
#  The "and lpad... not like ..." phrase is designed to select
#  FC200000, but not FC200000A - FC200000Z.  (FC200000 is a real
#  F.C. in SAP;  FC200000A-Z are added by the Roles DB for convenience.)
#
 @stmt = ("select --+ RULE\n",
           " a.function_id, ltrim(q.qualifier_code,'CF'), 'FC',",
           " a.kerberos_name",
           " from authorization a, qualifier q, qualifier_descendent qd",
           " where function_id = $sel_func_id1",
           " and a.qualifier_id = qd.parent_id",
           " and a.qualifier_id <> $top_fund_id",
           " and q.qualifier_id = qd.child_id",
           " and q.qualifier_code like 'FC%'",
           " and lpad(q.qualifier_code,9,'*') not like 'FC200000%'",
           " and nvl(q.custom_hierarchy,'N') = 'N'",
           " and a.do_function = 'Y'",
           " and a.effective_date <= sysdate",
           " and nvl(a.expiration_date,sysdate) >= sysdate",
           " union",
           " select a.function_id, ltrim(q.qualifier_code,'CF'),",
           " decode(rtrim(q.qualifier_code,'0123456789'),'F','FN',",
           "        rtrim(q.qualifier_code,'0123456789')),",
           " a.kerberos_name",
           " from authorization a, qualifier q",
           " where function_id = $sel_func_id1",
           " and a.qualifier_id <> $top_fund_id",
           " and a.qualifier_id = q.qualifier_id",
           " and nvl(q.custom_hierarchy,'N') = 'N'",
           " and lpad(a.qualifier_code,9,'*') not like 'FC200000%'",
           " and a.do_function = 'Y'",
           " and a.effective_date <= sysdate",
           " and nvl(a.expiration_date,sysdate) >= sysdate",
           " order by 3,2,4");
 print "Opening 1st cursor...\n";
 ###if (1 == 0) {
 $csr = &ora_open($lda, "@stmt")
        || die $ora_errstr;
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";

#
#  Read in rows from the authorization table
#
 print "Processing Authorizations (function_id = $sel_func_id1) from" 
       . " Oracle table...\n";
 $i = -1;
 while (($func_id, $qc_num, $qc_type, $kerbname)
        = &ora_fetch($csr)) 
 {
   if (($i++)%5000 == 0) {print $i . "\n";}
   if (! $user_no_sap{$kerbname}) {
     print F2 "$func_id\|$qc_num\|$qc_type\|$kerbname\n";
   }
 }
 do ora_close($csr) || die "can't close cursor";
 ###}
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";

#
#  Open another cursor, to read "ENTER BUDGETS" authorizations.
#
 @stmt = ("select",
           " a.function_id, a.qualifier_code, 'BU',",
           " a.kerberos_name",
           " from authorization a",
           " where function_id = $sel_func_id4",
           " and a.qualifier_id <> $top_budg_id",
           " and a.do_function = 'Y'",
           " and sysdate between a.effective_date and",
           " nvl(a.expiration_date,sysdate)",
           " order by 3,2,4");
 print "Opening 2nd cursor...\n";
 ###if (1 == 0) {
 $csr = &ora_open($lda, "@stmt")
        || die $ora_errstr;
 print "Processing Authorizations (function_id = $sel_func_id4) from" 
       . " Oracle table...\n";
 $i = -1;
 while (($func_id, $qc_num, $qc_type, $kerbname)
        = &ora_fetch($csr)) 
 {
   if (($i++)%20000 == 0) {print $i . "\n";}
   if (! $user_no_sap{$kerbname}) {
     print F2 "$func_id\|$qc_num\|$qc_type\|$kerbname\n";
   }
 }
 do ora_close($csr) || die "can't close cursor";
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";

#
#  Open another cursor, to read LDS authorizations.
#  Convert LDS E... function_id to LDS A function_id on output because
#    the two functions generate the same profiles.
#
 @stmt = ("select",
          " '$sel_func_id5', a.qualifier_code, 'PC',",
          " a.kerberos_name",
          " from authorization a",
          " where a.function_id in ($sel_func_id5, $sel_func_id6)",
          " and a.qualifier_id <> $top_lorg_id",
          " and a.qualifier_code like '______'",
          " and a.do_function = 'Y'",
          " and sysdate between a.effective_date and",
          " nvl(a.expiration_date,sysdate)",
          " union select",
          " '$sel_func_id5', q.qualifier_code, 'PC',",
          " a.kerberos_name",
          " from authorization a, qualifier_descendent qd, qualifier q",
          " where a.function_id in ($sel_func_id5, $sel_func_id6)",
          " and a.qualifier_id <> $top_lorg_id",
          " and qd.parent_id = a.qualifier_id",
          " and q.qualifier_id = qd.child_id",
          " and q.qualifier_code like '______'",
          " and a.do_function = 'Y'",
          " and sysdate between a.effective_date and",
          " nvl(a.expiration_date,sysdate)",
          " order by 3,2,4");
 print "Opening cursor 2-1/2...\n";
 $csr = &ora_open($lda, "@stmt")
        || die $ora_errstr;
 print "Processing Authorizations (function_ids $sel_func_id5 and"
       . " $sel_func_id6) from Oracle table...\n";
 $i = -1;
 while (($func_id, $qc_num, $qc_type, $kerbname)
        = &ora_fetch($csr)) 
 {
   if (($i++)%1000 == 0) {print $i . "\n";}
   # Remove duplicates.
   $old_func_id = ''; $old_qc_num = '';
   if ((! $user_no_sap{$kerbname}) && 
       ($func_id != $old_func_id || $qc_num != $old_qc_num)) {
     print F2 "$func_id\|$qc_num\|$qc_type\|$kerbname\n";
     #print "LDS $func_id $qc_num $qc_type $kerbname\n";
   }
   $old_func_id = $func_id;  $old_qc_num = $qc_num;
 }
 do ora_close($csr) || die "can't close cursor";
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";

#
#  Open another cursor, to read "REPORT BY CO/PC" authorizations.
#
#  SAP reporting profiles can use either a PC or a cost object as
#  the qualifier.  Therefore, Roles authorizations where the qualifier
#  is a PC or higher should generate profiles for the PCs and not
#  cost objects (#1 and #2), except where the descendent cost objects
#  are cross-PC WBSE children of other WBSEs (#3).  If the original
#  qualifier is a cost object, then generate a profile for the original
#  cost object in the authorization (#1), and if the original cost object
#  is a WBSE with children, add those children to the list also (#4).
#  If the original qualifier in the authorization is P_nnnnnnn, then 
#  generate a list of its WBSE children (#3).
#
#  It is a union of select statements
#  1.  Find authorizations where qualifier_code is not like '0%'
#      and not of the form P_nnnnnnn. (This should give us PC..., C...., 
#      I....., and Pnnnnnnn). These are authorizations where the 
#      original qualifier is to be used in the resulting profile.
#  2.  Join auth->qual_desc->qualifier finding expanded authorizations
#      where (resulting) qualifier_code is like 'PC%'.  We take authorizations
#      where the original qualifier is a group of PCs and generate a 
#      list of the child PCs.
#  3.  Join auth->qual_child->qualifier finding expanded authorizations where
#      qualifier_code is a child of P_nnnnnnn 
#  4.  Join auth->qual_child->qualifier finding expanded authorizations where
#      auth.qualifier_code is between 'P0000000' and 'P9999999' (Find
#      WBS children of an authorization for a WBS)
#
  @stmt = ("select",    # 1
          " a.function_id, ltrim(a.qualifier_code,'CIP'),",
          " decode(rtrim(a.qualifier_code, '0123456789X'), 'C','CC',",
          " 'I','IO', 'P','WB', rtrim(qualifier_code,'0123456789X')),", 
          " a.kerberos_name",
          " from authorization a",
          " where a.function_id = $sel_func_id2",
          " and a.qualifier_id <> $top_cost_id",
          " and a.qualifier_code not like '0%'",
#         " and a.qualifier_code not like '%XX'",
          " and translate(qualifier_code, '_', '!') not like 'P!%'",
          " and a.do_function = 'Y'",
          " and a.effective_date <= sysdate",
          " and nvl(a.expiration_date,sysdate) >= sysdate",
          " union",     #2
          " select a.function_id, ltrim(q.qualifier_code,'CIP'), 'PC',",
          " a.kerberos_name",
          " from authorization a, qualifier q, qualifier_descendent qd",
          " where function_id = $sel_func_id2",
          " and a.qualifier_id <> $top_cost_id",
          " and a.qualifier_id = qd.parent_id",
          " and q.qualifier_id = qd.child_id",
          " and q.qualifier_code like 'PC%'",
          " and a.do_function = 'Y'",
          " and a.effective_date <= sysdate",
          " and nvl(a.expiration_date,sysdate) >= sysdate",
          " union",     #3
          " select a.function_id, ltrim(q.qualifier_code,'CIP'),",
          " decode(rtrim(q.qualifier_code, '0123456789X'), 'C','CC',",
          " 'I','IO', 'P','WB', rtrim(q.qualifier_code,'0123456789X')),",
          " a.kerberos_name",
          " from authorization a, qualifier q, qualifier_descendent qd",
          " where function_id = $sel_func_id2",
          " and a.qualifier_id = qd.parent_id",
          " and a.qualifier_id <> $top_cost_id",
          " and q.qualifier_id = qd.child_id",
          #" and q.qualifier_code like 'P%'",
          " and q.qualifier_code between 'P0000000' and 'P9999999'", #1/12
          " and a.do_function = 'Y'",
          " and a.effective_date <= sysdate",
          " and nvl(a.expiration_date,sysdate) >= sysdate",
          " and exists (select qc.child_id ",
          # "  from qualifier_child qc, qualifier q2",
          "  from qualifier_descendent qc, qualifier q2",
          "  where qc.child_id = q.qualifier_id",  #  1/12/01
          "  and qc.parent_id = q2.qualifier_id",
          "  and q2.qualifier_code between 'P_0000000' and 'P_9999999'",
          "  and translate(q2.qualifier_code,'_','!') like 'P!%')",
          " union",     #4
          " select a.function_id, ltrim(q.qualifier_code,'CIP'),",
          " 'WB', a.kerberos_name",
          " from authorization a, qualifier q, qualifier_descendent qd",
          " where function_id = $sel_func_id2",
          " and a.qualifier_id = qd.parent_id",
          " and q.qualifier_id = qd.child_id",
          " and a.qualifier_code between 'P0' and 'P9999999'",
          " and q.qualifier_code between 'P0000000' and 'P9999999'",
          " and a.do_function = 'Y'",
          " and a.effective_date <= sysdate",
          " and nvl(a.expiration_date,sysdate) >= sysdate",
          " order by 3,2,4");
 print "Opening 3rd cursor...\n";
 $csr = &ora_open($lda, "@stmt")
        || die $ora_errstr;
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";
 
#
#  Read in more rows from the authorization table
#
 print "Processing Authorizations (function_id = $sel_func_id2) from" 
       . " Oracle table...\n";
 @auth_line = ();
 $i = -1;
 while (($func_id, $qc_num, $qc_type, $kerbname)
        = &ora_fetch($csr)) 
 {
   if (($i++)%20000 == 0) {print $i . "\n";}
   $idx = $qcodenum_to_idx{$qc_num};
   $parent_code = $qid_to_code{$parentid[$idx]};
   #print F2 "$func_id|$qc_num|$qc_type|$kerbname|$parent_code\n";
   push(@auth_line, "$func_id|$qc_num|$qc_type|$kerbname|$parent_code");   
 }
 do ora_close($csr) || die "can't close cursor";
 $n = @auth_line;
 print "Number of auths from $sel_func_id2 = $n\n";
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";

#
#  Open another cursor, to read "REPORT BY FUND/FC" authorizations.
#  Look only for Funds, not Fund Centers.
#
# @stmt = ("select --+ RULE\n",
 @stmt = ("select",
           " a.function_id, ltrim(q.qualifier_code,'F'),",
           " 'FN', a.kerberos_name",
           " from authorization a, qualifier q, qualifier_descendent qd",
           " where function_id = $sel_func_id3",
           " and a.qualifier_id != $top_fund_id",
           " and a.qualifier_id = qd.parent_id",
           " and q.qualifier_id = qd.child_id",
           " and q.qualifier_code not like 'FC%'",
           " and a.do_function = 'Y'",
           " and a.effective_date <= sysdate",
           " and nvl(a.expiration_date,sysdate) >= sysdate",
           " union",
           " select",
           " a.function_id, ltrim(a.qualifier_code,'F'),",
           " 'FN', a.kerberos_name",
           " from authorization a",
           " where function_id = $sel_func_id3",
           " and a.qualifier_code not like 'FC%'",
           " and a.do_function = 'Y'",
           " and a.effective_date <= sysdate",
           " and nvl(a.expiration_date,sysdate) >= sysdate");
 print "Opening 4th cursor...\n";
 $csr = &ora_open($lda, "@stmt")
        || die $ora_errstr;
 
#
#  Read in more rows from the authorization table
#
 print "Processing Authorizations (function_id = $sel_func_id3) from" 
       . " Oracle table...\n";
 @auth_temp = ();
 $i = -1;
 while (($func_id, $qc_num, $qc_type, $kerbname)
        = &ora_fetch($csr)) 
 {
   if (($i++)%20000 == 0) {print $i . "\n";}
   #print F2 "$func_id\|<$qc_num\|$qc_type\|$kerbname\n";
   push(@auth_temp, "$func_id\|$qc_num\|$qc_type\|$kerbname");   
 }
 do ora_close($csr) || die "can't close cursor";
 $n = @auth_temp;
 print "Number of auths from $sel_func_id3 = $n\n";
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";

#
#  Convert Funds to Cost Elements.
#
 print "Converting Funds to Cost Objects for Authorizations with"
       . " function_id = $sel_func_id3...\n";
 %prefix_to_type = ('C' => 'CC',
                    'I' => 'IO',
                    'P' => 'WB');
 $delim = '\|';
 for ($i = 0; $i < @auth_temp; $i++) {
   ($func_id, $qc_num, $qc_type, $kerbname) = split($delim, $auth_temp[$i]);  
   if ($i%20000 == 0) {
     print $i . "\n";
     #print "func_id = '$func_id' qc_num = '$qc_num' qc_type = '$qc_type'"
     #      . " kerbname = '$kerbname'\n";
   }
   $idx = $qcodenum_to_idx{$qc_num};
   $c_i_p = substr($qualcode[$idx], 0, 1);
   $qctype = $prefix_to_type{$c_i_p};
   $parent_code = $qid_to_code{$parentid[$idx]};
   # If parent is Pnnnnnnn or P_nnnnnnn then move up to PCnnnnnn
   while ($parent_code =~ /^P[0-9]/) { 
     $idx = $qcodenum_to_idx{substr($parent_code,1)};
     #print "qc_num = '$qc_num' parent_code = '$parent_code' idx=$idx\n";
     $parent_code = $qid_to_code{$parentid[$idx]};
     #print "new parent_code = '$parent_code'\n";
   }
   $func_id = $sel_func_id2;  # Change function_id to that for Cost/PC Rpt.
   $auth_temp[$i] = "$func_id|$qc_num|$qctype|$kerbname|$parent_code";
   #push(@auth_line, "$func_id|$qc_num|$qctype|$kerbname|$parent_code");
 }
 $n = @auth_temp;
 print "After conversion, number of auths from $sel_func_id3 = $n\n";
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";


#
#  Put authorizations for "Report by CO/PC" together with
#  "Reporting by Fund/FC" in a temporary file.
#
 undef @parentid;       # 5/1/2002
 undef @qualcode;       # 5/1/2002
 #undef @qualcode_num;   # 5/1/2002
 undef @haschild;       # 5/1/2002
 #undef @qualtype;       # 5/1/2002
 undef %qid_to_code;    # 11/14/2002
 print "Combining auths for Report by CO/PC and Report by Fund/FC into"
       . " one file...\n";
 $| = 0; #Do not Force Ouput Buffer to Flush on each write
 if( !open(F3, ">$tempfile") ) {
   die "$0: can't open ($tempfile) for writing - $!\n";
 }
 my $tempitem;
 $n = 0;
 foreach $tempitem (@auth_line) {
   print F3 "$tempitem\n";
   $n++;
   if ($n%20000 == 0) {print $n . "\n";}
 }
 foreach $tempitem (@auth_temp) {
   print F3 "$tempitem\n";
   $n++;
   if ($n%20000 == 0) {print $n . "\n";}
 }
 close (F3);
 $| = 1; #Once again, Force Ouput Buffer to Flush on each write
 ##push(@auth_line, @auth_temp);
 print "Undefining two large arrays\n";
 undef @auth_temp;
 undef @auth_line;
 ##$n = @auth_line;
 print "Number of auths from $sel_func_id2 and $sel_func_id3 = $n\n";

#
#  Remove duplicates from the authorizations for Reporting
#
 ##@auth_temp = ();
 @auth_line = ();
 %counta = ();
 if( !open(F3IN, "$tempfile") ) {
   die "$0: can't open ($tempfile) for reading - $!\n";
 }
 $i = 0;
 print "Removing duplicates from auths from $sel_func_id2 and $sel_func_id3\n";
 while (chomp($tempitem = <F3IN>)) {
   if (($i++)%20000 == 0) {print $i . "\n";}
   $n = ++$counta{$tempitem};   # Count the number of occurences of each
   if ($n < 2) {
     push(@auth_line, $tempitem);
   }
 }
 close (F3IN);
 system("rm $tempfile\n");
 ##for ($i = 0; $i < @auth_line; $i++) {
 ##  $n = ++$counta{$auth_line[$i]};   # Count the number of occurences of each
 ##  if ($n < 2) {
 ##    push(@auth_temp, $auth_line[$i]);
 ##  }
 ##}
 ##@auth_line = @auth_temp;
 print "Undefining a large hash\n";
 undef %counta;
 ##undef @auth_temp; 
 $n = @auth_line;
 print "Number of unique auths from $sel_func_id2 and $sel_func_id3 = $n\n";

#
#  Remove elements of @auth_line where qc is a child of another
#  element in the array.
#
 print "Removing redundant authorizations"
  . " (where auth for parent qcode exists)...\n";
 # First, build a hash of PC qualifiers
 %upc = ();   # Hash for store $kerbname . $parent_code
 print "Removing... (1)\n";
 for ($i = 0; $i < @auth_line; $i++) {
   ($func_id, $qc_num, $qc_type, $kerbname, $parent_code) 
      = split($delim, $auth_line[$i]);
   if ($qc_type = 'PC') {
     $temp = $kerbname . ".PC" . $qc_num;
     $upc{$temp} = 1;
   }
 }
 # Then, keep only elements whose parent code is not found.
 @auth_temp = ();
 print "Removing... (2)\n";
 ##
  $n = @auth_line;
  print "$n lines in \@auth_line\n";
  $n = (keys %upc);
  print "$n keys in \%upc\n";
 ##
 for ($i = 0; $i < @auth_line; $i++) {
   if ($i%10000 == 0) {
     ##$n = @auth_temp;
     $n = @auth_line;
     print "i=$i n=$n \n";
   }
   ($func_id, $qc_num, $qc_type, $kerbname, $parent_code) 
      = split($delim, $auth_line[$i]);
   if ($upc{$kerbname . '.' . $parent_code} ne '1') {
     push(@auth_temp, $auth_line[$i]);
   }
 }
 ##print "Before setting \@auth_line = \@auth_temp\n";
 ##@auth_line = @auth_temp;
 ##print "After setting \@auth_line = \@auth_temp\n";
 undef %upc;
 ##undef @auth_temp;
 ##$n = @auth_line;
 $n = @auth_temp;
 print "(After proc.) no. of auths $sel_func_id2 and $sel_func_id3 = $n\n";
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";

#
#  (Future step:  Try to consolidate cost elements into Profit Centers)
#

#
#  Put the Reporting authorizations together with the other authorizations.
#  Print them.
#
 ##for ($i = 0; $i < @auth_line; $i++) {
 for ($i = 0; $i < @auth_temp; $i++) {
   ($func_id, $qc_num, $qc_type, $kerbname, $parent_code) 
      = split($delim, $auth_temp[$i]);
   ##   = split($delim, $auth_line[$i]);
   if (! $user_no_sap{$kerbname}) {
     print F2 "$func_id|$qc_num|$qc_type|$kerbname|$parent_code\n";
   }
 }
 undef @auth_temp;

#
#  Now get distinct (user,function) pairs for all SAP-related authorizations
#  whose function_id is not in ($sel_func_id1, $sel_func_id2, $sel_func_id3
#  $sel_func_id4, $use_sap_func_id).
#  ### Changed 1/9/2003: Generate implicit CAN USE SAP authorizations,
#  ### and include these in a union.
#  First, open another cursor.
#
 @stmt = ("select",
           " distinct function_id, kerberos_name",
           " from authorization a",
           " where function_id not in",
           " ($sel_func_id1, $sel_func_id2, $sel_func_id3, $sel_func_id4)",
    #       " $use_sap_func_id)",
           " and function_category = '$function_category'",
           " and a.do_function = 'Y'",
           " and a.effective_date <= sysdate",
           " and nvl(a.expiration_date,sysdate) >= sysdate",
           " union select distinct $use_sap_func_id, kerberos_name",
           " from authorization a, function f",
           " where f.function_id = a.function_id",
           " and f.function_category = 'SAP'",
           " and f.function_name not in ('INVOICE APPROVAL UNLIMITED', ",
           "    'TRAVEL DOCUMENTS APPROVAL', 'MAINTAIN ALL NOTIFY PREFS',",
           "    'MAINTAIN NOTIFY PREFS FOR DEPT')",
           " and a.do_function = 'Y'",
           " and sysdate between a.effective_date and",
           " nvl(a.expiration_date,sysdate)",
           " order by function_id, kerberos_name");
 print "Opening 5th cursor...\n";
 $csr = &ora_open($lda, "@stmt")
        || die $ora_errstr;

#
#  Read in left-over function set of rows from the authorization table
#
 print "Processing left-over function batch of authorizations from"
       . " Oracle table...\n";
 @auth_temp = ();
 $i = -1;
 while (($func_id, $kerbname) = &ora_fetch($csr)) 
 {
   if (($i++)%5000 == 0) {print $i . "\n";}
   push(@auth_temp, "$func_id\|NA\|NA\|$kerbname");   
 }
 do ora_close($csr) || die "can't close cursor";
 $n = @auth_temp;
 print "Number of auths from left-over function select = $n\n";
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";

#
#  Finally, do a special step to find authorizations applying to the whole
#  qualifier tree.  Look for authorizations where qualifier_id in 
#  ($top_cost_id, $top_fund_id).  Identify these by selecting the
#  inverse (minus) of the qualifier_id.
#
 @stmt = ("select",
           " distinct -function_id, kerberos_name",
           " from authorization a",
           " where function_id in",
           " ($sel_func_id1,  $sel_func_id2,  $sel_func_id3,  $sel_func_id4,",
           "  $sel_func_id5,  $sel_func_id6,  $sel_func_id7,  $sel_func_id8,",
           "  $sel_func_id9,  $sel_func_id10, $sel_func_id11, $sel_func_id12,",
           "  $sel_func_id13, $sel_func_id14, $sel_func_id15, $sel_func_id16,",
           "  $sel_func_id17, $sel_func_id18, $sel_func_id19, $sel_func_id20,",
           "  $sel_func_id21, $sel_func_id22, $sel_func_id23, $sel_func_id24,",
           "  $sel_func_id25, $sel_func_id26, $sel_func_id27, ",
           "  $sel_func_id28, $sel_func_id29, $sel_func_id30, ",
           "  $sel_func_id31, $sel_func_id32, $sel_func_id33, ",
           "  $sel_func_id34, $sel_func_id35, $sel_func_id36, ",
           "  $sel_func_id37, $sel_func_id38, $sel_func_id39, ",
           "  $sel_func_id40, $sel_func_id41, $sel_func_id42, $sel_func_id43,",
           "  $sel_func_id44, $sel_func_id45, $sel_func_id46, $sel_func_id47,",
           "  $sel_func_id48, $sel_func_id49, $sel_func_id50, $sel_func_id51,",
           "  $sel_func_id52, $sel_func_id53, $sel_func_id54, $sel_func_id55,",
           "  $sel_func_id56, $sel_func_id57, $sel_func_id58, $sel_func_id59,",
           "  $sel_func_id60, $sel_func_id61, $sel_func_id62, $sel_func_id63,",
           "  $sel_func_id64, $sel_func_id65, $sel_func_id66, $sel_func_id67,",
           "  $sel_func_id68)",
           " and qualifier_id in ($top_cost_id, $top_fund_id, $top_budg_id,",
           "  $top_lorg_id, $top_org2_id, $top_dept_id, $top_pytg_id)",
           " and a.do_function = 'Y'",
           " and a.effective_date <= sysdate",
           " and nvl(a.expiration_date,sysdate) >= sysdate",
           " order by 1,2");
 print "Opening 6th cursor...\n";
 $csr = &ora_open($lda, "@stmt")
        || die $ora_errstr;

#
#  Read in all-qualifier rows from the authorization table
#
 print "Processing special all-qualifier authorizations from"
       . " Oracle table...\n";
 $i = -1;
 while (($func_id, $kerbname) = &ora_fetch($csr))
 {
   if (($i++)%1000 == 0) {print $i . "\n";}
   push(@auth_temp, "$func_id\|NA\|NA\|$kerbname");   
 }
 do ora_close($csr) || die "can't close cursor";
 $n = @auth_temp - $n;
 print "Number of all-qualifier authorizations = $n\n";
 $elapsed_sec = time() - $time0;
 print "Elapsed time = $elapsed_sec seconds.\n";

#
#  Write the last batch of authorizations to the output file.
#
 for ($i = 0; $i < @auth_temp; $i++) {
   ($func_id, $qc_num, $qc_type, $kerbname)
      = split($delim, $auth_temp[$i]);
   if (! $user_no_sap{$kerbname}) {
     print F2 "$func_id|$qc_num|$qc_type|$kerbname\n";
   }
 }

 close (F2);
 
 do ora_logoff($lda) || die "can't log off Oracle";

 exit();

##############################################################################
#
#  Subroutine 
#    &get_function_info($function_category, \%fid_to_name, \%fname_to_id)
#
#  Reads function_id and function_name info from the Roles DB FUNCTION
#  table.
#
##############################################################################
sub get_function_info {

 my ($lda, $function_category, $rfid_to_name, $rfname_to_id) = @_; # Get parms.
 my ($db, $user, $pw, $userpw);

 #
 #  Open a cursor to read in Function information from the Function
 #  table in the Roles DB.
 #
  @stmt = ("select f.function_id, f.function_name"
           . " from function f"
           . " where f.function_category = '$function_category'");
  $csr = &ora_open($lda, "@stmt")
         || die $ora_errstr;
  print "Reading in Functions (category = '$function_category') from"
        . " Oracle table...\n";
  while (($fid, $fname) = &ora_fetch($csr))
  {
    $fid_to_name{$fid} = $fname;
    $fname_to_id{$fname} = $fid;
    #print "$fid -> $fname\n";
  }
  &ora_close($csr) || die "can't close cursor";

}

