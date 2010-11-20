#!/usr/bin/perl
#############################################################################
#
#  Module MDept.pm for editing DLC's.
#  Call through wrapper. provide return page as cgi parameter:
#  $MDept::param_names->{'back_page'}
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
#  Written by Andrey Radul 04/04/04
#  Modified by Jim Repa 06/07/05. Show view_type_desc in parent link type
#                                 legend
#  Modified by Jim Repa 11/29/06. Show 5 extra obj links instead of 2.
#  Modified by Jim Repa 01/25/07. Use object_type table to build list of
#                                 available object types (no longer hard-coded)
#
#############################################################################

package MDept;

use DBI;
use CGI;


use Web('parse_ssl_info');
use Web('check_cert_source');
use Web('parse_ssl_info');
use Web('web_error'); 

use rolesweb('login_dbi_sql');   #Use sub. login_sql in rolesweb.pm
use rolesweb('parse_forms'); #Use sub. parse_forms in rolesweb.pm
use mdeptweb('print_mdept_header'); #Use sub. print_mdept_header in mdeptweb.pm

# Define some hashes so that when retrieving parameters, etc
# We simply need only access these hashes
# Therefore, these hashes is the only "hard coded" material (or most of it)

use constant ID     => 0;
use constant SHORT_NAME   => 1;
use constant NAME    => 2;
use constant START_DATE   => 3;
use constant END_DATE  => 4;

use constant ID_LEN => 12;
use constant SHORT_LEN => 20;
use constant MAXLEN => 50;

use constant DISPLAY_NOTHING => "";
use constant DISPLAY_NOTHING_LABEL => "N/A"; ## For children menu
use constant ORDER_CERT_TYPE => "CERT_ID";
use constant DATE_FORMAT => "mm/dd/yy"; ## check_date
use constant CHILD_CELLS_IN_A_ROW => 3;

$g_delim1 = '!!';

### Help URL ### TODO check if needed
my $host = $ENV{'HTTP_HOST'};

##########################################

$main_url = "http://$host/webroles.html";

## TODO remove hardcoded $g_owner?

$g_owner = 'mdept$owner';
$delim1 = '!';
###########################



################
## Button Name => button value ###
$buttons = {
    'add_dlc'    => 'Add a New DLC',
    'edit_dlc'   => 'Edit Existing DLC',
    'edit_obj_link'   => 'Edit Object Links',
    'commit_dlc' => 'Commit New DLC',
    'change_dlc' => 'Update Existing DLC',
    'delete_dlc' => 'Delete DLC',
    'cancel_dlc' => 'Back To the Main Page',
    'cancel_obj_link' => 'Back To the Main Page',
    'commit_obj_link' => 'Update Object Links',
};

