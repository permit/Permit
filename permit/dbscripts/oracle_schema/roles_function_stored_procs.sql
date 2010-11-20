/****************************************************************************
*
*  Connect as ROLESBB and run this script to create stored procedures for
*  the Roles DB.
*
*
*  Copyright (C) 2000-2010 Massachusetts Institute of Technology
*  For contact and other information see: http://mit.edu/permit/
*
*  This program is free software; you can redistribute it and/or modify it under the terms of the GNU General 
*  Public License as published by the Free Software Foundation; either version 2 of the License.
*
*  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even 
*  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public 
*  License for more details.
*
*  You should have received a copy of the GNU General Public License along with this program; if not, write 
*  to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*
****************************************************************************/

/****************************************************************************
*  Package roles_msg2
****************************************************************************/

CREATE OR REPLACE PACKAGE roles_msg2 AS
  err_no  integer;
  err_msg varchar2(255);
  err_20009_no integer := -20009;
  err_20009_msg varchar2(255) := 
    'Error creating/updating function: The function name already exists.'
    || ' (<name>)';
  err_20012_no integer := -20012;
  err_20012_msg varchar2(255) := 
   'Error creating/updating function: Function name must not be blank.';
  err_20013_no integer := -20013;
  err_20013_msg varchar2(255) := 
   'Error creating/updating function: Function name is too long.';
  err_20014_no integer := -20014;
  err_20014_msg varchar2(255) := 
   'Error creating/updating function: Function description is too long.';
  err_20015_no integer := -20015;
  err_20015_msg varchar2(255) := 
   'Error: Function category <category> does'
    || ' not exist.';
  err_20016_no integer := -20016;
  err_20016_msg varchar2(255) := 
   'Error: User <user> is not authorized to create/update/delete functions'
     || ' in category <category>';
  err_20017_no integer := -20017;
  err_20017_msg varchar2(255) := 
   'Error: Qualifier type <qualifier_type> does'
    || ' not exist.';
  err_20018_no integer := -20018;
  err_20018_msg varchar2(255) := 
   'Error creating/updating function: Primary_authorizable value <pa>'
    || ' must be Y or N.';
  err_20019_no integer := -20019;
  err_20019_msg varchar2(255) := 
   'Error creating/updating function: Primary_auth_group is too long.';
  err_20020_no integer := -20020;
  err_20020_msg varchar2(255) := 
   'Error creating/updating function: IS_PRIMARY_AUTH_PARENT must be'
      || ' Y, N, or null.';
  err_20021_no integer := -20021;
  err_20021_msg varchar2(255) := 
   'Error: User <user> is not authorized to maintain primary_auth'
     || ' parent functions';
  err_20022_no integer := -20021;
  err_20022_msg varchar2(255) := 
   'Error: Server <user> is not authorized to maintain primary_auth'
     || 'parent functions';
  err_20023_no integer := -20023;
  err_20023_msg varchar2(255) := 
   'Error creating/updating function: Primary_auth_group <group> is not valid.';
  err_20024_no integer := -20024;
  err_20024_msg varchar2(255) := 
   'Error creating/updating function: Primary_auth parent functions must have'
    || ' function_category=META and qualifier_type=DEPT';
  err_20025_no integer := -20025;
  err_20025_msg varchar2(255) := 
   'Error: Functions that are primary_authorizable'
    || ' or primary auth parents must have a primary_auth_group';
  err_20026_no integer := -20026;
  err_20026_msg varchar2(255) := 
   'Error: Functions that are neither primary_authorizable'
    || ' nor primary auth parents must not have a primary_auth_group';
  err_20027_no integer := -20027;
  err_20027_msg varchar2(255) := 
   'Error updating/deleting function: Function ID <function_id> does'
    || ' not exist.';
  err_20028_no integer := -20028;
  err_20028_msg varchar2(255) := 
   'Error: This function references <n> Authorization(s)'
   || ' and cannot be deleted.';
  err_20029_no integer := -20029;
  err_20029_msg varchar2(255) := 
   'Error: This function references <n> Authorization(s)'
   || '; the qualifier_type cannot be changed.';
  err_20030_no integer := -20030;
  err_20030_msg varchar2(255) := 
   'Error updating a Function or Function Group:'
   || ' You have not changed any fields';
  err_20031_no integer := -20031;
  err_20031_msg varchar2(255) := 
   'pa_authorizable must be Y, D, or N';
  err_20032_no integer := -20032;
  err_20032_msg varchar2(255) := 
   'Error removing function parent/child pair.  Parent/child pair '
   || '(<parent_id>, <child_id>) does not exist.';
  err_20033_no integer := -20033;
  err_20033_msg varchar2(255) := 
   'Error adding function parent/child pair.  Parent/child pair '
   || '(<parent_id>, <child_id>) already exists.';
  err_20034_no integer := -20034;
  err_20034_msg varchar2(255) := 
   'Error adding function parent/child pair.  Parent and child functions '
   || '(<parent_id>, <child_id>) do not have the same or related'
   || ' qualifier types.';
  err_20035_no integer := -20035;
  err_20035_msg varchar2(255) := 
   'Error adding function parent/child pair.  You cannot make a function '
   || 'a child of itself.';
  err_20036_no integer := -20036;
  err_20036_msg varchar2(255) := 
   'Error: This function or function group references <n> implied '
   || ' authorization rule(s) and cannot be deleted.';
  err_20037_no integer := -20037;
  err_20037_msg varchar2(255) := 
   'Error: This function is referenced by <n> rule(s)'
   || '; the qualifier_type cannot be changed.';
  err_20038_no integer := -20038;
  err_20038_msg varchar2(255) := 
   'Error: This function is referenced by one or more external auths or rules'
   || '; the function_category cannot be changed.';
  err_20039_no integer := -20039;
  err_20039_msg varchar2(255) := 
   'Error creating/updating function group: Function group name is too long.';
  err_20040_no integer := -20040;
  err_20040_msg varchar2(255) := 
   'Error creating/updating function group: Function group name'
   || ' must not be blank.';
  err_20041_no integer := -20041;
  err_20041_msg varchar2(255) := 
    'Error creating/updating function group: '
      || 'The function group name already exists. (<name>)';
  err_20042_no integer := -20042;
  err_20042_msg varchar2(255) := 
   'Error creating/updating function: Function description is too long.';
  err_20043_no integer := -20043;
  err_20043_msg varchar2(255) := 
   'Error: User <user> is not authorized to create/update/delete function'
     || ' groups or implied auth rules for category <category>';
  err_20044_no integer := -20044;
  err_20044_msg varchar2(255) := 
   'Error creating/updating function group: Matches_function value <mf>'
    || ' must be Y or N.';
  err_20045_no integer := -20045;
  err_20045_msg varchar2(255) := 
   'Error updating/deleting function group: '
   || 'Function Group ID <group_id> does not exist.';
  err_20046_no integer := -20046;
  err_20046_msg varchar2(255) := 
   'Error: This function group references <m> functions and <n> implied '
   || ' authorization rule(s); its function category cannot be changed.';
  err_20047_no integer := -20047;
  err_20047_msg varchar2(255) := 
   'Error: This function group references <m> functions and <n> implied '
   || ' authorization rule(s); its qualifier type cannot be changed.';
  err_20048_no integer := -20048;
  err_20048_msg varchar2(255) := 
   'Error: Could not add function group link.  Function <function_id> '
   || 'does not exist.';
  err_20049_no integer := -20049;
  err_20049_msg varchar2(255) := 
   'Error linking a function to a function group.  Function_group/function '
   || '(<parent_id>, <child_id>) link already exists.';
  err_20050_no integer := -20050;
  err_20050_msg varchar2(255) := 
   'Error linking function to a function_group.  The function group '
   || '<parent_id> and function <child_id> '
   || 'do not have the same qualifier type.';
  err_20051_no integer := -20051;
  err_20051_msg varchar2(255) := 
   'Error unlinking a function from a function group. Function_group/'
   || 'function (<parent_id>, <child_id>) link does not exist.';
  err_20052_no integer := -20052;
  err_20052_msg varchar2(255) := 
   'Error creating an external/implied function.  Function_load_pass '
   || '(<load_pass>) is not a number from 0 to 4';
END roles_msg2;
/


/****************************************************************************
*
*  Add routines
*  * function_group and function_group_link
*  * subtypes
*  * qualifier_type (add, delete, update)
*  * function_category (add, delete, update)
*
****************************************************************************/


/****************************************************************************
*  AUTH_SF_CAN_MAINT_PA_FUNC
*  
*  Test to see if the user is allowed to maintain "Primary Authorizer"
*  functions.
*
****************************************************************************/
create or replace FUNCTION auth_sf_can_maint_pa_func
		(ai_user IN varchar2) 
RETURN char
IS
v_check_auth varchar2(1);
begin
  /* Is requestor authorized to create function for the function_category? */
  select ROLESAPI_IS_USER_AUTHORIZED(upper(ai_user), 
           'MAINT PRIMARY AUTH FUNCTIONS', 'NULL')
         into v_check_auth from dual;
  return v_check_auth;
end ;
/

/****************************************************************************
*  ROLESAPI_CREATE_FUNCTION2
*  This is a stored procedure for creating functions that 
*  checks the authority of the server user (ai_server_user) and
*  the proxy user (ai_for_user) before allowing the function
*  to be created.
*
****************************************************************************/
CREATE OR REPLACE PROCEDURE ROLESAPI_CREATE_FUNCTION2
		(AI_SERVER_USER IN STRING,
                 AI_FOR_USER IN STRING,
                 AI_FUNCTION_NAME IN STRING,
		 AI_FUNCTION_DESCRIPTION IN STRING, 
		 AI_FUNCTION_CATEGORY IN STRING,
		 AI_QUALIFIER_TYPE IN STRING,
		 AI_PRIMARY_AUTHORIZABLE IN STRING,
		 AI_PRIMARY_AUTH_GROUP IN STRING,
		 AI_IS_PRIMARY_AUTH_PARENT IN STRING,
                 ao_function_id OUT STRING
		)
IS
V_FOR_USER varchar2(100);
V_SERVER_USER varchar2(100);
V_QUALIFIER_TYPE QUALIFIER.QUALIFIER_TYPE%TYPE;
V_FUNCTION_ID FUNCTION.FUNCTION_ID%TYPE;
V_FUNCTION_NAME FUNCTION.FUNCTION_NAME%TYPE;
V_FUNCTION_CATEGORY FUNCTION.FUNCTION_CATEGORY%TYPE;
V_FUNCTION_DESCRIPTION FUNCTION.FUNCTION_DESCRIPTION%TYPE;
V_PRIMARY_AUTHORIZABLE FUNCTION.PRIMARY_AUTHORIZABLE%TYPE;
V_PRIMARY_AUTH_GROUP FUNCTION.PRIMARY_AUTH_GROUP%TYPE;
V_IS_PRIMARY_AUTH_PARENT FUNCTION.IS_PRIMARY_AUTH_PARENT%TYPE;
v_count integer;
v_max_func_name_len integer := 30;
v_max_func_desc_len integer := 50;
v_max_pa_group_len integer := 4;
v_status integer;
v_msg_no roles_msg2.err_no%TYPE;
v_msg roles_msg2.err_msg%TYPE;
v_error_no roles_msg2.err_no%TYPE;
v_error_msg roles_msg2.err_msg%TYPE;
v_server_has_auth varchar2(1);
v_proxy_has_auth varchar2(1);

