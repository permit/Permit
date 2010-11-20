
=head1 NAME

RolesRecord - represent an input line that specifies a database change

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

use RolesRecord;

###########
# methods #
###########

$obj=RolesRecord->new(\$line); # split line into fields

$obj->error($num,$msg); # extend to contain error number
$obj->render();         # extend to display error number
$obj->transact();       # apply changes to the database

=head1 DESCRIPTION

The RolesRecord class creates objects that represent lines
of input which are used to specify changes to a Roles database.
An input line is considered to be a potential record as long
as the field separator ('!') is detected.

Record objects use RolesDB to determine what kind of change
(ADD, DELETE, ...) is being requested.  An "actor" object
is returned that will do the necessary dirty work to
apply the change to the database (the actors probably aren't
strictly necessary, but they were handy in working around some
minor problems in how Perl deals invocation of routines
specified by the string form of their name).

=cut

# ------------------------------------------------------

package RolesRecord;

use RolesItem;
use RolesDB;
use strict;

# -- class inheritance --

use vars qw(@ISA);
@ISA=('RolesItem');

# -- class methods --

# -- object construction/destruction protocol --

sub new {
  my $class=shift;
  my $ok=shift; # reference to indicate if this is recognized as a bad record
  my $qual_type=shift;
  my $prefix=shift; # string for the regex that checks for valid qualifiers
  #print "class='$class' ok='$$ok' qualtype='$qual_type' prefix='$prefix'<BR>";
  # invoke inherited construction
  my $self=bless $class->SUPER::new(@_),$class;
  # initialize object
  my $line=${$self->{LINE_REF}};
  #print "line='$line'<BR>";
  $line=~s/^\s*(.*?)\s*$/$1/; # trim whitespace from line
  if (!($line =~ /^.*!.*/)) {
    # not a record if no field separator found
    return undef;
  }
  my @fields=split('!',$line);
  if ( (@{$self->{FIELDS}}=@fields)) {
    $self->{IS_RECORD}=1;
    for (my $index=0; $index < @fields; $index++) {
      $fields[$index]=~s/\s*(\S*.*\S+)\s*/$1/; # trim whitespace from field
    }
    $fields[0] =~ tr/a-z/A-Z/ if @fields; # upper-case the kind of change
    $self->{FIELDS}=\@fields;
    #print "Here!!!! fields[0] = $fields[0] [1] = $fields[1]"
    #     . "[2] = $fields[2] [3] = $fields[3]<BR>";
    # now, analyze the fields to see if this is a valid qualifier change;
    # if so, hold the string name of a routine we can later use to
    # implement the change by passing the fields to it, otherwise the record
    # will be placed in the error state and the actor will be undefined
    if ($self->{ACTOR}=RolesDB->determine_change($self,$qual_type,$prefix)) {
      $$ok=1 unless $$ok==0;
    } else {
      $$ok=0;
    }
  } else {
    return undef;
  }
  # done
  return $self;
}

# -- object methods --

sub fields {
  my $self=shift;
  return $self->{FIELDS};
}

sub transact {
  my $self=shift;
  my $database=shift;
  my $qual_type=shift;
  my $changer=$self->{ACTOR};
  return $changer->apply(
    $database,$qual_type,@{$self->{FIELDS}}[1..$#{$self->{FIELDS}}]
  );
}

sub error {
  my $self=shift;
  my $class=ref $self;
  $self->{ERR}=shift;       # records have error number info to record
  $self->SUPER::error(@_),$class;
}

sub render {
  my $self=shift;
  my $msg="";
  if ($self->{IS_ERROR}) {
    ### The following line was changed 8/8/2000 by J. Repa
    $msg="* error ($self->{ERR}) on next line: $self->{MSG}\n";
  }
  my @fields=@{$self->{FIELDS}};
  if (@fields >= 1) {
    $msg=$msg.$fields[0];
    for (my $index=1; $index < @fields; $index++) {
      $msg=$msg."!$fields[$index]";
    }
  }
  return "$msg\n";
#  return $msg."${$self->{LINE_REF}}\n"; # display original input line
}

# ------------------------------------------------------

1;

