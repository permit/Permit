
=head1 NAME

RolesActor - provide actors for changing the Roles database

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

use RolesActor;

###########
# methods #
###########

$obj=RolesActor->new($routine_name);

$result=RolesActor->apply(@args); # invoke the routine

=head1 DESCRIPTION

The RolesActor class provides features for manipulating qualifier
data in a Roles database.  It holds the name of a routine.  When
applied, that routine is invoked with the specified arguments,
and the result is passed back to the caller.

The actor objects aren't strictly necessary, but they do
abstract away some of the interaction between RolesRecord
and RolesDB, so that changes to RolesDB should be much less
likely to require a change to RolesRecord.

=cut

# ------------------------------------------------------

package RolesActor;

use strict;

# -- object construction/destruction protocol --

sub new {
  my $class=shift;
  my $self=bless {},$class;
  $self->{TASK}=shift;
  return $self;
}

# -- object methods --

sub apply {
  my $self=shift;
  my $task=$self->{TASK};      # will be something like 'RolesDB::add_child'
  return eval("$task(\@_)");   # @_ will be the fields of the record
}

# ------------------------------------------------------

1;

