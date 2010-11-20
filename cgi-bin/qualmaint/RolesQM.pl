#!/usr/bin/perl

## RolesQM.pl
##
## CGI script for allowing web updates to Roles Qualifiers
##
## The detailed mechanics are described as POD documentation in
## the various packages used by this script; the RolesDB package
## is the best place to start looking for information.
##
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
## reidmp 98/12/02;  modified repa 98/12/09; modified reidmp 98/12/22

require "cgi-lib.pl";
use RolesDB;
use RolesError;
use RolesUpdater;

MAIN: {
  $title="Roles Qualifier Maintenance";
  print "Content-type: text/html\n";

  print PrintHeader();
  GeneratePageTop($title);
  RolesError::page_started();
  # if the query string is defined, then something "?uploaded" was appended
  #   and this isn't the first pass through the script
  if ($ENV{'QUERY_STRING'}) {
    $upload_type=$ENV{'QUERY_STRING'};
    $upload_type=~s/^\s*uploaded\s*=\s*(\S+)\s*$/$1/;
    # Limit upload size to avoid using too much memory
    $cgi_lib'maxdata = 50000;
    # Read in all the variables set by the form, including uploaded data
    $ret=ReadParse();
    RolesError::death("Unknown error in reading CGI input") if !defined $ret;
    # For $in{qualtype}, throw away everything but the first token
    my @tokens = split(' ', $in{qualtype});
    $in{qualtype} = $tokens[0];
    #
    if ($ret && $in{do_manual}) {
      ManualDataEntry($in{qualtype});
    } elsif (!$ret || !$in{qualtype} || !$in{upfile}) {
      print "<h2>Error</h2>\n";
      print "<p>Data not submitted or incomplete, please try again.\n";
      if (!$in{qualtype} || !$in{upfile}) {
        print "<span style='color:red'>You need to specify";
        if (!$in{qualtype}) { print " the qualifier type and"; }
        print " the file to upload.";
        print "</span></p>\n";
      }
      PrintFormBody($in{qualtype});
    } else {
      my $updater=RolesUpdater->new(
        RolesDB->handle(),$in{qualtype},$in{upfile}
      );
      if (!$updater->parse()) {
        # can't parse input, get user to fix
        RedisplayData(
          $updater,
          $in{qualtype},
          'Parsing Errors Detected in Input',
          'fixing_parse_error',
          'Please edit the form to fix the errors'
            . ' and re-submit the changes when you are done.'
        );
      } elsif ($upload_type ne 'clean_parse') {
        # parsed input, let user confirm going ahead
        RedisplayData(
          $updater,
          $in{qualtype},
          'No Parsing Errors Detected',
          'clean_parse',
          'Re-submit the data to confirm that it should be applied to'
            .' the database (you can make changes first if you wish).'
        );
      } elsif (!$updater->transact()) {
        # can't apply records to database, get user to fix
        RedisplayData(
          $updater,
          $in{qualtype},
          'Data Errors Detected in Input',
          'fixing_transact_error',
          'Please edit the form to fix the errors'
            . ' and re-submit the changes when you are done.'
        );
      } else {
        # everything seems fine, let the user know the good news
        print "<h2>DONE!</h2>\n";
        print "<p>Your data has been committed to the Roles database</p>\n";
      }
    }
  } else { # this is the first pass through the script
    PrintFormBody();
  }
  print "<hr><div align=center>";
  PrintChangeDocumentation();
  print "</div><hr>";
  print HtmlBot();
}

