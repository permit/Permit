-- -----------------
-- create the stored procedures necessary for the perMIT web services
--
--  Copyright (C) 2007-2010 Massachusetts Institute of Technology
--  For contact and other information see: http://mit.edu/permit/
--
--  This program is free software; you can redistribute it and/or modify it under the terms of the GNU General 
--  Public License as published by the Free Software Foundation; either version 2 of the License.
--
--  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even 
--  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public 
--  License for more details.
--
--  You should have received a copy of the GNU General Public License along with this program; if not, write 
--  to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
--
-- -----------------


create or replace package ROLES_SERVICE_CONSTANT as
  service_function_name varchar2(30) := 'RUN ROLES SERVICE PROCEDURES';
  category_crit_id integer := 210;
  function_name_crit_id integer := 215;
  kerberos_name_crit_id integer := 205;
  max_function_category_size integer := 4;
  max_function_name_size integer := 30;
  max_qualifier_type_size integer := 4;
  read_auth_function1 varchar2(30) := 'VIEW AUTH BY CATEGORY';
  read_auth_function2 varchar2(30) := 'CREATE AUTHORIZATIONS';
  /* Message numbers -20001 to -20020 are "not authorized" messages */
  err_20003_no integer := -20003;
  err_20003_msg varchar2(255) := 
    'Server ID ''<server_id>'' is not authorized to run Roles DB service'
    || ' procedures for category <function_category>.';
  err_20005_no integer := -20005;
  err_20005_msg varchar2(255) := 
    'User ''<proxy_user>'' is not authorized to look up authorizations'
    || ' in category ''<function_category>''.';
  err_20006_no integer := -20006;
  err_20006_msg varchar2(255) := 
    'User ''<proxy_user>'' is not authorized to look up authorizations'
    || ' in any category using this server (server ID ''<server_id>'').';
  /* Message numbers -20021, etc. are other errors */
  err_20021a_no integer := -20021;
  err_20021a_msg varchar2(255) := 
    'Function ID ''<function_id>'' is not a valid function_id number.';
  err_20021b_no integer := -20021;
  err_20021b_msg varchar2(255) := 
    'Function name ''<function_name>'' within category'
    || ' ''<function_category>'' was not found.';
  err_20021c_no integer := -20021;
  err_20021c_msg varchar2(255) := 
    'Function name ''<function_name>'' was not found.';
  err_20022a_no integer := -20022;
  err_20022a_msg varchar2(255) := 
    'Qualifier ID ''<qualifier_id>'' is not a valid qualifier_id number'
    || ' for qualifier_type <qualifier_type>.';
  err_20022b_no integer := -20022;
  err_20022b_msg varchar2(255) := 
    'Qualifier Code ''<qualifier_code>'' is not a valid qualifier code'
    || ' for qualifier_type <qualifier_type>.';
  /* In error -20023, the <argument_name> will be either qualifier_code,  */
  /* based_qualifier_code, parent_qualifier_code, or child_qualifier_code */
  err_20023_no integer := -20023;
  err_20023_msg varchar2(255) := 
    'Since you have specified <argument_name>, you must also specify '
    || 'either qualifier_type, function_name, or function_id as well.';
  err_20024_no integer := -20024;
  err_20024_msg varchar2(255) := 
    'Bad argument REAL_OR_IMPLIED: ''<arg_value>''. It must be '
     || '''R'', ''I'', ''B'', or null.';
  err_20027_no integer := -20027;
  err_20027_msg varchar2(255) := 
    'If a non-null function_name is specified, then a function_category '
    || 'must be specified as well.';
  err_20028_no integer := -20028;
  err_20028_msg varchar2(255) := 
    'Function_category ''<function_category>'' has more than '
    || to_char(max_function_category_size) || ' characters.';
  err_20029_no integer := -20029;
  err_20029_msg varchar2(255) := 
    'Function_name ''<function_name>'' has more than '
    || to_char(max_function_name_size) || ' characters.';
  err_20030_no integer := -20030;
  err_20030_msg varchar2(255) := 
    'Kerberos name must be specified.';
  err_20031_no integer := -20031;
  err_20031_msg varchar2(255) := 
    'Qualifier type ''<qualifier_type>'' has more than '
    || to_char(max_qualifier_type_size) || ' characters.';
  ------ error messages for implied authorization rules
  err_20032_no integer := -20032;
  err_20032_msg varchar2(255) := 
  'Result qualifier ''<qualifier_type>'', ''<qualifier_code>'' for ''<rule_type_code>'' do not match the result function ''<function_name>''.';
  err_20033_no integer := -20033;
  err_20033_msg varchar2(255) :=
  '''<for_user>'' is not authorized to create rules for ''<function_category>''.';
  err_20034_no integer := -20034;
  err_20034_msg varchar2(255) :=
  'Rule type code ''<rule_type_code>''  is not correct.';
  err_20035_no integer := -20035;
  err_20035_msg varchar2(255) :=
  'Wrong combination of condition_function_category ''<condition_function_category>'' and condition_function_name ''<condition_function_name>''.';
  err_20036_no integer := -20036;
  err_20036_msg varchar2(255) :=
  'Wrong combination of condition_qualifier_type ''<condition_qualifier_type>'' and condition_qualifier_code ''<condition_qualifier_code>'' for a condition function ''<function_name>''.';
  err_20037_no integer := -20037;
  err_20037_msg varchar(255) := 
  'Rule short name ''<rule_short_name>'' is not unique.';
  err_20038_no integer := -20038;
  err_20038_msg varchar(255) :=
  '''<rule_is_in_effect>'' is not allowed for rule_is_in_effect, must be Y or N.';
  err_20039_no integer := -20039;
  err_20039_msg varchar2(255) :=
  'Condition object type ''<condition_object_type>'' cannot be used with condition function ''<condition_function_name>'' of category ''<condition_function_category>''.'; 
  err_20040_no integer := -20040;
  err_20040_msg varchar2(255) :=
  'Condition ''<condition_function_name>'' and result ''<result_function_name>'' for the rule of type ''<rule_type_code>'' must have identical qualifiers !'; 
  err_20041_no integer := -20041;
  err_20041_msg varchar2(255) :=
  'For the rule ''<rule_type_code>'', result qual type should be a parent of condition qaul type. ''<result_qualifier_type>'' is not a parent of  ''<condition_qualifier_type>'' !';
  err_20042_no integer := -20042;
  err_20042_msg varchar2(255) :=
  'Attempt to create a duplicate to rule ''<rule_id>''.';
  err_20043_no integer := -20043;
  err_20043_msg varchar2(255) :=
  'For the rule ''<rule_type_code>'' condition qualifier code should be NULL, it is ''<condition_qualifier_code>''.';
 err_20044_no integer := -20044;
  err_20044_msg varchar2(255) :=
  'For the rule ''<rule_type_code>'' result qualifier code should be NULL, it is ''<result_qualifier_code>''.';
 err_20045_no integer := -20045;
  err_20045_msg varchar2(255) :=
  'For the rule ''<rule_type_code>'' result qualifier type should be NULL, it is ''<result_qualifier_type>''.';
 err_20046_no integer := -20046;
  err_20046_msg varchar2(255) :=
  'Wrong category (''<function_category>'') for function ''<function_name>''.'; 
 err_20047_no integer := -20047;
  err_20047_msg varchar2(255) :=
  'Condition object type ''<condition_object_type>'' cannot be used with result function ''<result_function_name>'' of category ''<result_function_category>''.'; 
 err_20048_no integer := -20048;
  err_20048_msg varchar2(255) :=
  'Wrong pass number (''<pass_number>'')  found for the condition function ''<function_name>''.';
 err_20049_no integer := -20049;
  err_20049_msg varchar2(255) :=
  'Wrong pass number (''<pass_number>'') found for the result function ''<function_name>''.';
end ROLES_SERVICE_CONSTANT;
/

create or replace package ROLESSERV as
  FUNCTION is_user_authorized
    (ai_server_user in string,
     ai_proxy_user in string,
     ai_kerberos_name in string,
     ai_function_id in string,
     ai_qualifier_id in string)
    return varchar2;
--PRAGMA RESTRICT_REFERENCES(is_user_authorized, WNDS);

  FUNCTION is_user_authorized
    (ai_server_user in string,
     ai_proxy_user in string,
     ai_kerberos_name in string,
     ai_function_category in string,
     ai_function_name in string,
     ai_qualifier_code in string)
    return varchar2;

  FUNCTION is_user_authorized_extended
    (ai_server_user in string,
     ai_proxy_user in string,
     ai_kerberos_name in string,
     ai_function_category in string,
     ai_function_name in string,
     ai_qualifier_code in string,
     ai_real_or_implied in string)
    return varchar2;

  FUNCTION get_sql_fragment
    (ai_proxy_user in string,
     ni_id in integer,
     ai_value in string)
    return varchar2;

  FUNCTION get_view_category_list
    (ai_server_user in string,
     ai_proxy_user in string)
    return varchar2;
--PRAGMA RESTRICT_REFERENCES(is_user_authorized, WNDS);

  PROCEDURE get_auth_person_sql
      (ai_server_user in VARCHAR2,
       ai_proxy_user in VARCHAR2,
       ai_kerberos_name in VARCHAR2,
       ai_function_category IN VARCHAR2, 
       ai_expand_qualifiers IN VARCHAR2, 
       ai_is_active_now IN VARCHAR2, 
       ai_opt_function_name IN VARCHAR2, 
       ai_opt_function_id IN VARCHAR2, 
       ai_opt_qualifier_type IN VARCHAR2, 
       ai_opt_qualifier_code IN VARCHAR2, 
       ai_opt_qualifier_id IN VARCHAR2, 
       ai_opt_base_qual_code IN VARCHAR2,
       ai_opt_base_qual_id IN VARCHAR2,
       ai_opt_parent_qual_code IN VARCHAR2,
       ai_opt_parent_qual_id IN VARCHAR2,
       ai_opt_child_qual_code IN VARCHAR2,
       ai_opt_child_qual_id IN VARCHAR2,
       ao_error_no OUT INTEGER,
       ao_error_msg OUT VARCHAR2,
       ao_sql_statement OUT VARCHAR2);

  PROCEDURE get_auth_person_sql2
      (ai_server_user in VARCHAR2,
       ai_proxy_user in VARCHAR2,
       ai_kerberos_name in VARCHAR2,
       ai_function_category IN VARCHAR2, 
       ai_expand_qualifiers IN VARCHAR2, 
       ai_is_active_now IN VARCHAR2, 
       ai_opt_function_name IN VARCHAR2, 
       ai_opt_function_id IN VARCHAR2, 
       ai_opt_qualifier_type IN VARCHAR2, 
       ai_opt_qualifier_code IN VARCHAR2, 
       ai_opt_qualifier_id IN VARCHAR2, 
       ai_opt_base_qual_code IN VARCHAR2,
       ai_opt_base_qual_id IN VARCHAR2,
       ai_opt_parent_qual_code IN VARCHAR2,
       ai_opt_parent_qual_id IN VARCHAR2,
       ai_opt_child_qual_code IN VARCHAR2,
       ai_opt_child_qual_id IN VARCHAR2, -- add sort argument after this
       ao_error_no OUT INTEGER,
       ao_error_msg OUT VARCHAR2,
       ao_sql_statement OUT VARCHAR2);

  PROCEDURE get_auth_person_sql_extend1
      (ai_server_user in VARCHAR2,
       ai_proxy_user in VARCHAR2,
       ai_kerberos_name in VARCHAR2,
       ai_function_category IN VARCHAR2, 
       ai_expand_qualifiers IN VARCHAR2, 
       ai_is_active_now IN VARCHAR2, 
       ai_opt_real_or_implied IN VARCHAR2,
       ai_opt_function_name IN VARCHAR2, 
       ai_opt_function_id IN VARCHAR2, 
       ai_opt_qualifier_type IN VARCHAR2, 
       ai_opt_qualifier_code IN VARCHAR2, 
       ai_opt_qualifier_id IN VARCHAR2, 
       ai_opt_base_qual_code IN VARCHAR2,
       ai_opt_base_qual_id IN VARCHAR2,
       ai_opt_parent_qual_code IN VARCHAR2,
       ai_opt_parent_qual_id IN VARCHAR2,
       ao_error_no OUT INTEGER,
       ao_error_msg OUT VARCHAR2,
       ao_sql_statement OUT VARCHAR2);

  FUNCTION get_auth_person_cursor
      (ai_server_user in VARCHAR2,
       ai_proxy_user in VARCHAR2,
       ai_kerberos_name in VARCHAR2,
       ai_function_category IN VARCHAR2, 
       ai_expand_qualifiers IN VARCHAR2, 
       ai_is_active_now IN VARCHAR2, 
       ai_opt_function_name IN VARCHAR2, 
       ai_opt_function_id IN VARCHAR2, 
       ai_opt_qualifier_type IN VARCHAR2, 
       ai_opt_qualifier_code IN VARCHAR2, 
       ai_opt_qualifier_id IN VARCHAR2, 
       ai_opt_base_qual_code IN VARCHAR2,
       ai_opt_base_qual_id IN VARCHAR2,
       ai_opt_parent_qual_code IN VARCHAR2,
       ai_opt_parent_qual_id IN VARCHAR2,
       ai_opt_child_qual_code IN VARCHAR2,
       ai_opt_child_qual_id IN VARCHAR2)
    RETURN roles_service_types.ref_cursor;

  FUNCTION get_auth_person_cursor2
      (ai_server_user in VARCHAR2,
       ai_proxy_user in VARCHAR2,
       ai_kerberos_name in VARCHAR2,
       ai_function_category IN VARCHAR2, 
       ai_expand_qualifiers IN VARCHAR2, 
       ai_is_active_now IN VARCHAR2, 
       ai_opt_function_name IN VARCHAR2, 
       ai_opt_function_id IN VARCHAR2, 
       ai_opt_qualifier_type IN VARCHAR2, 
       ai_opt_qualifier_code IN VARCHAR2, 
       ai_opt_qualifier_id IN VARCHAR2, 
       ai_opt_base_qual_code IN VARCHAR2,
       ai_opt_base_qual_id IN VARCHAR2,
       ai_opt_parent_qual_code IN VARCHAR2,
       ai_opt_parent_qual_id IN VARCHAR2,
       ai_opt_child_qual_code IN VARCHAR2,
       ai_opt_child_qual_id IN VARCHAR2)
    RETURN roles_service_types.ref_cursor;

  FUNCTION get_auth_person_curs_extend1
      (ai_server_user in VARCHAR2,
       ai_proxy_user in VARCHAR2,
       ai_kerberos_name in VARCHAR2,
       ai_function_category IN VARCHAR2, 
       ai_expand_qualifiers IN VARCHAR2, 
       ai_is_active_now IN VARCHAR2, 
       ai_opt_real_or_implied IN VARCHAR2,
       ai_opt_function_name IN VARCHAR2, 
       ai_opt_function_id IN VARCHAR2, 
       ai_opt_qualifier_type IN VARCHAR2, 
       ai_opt_qualifier_code IN VARCHAR2, 
       ai_opt_qualifier_id IN VARCHAR2, 
       ai_opt_base_qual_code IN VARCHAR2,
       ai_opt_base_qual_id IN VARCHAR2,
       ai_opt_parent_qual_code IN VARCHAR2,
       ai_opt_parent_qual_id IN VARCHAR2)
    RETURN roles_service_types.ref_cursor;

  PROCEDURE get_auth_general_sql
      (ai_server_user in VARCHAR2,
       ai_proxy_user in VARCHAR2,
       ai_num_criteria in STRING, /* Handle up to 20 criteria/value pairs */
       ai_id1 in STRING, ai_value1 in STRING,
       ai_id2 in STRING, ai_value2 in STRING,
       ai_id3 in STRING, ai_value3 in STRING,
       ai_id4 in STRING, ai_value4 in STRING,
       ai_id5 in STRING, ai_value5 in STRING,
       ai_id6 in STRING, ai_value6 in STRING,
       ai_id7 in STRING, ai_value7 in STRING,
       ai_id8 in STRING, ai_value8 in STRING,
       ai_id9 in STRING, ai_value9 in STRING,
       ai_id10 in STRING, ai_value10 in STRING,
       ai_id11 in STRING, ai_value11 in STRING,
       ai_id12 in STRING, ai_value12 in STRING,
       ai_id13 in STRING, ai_value13 in STRING,
       ai_id14 in STRING, ai_value14 in STRING,
       ai_id15 in STRING, ai_value15 in STRING,
       ai_id16 in STRING, ai_value16 in STRING,
       ai_id17 in STRING, ai_value17 in STRING,
       ai_id18 in STRING, ai_value18 in STRING,
       ai_id19 in STRING, ai_value19 in STRING,
       ai_id20 in STRING, ai_value20 in STRING,
       ao_error_no OUT VARCHAR2,
       ao_error_msg OUT VARCHAR2,
       ao_sql_statement OUT VARCHAR2);

FUNCTION get_auth_general_cursor
      (ai_server_user in VARCHAR2,
       ai_proxy_user in VARCHAR2,
       ai_num_criteria in STRING, /* Handle up to 20 criteria/value pairs */
       ai_id1 in STRING, ai_value1 in STRING,
       ai_id2 in STRING, ai_value2 in STRING,
       ai_id3 in STRING, ai_value3 in STRING,
       ai_id4 in STRING, ai_value4 in STRING,
       ai_id5 in STRING, ai_value5 in STRING,
       ai_id6 in STRING, ai_value6 in STRING,
       ai_id7 in STRING, ai_value7 in STRING,
       ai_id8 in STRING, ai_value8 in STRING,
       ai_id9 in STRING, ai_value9 in STRING,
       ai_id10 in STRING, ai_value10 in STRING,
       ai_id11 in STRING, ai_value11 in STRING,
       ai_id12 in STRING, ai_value12 in STRING,
       ai_id13 in STRING, ai_value13 in STRING,
       ai_id14 in STRING, ai_value14 in STRING,
       ai_id15 in STRING, ai_value15 in STRING,
       ai_id16 in STRING, ai_value16 in STRING,
       ai_id17 in STRING, ai_value17 in STRING,
       ai_id18 in STRING, ai_value18 in STRING,
       ai_id19 in STRING, ai_value19 in STRING,
       ai_id20 in STRING, ai_value20 in STRING)
  RETURN roles_service_types.ref_cursor;

  FUNCTION default_qualtree_level
    (ai_qualifier_type in string)
    return integer;


end ROLESSERV;
/

create or replace package body ROLESSERV as

/*****************************************************************************
*   First overloaded version of function IS_USER_AUTHORIZED
*   Takes Kerberos_name for user, function_id for function and 
*   qualifier_id for qualifier as arguments.
*
*   Use 
*   SELECT ROLESSERV.IS_USER_AUTHORIZED(server_user, proxy_user, 
*                                       user, func_id ,qual_id) 
*        FROM DUAL;
*   to get a 'Y' or 'N' answer about a user's authorization to do something.
*****************************************************************************/
FUNCTION is_user_authorized
    (ai_server_user in string,
     ai_proxy_user in string,
     ai_kerberos_name in string,
     ai_function_id in string,
     ai_qualifier_id in string)
    return varchar2
  is
  v_kerberos_name authorization.kerberos_name%type;
  v_server_user authorization.kerberos_name%type;
  v_proxy_user authorization.kerberos_name%type;
  v_function_id function.function_id%type;
  v_function_category function.function_category%type;
  v_qualifier_type function.qualifier_type%type;
  v_qualifier_id authorization.qualifier_id%type;
  v_count integer;
  v_check_auth varchar2(1);
  v_error_msg varchar2(255);
  v_error_no integer;

BEGIN
  v_kerberos_name := upper(ai_kerberos_name);
  v_server_user := upper(ai_server_user);
  v_proxy_user := upper(ai_proxy_user);

  /* Make sure ai_function_id is a valid number */
  if (translate(ai_function_id, '0123456789', '0000000000') <> 
      substr('00000000000000000000', 1, length(ai_function_id)) )
  then
    /* Raise error condition */
    v_error_no := roles_service_constant.err_20021a_no;
    v_error_msg := replace(roles_service_constant.err_20021a_msg, 
                          '<function_id>', ai_function_id);
    raise_application_error(v_error_no, v_error_msg);
  end if;

  /* Make sure the function_id exists.  Find the related function_category. */
  select count(*) into v_count from function 
     where function_id = to_number(ai_function_id);
  if v_count = 0 then
    v_error_no := roles_service_constant.err_20021a_no;
    v_error_msg := replace(roles_service_constant.err_20021a_msg, '<function_id>', 
                          ai_function_id);
    raise_application_error(v_error_no, v_error_msg);
  end if;
  select function_id, function_category, qualifier_type
    into v_function_id, v_function_category, v_qualifier_type
    from function
    where function_id = to_number(ai_function_id);

  /* Make sure the server_user is authorized to act as a proxy for the
     given category.  */
  select rolesapi_is_user_authorized(ai_server_user, 
           roles_service_constant.service_function_name, 
           'CAT' || rtrim(v_function_category, ' ')) 
         into v_check_auth from dual;
  if (v_check_auth <> 'Y') then
    v_error_no := roles_service_constant.err_20003_no;
    v_error_msg := roles_service_constant.err_20003_msg;
    v_error_msg := replace(v_error_msg, '<server_id>', 
                           ai_server_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                           v_function_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;

  /* Make sure the proxy_user is authorized to check the authorization, 
     either because proxy_user = kerberos_name or because proxy_user 
     has the authority to look up authorizations in this category */
  if (v_proxy_user = v_server_user) then 
    v_check_auth := 'Y';
  elsif (v_proxy_user = v_kerberos_name) then 
    v_check_auth := 'Y';
  else
    select rolesapi_is_user_authorized(v_proxy_user, 
             roles_service_constant.read_auth_function1, 
             'CAT' || rtrim(v_function_category, ' ')) 
           into v_check_auth from dual;
    if (v_check_auth <> 'Y') then
      select rolesapi_is_user_authorized(v_proxy_user, 
             roles_service_constant.read_auth_function2, 
             'CAT' || rtrim(v_function_category, ' '))
           into v_check_auth from dual;
    end if;
  end if;
  if (v_check_auth <> 'Y') then
    v_error_no := roles_service_constant.err_20005_no;
    v_error_msg := roles_service_constant.err_20005_msg;
    v_error_msg := replace(v_error_msg, '<proxy_user>', 
                          v_proxy_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                          v_function_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;

  /* Make sure ai_qualifier_id is a valid number */
  if (translate(ai_qualifier_id, '0123456789', '0000000000') <> 
      substr('00000000000000000000', 1, length(ai_qualifier_id)) )
  then
    /* Raise error condition */
    v_error_no := roles_service_constant.err_20022a_no;
    v_error_msg := roles_service_constant.err_20022a_msg;
    v_error_msg := replace(v_error_msg, '<qualifier_id>', 
                          ai_qualifier_id);
    v_error_msg := replace(v_error_msg, '<qualifier_type>', 
                          v_qualifier_type);
    raise_application_error(v_error_no, v_error_msg);
  end if;

  /* Make sure we have a valid qualifier_id */
  select count(*) into v_count 
    from qualifier
    where qualifier_type = v_qualifier_type
    and qualifier_id = to_number(ai_qualifier_id);
  if v_count = 0 then
    v_error_no := roles_service_constant.err_20022a_no;
    v_error_msg := roles_service_constant.err_20022a_msg;
    v_error_msg := replace(v_error_msg, '<qualifier_id>', 
                          ai_qualifier_id);
    v_error_msg := replace(v_error_msg, '<qualifier_type>', 
                          v_qualifier_type);
    raise_application_error(v_error_no, v_error_msg);
  end if;
  v_qualifier_id := to_number(ai_qualifier_id);

  /* Now, we'll actually check the authorization of user Kerberos_name.
     First, see if there is an authorization that exactly matches
     the kerberos_name, function_name, and qualifier_code specified */

  select count(*) into v_count from authorization
    where kerberos_name = v_kerberos_name
    and function_id = v_function_id 
    and qualifier_id = v_qualifier_id
    and do_function = 'Y'
    and sysdate between effective_date and nvl(expiration_date, sysdate);

  IF v_count > 0 THEN
    RETURN 'Y';
  END IF;

  /* Next, see if there is a matching authorization with a qualifier
     that is a parent of the specified qualifier_code */

  select count(*) into v_count 
    from authorization a, qualifier_descendent qd
    where a.kerberos_name = v_kerberos_name
    and a.function_id = v_function_id
    and a.do_function = 'Y'
    and a.descend = 'Y'
    and sysdate between a.effective_date and nvl(a.expiration_date, sysdate)
    and qd.child_id = v_qualifier_id
    and a.qualifier_id = qd.parent_id;
  IF v_count > 0 THEN
    RETURN 'Y';
  END IF;

  /* In the future, look to see if there are functions that are parents
     of the given function, and do the above 2 steps for the corresponding
     function_names.  We might also need to look to see if the person is
     in a group that is authorized. */
  RETURN 'N';

END is_user_authorized;

/*****************************************************************************
*   2nd overloaded version of function IS_USER_AUTHORIZED
*   Takes Kerberos_name for user, function_category and function_name
*   for function and qualifier_code for qualifier as arguments.
*
*   Use 
*   SELECT ROLESSERV.IS_USER_AUTHORIZED(server_user, proxy_user, 
*                                       user, category, func_name, qual_code) 
*        FROM DUAL;
*   to get a 'Y' or 'N' answer about a user's authorization to do something.
*****************************************************************************/
  FUNCTION is_user_authorized
    (ai_server_user in string,
     ai_proxy_user in string,
     ai_kerberos_name in string,
     ai_function_category in string,
     ai_function_name in string,
     ai_qualifier_code in string)
  return varchar2
  is
  v_kerberos_name authorization.kerberos_name%type;
  v_server_user authorization.kerberos_name%type;
  v_proxy_user authorization.kerberos_name%type;
  v_function_id function.function_id%type;
  v_function_category function.function_category%type;
  v_function_name function.function_name%type;
  v_qualifier_type function.qualifier_type%type;
  v_qualifier_code authorization.qualifier_code%type;
  v_qualifier_id authorization.qualifier_id%type;
  v_count integer;
  v_check_auth varchar2(1);
  v_error_msg varchar2(255);
  v_error_no integer;

BEGIN
  v_kerberos_name := upper(ai_kerberos_name);
  v_server_user := upper(ai_server_user);
  v_proxy_user := upper(ai_proxy_user);
  
  /* Make sure the given function_category does not exceed maximum length */
  if (length(ai_function_category) > 
      roles_service_constant.max_function_category_size) 
  then
    v_error_no := roles_service_constant.err_20028_no;
    v_error_msg := replace(roles_service_constant.err_20028_msg, 
                            '<function_category>', ai_function_category);
    raise_application_error(v_error_no, v_error_msg);
  else 
    v_function_category := upper(ai_function_category);
  end if;

  /* Make sure the given function_name does not exceed maximum length */
  if (length(ai_function_category) > 
      roles_service_constant.max_function_name_size) 
  then
    v_error_no := roles_service_constant.err_20029_no;
    v_error_msg := replace(roles_service_constant.err_20029_msg, 
                            '<function_name>', ai_function_name);
    raise_application_error(v_error_no, v_error_msg);
  else 
    v_function_category := upper(ai_function_category);
  end if;

  /* Make sure function_category and function_name exist */
  v_function_name := upper(ai_function_name);
  select count(*) into v_count from function 
     where function_category = v_function_category
     and function_name = v_function_name;
  if v_count = 0 then
    v_error_no := roles_service_constant.err_20021b_no;
    v_error_msg := roles_service_constant.err_20021b_msg;
    v_error_msg := replace(v_error_msg, '<function_name>', 
                          ai_function_name);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                          v_function_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;
  select function_id, qualifier_type
    into v_function_id, v_qualifier_type
    from function
    where function_category = v_function_category
    and function_name = v_function_name;

  /* Make sure the server_user is authorized to act as a proxy for the
     given category.  */
  select rolesapi_is_user_authorized(ai_server_user, 
           roles_service_constant.service_function_name, 
           'CAT' || rtrim(v_function_category, ' '))
         into v_check_auth from dual;
  if (v_check_auth <> 'Y') then
    v_error_no := roles_service_constant.err_20003_no;
    v_error_msg := roles_service_constant.err_20003_msg;
    v_error_msg := replace(v_error_msg, '<server_id>', 
                           ai_server_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                           v_function_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;

  /* Make sure the proxy_user is authorized to check the authorization, 
     either because proxy_user = kerberos_name or because proxy_user 
     has the authority to look up authorizations in this category */
  if (v_proxy_user = v_server_user) then 
    v_check_auth := 'Y';
  elsif (v_proxy_user = v_kerberos_name) then 
    v_check_auth := 'Y';
  else
    select rolesapi_is_user_authorized(v_proxy_user, 
             roles_service_constant.read_auth_function1, 
             'CAT' || rtrim(v_function_category, ' '))
           into v_check_auth from dual;
    if (v_check_auth <> 'Y') then
      select rolesapi_is_user_authorized(v_proxy_user, 
             roles_service_constant.read_auth_function2, 
             'CAT' || rtrim(v_function_category, ' '))
             into v_check_auth from dual;
    end if;
  end if;
  if (v_check_auth <> 'Y') then
    v_error_no := roles_service_constant.err_20005_no;
    v_error_msg := roles_service_constant.err_20005_msg;
    v_error_msg := replace(v_error_msg, '<proxy_user>', 
                          v_proxy_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                          v_function_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;

  /* Make sure we have a valid qualifier_code.  If not, then 
     raise an error condition.  */
  v_qualifier_code := upper(ai_qualifier_code);
  select count(*) into v_count 
    from qualifier
    where qualifier_type = v_qualifier_type
    and qualifier_code = v_qualifier_code;
  if v_count = 0 then
    v_error_no := roles_service_constant.err_20022b_no;
    v_error_msg := roles_service_constant.err_20022b_msg;
    v_error_msg := replace(v_error_msg, '<qualifier_code>', 
                          v_qualifier_code);
    v_error_msg := replace(v_error_msg, '<qualifier_type>', 
                          v_qualifier_type);
    raise_application_error(v_error_no, v_error_msg);
  end if;
  select qualifier_id into v_qualifier_id
    from qualifier
    where qualifier_type = v_qualifier_type
    and qualifier_code = v_qualifier_code;

  /* Now, we'll actually check the authorization of user Kerberos_name.
     First, see if there is an authorization that exactly matches
     the kerberos_name, function_name, and qualifier_code specified */

  select count(*) into v_count from authorization
    where kerberos_name = v_kerberos_name
    and function_id = v_function_id 
    and qualifier_id = v_qualifier_id
    and do_function = 'Y'
    and sysdate between effective_date and nvl(expiration_date, sysdate);

  IF v_count > 0 THEN
    RETURN 'Y';
  END IF;

  /* Next, see if there is a matching authorization with a qualifier
     that is a parent of the specified qualifier_code */

  select count(*) into v_count 
    from authorization a, qualifier_descendent qd
    where a.kerberos_name = v_kerberos_name
    and a.function_id = v_function_id
    and a.do_function = 'Y'
    and a.descend = 'Y'
    and sysdate between a.effective_date and nvl(a.expiration_date, sysdate)
    and qd.child_id = v_qualifier_id
    and a.qualifier_id = qd.parent_id;
  IF v_count > 0 THEN
    RETURN 'Y';
  END IF;

  /* In the future, look to see if there are functions that are parents
     of the given function, and do the above 2 steps for the corresponding
     function_names.  We might also need to look to see if the person is
     in a group that is authorized. */
  RETURN 'N';

END is_user_authorized;

/*****************************************************************************
*   IS_USER_AUTHORIZED_EXTENDED
*   This differs from IS_USER_AUTHORIZED in the following way:
*     - It takes into account implied (or external) authorizations
*       from the view AUTHORIZATION2, not just "real" authorizations
*       from the table AUTHORIZATION
*     - It takes an additional argument REAL_OR_IMPLIED, which
*       can be set to 'R' (examine real authorizations only), 
*       'I' (examine implied or external authorizations only), or
*       'B' (examine both).  'B' is the default.
*   Takes Kerberos_name for user, function_category and function_name
*   for function, qualifier_code for qualifier, and real_or_implied 
*   ('R', 'I', or 'B') as arguments.
*
*   Use 
*   SELECT ROLESSERV.IS_USER_AUTHORIZED_EXTENDED
*     (server_user, proxy_user, user, category, func_name, 
       qual_code, real_or_implied) 
*     FROM DUAL;
*   to get a 'Y' or 'N' answer about a user's authorization to do something.
*****************************************************************************/
  FUNCTION is_user_authorized_extended
    (ai_server_user in string,
     ai_proxy_user in string,
     ai_kerberos_name in string,
     ai_function_category in string,
     ai_function_name in string,
     ai_qualifier_code in string,
     ai_real_or_implied in string)
  return varchar2
  is
  v_kerberos_name authorization.kerberos_name%type;
  v_server_user authorization.kerberos_name%type;
  v_proxy_user authorization.kerberos_name%type;
  v_function_id_real function.function_id%type;
  v_function_id_imp function.function_id%type;
  v_function_category function.function_category%type;
  v_function_name function.function_name%type;
  v_star_function_name varchar2(31);
  v_qualifier_type function.qualifier_type%type;
  v_qualifier_code authorization.qualifier_code%type;
  v_qualifier_id authorization.qualifier_id%type;
  v_count integer;
  v_found_real_function integer := 0;
  v_found_imp_function integer := 0;
  v_valid_real_implied_arg integer;
  v_real_or_implied varchar2(1);
  v_allow_auth_type1 authorization2.auth_type%type;
  v_allow_auth_type2 authorization2.auth_type%type;
  v_check_auth varchar2(1);
  v_error_msg varchar2(255);
  v_error_no integer;

BEGIN
  v_kerberos_name := upper(ai_kerberos_name);
  v_server_user := upper(ai_server_user);
  v_proxy_user := upper(ai_proxy_user);

  /* Make sure the argument ai_real_or_implied is valid */
  if length(ai_real_or_implied) > 1 then
    v_valid_real_implied_arg := 0;
  else
    v_real_or_implied := upper(nvl(ai_real_or_implied, 'B'));
    if v_real_or_implied in ('R', 'I', 'B') then
      v_valid_real_implied_arg := 1;
    else
      v_valid_real_implied_arg := 0;
    end if;
  end if;
  if v_valid_real_implied_arg = 0 then
    v_error_no := roles_service_constant.err_20024_no;
    v_error_msg := replace(roles_service_constant.err_20024_msg, 
                            '<arg_value>', ai_real_or_implied);
    raise_application_error(v_error_no, v_error_msg);
  end if;
  
  /* Make sure the given function_category does not exceed maximum length */
  if (length(ai_function_category) > 
      roles_service_constant.max_function_category_size) 
  then
    v_error_no := roles_service_constant.err_20028_no;
    v_error_msg := replace(roles_service_constant.err_20028_msg, 
                            '<function_category>', ai_function_category);
    raise_application_error(v_error_no, v_error_msg);
  else 
    v_function_category := upper(ai_function_category);
  end if;

  /* Make sure the given function_name does not exceed maximum length */
  if (length(ai_function_category) > 
      roles_service_constant.max_function_name_size) 
  then
    v_error_no := roles_service_constant.err_20029_no;
    v_error_msg := replace(roles_service_constant.err_20029_msg, 
                            '<function_name>', ai_function_name);
    raise_application_error(v_error_no, v_error_msg);
  else 
    v_function_category := upper(ai_function_category);
  end if;

  /* Make sure function_category and function_name exist */
  v_function_name := upper(ai_function_name);
  v_star_function_name := '*' || v_function_name;
  -- Look for the function in FUNCTION table
  select count(*) into v_found_real_function from function 
     where function_category = v_function_category
     and function_name = v_function_name;
  select count(*) into v_found_imp_function from external_function 
       where function_category = v_function_category
       and function_name = v_star_function_name;
  if v_found_real_function = 1 then
    -- Get function_id and qualifier_type from the FUNCTION table
    select function_id, qualifier_type
      into v_function_id_real, v_qualifier_type
      from function
      where function_category = v_function_category
      and function_name = v_function_name;
  end if;
  if v_found_imp_function = 1 then
    -- Get function_id and qualifier_type from the EXTERNAL_FUNCTION table
    select function_id, qualifier_type
      into v_function_id_imp, v_qualifier_type
      from external_function
      where function_category = v_function_category
      and function_name = v_star_function_name;
  end if;
  if v_found_real_function + v_found_imp_function = 0 then
    v_error_no := roles_service_constant.err_20021b_no;
    v_error_msg := roles_service_constant.err_20021b_msg;
    v_error_msg := replace(v_error_msg, '<function_name>', 
                          ai_function_name);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                          v_function_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;

  /* Make sure the server_user is authorized to act as a proxy for the
     given category.  */
  select rolesapi_is_user_authorized(ai_server_user, 
           roles_service_constant.service_function_name, 
           'CAT' || rtrim(v_function_category, ' '))
         into v_check_auth from dual;
  if (v_check_auth <> 'Y') then
    v_error_no := roles_service_constant.err_20003_no;
    v_error_msg := roles_service_constant.err_20003_msg;
    v_error_msg := replace(v_error_msg, '<server_id>', 
                           ai_server_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                           v_function_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;

  /* Make sure the proxy_user is authorized to check the authorization, 
     either because proxy_user = kerberos_name or because proxy_user 
     has the authority to look up authorizations in this category */
  if (v_proxy_user = v_server_user) then 
    v_check_auth := 'Y';
  elsif (v_proxy_user = v_kerberos_name) then 
    v_check_auth := 'Y';
  elsif (v_proxy_user is null) then
    v_check_auth := 'Y';
  else
    select rolesapi_is_user_authorized(v_proxy_user, 
             roles_service_constant.read_auth_function1, 
             'CAT' || rtrim(v_function_category, ' '))
           into v_check_auth from dual;
    if (v_check_auth <> 'Y') then
      select rolesapi_is_user_authorized(v_proxy_user, 
             roles_service_constant.read_auth_function2, 
             'CAT' || rtrim(v_function_category, ' '))
             into v_check_auth from dual;
    end if;
  end if;
  if (v_check_auth <> 'Y') then
    v_error_no := roles_service_constant.err_20005_no;
    v_error_msg := roles_service_constant.err_20005_msg;
    v_error_msg := replace(v_error_msg, '<proxy_user>', 
                          v_proxy_user);
    v_error_msg := replace(v_error_msg, '<function_category>', 
                          v_function_category);
    raise_application_error(v_error_no, v_error_msg);
  end if;

  /* Make sure we have a valid qualifier_code.  If not, then 
     raise an error condition.  */
  v_qualifier_code := upper(ai_qualifier_code);
  select count(*) into v_count 
    from qualifier
    where qualifier_type = v_qualifier_type
    and qualifier_code = v_qualifier_code;
  if v_count = 0 then
    v_error_no := roles_service_constant.err_20022b_no;
    v_error_msg := roles_service_constant.err_20022b_msg;
    v_error_msg := replace(v_error_msg, '<qualifier_code>', 
                          v_qualifier_code);
    v_error_msg := replace(v_error_msg, '<qualifier_type>', 
                          v_qualifier_type);
    raise_application_error(v_error_no, v_error_msg);
  end if;
  select qualifier_id into v_qualifier_id
    from qualifier
    where qualifier_type = v_qualifier_type
    and qualifier_code = v_qualifier_code;

  /* Set two variables for allowable values for AUTH_TYPE based on 
     the input argument REAL_OR_IMPLIED */
  if v_real_or_implied = 'R' then
    v_allow_auth_type1 := 'R';
    v_allow_auth_type2 := 'R';
  elsif v_real_or_implied = 'I' then
    v_allow_auth_type1 := 'E';  -- Note:  Implied auths are marked 'E' external
    v_allow_auth_type2 := 'E';
  else
    v_allow_auth_type1 := 'R';
    v_allow_auth_type2 := 'E';
  end if;

  /* Now, we'll actually check the authorization of user Kerberos_name.
     First, see if there is an authorization that exactly matches
     the kerberos_name, function_name, and qualifier_code specified */

  select count(*) into v_count from authorization2
    where kerberos_name = v_kerberos_name
    and function_name in (v_function_name, v_star_function_name)
    and function_category = v_function_category
    and qualifier_id = v_qualifier_id
    and do_function = 'Y'
    and sysdate between effective_date and nvl(expiration_date, sysdate)
    and auth_type in (v_allow_auth_type1, v_allow_auth_type2);

  IF v_count > 0 THEN
    RETURN 'Y';
  END IF;

  /* Next, see if there is a matching authorization with a qualifier
     that is a parent of the specified qualifier_code */

  select count(*) into v_count 
    from authorization2 a, qualifier_descendent qd
    where a.kerberos_name = v_kerberos_name
    and function_name in (v_function_name, v_star_function_name)
    and function_category = v_function_category
    and a.do_function = 'Y'
    and a.descend = 'Y'
    and sysdate between a.effective_date and nvl(a.expiration_date, sysdate)
    and qd.child_id = v_qualifier_id
    and a.qualifier_id = qd.parent_id
    and auth_type in (v_allow_auth_type1, v_allow_auth_type2);
  IF v_count > 0 THEN
    RETURN 'Y';
  END IF;

  /* At this point, we have not found any matching authorizations, either
     real or implied.  See if the function has any parent functions.
     If not, we're done.
  */
  select count(*) into v_count 
    from function_child 
    where child_id in (nvl(v_function_id_real, v_function_id_imp),
                       nvl(v_function_id_imp, v_function_id_real));
  if v_count = 0 then
    RETURN 'N';
  end if; 

  /* Third, see if there is an authorization that exactly matches
     the kerberos_name and qualifier_code specified 
     and a parent function */

  select count(*) into v_count from authorization2
    where kerberos_name = v_kerberos_name
    and function_id in 
    ( select parent_id from function_child 
      where child_id in (nvl(v_function_id_real, v_function_id_imp),
                        nvl(v_function_id_imp, v_function_id_real)) )
    and function_category = v_function_category
    and qualifier_id = v_qualifier_id
    and do_function = 'Y'
    and sysdate between effective_date and nvl(expiration_date, sysdate)
    and auth_type in (v_allow_auth_type1, v_allow_auth_type2);

  IF v_count > 0 THEN
    RETURN 'Y';
  END IF;

  /* Fourth, see if there is a matching authorization with a qualifier
     that is a parent of the specified qualifier_code and
     a function that is a parent of the specified function */
  select count(*) into v_count 
    from authorization2 a, qualifier_descendent qd
    where a.kerberos_name = v_kerberos_name
    and function_id in 
    ( select parent_id from function_child 
      where child_id in (nvl(v_function_id_real, v_function_id_imp),
                        nvl(v_function_id_imp, v_function_id_real)) )
    and function_category = v_function_category
    and a.do_function = 'Y'
    and a.descend = 'Y'
    and sysdate between a.effective_date and nvl(a.expiration_date, sysdate)
    and qd.child_id = v_qualifier_id
    and a.qualifier_id = qd.parent_id
    and auth_type in (v_allow_auth_type1, v_allow_auth_type2);
  IF v_count > 0 THEN
    RETURN 'Y';
  END IF;

  /* At this point, we know the user is not authorized. */
  RETURN 'N';

END is_user_authorized_extended;

/*****************************************************************************
*   Function GET_SQL_FRAGMENT
*   Given a criteria_id and a value, create a fragment of a SQL select
*   statement from the sql_fragment in the table criteria2.  If the
*   value given was '<me>', then fill this in with the proxy_user.
*
*   Returns the resulting SQL fragment.
*****************************************************************************/
FUNCTION get_sql_fragment
    (ai_proxy_user in string,
     ni_id in integer,
     ai_value in string)
    return varchar2
  is
  cond_fragment varchar2(512) := '';
  return_fragment varchar2(512) := '';
  v_value varchar2(255);
  replace_str varchar2(10) := '?';
  sub_str1 varchar2(10) := '';
  sub_str2 varchar2(10) := '''';

