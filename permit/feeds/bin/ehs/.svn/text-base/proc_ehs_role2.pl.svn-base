#!/usr/bin/perl  -I/usr/users/rolesdb/lib/cpa/
##############################################################################
#
#  Get EHS-related DLC-level role information in SAP from Warehouse
#  tables.
#
#
#  Copyright (C) 2004-2010 Massachusetts Institute of Technology
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
#  Written 9/15/2004, Jim Repa.
#  Modified 7/19/2007, Jim Repa.  Add qualifier-less roles
#
##############################################################################
#
# Get packages
#
use config('GetValue');  # Use the subroutine GetValue in ~/lib/cpa/config.pm

#
#  Make sure we are set up to use Oraperl.
#
use DBI;
use Oraperl;
if (!(defined(&ora_login))) {die "Cannot find ora_login in Oraperl/DBI"
                             . "modules\n";}

#
#  Set some variables
#
 #$dbname = "testwarehouse";  # Pointer in config file to a database
 $dbname = @ARGV[0]; 
 print "dbname='$dbname'\n";
 $datafile_dir = $ENV{'EHS_DATADIR'};
 $program_dir = $ENV{'EHS_PROGDIR'};
 $mapping_file = "saprole2function.mapping";
 $delim = "!!"; # Internal delimiter for use within this program
 $delim2 = "\|";  # External delimiter for output file

#
#
#
 &process_warehouse_data();
 $lda->disconnect;

 exit();

