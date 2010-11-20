
=head1 NAME

RolesUnparsable - represent a full-line unparsable or whitespace

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

use RolesUnparsable; # isa RolesItem

###########
# methods #
###########

$obj=RolesUnparsable->new(\$line_of_text);

$obj->error($msg); # inherited from RolesItem
$obj->render();    # inherited from RolesItem
$obj->transact();  # apply to the database (generate error)

=head1 DESCRIPTION

The RolesUnparsable class creates objects that represent lines
of input which could not be successfully parsed.  Any attempt
to apply such lines to the database (which, given the logic
of the program, shouldn't happen) will generate an error.

=cut

# ------------------------------------------------------

package RolesUnparsable;

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
  $self->{IS_UNPARSABLE}=1;
  $self->error("can't figure out how to interpret this line");
  # done
  return $self;
}

# -- object methods --

sub transact {
  # do nothing, return a value signifying transaction failed
  return 0;
}

# ------------------------------------------------------

1;

