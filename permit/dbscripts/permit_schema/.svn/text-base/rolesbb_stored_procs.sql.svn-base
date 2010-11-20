-- ----------------------------------
--
--  Copyright (C) 2000-2010 Massachusetts Institute of Technology
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
-- ----------------------------------

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_can_create_auth`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_can_create_auth`(AI_USER  VARCHAR(20),
                  AI_FUNCTION_NAME VARCHAR(255),
 		 AI_QUALIFIER_CODE VARCHAR(30),
 		 AI_DO_FUNCTION VARCHAR(1),
 		 AI_GRANT_AND_VIEW VARCHAR(2)) RETURNS varchar(1) CHARSET latin1
begin

DECLARE a_function_name VARCHAR(255) DEFAULT '';
DECLARE a_qualifier_code VARCHAR(30) ;
DECLARE a_do_function VARCHAR(1);
DECLARE a_grant_and_view VARCHAR(2);
DECLARE v_count INTEGER DEFAULT 0;

 DECLARE v_category_code VARCHAR(10) DEFAULT '';
 DECLARE v_function_id INTEGER;
 DECLARE v_qualcode VARCHAR(30) DEFAULT '';
 DECLARE v_qualifier_id BIGINT;
 DECLARE v_today DATE;
 DECLARE EXIT HANDLER FOR NOT FOUND RETURN 'N';

   SET a_function_name  = upper(ai_function_name);
   SET a_qualifier_code = upper(ai_qualifier_code);
   SET a_do_function = upper(ai_do_function);
   SET a_grant_and_view = upper(ai_grant_and_view);
   
   select function_category, function_id into v_category_code, v_function_id
         from function where function_name = a_function_name;
   SET v_qualcode = concat('CAT',v_category_code);
   SET v_qualcode = RTRIM(v_qualcode);  

   
   select count(*) into v_count from authorization a
 	where a.function_name = 'CREATE AUTHORIZATIONS'
 	      and a.kerberos_name = ai_user
               and a.qualifier_code in (v_qualcode,'CATALL')
               and a.do_function = 'Y'
               and a.effective_date <= NOW()
               and (a.expiration_date is NULL or a.expiration_date >= NOW());
   if v_count > 0 then
     return 'Y';
   end if;
 
   IF a_qualifier_code = NULL THEN
     select count(*) into v_count from authorization a, function f1,
                                       function f2
        where f1.function_name = a.function_name
           and f1.IS_PRIMARY_AUTH_PARENT = 'Y'
 	  and a.kerberos_name = ai_user
           and a.do_function = 'Y'
           and NOW()
               between a.effective_date and IFNULL(a.expiration_date,NOW())
           and f2.function_name = a_function_name
           and f2.qualifier_type = 'NULL'
           and f2.primary_authorizable = 'Y'
           and f2.primary_auth_group = f1.primary_auth_group;
   else
     select count(*) into v_count from authorization a,
       primary_auth_descendent qd, qualifier q, function f1, function f2
       where f1.function_name = a.function_name
           and f1.IS_PRIMARY_AUTH_PARENT = 'Y'
 	  and a.kerberos_name = ai_user
           and qd.parent_id = a.qualifier_id
           and q.qualifier_id = qd.child_id
           and q.qualifier_code = a_qualifier_code
           and a.do_function = 'Y'
           and NOW()
               between a.effective_date and IFNULL(a.expiration_date,NOW())
           and f2.function_name = a_function_name
           and f2.primary_authorizable in ('Y', 'D')
           and f2.primary_auth_group = f1.primary_auth_group;
   end if;
   if v_count > 0 then
     return 'Y';
   end if;
 
   
 
   
   if ((a_do_function = 'Y') or (a_grant_and_view = 'GD')) then
      select count(*) into v_count from authorization
        where kerberos_name = ai_user
        and function_id = v_function_id
        and qualifier_code = a_qualifier_code
        and grant_and_view = 'GD'   
        and effective_date <= NOW()
        and (NOW() <= expiration_date or expiration_date is NULL);
        if v_count > 0 then
           return 'Y';
        end if;
   else
      select count(*) into v_count from authorization
        where kerberos_name = ai_user
        and function_id = v_function_id
        and qualifier_code = a_qualifier_code
        and grant_and_view in ('GV', 'GD') 
        and effective_date <= NOW()
        and (NOW() <= expiration_date or expiration_date is NULL);
        if v_count > 0 then
           return 'Y';
        end if;
   end if;
 
   
   select qualifier_id into v_qualifier_id from qualifier
     where qualifier_code = a_qualifier_code
     and qualifier_type = (select qualifier_type from function where
     function_name = a_function_name);
   if ((a_do_function = 'Y') or (a_grant_and_view = 'GD')) then
      select count(*) into v_count from authorization
        where kerberos_name = ai_user
        and function_id = v_function_id
        and descend = 'Y'
        and qualifier_id in (select parent_id from qualifier_descendent
          where child_id = v_qualifier_id)
        and grant_and_view = 'GD'   
        and effective_date <= NOW()
        and (NOW() <= expiration_date or expiration_date is NULL);
        if v_count > 0 then
           return 'Y';
        end if;
   else
      select count(*) into v_count from authorization
        where kerberos_name = ai_user
        and function_id = v_function_id
        and descend = 'Y'
        and qualifier_id in (select parent_id from qualifier_descendent
          where child_id = v_qualifier_id)
        and grant_and_view in ('GV', 'GD')   
        and effective_date <= NOW()
        and (NOW() <= expiration_date or expiration_date is NULL);
        if v_count > 0 then
           return 'Y';
        end if;
   end if;
 
   
   return 'N';
  END;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_can_create_function`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_can_create_function`(  a_user  varchar(20), a_category_code  VARCHAR(20)) RETURNS varchar(1) CHARSET latin1
BEGIN
            DECLARE v_count INT DEFAULT 0;
            DECLARE v_qualcode VARCHAR(30);
            DECLARE EXIT HANDLER FOR NOT FOUND RETURN 'N';


   SET v_qualcode = concat('CAT',a_category_code);  
   SET v_qualcode = RTRIM(v_qualcode);  
   select count(*) into v_count from authorization a, function f, qualifier q
 	where a.function_id = f.function_id and
 	      f.function_name = 'CREATE FUNCTIONS' and
 	      f.function_category = 'META' and
 	      a.qualifier_id = q.qualifier_id and
 	      q.qualifier_code in (v_qualcode, 'CATALL') and
 	      a.kerberos_name = a_user
               and a.do_function = 'Y'
               and a.effective_date <= NOW()
               and (a.expiration_date is NULL or a.expiration_date >= NOW());
   IF v_count > 0 THEN
      return 'Y';
   ELSE
      return 'N';
   END IF;
 END;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_can_create_rule`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_can_create_rule`(AI_USER  VARCHAR(20),
 		 AI_RESULT_FUNCTION_CATEGORY VARCHAR(20)) RETURNS varchar(1) CHARSET latin1
BEGIN
 	DECLARE v_count INT DEFAULT  0;
	DECLARE v_qualcode VARCHAR(30);
	DECLARE allow CHAR;

	DECLARE EXIT HANDLER FOR NOT FOUND RETURN 'N';

   SET   v_qualcode = concat('CAT',AI_RESULT_FUNCTION_CATEGORY);
   SET   v_qualcode = rtrim(v_qualcode);  

   select count(*) into v_count
 	from authorization a
 	where a.kerberos_name = AI_USER
 	and a.do_function = 'Y'
 	and a.qualifier_code = v_qualcode;
 
   select count(*) into v_count from authorization a
 	where a.function_name = 'CREATE IMPLIED AUTH RULES'
 	      and a.kerberos_name = AI_USER
               and a.qualifier_code = v_qualcode
               and a.do_function = 'Y'
 	      and NOW() between a.effective_date and IFNULL(a.expiration_date, NOW());
      IF v_count > 0 THEN
        RETURN 'Y';
      END IF;
 
     select count(*) into v_count
     from authorization a, qualifier_descendent qd, qualifier q
     where a.kerberos_name = AI_USER
     and q.qualifier_code = v_qualcode
     and a.function_name = 'CREATE IMPLIED AUTH RULES'
     and a.do_function = 'Y'
     and NOW() between a.effective_date and IFNULL(a.expiration_date, NOW())
     and qd.child_id = q.qualifier_id
     and qd.parent_id = a.qualifier_id;
 
   if v_count > 0 then
     return 'Y';
   end if;
 
   
   return 'N';
 
END;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_check_auth2`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_check_auth2`(a_function  VARCHAR(255),
                  a_qualifier  VARCHAR(30),
                  a_for_user  VARCHAR(30),
                  a_proxy_function  VARCHAR(30),
                  a_proxy_qualifier  VARCHAR(30)) RETURNS varchar(1) CHARSET latin1
BEGIN

  DECLARE v_retcode VARCHAR(1);
  DECLARE v_username VARCHAR(30);
  DECLARE v_temp VARCHAR(255);
  SET v_temp =  DBMS_OUTPUT.PUT_LINE(CONCAT('start auth_sf_check_auth2 for ',a_for_user)) ;
  if a_for_user is not NULL then
     SET v_retcode = ROLESAPI_IS_USER_AUTHORIZED(UC_USER_WITHOUT_HOST(), a_proxy_function,a_proxy_qualifier);
  
     if v_retcode = 'N' then
       return 'X';
     else
       SET v_username = a_for_user;
     end if;
   else
     SET v_username = UC_USER_WITHOUT_HOST();
   end if;
   
   
   SET v_username = upper(v_username);
   if substring(v_username, 1, 4) = 'OPS$' then
     SET v_username = substring(v_username, 5);
   end if;

   SET v_retcode = ROLESAPI_IS_USER_AUTHORIZED(v_username,a_function,a_qualifier);

   
   if v_retcode != 'Y' and a_function = 'MAINTAIN QUALIFIERS'
                       and a_qualifier = 'QUAL_SPGP' then
     SET v_retcode = ROLESAPI_IS_USER_AUTHORIZED(v_username, a_function,'QUAL_FUND');


   end if;

   return v_retcode;
END;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_check_date_mmddyyyy`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_check_date_mmddyyyy`(in_date VARCHAR(20)) RETURNS varchar(1) CHARSET latin1
begin
 
 DECLARE v_date DATE;
 DECLARE CONTINUE HANDLER FOR SQLEXCEPTION RETURN '0';

    SET v_date = str_to_date(in_date, "%m/%d/%Y");
   if SUBSTRING(in_date, 7, 4)  between '1980' and '2100' then
     return '1';
   else
     return '0';
   end if;	
 
END;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_check_date_noslash`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_check_date_noslash`(in_date VARCHAR(20)) RETURNS varchar(1) CHARSET latin1
begin
 
 DECLARE v_date varchar(10);
 DECLARE EXIT HANDLER FOR SQLEXCEPTION RETURN '0';

   SET v_date = str_to_date(in_date, "%m%d%Y");
   if SUBSTRING(in_date, 5, 4)  between '1980' and '2100' then
     return '1';
   else
     return '0';
   end if;
      
     
END;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_check_number`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_check_number`(in_number VARCHAR(20)) RETURNS varchar(1) CHARSET latin1
begin
   DECLARE v_number INT;
   DECLARE EXIT HANDLER FOR SQLEXCEPTION RETURN '0';


   SET v_number = CAST(in_number AS UNSIGNED);
   return '1';
 end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_check_version`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_check_version`(a_version  VARCHAR(10),
                  a_platform VARCHAR(20)) RETURNS varchar(255) CHARSET latin1