$param_names = {
    'view_type' => 'view_type',
    'show_link_name' => 'show_link_name',
    'dlc_id' => 'dlc_id',
    'dlc_code' => 'dlc_code',
    'short_name' => 'dlc_short_name',
    'name' => 'dlc_long_name',
    'dlc_type'  => 'dlc_type',
    'parent_dlc_codes'  => 'parent_dlc_codes',
    'parent_dlc_types' => 'parent_dlc_types',
    'link_object_types' => 'link_object_types',
    'link_object_codes' => 'link_object_codes',
    'link_object_names' => 'link_object_names',
    'back_page' => 'dlc_return_page',
};
###################################################
sub main {

 my $cgi = new CGI;
 print $cgi->header("text/html");

 $g_user = cert_check();  # Set global variable

 if ( my $user = $g_user ) {
    
    #For connecting with Oracles
    ### TODO: check possibility to change 
    ### user into mdept
    my $lda = &login_dbi_sql('mdept');
    if(!$lda ) { 
	# print $cgi->header();
	&web_error("Oracle error in login to EHS database. "
		      . "The database may be shut down temporarily" 
		      . "<BR><BR>" . $ora_errstr);
    }
    if ( auth_check($lda, $user) ) {

        my $back_page = $cgi->param($param_names->{'back_page'});

	if ( $cgi->param('add_dlc') ) {

            my %params = ();
            $params{-lda} = $lda;
            $params{-cgi} = $cgi;
            get_cgi_params($cgi, \%params);
                
	    generate_add_page(\%params);

            print $cgi->end_html, "\n";
            $lda->disconnect;
	    exit(0);
        }elsif ( $cgi->param('edit_dlc') ) {


            my %params = ();
            $params{-lda} = $lda;
            $params{-cgi} = $cgi;
      
            get_cgi_params($cgi, \%params);

            generate_edit_page(\%params);

            print $cgi->end_html, "\n";
            $lda->disconnect;
	    exit(0);

	}elsif ( $cgi->param('edit_obj_link') ) {

            my %params = ();
            $params{-lda} = $lda;
            $params{-cgi} = $cgi;

            get_cgi_params($cgi, \%params);

            #print "Here 3<BR>";
            #print_params_test(\%params);
            generate_edit_obj_link_page(\%params);

            print $cgi->end_html, "\n";
            $lda->disconnect;
	    exit(0);

	}elsif ( $cgi->param('delete_dlc') ) {
	    
	    my $error;
            my %params = ();
            $params{-lda} = $lda;
            $params{-cgi} = $cgi;

            get_cgi_params($cgi, \%params);

	    $error = delete_dept(\%params);
	    if ( $error ) {
                print $cgi->start_html;
                print "<p> <font color=red> $error \n</font>";
                generate_edit_page(\%params);
                $lda->rollback;
                $lda->disconnect;
                print $cgi->end_html, "\n";
		exit(0);
	    }
	    
	    $lda->commit;
            my %params_dd = ();
            $params_dd{-lda} = $lda;
            $params_dd{-cgi} = $cgi;
            
            $params_dd{-view_type} = $params{-view_type};
	    generate_default_page(\%params_dd);
	}else {
            

	    if ( $cgi->param('commit_dlc') ) {

                my %params = ();
                $params{-lda} = $lda;
                $params{-cgi} = $cgi;
                get_cgi_params($cgi, \%params);

                my $error = add_dlc(\%params);

		if ( $error ) {

                    print $cgi->start_html;
                    $params{-error} = $error;
		    generate_add_page(\%params);
                    print $cgi->end_html, "\n";
                    $lda->rollback;
                    $lda->disconnect;
		    exit(0);
		}

		$lda->commit();
                my %params_a = ();
                $params_a{-lda} = $lda;
                $params_a{-cgi} = $cgi;
                $params_a{-view_type} = $params{-view_type};
                $params_a{-dlc_id} = $params{-dlc_id};
                print $cgi->start_html;
                generate_edit_page(\%params_a);
                print $cgi->end_html, "\n";
		$lda->disconnect;
                exit(0);
	    } elsif ( $cgi->param('change_dlc') ) {

                #$params{-user} = $user;  NEVER DEPEND ON PARAMETER FOR USER!!!
                my %params = ();
                $params{-lda} = $lda;
                $params{-cgi} = $cgi;
                get_cgi_params($cgi, \%params);

                my $error = update_dlc(\%params);

		if ( $error ) {
                    print $cgi->start_html;
                    $params{-error} = $error;
                    generate_edit_page(\%params);
                    print $cgi->end_html, "\n";
                    $lda->rollback;
                    $lda->disconnect;
		    exit(0);
		}
                $lda->commit();
                my %params_ed = ();
                $params_ed{-lda} = $lda;
                $params_ed{-cgi} = $cgi;
                get_cgi_params($cgi, \%params_ed);
                print $cgi->start_html;
                generate_edit_page(\%params_ed);
                print $cgi->end_html, "\n";
		$lda->disconnect;
                exit(0);
	    } elsif ( $cgi->param('commit_obj_link') ) {

                #$params{-user} = $user;  NEVER DEPEND ON PARAMETER FOR USER!!!
                my %params = ();
                $params{-lda} = $lda;
                $params{-cgi} = $cgi;
                get_cgi_params($cgi, \%params);

                my $error = update_obj_link(\%params);
		if ( $error ) {
                    print $cgi->start_html;
                    $params{-error} = $error;
                    #print "Here 4<BR>";
                    generate_edit_obj_link_page(\%params);
                    print $cgi->end_html, "\n";
                    $lda->rollback;
                    $lda->disconnect;
		    exit(0);
		}
		
		$lda->commit();
                my %params_ol = ();
                $params_ol{-lda} = $lda;
                $params_ol{-cgi} = $cgi;
                get_cgi_params($cgi, \%params_ol);
                print $cgi->start_html;
                #print "Here 5<BR>";
                generate_edit_obj_link_page(\%params_ol);
                print $cgi->end_html, "\n";
                $lda->disconnect;
                exit(0);
            }

	    #Generates default page if none of the above buttons
	    #or parameters are met
            my %prm = ();
            get_cgi_params($cgi, \%prm);
            my %params_n = ();
            $params_n{-lda} = $lda;
            $params_n{-cgi} = $cgi;
            $params_n{-view_type} = $prm{-view_type};
            # get_cgi_params($cgi, \%params_n);
	    generate_default_page(\%params_n);
	}
      $lda->disconnect;
    } else {
	#print something here for not valid user
        print $cgi->start_html();
	print "Sorry - you are not authorized perform the requested 
               transaction (username='$user').<BR>";
        
    }

  }

  print $cgi->end_html, "\n";
  exit(1);
}
###############################################################################
#
# Small functions
#
###############################################################################
###
sub is_id{
    my($item) = @_;
    if($item =~ m/^\d+$/){return 1;}
    return undef;
}
###
sub get_unique_items {
 
    my ($from_arr, $to_arr) = @_;
    my $el;
    my %present;

    foreach $el (@$from_arr){
      if( defined($el) && !$present{$el} ){
          $present{$el} = 1;
          push @$to_arr, $el;
      }
    }
}
###
sub is_in_arr{
   my($arr, $item) = @_;

   my $el;
   foreach $el (@$arr) {
      if("$el" eq "$item"){ return 1;}
   }
   return undef;
}
###
sub strip_white{
   my($val)=@_;
   $val =~ s/^\s*//o;
   $val =~ s/\s*$//o;
   return $val;
}
###
sub to_display {
    my ($val) = @_;
    $val = strip_white($val);
    return "$val" eq "" ? DISPLAY_NOTHING : $val;
}
###
sub to_internal {
    my ($val) = @_;
    $val = strip_white($val);
    if("$val" eq DISPLAY_NOTHING) {return undef;}
    if("$val" eq ""){return undef;}
    return $val;
}
###
sub check_date {
    my ($val) = @_;
    if(!defined($val) or $val eq "" ) {return 1;}
    return $val =~ m|^\d{1,2}/\d{1,2}/\d{1,2}$|o;
}
###
sub adjust_back_page{
    my($back_page, $cert_id) = @_;

    if(!$back_page){return $back_page;}
    my $separ = "?";
    if($back_page =~ m/\?/){
       $separ = "&";
    }
    return $back_page.$separ."cert_id=$cert_id";
}
###
sub get_cgi_params {
    my ($cgi, $params) = @_;
    #print "In get_cgi_params<BR>";
    $params->{-view_type} = $cgi->param($param_names->{'view_type'});

    $params->{-show_link_name} = $cgi->param($param_names->{'show_link_name'});
    $params->{-dlc_id} = to_internal
      $cgi->param($param_names->{'dlc_id'});

    $params->{-dlc_code} = to_internal
       $cgi->param($param_names->{'dlc_code'});
    # Raise DLC_CODE to uppercase
    $params->{-dlc_code} =~ tr/a-z/A-Z/;

    if (!($params->{-dlc_id})) {
	if ($params->{-dlc_code}) {
            $params->{-dlc_id} = 
		lookup_dlc_id_from_dlc_code($params->{-lda}, 
                                            $params->{-dlc_code});
        }
        else {
	  if ( ($cgi->param('edit_dlc')) || ($cgi->param('edit_obj_link')) ) {
	     print "<font color=\"red\">Error: Missing DLC ID and DLC Code"
                   . "</font><BR>";
	  }
        }
    }

    $params->{-short_name} = to_internal
                         $cgi->param($param_names->{'short_name'});
    $params->{-name} = to_internal 
       $cgi->param($param_names->{'name'});
    $params->{-dlc_type} = to_internal
                         $cgi->param($param_names->{'dlc_type'});

    my @parent_dlc_codes = $cgi->param($param_names->{'parent_dlc_codes'});
    my @parent_dlc_types = $cgi->param($param_names->{'parent_dlc_types'});
    
    $params->{-parent_dlc_codes} = [];
    $params->{-parent_dlc_types} = [];

    my ($pdc, $pdt, $pind, $num_par);
    $num_par = scalar(@parent_dlc_codes);
    for($pind = 0; $pind < $num_par; $pind++){
        $pdc = to_internal($parent_dlc_codes[$pind]);
        $pdt = to_internal($parent_dlc_types[$pind]);
        if($pdc){
	    push @{$params->{-parent_dlc_codes}}, $pdc;
            push @{$params->{-parent_dlc_types}}, $pdt;
        }
    }

    my @link_object_types = $cgi->param($param_names->{'link_object_types'});
    my @link_object_codes = $cgi->param($param_names->{'link_object_codes'});
    my @link_object_names = $cgi->param($param_names->{'link_object_names'});
    
    $params->{-link_object_types} = [];
    $params->{-link_object_codes} = [];
    $params->{-link_object_names} = [];

    my ($lot, $loc, $lon, $lind, $num_lo);
    $num_lo = scalar(@link_object_codes);
    for($lind = 0; $lind < $num_lo; $lind++){
        $lot = to_internal($link_object_types[$lind]);
        $loc = to_internal($link_object_codes[$lind]);
        $lon = to_internal($link_object_names[$lind]);
        #unless ($lon) {$lon = '?';} ## Testing ##
        if($loc){
           push @{$params->{-link_object_types}}, $lot;
           push @{$params->{-link_object_codes}}, $loc;
           push @{$params->{-link_object_names}}, $lon;
        }
    }
    
    $params->{-back_page} = $cgi->param($param_names->{'back_page'});
}
###
sub delete_cgi_params {
    my ($cgi) = @_;

    print $cgi->delete($param_names->{'view_type'});
    print $cgi->delete($param_names->{'view_type_code'});
    print $cgi->delete($param_names->{'dlc_id'});
    print $cgi->delete($param_names->{'dlc_code'});
    print $cgi->delete($param_names->{'short_name'});
    print $cgi->delete($param_names->{'name'});
    print $cgi->delete($param_names->{'dlc_type'});
    print $cgi->delete($param_names->{'parent_dlc_codes'});
    print $cgi->delete($param_names->{'parent_dlc_types'});
    print $cgi->delete($param_names->{'link_object_types'});
    print $cgi->delete($param_names->{'link_object_codes'});
    print $cgi->delete($param_names->{'link_object_names'});
    print $cgi->delete($param_names->{'back_page'});
}
###
sub get_db_error_msg {
    my($lda) = @_;
    my $err = $lda->err;
    my $errstr = $lda->errstr;
 
    $errstr =~ /\: ([^\n]*)/;
 
    my $shorterr = $1;
    $shorterr =~ s/ORA.*?://g;
    if($err) {
      return "Error: $shorterr Error Number $err";
    }
    return undef;
}
### Module specific functions ###
sub update_obj_link{

    my($params) = @_;

    ### Get all variables ###
      ### Generic variables
      my $lda = $params->{-lda};
      my $cgi = $params->{-cgi};
      my $error = $params->{-error};
      my $back_page  =  $params->{-back_page};

      ### Mdept specific variables
      my $view_type = $params->{-view_type};
      my $show_link_name = $params->{-show_link_name};
      my $dlc_id  =  $params->{-dlc_id};
      my $short_name  =  $params->{-short_name};
      my $name  =  $params->{-name};
      my $dlc_type  =  $params->{-dlc_type};

      
    my $p_parent_dlc_codes  =  [];
    my $pdlcc;
    foreach $pdlcc (@{$params->{-parent_dlc_codes}}){
        if($pdlcc){
	   push(@{$p_parent_dlc_codes}, $pdlcc);
        }
    }
    my $p_link_object_types = [];
    my $plot;
    foreach $plot (@{$params->{-link_object_types}}){
	if($plot){
	    push(@{$p_link_object_types},$plot); 
	}
    }
    my $p_link_object_codes = [];
    my $ploc;
    foreach $ploc (@{$params->{-link_object_codes}}){
	if($ploc){
	    push(@{$p_link_object_codes}, $ploc);
	}
    }
    my $p_link_object_names  =  [];
    my $plon;
    foreach $plon (@{$params->{-link_object_names}}){
        if($plon){
	    push(@{$p_link_object_names},$plon); 
	}
    }

    my $user = $g_user;

    ## Get DB information ###
    my $db_link_object_types = [];
    my $db_link_object_codes = [];
    my $db_link_object_names = [];

    #print "Here 77<BR>";
    fill_dlc_objects_from_db($params, $db_link_object_types,
        $db_link_object_codes, $db_link_object_names);

    my $del_link_object_types = [];
    my $del_link_object_codes = [];
    my $del_link_object_names = [];
    my $add_link_object_types = [];
    my $add_link_object_codes = [];
    my $add_link_object_names = [];

    ### Compare updated and existing linked objects ###
    diff_link_obj($params, $db_link_object_types,
     $db_link_object_codes, $db_link_object_names,
     $p_link_object_types,
     $p_link_object_codes, $p_link_object_names,
     $del_link_object_types,
     $del_link_object_codes, $del_link_object_names,
     $add_link_object_types,
     $add_link_object_codes, $add_link_object_names);

    if(!@{$del_link_object_types} and !@{$add_link_object_types}){
        $error = "No changes made";
        return $error;
    }

    my $message;
    ### Deleting linked objects ###
    my $d_num = scalar(@{$del_link_object_types});

    my($d_ind, $d_type, $d_code, $d_name);
    my $d_stmt = ' CALL delete_link_to_object(?,?,?,?,@message) ';
    my $d_csr = $lda->prepare($d_stmt);
    $error = get_db_error_msg($lda);
    if($error){return $error;}
    for($d_ind = 0; $d_ind < $d_num; $d_ind++){
        $d_type = $del_link_object_types->[$d_ind];
        $d_code = $del_link_object_codes->[$d_ind];
        $d_csr->bind_param(1, $user);
        $d_csr->bind_param(2, $dlc_id);
        $d_csr->bind_param(3, $d_type);
        $d_csr->bind_param(4, $d_code);
        #print "Deleting $dlc_id $d_type $d_code<BR>";
        $error = get_db_error_msg($lda);
        if($error){return $error;}
        $d_csr->execute;
        $error = get_db_error_msg($lda);
        if($error){return $error;}
    }
    $d_csr->finish;
    ### Adding linked objects ###
    my $a_num = scalar(@{$add_link_object_types});
    my($a_ind, $a_type, $a_code, $a_name);
    my $a_stmt = ' CALL add_link_to_object(?,?,?,?,@message) ';
    my $a_csr = $lda->prepare($a_stmt);
    $error = get_db_error_msg($lda);
    if($error){return $error;}
    for($a_ind = 0; $a_ind < $a_num; $a_ind++){
        $a_type = $add_link_object_types->[$a_ind];
        $a_code = $add_link_object_codes->[$a_ind];
        $a_csr->bind_param(1,$user);
        $a_csr->bind_param(2,$dlc_id);
        $a_csr->bind_param(3,$a_type);
        $a_csr->bind_param(4,$a_code);
        #print "Adding $dlc_id $a_type $a_code<BR>";
        $error = get_db_error_msg($lda);
        if($error){return $error;}
        $a_csr->execute;
        $error = get_db_error_msg($lda);
        if($error){return $error;}
    }
    $a_csr->finish();
    return $error;
}
###
sub diff_link_obj{
    my($params, $db_link_object_types,
     $db_link_object_codes, $db_link_object_names,
     $p_link_object_types,
     $p_link_object_codes, $p_link_object_names,
     $del_link_object_types,
     $del_link_object_codes, $del_link_object_names,
     $add_link_object_types,
       $add_link_object_codes, $add_link_object_names) = @_;

    my $db_ind;
    my $p_ind;
    my $db_num = scalar(@{$db_link_object_codes});
    my $p_num = scalar(@{$p_link_object_codes});

    my %db_and_p = ();

    my($p_type, $p_code, $p_name);
    my($db_type, $db_code, $db_name);
    my ($p_common_key, $db_common_key);

    ### Common link objects ###
    for($p_ind = 0; $p_ind < $p_num; $p_ind++){
        $p_type = $p_link_object_types->[$p_ind];
        $p_code = $p_link_object_codes->[$p_ind];
        $p_name = $p_link_object_names->[$p_ind];
        $p_common_key = $p_type.$delim1.$p_code;
        #print "Common. '$p_type' '$p_code'<BR>";
        if($db_and_p{$p_common_key}){next;}
        for($db_ind = 0; $db_ind < $db_num; $db_ind++){
            $db_type = $db_link_object_types->[$db_ind];
            $db_code = $db_link_object_codes->[$db_ind];
            $db_name = $db_link_object_names->[$db_ind];
            $db_common_key = $db_type.$delim1.$db_code;
            #print "&nbsp;&nbsp;Common. comparing '$db_type' '$db_code'<BR>";
            if($db_and_p{$p_common_key}){next;}
            if($p_code and ($db_type eq $p_type) 
               and ($db_code eq $p_code)) {
                $db_and_p{$p_common_key} = 1;
            }
        }
    }
    ### Add link objects ###
    ### Skip duplicates ###
    my ($pp_type, $pp_code, $pp_name);
    for($p_ind = 0; $p_ind < $p_num; $p_ind++){
        $p_type = $p_link_object_types->[$p_ind];
        $p_code = $p_link_object_codes->[$p_ind];
        $p_name = $p_link_object_names->[$p_ind];
        $p_common_key = $p_type.$delim1.$p_code;
        if($db_and_p{$p_common_key}){next;}
        if(!$p_code){next;}
        if(($pp_type eq $p_type) and 
           ($pp_code eq $p_code)) {next;}
        $pp_type = $p_type;
        $pp_code = $p_code;
        $pp_name = $p_name;
        push(@{$add_link_object_types}, $p_type);
        push(@{$add_link_object_codes}, $p_code);
        push(@{$add_link_object_names}, $p_name);
    }
    ### Delete link objects ###
    ### Skip duplicates ###
    my ($pdb_type, $pdb_code, $pdb_name);
    for($db_ind = 0; $db_ind < $db_num; $db_ind++){
        $db_type = $db_link_object_types->[$db_ind];
        $db_code = $db_link_object_codes->[$db_ind];
        $db_name = $db_link_object_names->[$db_ind];
        $db_common_key = $db_type.$delim1.$db_code;
        if($db_and_p{$db_common_key}){next;}
        if(!$db_code){next;}
        if(($pdb_type eq $db_type)
           and ($pdb_code eq $db_code)) {next;}
        $pdb_type = $db_type;
        $pdb_code = $db_code;
        $pdb_name = $db_name;
        push(@{$del_link_object_types}, $db_type);
        push(@{$del_link_object_codes}, $db_code);
        push(@{$del_link_object_names}, $db_name);
    }
}
###
sub compare_db_and_cgi_parents{
    my($params, $dept_id, $parent_dlc_codes, $parent_dlc_types,
       $r_common_parents, $r_add_parents, $r_delete_parents) = @_;
    my $error;
    my %db_parents_info = ();
    $error = get_all_dlc_parents_by_id($params, $dept_id, \%db_parents_info);
    my $db_parents_array = $db_parents_info{-parent_dlc_info};
    my $num_db_parents = scalar(@{$db_parents_array});
    
    my $num_parent_codes = scalar(@{$parent_dlc_codes});
    if($num_parent_codes < 1){
	return "At least one Parent DLC Code should be selected";
    }
    my ($db_par_cnt, $cgi_par_cnt);
    my $db_par_info;
    my ($db_pid, $db_pcode, $db_vstid, $db_vtcode, $db_par_key);
    my ($cgi_pcode, $cgi_vstid, $cgi_par_key);
    for($db_par_cnt = 0; $db_par_cnt < $num_db_parents; $db_par_cnt++){
        $db_par_info = $db_parents_array->[$db_par_cnt];
        $db_pid = $db_par_info->[0];
        $db_pcode = $db_par_info->[1];
        $db_vstid = $db_par_info->[4];
        $db_par_key = $db_pcode.$delim1.$db_vstid;

        if($r_common_parents->{$db_par_key}){next;}
        for($cgi_par_cnt = 0; $cgi_par_cnt < $num_parent_codes; $cgi_par_cnt++){
            $cgi_pcode = $parent_dlc_codes->[$cgi_par_cnt];
            $cgi_vstid = $parent_dlc_types->[$cgi_par_cnt];
            $cgi_par_key = $cgi_pcode.$delim1.$cgi_vstid;

            if($r_common_parents->{$cgi_par_key}){next;}
            if($db_par_key eq $cgi_par_key){
		$r_common_parents->{$cgi_par_key} = [$db_pid, $db_vstid];
                break;
	    }
	}
    }
    ### Add parents ###
    my %cgi_pinf = ();
    my $cgi_pid;
    for($cgi_par_cnt = 0; $cgi_par_cnt < $num_parent_codes; $cgi_par_cnt++){
       $cgi_pcode = $parent_dlc_codes->[$cgi_par_cnt];
       $cgi_vstid = $parent_dlc_types->[$cgi_par_cnt];
       $cgi_par_key = $cgi_pcode.$delim1.$cgi_vstid;
       if($r_common_parents->{$cgi_par_key}){next;}
       if($r_add_parents->{$cgi_par_key}){next;}
       %cgi_pinf = ();
       $error = get_dlc_info_by_code($params, $cgi_pcode, \%cgi_pinf);
       if($error){return $error;}
       $cgi_pid = $cgi_pinf{-dept_id};
       if(!$cgi_pid){
	   return "Invalid Parent DLC Code $cgi_pcode";
       }
       if(!is_id($cgi_vstid)){
          return "Parent Link Type for Parent DLC Code $cgi_pcode should be selected";
       }
       $r_add_parents->{$cgi_par_key} = [$cgi_pid, $cgi_vstid];
    }
    ### Delete parents ###
    for($db_par_cnt = 0; $db_par_cnt < $num_db_parents; $db_par_cnt++){
        $db_par_info = $db_parents_array->[$db_par_cnt];
        $db_pid = $db_par_info->[0];
        $db_pcode = $db_par_info->[1];
        $db_vstid = $db_par_info->[4];
        $db_par_key = $db_pcode.$delim1.$db_vstid;
        if($r_common_parents->{$db_par_key}){next;}
        if($r_delete_parents->{$db_par_key}){next;}
        $r_delete_parents->{$db_par_key} = [$db_pid, $db_vstid];
    }
    return $error;
}
###
sub update_dlc{
    my($params) = @_;

   ### Get all variables ###
      ### Generic variables
      my $lda = $params->{-lda};
      my $cgi = $params->{-cgi};
      my $error = $params->{-error};
      my $back_page  =  $params->{-back_page};

      ### Mdept specific variables
      my $view_type = $params->{-view_type};
      my $show_link_name = $params->{-show_link_name};
      my $dlc_id  =  $params->{-dlc_id};
      my $d_code = $params->{-dlc_code};
      my $dlc_code = $d_code;
      my $short_name  =  $params->{-short_name};
      my $name  =  $params->{-name};
      my $dlc_type  =  $params->{-dlc_type};
      my $parent_dlc_codes  =  $params->{-parent_dlc_codes};
      my $parent_dlc_types  =  $params->{-parent_dlc_types};

    my $user = $g_user;
    my $dept_id = $dlc_id;
    if(!$dlc_code){return "DLC Code should be provided";}
    if(!$short_name){return "Short name should be provided";}
    if(!$name){return "Long Name should be provided";}

    my $node_types = [];
    $error = get_node_types($params, $node_types);
    if ( $error ) {return  $error;}
    my $type_info;
    my($db_dept_type_id, $db_dept_type_desc, $db_check_object_link);
    foreach $type_info (@{$node_types}){
	$db_dept_type_id = $type_info->[0];
        $db_dept_type_desc = $type_info->[1];
        $db_check_object_link = $type_info->[2];

        if( $db_dept_type_desc eq $dlc_type){
	   $dept_type_id = $db_dept_type_id;
           break;
        }
    }
    if(!$dept_type_id){return "DLC/Node Type should be selected";}

    ## Check for changes in dept info ###
    my $dept_changed;
    my %dpt_info = ();
    $error = get_dlc_info_by_id($params, $dlc_id, \%dpt_info);
    if ( $error ) {return  $error;}
    my $db_d_code = $dpt_info{-d_code};
    my $db_long_name = $dpt_info{-long_name};
    my $db_short_name = $dpt_info{-short_name};
    my $db_dept_type_id = $dpt_info{-dept_type_id};
    my $db_dlc_type = $dpt_info{-dlc_type};
    if($db_d_code ne $d_code){$dept_changed = 1;}
    if($db_long_name ne $name){$dept_changed = 1;}
    if($db_short_name ne $short_name){$dept_changed = 1;}
    if($db_dlc_type ne $dlc_type){$dept_changed = 1;}

    ## Compare cgi and db parents ##
    my %common_parents = ();
    my %add_parents = ();
    my %delete_parents = ();

    #print "**** Before compare_db_and_cgi_parents<br>";
    $error = compare_db_and_cgi_parents($params, $dept_id,
         $parent_dlc_codes, $parent_dlc_types,
         \%common_parents, \%add_parents, \%delete_parents);
    if ( $error ) {return  $error;}

    if(!$dept_changed and !%add_parents and !%delete_parents){
        return "No changes made";
    }

    ## Update department does not depend on parent id ###
    ## at least one valid parent id is enforced on 
    ## the cgi level ###

    my $message;
    if($dept_changed){
       my $parent_code = $parent_dlc_codes->[0];
       my $view_subtype_id = $parent_dlc_types->[0];
       if(!is_id($view_subtype_id)){
         return "Parent Link Type for Parent DLC Code $parent_code should be selected";
       }
       my %p_dlc_info = ();
       $error = get_dlc_info_by_code($params, $parent_code, \%p_dlc_info);
       if($error){return $error;}
       my $parent_id = $p_dlc_info{-dept_id};
       if(!$parent_id){return "Invalid Parent DLC Code $parent_code";}
       $error = update_department_info($lda, $user, 
                $dept_id, $d_code, $short_name, $name,
		$dept_type_id, $view_subtype_id, $parent_id,
                \$message);
       if($error){return $error;}
    }
    ### Update parents ###
    ### Modifies both add_parents and delete_parents ###
    if(%add_parents and %delete_parents){
       $error =	update_department_parents($lda, $user, $dept_id, 
        \%add_parents, \%delete_parents);
       if($error){return $error;}
    }

    ### Add parents ###
    my ($add_p_info, $add_p_key, $add_pid, $add_vstid);
    foreach $add_p_key (keys %add_parents){
        $add_p_info = $add_parents{$add_p_key};
        $add_pid = $add_p_info->[0];
        $add_vstid = $add_p_info->[1];
        $error = add_dept_parent($lda, $user, 
                 $dept_id, $add_vstid, $add_pid);
        if($error){return $error;}
    }
    ### Delete parents ###
    my ($del_p_info, $del_p_key, $del_pid, $del_vstid);
    foreach $del_p_key (keys %delete_parents){
        $del_p_info = $delete_parents{$del_p_key};
        $del_pid = $del_p_info->[0];
        $del_vstid = $del_p_info->[1];
        $error = delete_dept_parent($lda, $user, 
                 $dept_id, $del_vstid, $del_pid);
        if($error){return $error;}
    }
    return $error;
}
###
sub delete_dept_parent{
    my($lda, $user,
       $dept_id, $view_subtype_id, $par_dlc_id) = @_;

    my $message;
    my $stmt = ' CALL delete_dept_parent(?,?,?,?,@message) ';
    my $error;
    my $csr = $lda->prepare($stmt);
    $error = get_db_error_msg($lda);
    if($error){return $error;}

    if($error){return $error;}
    $csr->bind_param(1, $user);
    $csr->bind_param(2, $dept_id);
    $csr->bind_param(3, $view_subtype_id);
    $csr->bind_param(4, $par_dlc_id);
    $error = get_db_error_msg($lda);
    if($error){return $error;}
    $csr->execute;
    $error = get_db_error_msg($lda);
    $csr->finish;
    return $error;
}
###
sub update_department_info{
    my($lda, $user, 
       $dept_id, $d_code, $short_name, $name,
       $dept_type_id, $view_subtype_id, $parent_id, 
       $r_message) = @_;
    my $error;

    my $stmt = ' CALL update_dept( ?,?,?,?,?,?,?,@message) ';
    my $csr = $lda->prepare($stmt);
    my $error = get_db_error_msg($lda);
    if($error){return $error;}
    $csr->bind_param(1, $user);
    $csr->bind_param(2, $d_code);
    $csr->bind_param(3, $short_name);
    $csr->bind_param(4, $name);
    $csr->bind_param(5,  $dept_type_id);
    $csr->bind_param(6, $view_subtype_id);
    $csr->bind_param(7, $dept_id);
    $error = get_db_error_msg($lda);
    $csr->execute;
    $error = get_db_error_msg($lda);
    $csr->finish;
    return $error;
}
###
sub delete_dept{
    my($params) = @_;

    ### Get all variables ###
      ### Generic variables
      my $lda = $params->{-lda};
      my $cgi = $params->{-cgi};
      my $error = $params->{-error};
      my $back_page  =  $params->{-back_page};

      ### Mdept specific variables
      my $view_type = $params->{-view_type};
      my $show_link_name = $params->{-show_link_name};
      my $dlc_id  =  $params->{-dlc_id};
      my $short_name  =  $params->{-short_name};
      my $name  =  $params->{-name};
      my $dlc_type  =  $params->{-dlc_type};
      my $parent_dlc_codes  =  $params->{-parent_dlc_codes};
      my $link_object_types  =  $params->{-link_object_types};
      my $link_object_codes  =  $params->{-link_object_codes};
      my $link_object_names  =  $params->{-link_object_names};

    ## authorization
    my $user = $g_user;
    my $dept_id = $dlc_id;
    my $message;
    ############################
    my $stmt = ' CALL delete_dept(?,?,@message) ';
    
    my $csr = $lda->prepare($stmt);
    my $error = get_db_error_msg($lda);
    if($error){return $error;}
    $csr->bind_param(1, $user);
    $csr->bind_param(2, $dept_id);
    $error = get_db_error_msg($lda);
    $csr->execute;
    $error = get_db_error_msg($lda);
    $csr->finish();
    return $error;
}
###
sub add_dlc{
    my($params) = @_;
    ### Get all variables ###
      ### Generic variables
      my $lda = $params->{-lda};
      my $cgi = $params->{-cgi};
      my $error;
      my $back_page  =  $params->{-back_page};

      ### Mdept specific variables
      my $view_type = $params->{-view_type};
      my $show_link_name = $params->{-show_link_name};
      my $dlc_id  =  $params->{-dlc_id};
      my $dlc_code = $params->{-dlc_code};
      my $short_name  =  $params->{-short_name};
      my $name  =  $params->{-name};
      my $dlc_type  =  $params->{-dlc_type};
      my $parent_dlc_codes =  $params->{-parent_dlc_codes};
      my $parent_dlc_types = $params->{-parent_dlc_types};

    ## authorization 
    ## TODO remove fixes

    my $user = $g_user;
    my $d_code = $dlc_code;
    my $dept_type_id;
    my $dept_id;
    my $message = '';

    ### Preliminary checks ###
    if(!$dlc_code){return "DLC Code should be provided";}
    if(!$short_name){return "Short name should be provided";}
    if(!$name){return "Long Name should be provided";}

    my $node_types = [];
    $error = get_node_types($params, $node_types);
    if ( $error ) {return  $error;}
    my $type_info;
    my($db_dept_type_id, $db_dept_type_desc, $db_check_object_link);
    foreach $type_info (@{$node_types}){
	$db_dept_type_id = $type_info->[0];
        $db_dept_type_desc = $type_info->[1];
        $db_check_object_link = $type_info->[2];

        if( $db_dept_type_desc eq $dlc_type){
	   $dept_type_id = $db_dept_type_id;
           break;
        }
    }
    if(!$dept_type_id){return "DLC/Node Type should be selected";}

    my $num_parent_codes = scalar(@{$parent_dlc_codes});
    if($num_parent_codes < 1){
	return "At least one Parent DLC Code should be selected";
    }
    my $parent_code = $parent_dlc_codes->[0];
    my $view_subtype_id = $parent_dlc_types->[0];
    if(!is_id($view_subtype_id)){return "Parent Link Type for Parent DLC Code $parent_code should be selected";}
    my %p_dlc_info = ();
    $error = get_dlc_info_by_code($params, $parent_code, \%p_dlc_info);
    if($error){return $error;}
    my $parent_id = $p_dlc_info{-dept_id};
    if(!$parent_id){return "Invalid Parent DLC Code $parent_code";}
    ############################
    
    my $csr = $lda->prepare(' CALL add_dept(?,?,?,?,?,?,?,@dept_id,@message) ');
    $error = get_db_error_msg($lda);
    if($error){return $error;}

    $csr->bind_param(1, $user);
    $csr->bind_param(2, $d_code);
    $csr->bind_param(3, $short_name);
    $csr->bind_param(4, $name);
    $csr->bind_param(5, $dept_type_id);
    $csr->bind_param(6, $view_subtype_id);
    $csr->bind_param(7,$parent_id);
    $error = get_db_error_msg($lda);

    $csr->execute ;
    $error = get_db_error_msg($lda);
    $csr->finish();

    
    if($error){return $error;}

    my $csr1 = $lda->prepare(' select @dept_id  ');
    $csr1->execute ;
    $dept_id = $csr1->fetchrow_array();
    $csr1->finish ;

    $params->{-dlc_id} = $dept_id;
    ## Multiple parents ###
    my $par_cnt;
    my $num_par = scalar(@{$parent_dlc_codes});

    my ($pcode, $pid, $pvstid);
    for($par_cnt = 1; $par_cnt < $num_par; $par_cnt++){
        $pcode = $parent_dlc_codes->[$par_cnt];
        $pvstid =  $parent_dlc_types->[$par_cnt];
        if(!is_id($pvstid)){
	    return "Parent Link Type for Parent DLC Code $pcode should be selected";
        }
        %p_dlc_info = ();
        $error = get_dlc_info_by_code($params, $pcode, \%p_dlc_info);
        if($error){return $error;}
        $pid = $p_dlc_info{-dept_id};
        if(!$pid){return "Invalid Parent DLC Code $pcode";}


        $error = add_dept_parent($lda, $user, $dept_id, $pvstid, $pid);

        if($error){return $error;}
    }
    return $error;
}
###
sub update_department_parents{
    my($lda, $user, $dept_id,
       $r_add_parents, $r_delete_parents) = @_;
    my $error;
    my @add_keys = keys %{$r_add_parents};
    my @delete_keys = keys %{$r_delete_parents};
    my $num_add = scalar(@add_keys);
    my $num_del = scalar(@delete_keys);
    my $num_upd = $num_add < $num_del ? $num_add : $num_del;
    my ($ind_upd, $a_key, $d_key, $a_info, $d_info);
    for($ind_upd = 0; $ind_upd < $num_upd; $ind_upd++){
        $a_key = $add_keys[$ind_upd];
        $d_key = $delete_keys[$ind_upd];
        $a_info = $r_add_parents->{$a_key};
        $d_info = $r_delete_parents->{$d_key};
        $error = upd_dpt_par($lda, $user, $dept_id,
                             $a_info, $d_info);
        if($error){return $error;}
        delete $r_add_parents->{$a_key};
        delete $r_delete_parents->{$d_key};
    }
    return $error;
}
###
sub upd_dpt_par{
    my($lda, $user, $dept_id,
       $a_info, $d_info) = @_;
    my $error;
    my $new_pid = $a_info->[0];
    my $new_vstid = $a_info->[1];
    my $old_pid = $d_info->[0];
    my $old_vstid = $d_info->[1];
    my $message;
    my $stmt = '  CALL update_dept_parent(?,?,?,?,?,?,@message) ';
    my $csr = $lda->prepare($stmt);
    $error = get_db_error_msg($lda);
    if($error){return $error;}
    $csr->bind_param(1, $user);
    $csr->bind_param(2, $dept_id);
    $csr->bind_param(3, $old_vstid);
    $csr->bind_param(4, $new_vstid);
    $csr->bind_param(5, $old_pid);
    $csr->bind_param(6, $new_pid);
    $error = get_db_error_msg($lda);
    if($error){return $error;}
    $csr->execute;
    $csr->finish;
    $error = get_db_error_msg($lda);
    return $error;
}
###
sub add_dept_parent{
    my($lda, $user, $dept_id, $view_subtype_id, $par_dlc_id) = @_;
    my $message;
    my $stmt = 
                  '  CALL  add_dept_parent(?,?,?,?,@message) '; 
    my $error;
    my $csr = $lda->prepare($stmt);
    $error = get_db_error_msg($lda);
    if($error){return $error;}
    $csr->bind_param(1, $user);
    $csr->bind_param(2, $dept_id);
    $csr->bind_param(3, $view_subtype_id);
    $csr->bind_param(4, $par_dlc_id);
    $error = get_db_error_msg($lda);

    if($error){return $error;}

    $csr->execute;

    $csr->finish;

  my $csr1 = $lda->prepare(' select @message  ');
    $csr1->execute ;
    $error  = $csr1->fetchrow_array();
    $csr1->finish ;

    #$error = get_db_error_msg($lda);

    return $error;
    
}
###
sub get_summary_of_parent_link_types{

    my ($lda, $summary_of_parent_link_types) = @_;

    my $stmt = qq{ select vst.view_subtype_id, vst.view_subtype_desc, 
                 vt.view_type_code, vt.view_type_desc
                 from view_subtype vst,
                 view_type_to_subtype vttst,
                 view_type vt
                 where vttst.view_subtype_id = vst.view_subtype_id
                 and vt.view_type_code = vttst.view_type_code
                 order by vst.view_subtype_id, vt.view_type_code 
   };

    my $error;
  my $csr = $lda->prepare($stmt);
    $error = get_db_error_msg($lda);
    if($error){
	print "Error preparing statement: $stmt<br>\n";
      return $error; 
    }

  $csr->execute;
    my ($prev_view_subtype_id, $prev_view_subtype_desc);
 
  my $visible_in_views_string;
  while(my ($view_subtype_id, $view_subtype_desc, $visible_in_views,
            $view_type_desc) = $csr->fetchrow_array) {
     if ($view_subtype_id eq $prev_view_subtype_id) {
	 $visible_in_views_string .= 
             $g_delim1 . $visible_in_views . '. ' . $view_type_desc;
         pop(@{$summary_of_parent_link_types});
     }
     else {
         $visible_in_views_string = 
             $visible_in_views . '. ' . $view_type_desc;
     }
     my $type_array = [$view_subtype_id, $view_subtype_desc, 
                       $visible_in_views_string];
     push(@{$summary_of_parent_link_types}, $type_array);
     $prev_view_subtype_id = $view_subtype_id;
  }
  $csr->finish();
  return $error;
}

