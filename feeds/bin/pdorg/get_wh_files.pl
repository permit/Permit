#!/usr/bin/perl -I/usr/users/rolesdb/lib/cpa
########################################################################
#
#  Use FTP find these files on the Warehouse
#   wh-hrp1000, wh-hrp1001, wh-hrp1208
#  If the dates of these files on the warehouse are newer than the 
#   dates on the local copies of the files, get new copies from 
#   the warehouse and write out the file "wh-hrp.date" with the
#   date/time stamp of the files from the warehouse.
#
#  Copyright (C) 2000-2010 Massachusetts Institute of Technology
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
#
#  Modified 7/6/2000
#  Modified 2/22/2001 (fix problem with last-year's date with no year)
#  Modified 7/23/2002 (fix date problem, again)
#
########################################################################
$datafile_dir = $ENV{"PDORG_DATADIR"};
$pdorg_date = $datafile_dir . 'pdorg_ftp.date';

#
# Get packages
#
use config('GetValue');  # Use the subroutine GetValue in config.pm

#
#  Get FTP parameters
#
 my $ftp_parm = GetValue("ftpwarehouse");
 $ftp_parm =~ m/^(.*)\/(.*)\@(.*)$/;
 my $user_id = $1;
 my $user_pw = $2;
 my $ftp_machine = $3;
 #print "user_id = '$user_id' ftp_machine='$ftp_machine'\n";

#
#  Get dates of FTP files.
#
 $ftp_date = &GetFTPDate($user_id, $user_pw, $ftp_machine, $datafile_dir);
 print "FTP File date = $ftp_date\n";

#
#  Get dates of local files.
#
 $local_date = &GetLocalDate($datafile_dir);
 print "Local File date = $local_date\n";

#
#  If FTP date is later than local date, get new copies of the files
#  and write the file $pdorg_date
#
 if ($ftp_date > $local_date) {
   &FTPFromWarehouse($user_id, $user_pw, $ftp_machine, $datafile_dir);
   system("echo $ftp_date > $pdorg_date");
   exit(1);
 }
 else {
   print "Local files are more recent than files on warehouse.\n";
   exit(2);
 }

exit();

#############################################################################
#
#  Get dates of local hrp100x files
#
#############################################################################

sub GetLocalDate
{

 my($data_dir) = @_;
 $ls_results = $data_dir . 'ls.results';
 #print "ls_results = '$ls_results'\n";
 #my(@files) = ('wh-hrp1000', 'wh-hrp1001', 'wh-hrp1208'); 
 my(@files) = ('wh-hrp1000', 'wh-hrp1208'); 
my $file;

#
#  Run ls command to get file information
#
 system ("ls -l $data_dir > $ls_results");
 
#
#  Read in ls command results to find file dates.
#
 my ($ls_line, $ls_date);
 chomp (my $current_date = `date '+%Y%m%d%H%M'`);
 my $min_date = $current_date;
 foreach $file (@files) {
   chomp ($ls_line = `egrep ' $file\$' $ls_results`); # Changed 7/6/2000
   #print "ls_line  = '$ls_line'\n";
   $ls_date = '000000000000';
   if ($ls_line =~ /^.{40,41} (.{12})/) {
     $ls_date = $1;
   }
   #print "date=$ls_date\n";
   unless ($ls_date eq '000000000000') {
     $ls_date = &convert_date($ls_date);
   }
   #print "$ls_date\n";
   $min_date = ($ls_date < $min_date) ? $ls_date : $min_date;
 }
 print "min_date = $min_date current_date=$current_date\n";
 $min_date = ($min_date eq $current_date) ? '000000000000' : $min_date;
 return $min_date;

}

#############################################################################
#
#  Use FTP to get dates of hrp100x files from the Warehouse
#
#############################################################################

