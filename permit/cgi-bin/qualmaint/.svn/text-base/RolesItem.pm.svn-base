
=head1 NAME

RolesItem - abstract how text is converted to database transactions

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

use RolesItem;

###########
# methods #
###########

# only RolesItem subclasses should use these methods

$obj=RolesItem->new(\$line); # keep reference to input

$obj->error($msg);           # put in error state, store msg
$obj->render();              # display appropriately

=head1 DESCRIPTION

The RolesItem class creates objects that represent the attempt
to parse a line of input and generate a database transaction.
Each object stores a reference to its original input text,
together with any (but only the most recent) error information
that may have been reported.  Objects need to be able to
render themselves into a string for display purposes; this
causes the original input to be displayed, possibly prefixed
by an error message if the object is in an error state.

RolesItem is a class that should only be used by its subclasses.

=cut

# ------------------------------------------------------

package RolesItem;

use strict;

# -- object construction/destruction protocol --

sub new {
  my $class=shift;
  my $self=bless {},$class;
  $self->{LINE_REF}=shift;
  return $self;
}

# -- object methods --

sub error {
  my $self=shift;
  $self->{IS_ERROR}=1;
  $self->{MSG}=shift;
}

sub render {
  my $self=shift;
  my $msg="";
  if ($self->{IS_ERROR}) {
    $msg="* error on next line: $self->{MSG}\n";
  }
  # if this is an error comment line, absorb it, otherwise output the message
  if (!(${$self->{LINE_REF}} =~ /^\* error.*/)) {
    return $msg."${$self->{LINE_REF}}\n";
  }
}

# ------------------------------------------------------

1;