###
sub lookup_dlc_id_from_dlc_code {

    my ($lda, $dlc_code) = @_;

    my $stmt = "select dept_id from department
		       where d_code = '$dlc_code'";

   my $error;
   my $csr = $lda->prepare($stmt);
   $error = get_db_error_msg($lda);
   if($error){
      print "Error preparing statement: $stmt<br>\n";
      print "Error is: $error<BR>\n";
   }

   $csr->execute;
   my ($dlc_id) = $csr->fetchrow_array;
   $csr->finish;
   unless ($dlc_id) {
       #print "<font color=red>Error - DLC code '$dlc_code' not found"
       #      . "</font><BR>\n";
   }

   return $dlc_id;
}

###
sub print_summary_of_parent_link_types{

    my ($lda) = @_;

    my $summary_of_types = [];


    my $error = 
     get_summary_of_parent_link_types($lda, $summary_of_types);

    if($error){
	print "<font color=red>$error</font><br>\n";
    }

    print "<blockquote>";
    print "<i>Summary of parent link types</i><br>\n";
    print "<table border bgcolor=\"#E0E0E0\">";
    print "<tr>";
    print "<th><small>Parent-link<br>type ID</small></th>";
    print "<th><small>Parent-link type<br>Description</small></th>";
    print "<th><small>Visible in these views</small></th>";
    print "</tr>";

    my ($type, $view_subtype_id, $view_subtype_desc, $visible_in_views);
    my $num_views;
    foreach $type (@{$summary_of_types}){
        $view_subtype_id = $type->[0];
        $view_subtype_desc = $type->[1];
	$visible_in_views = $type->[2];
        my @visible_in_views_lines = split($g_delim1, $visible_in_views);
        $num_views = scalar(@visible_in_views_lines);
        $num_rows = $num_views + 1;
        print "<tr><td rowspan=$num_views align=center><small>$view_subtype_id"
              . "</small></td>";
        print "<td rowspan=$num_views><small>$view_subtype_desc</small></td>";
        for ($i=0; $i<$num_views; $i++) {
          unless ($i == 0) {print "<tr>";}
          print "<td align=left><small>$visible_in_views_lines[$i]</small>"
                . "</td></tr>";
        }
    }
    print "</table></blockquote>";
}
###
#####################
#
# Fills in $res with list of foreign keys \([table_name,column_name])
# refering to given primary key for $table
# assumes that primary key on $table is one column.
#
#####################
sub get_referential_constraints {
    my($lda, $table, $res) = @_;

    $table = uc($table);
    my $stmt = "select table_name, column_name from user_cons_columns ".
    " where constraint_name in ( ".
    " select constraint_name from user_constraints ".
    " where r_constraint_name in ( ".
    " select constraint_name from user_constraints ".
    " where table_name = \'$table\' ".
    " and constraint_type = \'P\')) ".
    " order by table_name";

    my $csr;
    unless ($csr = $lda->prepare($stmt)) {
      &web_error("Error preparing statement (Referential constraints).<BR>"
                . $lda->errstr . "<BR>");
    }

    $csr->execute;

    my @row;
    my $ind = 0;
    my $item;
    while ( @row = $csr->fetchrow_array ) {
      $res->[$ind] = [];
      foreach $item (@row) {
        push(@{$res->[$ind]}, $item);
      }
      $ind++;
  }

  $csr->finish;
  return; 

}
###############################################################################
#
#  generate_default_page($params)
#
#  prints HTML code to generate the default page
#
###############################################################################
sub generate_default_page_rm{
   my ($params) = @_;

    my $back_page  =  $params->{-back_page};
    my $cgi = $params->{-cgi};
    if (!$back_page) {
#      print $cgi->header();
       generate_default_page_old($params);
#       print "No back page ever<br>\n";
    } else {
        print $cgi->redirect($back_page);
        print $cgi->header();
    }
}
###
sub display_dlc_tree{
    my($lda, $cgi, $all_dlc_info) = @_;

    my $view_type = $cgi->param('view_type');
    my $show_link_name = $cgi->param('show_link_name');
    $show_link_name =~ tr/a-z/A-Z/;
    $view_type =~ s/\W.*//;  # Keep only the first word.
    $view_type =~ s/\.//;    # Remove '.'
    my $view_type_code = ($view_type) ? $view_type : 'A';
    my ($view_type_desc, $root_id) = &get_view_info($lda, $view_type_code);
    $all_dlc_info->{-view_type}=$view_type;
    $all_dlc_info->{-view_type_code} = $view_type_code;
    $all_dlc_info->{-view_type_desc} = $view_type_desc;

    $all_dlc_info->{-root_id} = $root_id; ## Transient
    $all_dlc_info->{-prefix_string} = ''; ## Transient
    $all_dlc_info->{-is_last_sibling} = 1; ## Transient
    $all_dlc_info->{-level} = 0; ## Transient

    my $csr1 = &open_cursor1($lda); ## DLC details
    my $csr2 = &open_cursor2($lda); ## Children

    $all_dlc_info->{-csr1} = $csr1;
    $all_dlc_info->{-csr2} = $csr2;
    $all_dlc_info->{-dlc_ids} = [];
    $all_dlc_info->{-dlcs}={};
    
    print_tree_wrap($lda, $cgi, $all_dlc_info);
    
}
###
sub print_tree_wrap{
    my($lda, $cgi, $all_dlc_info)=@_;
    my $view_type = $all_dlc_info->{-view_type};
    my $view_type_code = $all_dlc_info->{-view_type_code};
    my $root_id = $all_dlc_info->{-root_id}; ## Transient
    my $csr1 = $all_dlc_info->{-csr1}; ## DLC details
    my $csr2 = $all_dlc_info->{-csr2};  ## Children
    my $level = $all_dlc_info->{-level}; ## Transient
    my $prefix_string = $all_dlc_info->{-prefix_string}; ## Transient
    my $is_last_sibling = $all_dlc_info->{-is_last_sibling}; ## Transient


    ### DLC details ###
    my $indent_string = $prefix_string;
    print "$indent_string+--";
    &print_dlc_detail_in_tree($lda, $csr1, $root_id);

    ### Record the dlc display info ###
    push(@{$all_dlc_info->{-dlc_ids}}, $root_id);

    if(!$all_dlc_info->{-dlcs}->{$root_id}){
	$all_dlc_info->{-dlcs}->{$root_id} = {};
    }
    $all_dlc_info->{-dlcs}->{$root_id}->{-level} = $level;
    $all_dlc_info->{-dlcs}->{$root_id}->{-prefix_string} = $prefix_string;

    print_dlc_children($lda, $cgi, $all_dlc_info);
}
###
sub print_dlc_children{
    my($lda, $cgi, $all_dlc_info) = @_;

    my $view_type = $all_dlc_info->{-view_type};
    my $view_type_code = $all_dlc_info->{-view_type_code};
    my $root_id = $all_dlc_info->{-root_id}; ## Transient
    my $csr1 = $all_dlc_info->{-csr1}; ## DLC details
    my $csr2 = $all_dlc_info->{-csr2};  ## Children
    my $level = $all_dlc_info->{-level}; ## Transient
    my $prefix_string = $all_dlc_info->{-prefix_string}; ## Transient
    my $is_last_sibling = $all_dlc_info->{-is_last_sibling}; ## Transient

    ## Get children ##

    unless ($csr2->bind_param(1, $root_id)) {
      print "Error binding param: " . $DBI::errstr . "<BR>";
    }
    unless ($csr2->bind_param(2, $view_type_code)) {
      print "Error binding param: " . $DBI::errstr . "<BR>";
    }
    unless ($csr2->execute) {
      print "Error executing select statement: " . $DBI::errstr . "<BR>";
    }

    my ($child_id);
    my @child_list = ();
    while (($child_id) = $csr2->fetchrow_array) {
      push(@child_list, $child_id);
    }

    ## Process children ##
    my $num_children = scalar(@child_list);
    my $ii = 0;
    my $levelplus1 = $level + 1;
    my $new_last_sibling = 0;
    my $new_prefix_string;
    foreach $child_id (@child_list) {

        ## Adjust transient parameters
	$all_dlc_info->{-root_id} = $child_id;
        $all_dlc_info->{-level} = $levelplus1;

        if(++$ii == $num_children){
	     $new_last_sibling = 1;
        }
        if($is_last_sibling){
           $new_prefix_string = $prefix_string . "&nbsp;&nbsp;&nbsp;";
        } else {
           $new_prefix_string = $prefix_string . "|&nbsp;&nbsp;";
        }

        $all_dlc_info->{-prefix_string} = $new_prefix_string;
        $all_dlc_info->{-is_last_sibling} = $new_last_sibling;
        ## Print child
        print_tree_wrap($lda, $cgi, $all_dlc_info);
    }
}
###
sub put_view_type_in_cgi{
    my($cgi, $ext_view_type) = @_;
    my $view_type = $ext_view_type;
    if(!$view_type){
       $view_type = $cgi->param($param_names->{'view_type'});
    }
    my $view_type_code = ($view_type) ? $view_type : 'A';
    print $cgi->hidden($param_names->{'view_type'}, $view_type_code), "\n";
}
#####
sub generate_default_page{
    my ($params) = @_;

      ### Get all variables ###
      ### Generic variables
      my $lda = $params->{-lda};
      my $cgi = $params->{-cgi};
      my $error = $params->{-error};
      my $p_back_page  =  $params->{-back_page};

      ### Mdept specific variables
      my $p_view_type = $params->{-view_type};
      my $p_show_link_name = $params->{-show_link_name};
      my $p_dlc_id  =  $params->{-dlc_id};
      my $p_short_name  =  $params->{-short_name};
      my $p_name  =  $params->{-name};
      my $p_dlc_type  =  $params->{-dlc_type};
      my $p_parent_dlc_codes  =  $params->{-parent_dlc_codes};
      my $p_link_object_types  =  $params->{-link_object_types};
      my $p_link_object_codes  =  $params->{-link_object_codes};
      my $p_link_object_names  =  $params->{-link_object_names};
    ############################

###
#
#  Print out the http document header
#
 print "<HTML>", "\n";
 print "<HEAD>"
  . "<TITLE>Master Department Hierarchy - Tree of DLCs</TITLE></HEAD>", "\n";
 print '<BODY bgcolor="#fafafa">';
 #   delete_cgi_params($cgi);
 &print_mdept_header("Tree of DLCs", 'https');
    print $cgi->delete($param_names->{'dlc_id'});
    display_table_of_all_view_types($lda, $cgi);
    # Change view type
    display_view_types_list($lda, $cgi);
    put_view_type_in_cgi($cgi, $p_view_type);
    print "<hr><br>\n";
    # Add button
    print "\n", $cgi->startform();
       my $add_dlc_button = $buttons->{'add_dlc'};
       put_view_type_in_cgi($cgi, $p_view_type);
       print "<p>" , $cgi->submit(-name => 'add_dlc', -value=>$add_dlc_button);
    print $cgi->endform(), "\n";
    print "<hr><br>\n";

    my $all_dlc_info = {};

    ## Records dlc info related to display

    print "<tt>\n"; ## use a fixed font
    display_dlc_tree($lda, $cgi, $all_dlc_info);
    print "</tt>\n";

    # Print a legend of DLC types
    print "<P />&nbsp;<P />";
    &print_dlc_type_table($lda);

    ## Print department information in a flat list
    display_dlc_flat($lda, $cgi, $all_dlc_info);

    ## Cleanup ##
    $lda->disconnect;
    print "<HR>\n";
    print "</BODY></HTML>", "\n";
    exit(0);

}
###
sub display_table_of_all_view_types{
    my ($lda, $cgi) = @_;
    my $all_view_types_info = [];
    get_all_view_types($lda, $all_view_types_info);
    my $view_type = $cgi->param($param_names->{'view_type'});
    my $view_type_code = ($view_type) ? $view_type : 'A';

    my ($db_vt_info, $db_vt_code, $db_vt_desc, $db_root_dept_id);
    print "<table border>\n";
    print "<tr><th colspan=3>Available View Types</th></tr>\n";
    print "<tr><th>View Type Code</th><th>View Type Description</th><th>Root DLC ID</th></tr>\n";
    foreach $db_vt_info (@{$all_view_types_info}){
       $db_vt_code = $db_vt_info->[0];
       $db_vt_desc = $db_vt_info->[1];
       $db_root_dept_id = $db_vt_info->[2];

       print "<tr><td>$db_vt_code</td><td>$db_vt_desc</td><td>$db_root_dept_id</td></tr>\n";

    }
    print "</table>\n";
}
###
sub display_view_types_list{
    my ($lda, $cgi) = @_;
    my $all_view_types_info = [];
    get_all_view_types($lda, $all_view_types_info);
    my $view_type = $cgi->param($param_names->{'view_type'});
    my $view_type_code = ($view_type) ? $view_type : 'A';

    print "<br><b>Current View Type</b><br>\n";
    print  $cgi->startform();

    print "<select name=";
          print $param_names->{'view_type'};
    print " size=1>\n";

    my ($db_vt_info, $db_vt_code, $db_vt_desc, $db_root_dept_id);
    foreach $db_vt_info (@{$all_view_types_info}){
       $db_vt_code = $db_vt_info->[0];
       $db_vt_desc = $db_vt_info->[1];
       $db_root_dept_id = $db_vt_info->[2];

       if($db_vt_code eq $view_type_code){
           print "<option selected>$db_vt_code</option>\n";
       } else {
           print "<option>$db_vt_code</option>\n";
       }
    }
    print "</select>\n";
    print $cgi->submit(-name => 'redisplay_dlc_tree', -value=>'Redisplay DLC Tree');
    print $cgi->endform(), "\n";
}
###
sub get_all_view_types{
    my($lda, $all_view_types_info) = @_;

    my $stmt = "select VIEW_TYPE_CODE, VIEW_TYPE_DESC, ROOT_DEPT_ID
                  from $g_owner.view_type 
                  order by VIEW_TYPE_CODE";
    my $csr = $lda->prepare($stmt);
    my $error = get_db_error_msg($lda);
    if($error){return $error;}
    $csr->execute;
    my $error = get_db_error_msg($lda);
    if($error){return $error;}
    my($view_type_code, $view_type_desc, $root_dept_id);
    while(($view_type_code, $view_type_desc, $root_dept_id)
          = $csr->fetchrow_array) {
          push(@{$all_view_types_info}, 
               [$view_type_code, $view_type_desc, $root_dept_id]);
    }
   $csr->finish;
    return $error;
}
###
sub display_dlc_flat{
    my($lda, $cgi, $all_dlc_info) = @_;

    ### Get cgi params ####
    my $view_type = $cgi->param('view_type');
    my $show_link_name = $cgi->param('show_link_name');
    $show_link_name =~ tr/a-z/A-Z/;
    $all_dlc_info->{-show_link_name} = $show_link_name;
    $view_type =~ s/\W.*//;  # Keep only the first word.
    $view_type =~ s/\.//;    # Remove '.'
    my $view_type_code = ($view_type) ? $view_type : 'A';
    $all_dlc_info->{-view_type} = $view_type_code;
    my ($view_type_desc, $root_id) = &get_view_info($lda, $view_type_code);

    ## Get additional dlc info ##
    my $stmt = "select d.dept_id, d.d_code, d.long_name, d.short_name,"
           . " t.dept_type_id"
           . " from $g_owner.department d, $g_owner.dept_node_type t"  
           . " where t.dept_type_id = d.dept_type_id"
           . " order by d_code";

    my $csr;
    unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
    } 
    $csr->execute;

    my ($ddid, $ddcode, $ddname, $ddsname, $ddtype);
    while ( ($ddid, $ddcode, $ddname, $ddsname, $ddtype) = $csr->fetchrow_array)
    {
        $all_dlc_info->{-dlcs}->{$ddid}->{-ddcode} = $ddcode;
        $all_dlc_info->{-dlcs}->{$ddid}->{-ddname} = $ddname;
        $all_dlc_info->{-dlcs}->{$ddid}->{-ddsname} = $ddsname;
        $all_dlc_info->{-dlcs}->{$ddid}->{-ddtype} = $ddtype;
    }

    $csr->finish();
    ##  Get a list of object types
    my @object_type = ();
    my %object_type_desc = ();
    &get_object_types($lda, \@object_type, \%object_type_desc);
    $all_dlc_info->{-object_type}=\@object_type;
    $all_dlc_info->{-object_type_desc}=\%object_type_desc;

    ##  Get a list of the links of each DLC to other objects
    my %dlc_object_link = ();
    &get_dlc_object_link($lda, $delim1, \%dlc_object_link);
    $all_dlc_info->{-dlc_object_link} = \%dlc_object_link;

    ##  If the user has requested a display of object names (which slows down
    ##  the script, and therefore is an option for the user), then
    ##  go build a hash of object_codes and object_names.
    my %object_code2name = ();
    if ($show_link_name eq 'Y') {
       &get_object_names($lda, $delim1, \%object_code2name);
    }
 
    $all_dlc_info->{-object_names} = \%object_code2name;

    print_all_depts_header();

    ##  Print list of departments
    my $num_depts = scalar(@{$all_dlc_info->{-dlc_ids}});
    for($ii = 0; $ii < $num_depts; $ii++){
	print_flat_dept_info($ii, $cgi, $all_dlc_info);
        print_linked_objects_info($ii, $cgi, $all_dlc_info);
    }
    print "</TABLE>", "\n";    
}
##
sub print_linked_objects_info{
    my($ii, $cgi, $all_dlc_info)=@_;

    my $ddid = $all_dlc_info->{-dlc_ids}->[$ii];
#    print "<tr><td>DLC ID</td><td>$ddid</td></tr>\n";
    my $object_type = $all_dlc_info->{-object_type};
    my $object_type_desc = $all_dlc_info->{-object_type_desc};
    my $dlc_object_link = $all_dlc_info->{-dlc_object_link};
    my $show_link_name = $all_dlc_info->{-show_link_name};
    my $view_type = $all_dlc_info->{-view_type};
    ### Aliases
    my $dlc_id = $ddid;

    my $num_obj_links = number_of_object_links($ddid, $all_dlc_info);

    my $obj_type;
    my $temp_object_link;
    my $name_list;
    my $count = 0;
    my $num_obj_types = scalar(@{$object_type});
    foreach $obj_type (@{$object_type}){
	if($count == 0){
	    print "<tr><td rowspan=$num_obj_links>";
             print "\n", $cgi->startform();
               # Edit buttons
               my $dlc_button = $buttons->{'edit_dlc'};
               my $link_button = $buttons->{'edit_obj_link'};
               print "<p>" , $cgi->submit(-name => 'edit_dlc', -value=>$dlc_button);
               print "<p>" , $cgi->submit(-name => 'edit_obj_link', -value=>$link_button);
               ### Print hidden variables
               print $cgi->hidden($param_names->{'view_type'}, $view_type), "\n";
	       print $cgi->hidden($param_names->{'show_link_name'}, $show_link_name), "\n";
	       print $cgi->hidden($param_names->{'dlc_id'}, $dlc_id), "\n";
               print $cgi->endform, "\n";
            print "</td>";
        }
        $count++;
       $temp_object_link = $dlc_object_link->{"$ddid$delim1$obj_type"};
       $name_list = '&nbsp;';
       # if(!$temp_object_link){print "<td colspan=6>&nbsp;</td></tr>";}
       if ( ($temp_object_link) || ($ddtype eq '2') ) {
         if ($show_link_name eq 'Y' && ($temp_object_link)) {
           
           $name_list = 
	     &get_name_from_code($temp_object_link, $obj_type, 
                              $delim1, $object_code2name);
	 }
         my @code_array = split($delim1, $temp_object_link);
         my @name_array = split($delim1, $name_list);
         my $num_codes = scalar(@code_array);
         my $jj;
         my $rowspan = ($num_codes > 1) ? "rowspan=$num_codes" : "";
         for($jj = 0; $jj < $num_codes; $jj++){
            my $name_item = $name_array[$jj];
            unless ($name_item) {$name_item = '&nbsp;';}
            if ($jj == 0) {
		# print "<tr><td rowspan=$num_obj_links>&nbsp;</td>";
                # print "<tr><td $rowspan>&nbsp;</td>";
                print "<td colspan=2 rowspan=$num_codes>$object_type_desc->{$obj_type}</td>"
                 . "<td>$code_array[$jj]</td>"
                 . "<td colspan=2>$name_item</td></tr>\n";
           
            }else {
              print "<tr><td>$code_array[$jj]</td>"
                 . "<td colspan=2>$name_item</td></tr>\n";
           
            }
         }
         if ($num_codes == 0) {
             my $ot = $object_type_desc->{$obj_type};
             if(!$ot){$ot = "&nbsp;";}
             print "<td colspan=2 $rowspan>$ot</td>"
               . "<td>&nbsp;</td>"
               . "<td colspan=2>&nbsp;</td></tr>\n";
         }
       } 
    }
    if(!$num_obj_links){
	print "<td colspan=6>&nbsp;</td></tr>";
    }
}
##
sub number_of_object_links{
    my($ddid, $all_dlc_info)=@_;

    my $object_type = $all_dlc_info->{-object_type};
    my $object_type_desc = $all_dlc_info->{-object_type_desc};
    my $dlc_object_link = $all_dlc_info->{-dlc_object_link};
    my $object_code2name = $all_dlc_info->{-object_names};
    my $ddtype = $all_dlc_info->{-dlcs}->{$ddid}->{-ddtype};
    my $show_link_name = $all_dlc_info->{-show_link_name};

    my $count = 0;
    my $obj_type;
    my $temp_object_link;
    my $name_list;
    foreach $obj_type (@{$object_type}){
       $temp_object_link = $dlc_object_link->{"$ddid$delim1$obj_type"};
       $name_list = '&nbsp;';
       if($temp_object_link){
         if ($show_link_name eq 'Y' && ($temp_object_link)) {
           
           $name_list = 
	     &get_name_from_code($temp_object_link, $obj_type, 
                              $delim1, $object_code2name);
	 }
         my @code_array = split($delim1, $temp_object_link);
         my @name_array = split($delim1, $name_list);
         my $num_codes = scalar(@code_array);
         my $jj;
         my $rowspan = ($num_codes > 1) ? $num_codes : 1;
         
         $count += $rowspan;
       }
    }
    return $count;
}
##
sub print_flat_dept_info{
    my($ii, $cgi, $all_dlc_info)=@_;

    my $ddid = $all_dlc_info->{-dlc_ids}->[$ii];
    my $ddlevel = $all_dlc_info->{-dlcs}->{$ddid}->{-level};
    my $indent_string = '-' x $ddlevel;
    my $ddcode = $all_dlc_info->{-dlcs}->{$ddid}->{-ddcode};
    my $ddname = $all_dlc_info->{-dlcs}->{$ddid}->{-ddname};
    my $ddsname = $all_dlc_info->{-dlcs}->{$ddid}->{-ddsname};
    my $ddtype = $all_dlc_info->{-dlcs}->{$ddid}->{-ddtype};

    my $num_obj_links = number_of_object_links($ddid, $all_dlc_info);

    my $dlc_string = "$indent_string <a name=\"$ddid\">$ddcode</a>";
    
    print "<tr bgcolor=\"#E0E0E0\">"
           . "<td><tt>"
           . " $dlc_string</tt></td>"
           . "<td>$ddid</td>"
           . "<td align=center>$ddtype</td>"
           . "<td colspan=2>$ddname</td><td>$ddsname</td>"
           ." </tr>\n";
}
###
sub get_node_types{
    my ($params, $node_types) = @_;
    my $lda = $params->{-lda};
    my $stmt = qq{select DEPT_TYPE_ID, DEPT_TYPE_DESC, CHECK_OBJECT_LINK
                from dept_node_type
		order by DEPT_TYPE_ID
               };
  my $csr = $lda->prepare($stmt);
  my $error = get_db_error_msg($lda);
  if($error){return $error;}
  $csr->execute;
  my $error = get_db_error_msg($lda);
  if($error){return $error;}

  my($dept_type_id, $dept_type_desc, $check_object_link);
  while (($dept_type_id, $dept_type_desc, $check_object_link) =
	 $csr->fetchrow_array){
      my $rec = [$dept_type_id, $dept_type_desc, $check_object_link];
      push(@{$node_types}, $rec );
  }
   $csr->finish;
  return $error;
}
###
sub get_dlc_info_by_code{
    my($params, $dlc_code, $r_dlc_info ) = @_;
    my $lda = $params->{-lda};
    my $cgi = $params->{-cgi};

    my $quoted_dlc_code = "\'$dlc_code\'";

    my $stmt = "select d.dept_id, d.d_code, d.long_name, d.short_name,
                  t.dept_type_id, t.DEPT_TYPE_DESC
                  from $g_owner.department d, $g_owner.dept_node_type t  
                  where t.dept_type_id = d.dept_type_id
                  and d.d_code = $quoted_dlc_code
                  order by d_code";

    my $csr = $lda->prepare($stmt);
    my $error = get_db_error_msg($lda);
    if($error){return $error;}
    $csr->execute;
    my $error = get_db_error_msg($lda);
    if($error){return $error;}
    my ($dept_id, $d_code, $long_name, $short_name, $dept_type_id,
       $dlc_type);
    my $count = 0;
    while(($dept_id, $d_code, $long_name, $short_name, 
       $dept_type_id, $dlc_type) =
    $csr->fetchrow_array) {
         $r_dlc_info->{-dept_id} = $dept_id;
         $r_dlc_info->{-d_code} = $d_code;
         $r_dlc_info->{-long_name} = $long_name;
         $r_dlc_info->{-short_name} = $short_name;
         $r_dlc_info->{-dept_type_id} = $dept_type_id;
         $r_dlc_info->{-dlc_type} = $dlc_type;
         $count++; 
    }
   $csr->finish;
    if($count > 1){
	return "Database inconsistency for DLC Code<br>$dlc_code";
    }
    if($count < 1){
        return "Invalid DLC Code<br>$dlc_code";
    }
    return $error;
}
###
sub get_dlc_info_by_id{
    my($params, $dlc_id, $r_dlc_info ) = @_;
    my $lda = $params->{-lda};
    my $cgi = $params->{-cgi};

    my $stmt = " select d.dept_id, d.d_code, d.long_name, d.short_name,
                  t.dept_type_id, t.DEPT_TYPE_DESC
                  from $g_owner.department d, $g_owner.dept_node_type t  
                  where t.dept_type_id = d.dept_type_id
                  and d.dept_id = $dlc_id
                  order by d_code " ;
    my $csr = $lda->prepare($stmt);
    my $error = get_db_error_msg($lda);
    if($error){return $error;}
    $csr->execute;
    my $error = get_db_error_msg($lda);
    if($error){return $error;}
    my ($dept_id, $d_code, $long_name, $short_name, $dept_type_id,
       $dlc_type);
    my $count = 0;
    while(($dept_id, $d_code, $long_name, $short_name, 
       $dept_type_id, $dlc_type) =
    $csr->fetchrow_array) {
         $r_dlc_info->{-dept_id} = $dept_id;
         $r_dlc_info->{-d_code} = $d_code;
         $r_dlc_info->{-long_name} = $long_name;
         $r_dlc_info->{-short_name} = $short_name;
         $r_dlc_info->{-dept_type_id} = $dept_type_id;
         $r_dlc_info->{-dlc_type} = $dlc_type;
         $count++; 
    }
   $csr->finish;
    if($count != 1){
	return "Database inconsistency for DLC ID $dlc_id";
    }
    return $error;
}
###
sub get_all_dlc_parents_by_id{
    my($params, $dlc_id, $r_dlc_info ) = @_;
    my $lda = $params->{-lda};
    my $cgi = $params->{-cgi};

    my $stmt = qq{select d.dept_id, d.d_code, d.long_name, d.short_name,
                  dc.VIEW_SUBTYPE_ID
                  from $g_owner.department d, 
                       $g_owner.department_child dc
                  where 
                  d.dept_id = dc.parent_id
                  and dc.child_id = $dlc_id
                  order by d.d_code};
    my $csr = $lda->prepare($stmt);

    my $error = get_db_error_msg($lda);

    if($error){return $error;}
    $csr->execute;
    my $error = get_db_error_msg($lda);

    if($error){return $error;}
    my ($dept_id, $d_code, $long_name, $short_name, 
        $view_subtype_id);

    my $cnt = 0;

    while(($dept_id, $d_code, $long_name, $short_name, 
           $view_subtype_id) =
    $csr->fetchrow_array) {

        $cnt++;

	if(!$r_dlc_info->{-parent_dlc_info}){
            $r_dlc_info->{-parent_dlc_info} = [];
        }
        push(@{$r_dlc_info->{-parent_dlc_info}},
	     [$dept_id, $d_code, $long_name, $short_name, 
             $view_subtype_id]);
    }
   $csr->finish;
    return $error;
}
###
sub print_dlc_info{
    my($params) = @_;
    my $lda = $params->{-lda};
    my $cgi = $params->{-cgi};
    
    my $dlc_id = $params->{-dlc_id};
    my $short_name = $params->{-short_name};
    my $name = $params->{-name};
    my $dlc_type = $params->{-dlc_type};
    my $dlc_type_id = $params->{-dlc_type_id};
    my $dlc_code = $params->{-dlc_code};
    my $parent_dlc_codes = $params->{-parent_dlc_codes};

    my $back_page = $params->{-back_page};
    my $view_type = $cgi->param('view_type');
    my $show_link_name = $cgi->param('show_link_name');
    my $view_type_code = ($view_type) ? $view_type : 'A';
    my ($view_type_desc, $root_id) = &get_view_info($lda, $view_type_code);

    my $error;

    ### Fill parameters from database if they are not
    ### present
    if($dlc_id){
        my %dlc_info = ();
	get_dlc_info_by_id($params, $dlc_id, \%dlc_info );
        if(!$short_name){
	    $short_name = $dlc_info{-short_name};
        }
        if(!$name){
	    $name = $dlc_info{-long_name};
        }
        if(!$dlc_type){
	    $dlc_type = $dlc_info{-dlc_type};
        }
        if(!$dlc_type_id){
	    $dlc_type_id = $dlc_info{-dept_type_id};
        }
        if(!$dlc_code){
	    $dlc_code = $dlc_info{-d_code};
        }
    }
    my $node_types = [];
    $error = get_node_types($params, $node_types);
    if ( $error ) {
	print "<p> <font color=red> $error \n</font>";
    }
    print "<tr><td><b>DLC Code</b></td><td>",
            $cgi->textfield(-name=>$param_names->{'dlc_code'},
                           -value=>to_display($dlc_code),
			   -size=> SHORT_LEN,
			   -maxlength=> SHORT_LEN),  
           "</td></tr>\n" ;
    print "<tr><td><b>Short Name</b></td><td>",
	   $cgi->textfield(-name=>$param_names->{'short_name'},
                           -value=>to_display($short_name),
			   -size=> SHORT_LEN,
			   -maxlength=> SHORT_LEN), 
	   "</td></tr>\n";

    print "<tr><td><b>Long Name</b></td><td>",
	   $cgi->textfield(-name=>$param_names->{'name'},
                           -value=>to_display($name),
                           -size=> MAXLEN,
                           -maxlength=>MAXLEN),
	   "</td></tr>\n";
    print "<tr><td><b>DLC/Node Type</b></td><td>";
    print "<select name=$param_names->{'dlc_type'} size=1>";
    my $type_info;
    my($dept_type_id, $dept_type_desc, $check_object_link);


    foreach $type_info (@{$node_types}){
	$dept_type_id = $type_info->[0];
        $dept_type_desc = $type_info->[1];
        $check_object_link = $type_info->[2];

        if( $dept_type_desc eq $dlc_type){
	   print "<option selected>$dept_type_desc\n";
           $dlc_type_id = $dept_type_id;
        } else {
           print "<option>$dept_type_desc\n";
        }
    }

    if(!$dlc_type_id){
     print "<option selected>Select a type\n";
    } else {
     print "<option >Select a type\n";
    }

    print "</select>";
    print  "</td></tr>\n";
    print "<tr><td><b>Sort Order</b></td><td>";
    print $cgi->textfield(-name=>$param_names->{'sort_order'},
                           -value=>to_display($sort_order),
                           -size=> MAXLEN,
			  -maxlength=>MAXLEN);
    print "<i>Sort order within a group of siblings (not implemented)</i>\n";
    print   "</td></tr>\n";
}
###
###############################################################################
#  
#  generate_add_page($params)
#
#  prints HTML code to generate the "Add DLC" page
#
###############################################################################
sub generate_add_page{
    my ($params) = @_; 

    ### Get all variables ###
      ### Generic variables
      my $lda = $params->{-lda};
      my $cgi = $params->{-cgi};
      my $error = $params->{-error};
      my $p_back_page  =  $params->{-back_page};

      ### Mdept specific variables
      my $p_view_type = $params->{-view_type};
      my $p_show_link_name = $params->{-show_link_name};
      my $p_dlc_id  =  $params->{-dlc_id};
      my $p_short_name  =  $params->{-short_name};
      my $p_name  =  $params->{-name};
      my $p_dlc_type  =  $params->{-dlc_type};
      my $p_parent_dlc_codes  =  $params->{-parent_dlc_codes};
      my $p_parent_dlc_types = $params->{-parent_dlc_types};
    ############################

    print "<HTML>", "\n";
    print "<HEAD>";
    print "<TITLE>Add a DLC or Node</TITLE></HEAD>", "\n";
    print "<BODY bgcolor=\"#fafafa\">";
    &print_mdept_header("Add a DLC or Node", 'https');
    print "<HR>", "\n";
   
    if ( $error ) {
	print "<p> <font color=red> $error \n</font>";
    }
#    print "<br><b>Current View Type</b>&nbsp;$p_view_type<br>\n";
    delete_cgi_params($cgi);

    print "\n", $cgi->startform;
    print $cgi->hidden($param_names->{'back_page'}, $back_page), "\n";
    put_view_type_in_cgi($cgi, $p_view_type); 
    # Now we begin adding fields etc to add new DLC.
    print "<TABLE>\n";

    print_dlc_info($params);

    print_parent_dlcs($params, $p_parent_dlc_codes, $p_parent_dlc_types);

    ### Buttons ###
    print "</TABLE>\n";

    print "<p><center><table width=\"60%\"", "<tr><td align=center>";
          my $commit_dlc_button = $buttons->{'commit_dlc'};
    print $cgi->submit(-name => 'commit_dlc',
                       -value => $commit_dlc_button);
    print "</td><td align=center>";
    my $cancel_dlc_button = $buttons->{'cancel_dlc'};
    print $cgi->submit(-name =>'cancel_dlc' ,
              -value => $cancel_dlc_button);
    print "</td></tr></table></center>";
    print $cgi->endform, "\n";

    print_summary_of_parent_link_types($lda);
}
####
sub print_parent_dlcs{
    my ($params, $p_parent_dlc_codes, $p_parent_dlc_types ) = @_;

    my $dlc_id = $params->{-dlc_id};
    my $view_type_code = $params->{-view_type_code};
    my $num_parent_dlc_codes = scalar(@{$p_parent_dlc_codes});

    my $n_extra_parent_dlc_codes = 3; ## extra empty boxes

    ### Start printing parent dlc codes ####
    print "<table>\n";
    
    ### Skip empty parent dlc codes ###
    my ($parent_dlc_code, $parent_link_type);
    my $cnt_par;
    for($cnt_par = 0; $cnt_par < $num_parent_dlc_codes; $cnt_par++){
        $parent_dlc_code = $p_parent_dlc_codes->[$cnt_par];
        $parent_link_type = $p_parent_dlc_types->[$cnt_par];
        if($parent_dlc_code){
	    display_parent_dlc_code($params, $parent_dlc_code, $parent_link_type);
	}
    } 

    $parent_dlc_code = undef;
    $parent_link_type = undef;
    my $i_extra;
    for ($i_extra = 0; $i_extra < $n_extra_parent_dlc_codes; $i_extra++ ){
	display_parent_dlc_code($params, $parent_dlc_code, $parent_link_type);
    }
    print "</table>\n";
    ### End printing parent dlc codes
}
###
sub display_parent_dlc_code{
    my($params, $parent_dlc_code, $parent_link_type) = @_;
          ### Generic variables
      my $lda = $params->{-lda};
      my $cgi = $params->{-cgi};
    ### Actually parent link type is view subtype id ###
    my @parent_link_types = ();
    get_parent_link_types($params, \@parent_link_types);
    
    print "<tr>";
    ### Parent dlc code ###
    print "<td><b>Parent DLC<br>Code</b></td>";
    print "<td>";
    print $cgi->textfield($param_names->{'parent_dlc_codes'}, 
		to_display($parent_dlc_code), SHORT_LEN, SHORT_LEN);
    print "</td>";
    print "<td><b>Parent Link<br>Type</b></td>";
    print "<td>";
    my $pdlct_name = $param_names->{'parent_dlc_types'};
    print "<select name=$pdlct_name size=1>";
    ### Print empty option ###
    if($parent_link_type){
       print "<option>Select parent link type\n";
    } else {
       print "<option selected>Select parent link type\n";
    }
    my $pltinf;
    my ( $view_subtype_id, $view_subtype_desc);
    foreach $pltinf (@parent_link_types){
	$view_subtype_id = $pltinf->[0];
        if($view_subtype_id ne $parent_link_type){
           print "<option>$view_subtype_id\n";
        } else {
           print "<option selected >$view_subtype_id\n";
        }
    }
    print "</select>";
    print "</td></tr>\n";
}
###
sub get_parent_link_types{
    my($params, $parent_link_types) = @_;
    my $error;
    my $lda = $params->{-lda};
    my $stmt = qq{ select VIEW_SUBTYPE_ID, VIEW_SUBTYPE_DESC
                from view_subtype
		order by VIEW_SUBTYPE_ID
               };
    my $csr = $lda->prepare($stmt);
    $error = get_db_error_msg($lda);
    if($error){return $error;}
    $csr->execute;
    $error = get_db_error_msg($lda);
    if($error){return $error;}

    my($view_subtype_id, $view_subtype_desc);
    while (($view_subtype_id, $view_subtype_desc) =
	 $csr->fetchrow_array){
      my $rec = [$view_subtype_id, $view_subtype_desc];
      push(@{$parent_link_types}, $rec );
    }
   $csr->finish;
    return $error;
}

