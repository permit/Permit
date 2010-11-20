
=head1 NAME

RolesSSL - verify user SSL certificates

=head1 SYNOPSIS
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

use RolesSSL;

###########
# methods #
###########

$id=RolesSSL->kerberos_id;

=head1 DESCRIPTION

The RolesSSL class enforces checking of the user certificate
via package initialization.  The kerberos id is then used
by RolesDB as the proxy for invoking the stored procedures
that change qualifier data.

=cut

# ------------------------------------------------------

package RolesSSL;

use RolesError;
use strict;

# -- class attributes --

my %_Certificate=undef;
my $_KerberosID=undef;
my $_Domain=undef;

# -- class attribute methods --

sub certificate {
  return \%RolesSSL::_Certificate;
}

sub email {
  return $RolesSSL::_Certificate{emailAddress};
}

sub full_name {
  return $RolesSSL::_Certificate{CN};
}

sub kerberos_id {
  return $RolesSSL::_KerberosID;
}

sub domain {
  return $RolesSSL::_Domain;
}

sub establish_user {
  my $info = $ENV{"REMOTE_USER"};  # Get certificate information
  $info =~ tr/\n//;      # Get rid of newline(s)
 
  my ($k_principal, $domain) = split("\@", $info);
  if (!$k_principal) {
    RolesError::death("$info - No certificate sent.  Use https:// , not http://");
  }
  my $k_principal =~ tr/a-z/A-Z/;  # Raise username to uppercase
  my $result = &check_auth_source($info); # Check other certificate fields

  if ($result ne 'OK') {
    	RolesError::death("  Your certificate cannot be accepted: $result");
  }
 return $result;
}

sub check_auth_source {
        my $result = 'OK';  # Default result
        my $info = $_[0];  # Get reference to a hash
        my ($k_principal, $domain) = split("\@", $info);
        if (!$k_principal) {
                $result = "No Principal Id";
        }
        elsif (!$domain || lc($domain) != 'mit.edu' ) {
                $result = "Not Valid Domain ";
        }
  	$RolesSSL::_KerberosID = uc($k_principal);
  	$RolesSSL::_Domain = uc($domain);

    return $result;
}

sub parse_ssl_info {
        my $info = $ENV{"REMOTE_USER"};
	return $info;
}

sub parse_authentication_info {
    my $info = $ENV{"REMOTE_USER"};
    $info =~ tr/\n//;      # Get rid of newline(s)
    my ($k_principal, $domain) = split("\@", $info);
    return ($info,$k_principal, $domain);
}


##############################################################################
#
# Function &check_cert_source(\%ssl_info)
#
# Looks at parameters in the %ssl_info hash to make sure the certificate
# came from Country=US, State=Massachusetts,
# Org=Massachusetts Institute of Technology
# Also checks to make sure the email address is in the domain MIT.EDU
#
# If everything is OK, return 'OK'.  If not, return an error message.
#
##############################################################################
sub check_cert_source {
  my $ref=shift;
  my %rssl_info = %{$ref};  # Get reference to a hash
  my $result = 'OK';  # Default result
  if ($rssl_info{'C'} ne 'US') {
    $result = "Wrong certificate authority.  Country='$rssl_info{'C'}'"
              . " (should be 'US')";
  } elsif ($rssl_info{'ST'} ne 'Massachusetts') {
    $result = "Wrong certificate authority.  State='$rssl_info{'ST'}'"
              . " (should be 'Massachusetts')";
  } elsif ($rssl_info{'O'} ne 'Massachusetts Institute of Technology') {
    $result = "Wrong certificate authority.  Org='$rssl_info{'O'}'"
              . " (should be 'Massachusetts Institute of Technology')";
  }
  my ($username, $domain) = split('@', $rssl_info{'emailAddress'});
  if ($domain ne 'MIT.EDU') {
    $result = " Wrong Email domain in certificate. domain='$domain'"
              . " (should be 'MIT.EDU')";
  }
  return $result;
}

# -- class construction/destruction protocol --

sub BEGIN {
  RolesSSL->establish_user;
}

# ------------------------------------------------------

1;

