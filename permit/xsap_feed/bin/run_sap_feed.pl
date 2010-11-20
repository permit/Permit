#!/usr/bin/perl
##############################################################################
#
#  Run programs associated with Roles DB -> SAP feed
#
#  1.  "sap_extract2.pl" extracts SAP-related authorizations from 
#      the "authorization" table, and writes them to sap1.out.yyyymmdd
#      in the data directory
#  1a. Make sure there are at least 12000 lines in the output file.
#      If not, print an error message.  
#      Make sure there is at least one changed user.
#      Otherwise, put an error message in the  user1.* file, and exit.
#  2.  "compare_sap2.pl" compares the previous authorization extract file
#      with today's extract, and produces a list of users and a file
#      containing all of their SAP-related authorizations
#  2a. If there are no changes, then put a warning message in the user1.*
#      file and exit.
#  3.  Run sapmap2.pl to produce the r2s* files required by Robie's program.
#  4.  Build the control file and increment the sequence number.
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
#  Modified 11/05/1998, Jim Repa.  Use seqno instead of date in file names.
#  Modified 12/30/1998, Jim Repa.  Add step 4.
#
##############################################################################
#
# Get packages
#
use sap_feed('GetSequence');  # Use the subroutine GetSequence in sap_feed.pm
use sap_feed('IncrSequence');  # Use the subroutine IncrSequence in sap_feed.pm

$logdir = $ENV{"ROLES_HOMEDIR"} . "/xsap_feed/log/";
$bindir = $ENV{"ROLES_HOMEDIR"} . "/xsap_feed/bin/";
$datadir = $ENV{"ROLES_HOMEDIR"} . "/xsap_feed/data/";
$seqno = &GetSequence();
$outfile = $datadir . "sap1.out." . $seqno;   # Output file from step 1
$userfile = $datadir . "user1.out." . $seqno; # List of changed users (step 2)
$min_records = 12000; # Should be at least this no. of recs. in step 1 output
$test = 1;

#
#  If test is on, print a message.
#
 if ($test) {print "Test-mode is on\n";}

#
#  Set names of log files
#
$logfile1 = $logdir . "sap_extract_log.$seqno"; 
$logfile2 = $logdir . "sap_compare_log.$seqno"; 
$logfile3 = $logdir . "sap_map_log.$seqno"; 

#
#  If "test" is on, then just print the results to the console.
#  Otherwise, pipe them into a log file.
#
 if (test) {
   $pipeout1 = "";
   $pipeout2 = "";
   $pipeout3 = "";
 }
 else {
   $pipeout1 = " >\& $logfile1";
   $pipeout2 = " >\& $logfile2";
   $pipeout3 = " >\& $logfile3";
 }

#
#  1. Run sap_extract2.pl
#
 print "Starting sap_extract2.pl...\n";
 $rc = system($bindir . "sap_extract2.pl" . $pipeout1) / 256;
 if ($rc != 0) {die "***Error in sap_extract2.pl\n";}

#
#  1a. Make sure there are at least $min_records output records.
#
 chomp($linecount = `grep -c . $outfile`);
 print "Found $linecount lines in file $outfile\n";
 if ($linecount < $min_records) {
   system("echo **** Error: Only $linecount lines in sap1.out.$today file"
          . " > $userfile");
   die "***Found only $linecount lines in $outfile (should be > $min_records)\n"; 
 }

#
#  2. Run compare_sap2a.pl to compare previous and current SAP authorizations
#
 print "Starting compare_sap2a.pl...\n";
 $rc = system($bindir . "compare_sap2a.pl" . $pipeout2) / 256;
 if ($rc != 0) {die "***Error in compare_sap2a.pl\n";}

#
#  2a. If there are no users in the $userfile, then put a warning message
#      in the file, and exit.
#
 chomp($linecount = `grep -c . $userfile`);
 print "Found $linecount lines in file $userfile\n";
 if ($linecount < 1) {
   system("echo **** No authorization changes today"
          . " > $userfile");
   die "***No authorization changes today\n";
 }
 
#
#  3. Run sapmap2.pl to extract r2s*.nnnnnnnn files.
#
 print "Starting sapmap2.pl...\n";
 $rc =  system($bindir . "sapmap2.pl" . $pipeout3) / 256;
 if ($rc != 0) {die "***Error in sapmap2.pl\n";}

#
#  4. Run sap_ctl_file.pl to create control file r2scont.nnnnnnnn.
#
 print "Starting sap_ctl_file.pl...\n";
 $rc =  system($bindir . "sap_ctl_file.pl" . $pipeout3) / 256;
 if ($rc != 0) {die "***Error in sap_ctl_file.pl\n";}

#
#  5. Run move_out_files2.pl to copy files to SAP machine.
#     Then increment the sequence number in the sequence number file.
#
 print "Starting move_out_files2.pl...\n";
 $rc =  system($bindir . "move_out_files2.pl" . $pipeout3) / 256;
 if ($rc != 0) {die "***Error $rc in move_out_files2.pl\n";}
 &IncrSequence();