###
sub generate_edit_obj_link_page{
    my ($params) = @_;

    #print "In generate_edit_obj_link_page<BR>";

    ### Get all variables ###
      ### Generic variables
      my $lda = $params->{-lda};
      my $cgi = $params->{-cgi};
      my $error = $params->{-error};
      my $p_back_page  =  $params->{-back_page};

      ### Mdept specific variables
      my $p_view_type = $params->{-view_type};
      my $p_show_link_name = $params->{-show_link_name};
      my $p_dlc_id  =  $params->{-dlc_id};
      my $p_short_name  =  $params->{-short_name};
      my $p_name  =  $params->{-name};
      my $p_dlc_type  =  $params->{-dlc_type};

      ### If there is a dlc_code but no dlc_id, then print an error 
      ### message
      if (($params->{-dlc_code}) && !($p_dlc_id)) {
         print "<font color=red>Error: DLC code '" . $params->{-dlc_code} 
            . "' not found.</font><BR>\n";
         die "DLC code '" . $params->{-dlc_code} . "' not found.";
      }
      
    my $p_parent_dlc_codes  =  [];
    my $pdlcc;
    foreach $pdlcc (@{$params->{-parent_dlc_codes}}){
        if($pdlcc){
	   push(@{$p_parent_dlc_codes}, $pdlcc);
        }
    }
    my $p_link_object_types = [];
    my $plot;
    foreach $plot (@{$params->{-link_object_types}}){
	if($plot){
	    push(@{$p_link_object_types},$plot); 
	}
    }
    my $p_link_object_codes = [];
    my $ploc;
    foreach $ploc (@{$params->{-link_object_codes}}){
	if($ploc){
	    push(@{$p_link_object_codes}, $ploc);
	}
    }
    my $p_link_object_names  =  [];
    my $plon;
    foreach $plon (@{$params->{-link_object_names}}){
        if($plon){
	    push(@{$p_link_object_names},$plon); 
	}
    }
    
    ############################
    ### Adjustments
    my $dlc_id = $p_dlc_id;
    my %dlc_info = ();
    my $err = get_dlc_info_by_id($params, $dlc_id,\%dlc_info);
    if(!$error and $err){$error = $err;}
    print "<HTML>\n";
    print "<HEAD>";
    print "<TITLE>Update Object Links for a DLC or Node</TITLE></HEAD>\n";
    &print_mdept_header("Update Object Links for a DLC or Node", 'https');
    print "<BODY bgcolor=\"#fafafa\">";
    print "<HR>\n";

    if($error){
	print "<p> <font color=red> $error \n</font>";
    }
#    print "<br><b>Current View Type</b>&nbsp;$p_view_type<br>\n";
    print "<TABLE>\n";
    print "<tr><td><b>DLC ID</b></td><td>",
            $dlc_id,    
           "</td></tr>\n" ;
    print "<tr><td><b>DLC Code</b></td><td>",
            $dlc_info{-d_code},    
           "</td></tr>\n" ;
    print "<tr><td><b>DLC Name</b></td><td>",
            $dlc_info{-long_name},    
           "</td></tr>\n" ;
    print "</table><br>\n";
    
    ### Available object types ###
    my @object_types = ();
    my %object_types_desc = ();
    &get_object_types($lda, \@object_types, \%object_types_desc);

    #print "<table border>\n";
    #print "<tr><th>Linked Object Type</th><th>Linked Object Type Description</th></tr>\n";
    #my ($ot, $otd);
    #foreach  $ot ( @object_types){
    #   $otd = $object_types_desc{$ot};
    #   print "<tr><td>$ot</td><td>$otd</td></tr>";
    #}  
    #print "</table><hr>\n";

    delete_cgi_params($cgi);

    ### Real edit ###
    print "\n", $cgi->startform();
    print "\n";
    ## Pass variables
    put_view_type_in_cgi($cgi, $p_view_type);
    print $cgi->hidden($param_names->{'dlc_id'}, $dlc_id);
    print "<table border>\n";
    print "<tr><th>Linked Object Type</th><th>Linked Object Code</th><th>Linked Object Name</th></tr>\n";

    ### Content ####
    #print_params_test($params);
    my $current_obj_links = display_obj_links($params);

    ## Additional empty fields ####
    my $ind_obj = 0;
    my $extra_obj_link_fields = 2;
    my $add_obj_links = ($current_obj_links > 6) ? $extra_obj_link_fields
	: (8 - $current_obj_links);

    for ($ind_obj = 0; $ind_obj < $add_obj_links; $ind_obj++){
        #print "Here 1<BR>";
	displ_link_object($params, \@object_types);
    }
    print "</table><br>";

    ### Commit and Cancel buttons ###
    my $commit_obj_link_button = $buttons->{'commit_obj_link'};
    my $cancel_obj_link_button = $buttons->{'cancel_obj_link'};
    print $cgi->submit(-name => 'commit_obj_link', 
          -value=> $commit_obj_link_button);
    print "&nbsp;";
    print $cgi->submit(-name => 'cancel_obj_link', 
          -value=> $cancel_obj_link_button);
    print $cgi->endform(), "\n";

    ### Show legend of object types
    print "<p /><hr /><p />\n";
    print "<table border>\n";
    print "<caption>Legend of object types</caption>";
    print "<tr><th>Linked Object Type</th><th>Linked Object Type Description</th></tr>\n";
    my ($ot, $otd);
    foreach  $ot ( @object_types){
	$otd = $object_types_desc{$ot};
	print "<tr><td>$ot</td><td>$otd</td></tr>";
    }  
    print "</table><hr>\n";

}

