#!/usr/bin/perl
##############################################################################
#
#  Find the differences in two files of SAP authorization extracts.
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
#  Modified by Jim Repa, 7/8/1998
#  Modified by Jim Repa, 11/4/1998 (Use seq. no. in file names)
#
##############################################################################
#
# Get packages
#
use sap_feed('GetSequence');  # Use the subroutine GetSequence in sap_feed.pm

#
# Set some constants
#
#$datadir = $ENV{"ROLES_HOMEDIR"} . "/sap_feed/data/";
$datadir = $ENV{"ROLES_HOMEDIR"} . "/xsap_feed/data/";
$diff_file = $datadir . "sap1.diffs";  # Diffs betw prev and curr sap1.out file
$temp1 = $datadir . "sap1.temp";
$temp2 = $datadir . "sap2.temp";
$users_file = $datadir . "user1.out";        # Will be user1.out.nnnnnnnn
$newusers_file = $datadir . "r2snewu";       # Will be r2snewu.nnnnnnnn
$user_sap_file = $datadir . "sap1.changes";  # Will be sap1.changes.nnnnnnnn

#
#  Get the newest sequence number.  Subtract 1 to get previous one.
#  Make sure both files exist.
#
$seqno = &GetSequence();
$prevno = substr('00000000' . ($seqno-1), -8, 8);
#print "Current sequence number is $seqno.  Previous seq. no. was $prevno.\n";
$newfile = $datadir . 'sap1.out.' . $seqno;   # Current sap1.out file
$oldfile = $datadir . 'sap1.out.' . $prevno;  # Previous sap1.out file
print "oldfile = $oldfile\nnewfile = $newfile\n";
unless (-r $oldfile) {die "Can't read previous file '$oldfile'\n";}
unless (-r $newfile) {die "Can't read current file '$newfile'\n";}

#
#  Add new sequence number to file names.
#
$users_file .= ".$seqno";
$newusers_file .= ".$seqno";
$user_sap_file .= ".$seqno";

#
#  Find users who have SAP authorizations for the first time (according
#  to our comparison with yesterday's file), and who may need to be 
#  created for the first time in SAP.
#
#  Extract just the 4th token (username), ...
#
print "Looking for new usernames...\n";
system("cut -d'|' -f4 $oldfile \| sort -u > $temp1\n"); #Find old uniq. users
system("cut -d'|' -f4 $newfile \| sort -u > $temp2\n"); #Find new uniq. users
system("echo '** New users' > $newusers_file\n");
system("diff $temp1 $temp2 |"            # Find differences in two files
       . " grep '^>' |"                  # Select only new lines
       . " cut -c3-"                     # Remove '> ' from beginning of lines
       . " >> $newusers_file");
system("rm $temp1\n");
system("rm $temp2\n");

#
#  Sort the old and new files.  Also, reformat to remove the 5th token (parent
#  qualifier_code).
#
print "Sorting first file...\n";
system("cut -d'|' -f1-4 $oldfile \| sort -t '|' -k 4,4 -k 1,3 > $temp1\n");
#system("sort -t '|' -k 4,4 -k 1,3 -o $temp1 $oldfile\n");
print "Sorting 2nd file...\n";
system("cut -d'|' -f1-4 $newfile \| sort -t '|' -k 4,4 -k 1,3 > $temp2\n");
#system("sort -t '|' -k 4,4 -k 1,3 -o $temp2 $newfile\n");
 
#
#  Find differences in the two files.
#  ("grep -v" step removes auths. for cost objects that were presumed to 
#   exist because of matching Fund numbers, but don't exist yet, i.e., 
#   the CC|IO|WB field is blank, so we find '||' in the record.
#
print "Comparing files $oldfile and $newfile...\n";
system("diff $temp1 $temp2 |"            # Find differences in two files
       . " grep '^[><]' |"               # Select only added/deleted lines
       . " grep -v '\|\|' |"             # Remove non-existent cost objects
       . " sort -t '|' -k 4,4 -k 1,1 -k 3,3 -k 2,2"  # Sort on user, function, 
                                                     # qualcode, [<>]
       . " > $diff_file");
system("rm $temp1\n");
system("rm $temp2\n");

print "Finding list of users for which authorizations changed...\n";
system("cat $diff_file | cut -d '|' -f 4 | uniq > $users_file\n");

#
#  Read in $users_file.
#
 unless (open(IN,$users_file)) {
   die "Cannot open $users_file for reading\n"
 }
 %userlist = ();  # Keep a hash of usersa
 $n = 0;
 while (chop($line = <IN>)) {
   #push(@user, $line);
   $n++;
   $userlist{$line} = 1;
 }
 #$n = @user;
 print "$n users found\n";
 close(IN);

#
#  Now, find all the lines in $newfile relating to these users (improved
#  algorithm).
#
 if (-e $user_sap_file) {system("rm $user_sap_file\n");}
 print "Finding authorizations for users and writing to $user_sap_file...\n";
 unless (open(IN,$newfile)) {
   die "Cannot open $newfile for reading\n"
 }
 unless (open(OUT,">$user_sap_file")) {
   die "Cannot open $user_sap_file for writing\n";
 }
 while (chop($line = <IN>)) {
   $line =~ m/^([^\|]*)\|([^\|]*)\|([^\|]*)\|([^\|]*)/;
   $username = $4;
   #print "username='$username'\n"; 
   if ($userlist{$username}) {
     print OUT $line . "\n";   #push(@user, $line);
   }
 }
 close(IN);
 close(OUT);
 
 exit();
 
 
