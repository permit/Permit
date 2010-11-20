=head1 NAME

RolesDB - Roles database connectivity, qualifier maintenance services

=head1 SYNOPSIS
#
#  Copyright (C) 1998-2010 Massachusetts Institute of Technology
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
# Modified by J. Repa 12/9/1998
# Modified by J. Repa 1/6/1999 (change ' to '' in qualifier name)
# Modified by J. Repa 4/9/1999 - found that get_database_info does not
#                     work right, routine was just picking up last line
#                     of file.  Fixed it, but found another problem with
#                     variable $_DatabaseName (not available where you
#                     need it).  Just hardcoded 'rolesw' instead of 
#                     sorting out the layers of OO stuff.
# Modifyed by J. Repa 8/8/2000 - do not take default (AutoCommit=1) when
#                     connecting.

use RolesDB;

###########
# methods #
###########

RolesDB->handle();                 # return DBI handle
RolesDB->get_allowed_qualifiers(); # return (qual,description)

###############
# subroutines #
###############

# for the following, replace '*' with {add, delete, ...}
RolesDB::check_*_fields($rec,$pattern,...);
RolesDB::qualifier_*($dbh,$qual_type,...);

=head1 DESCRIPTION

The RolesDB class provides basic database connection management
via class initialization and finalization, and additional
methods for analyzing, retrieving, and modifying qualifier data.

The processing of commands like "ADD", etc., is controlled
via the %_QualifierChangeInfo hash table.  You can specify
the minimum number of parameters, the maximum number of
parameters, the name of the routine that will check the
parameters, and the name of the routine that will actually
try to apply the requested changes against the database.
Note that the names of these routines cannot be described
by class reference; Perl doesn't seem to know how to do that
with strings.  This is why the check_*_fields and qualifier_*
routines don't check for class arguments, and why the names
are specified as "PackageName::routineName" instead of
"PackageName->routineName".

The process of how input is parsed and turned into transaction
activites is managed in the RolesUpdater package.  That package
creates objects from the RolesItem hierarchy (RolesComment,
RolesUnparsable, and most importantly RolesRecord) to represent
each line of input.  These objects know how to render themselves
as output, how to store error information, and how to apply
themselves as database transactions.

Individual objects from RolesRecord will cache the names of the
routines they must invoke to check their parameters and apply
themselves against the database.  This allows each object to have
slightly different behaviour depending on whether it is an
ADD, DELETE, etc.

=cut

# ------------------------------------------------------

package RolesDB;

use DBI;
use RolesActor;
use RolesError;
use RolesSSL;
use strict;

# -- class attributes --

my $_Handle=undef;
my %_ConnectInfo=undef;
my $_DatabaseName='roles';  # This variable doesn't do anything. JR 4/9/1999
my %_QualifierChangeInfo=(
  ADD => {
    MIN_ARGS => 3,
    MAX_ARGS => 4, # actually 3, added 1 for comments
    FIELD_CHECKER => 'RolesDB::check_add_fields',
    DATABASE_CHANGER => 'RolesDB::qualifier_add',
  },
  DELETE => {
    MIN_ARGS => 1,
    MAX_ARGS => 4, # actually 1, added 3 for comments
    FIELD_CHECKER => 'RolesDB::check_delete_fields',
    DATABASE_CHANGER => 'RolesDB::qualifier_delete',
  },
  ADDCHILD => {
    MIN_ARGS => 2,
    MAX_ARGS => 3, # actually 2, added 1 for comments
    FIELD_CHECKER => 'RolesDB::check_addchild_fields',
    DATABASE_CHANGER => 'RolesDB::qualifier_addchild',
  },
  DELCHILD => {
    MIN_ARGS => 2,
    MAX_ARGS => 3, # actually 2, added 1 for comments
    FIELD_CHECKER => 'RolesDB::check_delchild_fields',
    DATABASE_CHANGER => 'RolesDB::qualifier_delchild',
  },
  UPDATE => {
    MIN_ARGS => 4,
    MAX_ARGS => 5, # actually 4, added 1 for comments
    FIELD_CHECKER => 'RolesDB::check_update_fields',
    DATABASE_CHANGER => 'RolesDB::qualifier_update',
  },
);

# -- class attribute methods --

sub handle { return $RolesDB::_Handle; }

# -- class methods --

sub server {
  my %connect=RolesDB->connect_info;
  return $connect{server};
}

