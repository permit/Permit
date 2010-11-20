-- ----------------------------------------------------------------------
-- MySQL Migration Toolkit
-- SQL Create Script
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
-- ----------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS `rolesbb`
  CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `rolesbb`;
-- -------------------------------------
-- Views


     CREATE OR REPLACE VIEW QUALIFIER_TYPE                 AS SELECT * FROM RDB_T_QUALIFIER_TYPE;
        CREATE OR REPLACE VIEW ROLES_USERS                    AS SELECT * FROM RDB_T_ROLES_USERS;
        CREATE OR REPLACE VIEW SCREEN                         AS SELECT * FROM RDB_T_SCREEN;
        CREATE OR REPLACE VIEW QUALIFIER_CHILD                AS SELECT * FROM RDB_T_QUALIFIER_CHILD;
        CREATE OR REPLACE VIEW SPECIAL_USERNAME               AS SELECT * FROM RDB_T_SPECIAL_USERNAME;
        CREATE OR REPLACE VIEW APPLICATION_VERSION            AS SELECT * FROM RDB_T_APPLICATION_VERSION;
        CREATE OR REPLACE VIEW QUALIFIER_DESCENDENT           AS SELECT * FROM RDB_T_QUALIFIER_DESCENDENT;
        CREATE OR REPLACE VIEW SELECTION_SET                  AS SELECT * FROM RDB_T_SELECTION_SET;
      
        CREATE OR REPLACE VIEW EXTRACT_CATEGORY               AS SELECT * FROM RDB_T_EXTRACT_CATEGORY;
         CREATE OR REPLACE VIEW FUNCTION                       AS SELECT * FROM RDB_T_FUNCTION;
        CREATE OR REPLACE VIEW FUNCTION_CHILD                 AS SELECT * FROM RDB_T_FUNCTION_CHILD;
      
        CREATE OR REPLACE VIEW HIDE_DEFAULT                   AS SELECT * FROM RDB_T_HIDE_DEFAULT;
        CREATE OR REPLACE VIEW PRIMARY_AUTH_DESCENDENT        AS SELECT * FROM RDB_T_PRIMARY_AUTH_DESCENDENT;
        CREATE OR REPLACE VIEW QUALIFIER                      AS SELECT * FROM RDB_T_QUALIFIER;
        CREATE OR REPLACE VIEW ERROR_KLUGE                    AS SELECT * FROM RDB_T_ERROR_KLUGE;
       CREATE OR REPLACE VIEW  PERSON_TYPE                    AS SELECT * FROM RDB_T_PERSON_TYPE;
       CREATE OR REPLACE VIEW  AUTHORIZATION                  AS SELECT * FROM RDB_T_AUTHORIZATION;
       CREATE OR REPLACE VIEW  CRITERIA_INSTANCE              AS SELECT * FROM RDB_T_CRITERIA_INSTANCE;
       CREATE OR REPLACE VIEW  AUTH_AUDIT                     AS SELECT * FROM RDB_T_AUTH_AUDIT;
      
       CREATE OR REPLACE VIEW  CATEGORY                       AS SELECT * FROM RDB_T_CATEGORY;
       CREATE OR REPLACE VIEW  CRITERIA                       AS SELECT * FROM RDB_T_CRITERIA;
       CREATE OR REPLACE VIEW  DEPT_APPROVER_FUNCTION         AS SELECT * FROM RDB_T_DEPT_APPROVER_FUNCTION;
      
       CREATE OR REPLACE VIEW  WH_COST_COLLECTOR              AS SELECT * FROM RDB_T_WH_COST_COLLECTOR;
       CREATE OR REPLACE VIEW  CONNECT_LOG                    AS SELECT * FROM RDB_T_CONNECT_LOG;
       CREATE OR REPLACE VIEW  PERSON_HISTORY                 AS SELECT * FROM RDB_T_PERSON_HISTORY;
       CREATE OR REPLACE VIEW  PA_GROUP                       AS SELECT * FROM RDB_T_PA_GROUP;
       CREATE OR REPLACE VIEW  EXTERNAL_FUNCTION              AS SELECT * FROM RDB_T_EXTERNAL_FUNCTION;
        CREATE OR REPLACE VIEW  EXTERNAL_AUTH                  AS SELECT * FROM RDB_T_EXTERNAL_AUTH;
        CREATE OR REPLACE VIEW SELECTION_SET2                 AS SELECT * FROM RDB_T_SELECTION_SET2;
        CREATE OR REPLACE VIEW SUPPRESSED_QUALNAME            AS SELECT * FROM RDB_T_SUPPRESSED_QUALNAME;
        CREATE OR REPLACE VIEW ACCESS_TO_QUALNAME             AS SELECT * FROM RDB_T_ACCESS_TO_QUALNAME;
        CREATE OR REPLACE VIEW CRITERIA2                      AS SELECT * FROM RDB_T_CRITERIA2;
      
      
        CREATE OR REPLACE VIEW SCREEN2                        AS SELECT * FROM RDB_T_SCREEN2;
       CREATE OR REPLACE VIEW  USER_SELECTION_SET2            AS SELECT * FROM RDB_T_USER_SELECTION_SET2;
	CREATE OR REPLACE VIEW  USER_SELECTION_CRITERIA2       AS SELECT * FROM RDB_T_USER_SEL_CRITERIA2;
        CREATE OR REPLACE VIEW  SPECIAL_SELECTION_SET2         AS SELECT * FROM RDB_T_SPECIAL_SEL_SET2;
        CREATE OR REPLACE VIEW SELECTION_CRITERIA2            AS SELECT * FROM RDB_T_SELECTION_CRITERIA2;
	CREATE OR REPLACE VIEW USER_SEL_CRITERIA2             AS SELECT * FROM RDB_T_USER_SEL_CRITERIA2;
	CREATE OR REPLACE VIEW AUTH_RULE_TYPE                 AS SELECT * FROM RDB_T_AUTH_RULE_TYPE;
	CREATE OR REPLACE VIEW PERSON                        AS SELECT * FROM RDB_T_PERSON;
	
	    CREATE OR REPLACE VIEW FUNCTION_GROUP                 AS SELECT * FROM RDB_T_FUNCTION_GROUP;
	    CREATE OR REPLACE VIEW FUNCTION_GROUP_LINK            AS SELECT * FROM RDB_T_FUNCTION_GROUP_LINK;
	   CREATE OR REPLACE VIEW  QUALIFIER_SUBTYPE              AS SELECT * FROM RDB_T_QUALIFIER_SUBTYPE;
	   CREATE OR REPLACE VIEW  IMPLIED_AUTH_RULE              AS SELECT * FROM RDB_T_IMPLIED_AUTH_RULE;
	    CREATE OR REPLACE VIEW FUNCTION_LOAD_PASS             AS SELECT * FROM RDB_T_FUNCTION_LOAD_PASS;
  CREATE OR REPLACE VIEW SUBTYPE_DESCENDENT_SUBTYPE     AS SELECT * FROM RDB_T_SUBT_DESCENDENT_SUBT ;


 CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_authorizable_function` (FUNCTION_ID) AS
 select distinct function_id from function
     where exists
     (select kerberos_name from authorization
     where function_category = 'META'
     and function_name = 'CREATE AUTHORIZATIONS'
     and kerberos_name = CURRENT_USER()
     and qualifier_code = 'CATALL'
     and effective_date <= NOW()
     and IFNULL(expiration_date,NOW()) >= NOW())
   union
   select distinct function_id from function
     where function_category in
     (select rpad(substr(qualifier_code,4),4,' ') from authorization
     where function_category = 'META'
     and function_name = 'CREATE AUTHORIZATIONS'
     and kerberos_name = CURRENT_USER()
     and effective_date <= NOW()
     and IFNULL(expiration_date,NOW()) >= NOW())
   --union
   --select f.function_id from function f
   --  where f.primary_authorizable = 'Y'
   --  and exists (select a.authorization_id from authorization a
   --  where a.kerberos_name = CURRENT_USER()
   --  and a.function_name = 'PRIMARY AUTHORIZOR'
   --  and a.effective_date <= NOW()
   --  and IFNULL(a.expiration_date,NOW()) >= NOW()
   --  and a.do_function = 'Y')
   --union
   --select /*+ ORDERED */ f.function_id
   --  from authorization a, dept_approver_function d, function f
   --  where a.kerberos_name = CURRENT_USER()
   --  and a.function_name = 'PRIMARY AUTHORIZOR'
   --  and a.effective_date <= NOW()
   --  and IFNULL(a.expiration_date,NOW()) >= NOW()
   --  and a.do_function = 'Y'
   --  and d.dept_code = a.qualifier_code
   --  and f.function_id = d.function_id
   union
   select f.function_id from function f
     where f.primary_authorizable = 'Y'
     and exists (select a.authorization_id from authorization a
     where a.kerberos_name = CURRENT_USER()
     and a.function_name = 'PRIMARY AUTHORIZOR'
     and a.effective_date <= NOW()
     and IFNULL(a.expiration_date,NOW()) >= NOW()
     and a.do_function = 'Y')
   union
   select /*+ ORDERED */ f.function_id
     from authorization a, dept_approver_function d, function f
     where a.kerberos_name = CURRENT_USER()
     and a.function_name = 'PRIMARY AUTHORIZOR'
     and a.effective_date <= NOW()
     and IFNULL(a.expiration_date,NOW()) >= NOW()
     and a.do_function = 'Y'
     and d.dept_code = a.qualifier_code
     and f.function_id = d.function_id
   union
   select f2.function_id
     from authorization a, function f1, function f2
     where f1.function_name = a.function_name
           and f1.IS_PRIMARY_AUTH_PARENT = 'Y'
 	  and a.kerberos_name = CURRENT_USER()
           and a.do_function = 'Y'
           and NOW()
               between a.effective_date and IFNULL(a.expiration_date,NOW())
           and f2.primary_authorizable = 'Y'
           and f2.primary_auth_group = f1.primary_auth_group
   union
   select f2.function_id
     from authorization a, dept_approver_function d, function f1, function f2
     where f1.function_name = a.function_name
     and f1.IS_PRIMARY_AUTH_PARENT = 'Y'
     and a.kerberos_name = CURRENT_USER()
     and a.effective_date <= NOW()
     and IFNULL(a.expiration_date,NOW()) >= NOW()
     and a.do_function = 'Y'
     and f2.primary_auth_group = f1.primary_auth_group
     and d.dept_code = a.qualifier_code
     and f2.function_id = d.function_id
   union
   select distinct function_id from authorization where
     kerberos_name = CURRENT_USER() and grant_and_view in ('GV','GD')
     and effective_date <= NOW()
    and IFNULL(expiration_date,NOW()) >= NOW();
    


    CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_authorization2` (AUTHORIZATION_ID, FUNCTION_ID, QUALIFIER_ID, KERBEROS_NAME, QUALIFIER_CODE, FUNCTION_NAME, FUNCTION_CATEGORY, QUALIFIER_NAME, MODIFIED_BY, MODIFIED_DATE, DO_FUNCTION, GRANT_AND_VIEW, DESCEND, EFFECTIVE_DATE, EXPIRATION_DATE, AUTH_TYPE) AS
    select authorization_id, function_id, qualifier_id,
                   kerberos_name,
                   qualifier_code, function_name, function_category,
                   qualifier_name, modified_by, modified_date, do_function,
                   grant_and_view, descend, effective_date, expiration_date,
                   'R' auth_type
            from rdb_t_authorization
            union all select authorization_id, function_id, qualifier_id,
                   kerberos_name,
                   qualifier_code, function_name, function_category,
                   qualifier_name, modified_by, modified_date, do_function,
                   grant_and_view, descend, effective_date, expiration_date,
                   'E' auth_type
        from rdb_t_external_auth;
        
        CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_auth_in_qualbranch` AS
	select
	 A.AUTHORIZATION_ID, A.FUNCTION_ID, A.QUALIFIER_ID,  A.KERBEROS_NAME,
	  A.QUALIFIER_CODE, A.FUNCTION_NAME, A.FUNCTION_CATEGORY, Q.QUALIFIER_NAME,
	  A.MODIFIED_BY, A.MODIFIED_DATE, A.DO_FUNCTION, A.GRANT_AND_VIEW, A.DESCEND,
	  A.EFFECTIVE_DATE, A.EXPIRATION_DATE, Q.QUALIFIER_CODE dept_qual_code,
	  Q.QUALIFIER_TYPE
	 from authorization a, qualifier q
	 where a.qualifier_id = q.qualifier_id
	union
	 select
	 A.AUTHORIZATION_ID, A.FUNCTION_ID, A.QUALIFIER_ID,  A.KERBEROS_NAME,
	  A.QUALIFIER_CODE, A.FUNCTION_NAME, A.FUNCTION_CATEGORY, Q.QUALIFIER_NAME,
	  A.MODIFIED_BY, A.MODIFIED_DATE, A.DO_FUNCTION, A.GRANT_AND_VIEW, A.DESCEND,
	  A.EFFECTIVE_DATE, A.EXPIRATION_DATE, Q.QUALIFIER_CODE dept_qual_code,
	  Q.QUALIFIER_TYPE
	 from authorization a, qualifier_descendent qd, qualifier q
	 where a.descend = 'Y'
	 and a.qualifier_id = qd.child_id
 and qd.parent_id = q.qualifier_id;


CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_auth_in_qualbranch` AS
select
 A.AUTHORIZATION_ID, A.FUNCTION_ID, A.QUALIFIER_ID,  A.KERBEROS_NAME,
  A.QUALIFIER_CODE, A.FUNCTION_NAME, A.FUNCTION_CATEGORY, Q.QUALIFIER_NAME,
  A.MODIFIED_BY, A.MODIFIED_DATE, A.DO_FUNCTION, A.GRANT_AND_VIEW, A.DESCEND,
  A.EFFECTIVE_DATE, A.EXPIRATION_DATE, Q.QUALIFIER_CODE dept_qual_code,
  Q.QUALIFIER_TYPE
 from authorization a, qualifier q
 where a.qualifier_id = q.qualifier_id
