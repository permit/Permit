#!/usr/bin/perl
##############################################################################
#
#  Find a list of usernames in the first file
#  Extract all records applying to those usernames from a 2nd file
#
#  This is a version of the Perl script that looks for the usernames in the
#  4th '|'-delimited field in the 2nd file.
#  The first file contains a list of usernames in c.c. 1-8.
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
#  Written:  Jim Repa, 6/24/1998
#  Modified: Jim Repa, 10/05/1998  Use seqno rather than date in filenames.
##############################################################################
#
# Get packages
#
use sap_feed('GetSequence');  # Use the subroutine GetSequence in sap_feed.pm

#
# Set some constants
#
$datadir = $ENV{"ROLES_HOMEDIR"} . "/xsap_feed/data/";
$seqno = &GetSequence();
$first_file = $datadir . "user1.out." . $seqno;
$second_file = $datadir . "sap1.out." . $seqno;
$result_file = $datadir . "sap1.changes." . $seqno;
$file1_user_cc = 0;  # Start col. of username in 1st file (start at 0)
$file1_user_len = 8; # Length of username in 1st file

#
#  Read an array of usernames from the first file.
#
 unless (open(IN1,$first_file)) {
   die "Cannot open $first_file for reading\n"
 }
 %userlist = ();
 while (chomp($line = <IN1>)) {
   $user = substr($line, $file1_user_cc, $file1_user_len);
   $user = &strip($user);
   $userlist{$user} = 1;
 }
 close(IN1);
 #foreach $key (sort keys(%userlist)) {
 #  print $key . "\n";
 #}

#
#  Read in 2nd file, and output lines that match the usernames from
#  the first file.
#
 unless (open(IN2,$second_file)) {
   die "Cannot open $second_file for reading\n"
 }
 unless (open(OUT,">$result_file")) {
   die "Cannot open $result_file for writing\n"
 }
 while (chomp($line = <IN2>)) {
   ($t1, $t2, $t3, $user, $t5) = split('\|', $line);
   #print "Line='$line'\nUser='$user'\n";
   if ($userlist{$user} == 1) {
     print OUT $line . "\n";
   }
 }
 close(IN2);
 close(OUT);


 exit();
 
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