###
sub fill_dlc_objects_from_db{
    my($params, $p_link_object_types,
    $p_link_object_codes, $p_link_object_names ) = @_;
    #print "In fill_dlc_objects_from_db<BR>";

    ### Get all variables ###
      ### Generic variables
      my $lda = $params->{-lda};
      my $cgi = $params->{-cgi};
      my $error = $params->{-error};
      my $p_back_page  =  $params->{-back_page};

      ### Mdept specific variables
      my $p_view_type = $params->{-view_type};
      my $p_show_link_name = $params->{-show_link_name};
      my $p_dlc_id  =  $params->{-dlc_id};
      my $p_short_name  =  $params->{-short_name};
      my $p_name  =  $params->{-name};
      my $p_dlc_type  =  $params->{-dlc_type};

    if(!$params->{-link_object_types}){
        $params->{-link_object_types} = [];
    }
    if(!$params->{-link_object_codes}){
        $params->{-link_object_codes} = [];
    }
    if(!$params->{-link_object_names}){
        $params->{-link_object_names} = [];
    }
    ### Getting data ###
    my %object_code2name = ();
    ### Last parm below ($p_dlc_id) says 
    ### only get the object_names of objects linked to that DLC.
    get_object_names($lda, $delim1, \%object_code2name, $p_dlc_id);
    #$key_count = (keys %object_code2name);
    #print "Number of keys = $key_count<BR>\n";
    #foreach $key (keys %object_code2name) {
    #	print "$key -> $object_code2name{$key}<BR>";
    #}

    my %dlc_objects = ();
    my %dlc_object_types = ();
    get_dlc_objects($lda, $p_dlc_id, \%object_code2name, 
    \%dlc_objects, \%dlc_object_types);
    my @object_type = ();
    my %object_type_desc = ();
    &get_object_types($lda, \@object_type, \%object_type_desc);

    my($obj_type, $record, 
    $object_type_code, $object_code, $object_name, $rec);

    foreach $obj_type (@object_type){

       $record = $dlc_objects{$obj_type};

       foreach $rec (@{$record}){
         $object_type_code = $rec->[0];
         $object_code = $rec->[1];
         $object_name = $rec->[2]; 

         push(@{$p_link_object_types},  $object_type_code);
         push(@{$p_link_object_codes},   $object_code);
         push(@{$p_link_object_names}, $object_name);
       }
    }
}

