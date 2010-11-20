
=head1 NAME

RolesUpdater - take lines of text and try to derive database changes from them

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

use RolesUpdater;

###########
# methods #
###########

$obj=RolesUpdater->new($db_handle,$qual_type,\$text_lines);

$obj->parse();    # turn lines into RolesItem objects
$obj->transact(); # apply the RolesItems to the database
$obj->render();   # convert the RolesItems into a string

=head1 DESCRIPTION

The RolesUpdater class creates an object that manages the stages
of taking text and splitting it into multiple lines (which happens
when the updater is created), parsing the lines, and applying
appropriate changes to the database.

Information on how qualifier fields will be pattern-matched is
stored in the %_KnownQualifierTypes hash; the keys for this
hash are the only qualifier types the package knows how to
recognize.  To add support for a new qualifier type, just
add another entry to %_KnownQualifierTypes.

For parsing, an updater object takes each line of input and tries
to create an appropriate RolesItem object from it.  It does this
by seeing if the input line can be parsed as a comment by trying
to create a new RolesComment object.  If that doesn't work the
process is repeated by attempting to create a new RolesRecord (which
uses the appropriate qualifier pattern from %_KnownQualifierTypes
to test the fields).  A record will be successfully created as long
as the line contains the specified input field specifies ('!'); any
field match errors will be cached in the record.  Finally, if a
record can't be created, a RolesUnparsable object is created to
indicate that we don't know what the input line contains.

For transacting, the updater object will tell each of the RolesItem
objects to transact themselves.  For a comment this is a do-nothing
method.  For records it invokes the appropriate routines in the
RolesDB package in an attempt to make the requested change.  For
unparsable objects an error will result.  Any errors that obviously
are a result of user input mistakes will be reported back to the
user so that the input can be re-edited; internal errors will cause
an error message and terminate the execution of the script.
If no errors are detected, the changes are committed to the database.

For rendering, the updater object asks each object to render itself
(ie: to output a string to display whatever it is the object thinks
should be displayed); the results are concatenated together and
returned to the caller.  Comments will display themselves as the
unmodified input line, as will records that don't have parsing or
execution errors.  Records with errors and unparsable input lines
will display a "# error ..." comment line followed by the
original line of input.

=cut

# ------------------------------------------------------

package RolesUpdater;

use RolesComment;
use RolesError;
use RolesRecord;
use RolesUnparsable;
use strict;

# -- class attributes --

my %_KnownQualifierTypes=(
  AORG => '/^.{1,15}?$/',
  BUDG => '/^.{1,15}?$/',
  CATE => '/^CAT.*$/',
  COST => '/^(C|I|P|PC|0HPC).*$/',
  FUND => '/^(F|FC|FC_)[0-9]*.*$/',
  IAPS => '/^.{1,15}?$/',
  NULL => '/^.{1,15}?$/',
  OMEP => '/^OME_.*$/',
  ORGU => '/^[0-9]*$/',
  ORG2 => '/^[0-9]*$/',
  PRIN => '/^.{1,15}?$/',
  PROF => '/^.{1,15}?$/',
  QTYP => '/^QUAL_.*$/',
  SPGP => '/^SG_[0-9]*$/',
  BAGS => '/^.{1,15}?$/',
  DEPT => '/^.{1,15}?$/',
  SISO => '/^.{1,15}?$/',
  EHSG => '/^EHSG_.{1,10}?$/',
  PDED => '/^.{1,15}?$/',
  PRTA => '/^.{1,15}?$/',
  PHON => '/^.{1,15}?$/',
  TSLV => '/^.{1,15}?$/',
  NETI => '/^.{1,15}$/',
  LIBM => '/^.{1,15}$/',
);

# -- object construction/destruction protocol --

sub new {
  my $class=shift;
  my $self=bless {},$class;
  # keep track of database handle for later processing
  $self->{DATABASE}=shift;
  # figure out what kind of qualifier these database changes are for
  $self->{QUALIFIER_TYPE}=shift;
  $self->{QUALIFIER_TYPE}=~tr/a-z/A-Z/;
  if (!$_KnownQualifierTypes{$self->{QUALIFIER_TYPE}}) {
    RolesError::death("Unrecognized qualifier type detected");
  }
  $self->{QUALIFIER_PREFIX}=$_KnownQualifierTypes{$self->{QUALIFIER_TYPE}};
  # carve up input into separate lines
  $self->{INPUT}=shift;
  $self->{INPUT}=~s/^(\s*\S.*\S)?\s*$/$1/s; # trim end-of-file whitespace
  $self->{INPUT}=~s/\r\n/\n/g; # Convert PC-style end-of-line to Unix-style
  $self->{INPUT}=~s/\r/\n/g;   # Convert Mac-style end-of-line to Unix-style
  $self->{INPUT}=~s/\t/ /g;    # Convert all tabs to single spaces
  @{$self->{LINES}}=split('\n',$self->{INPUT});
  # done
  return $self;
}

# -- object methods --

sub parse {
  my $self=shift;
  my $ok=1;
  my $qual_type=$self->{QUALIFIER_TYPE};
  my $prefix=$self->{QUALIFIER_PREFIX}; # regex for valid qualifiers
  my $item;
  my $line;
  my $index;
  for ($index=0; $index < @{$self->{LINES}}; $index++) {
    $item=\${$self->{ITEMS}}[$index];
    $line=\${$self->{LINES}}[$index];
    if ($$item=RolesComment->new($line)) { next; }
    if ($$item=RolesRecord->new(\$ok,$qual_type,$prefix,$line)) { next; }
    $$item=RolesUnparsable->new($line);
    $ok=0; # keep going to find all parse problems, but result is bad
  }
  return $ok;
}

sub transact {
  my $self=shift;
  my $item;
  my $index;
  for ($index=0; $index < @{$self->{ITEMS}}; $index++) {
    $item=${$self->{ITEMS}}[$index];
    if (!$item->transact($self->{DATABASE},$self->{QUALIFIER_TYPE})) {
      if ($item->{IS_RECORD}) {
        # modify item to contain error information
        my $err=$self->{DATABASE}->err;
        my $errstr=$self->{DATABASE}->errstr;
        my @errmsgs=split('\n',$errstr);
        $errmsgs[0] =~ s/\s*\S*\: (Error\: )?(.*)$/$2/; # 1st line of message
        $item->error($err,$errmsgs[0]);
        # now stop processing because of the database error encountered
      } else {
        # we attempted to process something we shouldn't have
        $item->error("can't apply this to the database [internal error?]");
      }
      # now clean up the database (can't do this until now or the
      # Oracle error messages are lost
      $self->{DATABASE}->rollback;
      return 0;
    }
  }
  $self->{DATABASE}->commit;
  return 1;
}

sub render {
  my $self=shift;
  my $index;
  my $result="";
  for ($index=0; $index < @{$self->{LINES}}; $index++) {
    $result=$result.${$self->{ITEMS}}[$index]->render;
  }
  return $result;
}

# ------------------------------------------------------

1;