##############################################################################
#
#  Subroutine to process the data from Warehouse on DLC-level 
#  Work Areas from SAP
#
##############################################################################
sub process_warehouse_data {

 my $out_dlc_role_file = $datafile_dir . "/" . "ehs_dlc_role.sap";
 my $out_dlc_work_area = $datafile_dir . "/" . "dlc_to_workarea.dat";
 my $inputmap = $program_dir . "/" . $mapping_file;

 #
 #  Get username and password for connecting to the Warehouse.
 #
  my $db_parm = GetValue($dbname);
  $db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
  my $user = $1;
  my $pw = $2;
  my $db = $3;
  print "db=$db user=$user\n";

 #
 #  Connect to the Warehouse
 #
  my $lda = &login_sql($dbname)
	|| die $ora_errstr;

 #
 #  Open a cursor for a select statement
 #
  my $stmt =
  "select wa.dlc_code, wa.dlc_name, wa.work_area_id, 
        upper(fd.krb_name), fd.personnel_key, f.ehss_function_code
   from wareuser.whehss_work_area wa, wareuser.whehss_function_detail fd,
        wareuser.whehss_function f
   where wa.work_area_type = 'DL'
   and sysdate between wa.valid_from_date-1 and wa.valid_to_date+1
   and work_area_status_code = 'AC'
   and fd.work_area_id(+) = wa.work_area_id
   and f.ehss_function_key(+) = fd.ehss_function_key
   union select nvl(wa.dlc_code, 'NULL'), nvl(wa.dlc_name, 'N/A'),
        wa.work_area_id, 
        upper(fd.krb_name), fd.personnel_key, 
        nvl(f.ehss_function_code, substr(fd.ehss_function_key, 2, 3))
   from wareuser.whehss_work_area wa, wareuser.whehss_function_detail fd,
        wareuser.whehss_function f
   where wa.work_area_type = 'EH'
   and sysdate between wa.valid_from_date-1 and wa.valid_to_date+1
   and work_area_status_code = 'AC'
   and fd.work_area_id(+) = wa.work_area_id
   and f.ehss_function_key(+) = fd.ehss_function_key   order by 3, 5, 6";
  my $csr = &ora_open($lda, $stmt)
         || die $ora_errstr;

 #
 #   Open output files.
 #
   my $outf = ">$out_dlc_role_file";
   if( !open(F1, $outf) ) {
     die "$0: can't open ($outf) - $!\n";
   }
   my $outf2 = ">$out_dlc_work_area";
   if( !open(F2, $outf2) ) {
     die "$0: can't open ($out2) - $!\n";
   }

 #
 #   Open the task-to-function mapping file.
 #   Read each record.  Build hash %taskname_to_function (Maps a task name
 #     in the PD Org to the Roles DB Function name for each approver task)
 #
  unless (open(MAP,$inputmap)) {
    die "Cannot open $inputmap for reading\n"
  }
  my $line;
  my %taskname_to_function;
  my ($task1, $func1);
  while (chop($line = <MAP>)) {
    ($task1, $func1) = split('!', $line);
    $taskname_to_function{$task1} = $func1;
    #print "task '$task1' -> function '$func1'\n";
  }
  close(MAP);

 #
 #   Read each record from the select statement.  Write records to the
 #   DLC role file.
 #
 my ($dlc_code, $dlc_name, $wa_id, $kerbname, $pernr, $function_code);
 my %dlc2work_area = ();
 my %dlc2name = ();
 my %work_area2dlc = ();
 my %work_area2name = ();
 my $rec_no = 0;

 while ( ($dlc_code, $dlc_name, $wa_id, $kerbname, $pernr, $function_code)
          = &ora_fetch($csr) ) 
 {
     #print "'$function_code' : '$wa_id' : '$pernr' : '$dlc_code'"
     #      . " : '$kerbname' : '$dlc_name'\n";
     if ($dlc_code) {
       $dlc2work_area{$dlc_code} = $wa_id;
       $dlc2name{$dlc_code} = $dlc_name;
     }
     if ($wa_id) {
       $work_area2dlc{$wa_id} = $dlc_code;
       $work_area2name{$wa_id} = $dlc_name;
     }
     if ($function_code) {
       print F1 "$function_code$delim2$wa_id$delim2$pernr$delim2"
                . "$dlc_code$delim2$kerbname\n";
     }
     $rec_no++;
 }
 &ora_close($csr) || die "can't close cursor";


#
#  Write out the DLC to Work Area mapping file.
#
 #foreach $dlc_code (sort keys %dlc2work_area) {
 #  $wa_id = $dlc2work_area{$dlc_code};
 #  $dlc_name = $dlc2name{$dlc_code};
 #  print "DLC '$dlc_code' -> Work Area '$wa_id' name '$dlc_name'\n";
 #  print F2 "$dlc_code$delim2$wa_id$delim2$dlc_name\n";
 #}
 foreach $wa_id (sort keys %work_area2dlc) {
   $dlc_code = $work_area2dlc{$wa_id};
   $dlc_name = $work_area2name{$wa_id};
   #print "Work Area '$wa_id' -> DLC '$dlc_code'name '$dlc_name'\n";
   print F2 "$dlc_code$delim2$wa_id$delim2$dlc_name\n";
 }

 close(F1);
 close(F2);
 &ora_logoff($lda);
 return();

}
########################################################################
#
#  Strips off trailing <cr> and leading and trailing blanks.
#
###########################################################################
sub strip {
  local($s);  #temporary string
  $s = $_[0];
  while ($s =~ /[\s\n]$/) {   # Remove trailing <cr> or space
    chop($s);
  }
  while (substr($s,0,1) =~ /^\s/) {
    $s = substr($s,1);
  }
 
  $s;
}

##############################################################################
#
# Subroutine login_sql($symbolic_db_name)
#
# Look up the symbolic database name in dbweb.config and
# get (db, username, pw).  Use this to login to an Oracle database.  Try
# up to 3 times.
#
##############################################################################
sub login_sql 
{
	my ($db_symbol) = @_;
        my $db_parm = GetValue($db_symbol);
        $db_parm =~ m/^(.*)\/(.*)\@(.*)$/;
        my $user = $1;
        my $pw = $2;
        my $db = $3;
        #my ($db, $user, $pw)=&get_database_info($db_symbol); #Read conf. file
        for ($i = 0; $i < 3; $i++) {  # Retry 3 times
	    if ($lda = &ora_login($db, $user, $pw)) {
               return $lda;
	   }
        }
        print "Oracle connect to database '$db' failed after 3 tries.<BR>\n";
        print "$ora_errstr<BR>\n";
        return 0;
}