union
 select
 A.AUTHORIZATION_ID, A.FUNCTION_ID, A.QUALIFIER_ID,  A.KERBEROS_NAME,
  A.QUALIFIER_CODE, A.FUNCTION_NAME, A.FUNCTION_CATEGORY, Q.QUALIFIER_NAME,
  A.MODIFIED_BY, A.MODIFIED_DATE, A.DO_FUNCTION, A.GRANT_AND_VIEW, A.DESCEND,
  A.EFFECTIVE_DATE, A.EXPIRATION_DATE, Q.QUALIFIER_CODE dept_qual_code,
  Q.QUALIFIER_TYPE
 from authorization a, qualifier_descendent qd, qualifier q
 where a.descend = 'Y'
 and a.qualifier_id = qd.child_id
 and qd.parent_id = q.qualifier_id;



 CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_dept_people` AS
 select p.kerberos_name, q1.qualifier_code over_dept_code
  from person p, qualifier q1, qualifier_descendent qd, qualifier q2
  where p.dept_code = q2.qualifier_code
  and q1.qualifier_id = qd.parent_id
  and qd.child_id = q2.qualifier_id
  and q1.qualifier_type = 'ORGU'
 union
select p.kerberos_name, p.dept_code over_dept_code from person p;


CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_dept_sap_auth` AS
select a.kerberos_name, a.function_id, a.function_name, a.qualifier_id, a.qualifier_code, a.descend, a.grant_and_view, a.expiration_date, a.effective_date, q.qualifier_code dept_fc_code
from authorization a, qualifier q, qualifier_descendent qd
where a.function_category = 'SAP'
and a.function_name = 'CAN SPEND OR COMMIT FUNDS'
and a.qualifier_id = qd.child_id
and qd.parent_id = q.qualifier_id
and q.qualifier_type = 'FUND'
union
select a.kerberos_name, a.function_id, a.function_name, a.qualifier_id, a.qualifier_code, a.descend, a.grant_and_view, a.expiration_date, a.effective_date, a.qualifier_code dept_fc_code
from authorization a
where a.function_category = 'SAP'
and a.function_name = 'CAN SPEND OR COMMIT FUNDS';   



CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_dept_sap_auth2` AS
select a.kerberos_name, a.function_id, a.function_name, a.qualifier_id,
   a.qualifier_code, a.descend, a.grant_and_view, a.expiration_date,
   a.effective_date, q.qualifier_code dept_sg_code
 from authorization a, qualifier q, qualifier_descendent qd
 where a.function_category = 'SAP'
 and a.function_name like  '%APPROVER%'
 and a.qualifier_id = qd.child_id
 and qd.parent_id = q.qualifier_id
 and q.qualifier_type = 'SPGP'
 union
 select a.kerberos_name, a.function_id, a.function_name, a.qualifier_id,
   a.qualifier_code, a.descend, a.grant_and_view, a.expiration_date,
   a.effective_date, a.qualifier_code dept_sg_code
 from authorization a
 where a.function_category = 'SAP'
 and a.function_name like '%APPROVER%';
 



 CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_expanded_auth2` AS
 select a.authorization_id, a.function_id, a.qualifier_id, a.kerberos_name,
         q0.qualifier_code, a.function_name, a.function_category,
         q0.qualifier_name, a.modified_by, a.modified_date, a.do_function,
         a.grant_and_view, a.descend, a.effective_date, a.expiration_date,
         q0.qualifier_type, 'R' virtual_or_real
   from rolesbb.rdb_t_authorization a, rolesbb.rdb_t_qualifier q0
   where q0.qualifier_id = a.qualifier_id
  union
  select a.authorization_id, a.function_id, q.qualifier_id, a.kerberos_name,
         q.qualifier_code, a.function_name, a.function_category,
         q.qualifier_name, a.modified_by, a.modified_date, a.do_function,
         a.grant_and_view, a.descend, a.effective_date, a.expiration_date,
         q0.qualifier_type, 'V' virtual_or_real
   from rolesbb.rdb_t_authorization a, rolesbb.rdb_t_qualifier q0,
     rolesbb.rdb_t_qualifier_descendent qd,
     rolesbb.rdb_t_qualifier q
   where q0.qualifier_id = a.qualifier_id
   and q0.qualifier_level <> 1
   and qd.parent_id = a.qualifier_id
   and a.descend='Y'
  and q.qualifier_id = qd.child_id;
  


CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_expanded_authorization` AS
select a.kerberos_name, a.function_id, a.function_name, q.qualifier_code
  from rolesbb.rdb_t_authorization a, rolesbb.rdb_t_qualifier q,
       rolesbb.rdb_t_extract_category e
  where a.function_category = e.function_category
  and e.username=CURRENT_USER()
  /* where a.function_category = (select function_category from */
  /*  extract_category where username=CURRENT_USER()) */
  and a.qualifier_id=q.qualifier_id
  and a.descend='Y'
  and a.do_function='Y'
  and NOW() between a.effective_date and IFNULL(expiration_date,NOW())
  and q.has_child='N'
 union
 select
  a.kerberos_name, a.function_id, a.function_name, q.qualifier_code
  from rolesbb.rdb_t_authorization a, rolesbb.rdb_t_qualifier_descendent qd,
    rolesbb.rdb_t_qualifier q, rolesbb.rdb_t_extract_category e
  where a.function_category = e.function_category
  and e.username=CURRENT_USER()
  /* where a.function_category (select function_category from */
  /*  extract_category where username=CURRENT_USER()) */
  and a.qualifier_id=qd.parent_id
  and a.descend='Y'
  and a.do_function='Y'
  and NOW() between a.effective_date and IFNULL(expiration_date,NOW())
  and qd.child_id=q.qualifier_id
  and q.has_child='N';
  


 CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_expanded_auth_func_qual` AS
 select
    a.AUTHORIZATION_ID, a.FUNCTION_ID, a.QUALIFIER_ID, a.KERBEROS_NAME,
    q.QUALIFIER_CODE, a.FUNCTION_NAME, a.FUNCTION_CATEGORY, q.QUALIFIER_NAME,
    q.QUALIFIER_TYPE,
    a.MODIFIED_BY, a. MODIFIED_DATE, a.DO_FUNCTION, a.GRANT_AND_VIEW,
    a.DESCEND, a.EFFECTIVE_DATE, a.EXPIRATION_DATE,
    a.AUTHORIZATION_ID parent_auth_id, a.FUNCTION_ID parent_func_id,
    a.QUALIFIER_ID parent_qual_id,
    q.QUALIFIER_CODE parent_qual_code, a.FUNCTION_NAME parent_function_name,
    q.QUALIFIER_NAME parent_qual_name,
    ELT(sign(NOW()-a.effective_date), -1, 'N',
            ELT(sign(IFNULL(a.expiration_date,NOW())-NOW()), -1, 'N',
                   do_function)) is_in_effect
  from authorization a, qualifier q
    where q.qualifier_id = a.qualifier_id
  union select
    a.AUTHORIZATION_ID, a.FUNCTION_ID, q.QUALIFIER_ID, a.KERBEROS_NAME,
    q.QUALIFIER_CODE, a.FUNCTION_NAME, a.FUNCTION_CATEGORY, q.QUALIFIER_NAME,
    q.QUALIFIER_TYPE,
    a.MODIFIED_BY, a. MODIFIED_DATE, a.DO_FUNCTION, a.GRANT_AND_VIEW,
    a.DESCEND, a.EFFECTIVE_DATE, a.EXPIRATION_DATE,
    a.AUTHORIZATION_ID parent_auth_id, a.FUNCTION_ID parent_func_id,
    a.QUALIFIER_ID parent_qual_id,
    a.QUALIFIER_CODE parent_qual_code, a.FUNCTION_NAME parent_function_name,
    a.QUALIFIER_NAME parent_qual_name,
    ELT(sign(NOW()-a.effective_date), -1, 'N',
            ELT(sign(IFNULL(a.expiration_date,NOW())-NOW()), -1, 'N',
                   do_function)) is_in_effect
  from authorization a, qualifier_descendent qd, qualifier q
  where qd.parent_id = a.qualifier_id
  and q.qualifier_id = qd.child_id
  union select
    a.AUTHORIZATION_ID, f2.FUNCTION_ID, a.QUALIFIER_ID, a.KERBEROS_NAME,
    q.QUALIFIER_CODE, f2.FUNCTION_NAME, f2.FUNCTION_CATEGORY, q.QUALIFIER_NAME,
    q.QUALIFIER_TYPE,
    a.MODIFIED_BY, a. MODIFIED_DATE, a.DO_FUNCTION, a.GRANT_AND_VIEW,
    a.DESCEND, a.EFFECTIVE_DATE, a.EXPIRATION_DATE,
    a.AUTHORIZATION_ID parent_auth_id, a.FUNCTION_ID parent_func_id,
    a.QUALIFIER_ID parent_qual_id,
    q.QUALIFIER_CODE parent_qual_code, a.FUNCTION_NAME parent_function_name,
    q.QUALIFIER_NAME parent_qual_name,
    ELT(sign(NOW()-a.effective_date), -1, 'N',
            ELT(sign(IFNULL(a.expiration_date,NOW())-NOW()), -1, 'N',
                   do_function)) is_in_effect
   from authorization a, function_child fc, function f2, qualifier q
   where fc.parent_id = a.function_id
   and f2.function_id = fc.child_id
   and q.qualifier_id = a.qualifier_id
   and q.qualifier_type = f2.qualifier_type
  union select /*+ ORDERED */
    a.AUTHORIZATION_ID, f2.FUNCTION_ID, q.QUALIFIER_ID, a.KERBEROS_NAME,
    q.QUALIFIER_CODE, f2.FUNCTION_NAME, f2.FUNCTION_CATEGORY, q.QUALIFIER_NAME,
    q.QUALIFIER_TYPE,
    a.MODIFIED_BY, a. MODIFIED_DATE, a.DO_FUNCTION, a.GRANT_AND_VIEW,
    a.DESCEND, a.EFFECTIVE_DATE, a.EXPIRATION_DATE,
    a.AUTHORIZATION_ID parent_auth_id, a.FUNCTION_ID parent_func_id,
    a.QUALIFIER_ID parent_qual_id,
    a.QUALIFIER_CODE parent_qual_code, a.FUNCTION_NAME parent_function_name,
    a.QUALIFIER_NAME parent_qual_name,
    ELT(sign(NOW()-a.effective_date), -1, 'N',
            ELT(sign(IFNULL(a.expiration_date,NOW())-NOW()), -1, 'N',
                   do_function)) is_in_effect
   from function f2, function_child fc,
       authorization a, qualifier_descendent qd, qualifier q
  where qd.parent_id = a.qualifier_id
  and q.qualifier_id = qd.child_id
  and fc.parent_id = a.function_id
  and f2.function_id = fc.child_id
  and q.qualifier_type = f2.qualifier_type
 and a.descend = 'Y';


CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_expanded_auth_func_root` AS
select
   a.AUTHORIZATION_ID, a.FUNCTION_ID, a.QUALIFIER_ID, a.KERBEROS_NAME,
   a.QUALIFIER_CODE, a.FUNCTION_NAME, a.FUNCTION_CATEGORY, a.QUALIFIER_NAME,
   a.MODIFIED_BY, a. MODIFIED_DATE, a.DO_FUNCTION, a.GRANT_AND_VIEW,
   a.DESCEND, a.EFFECTIVE_DATE, a.EXPIRATION_DATE,
   a.AUTHORIZATION_ID parent_auth_id, a.FUNCTION_ID parent_func_id,
   a.QUALIFIER_ID parent_qual_id,
   a.QUALIFIER_CODE parent_qual_code, a.FUNCTION_NAME parent_function_name,
   a.QUALIFIER_NAME parent_qual_name
 from authorization a, qualifier q
 where a.qualifier_id = q.qualifier_id
 and q.qualifier_level = 1
 union select
   a.AUTHORIZATION_ID, f2.FUNCTION_ID, a.QUALIFIER_ID, a.KERBEROS_NAME,
   a.QUALIFIER_CODE, f2.FUNCTION_NAME, f2.FUNCTION_CATEGORY, a.QUALIFIER_NAME,
   a.MODIFIED_BY, a. MODIFIED_DATE, a.DO_FUNCTION, a.GRANT_AND_VIEW,
   a.DESCEND, a.EFFECTIVE_DATE, a.EXPIRATION_DATE,
   a.AUTHORIZATION_ID parent_auth_id, a.FUNCTION_ID parent_func_id,
   a.QUALIFIER_ID parent_qual_id,
   a.QUALIFIER_CODE parent_qual_code, a.FUNCTION_NAME parent_function_name,
   a.QUALIFIER_NAME parent_qual_name
  from authorization a, qualifier q, function_child fc, function f2
  where q.qualifier_id = a.qualifier_id
  and q.qualifier_level = 1
  and fc.parent_id = a.function_id
  and f2.function_id = fc.child_id;



  
  CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_expanded_auth_no_root` AS
  select a.kerberos_name, a.function_id, a.function_name, q.qualifier_code
    from rolesbb.rdb_t_authorization a, rolesbb.rdb_t_qualifier q
    where a.function_category in (select function_category from
      rolesbb.rdb_t_extract_category where username=CURRENT_USER())
    and a.qualifier_id=q.qualifier_id
    and a.descend='Y'
    and a.do_function='Y'
    and NOW() between a.effective_date and IFNULL(expiration_date,NOW())
    and q.qualifier_level != 1
    and q.has_child='N'
   union
   select
    a.kerberos_name, a.function_id, a.function_name, q.qualifier_code
    from rolesbb.rdb_t_authorization a, rolesbb.rdb_t_qualifier_descendent qd,
      rolesbb.rdb_t_qualifier q, rolesbb.rdb_t_qualifier q0,
      rolesbb.rdb_t_extract_category e
    where q0.qualifier_id = a.qualifier_id
    and q0.qualifier_level != 1
    and e.username = CURRENT_USER()
    and a.function_category = e.function_category
    and a.qualifier_id=qd.parent_id
    and a.descend='Y'
    and a.do_function='Y'
    and NOW() between a.effective_date and IFNULL(expiration_date,NOW())
    and qd.child_id=q.qualifier_id
  and q.has_child='N';
  



    CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_exp_auth_f_q_lim_dept` AS
    select
       a.AUTHORIZATION_ID, a.FUNCTION_ID, a.QUALIFIER_ID, a.KERBEROS_NAME,
       a.QUALIFIER_CODE, a.FUNCTION_NAME, a.FUNCTION_CATEGORY, a.QUALIFIER_NAME,
       a.MODIFIED_BY, a. MODIFIED_DATE, a.DO_FUNCTION, a.GRANT_AND_VIEW,
       a.DESCEND, a.EFFECTIVE_DATE, a.EXPIRATION_DATE,
       a.AUTHORIZATION_ID parent_auth_id, a.FUNCTION_ID parent_func_id,
       a.QUALIFIER_ID parent_qual_id,
       a.QUALIFIER_CODE parent_qual_code, a.FUNCTION_NAME parent_function_name,
       a.QUALIFIER_NAME parent_qual_name
     from authorization a
     union select
       a.AUTHORIZATION_ID, a.FUNCTION_ID, q.QUALIFIER_ID, a.KERBEROS_NAME,
       q.QUALIFIER_CODE, a.FUNCTION_NAME, a.FUNCTION_CATEGORY, q.QUALIFIER_NAME,
       a.MODIFIED_BY, a. MODIFIED_DATE, a.DO_FUNCTION, a.GRANT_AND_VIEW,
       a.DESCEND, a.EFFECTIVE_DATE, a.EXPIRATION_DATE,
       a.AUTHORIZATION_ID parent_auth_id, a.FUNCTION_ID parent_func_id,
       a.QUALIFIER_ID parent_qual_id,
       a.QUALIFIER_CODE parent_qual_code, a.FUNCTION_NAME parent_function_name,
       a.QUALIFIER_NAME parent_qual_name
     from authorization a, qualifier_descendent qd, qualifier q
     where qd.parent_id = a.qualifier_id
     and q.qualifier_id = qd.child_id
     and substr(q.qualifier_code,1,2) in ('D_', 'NU')
     union select
       a.AUTHORIZATION_ID, f2.FUNCTION_ID, a.QUALIFIER_ID, a.KERBEROS_NAME,
       a.QUALIFIER_CODE, f2.FUNCTION_NAME, f2.FUNCTION_CATEGORY, a.QUALIFIER_NAME,
       a.MODIFIED_BY, a. MODIFIED_DATE, a.DO_FUNCTION, a.GRANT_AND_VIEW,
       a.DESCEND, a.EFFECTIVE_DATE, a.EXPIRATION_DATE,
       a.AUTHORIZATION_ID parent_auth_id, a.FUNCTION_ID parent_func_id,
       a.QUALIFIER_ID parent_qual_id,
       a.QUALIFIER_CODE parent_qual_code, a.FUNCTION_NAME parent_function_name,
       a.QUALIFIER_NAME parent_qual_name
     from authorization a, function_child fc, function f2
     where fc.parent_id = a.function_id
     and f2.function_id = fc.child_id
     union select /*+ ORDERED */
       a.AUTHORIZATION_ID, f2.FUNCTION_ID, q.QUALIFIER_ID, a.KERBEROS_NAME,
       q.QUALIFIER_CODE, f2.FUNCTION_NAME, f2.FUNCTION_CATEGORY, q.QUALIFIER_NAME,
       a.MODIFIED_BY, a. MODIFIED_DATE, a.DO_FUNCTION, a.GRANT_AND_VIEW,
       a.DESCEND, a.EFFECTIVE_DATE, a.EXPIRATION_DATE,
       a.AUTHORIZATION_ID parent_auth_id, a.FUNCTION_ID parent_func_id,
       a.QUALIFIER_ID parent_qual_id,
       a.QUALIFIER_CODE parent_qual_code, a.FUNCTION_NAME parent_function_name,
       a.QUALIFIER_NAME parent_qual_name
     from function f2, function_child fc,
          authorization a, qualifier_descendent qd, qualifier q
     where qd.parent_id = a.qualifier_id
     and q.qualifier_id = qd.child_id
     and substr(q.qualifier_code,1,2) in ('D_', 'NU')
     and fc.parent_id = a.function_id
 and f2.function_id = fc.child_id;



 CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_extract_auth` AS
 select KERBEROS_NAME, FUNCTION_NAME, QUALIFIER_CODE,
             FUNCTION_CATEGORY, DESCEND,
             EFFECTIVE_DATE, EXPIRATION_DATE
             from authorization
             where do_function = 'Y'
             and function_category in (select function_category
            from rdb_t_extract_category where CURRENT_USER() = username);


CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_extract_desc` AS
SELECT P.QUALIFIER_CODE AS PARENT_CODE,
            C.QUALIFIER_CODE AS CHILD_CODE
            FROM QUALIFIER P, QUALIFIER_DESCENDENT D, QUALIFIER C
            where P.QUALIFIER_ID = D.PARENT_ID and
            C.QUALIFIER_ID = D.CHILD_ID
            and D.PARENT_ID IN (SELECT DISTINCT QUALIFIER_ID
            FROM AUTHORIZATION WHERE FUNCTION_CATEGORY
            IN (SELECT function_category from rdb_t_extract_category
            where CURRENT_USER() = username)); 


CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_function2` AS
select function_id, function_name, function_description,
               function_category, modified_by, modified_date, qualifier_type,
               primary_authorizable, is_primary_auth_parent,
               primary_auth_group, 'R' real_or_external
        from rdb_t_function
        union all select function_id, function_name, function_description,
               function_category, modified_by, modified_date, qualifier_type,
               primary_authorizable, null is_primary_auth_parent,
               null primary_auth_group, 'X' real_or_external
        from rdb_t_external_function;
            
            
            



 


  CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_people_who_can_spend` AS
    select a.kerberos_name, a.function_id, a.function_name, a.qualifier_id, a.qualifier_code, a.descend, a.grant_and_view, q.qualifier_code spendable_fund
    from authorization a, qualifier q, qualifier_descendent qd
    where a.function_category = 'SAP'
    and a.function_name = 'CAN SPEND OR COMMIT FUNDS'
    and a.qualifier_id = qd.parent_id
    and qd.child_id = q.qualifier_id
    and q.qualifier_type = 'FUND'
    and NOW() between a.effective_date and IFNULL(a.expiration_date,NOW())
    and a.do_function = 'Y'
    union
    select a.kerberos_name, a.function_id, a.function_name, a.qualifier_id, a.qualifier_code, a.descend, a.grant_and_view, a.qualifier_code spendable_fund
    from authorization a
    where a.function_category = 'SAP'
    and a.function_name = 'CAN SPEND OR COMMIT FUNDS'
    and NOW() between a.effective_date and IFNULL(a.expiration_date,NOW())
and a.do_function = 'Y';




CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_person` AS
select "MIT_ID","LAST_NAME","FIRST_NAME","KERBEROS_NAME","EMAIL_ADDR","DEPT_CODE","PRIMARY_PERSON_TYPE","ORG_UNIT_ID","ACTIVE","STATUS_CODE","STATUS_DATE" from rdb_t_person;




  CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_pickable_auth_category` AS
  select a.kerberos_name, c.function_category, c.function_category_desc
      from authorization a, category c
      where a.function_name = 'CREATE AUTHORIZATIONS'
      and a.qualifier_code <> 'CATALL'
      and a.do_function = 'Y'
      and NOW() between a.effective_date
                          and IFNULL(a.expiration_date, NOW())
      and c.function_category = substring(CONCAT(a.qualifier_code , '   '), 4, 4)
   union select a.kerberos_name, c.function_category,
                c.function_category_desc
      from authorization a, qualifier_descendent qd, qualifier q,
           category c
      where a.function_name = 'CREATE AUTHORIZATIONS'
      and a.do_function = 'Y'
      and NOW() between a.effective_date
                          and IFNULL(a.expiration_date, NOW())
      and qd.parent_id = a.qualifier_id
      and q.qualifier_id = qd.child_id
      and c.function_category = substring(CONCAT(q.qualifier_code , '   '), 4, 4)
   union select distinct a.kerberos_name, f2.function_category,
                         c.function_category_desc
      from authorization a, function f1, function f2, category c
      where a.do_function = 'Y'
      and NOW() between a.effective_date
                          and IFNULL(a.expiration_date, NOW())
      and f1.function_id = a.function_id
      and f1.is_primary_auth_parent = 'Y'
      and f2.primary_authorizable in ('Y', 'D')
      and f2.primary_auth_group = f1.primary_auth_group
      and c.function_category = f2.function_category
   union select distinct a.kerberos_name, a.function_category,
                         c.function_category_desc
      from authorization a, category c
      where a.grant_and_view in ('GV', 'GD')
      and NOW() between a.effective_date
                          and IFNULL(a.expiration_date, NOW())
    and c.function_category = a.function_category;  



CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_pickable_auth_function` AS
select distinct a.kerberos_name, f.function_id, f.function_name,
                 f.function_category, f.qualifier_type, f.function_description
    from authorization a, function f
    where a.function_name = 'CREATE AUTHORIZATIONS'
    and a.qualifier_code <> 'CATALL'
    and a.do_function = 'Y'
    and NOW() between a.effective_date
                        and IFNULL(a.expiration_date, NOW())
    and f.function_category = substr(CONCAT(a.qualifier_code , '  '), 4, 4)
 union select distinct a.kerberos_name, f.function_id, f.function_name,
                  f.function_category, f.qualifier_type, f.function_description
    from authorization a, qualifier_descendent qd, qualifier q,
         function f
    where a.function_name = 'CREATE AUTHORIZATIONS'
    and a.do_function = 'Y'
    and NOW() between a.effective_date
                        and IFNULL(a.expiration_date, NOW())
    and qd.parent_id = a.qualifier_id
    and q.qualifier_id = qd.child_id
    and f.function_category = substr(CONCAT(q.qualifier_code , '  '), 4, 4)
 union select distinct a.kerberos_name, f2.function_id, f2.function_name,
                       f2.function_category, f2.qualifier_type,
                       f2.function_description
    from authorization a, function f1, function f2
    where a.do_function = 'Y'
    and NOW() between a.effective_date
                        and IFNULL(a.expiration_date, NOW())
    and f1.function_id = a.function_id
    and f1.is_primary_auth_parent = 'Y'
    and f2.primary_authorizable in ('Y', 'D')
    and f2.primary_auth_group = f1.primary_auth_group
 union select distinct a.kerberos_name, f.function_id, f.function_name,
                       f.function_category, f.qualifier_type,
                       f.function_description
    from authorization a, function f
    where a.grant_and_view in ('GV', 'GD')
    and NOW() between a.effective_date
                        and IFNULL(a.expiration_date, NOW())
    and f.function_id = a.function_id;


  CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_pickable_auth_qual_top` AS
  select distinct a.kerberos_name, f.function_name, f.function_id,
                   f.qualifier_type, q.qualifier_code, q.qualifier_id
      from authorization a, function f, qualifier q
      where a.function_name = 'CREATE AUTHORIZATIONS'
      and a.qualifier_code <> 'CATALL'
      and a.do_function = 'Y'
      and NOW() between a.effective_date
                          and IFNULL(a.expiration_date, NOW())
      and f.function_category = substring(CONCAT(a.qualifier_code , '   '), 4, 4)
      and q.qualifier_type = f.qualifier_type
      and q.qualifier_level = 1
   union select distinct a.kerberos_name, f.function_name, f.function_id,
                    f.qualifier_type, q.qualifier_code, q.qualifier_id
             from authorization a, qualifier_descendent qd, qualifier q0,
                  function f, qualifier q
             where a.function_name = 'CREATE AUTHORIZATIONS'
             and a.do_function = 'Y'
             and NOW() between a.effective_date
                                 and IFNULL(a.expiration_date, NOW())
             and qd.parent_id = a.qualifier_id
             and q0.qualifier_id = qd.child_id
             and f.function_category = substring(CONCAT(q0.qualifier_code , '   '), 4, 4)
             and q.qualifier_type = f.qualifier_type
             and q.qualifier_level = 1
   union select distinct a.kerberos_name, f2.function_name, f2.function_id,
                   f2.qualifier_type, q.qualifier_code, q.qualifier_id
      from authorization a, function f1, function f2, qualifier q0,
           qualifier_descendent qd, qualifier q1, qualifier q
      where a.do_function = 'Y'
      and NOW() between a.effective_date
                          and IFNULL(a.expiration_date, NOW())
      and f1.function_id = a.function_id
      and f1.is_primary_auth_parent = 'Y'
      and f2.primary_authorizable in ('Y', 'D')
      and f2.primary_auth_group = f1.primary_auth_group
      and q0.qualifier_type = 'DEPT'
      and q0.qualifier_code = a.qualifier_code
      and qd.parent_id = q0.qualifier_id
      and q1.qualifier_id = qd.child_id
      and q.qualifier_type = f2.qualifier_type
      and q.qualifier_code = q1.qualifier_code
      and not exists (select 1 from authorization a2
         where a2.kerberos_name = a.kerberos_name
         and a2.function_name = 'CREATE AUTHORIZATIONS'
         and (a2.qualifier_code = CONCAT('CAT' , rtrim(f2.function_category))
              or a2.qualifier_code = 'CATALL')
         and a2.do_function = 'Y'
         and NOW() between a2.effective_date
                                 and IFNULL(a2.expiration_date, NOW()))
  union select distinct a.kerberos_name, f2.function_name, --added 2/09
         f2.function_id, f2.qualifier_type, q.qualifier_code, q.qualifier_id
      from authorization a, function f1, function f2, qualifier q
      where a.do_function = 'Y'
      and NOW() between a.effective_date
                          and IFNULL(a.expiration_date, NOW())
      and f1.function_id = a.function_id
      and f1.is_primary_auth_parent = 'Y'
      and f2.primary_authorizable in ('Y', 'D')
      and f2.primary_auth_group = f1.primary_auth_group
      and f2.qualifier_type = 'NULL'
      and q.qualifier_type = f2.qualifier_type
      and q.qualifier_code = 'NULL'
      and not exists (select 1 from authorization a2
         where a2.kerberos_name = a.kerberos_name
         and a2.function_name = 'CREATE AUTHORIZATIONS'
         and (a2.qualifier_code = CONCAT('CAT' , rtrim(f2.function_category))
              or a2.qualifier_code = 'CATALL')
         and a2.do_function = 'Y'
         and NOW() between a2.effective_date
                                 and IFNULL(a2.expiration_date, NOW()))
   union select distinct a.kerberos_name, f.function_name, f.function_id,
                         f.qualifier_type, q.qualifier_code, q.qualifier_id
      from authorization a, function f, qualifier q
      where a.grant_and_view in ('GV', 'GD')
      and NOW() between a.effective_date
                          and IFNULL(a.expiration_date, NOW())
      and f.function_id = a.function_id
      and q.qualifier_id = a.qualifier_id
      and not exists (select 1 from authorization a2
         where a2.kerberos_name = a.kerberos_name
         and a2.function_name = 'CREATE AUTHORIZATIONS'
         and (a2.qualifier_code = CONCAT('CAT' , rtrim(f.function_category))
              or a2.qualifier_code = 'CATALL')
         and a2.do_function = 'Y'
         and NOW() between a2.effective_date
                               and IFNULL(a2.expiration_date, NOW()));


 CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_qualifier2` AS
  select q.QUALIFIER_ID,
          q.QUALIFIER_CODE,
          ELT(IFNULL(aq.kerberos_name, ' '), CURRENT_USER(), sqn.qualifier_name,
                     q.qualifier_name) QUALIFIER_NAME,
          q.QUALIFIER_TYPE,
          q.HAS_CHILD,
          q.QUALIFIER_LEVEL,
          q.CUSTOM_HIERARCHY
   from suppressed_qualname sqn, qualifier q right outer join access_to_qualname aq on aq.qualifier_type = q.qualifier_type 
	  where sqn.qualifier_id = q.qualifier_id
   and aq.kerberos_name= CURRENT_USER(); -- and aq.kerberos_name (+)= CURRENT_USER();
 



 CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_viewable_category` AS
 select a.kerberos_name, rpad(substring(a.qualifier_code, 4), 4, ' ') function_category,
      c.function_category_desc
   from authorization a, category c
   where a.function_name in ('VIEW AUTH BY CATEGORY', 'CREATE AUTHORIZATIONS')
   and a.do_function = 'Y'
   and a.qualifier_code <> 'CATALL'
   and NOW() between a.effective_date and IFNULL(a.expiration_date, NOW())
   and c.function_category = rpad(substring(a.qualifier_code, 4), 4,' ')
 union
 select a.kerberos_name, rpad(substring(q.qualifier_code, 4), 4, ' ') function_category,
      c.function_category_desc
   from authorization a, qualifier_descendent qd, qualifier q, category c
   where a.function_name in ('VIEW AUTH BY CATEGORY', 'CREATE AUTHORIZATIONS')
   and a.do_function = 'Y'
   and NOW() between a.effective_date and IFNULL(a.expiration_date, NOW())
   and qd.parent_id = a.qualifier_id
   and q.qualifier_id = qd.child_id
   and c.function_category = rpad(substring(q.qualifier_code, 4), 4,' ')
 union
 -- Implied auth-viewing auths for people with any SAP, HR or PAYR auth
 select distinct a.kerberos_name, rpad(c.function_category,4,' ') function_category,
     c.function_category_desc
   from authorization a, category c
   where a.function_category in ('SAP', 'HR', 'PAYR')
   and a.do_function = 'Y'
   and NOW() between a.effective_date and IFNULL(a.expiration_date, NOW())
   and c.function_category in ('SAP', 'LABD', 'ADMN', 'HR', 'META', 'PAYR')
 union
 -- Auths to view categories related to PRIMARY AUTHORIZER auths
 select distinct a.kerberos_name, f2.function_category, c.function_category_desc
   from authorization a, function f1, function f2, category c
   where f1.function_id = a.function_id
   and f1.is_primary_auth_parent = 'Y'
   and f2.primary_auth_group = f1.primary_auth_group
   and f2.primary_authorizable in ('D', 'Y')
  and c.function_category = f2.function_category;
  


CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_xexpanded_auth_func_qual` AS
select distinct
   a.AUTHORIZATION_ID,
   f2.FUNCTION_ID, a.QUALIFIER_ID, a.KERBEROS_NAME,
   q.QUALIFIER_CODE, f2.FUNCTION_NAME, f2.FUNCTION_CATEGORY, q.QUALIFIER_NAME,
   q.QUALIFIER_TYPE,
   a.MODIFIED_BY, a. MODIFIED_DATE,
   a.DO_FUNCTION, a.GRANT_AND_VIEW,
   a.DESCEND, a.EFFECTIVE_DATE, a.EXPIRATION_DATE,
   a.AUTHORIZATION_ID parent_auth_id, a.FUNCTION_ID parent_func_id,
   a.QUALIFIER_ID parent_qual_id,
   q.QUALIFIER_CODE parent_qual_code,
   a.FUNCTION_NAME parent_function_name,
   q.QUALIFIER_NAME parent_qual_name
  from authorization a, function_child fc, function f2, qualifier q,
       function f1
  where fc.parent_id = a.function_id
  and f2.function_id = fc.child_id
  and q.qualifier_code = a.qualifier_code
  and q.qualifier_type = f2.qualifier_type
  and f1.function_id = a.function_id
  and f1.qualifier_type <> f2.qualifier_type
