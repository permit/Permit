###############################################################################
## NAME: imprule.pm
##
## DESCRIPTION: 
## This Perl package contains common routines used by CGI scripts for
## the implied authorization rules interface
## 
## PRECONDITIONS:
##
## 1.)  use 'imprule';
##	 or
##	use 'imprule' 1.0;  #This will specify a minimum version number
##
## POSTCONDITIONS:   
##
## 1.) None.
##
#
#  Copyright (C) 2008-2010 Massachusetts Institute of Technology
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
##
## 08/25/2008 Jim Repa. -created (took get_user_categories out of rolesweb.pm)
## 08/27/2008 Jim Repa. -added more subroutines
##
###############################################################################

package imprule;
$VERSION = 1.0;
$package_name = 'imprule';

#Specify routines to be directly callable via the calling module without
#specifying the name of this package
use DBI;

use rolesweb('strip'); #Use sub. strip in rolesweb.pm
use Exporter;				#Standard Perl Module
@ISA = ('Exporter');			#Inherit from Exporter	
@EXPORT_OK = qw(get_user_categories get_rule_type_hashes user_categories_list);

$TEST_MODE = 0;            ## Test Mode (1 == ON, 0 == OFF)

if ($TEST_MODE) {print "TEST_MODE is ON for imprule.pm\n";}

##########################################################################
#
# Subroutine get_user_categories($lda, $kerbname, \%catlist) 
# Builds a hash of categories available as the Result_Category for 
# new rules creation for the given user.
#
##########################################################################
sub get_user_categories {

    my ($lda, $kerbname, $catlist) = @_;
    my ($vcat, $vcat_desc);
 
 #
 # Build select statement used in the query
 #
 
 my  $stmt ="select function_category, function_category_desc 
             from category 
             where ROLESAPI_IS_USER_AUTHORIZED('$kerbname',
                   'CREATE IMPLIED AUTH RULES',CONCAT('CAT' 
                   , rtrim(function_category)) ) = 'Y'";
 
 my $csr = $lda->prepare($stmt)
        || die $DBI::errstr;

 unless ($csr->execute) {
      print "Error executing select statement 1: " . $DBI::errstr . "<BR>";
 }

 #
 #  Get a list of function categories
 #
  
%$catlist = ();
  
 while (($vcat, $vcat_desc)
         = $csr->fetchrow_array())
 {
    $$catlist{&strip($vcat)} = $vcat_desc;
 }
 $csr->finish() || die $DBI::errstr;
  
}
 
###########################################################################
#  Subroutine user_categories_list ($lda, $username) 
#
#  Returns a list of categories accessible by current user
#  for the result function in new rule creation.
############################################################################
sub user_categories_list {
    my ($lda, $k_principal) = @_;
    my ( @user_cat, $user_category, $i, $option_string, $n);
    
    #
    # form statement used in the query
    #
    my $stmt ="select function_category
             from category 
             where ROLESAPI_IS_USER_AUTHORIZED('$k_principal',
                   'CREATE IMPLIED AUTH RULES',CONCAT('CAT' 
                   , rtrim(function_category)) ) = 'Y'";

    my $csr = $lda->prepare($stmt)
        || die $DBI::errstr;

   unless ($csr->execute) {
      print 'Error executing select statement 1: ' . $DBI::errstr . 'BR>';
   }

    
    #  Get a list of function categories
    @user_cat = ();
    $i = 0;
    while ((($user_category)
         = $csr->fetchrow_array()))
    {
        # mark any NULL fields found
        push(@user_cat, $user_category);
    }
   
    $csr->finish() || die $DBI::errstr;
   
    return @user_cat;
}

###########################################################################
#
#  Subroutine get_rule_type_hashes($lda, \%rule_code2name, \%rule_code2desc)
#
#  Returns two hashes
#   %rule_id2name maps a rule_code to its short name
#   %rule_id2desc maps a rule_code to its long description
#
###########################################################################
sub get_rule_type_hashes {
    my ($lda, $rrule_code2name, $rrule_code2desc) = @_;
    my $stmt = "select rule_type_code, rule_type_short_name, rule_type_description
             from auth_rule_type
             order by rule_type_code";
    my $csr = $lda->prepare($stmt)
        || die $DBI::errstr;

    unless ($csr->execute) {
      print 'Error executing select statement 1: ' . $DBI::errstr . 'BR>';
    }

    my ($rule_code, $rule_name, $rule_desc);
    while ((($rule_code, $rule_name, $rule_desc)
         = $csr->fetchrow_array()))
    {
	$$rrule_code2name{$rule_code} = $rule_name;
	$$rrule_code2desc{$rule_code} = $rule_desc;
    }
    $csr->finish() || die $DBI::errstr;
}

return 1;

#########################################################################
#######################       End Package          ######################  
#########################################################################
