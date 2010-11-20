#!/usr/bin/perl
##############################################################################
#
#  Find old files in the /xsap_feed/data directory.  Delete them.
#
#  Set $keep_extracts, the number of extract days to keep.
#  Get the current sequence number.  Subtract $keep_extracts from it 
#  (to keep the last $keep_extracts sets of extracts.  Any files of the form 
#      xxxxx.nnnnnnnn 
#            where nnnnnnnn is a number < current_seqno - $keep_extracts
#  should be deleted.
#
#
#  Copyright (C) 2001-2010 Massachusetts Institute of Technology
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
#  Written 10/15/2001, Jim Repa.
#
##############################################################################
#
# Get packages
#
use sap_feed('GetSequence');  # Use the subroutine GetSequence in sap_feed.pm

#
# Set variables
#
$keep_extracts = 225;  # No. of extract versions to keep
$logdir = $ENV{"ROLES_HOMEDIR"} . "/xsap_feed/log/";
$bindir = $ENV{"ROLES_HOMEDIR"} . "/xsap_feed/bin/";
$datadir = $ENV{"ROLES_HOMEDIR"} . "/xsap_feed/data/";
$seqno = &GetSequence();
$outfile = $datadir . "sap1.out." . $seqno;   # Output file from step 1
$userfile = $datadir . "user1.out." . $seqno; # List of changed users (step 2)

#
#  Get the current sequence no.
#
 $seqno = &GetSequence();
 print "sequence no. is $seqno\n";
 $keep_after = $seqno - $keep_extracts;
 print "Keep $keep_extracts versions of files. "
       . " Delete files with seqno < $keep_after\n";

#
#  Read in a list of files in the data directory.
# 
 open(LS, "ls $datadir|");
 @filelist = <LS>;
 close(LS);

#
#  If file has a seqno < $keep_after, delete it.
#
 foreach $file (@filelist) {
   chomp($file);
   $fullpath = $datadir . $file;
   if ($file =~ /^diffs/) {
     #print "Skip file: $file\n";
   }
   elsif ($file =~ /([0-9]{8})$/) {
     $file_seq = $1 + 0;
     if ($file_seq < $keep_after) {
       print "Delete file $file\n";
       system("rm $fullpath");
     }
     else {
       #print "Keep file $file\n";
     }
   }
   else {
     #print "Skip file: $file\n";
   }
 }

