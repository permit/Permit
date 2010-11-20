-- ------------------
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
-- ------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `mdept$owner`.`add_dept`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `mdept$owner`.`add_dept`(IN AI_FOR_USER          VARCHAR(80),
       IN AI_D_CODE            VARCHAR(15),
       IN AI_SHORT_NAME        VARCHAR(25),
       IN AI_LONG_NAME          VARCHAR(70),
       IN AI_DEPT_TYPE_ID      INTEGER,
       IN AI_VIEW_SUBTYPE_ID   INTEGER,
       IN AI_PARENT_ID         INTEGER,
       OUT AO_DEPT_ID          INTEGER,
       OUT AO_MESSAGE          VARCHAR(255))
BEGIN
 DECLARE v_user  varchar(20);
 DECLARE v_dept_type_id_count   INTEGER DEFAULT 0;
 DECLARE v_count INTEGER DEFAULT 0 ;
 DECLARE v_count_id INTEGER DEFAULT 0;
 DECLARE v_d_code VARCHAR(15);
 DECLARE v_dept_type_id INTEGER;
 DECLARE v_audit_id INTEGER;
 DECLARE v_errcode INTEGER DEFAULT -20090;

 DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
                rollback;
                SET ao_message = PUT_LINE(CONCAT(v_message, 'Error: Not able to get the next dept_id from sequence'));
                SET v_errcode  = -20081;
                call permit_signal( v_errcode, ao_message);

  END;

   DECLARE EXIT HANDLER FOR 1045
   BEGIN
                   rollback;
                   SET ao_message = PUT_LINE(CONCAT(v_message, ' Access Error '));
                   SET v_errcode  = -20091;
                   call permit_signal( v_errcode, ao_message);

  END;

  DECLARE EXIT HANDLER FOR 1054
  BEGIN
                    rollback;
                    SET ao_message = PUT_LINE(CONCAT(v_message, ' Unknown column '));
                    SET v_errcode  = -20092;
                    call permit_signal( v_errcode, ao_message);

  END;

  DECLARE EXIT HANDLER FOR 1044
  BEGIN
                    rollback;
                    SET ao_message = PUT_LINE(CONCAT(v_message, ' Error: DB Access denied '));
                    SET v_errcode  = -20093;
                    call permit_signal( v_errcode, ao_message);

  END;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
                    rollback;
                    call permit_signal( v_errcode, ao_message);

  END;

  DECLARE EXIT HANDLER FOR 1062
  BEGIN
                    rollback;
                    SET ao_message = PUT_LINE(CONCAT(v_message, ' Duplicate row '));
                    SET v_errcode  = -20094;
                    call permit_signal( v_errcode, ao_message);

  END;

  start transaction;

  SET ao_message = 'SQL Exception';
  if (ai_for_user is null) then
     SET v_user = USER() ;
   else
    SET v_user = ai_for_user;

   end if;
  SET v_user = upper(v_user);

  SET v_d_code = upper(ai_d_code);

 if (can_maintain_dept(v_user, 1) = 'N') then
        SET ao_message = 'Error: the user does not have the authorization to maintain dept.';
        SET v_errcode  = -20060;
        call permit_signal(v_errcode, ao_message);
   end if;

   if (ai_d_code is NULL)  then
     SET ao_message = 'Error: d_code can not be null.';
     SET v_errcode  = -20054;
     call permit_signal ( v_errcode, ao_message );
   end if;

    if (ai_short_name is null)  then
     SET ao_message = 'Error: dept_short_name can not be null.';
     SET v_errcode  = -20052;
     call permit_signal ( v_errcode, ao_message );
   end if;

   if (ai_long_name is null)  then
     SET ao_message = 'Error: dept_long_name cannot  be null.';
     SET v_errcode  = -20053;
     call permit_signal ( v_errcode, ao_message );
   end if;

   if (ai_dept_type_id is null)  then
     SET ao_message = 'Error: dept_type_id  can not be null.';
     SET v_errcode  = -20055;
      call permit_signal ( v_errcode, ao_message );
   end if;

   SET v_d_code = UPPER (ai_d_code);
   if (SUBSTR(v_d_code, 1, 2) <> 'D_') then
     SET ao_message = 'Error: dept_code must start with D_.';
     SET v_errcode  = -20030;
      call permit_signal(v_errcode, ao_message);
   end if;

   if (LENGTH(v_d_code) > 15) then
    SET ao_message = 'Error: d_code is longer than 15 characters.';
     SET v_errcode  = -20020;
    call permit_signal (v_errcode, ao_message);
   end if;

  if (LENGTH(ai_short_name) > 25 ) then
     SET ao_message = 'Error: dept_short_name is longer than 20 characters.';
     SET v_errcode  = -20022;
      call permit_signal ( v_errcode, ao_message );
    end if;

  if (LENGTH(ai_long_name) > 70 ) then
    SET ao_message = 'Error: dept_long_name is longer than 70 characters.';
     SET v_errcode  = -20023;
    call permit_signal ( v_errcode, ao_message );
   end if;

 
     select count(*) into v_dept_type_id_count from dept_node_type
                     where dept_type_id = ai_dept_type_id;
     if v_dept_type_id_count = 0 then
       SET ao_message = CONCAT('Error: Dept_type_id ''' , ai_dept_type_id
                      , ''' does not exist.');
      SET v_errcode  = -20015;
       call permit_signal(v_errcode, ao_message);
     end if;

   
   select count(view_subtype_id) into v_count_id from view_subtype
                where view_subtype_id = ai_view_subtype_id;
   if (v_count_id = 0) then
         SET ao_message = CONCAT('Error: view_subtype_id ''' , ai_view_subtype_id , ''' does not exist.');
         SET v_errcode  = -20012;
         call permit_signal(v_errcode, ao_message);
   end if;
 
  select count(d_code) into v_count_id from department where d_code = ai_d_code;
  if (v_count_id <> 0) then
         SET ao_message = CONCAT('Error: D_code of ',ai_d_code,' has to be unique');
         SET v_errcode  = -20014;
         call permit_signal(v_errcode, ao_message);
  end if;


  
  insert into department ( d_code, short_name, long_name, dept_type_id,
                          create_date, create_by, modified_date, modified_by)
         values(v_d_code, ai_short_name,ai_long_name,
                ai_dept_type_id, sysdate(), v_user, sysdate(), v_user);


  select last_insert_id() into ao_dept_id;

 insert into department_child (parent_id, view_subtype_id, child_id,
                                created_by, start_date, end_date)
          values(ai_parent_id, ai_view_subtype_id, ao_dept_id,
                 v_user, sysdate(), null);

   SET  v_audit_id = next_sequence_val('audit_sequence') ;

   insert into department_audit
          ( audit_id, MOD_BY_USERNAME, ACTION_DATE, ACTION_TYPE, OLD_NEW,
           DEPT_ID, D_CODE, SHORT_NAME, LONG_NAME, DEPT_TYPE_ID,
           DEPT_TYPE_DESC, CREATE_DATE, CREATE_BY, MODIFIED_DATE, MODIFIED_BY)
          SELECT  v_audit_id,v_user, sysdate(), 'I', '>',
            d.dept_id, d.d_code, d.short_name, d.long_name, d.dept_type_id,
            nt.dept_type_desc, d.create_date, d.create_by, d.modified_date,
            d.modified_by
        from department d LEFT OUTER JOIN dept_node_type nt ON  d.dept_type_id = nt.dept_type_id
        where dept_id = ao_dept_id;



      INSERT into dept_child_audit
          (audit_id, MOD_BY_USERNAME, ACTION_DATE, ACTION_TYPE,
           OLD_NEW,
           PARENT_ID, PARENT_D_CODE, VIEW_SUBTYPE_ID, CHILD_ID,
           CHILD_D_CODE, CREATED_BY, START_DATE, END_DATE)
          SELECT  v_audit_id, v_user, sysdate(), 'I', '>',
            dc.parent_id, d1.d_code, dc.view_subtype_id, dc.child_id,
            d2.d_code, dc.created_by, dc.start_date, dc.end_date
          from department_child dc
          LEFT OUTER JOIN department d1 ON (d1.dept_id = dc.parent_id)
          LEFT OUTER JOIN department d2 ON (d2.dept_id = dc.child_id)
          where dc.child_id = ao_dept_id;

   SET ao_message = CONCAT('Dept ',ao_dept_id,' successfully added');

COMMIT;



END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `mdept$owner`.`add_dept_parent`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `mdept$owner`.`add_dept_parent`(IN AI_FOR_USER            VARCHAR(20),
                    IN AI_DEPT_ID              INTEGER,
                    IN AI_VIEW_SUBTYPE_ID      INTEGER,
                    IN AI_PARENT_ID            INTEGER,
                    OUT AO_MESSAGE            VARCHAR(255))
BEGIN

 DECLARE v_user  varchar(20);
 DECLARE v_dept_id_count  INTEGER DEFAULT 0;
 DECLARE v_view_subtype_id_count INTEGER DEFAULT 0;
 DECLARE v_parent_id_count    INTEGER DEFAULT 0;
 DECLARE v_count INTEGER DEFAULT 0;
 DECLARE v_audit_id INTEGER;
 DECLARE v_errcode INTEGER DEFAULT -20090;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
                  rollback;

                  call permit_signal( ao_errcode, ao_message);
   END;

    start transaction;

    SET ao_message = 'SQL Error';

    if ai_for_user is null then
      SET v_user = user();
    else
       SET v_user = ai_for_user;
    end if;
    SET v_user = upper(v_user);
  if (v_user is null) then
     SET ao_message = 'Error: v_user is null';
     SET v_errcode = -20060;
     call permit_signal(v_errcode, ao_message);
  end if;
  if can_maintain_dept(v_user, 1) = 'N' then
        SET ao_message = CONCAT('Error: User ''' , v_user ,
            ''' does not have the authorization to make this change.');
        SET v_errcode = -20060;
        call permit_signal(v_errcode, ao_message);
   end if;

    if ai_dept_id is null  then
       SET ao_message = 'Error: dept_id can not be null.';
       SET v_errcode = -20051;
       call permit_signal ( v_errcode, ao_message );
    end if;

    select count(*) into v_dept_id_count from department
                    where dept_id = ai_dept_id;
    if v_dept_id_count = 0 then
       SET ao_message = CONCAT('Dept_id ''' , ai_dept_id , ''' does not exist.');
       SET v_errcode = -20010;
       call permit_signal(v_errcode, ao_message);
    end if;

    if can_maintain_dept(v_user, ai_dept_id) = 'N' then
       SET ao_message = CONCAT('Error: User ''' , v_user ,
              ''' does not have the authorization to maintain departments.');
        SET v_errcode = -20060;
      call permit_signal(v_errcode, ao_message);
    end if;

    
    
    if ai_parent_id is null  then
       SET ao_message = 'Error: the input parent_id  can not be null.';
        SET v_errcode = -20058;
      call permit_signal ( v_errcode, ao_message );
    end if;

    if ai_view_subtype_id is null  then
       SET ao_message = 'Error: view_subtype_id can not be null.';
        SET v_errcode = -20055;
       call permit_signal ( v_errcode, ao_message );
    end if;

    
    select count(*) into v_view_subtype_id_count from view_subtype
                    where view_subtype_id = ai_view_subtype_id;
    if v_view_subtype_id_count = 0 then
       SET ao_message = CONCAT('View_subtype_id ''' , ai_view_subtype_id
                     , ''' does not exist.');
         SET v_errcode = -20012;
      call permit_signal(v_errcode, ao_message);
    end if;

    select count(*) into v_parent_id_count from department
                    where dept_id = ai_parent_id;
    if v_parent_id_count = 0 then
       SET ao_message = CONCAT('Dept_id ''' , ai_parent_id , ''' does not exist.');
        SET v_errcode = -20011;
       call permit_signal(v_errcode, ao_message);
    end if;

    
     select count(*) into v_count from department_child
                  where parent_id = ai_parent_id and
                        child_id  = ai_dept_id;
     if v_count > 0 then
       SET ao_message = CONCAT('Error: Parent-child relationship already exists for ('''
                      , ai_parent_id , ''','''
                      , ai_dept_id , ''')');
        SET v_errcode = -20092;
        call permit_signal(v_errcode, ao_message);
     end if;



     SET ao_message = CONCAT(ao_message , ' Added the parent link for dept '
            , ai_dept_id , ' successfully');

 
     if (ai_parent_id = ai_dept_id) then
        SET ao_message = 'Error: Parent dept cannot equal child dept';
        SET v_errcode = -20093;
        call permit_signal(v_errcode, ao_message);
     end if;

  
     if is_loop(ai_dept_id, ai_parent_id) = 'Y' then
        SET ao_message = CONCAT('Error: the requested parent/child relationship would make the child'
                      , ' node an ancestor of itself.');
         SET v_errcode = -20068;
       call permit_signal(v_errcode, ao_message);
     end if;

 
      select count(*) into v_count from department_child
         where child_id = ai_dept_id
         and view_subtype_id = ai_view_subtype_id;
      if v_count <> 0 then
       SET ao_message = CONCAT('If a department has more than one parent, then parents '
                       , 'must all have a different Parent Link Type');
        SET v_errcode = -20098;
       call permit_signal(v_errcode, ao_message);
      end if;

     insert into department_child ( parent_id, view_subtype_id, child_id, created_by,
                                 start_date, end_date) values (ai_parent_id,
                                         ai_view_subtype_id,
                                         ai_dept_id,
                                         v_user, sysdate(), null );
     select next_sequence_val('audit_sequence') into v_audit_id;

 

      
      INSERT into dept_child_audit
          (AUDIT_ID, MOD_BY_USERNAME, ACTION_DATE, ACTION_TYPE,
           OLD_NEW,
           PARENT_ID, PARENT_D_CODE, VIEW_SUBTYPE_ID, CHILD_ID,
           CHILD_D_CODE, CREATED_BY, START_DATE, END_DATE)
          SELECT v_audit_id, v_user, sysdate(), 'I', '>',
            dc.parent_id, d1.d_code, dc.view_subtype_id, dc.child_id,
            d2.d_code, dc.created_by, dc.start_date, dc.end_date
          from department_child dc LEFT OUTER JOIN department d1 ON d1.dept_id = dc.parent_id
           LEFT OUTER JOIN  department d2 ON d2.dept_id = dc.child_id
          where dc.child_id = ai_dept_id
          and dc.parent_id = ai_parent_id;


     COMMIT;

    SET ao_message = ' Dept parent added successfully';
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `mdept$owner`.`add_link_to_object`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `mdept$owner`.`add_link_to_object`(IN AI_FOR_USER            VARCHAR(20),
                    IN AI_DEPT_ID             INTEGER,
                    IN AI_OBJECT_TYPE_CODE    VARCHAR(8),
                    IN AI_OBJECT_CODE         VARCHAR(20),
                    OUT AO_MESSAGE            VARCHAR(255))
BEGIN

 DECLARE v_user  varchar(20);
 DECLARE v_count_id  INTEGER DEFAULT 0 ;
 DECLARE v_count_object_type_code INTEGER DEFAULT 0 ;
 DECLARE v_audit_id INTEGER ;
DECLARE v_errcode INTEGER DEFAULT -20090;


 DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
                  rollback;
                  call permit_signal( v_errcode, ao_message);
   END;

    start transaction;

    SET ao_message = ' SQL Exception';
   if (ai_for_user is null) then
     SET v_user = USER() ;
   else
    SET v_user = ai_for_user;

   end if;
   SET v_user = UPPER(v_user);

   if ai_dept_id is null  then
      SET ao_message = 'Error: d_dept_id can not be null.';
      SET v_errcode =-20051;
      call permit_signal ( v_errcode, ao_message );
   end if;

   select count(dept_id) into v_count_id from department
          where dept_id = ai_dept_id;

   if v_count_id = 0 then
      SET ao_message = CONCAT('Dept_id ''' , ai_dept_id , ''' does not exist.');
      SET v_errcode =-20010;
      call permit_signal(v_errcode, ao_message);
   end if;

   if can_maintain_link(v_user, ai_dept_id) = 'N' then
      SET ao_message = 'Error: the user does not have the authorization to maintain link.';
      SET v_errcode =-20061;
      call permit_signal(v_errcode, ao_message);
   end if;

   if ai_object_code is null  then
      SET ao_message = 'Error: object_code can not be null.';
      SET v_errcode =-20054;
      call permit_signal ( v_errcode, ao_message );
   end if;

   if ai_object_type_code is null  then
      SET ao_message = 'Error: object_type_code can not be null.';
      SET v_errcode =-20056;
      call permit_signal ( v_errcode, ao_message );
   end if;

   if length(ai_object_code) > 20 then
     SET ao_message = 'Error: object code is longer than 20 characters.';
      SET v_errcode =-20021;
     call permit_signal ( v_errcode , ao_message );
   end if;

   select count(object_type_code) into v_count_object_type_code
           from object_type where object_type_code = ai_object_type_code;

   if v_count_object_type_code = 0 then
      SET ao_message = CONCAT('Object_type_code  ''' , ai_object_type_code
                     , ''' does not exist.');
      SET v_errcode =-20017;
      call permit_signal(v_errcode, ao_message);
   end if;

   insert into object_link values(ai_dept_id,
                                  ai_object_type_code,
                                  ai_object_code);

    SET  v_audit_id = next_sequence_val('audit_sequence');

     
      
      INSERT into object_link_audit
          (AUDIT_ID, MOD_BY_USERNAME, ACTION_DATE, ACTION_TYPE, OLD_NEW,
           DEPT_ID, D_CODE, OBJECT_TYPE_CODE, OBJECT_CODE)
          SELECT v_audit_id, v_user, sysdate(), 'I', '>',
            ol.dept_id, d.d_code, ol.object_type_code, ol.object_code
          from department d LEFT OUTER JOIN object_link ol ON d.dept_id = ol.dept_id
          where ol.dept_id = ai_dept_id
          and ol.object_type_code = ai_object_type_code
          and ol.object_code = ai_object_code;

   SET ao_message = 'Object link successfully added';

 COMMIT;

END $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `mdept$owner`.`can_maintain_any_dept`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `mdept$owner`.`can_maintain_any_dept`( AI_FOR_USER VARCHAR(20)) RETURNS varchar(1) CHARSET latin1
BEGIN
 DECLARE v_user varchar(24);
 DECLARE v_count INTEGER;

 SET   v_user = upper(AI_FOR_USER);
 select count(*) into v_count from rolesbb.authorization
      where kerberos_name = v_user
      and function_name = 'MAINTAIN MDEPT DATA'
      and qualifier_code = 'NULL'
      and do_function = 'Y'
      and sysdate() between effective_date and IFNULL(expiration_date, sysdate());
    if v_count > 0 then
      return 'Y';
    end if;
    return 'N';
END;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `mdept$owner`.`can_maintain_dept`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `mdept$owner`.`can_maintain_dept`( AI_FOR_USER  VARCHAR(20),
                              AI_DEPT_ID INTEGER) RETURNS varchar(1) CHARSET latin1
begin
    return can_maintain_any_dept(ai_for_user);
END;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `mdept$owner`.`can_maintain_link`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `mdept$owner`.`can_maintain_link`( AI_FOR_USER  VARCHAR(20),
                              AI_DEPT_ID INTEGER) RETURNS varchar(1) CHARSET latin1
begin
    return can_maintain_any_dept(ai_for_user);
END;

 $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `mdept$owner`.`delete_dept`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `mdept$owner`.`delete_dept`(IN AI_FOR_USER        VARCHAR(20),
                               IN AI_DEPT_ID         INTEGER   ,
                               OUT AO_MESSAGE        VARCHAR(255))
BEGIN
 DECLARE v_user  varchar(20);
 DECLARE v_dept_id_count  INTEGER DEFAULT 0;
 DECLARE v_child_id_count INTEGER DEFAULT 0;
 DECLARE v_link_count     INTEGER DEFAULT  0;
 DECLARE v_exp_link_count INTEGER DEFAULT 0;
 DECLARE v_message_no INTEGER DEFAULT  -20090;
 DECLARE v_audit_id INTEGER;
 DECLARE v_message VARCHAR(255);

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
                rollback;
                SET v_message_no = -20081;
                SET ao_message = 'Error: Unable to get the next dept_id from sequence';
                call permit_signal( v_message_no, ao_message);
  END;

   DECLARE EXIT HANDLER FOR 1045
   BEGIN
                    rollback;
                    SET v_message_no = -20091;
                    SET ao_message = ' Access Denied Error ';
                     call permit_signal( v_message_no, ao_message);

  END;

  DECLARE EXIT HANDLER FOR 1054
  BEGIN
                    rollback;
                    SET v_message_no = -20092;
                    SET ao_message = ' Unknown column ';
                    call permit_signal( v_message_no, ao_message);

  END;

  DECLARE EXIT HANDLER FOR 1044
  BEGIN
                    rollback;
                    SET v_message_no = -20093;
                    SET ao_message = ' DB Access Error';
                    call permit_signal( v_message_no, ao_message);

  END;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
                    rollback;
                    SET v_message = PUT_LINE(CONCAT(v_message,   ' SQLEXCEPTION '));
                    call permit_signal( v_message_no, 'Error: SQL error');

  END;

  DECLARE EXIT HANDLER FOR 1062
  BEGIN
                    rollback;
                    SET v_message_no = -20094;
                    SET ao_message = ' Duplicate Error';
                    call permit_signal( v_message_no, ao_message);
  END;



  start transaction;

  SET ao_message = 'Unexpected SQL error.';

  if (ai_for_user is null) then
      SET v_user = USER() ;
    else
    SET v_user = ai_for_user;
  end if;
  SET v_user = upper(v_user);

  if ai_dept_id is null  then
     SET ao_message = 'dept_id can not be null.';
     SET v_message_no = -20051;
     call permit_signal(v_message_no, ao_message);
  end if;

  select count(*) into v_dept_id_count from department where dept_id = ai_dept_id;
  if v_dept_id_count = 0 then
     SET ao_message = CONCAT('Department ID ''' , ai_dept_id, ''' does not exist.');
     SET v_message_no = -20011;
       call permit_signal(v_message_no, ao_message);
  end if;
  
   if can_maintain_dept(v_user, ai_dept_id) = 'N' then
      SET ao_message = 'User does not have the authorization to maintain dept.';
      SET v_message_no = -20060;
       call permit_signal(v_message_no, ao_message);
   end if;


 
   select count(child_id) into v_child_id_count from department_child where parent_id = ai_dept_id;
   if v_child_id_count <>0 then
     SET ao_message = 'Cannot delete department with children';
     SET v_message_no = -20041;
     call permit_signal(v_message_no, ao_message);
   end if;



   select count(child_id) into v_child_id_count from department_child
                          where child_id = ai_dept_id;
   select count(dept_id)  into v_link_count from object_link
                          where dept_id = ai_dept_id;
   select count(dept_id) into v_dept_id_count from department
                          where dept_id = ai_dept_id;
   select count(dept_id) into v_exp_link_count from expanded_object_link
                          where dept_id = ai_dept_id;


   SET ao_message = CONCAT(v_dept_id_count ,' department ',ai_dept_id
                 ,' successfully deleted: there are '
                 , v_child_id_count , ' children and ', v_link_count
                 ,' object links have been deleted');

     select next_sequence_val('audit_sequence') INTO v_audit_id ;

        INSERT into department_audit
          ( audit_id, MOD_BY_USERNAME, ACTION_DATE, ACTION_TYPE, OLD_NEW,
           DEPT_ID, D_CODE, SHORT_NAME, LONG_NAME, DEPT_TYPE_ID,
           DEPT_TYPE_DESC, CREATE_DATE, CREATE_BY, MODIFIED_DATE, MODIFIED_BY)
          SELECT v_audit_id, v_user, sysdate(), 'D', '<',
            d.dept_id, d.d_code, d.short_name, d.long_name, d.dept_type_id,
            nt.dept_type_desc, d.create_date, d.create_by, d.modified_date,
            d.modified_by
        from dept_node_type nt LEFT OUTER JOIN department d ON (nt.dept_type_id = d.dept_type_id)
        where dept_id = ai_dept_id;




        INSERT into dept_child_audit
          (audit_id, MOD_BY_USERNAME, ACTION_DATE, ACTION_TYPE,
           OLD_NEW,
           PARENT_ID, PARENT_D_CODE, VIEW_SUBTYPE_ID, CHILD_ID,
           CHILD_D_CODE, CREATED_BY, START_DATE, END_DATE)
          SELECT v_audit_id, v_user, sysdate(), 'D', '<',
            dc.parent_id, d1.d_code, dc.view_subtype_id, dc.child_id,
            d2.d_code, dc.created_by, dc.start_date, dc.end_date
          from department_child dc  LEFT OUTER JOIN department d1 ON (d1.dept_id = dc.parent_id )
          			LEFT OUTER JOIN department d2 ON (d2.dept_id = dc.child_id)
           where dc.child_id = ai_dept_id;


        INSERT into object_link_audit
          (audit_id,MOD_BY_USERNAME, ACTION_DATE, ACTION_TYPE, OLD_NEW,
           DEPT_ID, D_CODE, OBJECT_TYPE_CODE, OBJECT_CODE)
          SELECT  v_audit_id,v_user, sysdate(), 'D', '<',
            ol.dept_id, d.d_code, ol.object_type_code, ol.object_code
          from  department d LEFT OUTER JOIN object_link ol ON (d.dept_id = ol.dept_id)
          where ol.dept_id = ai_dept_id  ;

  
   
   if v_child_id_count > 0 then
      delete from department_child where child_id = ai_dept_id;
   end if;
   if v_link_count > 0 then
      delete from object_link where dept_id = ai_dept_id;
   end if;
   if v_exp_link_count > 0 then
      delete from expanded_object_link where dept_id = ai_dept_id;
   end if;
   if v_dept_id_count > 0 then
      delete from department where dept_id = ai_dept_id;
   end if;


  SET ao_message = CONCAT('Department ',ai_dept_id,' successfully deleted');

   COMMIT;

 END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `mdept$owner`.`delete_dept_parent`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `mdept$owner`.`delete_dept_parent`(IN AI_FOR_USER             VARCHAR(20),
                    IN AI_DEPT_ID              INTEGER,
                    IN AI_VIEW_SUBTYPE_ID      INTEGER,
                    IN AI_PARENT_ID            INTEGER,
                    OUT AO_MESSAGE             VARCHAR(255))
BEGIN
 
 DECLARE v_user  		varchar(20);
 DECLARE v_count     		INTEGER DEFAULT 0 ;
 DECLARE v_link_count 		INTEGER DEFAULT 0;
 DECLARE v_dept_id_count   	INTEGER DEFAULT  0;
 DECLARE v_view_subtype_id_count INTEGER DEFAULT  0;
 DECLARE v_parent_id_count    	 INTEGER DEFAULT 0;
 DECLARE v_audit_id INTEGER;
 DECLARE v_message INTEGER DEFAULT -20090;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
                  rollback;
                  call permit_signal( v_message, ao_message);
   END;

    start transaction;

  SET ao_message = ' SQL Error';
  
  if (ai_for_user is null) then
      SET v_user = USER() ;
    else
    SET v_user = ai_for_user;
  end if;
  SET v_user = UPPER(v_user);
    
   if ai_dept_id is null  then
      SET ao_message = 'Error: dept_id can not be null.';
      SET v_message = -20051;
      call permit_signal ( v_message, ao_message );
   end if;
 
   select count(*) into v_dept_id_count from department
                   where dept_id = ai_dept_id;
   if v_dept_id_count = 0 then
      SET ao_message = CONCAT('Dept_id ''' , ai_dept_id , ''' does not exist.');
      SET v_message = -20010;
      call permit_signal (v_message, ao_message);
   end if;

   if can_maintain_dept(v_user, ai_dept_id) = 'N' then
       SET ao_message = 'Error: the user does not have the authorization to maintain this dept.';
      SET v_message = -20060;
       call permit_signal (v_message, ao_message);
    end if;

   
   if ai_parent_id is null  then
      SET ao_message = 'Error: the input parent_id  can not be null.';
      SET v_message = -20058;
      call permit_signal  ( v_message, ao_message );
   end if;

   if ai_view_subtype_id is null  then
      SET ao_message = 'Error: view_subtype_id can not be null.';
      SET v_message = -20055;
      call permit_signal  ( v_message, ao_message );
   end if;


 
   select count(*) into v_view_subtype_id_count from view_subtype
                   where view_subtype_id = ai_view_subtype_id;
   if v_view_subtype_id_count = 0 then
      SET ao_message = CONCAT('View_subtype_id ''' , ai_view_subtype_id , ''' does not exist.');
      SET v_message = -20011;
      call permit_signal (v_message, ao_message);
   end if;

   select count(*) into v_parent_id_count from department
                   where dept_id = ai_parent_id;
   if v_parent_id_count = 0 then
      SET ao_message = CONCAT('Dept_id ''' , ai_parent_id , ''' does not exist.');
      SET v_message = -20010;
      call permit_signal (v_message, ao_message);
   end if;

   
   select count(*) into v_link_count from department_child
                   where child_id = ai_dept_id
                   and parent_id = ai_parent_id
                   and view_subtype_id = ai_view_subtype_id;
   if v_link_count = 0 then
      SET ao_message = 'Parent_child link does not exist.';
      SET v_message = -20012;
      call permit_signal (v_message, ao_message);
   end if;


   select count(parent_id) into v_count from department_child
                            where child_id = ai_dept_id;
   if v_count < 2 then
      SET ao_message = CONCAT('Error: Cannot delete parent of ''' , ai_dept_id
                     ,'''.  It has only one parent.');
      SET v_message = -20070;
      call permit_signal (v_message, ao_message);
   end if;

   SET  v_audit_id = next_sequence_val('audit_sequence') ;

   SET ao_message = CONCAT(v_link_count , ' parent link for dept ',ai_dept_id,' successfully deleted.');


    
    INSERT into dept_child_audit
          ( audit_id, MOD_BY_USERNAME, ACTION_DATE, ACTION_TYPE,
           OLD_NEW,
           PARENT_ID, PARENT_D_CODE, VIEW_SUBTYPE_ID, CHILD_ID,
           CHILD_D_CODE, CREATED_BY, START_DATE, END_DATE)
          SELECT  v_audit_id,ai_for_user, sysdate(), 'D', '<',
            dc.parent_id, d1.d_code, dc.view_subtype_id, dc.child_id,
            d2.d_code, dc.created_by, dc.start_date, dc.end_date
          from department_child dc LEFT OUTER JOIN department d1 ON (d1.dept_id = dc.parent_id)
          	LEFT OUTER JOIN department d2 ON (d2.dept_id = dc.child_id)
          where dc.child_id = ai_dept_id
          and dc.parent_id = ai_parent_id;

   delete from department_child where child_id = ai_dept_id
          and parent_id = ai_parent_id and view_subtype_id = ai_view_subtype_id;

   COMMIT;

  SET ao_message = CONCAT( ' Dapartment parent ',AI_PARENT_ID, ' for Dept ',ai_dept_id,' successfully deleted.');

 END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `mdept$owner`.`delete_link_to_object`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `mdept$owner`.`delete_link_to_object`(IN  AI_FOR_USER          VARCHAR(20),
                    IN  AI_DEPT_ID           INTEGER,
                    IN  AI_OBJECT_TYPE_CODE    INTEGER,
                    IN  AI_OBJECT_CODE         INTEGER,
                    OUT AO_MESSAGE           VARCHAR(255))
BEGIN
 
 DECLARE v_user  varchar(20);
 DECLARE v_count_id  INTEGER DEFAULT  0 ;
 DECLARE v_count_link INTEGER DEFAULT  0;
 DECLARE v_count_object_type_code INTEGER DEFAULT 0 ;
 DECLARE v_audit_id INTEGER;
 DECLARE v_message INTEGER DEFAULT -20090;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
                  rollback;
                  call permit_signal( v_message, ao_message);
   END;

    start transaction;

  SET ao_message = ' SQL Error';

  if (ai_for_user is null) then
      SET v_user = USER() ;
    else
    SET v_user = ai_for_user;
  end if;
  SET v_user = UPPER(v_user);
 
   if ai_dept_id is null  then
      SET ao_message = 'Error: d_dept_id can not be null.';
      SET v_message = -20051;
      call permit_signal ( v_message, ao_message );
   end if;
 
  select count(dept_id) into v_count_id from department
                         where dept_id = ai_dept_id;
   if v_count_id = 0 then
      SET ao_message = CONCAT('Dept_id ''' , ai_dept_id , ''' does not exist.');
      SET v_message = -20010;
      call permit_signal(v_message, ao_message);
   end if;
 
   if can_maintain_link(v_user, ai_dept_id) = 'N' then
      SET ao_message = 'Error: the user does not have the authorization to maintain links for this department.';
      SET v_message = -20061;
      call permit_signal(v_message, ao_message);
   end if;
 
 
   if length(ai_object_code) > 20 then
      SET ao_message = 'Error: object code is longer than 20 characters.';
      SET v_message = -20021;
      call permit_signal ( v_message , ao_message );
   end if;
 
   select count(object_type_code) into v_count_object_type_code
          from object_type where object_type_code = ai_object_type_code;
   if v_count_object_type_code = 0 then
      SET ao_message = CONCAT('Object_type_code  ''' , ai_object_type_code
                     , ''' does not exist.');
      SET v_message = -20011;
      call permit_signal(v_message, ao_message);
   end if;
 
   
   select count(*) into v_count_link
          from object_link where dept_id = ai_dept_id and
                           object_type_code = ai_object_type_code and
                                object_code = ai_object_code ;
   if v_count_link = 0 then
      SET ao_message = 'Error: this department-object does not exist.';
      SET v_message = -20011;
      call permit_signal(v_message, ao_message);
   end if;

    SET v_audit_id =  next_sequence_val('audit_sequence');

   
    
      INSERT into object_link_audit
          ( audit_id, MOD_BY_USERNAME, ACTION_DATE, ACTION_TYPE, OLD_NEW,
           DEPT_ID, D_CODE, OBJECT_TYPE_CODE, OBJECT_CODE)
          SELECT  v_audit_id, v_user, sysdate(), 'D', '<',
            ol.dept_id, d.d_code, ol.object_type_code, ol.object_code
          from  department d LEFT OUTER JOIN object_link ol ON (d.dept_id = ol.dept_id)
          where ol.dept_id = ai_dept_id
          and ol.object_type_code = ai_object_type_code
          and ol.object_code = ai_object_code;
 
   delete from object_link where dept_id = ai_dept_id and
                           object_type_code = ai_object_type_code and
                                object_code = ai_object_code;
 
  SET ao_message = CONCAT('Totally ' ,v_count_link ,'Object link(s) successfully deleted.');

COMMIT;
 
 END $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `mdept$owner`.`is_loop`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `mdept$owner`.`is_loop`( AI_DEPT_ID INTEGER,
                         AI_PARENT_ID  INTEGER) RETURNS varchar(1) CHARSET latin1
BEGIN

  DECLARE is_loop_val VARCHAR(1);
  
  CALL is_loop_proc(AI_DEPT_ID,AI_PARENT_ID, is_loop_val);

  RETURN is_loop_val;
  

 end;

 $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `mdept$owner`.`is_loop_proc`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `mdept$owner`.`is_loop_proc`(IN AI_DEPT_ID INTEGER,
                         IN AI_PARENT_ID  INTEGER,
                         OUT is_loop VARCHAR(1))
BEGIN
  
  DECLARE v_new_child INTEGER;
  DECLARE v_parent_id INTEGER;
  DECLARE done INTEGER DEFAULT 0;


  DECLARE c_get_parent CURSOR  FOR SELECT parent_id from department_child where child_id = ai_parent_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SET v_new_child = ai_dept_id;
  SET is_loop = 'N';

  OPEN c_get_parent;
  
  Fetch c_get_parent INTO v_parent_id;
  WHILE (done > 0) DO
           if v_parent_id = v_new_child then
              SET is_loop =  'Y';
              SET done = 1;
           else
              CALL is_loop_proc(v_new_child, v_parent_id,is_loop);
              if (is_loop = 'Y') then
                set done = 1;
              end if;
           end if;
           if (done = 0) then
           	Fetch c_get_parent INTO v_parent_id;
           end if;
    END WHILE;
    close c_get_parent;
    
  
  end $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `mdept$owner`.`next_sequence_val`$$
CREATE DEFINER=`mdept$owner`@`%` FUNCTION  `mdept$owner`.`next_sequence_val`(seq_name char(255) ) RETURNS bigint(20) unsigned
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

DROP PROCEDURE IF EXISTS `mdept$owner`.`permit_signal`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `mdept$owner`.`permit_signal`(error_code INTEGER, error_text VARCHAR(255))
BEGIN

SET @sql = CONCAT('UPDATE `',error_text,'`SET x=1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
END $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `mdept$owner`.`PUT_LINE`$$
CREATE DEFINER=`mdept$owner`@`%` FUNCTION  `mdept$owner`.`PUT_LINE`(  message     VARCHAR(255)) RETURNS varchar(255) CHARSET latin1
BEGIN

IF (message is null) THEN
  SET message = CONCAT (' Unknown error ', message);
END IF;

INSERT INTO  DBMS_OUTPUT.log  (message) VALUES(message);
RETURN message;

END;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `mdept$owner`.`translate`$$
CREATE DEFINER=`rolesbb`@`%` FUNCTION  `mdept$owner`.`translate`(
   V_STR VARCHAR(255),
   V_ORIG VARCHAR(100),
   V_REPL VARCHAR(100)) RETURNS varchar(255) CHARSET latin1
BEGIN
  DECLARE i INTEGER;
  DECLARE p_WHAT VARCHAR(255);

   SET p_WHAT = V_STR;
  SET i = LENGTH(V_ORIG);
  WHILE i > 0 DO
    SET p_WHAT = REPLACE(p_WHAT, SUBSTR(V_ORIG, i, 1), SUBSTR(V_REPL, i, 1));
    SET i = i - 1;
  END WHILE;

  RETURN p_WHAT;
END;

 $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `mdept$owner`.`update_dept`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `mdept$owner`.`update_dept`(IN AI_FOR_USER        VARCHAR(20),
           IN AI_D_CODE          VARCHAR(15),
           IN AI_SHORT_NAME      VARCHAR(25),
           IN AI_LONG_NAME       VARCHAR(70),
           IN AI_DEPT_TYPE_ID    INTEGER,
           IN AI_VIEW_SUBTYPE_ID INTEGER,
           IN AI_DEPT_ID         INTEGER,
           OUT AO_MESSAGE        VARCHAR(255))
BEGIN

 DECLARE v_user  varchar(20);
 DECLARE v_dept_type_id_count   INTEGER DEFAULT 0;
 DECLARE v_count INTEGER DEFAULT 0 ;
 DECLARE v_count_id INTEGER DEFAULT 0;
 DECLARE v_d_code VARCHAR(15);
 DECLARE v_dept_type_id INTEGER;
 DECLARE v_audit_id INTEGER ;
 DECLARE v_audit_date date;
 DECLARE v_msg_no INTEGER DEFAULT -20090;

  DECLARE EXIT HANDLER FOR NOT FOUND
   BEGIN
                rollback;
        SET ao_message = 'Error: Not able to get the next dept_id from sequence';
        SET v_msg_no = -20081;
        call permit_signal(v_msg_no, ao_message);
  END;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
   BEGIN
           rollback;
           call permit_signal( v_msg_no, ao_message);
  END;


  start transaction;

  SET ao_message = ' SQL Error ';


  if (ai_for_user is null) then
     SET v_user = USER() ;
   else
    SET v_user = ai_for_user;

   end if;
   SET v_user = UPPER(v_user);

    if can_maintain_dept(v_user, 1) = 'N' then
        SET ao_message = 'Error: the user does not have the authorization to maintain dept.';
        SET v_msg_no = -20060;
        call permit_signal(v_msg_no, ao_message);
   end if;

   if ai_d_code is null  then
     SET ao_message = 'Error: d_code can not be null.';
        SET v_msg_no = -20054;
        call permit_signal(v_msg_no, ao_message);
    end if;

    if ai_short_name is null  then
     SET ao_message = 'Error: dept_short_name can not be null.';
        SET v_msg_no = -20052;
        call permit_signal(v_msg_no, ao_message);
   end if;

   if ai_long_name is null  then
     SET ao_message = 'Error: dept_long_name cannot  be null.';
        SET v_msg_no = -20053;
        call permit_signal(v_msg_no, ao_message);
   end if;

   if ai_dept_type_id is null  then
     SET ao_message = 'Error: dept_type_id  can not be null.';
        SET v_msg_no = -20055;
        call permit_signal(v_msg_no, ao_message);
   end if;

   SET v_d_code = upper (ai_d_code);
   if substring(v_d_code, 1, 2) != 'D_' then
     SET ao_message = 'Error: dept_code must start with D_.';
        SET v_msg_no = -20030;
        call permit_signal(v_msg_no, ao_message);
   end if;

   if length(v_d_code) > 15 then
    SET ao_message = 'Error: d_code is longer than 15 characters.';
        SET v_msg_no = -20020;
        call permit_signal(v_msg_no, ao_message);
   end if;

  if (length(ai_short_name) > 25 ) then
     SET ao_message = 'Error: dept_short_name is longer than 20 characters.';
        SET v_msg_no = -20022;
        call permit_signal(v_msg_no, ao_message);
    end if;

  if (length(ai_long_name) > 70 ) then
     SET ao_message = 'Error: dept_long_name is longer than 70 characters.';
        SET v_msg_no = -20023;
        call permit_signal(v_msg_no, ao_message);
   end if;

   
     select count(*) into v_dept_type_id_count from dept_node_type
                     where dept_type_id = ai_dept_type_id;
     if v_dept_type_id_count = 0 then
       SET ao_message = CONCAT('Error: Dept_type_id ''' , ai_dept_type_id
                      , ''' does not exist.');
        SET v_msg_no = -20015;
        call permit_signal(v_msg_no, ao_message);
     end if;

   
   select count(view_subtype_id) into v_count_id from view_subtype
                where view_subtype_id = ai_view_subtype_id;
   if (v_count_id = 0) then
         SET ao_message = CONCAT('Error: view_subtype_id ''' , ai_view_subtype_id , ''' does not exist.');
        SET v_msg_no = -20012;
        call permit_signal(v_msg_no, ao_message);
   end if;

   
  select count(d_code) into v_count_id from department
  where d_code = ai_d_code
  and DEPT_ID <> ai_dept_id;
  if (v_count_id <> 0) then
         SET ao_message = CONCAT('Error: D_code of ',ai_d_code,' has to be unique');
        SET v_msg_no = -20014;
        call permit_signal(v_msg_no, ao_message);
  end if;

  select sysdate() into v_audit_date from dual;
   SET  v_audit_id = next_sequence_val('audit_sequence') ;

  
   INSERT into department_audit
          ( audit_id,MOD_BY_USERNAME, ACTION_DATE, ACTION_TYPE, OLD_NEW,
           DEPT_ID, D_CODE, SHORT_NAME, LONG_NAME, DEPT_TYPE_ID,
           DEPT_TYPE_DESC, CREATE_DATE, CREATE_BY, MODIFIED_DATE, MODIFIED_BY)
          SELECT v_audit_id,ai_for_user, v_audit_date, 'U', '<',
            d.dept_id, d.d_code, d.short_name, d.long_name, d.dept_type_id,
            nt.dept_type_desc, d.create_date, d.create_by, d.modified_date,
            d.modified_by
        from dept_node_type nt left outer join  department d ON (nt.dept_type_id = d.dept_type_id)
        where dept_id = ai_dept_id;


  
  update department set
         d_code = v_d_code,
         short_name = ai_short_name,
         long_name = ai_long_name,
         dept_type_id = ai_dept_type_id,
         modified_date = v_audit_date,
         modified_by = v_user
    where
      dept_id = ai_dept_id;



  
  
    INSERT into department_audit
          (AUDIT_ID, MOD_BY_USERNAME, ACTION_DATE, ACTION_TYPE, OLD_NEW,
           DEPT_ID, D_CODE, SHORT_NAME, LONG_NAME, DEPT_TYPE_ID,
           DEPT_TYPE_DESC, CREATE_DATE, CREATE_BY, MODIFIED_DATE, MODIFIED_BY)
          SELECT v_audit_id, ai_for_user, v_audit_date, 'U', '>',
            d.dept_id, d.d_code, d.short_name, d.long_name, d.dept_type_id,
            nt.dept_type_desc, d.create_date, d.create_by, d.modified_date,
            d.modified_by
        from dept_node_type nt left outer join  department d ON (nt.dept_type_id = d.dept_type_id)
        where dept_id = ai_dept_id;

    SET ao_message = CONCAT('Dept ',ai_dept_id,' successfully updated');

    COMMIT;

 END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `mdept$owner`.`update_dept_parent`$$
CREATE DEFINER=`rolesbb`@`%` PROCEDURE  `mdept$owner`.`update_dept_parent`(IN  AI_FOR_USER           VARCHAR(20),
                    IN  AI_DEPT_ID            INTEGER,
                    IN  AI_OLD_SUBTYPE_ID    INTEGER,
                    IN  AI_NEW_SUBTYPE_ID    INTEGER,
                    IN  AI_OLD_PARENT_ID      INTEGER,
                    IN  AI_NEW_PARENT_ID      INTEGER,
                    OUT AO_MESSAGE            VARCHAR(255))
BEGIN
 
 DECLARE v_user  varchar(20);
 DECLARE v_dept_id_count   INTEGER DEFAULT 0;
 DECLARE v_view_subtype_id_count INTEGER DEFAULT 0;
 DECLARE v_parent_id_count   INTEGER DEFAULT 0;
 DECLARE v_count  INTEGER DEFAULT 0;
 DECLARE v_audit_id INTEGER;
 DECLARE v_audit_date date;
 DECLARE v_msg_no INTEGER DEFAULT -20090;

 DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
                  rollback;
                  call permit_signal( v_msg_no, ao_message);
   END;

    start transaction;

  SET ao_message = ' SQL Exception';
  if (ai_for_user is null) then
     SET v_user = USER() ;
   else
    SET v_user = ai_for_user;

   end if;
   SET v_user = upper(v_user);
   
  
   if ai_dept_id is null  then
      SET ao_message = 'Error: dept_id can not be null.';
      SET v_msg_no = -20051;
      call permit_signal ( v_msg_no, ao_message );
   end if;
 
   select count(*) into v_dept_id_count from department
                   where dept_id = ai_dept_id;
   if v_dept_id_count = 0 then
      SET ao_message = CONCAT('Dept_id ''' , ai_dept_id , ''' does not exist.');
       SET v_msg_no = -20010;
      call permit_signal ( v_msg_no, ao_message );
   end if;

   if can_maintain_dept(v_user, ai_dept_id) = 'N' then
      SET ao_message =
       'Error: User is not authorized to maintain the dept. hierarchy';
       SET v_msg_no = -20060;
      call permit_signal ( v_msg_no, ao_message );
   end if;

   
   if ai_old_parent_id is null  then
      SET ao_message = 'Error: the input old_parent_id  can not be null.';
       SET v_msg_no = -20058;
      call permit_signal ( v_msg_no, ao_message );
   end if;

   if ai_new_parent_id is null  then
      SET ao_message = 'Error: the input new_parent_id  can not be null.';
       SET v_msg_no = -20059;
      call permit_signal ( v_msg_no, ao_message );
   end if;

   if ai_old_subtype_id is null  then
      SET ao_message = 'Error: old view_subtype_id can not be null.';
       SET v_msg_no = -20055;
      call permit_signal ( v_msg_no, ao_message );
   end if;

   if ai_new_subtype_id is null  then
      SET ao_message = 'Error: new view_subtype_id can not be null.';
       SET v_msg_no = -20056;
      call permit_signal ( v_msg_no, ao_message );
   end if;

   select count(*) into v_view_subtype_id_count from view_subtype
                    where view_subtype_id = ai_old_subtype_id;
   if v_view_subtype_id_count = 0 then
      SET ao_message = CONCAT('Old View_subtype_id ''' ,ai_old_subtype_id
                     , ''' does not exist.');
       SET v_msg_no = -20012;
      call permit_signal ( v_msg_no, ao_message );
   end if;

   select count(*) into v_view_subtype_id_count from view_subtype
                    where view_subtype_id = ai_new_subtype_id;
   if v_view_subtype_id_count = 0 then
      SET ao_message = CONCAT('New View_subtype_id ''' , ai_new_subtype_id
                     , ''' does not exist.');
       SET v_msg_no = -20013;
      call permit_signal ( v_msg_no, ao_message );
   end if;


    select count(*) into v_parent_id_count from department
                    where dept_id = ai_new_parent_id;
    if v_parent_id_count = 0 then
       SET ao_message = CONCAT('Dept_id ''' , ai_new_parent_id , ''' does not exist.');
       SET v_msg_no = -20011;
       call permit_signal ( v_msg_no, ao_message );
    end if;

    

    if ai_old_subtype_id = ai_new_subtype_id then
       select count(*) into v_parent_id_count from department
              where dept_id = ai_old_parent_id;
       if v_parent_id_count = 0 then
          SET ao_message = CONCAT('Dept_id ''' , ai_old_parent_id
                        , ''' does not exist.');
       SET v_msg_no = -20011;
       call permit_signal ( v_msg_no, ao_message );
       end if;
    end if;

    
    select count(*) into v_count from department_child where
                    parent_id = ai_new_parent_id and
                    child_id = ai_dept_id and
                    view_subtype_id = ai_new_subtype_id;
    if v_count > 0 then
       SET ao_message = CONCAT('Error: Parent-child relationship already exists for ('''
                      , ai_new_parent_id , ''','''
                      , ai_dept_id, ''')');
       SET v_msg_no = -20092;
       call permit_signal ( v_msg_no, ao_message );
    end if;

    
    if (ai_new_parent_id = ai_dept_id) then
        SET ao_message = 'Error: Parent dept cannot equal child dept';
       SET v_msg_no = -20093;
       call permit_signal ( v_msg_no, ao_message );
    end if;

    
    if is_loop(ai_dept_id, ai_new_parent_id) = 'Y' then
       SET ao_message
       = CONCAT('Error: the requested parent/child relationship would make the child'
                      , ' node an ancestor of itself.');
       SET v_msg_no = -20068;
       call permit_signal ( v_msg_no, ao_message );
    end if;

    
      select count(*) into v_count from department_child
         where child_id = ai_dept_id
         and view_subtype_id = ai_new_subtype_id
         and parent_id <> ai_old_parent_id;
      if v_count <> 0 then
       SET ao_message = CONCAT('Error: for the same view_subtype_id,' ,
                     'a child cannot have more than one parent ');
       SET v_msg_no = -20098;
       call permit_signal ( v_msg_no, ao_message );
      end if;

    
    
      select sysdate() into v_audit_date from dual;

      SET  v_audit_id = next_sequence_val('audit_sequence') ;


    INSERT into dept_child_audit
          (AUDIT_ID, MOD_BY_USERNAME, ACTION_DATE, ACTION_TYPE,
           OLD_NEW,
           PARENT_ID, PARENT_D_CODE, VIEW_SUBTYPE_ID, CHILD_ID,
           CHILD_D_CODE, CREATED_BY, START_DATE, END_DATE)
          SELECT v_audit_id, v_user, v_audit_date, 'U', '<',
            dc.parent_id, d1.d_code, dc.view_subtype_id, dc.child_id,
            d2.d_code, dc.created_by, dc.start_date, dc.end_date
          from department_child dc LEFT OUTER JOIN department d1 ON (d1.dept_id = dc.parent_id)
          	LEFT OUTER JOIN  department d2 ON (d2.dept_id = dc.child_id)
          where dc.child_id = ai_dept_id
          and dc.parent_id = ai_old_parent_id;




     update department_child set parent_id = ai_new_parent_id,
                            view_subtype_id = ai_new_subtype_id,
                                 created_by = v_user,
                                 start_date = sysdate()
                       where child_id = ai_dept_id
                       and parent_id = ai_old_parent_id
                      and view_subtype_id = ai_old_subtype_id;

    
      INSERT into dept_child_audit
          (audit_id, MOD_BY_USERNAME, ACTION_DATE, ACTION_TYPE,
           OLD_NEW,
           PARENT_ID, PARENT_D_CODE, VIEW_SUBTYPE_ID, CHILD_ID,
           CHILD_D_CODE, CREATED_BY, START_DATE, END_DATE)
          SELECT  v_audit_id, v_user, v_audit_date, 'U', '>',
            dc.parent_id, d1.d_code, dc.view_subtype_id, dc.child_id,
            d2.d_code, dc.created_by, dc.start_date, dc.end_date
          from department_child dc LEFT OUTER JOIN department d1 ON (d1.dept_id = dc.parent_id)
          	LEFT OUTER JOIN  department d2 ON (d2.dept_id = dc.child_id)
          where dc.child_id = ai_dept_id
          and dc.parent_id = ai_new_parent_id;

      SET ao_message = CONCAT('For dept. ' , ai_dept_id ,
                     ', parent_id was changed from '
                     ,ai_old_parent_id , ' to ' ,
                     ai_new_parent_id , '.');


      COMMIT;

 END $$

DELIMITER ;