sub db_user {
  my %connect=RolesDB->connect_info;
  return $connect{db_user};
}

sub password {
  my %connect=RolesDB->connect_info;
  return $connect{password};
}

sub connect_info {
  if (!%RolesDB::_ConnectInfo) {
    ($RolesDB::_ConnectInfo{server},
     $RolesDB::_ConnectInfo{db_user},
     ### Variable $_DatabaseName is not available here.  I don't have time
     ### to debug original code, so I hard-coded 'rolesw'. Jim Repa, 4/9/1999
     #$RolesDB::_ConnectInfo{password})=get_database_info($_DatabaseName);
     $RolesDB::_ConnectInfo{password})=get_database_info('rolesw');
     $RolesDB::_ConnectInfo{db_user}=~tr/a-z/A-Z/;
  }

  return %RolesDB::_ConnectInfo;
}

sub qualifier_change_info {
  my $class=shift;
  my $type=shift;
  if (!$_QualifierChangeInfo{$type}) {
    return undef;
  } else {
    return \$_QualifierChangeInfo{$type};
  }
}

sub get_database_info {
  #my $class=shift;  # Mistake fixed by Jim Repa, 4/9/1999
  my $db_symbol=shift; # Get symbolic database name
  my $filename="dbweb.config";
  my $fullpath=$filename;
  my ($sym_db,$db,$db_user,$pw);
  unless (open(CONF,$fullpath)) {  # Open the config file
    RolesError::death("Cannot open the configuration file.<br>\n"
                      . " The configuration file should be $fullpath");
  }
  my $line;
  while (chop($line = <CONF>)) {
    if ($line =~ /^$db_symbol\:/) {  # Look for the right line
      ($sym_db, $db, $db_user, $pw) = split(':',$line); # Parse db, db_user, pw
    }
  }
  close(CONF);  # Close the config file
  return ($db, $db_user, $pw);  # Return triplet of db, db_user, pw
}

# take a record item
# invoke error on it if the fields don't check out ok and return undef
# else return an actor object that would implement the change
sub determine_change {
  my $class=shift;
  my $record=shift;
  my $qual_type=shift;
  my $prefix=shift; # regex for valid qualifiers
  my ($type,@args)=@{$record->fields()};
  my $nargs=@args;
  my $ref=RolesDB->qualifier_change_info($type);
  if (!$ref) {
    $record->error("$type is not a recognized qualifier change");
  } else {
    my $min_args=${$$ref}{MIN_ARGS};
    my $max_args=${$$ref}{MAX_ARGS};
    my $checker=${$$ref}{FIELD_CHECKER};
    my $changer=${$$ref}{DATABASE_CHANGER};
    if ($nargs < $min_args || $nargs > $max_args) {
      $record->error("incorrect number of parameters for $type");
    } elsif (eval "$checker(\$record,\$prefix,\@args)") {
      # the checker will report errors on its own
      return RolesActor->new($changer);
    }
  }
  return undef;
}

sub get_allowed_qualifiers {
  my $class=shift;
  my $k_user=RolesSSL->kerberos_id;
  my $db=RolesDB->handle;
  my @stmt=qq{
    select qualifier_type, qualifier_type_desc
      from qualifier_type
      where qualifier_type in
        (select substr(a.qualifier_code, 6)
           from authorization a
           where a.function_name = 'MAINTAIN QUALIFIERS'
             and a.qualifier_code != 'QUAL_ALL'
             and a.kerberos_name = '$k_user'
             and a.do_function = 'Y'
             and NOW() between 
                 a.effective_date and IFNULL(a.expiration_date, NOW())
         union select substr(q.qualifier_code, 6)
           from authorization a, qualifier_descendent qd, qualifier q
           where a.function_name = 'MAINTAIN QUALIFIERS'
             and a.kerberos_name = '$k_user'
             and a.do_function = 'Y'
             and NOW() between 
                 a.effective_date and IFNULL(a.expiration_date, NOW())
             and a.qualifier_id = qd.parent_id
             and qd.child_id = q.qualifier_id)
  };
  my $cursor=$db->prepare(@stmt)
    or RolesError::death("Can't prepare database statement ($DBI::errstr)");
    # a failure to prepare the statement is probably an internal error,
    # hence handling by death
  $cursor->execute
    or RolesError::death("Can't execute statement ($DBI::errstr)");
    # since this particular query doesn't depend on user input (just
    # certificate parsing) a failure to execute the statement is also
    # probably an internal error, hence handling by death
  # Fetch the rows back from the SELECT statement
  my $index=0;
  my @row;
  my @result;
  for ($index=0; @row=$cursor->fetchrow(); $index++) {
    $result[$index]=[ @row ];
  }
  $cursor->finish;
  return @result;
}