sub GetFTPDate
{

 my($user_id, $user_pw, $ftp_machine, $data_dir) = @_;
 print "data_dir = $data_dir\n";
 my $ftp_results = $data_dir . "ftp.results";
# my(@files) = ('wh-hrp1000', 'wh-hrp1001', 'wh-hrp1208'); 
 my(@files) = ('wh-hrp1000', 'wh-hrp1208');
 my $file;
 
#
#  Run FTP
#
 open (FTP, "|ftp -n -v $ftp_machine > $ftp_results\n");
 print FTP "user $user_id $user_pw\n";

 print FTP "lcd $data_dir\n";
 print FTP "ls -l\n";
 print FTP "quit\n";
 close (FTP);

#
#  Read in $ftp_results to find file dates.
#
 my ($ls_line, $ls_date);
 chomp (my $min_date = `date '+%Y%m%d%H%M'`);
 #print "min_date = '$min_date'\n";
 foreach $file (@files) {
   chomp ($ls_line = `egrep ' $file\$' $ftp_results`); # Changed 7/6/2000
   print "$ls_line\n";
   $ls_date = '999999999999';
   if ($ls_line =~ /^.{42,43} (.{12})/) {
     $ls_date = $1;
   }
   print "date=$ls_date\n";
   unless ($ls_date eq '999999999999') {
     $ls_date = &convert_date($ls_date);
   }
   #print "$ls_date\n";
   $min_date = ($ls_date < $min_date) ? $ls_date : $min_date;
 }
 return $min_date;

}

#############################################################################
#
#  Use FTP to get hrp100x files from the Warehouse
#
#############################################################################

sub FTPFromWarehouse
{

 my($user_id, $user_pw, $ftp_machine, $data_dir) = @_;

# my(@files) = ('wh-hrp1000', 'wh-hrp1001', 'wh-hrp1208'); 
  my(@files) = ('wh-hrp1000', 'wh-hrp1208'); 
#
#  Run FTP
#
 open (FTP, "|ftp -n -v $ftp_machine\n");
 print FTP "user $user_id $user_pw\n";

 print FTP "lcd $data_dir\n";
 #print FTP "ls -l\n";
 for ($i = 0; $i < @files; $i++) {
   print FTP "get $files[$i]\n";
 }
 print FTP "quit\n";
 close (FTP);
 print "\nFTP completed.\n";

}


#############################################################################
#
#  Function convert_date
#  
#  Convert date from the ls command to the format yyyymmddhhmm.
#
#
#############################################################################

sub convert_date
{

 my($indate) = @_;
 my $month_list = "[Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec]";
 $month_list = '.{3}';
 my %month_to_number = (
   'Jan' => '01',
   'Feb' => '02',
   'Mar' => '03',
   'Apr' => '04',
   'May' => '05',
   'Jun' => '06',
   'Jul' => '07',
   'Aug' => '08',
   'Sep' => '09',
   'Oct' => '10',
   'Nov' => '11',
   'Dec' => '12' 
 );    
 my ($month, $day, $year, $time);
       
 #print "indate='$indate'\n";
 if ($indate =~  # Mon nn hh:mm
     /^($month_list) ([0-9 ]{2}) ([0-9]{2}\:[0-9]{2})/) {
   $month = $1;
   $day = $2;
   $time = $3;
   $month = $month_to_number{$1};
   $day =~ s/ /0/;
   chomp($year = `date '+%Y'`);
   $time =~ s/://;
   ### Patch ###
   my $current_month_day;
   chomp($current_month_day = `date '+%m%d'`);
   if ("$month$day" gt $current_month_day) {  
     $year--;
   }
   ### End of patch ###
   return $year . $month . $day . $time;
 }     
 elsif ($indate =~  # Mon nn  yyyy
     /^($month_list) ([0-9 ]{2})  ([0-9]{4})/) {
   $month = $1;
   $day = $2;
   $year = $3;
   $month = $month_to_number{$1};
   $day =~ s/ /0/;
   $time = '0000';
   return $year . $month . $day . $time;
 }
 else {
   return "000000000000";
 }
}  
