
=head1 NAME

RolesComment - represent a full-line comment or whitespace

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

use RolesComment; # isa RolesItem

###########
# methods #
###########

$obj=RolesComment->new(\$line_of_text);

$obj->error($msg); # inherited from RolesItem
$obj->render();    # inherited from RolesItem
$obj->transact();  # apply to the database (do nothing)

=head1 DESCRIPTION

The RolesComment class creates objects that represent lines
of input which only contain comments or whitespace (and
hence result in no database transaction).

=cut

# ------------------------------------------------------

package RolesComment;

use RolesItem;
use strict;

# -- class inheritance --

use vars qw(@ISA);
@ISA=('RolesItem');

# -- object construction/destruction protocol --

sub new {
  my $class=shift;
  # invoke inherited construction
  my $self=bless $class->SUPER::new(@_),$class;
  # place any class-specific initialization here
  if (${$self->{LINE_REF}} =~ /^\s*(\*.*)?$/) { # comments begin with '*'
    $self->{IS_COMMENT}=1;
    $self->{TEXT}=${$self->{LINE_REF}};
    $self->{TEXT}=~s/^\s*(\*.*)?$/$1/;
  } else {
    return undef;
  }
  # done
  return $self;
}

# -- object methods --

sub transact {
  # do nothing, return a value signifying all is well
  return 1;
}

# if you eliminate this routine, the output will be the original
# input line(s), no whitespace removed
sub render {
  my $self=shift;
  my $msg="";
  my $line=$self->{TEXT};
  # if this is an error comment line or whitespace
  #   then absorb it
  #   otherwise output the message
  if (!($self->{TEXT} =~ /^\* error.*/) && ($self->{TEXT} =~ /^\s*\S\.*$/)) {
    return $msg."$self->{TEXT}\n";
  }
}

# ------------------------------------------------------

1;

