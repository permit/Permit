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

use rolesbb;
select 5000*truncate(qualifier_id/5000,0), count(qualifier_id)
   from qualifier where qualifier_id between 6000000 and 6981520
   group by 5000*truncate(qualifier_id/5000,0);
   
# Delta will be 2000000, push COST up to 8000000 from 6000000
select min(qualifier_id), max(qualifier_id), qualifier_type
from qualifier
GROUP BY qualifier_type;


# Grab the existing authorizations so we can do a sanity check
# later on
select a.kerberos_name, a.qualifier_code, a.function_name 
from authorization a, qualifier q 
where q.qualifier_id = a.qualifier_id and q.qualifier_type = 'COST' 
order by a.kerberos_name, a.qualifier_code, a.function_name;

# The number of records returns should match the below statement:
select count(*)
from authorization a 
where a.qualifier_id BETWEEN 6000000 and 6999999;

# Record the result from this next statement for another sanity check later
select count(*)
from qualifier 
where qualifier_id BETWEEN 6000000 and 6999999;

# Create two temporary qualifier types
insert into qualifier_type values ('TST1', 'Temp qualtype 1', 'N'); 
insert into qualifier_type values ('TST2', 'Temp qualtype 2', 'N');

# Delta = 2000000
# old_min_id = 6000000
# old_max_id = 6999999
# new_min_id = 8000000
insert into qualifier
        (QUALIFIER_ID, qualifier_code, qualifier_name, qualifier_type, 
         HAS_CHILD, QUALIFIER_LEVEL, CUSTOM_HIERARCHY, STATUS, 
         LAST_MODIFIED_DATE)
        select QUALIFIER_ID+2000000, qualifier_code, qualifier_name, 'TST1',
               has_child, qualifier_level, custom_hierarchy, status,
               last_modified_date
        from qualifier where qualifier_type = 'COST';
        

# Cloning the parent/child relationships
insert into qualifier_child
        (parent_id, child_id)
         select PARENT_ID+2000000, CHILD_ID+2000000
        from qualifier_child where parent_id between 6000000 and 6999999;

insert into qualifier_descendent
        (parent_id, child_id)
         select PARENT_ID+2000000, CHILD_ID+2000000
        from qualifier_descendent where parent_id between 6000000 and 6999999;
        
        
insert into primary_auth_descendent
       (parent_id, child_id, is_dlc)
       select parent_id, child_id+2000000, is_dlc
       from primary_auth_descendent
       where child_id between 6000000 and 6999999;


update authorization set qualifier_id = qualifier_id+2000000
         where qualifier_id between 6000000 and 6999999;
         

# Move the COST qualifier type to TST2...     
update qualifier set qualifier_type = 'TST2'
        where qualifier_type = 'COST';

# ...then change the TST1 qualifier to COST
update qualifier set qualifier_type = 'COST'
        where qualifier_type = 'TST1';
        
        
# Sanity check time.
# The results from the first group of statement below...
select count(*) from qualifier where qualifier_type = 'TST2';
select count(*) from qualifier_child
    where child_id between 6000000 and 6999999;
select count(*) from qualifier_descendent
    where child_id between 6000000 and 6999999;
select count(*) from primary_auth_descendent
    where child_id between 6000000 and 6999999;
    
# ...Should match the results of statements from this next group
select count(*) from qualifier where qualifier_type = 'COST';
select count(*) from qualifier_child
    where child_id between 8000000 and 8999999;
select count(*) from qualifier_descendent
    where child_id between 8000000 and 8999999;
select count(*) from primary_auth_descendent
    where child_id between 8000000 and 8999999;
    

# Warning: Cleanup the 'old' qualifiers. This is destructive!
delete from primary_auth_descendent
    where child_id between 6000000 and 6999999;
    
delete from qualifier_child
    where child_id between 6000000 and 6999999;
delete from qualifier_descendent
    where child_id between 6000000 and 6999999;
    
delete from qualifier
    where qualifier_id between 6000000 and 6999999;
    
delete from qualifier_type where qualifier_type in ('TST1', 'TST2');