# -- package (ie: not class referenced) routines --

sub check_add_fields {
  my ($record,$prefix,$arg1,$arg2)=@_;
  if (!eval("'$arg1'=~$prefix")) {
    $record->error("incorrect parameter 1 value for an ADD");
    return 0;
  }
  if (!eval("'$arg2'=~$prefix")) {
    $record->error("incorrect parameter 2 value for an ADD");
    return 0;
  }
  return 1;
}

sub check_delete_fields {
  my ($record,$prefix,$arg1)=@_;
  if (!eval("'$arg1'=~$prefix")) {
    $record->error("incorrect parameter value for a DELETE");
    return 0;
  }
  return 1;
}

sub check_addchild_fields {
  my ($record,$prefix,$arg1,$arg2)=@_;
  if (!eval("'$arg1'=~$prefix")) {
    $record->error("incorrect parameter 1 value for an ADDCHILD");
    return 0;
  }
  if (!eval("'$arg2'=~$prefix")) {
    $record->error("incorrect parameter 2 value for an ADDCHILD");
    return 0;
  }
  return 1;
}

sub check_delchild_fields {
  my ($record,$prefix,$arg1,$arg2)=@_;
  if (!eval("'$arg1'=~$prefix")) {
    $record->error("incorrect parameter 1 value for a DELCHILD");
    return 0;
  }
  if (!eval("'$arg2'=~$prefix")) {
    $record->error("incorrect parameter 2 value for a DELCHILD");
    return 0;
  }
  return 1;
}

sub check_update_fields {
  my ($record,$prefix,$arg1,$arg2,$arg3,$arg4)=@_;
  $arg2=~tr/a-z/A-Z/;
  if ($arg2 eq 'PARENT') {
    if (!eval("'$arg1'=~$prefix")) {
      $record->error("incorrect parameter 1 value for an UPDATE $arg2");
      return 0;
    }
    if (!eval("'$arg3'=~$prefix")) {
      $record->error("incorrect parameter 3 value for an UPDATE $arg2");
      return 0;
    }
    if (!eval("'$arg4'=~$prefix")) {
      $record->error("incorrect parameter 4 value for an UPDATE $arg2");
      return 0;
    }
    return 1;
  } elsif ($arg2 eq 'NAME') {
    if (!eval("'$arg1'=~$prefix")) {
      $record->error("incorrect parameter 1 value for an UPDATE $arg2");
      return 0;
    }
    return 1;
  } else {
    $record->error("incorrect parameter 2 value for an UPDATE");
    return 0; # failed check
  }
}

sub qualifier_add1 {
  my ($dbh,$qual_type,$qual_code,$parent_code,$qual_name)=@_;
  $qual_name =~ s/'/''/g;
  my $user_id=RolesSSL->kerberos_id;
  my $out_message='blank';
  my @stmt=qq{
    BEGIN
      auth_sp_insert_qual('$qual_type','$qual_code','$parent_code',
                          '$qual_name','$user_id',:out_message);
    END;
  };
  my $cursor = $dbh->prepare(@stmt)
    or RolesError::death("Can't prepare database statement ($DBI::errstr)");
    # a failure to prepare the statement is probably an internal error,
    # hence handling by death
  $cursor->bind_param_inout(":out_message", \$out_message, 255);
  $cursor->execute
    or return 0; # failed change
    # a failure to execute the statement is probably due to input data errors
    # hence handling by returning 0 (so the updater will report the problem)
  $cursor->finish;
  return 1; # change succeeded
}


sub qualifier_add {
  my ($dbh,$qual_type,$qual_code,$parent_code,$qual_name)=@_;
  $qual_name =~ s/'/''/g;
  my $user_id=RolesSSL->kerberos_id;
  my $out_message='blank';
  my $cursor = $dbh->prepare('CALL auth_sp_insert_qual(?,?,?,?,?,@ao_message)')
    || RolesError::death("Can't prepare database statement ($DBI::errstr)");
    # a failure to prepare the statement is probably an internal error,
    # hence handling by death
  $cursor->bind_param(1, $qual_type);
  $cursor->bind_param(2, $qual_code);
  $cursor->bind_param(3, $parent_code);
  $cursor->bind_param(4, $qual_name);
  $cursor->bind_param(5, $user_id);
  #$cursor->bind_param_inout(6, \$out_message,255);
  $cursor->execute
    or return 0; # failed change
    # a failure to execute the statement is probably due to input data errors
    # hence handling by returning 0 (so the updater will report the problem)
  $cursor->finish;
  return 1; # change succeeded
}