union select distinct
   a.AUTHORIZATION_ID,
   f2.FUNCTION_ID, q.QUALIFIER_ID, a.KERBEROS_NAME,
   q.QUALIFIER_CODE, f2.FUNCTION_NAME, f2.FUNCTION_CATEGORY, q.QUALIFIER_NAME,
   q.QUALIFIER_TYPE,
   a.MODIFIED_BY, a. MODIFIED_DATE,
   a.DO_FUNCTION, a.GRANT_AND_VIEW,
   a.DESCEND, a.EFFECTIVE_DATE, a.EXPIRATION_DATE,
   a.AUTHORIZATION_ID parent_auth_id, a.FUNCTION_ID parent_func_id,
   a.QUALIFIER_ID parent_qual_id,
   q.QUALIFIER_CODE parent_qual_code,
   a.FUNCTION_NAME parent_function_name,
   q.QUALIFIER_NAME parent_qual_name
  from authorization a, function_child fc, function f2,
       qualifier q0, qualifier_descendent qd, qualifier q,
       function f1
  where fc.parent_id = a.function_id
  and f2.function_id = fc.child_id
  and q0.qualifier_code = a.qualifier_code
  and q0.qualifier_type = f2.qualifier_type
  and qd.parent_id = q0.qualifier_id
  and q.qualifier_id = qd.child_id
  and f1.function_id = a.function_id
  and f1.qualifier_type <> f2.qualifier_type;


	CREATE OR REPLACE VIEW `rolesbb`.`rdb_v_functionable_category` AS
	select function_category, function_category_desc from category where
      auth_sf_can_create_function(CURRENT_USER(),function_category) = 'Y';


