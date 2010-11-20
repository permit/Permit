#!/usr/bin/perl -I/usr/users/rolesdb/lib/cpa -I/usr/users/rolesdb/bin/roles_feed
##############################################################################
#
#  Move the Roles -> SAP feed files to the SAP machine using scp.
#
#
#  Copyright (C) 1999-2010 Massachusetts Institute of Technology
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
#  Jim Repa, 5/6/1999
#  Modified, 1/21/2000 Add a diagnostic print statement to debug 'ls' 
#                      error "arg list too long"
#  Modified, 1/24/2000 Circumvent argument overflow in 'ls' command for
#                       'ls /usr/users/rolesdb/xsap_feed/*.*'
#  Modified, 2/3/2000  Add options to SCP command so that it will work from
#                       a cron job.
#  Modified, 6/2/2010  Added $scp_program so that a different version than the default can be called. 
#						Removed use of $identity_file and $scp_options (pbh)
# 
##############################################################################
#
#  Set some constants
#
 $scp_parm = 'scptosap';
 $days_to_keep = 10;  # How many days worth of files to we keep before erasing?
 $datadir = $ENV{"ROLES_HOMEDIR"} . "/xsap_feed/data/";
 $archivedir = $ENV{"ROLES_HOMEDIR"} . "/xsap_feed/archive/";
 $remotedir = ".";  # No need to change directory after connection
# $identity_file = $ENV{"ROLES_HOMEDIR"} . "/.ssh/identity";
# $scp_options = "-o 'IdentityFile $identity_file'";
 $scp_program = "/opt/MITOpenSSH/bin/scp"; #location of current scp on Roles production

#
# Get packages
#
 use config('GetValue');  # Use the subroutine GetValue in ~/lib/cpa/config.pm
#use roles_base('ArchiveFile'); # ArchiveFile in ~/bin/roles_feed/roles_base.pm
 use sap_feed('GetSequence');  # Use the subroutine GetSequence in sap_feed.pm
 use sap_feed('TransformFilename'); # Use TransformFilename in sap_feed.pm

#
# Get the current sequence number and calculate the earliest sequence number
# for files that we want to keep.
#
 $seqno = &GetSequence();
 $keep_seqno = $seqno - $days_to_keep + 1;
 print "Current seqno = $seqno -- oldest seqno to keep = $keep_seqno\n";

#
#  Get username and host for SCP command
#
 $temp = &GetValue($scp_parm);
 $temp =~ m/^(.*)\@(.*)$/;
 $user  = $1;
 $host = $2; 

#
#  Find a list of files that we want to transfer.
#
 opendir(DIR, $datadir) or die "can't opendir $datadir: $!";
 my @files = grep { /^r2s.*\.$seqno/ } readdir(DIR); # Find pertinent files
 closedir(DIR);

#
#  Use the SCP command to transfer all files except the interface file
#
 my ($filename, $newname);
 foreach $filename (sort @files) {
   if (! ($filename =~ /^r2sintrf/) ) {
     $newname = &TransformFilename($filename);
     print "$filename -> $newname\n";
     $scpcmd = "$scp_program"
               . " ${datadir}$filename $user\@$host:$remotedir/$newname";
     #print "$scpcmd\n";
     ($rc = system($scpcmd))
      && die "Error " . $rc/256 . " (" . $rc . ") scp command for $filename\n";
   }
 }

#
#  Use the SCP command to transfer the interface file
#
 foreach $filename (sort @files) {
   if ($filename =~ /^r2sintrf/) {
     $newname = &TransformFilename($filename);
     print "$filename -> $newname\n";
     $scpcmd = "$scp_program"
               . " ${datadir}$filename $user\@$host:$remotedir/$newname";
     #print "$scpcmd\n";
     ($rc = system($scpcmd))
      && die "Error " . $rc/256 . " (" . $rc . ") scp command for $filename\n";
   }
 }

#
#  Call &cleanup_old_files to archive or erase old files in the 
#  ~/sap_feed/data directory.  Also, build a list of files on the
#  FTP disk that should be erased.
#
 &cleanup_old_files($keep_seqno, $datadir, $archivedir);

 exit();

##############################################################################
#
#  Subroutine cleanup_old_files 
#    ($keep_seqno, $datadir, $archivedir)
#
#  Where $keep_seqno is a number in nnnnnnnn format.  Files with names
#                    of the form *.nnnnnnnn where nnnnnnnn < $keep_seqno
#                    are erased or archived
#        $datadir    is the directory to look for files for archiving
#        $archivedir is the directory where files are archived
#  Find out what files need to be archived or erased. For files to be
#  archived, call &ArchiveFile to compress and move them to the archive 
#  directory.
#  ***** Note:  No archiving is currently done, just erasing.
#
##############################################################################

 sub cleanup_old_files {
   my ($keep_seqno, $datadir, $archivedir) = @_;
   $keep_seqno = substr('00000000' . $keep_seqno, -8);  # Add leading zeroes
   my @keep_file =
     qw(r2sauth r2scont r2sdmapl r2slock r2snewu r2sprof r2sumap sap1.changes);
   my @erase_file = 
      qw(r2sintrf sap1.out umap1.temp umap1.deltemp user1.out sap1.out);
   my (@filelist, @filelist2, $file_seqno, $filestem, $n, $fname);

   #print "keep_seqno = $keep_seqno\n";
   #print "datadir = $datadir\n";
   #print "archivedir = $archivedir\n";

 #
 #  Find all files that match *.nnnnnnnn
 #
  #$filestem = $datadir . '*.*';  # This breaks ls command - too many args.
  $filestem = $datadir;  # This fixes it
  #print "The ls statement is: "
  #      . "\"ls $filestem | egrep '.*\.[0-9]{8}\$'\"\n";
  open(LS, "ls $filestem" . 
            " | egrep '.*\.[0-9]{8}\$' |");
  chomp(@filelist = <LS>);
  close(LS);
  $n = length($datadir);
  grep{$_ = substr($_,$n)} @filelist;  # Strip off directory name

 #
 #  Find all files that match patterns in @keep_file.  Archive them.
 #  Find all files that match patterns in @erase_file.  Erase them.
 #
  foreach $fname (@filelist) {
    $file_seqno = substr($fname, -8, 8); # Get nnnnnnnn part of $fname
    #print "filedate = $filedate\n";
    if ($file_seqno le $keep_seqno) {
      foreach $filestem (@erase_file) {
        if ($fname =~ /^$filestem/) {
          system("rm $datadir" . $fname)
        }
      }
      foreach $filestem (@keep_file) {
        if ($fname =~ /^$filestem/) {
          #&ArchiveFile($datadir . $fname, $archivedir);
        }
      }
    }
  }
 } 