sub qualifier_delete {
  my ($dbh,$qual_type,$qual_code)=@_;
  my $user_id=RolesSSL->kerberos_id;
  my $out_message='blank';
  my @stmt=qq{
    BEGIN
      auth_sp_delete_qual('$qual_type','$qual_code','$user_id',:out_message);
    END;
  };
  my $cursor = $dbh->prepare('CALL auth_sp_delete_qual(?,?,?,@ao_message)')
    or RolesError::death("Can't prepare database statement ($DBI::errstr)");
    # a failure to prepare the statement is probably an internal error,
    # hence handling by death
  #$cursor->bind_param_inout(":out_message", \$out_message, 255);
  $cursor->bind_param(1, $qual_type);
  $cursor->bind_param(2, $qual_code);
  $cursor->bind_param(3, $user_id);
  $cursor->execute
    or return 0; # failed change
    # a failure to execute the statement is probably due to input data errors
    # hence handling by returning 0 (so the updater will report the problem)
  $cursor->finish;
  return 1; # change succeeded
}

sub qualifier_addchild {
  my ($dbh,$qual_type,$qual_code,$parent_code)=@_;
  my $user_id=RolesSSL->kerberos_id;
  my $out_message='blank';
  my @stmt=qq{
    BEGIN
      auth_sp_update_qualpar('$qual_type','$qual_code','','$parent_code',
                             '$user_id',:out_message);
    END;
  };
  my $cursor = $dbh->prepare(' CALL auth_sp_update_qualpar(?,?,?,?,?,@ao_msg)')
    or RolesError::death("Can't prepare database statement ($DBI::errstr)");
    # a failure to prepare the statement is probably an internal error,
    # hence handling by death
  #$cursor->bind_param_inout(":out_message", \$out_message, 255);
  $cursor->bind_param(1, $qual_type);
  $cursor->bind_param(2, $qual_code);
  $cursor->bind_param(3, '');
  $cursor->bind_param(4, $parent_code);
  $cursor->bind_param(5, $user_id);
  $cursor->execute
    or return 0; # failed change
    # a failure to execute the statement is probably due to input data errors
    # hence handling by returning 0 (so the updater will report the problem)
  $cursor->finish;
  return 1; # change succeeded
}

sub qualifier_delchild {
  my ($dbh,$qual_type,$qual_code,$parent_code)=@_;
  my $user_id=RolesSSL->kerberos_id;
  my $out_message='blank';
  my @stmt=qq{
    BEGIN
      auth_sp_update_qualpar('$qual_type','$qual_code','$parent_code','',
                             '$user_id',:out_message);
    END;
  };
  my $cursor = $dbh->prepare(' CALL auth_sp_update_qualpar(?,?,?,?,?,@ao_msg)')
    or RolesError::death("Can't prepare database statement ($DBI::errstr)");
    # a failure to prepare the statement is probably an internal error,
    # hence handling by death
  $cursor->bind_param(1, $qual_type);
  $cursor->bind_param(2, $qual_code);
  $cursor->bind_param(3, $parent_code);
  $cursor->bind_param(4, '');
  $cursor->bind_param(5, $user_id);
  #$cursor->bind_param_inout(":out_message", \$out_message, 255);
  $cursor->execute
    or return 0; # failed change
    # a failure to execute the statement is probably due to input data errors
    # hence handling by returning 0 (so the updater will report the problem)
  $cursor->finish;
  return 1; # change succeeded
}