CREATE OR REPLACE VIEW FUNCTION2                      AS SELECT * FROM RDB_V_FUNCTION2;


CREATE OR REPLACE VIEW  AUTHORIZABLE_FUNCTION           AS SELECT * FROM RDB_V_AUTHORIZABLE_FUNCTION    ;

CREATE OR REPLACE VIEW  AUTHORIZATION2                  AS SELECT * FROM RDB_V_AUTHORIZATION2           ;

CREATE OR REPLACE VIEW  DEPT_PEOPLE                     AS SELECT * FROM RDB_V_DEPT_PEOPLE              ;

CREATE OR REPLACE VIEW  DEPT_SAP_AUTH                   AS SELECT * FROM RDB_V_DEPT_SAP_AUTH            ;

CREATE OR REPLACE VIEW  DEPT_SAP_AUTH2                  AS SELECT * FROM RDB_V_DEPT_SAP_AUTH2           ;

CREATE OR REPLACE VIEW  EXPANDED_AUTH2                  AS SELECT * FROM RDB_V_EXPANDED_AUTH2           ;

CREATE OR REPLACE VIEW  EXPANDED_AUTHORIZATION          AS SELECT * FROM RDB_V_EXPANDED_AUTHORIZATION   ;

CREATE OR REPLACE VIEW  EXPANDED_AUTH_FUNC_QUAL         AS SELECT * FROM RDB_V_EXPANDED_AUTH_FUNC_QUAL  ;

CREATE OR REPLACE VIEW  EXPANDED_AUTH_NO_ROOT           AS SELECT * FROM RDB_V_EXPANDED_AUTH_NO_ROOT    ;

CREATE OR REPLACE VIEW  EXP_AUTH_FUNC_QUAL_LIM_DEPT     AS SELECT * FROM RDB_V_EXP_AUTH_F_Q_LIM_DEPT    ;

CREATE OR REPLACE VIEW  EXTRACT_AUTH                    AS SELECT * FROM RDB_V_EXTRACT_AUTH             ;

CREATE OR REPLACE VIEW  EXTRACT_DESC                    AS SELECT * FROM RDB_V_EXTRACT_DESC             ;

CREATE OR REPLACE VIEW  FUNCTION2                       AS SELECT * FROM RDB_V_FUNCTION2                ;



CREATE OR REPLACE VIEW  FUNCTIONABLE_CATEGORY           AS SELECT * FROM RDB_V_FUNCTIONABLE_CATEGORY    ;

CREATE OR REPLACE VIEW  PEOPLE_WHO_CAN_SPEND            AS SELECT * FROM RDB_V_PEOPLE_WHO_CAN_SPEND     ;

CREATE OR REPLACE VIEW  PERSON                          AS SELECT * FROM RDB_V_PERSON                   ;

CREATE OR REPLACE VIEW  PROXY_QUALIFIER2                AS SELECT * FROM RDB_V_PROXY_QUALIFIER2         ;

CREATE OR REPLACE VIEW  QUALIFIER2                      AS SELECT * FROM RDB_V_QUALIFIER2               ;


SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------------------------------------------------
-- EOF