begin
 DECLARE v_message_type VARCHAR(1);
 DECLARE v_message_text VARCHAR(255);
 DECLARE v_last_name VARCHAR(30);
 DECLARE v_first_name VARCHAR(30);
 DECLARE v_mit_id VARCHAR(10);
   select message_type, message_text into v_message_type, v_message_text
    from application_version
    where IFNULL(a_platform, ' ') between from_platform and to_platform
    and IFNULL(a_version, ' ') between from_version and to_version
    and rownum = 1;
   if v_message_type = 'N' then
     return 'N_';
   else
     return CONCAT(v_message_type , '_You are running version ''' , a_version
            , ''' on ''' , a_platform , '''. ' , v_message_text);
   end if;
 end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_convert_date_to_str`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_convert_date_to_str`(a_source_date DATE) RETURNS varchar(255) CHARSET latin1
begin
	DECLARE  v_target_date_format VARCHAR(255) DEFAULT '%m/%d/%Y %H:%i:%s';

   if a_source_date = null then /* if 8 spaces are used */
 	return null;
   end if;
   return date_format(a_source_date,v_target_date_format) ;

END;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_convert_str_to_date`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_convert_str_to_date`(a_source_date VARCHAR(25)) RETURNS date
begin
	DECLARE  v_target_date_format VARCHAR(255) DEFAULT '%m%d%Y %H:%i:%s';

   if a_source_date = '        ' then 
 	return null;
   end if;
   return str_to_date(CONCAT(a_source_date , ' 00:00:00'), v_target_date_format) ;
    
END;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_convert_user`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_convert_user`(a_user VARCHAR(30)) RETURNS varchar(16) CHARSET latin1
begin
 DECLARE v_username VARCHAR(16);
 SET v_username = UPPER(a_user);
 IF  SUBSTRING(v_username, 1, 4) = 'OPS$' THEN
     SET v_username = substring(v_username, 5);
 END IF;
   return v_username;
END;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_edit_function`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_edit_function`(a_function_name  VARCHAR(255),
                  a_do_function  VARCHAR(1),
                  a_grant_and_view  VARCHAR(2),
                  a_effective_date  DATETIME,
                  a_expiration_date  DATETIME) RETURNS varchar(255) CHARSET latin1
begin
 DECLARE v_function_name varchar(33);
   SET v_function_name = a_function_name;
   
   if ( (a_do_function = 'N') OR (a_effective_date > NOW())
        OR (IFNULL(a_expiration_date, NOW()) < NOW()) ) then
     SET v_function_name = CONCAT('(', v_function_name , ')');
   end if;
   
   if (a_grant_and_view = 'GD') then
     SET v_function_name = CONCAT('+', v_function_name);
   end if;
   return v_function_name;
END;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_get_1st_token`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_get_1st_token`(a_list VARCHAR(1000)) RETURNS varchar(20) CHARSET latin1
BEGIN
 DECLARE v_token VARCHAR(20) DEFAULT '';
 DECLARE v_pos1 INT;
 DECLARE v_pos2 INT;
   SET v_pos1 = 1;
   while substring(a_list,v_pos1,1) = ' ' DO	  
     SET v_pos1 = v_pos1 + 1;
     if v_pos1 = length(a_list) then
       return v_token;
     end if;
   end WHILE;
   SET v_pos2 = LOCATE(' ', a_list,  v_pos1);  
   if v_pos2 = 0 then
     SET v_pos2 = length(a_list) + 1;
   end if;
   
   SET v_token = substring(a_list, v_pos1, v_pos2 - v_pos1);
   return v_token;
 end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_get_correct_value`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_get_correct_value`(a_value VARCHAR(255)) RETURNS varchar(255) CHARSET latin1
begin
   if RTRIM(LOWER(a_value)) = '<me>' then
      return UC_USER_WITHOUT_HOST() ;
   else
      return a_value;
   end if;
 END;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_get_fragment`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_get_fragment`(C_ID  INTEGER, C_VALUE  VARCHAR(255) 	) RETURNS varchar(255) CHARSET latin1
BEGIN
 
 DECLARE COND_FRAGMENT VARCHAR(255) DEFAULT '';
 DECLARE RETURN_FRAGMENT VARCHAR(255) DEFAULT '';
 DECLARE REPLACE_STR VARCHAR(10) DEFAULT '?';
 DECLARE SUB_STR1 VARCHAR(10) DEFAULT '';
 DECLARE SUB_STR2 VARCHAR(10) DEFAULT  '''';

   SELECT RTRIM(LTRIM(C.SQL_FRAGMENT)) INTO COND_FRAGMENT FROM CRITERIA C WHERE C.CRITERIA_ID = C_ID;
   IF (COND_FRAGMENT != 'NULL' && COND_FRAGMENT IS NOT NULL && TRIM(COND_FRAGMENT) != '') THEN
      IF LOCATE('%?%',COND_FRAGMENT) > 0 THEN
       	SET REPLACE_STR = '%?%';
         SET SUB_STR1 = '%';
 	      SET SUB_STR2 = '%''';
      ELSEIF LOCATE('?%',  COND_FRAGMENT) > 0 THEN
 	      SET REPLACE_STR = '?%';
 	      SET SUB_STR2 = '%''';
      ELSEIF LOCATE('?',COND_FRAGMENT) = 0 THEN
 	      RETURN COND_FRAGMENT;
      END IF;
         SET RETURN_FRAGMENT = REPLACE(COND_FRAGMENT, REPLACE_STR, CONCAT('''' , SUB_STR1,upper(C_VALUE), SUB_STR2));
   END IF;
   RETURN RETURN_FRAGMENT;
 end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_get_scrn_id`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_get_scrn_id`(a_selection_id INTEGER) RETURNS int(11)
begin
 DECLARE scrn_id integer DEFAULT 0;
	DECLARE EXIT HANDLER FOR NOT FOUND RETURN 0;

 
   select ss.screen_id into scrn_id from selection_set ss
 	where ss.selection_id = a_selection_id and ROWNUM < 2;
   return scrn_id;
 end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_is_auth_active`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_is_auth_active`(a_do_function VARCHAR(1),
                  a_effective_date date,
                  a_expiration_date date) RETURNS varchar(1) CHARSET latin1
begin
   if (a_do_function = 'Y') and (a_effective_date <= NOW())
       and (IFNULL(a_expiration_date,NOW()) >= NOW()) then
     return 'Y';
   else
     return 'N';
   end if;
 
END;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_is_auth_current`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_is_auth_current`(a_effective_date  date,
                  a_expiration_date  date) RETURNS char(1) CHARSET latin1
begin
   if (a_effective_date <= NOW())
       and (IFNULL(a_expiration_date,NOW()) >= NOW()) then
     return 'Y';
   else
     return 'N';
   end if;

END;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_qual_subtype`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_qual_subtype`(a_qual_type  VARCHAR(30),
                  a_qual_code  VARCHAR(30),
                  a_qual_ch  VARCHAR(30)) RETURNS varchar(255) CHARSET latin1
begin
   if (a_qual_type = 'COST') then
     if (SUBSTRING(a_qual_code,1,2) = 'P_') then
        return 'Group of child WBSs, diff. prof. ctr.';
     elseif (a_qual_ch = 'Y') then
        return 'Custom group of prof ctr. or cost coll.';
     elseif (SUBSTRING(a_qual_code,1,4) = '0HPC') then
        return 'Group of profit centers';
     elseif (SUBSTRING(a_qual_code,1,3) = '0PC') then
        return 'Profit center';
     elseif (SUBSTRING(a_qual_code,1,1) = 'C') then
        return 'Cost center';
     elseif (SUBSTRING(a_qual_code,1,1) = 'I') then
        return 'Internal order';
     elseif (SUBSTRING(a_qual_code,1,1) = 'P') then
        return 'Project';
     else
        return 'Unknown';
     end if;
   elseif (a_qual_type = 'PROF') then
     if (a_qual_ch = 'Y') then
        return 'Custom group of profit centers';
     elseif (SUBSTRING(a_qual_code,1,3) = '0HP') then
        return 'Group of profit centers';
     elseif (SUBSTRING(a_qual_code,1,2) = 'PC') then
        return 'Profit center';
     else
        return 'Unknown';
     end if;
   elseif (a_qual_type = 'FUND') then
     if (a_qual_ch = 'Y') then
        return 'Custom group of fund centers';
     elseif (SUBSTRING(a_qual_code,1,2) = 'FC') then
        return 'Fund center';
     elseif (SUBSTRING(a_qual_code,1,1) = 'F') then
        return 'Fund';
     else
        return 'Unknown';
     end if;
   else
     return '';
   end if;
 end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_remove_token`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_remove_token`(a_token  VARCHAR(10),
                  a_list  VARCHAR(1000)) RETURNS varchar(1000) CHARSET latin1
BEGIN
 DECLARE v_list VARCHAR(1000) ;
 DECLARE v_list_left VARCHAR(1000);
 DECLARE v_list_right VARCHAR(1000);
 DECLARE v_continue INTEGER DEFAULT 1;
 DECLARE v_pos1 INTEGER;
 DECLARE v_pos2 INTEGER;
 SET v_list = a_list;
 
   if (substr(v_list,1,1) != ' ') then  
     SET v_list = CONCAT(' ' , v_list);
   end if;
   if (substr(v_list,length(v_list),1) != ' ') then  
     SET v_list = CONCAT(v_list , ' ');
   end if;
   while v_continue = 1 DO
     SET v_pos1 = LOCATE(CONCAT(' ' , a_token , ' '), v_list);  
     if v_pos1 > 0 then
       SET v_list_left = substr(v_list, 1, v_pos1);  
       SET v_list_right = substr(v_list, v_pos1+length(a_token)+2);  
       SET v_list = CONCAT(v_list_left , v_list_right);
     else
       SET v_continue = 0;
     end if;
   end WHILE;
   return v_list;
 end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`auth_sf_user_priv_list`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`auth_sf_user_priv_list`(ai_user VARCHAR(20)) RETURNS varchar(255) CHARSET latin1
BEGIN

 DECLARE v_count INTEGER DEFAULT 0;
 DECLARE v_user VARCHAR(20);
 DECLARE v_priv_array varchar(10) DEFAULT 'NNNNNNNNNN';

 SET v_user = upper(ai_user);
 if v_user = '*' then 
      SET v_user = UC_USER_WITHOUT_HOST();
 end if;
   
 select count(*) into v_count from authorization a
     where a.function_name in ('CREATE AUTHORIZATIONS', 'PRIMARY AUTHORIZOR')
             and a.function_category = 'META' and
             a.kerberos_name = v_user
             and a.do_function = 'Y'
             and a.effective_date <= NOW()
             and (a.expiration_date is NULL or a.expiration_date >= NOW());
   select count(*) into v_count from authorization a, function f
       where a.function_id = f.function_id
               and (f.is_primary_auth_parent = 'Y'
                    or f.function_name = 'CREATE AUTHORIZATIONS')
               and a.kerberos_name = v_user
               and a.do_function = 'Y'
               and a.effective_date <= NOW()
               and (a.expiration_date is NULL or a.expiration_date >= NOW());
   if v_count > 0 then
     SET v_priv_array = CONCAT('Y' , substring(v_priv_array,2));
   else
     select count(*) into v_count from authorization a
         where a.kerberos_name = v_user
               and a.grant_and_view in ('GV','GD')
               and a.effective_date <= NOW()
               and (a.expiration_date is NULL or a.expiration_date >= NOW());
     if v_count > 0 then
       SET v_priv_array = CONCAT('Y' ,substring(v_priv_array,2));
     end if;
   end if;
 
   
   select count(*) into v_count from authorization a
         where a.function_name = 'CREATE FUNCTIONS' and
               a.function_category = 'META' and
               a.kerberos_name = v_user
               and a.effective_date <= NOW()
               and (a.expiration_date is NULL or a.expiration_date >= NOW());
   if v_count > 0 then
     SET v_priv_array = CONCAT(substring(v_priv_array,1,1), 'Y',substring(v_priv_array,3));
   end if;
 
   return v_priv_array;
 
END;

 $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_ancestors_qc`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_ancestors_qc`(  IN a_qual_id  VARCHAR(100),  IN a_list     VARCHAR(500), OUT v_out_list VARCHAR(1000))
BEGIN
   DECLARE record_not_found INT DEFAULT 0;
   DECLARE v_temp VARCHAR(1000) DEFAULT '';
   DECLARE v_qual_id BIGINT;
   DECLARE v_msg VARCHAR(255);
   DECLARE v_new_list VARCHAR(255);
   DECLARE get_ancestors CURSOR FOR SELECT parent_id from qualifier_child where child_id = a_qual_id;

   DECLARE CONTINUE HANDLER FOR NOT FOUND SET record_not_found = 1;

   
   OPEN get_ancestors;

   IF (a_list is NULL || trim(a_list)='') THEN
     SET v_out_list = ' ';
   ELSE
     SET v_out_list = a_list;
   END IF;
	 FETCH get_ancestors INTO v_qual_id;
	 WHILE   NOT record_not_found   DO
           
           SET v_out_list = CONCAT(v_out_list , CAST(v_qual_id AS CHAR)  , ' ');
           

			     IF length(v_out_list) < 800 THEN  
			        CALL auth_sp_ancestors_qc(CAST(v_qual_id AS CHAR), v_out_list,v_new_list);
              SET v_out_list =  v_new_list;
	         END IF;
          FETCH get_ancestors INTO v_qual_id;
   END WHILE;
   CLOSE get_ancestors;

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_ancestors_qd`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_ancestors_qd`(  IN a_qual_id  VARCHAR(100), OUT v_out_list VARCHAR(1000))
BEGIN

  DECLARE record_not_found INT DEFAULT 0;
	DECLARE v_qual_id BIGINT;
 

  DECLARE get_ancestors CURSOR FOR SELECT parent_id from qualifier_descendent where child_id = a_qual_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET record_not_found = 1;
  OPEN get_ancestors;
  SET v_out_list = ' ';
  FETCH get_ancestors INTO v_qual_id;
	WHILE   NOT record_not_found   DO
                     SET v_out_list = CONCAT(v_out_list,CAST(v_qual_id AS CHAR),' ');
                     FETCH get_ancestors INTO v_qual_id;
  END WHILE;
  CLOSE get_ancestors;

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_check_version`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_check_version`(IN a_version  VARCHAR(20),
                 IN  a_platform  VARCHAR(50),
                 OUT  a_message  VARCHAR(255))
BEGIN
 DECLARE v_message_type VARCHAR(10);
 DECLARE v_message_text VARCHAR(255);
 DECLARE v_last_name VARCHAR(255);
 DECLARE v_first_name VARCHAR(255);
 DECLARE v_mit_id VARCHAR(10);
 
 select last_name, first_name, mit_id
    into v_last_name, v_first_name, v_mit_id
    from person
    where kerberos_name = upper(UC_USER_WITHOUT_HOST());
   insert into connect_log
    (roles_username, connect_date, client_version, client_platform,
     last_name, first_name, mit_id)
    values (UC_USER_WITHOUT_HOST(), NOW(), a_version, a_platform,
     v_last_name, v_first_name, v_mit_id);
   select message_type, message_text into v_message_type, v_message_text
    from application_version
    where IFNULL(a_platform, ' ') between from_platform and to_platform
    and IFNULL(a_version, ' ') between from_version and to_version
    and rownum = 1;
   if v_message_type = 'N' then
     SET a_message = 'N_';
   else
     SET a_message = CONCAT(v_message_type , '_You are running version ''' , a_version
            , ''' on ''' , a_platform , '''. ' , v_message_text);
   end if;
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_copy_authorizations`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_copy_authorizations`(IN ai_category VARCHAR(30),
 	         IN ai_source_kerberos_name   VARCHAR(10),
 		 IN ai_dest_kerberos_name   VARCHAR(10),
                  OUT ao_message  VARCHAR(255))
BEGIN
 DECLARE  v_date date DEFAULT NOW(); 
 DECLARE  v_count INTEGER;
 DECLARE  v_count2 INTEGER;
 DECLARE  v_count3 INTEGER;
 DECLARE  v_user_count INTEGER;
 DECLARE  a_source_kerberos_name VARCHAR(10);
 DECLARE  a_dest_kerberos_name VARCHAR(10);
 DECLARE  a_category VARCHAR(30);
 DECLARE  a_bad_function VARCHAR(60);
 DECLARE  a_bad_qc VARCHAR(20);
 
 SET a_source_kerberos_name = upper(ai_source_kerberos_name);
 SET a_dest_kerberos_name = upper(ai_dest_kerberos_name);
 SET a_category = upper(ai_category);
   
 select count(*) into v_user_count from person
     where kerberos_name = a_dest_kerberos_name;
   
   select count(*) into v_count from AUTHORIZATION A1
 	where A1.kerberos_name = a_source_kerberos_name
         and A1.function_category = a_category
         and not exists (SELECT A2.AUTHORIZATION_ID FROM AUTHORIZATION A2
            WHERE A2.KERBEROS_NAME = a_dest_kerberos_name
            AND A2.FUNCTION_ID = A1.FUNCTION_ID
            AND A2.QUALIFIER_CODE = A1.QUALIFIER_CODE)
         and auth_sf_can_create_auth(UC_USER_WITHOUT_HOST(), A1.function_name, A1.qualifier_code,
         A1.do_function, A1.grant_and_view) = 'Y';
   
   select count(*) into v_count2 from AUTHORIZATION A1
 	where A1.kerberos_name = a_source_kerberos_name
         and A1.function_category = a_category
         and not exists (SELECT A2.AUTHORIZATION_ID FROM AUTHORIZATION A2
            WHERE A2.KERBEROS_NAME = a_dest_kerberos_name
            AND A2.FUNCTION_ID = A1.FUNCTION_ID
            AND A2.QUALIFIER_CODE = A1.QUALIFIER_CODE);
   
   if v_count2 > v_count then
     SET v_count3 = v_count2 - v_count;
     select A1.function_name, A1.qualifier_code into a_bad_function, a_bad_qc
         from AUTHORIZATION A1 LEFT OUTER JOIN authorization A2 ON A1.kerberos_name = a_dest_kerberos_name AND A2.function_id = A1.function_id 
         AND A2.qualifier_code = A1.qualifier_code
    WHERE A1.kerberos_name = a_source_kerberos_name
         and A1.function_category = a_category
         and A2.function_id is NULL
         and rownum = 1
         and auth_sf_can_create_auth(UC_USER_WITHOUT_HOST(),
           A1.function_name, A1.qualifier_code,
         A1.do_function, A1.grant_and_view) = 'N';
     SET ao_message = CONCAT('You are not authorized to copy ' ,CAST(v_count3 AS CHAR)
          , ' of the ' , CAST(v_count2 AS CHAR) , ' authorizations, e.g., '
          , a_bad_function , ', qual=' , a_bad_qc);
     SET ao_message = 'You are not authorized to copy all these authorizations';
   elseif v_count = 0 then
     SET ao_message = CONCAT('No authorizations to be copied for ''' ,
       a_source_kerberos_name , ''' in category ''' ,
       a_category , '''');
   elseif v_user_count = 0 then
     SET ao_message = CONCAT('Destination kerberos_name ''' ,
        a_dest_kerberos_name , ''' does not exist.');
   else
       insert into authorization
       select 
       
                   A1.FUNCTION_ID, a1.QUALIFIER_ID,
                   a_dest_kerberos_name,
 		  A1.QUALIFIER_CODE, A1.FUNCTION_NAME, A1.FUNCTION_CATEGORY,
                   A1.QUALIFIER_NAME, UC_USER_WITHOUT_HOST(), v_date, A1.DO_FUNCTION,
                   A1.GRANT_AND_VIEW, A1.DESCEND,
 	          greatest(A1.EFFECTIVE_DATE, NOW()),
                   A1.EXPIRATION_DATE from authorization A1
 	  where A1.kerberos_name = a_source_kerberos_name
           and A1.function_category = a_category
           and not exists (SELECT A2.AUTHORIZATION_ID FROM AUTHORIZATION A2
             WHERE A2.KERBEROS_NAME = a_dest_kerberos_name
             AND A2.FUNCTION_ID = A1.FUNCTION_ID
             AND A2.QUALIFIER_CODE = A1.QUALIFIER_CODE);
      SET ao_message = CONCAT(CAST(v_count AS CHAR) , ' authorizations copied.');
   end if;
 end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_create_auth2`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_create_auth2`(IN  AI_FUNCTION_NAME VARCHAR(60),
 		 IN  AI_QUALIFIER_CODE  VARCHAR(60),
 		 IN  AI_KERBEROS_NAME  VARCHAR(10),
 		 IN  AI_DO_FUNCTION  VARCHAR(1),
 		 IN  AI_GRANT_AND_VIEW  VARCHAR(3),
 		 IN  AI_DESCEND  VARCHAR(10),
 		 IN  AI_EFFECTIVE_DATE  VARCHAR(20),
 		 IN  AI_EXPIRATION_DATE  VARCHAR(20),
 		 OUT a_modified_by  VARCHAR(40),
 		 OUT a_modified_date  VARCHAR(20),
                 OUT a_authorization_id  INTEGER
 		)
BEGIN

 DECLARE V_KERBEROS_NAME VARCHAR(10);
 DECLARE V_QUALIFIER_ID INTEGER;
 DECLARE V_QUALIFIER_CODE VARCHAR(20);
 DECLARE V_QUALIFIER_NAME VARCHAR(50);
 DECLARE V_QUALIFIER_TYPE VARCHAR(20);
 DECLARE V_FUNCTION_ID INTEGER;
 DECLARE V_FUNCTION_NAME VARCHAR(255);
 DECLARE V_FUNCTION_CATEGORY VARCHAR(20);
 DECLARE v_status integer;
 DECLARE v_msg_no INTEGER;
 DECLARE v_msg VARCHAR(255);
 DECLARE A_FUNCTION_NAME VARCHAR(255);
 DECLARE A_QUALIFIER_CODE VARCHAR(50);
 DECLARE A_KERBEROS_NAME VARCHAR(10);
 DECLARE A_DO_FUNCTION VARCHAR(1);
 DECLARE A_GRANT_AND_VIEW VARCHAR(2);
 DECLARE A_DESCEND VARCHAR(10);
 DECLARE A_EFFECTIVE_DATE varchar(255);
 DECLARE A_EXPIRATION_DATE varchar(255);
 
  	
  DECLARE EXIT HANDLER FOR 1022
  	BEGIN
  		SET v_msg_no = -20007;
 	 	SET v_msg = roles_msg(-20007);
   		CALL permit_signal(v_msg,v_msg_no);
 
  	END;

 DECLARE EXIT HANDLER FOR NOT FOUND 
 	BEGIN
             if v_status = 1 then
 		   SET v_msg_no = -20001;
 		   SET v_msg = roles_msg(-20001);
             elseif v_status = 2 then
                    SET v_msg_no = -20017;
                    SET v_msg = roles_msg(-20017);
             else
 		   SET v_msg_no = -20003;
 		   SET v_msg = roles_msg(-20003);
             end if;
   		CALL permit_signal(v_msg,v_msg_no);
 
 	END;
 	
 DECLARE EXIT HANDLER FOR SQLEXCEPTION
 	BEGIN
 		SET v_msg_no = -20007;
	 	SET v_msg = roles_msg(-20007);
   		CALL permit_signal(v_msg,v_msg_no);
 
 	END;

   SET a_kerberos_name = upper(ai_kerberos_name);
   SET a_function_name = upper(ai_function_name);
   SET a_qualifier_code = upper(ai_qualifier_code);
   SET a_do_function = upper(ai_do_function);
   SET a_grant_and_view = upper(ai_grant_and_view);
   SET a_descend = upper(ai_descend);
   SET a_effective_date = upper(ai_effective_date);
   SET a_expiration_date = upper(ai_expiration_date);
 
   
   if (a_grant_and_view = 'Y ' || a_grant_and_view = 'GD') then
     SET a_grant_and_view = 'GD';
   else
     SET a_grant_and_view = 'N ';
   end if;
 
   SET v_status = 1;  
   select function_id, function_name, function_category, qualifier_type
     into v_function_id, v_function_name, v_function_category, v_qualifier_type
     from function
     where function_name = a_function_name;
 
   SET v_status = 2;  
   select qualifier_id, qualifier_code, qualifier_name
     into v_qualifier_id, v_qualifier_code, v_qualifier_name
     from qualifier where qualifier_code = a_qualifier_code
     and qualifier_type = v_qualifier_type;
 
   SET v_status = 3;  
   select kerberos_name into v_kerberos_name
     from person where kerberos_name = a_kerberos_name;
 
  
  

   if (v_qualifier_type = 'DEPT'
       and substring(v_qualifier_code, 1, 2) != 'D_') then
   		CALL permit_signal(roles_msg(-20015),-20015);
 
    end if;
 
   
 
   IF auth_sf_can_create_auth(UC_USER_WITHOUT_HOST(), AI_FUNCTION_NAME, AI_QUALIFIER_CODE,
 	AI_DO_FUNCTION, AI_GRANT_AND_VIEW) = 'N' then
   		CALL permit_signal(roles_msg(-20014),-20014);
	
   ELSE	
 	insert into authorization
 	values( V_FUNCTION_ID, V_QUALIFIER_ID,
 		A_KERBEROS_NAME, V_QUALIFIER_CODE, V_FUNCTION_NAME,
 		V_FUNCTION_CATEGORY, V_QUALIFIER_NAME, UC_USER_WITHOUT_HOST(),
 		NOW(), A_DO_FUNCTION, A_GRANT_AND_VIEW, A_DESCEND,
 		greatest(auth_sf_convert_str_to_date(A_EFFECTIVE_DATE),
                         NOW()),
 		auth_sf_convert_str_to_date(A_EXPIRATION_DATE));
   SET a_modified_by = UC_USER_WITHOUT_HOST();
   SET a_modified_date = auth_sf_convert_date_to_str(NOW());
   select authorization_id into a_authorization_id
     from authorization where kerberos_name = a_kerberos_name
     and function_category = V_FUNCTION_CATEGORY
     and function_name = V_FUNCTION_NAME
     and qualifier_code = V_QUALIFIER_CODE;
 END IF;
 end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_create_authorizations`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_create_authorizations`(IN AI_FUNCTION_NAME VARCHAR(50),
 		 IN AI_QUALIFIER_CODE  VARCHAR(20),
 		 IN AI_KERBEROS_NAME  VARCHAR(20),
 		 IN AI_DO_FUNCTION  VARCHAR(10),
 		 IN AI_GRANT_AND_VIEW  VARCHAR(2),
 		 IN AI_DESCEND  VARCHAR(10),
 		 IN AI_EFFECTIVE_DATE  VARCHAR(20),
 		 IN AI_EXPIRATION_DATE  VARCHAR(20),
 		 OUT a_modified_by  VARCHAR(20),
 		 OUT a_modified_date  VARCHAR(20)
 		)
BEGIN
 DECLARE V_KERBEROS_NAME VARCHAR(20);
 DECLARE V_QUALIFIER_ID INTEGER;
 DECLARE V_QUALIFIER_CODE VARCHAR(20);
 DECLARE V_QUALIFIER_NAME VARCHAR(20);
 DECLARE V_QUALIFIER_TYPE VARCHAR(20);
 DECLARE V_FUNCTION_ID INTEGER;
 DECLARE V_FUNCTION_NAME VARCHAR(50);
 DECLARE V_FUNCTION_CATEGORY VARCHAR(20);
 DECLARE v_status integer;
 DECLARE v_msg_no INTEGER;
 DECLARE v_msg VARCHAR(255);
 DECLARE A_FUNCTION_NAME VARCHAR(50);
 DECLARE A_QUALIFIER_CODE VARCHAR(20);
 DECLARE A_KERBEROS_NAME VARCHAR(20);
 DECLARE A_DO_FUNCTION VARCHAR(10);
 DECLARE A_GRANT_AND_VIEW VARCHAR(10);
 DECLARE A_DESCEND VARCHAR(10);
 DECLARE A_EFFECTIVE_DATE varchar(255);
 DECLARE A_EXPIRATION_DATE varchar(255);
 
	DECLARE EXIT HANDLER FOR 1022
  	BEGIN
  		SET v_msg_no = -20007;
 	 	SET v_msg = roles_msg(-20007);
   		CALL permit_signal(v_msg,v_msg_no);
 
  	END;

	DECLARE EXIT HANDLER FOR NOT FOUND 
 	BEGIN
             if v_status = 1 then
 		SET v_msg_no = -20001;
 	 	SET v_msg = roles_msg(-20001);
             elseif v_status = 2 then
 		SET v_msg_no = -20017;
 	 	SET v_msg = roles_msg(-20017);
             else
 		SET v_msg_no = -20003;
 	 	SET v_msg = roles_msg(-20003);
             end if;
   		CALL permit_signal(v_msg,v_msg_no);
 
 	END;
 	
 	DECLARE EXIT HANDLER FOR SQLEXCEPTION
 	BEGIN
 		SET v_msg_no = -20007;
 	 	SET v_msg = roles_msg(-20007);
   		CALL permit_signal(v_msg,v_msg_no);
 	END;


	SET a_kerberos_name = upper(ai_kerberos_name);
	SET a_function_name = upper(ai_function_name);
	SET a_qualifier_code = upper(ai_qualifier_code);
	SET a_do_function = upper(ai_do_function);
	SET a_grant_and_view = upper(ai_grant_and_view);
	SET a_descend = upper(ai_descend);
	SET a_effective_date = upper(ai_effective_date);
	SET a_expiration_date = upper(ai_expiration_date);
   
	if (a_grant_and_view = 'Y ' or a_grant_and_view = 'GD') then
     		SET a_grant_and_view = 'GD';
   	else
   	  SET a_grant_and_view = 'N ';
   end if;
   SET v_status = 1;  
   select function_id, function_name, function_category, qualifier_type
     into v_function_id, v_function_name, v_function_category, v_qualifier_type
     from function
     where function_name = a_function_name;
   SET v_status = 2;  
   select qualifier_id, qualifier_code, qualifier_name
     into v_qualifier_id, v_qualifier_code, v_qualifier_name
     from qualifier where qualifier_code = a_qualifier_code
     and qualifier_type = v_qualifier_type;
   SET v_status = 3;  
   select kerberos_name into v_kerberos_name
     from person where kerberos_name = a_kerberos_name;
    
   if auth_sf_can_create_auth(USER, AI_FUNCTION_NAME, AI_QUALIFIER_CODE,
 	AI_DO_FUNCTION, AI_GRANT_AND_VIEW) = 'N' then
  		SET v_msg_no = -20014;
 	 	SET v_msg = roles_msg(-20014);
	  	
   		CALL permit_signal(v_msg,v_msg_no);
 
   ELSE 	 	
   insert into authorization
 	values( V_FUNCTION_ID, V_QUALIFIER_ID,
 		A_KERBEROS_NAME, V_QUALIFIER_CODE, V_FUNCTION_NAME,
 		V_FUNCTION_CATEGORY, V_QUALIFIER_NAME, user,
 		NOW(), A_DO_FUNCTION, A_GRANT_AND_VIEW, A_DESCEND,
 		auth_sf_convert_str_to_date(A_EFFECTIVE_DATE),
 		auth_sf_convert_str_to_date(A_EXPIRATION_DATE));
   SET a_modified_by = UC_USER_WITHOUT_HOST();
   SET a_modified_date = auth_sf_convert_date_to_str(NOW());
      end if;

 end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_create_function`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_create_function`(IN ai_function_name  VARCHAR(255),
 		 IN ai_function_description  VARCHAR(255),
 		 IN ai_function_category  VARCHAR(30),
 		 IN ai_qualifier_type  VARCHAR(30),
 		 OUT a_creator  VARCHAR(20),
 		 OUT a_modified_by  VARCHAR(20),
 		 OUT a_modified_date  VARCHAR(20)
 		)
BEGIN
 
 DECLARE v_qualifier_type VARCHAR(30);
 DECLARE v_function_category VARCHAR(30);
 DECLARE a_function_name VARCHAR(255);
 DECLARE a_function_description VARCHAR(30);
 DECLARE a_function_category VARCHAR(30);
 DECLARE a_qualifier_type VARCHAR(30);
 DECLARE v_status INTEGER;
 DECLARE v_msg_no INTEGER;
 DECLARE v_msg VARCHAR(255);

 	DECLARE EXIT HANDLER FOR 1022
  	BEGIN
  		SET v_msg_no = -20009;
 	 	SET v_msg = roles_msg(-20009);
   		CALL permit_signal(v_msg,v_msg_no);
 
 	END;

  	DECLARE EXIT HANDLER FOR NOT FOUND
  	BEGIN
              if v_status = 1 then
  		           SET v_msg_no = -20008;
  		           SET v_msg = roles_msg(-20008);
              elseif v_status = 2 then
                 SET v_msg_no = -20016;
                 SET v_msg = roles_msg(-20016);
              end if;
   		CALL permit_signal(v_msg,v_msg_no);
 
 	END;
  		
  	DECLARE EXIT HANDLER FOR SQLEXCEPTION
  	BEGIN
  		SET v_msg_no = -20009;
 	 	SET v_msg = roles_msg(-20009);
 
   		CALL permit_signal(v_msg,v_msg_no);
 	END;
		
 
   SET a_function_name = upper(ai_function_name);
   SET a_function_description = ai_function_description; 
   SET  a_function_category = upper(ai_function_category);
   SET a_qualifier_type = upper(ai_qualifier_type);
   if auth_sf_can_create_function(UC_USER_WITHOUT_HOST(), a_function_category) = 'N' then
	  		SET v_msg_no = -20014;
	 	 	SET v_msg =  CONCAT( 'Not authorized to create functions in category ''', a_function_category , '''');
   		CALL permit_signal(v_msg,v_msg_no);
 
   ELSE	 	 	
	   SET v_status = 1;
	   select qualifier_type into v_qualifier_type from qualifier_type where
	     qualifier_type = a_qualifier_type; 
	   SET v_status = 2;
	   select function_category into v_function_category from category where
	     function_category = a_function_category; 
	   insert into function
		 (function_name, function_description, function_category,
		  creator, modified_by, modified_date, qualifier_type) 
		values( a_function_name,
			a_function_description, a_function_category,
			UC_USER_WITHOUT_HOST(), UC_USER_WITHOUT_HOST(), NOW(), a_qualifier_type);
	   SET a_creator = UC_USER_WITHOUT_HOST();
	   SET a_modified_by = UC_USER_WITHOUT_HOST();
	   SET a_modified_date = auth_sf_convert_date_to_str(NOW()	);
   END IF;
 end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_delete_authorizations`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_delete_authorizations`( IN a_auth_id INTEGER)
BEGIN
 
  DECLARE V_FUNCTION_NAME VARCHAR(255);
  DECLARE V_QUALIFIER_CODE VARCHAR(30);
  DECLARE V_DO_FUNCTION VARCHAR(1);
  DECLARE  V_GRANT_AND_VIEW VARCHAR(2);
  DECLARE ao_message varchar(255);
  
  DECLARE EXIT HANDLER  FOR NOT FOUND
   		CALL permit_signal(roles_msg(-20020),-20020);
 
  
    select function_name, qualifier_code, do_function, grant_and_view
          into V_FUNCTION_NAME, V_QUALIFIER_CODE, V_DO_FUNCTION, V_GRANT_AND_VIEW
          from authorization
          where authorization_id = a_auth_id;
    if auth_sf_can_create_auth(UC_USER_WITHOUT_HOST(), V_FUNCTION_NAME, V_QUALIFIER_CODE,
          V_DO_FUNCTION, V_GRANT_AND_VIEW) = 'N' then
      SET ao_message = CONCAT('You are not authorized to delete ', ' this authorization. function=', V_FUNCTION_NAME ,', qual=' , v_qualifier_code);
   		CALL permit_signal(roles_msg(-20014),-20014);
 
    end if;
 	  delete from authorization where authorization_id = a_auth_id;
  end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_delete_function`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_delete_function`(a_function_id INTEGER)
BEGIN
 DECLARE v_function_category VARCHAR(30);
 DECLARE v_count INTEGER DEFAULT 0;
 DECLARE v_msg_no INTEGER DEFAULT 0;
  DECLARE v_msg VARCHAR(100) ;

  DECLARE EXIT HANDLER FOR NOT FOUND 
  	BEGIN
  		   SET v_msg_no = -20019;
  		   SET v_msg = roles_msg(-20019);
  		   CALL permit_signal(v_msg,v_msg_no);
  	END;

   

   SELECT function_category into v_function_category
         from function
   WHERE function_id = a_function_id;
 	
   IF auth_sf_can_create_function(user, a_function_category) = 'N' then
	  		SET v_msg_no = -20014;
	 	 	SET v_msg =  CONCAT( 'Not authorized to delete functions in category ''', v_function_category , v_function_category);
	 	 	CALL permit_signal(v_msg,v_msg_no);

   ELSE	 	 	
	   select count(*) into v_count
	         from authorization
	 	where function_id = a_function_id;
	   IF v_count > 0 then
	 	SET v_msg_no = -20022;
	  	SET v_msg =  CONCAT( 'Function cannot be deleted. ' ,CAST(v_count AS CHAR) , ' authorizations' , ' reference this function');
   		CALL permit_signal(v_msg,v_msg_no);
 
	   ELSE
	   	delete FROM function where function_id = a_function_id;
	   END IF;
   end if;
 end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_delete_qual`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_delete_qual`(IN ai_qualtype     VARCHAR(20),
                  IN ai_qualcode     VARCHAR(20),
                  IN ai_for_user     VARCHAR(50),
                  OUT ao_message     VARCHAR(255))
BEGIN
 DECLARE v_qualid INTEGER;
 DECLARE v_count INTEGER;
 DECLARE v_count2 INTEGER;
 DECLARE v_count3 INTEGER DEFAULT  0;
 DECLARE v_count4 INTEGER;
 DECLARE v_qualtype VARCHAR(20);
 DECLARE v_qualcode VARCHAR(20);
 DECLARE v_related_qualcode VARCHAR(20) DEFAULT '';
 DECLARE v_qualtype_code VARCHAR(20);
 DECLARE v_check_auth varchar(2);
 DECLARE v_message_no integer DEFAULT -20100;

  DECLARE v_message varchar(255) DEFAULT 'Miscellaneous error in auth_sp_delete_qual';

   DECLARE EXIT HANDLER FOR SQLEXCEPTION
   BEGIN





          rollback;
        if v_message_no = 0 then
          SET v_message = "Unknown SQL Exception error";
        end if;
   		CALL permit_signal(v_message,v_message_no);

    END;



   SET v_qualtype = upper(ai_qualtype);
   SET v_qualcode = upper(ai_qualcode);



  start transaction;


   select IFNULL(max(qualifier_id),-99) into v_qualid
     from qualifier where qualifier_type = v_qualtype
     and qualifier_code = v_qualcode;

   if v_qualid = -99 then
     SET v_message_no = -20105;
     SET v_message = CONCAT('Error: Qualifier code ''', v_qualcode , ''' type '''
                   , v_qualtype ,  ''' not found');
   else

     SET v_qualtype_code = CONCAT('QUAL_' , v_qualtype);
     SET v_check_auth = AUTH_SF_CHECK_AUTH2('MAINTAIN QUALIFIERS', v_qualtype_code,
                      ai_for_user, 'PROXY TO MAINTAIN QUAL', v_qualtype_code);
     if v_check_auth = 'N' then
       SET v_message_no = -20102;
       SET v_message = CONCAT('''' , IFNULL(ai_for_user, UC_USER_WITHOUT_HOST())
                    , ''' not authorized to maintain qualifiers of type '''
                    , v_qualtype_code , '''');
     elseif v_check_auth = 'X' then
       SET v_message_no = -20103;
       SET v_message = CONCAT('''' , UC_USER_WITHOUT_HOST()
                    , ''' not authorized to act as proxy for qualifier'
                    , ' maintenance for type '''
                    , v_qualtype_code , '''');
     else


       select count(*) into v_count
         from qualifier_child where parent_id = v_qualid;

       select count(*) into v_count2
         from authorization where qualifier_id = v_qualid;

        select count(*) into v_count4
         from external_auth where qualifier_id = v_qualid;

      if v_qualtype = 'FUND' and substr(v_qualcode, 1, 3) = 'FC_' then
         SET v_related_qualcode = CONCAT('SG' , substring(v_qualcode, 3));
         select count(*) into v_count3
           from authorization a, qualifier q
           where a.qualifier_id = q.qualifier_id
           and q.qualifier_type = 'SPGP'
           and q.qualifier_code = v_related_qualcode;
       end if;


       if v_count > 0 then
         SET v_message_no = -20106;
         SET  v_message = CONCAT('Qualifier ''' , v_qualcode , ''' type ''', v_qualtype , ''' has children and cannot be deleted.');
       elseif v_count2 > 0 then
         SET v_message_no = -20107;
         SET v_message = CONCAT('Qualifier ''' , v_qualcode , ''' type '''
            , v_qualtype , ''' has authorizations and cannot be deleted.');
       elseif v_count3 > 0 then
         SET v_message_no = -20116;
         SET v_message = CONCAT('Related qualifier ''' , v_related_qualcode
           , ''' has authorizations. ''' , v_qualcode
           , ''' cannot be deleted.');
       elseif v_count4 > 0 then
         SET v_message_no = -20117;
         SET v_message = CONCAT('Qualifier ''' , v_qualcode , ''' type '''
            , v_qualtype , ''' is referenced in the external_auth table and cannot be deleted. ');

      else

    update qualifier   inner join
      (   (select parent_id from qualifier_child qc1
      where child_id = v_qualid
      and not exists
      (select qc2.child_id from qualifier_child qc2
       where qc2.parent_id = qc1.parent_id
         and qc2.child_id <> qc1.child_id))) as t on qualifier_id= t.parent_id set has_child='N';



       delete from qualifier_child where child_id = v_qualid;
         delete from qualifier_descendent where child_id = v_qualid;

         delete from qualifier where qualifier_id = v_qualid;


         SET v_message_no = 0;
         SET ao_message = CONCAT('Qualifier ''' , v_qualcode , ''' type '''
           , v_qualtype , ''' has been deleted.');

       end if;
     end if;
   end if;


   SET ao_message = CONCAT('v_related_qualcode is ''' , v_related_qualcode
        , ''' v_message_no is ' , CAST(v_message_no AS CHAR));
   if substring(v_related_qualcode, 1, 2) = 'SG' and v_message_no = 0 then

     CALL auth_sp_delete_qual('SPGP', v_related_qualcode, ai_for_user, v_message);
   end if;


   if v_message_no != 0 then
    rollback;
   		CALL permit_signal(v_message,v_message_no);

   end if;
    commit;
 END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_delete_sql_lines`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_delete_sql_lines`()
begin
   
   
 end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_duplicate_sys_criteria`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_duplicate_sys_criteria`()
BEGIN
 
 DECLARE tmp_selection_id  INTEGER;
 DECLARE tmp_criteria_id INTEGER;
 DECLARE flag1 VARCHAR(5) DEFAULT 'START';

 DECLARE get_sys_criteria CURSOR  FOR
	SELECT selection_id, criteria_id FROM criteria_instance where username = 'root' and username != UC_USER_WITHOUT_HOST();
DECLARE CONTINUE HANDLER FOR NOT FOUND SET flag1 = 'END';

DECLARE EXIT HANDLER FOR SQLEXCEPTION
	CLOSE get_sys_criteria;
	
   OPEN get_sys_criteria;
   WHILE flag1 <> 'END' DO
     FETCH get_sys_criteria INTO tmp_selection_id, tmp_criteria_id;
      insert into criteria_instance
 	select selection_id, criteria_id,
 		UC_USER_WITHOUT_HOST(), apply, auth_sf_get_correct_value(value),
 		 next_scrn_selection_id,
 		no_change, sequence
 		 from criteria_instance
 		where selection_id = tmp_selection_id and
 		      criteria_id = tmp_criteria_id and
 		      username = 'root';
   END WHILE;
   CLOSE get_sys_criteria;
 end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_fix_qd_add`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_fix_qd_add`(IN a_qual_id VARCHAR(30))
begin
 DECLARE v_qc_list VARCHAR(1000);
 DECLARE v_qd_list VARCHAR(1000);
 DECLARE v_qual_id VARCHAR(10);
 DECLARE v_pos1 INTEGER;
 DECLARE v_pos2 INTEGER;
 DECLARE  temp_message VARCHAR(255);   

   select CONCAT('A1. ' , DATE_FORMAT(NOW(), '%H:%i:%s')) into temp_message from dual;
   
  CALL   auth_sf_ancestors_qc(a_qual_id, ' ', v_qc_list);
   select CONCAT('A2. ' , DATE_FORMAT(NOW(), '%H:%i:%s')) into temp_message from dual;
   
   CALL auth_sf_ancestors_qd(a_qual_id,v_qd_list );
   select CONCAT('A3. ' , DATE_FORMAT(NOW(), '%H:%i:%s')) into temp_message from dual;
   
   while length(v_qc_list) > 1 DO  
     SET v_qual_id = auth_sf_get_1st_token(v_qc_list);  
     SET v_pos1 = LOCATE(CONCAT(' ' , v_qual_id , ' '), v_qd_list); 
     if v_pos1 > 0 then
       SET v_qd_list = auth_sf_remove_token(v_qual_id,v_qd_list); 
     else
       insert into qualifier_descendent values (v_qual_id, a_qual_id);
       
       insert into qualifier_descendent
         select v_qual_id, qd.child_id from qualifier_descendent qd
         where qd.parent_id = a_qual_id
         and not exists
         (select child_id from qualifier_descendent
          where parent_id = v_qual_id and child_id = qd.child_id);
     end if;
     SET v_qc_list = auth_sf_remove_token(v_qual_id,v_qc_list); 
   end WHILE;
   
 end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_fix_qd_for_1_qual`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_fix_qd_for_1_qual`(IN a_qual_id VARCHAR(10))
BEGIN

 DECLARE v_qc_list VARCHAR(1000) DEFAULT ' ';
 DECLARE v_qd_list VARCHAR(1000) DEFAULT ' ';
 DECLARE v_qual_id VARCHAR(10);
 DECLARE v_pos1 INTEGER;
 DECLARE v_pos2 INTEGER;
 DECLARE v_msg VARCHAR(255);


 CALL auth_sp_ancestors_qc(a_qual_id, ' ',v_qc_list);
 

 CALL auth_sp_ancestors_qd(a_qual_id,v_qd_list);

 
 WHILE length(v_qc_list) > 1 DO  
     SET v_qual_id = auth_sf_get_1st_token(v_qc_list);  
     SET v_pos1 = LOCATE(CONCAT(' ' , v_qual_id , ' '), v_qd_list); 
     
     if v_pos1 > 0 then
       SET v_qd_list = auth_sf_remove_token(v_qual_id,v_qd_list); 
       
     else
       insert into qualifier_descendent values (v_qual_id, a_qual_id);
       
     end if;
     SET v_qc_list = auth_sf_remove_token(v_qual_id,v_qc_list); 
     
end WHILE;
   
  while length(v_qd_list) > 1 DO  
    SET v_qual_id = auth_sf_get_1st_token(v_qd_list);  
    
    delete from qualifier_descendent where parent_id = v_qual_id
      and child_id = a_qual_id;
     
     SET v_qd_list = auth_sf_remove_token(v_qual_id,v_qd_list); 
     
  end WHILE;
 end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_fix_qd_for_many_qual`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_fix_qd_for_many_qual`(IN a_qual_id  VARCHAR(20))
BEGIN
         
 DECLARE flag1 VARCHAR(5) DEFAULT 'START';        
        
 DECLARE v_qual_id VARCHAR(20);

 DECLARE get_descendents CURSOR  FOR
   SELECT child_id from qualifier_descendent
         where parent_id = a_qual_id;
         
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET flag1 = 'END';
        

   CALL auth_sp_fix_qd_for_1_qual (a_qual_id);  
   OPEN get_descendents;
   WHILE (flag1 != 'END') DO
     FETCH get_descendents INTO v_qual_id;
     IF (flag1 != 'END') THEN 
      	CALL auth_sp_fix_qd_for_1_qual (v_qual_id);  
     END IF; 	
   END WHILE;
   CLOSE get_descendents;
 end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_insert_qual`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_insert_qual`(IN  ai_qualtype     VARCHAR(30),
                  IN  ai_qualcode     VARCHAR(30),
                  IN  ai_parent_code  VARCHAR(30),
                  IN  ai_qualname     VARCHAR(50),
                  IN  ai_for_user     VARCHAR(30),
                  OUT ao_message      VARCHAR(255))
BEGIN

 DECLARE v_qualid BIGINT;
 DECLARE v_count INTEGER;
 DECLARE v_qualtype VARCHAR(30);
 DECLARE v_qual_level INTEGER;
 DECLARE v_qualcode VARCHAR(30);
 DECLARE v_parent_code VARCHAR(30);
 DECLARE v_parent_id BIGINT;
 DECLARE v_qualtype_code VARCHAR(30);
 DECLARE v_custom_hierarchy VARCHAR(1);
 DECLARE v_check_auth varchar(2);
 DECLARE v_message varchar(255) DEFAULT 'Miscellaneous error in auth_sp_insert_qual';
 DECLARE v_message_no integer DEFAULT -20100;
DECLARE v_temp_msg  VARCHAR(255)  DEFAULT '';




DECLARE exit handler for sqlexception
  BEGIN
    rollback;
   CALL permit_signal(v_message,v_message_no);
  END;

  DECLARE exit handler for not found
  BEGIN
  	rollback;
   	CALL permit_signal(v_message,v_message_no);
  END;



   
   start transaction;


   
   SET v_qualcode = upper(ai_qualcode);
   SET v_qualtype = upper(ai_qualtype);



   select IFNULL(max(qualifier_id)+1,-99) into v_qualid
     from qualifier where qualifier_type = v_qualtype;
   select count(*) into v_count from qualifier where qualifier_type = v_qualtype
     and qualifier_code = v_qualcode;



    if v_qualid = -99 then
     SET v_message = CONCAT('Error: Qualifier type ''' , v_qualtype , ''' not found');
     SET v_message_no = -20101;
 

   elseif v_count > 0 then
     SET v_message = CONCAT('Error: Qualifier code ''' , v_qualcode , ''', type, '''
                  , v_qualtype , ''' already exists');
 

     SET v_message_no = -20104;
   else
     
     SET v_qualtype_code = CONCAT('QUAL_' , v_qualtype); 
 
    SET v_check_auth =  AUTH_SF_CHECK_AUTH2('MAINTAIN QUALIFIERS', v_qualtype_code,
                      ai_for_user, 'PROXY TO MAINTAIN QUAL', v_qualtype_code)  ;
 

     if v_check_auth = 'N' then
       SET v_message_no = -20102;
       SET v_message = CONCAT('''' , IFNULL(ai_for_user, UC_USER_WITHOUT_HOST())
                    , ''' not authorized to maintain qualifiers of type '''
                    , v_qualtype_code , '     ''');


     elseif v_check_auth = 'X' then
       SET v_message_no = -20103;
       SET v_message = CONCAT('''' , UC_USER_WITHOUT_HOST()
                    , ''' not authorized to act as proxy for qualifier'
                    , ' maintenance for type '''
                    , v_qualtype_code , '''');

     else
       
       SET v_parent_code = upper(ai_parent_code);
       select IFNULL(max(qualifier_level+1), -99), max(qualifier_id)
         into v_qual_level, v_parent_id
         from qualifier where qualifier_type = v_qualtype
         and qualifier_code = v_parent_code;
       if v_qual_level = -99 then
         SET v_message_no = -20103;
         SET v_message = CONCAT('Error: Parent code ''' , v_parent_code ,
                       ''' type ''' , v_qualtype , ''' does not exist.');
       else
         
         if (v_qualtype = 'FUND'
             and substring(v_qualcode, 1, 3) = 'FC_') then
           SET v_custom_hierarchy = 'Y';
         else
           SET v_custom_hierarchy = NULL;
         end if;
         

         insert into qualifier (QUALIFIER_ID,  QUALIFIER_CODE,
           QUALIFIER_NAME, QUALIFIER_TYPE, HAS_CHILD,
           QUALIFIER_LEVEL, CUSTOM_HIERARCHY)
           values (v_qualid, v_qualcode, ai_qualname, v_qualtype, 'N',
                   	v_qual_level, v_custom_hierarchy);

         
         insert into qualifier_child (PARENT_ID, CHILD_ID)
           values (v_parent_id, v_qualid);
 
        
         update qualifier set has_child = 'Y'
           where qualifier_id = v_parent_id;
         
  
       CALL auth_sp_fix_qd_for_1_qual (v_qualid);  
         
         
         SET v_message_no = 0;  
         SET ao_message = CONCAT('Qualifier ''' , v_qualcode ,
           ''' successfully added to ''' , v_qualtype , ''' hierarchy');
       end if;
     end if;
   end if;


   

	    
	      
	      
	 if v_message_no != 0 then
	  rollback;

   	  CALL permit_signal(v_message,v_message_no);

        ELSE
 		commit;
 	END IF;

 END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_update_auth_dates`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_update_auth_dates`(IN ai_category  VARCHAR(14),
                  IN ai_kerberos_name VARCHAR(14),
  		 IN ai_action_type  VARCHAR(14),
           	 IN AI_EFFECTIVE_DATE  VARCHAR(14),
           	 IN AI_EXPIRATION_DATE  VARCHAR(14),
                  OUT ao_message VARCHAR(255))
BEGIN
  DECLARE v_count INTEGER;
  DECLARE v_count2 INTEGER;
  DECLARE v_user_count INTEGER;
  DECLARE a_kerberos_name VARCHAR(20);
  DECLARE a_category VARCHAR(20);
  DECLARE a_action_type varchar(2) DEFAULT ai_action_type;
  DECLARE A_EFFECTIVE_DATE varchar(20);
  DECLARE A_EXPIRATION_DATE varchar(20);
  DECLARE v_status integer;
  DECLARE a_date date;
 
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
 
        if v_status = 1 then
  	        SET ao_message = CONCAT('Bad format in effective date: ''' , a_effective_date, '''');
        elseif v_status = 2 then
  	        SET ao_message = CONCAT('Bad format in expiration date: ''' , a_expiration_date, '''');
        else
  	        SET ao_message = CONCAT('System error in auth_sp_update_auth_dates');
        end if;
    END;
    
    SET a_kerberos_name = upper(ai_kerberos_name);
    SET a_category = upper(ai_category);
    SET a_effective_date = ai_effective_date;
    SET a_expiration_date = ai_expiration_date;
    SET v_status = 0;  
    
    select count(*) into v_user_count from person
      where kerberos_name = a_kerberos_name;
    
    select count(*) into v_count from AUTHORIZATION A1
  	where A1.kerberos_name = a_kerberos_name
          and A1.function_category = a_category
          and auth_sf_can_create_auth(UC_USER_WITHOUT_HOST(), A1.function_name, A1.qualifier_code,
          A1.do_function, A1.grant_and_view) = 'Y';
    
    select count(*) into v_count2 from AUTHORIZATION A1
  	where A1.kerberos_name = a_kerberos_name
          and A1.function_category = a_category;
    
    if v_count2 > v_count then
      SET ao_message = 'You are not authorized to update all these authorizations';
    elseif v_user_count = 0 then
      SET ao_message = CONCAT('Kerberos_name ''' ,
        a_kerberos_name , ''' does not exist.');
    elseif v_count = 0 then
      SET ao_message = CONCAT('No authorizations to be updated for ''' ,
        a_kerberos_name , ''' in category ''' , a_category , '''');
    else
      if a_action_type = '1' then 
        SET v_status = 1;  
        SET a_date = auth_sf_convert_str_to_date(a_effective_date);
        SET v_status = 0;  
        UPDATE AUTHORIZATION SET EFFECTIVE_DATE = a_date
          WHERE KERBEROS_NAME = a_kerberos_name
          AND FUNCTION_CATEGORY = a_category;
        SET ao_message = CONCAT('Effective date modified in ' ,
                      CAST(v_count AS CHAR) , ' authorizations.');
      elseif a_action_type = '2' then 
        SET v_status = 2;  
        SET a_date = auth_sf_convert_str_to_date(a_expiration_date);
        SET v_status = 0;  
        UPDATE AUTHORIZATION SET EXPIRATION_DATE = a_date
          WHERE KERBEROS_NAME = a_kerberos_name
          AND FUNCTION_CATEGORY = a_category;
        SET ao_message = CONCAT('Expiration date modified in ' , CAST(v_count AS CHAR) , ' authorizations.');
      elseif a_action_type = '3' then 
        UPDATE AUTHORIZATION SET EXPIRATION_DATE = NULL
          WHERE KERBEROS_NAME = a_kerberos_name
          AND FUNCTION_CATEGORY = a_category;
        SET ao_message = CONCAT('Expiration date turned off in ' ,
                      CAST(v_count AS CHAR) , ' authorizations.');
      else
        SET ao_message = CONCAT('Application error. Bad action_type: ' , a_action_type);
      end if;
    end if;
  end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_update_authorizations`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_update_authorizations`(IN AI_AUTHORIZATION_ID INTEGER,
 	 IN AI_FUNCTION_NAME  VARCHAR(30),
 	 IN AI_QUALIFIER_CODE  VARCHAR(20),
 	 IN AI_KERBEROS_NAME  VARCHAR(20),
 	 IN AI_DO_FUNCTION  VARCHAR(1),
 	 IN AI_GRANT_AND_VIEW  VARCHAR(2),
 	 IN AI_DESCEND  VARCHAR(1),
 	 IN AI_EFFECTIVE_DATE  VARCHAR(10),
 	 IN AI_EXPIRATION_DATE  VARCHAR(10),
 	 OUT a_modified_by  VARCHAR(20),
 	 OUT a_modified_date  VARCHAR(20)
 	)
BEGIN
 DECLARE V_FUNCTION_ID INTEGER;
 DECLARE V_QUALIFIER_ID INTEGER;
 DECLARE V_KERBEROS_NAME VARCHAR(20);
 DECLARE V_QUALIFIER_CODE VARCHAR(20);
 DECLARE V_FUNCTION_NAME VARCHAR(30);
 DECLARE V_FUNCTION_CATEGORY VARCHAR(4);
 DECLARE V_QUALIFIER_NAME VARCHAR(50);
 DECLARE V_QUALIFIER_TYPE VARCHAR(4);
 DECLARE V_MODIFIED_BY VARCHAR(20);
 DECLARE V_DO_FUNCTION VARCHAR(1);
 DECLARE V_GRANT_AND_VIEW VARCHAR(2);
 DECLARE V_DESCEND VARCHAR(1);
 DECLARE V_EFFECTIVE_DATE DATETIME;
 DECLARE V_EXPIRATION_DATE DATETIME;
 DECLARE v_status integer;
 DECLARE v_msg_no INTEGER;
 DECLARE v_msg VARCHAR(255);
 DECLARE a_function_id INTEGER;
 DECLARE a_function_name VARCHAR(50);
 DECLARE a_qualifier_id INTEGER;
 DECLARE a_qualifier_code VARCHAR(20);
 DECLARE a_kerberos_name VARCHAR(20);
 DECLARE a_do_function VARCHAR(1);
 DECLARE a_grant_and_view VARCHAR(2);
 DECLARE a_descend VARCHAR(1);
 DECLARE a_effective_date DATETIME;
 DECLARE a_expiration_date varchar(255);
 DECLARE old_qualifier_code VARCHAR(20);
 DECLARE old_kerberos_name VARCHAR(20);


  DECLARE exit handler for 1022 

  BEGIN
 	SET v_msg_no = -20007;
 	SET v_msg = roles_msg(-20007);
   	CALL permit_signal(v_msg,v_msg_no);
  END;


DECLARE exit handler for sqlexception

  BEGIN
	  SET v_msg_no = -20007;
 	  SET v_msg = roles_msg(-20007);
   	  CALL permit_signal(v_msg,v_msg_no);
 END;

 DECLARE exit handler for not found
  BEGIN
	  if v_status = 0 then
 	     SET v_msg_no = -20010;
 	     SET v_msg = roles_msg(-20010);
 	  elseif v_status = 1 then
 	     SET v_msg_no = -20001;
 	     SET v_msg = roles_msg(-20001);
 	  elseif v_status = 2 then
  	     SET v_msg_no = -20017;
 	     SET v_msg = roles_msg(-20017);
 	  else
 	     SET v_msg_no = -20003;
 	     SET v_msg = roles_msg(-20003);
           end if;
   		CALL permit_signal(v_msg,v_msg_no);
    END;
  
   SET a_kerberos_name = upper(ai_kerberos_name);
   SET a_function_name = upper(ai_function_name);
   SET a_qualifier_code = upper(ai_qualifier_code);
   SET a_do_function = upper(ai_do_function);
   SET a_grant_and_view = upper(ai_grant_and_view);
   SET a_descend = upper(ai_descend);
   SET a_effective_date = auth_sf_convert_str_to_date(ai_effective_date);
   SET a_expiration_date = upper(ai_expiration_date);
 
 
 
   
   if (a_grant_and_view = 'Y ' or a_grant_and_view = 'GD') then
     SET a_grant_and_view = 'GD';
   else
     SET a_grant_and_view = 'N ';
   end if;
 
   
   SET v_status = 0;
   select function_id, function_name, qualifier_id, qualifier_code,
         kerberos_name, modified_by, do_function, grant_and_view, descend,
         effective_date, expiration_date
         into
         V_FUNCTION_ID, V_FUNCTION_NAME, V_QUALIFIER_ID, OLD_QUALIFIER_CODE,
         OLD_KERBEROS_NAME, V_MODIFIED_BY,
         V_DO_FUNCTION, V_GRANT_AND_VIEW, V_DESCEND,
         V_EFFECTIVE_DATE, V_EXPIRATION_DATE
         from authorization
         where authorization_id = ai_authorization_id;
 
   
   SET v_status = 1;
   select function_id, function_category, qualifier_type
         into V_FUNCTION_ID, V_FUNCTION_CATEGORY, V_QUALIFIER_TYPE
         from function
  	where function_name = a_function_name;
 
   
   SET v_status = 2;
   select qualifier_code, qualifier_name, qualifier_id
         into V_QUALIFIER_CODE, V_QUALIFIER_NAME, V_QUALIFIER_ID
         from qualifier
 	where qualifier_code = a_qualifier_code
         and qualifier_type = v_qualifier_type;
 
   
   SET v_status = 3;
   select kerberos_name into V_KERBEROS_NAME from person
 	where kerberos_name = a_kerberos_name;
 
  
  
  
  
  
  
  
  
  
   if (v_qualifier_type = 'DEPT'
       and substr(v_qualifier_code, 1, 2) <> 'D_') then
 		CALL permit_signal(roles_msg(-20015),-20015);
   end if;
 
 
   
   
     if auth_sf_can_create_auth(uc_user_without_host(), A_FUNCTION_NAME, A_QUALIFIER_CODE,
 	  AI_DO_FUNCTION, A_GRANT_AND_VIEW) = 'N' then
 		CALL permit_signal(roles_msg(-20014),-20014);
     end if;
 
   
     if ((a_kerberos_name <> old_kerberos_name
          or a_function_name <> v_function_name
          or a_qualifier_code <> old_qualifier_code)
         and v_effective_date = a_effective_date
         and NOW() > a_effective_date) then
        SET a_effective_date = NOW();
     end if;
 
   update authorization
     set FUNCTION_ID = v_function_id, QUALIFIER_ID = v_qualifier_id,
       KERBEROS_NAME = a_kerberos_name, QUALIFIER_CODE = v_qualifier_code,
       FUNCTION_NAME = a_function_name, FUNCTION_CATEGORY = v_function_category,
       QUALIFIER_NAME = v_qualifier_name, MODIFIED_BY = uc_user_without_host(),
       MODIFIED_DATE = NOW(), DO_FUNCTION = a_do_function,
       GRANT_AND_VIEW = a_grant_and_view, DESCEND = a_descend,
       EFFECTIVE_DATE = A_EFFECTIVE_DATE,
       EXPIRATION_DATE = auth_sf_convert_str_to_date(A_EXPIRATION_DATE)
     where AUTHORIZATION_ID = ai_authorization_id;
   SET a_modified_by = uc_user_without_host();
   SET a_modified_date = auth_sf_convert_date_to_str(NOW());
 
 end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_update_criteria`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_update_criteria`(IN a_selection_id INTEGER,
 				IN a_criteria_id  INTEGER,
 				IN a_username  VARCHAR(50),
 				IN a_apply VARCHAR(10),
 				IN a_value VARCHAR(50),
 				IN a_next_scrn_selection_id INTEGER)
begin
   update criteria_instance
 		set apply = a_apply,
 		    value = a_value,
 		    next_scrn_selection_id = a_next_scrn_selection_id
 	where 	selection_id = a_selection_id and
 		criteria_id = a_criteria_id and
 		username = a_username;
 end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_update_def_sel_id`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_update_def_sel_id`(IN a_cur_selection_id  INTEGER,
 			 IN a_new_selection_id INTEGER)
BEGIN
 DECLARE v_num integer DEFAULT 0;

    if a_new_selection_id != a_cur_selection_id then

     select count(*) into v_num from hide_default
 			     where selection_id = a_cur_selection_id and
 				   apply_username = UC_USER_WITHOUT_HOST();
     if v_num = 0 then
 	    select count(*) into v_num from hide_default
 			     where selection_id = a_cur_selection_id and
 				   apply_username = 'SYSTEM';
 	    if v_num <> 0 then
 	       insert into hide_default
 		     select a_new_selection_id, UC_USER_WITHOUT_HOST(), default_flag, hide_flag
 			    from hide_default
 			  where selection_id = a_cur_selection_id and apply_username = 'SYSTEM';
 	    else
 	     insert into hide_default values (a_new_selection_id, UC_USER_WITHOUT_HOST(), 'Y', 'N');
 	    end if;
     else
 	    insert into hide_default
 		    select a_new_selection_id, UC_USER_WITHOUT_HOST(), default_flag, hide_flag
 			  from hide_default
 			  where selection_id = a_cur_selection_id and
 			      apply_username = UC_USER_WITHOUT_HOST();
 	      delete from hide_default where selection_id = a_cur_selection_id and
 				  apply_username = UC_USER_WITHOUT_HOST();
     end if;

  end if;
 end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_update_function`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_update_function`(IN ai_orig_function_name VARCHAR(50),
 	 IN ai_orig_function_category VARCHAR(10),
 	 IN ai_function_name  VARCHAR(50),
 	 IN ai_function_description  VARCHAR(50),
 	 IN ai_function_category  VARCHAR(10),
 	 IN ai_qualifier_type  VARCHAR(10),
 	 OUT a_modified_by  VARCHAR(20),
 	 OUT a_modified_date VARCHAR(20)
 	)
begin
 DECLARE v_function_id INTEGER	;
 DECLARE v_qualifier_type VARCHAR(10);
 DECLARE v_orig_qualifier_type VARCHAR(10);
 DECLARE v_function_category VARCHAR(10);
 DECLARE v_status integer;
 DECLARE v_msg_no INTEGER;
 DECLARE v_msg VARCHAR(255);
 DECLARE v_count INTEGER;
 DECLARE a_orig_function_name VARCHAR(50);
 DECLARE a_orig_function_category VARCHAR(20);
 DECLARE a_function_name VARCHAR(50);
 DECLARE a_function_description VARCHAR(50);
 DECLARE a_function_category VARCHAR(10);
 DECLARE a_qualifier_type VARCHAR(10);
 
 
  	DECLARE EXIT HANDLER FOR NOT FOUND
  	BEGIN
         if v_status = 1 then
  		           SET v_msg_no = -20008;
  		           SET v_msg = roles_msg(-20008);
         elseif v_status = 2 then
                 SET v_msg_no = -20016;
                 SET v_msg = roles_msg(-20016);
         else 
                 SET v_msg_no = -20012;
                 SET v_msg = roles_msg(-20012);
         end if;
   		CALL permit_signal(v_msg,v_msg_no);
 	END;
 	
   SET a_orig_function_name = upper(ai_orig_function_name);
   SET a_orig_function_category = upper(ai_orig_function_category);
   SET a_function_name = upper(ai_function_name);
   SET a_function_description = ai_function_description; 
   SET a_function_category = upper(ai_function_category);
   SET a_qualifier_type = upper(ai_qualifier_type);
   SET v_status = 3;
   select function_id,qualifier_type into v_function_id,v_qualifier_type
         from function
 	where function_name = a_orig_function_name
         and function_category = a_orig_function_category;
   SET v_orig_qualifier_type = v_qualifier_type;
   SET v_status = 1;
   if a_qualifier_type != v_qualifier_type then
     select qualifier_type into v_qualifier_type from qualifier_type
           where qualifier_type = a_qualifier_type;
   end if;
   SET v_status = 2;
   
   if a_function_category != a_orig_function_category then
     select function_category into v_function_category from category
           where function_category = a_function_category;
     
     if auth_sf_can_create_function(UC_USER_WITHOUT_HOST(), v_function_category) = 'N' then
        SET v_msg =  CONCAT('Not authorized to update functions in category '''
        , v_function_category , '''');
   		CALL permit_signal(v_msg,-20014);
     end if;
   end if;
   
   if auth_sf_can_create_function(UC_USER_WITHOUT_HOST(), a_orig_function_category) = 'N' then
        SET v_msg =  CONCAT('Not authorized to update functions in category ''', a_orig_function_category , '''');
   		CALL permit_signal(v_msg,-20014);
   end if;
   
   select count(*) into v_count from authorization a, function f
      where a.function_id = f.function_id and a.function_id = v_function_id;
   if (v_count > 0) and (a_qualifier_type <> v_orig_qualifier_type) then
   	SET v_msg_no = -20011;
        SET v_msg =  roles_msg(-20011);
   		CALL permit_signal(v_msg,v_msg_no);
   end if;
   
   update function set function_name = a_function_name,
 				FUNCTION_DESCRIPTION = a_function_description,
 				FUNCTION_CATEGORY = a_function_category,
 				modified_by = UC_USER_WITHOUT_HOST(),
 				modified_date = NOW(),
 				qualifier_type = v_qualifier_type
 	where FUNCTION_ID = v_function_id;

  
  


   
   if ((a_orig_function_name <> a_function_name)
       or (a_orig_function_category <> a_function_category)) then
     update authorization set FUNCTION_NAME = a_function_name,
       FUNCTION_CATEGORY = a_function_category
       where function_id = v_function_id;
   end if;
   SET a_modified_by = UC_USER_WITHOUT_HOST();
   SET a_modified_date = auth_sf_convert_date_to_str(NOW());

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_update_qualcode`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_update_qualcode`(IN ai_qualtype     VARCHAR(30),
                  IN ai_qualcode     VARCHAR(30),
                  IN ai_newqualcode  VARCHAR(30),
                  IN ai_for_user     VARCHAR(30),
                  IN ao_message      VARCHAR(255))
BEGIN
 
 DECLARE v_qualid INTEGER;
 DECLARE v_qualid2 INTEGER;
 DECLARE v_qualtype VARCHAR(30);
 DECLARE v_qualcode VARCHAR(30);
 DECLARE v_qualtype_code VARCHAR(30);
 DECLARE v_newqualcode VARCHAR(30);
 DECLARE v_check_auth varchar(2);
 DECLARE v_message varchar(255) DEFAULT 'Miscellaneous error in auth_sp_update_qualcode';
 DECLARE v_message_no integer DEFAULT -20100;

   DECLARE EXIT HANDLER FOR SQLEXCEPTION
   BEGIN
       rollback;
   	CALL permit_signal(v_message,v_message_no);
    END;
 
 
 
 
 
 START transaction;
 
   SET v_qualtype = upper(ai_qualtype);
   SET v_qualcode = upper(ai_qualcode);
   SET v_newqualcode = upper(ai_newqualcode);
   
   select IFNULL(max(qualifier_id),-99) into v_qualid
     from qualifier where qualifier_type = v_qualtype
     and qualifier_code = v_qualcode;
   select IFNULL(max(qualifier_id),-99) into v_qualid2
     from qualifier where qualifier_type = v_qualtype
     and qualifier_code = v_newqualcode;
   if v_qualid = -99 then
     SET v_message_no = -20105;
     SET v_message = CONCAT('Error: Old qualifier code ''' , v_qualcode , ''' type '''
                   , v_qualtype ,  ''' not found');
   elseif v_qualid2 != -99 then
     SET v_message_no = -20106;
     SET v_message = CONCAT('Error: New qualifier code ''' , v_newqualcode
                   , ''' type ''' , v_qualtype ,  ''' already exists');
   else
     
     SET v_qualtype_code = CONCAT('QUAL_' , v_qualtype); 
     SET v_check_auth = AUTH_SF_CHECK_AUTH2('MAINTAIN QUALIFIERS', v_qualtype_code,
                      ai_for_user, 'PROXY TO MAINTAIN QUAL', v_qualtype_code);
     if v_check_auth = 'N' then
       SET v_message_no = -20102;
       SET v_message = CONCAT('''' , IFNULL(ai_for_user, UC_USER_WITHOUT_HOST())
                    , ''' not authorized to maintain qualifiers of type '''
                    , v_qualtype_code , '''');
     elseif v_check_auth = 'X' then
       SET v_message_no = -20103;
       SET v_message = CONCAT('''' , UC_USER_WITHOUT_HOST()
                    , ''' not authorized to act as proxy for qualifier'
                    , ' maintenance for type '''
                    , v_qualtype_code , '''');
     elseif length(ai_newqualcode) > 15 then
       SET v_message_no = -20116;
       SET v_message = 'Error: New qualifier code is longer than 15 characters.';
     else
       update qualifier set qualifier_code = v_newqualcode
        where qualifier_id = v_qualid;
       update authorization set qualifier_code = v_newqualcode
        where qualifier_id = v_qualid;
       SET v_message_no := 0;
       SET ao_message = CONCAT('Qualifier code ''' , v_qualcode ,
         ''' type ''' , v_qualtype , ''' sucessfully changed to '''
         , v_newqualcode , '''');
     end if;
   end if;
   
   if v_message_no != 0 then
       rollback;
   	CALL permit_signal(v_message,v_message_no);
   end if;
   
   COMMIT;
 END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_update_qualname`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_update_qualname`(IN ai_qualtype     VARCHAR(30),
                  IN ai_qualcode     VARCHAR(30),
                  IN ai_qualname     VARCHAR(50),
                  IN ai_for_user     VARCHAR(30),
                  IN ao_message      VARCHAR(30))
BEGIN
 
 DECLARE v_qualid INTEGER;
 DECLARE v_qualtype VARCHAR(30);
 DECLARE v_qualcode VARCHAR(30);
 DECLARE v_qualtype_code VARCHAR(30);
 DECLARE v_qualname VARCHAR(50);
 DECLARE v_check_auth varchar(2);
 DECLARE v_message varchar(255) DEFAULT 'Miscellaneous error in auth_sp_update_qualname';
 DECLARE v_message_no integer DEFAULT -20100;
DECLARE v_temp_msg varchar(255);

   
   
	 DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
	 rollback;
   	 CALL permit_signal(v_message,v_message_no);
    END;
  
  


 



   SET v_qualtype = upper(ai_qualtype);
   SET v_qualcode = upper(ai_qualcode);

 

    start transaction;

   
   select IFNULL(max(qualifier_id),-99) into v_qualid
     from qualifier where qualifier_type = v_qualtype
     and qualifier_code = v_qualcode;

    if v_qualid = -99 then
     SET v_message_no = -20105;
     SET v_message = CONCAT('Error: Qualifier code ''' , v_qualcode , ''' type '''
                   , v_qualtype ,  ''' not found');
   else
     
     SET v_qualtype_code = CONCAT('QUAL_' , v_qualtype); 
     SET v_check_auth = AUTH_SF_CHECK_AUTH2('MAINTAIN QUALIFIERS', v_qualtype_code,
                      ai_for_user, 'PROXY TO MAINTAIN QUAL', v_qualtype_code);
     if v_check_auth = 'N' then
       SET v_message_no = -20102;
       SET v_message = CONCAT('''' , IFNULL(ai_for_user, UC_USER_WITHOUT_HOST())
                    , ''' not authorized to maintain qualifiers of type '''
                    , v_qualtype_code , '''');
     elseif v_check_auth = 'X' then
       SET v_message_no = -20103;
       SET v_message = CONCAT('''' , UC_USER_WITHOUT_HOST()
                    , ''' not authorized to act as proxy for qualifier'
                    , ' maintenance for type '''
                    , v_qualtype_code , '''');
     elseif length(ai_qualname) > 50 then
       SET v_message_no = -20115;
       SET v_message = 'Error: New qualifier name is longer than 50 characters.';

     else

       SET v_qualname = ai_qualname;
       update qualifier set qualifier_name = v_qualname
        where qualifier_id = v_qualid;
  
       update authorization set qualifier_name = v_qualname
        where qualifier_id = v_qualid;
  
      SET v_message_no = 0;
       SET ao_message = CONCAT('Qualifier name for ''' , v_qualcode ,
         ''' type ''' , v_qualtype , ''' sucessfully updated.');
     end if;
   end if;
   
   if v_message_no != 0 then
    	rollback;
   	CALL permit_signal(v_message,v_message_no);
   end if;
  commit;
 
 END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_update_qualpar`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_update_qualpar`(IN ai_qualtype     VARCHAR(30),
                  IN ai_childcode    VARCHAR(30),
                  IN ai_old_parcode  VARCHAR(30),
                  IN ai_new_parcode  VARCHAR(30),
                  IN ai_for_user     VARCHAR(30),
                  OUT ao_message     VARCHAR(255))
BEGIN
 
 DECLARE v_count INTEGER;
 DECLARE v_qualtype VARCHAR(30);
 DECLARE v_qual_level INTEGER;
 DECLARE v_childcode VARCHAR(30);
 DECLARE v_childid INTEGER;
 DECLARE v_old_parcode VARCHAR(30);
 DECLARE v_old_parid INTEGER;
 DECLARE v_new_parcode VARCHAR(30);
 DECLARE v_new_parid INTEGER;
 DECLARE v_qualtype_code VARCHAR(30);
 DECLARE v_check_auth varchar(2);
 DECLARE v_message varchar(255) DEFAULT 'Miscellaneous error in auth_sp_update_qualpar';
 DECLARE v_message_no integer DEFAULT -20100;
    
   

   	DECLARE EXIT HANDLER FOR SQLEXCEPTION
      	BEGIN
   		rollback;
   		CALL permit_signal(v_message,v_message_no);
   	END;

      start transaction;

   
   SET v_childcode = upper(ai_childcode);
   SET v_qualtype = upper(ai_qualtype);
   select IFNULL(max(qualifier_id),-99) into v_childid
     from qualifier where qualifier_type = v_qualtype
     and qualifier_code = v_childcode;
   if v_childid = -99 then
     SET v_message = CONCAT('Error: Qualifier ''' , v_childcode , ''' type '''
       , v_qualtype , ''' not found');
     SET v_message_no = -20101;
     CALL permit_signal(v_message,v_message_no) ;
   end if;
   
    SET v_qualtype_code = CONCAT('QUAL_' , v_qualtype); 
    SET v_check_auth = AUTH_SF_CHECK_AUTH2('MAINTAIN QUALIFIERS', v_qualtype_code,
                    ai_for_user, 'PROXY TO MAINTAIN QUAL', v_qualtype_code);
   if v_check_auth = 'N' then
     SET v_message_no = -20102;
     SET v_message = CONCAT('''' , IFNULL(ai_for_user, UC_USER_WITHOUT_HOST())
                  , ''' not authorized to maintain qualifiers of type '''
                  , v_qualtype_code , '''');
       CALL permit_signal(v_message,v_message_no);
   elseif v_check_auth = 'X' then
     SET v_message_no = -20103;
     SET v_message = CONCAT('''' , UC_USER_WITHOUT_HOST()
                  , ''' not authorized to act as proxy for qualifier'
                  , ' maintenance for type '''
                  , v_qualtype_code , '''');
     CALL permit_signal(v_message,v_message_no);
 end if;
   SET v_old_parcode = upper(ai_old_parcode);
   if (v_old_parcode is not NULL && TRIM(v_old_parcode) != '') then 
     
     select IFNULL(max(qualifier_level+1), -99), max(qualifier_id)
       into v_qual_level, v_old_parid
       from qualifier where qualifier_type = v_qualtype
       and qualifier_code = v_old_parcode;
     if (v_qual_level = -99) then
       SET v_message_no = -20103;
       SET v_message = CONCAT('Error: Old parent code ''' , v_old_parcode ,
                   ''' type ''' , v_qualtype , ''' does not exist.');
       	CALL permit_signal(v_message,v_message_no);
     end if;
     
     select count(*) into v_count
       from qualifier_child where parent_id = v_old_parid
       and child_id = v_childid;
     if v_count < 1 then
       SET v_message_no = -20108;
       SET v_message = CONCAT('Error: Qualifier ''' , v_old_parcode , ''' type '''
          , v_qualtype , ''' is not a parent of ''' , v_childcode
          , '''.');
      
       		CALL permit_signal(v_message,v_message_no);
     end if;
     
     select count(*) into v_count
       from qualifier_child where child_id = v_childid;
     if (v_count < 2) and (ai_new_parcode is NULL || trim(ai_new_parcode) = '') then
       SET v_message_no = -20109;
       SET v_message = CONCAT('Error. Dropping parent ''' , v_old_parcode
         , ''' would make ''' , v_childcode , ''' an orphan.');
       	CALL permit_signal(v_message,v_message_no);
     end if;
   end if;
   SET v_new_parcode = upper(ai_new_parcode);
   if (v_new_parcode is not NULL && TRIM(v_new_parcode) != '') then 
     
     select IFNULL(max(qualifier_id), -99)
       into v_new_parid
       from qualifier where qualifier_type = v_qualtype
       and qualifier_code = v_new_parcode;
     if (v_new_parid = -99) then
       SET v_message_no = -20110;
       SET v_message = CONCAT('Error: New parent code ''' , v_new_parcode ,
                   ''' type ''' , v_qualtype , ''' does not exist.');
        CALL permit_signal(v_message,v_message_no);
     end if;
     
     select count(*) into v_count
       from qualifier_child where parent_id = v_new_parid
       and child_id = v_childid;
     if (v_count > 0) then
       SET v_message = CONCAT('Error: Parent-child relationship already exists for ('''
                  , v_new_parcode , ''','''
                  , v_childcode , ''')');
       SET v_message_no = -20111;
       CALL permit_signal(v_message,v_message_no);
     end if;
     
     if (v_childid = v_new_parid) then
       SET v_message = 'Error: Parent qualifier cannot equal child qualifier';
       SET v_message_no = -20112;
        		CALL permit_signal(v_message,v_message_no);
    end if;
     
     select count(*) into v_count
       from qualifier_descendent where parent_id = v_childid
       and child_id = v_new_parid;
     if v_count > 0 then
       SET v_message_no = -20113;
       SET v_message = CONCAT('Error: Parent-child relation would create a loop. '
         , v_childcode , ' is an ancestor of ' , v_new_parcode , '.');
      	CALL permit_signal(v_message,v_message_no);
   end if;
   end if;
   
   if (v_old_parcode is NULL || trim(v_old_parcode) = '') and (v_new_parcode is NULL || trim(v_new_parcode) = '') then
     SET v_message_no = -20114;
     SET v_message = 'Error: Both old and new parent codes are null.';
     CALL permit_signal(v_message,v_message_no);
  end if;

   
   
   
   if (v_old_parcode is not NULL && TRIM(v_old_parcode) != '') then
     delete from qualifier_child where parent_id = v_old_parid
       and child_id = v_childid;
     
     update qualifier set has_child = 'N'
       where qualifier_id = v_old_parid
       and not exists
       (select parent_id from qualifier_child where parent_id
       = qualifier_id);
   end if;
   
   if (v_new_parcode is not NULL && TRIM(v_new_parcode) != '') then
     insert into qualifier_child (PARENT_ID, CHILD_ID)
       values (v_new_parid, v_childid);
     
     update qualifier set has_child = 'Y'
       where qualifier_id = v_new_parid;
   end if;
   
   if (v_old_parcode is NULL) then
     CALL auth_sp_fix_qd_add (v_childid);            
   else
     CALL auth_sp_fix_qd_for_many_qual (v_childid);  
   end if;
   
   
   SET v_message_no = 0;  
   if (v_old_parcode is NULL || trim(v_old_parcode) = '' ) then
     SET ao_message = CONCAT('New parent-child relationship successfully added for ('''
           , v_new_parcode , ''','''
           , v_childcode , ''')');
   elseif (v_new_parcode is NULL || trim(v_new_parcode) = '') then
     SET ao_message = CONCAT('Old parent-child relationship successfully deleted for ('''
           , v_old_parcode , ''','''
           , v_childcode , ''')');
   else
     SET ao_message = CONCAT('Parent of ''' , v_childcode
           , ''' successfully changed from ''' , v_old_parcode , ''' to '''
           , v_new_parcode);
   end if;
  commit;
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`auth_sp_update_test`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`auth_sp_update_test`(IN AI_AUTHORIZATION_ID VARCHAR(20),
 	 IN AI_FUNCTION_NAME  VARCHAR(100),
 	 IN AI_QUALIFIER_CODE  VARCHAR(20),
 	 IN AI_KERBEROS_NAME  VARCHAR(20),
 	 IN AI_DO_FUNCTION  VARCHAR(1),
 	 IN AI_GRANT_AND_VIEW  VARCHAR(2),
 	 IN AI_DESCEND  VARCHAR(1),
 	 IN AI_EFFECTIVE_DATE  VARCHAR(20),
 	 IN AI_EXPIRATION_DATE  VARCHAR(20),
 	 OUT a_modified_by  VARCHAR(20),
 	 OUT a_modified_date VARCHAR(20)
 	)
BEGIN

 DECLARE V_AUTHORIZATION_ID BIGINT;
 DECLARE V_FUNCTION_ID INTEGER;
 DECLARE V_QUALIFIER_ID BIGINT;
 DECLARE V_KERBEROS_NAME VARCHAR(20);
 DECLARE V_QUALIFIER_CODE VARCHAR(20);
 DECLARE V_FUNCTION_NAME VARCHAR(30);
 DECLARE V_FUNCTION_CATEGORY VARCHAR(10);
 DECLARE V_QUALIFIER_NAME VARCHAR(50);
 DECLARE V_QUALIFIER_TYPE VARCHAR(50);
 DECLARE V_MODIFIED_BY VARCHAR(20);
 DECLARE V_DO_FUNCTION VARCHAR(1);
 DECLARE V_GRANT_AND_VIEW VARCHAR(2);
 DECLARE V_DESCEND VARCHAR(1);
 DECLARE V_EFFECTIVE_DATE DATETIME;
 DECLARE V_EXPIRATION_DATE DATETIME;
 DECLARE v_status integer;
 DECLARE v_msg_no INTEGER;
 DECLARE v_msg VARCHAR(100);
 DECLARE a_function_id INTEGER;
 DECLARE a_function_name VARCHAR(100);
 DECLARE a_qualifier_id BIGINT;
 DECLARE a_qualifier_code VARCHAR(20);
 DECLARE a_kerberos_name VARCHAR(20);
 DECLARE a_do_function VARCHAR(1);
 DECLARE a_grant_and_view VARCHAR(2);
 DECLARE a_descend VARCHAR(1);
 DECLARE a_effective_date varchar(255);
 DECLARE a_expiration_date varchar(255);

 	DECLARE EXIT HANDLER FOR 1022
  	BEGIN
  		SET v_msg_no = -20007;
 	 	SET v_msg = roles_msg(-20007);
 
   		CALL permit_signal(v_msg,v_msg_no);
 	END;

  	DECLARE EXIT HANDLER FOR NOT FOUND
  	BEGIN
	 if v_status = 0 then
 	     	 SET v_msg_no = -20010;
  		 SET v_msg = roles_msg(-20010);
         elseif v_status = 1 then
  		           SET v_msg_no = -20001;
  		           SET v_msg = roles_msg(-20001);
         elseif v_status = 2 then
                 SET v_msg_no = -20017;
                 SET v_msg = roles_msg(-20017);
         else 
                 SET v_msg_no = -20003;
                 SET v_msg = roles_msg(-20003);
         end if;
   		CALL permit_signal(v_msg,v_msg_no);
 	END;
  		
  	DECLARE EXIT HANDLER FOR SQLEXCEPTION
  	BEGIN
  		SET v_msg_no = -20018;
 	 	SET v_msg = roles_msg(-20018);
 
   		CALL permit_signal(v_msg,v_msg_no);
 	END;


  SET  v_authorization_id = to_number(ai_authorization_id);
  SET  a_kerberos_name = upper(ai_kerberos_name);
  SET  a_function_name = upper(ai_function_name);
  SET  a_qualifier_code = upper(ai_qualifier_code);
  SET  a_do_function = upper(ai_do_function);
  SET  a_grant_and_view = upper(ai_grant_and_view);
  SET  a_descend = upper(ai_descend);
  SET  a_effective_date = upper(ai_effective_date);
  SET  a_expiration_date = upper(ai_expiration_date);
   
  SET  v_status = 0;
   select function_id, qualifier_id, kerberos_name, modified_by,
         do_function, grant_and_view, descend,
         effective_date, expiration_date
         into V_FUNCTION_ID, V_QUALIFIER_ID, V_KERBEROS_NAME, V_MODIFIED_BY,
         V_DO_FUNCTION, V_GRANT_AND_VIEW, V_DESCEND,
         V_EFFECTIVE_DATE, V_EXPIRATION_DATE
         from authorization
         where authorization_id = ai_authorization_id;
   
  SET  v_status = 1;
   select function_id, function_category, qualifier_type
         into V_FUNCTION_ID, V_FUNCTION_CATEGORY, V_QUALIFIER_TYPE
         from function
  	where function_name = a_function_name;
   
  SET  v_status = 2;
   select qualifier_code, qualifier_name
         into V_QUALIFIER_CODE, V_QUALIFIER_NAME
         from qualifier
 	where qualifier_code = a_qualifier_code
         and qualifier_type = v_qualifier_type;
   
  SET  v_status = 3;
   select kerberos_name into V_KERBEROS_NAME from person
 	where kerberos_name = a_kerberos_name;
   update authorization
     set FUNCTION_ID = v_function_id, QUALIFIER_ID = v_qualifier_id,
       KERBEROS_NAME = a_kerberos_name, QUALIFIER_CODE = v_qualifier_code,
       FUNCTION_NAME = a_function_name, FUNCTION_CATEGORY = v_function_category,
       QUALIFIER_NAME = v_qualifier_name, MODIFIED_BY = user,
       MODIFIED_DATE = sysdate, DO_FUNCTION = a_do_function,
       GRANT_AND_VIEW = a_grant_and_view, DESCEND = a_descend,
       EFFECTIVE_DATE = auth_sf_convert_str_to_date(A_EFFECTIVE_DATE),
       EXPIRATION_DATE = auth_sf_convert_str_to_date(A_EXPIRATION_DATE)
     where AUTHORIZATION_ID = ai_authorization_id;
  SET  a_modified_by = UC_USER_WITHOUT_HOST();
  SET a_modified_date = auth_sf_convert_date_to_str(NOW());

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`delete_fund_centers_rel_str`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`delete_fund_centers_rel_str`(
    IN  ai_fund_center     VARCHAR(50),
    IN 	ai_for_user        VARCHAR(20),
    OUT ao_message          VARCHAR(255) )
BEGIN
   DECLARE   v_check_auth     VARCHAR (2);
    DECLARE v_message        VARCHAR(255);
    DECLARE v_message_no     INTEGER;
    DECLARE v_count          INTEGER;
    DECLARE v_fund_center    varchar(10);

 
    SET v_check_auth =
       auth_sf_check_auth2 ('MAINTAIN MOD 1 FC',
                            'NULL',
                            ai_for_user,
                            'PROXY FOR ROLES ADMIN FUNC',
                            'NULL'
                           );
 
  IF v_check_auth ='X' THEN
	SET ao_message = CONCAT('Database user ',' ',UC_USER_WITHOUT_HOST(),' is not authorized to act as a proxy for other users.');
	  CALL permit_signal(ao_message,-20012);
  ELSEIF v_check_auth ='N' THEN
	SET ao_message = CONCAT(ai_for_user, ''' not authorized to maintain list of Model 1 fund centers');
	  CALL permit_signal(ao_message,-20100);
  ELSE
       SELECT COUNT (fund_center_id)
         INTO v_count
         FROM rdb_t_funds_cntr_release_str
        WHERE fund_center_id = ai_fund_center;
 
       select ai_fund_center into v_fund_center FROM dual;
 
  IF (v_fund_center is null || trim(v_fund_center) = '') THEN
   	SET ao_message = ' Fund Center ID needs to be provided';
   	CALL permit_signal(ao_message,-20110);
    elseif v_count > 0 THEN
          DELETE FROM rdb_t_funds_cntr_release_str
                WHERE fund_center_id = ai_fund_center;
 
          COMMIT;
          SET ao_message =
                  CONCAT('FUND CENTER ''' , ai_fund_center , ''' has been deleted.');
       ELSEIF v_count = 0
            THEN
  
       		SET ao_message = CONCAT('FUND CENTER ''' , ai_fund_center , ''' does not exist.');
   		CALL permit_signal(ao_message,-20101);

         END IF;
       END IF;

 
 END $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`initcap`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`initcap`(str varchar(255)) RETURNS varchar(255) CHARSET latin1
begin
declare counter int;
declare pos int;
declare strtemp varchar(255);
declare strfinal varchar(255);
set pos = locate(' ',str);
if pos = 0
then
set strfinal = uppercase(str);
else
set strtemp = substring(str,1,pos-1);
set strfinal = uppercase(strtemp);
set counter = pos;

while counter < length(str)
do
set pos=locate(' ',str,counter+1);
if pos = 0
then
set strtemp = substring(str,counter+1);
set strfinal = concat(strfinal,' ',uppercase(strtemp));
set counter = length(str);
else
set strtemp = substring(str,counter+1,pos-1);
set strfinal = concat(strfinal,' ',uppercase(strtemp));
set counter = pos;
end if;
end while;
end if;
return strfinal;
end;

 $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`Insert_Fund_Centers_Rel_Str`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`Insert_Fund_Centers_Rel_Str`(
    IN ai_fund_center   VARCHAR(30),
    IN ai_for_user      VARCHAR(30),
    IN ao_message       VARCHAR(255)
 )
BEGIN
    DECLARE  v_check_auth          VARCHAR (2);

    
    DECLARE  v_message             VARCHAR (255);
    DECLARE  v_message_no          INTEGER;
    DECLARE  v_length              INTEGER DEFAULT 0;
    DECLARE  v_fund_center_count   INTEGER DEFAULT 0;
    DECLARE  v_numeric             VARCHAR (6) DEFAULT '';
    DECLARE  v_fund_center         VARCHAR(20);


 DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
 	SET v_message = 'Error in insert_fund_centers_rel_str' ;
       SET v_message_no = -20110;
       SET ao_message = CONCAT(v_message_no,' ',v_message);
	CALL permit_signal(ao_message,v_message_no);
  END;

 IF (v_fund_center is null || TRIM(v_fund_center) = '') THEN
          		SET ao_message = 'FUND CENTER ID needs to be provided.';
	  		CALL permit_signal(ao_message,-20110);
 END IF;

 SET v_check_auth =
       auth_sf_check_auth2 ('MAINTAIN MOD 1 FC',
                            'NULL',
                            ai_for_user,
                            'PROXY FOR ROLES ADMIN FUNC',
                            'NULL'
                           );
 
  IF v_check_auth ='X' THEN
	SET ao_message = CONCAT('Database user ',' ',UC_USER_WITHOUT_HOST(),' is not authorized to act as a proxy for other users.');
	CALL permit_signal(ao_message,-20102);
  ELSEIF v_check_auth ='N' THEN
	SET ao_message = CONCAT(ai_for_user, ''' not authorized to maintain list of Model 1 fund centers');
	CALL permit_signal(ao_message,-20101);
 end if;

 SELECT LENGTH(ai_fund_center) INTO v_length FROM DUAL;


       SELECT SUBSTRING(ai_fund_center, 4, 6) INTO v_numeric FROM DUAL;

       SELECT ai_fund_center
         INTO v_fund_center
         FROM DUAL;

      SELECT COUNT(*) INTO v_fund_center_count FROM RDB_T_FUNDS_CNTR_RELEASE_STR
       WHERE fund_center_id = ai_fund_center;

       IF v_length < 8 THEN
		      SET ao_message = CONCAT('FUND CENTER ''' , ai_fund_center , ''' IS too short.');
		      CALL permit_signal(ao_message,-20105);
       ELSEIF v_length > 8 THEN
          	SET ao_message = CONCAT('FUND CENTER ''' , ai_fund_center , ''' IS too long.');
	  		    CALL permit_signal(ao_message,-20104);
      END IF;

       IF v_fund_center_count > 0 THEN
		SET ao_message = CONCAT('FUND CENTER ''' , ai_fund_center , ''' already exists.');
		CALL permit_signal(ao_message,-20103);
       ELSEIF    (   SUBSTR (v_numeric, 1, 1) < '0'
                       OR SUBSTR (v_numeric, 1, 1) > '9'
                      )
                   OR (   SUBSTR (v_numeric, 2, 1) < '0'
                       OR SUBSTR (v_numeric, 2, 1) > '9'
                      )
                   OR (   SUBSTR (v_numeric, 3, 1) < '0'
                       OR SUBSTR (v_numeric, 3, 1) > '9'
                      )
                   OR (   SUBSTR (v_numeric, 4, 1) < '0'
                       OR SUBSTR (v_numeric, 4, 1) > '9'
                      )
                   OR (   SUBSTR (v_numeric, 5, 1) < '0'
                       OR SUBSTR (v_numeric, 5, 1) > '9'
                      )
                   OR (   SUBSTR (v_numeric, 6, 1) < '0'
                       OR SUBSTR (v_numeric, 6, 1) > '9'
                      )
                THEN
			SET ao_message = CONCAT( 'FUND CENTER ''' , ai_fund_center, ''' must have numeric values after "FC"');
			CALL permit_signal(ao_message,-20106);

         ELSE
                 INSERT INTO rolesbb.RDB_T_FUNDS_CNTR_RELEASE_STR
                        VALUES (ai_fund_center, '1', ai_for_user, NOW());

                   COMMIT;
                   SET ao_message = CONCAT(
                         'FUND CENTER '''
                      , ai_fund_center
                      , ''' has been inserted');
         END IF;


 END $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`next_sequence_val`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`next_sequence_val`(seq_name char(255) ) RETURNS bigint(20) unsigned
    MODIFIES SQL DATA
    DETERMINISTIC
begin
                declare o_return bigint unsigned;
                declare curr_val bigint unsigned DEFAULT -1;
                declare v_lock tinyint unsigned;
                select get_lock('sequence_table', 10) into v_lock;

                select currval into curr_val from sequence_table  where sequence_name=seq_name;
                if curr_val != -1 then
                        update sequence_table set currval=currval+1 where sequence_name=seq_name;
                
                else
                        insert into sequence_table (sequence_name,currval) values (seq_name,1);
                end if;
                select currval into o_return from sequence_table where sequence_name=seq_name ;
                select release_lock('sequence_table') into v_lock;
                return o_return;
END;

 $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`permit_signal`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`permit_signal`(error_text VARCHAR(255), error_code INTEGER)
BEGIN

SET @sql = CONCAT('UPDATE `',error_text,'`SET x=1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
END $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`roles_msg`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`roles_msg`(err_number INTEGER) RETURNS varchar(255) CHARSET latin1
begin

DECLARE a_msg VARCHAR(255) DEFAULT '';
DECLARE EXIT HANDLER FOR NOT FOUND
 RETURN 'Unknown error code';
 
SELECT err_msg INTO a_msg FROM roles_error_msg WHERE err_no = error_number;

RETURN a_msg;
end;

 $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`rolesapi_batch_create_auth`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`rolesapi_batch_create_auth`(IN AI_SERVER_USER  VARCHAR(20),
                  IN AI_FOR_USER  VARCHAR(20),
 		 IN AI_KERBEROS_NAME  VARCHAR(20),
                  IN AI_AUTHORIZATION_ID  VARCHAR(20),
 		 OUT a_modified_by  VARCHAR(10),
 		 OUT a_modified_date  VARCHAR(10),
                  OUT a_authorization_id  VARCHAR(20)
 		)
BEGIN
 
 
 DECLARE V_KERBEROS_NAME VARCHAR(20);
 DECLARE V_FOR_USER VARCHAR(20);
 DECLARE V_SERVER_USER VARCHAR(20);
 DECLARE V_AUTHORIZATION_ID INTEGER;
 DECLARE v_status integer;
 DECLARE v_error_no INTEGER;
 DECLARE v_error_msg VARCHAR(255);
 DECLARE v_msg_no INTEGER;
 DECLARE v_msg VARCHAR(255);
 DECLARE A_KERBEROS_NAME VARCHAR(20);
 DECLARE v_server_has_auth varchar(1);
 DECLARE v_proxy_has_auth varchar(1);
 
 DECLARE v_old_function_id INTEGER;
 DECLARE v_old_function_name VARCHAR(50);
 DECLARE v_old_qualifier_id INTEGER;
 DECLARE v_old_qualifier_code VARCHAR(20);
 DECLARE v_old_kerberos_name VARCHAR(20);
 DECLARE v_old_function_category VARCHAR(10);
 DECLARE v_old_qualifier_name VARCHAR(50);
 DECLARE v_old_descend VARCHAR(1);
 DECLARE v_old_do_function VARCHAR(1);
 DECLARE v_old_grant_and_view VARCHAR(2);
 DECLARE v_old_effective_date varchar(20);
 DECLARE v_old_expiration_date varchar(20);
 DECLARE v_count integer;

    DECLARE EXIT HANDLER FOR NOT FOUND
      BEGIN
           if v_status = 1 then
     		     SET v_msg_no = -20001;
     		     SET v_msg = roles_msg(-20001);
           elseif v_status = 2 then
                        SET v_msg_no = -20017;
                        SET v_msg = roles_msg(-20017);
           else
     		     SET v_msg_no = -20003;
     		     SET v_msg = roles_msg(-20003);
           end if;
               call permit_signal( v_msg,v_msg_no);
       END;
   
      DECLARE EXIT HANDLER FOR 1022
             call permit_signal( roles_msg(-20007),-20007);

   SET v_for_user = upper(ai_for_user);
   if (ai_server_user is not null && trim(ai_server_user) != '') then
     SET v_server_user = upper(ai_server_user);
   else
     SET v_server_user = upper(user);
   end if;
   SET a_kerberos_name = upper(ai_kerberos_name);
 
   
   SET v_status = 1;  
   select auth_sf_check_number(ai_authorization_id) into v_count from dual;
   if (v_count <> 1) then
      call permit_signal(CONCAT('Authorization_id '''
        , ai_authorization_id
        , ''') is not a valid number.'),-20010);
   end if;
   SET v_authorization_id = CAST(ai_authorization_id AS UNSIGNED INTEGER);
 
   SET v_status = 2;  
   select count(*) into v_count
          from authorization
          where authorization_id = v_authorization_id;
   if (v_count < 1) then
      call permit_signal( CONCAT('Authorization_id '''
        , v_authorization_id
        ,''') is not a valid id.'),-20011);
   end if;
 
   select function_category, function_name, qualifier_code,
          do_function, grant_and_view,
           function_id, function_name, function_category, qualifier_id, kerberos_name,
           qualifier_name, descend,
           auth_sf_convert_date_to_str(effective_date),
           auth_sf_convert_date_to_str(expiration_date)
          into v_old_function_category, v_old_function_name, v_old_qualifier_code,
           v_old_do_function, v_old_grant_and_view,
           v_old_function_id, v_old_function_name,
 	  v_old_function_category, v_old_qualifier_id, v_old_kerberos_name,
           v_old_qualifier_name, v_old_descend,
           v_old_effective_date, v_old_expiration_date
          from authorization
          where authorization_id = v_authorization_id;
 
   SET v_status = 3;  
   
   select count(*) into v_count
     from person where kerberos_name = a_kerberos_name;
   if v_count = 0 then
     SET v_error_no = -20030;
     SET v_error_msg = CONCAT('Kerberos name ''' , a_kerberos_name , ''' not found.');
     call permit_signal( v_error_msg,v_error_no);
   end if;
 
   
   if (v_server_user <> UC_USER_WITHOUT_HOST()) then
      SELECT ROLESAPI_IS_USER_AUTHORIZED(UC_USER_WITHOUT_HOST(),
                                         'RUN ROLES SERVICE PROCEDURES',
                                         CONCAT('CAT' , trim(v_old_function_category)))
         INTO v_server_has_auth
         FROM DUAL;
      if v_server_has_auth <> 'Y' then
        SET v_error_no = -20003;
        SET v_error_msg = '<server_id> has no authorization to be proxy for creating auths in category <function_category>';
        SET v_error_msg = replace(v_error_msg, '<server_id>',
                               UC_USER_WITHOUT_HOST());
        SET v_error_msg = replace(v_error_msg, '<function_category>',
                               v_old_function_category);
        call permit_signal(v_error_msg, v_error_no);
      end if;
   end if;
 
   
   if (v_server_user <> v_for_user) then
      SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user,
                                         'RUN ROLES SERVICE PROCEDURES',
                                         CONCAT('CAT' , trim(v_old_function_category)))
         INTO v_server_has_auth
         FROM DUAL;
   else  
   SET   v_server_has_auth = 'Y';
   end if;
   if v_server_has_auth <> 'Y' then
     SET v_error_no = -20003;
        SET v_error_msg = '<server_id> has authorization to be proxy for creating auths in category <function_category>';
     SET v_error_msg = replace(v_error_msg, '<server_id>',
                            v_server_user);
     SET v_error_msg = replace(v_error_msg, '<function_category>',
                            v_old_function_category);
     call permit_signal(v_error_msg, v_error_no);
   end if;
 
   
   if (auth_sf_can_create_auth(v_for_user, v_old_function_name, v_old_qualifier_code,
 	v_old_do_function, v_old_grant_and_view) = 'N') then
      SET v_error_no = -20014;
      SET v_error_msg = CONCAT('User ''' , v_for_user
                    , ''' is not authorized to create authorizations'
                    , ' for function '''
                    , v_old_function_name , ''' and qualifier '''
                    , v_old_qualifier_code , '''.');
      call permit_signal( v_error_msg, v_error_no);
   end if;

   
   select count(*) into v_count from authorization
     where kerberos_name = a_kerberos_name
     and function_id = v_old_function_id
     and qualifier_id = v_old_qualifier_id;
   if v_count > 0 then
     SET v_error_no = -20007;
     SET v_error_msg = roles_msg(-20007);
         call permit_signal( v_error_msg, v_error_no);

   end if;
 
   

   insert into authorization
 	values(authorization_sequence.nextval, V_OLD_FUNCTION_ID, V_OLD_QUALIFIER_ID,
 		A_KERBEROS_NAME, V_OLD_QUALIFIER_CODE, V_OLD_FUNCTION_NAME,
 		V_OLD_FUNCTION_CATEGORY, V_OLD_QUALIFIER_NAME, v_for_user,
 		NOW(), V_OLD_DO_FUNCTION, V_OLD_GRANT_AND_VIEW, V_OLD_DESCEND,
 		greatest(auth_sf_convert_str_to_date(V_OLD_EFFECTIVE_DATE),
                         NOW()),
 		auth_sf_convert_str_to_date(V_OLD_EXPIRATION_DATE));
   SET a_modified_by = v_for_user;
   select CONCAT(v_for_user , ':' )  
       into a_modified_by from dual;
   SET a_modified_date = auth_sf_convert_date_to_str(NOW());
   select to_char(authorization_id) into a_authorization_id
     from authorization where kerberos_name = a_kerberos_name
     and function_category = V_OLD_FUNCTION_CATEGORY
     and function_name = V_OLD_FUNCTION_NAME
     and qualifier_code = V_OLD_QUALIFIER_CODE;

 
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`rolesapi_batch_update_auth`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`rolesapi_batch_update_auth`(IN AI_SERVER_USER  VARCHAR(20),
		IN AI_FOR_USER  VARCHAR(20),
                 IN  AI_AUTHORIZATION_ID VARCHAR(10),
                  AI_EFFECTIVE_DATE VARCHAR(10),
                  AI_EXPIRATION_DATE VARCHAR(10),
		OUT a_modified_by  VARCHAR(10),
		OUT a_modified_date  VARCHAR(10))
BEGIN


 DECLARE V_KERBEROS_NAME VARCHAR(20);
 DECLARE V_FOR_USER VARCHAR(20);
 DECLARE V_SERVER_USER VARCHAR(20);
 DECLARE V_AUTHORIZATION_ID INTEGER;
 DECLARE v_status integer;
 DECLARE v_error_no INTEGER;
 DECLARE v_error_msg VARCHAR(255);
 DECLARE v_msg_no INTEGER;
 DECLARE v_msg VARCHAR(255);
 DECLARE v_server_has_auth varchar(1);
 DECLARE v_proxy_has_auth varchar(1);
 
 DECLARE v_old_function_id INTEGER;
 DECLARE v_old_function_name VARCHAR(50);
 DECLARE v_old_qualifier_id INTEGER;
 DECLARE v_old_qualifier_code VARCHAR(20);
 DECLARE v_old_kerberos_name VARCHAR(20);
 DECLARE v_old_function_category VARCHAR(10);
 DECLARE v_old_qualifier_name VARCHAR(50);
 DECLARE v_old_descend VARCHAR(1);
 DECLARE v_old_do_function VARCHAR(1);
 DECLARE v_old_grant_and_view VARCHAR(2);
 DECLARE v_old_effective_date varchar(20);
 DECLARE v_old_expiration_date varchar(20);
 DECLARE v_count integer;


 DECLARE  A_EFFECTIVE_DATE varchar(255);
 DECLARE A_EXPIRATION_DATE varchar(255);
 
             
DECLARE EXIT HANDLER FOR NOT FOUND
   BEGIN
              if v_status = 1 then
                     SET v_msg_no = -20001;
                     SET v_msg = CONCAT('Invalid function ''' , v_old_function_name ,
                              ''' specified.');
              elseif v_status = 2 then
                     SET v_msg_no = -20017;
                     SET v_msg = roles_msg(-20017);
              elseif v_status = 3 then
                     SET v_msg_no = -20003;
                     SET v_msg = CONCAT('Invalid Kerberos_name ''' , v_old_kerberos_name ,
                              ''' specified.');
              elseif v_status = 5 then
                     SET v_msg_no = -20010;
                     SET v_msg = roles_msg(-20010);
              else
                     SET v_msg_no = -20999;
                     SET v_msg = CONCAT('Internal program problem. Bad v_status_code'
                              , ' in procedure rolesapi_batch_update_auth.');
              end if;
              CALL permit_signal( v_msg,v_msg_no);
   END;

   DECLARE EXIT HANDLER FOR 1022 
              CALL permit_signal( roles_msg(-20007),-20007);             
 

  SET v_for_user = upper(ai_for_user);
    if (ai_server_user is not null && trim(ai_server_user) != '') then
      SET v_server_user = upper(ai_server_user);
    else
      SET v_server_user = upper(user);
    end if;
   SET a_effective_date = DATE_FORMAT(NOW(), '%m%d%y');
   if (ai_expiration_date is not null  && ai_expiration_date != '') then
     SET a_expiration_date = ai_expiration_date;
   else
     SET a_expiration_date = '        ';
   end if;
  
    
    SET v_status = 1;  
    select auth_sf_check_number(ai_authorization_id) into v_count from dual;
    if (v_count <> 1) then
       CALL permit_signal(CONCAT('Authorization_id '''
         , ai_authorization_id
         , ''') is not a valid number.'),-20010);
    end if;
    SET v_authorization_id = CAST(ai_authorization_id AS UNSIGNED INTEGER);


   SET v_status = 2;  
   select count(*) into v_count
          from authorization
          where authorization_id = v_authorization_id;
   if (v_count < 1) then
      CALL permit_signal( CONCAT('Authorization_id '''
        , v_authorization_id
        ,''') is not a valid id.'),-20011);
   end if;
 
 
   
   if a_expiration_date <> '        ' then
     select auth_sf_check_date_noslash(a_expiration_date)
         into v_count from dual;
     if (v_count <> 1) then
        CALL permit_signal(CONCAT('Invalid expiration date ''',ai_expiration_date, ''' must be in mmddyyyy format.'),-20011);
     end if;
   end if;
 
 
   select function_category, function_name, qualifier_code,
          do_function, grant_and_view,
           function_id, function_name, function_category, qualifier_id, kerberos_name,
           qualifier_name, descend,
           auth_sf_convert_date_to_str(effective_date),
           auth_sf_convert_date_to_str(expiration_date)
          into v_old_function_category, v_old_function_name, v_old_qualifier_code,
           v_old_do_function, v_old_grant_and_view,
           v_old_function_id, v_old_function_name,
 	  v_old_function_category, v_old_qualifier_id, v_old_kerberos_name,
           v_old_qualifier_name, v_old_descend,
           v_old_effective_date, v_old_expiration_date
          from authorization
          where authorization_id = v_authorization_id;
 
   
   if (v_server_user <> UC_USER_WITHOUT_HOST()) then
      SELECT ROLESAPI_IS_USER_AUTHORIZED(UC_USER_WITHOUT_HOST(),
                                         'RUN ROLES SERVICE PROCEDURES',
                                         CONCAT('CAT' , trim(v_old_function_category)))
         INTO v_server_has_auth
         FROM DUAL;
      if v_server_has_auth <> 'Y' then
        SET v_error_no = -20003;
        SET v_error_msg = '<server_id> has no authorization to be proxy for creating auths in category <function_category>';
        SET v_error_msg = replace(v_error_msg, '<server_id>',
                               UC_USER_WITHOUT_HOST());
        SET v_error_msg = replace(v_error_msg, '<function_category>',
                               v_old_function_category);
        CALL permit_signal( v_error_msg,v_error_no);
      end if;
   end if;
 
   
   if (v_server_user <> v_for_user) then
      SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user,
                                         'RUN ROLES SERVICE PROCEDURES',
                                         CONCAT('CAT' , trim(v_old_function_category)))
         INTO v_server_has_auth
         FROM DUAL;
   else  
     SET v_server_has_auth = 'Y';
   end if;
   if v_server_has_auth <> 'Y' then
     SET v_error_no := roles_service_constant.err_20003_no;
     SET v_error_msg = '<server_id> has no authorization to be proxy for creating auths in category <function_category>';
     SET v_error_msg = replace(v_error_msg, '<server_id>',
                            v_server_user);
     SET v_error_msg = replace(v_error_msg, '<function_category>',v_old_function_category);
     CALL permit_signal( v_error_msg,v_error_no);
   end if;
 
   
   if auth_sf_can_create_auth(v_for_user, v_old_function_name, v_old_qualifier_code,
 	v_old_do_function, v_old_grant_and_view) = 'N' then
      SET v_error_no = -20014;
      SET v_error_msg = CONCAT('User ''' , v_for_user
                    , ''' is not authorized to create authorizations'
                    , ' for function '''
                    , v_old_function_name , ''' and qualifier '''
                    , v_old_qualifier_code , '''.');
      CALL permit_signal( v_error_msg,v_error_no);
   end if;
 
 
   IF not (IFNULL(v_old_expiration_date,'        ') = a_expiration_date) then
     
     update authorization
         set function_id = v_old_function_id,
             qualifier_id = v_old_qualifier_id,
             kerberos_name = v_old_kerberos_name,
             qualifier_code = v_old_qualifier_code,
             function_name = v_old_function_name,
             function_category = v_old_function_category,
             qualifier_name = v_old_qualifier_name,
             modified_by = v_for_user,
             modified_date = sysdate,
             do_function = v_old_do_function,
             grant_and_view = v_old_grant_and_view,
             descend = v_old_descend,
             effective_date =
 		auth_sf_convert_str_to_date(v_old_effective_date),
             expiration_date =
                 auth_sf_convert_str_to_date(A_EXPIRATION_DATE)
          where authorization_id = v_authorization_id;
    else
      CALL permit_signal(
        CONCAT('There are no changes to be made. Exp date = ' ,a_expiration_date ,' Old = ' , v_old_expiration_date),-20002);
    end if;
 
    SET a_modified_by = v_for_user;
    SET a_modified_date = NOW();
 
  
 end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`rolesapi_create_auth`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`rolesapi_create_auth`(IN AI_SERVER_USER  VARCHAR(20),
                 IN AI_FOR_USER  VARCHAR(20),
                 IN AI_FUNCTION_NAME VARCHAR(50),
 		 IN AI_QUALIFIER_CODE VARCHAR(30),
 		 IN AI_KERBEROS_NAME  VARCHAR(20),
 		 IN AI_DO_FUNCTION  VARCHAR(1),
 		 IN AI_GRANT_AND_VIEW VARCHAR(2),
 		 IN AI_DESCEND VARCHAR(1),
 		 IN AI_EFFECTIVE_DATE VARCHAR(10),
 		 IN AI_EXPIRATION_DATE VARCHAR(10),
 		 OUT a_modified_by  VARCHAR(10),
 		 OUT a_modified_date  VARCHAR(10),
                 OUT a_authorization_id  VARCHAR(20))
BEGIN
 
  DECLARE V_KERBEROS_NAME VARCHAR(20);
  DECLARE V_FOR_USER VARCHAR(20);
  DECLARE V_SERVER_USER VARCHAR(20);
  
 DECLARE V_QUALIFIER_ID INTEGER;
 DECLARE V_QUALIFIER_CODE VARCHAR(30);
 DECLARE V_QUALIFIER_NAME VARCHAR(30);
 DECLARE V_QUALIFIER_TYPE VARCHAR(30);
 DECLARE V_FUNCTION_ID INTEGER;
 DECLARE V_FUNCTION_NAME VARCHAR(50);
 DECLARE V_FUNCTION_CATEGORY VARCHAR(10);
 
  DECLARE v_status integer;
  DECLARE v_error_no INTEGER;
  DECLARE v_error_msg VARCHAR(255);
  DECLARE v_msg_no INTEGER;
  DECLARE v_msg VARCHAR(255);
  
   DECLARE A_FUNCTION_NAME VARCHAR(50);
   DECLARE A_QUALIFIER_CODE VARCHAR(30);
   DECLARE A_KERBEROS_NAME VARCHAR(20);
   DECLARE A_DO_FUNCTION VARCHAR(1);
   DECLARE A_GRANT_AND_VIEW VARCHAR(2);
   DECLARE A_DESCEND VARCHAR(1);
   
   DECLARE A_EFFECTIVE_DATE varchar(255);
   DECLARE A_EXPIRATION_DATE varchar(255);

  DECLARE v_server_has_auth varchar(1);
  DECLARE v_proxy_has_auth varchar(1);
  
  DECLARE EXIT HANDLER FOR NOT FOUND
      BEGIN
           if v_status = 1 then
     		     SET v_msg_no = -20001;
     		     SET v_msg = roles_msg(-20001);
           elseif v_status = 2 then
                        SET v_msg_no = -20017;
                        SET v_msg = roles_msg(-20017);
           else
     		     SET v_msg_no = -20003;
     		     SET v_msg = roles_msg(-20003);
           end if;
               call permit_signal( v_msg,v_msg_no);
       END;
   
      DECLARE EXIT HANDLER FOR 1022
             call permit_signal( roles_msg(-20007),-20007);
             
      
   SET v_for_user = upper(ai_for_user);
   if (ai_server_user is not null && trim(ai_server_user) != '') then
     SET v_server_user = upper(ai_server_user);
   else
     SET v_server_user = upper(UC_USER_WITHOUT_HOST());
   end if;
   SET a_kerberos_name = upper(ai_kerberos_name);


   SET a_function_name = upper(ai_function_name);
   SET a_qualifier_code = upper(ai_qualifier_code);
   SET a_do_function = upper(ai_do_function);
   SET a_grant_and_view = upper(ai_grant_and_view);
   SET a_descend = upper(ai_descend);
   if (ai_effective_date is not null && trim(ai_effective_date) != '') then
     SET a_effective_date = ai_effective_date;
   else
     SET a_effective_date = DATE_FORMAT(NOW(), '%m%d%y');
   end if;
   if (ai_expiration_date is not null && trim(ai_expiration_date) != '') then
     SET a_expiration_date = ai_expiration_date;
   else
     SET a_expiration_date = '        ';
   end if;
 
   
   
   if (a_grant_and_view = 'Y ' or a_grant_and_view = 'Y'
       or a_grant_and_view = 'GD' or a_grant_and_view = 'G') then
     SET a_grant_and_view = 'GD';
   else
     SET a_grant_and_view = 'N ';
   end if;
 
   
   if (a_descend <> 'Y' and a_descend <> 'N') then
      call permit_signal('Descend must be ''Y'' or ''N''.',-20009);
   end if;
 
   SET v_status = 1;  
   select function_id, function_name, function_category, qualifier_type
     into v_function_id, v_function_name, v_function_category, v_qualifier_type
     from function
     where function_name = a_function_name;
 
   SET v_status = 2;  
   select qualifier_id, qualifier_code, qualifier_name
     into v_qualifier_id, v_qualifier_code, v_qualifier_name
     from qualifier where qualifier_code = a_qualifier_code
     and qualifier_type = v_qualifier_type;
 
   SET v_status = 3;  
   select kerberos_name into v_kerberos_name
     from person where kerberos_name = a_kerberos_name;
 
   
   if (v_qualifier_type = 'DEPT'
       and substr(v_qualifier_code, 1, 2) <> 'D_') then
      call permit_signal('In auths. for this function, qualifier code must start with D_',-20015);
   end if;
 
   
   if (v_server_user <> UC_USER_WITHOUT_HOST()) then
      SELECT ROLESAPI_IS_USER_AUTHORIZED(UC_USER_WITHOUT_HOST(),
                                         'RUN ROLES SERVICE PROCEDURES',
                                         CONCAT('CAT' ,trim(v_function_category)))
         INTO v_server_has_auth
         FROM DUAL;
      if v_server_has_auth <> 'Y' then
        set v_error_no = -20003;
        SET v_error_msg = '<server_id> has no authorization to be proxy for creating auths in category <function_category>';
        SET v_error_msg = replace(v_error_msg, '<server_id>',
                               UC_USER_WITHOUT_HOST());
        SET v_error_msg = replace(v_error_msg, '<function_category>',v_function_category);
        call permit_signal( v_error_msg,v_error_no);
      end if;
   end if;
 
   
   if (v_server_user <> v_for_user) then
      SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user,
                                         'RUN ROLES SERVICE PROCEDURES',
                                         CONCAT('CAT' ,trim(v_function_category)))
         INTO v_server_has_auth
         FROM DUAL;
   else   
     SET v_server_has_auth = 'Y';
   end if;
   if v_server_has_auth <> 'Y' then
     SET v_error_no = roles_service_constant.err_20003_no;
     SET v_error_msg = roles_service_constant.err_20003_msg;
     SET v_error_msg = replace(v_error_msg, '<server_id>',
                            v_server_user);
     SET v_error_msg = replace(v_error_msg, '<function_category>',
                            v_function_category);
        call permit_signal( v_error_msg,v_error_no);
   end if;
 
   
   if auth_sf_can_create_auth(v_for_user, AI_FUNCTION_NAME, AI_QUALIFIER_CODE,
 	AI_DO_FUNCTION, AI_GRANT_AND_VIEW) = 'N' then
      SET v_error_no = -20014;
      SET v_error_msg = CONCAT('User ''' , v_for_user
                    ,''' is not authorized to create authorizations'
                    , ' for function '''
                    , ai_function_name , ''' and qualifier '''
                    , ai_qualifier_code , '''.');
        call permit_signal( v_error_msg,v_error_no);
   end if;
 
   insert into authorization (function_id,qualifier_id,kerberos_name,qualifier_code,
   function_name,function_category,qualifier_name,modified_by,modified_date,do_function,
   grant_and_view,descend,effective_date,expiration_date)
 	values( V_FUNCTION_ID, V_QUALIFIER_ID,
 		A_KERBEROS_NAME, V_QUALIFIER_CODE, V_FUNCTION_NAME,
 		V_FUNCTION_CATEGORY, V_QUALIFIER_NAME, v_for_user,
 		NOW(), A_DO_FUNCTION, A_GRANT_AND_VIEW, A_DESCEND,
 		greatest(auth_sf_convert_str_to_date(A_EFFECTIVE_DATE),
                         NOW()),
 		auth_sf_convert_str_to_date(A_EXPIRATION_DATE));
   
   select CONCAT(v_for_user , ':' )       
       into a_modified_by from dual;
   SET a_modified_date = auth_sf_convert_date_to_str(NOW());
   select authorization_id into a_authorization_id
     from authorization where kerberos_name = a_kerberos_name
     and function_category = V_FUNCTION_CATEGORY
     and function_name = V_FUNCTION_NAME
     and qualifier_code = V_QUALIFIER_CODE;

 end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`rolesapi_create_imprule`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`rolesapi_create_imprule`( IN AI_FOR_USER VARCHAR(20),
 		  IN AI_SERVER_USER  VARCHAR(20),
 		  IN AI_RULE_TYPE_CODE  VARCHAR(20),
                  IN  AI_CONDITION_FUNCTION_OR_GROUP  VARCHAR(20),
                  IN  AI_CONDITION_FUNCTION_CATEGORY  VARCHAR(10),
 		  IN AI_CONDITION_FUNCTION_NAME  VARCHAR(50),
 		  IN AI_CONDITION_OBJECT_TYPE  VARCHAR(20),
 		  IN AI_CONDITION_QUAL_CODE  VARCHAR(20),
 		  IN AI_RESULT_FUNCTION_CATEGORY  VARCHAR(20),
 		  IN AI_RESULT_FUNCTION_NAME  VARCHAR(50),
 		  IN AI_AUTH_PARENT_OBJ_TYPE  VARCHAR(20),
 		  IN AI_RESULT_QUALIFIER_CODE  VARCHAR(20),
 		  IN AI_RULE_SHORT_NAME  VARCHAR(20),
 		  IN AI_RULE_DESCRIPTION  VARCHAR(2000),
 		  IN AI_RULE_IS_IN_EFFECT VARCHAR(1),
 		  OUT a_modified_by  VARCHAR(20),
 		  OUT a_modified_date  VARCHAR(20),
 		  OUT a_rule_id  VARCHAR(10)
 		)
BEGIN
 
 DECLARE A_FOR_USER VARCHAR(20);
 DECLARE A_SERVER_USER VARCHAR(20);
 DECLARE A_RULE_TYPE_CODE VARCHAR(20);
 DECLARE A_CONDITION_FUNCTION_OR_GROUP VARCHAR(20);
 DECLARE A_CONDITION_FUNCTION_CATEGORY VARCHAR(20);
 DECLARE A_CONDITION_FUNCTION_NAME VARCHAR(30);
 DECLARE A_CONDITION_OBJECT_TYPE VARCHAR(20);
 DECLARE A_CONDITION_QUAL_CODE VARCHAR(20);
 DECLARE A_RESULT_FUNCTION_CATEGORY VARCHAR(20);
 DECLARE A_RESULT_FUNCTION_NAME VARCHAR(50);
 DECLARE A_AUTH_PARENT_OBJ_TYPE VARCHAR(20);
 DECLARE A_RESULT_QUALIFIER_CODE VARCHAR(20);
 DECLARE A_RULE_SHORT_NAME VARCHAR(60);
 DECLARE A_RULE_DESCRIPTION VARCHAR(2000);
 DECLARE A_RULE_IS_IN_EFFECT VARCHAR(1);
 DECLARE v_qualifier_code VARCHAR(15);
 DECLARE v_error_no INTEGER;
 DECLARE v_error_msg VARCHAR(255);
 DECLARE v_msg_no INTEGER;
 DECLARE v_msg VARCHAR(255);
 DECLARE v_function_category VARCHAR(4);
 DECLARE v_function_name VARCHAR(30);
 DECLARE v_status integer;
 DECLARE v_rule_id integer;
 
 
 DECLARE v_count integer DEFAULT 0;
 DECLARE v_count2 integer  DEFAULT 0;
 
 DECLARE v_for_user VARCHAR(20);
 DECLARE v_server_user VARCHAR(20);
 DECLARE v_server_has_auth varchar(1);
 DECLARE v_proxy_has_auth varchar(1);
 

   SET v_for_user = upper(ai_for_user);
   if (ai_server_user is not null && trim(ai_server_user) != '') then
     SET v_server_user = upper(ai_server_user);
   else
     SET v_server_user = upper(UC_USER_WITHOUT_HOST());
   end if;
   SET a_rule_type_code = ai_rule_type_code;
   SET a_condition_function_or_group = upper(ai_condition_function_or_group);
   SET a_condition_function_category = upper(ai_condition_function_category);
   SET a_condition_function_name = upper(ai_condition_function_name);
   SET a_condition_object_type = upper(ai_condition_object_type);
   SET a_condition_qual_code = upper(ai_condition_qual_code);
   SET a_result_function_category = upper(ai_result_function_category);
   SET a_result_function_name  = upper(ai_result_function_name);
   SET a_auth_parent_obj_type = upper(ai_auth_parent_obj_type);
   SET a_result_qualifier_code = upper(ai_result_qualifier_code);
   SET a_rule_short_name = trim(ai_rule_short_name);
   SET a_rule_description = trim(ai_rule_description);
   SET a_rule_is_in_effect = upper(ai_rule_is_in_effect);
   SET v_function_category  = upper(ai_result_function_category);
 
 
   
   if (v_server_user <> UC_USER_WITHOUT_HOST()) then
      SELECT ROLESAPI_IS_USER_AUTHORIZED(UC_USER_WITHOUT_HOST(),
                                         'RUN ROLES SERVICE PROCEDURES',
                                         CONCAT('CAT' ,trim(v_function_category)))
         INTO v_server_has_auth
         FROM DUAL;
      if v_server_has_auth <> 'Y' then
	     SET v_error_no = -20003;
	     SET v_error_msg = 'Error: <server_id> has no authorization to be proxy for creating auths in category <function_category>';
	     SET v_error_msg = replace(v_error_msg, '<server_id>',
				    UC_USER_WITHOUT_HOST());
	     SET v_error_msg = replace(v_error_msg, '<function_category>',
				    v_function_category);
	     call permit_signal(v_error_msg, v_error_no);
      end if;
   end if;
 
   
   if (v_server_user <> v_for_user) then
      SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user,
                                         'RUN ROLES SERVICE PROCEDURES',
                                         CONCAT('CAT' , trim(v_function_category)))
         INTO v_server_has_auth
         FROM DUAL;
   else   
     SET v_server_has_auth = 'Y';
   end if;
   if v_server_has_auth <> 'Y' then
     SET v_error_no = -20003;
     SET v_error_msg = 'Error: <server_id> has no authorization to be proxy for creating auths in category <function_category>';
     SET v_error_msg = replace(v_error_msg, '<server_id>',
                            v_server_user);
     SET v_error_msg = replace(v_error_msg, '<function_category>',
                            v_function_category);
     call permit_signal(v_error_msg, v_error_no);
   end if;
 
 
 
 
   if auth_sf_can_create_rule(v_for_user, ai_result_function_category
 	) = 'N' then
	   SET v_error_no = -20033;
	   SET v_error_msg = CONCAT('Error: User ''' , v_for_user
                    , ''' is not authorized to create an implied authorization rule'
                    , ' for function category'''
                    , ai_result_function_category , '''.');
	    call permit_signal( v_error_msg,v_error_no);
   end if;
 
 
 
 
 
 
 

 if (a_rule_type_code not in ('1a', '1b','2a', '2b')) then
 
  SET v_error_no  = -20034;
  SET v_error_msg = CONCAT('Error: Invalid rule type code ''', '<rule_type_code>',''' . Should be 1a or 1b or 2a or 2b.');
  SET v_error_msg = replace(v_error_msg,'<rule_type_code>',a_rule_type_code);
  call permit_signal( v_error_msg,v_error_no);
 end if;
 

 

 select count(*) into v_count from implied_auth_rule iar where iar.rule_short_name=ai_rule_short_name;
 if (v_count > 0 ) then
    SET v_error_no = -20037;
    SET v_error_msg = CONCAT('Error: Duplicate short name. A rule with short name ''','<rule_short_name>',''' already exists') ;
    SET v_error_msg = replace(v_error_msg,'<rule_short_name>',ai_rule_short_name);
    call permit_signal( v_error_msg,v_error_no);
 end if;
 
 
 
 
 select count(*) into v_count from implied_auth_rule iar where
 iar.rule_is_in_effect in ('Y','N');
 if (ai_rule_is_in_effect not in ('Y','N')) then
    SET v_error_no = -20038;
    SET v_error_msg = CONCAT('Error: Invalid value for rule_is_in_effect ''','<rule_is_in_effect>',''' . The value should be Y or N.') ;
    SET v_error_msg = replace(v_error_msg,'<rule_is_in_effect>',ai_rule_is_in_effect);
    call permit_signal( v_error_msg,v_error_no);
 end if;
 

  
 
   if (a_condition_function_or_group = 'G') then
    select count(*) into v_count from function_group fg
    where
    fg.function_category=a_condition_function_category
    and
    fg.function_group_name in (CONCAT('*' , a_condition_function_name), a_condition_function_name);
   end if;
   if (a_condition_function_or_group = 'F') then
    select count(*) into v_count from function2 f2
    where
    trim(f2.function_category)=trim(a_condition_function_category)
    and
    f2.function_name in  (CONCAT('*' , a_condition_function_name), a_condition_function_name);
   end if;
 
   if (v_count < 1) then
      SET v_error_no = -20035;
      SET v_error_msg = ' Error: The condition function category <condition_function_category> must match condition function or group <condition_function> or function  <condition_function_name>' ;
      SET v_error_msg = replace(v_error_msg,'<condition_function>',a_condition_function_or_group);
      SET v_error_msg = replace(v_error_msg,'<condition_function_category>',a_condition_function_category);
      SET v_error_msg = replace(v_error_msg,'<condition_function_name>', a_condition_function_name);
      call permit_signal( v_error_msg,v_error_no);
    end if;
 
 
 
 
 select count(function_id) into v_count from function2  where
 trim(function_category) = trim(a_result_function_category)
 and function_name in (CONCAT('*' , a_result_function_name), a_result_function_name);
 if (v_count < 1) then
	SET v_error_no = -20046;
	SET v_error_msg = ' Error: The result function category <function_category> does not match result function name <function_name>';
	SET v_error_msg = replace(v_error_msg,'<function_category>',a_result_function_category);
	SET v_error_msg = replace(v_error_msg,'<function_name>',a_result_function_name);
	call permit_signal( v_error_msg,v_error_no);
 end if;
 
 
  
 
 select count(*) into v_count from function_load_pass
 where
 pass_number = 2
 and
 function_id =  (select function_id from external_function where function_name = CONCAT('*' , a_condition_function_name));
 if (v_count > 0 ) then
	SET v_error_no = -20048;
	SET v_error_msg = ' Error: The function name  <function_name> matches function in load pass table with pass number <pass_number>';
	SET v_error_msg = replace(v_error_msg,'<pass_number>','2');
	SET v_error_msg = replace(v_error_msg,'<function_name>',a_condition_function_name);
	call permit_signal( v_error_msg,v_error_no);   
 end if;
 
 
  
 
 select count(*) into v_count from function_load_pass
 where
 pass_number = 1
 and
 function_id =  (select function_id from external_function where function_name = (CONCAT('*' , a_result_function_name)));
 if (v_count > 0 ) then
	SET v_error_no = -20049;
	SET v_error_msg = ' Error: The function name  <function_name> matches function in load pass table with pass number <pass_number>';
	SET v_error_msg = replace(v_error_msg,'<pass_number>','2');
	SET v_error_msg = replace(v_error_msg,'<function_name>',a_condition_function_name);
	call permit_signal( v_error_msg,v_error_no);   
 end if;
 
  
 if (a_rule_type_code in ('1a', '1b')) then
    if (a_condition_qual_code is not NULL || trim(a_condition_qual_code) != '') then
	SET v_error_no  = -20043;
	SET v_error_msg = 'Error: The rules of type <rule_type_code> should not have qualifier code but qualifier code <condition_qualifier_code> is specified' ;
	SET v_error_msg = replace (v_error_msg,'<rule_type_code>', a_rule_type_code);
	SET v_error_msg = replace(v_error_msg, '<condition_qualifier_code>', a_condition_qual_code);
	call permit_signal( v_error_msg,v_error_no);   
    end if;
 end if;
 
  
 if (a_rule_type_code = '1a') then
 if (a_auth_parent_obj_type is not NULL) then
	SET v_error_no  = -20045;
	SET v_error_msg = 'Error. The rules of type <rule_type_code> should not have qualifier type but qualifier type <result_qualifier_type> is specified' ;
	SET v_error_msg = replace (v_error_msg,'<rule_type_code>', a_rule_type_code);
	SET v_error_msg = replace(v_error_msg, '<result_qualifier_type>', a_auth_parent_obj_type);
	call permit_signal( v_error_msg,v_error_no);   
 end if;
 end if;
 
 
  

 if (a_rule_type_code in ('1a','1b')) then
	select count(*) into v_count from function2
	    where
	    trim(function_category) = trim(a_condition_function_category)
	    and
	    qualifier_type = (select parent_qualifier_type from qualifier_subtype where qualifier_subtype_code = a_condition_object_type)
	    and
	    function_name in (CONCAT('*' , a_condition_function_name), a_condition_function_name);

	if (v_count < 1) then
		    select count(*) into v_count2 from function_group
		    where
		    trim(function_category) = trim(a_condition_function_category)
		    and
		    qualifier_type = (select parent_qualifier_type from qualifier_subtype where qualifier_subtype_code = a_condition_object_type)
		    and
		    function_group_name = a_condition_function_name;
	end if;
 
	if (v_count <  1 and v_count2 < 1) then
		SET v_error_no = -20039;
		SET v_error_msg = ' Error: The parent qualifier type (object type) <result_qualifier_type> ';
		SET v_error_msg = CONCAT(v_error_msg,' found in the qualifier_subtype table for condition object type (subtype) <condition_object_type>');
		SET v_error_msg = CONCAT(v_error_msg,' does not match qualifier type <result_qualifier_type> for given condition function <condition_function_name> and category <condition_function_category>. ');
		SET v_error_msg = replace(v_error_msg,'<condition_object_type>', a_condition_object_type);
		SET v_error_msg = replace(v_error_msg,'<condition_function_name>', a_condition_function_name);
		SET v_error_msg = replace(v_error_msg,'<condition_function_category>', a_condition_function_category);
		SET v_error_msg = replace(v_error_msg,'<result_qualifier_type>', a_auth_parent_obj_type);
		SET v_error_msg = replace(v_error_msg,'<result_qualifier_code>', a_result_qualifier_code);
		call permit_signal( v_error_msg,v_error_no);   
	 end if;
 
 end if;
 
 
  

 if (a_rule_type_code in ('1a','1b')) then
	 select count(*) into v_count from function2
	    where
	    trim(function_category) = trim(a_result_function_category)
	    and
	    qualifier_type = (select parent_qualifier_type from qualifier_subtype where qualifier_subtype_code = a_condition_object_type)
	    and
	    function_name in (CONCAT('*' , a_result_function_name), a_result_function_name);
 
	 if (v_count <  1 ) then
			SET v_error_no = -20047;
			SET v_error_msg = ' Error: The parent qualifier type (object type) <result_qualifier_type> ';
			SET v_error_msg = CONCAT(v_error_msg,' found in the qualifier_subtype table for condition object type (subtype) <condition_object_type>');
			SET v_error_msg = CONCAT(v_error_msg,' does not match qualifier type <result_qualifier_type> for given result function <result_function_name> and category <result_function_category>. ');
			SET v_error_msg = replace(v_error_msg,'<condition_object_type>', a_condition_object_type);
			SET v_error_msg = replace(v_error_msg,'<condition_function_name>', a_condition_function_name);
			SET v_error_msg = replace(v_error_msg,'<condition_function_category>', a_condition_function_category);
			SET v_error_msg = replace(v_error_msg,'<result_qualifier_type>', a_auth_parent_obj_type);
			SET v_error_msg = replace(v_error_msg,'<result_qualifier_code>', a_result_qualifier_code);
			call permit_signal( v_error_msg,v_error_no);   
	 end if;
 end if;
 
 
  

 if (a_rule_type_code = '1b') then
    select count(*) into v_count from subtype_descendent_subtype sds where
     sds.child_subtype_code = a_condition_object_type
    and
     sds.parent_subtype_code = a_auth_parent_obj_type;
   if (v_count < 1 ) then
		SET v_error_no = -20041;
		SET v_error_msg = ' Error: For the the rules of type <rule_type_code> result qualifier type <result_qualifier_type> should be parent of the condition qualifier type <condition_qualifier_type>';
		SET v_error_msg = replace (v_error_msg,'<rule_type_code>',a_rule_type_code);
		SET v_error_msg = replace(v_error_msg,'<condition_qualifier_type>',a_condition_object_type);
		SET v_error_msg = replace(v_error_msg,'<result_qualifier_type>',a_auth_parent_obj_type);
		call permit_signal( v_error_msg,v_error_no);   
   end if;
 end if;
 
 
  
 
 if (a_rule_type_code in ('2a','2b')) then
  select count(qs.qualifier_subtype_code) into v_count from qualifier_subtype qs, qualifier q,
  function2 f2
  where
  qs.qualifier_subtype_code = a_condition_object_type
  and
  qs.parent_qualifier_type = f2.qualifier_type
  and
  f2.function_name in (CONCAT('*' , a_condition_function_name), a_condition_function_name)
  and
  q.qualifier_type = qs.parent_qualifier_type
  and
  q.qualifier_code = a_condition_qual_code;
 
 if (v_count < 1 ) then
  select count(qs.qualifier_subtype_code) into v_count2 from qualifier_subtype qs, qualifier q,
  function_group fg
  where
  qs.qualifier_subtype_code = a_condition_object_type
  and
  qs.parent_qualifier_type = fg.qualifier_type
  and
  fg.function_group_name = a_condition_function_name
  and
  q.qualifier_type = qs.parent_qualifier_type
  and
  q.qualifier_code = a_condition_qual_code;
 end if;
 
  if (v_count < 1 and v_count2 < 1 ) then
      SET v_error_no = -20036;
      SET v_error_msg = ' ai_condition_object_type  (a qualifier type) <condition_qualifier_type> and ai_condition_qual_code <condition_qualifier_code> should be related via qualifier_subtype and function2 tables';
      SET v_error_msg = replace(v_error_msg,'<condition_qualifier_code>',a_condition_qual_code);
      SET v_error_msg = replace(v_error_msg,'<condition_qualifier_type>',a_condition_object_type);
      SET v_error_msg = replace(v_error_msg,'<function_name>',a_condition_function_name);
      call permit_signal( v_error_msg,v_error_no);
   end if;
  end if;
 
 
 
 
 if (a_rule_type_code in ('2a','2b')) then
  select count(qs.qualifier_subtype_code) into v_count from qualifier_subtype qs, qualifier q,
  function2 f2
  where
  qs.qualifier_subtype_code = a_auth_parent_obj_type
  and
  qs.parent_qualifier_type = f2.qualifier_type
  and
  f2.function_name in (CONCAT('*' , a_result_function_name), a_result_function_name)
  and
  q.qualifier_type = qs.parent_qualifier_type
  and
  q.qualifier_code = a_result_qualifier_code;
  if (v_count < 1 ) then
      SET v_error_no = -20032;
      SET v_error_msg = ' The result qualifer code <qualifier_code> and PARENT of the result qualifier type <qualifier_type> does not match the result function <function_name> for rule type <rule_type_code>';
      SET v_error_msg = replace(v_error_msg,'<function_name>',a_result_function_name);
      SET v_error_msg = replace(v_error_msg,'<qualifier_type>',a_auth_parent_obj_type);
      SET v_error_msg = replace(v_error_msg,'<qualifier_code>',a_result_qualifier_code);
      SET v_error_msg  = replace(v_error_msg,'<rule_type_code>',a_rule_type_code);
      call permit_signal( v_error_msg,v_error_no);
     end if;
  end if;
 
 
  
 select min(rule_id) into v_count from implied_auth_rule
 where
       rule_type_code = a_rule_type_code
       and condition_function_or_group = a_condition_function_or_group
       and condition_function_category = a_condition_function_category
       and condition_function_name = a_condition_function_name
       and condition_obj_type = a_condition_object_type
       and IFNULL(condition_qual_code, 'XYZ') = IFNULL(a_condition_qual_code, 'XYZ')
       and result_function_category = a_result_function_category
       and result_function_name = a_result_function_name
       and IFNULL(auth_parent_obj_type, 'XYZ') = IFNULL(a_auth_parent_obj_type, 'XYZ')
       and IFNULL(result_qualifier_code, 'XYZ') = IFNULL(a_result_qualifier_code, 'XYZ');
 if (v_count > 0) then
    SET v_error_no = -20042;
    SET v_error_msg = 'The rule id <rule_id> is duplicated';
    SET v_error_msg = replace(v_error_msg,'<rule_id>',v_count);
    call permit_signal( v_error_msg,v_error_no);
 end if;
 
 
 
  
  
   insert into implied_auth_rule
   (
   rule_type_code,
   condition_function_or_group,
   condition_function_category,
   condition_function_name,
   condition_obj_type,
   condition_qual_code,
   result_function_category,
   result_function_name,
   auth_parent_obj_type,
   result_qualifier_code,
   rule_short_name,
   rule_description,
   rule_is_in_effect,
   modified_by,
   modified_date
   )
   values(
   ai_rule_type_code,
   a_condition_function_or_group,
   a_condition_function_category,
   a_condition_function_name,
   a_condition_object_type,
   a_condition_qual_code,
   a_result_function_category,
   a_result_function_name,
   a_auth_parent_obj_type,
   a_result_qualifier_code,
   a_rule_short_name,
   a_rule_description,
   a_rule_is_in_effect,
   v_for_user,
   NOW()) ;
 
 SET v_rule_id = LAST_INSERT_ID();
 end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`rolesapi_delete_auth`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`rolesapi_delete_auth`(IN AI_SERVER_USER  VARCHAR(20),
                 IN AI_FOR_USER VARCHAR(20),
                 IN AI_AUTHORIZATION_ID VARCHAR(10)
 		)
BEGIN
 
 DECLARE V_KERBEROS_NAME VARCHAR(20);
 DECLARE V_FOR_USER VARCHAR(20);
 DECLARE V_SERVER_USER VARCHAR(20);
 DECLARE V_AUTHORIZATION_ID VARCHAR(10);
 DECLARE V_FUNCTION_ID INTEGER;
 DECLARE V_FUNCTION_NAME VARCHAR(50);
 DECLARE V_FUNCTION_CATEGORY VARCHAR(10);
 DECLARE V_QUALIFIER_TYPE VARCHAR(10);
 DECLARE V_QUALIFIER_CODE VARCHAR(20);
 DECLARE V_DO_FUNCTION VARCHAR(1);
 DECLARE V_GRANT_AND_VIEW VARCHAR(2);
 
 DECLARE V_QUALIFIER_ID INTEGER;
 DECLARE V_MODIFIED_BY VARCHAR(20);
 DECLARE V_MODIFIED_DATE DATETIME;
 DECLARE V_DESCEND VARCHAR(1);
 DECLARE V_EFFECTIVE_DATE DATETIME;
 DECLARE V_EXPIRATION_DATE DATETIME;
 
 DECLARE v_status integer;
 DECLARE v_error_no INTEGER;
 DECLARE v_error_msg VARCHAR(255);
 DECLARE v_msg_no INTEGER;
 DECLARE v_msg VARCHAR(255);
 DECLARE A_FUNCTION_NAME VARCHAR(50);
 DECLARE A_KERBEROS_NAME VARCHAR(20);
 DECLARE v_server_has_auth varchar(1);
 DECLARE v_proxy_has_auth varchar(1);
 DECLARE v_count INTEGER;
 DECLARE v_counter INTEGER;
 
 DECLARE EXIT HANDLER FOR NOT FOUND
    BEGIN
               if v_status = 3 then
                      SET v_msg_no = -20001;
                      SET v_msg = roles_msg(-20001);
               elseif v_status = 2 then
                      SET v_msg_no = -20017;
                      SET v_msg = roles_msg(-20017);
               else
                      SET v_msg_no = -20003;
                      SET v_msg = roles_msg(-20003);
               end if;
               CALL permit_signal( v_msg,v_msg_no);
    END;
 
    DECLARE EXIT HANDLER FOR 1022 
               CALL permit_signal( roles_msg(-20007),-20007);             

  
    SET v_for_user = upper(ai_for_user);
   if (ai_server_user is not null) then
     SET v_server_user = upper(ai_server_user);
   else
     SET v_server_user = upper(UC_USER_WITHOUT_HOST());
   end if;
 
   
   SET v_status = 1;  
   select auth_sf_check_number(ai_authorization_id) into v_count from dual;
   if (v_count <> 1) then
      CALL permit_signal(CONCAT('Authorization_id '''
        , ai_authorization_id
        , ''') is not a valid number.'),-20010);
   end if;
   SET v_authorization_id = CAST(ai_authorization_id AS UNSIGNED INTEGER);
 
   SET v_status = 2;  
   select count(*) into v_counter
          from authorization
          where authorization_id = v_authorization_id;
   if (v_counter < 1) then
      CALL permit_signal(-20011, CONCAT('Authoriziation_id '''
        , v_authorization_id
        , ''') is not a valid id.'),-20011);
   end if;
 
   SET v_status = 3;
   
   select function_id, function_name, function_category, qualifier_code,
          kerberos_name, do_function, grant_and_view,
          qualifier_id, modified_by, modified_date, descend,  
          effective_date, expiration_date                     
     into v_function_id, v_function_name, v_function_category, v_qualifier_code,
          v_kerberos_name, v_do_function, v_grant_and_view,
          v_qualifier_id, v_modified_by, v_modified_date, v_descend,  
          v_effective_date, v_expiration_date  
     from authorization
     where authorization_id = v_authorization_id;
 
  
   if (v_server_user <> UC_USER_WITHOUT_HOST()) then
      SELECT ROLESAPI_IS_USER_AUTHORIZED(UC_USER_WITHOUT_HOST(),
                                         'RUN ROLES SERVICE PROCEDURES',
                                         CONCAT('CAT' , trim(v_function_category)))
         INTO v_server_has_auth
         FROM DUAL;
      if v_server_has_auth <> 'Y' then
        SET v_error_no = roles_service_constant.err_20003_no;
        SET v_error_msg = '<server_id> has no authorization to be proxy for creating auths in category <function_category>';
       SET v_error_msg = replace(v_error_msg, '<server_id>',
                               UC_USER_WITHOUT_HOST());
        SET v_error_msg = replace(v_error_msg, '<function_category>',
                               v_function_category);
        CALL permit_signal( v_error_msg,v_error_no);
      end if;
   end if;
 
   
   if (v_server_user <> v_for_user) then
      SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user,
                                         'RUN ROLES SERVICE PROCEDURES',
                                         'CAT' , trim(v_function_category))
         INTO v_server_has_auth
         FROM DUAL;
   else   
     SET v_server_has_auth = 'Y';
   end if;
   if v_server_has_auth <> 'Y' then
     SET v_error_no = -20003;
        SET v_error_msg = '<server_id> has no authorization to be proxy for creating auths in category <function_category>';
     SET v_error_msg = replace(v_error_msg, '<server_id>',
                            v_server_user);
     SET v_error_msg = replace(v_error_msg, '<function_category>',
                            v_function_category);
     CALL permit_signal( v_error_msg,v_error_no);
   end if;
 
   
   if auth_sf_can_create_auth(v_for_user, V_FUNCTION_NAME, V_QUALIFIER_CODE,
 	V_DO_FUNCTION, V_GRANT_AND_VIEW) = 'N' then
      SET v_error_no = -20014;
      SET v_error_msg = CONCAT('User ''' , v_for_user
                    , ''' is not authorized to delete authorizations'
                    , ' for function '''
                    , v_function_name , ''' and qualifier '''
                    , v_qualifier_code , '''.');
      CALL permit_signal( v_error_msg,v_error_no);
   end if;
 
  
   
 	INSERT INTO auth_audit
 	(
    AUTH_AUDIT_ID,
    ACTION_TYPE,
 	 OLD_NEW,
 	 ACTION_DATE,
 	 ROLES_USERNAME,
 
 	 AUTHORIZATION_ID,
 	 FUNCTION_ID,
 	 QUALIFIER_ID,
 	 KERBEROS_NAME,
 	 QUALIFIER_CODE,
 	 FUNCTION_NAME,
 	 FUNCTION_CATEGORY,
 	 MODIFIED_BY,
 	 MODIFIED_DATE,
 	 DO_FUNCTION,
 	 GRANT_AND_VIEW,
 	 DESCEND,
 	 EFFECTIVE_DATE,
 	 EXPIRATION_DATE,
          SERVER_USERNAME)  
 
 	VALUES(
 next_sequence_val('audit_sequence'),
 	 'D',
 	 '<',
 	 NOW(),
 	 upper(ai_for_user),
 	 v_AUTHORIZATION_ID,
 	 v_FUNCTION_ID,
 	 v_QUALIFIER_ID,
 	 v_KERBEROS_NAME,
 	 v_QUALIFIER_CODE,
 	 v_FUNCTION_NAME,
 	 v_FUNCTION_CATEGORY,
 	 v_MODIFIED_BY,
 	 v_MODIFIED_DATE,
 	 v_DO_FUNCTION,
 	 v_GRANT_AND_VIEW,
 	 v_DESCEND,
 	 v_EFFECTIVE_DATE,
 	 v_EXPIRATION_DATE,
          UC_USER_WITHOUT_HOST() 	);   
 
   
 
   delete from authorization
     where authorization_id = AI_AUTHORIZATION_ID;
 
 end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`rolesapi_delete_imprule`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`rolesapi_delete_imprule`( IN AI_FOR_USER VARCHAR(20),
 		  IN AI_SERVER_USER VARCHAR(20),
 		  IN AI_RULE_ID  VARCHAR(10),
 		  OUT a_rule_id  VARCHAR(10)
 		)
BEGIN
 
 
 DECLARE v_error_no INTEGER;
 DECLARE v_error_msg VARCHAR(255);
 DECLARE v_function_category VARCHAR(4);
 DECLARE v_status integer;
 DECLARE v_count INTEGER  DEFAULT 0;
 DECLARE v_for_user VARCHAR(20);
 DECLARE v_server_user VARCHAR(20);
 DECLARE v_server_has_auth varchar(1);
 DECLARE v_proxy_has_auth varchar(1);
 

   select result_function_category into v_function_category 
   	from implied_auth_rule where rule_id=ai_rule_id;
   	
   SET v_for_user = upper(ai_for_user);
   if (ai_server_user is not null && trim(ai_server_user) != '') then
     SET v_server_user = upper(ai_server_user);
   else
     SET v_server_user = upper(UC_USER_WITHOUT_HOST());
   end if;
 
   if (v_server_user <> UC_USER_WITHOUT_HOST()) then
      SELECT ROLESAPI_IS_USER_AUTHORIZED(UC_USER_WITHOUT_HOST(),
                                         'RUN ROLES SERVICE PROCEDURES',
                                         CONCAT('CAT' , trim(v_function_category)))
         INTO v_server_has_auth
         FROM DUAL;
      if v_server_has_auth <> 'Y' then
        SET v_error_no = -20003;
        SET v_error_msg = '<server_id> has no authorization to be proxy for creating auths in category <function_category>';
        SET v_error_msg = replace(v_error_msg, '<server_id>',
                               UC_USER_WITHOUT_HOST());
        SET v_error_msg = replace(v_error_msg, '<function_category>',
                               v_function_category);
        CALL permit_signal( v_error_msg,v_error_no);
      end if;
   end if;

  
   if (v_server_user <> v_for_user) then
      SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user,
                                         'RUN ROLES SERVICE PROCEDURES',
                                         CONCAT('CAT' , trim(v_function_category)))
         INTO v_server_has_auth
         FROM DUAL;
   else   
   SET   v_server_has_auth = 'Y';
   end if;
   if v_server_has_auth <> 'Y' then
     SET v_error_no = -20003;
       SET v_error_msg = '<server_id> has no authorization to be proxy for creating auths in category <function_category>';
     SET v_error_msg = replace(v_error_msg, '<server_id>',
                            v_server_user);
     SET v_error_msg = replace(v_error_msg, '<function_category>',
                            v_function_category);
        CALL permit_signal( v_error_msg,v_error_no);
   end if;
 
 
 
 
 
 
   if auth_sf_can_create_rule(v_for_user, v_function_category) = 'N' then
      SET v_error_no = -20033;
      SET v_error_msg = CONCAT('User ''' , v_for_user
                    , ''' is not authorized to create an implied authorization rule'
                    , ' for function category'''
                    , v_function_category , '''.');
        CALL permit_signal( v_error_msg,v_error_no);
   end if;
 
 
 
   SET a_rule_id = ai_rule_id;

   delete from  implied_auth_rule
   where
   rule_id = ai_rule_id;
 

 END $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`rolesapi_is_user_authorized`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`rolesapi_is_user_authorized`(ai_kerberos_name varchar(20),ai_function_name varchar(255),ai_qualifier_code varchar(30)) RETURNS varchar(1) CHARSET latin1
BEGIN
 DECLARE a_kerberos_name VARCHAR(20);
 DECLARE  a_function_name varchar(255);
 DECLARE a_qualifier_code varchar(30) ;
 DECLARE v_count integer;
 DECLARE  v_qualifier_id INTEGER;
 
DECLARE EXIT HANDLER FOR NOT FOUND RETURN 'N';
DECLARE EXIT HANDLER FOR SQLEXCEPTION RETURN 'N';

   SET a_kerberos_name = upper(ai_kerberos_name);
   SET a_function_name = upper(ai_function_name);
   SET a_qualifier_code = upper(ai_qualifier_code);
   
   select count(*) into v_count from authorization
     where kerberos_name = a_kerberos_name
     and function_name = a_function_name
     and qualifier_code = a_qualifier_code
     and do_function = 'Y'
     and effective_date <= NOW()
     and (expiration_date is NULL OR NOW() <= expiration_date);
   IF v_count > 0 THEN
     RETURN 'Y';
   END IF;
   
   select qualifier_id into v_qualifier_id from qualifier
     where qualifier_code = a_qualifier_code
     and qualifier_type = (select qualifier_type from function where
     function_name = a_function_name);
   select count(*) into v_count
     from authorization
     where kerberos_name = a_kerberos_name
     and function_name = a_function_name
     and do_function = 'Y'
     and descend = 'Y'
     and effective_date <= NOW()
     and (expiration_date is NULL OR NOW() <= expiration_date )
     and qualifier_id in (select parent_id from qualifier_descendent
       where child_id = v_qualifier_id);
   IF v_count > 0 THEN
     RETURN 'Y';
   END IF;
   
   RETURN 'N';

END;

 $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`rolesapi_update_auth1`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`rolesapi_update_auth1`(IN AI_SERVER_USER VARCHAR(20),
                  IN AI_FOR_USER VARCHAR(20),
                  IN AI_AUTHORIZATION_ID  VARCHAR(20),
                  IN AI_FUNCTION_NAME VARCHAR(50),
  		 IN AI_QUALIFIER_CODE VARCHAR(20),
  		 IN AI_KERBEROS_NAME  VARCHAR(20),
  		 IN AI_DO_FUNCTION  VARCHAR(1),
  		 IN AI_GRANT_AND_VIEW  VARCHAR(2),
  		 IN AI_DESCEND VARCHAR(1),
  		 IN AI_EFFECTIVE_DATE VARCHAR(20),
  		 IN AI_EXPIRATION_DATE VARCHAR(20),
  		 OUT a_modified_by   VARCHAR(50),
  		 OUT a_modified_date VARCHAR(20)
  		)
BEGIN
  
  DECLARE V_KERBEROS_NAME VARCHAR(20);
  DECLARE V_FOR_USER VARCHAR(20);
  DECLARE V_SERVER_USER VARCHAR(20);
  DECLARE V_AUTHORIZATION_ID INTEGER;
  DECLARE V_QUALIFIER_ID INTEGER;
  DECLARE V_QUALIFIER_CODE VARCHAR(20);
  DECLARE V_OLD_QUALIFIER_CODE VARCHAR(20);
  DECLARE V_QUALIFIER_NAME VARCHAR(50);
  DECLARE V_QUALIFIER_TYPE VARCHAR(20);
  DECLARE V_FUNCTION_ID INTEGER;
  DECLARE V_FUNCTION_NAME VARCHAR(50);
  DECLARE V_OLD_FUNCTION_NAME VARCHAR(50);
  DECLARE V_FUNCTION_CATEGORY VARCHAR(10);
  DECLARE V_OLD_CATEGORY VARCHAR(10);
  
  DECLARE v_old_function_id INTEGER;
  DECLARE v_old_qualifier_id INTEGER;
  DECLARE v_old_kerberos_name VARCHAR(20);
  DECLARE v_old_function_category VARCHAR(10);
  DECLARE v_old_qualifier_name VARCHAR(50);
  DECLARE v_old_descend VARCHAR(1);
  DECLARE v_old_effective_date VARCHAR(20);
  DECLARE v_old_expiration_date VARCHAR(20);
  
  DECLARE v_status integer;
  DECLARE v_error_no INTEGER;
  DECLARE v_error_msg VARCHAR(255);
  DECLARE v_msg_no INTEGER;
  DECLARE v_msg VARCHAR(255);
  DECLARE A_FUNCTION_NAME VARCHAR(50);
  DECLARE A_QUALIFIER_CODE VARCHAR(20);
  DECLARE A_KERBEROS_NAME VARCHAR(20);
  DECLARE A_DO_FUNCTION VARCHAR(1);
  DECLARE V_OLD_DO_FUNCTION VARCHAR(1);
  DECLARE A_GRANT_AND_VIEW VARCHAR(2);
  DECLARE V_OLD_GRANT_AND_VIEW VARCHAR(2);
  DECLARE A_DESCEND VARCHAR(1);
  DECLARE A_EFFECTIVE_DATE VARCHAR(255);
  DECLARE A_EXPIRATION_DATE VARCHAR(255);
  DECLARE v_server_has_auth VARCHAR(1);
  DECLARE v_proxy_has_auth VARCHAR(1);
  DECLARE v_count INTEGER;
  
  DECLARE EXIT HANDLER FOR NOT FOUND
     BEGIN
                if v_status = 1 then
                       SET v_msg_no = -20001;
                       SET v_msg = CONCAT('Invalid function ''' , ai_function_name ,
                                ''' specified.');
                elseif v_status = 2 then
                       SET v_msg_no = -20017;
                       SET v_msg = roles_msg(-20017);
                elseif v_status = 3 then
                       SET v_msg_no = -20003;
                       SET v_msg = CONCAT('Invalid Kerberos_name ''' , ai_kerberos_name ,
                                ''' specified.');
                elseif v_status = 5 then
                       SET v_msg_no = -20010;
                       SET v_msg = roles_msg(-20010);
                else
                       SET v_msg_no = -20999;
                       SET v_msg = CONCAT('Internal program problem. Bad v_status_code'
                                , ' in procedure ROLESAPI_UPDATE_AUTH1.');
                end if;
                CALL permit_signal( v_msg,v_msg_no);
     END;
  
     DECLARE EXIT HANDLER FOR 1022 
                CALL permit_signal( roles_msg(-20007),-20007);
 
 
    SET v_for_user = upper(ai_for_user);
    if (ai_server_user is not null && trim(ai_server_user) != '') then
      SET v_server_user = upper(ai_server_user);
    else
      SET v_server_user = upper(user);
    end if;
    SET a_kerberos_name = upper(ai_kerberos_name);
    SET a_function_name = upper(ai_function_name);
    SET a_qualifier_code = upper(ai_qualifier_code);
    SET a_do_function = upper(ai_do_function);
    SET a_grant_and_view = upper(ai_grant_and_view);
    SET a_descend = upper(ai_descend);
    if (ai_effective_date is not null && trim(ai_effective_date) != '' ) then
      SET a_effective_date = ai_effective_date;
    else
      SET a_effective_date = DATE_FORMAT(trunc(NOW()), '%m%d%y');
    end if;
    if (ai_expiration_date is not null && trim(ai_expiration_date) != '' ) then
      SET a_expiration_date = ai_expiration_date;
    else
      SET a_expiration_date = '        ';
    end if;
  
    
    if (a_grant_and_view = 'Y ' or a_grant_and_view = 'Y'
		or a_grant_and_view = 'GD' or a_grant_and_view = 'G') then
	      SET a_grant_and_view = 'GD';
	    else
	      SET a_grant_and_view = 'N ';
    end if;
  
    
    select auth_sf_check_date_noslash(a_effective_date) into v_count from dual;
    if (v_count <> 1) then
       call permit_signal( CONCAT('Invalid effective date '''
         , ai_effective_date
         , ''' must be in mmddyyyy format.'), -20011);
    end if;
  
    
    if a_expiration_date <> '        ' then
      select auth_sf_check_date_noslash(a_expiration_date)
          into v_count from dual;
      if (v_count <> 1) then
         call permit_signal( CONCAT('Invalid expiration date '''
           , ai_expiration_date
           , ''' must be in mmddyyyy format.'), -20011);
      end if;
    end if;
  
    
    SET v_status = 4;  
    select auth_sf_check_number(ai_authorization_id) into v_count from dual;
    if (v_count <> 1) then
       call permit_signal( CONCAT('Authorization_id '''
         , ai_authorization_id
         , ''') is not a valid number.'),-20010);
    end if;
    SET v_authorization_id = CAST(ai_authorization_id AS UNSIGNED);
 
    SET v_status = 5;  
    select function_category, function_name, qualifier_code,
           do_function, grant_and_view,
            function_id, qualifier_id, kerberos_name,
            qualifier_name, descend,
            auth_sf_convert_date_to_str(effective_date),
            auth_sf_convert_date_to_str(expiration_date)
           into v_old_category, v_old_function_name, v_old_qualifier_code,
            v_old_do_function, v_old_grant_and_view,
            v_old_function_id, v_old_qualifier_id, v_old_kerberos_name,
            v_old_qualifier_name, v_old_descend,
            v_old_effective_date, v_old_expiration_date
           from authorization
           where authorization_id = v_authorization_id;
  
    SET v_status = 1;  
    select function_id, function_name, function_category, qualifier_type
      into v_function_id, v_function_name, v_function_category, v_qualifier_type
      from function
      where function_name = a_function_name;
 
    SET v_status = 2;  
    select qualifier_id, qualifier_code, qualifier_name
      into v_qualifier_id, v_qualifier_code, v_qualifier_name
      from qualifier where qualifier_code = a_qualifier_code
      and qualifier_type = v_qualifier_type;
  
    SET v_status = 3;  
    select kerberos_name into v_kerberos_name
      from person where kerberos_name = a_kerberos_name;
 
    
    if a_do_function not in ('Y', 'N') then
       call permit_signal( CONCAT('Do_function (''' , ai_do_function
         , ''') is not ''Y'' or ''N''.'),-20020);
    end if;
 
    
    if a_descend not in ('Y', 'N') then
       call permit_signal(CONCAT('DESCEND (''' , ai_descend
         , ''') is not ''Y'' or ''N''.'), -20021);
    end if;
 
    
    if (v_qualifier_type = 'DEPT'
        and substr(v_qualifier_code, 1, 2) <> 'D_') then
       call permit_signal(  'In auths. for this function, qualifier code must start with D_',-20015);
    end if;
  
    
    if (v_server_user <> user) then
       
       SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                          'RUN ROLES SERVICE PROCEDURES',
                                          CONCAT('CAT' , trim(v_old_category)))
          INTO v_server_has_auth
          FROM DUAL;
       if v_server_has_auth <> 'Y' then
 	       SET v_error_no = -20003;
 	       SET v_error_msg = '<server_id> has no authorization to be proxy for creating auths in category <function_category>';
 	       SET v_error_msg = replace(v_error_msg, '<server_id>',
 				      v_server_user);
 	       SET v_error_msg = replace(v_error_msg, '<function_category>',
 				      v_old_category);
 	       call permit_signal( v_error_msg,v_error_no);
       end if;
       
       if (v_old_category <> v_function_category) then
         SELECT ROLESAPI_IS_USER_AUTHORIZED(user,
                                            'RUN ROLES SERVICE PROCEDURES',
                                            CONCAT('CAT' , trim(v_function_category)))
            INTO v_server_has_auth
            FROM DUAL;
         if v_server_has_auth <> 'Y' then
 	       SET v_error_no = -20003;
 	       SET v_error_msg = '<server_id> has no authorization to be proxy for creating auths in category <function_category>';
 	       SET v_error_msg = replace(v_error_msg, '<server_id>',
 				      v_server_user);
 	       SET v_error_msg = replace(v_error_msg, '<function_category>',
 				      v_old_category);
 	       call permit_signal( v_error_msg,v_error_no);
         end if;
       end if;
    end if;
  
    
    if (v_server_user <> v_for_user) then
       SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user,
                                          'RUN ROLES SERVICE PROCEDURES',
                                          CONCAT('CAT' , trim(v_function_category)))
          INTO v_server_has_auth
          FROM DUAL;
    else  
      SET v_server_has_auth = 'Y';
    end if;
    if v_server_has_auth <> 'Y' then
        SET v_error_no = -20003;
        SET v_error_msg = '<server_id> has no authorization to be proxy for creating auths in category <function_category>';
        SET v_error_msg = replace(v_error_msg, '<server_id>',
                               v_server_user);
        SET v_error_msg = replace(v_error_msg, '<function_category>',
                               v_old_category);
        call permit_signal( v_error_msg,v_error_no);
    end if;
    
    if ( (v_server_user <> v_for_user)
         and (v_function_category <> v_old_category) )
    then
       SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user,
                                          'RUN ROLES SERVICE PROCEDURES',
                                          CONCAT('CAT' , trim(v_old_category)))
          INTO v_server_has_auth
          FROM DUAL;
      if (v_server_has_auth <> 'Y') then
        SET v_error_no = -20003;
        SET v_error_msg = '<server_id> has no authorization to be proxy for creating auths in category <function_category>';
        SET v_error_msg = replace(v_error_msg, '<server_id>',
                               v_server_user);
        SET v_error_msg = replace(v_error_msg, '<function_category>',
                               v_old_category);
        call permit_signal( v_error_msg,v_error_no);
      end if;
    end if;
  
    
    if (auth_sf_can_create_auth(v_for_user, AI_FUNCTION_NAME, AI_QUALIFIER_CODE,
  	AI_DO_FUNCTION, A_GRANT_AND_VIEW) = 'N') then
       SET v_error_no = -20014;
       SET v_error_msg = CONCAT('User ''' , v_for_user
                     , ''' is not authorized to update authorizations'
                     , ' for function '''
                     , ai_function_name , ''' and qualifier '''
                     , ai_qualifier_code , '''.');
       call permit_signal(v_error_msg, v_error_no);
    end if;
 
     
    if auth_sf_can_create_auth(v_for_user, V_OLD_FUNCTION_NAME,
          V_OLD_QUALIFIER_CODE,
  	V_OLD_DO_FUNCTION,V_OLD_GRANT_AND_VIEW) = 'N' then
       SET v_error_no = -20014;
       SET v_error_msg = CONCAT('User ''' , v_for_user
                     , ''' is not authorized to create authorizations'
                     , ' for function '''
                     , v_old_function_name , ''' and qualifier '''
                     , v_old_qualifier_code , '''.');
       call permit_signal( v_error_msg,v_error_no);
    end if;
 
       
    if not (v_old_function_id = v_function_id
        and v_old_qualifier_id = v_qualifier_id
        and v_old_kerberos_name = v_kerberos_name
        and v_old_function_name = v_function_name
        and v_old_function_category = v_function_category
        and v_old_qualifier_name = v_qualifier_name
        and v_old_do_function = a_do_function
        and v_old_grant_and_view = a_grant_and_view
        and v_old_descend = a_descend
        and v_old_effective_date = a_effective_date
        and trim(IFNULL(v_old_expiration_date,'        ')) = trim(a_expiration_date)
       ) then
      
      update authorization
          set function_id = v_function_id,
              qualifier_id = v_qualifier_id,
              kerberos_name = v_kerberos_name,
              qualifier_code = v_qualifier_code,
              function_name = v_function_name,
              function_category = v_function_category,
              qualifier_name = v_qualifier_name,
              modified_by = v_for_user,
              modified_date = NOW(),
              do_function = a_do_function,
              grant_and_view = a_grant_and_view,
              descend = a_descend,
              effective_date = auth_sf_convert_str_to_date(A_EFFECTIVE_DATE),
              expiration_date =
  		auth_sf_convert_str_to_date(A_EXPIRATION_DATE)
           where authorization_id = v_authorization_id;
     else
       call permit_signal('There are no changes to be made.',-20002);
     end if;
 
     SET a_modified_by = v_for_user;
     SET a_modified_date = NOW();
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`rolesapi_update_imprule`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`rolesapi_update_imprule`( IN AI_FOR_USER  VARCHAR(20),
 		  IN AI_SERVER_USER VARCHAR(30),
 		  IN AI_RULE_ID VARCHAR(10),
 		  IN AI_RULE_SHORT_NAME VARCHAR(60),
 		  IN AI_RULE_DESCRIPTION VARCHAR(2000),
 		  IN AI_RULE_IS_IN_EFFECT VARCHAR(1),
 		  OUT a_rule_id VARCHAR(10)
 		)
BEGIN

 DECLARE A_RULE_SHORT_NAME VARCHAR(60);
 DECLARE A_RULE_DESCRIPTION VARCHAR(2000);
 DECLARE A_RULE_IS_IN_EFFECT VARCHAR(1);

 DECLARE v_error_no INTEGER;
 DECLARE v_error_msg VARCHAR(255);
 DECLARE v_function_category VARCHAR(4);
 DECLARE v_status integer;
 DECLARE v_count INTEGER  DEFAULT 0;
 DECLARE v_for_user VARCHAR(20);
 DECLARE v_server_user VARCHAR(20);
 DECLARE v_server_has_auth varchar(1);
 DECLARE v_proxy_has_auth varchar(1);


   select result_function_category into v_function_category from implied_auth_rule where rule_id=ai_rule_id;
   SET v_for_user = upper(ai_for_user);
   if (ai_server_user is not null && TRIM(ai_server_user) != '') then
     SET v_server_user = upper(ai_server_user);
   else
     SET v_server_user = upper(UC_USER_WITHOUT_HOST());
   end if;
 
   SET a_rule_short_name = trim(ai_rule_short_name);
   SET a_rule_description = ai_rule_description;
   SET a_rule_is_in_effect = upper(ai_rule_is_in_effect);
 
 
   if (v_server_user <> UC_USER_WITHOUT_HOST()) then
      SELECT ROLESAPI_IS_USER_AUTHORIZED(UC_USER_WITHOUT_HOST(),
                                         'RUN ROLES SERVICE PROCEDURES',
                                         CONCAT('CAT' , trim(v_function_category)))
         INTO v_server_has_auth
         FROM DUAL;
      if v_server_has_auth <> 'Y' then
        SET v_error_no = -20003;
	SET v_error_msg = 'Error: <server_id> has no authorization to be proxy for creating auths in category <function_category>';
        SET v_error_msg = replace(v_error_msg, '<server_id>',
                               UC_USER_WITHOUT_HOST());
        SET v_error_msg = replace(v_error_msg, '<function_category>',
                               v_function_category);
        CALL permit_signal( v_error_msg,v_error_no);
      end if;
   end if;
 
    
   if (v_server_user <> v_for_user) then
      SELECT ROLESAPI_IS_USER_AUTHORIZED(v_server_user,
                                         'RUN ROLES SERVICE PROCEDURES',
                                         CONCAT('CAT' , trim(v_function_category)))
         INTO v_server_has_auth
         FROM DUAL;
   else   
     SET v_server_has_auth = 'Y';
   end if;
   if v_server_has_auth <> 'Y' then
     SET v_error_no = -20003;
     SET v_error_msg = 'Error: <server_id> has no authorization to be proxy for creating auths in category <function_category>';
     SET v_error_msg = replace(v_error_msg, '<server_id>',
                            v_server_user);
     SET v_error_msg = replace(v_error_msg, '<function_category>',
                            v_function_category);
     CALL permit_signal( v_error_msg,v_error_no);
   end if;

 
 
 
 
 
   if auth_sf_can_create_rule(v_for_user, v_function_category) = 'N' then
      SET v_error_no = -20033;
      SET v_error_msg = CONCAT('User ''' , v_for_user
                    , ''' is not authorized to create an implied authorization rule'
                    , ' for function category'''
                   , v_function_category , '''.');
     CALL permit_signal( v_error_msg,v_error_no);
   end if;
 
 
 
 
 
 
 if (ai_rule_is_in_effect not in ('Y','N')) then
    SET v_error_no = -20038;
    SET v_error_msg = CONCAT('Error: Invalid value for rule_is_in_effect ''','<rule_is_in_effect>',''' . The value should be Y or N.') ;
    SET v_error_msg = replace(v_error_msg,'<rule_is_in_effect>',ai_rule_is_in_effect);
    CALL permit_signal( v_error_msg,v_error_no);
 end if;
 
 
 
   SET a_rule_id = ai_rule_id;
 
   update implied_auth_rule
   set
   rule_short_name = a_rule_short_name,
   rule_description = a_rule_description,
   rule_is_in_effect = a_rule_is_in_effect,
   modified_by = v_for_user,
   modified_date =  NOW()
   where
   rule_id = a_rule_id;
 
 end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`show_test_results`$$
CREATE DEFINER=`rolesbb`@`localhost` PROCEDURE  `rolesbb`.`show_test_results`()
    READS SQL DATA
begin
    declare total_passed_tests int;
    declare total_failed_tests int;
    declare total_tests        int;
    set total_passed_tests = (select count(*) from _test_results where outcome  );
    set total_failed_tests = (select count(*) from _test_results where not outcome );
    set total_tests        =  (select count(*) from _test_results);
    select * from test_outcome;
    select total_tests as `total tests`,
           total_passed_tests as `passed`,
           total_failed_tests as `failed`,
           format(total_passed_tests / total_tests * 100,2) as `passed tests percentage` ;

    if (total_failed_tests) then
        select * from test_outcome where outcome like '%fail%';
    end if;
end $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`uc_user_without_host`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`uc_user_without_host`() RETURNS varchar(50) CHARSET latin1
begin

DECLARE a_user VARCHAR(100) DEFAULT '';
DECLARE idx INTEGER DEFAULT 0;

SET a_user = UPPER(USER());

SET  idx = LOCATE('@',a_user);

IF (idx != 0) THEN
  SET a_user = SUBSTRING(a_user,1,idx-1);
END IF;

RETURN a_user;
end;

 $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`update_parameter_value`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`update_parameter_value`(
    IN ai_parameter          VARCHAR(30),
    IN ai_value            VARCHAR(100),
    IN ai_for_user          VARCHAR(20),
    OUT ao_message          VARCHAR(255)
 )
BEGIN
    DECLARE v_check_auth           VARCHAR (2);
    DECLARE v_check_auth1          VARCHAR (2);
    DECLARE v_message              VARCHAR (255);
    DECLARE v_message_no           INTEGER;
    DECLARE v_length_value         INTEGER;
    DECLARE v_numeric              VARCHAR (1);
    DECLARE v_value                VARCHAR (100);
    DECLARE v_parameter            VARCHAR (30);
    DECLARE v_count                INTEGER;
    DECLARE p1 INTEGER DEFAULT  0;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
	       SET v_message = 'Unknown exception in update_parameter_value procedure';
	       SET v_message_no = -20099;
	       SET ao_message = CONCAT(v_message_no , ' ' , v_message);
	       call permit_signal(ao_message,v_message_no);

	END;

    SET v_check_auth =
       auth_sf_check_auth2 ('MAINTAIN PARAMETER VALUES',
                            'NULL',
                            ai_for_user,
                            'PROXY FOR ROLES ADMIN FUNC',
                            'NULL'
                           );
 
    IF v_check_auth = 'X' THEN
       SET v_message_no = -20102;
       SET ao_message =
           CONCAT(  'ORA'
          , v_message_no
          , ' '
          , 'database user '
          , ' '
          , UC_USER_WITHOUT_HOST()
          , ' '
          , 'is not authorized to act as a proxy for other users.');
          call permit_signal(ao_message,v_message_no);
    ELSEIF v_check_auth = 'N'  THEN
          SET v_check_auth1= auth_sf_check_auth2 ('MAINTAIN ALL PARAMETER DATA',
                            'NULL',
                            ai_for_user,
                            'PROXY FOR ROLES ADMIN FUNC',
                            'NULL'
                           );
 
       	IF  v_check_auth1 = 'N' THEN
	       SET v_message_no = -20101;
	       SET ao_message =
		   CONCAT(  'ORA'
		  , v_message_no
		  , ' '
		  , ''''
		  , ai_for_user
		  , '''Not authorized to Maintain Parameter Value');
		  call permit_signal(ao_message,v_message_no);
       END IF;
    END IF;
 
    SELECT COUNT(parameter)
      INTO v_count
      FROM roles_parameters
     WHERE parameter = ai_parameter;
 
 
    IF v_count = 0
    THEN
	       SET v_message_no = -20105;
	       SET ao_message =
		   CONCAT(  'ORA'
		  , v_message_no
		  , ' '
		  , 'Parameter Code = '''
		  , ai_parameter
		  , ''' Does not exist');
		  call permit_signal(ao_message,v_message_no);
    END IF;
 
    SELECT VALUE, parameter, is_number
      INTO v_value, v_parameter, v_numeric
      FROM roles_parameters
     WHERE parameter = ai_parameter;
 
    IF ai_value IS NULL
    THEN
	       SET v_message_no = -20104;
	       SET ao_message =
		   CONCAT(  'ORA'
		  , v_message_no
		  , ' '
		  ,	'Parameter Value Cannot be Null.');
		call permit_signal(ao_message,v_message_no);
    END IF;
 
    SET v_length_value = LENGTH (ai_value);
 
    IF v_value = ai_value
    THEN
	       SET v_message_no = -20105;
	       SET ao_message =
		   CONCAT(  'ORA'
	          , v_message_no
		  , ' '
		  , 'Record with Parameter Code = '''
		  , ai_parameter
		  , ''' has not been changed because Parameter Value field is the same');
		call permit_signal(ao_message,v_message_no);
    END IF;
 
 
    IF v_numeric = 'Y' THEN
    
    	SET p1 = 1;
       label1: LOOP
       
       
          IF SUBSTR (ai_value, i, 1) < '0' OR SUBSTR (ai_value, i, 1) > '9'
          THEN
	       SET v_message_no = -20105;
	       SET ao_message =
		   CONCAT(  'ORA'
		  , v_message_no
		  , ' '
		  , 'Parameter Value  '''
		  , ai_value
		  , ''' is not numeric.');
		call permit_signal(ao_message,v_message_no);
          END IF;
          SET p1 = p1 +1;
        IF (p1 <= v_length_value) THEN ITERATE label1; END IF;
        LEAVE label1;
       END LOOP label1;
    END IF;
 
   
       UPDATE rolesbb.rdb_t_roles_parameters
          SET VALUE = ai_value,
              update_user = ai_for_user,             
              update_timestamp = NOW()
        WHERE parameter = ai_parameter;

       SET ao_message =
           CONCAT(  'Parameter Value for Parameter_code = '
          , ai_parameter
          , ' has been updated');
    

 
 END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `rolesbb`.`update_roles_parameters_all`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `rolesbb`.`update_roles_parameters_all`(
    IN  ai_parameter            VARCHAR(20),
    IN  ai_value                  VARCHAR(100),
    IN  ai_description            VARCHAR(100),
    IN  ai_default_value          VARCHAR(100),
    IN  ai_is_number              VARCHAR(10),
    IN  ai_for_user               VARCHAR(20),
    OUT  ao_message               VARCHAR(255)
 )
BEGIN
    DECLARE v_check_auth                    VARCHAR (2);
    DECLARE v_message                       VARCHAR (255);
    DECLARE v_message_no                    INTEGER;
    DECLARE v_length_value                  INTEGER;
    DECLARE v_length_default_value          INTEGER;
    DECLARE v_numeric                       VARCHAR (1);
    DECLARE v_num_default_value             VARCHAR (1);
    DECLARE v_value                         VARCHAR (100);
    DECLARE v_parameter                     VARCHAR (30);
    DECLARE v_default_value                 VARCHAR (100);
    DECLARE v_desc                          VARCHAR (100);
    DECLARE v_is_number                     VARCHAR (1);
    DECLARE v_count                         INTEGER;

    DECLARE p1                         INTEGER DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    
          SET v_message = 'Unknown exception in update_roles_parameters_all';
          SET v_message_no = -20099;
          SET ao_message = CONCAT(v_message_no , ' ' , v_message);
          call permit_signal(ao_message,v_message_no);

    END;

    SET v_check_auth =
       auth_sf_check_auth2 ('MAINTAIN ALL PARAMETER DATA',
                            'NULL',
                            ai_for_user,
                            'PROXY FOR ROLES ADMIN FUNC',
                            'NULL'
                           );
 
    IF v_check_auth = 'X'
    THEN
       SET v_message_no = -20102;
       SET ao_message =
          CONCAT(
          'ORA'
          , v_message_no
          , ' '
          , 'database user '
          , ' '
          , UC_USER_WITHOUT_HOST()
          , ' '
          , 'is not authorized to act as a proxy for other users.');
          call permit_signal(ao_message,v_message_no);
    ELSEIF v_check_auth = 'N'
       THEN
       SET v_message_no = -20101;
       SET ao_message =
          CONCAT(
           'ORA'
          , v_message_no
          , ' '          , ''''
          , ai_for_user
          , '''Not authorized to MAINTAIN ALL PARAMETER DATA');
          call permit_signal(ao_message,v_message_no);
    END IF;
 
    
    SELECT COUNT(*)
      INTO v_count
      FROM roles_parameters
     WHERE parameter = ai_parameter;
 
    IF v_count = 0
    THEN
       SET v_message_no = -20110;
       SET ao_message =
          CONCAT(   'ORA'
          , v_message_no
          , ' '
          ,  'Parameter Code = '''
          , ai_parameter
          , ''' Does not exist');
          call permit_signal(ao_message,v_message_no);
    END IF;
 
    SELECT parameter, value, description, DEFAULT_VALUE, is_number
      INTO v_parameter, v_value, v_desc, v_default_value, v_numeric
      FROM roles_parameters
     WHERE parameter = ai_parameter;
 
    IF  (   v_value = ai_value
       AND v_desc = ai_description
       AND v_default_value = ai_default_value
       AND v_numeric = ai_is_number
       AND v_parameter = ai_parameter)
    THEN
       SET v_message_no = -20104;
       SET ao_message = CONCAT(
             'ORA'
          , v_message_no
          , ' '
          , 'Record with Parameter = '''
          , ai_parameter
          , ''' has not been changed because all fileds are the same');
          call permit_signal(ao_message,v_message_no);
    END IF;

    IF ( ai_value IS NULL or trim(ai_value) = '')
    THEN
       SET v_message_no = -20109;
       SET ao_message =
          CONCAT(   
          'ORA'
          , v_message_no
          , ' ' 
          ,             ' Parameter Value Cannot be Null.');
         call permit_signal(ao_message,v_message_no);
    END IF;
 
    SET v_length_value = LENGTH (ai_value);
 
    IF ai_default_value IS NULL
    THEN
       SET v_message_no = -20107;
       SET ao_message =
          CONCAT(   
          'ORA'
          , v_message_no
          , ' ' 
          , 'Default Value Parameter Cannot be null.');
         call permit_signal(ao_message,v_message_no);
    END IF;
 
    SET v_length_default_value = LENGTH (ai_default_value);
 
    IF (ai_is_number IS NULL or trim(ai_is_number) = '')
    THEN
       SET v_message_no = -20108;
       SET ao_message =
           CONCAT(   'ORA'
          , v_message_no
          , ' '        
          ,          'Field  is_number is null.');
         call permit_signal(ao_message,v_message_no);
    END IF;
 
    IF ai_is_number = 'Y'
    THEN
        SET p1 = 1;
         label1: LOOP

          IF (SUBSTR (ai_value, i, 1) < '0' OR SUBSTR (ai_value, i, 1) > '9')
          THEN
           SET v_message_no = -20103;
           SET ao_message =
              CONCAT(   'ORA'
              , v_message_no
              , ' '
              , 'Value Parameter '''
              , ai_value
              , ''' is not numeric.');
             call permit_signal(ao_message,v_message_no);
          END IF;
          SET p1 = p1 +1;
        IF (p1 <= v_length_value) THEN ITERATE label1; END IF;
        LEAVE label1;
       END LOOP label1;


        SET p1 = 1;
         label2: LOOP
          
          SET p1 = p1 +1;
          
             IF (   SUBSTR (ai_default_value, i, 1) < '0'
                OR SUBSTR (ai_default_value, i, 1) > '9')
             THEN
        	       SET v_message_no = -20106;
	               SET ao_message =
		                 CONCAT(  'ORA'
		                    , v_message_no
		                    , ' '
		                    , 'DEFAULT Value Parameter '''
		                    , ai_default_value
		                    , ''' is not numeric.');
		              call permit_signal(ao_message,v_message_no);
             END IF;
            SET p1 = p1 +1;
            IF (p1 <= v_length_value) THEN ITERATE label2; END IF;
            LEAVE label2;
         END LOOP label2;

       ELSEIF (ai_description IS NULL OR trim (ai_description) = '')
          THEN
    	       SET v_message_no = -20105;
    	       SET ao_message =CONCAT(   'ORA'
    		  , v_message_no
    		  , ' '
	    	  , 'Value Parameter Description  Cannot be null.');
		      call permit_signal(ao_message,v_message_no);

        END IF;

    UPDATE rdb_t_roles_parameters
       SET VALUE = ai_value,
           description = ai_description,
           DEFAULT_VALUE = ai_default_value,
           is_number = ai_is_number,
           update_user = ai_for_user,
           update_timestamp = NOW()
     WHERE parameter = ai_parameter;
 
    SET ao_message =
          CONCAT('ROLES_PARAMETERS record with PARAMETER = '
       , ai_parameter
       , ' has been updated');
 
  
 END $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `rolesbb`.`uppercase`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `rolesbb`.`uppercase`(str varchar(255)) RETURNS varchar(255) CHARSET latin1
BEGIN
  return concat(upper(left(str,1)),lower(right(str,length(str)-1)));
end;

 $$

DELIMITER ;