###
#  Function display_obj_links displays a table of object link info, and
#  returns the number of object links found.
###
sub display_obj_links{
    my($params) = @_;
    #print "In display_obj_links<BR>";
    
     ### Get all variables ###
      ### Generic variables
      my $lda = $params->{-lda};
      my $cgi = $params->{-cgi};
      my $error = $params->{-error};
      my $p_back_page  =  $params->{-back_page};

      ### Mdept specific variables
      my $p_view_type = $params->{-view_type};
      my $p_show_link_name = $params->{-show_link_name};
      my $p_dlc_id  =  $params->{-dlc_id};
      my $p_short_name  =  $params->{-short_name};
      my $p_name  =  $params->{-name};
      my $p_dlc_type  =  $params->{-dlc_type};
    my $p_parent_dlc_codes  =  [];
    my $pdlcc;
    foreach $pdlcc (@{$params->{-parent_dlc_codes}}){
        if($pdlcc){
	   push(@{$p_parent_dlc_codes}, $pdlcc);
        }
    }
    my $p_link_object_types = [];
    my $plot;
    foreach $plot (@{$params->{-link_object_types}}){
	if($plot){
	    push(@{$p_link_object_types},$plot); 
	}
    }
    my $p_link_object_codes = [];
    my $ploc;
    foreach $ploc (@{$params->{-link_object_codes}}){
	if($ploc){
	    push(@{$p_link_object_codes}, $ploc);
	}
    }
    my $p_link_object_names  =  [];
    my $plon;
    foreach $plon (@{$params->{-link_object_names}}){
        if($plon){
            push(@{$p_link_object_names},$plon); 
    	   }
    }

    ############################
    ### Adjustments
    my $dlc_id = $p_dlc_id;
    my $num_link_object_codes = scalar(@{$p_link_object_codes});
    #print "num_link_object_codes = $num_link_object_codes<br>";
    my $num_link_object_names = scalar(@{$p_link_object_names});
    #print "num_link_object_names = $num_link_object_names<br>";

    # Changed 9/26,2005: Always clear link types, codes, and names and
    # rebuild them.
    #if(!$num_link_object_codes ){
     @{$p_link_object_types} = ();
     @{$p_link_object_codes} = ();
     @{$p_link_object_names} = ();

       ## Fill everything from DB ###
        #print "Here 99<BR>";
	fill_dlc_objects_from_db($params, $p_link_object_types,
                $p_link_object_codes, $p_link_object_names);
    #}

    ### Sanity ####
    my $num_link_object_types = scalar(@{$p_link_object_types});
    $num_link_object_codes = scalar(@{$p_link_object_codes});

    my @object_types = ();
    my %object_types_desc = ();
    &get_object_types($lda, \@object_types, \%object_types_desc);

    my $displ_ind;
    my($object_type_code, $object_code, $object_name);
    for($displ_ind = 0; $displ_ind < $num_link_object_codes; $displ_ind++){
        $object_type_code = $p_link_object_types->[$displ_ind];
        $object_code = $p_link_object_codes->[$displ_ind];
        $object_name = $p_link_object_names->[$displ_ind];

        if(!$object_code){next;}

        #print "Here 2<BR>";
        displ_link_object($params, \@object_types,
                          $object_type_code, $object_code, $object_name);
    }

    return $num_link_object_codes;
}

###
sub displ_link_object{
    my($params, $obj_types, $obj_type_code, $obj_code, $obj_name) = @_;
    my $cgi = $params->{-cgi};

    my $sel_name = $param_names->{'link_object_types'};
    print "<tr><td>";
    print "<select name=$sel_name size=1>";
    my $ot;
    my $num_ot = scalar(@{$obj_types});
    print "displ_link_object num_obj_types $num_ot<br>\n";
    foreach $ot (@{$obj_types}){
	if($ot eq $obj_type_code){
	    print "<option selected>$ot\n";
        } else {
            print "<option>$ot\n";
	}

    }
    print "</select>";
    print "</td><td>";
    print $cgi->textfield(-name=>$param_names->{'link_object_codes'},
                           -value=>$obj_code,
			   -size=> SHORT_LEN,
			      -maxlength=> SHORT_LEN);

    print "</td><td>";
    my $object_name = $obj_name;
    if (!$object_name) {
	if ($obj_code) {$object_name = "<font color=red>not found</font>";}
        else {$object_name = "&nbsp;"};
    }
    print "$object_name";
#    print $cgi->textfield(-name=>$param_names->{'link_object_names'},
#                           -value=>$obj_name,
#			   -size=> SHORT_LEN,
#			      -maxlength=> SHORT_LEN);
    print "</td></tr>\n"; 
}