BEGIN
  v_for_user := upper(ai_for_user);
  if (ai_server_user is not null) then
    v_server_user := upper(ai_server_user);
  else
    v_server_user := upper(user);
  end if;

 /* Make sure function_name is not too long */
  if length(ai_function_name) > v_max_func_name_len then
     raise_application_error(roles_msg2.err_20013_no,
       roles_msg2.err_20013_msg || ' (Length must be <= ' || 
       to_char(v_max_func_name_len) || ' bytes.)');
  end if;

 /* Make sure function_name is not blank */
  if rtrim(ai_function_name, ' ') is null then
     raise_application_error(roles_msg2.err_20012_no,
       roles_msg2.err_20012_msg);
  else
     v_function_name := upper(ai_function_name);
  end if;

 /* Make sure function name does not already exist */
  select count(*) into v_count from function where function_name = 
      v_function_name;
  if v_count > 0 then 
     v_error_msg := replace(roles_msg2.err_20009_msg, 
                            '<name>', '''' || v_function_name || '''');
     raise_application_error(roles_msg2.err_20009_no, v_error_msg);
  end if;

 /* Make sure function_description is not too long */
  if length(ai_function_description) > v_max_func_desc_len then
     raise_application_error(roles_msg2.err_20014_no,
       roles_msg2.err_20014_msg || ' (Length must be <= ' || 
       to_char(v_max_func_desc_len) || ' bytes.)');
  end if;
  v_function_description := ai_function_description;

 /* Make sure function_category exists */
  select count(*) into v_count from category where function_category = 
      upper(ai_function_category);
  if v_count = 0 then 
     v_error_msg := replace(roles_msg2.err_20015_msg, '<category>', 
        '''' || ai_function_category || '''');
     raise_application_error(roles_msg2.err_20015_no, v_error_msg);
  else
     v_function_category := upper(ai_function_category);
  end if;

 /* Make sure both server_user and for_user are authorized to create 
    functions in the given category */
 /* Check authority of Oracle login-user to be proxy for creating functions */
  if (v_server_user <> user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
     if v_server_has_auth <> 'Y' then
       v_error_no := roles_service_constant.err_20003_no;
       v_error_msg := roles_service_constant.err_20003_msg;
       v_error_msg := replace(v_error_msg, '<server_id>', 
                              user);
       v_error_msg := replace(v_error_msg, '<function_category>', 
                              v_function_category);
       raise_application_error(v_error_no, v_error_msg);
     end if;
  end if;

  /* Check authority of server_user to be proxy for creating functions */
  if (v_server_user <> v_for_user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user, 
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
  else  -- No need to worry about separate server authorization
    v_server_has_auth := 'Y';
  end if;
  if v_server_has_auth <> 'Y' then
    v_error_no := roles_service_constant.err_20003_no;
    v_error_msg := roles_service_constant.err_20003_msg;
    v_error_msg := replace(v_error_msg, '<server_id>', 
                           v_server_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                           v_function_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;

  /* Check for_user authority to create function */
  if auth_sf_can_create_function(v_for_user, V_FUNCTION_CATEGORY) = 'N' then
     v_error_msg := replace(roles_msg2.err_20016_msg, '<category>', 
        '''' || ai_function_category || '''');
     v_error_msg := replace(v_error_msg, '<user>', '''' || v_for_user || '''');
     raise_application_error(roles_msg2.err_20016_no, v_error_msg);
  end if;

 /* Make sure the qualifier_type exists */
  select count(*) into v_count from qualifier_type where qualifier_type = 
      upper(ai_qualifier_type);
  if v_count = 0 then 
     v_error_msg := replace(roles_msg2.err_20017_msg, '<qualifier_type>', 
        '''' || ai_qualifier_type || '''');
     raise_application_error(roles_msg2.err_20017_no, v_error_msg);
  else
     v_qualifier_type := upper(ai_qualifier_type);
  end if;

 /* Make sure ai_primary_authorizable is 'Y', 'D', or 'N' */
  if upper(ai_primary_authorizable) in ('Y', 'D', 'N') then 
    v_primary_authorizable := upper(ai_primary_authorizable);
  else
     v_error_msg := replace(roles_msg2.err_20031_msg, '<pa>', 
        '''' || ai_primary_authorizable || '''');
     raise_application_error(roles_msg2.err_20031_no, v_error_msg);
  end if;

 /* Make sure primary_auth_group is not too long */
  if length(ai_primary_auth_group) > v_max_pa_group_len then
     raise_application_error(roles_msg2.err_20019_no,
       roles_msg2.err_20019_msg || ' (Length must be <= ' || 
       to_char(v_max_pa_group_len) || ' bytes.)');
  else
     v_primary_auth_group := upper(ai_primary_auth_group);
  end if;

 /* If IS_PRIMARY_AUTH_PARENT is not 'Y', make sure primary_auth_group 
    matches an existing one */
  if (nvl(v_is_primary_auth_parent, 'N') <> 'Y'   
      and v_primary_auth_group is not null) then
    select count(*) into v_count from function 
     where is_primary_auth_parent = 'Y'
     and primary_auth_group = v_primary_auth_group;
    if v_count = 0 then
       v_error_msg := 
          replace(roles_msg2.err_20023_msg, '<group>', v_primary_auth_group);
       raise_application_error(roles_msg2.err_20023_no, v_error_msg);
    end if;
  end if;

 /* Make sure IS_PRIMARY_AUTH_PARENT is Y, N or null. */
  if upper(nvl(ai_is_primary_auth_parent, 'N')) in ('Y', 'N') then 
    v_is_primary_auth_parent := upper(ai_is_primary_auth_parent);
  else
     raise_application_error(roles_msg2.err_20020_no, 
            roles_msg2.err_20020_msg);
  end if;

 /* Make sure that either the for_user is authorized to maintain 
    primary authorizer functions or IS_PRIMARY_AUTH_PARENT is  N or null. */ 
  if (nvl(v_is_primary_auth_parent, 'N') = 'Y') then
    if auth_sf_can_maint_pa_func(v_for_user) <> 'Y' then
      v_error_msg := replace(roles_msg2.err_20021_msg, '<user>', 
         '''' || v_for_user || '''');
      raise_application_error(roles_msg2.err_20021_no, v_error_msg);
    elsif auth_sf_can_maint_pa_func(v_server_user) <> 'Y' then
      v_error_msg := replace(roles_msg2.err_20022_msg, '<user>', 
         '''' || v_server_user || '''');
      raise_application_error(roles_msg2.err_20022_no, v_error_msg);
    end if;
  end if;

 /* If IS_PRIMARY_AUTH_PARENT is 'Y', make sure the category is 'META' 
    and qualifier_type is DEPT */
  if (nvl(v_is_primary_auth_parent, 'N') = 'Y' and 
      (v_function_category <> 'META' or v_qualifier_type <> 'DEPT') ) then
     raise_application_error(roles_msg2.err_20024_no, 
            roles_msg2.err_20024_msg);
  end if;

 /* If IS_PRIMARY_AUTH_PARENT is 'Y' or PRIMARY_AUTHORIZABLE is 'Y' or 'D', 
    make sure the PRIMARY_AUTH_GROUP is not null */
  if ( (nvl(v_is_primary_auth_parent,'N') = 'Y' 
        or nvl(v_primary_authorizable, 'N') = 'D'
        or nvl(v_primary_authorizable,'N') = 'Y')
       and v_primary_auth_group is null) then
     raise_application_error(roles_msg2.err_20025_no, 
            roles_msg2.err_20025_msg);
  end if;

 /* If IS_PRIMARY_AUTH_PARENT is 'N' and PRIMARY_AUTHORIZABLE is 'N', 
    make sure the PRIMARY_AUTH_GROUP is also null */
  if ( nvl(v_is_primary_auth_parent,'N') = 'N' 
       and nvl(v_primary_authorizable,'N') = 'N'
       and v_primary_auth_group is not null) then
     raise_application_error(roles_msg2.err_20026_no, 
            roles_msg2.err_20026_msg);
  end if;

 /* No errors found.  Insert a record into the FUNCTION table */
  select function_sequence.nextval into v_function_id from dual;
  insert into function
        (function_id, function_name, 
         function_description, function_category,
         creator, modified_by, modified_date, qualifier_type,
         primary_authorizable, is_primary_auth_parent, 
         primary_auth_group)
	values (v_function_id, V_FUNCTION_NAME, 
                v_function_description, v_function_category,
                v_for_user, v_for_user, sysdate, v_qualifier_type,
                v_primary_authorizable, v_is_primary_auth_parent, 
                v_primary_auth_group);
  ao_function_id := to_char(v_function_id);

end;
/

/****************************************************************************
*  ROLESAPI_CREATE_FUNC_GROUP
*  This is a stored procedure for creating function groups.  
*  It checks the authority of the server user (ai_server_user) and
*  the proxy user (ai_for_user) before allowing the function group
*  to be created.  To check the authorization for the proxy user,
*  it looks for an "CREATE IMPLIED AUTH RULES" authorization
*  for the given category.
*
****************************************************************************/
CREATE OR REPLACE PROCEDURE ROLESAPI_CREATE_FUNC_GROUP
		(AI_SERVER_USER IN STRING,
                 AI_FOR_USER IN STRING,
                 AI_GROUP_NAME IN STRING,
		 AI_GROUP_DESCRIPTION IN STRING, 
		 AI_FUNCTION_CATEGORY IN STRING,
                 AI_MATCHES_FUNCTION IN STRING,
		 AI_QUALIFIER_TYPE IN STRING,
                 ao_function_group_id OUT STRING
		)
IS
V_FOR_USER varchar2(100);
V_SERVER_USER varchar2(100);
V_QUALIFIER_TYPE QUALIFIER.QUALIFIER_TYPE%TYPE;
V_GROUP_ID FUNCTION_GROUP.FUNCTION_GROUP_ID%TYPE;
V_GROUP_NAME FUNCTION_GROUP.FUNCTION_GROUP_NAME%TYPE;
V_FUNCTION_CATEGORY FUNCTION_GROUP.FUNCTION_CATEGORY%TYPE;
V_GROUP_DESCRIPTION FUNCTION_GROUP.FUNCTION_GROUP_DESC%TYPE;
V_MATCHES_FUNCTION FUNCTION_GROUP.MATCHES_A_FUNCTION%TYPE;
v_count integer;
v_max_func_name_len integer := 30;
v_max_func_desc_len integer := 70;
v_status integer;
v_msg_no roles_msg2.err_no%TYPE;
v_msg roles_msg2.err_msg%TYPE;
v_error_no roles_msg2.err_no%TYPE;
v_error_msg roles_msg2.err_msg%TYPE;
v_server_has_auth varchar2(1);
v_proxy_has_auth varchar2(1);

BEGIN
  v_for_user := upper(ai_for_user);
  if (ai_server_user is not null) then
    v_server_user := upper(ai_server_user);
  else
    v_server_user := upper(user);
  end if;

 /* Make sure group_name is not too long */
  if length(ai_group_name) > v_max_func_name_len then
     raise_application_error(roles_msg2.err_20039_no,
       roles_msg2.err_20039_msg || ' (Length must be <= ' || 
       to_char(v_max_func_name_len) || ' bytes.)');
  end if;

 /* Make sure group_name is not blank */
  if rtrim(ai_group_name, ' ') is null then
     raise_application_error(roles_msg2.err_20040_no,
       roles_msg2.err_20040_msg);
  else
     v_group_name := upper(ai_group_name);
  end if;

 /* Make sure function group name does not already exist */
  select count(*) into v_count from function_group 
      where function_group_name = v_group_name;
  if v_count > 0 then 
     v_error_msg := replace(roles_msg2.err_20041_msg, 
                            '<name>', '''' || v_group_name || '''');
     raise_application_error(roles_msg2.err_20041_no, v_error_msg);
  end if;

 /* Make sure function_description is not too long */
  if length(ai_group_description) > v_max_func_desc_len then
     raise_application_error(roles_msg2.err_20042_no,
       roles_msg2.err_20042_msg || ' (Length must be <= ' || 
       to_char(v_max_func_desc_len) || ' bytes.)');
  end if;
  v_group_description := ai_group_description;

 /* Make sure function_category exists */
  select count(*) into v_count from category where function_category = 
      upper(ai_function_category);
  if v_count = 0 then 
     v_error_msg := replace(roles_msg2.err_20015_msg, '<category>', 
        '''' || ai_function_category || '''');
     raise_application_error(roles_msg2.err_20015_no, v_error_msg);
  else
     v_function_category := upper(ai_function_category);
  end if;

 /* Make sure both server_user and for_user are authorized to create 
    functions in the given category */
 /* Check authority of Oracle login-user to be proxy for creating functions */
  if (v_server_user <> user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
     if v_server_has_auth <> 'Y' then
       v_error_no := roles_service_constant.err_20003_no;
       v_error_msg := roles_service_constant.err_20003_msg;
       v_error_msg := replace(v_error_msg, '<server_id>', 
                              user);
       v_error_msg := replace(v_error_msg, '<function_category>', 
                              v_function_category);
       raise_application_error(v_error_no, v_error_msg);
     end if;
  end if;

  /* Check authority of server_user to be proxy for creating functions */
  if (v_server_user <> v_for_user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user, 
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
  else  -- No need to worry about separate server authorization
    v_server_has_auth := 'Y';
  end if;
  if v_server_has_auth <> 'Y' then
    v_error_no := roles_service_constant.err_20003_no;
    v_error_msg := roles_service_constant.err_20003_msg;
    v_error_msg := replace(v_error_msg, '<server_id>', 
                           v_server_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                           v_function_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;

  /* Check for_user authority to create function group.
     This is controlled by CREATE IMPLIED AUTH RULES authorizations */
  SELECT ROLESAPI_IS_USER_AUTHORIZED(v_for_user,
                                     'CREATE IMPLIED AUTH RULES', 
                                        'CAT' || trim(v_function_category)) 
        INTO v_proxy_has_auth
        FROM DUAL;

  if v_proxy_has_auth = 'N' then
     v_error_msg := replace(roles_msg2.err_20043_msg, '<category>', 
        '''' || ai_function_category || '''');
     v_error_msg := replace(v_error_msg, '<user>', '''' || v_for_user || '''');
     raise_application_error(roles_msg2.err_20043_no, v_error_msg);
  end if;

 /* Make sure the qualifier_type exists */
  select count(*) into v_count from qualifier_type where qualifier_type = 
      upper(ai_qualifier_type);
  if v_count = 0 then 
     v_error_msg := replace(roles_msg2.err_20017_msg, '<qualifier_type>', 
        '''' || ai_qualifier_type || '''');
     raise_application_error(roles_msg2.err_20017_no, v_error_msg);
  else
     v_qualifier_type := upper(ai_qualifier_type);
  end if;

 /* Make sure AI_MATCHES_FUNCTION is 'Y' or 'N'
    The field in the table MATCHES_A_FUNCTION is intended for
    use in the future to allow a function_group and an external function
    sharing the same name.  Currently, no special processing for 
    this scenario is supported, but we do support the field in the table.   */
 v_matches_function := upper(ai_matches_function);
 if (v_matches_function <> 'Y' and v_matches_function <> 'N') then
     v_error_msg := replace(roles_msg2.err_20044_msg, '<mf>', 
        '''' || ai_matches_function || '''');
     raise_application_error(roles_msg2.err_20044_no, v_error_msg);
 end if;

 /* No errors found.  Insert a record into the FUNCTION_GROUP table */
  select function_sequence.nextval into v_group_id from dual;
  insert into function_group
        (function_group_id, function_group_name, 
         function_group_desc, function_category,
         matches_a_function, 
         qualifier_type,
         modified_by, modified_date)
	values (v_group_id, V_group_NAME, 
                v_group_description, v_function_category,
                v_matches_function,
                v_qualifier_type, v_for_user, sysdate);
  ao_function_group_id := to_char(v_group_id);

end;
/

/****************************************************************************
*  ROLESAPI_UPDATE_FUNC_GROUP
*  This is a stored procedure for updating function groups.  
*  It checks the authority of the server user (ai_server_user) and
*  the proxy user (ai_for_user) before allowing the function
*  to be updated.  To check the authorization for the proxy user,
*  it looks for an "CREATE IMPLIED AUTH RULES" authorization
*  for the given category.
*
*  Allow the group_name and group_description to be modified.  Make sure
*  the new group_name does not already exist.  If there are any rules 
*  that reference the group_name, then update the group name in those rules.
*
*  Do not allow the function_category to be modified if there are any 
*  rules that reference this function_group or if there are any linked
*  functions.  Make sure the for_user and proxy_user are authorized 
*  to maintain function_groups in both the old and new category.
*
*  Do not allow the qualifier_type to be modified if there are any 
*  rules that reference this function_group or if there are any linked
*  functions.
*
****************************************************************************/
CREATE OR REPLACE PROCEDURE ROLESAPI_UPDATE_FUNC_GROUP
		(AI_SERVER_USER IN STRING,
                 AI_FOR_USER IN STRING,
                 AI_GROUP_ID IN STRING,
                 AI_GROUP_NAME IN STRING,
		 AI_GROUP_DESCRIPTION IN STRING, 
		 AI_FUNCTION_CATEGORY IN STRING,
                 AI_MATCHES_FUNCTION IN STRING,
		 AI_QUALIFIER_TYPE IN STRING
		)
IS
V_FOR_USER varchar2(100);
V_SERVER_USER varchar2(100);
V_QUALIFIER_TYPE QUALIFIER.QUALIFIER_TYPE%TYPE;
V_GROUP_ID FUNCTION_GROUP.FUNCTION_GROUP_ID%TYPE;
V_GROUP_NAME FUNCTION_GROUP.FUNCTION_GROUP_NAME%TYPE;
V_FUNCTION_CATEGORY FUNCTION_GROUP.FUNCTION_CATEGORY%TYPE;
V_GROUP_DESCRIPTION FUNCTION_GROUP.FUNCTION_GROUP_DESC%TYPE;
V_MATCHES_FUNCTION FUNCTION_GROUP.MATCHES_A_FUNCTION%TYPE;

V_OLD_QUALIFIER_TYPE QUALIFIER.QUALIFIER_TYPE%TYPE;
V_OLD_GROUP_NAME FUNCTION_GROUP.FUNCTION_GROUP_NAME%TYPE;
V_OLD_FUNCTION_CATEGORY FUNCTION_GROUP.FUNCTION_CATEGORY%TYPE;
V_OLD_GROUP_DESCRIPTION FUNCTION_GROUP.FUNCTION_GROUP_DESC%TYPE;
V_OLD_MATCHES_FUNCTION FUNCTION_GROUP.MATCHES_A_FUNCTION%TYPE;
v_count integer;
v_rule_count integer;
v_link_count integer;
v_max_func_name_len integer := 30;
v_max_func_desc_len integer := 70;
v_status integer;
v_msg_no roles_msg2.err_no%TYPE;
v_msg roles_msg2.err_msg%TYPE;
v_error_no roles_msg2.err_no%TYPE;
v_error_msg roles_msg2.err_msg%TYPE;
v_server_has_auth varchar2(1);
v_proxy_has_auth varchar2(1);

BEGIN
  v_for_user := upper(ai_for_user);
  if (ai_server_user is not null) then
    v_server_user := upper(ai_server_user);
  else
    v_server_user := upper(user);
  end if;

 /* Make sure the function_group_id exists */
  select count(*) into v_count
    from function_group where to_char(function_group_id) = ai_group_id;
  if v_count = 0 then
     v_error_msg := replace(roles_msg2.err_20045_msg, '<group_id>', 
                            '''' || ai_group_id || '''');
     raise_application_error(roles_msg2.err_20045_no, v_error_msg);
  else
     v_group_id := to_number(ai_group_id);
     select FUNCTION_GROUP_NAME, FUNCTION_GROUP_DESC, FUNCTION_CATEGORY,
            MATCHES_A_FUNCTION, QUALIFIER_TYPE
        into v_old_group_name, v_old_group_description,
             v_old_function_category, v_old_matches_function,
             v_old_qualifier_type
     from function_group where function_group_id = v_group_id;
  end if; 

 /* Make sure group_name is not too long */
  if length(ai_group_name) > v_max_func_name_len then
     raise_application_error(roles_msg2.err_20039_no,
       roles_msg2.err_20039_msg || ' (Length must be <= ' || 
       to_char(v_max_func_name_len) || ' bytes.)');
  end if;

 /* Make sure group_name is not blank */
  if rtrim(ai_group_name, ' ') is null then
     raise_application_error(roles_msg2.err_20040_no,
       roles_msg2.err_20040_msg);
  else
     v_group_name := upper(ai_group_name);
  end if;

 /* Make sure function group name does not already exist */
  select count(*) into v_count from function_group 
      where function_group_name = v_group_name
      and function_group_id <> v_group_id;
  if v_count > 0 then 
     v_error_msg := replace(roles_msg2.err_20041_msg, 
                            '<name>', '''' || v_group_name || '''');
     raise_application_error(roles_msg2.err_20041_no, v_error_msg);
  end if;

 /* Make sure function_description is not too long */
  if length(ai_group_description) > v_max_func_desc_len then
     raise_application_error(roles_msg2.err_20042_no,
       roles_msg2.err_20042_msg || ' (Length must be <= ' || 
       to_char(v_max_func_desc_len) || ' bytes.)');
  end if;
  v_group_description := ai_group_description;

 /* Make sure function_category exists */
  select count(*) into v_count from category where function_category = 
      upper(ai_function_category);
  if v_count = 0 then 
     v_error_msg := replace(roles_msg2.err_20015_msg, '<category>', 
        '''' || ai_function_category || '''');
     raise_application_error(roles_msg2.err_20015_no, v_error_msg);
  else
     v_function_category := upper(ai_function_category);
  end if;

 /* Make sure both server_user and for_user are authorized to create 
    functions in the given category.  Check both the old and new categories. */
 /* Check authority of Oracle login-user to be proxy for creating function
    groups in the new category */
  if (v_server_user <> user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
     if v_server_has_auth <> 'Y' then
       v_error_no := roles_service_constant.err_20003_no;
       v_error_msg := roles_service_constant.err_20003_msg;
       v_error_msg := replace(v_error_msg, '<server_id>', 
                              user);
       v_error_msg := replace(v_error_msg, '<function_category>', 
                              v_function_category);
       raise_application_error(v_error_no, v_error_msg);
     end if;
  end if;

 /* Check authority of Oracle login-user to be proxy for creating function
    groups in the old category */
  if (v_server_user <> user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                       'RUN ROLES SERVICE PROCEDURES', 
                                       'CAT' || trim(v_old_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
     if v_server_has_auth <> 'Y' then
       v_error_no := roles_service_constant.err_20003_no;
       v_error_msg := roles_service_constant.err_20003_msg;
       v_error_msg := replace(v_error_msg, '<server_id>', 
                              user);
       v_error_msg := replace(v_error_msg, '<function_category>', 
                              v_old_function_category);
       raise_application_error(v_error_no, v_error_msg);
     end if;
  end if;

  /* Check authority of server_user to be proxy for creating function
     groups in the new category */
  if (v_server_user <> v_for_user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user, 
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
  else  -- No need to worry about separate server authorization
    v_server_has_auth := 'Y';
  end if;
  if v_server_has_auth <> 'Y' then
    v_error_no := roles_service_constant.err_20003_no;
    v_error_msg := roles_service_constant.err_20003_msg;
    v_error_msg := replace(v_error_msg, '<server_id>', 
                           v_server_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                           v_function_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;

  /* Check authority of server_user to be proxy for creating function
     groups in the old category */
  if (v_server_user <> v_for_user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user, 
                                       'RUN ROLES SERVICE PROCEDURES', 
                                       'CAT' || trim(v_old_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
  else  -- No need to worry about separate server authorization
    v_server_has_auth := 'Y';
  end if;
  if v_server_has_auth <> 'Y' then
    v_error_no := roles_service_constant.err_20003_no;
    v_error_msg := roles_service_constant.err_20003_msg;
    v_error_msg := replace(v_error_msg, '<server_id>', 
                           v_server_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                           v_old_function_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;

  /* Check for_user authority to create function groups in the new category.
     This is controlled by CREATE IMPLIED AUTH RULES authorizations */
  SELECT ROLESAPI_IS_USER_AUTHORIZED(v_for_user,
                                     'CREATE IMPLIED AUTH RULES', 
                                        'CAT' || trim(v_function_category)) 
        INTO v_proxy_has_auth
        FROM DUAL;

  if v_proxy_has_auth = 'N' then
     v_error_msg := replace(roles_msg2.err_20043_msg, '<category>', 
        '''' || ai_function_category || '''');
     v_error_msg := replace(v_error_msg, '<user>', '''' || v_for_user || '''');
     raise_application_error(roles_msg2.err_20043_no, v_error_msg);
  end if;

  /* Check for_user authority to create function groups in the old category.
     This is controlled by CREATE IMPLIED AUTH RULES authorizations */
  SELECT ROLESAPI_IS_USER_AUTHORIZED(v_for_user,
                                     'CREATE IMPLIED AUTH RULES', 
                                       'CAT' || trim(v_old_function_category)) 
        INTO v_proxy_has_auth
        FROM DUAL;

  if v_proxy_has_auth = 'N' then
     v_error_msg := replace(roles_msg2.err_20043_msg, '<category>', 
        '''' || v_old_function_category || '''');
     v_error_msg := replace(v_error_msg, '<user>', '''' || v_for_user || '''');
     raise_application_error(roles_msg2.err_20043_no, v_error_msg);
  end if;

 /* Make sure the qualifier_type exists */
  select count(*) into v_count from qualifier_type where qualifier_type = 
      upper(ai_qualifier_type);
  if v_count = 0 then 
     v_error_msg := replace(roles_msg2.err_20017_msg, '<qualifier_type>', 
        '''' || ai_qualifier_type || '''');
     raise_application_error(roles_msg2.err_20017_no, v_error_msg);
  else
     v_qualifier_type := upper(ai_qualifier_type);
  end if;

 /* Make sure AI_MATCHES_FUNCTION is 'Y' or 'N'
    The field in the table MATCHES_A_FUNCTION is intended for
    use in the future to allow a function_group and an external function
    sharing the same name.  Currently, no special processing for 
    this scenario is supported, but we do support the field in the table.   */
 v_matches_function := upper(ai_matches_function);
 if (v_matches_function <> 'Y' and v_matches_function <> 'N') then
     v_error_msg := replace(roles_msg2.err_20044_msg, '<mf>', 
        '''' || ai_matches_function || '''');
     raise_application_error(roles_msg2.err_20044_no, v_error_msg);
 end if;

 /* Get the number of rules referencing this function_group. */
   select count(*) into v_rule_count
    from implied_auth_rule
    where rtrim(condition_function_category)=rtrim(v_old_function_category)
             and condition_function_name = v_old_group_name
             and condition_function_or_group = 'G';

 /* Get the number of functions linked to this function_group. */
   select count(*) into v_link_count
    from function_group_link
    where parent_id = v_group_id;

 /* If the new function_category is different than the old function_category,
    make sure there are no referenced rules or links to functions */
  if (v_function_category <> v_old_function_category) then
    if (v_link_count > 0 or v_rule_count > 0) then
       v_error_msg := replace(roles_msg2.err_20046_msg, '<m>', 
                              to_char(v_link_count));
       v_error_msg := replace(v_error_msg, '<n>', 
                              to_char(v_rule_count));
       raise_application_error(roles_msg2.err_20046_no, v_error_msg);
    end if;
  end if;

 /* If the new qualifier_type is different than the old qualifier_type,
    make sure there are no referenced rules or links to functions */
  if (v_qualifier_type <> v_old_qualifier_type) then
    if (v_link_count > 0 or v_rule_count > 0) then
       v_error_msg := replace(roles_msg2.err_20047_msg, '<m>', 
                              to_char(v_link_count));
       v_error_msg := replace(v_error_msg, '<n>', 
                              to_char(v_rule_count));
       raise_application_error(roles_msg2.err_20047_no, v_error_msg);
    end if;
  end if;

 /* Make sure that at least one field has changed */
  if (v_old_group_name = v_group_name
      and v_old_group_description = v_group_description
      and v_old_function_category = v_function_category
      and v_old_qualifier_type = v_qualifier_type
      and v_old_matches_function = v_matches_function)
  then
     raise_application_error(roles_msg2.err_20030_no, 
            roles_msg2.err_20030_msg);
  end if;

 /* No errors found.  Update the record in the FUNCTION_GROUP table.
    Also update any rules that reference this function_group. */
  update function_group
         set function_group_name = v_group_name,
         function_group_desc = v_group_description,
         function_category = v_function_category,
         matches_a_function = v_matches_function,
         qualifier_type = v_qualifier_type,
         modified_by = v_for_user,
         modified_date = sysdate
       where function_group_id = v_group_id;
  if (v_group_name <> v_old_group_name) then
    update implied_auth_rule 
      set condition_function_or_group = v_group_name,
          condition_function_category = v_function_category
      where condition_function_or_group = v_old_group_name
      and condition_function_category = v_old_function_category;
  end if;

end;
/

/****************************************************************************
*  ROLESAPI_CREATE_EXT_FUNCTION
*  This is a stored procedure for creating implied functions (in the
*  EXTERNAL_FUNCTION table).  It also inserts one record into the
*  table EXTERNAL_FUNCTION and another record into FUNCTION_LOAD_PASS.  It  
*  checks the authority of the server user (ai_server_user) and
*  the proxy user (ai_for_user) before allowing the function
*  to be created.
*
****************************************************************************/
CREATE OR REPLACE PROCEDURE ROLESAPI_CREATE_EXT_FUNCTION
		(AI_SERVER_USER IN STRING,
                 AI_FOR_USER IN STRING,
                 AI_FUNCTION_NAME IN STRING,
		 AI_FUNCTION_DESCRIPTION IN STRING, 
		 AI_FUNCTION_CATEGORY IN STRING,
		 AI_QUALIFIER_TYPE IN STRING,
                 AI_FUNCTION_LOAD_PASS IN STRING,
                 ao_function_id OUT STRING
		)
IS
V_FOR_USER varchar2(100);
V_SERVER_USER varchar2(100);
V_QUALIFIER_TYPE QUALIFIER.QUALIFIER_TYPE%TYPE;
V_FUNCTION_ID FUNCTION.FUNCTION_ID%TYPE;
v_temp_function_name varchar2(200);
V_FUNCTION_NAME FUNCTION.FUNCTION_NAME%TYPE;
V_FUNCTION_CATEGORY FUNCTION.FUNCTION_CATEGORY%TYPE;
V_FUNCTION_DESCRIPTION FUNCTION.FUNCTION_DESCRIPTION%TYPE;
v_count integer;
v_function_load_pass integer;
v_max_func_name_len integer := 30;
v_max_func_desc_len integer := 50;
v_max_pa_group_len integer := 4;
v_status integer;
v_msg_no roles_msg2.err_no%TYPE;
v_msg roles_msg2.err_msg%TYPE;
v_error_no roles_msg2.err_no%TYPE;
v_error_msg roles_msg2.err_msg%TYPE;
v_server_has_auth varchar2(1);
v_proxy_has_auth varchar2(1);

BEGIN
  v_for_user := upper(ai_for_user);
  if (ai_server_user is not null) then
    v_server_user := upper(ai_server_user);
  else
    v_server_user := upper(user);
  end if;

 /* Make sure function_name is not blank */
  if rtrim(ai_function_name, ' ') is null then
     raise_application_error(roles_msg2.err_20012_no,
       roles_msg2.err_20012_msg);
  else
     v_function_name := upper(ai_function_name);
  end if;

 /* If the function_name does not start with an asterisk, add one */
  if (substr(ai_function_name, 1, 1) = '*') then
     v_temp_function_name := ai_function_name;
  else
     v_temp_function_name := '*' || ai_function_name;
  end if;

 /* Make sure function_name is not too long */
  if length(v_temp_function_name) > v_max_func_name_len then
     raise_application_error(roles_msg2.err_20013_no,
       roles_msg2.err_20013_msg || ' (Length must be <= ' || 
       to_char(v_max_func_name_len) || ' bytes.)');
  end if;

 /* Make sure function name does not already exist */
  select count(*) into v_count from external_function where function_name = 
      v_function_name;
  if v_count > 0 then 
     v_error_msg := replace(roles_msg2.err_20009_msg, 
                            '<name>', '''' || v_function_name || '''');
     raise_application_error(roles_msg2.err_20009_no, v_error_msg);
  end if;

 /* Make sure function_description is not too long */
  if length(ai_function_description) > v_max_func_desc_len then
     raise_application_error(roles_msg2.err_20014_no,
       roles_msg2.err_20014_msg || ' (Length must be <= ' || 
       to_char(v_max_func_desc_len) || ' bytes.)');
  end if;
  v_function_description := ai_function_description;

 /* Make sure function_category exists */
  select count(*) into v_count from category where function_category = 
      upper(ai_function_category);
  if v_count = 0 then 
     v_error_msg := replace(roles_msg2.err_20015_msg, '<category>', 
        '''' || ai_function_category || '''');
     raise_application_error(roles_msg2.err_20015_no, v_error_msg);
  else
     v_function_category := upper(ai_function_category);
  end if;

 /* Make sure function_load_pass is a valid number */
  if ai_function_load_pass in ('0', '1', '2', '3', '4') then
     v_function_load_pass := to_number(ai_function_load_pass);
  else
     v_error_msg := replace(roles_msg2.err_20052_msg, '<load_pass>', 
        '''' || ai_function_load_pass || '''');
     raise_application_error(roles_msg2.err_20052_no, v_error_msg);
  end if;

 /* Make sure both server_user and for_user are authorized to create 
    functions in the given category */
 /* Check authority of Oracle login-user to be proxy for creating functions */
  if (v_server_user <> user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
     if v_server_has_auth <> 'Y' then
       v_error_no := roles_service_constant.err_20003_no;
       v_error_msg := roles_service_constant.err_20003_msg;
       v_error_msg := replace(v_error_msg, '<server_id>', 
                              user);
       v_error_msg := replace(v_error_msg, '<function_category>', 
                              v_function_category);
       raise_application_error(v_error_no, v_error_msg);
     end if;
  end if;

  /* Check authority of server_user to be proxy for creating functions */
  if (v_server_user <> v_for_user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user, 
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
  else  -- No need to worry about separate server authorization
    v_server_has_auth := 'Y';
  end if;
  if v_server_has_auth <> 'Y' then
    v_error_no := roles_service_constant.err_20003_no;
    v_error_msg := roles_service_constant.err_20003_msg;
    v_error_msg := replace(v_error_msg, '<server_id>', 
                           v_server_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                           v_function_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;

  /* Check for_user authority to create function */
  if auth_sf_can_create_function(v_for_user, V_FUNCTION_CATEGORY) = 'N' then
     v_error_msg := replace(roles_msg2.err_20016_msg, '<category>', 
        '''' || ai_function_category || '''');
     v_error_msg := replace(v_error_msg, '<user>', '''' || v_for_user || '''');
     raise_application_error(roles_msg2.err_20016_no, v_error_msg);
  end if;

 /* Make sure the qualifier_type exists */
  select count(*) into v_count from qualifier_type where qualifier_type = 
      upper(ai_qualifier_type);
  if v_count = 0 then 
     v_error_msg := replace(roles_msg2.err_20017_msg, '<qualifier_type>', 
        '''' || ai_qualifier_type || '''');
     raise_application_error(roles_msg2.err_20017_no, v_error_msg);
  else
     v_qualifier_type := upper(ai_qualifier_type);
  end if;

 /* No errors found.  Insert a record into the FUNCTION table */
  select function_sequence.nextval into v_function_id from dual;
  insert into external_function
        (function_id, function_name, 
         function_description, function_category,
         creator, modified_by, modified_date, qualifier_type,
         primary_authorizable)
	values (v_function_id, v_temp_function_name, 
                v_function_description, v_function_category,
                v_for_user, v_for_user, sysdate, v_qualifier_type,
                'N');
  ao_function_id := to_char(v_function_id);
  insert into function_load_pass (function_id, pass_number)
    values (v_function_id, v_function_load_pass);

end;
/

/****************************************************************************
*  ROLESAPI_UPDATE_FUNCTION2
*  This is a stored procedure for updating functions that 
*  checks the authority of the server user (ai_server_user) and
*  the proxy user (ai_for_user) before allowing the function
*  to be updated. 
*
****************************************************************************/
CREATE OR REPLACE PROCEDURE ROLESAPI_UPDATE_FUNCTION2
		(AI_SERVER_USER IN STRING,
                 AI_FOR_USER IN STRING,
                 AI_FUNCTION_ID IN STRING,
                 AI_FUNCTION_NAME IN STRING,
		 AI_FUNCTION_DESCRIPTION IN STRING, 
		 AI_FUNCTION_CATEGORY IN STRING,
		 AI_QUALIFIER_TYPE IN STRING,
		 AI_PRIMARY_AUTHORIZABLE IN STRING,
		 AI_PRIMARY_AUTH_GROUP IN STRING,
		 AI_IS_PRIMARY_AUTH_PARENT IN STRING
		)
IS
V_FOR_USER PERSON.KERBEROS_NAME%TYPE;
V_SERVER_USER PERSON.KERBEROS_NAME%TYPE;
V_QUALIFIER_TYPE QUALIFIER.QUALIFIER_TYPE%TYPE;
V_FUNCTION_ID FUNCTION.FUNCTION_ID%TYPE;
V_FUNCTION_NAME FUNCTION.FUNCTION_NAME%TYPE;
V_FUNCTION_CATEGORY FUNCTION.FUNCTION_CATEGORY%TYPE;
V_FUNCTION_DESCRIPTION FUNCTION.FUNCTION_DESCRIPTION%TYPE;
V_PRIMARY_AUTHORIZABLE FUNCTION.PRIMARY_AUTHORIZABLE%TYPE;
V_PRIMARY_AUTH_GROUP FUNCTION.PRIMARY_AUTH_GROUP%TYPE;
V_IS_PRIMARY_AUTH_PARENT FUNCTION.IS_PRIMARY_AUTH_PARENT%TYPE;
V_OLD_QUALIFIER_TYPE QUALIFIER.QUALIFIER_TYPE%TYPE;
V_OLD_FUNCTION_NAME FUNCTION.FUNCTION_NAME%TYPE;
V_OLD_FUNCTION_CATEGORY FUNCTION.FUNCTION_CATEGORY%TYPE;
V_OLD_FUNCTION_DESCRIPTION FUNCTION.FUNCTION_DESCRIPTION%TYPE;
V_OLD_PRIMARY_AUTHORIZABLE FUNCTION.PRIMARY_AUTHORIZABLE%TYPE;
V_OLD_PRIMARY_AUTH_GROUP FUNCTION.PRIMARY_AUTH_GROUP%TYPE;
V_OLD_IS_PA_PARENT FUNCTION.IS_PRIMARY_AUTH_PARENT%TYPE;
v_max_func_name_len integer := 30;
v_max_func_desc_len integer := 50;
v_max_pa_group_len integer := 4;
v_count integer;
v_auth_count integer;
v_status integer;
v_error_no roles_msg.err_no%TYPE;
v_error_msg roles_msg.err_msg%TYPE;
v_msg_no roles_msg.err_no%TYPE;
v_msg roles_msg.err_msg%TYPE;
v_server_has_auth varchar2(1);
v_proxy_has_auth varchar2(1);

BEGIN
  v_for_user := upper(ai_for_user);
  if (ai_server_user is not null) then
    v_server_user := upper(ai_server_user);
  else
    v_server_user := upper(user);
  end if;

 /* Make sure the function_id exists */
  select count(*) into v_count
    from function where to_char(function_id) = ai_function_id;
  if v_count = 0 then
     v_error_msg := replace(roles_msg2.err_20027_msg, '<function_id>', 
                            '''' || ai_function_id || '''');
     raise_application_error(roles_msg2.err_20027_no, v_error_msg);
  else
     v_function_id := to_number(ai_function_id);
     select FUNCTION_NAME, FUNCTION_DESCRIPTION, FUNCTION_CATEGORY, 
            QUALIFIER_TYPE, PRIMARY_AUTHORIZABLE,
            IS_PRIMARY_AUTH_PARENT, PRIMARY_AUTH_GROUP
        into v_old_function_name, v_old_function_description, 
             v_old_function_category,
             v_old_qualifier_type, v_old_primary_authorizable,
             v_old_is_pa_parent, v_old_primary_auth_group
     from function where function_id = v_function_id;
  end if; 

 /* Check authorizations for old function_category */
 /* Make sure both server_user and for_user are authorized to create 
    functions in the given category */
 /* Check authority of Oracle login-user to be proxy for creating functions */
  if (v_server_user <> user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                        'RUN ROLES SERVICE PROCEDURES', 
                                      'CAT' || trim(v_old_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
     if v_server_has_auth <> 'Y' then
       v_error_no := roles_service_constant.err_20003_no;
       v_error_msg := roles_service_constant.err_20003_msg;
       v_error_msg := replace(v_error_msg, '<server_id>', 
                              user);
       v_error_msg := replace(v_error_msg, '<function_category>', 
                              v_old_function_category);
       raise_application_error(v_error_no, v_error_msg);
     end if;
  end if;

  /* Check authority of server_user to be proxy for creating functions */
  if (v_server_user <> v_for_user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user, 
                                        'RUN ROLES SERVICE PROCEDURES', 
                                    'CAT' || trim(v_old_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
  else  -- No need to worry about separate server authorization
    v_server_has_auth := 'Y';
  end if;
  if v_server_has_auth <> 'Y' then
    v_error_no := roles_service_constant.err_20003_no;
    v_error_msg := roles_service_constant.err_20003_msg;
    v_error_msg := replace(v_error_msg, '<server_id>', 
                           v_server_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                           v_old_function_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;

 /* Make sure the new function_category exists */
  select count(*) into v_count from category where function_category = 
      upper(ai_function_category);
  if v_count = 0 then 
     v_error_msg := replace(roles_msg2.err_20015_msg, '<category>', 
        '''' || ai_function_category || '''');
     raise_application_error(roles_msg2.err_20015_no, v_error_msg);
  else
     v_function_category := upper(ai_function_category);
  end if;

 /* If the function_category has changed, then
    make sure new function_category exists.  Also, make sure 
    that both server_user and
    for_user are authorized to update functions in the new category */
  if (v_function_category <> v_old_function_category) then
  ----
   v_server_has_auth := 'N';
   /* Check authority of Oracle login-user to be proxy for creating funcs */
    if (v_server_user <> user) then
       SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                          'RUN ROLES SERVICE PROCEDURES', 
                                       'CAT' || trim(v_function_category)) 
          INTO v_server_has_auth
          FROM DUAL;
       if v_server_has_auth <> 'Y' then
         v_error_no := roles_service_constant.err_20003_no;
         v_error_msg := roles_service_constant.err_20003_msg;
         v_error_msg := replace(v_error_msg, '<server_id>', 
                                user);
         v_error_msg := replace(v_error_msg, '<function_category>', 
                                v_function_category);
         raise_application_error(v_error_no, v_error_msg);
       end if;
    end if;

    /* Check authority of server_user to be proxy for creating functions */
    if (v_server_user <> v_for_user) then
       SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user, 
                                          'RUN ROLES SERVICE PROCEDURES', 
                                      'CAT' || trim(v_function_category)) 
          INTO v_server_has_auth
          FROM DUAL;
    else  -- No need to worry about separate server authorization
      v_server_has_auth := 'Y';
    end if;
    if v_server_has_auth <> 'Y' then
      v_error_no := roles_service_constant.err_20003_no;
      v_error_msg := roles_service_constant.err_20003_msg;
      v_error_msg := replace(v_error_msg, '<server_id>', 
                             v_server_user);
      v_error_msg := replace(v_error_msg, '<function_category>', 
                             v_function_category);
      raise_application_error(v_error_no, v_error_msg);
    end if;
  ----
  end if;

 /* Make sure the new function_name is not too long */
  if length(ai_function_name) > v_max_func_name_len then
     raise_application_error(roles_msg2.err_20013_no,
       roles_msg2.err_20013_msg || ' (Length must be <= ' || 
       to_char(v_max_func_name_len) || ' bytes.)');
  else
     v_function_name := upper(ai_function_name);
  end if;

 /* Make sure the new function name does not already exist */
  select count(*) into v_count from function 
      where function_name = v_function_name
      and function_id <> v_function_id;
  if v_count > 0 then 
     v_error_msg := replace(roles_msg2.err_20009_msg, 
                            '<name>', '''' || v_function_name || '''');
     raise_application_error(roles_msg2.err_20009_no, v_error_msg);
  end if;

 /* Make sure the new function_description is not too long */
  if length(ai_function_description) > v_max_func_desc_len then
     raise_application_error(roles_msg2.err_20014_no,
       roles_msg2.err_20014_msg || ' (Length must be <= ' || 
       to_char(v_max_func_desc_len) || ' bytes.)');
  end if;
  v_function_description := ai_function_description;

 /* Make sure the new qualifier_type exists */
  select count(*) into v_count from qualifier_type where qualifier_type = 
      upper(ai_qualifier_type);
  if v_count = 0 then 
     v_error_msg := replace(roles_msg2.err_20017_msg, '<qualifier_type>', 
        '''' || ai_qualifier_type || '''');
     raise_application_error(roles_msg2.err_20017_no, v_error_msg);
  else
     v_qualifier_type := upper(ai_qualifier_type);
  end if;

 /* Make sure the qualifier_type either matches the original qualifier_type
    or there are no existing authorizations for this function */
  select count(*) into v_auth_count from authorization
     where function_id = v_function_id;
  if (v_qualifier_type <> v_old_qualifier_type and v_auth_count > 0) then
     v_error_msg := replace(roles_msg2.err_20029_msg, '<n>', 
                            to_char(v_auth_count));
     raise_application_error(roles_msg2.err_20029_no, v_error_msg);
  end if;

 /* Make sure ai_primary_authorizable is 'Y', 'D',  or 'N' */
  if upper(ai_primary_authorizable) in ('Y', 'D', 'N') then 
    v_primary_authorizable := upper(ai_primary_authorizable);
  else
     v_error_msg := replace(roles_msg2.err_20031_msg, '<pa>', 
        '''' || ai_primary_authorizable || '''');
     raise_application_error(roles_msg2.err_20031_no, v_error_msg);
  end if;

 /* Make sure primary_auth_group is not too long */
  if length(ai_primary_auth_group) > v_max_pa_group_len then
     raise_application_error(roles_msg2.err_20019_no,
       roles_msg2.err_20019_msg || ' (Length must be <= ' || 
       to_char(v_max_pa_group_len) || ' bytes.)');
  else
     v_primary_auth_group := upper(ai_primary_auth_group);
  end if;

 /* Make sure is_primary_auth_parent is Y, N or null. */
  if upper(nvl(ai_is_primary_auth_parent, 'N')) in ('Y', 'N') then 
    v_is_primary_auth_parent := upper(ai_is_primary_auth_parent);
  else
     raise_application_error(roles_msg2.err_20020_no, 
            roles_msg2.err_20020_msg);
  end if;

 /* If IS_PRIMARY_AUTH_PARENT is not 'Y', and primary_auth_group has changed
    Make sure primary_auth_group matches an existing primary_auth_group */
  if (nvl(v_is_primary_auth_parent, 'N') <> 'Y'   
      and v_primary_auth_group is not null
      and v_primary_auth_group <> v_old_primary_auth_group) then
    select count(*) into v_count from function 
     where is_primary_auth_parent = 'Y'
     and primary_auth_group = v_primary_auth_group;
    if v_count = 0 then
       v_error_msg := 
          replace(roles_msg2.err_20023_msg, '<group>', v_primary_auth_group);
       raise_application_error(roles_msg2.err_20023_no, v_error_msg);
    end if;
  end if;

 /* If is_primary_auth_parent is changed, make sure for_user 
    and server_user are authorized
    to maintain primary authorizer functions */
  if (nvl(v_is_primary_auth_parent, 'N') <> nvl(v_old_is_pa_parent, 'N')) then
    if auth_sf_can_maint_pa_func(v_for_user) <> 'Y' then
      v_error_msg := replace(roles_msg2.err_20021_msg, '<user>', 
         '''' || v_for_user || '''');
      raise_application_error(roles_msg2.err_20021_no, v_error_msg);
    elsif auth_sf_can_maint_pa_func(v_server_user) <> 'Y' then
      v_error_msg := replace(roles_msg2.err_20022_msg, '<user>', 
         '''' || v_server_user || '''');
      raise_application_error(roles_msg2.err_20022_no, v_error_msg);
    end if;
  end if;

 /* If new IS_PRIMARY_AUTH_PARENT is 'Y', make sure the category is 'META'
    and qualifier_type is DEPT */
  if (nvl(v_is_primary_auth_parent, 'N') = 'Y' and 
      (v_function_category <> 'META' or v_qualifier_type <> 'DEPT') ) then
     raise_application_error(roles_msg2.err_20024_no, 
            roles_msg2.err_20024_msg);
  end if;

 /* If IS_PRIMARY_AUTH_PARENT is 'Y' or PRIMARY_AUTHORIZABLE is 'Y' or 'D', 
    make sure the PRIMARY_AUTH_GROUP is not null */
  if ( (nvl(v_is_primary_auth_parent,'N') = 'Y' 
        or nvl(v_primary_authorizable, 'N') = 'D'
        or nvl(v_primary_authorizable,'N') = 'Y')
       and v_primary_auth_group is null) then
     raise_application_error(roles_msg2.err_20025_no, 
            roles_msg2.err_20025_msg);
  end if;

 /* If IS_PRIMARY_AUTH_PARENT is 'N' and PRIMARY_AUTHORIZABLE is 'N', 
    make sure the PRIMARY_AUTH_GROUP is also null */
  if ( nvl(v_is_primary_auth_parent,'N') = 'N' 
       and nvl(v_primary_authorizable,'N') = 'N'
       and v_primary_auth_group is not null) then
     raise_application_error(roles_msg2.err_20026_no, 
            roles_msg2.err_20026_msg);
  end if;

 /* Make sure that at least one field will be changed in the Function */
  if (v_old_function_name = v_function_name
      and v_old_function_description = v_function_description
      and v_old_function_category = v_function_category
      and v_old_qualifier_type = v_qualifier_type
      and nvl(v_old_primary_authorizable, 'N') = v_primary_authorizable
      and nvl(v_old_is_pa_parent, 'N') = v_is_primary_auth_parent
      and nvl(v_old_primary_auth_group, 'NONE') = 
          nvl(v_primary_auth_group, 'NONE')) 
  then
     raise_application_error(roles_msg2.err_20030_no, 
            roles_msg2.err_20030_msg);
  end if;

 /* If no errors were found, then 
     (1) update the function 
     (2) if function_category or function_name has changed, then 
         update any authorizations pointing to this function 
 */
  update function set function_name = v_function_name,
                      function_description = v_function_description,
                      function_category = v_function_category,
                      qualifier_type = v_qualifier_type,
                      primary_authorizable = v_primary_authorizable,
                      is_primary_auth_parent = v_is_primary_auth_parent,
                      primary_auth_group = v_primary_auth_group,
                      modified_by = v_for_user,
                      modified_date = sysdate
    where function_id = v_function_id;
  if (v_function_category <> v_old_function_category
      or v_function_name <> v_old_function_name) 
  then
    update authorization set function_name = v_function_name,
                             function_category = v_function_category
      where function_id = v_function_id;
  end if;

end;
/

/****************************************************************************
*  ROLESAPI_UPDATE_EXT_FUNCTION
*  This is a stored procedure for updating external functions in 
*  the table EXTERNAL_FUNCTION.  It may also update a record in 
*  the FUNCTION_LOAD_PASS table.  It
*  checks the authority of the server user (ai_server_user) and
*  the proxy user (ai_for_user) before allowing the function
*  to be updated. 
*
*  If there are no referenced external/implied authorizations 
*  (in external_auth) table and there are no referenced rules, then
*  allow category, function_name, function_description, and/or 
*  qualifier_type to be updated.  Otherwise, allow only function_name
*  and function_description to be updated.  If function_category or
*  function_name are updated, then make corresponding updates in the
*  external_auth table and implied_auth_rule table.
****************************************************************************/
CREATE OR REPLACE PROCEDURE ROLESAPI_UPDATE_EXT_FUNCTION
		(AI_SERVER_USER IN STRING,
                 AI_FOR_USER IN STRING,
                 AI_FUNCTION_ID IN STRING,
                 AI_FUNCTION_NAME IN STRING,
		 AI_FUNCTION_DESCRIPTION IN STRING, 
		 AI_FUNCTION_CATEGORY IN STRING,
		 AI_QUALIFIER_TYPE IN STRING, 
                 AI_FUNCTION_LOAD_PASS IN STRING
		)
IS
V_FOR_USER PERSON.KERBEROS_NAME%TYPE;
V_SERVER_USER PERSON.KERBEROS_NAME%TYPE;
V_QUALIFIER_TYPE QUALIFIER.QUALIFIER_TYPE%TYPE;
V_FUNCTION_ID FUNCTION.FUNCTION_ID%TYPE;
v_temp_function_name varchar2(200);
V_FUNCTION_NAME FUNCTION.FUNCTION_NAME%TYPE;
V_FUNCTION_CATEGORY FUNCTION.FUNCTION_CATEGORY%TYPE;
V_FUNCTION_DESCRIPTION FUNCTION.FUNCTION_DESCRIPTION%TYPE;
V_OLD_QUALIFIER_TYPE QUALIFIER.QUALIFIER_TYPE%TYPE;
V_OLD_FUNCTION_NAME FUNCTION.FUNCTION_NAME%TYPE;
V_OLD_FUNCTION_CATEGORY FUNCTION.FUNCTION_CATEGORY%TYPE;
V_OLD_FUNCTION_DESCRIPTION FUNCTION.FUNCTION_DESCRIPTION%TYPE;
V_OLD_FUNCTION_LOAD_PASS FUNCTION_LOAD_PASS.PASS_NUMBER%TYPE;
v_max_func_name_len integer := 30;
v_max_func_desc_len integer := 50;
v_max_pa_group_len integer := 4;
v_count integer;
v_function_load_pass integer;
v_auth_count integer;
v_rule_count integer;
v_status integer;
v_error_no roles_msg.err_no%TYPE;
v_error_msg roles_msg.err_msg%TYPE;
v_msg_no roles_msg.err_no%TYPE;
v_msg roles_msg.err_msg%TYPE;
v_server_has_auth varchar2(1);
v_proxy_has_auth varchar2(1);

BEGIN
  v_for_user := upper(ai_for_user);
  if (ai_server_user is not null) then
    v_server_user := upper(ai_server_user);
  else
    v_server_user := upper(user);
  end if;

 /* Make sure the function_id exists */
  select count(*) into v_count
    from external_function where to_char(function_id) = ai_function_id;
  if v_count = 0 then
     v_error_msg := replace(roles_msg2.err_20027_msg, '<function_id>', 
                            '''' || ai_function_id || '''');
     raise_application_error(roles_msg2.err_20027_no, v_error_msg);
  else
     v_function_id := to_number(ai_function_id);
     select FUNCTION_NAME, FUNCTION_DESCRIPTION, FUNCTION_CATEGORY, 
            QUALIFIER_TYPE, nvl(PASS_NUMBER, 0)
        into v_old_function_name, v_old_function_description, 
             v_old_function_category,
             v_old_qualifier_type,
             v_old_function_load_pass
     from external_function f, function_load_pass lp
     where f.function_id = v_function_id
     and lp.function_id(+) = f.function_id;
  end if; 

 /* Check authorizations for old function_category */
 /* Make sure both server_user and for_user are authorized to create 
    functions in the given category */
 /* Check authority of Oracle login-user to be proxy for creating functions */
  if (v_server_user <> user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                        'RUN ROLES SERVICE PROCEDURES', 
                                      'CAT' || trim(v_old_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
     if v_server_has_auth <> 'Y' then
       v_error_no := roles_service_constant.err_20003_no;
       v_error_msg := roles_service_constant.err_20003_msg;
       v_error_msg := replace(v_error_msg, '<server_id>', 
                              user);
       v_error_msg := replace(v_error_msg, '<function_category>', 
                              v_old_function_category);
       raise_application_error(v_error_no, v_error_msg);
     end if;
  end if;

  /* Check authority of server_user to be proxy for creating functions */
  if (v_server_user <> v_for_user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user, 
                                        'RUN ROLES SERVICE PROCEDURES', 
                                    'CAT' || trim(v_old_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
  else  -- No need to worry about separate server authorization
    v_server_has_auth := 'Y';
  end if;
  if v_server_has_auth <> 'Y' then
    v_error_no := roles_service_constant.err_20003_no;
    v_error_msg := roles_service_constant.err_20003_msg;
    v_error_msg := replace(v_error_msg, '<server_id>', 
                           v_server_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                           v_old_function_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;

 /* Make sure the new function_category exists */
  select count(*) into v_count from category where function_category = 
      upper(ai_function_category);
  if v_count = 0 then 
     v_error_msg := replace(roles_msg2.err_20015_msg, '<category>', 
        '''' || ai_function_category || '''');
     raise_application_error(roles_msg2.err_20015_no, v_error_msg);
  else
     v_function_category := upper(ai_function_category);
  end if;

 /* If the function_category has changed, then
    make sure new function_category exists.  Also, make sure 
    that both server_user and
    for_user are authorized to update functions in the new category */
  if (v_function_category <> v_old_function_category) then
   v_server_has_auth := 'N';
   /* Check authority of Oracle login-user to be proxy for creating funcs */
    if (v_server_user <> user) then
       SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                          'RUN ROLES SERVICE PROCEDURES', 
                                       'CAT' || trim(v_function_category)) 
          INTO v_server_has_auth
          FROM DUAL;
       if v_server_has_auth <> 'Y' then
         v_error_no := roles_service_constant.err_20003_no;
         v_error_msg := roles_service_constant.err_20003_msg;
         v_error_msg := replace(v_error_msg, '<server_id>', 
                                user);
         v_error_msg := replace(v_error_msg, '<function_category>', 
                                v_function_category);
         raise_application_error(v_error_no, v_error_msg);
       end if;
    end if;

    /* Check authority of server_user to be proxy for creating functions */
    if (v_server_user <> v_for_user) then
       SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user, 
                                          'RUN ROLES SERVICE PROCEDURES', 
                                      'CAT' || trim(v_function_category)) 
          INTO v_server_has_auth
          FROM DUAL;
    else  -- No need to worry about separate server authorization
      v_server_has_auth := 'Y';
    end if;
    if v_server_has_auth <> 'Y' then
      v_error_no := roles_service_constant.err_20003_no;
      v_error_msg := roles_service_constant.err_20003_msg;
      v_error_msg := replace(v_error_msg, '<server_id>', 
                             v_server_user);
      v_error_msg := replace(v_error_msg, '<function_category>', 
                             v_function_category);
      raise_application_error(v_error_no, v_error_msg);
    end if;
  end if;

 /* If the new function_name does not start with '*', add one */
  if (substr(ai_function_name, 1, 1) = '*') then
     v_temp_function_name := ai_function_name;
  else
     v_temp_function_name := '*' || ai_function_name;
  end if;

 /* Make sure the new function_name is not too long */
  if length(v_temp_function_name) > v_max_func_name_len then
     raise_application_error(roles_msg2.err_20013_no,
       roles_msg2.err_20013_msg || ' (Length must be <= ' || 
       to_char(v_max_func_name_len) || ' bytes.)');
  else
     v_function_name := upper(v_temp_function_name);
  end if;

 /* Make sure the new function name does not already exist */
  select count(*) into v_count from external_function 
      where function_name = v_function_name
      and function_id <> v_function_id;
  if v_count > 0 then 
     v_error_msg := replace(roles_msg2.err_20009_msg, 
                            '<name>', '''' || v_function_name || '''');
     raise_application_error(roles_msg2.err_20009_no, v_error_msg);
  end if;

 /* Make sure the new function_description is not too long */
  if length(ai_function_description) > v_max_func_desc_len then
     raise_application_error(roles_msg2.err_20014_no,
       roles_msg2.err_20014_msg || ' (Length must be <= ' || 
       to_char(v_max_func_desc_len) || ' bytes.)');
  end if;
  v_function_description := ai_function_description;

 /* Make sure the new qualifier_type exists */
  select count(*) into v_count from qualifier_type where qualifier_type = 
      upper(ai_qualifier_type);
  if v_count = 0 then 
     v_error_msg := replace(roles_msg2.err_20017_msg, '<qualifier_type>', 
        '''' || ai_qualifier_type || '''');
     raise_application_error(roles_msg2.err_20017_no, v_error_msg);
  else
     v_qualifier_type := upper(ai_qualifier_type);
  end if;

 /* If the new qualifier_type is different than the original qualifier_type,
    then make sure there are no existing authorizations that 
    reference this function */
  select count(*) into v_auth_count from external_auth
     where function_id = v_function_id;
  if (v_qualifier_type <> v_old_qualifier_type and v_auth_count > 0) then
     v_error_msg := replace(roles_msg2.err_20029_msg, '<n>', 
                            to_char(v_auth_count));
     raise_application_error(roles_msg2.err_20029_no, v_error_msg);
  end if;

 /* If the new qualifier_type is different than the original qualifier_type,
    then make sure there are no rules that reference this function */
  select count(*) into v_rule_count 
    from implied_auth_rule r
    where (r.condition_function_category = v_old_function_category
             and r.condition_function_name = substr(v_old_function_name, 2) 
             and r.condition_function_or_group = 'F')
            or (r.result_function_category = v_old_function_category
                and r.result_function_name = substr(v_old_function_name, 2) );
  if (v_qualifier_type <> v_old_qualifier_type and v_rule_count > 0) then
     v_error_msg := replace(roles_msg2.err_20036_msg, '<n>', 
                            to_char(v_rule_count));
     raise_application_error(roles_msg2.err_20036_no, v_error_msg);
  end if;

 /* If the function_category has changed, make sure there are no rules
    or external authorizations that reference this external function */
  if (v_function_category <> v_old_function_category and v_rule_count > 0) then
     v_error_msg := roles_msg2.err_20038_msg;
     raise_application_error(roles_msg2.err_20038_no, v_error_msg);
  end if;

 /* Make sure function_load_pass is a valid number */
  if ai_function_load_pass in ('0', '1', '2', '3', '4') then
     v_function_load_pass := to_number(ai_function_load_pass);
  else
     v_error_msg := replace(roles_msg2.err_20052_msg, '<load_pass>', 
        '''' || ai_function_load_pass || '''');
     raise_application_error(roles_msg2.err_20052_no, v_error_msg);
  end if;

 /* Make sure that at least one field will be changed in the Ext Function */
  if (v_old_function_name = v_function_name
      and v_old_function_description = v_function_description
      and v_old_function_category = v_function_category
      and v_old_qualifier_type = v_qualifier_type
      and v_old_function_load_pass = v_function_load_pass) 
  then
     raise_application_error(roles_msg2.err_20030_no, 
            roles_msg2.err_20030_msg);
  end if;

 /* If no errors were found, then 
     (1) update the function 
     (2) if function_category or function_name has changed, then 
         update any authorizations pointing to this function 
     (3) if the function_category or function_name has changed, then
         update any referenced rules in implied_auth_rule table.
 */
  update external_function set function_name = v_function_name,
                      function_description = v_function_description,
                      function_category = v_function_category,
                      qualifier_type = v_qualifier_type,
                      modified_by = v_for_user,
                      modified_date = sysdate
    where function_id = v_function_id;
  update function_load_pass set pass_number = v_function_load_pass
    where function_id = v_function_id;
  if (v_function_category <> v_old_function_category
      or v_function_name <> v_old_function_name) 
  then
    update external_auth set function_name = v_function_name,
                             function_category = v_function_category
      where function_id = v_function_id;
    update implied_auth_rule 
        set condition_function_name = substr(v_function_name, 2),
            condition_function_category = v_function_category
        where condition_function_name = substr(v_old_function_name, 2)
        and condition_function_category = v_old_function_category
        and condition_function_or_group = 'F';
    update implied_auth_rule 
        set result_function_name = substr(v_function_name, 2),
            result_function_category = v_function_category
        where result_function_name = substr(v_old_function_name, 2)
        and result_function_category = v_old_function_category;
           
  end if;

end;
/

/****************************************************************************
*  ROLESAPI_DELETE_FUNCTION2
*  This is a stored procedure for deleting functions that 
*  checks the authority of the server user (ai_server_user) and
*  the proxy user (ai_for_user) before allowing the function
*  to be deleted. 
*
****************************************************************************/
CREATE OR REPLACE PROCEDURE ROLESAPI_DELETE_FUNCTION2
		(AI_SERVER_USER IN STRING,
                 AI_FOR_USER IN STRING,
                 AI_FUNCTION_ID IN STRING
		)
IS
V_FOR_USER PERSON.KERBEROS_NAME%TYPE;
V_SERVER_USER PERSON.KERBEROS_NAME%TYPE;
V_QUALIFIER_TYPE QUALIFIER.QUALIFIER_TYPE%TYPE;
V_FUNCTION_ID FUNCTION.FUNCTION_ID%TYPE;
V_FUNCTION_NAME FUNCTION.FUNCTION_NAME%TYPE;
V_FUNCTION_CATEGORY FUNCTION.FUNCTION_CATEGORY%TYPE;
V_IS_PRIMARY_AUTH_PARENT FUNCTION.IS_PRIMARY_AUTH_PARENT%TYPE;
v_count integer;

v_status integer;
v_error_no roles_msg.err_no%TYPE;
v_error_msg roles_msg.err_msg%TYPE;
v_msg_no roles_msg.err_no%TYPE;
v_msg roles_msg.err_msg%TYPE;
v_server_has_auth varchar2(1);
v_proxy_has_auth varchar2(1);

BEGIN
  v_for_user := upper(ai_for_user);
  if (ai_server_user is not null) then
    v_server_user := upper(ai_server_user);
  else
    v_server_user := upper(user);
  end if;

 /* Make sure the function_id exists */
  select count(*) into v_count
    from function where to_char(function_id) = ai_function_id;
  if v_count = 0 then
     v_error_msg := replace(roles_msg2.err_20027_msg, '<function_id>', 
                            '''' || ai_function_id || '''');
     raise_application_error(roles_msg2.err_20027_no, v_error_msg);
  else
     v_function_id := to_number(ai_function_id);
     select FUNCTION_NAME, FUNCTION_CATEGORY, 
            QUALIFIER_TYPE, IS_PRIMARY_AUTH_PARENT
        into v_function_name, v_function_category,
             v_qualifier_type, v_is_primary_auth_parent
     from function where function_id = v_function_id;
  end if; 

 /* Make sure both server_user and for_user are authorized to maintain
    functions in the given category */
 /* Check authority of Oracle login-user to be proxy for creating functions */
  if (v_server_user <> user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
     if v_server_has_auth <> 'Y' then
       v_error_no := roles_service_constant.err_20003_no;
       v_error_msg := roles_service_constant.err_20003_msg;
       v_error_msg := replace(v_error_msg, '<server_id>', 
                              user);
       v_error_msg := replace(v_error_msg, '<function_category>', 
                              v_function_category);
       raise_application_error(v_error_no, v_error_msg);
     end if;
  end if;

  /* Check authority of server_user to be proxy for creating functions */
  if (v_server_user <> v_for_user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user, 
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
  else  -- No need to worry about separate server authorization
    v_server_has_auth := 'Y';
  end if;
  if v_server_has_auth <> 'Y' then
    v_error_no := roles_service_constant.err_20003_no;
    v_error_msg := roles_service_constant.err_20003_msg;
    v_error_msg := replace(v_error_msg, '<server_id>', 
                           v_server_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                           v_function_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;

  /* Check for_user authority to delete function */
  if auth_sf_can_create_function(v_for_user, V_FUNCTION_CATEGORY) = 'N' then
     v_error_msg := replace(roles_msg2.err_20016_msg, '<category>', 
        '''' || v_function_category || '''');
     v_error_msg := replace(v_error_msg, '<user>', '''' || v_for_user || '''');
     raise_application_error(roles_msg2.err_20016_no, v_error_msg);
  end if;

 /* Make sure there are no existing authorizations for this function */
  select count(*) into v_count from authorization
     where function_id = v_function_id;
  if v_count > 0 then
     v_error_msg := replace(roles_msg2.err_20028_msg, '<n>', 
                            to_char(v_count));
     raise_application_error(roles_msg2.err_20028_no, v_error_msg);
  end if;

 /* Make sure that either the for_user is authorized to maintain 
    primary authorizer functions or IS_PRIMARY_AUTH_PARENT is  N or null. */ 
  if (nvl(v_is_primary_auth_parent, 'N') = 'Y') then
    if auth_sf_can_maint_pa_func(v_for_user) <> 'Y' then
      v_error_msg := replace(roles_msg2.err_20021_msg, '<user>', 
         '''' || v_for_user || '''');
      raise_application_error(roles_msg2.err_20021_no, v_error_msg);
    elsif auth_sf_can_maint_pa_func(v_server_user) <> 'Y' then
      v_error_msg := replace(roles_msg2.err_20022_msg, '<user>', 
         '''' || v_server_user || '''');
      raise_application_error(roles_msg2.err_20022_no, v_error_msg);
    end if;
  end if;

 /* If no errors were found, then 
    (1) delete any related records from the function_child table and
    (2) delete the record from the Function table */
  delete from function_child where parent_id = v_function_id;
  delete from function_child where child_id = v_function_id;
  delete from function where function_id = v_function_id;

end;
/

/****************************************************************************
*  ROLESAPI_DELETE_FUNC_GROUP
*  This is a stored procedure for deleting function groups.  It
*  checks the authority of the server user (ai_server_user) and
*  the proxy user (ai_for_user) before allowing the function group
*  to be deleted.  It also verifies that there are no rules that 
*  reference the function group to be deleted.
*
****************************************************************************/
CREATE OR REPLACE PROCEDURE ROLESAPI_DELETE_FUNC_GROUP
		(AI_SERVER_USER IN STRING,
                 AI_FOR_USER IN STRING,
                 AI_FUNCTION_GROUP_ID IN STRING
		)
IS
V_FOR_USER PERSON.KERBEROS_NAME%TYPE;
V_SERVER_USER PERSON.KERBEROS_NAME%TYPE;
V_GROUP_ID FUNCTION.FUNCTION_ID%TYPE;
V_GROUP_NAME FUNCTION.FUNCTION_NAME%TYPE;
V_FUNCTION_CATEGORY FUNCTION.FUNCTION_CATEGORY%TYPE;
v_count integer;

v_status integer;
v_error_no roles_msg.err_no%TYPE;
v_error_msg roles_msg.err_msg%TYPE;
v_msg_no roles_msg.err_no%TYPE;
v_msg roles_msg.err_msg%TYPE;
v_server_has_auth varchar2(1);
v_proxy_has_auth varchar2(1);

BEGIN
  v_for_user := upper(ai_for_user);
  if (ai_server_user is not null) then
    v_server_user := upper(ai_server_user);
  else
    v_server_user := upper(user);
  end if;

 /* Make sure the function_group_id exists */
  select count(*) into v_count
    from function_group where to_char(function_group_id)=ai_function_group_id;
  if v_count = 0 then
     v_error_msg := replace(roles_msg2.err_20045_msg, '<group_id>', 
                            '''' || ai_function_group_id || '''');
     raise_application_error(roles_msg2.err_20045_no, v_error_msg);
  else
     v_group_id := to_number(ai_function_group_id);
     select FUNCTION_GROUP_NAME, FUNCTION_CATEGORY
        into v_group_name, v_function_category
     from function_group where function_group_id = v_group_id;
  end if; 

 /* Make sure both server_user and for_user are authorized to maintain
    function groups in the given category */
 /* Check authority of Oracle login-user to be proxy for creating functions */
  if (v_server_user <> user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
     if v_server_has_auth <> 'Y' then
       v_error_no := roles_service_constant.err_20003_no;
       v_error_msg := roles_service_constant.err_20003_msg;
       v_error_msg := replace(v_error_msg, '<server_id>', 
                              user);
       v_error_msg := replace(v_error_msg, '<function_category>', 
                              v_function_category);
       raise_application_error(v_error_no, v_error_msg);
     end if;
  end if;

  /* Check authority of server_user to be proxy for creating functions */
  if (v_server_user <> v_for_user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user, 
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
  else  -- No need to worry about separate server authorization
    v_server_has_auth := 'Y';
  end if;
  if v_server_has_auth <> 'Y' then
    v_error_no := roles_service_constant.err_20003_no;
    v_error_msg := roles_service_constant.err_20003_msg;
    v_error_msg := replace(v_error_msg, '<server_id>', 
                           v_server_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                           v_function_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;

  /* Check for_user authority to delete function group */
  SELECT ROLESAPI_IS_USER_AUTHORIZED(v_for_user,
                                     'CREATE IMPLIED AUTH RULES', 
                                        'CAT' || trim(v_function_category)) 
        INTO v_proxy_has_auth
        FROM DUAL;

  if v_proxy_has_auth = 'N' then
     v_error_msg := replace(roles_msg2.err_20043_msg, '<category>', 
        '''' || v_function_category || '''');
     v_error_msg := replace(v_error_msg, '<user>', '''' || v_for_user || '''');
     raise_application_error(roles_msg2.err_20043_no, v_error_msg);
  end if;

 /* Make sure there are no rules referencing this function */
  select count(r.rule_id) into v_count
    from implied_auth_rule r
    where r.condition_function_category = v_function_category
             and r.condition_function_name = v_group_name
             and r.condition_function_or_group = 'G';
  if v_count > 0 then
     v_error_msg := replace(roles_msg2.err_20036_msg, '<n>', 
                            to_char(v_count));
     raise_application_error(roles_msg2.err_20036_no, v_error_msg);
  end if;

 /* If no errors were found, then 
    (1) delete any related records from the function_group_link table and
    (2) delete the record from the Function Group table */
  delete from function_group_link where parent_id = v_group_id;
  delete from function_group where function_group_id = v_group_id;

end;
/

/****************************************************************************
*  ROLESAPI_DELETE_EXT_FUNCTION
*  This is a stored procedure for deleting functions from the 
*  EXTERNAL_FUNCTION table.  It 
*  checks the authority of the server user (ai_server_user) and
*  the proxy user (ai_for_user) before allowing the function
*  to be deleted. 
*
****************************************************************************/
CREATE OR REPLACE PROCEDURE ROLESAPI_DELETE_EXT_FUNCTION
		(AI_SERVER_USER IN STRING,
                 AI_FOR_USER IN STRING,
                 AI_FUNCTION_ID IN STRING
		)
IS
V_FOR_USER PERSON.KERBEROS_NAME%TYPE;
V_SERVER_USER PERSON.KERBEROS_NAME%TYPE;
V_QUALIFIER_TYPE QUALIFIER.QUALIFIER_TYPE%TYPE;
V_FUNCTION_ID FUNCTION.FUNCTION_ID%TYPE;
V_FUNCTION_NAME FUNCTION.FUNCTION_NAME%TYPE;
V_FUNCTION_CATEGORY FUNCTION.FUNCTION_CATEGORY%TYPE;
v_count integer;

v_status integer;
v_error_no roles_msg.err_no%TYPE;
v_error_msg roles_msg.err_msg%TYPE;
v_msg_no roles_msg.err_no%TYPE;
v_msg roles_msg.err_msg%TYPE;
v_server_has_auth varchar2(1);
v_proxy_has_auth varchar2(1);

BEGIN
  v_for_user := upper(ai_for_user);
  if (ai_server_user is not null) then
    v_server_user := upper(ai_server_user);
  else
    v_server_user := upper(user);
  end if;

 /* Make sure the function_id exists */
  select count(*) into v_count
    from external_function where to_char(function_id) = ai_function_id;
  if v_count = 0 then
     v_error_msg := replace(roles_msg2.err_20027_msg, '<function_id>', 
                            '''' || ai_function_id || '''');
     raise_application_error(roles_msg2.err_20027_no, v_error_msg);
  else
     v_function_id := to_number(ai_function_id);
     select FUNCTION_NAME, FUNCTION_CATEGORY, 
            QUALIFIER_TYPE
        into v_function_name, v_function_category,
             v_qualifier_type
     from external_function where function_id = v_function_id;
  end if; 

 /* Make sure both server_user and for_user are authorized to maintain
    functions in the given category */
 /* Check authority of Oracle login-user to be proxy for creating functions */
  if (v_server_user <> user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
     if v_server_has_auth <> 'Y' then
       v_error_no := roles_service_constant.err_20003_no;
       v_error_msg := roles_service_constant.err_20003_msg;
       v_error_msg := replace(v_error_msg, '<server_id>', 
                              user);
       v_error_msg := replace(v_error_msg, '<function_category>', 
                              v_function_category);
       raise_application_error(v_error_no, v_error_msg);
     end if;
  end if;

  /* Check authority of server_user to be proxy for creating functions */
  if (v_server_user <> v_for_user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user, 
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_function_category)) 
        INTO v_server_has_auth
        FROM DUAL;
  else  -- No need to worry about separate server authorization
    v_server_has_auth := 'Y';
  end if;
  if v_server_has_auth <> 'Y' then
    v_error_no := roles_service_constant.err_20003_no;
    v_error_msg := roles_service_constant.err_20003_msg;
    v_error_msg := replace(v_error_msg, '<server_id>', 
                           v_server_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                           v_function_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;

  /* Check for_user authority to delete function */
  if auth_sf_can_create_function(v_for_user, V_FUNCTION_CATEGORY) = 'N' then
     v_error_msg := replace(roles_msg2.err_20016_msg, '<category>', 
        '''' || v_function_category || '''');
     v_error_msg := replace(v_error_msg, '<user>', '''' || v_for_user || '''');
     raise_application_error(roles_msg2.err_20016_no, v_error_msg);
  end if;

 /* Make sure there are no existing authorizations for this function */
  select count(*) into v_count from external_auth
     where function_id = v_function_id;
  if v_count > 0 then
     v_error_msg := replace(roles_msg2.err_20028_msg, '<n>', 
                            to_char(v_count));
     raise_application_error(roles_msg2.err_20028_no, v_error_msg);
  end if;

 /* Make sure this function is not referenced by any implied 
    authorization rules */

 /* Make sure there are no rules that reference this external function */
  select count(distinct r.rule_id) into v_count
  from external_function f, implied_auth_rule r
  where f.function_id = v_function_id
  and ( (f.function_category = r.condition_function_category
           and f.function_name = '*' || r.condition_function_name
           and r.condition_function_or_group = 'F')
          or (f.function_category = r.result_function_category        
              and f.function_name = '*' || r.result_function_name) );
  if v_count > 0 then
     v_error_msg := replace(roles_msg2.err_20036_msg, '<n>', 
                            to_char(v_count));
     raise_application_error(roles_msg2.err_20036_no, v_error_msg);
  end if;


 /* If no errors were found, then 
    (1) delete any related records from the function_group_link table and
    (2) delete the record from the Function table */
  delete from function_group_link where child_id = v_function_id;
  delete from function_load_pass where function_id = v_function_id;
  --delete from function_child where child_id = v_function_id;
  delete from external_function where function_id = v_function_id;

end;
/

/****************************************************************************
*  ROLESAPI_DELETE_FUNCTION_CHILD
*  This is a stored procedure for deleting a function parent/child
*  link in the function_child table.  
*  It checks the authority of the server user (ai_server_user) and
*  the proxy user (ai_for_user) before allowing the function
*  parent/child pair to be deleted. 
*
****************************************************************************/
CREATE OR REPLACE PROCEDURE ROLESAPI_DELETE_FUNCTION_CHILD
		(AI_SERVER_USER IN STRING,
                 AI_FOR_USER IN STRING,
                 AI_PARENT_ID IN STRING,
                 AI_CHILD_ID IN STRING
		)
IS
V_FOR_USER PERSON.KERBEROS_NAME%TYPE;
V_SERVER_USER PERSON.KERBEROS_NAME%TYPE;
V_PARENT_ID FUNCTION.FUNCTION_ID%TYPE;
V_CHILD_ID FUNCTION.FUNCTION_ID%TYPE;
V_PARENT_FUNCTION_NAME FUNCTION.FUNCTION_NAME%TYPE;
V_CHILD_FUNCTION_NAME FUNCTION.FUNCTION_NAME%TYPE;
V_PARENT_CATEGORY FUNCTION.FUNCTION_CATEGORY%TYPE;
V_CHILD_CATEGORY FUNCTION.FUNCTION_CATEGORY%TYPE;
v_count integer;

v_status integer;
v_error_no roles_msg.err_no%TYPE;
v_error_msg roles_msg.err_msg%TYPE;
v_msg_no roles_msg.err_no%TYPE;
v_msg roles_msg.err_msg%TYPE;
v_server_has_authp varchar2(1);
v_server_has_authc varchar2(1);
v_proxy_has_auth varchar2(1);

BEGIN
  v_for_user := upper(ai_for_user);
  if (ai_server_user is not null) then
    v_server_user := upper(ai_server_user);
  else
    v_server_user := upper(user);
  end if;

 /* Make sure the parent/child pair exists */
  select count(*) into v_count
    from function_child where to_char(parent_id) = ai_parent_id
    and to_char(child_id) = ai_child_id;
  if v_count = 0 then
     v_error_msg := replace(roles_msg2.err_20032_msg, '<parent_id>', 
                            '''' || ai_parent_id || '''');
     v_error_msg := replace(v_error_msg, '<child_id>', 
                            '''' || ai_child_id || '''');
     raise_application_error(roles_msg2.err_20032_no, v_error_msg);
  else
     v_parent_id := to_number(ai_parent_id);
     v_child_id := to_number(ai_child_id);
     select FUNCTION_NAME, FUNCTION_CATEGORY
        into v_parent_function_name, v_parent_category
     from function where function_id = v_parent_id;
     select FUNCTION_NAME, FUNCTION_CATEGORY
        into v_child_function_name, v_child_category
     from function where function_id = v_child_id;
  end if; 

 /* Make sure both server_user and for_user are authorized to maintain
    functions in the given category */
 /* Check authority of Oracle login-user to be proxy for creating functions */
  if (v_server_user <> user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_parent_category)) 
        INTO v_server_has_authp
        FROM DUAL;
     if v_server_has_authp <> 'Y' then
       v_error_no := roles_service_constant.err_20003_no;
       v_error_msg := roles_service_constant.err_20003_msg;
       v_error_msg := replace(v_error_msg, '<server_id>', 
                              user);
       v_error_msg := replace(v_error_msg, '<function_category>', 
                              v_parent_category);
       raise_application_error(v_error_no, v_error_msg);
     end if;
  end if;
  if (v_parent_category <> v_child_category) then
    if (v_server_user <> user) then
       SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                          'RUN ROLES SERVICE PROCEDURES', 
                                          'CAT' || trim(v_child_category)) 
          INTO v_server_has_authp
          FROM DUAL;
       if v_server_has_authp <> 'Y' then
         v_error_no := roles_service_constant.err_20003_no;
         v_error_msg := roles_service_constant.err_20003_msg;
         v_error_msg := replace(v_error_msg, '<server_id>', 
                                user);
         v_error_msg := replace(v_error_msg, '<function_category>', 
                                v_child_category);
         raise_application_error(v_error_no, v_error_msg);
       end if;
    end if;
  end if;


  /* Check authority of server_user to be proxy for creating functions */
  if (v_server_user <> v_for_user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user, 
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_parent_category)) 
        INTO v_server_has_authp
        FROM DUAL;
  else  -- No need to worry about separate server authorization
    v_server_has_authp := 'Y';
  end if;
  if v_server_has_authp <> 'Y' then
    v_error_no := roles_service_constant.err_20003_no;
    v_error_msg := roles_service_constant.err_20003_msg;
    v_error_msg := replace(v_error_msg, '<server_id>', 
                           v_server_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                           v_parent_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;
  if (v_parent_category <> v_child_category) then
    if (v_server_user <> v_for_user) then
       SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user, 
                                          'RUN ROLES SERVICE PROCEDURES', 
                                          'CAT' || trim(v_child_category)) 
          INTO v_server_has_authc
          FROM DUAL;
    else  -- No need to worry about separate server authorization
      v_server_has_authc := 'Y';
    end if;
    if v_server_has_authc <> 'Y' then
      v_error_no := roles_service_constant.err_20003_no;
      v_error_msg := roles_service_constant.err_20003_msg;
      v_error_msg := replace(v_error_msg, '<server_id>', 
                             v_server_user);
      v_error_msg := replace(v_error_msg, '<function_category>', 
                             v_child_category);
      raise_application_error(v_error_no, v_error_msg);
    end if;
  end if;

  /* Check for_user authority to update function */
  if auth_sf_can_create_function(v_for_user, V_PARENT_CATEGORY) = 'N' then
     v_error_msg := replace(roles_msg2.err_20016_msg, '<category>', 
        '''' || v_parent_category || '''');
     v_error_msg := replace(v_error_msg, '<user>', '''' || v_for_user || '''');
     raise_application_error(roles_msg2.err_20016_no, v_error_msg);
  end if;
  if (v_parent_category <> v_child_category) then
    if auth_sf_can_create_function(v_for_user, V_CHILD_CATEGORY) = 'N' then
       v_error_msg := replace(roles_msg2.err_20016_msg, '<category>', 
          '''' || v_child_category || '''');
       v_error_msg := replace(v_error_msg, '<user>', '''' 
                              || v_for_user || '''');
       raise_application_error(roles_msg2.err_20016_no, v_error_msg);
    end if;
  end if;

 /* If no errors were found, then 
    delete the record from the parent/child table */
  delete from function_child 
         where parent_id = v_parent_id
         and child_id = v_child_id;

end;
/

/****************************************************************************
*  ROLESAPI_ADD_FUNCTION_CHILD
*  This is a stored procedure for adding a function parent/child
*  link to the function_child table.  
*  It checks the authority of the server user (ai_server_user) and
*  the proxy user (ai_for_user) before allowing the function
*  parent/child pair to be added. 
*
****************************************************************************/
CREATE OR REPLACE PROCEDURE ROLESAPI_ADD_FUNCTION_CHILD
		(AI_SERVER_USER IN STRING,
                 AI_FOR_USER IN STRING,
                 AI_PARENT_ID IN STRING,
                 AI_CHILD_ID IN STRING
		)
IS
V_FOR_USER PERSON.KERBEROS_NAME%TYPE;
V_SERVER_USER PERSON.KERBEROS_NAME%TYPE;
V_PARENT_QUALTYPE QUALIFIER.QUALIFIER_TYPE%TYPE;
V_CHILD_QUALTYPE QUALIFIER.QUALIFIER_TYPE%TYPE;
V_PARENT_ID FUNCTION.FUNCTION_ID%TYPE;
V_CHILD_ID FUNCTION.FUNCTION_ID%TYPE;
V_PARENT_FUNCTION_NAME FUNCTION.FUNCTION_NAME%TYPE;
V_CHILD_FUNCTION_NAME FUNCTION.FUNCTION_NAME%TYPE;
V_PARENT_CATEGORY FUNCTION.FUNCTION_CATEGORY%TYPE;
V_CHILD_CATEGORY FUNCTION.FUNCTION_CATEGORY%TYPE;
v_count integer;

v_status integer;
v_error_no roles_msg.err_no%TYPE;
v_error_msg roles_msg.err_msg%TYPE;
v_msg_no roles_msg.err_no%TYPE;
v_msg roles_msg.err_msg%TYPE;
v_server_has_authp varchar2(1);
v_server_has_authc varchar2(1);
v_proxy_has_auth varchar2(1);

BEGIN
  v_for_user := upper(ai_for_user);
  if (ai_server_user is not null) then
    v_server_user := upper(ai_server_user);
  else
    v_server_user := upper(user);
  end if;

 /* Make sure the parent_function_id exists */
  select count(*) into v_count
    from function where to_char(function_id) = ai_parent_id;
  if v_count = 0 then
     v_error_msg := replace(roles_msg2.err_20027_msg, '<function_id>', 
                            '''' || ai_parent_id || '''');
     raise_application_error(roles_msg2.err_20027_no, v_error_msg);
  else
     v_parent_id := to_number(ai_parent_id);
     select FUNCTION_NAME, FUNCTION_CATEGORY, 
            QUALIFIER_TYPE
        into v_parent_function_name, v_parent_category,
             v_parent_qualtype
     from function where function_id = v_parent_id;
  end if; 

 /* Make sure the child_function_id exists */
  select count(*) into v_count
    from function where to_char(function_id) = ai_child_id;
  if v_count = 0 then
     v_error_msg := replace(roles_msg2.err_20027_msg, '<function_id>', 
                            '''' || ai_child_id || '''');
     raise_application_error(roles_msg2.err_20027_no, v_error_msg);
  else
     v_child_id := to_number(ai_child_id);
     select FUNCTION_NAME, FUNCTION_CATEGORY, 
            QUALIFIER_TYPE
        into v_child_function_name, v_child_category,
             v_child_qualtype
     from function where function_id = v_child_id;
  end if; 

 /* Make sure the parent/child pair does not already exist */
  select count(*) into v_count
    from function_child where to_char(parent_id) = ai_parent_id
    and to_char(child_id) = ai_child_id;
  if v_count > 0 then
     v_error_msg := replace(roles_msg2.err_20033_msg, '<parent_id>', 
                            '''' || ai_parent_id || '''');
     v_error_msg := replace(v_error_msg, '<child_id>', 
                            '''' || ai_child_id || '''');
     raise_application_error(roles_msg2.err_20033_no, v_error_msg);
  end if; 

 /* Make sure both server_user and for_user are authorized to maintain
    functions in the given category */
 /* Check authority of Oracle login-user to be proxy for creating functions */
  if (v_server_user <> user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_parent_category)) 
        INTO v_server_has_authp
        FROM DUAL;
     if v_server_has_authp <> 'Y' then
       v_error_no := roles_service_constant.err_20003_no;
       v_error_msg := roles_service_constant.err_20003_msg;
       v_error_msg := replace(v_error_msg, '<server_id>', 
                              user);
       v_error_msg := replace(v_error_msg, '<function_category>', 
                              v_parent_category);
       raise_application_error(v_error_no, v_error_msg);
     end if;
  end if;
  if (v_parent_category <> v_child_category) then
    if (v_server_user <> user) then
       SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                          'RUN ROLES SERVICE PROCEDURES', 
                                          'CAT' || trim(v_child_category)) 
          INTO v_server_has_authp
          FROM DUAL;
       if v_server_has_authp <> 'Y' then
         v_error_no := roles_service_constant.err_20003_no;
         v_error_msg := roles_service_constant.err_20003_msg;
         v_error_msg := replace(v_error_msg, '<server_id>', 
                                user);
         v_error_msg := replace(v_error_msg, '<function_category>', 
                                v_child_category);
         raise_application_error(v_error_no, v_error_msg);
       end if;
    end if;
  end if;

  /* Check authority of server_user to be proxy for creating functions */
  if (v_server_user <> v_for_user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user, 
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_parent_category)) 
        INTO v_server_has_authp
        FROM DUAL;
  else  -- No need to worry about separate server authorization
    v_server_has_authp := 'Y';
  end if;
  if v_server_has_authp <> 'Y' then
    v_error_no := roles_service_constant.err_20003_no;
    v_error_msg := roles_service_constant.err_20003_msg;
    v_error_msg := replace(v_error_msg, '<server_id>', 
                           v_server_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                           v_parent_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;
  if (v_parent_category <> v_child_category) then
    if (v_server_user <> v_for_user) then
       SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user, 
                                          'RUN ROLES SERVICE PROCEDURES', 
                                          'CAT' || trim(v_child_category)) 
          INTO v_server_has_authc
          FROM DUAL;
    else  -- No need to worry about separate server authorization
      v_server_has_authc := 'Y';
    end if;
    if v_server_has_authc <> 'Y' then
      v_error_no := roles_service_constant.err_20003_no;
      v_error_msg := roles_service_constant.err_20003_msg;
      v_error_msg := replace(v_error_msg, '<server_id>', 
                             v_server_user);
      v_error_msg := replace(v_error_msg, '<function_category>', 
                             v_child_category);
      raise_application_error(v_error_no, v_error_msg);
    end if;
  end if;

  /* Check for_user authority to update function */
  if auth_sf_can_create_function(v_for_user, V_PARENT_CATEGORY) = 'N' then
     v_error_msg := replace(roles_msg2.err_20016_msg, '<category>', 
        '''' || v_parent_category || '''');
     v_error_msg := replace(v_error_msg, '<user>', '''' || v_for_user || '''');
     raise_application_error(roles_msg2.err_20016_no, v_error_msg);
  end if;
  if (v_parent_category <> v_child_category) then
    if auth_sf_can_create_function(v_for_user, V_CHILD_CATEGORY) = 'N' then
       v_error_msg := replace(roles_msg2.err_20016_msg, '<category>', 
          '''' || v_child_category || '''');
       v_error_msg := replace(v_error_msg, '<user>', '''' 
                              || v_for_user || '''');
       raise_application_error(roles_msg2.err_20016_no, v_error_msg);
    end if;
  end if;

 /* Make sure the parent and child functions have the same qualifier_type
    Also allow different qualifier_types if pair is in table 
    related_qualifier_type  */
  if (v_parent_qualtype <> v_child_qualtype) then
     select count(*) into v_count 
        from related_qualifier_type
        where parent_qualifier_type = v_parent_qualtype
        and child_qualifier_type = v_child_qualtype;
     if (v_count = 0) then
       v_error_msg := replace(roles_msg2.err_20034_msg, '<parent_id>', 
                              '''' || ai_parent_id || '''');
       v_error_msg := replace(v_error_msg, '<child_id>', 
                              '''' || ai_child_id || '''');
       raise_application_error(roles_msg2.err_20034_no, v_error_msg);
     end if;
  end if; 

 /* Make sure the parent and child functions are not the same */
  if (v_parent_id = v_child_id) then
     raise_application_error(roles_msg2.err_20035_no, 
                             roles_msg2.err_20035_msg);
  end if; 

 /* If no errors were found, then 
    insert the record into the parent/child table */
  insert into function_child (parent_id, child_id)
         values (v_parent_id, v_child_id);

end;
/

/****************************************************************************
*  ROLESAPI_ADD_FUNC_GROUP_LINK
*  This is a stored procedure for adding a link between a function group
*  and a function.
*  It checks the authority of the server user (ai_server_user) and
*  the proxy user (ai_for_user) before allowing the link
*  to be added. 
*
****************************************************************************/
CREATE OR REPLACE PROCEDURE ROLESAPI_ADD_FUNC_GROUP_LINK
		(AI_SERVER_USER IN STRING,
                 AI_FOR_USER IN STRING,
                 AI_PARENT_ID IN STRING,
                 AI_CHILD_ID IN STRING
		)
IS
V_FOR_USER PERSON.KERBEROS_NAME%TYPE;
V_SERVER_USER PERSON.KERBEROS_NAME%TYPE;
V_PARENT_QUALTYPE QUALIFIER.QUALIFIER_TYPE%TYPE;
V_CHILD_QUALTYPE QUALIFIER.QUALIFIER_TYPE%TYPE;
V_PARENT_ID FUNCTION.FUNCTION_ID%TYPE;
V_CHILD_ID FUNCTION.FUNCTION_ID%TYPE;
V_PARENT_GROUP_NAME FUNCTION.FUNCTION_NAME%TYPE;
V_CHILD_FUNCTION_NAME FUNCTION.FUNCTION_NAME%TYPE;
V_PARENT_CATEGORY FUNCTION.FUNCTION_CATEGORY%TYPE;
V_CHILD_CATEGORY FUNCTION.FUNCTION_CATEGORY%TYPE;
v_count integer;

v_status integer;
v_error_no roles_msg.err_no%TYPE;
v_error_msg roles_msg.err_msg%TYPE;
v_msg_no roles_msg.err_no%TYPE;
v_msg roles_msg.err_msg%TYPE;
v_server_has_authp varchar2(1);
v_server_has_authc varchar2(1);
v_proxy_has_auth varchar2(1);

BEGIN
  v_for_user := upper(ai_for_user);
  if (ai_server_user is not null) then
    v_server_user := upper(ai_server_user);
  else
    v_server_user := upper(user);
  end if;

 /* Make sure the parent function_group_id exists */
  select count(*) into v_count
    from function_group where to_char(function_group_id) = ai_parent_id;
  if v_count = 0 then
     v_error_msg := replace(roles_msg2.err_20045_msg, '<group_id>', 
                            '''' || ai_parent_id || '''');
     raise_application_error(roles_msg2.err_20045_no, v_error_msg);
  else
     v_parent_id := to_number(ai_parent_id);
     select FUNCTION_GROUP_NAME, FUNCTION_CATEGORY, 
            QUALIFIER_TYPE
        into v_parent_group_name, v_parent_category,
             v_parent_qualtype
     from function_group where function_group_id = v_parent_id;
  end if; 

 /* Make sure the child_function_id exists */
  select count(*) into v_count
    from function2 where to_char(function_id) = ai_child_id;
  if v_count = 0 then
     v_error_msg := replace(roles_msg2.err_20048_msg, '<function_id>', 
                            '''' || ai_child_id || '''');
     raise_application_error(roles_msg2.err_20048_no, v_error_msg);
  else
     v_child_id := to_number(ai_child_id);
     select FUNCTION_NAME, FUNCTION_CATEGORY, 
            QUALIFIER_TYPE
        into v_child_function_name, v_child_category,
             v_child_qualtype
     from function2 where function_id = v_child_id;
  end if; 

 /* Make sure the function_group/function pair does not already exist */
  select count(*) into v_count
    from function_group_link where to_char(parent_id) = ai_parent_id
    and to_char(child_id) = ai_child_id;
  if v_count > 0 then
     v_error_msg := replace(roles_msg2.err_20049_msg, '<parent_id>', 
                            '''' || ai_parent_id || '''');
     v_error_msg := replace(v_error_msg, '<child_id>', 
                            '''' || ai_child_id || '''');
     raise_application_error(roles_msg2.err_20049_no, v_error_msg);
  end if; 

 /* Make sure both server_user and for_user are authorized to maintain
    functions in the given category */
 /* Check authority of Oracle login-user to be proxy for Roles procedures */
  if (v_server_user <> user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_parent_category)) 
        INTO v_server_has_authp
        FROM DUAL;
     if v_server_has_authp <> 'Y' then
       v_error_no := roles_service_constant.err_20003_no;
       v_error_msg := roles_service_constant.err_20003_msg;
       v_error_msg := replace(v_error_msg, '<server_id>', 
                              user);
       v_error_msg := replace(v_error_msg, '<function_category>', 
                              v_parent_category);
       raise_application_error(v_error_no, v_error_msg);
     end if;
  end if;
 /* Note: For this stored procedure, there is no need to check
    authorizations for the child category.  */

  /* Check authority of server_user to be proxy for Roles procedures */
  if (v_server_user <> v_for_user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user, 
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_parent_category)) 
        INTO v_server_has_authp
        FROM DUAL;
  else  -- No need to worry about separate server authorization
    v_server_has_authp := 'Y';
  end if;
  if v_server_has_authp <> 'Y' then
    v_error_no := roles_service_constant.err_20003_no;
    v_error_msg := roles_service_constant.err_20003_msg;
    v_error_msg := replace(v_error_msg, '<server_id>', 
                           v_server_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                           v_parent_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;
 /* Note: For this stored procedure, there is no need to check
    authorizations for the child category.  */

  /* Check for_user authority to maintain function group.
     This is controlled by CREATE IMPLIED AUTH RULES authorizations */
  SELECT ROLESAPI_IS_USER_AUTHORIZED(v_for_user,
                                     'CREATE IMPLIED AUTH RULES', 
                                        'CAT' || trim(v_parent_category)) 
        INTO v_proxy_has_auth
        FROM DUAL;

  if v_proxy_has_auth = 'N' then
     v_error_msg := replace(roles_msg2.err_20043_msg, '<category>', 
        '''' || v_parent_category || '''');
     v_error_msg := replace(v_error_msg,'<user>','''' || v_for_user || '''');
     raise_application_error(roles_msg2.err_20043_no, v_error_msg);
  end if;

 /* Make sure the parent function group and child function 
    have the same qualifier_type */
  if (v_parent_qualtype <> v_child_qualtype) then
     v_error_msg := replace(roles_msg2.err_20050_msg, '<parent_id>', 
                            '''' || ai_parent_id || '''');
     v_error_msg := replace(v_error_msg, '<child_id>', 
                            '''' || ai_child_id || '''');
     raise_application_error(roles_msg2.err_20050_no, v_error_msg);
  end if; 

 /* If no errors were found, then 
    insert the record into the parent/child table */
  insert into function_group_link (parent_id, child_id)
         values (v_parent_id, v_child_id);

end;
/

/****************************************************************************
*  ROLESAPI_DEL_FUNC_GROUP_LINK
*  This is a stored procedure for adding a link between a function group
*  and a function.
*  It checks the authority of the server user (ai_server_user) and
*  the proxy user (ai_for_user) before allowing the link
*  to be added. 
*
****************************************************************************/
CREATE OR REPLACE PROCEDURE ROLESAPI_DEL_FUNC_GROUP_LINK
		(AI_SERVER_USER IN STRING,
                 AI_FOR_USER IN STRING,
                 AI_PARENT_ID IN STRING,
                 AI_CHILD_ID IN STRING
		)
IS
V_FOR_USER PERSON.KERBEROS_NAME%TYPE;
V_SERVER_USER PERSON.KERBEROS_NAME%TYPE;
V_PARENT_QUALTYPE QUALIFIER.QUALIFIER_TYPE%TYPE;
V_CHILD_QUALTYPE QUALIFIER.QUALIFIER_TYPE%TYPE;
V_PARENT_ID FUNCTION.FUNCTION_ID%TYPE;
V_CHILD_ID FUNCTION.FUNCTION_ID%TYPE;
V_PARENT_GROUP_NAME FUNCTION.FUNCTION_NAME%TYPE;
V_CHILD_FUNCTION_NAME FUNCTION.FUNCTION_NAME%TYPE;
V_PARENT_CATEGORY FUNCTION.FUNCTION_CATEGORY%TYPE;
V_CHILD_CATEGORY FUNCTION.FUNCTION_CATEGORY%TYPE;
v_count integer;

v_status integer;
v_error_no roles_msg.err_no%TYPE;
v_error_msg roles_msg.err_msg%TYPE;
v_msg_no roles_msg.err_no%TYPE;
v_msg roles_msg.err_msg%TYPE;
v_server_has_authp varchar2(1);
v_server_has_authc varchar2(1);
v_proxy_has_auth varchar2(1);

BEGIN
  v_for_user := upper(ai_for_user);
  if (ai_server_user is not null) then
    v_server_user := upper(ai_server_user);
  else
    v_server_user := upper(user);
  end if;

 /* Make sure the function_group/function pair exists */
  select count(*) into v_count
    from function_group_link where to_char(parent_id) = ai_parent_id
    and to_char(child_id) = ai_child_id;
  if v_count < 1 then
     v_error_msg := replace(roles_msg2.err_20051_msg, '<parent_id>', 
                            '''' || ai_parent_id || '''');
     v_error_msg := replace(v_error_msg, '<child_id>', 
                            '''' || ai_child_id || '''');
     raise_application_error(roles_msg2.err_20051_no, v_error_msg);
  end if; 

 /* Get function_group info for the function_group_id */
  v_parent_id := to_number(ai_parent_id);
  select FUNCTION_GROUP_NAME, FUNCTION_CATEGORY, 
         QUALIFIER_TYPE
     into v_parent_group_name, v_parent_category,
          v_parent_qualtype
  from function_group where function_group_id = v_parent_id;

 /* Get function info for the child function_id */
  v_child_id := to_number(ai_child_id);
  select FUNCTION_NAME, FUNCTION_CATEGORY, 
         QUALIFIER_TYPE
     into v_child_function_name, v_child_category,
          v_child_qualtype
  from function2 where function_id = v_child_id;

 /* Make sure both server_user and for_user are authorized to maintain
    functions in the given category */
 /* Check authority of Oracle login-user to be proxy for Roles procedures */
  if (v_server_user <> user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_parent_category)) 
        INTO v_server_has_authp
        FROM DUAL;
     if v_server_has_authp <> 'Y' then
       v_error_no := roles_service_constant.err_20003_no;
       v_error_msg := roles_service_constant.err_20003_msg;
       v_error_msg := replace(v_error_msg, '<server_id>', 
                              user);
       v_error_msg := replace(v_error_msg, '<function_category>', 
                              v_parent_category);
       raise_application_error(v_error_no, v_error_msg);
     end if;
  end if;
 /* Note: For this stored procedure, there is no need to check
    authorizations for the child category.  */

  /* Check authority of server_user to be proxy for Roles procedures */
  if (v_server_user <> v_for_user) then
     SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user, 
                                        'RUN ROLES SERVICE PROCEDURES', 
                                        'CAT' || trim(v_parent_category)) 
        INTO v_server_has_authp
        FROM DUAL;
  else  -- No need to worry about separate server authorization
    v_server_has_authp := 'Y';
  end if;
  if v_server_has_authp <> 'Y' then
    v_error_no := roles_service_constant.err_20003_no;
    v_error_msg := roles_service_constant.err_20003_msg;
    v_error_msg := replace(v_error_msg, '<server_id>', 
                           v_server_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                           v_parent_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;
 /* Note: For this stored procedure, there is no need to check
    authorizations for the child category.  */

  /* Check for_user authority to maintain function group.
     This is controlled by CREATE IMPLIED AUTH RULES authorizations */
  SELECT ROLESAPI_IS_USER_AUTHORIZED(v_for_user,
                                     'CREATE IMPLIED AUTH RULES', 
                                        'CAT' || trim(v_parent_category)) 
        INTO v_proxy_has_auth
        FROM DUAL;

  if v_proxy_has_auth = 'N' then
     v_error_msg := replace(roles_msg2.err_20043_msg, '<category>', 
        '''' || v_parent_category || '''');
     v_error_msg := replace(v_error_msg,'<user>','''' || v_for_user || '''');
     raise_application_error(roles_msg2.err_20043_no, v_error_msg);
  end if;

 /* If no errors were found, then 
    delete the record from the parent/child table */
  delete from function_group_link 
     where parent_id = v_parent_id  
     and child_id = v_child_id;

end;
/

/* Create synonyms and grant execute access on the stored procedures */

grant execute on ROLESAPI_CREATE_FUNCTION2 to public;
--grant execute on ROLESAPI_CREATE_FUNCTION2 to rolesbb;
create or replace public synonym ROLESAPI_CREATE_FUNCTION2 
   for ROLESAPI_CREATE_FUNCTION2;

grant execute on ROLESAPI_CREATE_FUNC_GROUP to public;
--grant execute on ROLESAPI_CREATE_FUNC_GROUP to rolesbb;
create or replace public synonym ROLESAPI_CREATE_FUNC_GROUP
   for ROLESAPI_CREATE_FUNC_GROUP;

grant execute on ROLESAPI_CREATE_EXT_FUNCTION to public;
--grant execute on ROLESAPI_CREATE_EXT_FUNCTION to rolesbb;
create or replace public synonym ROLESAPI_CREATE_EXT_FUNCTION 
   for ROLESAPI_CREATE_EXT_FUNCTION;

grant execute on ROLESAPI_UPDATE_FUNCTION2 to public;
--grant execute on ROLESAPI_UPDATE_FUNCTION2 to rolesbb;
create or replace public synonym ROLESAPI_UPDATE_FUNCTION2 
   for ROLESAPI_UPDATE_FUNCTION2;

grant execute on ROLESAPI_UPDATE_EXT_FUNCTION to public;
--grant execute on ROLESAPI_UPDATE_EXT_FUNCTION to rolesbb;
create or replace public synonym ROLESAPI_UPDATE_EXT_FUNCTION
   for ROLESAPI_UPDATE_EXT_FUNCTION;

grant execute on ROLESAPI_DELETE_FUNCTION2 to public;
--grant execute on ROLESAPI_DELETE_FUNCTION2 to rolesbb;
create or replace public synonym ROLESAPI_DELETE_FUNCTION2 
   for ROLESAPI_DELETE_FUNCTION2;

grant execute on ROLESAPI_DELETE_FUNC_GROUP to public;
--grant execute on ROLESAPI_DELETE_FUNC_GROUP to rolesbb;
create or replace public synonym ROLESAPI_DELETE_FUNC_GROUP 
   for ROLESAPI_DELETE_FUNC_GROUP;

grant execute on ROLESAPI_UPDATE_FUNC_GROUP to public;
--grant execute on ROLESAPI_UPDATE_FUNC_GROUP to rolesbb;
create or replace public synonym ROLESAPI_UPDATE_FUNC_GROUP 
   for ROLESAPI_UPDATE_FUNC_GROUP;

grant execute on ROLESAPI_DELETE_EXT_FUNCTION to public;
--grant execute on ROLESAPI_DELETE_EXT_FUNCTION to rolesbb;
create or replace public synonym ROLESAPI_DELETE_EXT_FUNCTION 
   for ROLESAPI_DELETE_EXT_FUNCTION;

grant execute on ROLESAPI_DELETE_FUNCTION_CHILD to public;
create or replace public synonym ROLESAPI_DELETE_FUNCTION_CHILD 
   for ROLESAPI_DELETE_FUNCTION_CHILD;

grant execute on ROLESAPI_ADD_FUNCTION_CHILD to public;
create or replace public synonym ROLESAPI_ADD_FUNCTION_CHILD 
   for ROLESAPI_ADD_FUNCTION_CHILD;

grant execute on ROLESAPI_ADD_FUNC_GROUP_LINK to public;
create or replace public synonym ROLESAPI_ADD_FUNC_GROUP_LINK
   for ROLESAPI_ADD_FUNC_GROUP_LINK;

grant execute on ROLESAPI_DEL_FUNC_GROUP_LINK to public;
create or replace public synonym ROLESAPI_DEL_FUNC_GROUP_LINK
   for ROLESAPI_DEL_FUNC_GROUP_LINK;

grant execute on AUTH_SF_CAN_MAINT_PA_FUNC to public;
create or replace public synonym AUTH_SF_CAN_MAINT_PA_FUNC
   for AUTH_SF_CAN_MAINT_PA_FUNC;