sub qualifier_update {
  # two cases to deal with in this routine, updating parents and updating names
  my ($dbh,$qual_type,$qual_code,$command,$arg1,$arg2)=@_;
  $command=~tr/a-z/A-Z/;
  my $user_id=RolesSSL->kerberos_id;
  my $out_message='blank';
  my @stmt;
  my $cursor1;
  my $stmt1 = '';


    my ($old_parent,$new_parent)=($arg1,$arg2);
    my $new_name=$arg2; # arg1 is the old name, and can be ignored
    $new_name =~ s/'/''/g;

  if ($command eq 'PARENT') {
    #my ($old_parent,$new_parent)=($arg1,$arg2);
    @stmt=qq{
      BEGIN
        auth_sp_update_qualpar('$qual_type','$qual_code','$old_parent',
                               '$new_parent','$user_id',:out_message);
      END;
    };
  } elsif ($command eq 'NAME') {
    #my $new_name=$arg2; # arg1 is the old name, and can be ignored
    #$new_name =~ s/'/''/g;
    @stmt=qq{
      BEGIN
        auth_sp_update_qualname('$qual_type','$qual_code','$new_name',
                                '$user_id',:out_message);
      END;
    };
  } else {
    RolesError::death("Can't process update due to internal error");
    # if we don't know what kind of update command this is, it is an
    # internal error because the record parsing should have caught
    # the problem before now, hence handling by death
  }
  #my $cursor = $dbh->prepare(@stmt)
  my $cursor ;
  if ($command eq 'PARENT') {
	$cursor = $dbh->prepare('CALL auth_sp_update_qualpar(?,?,?,?,?,@ao_message)')
    or RolesError::death("Can't prepare database statement ($DBI::errstr)");
  $cursor->bind_param(1, $qual_type);
  $cursor->bind_param(2, $qual_code);
  $cursor->bind_param(3, $old_parent);
  $cursor->bind_param(4, $new_parent);
  $cursor->bind_param(5, $user_id);
  } elsif ($command eq 'NAME') {
	$cursor = $dbh->prepare('CALL auth_sp_update_qualname(?,?,?,?,@ao_message)')
    or RolesError::death("Can't prepare database statement ($DBI::errstr)");
print 'binding ...';
  $cursor->bind_param(1, $qual_type);
  $cursor->bind_param(2, $qual_code);
  $cursor->bind_param(3, $new_name);
  $cursor->bind_param(4, $user_id);
}
    # a failure to prepare the statement is probably an internal error,
    # hence handling by death
 # $cursor->bind_param(":out_message", \$out_message, 255);
  $cursor->execute
    or return 0; # failed change
    # a failure to execute the statement is probably due to input data errors
    # hence handling by returning 0 (so the updater will report the problem)
  $cursor->finish;
  return 1; # change succeeded
}

# -- class construction/destruction protocol --

##############################################################################
#
# Subroutine get_database_info($symbolic_db_name)
#
# Look up the symbolic database name in dbweb.config and
# return (db, username, pw).
#
##############################################################################
sub get_database_info {
    my($db_symbol) = $_[0];  # Get first argument (symbolic_database_name)
    my $filename = "dbweb.config";
    $ENV{'PERMIT_CONFIG_HOME'} = '/var/www/permit';
    my $fullpath = $ENV{'PERMIT_CONFIG_HOME'} . "/" . $filename;
        print "config file: '$fullpath'";
    my ($sym_db, $db, $user, $pw,$host);

    unless (open(CONF,$fullpath)) {  # Open the config file
       print "<br><b>Cannot open the configuration file. <br>"
         . " The configuration file should be $fullpath<b>";
       exit();
    }
    my $line;

    while (chop($line = <CONF>)) {
      if ($line =~ /^$db_symbol\:/) {  # Look for the right line
        ($sym_db, $db, $user, $pw,$host) = split(':',$line); # Parse db, user, pw
      }
    }
    close(CONF);  # Close the config file
    return ($db, $user, $pw,$host);  # Return quartet of db, user, pw, host
}


sub BEGIN {
  my ($db_symbol) = 'roles';
  my ($db, $user, $pw,$host) = &get_database_info($db_symbol); #Read conf. file
  my $dsn = "dbi:mysql:" . $db . ":" . $host;
  my $i;
  my %attr; # Change made by J. Repa, 8/8/2000
  $attr{'AutoCommit'} = 0;  # Do not use default. Do not AutoCommit.
  for ($i=0; $i<3; $i++) {
    if ($RolesDB::_Handle=DBI->connect($dsn,$user,$pw)) { 
            $RolesDB::_Handle->{AutoCommit}    = 0;
            $RolesDB::_Handle->{RaiseError}    = 1;
      	    return; 
    }
  }
  RolesError::death("Unable to connect to $db: $DBI::errstr <BR>");
}

sub END { $RolesDB::_Handle->disconnect; }

# ------------------------------------------------------

1;