###
sub get_dlc_objects{
    my($lda, $dlc_id, $r_object_code2name, 
    $r_dlc_objects, $r_dlc_object_types) = @_;
    
    my $stmt = qq{select object_type_code, object_code
               from $g_owner.object_link
               where dept_id = $dlc_id
               order by object_type_code, object_code};
    my $csr = $lda->prepare($stmt);
    my $error = get_db_error_msg($lda);
    if($error){return $error;}

    $csr->execute;
    my $error = get_db_error_msg($lda);
    if($error){return $error;}

    my @rec;
    my($object_type_code, $p_object_type_code,
    $object_code, $object_name);
    my $count = 0;
    my $num_objects_of_given_type = 0;

    while(@rec = $csr->fetchrow_array ) {
       $object_type_code = $rec[0];
       $object_code = $rec[1];
       $object_name = 
           $r_object_code2name->{"${object_type_code}${delim1}${object_code}"};

       if($count == 0){$p_object_type_code = $object_type_code};
       if($object_type_code ne $p_object_type_code){
	   $r_dlc_object_types->{$p_object_type_code} = $num_objects_of_given_type;
           $num_objects_of_given_type = 0;
           $p_object_type_code = $object_type_code;
       }
       my $record = [$object_type_code, $object_code, $object_name];
       if(!$r_dlc_objects->{$object_type_code}){
           $r_dlc_objects->{$object_type_code} = [];
       }
       push @{$r_dlc_objects->{$object_type_code}}, $record;
       $num_objects_of_given_type++;
       $count++;
    }

    $r_dlc_object_types->{$p_object_type_code} = $num_objects_of_given_type;
    return $error;
}
###############################################################################
#  
#  generate_edit_page($params) 
#
#  prints HTML code to generate the "Edit DLC" page
#
###############################################################################
sub generate_edit_page{
    my ($params) = @_;

    ### Get all variables ###
      ### Generic variables
      my $lda = $params->{-lda};
      my $cgi = $params->{-cgi};
      my $error = $params->{-error};
      my $p_back_page  =  $params->{-back_page};

      ### Mdept specific variables
      my $p_view_type = $params->{-view_type};
      my $p_show_link_name = $params->{-show_link_name};
      my $p_dlc_id  =  $params->{-dlc_id};
      my $p_dlc_code = $params->{-dlc_code};
      my $p_short_name  =  $params->{-short_name};
      my $p_name  =  $params->{-name};
      my $p_dlc_type  =  $params->{-dlc_type};

    my $p_parent_dlc_codes = [];
    my $p_parent_dlc_types = [];
    my ($pdlcc, $pdlct);
    my $num_par = scalar(@{$params->{-parent_dlc_codes}});
    my $cnt_par;
    ## Ignore empty parent dlc codes ###
    for($cnt_par = 0; $cnt_par < $num_par; $cnt_par++){
        $pdlcc = $params->{-parent_dlc_codes}->[$cnt_par];
        $pdlct = $params->{-parent_dlc_types}->[$cnt_par];
        if($pdlcc){
           push(@{$p_parent_dlc_codes}, $pdlcc);
           push(@{$p_parent_dlc_types}, $pdlct);
	}
    }

    ############################
    ### If info is not present in params - get it from DB ###
    my $dlc_id = $p_dlc_id;
    if (($p_dlc_code) && !($dlc_id)) {
         print "<font color=red>Error: DLC code '" . $params->{-dlc_code} 
            . "' not found.</font><BR>\n";
         die "DLC code '$p_dlc_code' not found.";
    }

    my %db_dlc_info = ();
    ### Get DB info ###
    my $db_error = get_dlc_info_by_id($params, $dlc_id, \%db_dlc_info);
    if(!$error){
	$error = $db_error;
    }

    if(!$p_dlc_code){$p_dlc_code = $db_dlc_info{-d_code};}
    if(!$p_short_name){$p_short_name = $db_dlc_info{-short_name};}
    if(!$p_name){$p_name = $db_dlc_info{-long_name};}
    if(!$p_dlc_type){$p_dlc_type = $db_dlc_info{-dlc_type};}
    if(!@{$p_parent_dlc_codes}){
       $db_error =  get_all_dlc_parents_by_id($params, $dlc_id, \%db_dlc_info);
       my $pa_dlci;
       my($pa_d_code, $pa_view_subtype_id);
       foreach $pdlci (@{$db_dlc_info{-parent_dlc_info}}){
	   $pa_d_code = $pdlci->[1];
           $pa_view_subtype_id = $pdlci->[4];
        if($pa_d_code){
	   push(@{$p_parent_dlc_codes}, $pa_d_code);
           push(@{$p_parent_dlc_types}, $pa_view_subtype_id);
        }
       }
    }
    print "<HTML>\n";
    print "<HEAD>";
    print "<TITLE>Update a DLC or Node</TITLE></HEAD>", "\n";
    print "<BODY bgcolor=\"#fafafa\">";
    &print_mdept_header("Update a DLC or Node", 'https');
    print "<HR>\n";

    if ( $error ) {
	print "<p> <font color=red> $error \n</font>";
    }
#    print "<br><b>Current View Type</b>&nbsp;$p_view_type<br>\n";

    delete_cgi_params($cgi);

    ### preparations ###
    my $dlc_info = {};
    get_complete_dlc_info($lda, $dlc_id, $dlc_info);

    ### Delete button form
    print $cgi->startform, "\n";
       put_view_type_in_cgi($cgi, $p_view_type); 
       my $delete_dlc_button = $buttons->{'delete_dlc'};
       print "<p>" , $cgi->submit(-name => 'delete_dlc', 
                     -value=>$delete_dlc_button);
       print $cgi->hidden($param_names->{'dlc_id'}, $p_dlc_id), "\n";
    print $cgi->endform(), "\n";

    ### General edit DLC form 
    print $cgi->startform, "\n";

     put_view_type_in_cgi($cgi, $p_view_type);
     print $cgi->hidden($param_names->{'dlc_id'}, $p_dlc_id), "\n";
    print "<TABLE>\n";

    print "<tr><td><b>DLC ID Number</b></td><td>",
            $dlc_id,    
           "</td></tr>\n" ;

    print_dlc_info($params);
    print "</table>\n";

    print_parent_dlcs($params, $p_parent_dlc_codes, $p_parent_dlc_types);

        ### Buttons ###
    print "<p><center><table width=\"60%\"", 
          "<tr><td align=center>",
          $cgi->submit(-name => 'change_dlc',
                       -value => $buttons->{'change_dlc'}),
          "</td><td align=center>",
          $cgi->submit(-name => 'cancel_dlc', 
                       -value => $buttons->{'cancel_dlc'}),
          "</td></tr></table></center>";
    print $cgi->endform, "\n";

    print_summary_of_parent_link_types($lda);
    return;

}
####
sub display_reg_field{
    my($val) = @_;
    unless ($val) {$val = "&nbsp;"}
    print "<td>$val</td>"; 
}
###############################################################################
#
#  generate_remove_dialog_script();
#
#  Generates the HTML to generate JavaScript to the remove dialog popup
#
###############################################################################
sub generate_remove_dialog_script {
    print <<END_OF_SCRIPT;
    <script language="JavaScript1.1">
      function confirm_delete(smth){
        var msg;
        msg = "Do you really want to delete : " + smth;
        if (confirm(msg)) {return true;}
        return false;
      }
    </script>
END_OF_SCRIPT
}
#####
sub generate_back_script {
    print <<END_OF_SCRIPT;
    <script language="JavaScript1.1">
      function back(loc){
        location = loc;
        return true;
      }
    </script>
END_OF_SCRIPT
}
###############################################################################
sub generate_remove_dialog_script_old {

    print "<script language=\"JavaScript1.1\">\n";
    print "function confirm_delete_type()\n";
    print "{\n";
    print "    var msg;\n";
    print '    msg = "\nDo you really want to delete the Type: "' . "\n"; 
    print '		+ confirm_delete_type.arguments[0]' . "\n";
    print '		    + "\n";' . "\n";
    print "    var arg;\n";
    print "    var loc;\n\n";
    print "    var arg2;\n";
    print "    var loc2;\n\n";
    print '    arg  = confirm_delete_type.arguments[0]' . "\n";
    print '    arg2 = confirm_delete_type.arguments[1]' . "\n";
    print '        if (confirm(msg)) {' ."\n";
    print ("          loc  = '", 
	   $cgi->url(-relative=>1),
	   '?',
	   $buttons->{'delete'},
	   '=1&',
	   $param_names->{'id'},
	   "=';\n",
	   );
    print ("          loc2 = '", 
	   '&',
	   $param_names->{'name'},
	   "=';\n",
	   );
    
    print '          location = loc + arg2 + loc2 +arg;' . "\n";

    print '   }' ."\n";
    print '}' . "\n";
    print '</script>' ."\n";
}
###############################################################################
#
#  cert_check();
#
#  Checks kerberos certificates to see if user is authenticated as
#  the proper user.
#  If user is not authenticated properly, generates HMTL for error
#  and stops script
#  else, returns 1
#
#  Uses:    ehs: parse_ssl_info,check_cert_source
#  Returns: Username (all CAPS)
#
###############################################################################
sub cert_check {

    my $info = $ENV{"REMOTE_USER"};  # Get certificate information
    my %ssl_info = &parse_ssl_info($info);  # Parse certificate

    my $full_name = $ssl_info{'CN'};   # Get full name from cert. 'CN' field

    my ($k_principal, $domain) = split("\@", $info);
    $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase

#    print "Email: $email<br>\n";
#    print "Full name $full_name<br>\n";

    if (!$k_principal) {
        print "<HTML>", "\n";
	print "<br><b>No certificate sent.  Use https:// , not http://</b>\n";
        print "</HTML>", "\n";
	exit();
    }
 
#
#  Check the other fields in the certificate
#
    my $result = &check_cert_source($info);
    if ($result ne 'OK') {
	print "<br><b>Your certificate cannot be accepted: $result";
	exit();
    }

    return $k_principal;
}

###############################################################################
#
#  Function auth_check($lda, $username)
#
#  Returns: 1 if specified user can maintain training rules, 0 otherwise
#
###############################################################################
sub auth_check {
  my ($lda, $username) = @_;

 #
 #  For testing, set a different $username.
 #
 # $username = 'JAD2';  


  my $stmt1 = "select can_maintain_any_dept(\'$username\') from dual";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt1)) 
  {
     &web_error("Error preparing statement "
                . "$stmt1.<BR>"
                . $lda->errstr . "<BR>");
  }
  $csr1->execute;

  my $can = $csr1->fetchrow_array;
  $csr1->finish; 

  $can = ( $can eq 'Y' ) ? 1 : 0;
  return $can;
}

####
###########################################################################
#
#  Function open_cursor1
#
#  Opens a cursor to a select statement to return details about a 
#  node or DLC in the hierarchy.
#
###########################################################################
sub open_cursor1 {
  my ($lda) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = "select d.dept_id, d.d_code, d.long_name"
           . " from $g_owner.department d"  
           . " where dept_id = ?"
           . " order by d_code";
  my $csr1;
  unless ($csr1 = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }

  return $csr1;
}
####
###########################################################################
#
#  Function open_cursor2
#
#  Opens a cursor to a select statement to return a list of child nodes
#  under a given node
#
###########################################################################
sub open_cursor2 {
  my ($lda) = @_;

  #
  #  Open connection to oracle
  #
   my $stmt = 
      "select dc.child_id
       from $g_owner.department_child dc, $g_owner.view_type_to_subtype s, 
       $g_owner.department d
       where dc.parent_id = ?
       and s.view_subtype_id = dc.view_subtype_id
       and s.view_type_code = ?
       and d.dept_id = dc.child_id
       order by d.d_code";
   my $csr2;
   unless ($csr2 = $lda->prepare($stmt)) {
       print "Error preparing select statement: " . $DBI::errstr . "<BR>";
   }

   return $csr2;
}


###########################################################################
#
#  Subroutine print_tree
#
###########################################################################
sub print_tree {
  my ($lda, $csr1, $csr2, $root_id, $level, $view_type_code, 
      $prefix_string, $is_last_sibling) = @_;

  unless ($csr2->bind_param(1, $root_id)) {
      print "Error binding param: " . $DBI::errstr . "<BR>";
  }
  unless ($csr2->bind_param(2, $view_type_code)) {
      print "Error binding param: " . $DBI::errstr . "<BR>";
  }
  unless ($csr2->execute) {
      print "Error executing select statement: " . $DBI::errstr . "<BR>";
  }
  
  #
  #  Print information about the current node
  #
   my $indent_string = $prefix_string;
   print "$indent_string+--";
   &print_dlc_detail_in_tree($lda, $csr1, $root_id);
   push(@g_dept_id_list, $root_id);
   push(@g_dept_level, $level);

  #
  #  Get child nodes
  #
  my ($child_id);
  my @child_list = ();
  while (($child_id) = $csr2->fetchrow_array) {
    push(@child_list, $child_id);
  }

  #
  #  Print child nodes
  #
  my $levelplus1 = $level + 1;
  my $n = @child_list;
  my $i = 0;
  my $new_last_sibling = 0;
  my $new_prefix_string;
  foreach $child_id (@child_list) {
    if (++$i == $n) {$new_last_sibling = 1;}
    if ($is_last_sibling) {
      $new_prefix_string = $prefix_string . "&nbsp;&nbsp;&nbsp;";
    }
    else {
      $new_prefix_string = $prefix_string . "|&nbsp;&nbsp;";
    }
    &print_tree($lda, $csr1, $csr2, $child_id, $levelplus1, $view_type_code,
                $new_prefix_string, $new_last_sibling);
  }

}

###########################################################################
#
#  Subroutine print_dlc_type_table
#
#  For testing purposes, prints a flat list of departments
#
###########################################################################
sub print_dlc_type_table {
  my ($lda) = @_;

  #
  #  Open cursor
  #
  my $stmt = "select t.dept_type_id, t.dept_type_desc"
           . " from $g_owner.dept_node_type t"  
           . " order by t.dept_type_id";
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  
  #
  #  Get a list of dept_types
  #
  my @type_id = ();
  %type_desc = ();
  my ($ttid, $ttdesc);
  while ( ($ttid, $ttdesc) = $csr->fetchrow_array)
  {
        push(@type_id, $ttid);
        $type_desc{$ttid} = $ttdesc;
  }
  $csr->finish();
 #
 #  Print list of department types
 #
  print "<blockquote>";
  print "<TABLE border>\n";
  print "<caption align=type>List of DLC types</caption>\n";
  print "<tr><th>Type*</th><th>Description</th></tr>\n";
  foreach $ttid (@type_id) {
     print "<tr><td>$ttid</td><td>$type_desc{$ttid}</td>"
           . "</tr>\n";
  }
  print "</TABLE>", "\n";
  print "</blockquote>";

}
###
sub get_dlc_info{
    my ($lda, $dlc_info, $dids) = @_;
    my $stmt = "select d.dept_id, d.d_code, d.long_name, d.short_name,"
           . " t.dept_type_id"
           . " from $g_owner.department d, $g_owner.dept_node_type t"  
           . " where t.dept_type_id = d.dept_type_id"
           . " order by d_code";
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  my ($ddid, $ddcode, $ddname, $ddsname, $ddtype);
  while ( ($ddid, $ddcode, $ddname, $ddsname, $ddtype) = $csr->fetchrow_array)
  {
        push(@$dids, $ddid);
        if(!$dlc_info->{$ddid}){
            $dlc_info->{$ddid}= {};
        }
        $dlc_info->{$ddid}->{-ddcode} = $ddcode;
        $dlc_info->{$ddid}->{-ddname} = $ddname;
        $dlc_info->{$ddid}->{-ddsname} = $ddsname;
        $dlc_info->{$ddid}->{-ddtype} = $ddtype;
  }
  $csr->finish();
}
###
sub print_all_depts_header{
  print "<TABLE border width=\"100%\">", "\n";
  print "<caption align=type>Table of DLCs with detailed information"
        . "</caption>\n";
  print "<tr><td width=\"1%\"></td><td width=\"10%\"></td>"
        . "<td width=\"1%\"></td><td width=\"1%\"></td>"
        . "<td width=\"20%\"></td><td></tr>\n";
  print "<tr bgcolor=\"#E0E0E0\">"
        . "<th>DLC Code</th>"
        . "<th>DLC ID</th>"
        . "<th>Type*</th>"
        . "<th colspan=2>Long Name</th>"
        . "<th>Short Name</th></tr>\n";
  print "<tr><th>&nbsp;</th>"
        . "<th colspan=2>Linked object type</th>"
        . "<th>Object code</th>"
        . "<th colspan=2>Object name</th></tr>\n";
  print "<tr><th colspan=6></th></tr>\n";
}