BEGIN
   v_value := ai_value;
   v_value := upper(replace(v_value, '<me>', ai_proxy_user));
   v_value := upper(replace(v_value, '<ME>', ai_proxy_user));
   select rtrim(ltrim(c.sql_fragment)) into cond_fragment 
     from criteria2 c where c.criteria_id = ni_id;
   if cond_fragment != 'NULL' then
     if instr(cond_fragment, '%?%') > 0 then
        replace_str := '%?%';
	sub_str1 := '%';
	sub_str2 := '%''';
     elsif instr(cond_fragment, '?%') > 0 then
	replace_str := '?%';
	sub_str2 := '%''';
     elsif instr(cond_fragment, '?') = 0 then
	return cond_fragment;
     end if;
     return_fragment := replace(cond_fragment, replace_str, 
                        '''' || sub_str1 || v_value || sub_str2);
  end if;
  return return_fragment;

END get_sql_fragment;

/*****************************************************************************
*   Function GET_VIEW_CATEGORY_LIST
*   Takes the server_user and proxy_user and finds a list of 
*   function categories for which both have at least auth viewing authority.
*   May return a null string if there are no categories.
*
*   Use 
*   SELECT ROLESSERV.GET_VIEW_CATEGORY_LIST(server_user, proxy_user)
*        FROM DUAL;
*   to get a string of categories for which the user is authorized to
*   view authorizations
*****************************************************************************/
FUNCTION get_view_category_list
    (ai_server_user in string,
     ai_proxy_user in string)
    return varchar2
  is
  v_server_user authorization.kerberos_name%type;
  v_proxy_user authorization.kerberos_name%type;
  v_function_category category.function_category%type;
  v_count number := 0;
  v_category_list varchar2(2000);

  CURSOR curs_get_cat_list1 (
	c_server_user	IN VARCHAR2,
	c_proxy_user	IN VARCHAR2
	)
   IS
     SELECT function_category from viewable_category
      where kerberos_name = c_proxy_user
     INTERSECT SELECT function_category from category 
      where rolesapi_is_user_authorized(c_server_user, 
                 roles_service_constant.service_function_name,
                 'CAT' || rtrim(function_category)) = 'Y';

  CURSOR curs_get_cat_list2 (
	c_proxy_user	IN VARCHAR2
	)
   IS
     SELECT function_category from viewable_category
      where kerberos_name = c_proxy_user;

BEGIN
  v_server_user := upper(ai_server_user);
  v_proxy_user := upper(ai_proxy_user);

  if ( nvl(v_server_user, v_proxy_user) = nvl(v_proxy_user, v_server_user) )
  then 
    v_proxy_user := nvl(v_proxy_user, v_server_user);
    OPEN curs_get_cat_list2(v_proxy_user);
    LOOP
      FETCH curs_get_cat_list2 INTO v_function_category;
      EXIT WHEN curs_get_cat_list2%NOTFOUND;
      if (v_count = 0) then
        v_category_list := '''' || v_function_category || '''';
      else
        v_category_list := v_category_list || ', ''' 
                           || v_function_category || '''';
      end if;
      v_count := v_count + 1;
    END LOOP;
    CLOSE curs_get_cat_list2;
  else
    OPEN curs_get_cat_list1(v_server_user, v_proxy_user);
    LOOP
      FETCH curs_get_cat_list1 INTO v_function_category;
      EXIT WHEN curs_get_cat_list1%NOTFOUND;
      if (v_count = 0) then
        v_category_list := '''' || v_function_category || '''';
      else
        v_category_list := v_category_list || ',''' 
                           || v_function_category || '''';
      end if;
      v_count := v_count + 1;
    END LOOP;
    CLOSE curs_get_cat_list1;
  end if;
  return v_category_list;

END get_view_category_list;

/*****************************************************************************
*   GET_AUTH_PERSON_SQL
*
*  Supply some input parameters, and the stored procedure will construct
*  and return a SELECT statement for returning authorizations.  This 
*  stored procedure should be called by another stored procedure that 
*  actually executes the SELECT statement (and returns a REF CURSOR).
*  If there are authorization or other errors, then ao_error_no
*  and ao_error_msg are set;  otherwise, ao_sql_statement is set.
*
*  Of the arguments:
*   ai_server_user   is the ID of the service running this procedure
*   ai_proxy_user     is the username of the Proxy user running this procedure
*   ai_kerberos_name  is the Kerberos name of the person whose authorizations
*                     are to be returned.  Required argument.
*   ai_function_category  is the function_category in which you want to 
*                         return the authorizations.  If null, and if 
*                         ai_opt_function_name and ai_opt_function_id 
*                         are also null, then the stored 
*                         procedure returns authorizations in all categories.
*                         Whatever category is picked or implied from
*                         function information, the ai_server_user and
*                         ai_proxy_user need appropriate viewing 
*                         authorizations or an error condition will be 
*                         raised.
*   ai_expand_qualifiers  is 'Y' if you want to list authorizations expanded
*                         by qualifier_child and function_child; 'N' if you
*                         only want to see actual authorizations
*   ai_is_active_now      is 'Y' if you only want to see active authorizations
*                         (current, and with do_function = 'Y')
*   -- the remaining input arguments are optional --
*   ai_opt_function_name  If ai_opt_function_name is supplied, then 
*                         ai_function_category must be supplied as well.
*                         If ai_opt_function_name is supplied, then 
*                         authorizations shown are limited to those for the 
*                         given function name
*   ai_opt_function_id    If function_id is supplied, then authorizations 
*                         are limited to those for the given function_id.
*                         It is intended that either function_name or 
*                         function name will be supplied, but not both; 
*                         however, no error condition will be raised if
*                         both are supplied and they do not match each other.
*   -- note: the intention is that one of the following combinations of     --
*   -- arguments will be supplied: (a) no qualifier_related arguments,      --
*   -- (b) ai_opt_qualifier_type and ai_opt_qualifier_type,                 --
*   -- (c) ai_opt_qualifier_id, (d) ai_opt_qualifier_type and               --
*   -- ai_opt_base_qual_code, (e) ai_opt_base_qual_id,                      --
*   -- (f) ai_opt_qualifier_type and ai_opt_parent_qual_code,               --
*   -- (g) ai_opt_parent_qual_id, (h) ai_opt_qualifier_type and             --
*   -- ai_opt_child_qual_code, or (i) ai_opt_child_qual_id.                 --
*   ai_opt_qualifier_type  If ai_opt_qualifier_type is supplied, then only
*                          authorizations for qualifiers of the given type
*                          will be returned.
*   ai_opt_qualifier_code  If ai_opt_qualifier_code is supplied, then 
*                          either ai_opt_function_name, ai_opt_function_id,
*                          or ai_opt_qualifier_type must be supplied as well.
*                          If ai_opt_qualifier_code is supplied, then
*                          only real or implied authorizations for the 
*                          given qualifier will be returned.
*   ai_opt_qualifier_id    If ai_opt_qualifier_id is supplied, then 
*                          only real or implied authorizations for the given
*                          qualifier will be returned.
*   ai_opt_base_qual_code  If ai_opt_qualifier_code is supplied, then 
*                          either ai_opt_function_name, ai_opt_function_id,
*                          or ai_opt_qualifier_type must be supplied as well.
*                          If ai_opt_qualifier_code is supplied, then
*                          only a real authorization for this qualifier_code 
*                          or expanded authorizations for children of this
*                          qualifier will be returned.
*   ai_opt_base_qual_id   If ai_opt_qualifier_id is supplied, then
*                          only a real authorization for this qualifier_code 
*                          or expanded authorizations for children of this
*                          qualifier will be returned.
*   ai_opt_parent_qual_code  If ai_opt_parent_qual_code is supplied, then
*                          either ai_opt_function_name, ai_opt_function_id,
*                          or ai_opt_qualifier_type must be supplied as well.
*                          If ai_opt_parent_qual_code is supplied, then 
*                          the only authorizations shown will be those whose 
*                          base qualifier_id is a descendent (child) of 
*                          ai_opt_parent_qual_code.  This would allow you
*                          to show only authorizations within a given branch
*                          of a qualifier hierarchy.
*   ai_opt_parent_qual_id  If ai_opt_parent_qual_id is supplied, then 
*                          the only authorizations shown will be those whose 
*                          base qualifier_id is a descendent (child) of 
*                          ai_opt_parent_qual_id.  This would allow you
*                          to show only authorizations within a given branch
*                          of a qualifier hierarchy.
*   ai_opt_child_qual_code If ai_opt_child_qual_code is supplied, then
*                          either ai_opt_function_name, ai_opt_function_id,
*                          or ai_opt_qualifier_type must be supplied as well.
*                          If ai_opt_child_qual_code is supplied, then 
*                          the only authorizations shown will be those whose 
*                          base qualifier_id is an ancestor (parent) of 
*                          ai_opt_child_qual_code.  This would allow you
*                          to find which authorization implies an 
*                          authorization for a specific child qualifier.
*   ai_opt_child_qual_id   If ai_opt_child_qual_id is supplied, then 
*                          the only authorizations shown will be those whose 
*                          base qualifier_id is an ancestor (parent) of 
*                          ai_opt_child_qual_id.  This would allow you
*                          to find which authorization implies an 
*                          authorization for a specific child qualifier.
*                        
*****************************************************************************/
  PROCEDURE get_auth_person_sql
      (ai_server_user in VARCHAR2,
       ai_proxy_user in VARCHAR2,
       ai_kerberos_name in VARCHAR2,
       ai_function_category IN VARCHAR2, 
       ai_expand_qualifiers IN VARCHAR2, 
       ai_is_active_now IN VARCHAR2, 
       ai_opt_function_name IN VARCHAR2, 
       ai_opt_function_id IN VARCHAR2, 
       ai_opt_qualifier_type IN VARCHAR2, 
       ai_opt_qualifier_code IN VARCHAR2, 
       ai_opt_qualifier_id IN VARCHAR2, 
       ai_opt_base_qual_code IN VARCHAR2,
       ai_opt_base_qual_id IN VARCHAR2,
       ai_opt_parent_qual_code IN VARCHAR2,
       ai_opt_parent_qual_id IN VARCHAR2,
       ai_opt_child_qual_code IN VARCHAR2,
       ai_opt_child_qual_id IN VARCHAR2,
       ao_error_no OUT INTEGER,
       ao_error_msg OUT VARCHAR2,
       ao_sql_statement OUT VARCHAR2)
  is
  v_kerberos_name authorization.kerberos_name%type;
  v_server_user authorization.kerberos_name%type;
  v_proxy_user authorization.kerberos_name%type;
  v_function_id function.function_id%type;
  v_function_category function.function_category%type;
  v_eval_function_category function.function_category%type;
  v_function_name function.function_name%type;
  v_function_name_wildcard function.function_name%type;  /**** Add 6/6/08 ***/
  v_qualifier_type function.qualifier_type%type;
  v_qualifier_code authorization.qualifier_code%type;
  v_qualifier_id authorization.qualifier_id%type;
  v_error_msg varchar2(255);
  v_error_no integer;
  v_count integer;
  v_check_auth varchar2(1);
  v_location varchar2(2);
  outstring VARCHAR2(10000) := '';
  /*** "Where" phrases to be used for constructing the SELECT statement ***/
  c_is_active_now_phrase VARCHAR2(200) := 
                'a.do_function = ''Y'' and sysdate between a.effective_date'
                || ' and nvl(a.expiration_date,sysdate)'; 
  c_function_category_phrase VARCHAR2(200) := 
          'a.function_category = ''' || upper(ai_function_category) || '''';
  c_function_name_phrase VARCHAR2(200) :=      
                'a.function_name = ''' || upper(ai_opt_function_name) || '''';
  c_function_id_phrase VARCHAR2(200) := 
                'a.function_id = ''' || ai_opt_function_id || '''';
  c_kerberos_name_phrase VARCHAR2(200) := 
                'a.kerberos_name = ''' || upper(ai_kerberos_name) || '''';
  v_select_fields VARCHAR2(2000) := 
    'select a.kerberos_name,  a.function_category, a.function_name,'
     || ' a.qualifier_code, a.qualifier_name, '
     || ' auth_sf_is_auth_active(a.do_function, a.effective_date,'
     || '     a.expiration_date) is_active_now,'
     || ' decode(a.grant_and_view, ''GD'', ''G'', ''N'') grant_authorization,'
     || ' a.authorization_id, a.function_id, a.qualifier_id, '
     || ' a.do_function, a.effective_date, a.expiration_date';
  v_from1f VARCHAR2(250) := ' from authorization a'; 
  v_from2f VARCHAR2(250) :=
       ' from qualifier q, qualifier_descendent qd, authorization a'; 
  v_from1s VARCHAR2(250) := ' from authorization a, qualifier q1'; 
  v_from2s VARCHAR2(250) := 
       ' from authorization a, qualifier q1, qualifier_descendent qd,' 
    || ' qualifier q2'; 
  v_from1w VARCHAR2(250) := ' from authorization a, person p'; 

  v_from2w VARCHAR2(250) := 
       ' from qualifier q, qualifier_descendent qd, authorization a,' 
    || ' person p'; 
  v_counter integer;
  v_select_fields_2s VARCHAR2(2000); 
  v_criteria1 VARCHAR2(2000) := ''; 
  v_criteria2 VARCHAR2(2000) := ''; 
  v_criteria12 VARCHAR2(5000) := ''; 
BEGIN
  v_select_fields_2s := replace(v_select_fields, 'a.qualifier_code',
                                                 'q2.qualifier_code');
  v_select_fields_2s := replace(v_select_fields_2s, 'a.qualifier_name',
                                                    'q2.qualifier_name');
  v_select_fields_2s := replace(v_select_fields_2s, 'a.qualifier_id',
                                                    'q2.qualifier_id');

  v_kerberos_name := upper(ai_kerberos_name);
  v_server_user := upper(ai_server_user);
  v_proxy_user := upper(ai_proxy_user);
  v_location := 'A';

  /* Make sure the given function_category does not exceed maximum length */
  if (length(ai_function_category) > 
      roles_service_constant.max_function_category_size) then
    v_error_no := roles_service_constant.err_20028_no;
    v_error_msg := replace(roles_service_constant.err_20028_msg, 
                            '<function_category>', ai_function_category);
  else 
    v_function_category := upper(ai_function_category);
  end if;

  /* Make sure the given function_name does not exceed maximum length */
  if (length(ai_opt_function_name) > 
      roles_service_constant.max_function_name_size) then
    v_error_no := roles_service_constant.err_20029_no;
    v_error_msg := replace(roles_service_constant.err_20029_msg, 
                            '<function_name>', ai_opt_function_name);
  else 
    /***** Add some code 6/6/2008 *****/
    --v_function_name := upper(ai_opt_function_name);
    if (substr(ai_opt_function_name, -2, 2) = '\*') then 
      v_function_name := 
        substr(upper(ai_opt_function_name), 1, length(ai_opt_function_name)-2)
        || '*';
      c_function_name_phrase :=      
                'a.function_name = ''' || v_function_name || '''';
    elsif (substr(ai_opt_function_name, -1, 1) = '*') then 
      v_function_name_wildcard := 
        substr(upper(ai_opt_function_name), 1, length(ai_opt_function_name)-1)
        || '%';
      c_function_name_phrase :=      
                'a.function_name like ''' || v_function_name_wildcard || '''';
    else
      v_function_name := upper(ai_opt_function_name);
      c_function_name_phrase :=      
                'a.function_name = ''' || v_function_name || '''';
    end if;
    /***** End add some code 6/6/2008 *****/
  end if;

  /* Make sure the Kerberos_name field has been specified */
  if (v_kerberos_name is null) then
    v_error_no := roles_service_constant.err_20030_no;
    v_error_msg := roles_service_constant.err_20030_msg;
  end if;

  /* If function_name has been specified, but not function_category, 
     then return an error messsage */
  if (v_error_no is null) then 
    if (ai_function_category is null and v_function_name is not null) then
      v_error_no := roles_service_constant.err_20027_no;
      v_error_msg := roles_service_constant.err_20027_msg;
    end if;
    /**** Add 6/6/2008 ****/
    if (ai_function_category is null and v_function_name_wildcard is not null) 
    then
      v_error_no := roles_service_constant.err_20027_no;
      v_error_msg := roles_service_constant.err_20027_msg;
    end if;
    /**** End add 6/6/2008 ****/
  end if;
  v_location := 'B';

  /* If function_id has been specified but it is not a valid number, 
     then return an error message */
  if (v_error_no is null) then 
    if (ai_opt_function_id is not null) then
      if (translate(ai_opt_function_id, '0123456789', '0000000000') <> 
          substr('00000000000000000000', 1, length(ai_opt_function_id)) )
      then
        /* Raise error condition */
        v_error_no := roles_service_constant.err_20021a_no;
        v_error_msg := replace(roles_service_constant.err_20021a_msg, 
                              '<function_id>', ai_opt_function_id);
      else
        v_function_id := to_number(ai_opt_function_id);
      end if;
    end if;
  end if;

  /* If qualifier_id has been specified but it is not a valid number, 
     then return an error message */
  if (v_error_no is null) then 
    if (ai_opt_qualifier_id is not null) then
      if (translate(ai_opt_function_id, '0123456789', '0000000000') <> 
          substr('00000000000000000000', 1, length(ai_opt_qualifier_id)) )
      then
        /* Raise error condition */
        v_error_no := roles_service_constant.err_20022a_no;
        v_error_msg := roles_service_constant.err_20022a_msg;
        v_error_msg := replace(v_error_msg, '<qualifier_id>', 
                               ai_opt_qualifier_id);
        v_error_msg := replace(v_error_msg, '<qualifier_type>', 
                               '(any)');
      else
        v_qualifier_id := to_number(ai_opt_qualifier_id);
      end if;
    end if;
  end if;

  /* If we have sufficient information, then get the qualifier_type */
  /* If the qualifier_type is specified, then set v_qualifier_type */
  /****** fix 6/6/2008 *****/
  --if (ai_opt_qualifier_type is not null) then
  --    if (translate(ai_opt_qualifier_type, '0123456789', '0000000000') <> 
  --        substr('00000000000000000000', 1, length(ai_opt_qualifier_type)) )
  /****** end fix *****/
  if (ai_opt_qualifier_type is not null) then
      if (length(ai_opt_qualifier_type) > 4)
      then
        /* Raise error condition */
        v_error_no := roles_service_constant.err_20031_no;
        v_error_msg := replace(roles_service_constant.err_20031_msg, 
                              '<qualifier_type>', ai_opt_qualifier_type);
      else
        v_qualifier_type := ai_opt_qualifier_type;
      end if;
  /* else if function_name is specified, then get qualifier_type from */
  /* function table */
  /***** Adjust code 6/6/2008 *****/
  --elsif (ai_opt_function_name is not null) then
  elsif (v_function_name is not null) then
  /***** End adjust code 6/6/2008 *****/
    select count(*) into v_count from function 
       where function_category = upper(ai_function_category)
       and function_name = upper(ai_opt_function_name);
    if v_count = 0 then
      v_error_no := roles_service_constant.err_20021b_no;
      v_error_msg := roles_service_constant.err_20021b_msg;
      v_error_msg := replace(v_error_msg, '<function_name>', 
                            ai_opt_function_name);
      v_error_msg := replace(v_error_msg, '<function_category>', 
                            ai_function_category);
    end if;
    select function_id, qualifier_type
      into v_function_id, v_qualifier_type
      from function
      where function_category = upper(ai_function_category)
      and function_name = v_function_name;              /*** Adjust 6/6/8 ***/
    --and function_name = upper(ai_opt_function_name);  /*** Adjust 6/6/8 ***/
  /* else if function_id is specified, then get qualifier_type from */
  /* function table */
  elsif (v_function_id is not null) then
    select qualifier_type
      into v_qualifier_type
      from function
      where function_id = v_function_id;
  /* else if qualifier_id is specified, then get qualifier_type from */
  /*      qualifier table */
  elsif (v_qualifier_id is not null) then
    select qualifier_type
      into v_qualifier_type
      from qualifier
      where qualifier_id = v_qualifier_id;
  end if;
  
  /* If qualifier_code has been specified, then make sure either 
     function_name, function_id, or qualifier_type has been specified */
  if (ai_opt_qualifier_code is not null and v_qualifier_type is null) then
      v_error_no := roles_service_constant.err_20023_no;
      v_error_msg := replace(roles_service_constant.err_20023_msg, 
                             '<argument_name>', 'Qualifier Code');
  end if;

  /* If base_qualifier_code has been specified, then make sure either 
     function_name, function_id, or qualifier_type has been specified */
  if (ai_opt_base_qual_code is not null and v_qualifier_type is null) then
      v_error_no := roles_service_constant.err_20023_no;
      v_error_msg := replace(roles_service_constant.err_20023_msg, 
                             '<argument_name>', 'Base Qualifier Code');
  end if;

  /* If parent_qualifier_code has been specified, then make sure either 
     function_name, function_id, or qualifier_type has been specified */
  if (ai_opt_parent_qual_code is not null and v_qualifier_type is null) then
      v_error_no := roles_service_constant.err_20023_no;
      v_error_msg := replace(roles_service_constant.err_20023_msg, 
                             '<argument_name>', 'Parent Qualifier Code');
  end if;

  /* If child_qualifier_code has been specified, then make sure either 
     function_name, function_id, or qualifier_type has been specified */
  if (ai_opt_child_qual_code is not null and v_qualifier_type is null) then
      v_error_no := roles_service_constant.err_20023_no;
      v_error_msg := replace(roles_service_constant.err_20023_msg, 
                             '<argument_name>', 'Child Qualifier Code');
  end if;

  /* We have no errors yet. Check authorizations and keep processing. */
  
  if (v_error_no is null) then 
    /* Determine what function_category to use for evaluating 
       authorizations */
    v_function_category := upper(ai_function_category);
    if (v_function_category is not null) then
      v_eval_function_category := v_function_category;
    elsif (v_function_id is not null) then
      select count(*) into v_count from function 
        where function_id = v_function_id;
      if v_count = 0 then
        v_error_no := roles_service_constant.err_20021a_no;
        v_error_msg := replace(roles_service_constant.err_20021a_msg, 
                              '<function_id>', ai_opt_function_id);
      else 
        select function_category into v_eval_function_category
          from function 
          where function_id = v_function_id;
      end if;
    end if;
  end if;
  v_location := 'D';

  /* At this point, we should either have a function category in 
     variable v_eval_function_category, or we should have an error 
     code and error message set in v_error_no and v_error_msg. 
     If we have a function_category, then check the authorizations 
     of the server_user and proxy_user. */
  if (v_error_no is null) then 
    /* Make sure the server_user is authorized to act as a proxy for the
       given category.  */
    select rolesapi_is_user_authorized(ai_server_user, 
             roles_service_constant.service_function_name, 
             'CAT' || rtrim(v_eval_function_category, ' '))
           into v_check_auth from dual;
    if (v_check_auth <> 'Y') then
      v_error_no := roles_service_constant.err_20003_no;
      v_error_msg := roles_service_constant.err_20003_msg;
      v_error_msg := replace(v_error_msg, '<server_id>', 
                             ai_server_user);
      v_error_msg := replace(v_error_msg, '<function_category>', 
                             v_eval_function_category);
    else
      /* Make sure the proxy_user is authorized to check the authorization, 
         either because proxy_user = kerberos_name or because proxy_user 
         has the authority to look up authorizations in this category */
      if (v_proxy_user = v_server_user) then 
        v_check_auth := 'Y';
      elsif (v_proxy_user = v_kerberos_name) then 
        v_check_auth := 'Y';
      else
        select rolesapi_is_user_authorized(v_proxy_user, 
                 roles_service_constant.read_auth_function1, 
                 'CAT' || rtrim(v_eval_function_category, ' '))
               into v_check_auth from dual;
        if (v_check_auth <> 'Y') then
          select rolesapi_is_user_authorized(v_proxy_user, 
                 roles_service_constant.read_auth_function2, 
                 'CAT' || rtrim(v_eval_function_category, ' '))
                 into v_check_auth from dual;
        end if;
      end if;
      if (v_check_auth <> 'Y') then
        v_error_no := roles_service_constant.err_20005_no;
        v_error_msg := roles_service_constant.err_20005_msg;
        v_error_msg := replace(v_error_msg, '<proxy_user>', 
                              v_proxy_user);
        v_error_msg := replace(v_error_msg, '<function_category>', 
                              v_eval_function_category);
      end if;
    end if;
  end if;
  v_location := 'E';

  /* If we have not recorded an error in v_error_no and v_error_msg,
     then keep going, and generate the select statement */
  if (v_error_no is null) then

    /* 
    **  Build the WHERE clauses.
    */
    v_criteria1 := 'WHERE q1.qualifier_id = a.qualifier_id';
    v_criteria2 := 'WHERE q1.qualifier_id = a.qualifier_id'
                 || ' and a.descend = ''Y'''
                 || ' and qd.parent_id = a.qualifier_id'
                 || ' and q2.qualifier_id = qd.child_id';
    v_criteria12 := '';
    if ai_is_active_now in ('y', 'Y') then 
      v_criteria12 := v_criteria12 || ' and ' || c_is_active_now_phrase; 
    end if;
    if ai_function_category is not null then 
      v_criteria12 := v_criteria12 || ' and ' || c_function_category_phrase;
    end if;
    --if ai_opt_function_name is not null then    /*** Adjust 6/6/8 ***/
    if (v_function_name is not null) then         /*** Adjust 6/6/8 ***/
      v_criteria12 := v_criteria12 || ' and ' || c_function_name_phrase;
    end if;
    /***** Add 6/6/2008 *****/
    if v_function_name_wildcard is not null then
      v_criteria12 := v_criteria12 || ' and ' || c_function_name_phrase;
    end if;
    /***** End add 6/6/2008 *****/
    if ai_opt_function_id is not null then 
      v_criteria12 := v_criteria12 || ' and ' || c_function_id_phrase; 
    end if;
    if ai_opt_qualifier_type is not null then 
      v_criteria12 := v_criteria12 || ' and ' ||
                 'q1.qualifier_type = ''' || ai_opt_qualifier_type || ''''; 
    end if;
    if ai_opt_qualifier_code is not null then
    /***** Fix 6/6/2008 *****/
      --v_criteria1 := v_criteria12 || ' and ' ||
      --           'q1.qualifier_code = ''' || ai_opt_qualifier_code || '''';
      --v_criteria2 := v_criteria12 || ' and ' ||
      --           'q2.qualifier_code = ''' || ai_opt_qualifier_code || '''';
      v_criteria1 := v_criteria1 || ' and ' ||
                 'q1.qualifier_code = ''' || ai_opt_qualifier_code || '''';
      v_criteria2 := v_criteria2 || ' and ' ||
                 'q2.qualifier_code = ''' || ai_opt_qualifier_code || '''';
    /***** Fix 6/6/2008 *****/
    end if;
    if ai_opt_qualifier_id is not null then
      v_criteria1 := v_criteria1 || ' and ' ||
                 'q1.qualifier_id = ''' || ai_opt_qualifier_id || '''';
      v_criteria2 := v_criteria2 || ' and ' ||
                 'q2.qualifier_id = ''' || ai_opt_qualifier_id || '''';
    end if;
    if ai_opt_base_qual_code is not null then
      v_criteria12 := v_criteria12 || ' and ' ||
                 'q1.qualifier_code = ''' || ai_opt_qualifier_code || '''';
    end if;
    if ai_opt_base_qual_id is not null then
      v_criteria12 := v_criteria1 || ' and ' ||
                 'a.qualifier_id = ''' || ai_opt_qualifier_id || '''';
    end if;
    if ai_kerberos_name is not null then
      v_criteria12 := v_criteria12 || ' and ' || c_kerberos_name_phrase;
    end if;

    /*
    **  Now, put the pieces together 
    */
    outstring := v_select_fields || ' ' || v_from1s || ' ' || v_criteria1
                                 || v_criteria12;
    if ai_expand_qualifiers in ('y', 'Y') then
       outstring := outstring || ' UNION ' || v_select_fields_2s
                    || ' ' || v_from2s || ' ' || v_criteria2 || v_criteria12;
    end if;
    ao_sql_statement := outstring;

  /* If we have recorded an error in v_error_no and v_error_msg, then 
     move these into the output arguments ao_error_no and ao_error_msg */
  else   -- if (v_error_no is not null)
    ao_error_no := v_error_no;
    ao_error_msg := v_error_msg;
    v_location := 'E1';
  end if;
  v_location := 'F';

  --EXCEPTION
  --  WHEN OTHERS THEN
  --    v_error_no := -20001;
  --    v_error_msg := 'Location -' || v_location; 
  --    raise_application_error(v_error_no, v_error_msg);

end get_auth_person_sql;

/*****************************************************************************
*   GET_AUTH_PERSON_SQL2
*
*  Supply some input parameters, and the stored procedure will construct
*  and return a SELECT statement for returning authorizations.  This 
*  stored procedure should be called by another stored procedure that 
*  actually executes the SELECT statement (and returns a REF CURSOR).
*  If there are authorization or other errors, then ao_error_no
*  and ao_error_msg are set;  otherwise, ao_sql_statement is set.
*
*  Of the arguments:
*   ai_server_user   is the ID of the service running this procedure
*   ai_proxy_user     is the username of the Proxy user running this procedure
*   ai_kerberos_name  is the Kerberos name of the person whose authorizations
*                     are to be returned.  Required argument.
*   ai_function_category  is the function_category in which you want to 
*                         return the authorizations.  If null, and if 
*                         ai_opt_function_name and ai_opt_function_id 
*                         are also null, then the stored 
*                         procedure returns authorizations in all categories.
*                         Whatever category is picked or implied from
*                         function information, the ai_server_user and
*                         ai_proxy_user need appropriate viewing 
*                         authorizations or an error condition will be 
*                         raised.
*   ai_expand_qualifiers  is 'Y' if you want to list authorizations expanded
*                         by qualifier_child and function_child; 'N' if you
*                         only want to see actual authorizations
*   ai_is_active_now      is 'Y' if you only want to see active authorizations
*                         (current, and with do_function = 'Y')
*   -- the remaining input arguments are optional --
*   ai_opt_function_name  If ai_opt_function_name is supplied, then 
*                         ai_function_category must be supplied as well.
*                         If ai_opt_function_name is supplied, then 
*                         authorizations shown are limited to those for the 
*                         given function name
*   ai_opt_function_id    If function_id is supplied, then authorizations 
*                         are limited to those for the given function_id.
*                         It is intended that either function_name or 
*                         function name will be supplied, but not both; 
*                         however, no error condition will be raised if
*                         both are supplied and they do not match each other.
*   -- note: the intention is that one of the following combinations of     --
*   -- arguments will be supplied: (a) no qualifier_related arguments,      --
*   -- (b) ai_opt_qualifier_type and ai_opt_qualifier_type,                 --
*   -- (c) ai_opt_qualifier_id, (d) ai_opt_qualifier_type and               --
*   -- ai_opt_base_qual_code, (e) ai_opt_base_qual_id,                      --
*   -- (f) ai_opt_qualifier_type and ai_opt_parent_qual_code,               --
*   -- (g) ai_opt_parent_qual_id, (h) ai_opt_qualifier_type and             --
*   -- ai_opt_child_qual_code, or (i) ai_opt_child_qual_id.                 --
*   ai_opt_qualifier_type  If ai_opt_qualifier_type is supplied, then only
*                          authorizations for qualifiers of the given type
*                          will be returned.
*   ai_opt_qualifier_code  If ai_opt_qualifier_code is supplied, then 
*                          either ai_opt_function_name, ai_opt_function_id,
*                          or ai_opt_qualifier_type must be supplied as well.
*                          If ai_opt_qualifier_code is supplied, then
*                          only real or implied authorizations for the 
*                          given qualifier will be returned.
*   ai_opt_qualifier_id    If ai_opt_qualifier_id is supplied, then 
*                          only real or implied authorizations for the given
*                          qualifier will be returned.
*   ai_opt_base_qual_code  If ai_opt_qualifier_code is supplied, then 
*                          either ai_opt_function_name, ai_opt_function_id,
*                          or ai_opt_qualifier_type must be supplied as well.
*                          If ai_opt_qualifier_code is supplied, then
*                          only a real authorization for this qualifier_code 
*                          or expanded authorizations for children of this
*                          qualifier will be returned.
*   ai_opt_base_qual_id   If ai_opt_qualifier_id is supplied, then
*                          only a real authorization for this qualifier_code 
*                          or expanded authorizations for children of this
*                          qualifier will be returned.
*   ai_opt_parent_qual_code  If ai_opt_parent_qual_code is supplied, then
*                          either ai_opt_function_name, ai_opt_function_id,
*                          or ai_opt_qualifier_type must be supplied as well.
*                          If ai_opt_parent_qual_code is supplied, then 
*                          the only authorizations shown will be those whose 
*                          base qualifier_id is a descendent (child) of 
*                          ai_opt_parent_qual_code.  This would allow you
*                          to show only authorizations within a given branch
*                          of a qualifier hierarchy.
*   ai_opt_parent_qual_id  If ai_opt_parent_qual_id is supplied, then 
*                          the only authorizations shown will be those whose 
*                          base qualifier_id is a descendent (child) of 
*                          ai_opt_parent_qual_id.  This would allow you
*                          to show only authorizations within a given branch
*                          of a qualifier hierarchy.
*   ai_opt_child_qual_code If ai_opt_child_qual_code is supplied, then
*                          either ai_opt_function_name, ai_opt_function_id,
*                          or ai_opt_qualifier_type must be supplied as well.
*                          If ai_opt_child_qual_code is supplied, then 
*                          the only authorizations shown will be those whose 
*                          base qualifier_id is an ancestor (parent) of 
*                          ai_opt_child_qual_code.  This would allow you
*                          to find which authorization implies an 
*                          authorization for a specific child qualifier.
*   ai_opt_child_qual_id   If ai_opt_child_qual_id is supplied, then 
*                          the only authorizations shown will be those whose 
*                          base qualifier_id is an ancestor (parent) of 
*                          ai_opt_child_qual_id.  This would allow you
*                          to find which authorization implies an 
*                          authorization for a specific child qualifier.
*                        
*****************************************************************************/
  PROCEDURE get_auth_person_sql2
      (ai_server_user in VARCHAR2,
       ai_proxy_user in VARCHAR2,
       ai_kerberos_name in VARCHAR2,
       ai_function_category IN VARCHAR2, 
       ai_expand_qualifiers IN VARCHAR2, 
       ai_is_active_now IN VARCHAR2, 
       ai_opt_function_name IN VARCHAR2, 
       ai_opt_function_id IN VARCHAR2, 
       ai_opt_qualifier_type IN VARCHAR2, 
       ai_opt_qualifier_code IN VARCHAR2, 
       ai_opt_qualifier_id IN VARCHAR2, 
       ai_opt_base_qual_code IN VARCHAR2,
       ai_opt_base_qual_id IN VARCHAR2,
       ai_opt_parent_qual_code IN VARCHAR2,
       ai_opt_parent_qual_id IN VARCHAR2,
       ai_opt_child_qual_code IN VARCHAR2,
       ai_opt_child_qual_id IN VARCHAR2,
       ao_error_no OUT INTEGER,
       ao_error_msg OUT VARCHAR2,
       ao_sql_statement OUT VARCHAR2)
  is
  v_kerberos_name authorization.kerberos_name%type;
  v_server_user authorization.kerberos_name%type;
  v_proxy_user authorization.kerberos_name%type;
  v_function_id function.function_id%type;
  v_function_category function.function_category%type;
  v_eval_function_category function.function_category%type;
  v_function_name function.function_name%type;
  v_function_name_wildcard function.function_name%type;  /**** Add 6/6/08 ***/
  v_qualifier_type function.qualifier_type%type;
  v_qualifier_code authorization.qualifier_code%type;
  v_qualifier_id authorization.qualifier_id%type;
  v_error_msg varchar2(255);
  v_error_no integer;
  v_count integer;
  v_check_auth varchar2(1);
  v_location varchar2(2);
  outstring VARCHAR2(10000) := '';
  /*** "Where" phrases to be used for constructing the SELECT statement ***/
  c_is_active_now_phrase VARCHAR2(200) := 
                'a.do_function = ''Y'' and sysdate between a.effective_date'
                || ' and nvl(a.expiration_date,sysdate)'; 
  c_function_category_phrase VARCHAR2(200) := 
          'a.function_category = ''' || upper(ai_function_category) || '''';
  c_function_name_phrase VARCHAR2(200) :=      
                'a.function_name = ''' || upper(ai_opt_function_name) || '''';
  c_function_id_phrase VARCHAR2(200) := 
                'a.function_id = ''' || ai_opt_function_id || '''';
  c_kerberos_name_phrase VARCHAR2(200) := 
                'a.kerberos_name = ''' || upper(ai_kerberos_name) || '''';
  v_select_fields VARCHAR2(2000) := 
    'select a.kerberos_name,  a.function_category, a.function_name,'
     || ' a.qualifier_code, nvl(a.qualifier_name, '' '') qualifier_name, '
     || ' auth_sf_is_auth_active(a.do_function, a.effective_date,'
     || '     a.expiration_date) is_active_now,'
     || ' decode(a.grant_and_view, ''GD'', ''G'', ''N'') grant_authorization,'
     || ' a.authorization_id, a.function_id, a.qualifier_id, '
     || ' a.do_function, a.effective_date, a.expiration_date, '
     || ' a.modified_by, a.modified_date, q1.qualifier_type'; --Changed 12/4/07
  --v_from1f VARCHAR2(250) := ' from authorization a'; 
  --v_from2f VARCHAR2(250) :=
  --  ' from qualifier q, qualifier_descendent qd, authorization a'; 
  v_from1s VARCHAR2(250) := ' from authorization a, qualifier q1'; 
  v_from2s VARCHAR2(250) := 
       ' from authorization a, qualifier q1, qualifier_descendent qd,' 
    || ' qualifier q2'; 
  --v_from1w VARCHAR2(250) := ' from authorization a, person p'; 

  --v_from2w VARCHAR2(250) := 
  --     ' from qualifier q, qualifier_descendent qd, authorization a,' 
  --  || ' person p'; 
  v_counter integer;
  v_select_fields_2s VARCHAR2(2000); 
  v_criteria1 VARCHAR2(2000) := ''; 
  v_criteria2 VARCHAR2(2000) := ''; 
  v_criteria12 VARCHAR2(5000) := ''; 
  v_category_string VARCHAR2(2000) := '';
  v_cat_criteria VARCHAR2(2040) := '';
BEGIN
  v_select_fields_2s := replace(v_select_fields, 'a.qualifier_code',
                                                 'q2.qualifier_code');
  v_select_fields_2s := replace(v_select_fields_2s, 'a.qualifier_name',
                                                    'q2.qualifier_name');
  v_select_fields_2s := replace(v_select_fields_2s, 'a.qualifier_id',
                                                    'q2.qualifier_id');

  v_kerberos_name := upper(ai_kerberos_name);
  v_server_user := upper(ai_server_user);
  v_proxy_user := upper(ai_proxy_user);
  v_location := 'A';

  /* Make sure the given function_category does not exceed maximum length */
  if (length(ai_function_category) > 
      roles_service_constant.max_function_category_size) then
    v_error_no := roles_service_constant.err_20028_no;
    v_error_msg := replace(roles_service_constant.err_20028_msg, 
                            '<function_category>', ai_function_category);
  else 
    v_function_category := upper(ai_function_category);
  end if;

  /* Make sure the given function_name does not exceed maximum length */
  if (length(ai_opt_function_name) > 
      roles_service_constant.max_function_name_size) then
    v_error_no := roles_service_constant.err_20029_no;
    v_error_msg := replace(roles_service_constant.err_20029_msg, 
                            '<function_name>', ai_opt_function_name);
  else 
    /***** Add some code 6/6/2008 *****/
    --v_function_name := upper(ai_opt_function_name);
    if (substr(ai_opt_function_name, -2, 2) = '\*') then 
      v_function_name := 
        substr(upper(ai_opt_function_name), 1, length(ai_opt_function_name)-2)
        || '*';
      c_function_name_phrase :=      
                'a.function_name = ''' || v_function_name || '''';
    elsif (substr(ai_opt_function_name, -1, 1) = '*') then 
      v_function_name_wildcard := 
        substr(upper(ai_opt_function_name), 1, length(ai_opt_function_name)-1)
        || '%';
      c_function_name_phrase :=      
                'a.function_name like ''' || v_function_name_wildcard || '''';
    else
      v_function_name := upper(ai_opt_function_name);
      c_function_name_phrase :=      
                'a.function_name = ''' || v_function_name || '''';
    end if;
    /***** End add some code 6/6/2008 *****/
  end if;

  /* Make sure the Kerberos_name field has been specified */
  if (v_kerberos_name is null) then
    v_error_no := roles_service_constant.err_20030_no;
    v_error_msg := roles_service_constant.err_20030_msg;
  end if;

  /* If function_name has been specified, but not function_category, 
     then return an error messsage */
  if (v_error_no is null) then 
    if (ai_function_category is null and v_function_name is not null) then
      v_error_no := roles_service_constant.err_20027_no;
      v_error_msg := roles_service_constant.err_20027_msg;
    end if;
    /**** Add 6/6/2008 ****/
    if (ai_function_category is null and v_function_name_wildcard is not null) 
    then
      v_error_no := roles_service_constant.err_20027_no;
      v_error_msg := roles_service_constant.err_20027_msg;
    end if;
    /**** End add 6/6/2008 ****/
  end if;
  v_location := 'B';

  /* If function_id has been specified but it is not a valid number, 
     then return an error message */
  if (v_error_no is null) then 
    if (ai_opt_function_id is not null) then
      if (translate(ai_opt_function_id, '0123456789', '0000000000') <> 
          substr('00000000000000000000', 1, length(ai_opt_function_id)) )
      then
        /* Raise error condition */
        v_error_no := roles_service_constant.err_20021a_no;
        v_error_msg := replace(roles_service_constant.err_20021a_msg, 
                              '<function_id>', ai_opt_function_id);
      else
        v_function_id := to_number(ai_opt_function_id);
      end if;
    end if;
  end if;

  /* If qualifier_id has been specified but it is not a valid number, 
     then return an error message */
  if (v_error_no is null) then 
    if (ai_opt_qualifier_id is not null) then
      if (translate(ai_opt_function_id, '0123456789', '0000000000') <> 
          substr('00000000000000000000', 1, length(ai_opt_qualifier_id)) )
      then
        /* Raise error condition */
        v_error_no := roles_service_constant.err_20022a_no;
        v_error_msg := roles_service_constant.err_20022a_msg;
        v_error_msg := replace(v_error_msg, '<qualifier_id>', 
                               ai_opt_qualifier_id);
        v_error_msg := replace(v_error_msg, '<qualifier_type>', 
                               '(any)');
      else
        v_qualifier_id := to_number(ai_opt_qualifier_id);
      end if;
    end if;
  end if;

  /* If we have sufficient information, then get the qualifier_type */
  /* If the qualifier_type is specified, then set v_qualifier_type */
  /****** fix 6/6/2008 *****/
  --if (ai_opt_qualifier_type is not null) then
  --    if (translate(ai_opt_qualifier_type, '0123456789', '0000000000') <> 
  --        substr('00000000000000000000', 1, length(ai_opt_qualifier_type)) )
  if (ai_opt_qualifier_type is not null) then
      if (length(ai_opt_qualifier_type) > 4)
      then
        /* Raise error condition */
        v_error_no := roles_service_constant.err_20031_no;
        v_error_msg := replace(roles_service_constant.err_20031_msg, 
                              '<qualifier_type>', ai_opt_qualifier_type);
      else
        v_qualifier_type := ai_opt_qualifier_type;
      end if;
  /* else if function_name is specified, then get qualifier_type from */
  /* function table */
  /***** Adjust code 6/6/2008 *****/
  --elsif (ai_opt_function_name is not null) then
  elsif (v_function_name is not null) then
    select count(*) into v_count from function 
       where function_category = upper(ai_function_category)
       and function_name = upper(ai_opt_function_name);
    if v_count = 0 then
      v_error_no := roles_service_constant.err_20021b_no;
      v_error_msg := roles_service_constant.err_20021b_msg;
      v_error_msg := replace(v_error_msg, '<function_name>', 
                            ai_opt_function_name);
      v_error_msg := replace(v_error_msg, '<function_category>', 
                            ai_function_category);
    end if;
    select function_id, qualifier_type
      into v_function_id, v_qualifier_type
      from function
      where function_category = upper(ai_function_category)
      and function_name = v_function_name;              /*** Adjust 6/6/8 ***/
    --and function_name = upper(ai_opt_function_name);  /*** Adjust 6/6/8 ***/
  /* else if function_id is specified, then get qualifier_type from */
  /* function table */
  elsif (v_function_id is not null) then
    select qualifier_type
      into v_qualifier_type
      from function
      where function_id = v_function_id;
  /* else if qualifier_id is specified, then get qualifier_type from */
  /*      qualifier table */
  elsif (v_qualifier_id is not null) then
    select qualifier_type
      into v_qualifier_type
      from qualifier
      where qualifier_id = v_qualifier_id;
  end if;
  
  /* If qualifier_code has been specified, then make sure either 
     function_name, function_id, or qualifier_type has been specified */
  if (ai_opt_qualifier_code is not null and v_qualifier_type is null) then
      v_error_no := roles_service_constant.err_20023_no;
      v_error_msg := replace(roles_service_constant.err_20023_msg, 
                             '<argument_name>', 'Qualifier Code');
  end if;

  /* If base_qualifier_code has been specified, then make sure either 
     function_name, function_id, or qualifier_type has been specified */
  if (ai_opt_base_qual_code is not null and v_qualifier_type is null) then
      v_error_no := roles_service_constant.err_20023_no;
      v_error_msg := replace(roles_service_constant.err_20023_msg, 
                             '<argument_name>', 'Base Qualifier Code');
  end if;

  /* If parent_qualifier_code has been specified, then make sure either 
     function_name, function_id, or qualifier_type has been specified */
  if (ai_opt_parent_qual_code is not null and v_qualifier_type is null) then
      v_error_no := roles_service_constant.err_20023_no;
      v_error_msg := replace(roles_service_constant.err_20023_msg, 
                             '<argument_name>', 'Parent Qualifier Code');
  end if;

  /* If child_qualifier_code has been specified, then make sure either 
     function_name, function_id, or qualifier_type has been specified */
  if (ai_opt_child_qual_code is not null and v_qualifier_type is null) then
      v_error_no := roles_service_constant.err_20023_no;
      v_error_msg := replace(roles_service_constant.err_20023_msg, 
                             '<argument_name>', 'Child Qualifier Code');
  end if;

  /* We have no errors yet. Check authorizations and keep processing. */
  
  if (v_error_no is null) then 
    /* Determine what function_category to use, if any, for evaluating 
       the user's authorizations for viewing auths */
    v_function_category := upper(ai_function_category);
    if (v_function_category is not null) then
      v_eval_function_category := v_function_category;
    elsif (v_function_id is not null) then
      select count(*) into v_count from function 
        where function_id = v_function_id;
      if v_count = 0 then
        v_error_no := roles_service_constant.err_20021a_no;
        v_error_msg := replace(roles_service_constant.err_20021a_msg, 
                              '<function_id>', ai_opt_function_id);
      else 
        select function_category into v_eval_function_category
          from function 
          where function_id = v_function_id;
      end if;
    end if;
  end if;
  v_location := 'D';

  /* If there is no function_category in v_eval_function_category and
     no errors are recorded in v_error_no and v_error_msg, then we
     will construct a SQL where clause to limit the authorization list
     to only those function_categories viewable by both the proxy_user
     and the server_id.  If there are none, then set an error message. */

  if (v_error_no is null and v_eval_function_category is null) then
    v_category_string := rolesserv.get_view_category_list(v_server_user,
                                                          v_proxy_user);
    if (v_category_string is null) then
      v_error_no := roles_service_constant.err_20006_no;
      v_error_msg := roles_service_constant.err_20006_msg;
      v_error_msg := replace(v_error_msg, '<proxy_user>', v_proxy_user);
      v_error_msg := replace(v_error_msg, '<server_id>', v_server_user);
    else
      v_cat_criteria := ' and a.function_category in (' || v_category_string
                        || ')';
    end if;
  end if;

  /* If there was no function_category, then we've constructed a 
     SQL fragment to limit the authorization list to categories viewable
     by the given user under the given server.
     Otherwise, we should either have a function category in 
     variable v_eval_function_category, or we should have an error 
     code and error message set in v_error_no and v_error_msg. 
     If we have a function_category, then check the authorizations 
     of the server_user and proxy_user. */
  if (v_error_no is null and v_cat_criteria is null) then 
    /* Make sure the server_user is authorized to act as a proxy for the
       given category.  */
    select rolesapi_is_user_authorized(ai_server_user, 
             roles_service_constant.service_function_name, 
             'CAT' || rtrim(v_function_category, ' '))
           into v_check_auth from dual;
    if (v_check_auth <> 'Y') then
      v_error_no := roles_service_constant.err_20003_no;
      v_error_msg := roles_service_constant.err_20003_msg;
      v_error_msg := replace(v_error_msg, '<server_id>', 
                             ai_server_user);
      v_error_msg := replace(v_error_msg, '<function_category>', 
                             v_function_category);
    else
      /* Make sure the proxy_user is authorized to check the authorization, 
         either because proxy_user = kerberos_name or because proxy_user 
         has the authority to look up authorizations in this category */
      if (v_proxy_user = v_server_user) then 
        v_check_auth := 'Y';
      elsif (v_proxy_user = v_kerberos_name) then 
        v_check_auth := 'Y';
      else
        select rolesapi_is_user_authorized(v_proxy_user, 
                 roles_service_constant.read_auth_function1, 
                 'CAT' || rtrim(v_function_category, ' '))
               into v_check_auth from dual;
        if (v_check_auth <> 'Y') then
          select rolesapi_is_user_authorized(v_proxy_user, 
                 roles_service_constant.read_auth_function2, 
                 'CAT' || rtrim(v_function_category, ' '))
                 into v_check_auth from dual;
        end if;
      end if;
      if (v_check_auth <> 'Y') then
        v_error_no := roles_service_constant.err_20005_no;
        v_error_msg := roles_service_constant.err_20005_msg;
        v_error_msg := replace(v_error_msg, '<proxy_user>', 
                              v_proxy_user);
        v_error_msg := replace(v_error_msg, '<function_category>', 
                              v_function_category);
      end if;
    end if;
  end if;
  v_location := 'E';

  /* If we have not recorded an error in v_error_no and v_error_msg,
     then keep going, and generate the select statement */
  if (v_error_no is null) then

    /* 
    **  Build the WHERE clauses.
    */
    v_criteria1 := 'WHERE q1.qualifier_id = a.qualifier_id';
    v_criteria2 := 'WHERE q1.qualifier_id = a.qualifier_id'
                 || ' and a.descend = ''Y'''
                 || ' and qd.parent_id = a.qualifier_id'
                 || ' and q2.qualifier_id = qd.child_id';
    v_criteria12 := '';
    if ai_is_active_now in ('y', 'Y') then 
      v_criteria12 := v_criteria12 || ' and ' || c_is_active_now_phrase; 
    end if;
    if ai_function_category is not null then 
      v_criteria12 := v_criteria12 || ' and ' || c_function_category_phrase;
    end if;
    --if ai_opt_function_name is not null then    /*** Adjust 6/6/8 ***/
    if (v_function_name is not null               /*** Adjust 6/6/8 ***/
        or v_function_name_wildcard is not null) then  /*** Adjust 6/6/8 ***/
      v_criteria12 := v_criteria12 || ' and ' || c_function_name_phrase;
    end if;
    /***** Add 6/6/2008 *****/
    if v_function_name_wildcard is not null then
      v_criteria12 := v_criteria12 || ' and ' || c_function_name_phrase;
    end if;
    /***** End add 6/6/2008 *****/
    if ai_opt_function_id is not null then 
      v_criteria12 := v_criteria12 || ' and ' || c_function_id_phrase; 
    end if;
    if ai_opt_qualifier_type is not null then 
      v_criteria12 := v_criteria12 || ' and ' ||
                 'q1.qualifier_type = ''' || ai_opt_qualifier_type || ''''; 
    end if;
    if ai_opt_qualifier_code is not null then
    /***** Fixed 6/6/2008 *****/
      v_criteria1 := v_criteria1 || ' and ' ||
                 'q1.qualifier_code = ''' || ai_opt_qualifier_code || '''';
      v_criteria2 := v_criteria2 || ' and ' ||
                 'q2.qualifier_code = ''' || ai_opt_qualifier_code || '''';
    end if;
    if ai_opt_qualifier_id is not null then
      v_criteria1 := v_criteria1 || ' and ' ||
                 'q1.qualifier_id = ''' || ai_opt_qualifier_id || '''';
      v_criteria2 := v_criteria2 || ' and ' ||
                 'q2.qualifier_id = ''' || ai_opt_qualifier_id || '''';
    end if;
    if ai_opt_base_qual_code is not null then
      v_criteria12 := v_criteria12 || ' and ' ||
                 'q1.qualifier_code = ''' || ai_opt_qualifier_code || '''';
    end if;
    if ai_opt_base_qual_id is not null then
      v_criteria12 := v_criteria1 || ' and ' ||
                 'a.qualifier_id = ''' || ai_opt_qualifier_id || '''';
    end if;
    if ai_kerberos_name is not null then
      v_criteria12 := v_criteria12 || ' and ' || c_kerberos_name_phrase;
    end if;

    /*
    **  Now, put the pieces together 
    */
    outstring := v_select_fields || ' ' || v_from1s || ' ' || v_criteria1
                                 || v_criteria12 || v_cat_criteria;
    if ai_expand_qualifiers in ('y', 'Y') then
       outstring := outstring || ' UNION ' || v_select_fields_2s
                    || ' ' || v_from2s || ' ' || v_criteria2 || v_criteria12
                    || v_cat_criteria;
    end if;
    ao_sql_statement := outstring;

  /* If we have recorded an error in v_error_no and v_error_msg, then 
     move these into the output arguments ao_error_no and ao_error_msg */
  else   -- if (v_error_no is not null)
    ao_error_no := v_error_no;
    ao_error_msg := v_error_msg;
    v_location := 'E1';
  end if;
  v_location := 'F';

  --EXCEPTION
  --  WHEN OTHERS THEN
  --    v_error_no := -20001;
  --    v_error_msg := 'Location -' || v_location; 
  --    raise_application_error(v_error_no, v_error_msg);

end get_auth_person_sql2;

/*****************************************************************************
*   GET_AUTH_PERSON_SQL_EXTEND1
*
*  Supply some input parameters, and the stored procedure will construct
*  and return a SELECT statement for returning authorizations.  This 
*  stored procedure should be called by another stored procedure that 
*  actually executes the SELECT statement (and returns a REF CURSOR).
*  If there are authorization or other errors, then ao_error_no
*  and ao_error_msg are set;  otherwise, ao_sql_statement is set.
*
*  Of the arguments:
*   ai_server_user   is the ID of the service running this procedure
*   ai_proxy_user     is the username of the Proxy user running this procedure
*   ai_kerberos_name  is the Kerberos name of the person whose authorizations
*                     are to be returned.  Required argument.
*   ai_function_category  is the function_category in which you want to 
*                         return the authorizations.  If null, and if 
*                         ai_opt_function_name and ai_opt_function_id 
*                         are also null, then the stored 
*                         procedure returns authorizations in all categories.
*                         Whatever category is picked or implied from
*                         function information, the ai_server_user and
*                         ai_proxy_user need appropriate viewing 
*                         authorizations or an error condition will be 
*                         raised.
*   ai_expand_qualifiers  is 'Y' if you want to list authorizations expanded
*                         by qualifier_child and function_child; 'N' if you
*                         only want to see actual authorizations
*   ai_is_active_now      is 'Y' if you only want to see active authorizations
*                         (current, and with do_function = 'Y')
*   -- the remaining input arguments are optional --
*   ai_opt_real_or_implied  is '' or 'B' if you want to include Real and
*                           implied auths (from table EXTERNAL_AUTHORIZATION);
*                           'R' if you want only Real auths from the 
*                           AUTHORIZATION table, 'I' if you want only
*                           implied (aka external) authorizations.
*   ai_opt_function_name  If ai_opt_function_name is supplied, then 
*                         ai_function_category must be supplied as well.
*                         If ai_opt_function_name is supplied, then 
*                         authorizations shown are limited to those for the 
*                         given function name
*   ai_opt_function_id    If function_id is supplied, then authorizations 
*                         are limited to those for the given function_id.
*                         It is intended that either function_name or 
*                         function name will be supplied, but not both; 
*                         however, no error condition will be raised if
*                         both are supplied and they do not match each other.
*   -- note: the intention is that one of the following combinations of     --
*   -- arguments will be supplied: (a) no qualifier_related arguments,      --
*   -- (b) ai_opt_qualifier_type and ai_opt_qualifier_type,                 --
*   -- (c) ai_opt_qualifier_id, (d) ai_opt_qualifier_type and               --
*   -- ai_opt_base_qual_code, (e) ai_opt_base_qual_id,                      --
*   -- (f) ai_opt_qualifier_type and ai_opt_parent_qual_code,               --
*   -- (g) ai_opt_parent_qual_id                                            --
*   ai_opt_qualifier_type  If ai_opt_qualifier_type is supplied, then only
*                          authorizations for qualifiers of the given type
*                          will be returned.
*   ai_opt_qualifier_code  If ai_opt_qualifier_code is supplied, then 
*                          either ai_opt_function_name, ai_opt_function_id,
*                          or ai_opt_qualifier_type must be supplied as well.
*                          If ai_opt_qualifier_code is supplied, then
*                          only real or implied authorizations for the 
*                          given qualifier will be returned.
*   ai_opt_qualifier_id    If ai_opt_qualifier_id is supplied, then 
*                          only real or implied authorizations for the given
*                          qualifier will be returned.
*   ai_opt_base_qual_code  If ai_opt_qualifier_code is supplied, then 
*                          either ai_opt_function_name, ai_opt_function_id,
*                          or ai_opt_qualifier_type must be supplied as well.
*                          If ai_opt_qualifier_code is supplied, then
*                          only a real authorization for this qualifier_code 
*                          or expanded authorizations for children of this
*                          qualifier will be returned.
*   ai_opt_base_qual_id   If ai_opt_qualifier_id is supplied, then
*                          only a real authorization for this qualifier_code 
*                          or expanded authorizations for children of this
*                          qualifier will be returned.
*   ai_opt_parent_qual_code  If ai_opt_parent_qual_code is supplied, then
*                          either ai_opt_function_name, ai_opt_function_id,
*                          or ai_opt_qualifier_type must be supplied as well.
*                          If ai_opt_parent_qual_code is supplied, then 
*                          the only authorizations shown will be those whose 
*                          base qualifier_id is a descendent (child) of 
*                          ai_opt_parent_qual_code.  This allows you
*                          to show only authorizations within a given branch
*                          of a qualifier hierarchy.
*   ai_opt_parent_qual_id  If ai_opt_parent_qual_id is supplied, then 
*                          the only authorizations shown will be those whose 
*                          base qualifier_id is a descendent (child) of 
*                          ai_opt_parent_qual_id.  This allows you
*                          to show only authorizations within a given branch
*                          of a qualifier hierarchy.
*                        
*****************************************************************************/
  PROCEDURE get_auth_person_sql_extend1
      (ai_server_user in VARCHAR2,
       ai_proxy_user in VARCHAR2,
       ai_kerberos_name in VARCHAR2,
       ai_function_category IN VARCHAR2, 
       ai_expand_qualifiers IN VARCHAR2, 
       ai_is_active_now IN VARCHAR2, 
       ai_opt_real_or_implied IN VARCHAR2, 
       ai_opt_function_name IN VARCHAR2, 
       ai_opt_function_id IN VARCHAR2, 
       ai_opt_qualifier_type IN VARCHAR2, 
       ai_opt_qualifier_code IN VARCHAR2, 
       ai_opt_qualifier_id IN VARCHAR2, 
       ai_opt_base_qual_code IN VARCHAR2,
       ai_opt_base_qual_id IN VARCHAR2,
       ai_opt_parent_qual_code IN VARCHAR2,
       ai_opt_parent_qual_id IN VARCHAR2,
       ao_error_no OUT INTEGER,
       ao_error_msg OUT VARCHAR2,
       ao_sql_statement OUT VARCHAR2)
  is
  v_kerberos_name authorization.kerberos_name%type;
  v_server_user authorization.kerberos_name%type;
  v_proxy_user authorization.kerberos_name%type;
  v_function_id function.function_id%type;
  v_function_category function.function_category%type;
  v_eval_function_category function.function_category%type;
  v_function_name function.function_name%type;
  v_function_name_wildcard function.function_name%type;  /**** Add 6/6/08 ***/
  v_qualifier_type function.qualifier_type%type;
  v_qualifier_code authorization.qualifier_code%type;
  v_qualifier_id authorization.qualifier_id%type;
  v_parent_qualifier_id qualifier.qualifier_id%type;
  v_valid_real_implied_arg integer;
  v_real_or_implied varchar2(1);
  v_error_msg varchar2(255);
  v_error_no integer;
  v_count integer;
  v_check_auth varchar2(1);
  v_location varchar2(2);
  outstring VARCHAR2(10000) := '';
  /*** "Where" phrases to be used for constructing the SELECT statement ***/
  c_is_active_now_phrase VARCHAR2(200) := 
                'a.do_function = ''Y'' and sysdate between a.effective_date'
                || ' and nvl(a.expiration_date,sysdate)'; 
  c_function_category_phrase VARCHAR2(200) := 
          'a.function_category = ''' || upper(ai_function_category) || '''';
  c_function_name_phrase VARCHAR2(200) :=      
                'a.function_name in (''' 
                 || upper(ai_opt_function_name) || ''', '''
                 || '*' || upper(ai_opt_function_name) || ''')';
  c_function_id_phrase VARCHAR2(200) := 
                'a.function_id = ''' || ai_opt_function_id || '''';
  c_kerberos_name_phrase VARCHAR2(200) := 
                'a.kerberos_name = ''' || upper(ai_kerberos_name) || '''';
  v_select_fields VARCHAR2(2000) := 
    'select a.kerberos_name, a.function_category,'
     || ' ltrim(a.function_name,''*'') function_name,'
     || ' a.qualifier_code, nvl(a.qualifier_name, '' '') qualifier_name, '
     || ' auth_sf_is_auth_active(a.do_function, a.effective_date,'
     || '     a.expiration_date) is_active_now,'
     || ' decode(a.grant_and_view, ''GD'', ''G'', ''N'') grant_authorization,'
     || ' a.authorization_id, a.function_id, a.qualifier_id,'
     || ' a.do_function, a.effective_date, a.expiration_date,'
     || ' a.modified_by, a.modified_date, q1.qualifier_type,'
     || ' q1.qualifier_code base_qualifier_code,';
  v_from1s VARCHAR2(250) := ' from authorization2 a, qualifier q1'; 
  v_from2s VARCHAR2(250) := 
       ' from authorization2 a, qualifier q1, qualifier_descendent qd,' 
    || ' qualifier q2'; 

  v_order_by VARCHAR2(100)
    := ' ORDER BY 1, 2, 3, 4';

  v_counter integer;
  v_select_fields_2s VARCHAR2(2000); 
  v_criteria1 VARCHAR2(2000) := ''; 
  v_criteria2 VARCHAR2(2000) := ''; 
  v_criteria12 VARCHAR2(5000) := ''; 
  v_category_string VARCHAR2(2000) := '';
  v_cat_criteria VARCHAR2(2040) := '';
BEGIN
  v_select_fields_2s := replace(v_select_fields, 'a.qualifier_code',
                                                 'q2.qualifier_code');
  v_select_fields_2s := replace(v_select_fields_2s, 'a.qualifier_name',
                                                    'q2.qualifier_name');
  v_select_fields_2s := replace(v_select_fields_2s, 'a.qualifier_id',
                                                    'q2.qualifier_id');

  v_kerberos_name := upper(ai_kerberos_name);
  v_server_user := upper(ai_server_user);
  v_proxy_user := upper(ai_proxy_user);
  if v_proxy_user is null then
    v_proxy_user := v_server_user;
  end if;
  v_location := 'A';

  /* Make sure the argument ai_opt_real_or_implied is valid */
  if length(ai_opt_real_or_implied) > 1 then
    v_valid_real_implied_arg := 0;
  else
    v_real_or_implied := upper(nvl(ai_opt_real_or_implied, 'B'));
    if v_real_or_implied in ('R', 'I', 'B') then
      v_valid_real_implied_arg := 1;
    else
      v_valid_real_implied_arg := 0;
    end if;
  end if;
  if v_valid_real_implied_arg = 0 then
    v_error_no := roles_service_constant.err_20024_no;
    v_error_msg := replace(roles_service_constant.err_20024_msg, 
                            '<arg_value>', ai_opt_real_or_implied);
    raise_application_error(v_error_no, v_error_msg);
  end if;

  /* If v_real_or_implied is 'R' (real auths only), then use the
     table AUTHORIZATION rather than AUTHORIZATION2.
     Also, make the last field in the list of returned field
     into the literal string 'R' rather than "a.auth_type".  */
  if v_real_or_implied = 'R' then
    v_from1s := replace(v_from1s, 'authorization2', 'authorization');
    v_from2s := replace(v_from2s, 'authorization2', 'authorization');
    v_select_fields := v_select_fields || '''R'' real_or_implied';
    v_select_fields_2s := v_select_fields || '''R'' real_or_implied';
  else 
    v_select_fields := v_select_fields 
      || ' decode(a.auth_type, ''E'', ''I'', a.auth_type) real_or_implied';
    v_select_fields_2s := v_select_fields_2s
      || ' decode(a.auth_type, ''E'', ''I'', a.auth_type) real_or_implied';
  end if;
  
  /* Make sure the given function_category does not exceed maximum length */
  if (length(ai_function_category) > 
      roles_service_constant.max_function_category_size) then
    v_error_no := roles_service_constant.err_20028_no;
    v_error_msg := replace(roles_service_constant.err_20028_msg, 
                            '<function_category>', ai_function_category);
  else 
    v_function_category := upper(ai_function_category);
  end if;

  /* Make sure the given function_name does not exceed maximum length */
  if (length(ai_opt_function_name) > 
      roles_service_constant.max_function_name_size) then
    v_error_no := roles_service_constant.err_20029_no;
    v_error_msg := replace(roles_service_constant.err_20029_msg, 
                            '<function_name>', ai_opt_function_name);
  else 
    /***** Add some code 6/6/2008 *****/
    --v_function_name := upper(ai_opt_function_name);
    if (substr(ai_opt_function_name, -2, 2) = '\*') then 
      v_function_name := 
        substr(upper(ai_opt_function_name), 1, length(ai_opt_function_name)-2)
        || '*';
      c_function_name_phrase :=      
                'a.function_name = ''' || v_function_name || '''';
    elsif (substr(ai_opt_function_name, -1, 1) = '*') then 
      v_function_name_wildcard := 
        substr(upper(ai_opt_function_name), 1, length(ai_opt_function_name)-1)
        || '%';
      c_function_name_phrase :=      
                'a.function_name like ''' || v_function_name_wildcard || '''';
    else
      v_function_name := upper(ai_opt_function_name);
      c_function_name_phrase :=      
                'a.function_name = ''' || v_function_name || '''';
    end if;
    /***** End add some code 6/6/2008 *****/
  end if;

  /* Make sure the Kerberos_name field has been specified */
  if (v_kerberos_name is null) then
    v_error_no := roles_service_constant.err_20030_no;
    v_error_msg := roles_service_constant.err_20030_msg;
  end if;

  /* If function_name has been specified, but not function_category, 
     then return an error messsage */
  if (v_error_no is null) then 
    if (ai_function_category is null and v_function_name is not null) then
      v_error_no := roles_service_constant.err_20027_no;
      v_error_msg := roles_service_constant.err_20027_msg;
    end if;
    /**** Add 6/6/2008 ****/
    if (ai_function_category is null and v_function_name_wildcard is not null) 
    then
      v_error_no := roles_service_constant.err_20027_no;
      v_error_msg := roles_service_constant.err_20027_msg;
    end if;
    /**** End add 6/6/2008 ****/
  end if;
  v_location := 'B';

  /* If function_id has been specified but it is not a valid number, 
     then return an error message */
  if (v_error_no is null) then 
    if (ai_opt_function_id is not null) then
      if (translate(ai_opt_function_id, '0123456789', '0000000000') <> 
          substr('00000000000000000000', 1, length(ai_opt_function_id)) )
      then
        /* Raise error condition */
        v_error_no := roles_service_constant.err_20021a_no;
        v_error_msg := replace(roles_service_constant.err_20021a_msg, 
                              '<function_id>', ai_opt_function_id);
      else
        v_function_id := to_number(ai_opt_function_id);
      end if;
    end if;
  end if;

  /* If qualifier_id has been specified but it is not a valid number, 
     then return an error message */
  if (v_error_no is null) then 
    if (ai_opt_qualifier_id is not null) then
      if (translate(ai_opt_function_id, '0123456789', '0000000000') <> 
          substr('00000000000000000000', 1, length(ai_opt_qualifier_id)) )
      then
        /* Raise error condition */
        v_error_no := roles_service_constant.err_20022a_no;
        v_error_msg := roles_service_constant.err_20022a_msg;
        v_error_msg := replace(v_error_msg, '<qualifier_id>', 
                               ai_opt_qualifier_id);
        v_error_msg := replace(v_error_msg, '<qualifier_type>', 
                               '(any)');
      else
        v_qualifier_id := to_number(ai_opt_qualifier_id);
      end if;
    end if;
  end if;

  /* If we have sufficient information, then get the qualifier_type */
  /* If the qualifier_type is specified, then set v_qualifier_type */
  if (ai_opt_qualifier_type is not null) then
      if (length(ai_opt_qualifier_type) 
          > roles_service_constant.max_qualifier_type_size)
      then
        /* Raise error condition */
        v_error_no := roles_service_constant.err_20031_no;
        v_error_msg := replace(roles_service_constant.err_20031_msg, 
                              '<qualifier_type>', ai_opt_qualifier_type);
      else
        v_qualifier_type := ai_opt_qualifier_type;
      end if;
  /* else if function_name is specified, then get qualifier_type from */
  /* function table */
  /***** Adjust code 6/6/2008 *****/
  --elsif (ai_opt_function_name is not null) then
  elsif (v_function_name is not null) then
  /***** End adjust code 6/6/2008 *****/
    select count(*) into v_count from function 
       where function_category = upper(ai_function_category)
       and function_name = upper(ai_opt_function_name);
    if v_count > 0 then
     select function_id, qualifier_type
       into v_function_id, v_qualifier_type
       from function
       where function_category = upper(ai_function_category)
       and function_name = v_function_name;              /*** Adjust 6/6/8 ***/
     --and function_name = upper(ai_opt_function_name);  /*** Adjust 6/6/8 ***/
    else
     select count(*) into v_count from external_function 
        where function_category = upper(ai_function_category)
        and function_name = '*' || upper(v_function_name)
        and v_real_or_implied in ('B', 'I');
     if v_count > 0 then
       select function_id, qualifier_type
         into v_function_id, v_qualifier_type
         from external_function
         where function_category = upper(ai_function_category)
         and function_name = '*' || v_function_name;
     end if;
    end if;
    if v_count = 0 then
      v_error_no := roles_service_constant.err_20021b_no;
      v_error_msg := roles_service_constant.err_20021b_msg;
      v_error_msg := replace(v_error_msg, '<function_name>', 
                            ai_opt_function_name);
      v_error_msg := replace(v_error_msg, '<function_category>', 
                            ai_function_category);
    end if;
  /* else if function_id is specified, then get qualifier_type from */
  /* function table */
  elsif (v_function_id is not null) then
    select qualifier_type
      into v_qualifier_type
      from function
      where function_id = v_function_id;
  /* else if qualifier_id is specified, then get qualifier_type from */
  /*      qualifier table */
  elsif (v_qualifier_id is not null) then
    select qualifier_type
      into v_qualifier_type
      from qualifier
      where qualifier_id = v_qualifier_id;
  end if;
  
  /* If qualifier_code has been specified, then make sure either 
     function_name, function_id, or qualifier_type has been specified */
  if (ai_opt_qualifier_code is not null and v_qualifier_type is null) then
      v_error_no := roles_service_constant.err_20023_no;
      v_error_msg := replace(roles_service_constant.err_20023_msg, 
                             '<argument_name>', 'Qualifier Code');
  end if;

  /* If base_qual_code has been specified, then make sure either 
     function_name, function_id, or qualifier_type has been specified */
  if (ai_opt_base_qual_code is not null and v_qualifier_type is null) then
      v_error_no := roles_service_constant.err_20023_no;
      v_error_msg := replace(roles_service_constant.err_20023_msg, 
                             '<argument_name>', 'Base Qualifier Code');
  end if;

  /* If parent_qualifier_code has been specified, then make sure either 
     function_name, function_id, or qualifier_type has been specified */
  if (ai_opt_parent_qual_code is not null and v_qualifier_type is null) then
      v_error_no := roles_service_constant.err_20023_no;
      v_error_msg := replace(roles_service_constant.err_20023_msg, 
                             '<argument_name>', 'Parent Qualifier Code');
  end if;

  /* If parent_qualifier_code has been specified, then make sure it
     actually exists for the appropriate qualifier_type. */
  if (ai_opt_parent_qual_code is not null) then
    select count(*) into v_count from qualifier
      where qualifier_type = v_qualifier_type
      and qualifier_code = ai_opt_parent_qual_code;
    if v_count = 0 then
      v_error_no := roles_service_constant.err_20022b_no;
      v_error_msg := roles_service_constant.err_20022b_msg;
      v_error_msg := replace(v_error_msg, '<qualifier_code>', 
                            ai_opt_parent_qual_code);
      v_error_msg := replace(v_error_msg, '<qualifier_type>', 
                            v_qualifier_type);
      raise_application_error(v_error_no, v_error_msg);
    else
      select qualifier_id into v_parent_qualifier_id from qualifier
        where qualifier_type = v_qualifier_type
        and qualifier_code = ai_opt_parent_qual_code;
    end if;
  end if;

  /* We have no errors yet. Check authorizations and keep processing. */
  
  if (v_error_no is null) then 
    /* Determine what function_category to use, if any, for evaluating 
       the user's authorizations for viewing auths */
    v_function_category := upper(ai_function_category);
    if (v_function_category is not null) then
      v_eval_function_category := v_function_category;
    elsif (v_function_id is not null) then
      select count(*) into v_count from function 
        where function_id = v_function_id;
      if v_count = 0 then
        v_error_no := roles_service_constant.err_20021a_no;
        v_error_msg := replace(roles_service_constant.err_20021a_msg, 
                              '<function_id>', ai_opt_function_id);
      else 
        select function_category into v_eval_function_category
          from function 
          where function_id = v_function_id;
      end if;
    end if;
  end if;
  v_location := 'D';

  /* If there is no function_category in v_eval_function_category and
     no errors are recorded in v_error_no and v_error_msg, then we
     will construct a SQL where clause to limit the authorization list
     to only those function_categories viewable by both the proxy_user
     and the server_id.  If there are none, then set an error message. */

  if (v_error_no is null and v_eval_function_category is null) then
    v_category_string := rolesserv.get_view_category_list(v_server_user,
                                                          v_proxy_user);
    if (v_category_string is null) then
      v_error_no := roles_service_constant.err_20006_no;
      v_error_msg := roles_service_constant.err_20006_msg;
      v_error_msg := replace(v_error_msg, '<proxy_user>', v_proxy_user);
      v_error_msg := replace(v_error_msg, '<server_id>', v_server_user);
    else
      v_cat_criteria := ' and a.function_category in (' || v_category_string
                        || ')';
    end if;
  end if;

  /* If there was no function_category, then we've constructed a 
     SQL fragment to limit the authorization list to categories viewable
     by the given user under the given server.
     Otherwise, we should either have a function category in 
     variable v_eval_function_category, or we should have an error 
     code and error message set in v_error_no and v_error_msg. 
     If we have a function_category, then check the authorizations 
     of the server_user and proxy_user. */
  if (v_error_no is null and v_cat_criteria is null) then 
    /* Make sure the server_user is authorized to act as a proxy for the
       given category.  */
    select rolesapi_is_user_authorized(ai_server_user, 
             roles_service_constant.service_function_name, 
             'CAT' || rtrim(v_function_category, ' '))
           into v_check_auth from dual;
    if (v_check_auth <> 'Y') then
      v_error_no := roles_service_constant.err_20003_no;
      v_error_msg := roles_service_constant.err_20003_msg;
      v_error_msg := replace(v_error_msg, '<server_id>', 
                             ai_server_user);
      v_error_msg := replace(v_error_msg, '<function_category>', 
                             v_function_category);
    else
      /* Make sure the proxy_user is authorized to check the authorization, 
         either because proxy_user = kerberos_name or because proxy_user 
         has the authority to look up authorizations in this category */
      if (v_proxy_user = v_server_user) then 
        v_check_auth := 'Y';
      elsif (v_proxy_user = v_kerberos_name) then 
        v_check_auth := 'Y';
      else
        select rolesapi_is_user_authorized(v_proxy_user, 
                 roles_service_constant.read_auth_function1, 
                 'CAT' || rtrim(v_function_category, ' '))
               into v_check_auth from dual;
        if (v_check_auth <> 'Y') then
          select rolesapi_is_user_authorized(v_proxy_user, 
                 roles_service_constant.read_auth_function2, 
                 'CAT' || rtrim(v_function_category, ' '))
                 into v_check_auth from dual;
        end if;
      end if;
      if (v_check_auth <> 'Y') then
        v_error_no := roles_service_constant.err_20005_no;
        v_error_msg := roles_service_constant.err_20005_msg;
        v_error_msg := replace(v_error_msg, '<proxy_user>', 
                              v_proxy_user);
        v_error_msg := replace(v_error_msg, '<function_category>', 
                              v_function_category);
      end if;
    end if;
  end if;
  v_location := 'E';

  /* If we have not recorded an error in v_error_no and v_error_msg,
     then keep going, and generate the select statement */
  if (v_error_no is null) then

    /* 
    **  Build the WHERE clauses.
    */
    v_criteria1 := 'WHERE q1.qualifier_id = a.qualifier_id';
    v_criteria2 := 'WHERE q1.qualifier_id = a.qualifier_id'
                 || ' and a.descend = ''Y'''
                 || ' and qd.parent_id = a.qualifier_id'
                 || ' and q2.qualifier_id = qd.child_id';
    v_criteria12 := '';
    if ai_is_active_now in ('y', 'Y') then 
      v_criteria12 := v_criteria12 || ' and ' || c_is_active_now_phrase; 
    end if;
    if v_real_or_implied = 'I' then
      v_criteria12 := v_criteria12 || ' and a.auth_type = ''E'' ';
    end if;
    if ai_function_category is not null then 
      v_criteria12 := v_criteria12 || ' and ' || c_function_category_phrase;
    end if;
    --if ai_opt_function_name is not null then    /*** Adjust 6/6/8 ***/
    if (v_function_name is not null) then         /*** Adjust 6/6/8 ***/
      v_criteria12 := v_criteria12 || ' and ' || c_function_name_phrase;
    end if;
    /***** Add 6/6/2008 *****/
    if v_function_name_wildcard is not null then
      v_criteria12 := v_criteria12 || ' and ' || c_function_name_phrase;
    end if;
    /***** End add 6/6/2008 *****/
    /* If you specify a function_id, then we handle whatever kind of
       function is represented by the function_id, either Real or
       Implied, but not both */
    if ai_opt_function_id is not null then 
      v_criteria12 := v_criteria12 || ' and ' || c_function_id_phrase; 
    end if;
    if ai_opt_qualifier_type is not null then 
      v_criteria12 := v_criteria12 || ' and ' ||
                 'q1.qualifier_type = ''' || ai_opt_qualifier_type || ''''; 
    end if;
    if ai_opt_qualifier_code is not null then
    /***** Fix 6/6/2008 *****/
      --v_criteria12 := v_criteria12 || ' and ' ||
      --           'q1.qualifier_code = ''' || ai_opt_qualifier_code || '''';
      v_criteria1 := v_criteria1 || ' and ' ||
                 'q1.qualifier_code = ''' || ai_opt_qualifier_code || '''';
      v_criteria2 := v_criteria2 || ' and ' ||
                 'q2.qualifier_code = ''' || ai_opt_qualifier_code || '''';
    /***** End fix 6/6/2008 *****/
    end if;
    if ai_opt_qualifier_id is not null then
      v_criteria1 := v_criteria1 || ' and ' ||
                 'q1.qualifier_id = ''' || ai_opt_qualifier_id || '''';
      v_criteria2 := v_criteria2 || ' and ' ||
                 'q2.qualifier_id = ''' || ai_opt_qualifier_id || '''';
    end if;
    if ai_opt_base_qual_code is not null then
      v_criteria12 := v_criteria12 || ' and ' ||
            'q1.qualifier_code = ''' || ai_opt_base_qual_code || '''';
    end if;
    if ai_opt_base_qual_id is not null then
      v_criteria12 := v_criteria12 || ' and ' ||
                 'a.qualifier_id = ''' || ai_opt_base_qual_id || '''';
    end if;
    if ai_opt_parent_qual_id is not null then
      v_criteria1 := v_criteria1 || ' and (a.qualifier_id = ''' ||
                 ai_opt_parent_qual_id || ''' or exists' ||
                 ' (select 1 from qualifier_descendent qd1 where' ||
                 ' qd1.child_id = a.qualifier_id and qd1.parent_id = ''' || 
                 ai_opt_parent_qual_id || '''))';
      v_criteria2 := v_criteria2 || ' and (q2.qualifier_id = ''' ||
                 ai_opt_parent_qual_id || ''' or exists' ||
                 ' (select 1 from qualifier_descendent qd1 where' ||
                 ' qd1.child_id = q2.qualifier_id and qd1.parent_id = ''' || 
                 ai_opt_parent_qual_id || '''))';
    end if;
    if ai_opt_parent_qual_code is not null then
      v_criteria1 := v_criteria1 || ' and (a.qualifier_id = ''' ||
                 v_parent_qualifier_id || ''' or exists' ||
                 ' (select 1 from qualifier_descendent qd1 where' ||
                 ' qd1.child_id = a.qualifier_id and qd1.parent_id = ''' || 
                 v_parent_qualifier_id || '''))';
      v_criteria2 := v_criteria2 || ' and (q2.qualifier_id = ''' ||
                 v_parent_qualifier_id || ''' or exists' ||
                 ' (select 1 from qualifier_descendent qd1 where' ||
                 ' qd1.child_id = q2.qualifier_id and qd1.parent_id = ''' || 
                 v_parent_qualifier_id || '''))';
    end if;
    if ai_kerberos_name is not null then
      v_criteria12 := v_criteria12 || ' and ' || c_kerberos_name_phrase;
    end if;

    /*
    **  Now, put the pieces together 
    */
    outstring := v_select_fields || ' ' || v_from1s || ' ' || v_criteria1
                                 || v_criteria12 || v_cat_criteria;
    if ai_expand_qualifiers in ('y', 'Y') then
       outstring := outstring || ' UNION ' || v_select_fields_2s
                    || ' ' || v_from2s || ' ' || v_criteria2 || v_criteria12
                    || v_cat_criteria;
    end if;
    outstring := outstring || v_order_by;
    ao_sql_statement := outstring;

  /* If we have recorded an error in v_error_no and v_error_msg, then 
     move these into the output arguments ao_error_no and ao_error_msg */
  else   -- if (v_error_no is not null)
    ao_error_no := v_error_no;
    ao_error_msg := v_error_msg;
    v_location := 'E1';
  end if;
  v_location := 'F';

  --EXCEPTION
  --  WHEN OTHERS THEN
  --    v_error_no := -20001;
  --    v_error_msg := 'Location -' || v_location; 
  --    raise_application_error(v_error_no, v_error_msg);

end get_auth_person_sql_extend1;

FUNCTION get_auth_person_cursor
      (ai_server_user in VARCHAR2,
       ai_proxy_user in VARCHAR2,
       ai_kerberos_name in VARCHAR2,
       ai_function_category IN VARCHAR2, 
       ai_expand_qualifiers IN VARCHAR2, 
       ai_is_active_now IN VARCHAR2, 
       ai_opt_function_name IN VARCHAR2, 
       ai_opt_function_id IN VARCHAR2, 
       ai_opt_qualifier_type IN VARCHAR2, 
       ai_opt_qualifier_code IN VARCHAR2, 
       ai_opt_qualifier_id IN VARCHAR2, 
       ai_opt_base_qual_code IN VARCHAR2,
       ai_opt_base_qual_id IN VARCHAR2,
       ai_opt_parent_qual_code IN VARCHAR2,
       ai_opt_parent_qual_id IN VARCHAR2,
       ai_opt_child_qual_code IN VARCHAR2,
       ai_opt_child_qual_id IN VARCHAR2)
RETURN roles_service_types.ref_cursor
IS
    v_authorizations_cursor ROLES_SERVICE_TYPES.ref_cursor;
    v_statement varchar2(10000);
    v_error_no integer;
    v_error_msg varchar2(2000);
BEGIN

   get_auth_person_sql
      (ai_server_user, ai_proxy_user, ai_kerberos_name, 
       ai_function_category, ai_expand_qualifiers, ai_is_active_now, 
       ai_opt_function_name, ai_opt_function_id, ai_opt_qualifier_type, 
       ai_opt_qualifier_code, ai_opt_qualifier_id, 
       ai_opt_base_qual_code, ai_opt_base_qual_id, 
       ai_opt_parent_qual_code, ai_opt_parent_qual_id, 
       ai_opt_child_qual_code, ai_opt_child_qual_id,
       v_error_no, v_error_msg, v_statement);

   if (v_error_no is not null) then 
     raise_application_error(v_error_no, v_error_msg);
   end if;
	
   open v_authorizations_cursor for v_statement;
   RETURN v_authorizations_cursor;

END get_auth_person_cursor;
  
FUNCTION get_auth_person_cursor2
      (ai_server_user in VARCHAR2,
       ai_proxy_user in VARCHAR2,
       ai_kerberos_name in VARCHAR2,
       ai_function_category IN VARCHAR2, 
       ai_expand_qualifiers IN VARCHAR2, 
       ai_is_active_now IN VARCHAR2, 
       ai_opt_function_name IN VARCHAR2, 
       ai_opt_function_id IN VARCHAR2, 
       ai_opt_qualifier_type IN VARCHAR2, 
       ai_opt_qualifier_code IN VARCHAR2, 
       ai_opt_qualifier_id IN VARCHAR2, 
       ai_opt_base_qual_code IN VARCHAR2,
       ai_opt_base_qual_id IN VARCHAR2,
       ai_opt_parent_qual_code IN VARCHAR2,
       ai_opt_parent_qual_id IN VARCHAR2,
       ai_opt_child_qual_code IN VARCHAR2,
       ai_opt_child_qual_id IN VARCHAR2)
RETURN roles_service_types.ref_cursor
IS
    v_authorizations_cursor ROLES_SERVICE_TYPES.ref_cursor;
    v_statement varchar2(10000);
    v_error_no integer;
    v_error_msg varchar2(2000);
BEGIN

   get_auth_person_sql2
      (ai_server_user, ai_proxy_user, ai_kerberos_name, 
       ai_function_category, ai_expand_qualifiers, ai_is_active_now, 
       ai_opt_function_name, ai_opt_function_id, ai_opt_qualifier_type, 
       ai_opt_qualifier_code, ai_opt_qualifier_id, 
       ai_opt_base_qual_code, ai_opt_base_qual_id, 
       ai_opt_parent_qual_code, ai_opt_parent_qual_id, 
       ai_opt_child_qual_code, ai_opt_child_qual_id,
       v_error_no, v_error_msg, v_statement);

   if (v_error_no is not null) then 
     raise_application_error(v_error_no, v_error_msg);
   end if;
	
   open v_authorizations_cursor for v_statement;
   RETURN v_authorizations_cursor;

END get_auth_person_cursor2;
  
FUNCTION get_auth_person_curs_extend1
      (ai_server_user in VARCHAR2,
       ai_proxy_user in VARCHAR2,
       ai_kerberos_name in VARCHAR2,
       ai_function_category IN VARCHAR2, 
       ai_expand_qualifiers IN VARCHAR2, 
       ai_is_active_now IN VARCHAR2, 
       ai_opt_real_or_implied IN VARCHAR2,
       ai_opt_function_name IN VARCHAR2, 
       ai_opt_function_id IN VARCHAR2, 
       ai_opt_qualifier_type IN VARCHAR2, 
       ai_opt_qualifier_code IN VARCHAR2, 
       ai_opt_qualifier_id IN VARCHAR2, 
       ai_opt_base_qual_code IN VARCHAR2,
       ai_opt_base_qual_id IN VARCHAR2,
       ai_opt_parent_qual_code IN VARCHAR2,
       ai_opt_parent_qual_id IN VARCHAR2)
RETURN roles_service_types.ref_cursor
IS
    v_authorizations_cursor ROLES_SERVICE_TYPES.ref_cursor;
    v_statement varchar2(10000);
    v_error_no integer;
    v_error_msg varchar2(2000);
BEGIN

   get_auth_person_sql_extend1
      (ai_server_user, ai_proxy_user, ai_kerberos_name, 
       ai_function_category, ai_expand_qualifiers, ai_is_active_now, 
       ai_opt_real_or_implied,
       ai_opt_function_name, ai_opt_function_id, ai_opt_qualifier_type, 
       ai_opt_qualifier_code, ai_opt_qualifier_id, 
       ai_opt_base_qual_code, ai_opt_base_qual_id, 
       ai_opt_parent_qual_code, ai_opt_parent_qual_id, 
       v_error_no, v_error_msg, v_statement);

   if (v_error_no is not null) then 
     raise_application_error(v_error_no, v_error_msg);
   end if;
	
   open v_authorizations_cursor for v_statement;
   RETURN v_authorizations_cursor;

END get_auth_person_curs_extend1;
  
/*****************************************************************************
*   GET_AUTH_GENERAL_SQL
*
*  Generate an SQL Select statement based on up to 20 criteria_id/value 
*  pairs.
*
*****************************************************************************/
  PROCEDURE get_auth_general_sql
      (ai_server_user in VARCHAR2,
       ai_proxy_user in VARCHAR2,
       ai_num_criteria in STRING, /* Handle up to 20 criteria/value pairs */
       ai_id1 in STRING, ai_value1 in STRING,
       ai_id2 in STRING, ai_value2 in STRING,
       ai_id3 in STRING, ai_value3 in STRING,
       ai_id4 in STRING, ai_value4 in STRING,
       ai_id5 in STRING, ai_value5 in STRING,
       ai_id6 in STRING, ai_value6 in STRING,
       ai_id7 in STRING, ai_value7 in STRING,
       ai_id8 in STRING, ai_value8 in STRING,
       ai_id9 in STRING, ai_value9 in STRING,
       ai_id10 in STRING, ai_value10 in STRING,
       ai_id11 in STRING, ai_value11 in STRING,
       ai_id12 in STRING, ai_value12 in STRING,
       ai_id13 in STRING, ai_value13 in STRING,
       ai_id14 in STRING, ai_value14 in STRING,
       ai_id15 in STRING, ai_value15 in STRING,
       ai_id16 in STRING, ai_value16 in STRING,
       ai_id17 in STRING, ai_value17 in STRING,
       ai_id18 in STRING, ai_value18 in STRING,
       ai_id19 in STRING, ai_value19 in STRING,
       ai_id20 in STRING, ai_value20 in STRING,
       ao_error_no OUT VARCHAR2,
       ao_error_msg OUT VARCHAR2,
       ao_sql_statement OUT VARCHAR2)
  is
  v_server_user authorization.kerberos_name%type;
  v_proxy_user authorization.kerberos_name%type;
  TYPE INT_ARRAY IS TABLE OF INTEGER INDEX BY BINARY_INTEGER;
  TYPE STRING_ARRAY IS TABLE OF STRING(255) INDEX BY BINARY_INTEGER;
  c_id INT_ARRAY;
  c_value STRING_ARRAY;
  i binary_integer := 0;
  v_num_criteria number;
  cond_fragment VARCHAR2(255);
  b_found_left_par boolean := FALSE;
  b_found_or boolean := FALSE;
  v_function_category varchar2(255) := '';
  v_function_name varchar2(255) := '';
  v_kerberos_name varchar2(255) := '';
  v_check_auth varchar2(1);
  v_category_string VARCHAR2(2000) := '';
  v_cat_criteria VARCHAR2(2040) := '';
  v_count integer;
  v_error_msg varchar2(255);
  v_error_no integer;
BEGIN
  c_id(1) := to_number(ai_id1); c_value(1) := ai_value1;
  c_id(2) := to_number(ai_id2); c_value(2) := ai_value2;
  c_id(3) := to_number(ai_id3); c_value(3) := ai_value3;
  c_id(4) := to_number(ai_id4); c_value(4) := ai_value4;
  c_id(5) := to_number(ai_id5); c_value(5) := ai_value5;
  c_id(6) := to_number(ai_id6); c_value(6) := ai_value6;
  c_id(7) := to_number(ai_id7); c_value(7) := ai_value7;
  c_id(8) := to_number(ai_id8); c_value(8) := ai_value8;
  c_id(9) := to_number(ai_id9); c_value(9) := ai_value9;
  c_id(10) := to_number(ai_id10); c_value(10) := ai_value10;
  c_id(11) := to_number(ai_id11); c_value(11) := ai_value11;
  c_id(12) := to_number(ai_id12); c_value(12) := ai_value12;
  c_id(13) := to_number(ai_id13); c_value(13) := ai_value13;
  c_id(14) := to_number(ai_id14); c_value(14) := ai_value14;
  c_id(15) := to_number(ai_id15); c_value(15) := ai_value15;
  c_id(16) := to_number(ai_id16); c_value(16) := ai_value16;
  c_id(17) := to_number(ai_id17); c_value(17) := ai_value17;
  c_id(18) := to_number(ai_id18); c_value(18) := ai_value18;
  c_id(19) := to_number(ai_id19); c_value(19) := ai_value19;
  c_id(20) := to_number(ai_id20); c_value(20) := ai_value20;

  v_proxy_user := upper(nvl(ai_proxy_user, ai_server_user));
  --v_server_user := upper(ai_server_user);
  v_server_user := nvl(upper(ai_server_user), user);
  v_num_criteria := to_number(ai_num_criteria);
  FOR I IN 1..V_NUM_CRITERIA LOOP  /* Check for special "(... OR ...)" cond */
     cond_fragment 
       := rolesserv.get_sql_fragment(v_proxy_user, c_id(i), c_value(i));
     IF SUBSTR(COND_FRAGMENT,1,3) = 'OR ' THEN
       B_FOUND_OR := TRUE;
     END IF;
     IF SUBSTR(COND_FRAGMENT,1,1) = '(' THEN
       B_FOUND_LEFT_PAR := TRUE;
     END IF;
  END LOOP;

  ao_sql_statement := 
    'select a.kerberos_name,  a.function_category, a.function_name,'
     || ' a.qualifier_code, a.qualifier_name, '
     || ' auth_sf_is_auth_active(a.do_function, a.effective_date,'
     || '     a.expiration_date) is_active_now,'
     || ' decode(a.grant_and_view, ''GD'', ''G'', ''N'') grant_authorization,'
     || ' a.authorization_id, a.function_id, a.qualifier_id, '
     || ' a.do_function, a.effective_date, a.expiration_date,'
     || ' a.modified_by, a.modified_date, p.first_name, p.last_name, '
     || ' f.qualifier_type, f.function_description'
     || ' from authorization a, function f, person p ';

  FOR I IN 1..V_NUM_CRITERIA LOOP
    if c_id(i) = roles_service_constant.category_crit_id then
      v_function_category := upper(c_value(i));
    elsif c_id(i) = roles_service_constant.function_name_crit_id then
      v_function_name := upper(c_value(i));
    elsif c_id(i) = roles_service_constant.kerberos_name_crit_id then
      v_kerberos_name := upper(c_value(i));
    end if;
    cond_fragment
       := rolesserv.get_sql_fragment(v_proxy_user, c_id(i), c_value(i));
    IF LENGTH(COND_FRAGMENT) > 0 THEN
       /* Kluge to enhance performance */
       IF (COND_FRAGMENT = 
        'auth_sf_is_auth_current(a.effective_date,a.expiration_date) = ''Y''')
       THEN
         COND_FRAGMENT := 
         'sysdate between a.effective_date and nvl(a.expiration_date,sysdate)';
       END IF;
       IF (COND_FRAGMENT = 
        'auth_sf_is_auth_current(a.effective_date,a.expiration_date) = ''N''')
       THEN
         COND_FRAGMENT := 
         'sysdate not between a.effective_date and nvl(a.expiration_date,sysdate)';
       END IF;
       /* If we find '(a.kerberos_name =?' but not 'OR a.kerberos_name=?)'
          then chop off leading '(' */
       IF (SUBSTR(COND_FRAGMENT,1,7) = '(a.kerb' 
           AND (NOT B_FOUND_OR)) THEN
          COND_FRAGMENT := SUBSTR(COND_FRAGMENT,2);
       END IF;
       /* If we find 'OR a.kerberos_name=?)' but not '(a.kerberos_name = ?'
          then chop off leading 'OR ' and trailing ')'*/
       IF (SUBSTR(COND_FRAGMENT,1,3) = 'OR ' AND (NOT B_FOUND_LEFT_PAR)) THEN
          COND_FRAGMENT := SUBSTR(COND_FRAGMENT,3);
          COND_FRAGMENT := SUBSTR(COND_FRAGMENT,1,LENGTH(COND_FRAGMENT)-1);
       END IF;
       /* Now add this condition fragment to the select statement */
       IF I = 1 THEN
         --ao_sql_statement := ao_sql_statement || ' WHERE ';
         ao_sql_statement := ao_sql_statement 
           || ' WHERE f.function_id = a.function_id AND'
           || ' p.kerberos_name = a.kerberos_name AND ';
       ELSE /* Special case for (kerb_name = 'x' or kerb_name = 'y') */
         IF SUBSTR(COND_FRAGMENT,1,3) != 'OR ' THEN
           ao_sql_statement := ao_sql_statement || ' AND ';
         ELSE 
           ao_sql_statement := ao_sql_statement || ' ';
         END IF;
       END IF;
       ao_sql_statement := ao_sql_statement 
                           || ' /* crit ' || to_char(I) || ' */ ';
       ao_sql_statement := ao_sql_statement || COND_FRAGMENT;
    END IF;
  END LOOP;

  /* Add check to either (1) make sure the server and proxy users are 
     authorized to view auths in the given category or (2) add limits
     on which categories of authorizations are included. */
  if (v_function_category is null and v_function_name is not null) then
    select count(*) into v_count from function
      where function_name = v_function_name;
    if v_count = 0 then
      v_error_no := roles_service_constant.err_20021c_no;
      v_error_msg := roles_service_constant.err_20021c_msg;
      v_error_msg := replace(v_error_msg, '<function_name>', 
                            v_function_name);
      raise_application_error(v_error_no, v_error_msg);
    else
      select min(function_category) into v_function_category from function
        where function_category = v_function_name;
    end if;
  end if;
  if v_function_category is not null then
    /* Make sure the server user is authorized to view auths for category */
    --select rolesapi_is_user_authorized(v_server_user,  /* Changed 12/11 */
    select rolesapi_is_user_authorized(ai_server_user,
           roles_service_constant.service_function_name, 
           'CAT' || rtrim(v_function_category, ' '))
         into v_check_auth from dual;
    if (v_check_auth <> 'Y') then
      v_error_no := roles_service_constant.err_20003_no;
      v_error_msg := roles_service_constant.err_20003_msg;
      v_error_msg := replace(v_error_msg, '<server_id>', 
                             ai_server_user);   /* Need to change this */
      v_error_msg := replace(v_error_msg, '<function_category>', 
                             v_function_category);
      raise_application_error(v_error_no, v_error_msg);
    end if;
    /* Make sure the proxy_user is authorized to view the authorizations, 
       either because proxy_user = kerberos_name or because proxy_user 
       has the authority to look up authorizations in this category */
    if (v_proxy_user = v_server_user) then 
      v_check_auth := 'Y';
    elsif (v_proxy_user = v_kerberos_name) then 
      v_check_auth := 'Y';
    else
      --select rolesapi_is_user_authorized(v_proxy_user, 
      --         roles_service_constant.read_auth_function1, 
      --         'CAT' || rtrim(v_function_category, ' '))
      --       into v_check_auth from dual;
      --if (v_check_auth <> 'Y') then
      --  select rolesapi_is_user_authorized(v_proxy_user, 
      --         roles_service_constant.read_auth_function2, 
      --         'CAT' || rtrim(v_function_category, ' '))
      --         into v_check_auth from dual;
      --end if;
      select count(*) into v_count from viewable_category
        where kerberos_name = v_proxy_user
        and function_category = rpad(v_function_category, 4);
      if v_count > 0 then
         v_check_auth := 'Y';
      else
         v_check_auth := 'N';
      end if;
    end if;
    if (v_check_auth <> 'Y') then
      v_error_no := roles_service_constant.err_20005_no;
      v_error_msg := roles_service_constant.err_20005_msg;
      v_error_msg := replace(v_error_msg, '<proxy_user>', 
                            v_proxy_user);
      v_error_msg := replace(v_error_msg, '<function_category>', 
                            v_function_category);
      raise_application_error(v_error_no, v_error_msg);
    end if;
  else
  /* At this point, we find that no category was specified.  Add
     limits to which categories will be included */
    v_category_string := rolesserv.get_view_category_list(v_server_user,
                                                          v_proxy_user);
    v_cat_criteria := ' and a.function_category in (' || v_category_string
                        || ')';
  end if;

  ao_sql_statement := ao_sql_statement || v_cat_criteria;
  /* If this includes ' OR ' in the where clause, then we are 
     doing a comparison between two people's authorizations.  In this
     case, order by category, function_name, qualifier_code, and kerberos_name.
     If not, then order by kerberos_name, category, function_name, and
     qualifier_code. */
  if (b_found_or) then
    ao_sql_statement := ao_sql_statement 
          || ' ORDER BY A.FUNCTION_CATEGORY, ';
    ao_sql_statement := ao_sql_statement 
          || ' A.FUNCTION_NAME, A.QUALIFIER_CODE, A.KERBEROS_NAME';
  else
    ao_sql_statement := ao_sql_statement 
          || ' ORDER BY A.KERBEROS_NAME, A.FUNCTION_CATEGORY, ';
    ao_sql_statement := ao_sql_statement 
          || ' A.FUNCTION_NAME, A.QUALIFIER_CODE';
  end if;
end get_auth_general_sql;

FUNCTION get_auth_general_cursor
      (ai_server_user in VARCHAR2,
       ai_proxy_user in VARCHAR2,
       ai_num_criteria in STRING, /* Handle up to 20 criteria/value pairs */
       ai_id1 in STRING, ai_value1 in STRING,
       ai_id2 in STRING, ai_value2 in STRING,
       ai_id3 in STRING, ai_value3 in STRING,
       ai_id4 in STRING, ai_value4 in STRING,
       ai_id5 in STRING, ai_value5 in STRING,
       ai_id6 in STRING, ai_value6 in STRING,
       ai_id7 in STRING, ai_value7 in STRING,
       ai_id8 in STRING, ai_value8 in STRING,
       ai_id9 in STRING, ai_value9 in STRING,
       ai_id10 in STRING, ai_value10 in STRING,
       ai_id11 in STRING, ai_value11 in STRING,
       ai_id12 in STRING, ai_value12 in STRING,
       ai_id13 in STRING, ai_value13 in STRING,
       ai_id14 in STRING, ai_value14 in STRING,
       ai_id15 in STRING, ai_value15 in STRING,
       ai_id16 in STRING, ai_value16 in STRING,
       ai_id17 in STRING, ai_value17 in STRING,
       ai_id18 in STRING, ai_value18 in STRING,
       ai_id19 in STRING, ai_value19 in STRING,
       ai_id20 in STRING, ai_value20 in STRING)
RETURN roles_service_types.ref_cursor
IS
    v_authorizations_cursor ROLES_SERVICE_TYPES.ref_cursor;
    v_statement varchar2(32000);
    v_error_no integer;
    v_error_msg varchar2(2000);
BEGIN

  get_auth_general_sql
      (ai_server_user, ai_proxy_user, ai_num_criteria, 
       ai_id1, ai_value1,
       ai_id2, ai_value2,
       ai_id3, ai_value3,
       ai_id4, ai_value4,
       ai_id5, ai_value5,
       ai_id6, ai_value6,
       ai_id7, ai_value7,
       ai_id8, ai_value8,
       ai_id9, ai_value9,
       ai_id10, ai_value10,
       ai_id11, ai_value11,
       ai_id12, ai_value12,
       ai_id13, ai_value13,
       ai_id14, ai_value14,
       ai_id15, ai_value15,
       ai_id16, ai_value16,
       ai_id17, ai_value17,
       ai_id18, ai_value18,
       ai_id19, ai_value19,
       ai_id20, ai_value20,
       v_error_no, v_error_msg, v_statement);

   if (v_error_no is not null) then 
     raise_application_error(v_error_no, v_error_msg);
   end if;
	
   open v_authorizations_cursor for v_statement;
   RETURN v_authorizations_cursor;

END get_auth_general_cursor;
  
FUNCTION default_qualtree_level
      (ai_qualifier_type in string)
RETURN integer
IS
    v_level_no integer;
BEGIN
  if (upper(ai_qualifier_type) = 'COST') then
    v_level_no := 2;
  elsif (upper(ai_qualifier_type) = 'FUND') then
    v_level_no := 2;
  else
    v_level_no := 3;
  end if;
  return v_level_no;
END default_qualtree_level;
  
end ROLESSERV;
/

create or replace public synonym rolesserv for rolesserv;
grant execute on rolesserv to REPA;
grant execute on rolesserv to DONGQ;
grant execute on rolesserv to ISDA_WEB_SERVER;
grant execute on rolesserv to ROLEWWW9;