sub GeneratePageTop() {
  my $title=shift;
  print << 'ENDOFTEXT';
<html>
  <head>
ENDOFTEXT
  print "    <title>$title</title>\n";
  print << 'ENDOFTEXT';
    <!-- start cascading style sheet -->
    <style>
    <!--
      body {
        background:silver;
        font-family:monospace;
        font-size:10pt;
      }
      h1 {
        color:darkred;
        font-family:Helvetica,sans-serif;
        font-size:18pt;
        margin-top:0.4em;
        margin-bottom:0.1em;
        align:center;
      }
      h2 {
        color:darkred;
        font-family:Times,serif;
        font-size:14pt;
        margin-top:0.4em;
        margin-bottom:0.1em;
      }
      h3 {
        color:darkred;
        font-family:Times,serif;
        font-size:12pt;
        margin-top:0.4em;
        margin-bottom:0.1em;
      }
      p {
        margin-top:0em;
        margin-bottom:0.3em;
      }
      table {
        border-width:1;
        padding:3;
        font-family:Times,serif;
        font-size:10pt;
      }
      table.wrapper {
        border-width:1;
        padding:0;
        font-family:Times,serif;
        font-size:10pt
      }
      th {
        color:darkred;
        font-family:Times,serif;
        font-size:12pt;
      }
      td {
        font-family:Times,serif;
        font-size:10pt;
      }
      textarea {
        font-family:monospace;
        font-size:10pt;
      }
      input {
        font-family:Times,serif;
        font-size:10pt;
      }
    -->
    </style>
    <!-- end cascading style sheet -->
  </head>
<body>
ENDOFTEXT
  print "  <h1>$title</h1>\n";
  print "  <hr>\n";
}

sub PrintFormBody {
  my $default_qt=shift; # Set if a qualifier type was already selected
                        # Notice that we don't pass a default upload filename:
                        # HTML security won't let us set a default value
  # Note that if ENDOFTEXT weren't surrounded by single quotes,
  # it would be necessary to be more careful with the other text
  # For example, the @ sign (in the address) would need to be escaped as \@
  print <<'ENDOFTEXT';
<form method='POST' enctype='multipart/form-data'
      action='RolesQM.pl?uploaded=file_transfer'>
  <table>
    <tr>
      <td>
ENDOFTEXT
        if (PrintQualifierTypes($default_qt)) {
          print <<'ENDOFTEXT';
        </td>
        <td>
ENDOFTEXT
          PrintInstructions();
        }
        print <<'ENDOFTEXT';
      </td>
    </tr>
  </table>
</form>
ENDOFTEXT
}

# display instructions and file upload widget
sub PrintInstructions {
  print <<'ENDOFTEXT';
  <table>
    <tr><th>Instructions</th></tr>
    <tr><td>
      Please fill in the file-upload form below by
      selecting a qualifier type and by specifying
      the file of transaction data to be uploaded.
    </td></tr>
    <tr><th>File to Upload</th></tr>
    <tr><td>
      <input type=file name=upfile size=30><br>
      <input type=submit name=do_file value='Upload the file'>
      <input type=submit name=do_manual value='Manually create the data'>
    </td></tr>
  </table>
ENDOFTEXT
}


# display list of qualifier types that this user is allowed to maintain
sub PrintQualifierTypesOld {
  my $default_qt=shift;
  my @qualinfo=RolesDB->get_allowed_qualifiers;
  print <<'ENDOFTEXT';
<table class=wrapper border>
  <tr><th>Qualifier Types You Can Maintain</th></tr>
  <tr><td>
    <table border>
      <tr>
        <th>Qualifier Type</th><th>Description</th>
      </tr>
ENDOFTEXT
  my $index, $qual, $description;
  for ($index=0; $index < @qualinfo; $index++) {
    ($qual,$description)=@{@qualinfo[$index]}[0,1];
    print "<tr><td><input type=\"radio\" name=\"qualtype\" value=\"$qual\"";
    if ($default_qt && $default_qt eq $qual) {
      print " checked";
    }
    print "><b>$qual</b></td><td>$description</td></tr>";
    print "</tr>\n";
  }
  print <<'ENDOFTEXT';
    </table>
  </td></tr>
</table>
ENDOFTEXT
}