###
### This subroutine does not seem to be used ###
sub get_object_info{
    my($lda, $object_info)=@_;
    $object_info->{-object_type} = [];
    $object_info->{-object_type_desc}={};
    $object_info->{-dlc_object_link} = {};
    $object_info->{-object_code2name} = {};

    my $delim1 = '!';
    &get_object_types($lda, $object_info->{-object_type}, 
    $object_info->{-object_type_desc});

    &get_dlc_object_link($lda, $delim1, 
			 $object_info->{-dlc_object_link});
    if ($g_show_link_name eq 'Y') {
       &get_object_names($lda, $delim1, 
       $object_info->{-object_code2name});
    }
}
###########################################################################
#
#  Subroutine get_view_info($lda, $view_type_code);
#
#  Looks up the view_type_code and returns (<description>, <root_id>)
#
###########################################################################
sub get_view_info {
  my ($lda, $view_type_code) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = "select view_type_desc, root_dept_id"
           . " from $g_owner.view_type"  
           . " where view_type_code = '$view_type_code'";
#  print "get view info Statement $stmt<br>\n";
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  
  #
  #  Get info about a DLC
  #
  my ($view_desc, $root_id);
  ($view_desc, $root_id) = $csr->fetchrow_array;
  $csr->finish();

  #
  #  Print info
  #
  return ($view_desc, $root_id);

}

###########################################################################
#
#  Subroutine get_object_types($lda, \@object_type, \%object_type_desc)
#
#  Gets an array of object_types (@object_type) and a hash %object_type_desc
#  where $object_type_desc{$object_type} = <description of this object type>
#
###########################################################################
sub get_object_types {
  my ($lda, $robject_type, $robject_type_desc) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = "select object_type_code, obj_type_desc"
           . " from $g_owner.object_type"  
           . " order by obj_type_desc";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  
  #
  #  Get object types and their descriptions
  #
  my ($object_type, $object_type_desc);
  @$robject_type = ();
  %$robject_type_desc = ();
  while ( ($object_type, $object_type_desc) = $csr->fetchrow_array ) {
    push(@$robject_type, $object_type);
    $$robject_type_desc{$object_type} = $object_type_desc;
  }
  $csr->finish();

}

###########################################################################
#
#  We save the old version here while testing.  The subroutine can be
#  deleted when testing is done.
#
#  Subroutine get_object_names_old($lda, $delim, \%object_code2name)
#
#  Gets a hash of object_codes and their names, where 
#     $object_code2name{"$object_type$delim$object_code} = $object_name
#
###########################################################################
sub get_object_names_old {
  my ($lda, $delim, $robject_code2name) = @_;

  #print "Here we are in 'get_object_names'<BR>";

  #
  #  Open connection to oracle
  #
  my $stmt = 
   "select l.object_type_code, l.object_code, q.qualifier_name
    from ${g_owner}.object_link l, rolesbb.qualifier q
    where l.object_type_code 
        in ('ORGU', 'ORG2', 'BAG', 'FC', 'SPGP', 'LORG', 'SIS')
    and q.qualifier_code = l.object_code
    and q.qualifier_type = CASE l.object_type_code  WHEN 'ORGU' THEN  'ORGU' 
                                 WHEN 'ORG2' THEN  'ORG2' WHEN  'BAG' THEN  'BAGS'
                                 WHEN 'FC' THEN  'FUND' WHEN  'SPGP' THEN  'SPGP'
                                 WHEN 'LORG' THEN 'LORG' WHEN  'SIS' THEN  'SISO'
                                 WHEN 'PMIT' THEN 'PMIT' END
    union select l.object_type_code, l.object_code, q.qualifier_name
    from ${g_owner}.object_link l, rolesbb.qualifier q
    where l.object_type_code = 'PC'
    and q.qualifier_code = 
      replace(replace(l.object_code, '0P', '0HP'), 'P', 'PC')
    and q.qualifier_type = 'COST'";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  
  #
  #  Get object codes and their names
  #
  my ($object_type, $object_code, $object_name);
  %$robject_code2name = ();
  while ( ($object_type, $object_code, $object_name) = $csr->fetchrow_array ) {
    $$robject_code2name{"$object_type$delim$object_code"} = $object_name;
  }
  $csr->finish();

}

###########################################################################
#
#  Subroutine get_object_names($lda, $delim, \%object_code2name)
#
#  Gets a hash of object_codes and their names, where 
#     $object_code2name{"$object_type$delim$object_code} = $object_name
#
###########################################################################
sub get_object_names {
  my ($lda, $delim, $robject_code2name, $dlc_id) = @_;

  #print "Here we are in 'get_object_names'<BR>";

  #
  #  If a $dlc_id is provided, then only find the object names for objects
  #  linked to this DLC.  This will run faster.
  #
  my $sql_frag = '';
  if ($dlc_id) {
      $sql_frag = "and l.dept_id = '$dlc_id'";
  }

  #
  #  Build some SQL fragments from the MDEPT object_type table
  #
  my $object_type_list;
  #   = "'ORGU', 'ORG2', 'BAG', 'FC', 'SPGP', 'LORG', 'SIS', 'PMIT', 'PBM'";
  my $obj_type_qualtype_pairs_list;
  #  = "'ORGU', 'ORGU', 'ORG2', 'ORG2', 'BAG', 'BAGS', "
  #    . "'FC', 'FUND', 'SPGP', 'SPGP', 'LORG', 'LORG', 'SIS', 'SISO',"
  #    . "'PMIT', 'PMIT', 'PBM', 'PBM1'";
  my $object_type2qualtype;
  &get_object_type_info ($lda, \%object_type2qualtype);
  foreach $key (keys %object_type2qualtype) {
      if ($object_type_list) {
	  $object_type_list .= ", '$key'";
          $obj_type_qualtype_pairs_list .= 
              ", '$key', '$object_type2qualtype{$key}'";
      }
      else {
	  $object_type_list = "'$key'";
          $obj_type_qualtype_pairs_list = 
              "'$key', '$object_type2qualtype{$key}'";
      }
  }

my $qual_case = " CASE l.object_type_code ";
  my $i = 0;
  my @arr = split(/\,/,$obj_type_qualtype_pairs_list);
  my $count=@arr;

  my $val1, $val2 ,$when_str;
  foreach (@arr) {
        if ($i % 2 == 0)
        {
                 $val1 = $_;
                 $val2 = "";
                $when_var = " ";
        }
        else
        {
                 $val2 = $_;
                $when_var = " WHEN $val1 THEN $val2 ";
                $qual_case = $qual_case . $when_var;
        }
        $i++;
  }

  $qual_case = $qual_case .  " END ";

  #
  #  Define and open a cursor to a select statement for object names
  #
  my $stmt = 
   "select l.object_type_code, l.object_code, q.qualifier_name
    from ${g_owner}.object_link l, rolesbb.qualifier q
    where l.object_type_code 
        in ($object_type_list)
    $sql_frag
    and q.qualifier_code = l.object_code
    and q.qualifier_type = $qual_case
    and (l.object_type_code <> 'PMIT' 
         or substr(replace(l.object_code, 'PC', 'P'),1,2)
                   not between 'P000000' and 'P999999')
    union select l.object_type_code, l.object_code, q.qualifier_name
    from ${g_owner}.object_link l, rolesbb.qualifier q
    where l.object_type_code in ('PC', 'PMIT')
    $sql_frag
    and q.qualifier_code = 
      replace(replace(l.object_code, '0P', '0HP'), 'P', 'PC')
    and q.qualifier_type = CASE l.object_type_code WHEN 'PC' THEN  'COST' 
                                 WHEN 'PMIT' THEN 'PMIT' END ";
  #print "'$stmt'<BR>";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  
  #
  #  Get object codes and their names
  #
  my ($object_type, $object_code, $object_name);
  %$robject_code2name = ();
  while ( ($object_type, $object_code, $object_name) = $csr->fetchrow_array ) {
    $$robject_code2name{"$object_type$delim$object_code"} = $object_name;
  }
  $csr->finish();

}

###########################################################################
#
#  Subroutine get_dlc_object_link($lda, $delim, \%dlc_object_link);
#
#  Finds object links for each DLC.  
#  Builds hash %dlc_object_link, setting
#    $dlc_object_link{$dlc_id . $delim . $object_type} = 
#         $object1 . $delim . $object2 . $delim ...
#
###########################################################################
sub get_dlc_object_link {
  my ($lda, $delim, $rdlc_object_link) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = "select dept_id, object_type_code, object_code"
           . " from $g_owner.object_link"  
           . " order by dept_id, object_type_code, object_code";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  
  #
  #  Get object links
  #
  my ($dept_id, $object_type, $object_code);
  my ($current_key, $prev_key) = '';
  while ( ($dept_id, $object_type, $object_code) = $csr->fetchrow_array ) {
    $current_key = $dept_id . $delim . $object_type;
    if ($current_key eq $prev_key) {
      $$rdlc_object_link{"$dept_id$delim$object_type"} .= "$delim$object_code";
    }
    else {
      $$rdlc_object_link{"$dept_id$delim$object_type"} = $object_code;
    }
    $prev_key = $current_key;
  }
  $csr->finish();

}

###########################################################################
#
#  Subroutine get_object_type_info($lda, \%object_type2qualtype);
#
#  Builds a hash of object_type codes to Roles qualifier types.
#
###########################################################################
sub get_object_type_info {
  my ($lda, $robject_type2qualtype) = @_;

  #
  #  Open connection to oracle
  #
  my $stmt = "select object_type_code, roles_qualifier_type
              from $g_owner.object_type
              order by 1";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
      print "Error preparing select statement: " . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  
  #
  #  Get object type -> qualifier type pairs
  #
  my ($object_type, $qualtype);
  while ( ($object_type, $qualtype) = $csr->fetchrow_array ) {
      $$robject_type2qualtype{$object_type} = $qualtype;
  }
  $csr->finish;

}

###########################################################################
#
#  Subroutine print_dlc_detail_in_tree
#
###########################################################################
sub print_dlc_detail_in_tree {
  my ($lda, $csr1, $dept_id) = @_;

  unless ($csr1->bind_param(1, $dept_id)) {
      print "Error binding param: " . $DBI::errstr . "<BR>";
  }
  unless ($csr1->execute) {
      print "Error executing select statement: " . $DBI::errstr . "<BR>";
  }
  
  #
  #  Get info about a DLC
  #
  my ($ddid, $ddcode, $ddname);
  ($ddid, $ddcode, $ddname) = $csr1->fetchrow_array;

  #
  #  Print info
  #
   print "<b><a href=\"#$ddid\">"
         ." $ddcode</a></b> $ddname ($ddid)<BR>\n";

}

###########################################################################
#
#  Function add_name_to_code($temp_object_link, $object_type, 
#                            $delim, \%object_code2name)
#
#  Splits up object_link string into individual object_codes, 
#  adds names after each object_code,
#  and puts the string back together.
#
###########################################################################
sub add_name_to_code {
  my ($old_object_string, $object_type, $delim, $robject_code2name) = @_;

  my @object_array = split($delim, $old_object_string);
  my $new_object_string = '';
  my ($object_item, $object_name);
  $first_time = 1;
  foreach $object_item (@object_array) {
    $object_name = $$robject_code2name{"$object_type$delim$object_item"};
    unless ($object_name) {
      $object_name = "<font color=red>not found</font>";
    }
    $object_item = "<b>$object_item</b> $object_name";
    if ($first_time) {
      $new_object_item = $object_item;
      $first_time = 0;
    }
    else {
      $new_object_item .= "$delim$object_item";
    }
  }
  return $new_object_item;

}

###########################################################################
#
#  Function get_name_from_code($temp_object_link, $object_type, 
#                              $delim, \%object_code2name)
#
#  Splits up object_link string into individual object_codes, 
#  gets a list of names associated with each object_code,
#  and puts the string back together.
#
###########################################################################
sub get_name_from_code {
  my ($temp_object_string, $object_type, $delim, $robject_code2name) = @_;

  my @object_array = split($delim, $temp_object_string);
  my $name_string = '';
  my ($object_item, $object_name);
  $first_time = 1;
  foreach $object_item (@object_array) {
    $object_name = $$robject_code2name{"$object_type$delim$object_item"};
    unless ($object_name) {
      $object_name = "<font color=red>not found</font>";
    }
    if ($first_time) {
      $name_string = $object_name;
      $first_time = 0;
    }
    else {
      $name_string .= "$delim$object_name";
    }
  }
  return $name_string;

}
###
sub get_one_dlc_info{
    my($lda, $ddid) = @_;

     my $stmt = "select d.dept_id, d.d_code, d.short_name, d.long_name,
                d.DEPT_TYPE_ID, 
                dnt.DEPT_TYPE_DESC
           from $g_owner.department d, $g_owner.dept_node_type dnt 
	   where dept_id = $ddid
           and d.DEPT_TYPE_ID = dnt.DEPT_TYPE_ID";
  my $csr;
  unless ($csr = $lda->prepare($stmt)) {
       print "Error preparing select statement: $stmt" . $DBI::errstr . "<BR>";
  }
  $csr->execute;
  my ($dept_id, $d_code, $short_name, $long_name, 
      $dept_type_id, $dept_type_desc) = $csr->fetchrow_array;

  $csr->finish();
  return ($dept_id, $d_code, $short_name, $long_name, 
	  $dept_type_id, $dept_type_desc);
}
###
sub get_complete_dlc_info{
    my($lda, $ddid, $dlc_info) = @_;

    ## Assume that no ddid implies add dlc situation
    if(!$ddid){return;}

    my ($dept_id, $d_code, $short_name, $long_name, 
      $dept_type_id, $dept_type_desc) = get_one_dlc_info($lda, $ddid);
    $dlc_info->{-dept_id}=$dept_id;
    $dlc_info->{-d_code}=$d_code;
    $dlc_info->{-short_name}=$short_name;
    $dlc_info->{-long_name}=$long_name;
    $dlc_info->{-dept_type_id}=$dept_type_id;
    $dlc_info->{-dept_type_desc}=$dept_type_desc;
}

###########################################################################
#
#  Subroutine print_params_test
#
###########################################################################
sub print_params_test {
  my ($params) = @_;
  print "In print_params_test<BR>";
  my $view_type = $params->{-view_type};
  my $dlc_id = $params->{-dlc_id};
  print "view_type = '$view_type' dlc_id = '$dlc_id'<BR>";

}


###########################################################################
#
#  Subroutine print_child_test
#
###########################################################################
sub print_child_test {
  my ($lda, $csr2, $dept_id, $view_type_code) = @_;

  unless ($csr2->bind_param(1, $dept_id)) {
      print "Error binding param: " . $DBI::errstr . "<BR>";
  }
  unless ($csr2->bind_param(2, $view_type_code)) {
      print "Error binding param: " . $DBI::errstr . "<BR>";
  }
  unless ($csr2->execute) {
      print "Error executing select statement: " . $DBI::errstr . "<BR>";
  }
  
  #
  #  Get child nodes
  #
  my ($child_id);
  print "Child nodes of $dept_id:<BR>";
  while (($child_id) = $csr2->fetchrow_array) {
    print "&nbsp;&nbsp;$child_id<BR>";
  }

}
##############################################
1;
