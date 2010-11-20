
#Qualifier Four-Letter-Code: SUBJ

#
#  Copyright (C) 2009-2010 Massachusetts Institute of Technology
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

USE rolesbb;
INSERT INTO qualifier_type
  (qualifier_type, qualifier_type_desc, is_sensitive)
  VALUES ('SUBJ', 'Subjects and Sections', 'N');

# Run the below SELECT statement on qualifier BEFORE
# choosing a base id (qualifier_id) for it to make
# sure you have enough room to expand.
SELECT qualifier_type, min(qualifier_id), max(qualifier_id) 
        FROM qualifier
        GROUP BY qualifier_type
        ORDER BY min(qualifier_id);
        
        
INSERT INTO qualifier
  (qualifier_id, qualifier_code, qualifier_name,
    qualifier_type, has_child, qualifier_level, custom_hierarchy)
  VALUES (2000000,'ALL_SUBJECTS','All academic courses and subjects','SUBJ','N',1,'N');


# This SELECT statement will give you the value to use for the
# qualifier_id in the next INSERT statement
SELECT max(qualifier_id)+1 FROM qualifier WHERE qualifier_type = 'QTYP';

INSERT INTO qualifier 
  (qualifier_id, qualifier_code, qualifier_name, 
   qualifier_type, has_child, qualifier_level, custom_hierarchy) 
  VALUES (120038, 'QUAL_SUBJ', 'Qualifier type: SUBJ', 'QTYP', 'N', 2, 'N');

# Fix the parent/child/decendent mappings
INSERT INTO qualifier_child (parent_id, child_id) 
  VALUES (120000, 120038);

INSERT INTO qualifier_descendent (parent_id, child_id) 
  VALUES (120000, 120038);
  

# Add the MAX_SUBJ parameter to the parameters table to control the
# maximum number of actions permitted in a single transaction.
INSERT INTO rdb_t_roles_parameters
   (parameter,value,description,default_value,is_number,update_user,update_timestamp)
    VALUES ('MAX_SUBJ',2000,'Maximum number of actions allowed for SUBJ qualifiers',1000,'Y','BSKINNER',NOW());