# display list of qualifier types that this user is allowed to maintain
sub PrintQualifierTypes {
  my $default_qt=shift;
  my @qualinfo=RolesDB->get_allowed_qualifiers;
  my $count_qt = @qualinfo;  # No. of qual types you are allowed to maintain
  if ($count_qt) {
    print "Pick a qualifier type from the list of Qualifier Types you can"
      . " maintain:<br>\n";
    print '<select name="qualtype">';
    my $index, $qual, $description, $selected;
    for ($index=0; $index < @qualinfo; $index++) {
      ($qual,$description)=@{@qualinfo[$index]}[0,1];
      if ($default_qt && $default_qt eq $qual) {
        $selected = "selected";
      } else {
        $selected = "";
      }
      print "<option $selected>$qual ($description)\n";
    }
    print "</select>\n";
    return 1; # user can maintain something
  } else {
    print "You are not authorized to maintain qualifiers of any type.<BR>";
    return 0; # user can't maintain anything
  }
}

sub RedisplayData {
  my $updater=shift;
  my $default_qt=shift; # set if a qualifier type was already selected
  my $msg=shift; # tell user what kind of problem needs fixing
  my $state=shift; # code to use on action to transition CGI state
  my $instructions=shift; # tell user how to proceed
  print "<form method='POST' enctype='multipart/form-data'\n";
  print "      action='RolesQM.pl?uploaded=$state'>\n";
  PrintInputData($updater);
  print << 'ENDOFTEXT';
  <table>
    <tr>
      <td>
ENDOFTEXT
        PrintRedisplayInstructions($msg,$instructions);
        print <<'ENDOFTEXT';
      </td>
      <td>
ENDOFTEXT
        PrintQualifierTypes($default_qt);
        print <<'ENDOFTEXT';
      </td>
    </tr>
  </table>
</form>
ENDOFTEXT
}

sub PrintRedisplayInstructions {
  my $msg=shift;
  my $instructions=shift;
  print <<'ENDOFTEXT';
  <table>
    <tr>
ENDOFTEXT
      print "<th>$msg</th>\n";
      print <<'ENDOFTEXT';
    </tr>
    <tr><td style='color:red'>
ENDOFTEXT
      print "$instructions\n";
      print <<'ENDOFTEXT';
    </td></tr>
  </table>
ENDOFTEXT
}

sub PrintInputData {
  my $updater=shift;
  print "<textarea rows=12 cols=80 name=upfile>\n";
  print $updater->render();
  print <<'ENDOFTEXT';
  </textarea>
  <br>
  <input type=submit name=do_file value='Re-submit your changes'>
  <br>
ENDOFTEXT
}

sub PrintChangeDocumentation {
  print <<'ENDOFTEXT';
  <table class=wrapper border>
    <tr><th>Allowable Qualifier Maintenance Transactions</th></tr>
    <tr><td><table>
      <tr><td>
         ADD!new_qualifier_code!parent_qualifier_code!new_qualifier_name
      </td></tr>
      <tr><td>
       DELETE!qualifier_code
      </td></tr>
      <tr><td>
       ADDCHILD!child_qualifier_code!parent_qualifier_code
      </td></tr>
      <tr><td>
       DELCHILD!child_qualifier_code!parent_qualifier_code
      </td></tr>
      <tr><td>
       UPDATE!qualifier_code!NAME!old_name!new_name
      </td></tr>
      <tr><td>
       UPDATE!qualifier_code!PARENT!old_parent_qual_code!new_parent_qual_code
      </td></tr>
    </table></td></tr>
  </table>
ENDOFTEXT
}

sub ManualDataEntry {
  my $default_qt=shift; # set if a qualifier type was already selected
  print << 'ENDOFTEXT';
<form method='POST' enctype='multipart/form-data'
      action='RolesQM.pl?uploaded=manual_entry'>
  <textarea rows=12 cols=80 name=upfile></textarea>
  <br>
  <input type=submit name=do_file value='Submit your data'>
  <br>
  <table>
    <tr>
      <td>
ENDOFTEXT
        my $instructions='Submit your data when you are done';
        if (!$default_qt) {
          $instructions=$instructions
                        ." (and don't forget to select a qualifier type!)";
        }
        PrintRedisplayInstructions('Manual Data Entry',$instructions);
        print <<'ENDOFTEXT';
      </td>
      <td>
ENDOFTEXT
        PrintQualifierTypes($default_qt);
        print <<'ENDOFTEXT';
      </td>
    </tr>
  </table>
</form>
ENDOFTEXT
}

