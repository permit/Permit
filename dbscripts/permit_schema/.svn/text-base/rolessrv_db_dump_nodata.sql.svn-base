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

-- MySQL dump 10.13  Distrib 5.4.1-beta, for unknown-linux-gnu (x86_64)
--
-- Host: localhost    Database: rolessrv
-- ------------------------------------------------------
-- Server version	5.4.1-beta

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `_array_contents`
--

DROP TABLE IF EXISTS `_array_contents`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `_array_contents` (
  `array_id` int(11) NOT NULL,
  `array_key` varchar(50) DEFAULT NULL,
  `array_index` int(11) NOT NULL,
  `array_value` text,
  PRIMARY KEY (`array_id`,`array_index`),
  UNIQUE KEY `array_id` (`array_id`,`array_key`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `_arrays`
--

DROP TABLE IF EXISTS `_arrays`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `_arrays` (
  `array_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 NOT NULL,
  `array_name` varchar(50) NOT NULL,
  `array_size` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`array_id`),
  UNIQUE KEY `username` (`username`,`array_name`)
) ENGINE=MyISAM AUTO_INCREMENT=123 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `_globals`
--

DROP TABLE IF EXISTS `_globals`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `_globals` (
  `user_name` varchar(50) NOT NULL,
  `var_name` varchar(50) NOT NULL,
  `the_value` text,
  `TS` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_name`,`var_name`),
  KEY `var_name` (`var_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `_modules`
--

DROP TABLE IF EXISTS `_modules`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `_modules` (
  `module_code` varchar(10) NOT NULL,
  `module_name` varchar(50) NOT NULL,
  `module_version` varchar(10) NOT NULL DEFAULT '1.0',
  PRIMARY KEY (`module_code`),
  UNIQUE KEY `module_name` (`module_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `_routine_parameters`
--

DROP TABLE IF EXISTS `_routine_parameters`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `_routine_parameters` (
  `routine_id` int(11) NOT NULL,
  `parameter_name` varchar(50) NOT NULL,
  `parameter_type` varchar(50) NOT NULL,
  `parameter_sequence` int(11) NOT NULL,
  PRIMARY KEY (`routine_id`,`parameter_name`,`parameter_sequence`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `_routine_syntax`
--

DROP TABLE IF EXISTS `_routine_syntax`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `_routine_syntax` (
  `routine_id` int(11) NOT NULL AUTO_INCREMENT,
  `routine_schema` varchar(50) NOT NULL,
  `routine_name` varchar(50) NOT NULL,
  `routine_type` enum('function','procedure') NOT NULL DEFAULT 'function',
  `routine_complete_name` varchar(100) NOT NULL DEFAULT '',
  `routine_description` text NOT NULL,
  `user_variables` text,
  `other_variables` text,
  `return_value` varchar(50) DEFAULT NULL,
  `see_also` text,
  `module_code` varchar(10) NOT NULL,
  PRIMARY KEY (`routine_id`),
  UNIQUE KEY `routine_schema` (`routine_schema`,`routine_name`,`routine_type`)
) ENGINE=MyISAM AUTO_INCREMENT=106 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `_test_results`
--

DROP TABLE IF EXISTS `_test_results`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `_test_results` (
  `num` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(200) NOT NULL,
  `result` text,
  `expected` text,
  `outcome` tinyint(1) DEFAULT '0',
  `TS` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`num`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `temp_criteria`
--

DROP TABLE IF EXISTS `temp_criteria`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `temp_criteria` (
  `key` int(10) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `seq` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL,
  `value` varchar(255) NOT NULL,
  `query_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `test_outcome`
--

DROP TABLE IF EXISTS `test_outcome`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `test_outcome` (
  `test no` int(11) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `result` text,
  `expected` text,
  `outcome` varchar(10) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'rolessrv'
--
/*!50003 DROP FUNCTION IF EXISTS `arrays_available` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `arrays_available`( ) RETURNS tinyint(1)
    READS SQL DATA
begin
    return 
        (select count(*) from information_schema.tables
        where table_schema=database() and table_name = '_arrays') 
        and
        (select count(*) from information_schema.tables
        where table_schema=database() and table_name = '_array_contents') ;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_append` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_append`(
    p_base_array_name     varchar(50),
    p_second_array_name varchar(50)
) RETURNS varchar(50) CHARSET latin1
    MODIFIES SQL DATA
begin
   return array_copy_complete(p_second_array_name, p_base_array_name, 'use_second', false,null,null);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_clear` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_clear`(
    p_array_name varchar(50)
) RETURNS int(11)
    MODIFIES SQL DATA
begin
    declare array_code int;

    set array_code = (select array_id from _arrays where array_name = p_array_name and username=library_user());
    if (array_code is null) then
        return 0;
    end if;
    delete from _array_contents where array_id = array_code;
    update _arrays set array_size=0 where array_id=array_code;
    return 1;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_copy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_copy`(
    p_array_name     varchar(50),
    p_new_array_name varchar(50)
) RETURNS varchar(50) CHARSET latin1
    MODIFIES SQL DATA
begin
   return array_copy_complete(p_array_name, p_new_array_name, 'use_second', true, null,null);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_copy_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_copy_complete`(
    p_array_name     varchar(50),
    p_new_array_name varchar(50),
    on_key_conflict  enum("use_first", "use_second"),
    drop_new         boolean,
    key_regexp       varchar(100),
    value_regexp     varchar(100)
) RETURNS varchar(50) CHARSET latin1
    MODIFIES SQL DATA
begin
    declare done boolean default false;
    declare a_key varchar(50);
    declare a_value2 text;
    declare a_index int;
    declare a_value text;
    declare a_index_delta int;
    declare walk_array cursor for
        select array_index, array_key, array_value
        from _array_contents inner join _arrays using (array_id)
        where array_name = p_array_name and username = library_user()
        order by array_index;
 
    declare continue handler for not found
        set done = true;

    if (p_array_name = p_new_array_name) then
        set @array_error = 'array_copy: source and destination arrays cannot be the same';
        return null;
    end if;
    if (drop_new) then
        call array_create(p_new_array_name,0);
        call array_clear(p_new_array_name);
        set a_index_delta=0;
    else
        set a_index_delta = array_size(p_array_name);
    end if;
    if (key_regexp = '') then
        set key_regexp = null;
    end if;
    if (value_regexp = '') then
        set value_regexp = null;
    end if;

    set done = false; 
    open walk_array;
    WALK:
    loop
        fetch walk_array into a_index, a_key, a_value;
        if (done) then
            leave WALK;
        end if;
        if (a_key is not null) 
        then
            if ((key_regexp is null) or (a_key regexp key_regexp))
               and
               ((value_regexp is null) or (a_value regexp value_regexp))
            then
                if (drop_new = false and on_key_conflict = 'use_second') 
                then
                    call array_set_value_by_key(p_new_array_name, a_key, a_value);
                else
                    set a_value2 = array_get_value_by_key(p_new_array_name, a_key);
                    if (a_value2 is not null) 
                    then
                        call array_set_value_by_key(p_new_array_name, a_key, a_value2);
                    else
                        call array_set_value_by_key(p_new_array_name, a_key, a_value);
                    end if; 
                end if; 
            end if; 
        else
            if    ((value_regexp is null) or (value_regexp ='') or (a_value regexp value_regexp))
            then
                call array_set_value_by_index(p_new_array_name, a_index + a_index_delta, a_value);
            end if;
        end if;
    end loop;              
    return p_new_array_name;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_create` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_create`(
    p_array_name varchar(50),
    p_array_size int
) RETURNS int(11)
    MODIFIES SQL DATA
begin
    declare array_code int;
    declare counter    int;
    if ( p_array_name regexp '^[0-9]+$' ) then
        set @array_error = 'array name cannot be made of all digits';
        return 0;
    end if;
    set array_code = array_get_or_create_id(p_array_name);
    delete from _array_contents where array_id = array_code;
    set counter = 0;
    while counter < p_array_size do
        insert into _array_contents (array_id, array_index) 
            values (array_code, counter) 
            on duplicate key update array_value = array_value;
        set counter = counter + 1;
    end while;    
    update _arrays set array_size= 
        (select count(*) from _array_contents  where _array_contents.array_id = array_code)
    where _arrays.array_id = array_code;
    return array_code;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_drop` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_drop`(
    p_array_name varchar(50)
) RETURNS int(11)
    MODIFIES SQL DATA
begin
    if ( array_clear(p_array_name)) then
        delete from _arrays where array_name = p_array_name and username = library_user();
        return 1;
    end if;
    return 0;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_exists` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_exists`( p_array_name varchar(50) ) RETURNS tinyint(1)
    READS SQL DATA
begin
    return 
        
        
        (select count(*) from _arrays
        where array_name = p_array_name and username = library_user()) ;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_from_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_from_list`(
    p_list        text,
    p_array_name  varchar(50)
) RETURNS varchar(50) CHARSET latin1
    MODIFIES SQL DATA
begin
    return array_from_list_complete(p_list, p_array_name, ',');
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_from_list_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_from_list_complete`(
    p_list        text,
    p_array_name  varchar(50),
    p_separator   varchar(10)
) RETURNS varchar(50) CHARSET latin1
    READS SQL DATA
begin
    declare item varchar(100);
    declare separator_pos int;
    call array_clear(p_array_name);
    PARSE_LIST:
    while length(p_list) > 0 do
        set separator_pos = instr(p_list, p_separator);
        if ( separator_pos = 0) then
            set item = p_list;
            set p_list = '';
        else
            set item = trim(replace(substring(p_list, 1, separator_pos -1),p_separator,''));
            set p_list = substring(p_list, separator_pos + length(p_separator) );
        end if;
        call array_push(p_array_name, item);
    end while;
    return p_array_name;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_from_pair_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_from_pair_list`(
    p_list             text,
    p_array_name       varchar(50)
) RETURNS varchar(50) CHARSET latin1
    MODIFIES SQL DATA
begin
    return array_from_pair_list_complete(p_list, p_array_name, ',', '=>');
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_from_pair_list_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_from_pair_list_complete`(
    p_list             text,
    p_array_name       varchar(50),
    p_list_separator   varchar(10),
    p_pair_separator   varchar(10)
) RETURNS varchar(50) CHARSET latin1
    MODIFIES SQL DATA
begin
    declare item varchar(100);
    declare separator_pos int;
    declare item_key varchar(100);
    declare item_value varchar(100);
    call array_clear(p_array_name);
    PARSE_LIST:
    while length(p_list) > 0 do
        set separator_pos = instr(p_list, p_list_separator);
        if ( separator_pos = 0) then
            set item = p_list;
            set p_list = '';
        else
            set item = trim(replace(substring(p_list, 1, separator_pos -1),p_list_separator,''));
            set p_list = substring(p_list, separator_pos + length(p_list_separator) );
        end if;
        set item_key   = trim(substring_index(item, p_pair_separator,  1));
        set item_value = trim(substring_index(item, p_pair_separator, -1));
        call array_set(p_array_name, item_key, item_value);
    end while;
    return p_array_name;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_get`(
    p_array_name    varchar(50),
    p_array_ndx_key     varchar(50)
) RETURNS text CHARSET latin1
    READS SQL DATA
begin
    if ( p_array_ndx_key regexp '^[0-9]+$' ) then
        return array_get_value_by_index(p_array_name, p_array_ndx_key);
    else
        return array_get_value_by_key(p_array_name, p_array_ndx_key);
    end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_get_key_by_index` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_get_key_by_index`(
    p_array_name    varchar(50),
    p_array_index   int
) RETURNS text CHARSET latin1
    READS SQL DATA
begin
    return (
        select array_key 
        from _array_contents
        inner join _arrays using (array_id)
        where 
            array_name = p_array_name and username= library_user()
            and array_index = p_array_index
    );
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_get_or_create_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_get_or_create_id`(
    p_array_name varchar(50)
) RETURNS int(11)
    MODIFIES SQL DATA
begin
    declare array_code int;
    set array_code = (
        select array_id 
        from _arrays 
        where username = library_user() and array_name = p_array_name
        );
    if ( array_code is null ) then
        insert into _arrays (username, array_name) 
            values ( library_user(), p_array_name );
        select last_insert_id() into array_code;
    end if;
    return array_code;    
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_get_value_by_index` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_get_value_by_index`(
    p_array_name    varchar(50),
    p_array_index   int
) RETURNS text CHARSET latin1
    READS SQL DATA
begin
    return (
        select array_value 
        from _array_contents
        inner join _arrays using (array_id)
        where 
            array_name = p_array_name and username = library_user()
            and array_index = p_array_index
    );
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_get_value_by_key` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_get_value_by_key`(
    p_array_name    varchar(50),
    p_array_key     varchar(50)
) RETURNS text CHARSET latin1
    READS SQL DATA
begin
    return (
        select array_value 
        from 
            _array_contents
            inner join _arrays using (array_id)
        where 
            array_name  = p_array_name and username = library_user()
            and 
            array_key   = p_array_key
    );
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_grep` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_grep`(
    p_array_name     varchar(50),
    p_new_array_name varchar(50),
    value_regexp     varchar(100)
) RETURNS varchar(50) CHARSET latin1
    MODIFIES SQL DATA
begin
   return array_grep_complete(p_array_name, p_new_array_name,null,value_regexp);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_grep_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_grep_complete`(
    p_array_name     varchar(50),
    p_new_array_name varchar(50),
    key_regexp       varchar(100),
    value_regexp     varchar(100)
) RETURNS varchar(50) CHARSET latin1
    MODIFIES SQL DATA
begin
   return array_copy_complete(p_array_name, p_new_array_name, 'use_second', true, key_regexp,value_regexp);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_max_index` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_max_index`( p_array_name varchar(50) ) RETURNS int(11)
    READS SQL DATA
begin
    declare asize int;
    set asize = (select array_size from _arrays where array_name = p_array_name and username=library_user());
    if (asize is null) then
        return null;
    else
        return if(asize > 0, asize -1, null);
    end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_merge` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_merge`(
    p_first_array_name     varchar(50),
    p_second_array_name    varchar(50),
    p_new_array_name       varchar(50)
) RETURNS varchar(50) CHARSET latin1
    MODIFIES SQL DATA
begin
    return array_merge_complete(
        p_first_array_name, 
        p_second_array_name, 
        p_new_array_name,
        'use_first');
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_merge_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_merge_complete`(
    p_first_array_name     varchar(50),
    p_second_array_name    varchar(50),
    p_new_array_name       varchar(50),
    on_key_conflict        enum("use_first", "use_second")
) RETURNS varchar(50) CHARSET latin1
    MODIFIES SQL DATA
begin
    set p_new_array_name = array_copy(p_first_array_name, p_new_array_name);
    if (p_new_array_name is null) then
        return null;
    end if;
    set p_new_array_name = array_copy_complete(p_second_array_name, p_new_array_name,on_key_conflict, false,null,null);
    if (p_new_array_name is null) then
        return null;
    end if;
    return p_new_array_name;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_pop` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_pop`(
    p_array_name    varchar(50)
) RETURNS text CHARSET latin1
    MODIFIES SQL DATA
begin
    declare array_code int;
    declare highest_index int;
    declare avalue  text;
    
    
    

    if ( p_array_name regexp '^[0-9]+$' ) then
        set array_code = p_array_name;
    else
        set array_code = array_get_or_create_id(p_array_name);
    end if;

    set highest_index = (select max(array_index) from _array_contents
         where array_id = array_code);
    
    if (highest_index is null) then
         return null;
    else
        set avalue = (
                select array_value 
                    from _array_contents 
                    where array_id = array_code and array_index = highest_index
                );
        delete 
            from _array_contents 
            where array_id = array_code and array_index = highest_index;
        update _arrays set array_size = array_size - 1 where array_id = array_code;
        return avalue;
    end if;
   
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_push` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_push`(
    p_array_name    varchar(50),
    p_array_value   text
) RETURNS int(11)
    MODIFIES SQL DATA
begin
    declare array_code int;
    declare highest_index int;
    
    
    

    if ( p_array_name regexp '^[0-9]+$' ) then
        set array_code = p_array_name;
    else
        set array_code = array_get_or_create_id(p_array_name);
    end if;

    set highest_index = (select max(array_index) from _array_contents
         where array_id = array_code);
    
    if (highest_index is null) then
         set highest_index = 0;
    else
         set highest_index = highest_index + 1;
    end if;
    
    return array_set_value_by_index( array_code , highest_index, p_array_value);
   
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_set` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_set`(
    p_array_name  varchar(50),
    p_array_ndx_key varchar(50),
    p_array_value text
) RETURNS int(11)
    MODIFIES SQL DATA
begin
    if (p_array_ndx_key regexp '^[0-9]+$') then
        return array_set_value_by_index(
            p_array_name, p_array_ndx_key, p_array_value);
    else
        return array_set_value_by_key(
            p_array_name, p_array_ndx_key, p_array_value);
    end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_setn` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_setn`(
    p_array_name  varchar(50),
    p_array_ndx_key varchar(50),
    p_array_value text
) RETURNS varchar(50) CHARSET latin1
    MODIFIES SQL DATA
begin
    if (p_array_ndx_key regexp '^[0-9]+$') then
        call array_set_value_by_index(
            p_array_name, p_array_ndx_key, p_array_value);
    else
        call array_set_value_by_key(
            p_array_name, p_array_ndx_key, p_array_value);
    end if;
    return p_array_name;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_set_key_by_index` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_set_key_by_index`(
    p_array_name  varchar(50),
    p_array_index int,
    p_array_key   varchar(50)
) RETURNS int(11)
    MODIFIES SQL DATA
begin
    declare array_code int;
    
    
    
    
    if ( p_array_name regexp '^[0-9]+$' ) then
        set array_code = p_array_name ;
    else
        set array_code = array_get_or_create_id(p_array_name);
    end if;

    insert into _array_contents set 
        array_id    = array_code,
        array_key   = p_array_key,
        array_index = p_array_index
        on duplicate key update array_key = p_array_key;
    return 1;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_set_value_by_index` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_set_value_by_index`(
    p_array_name  varchar(50),
    p_array_index int,
    p_array_value text
) RETURNS int(11)
    MODIFIES SQL DATA
begin
    declare array_code int;
    declare new_array_size int;
    
    
    
    
    if ( p_array_name regexp '^[0-9]+$' ) then
        set array_code = p_array_name ;
    else
        set array_code = array_get_or_create_id(p_array_name);
    end if;

    insert into _array_contents set 
        array_id    = array_code,
        array_value = p_array_value,
        array_index = p_array_index
        on duplicate key update array_value = p_array_value;
    set new_array_size = (select count(*) from _array_contents where array_id=array_code);
        update _arrays set array_size = new_array_size where array_id = array_code;
    return new_array_size;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_set_value_by_key` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_set_value_by_key`(
    p_array_name  varchar(50),
    p_array_key   varchar(50),
    p_array_value text
) RETURNS int(11)
    MODIFIES SQL DATA
begin
    declare array_code int;
    declare highest_index int;
    declare index_of_existing_key int;

    
    
    

    if ( p_array_name regexp '^[0-9]+$' ) then
        set array_code = p_array_name;
    else
        set array_code = array_get_or_create_id(p_array_name);
    end if;

    set index_of_existing_key = (select array_index from _array_contents
        where array_id = array_code and array_key = p_array_key);

    if ( index_of_existing_key is null ) then

        set highest_index = (select max(array_index) from _array_contents
            where array_id = array_code);
    
        if (highest_index is null) then
            set highest_index = 0;
        else
            set highest_index = highest_index + 1;
        end if;

        insert into _array_contents set 
            array_id    = array_code,
            array_value = p_array_value,
            array_index = highest_index,
            array_key   = p_array_key ;
        update _arrays set array_size = array_size+1 where array_id = array_code;
    else
        update _array_contents
            set array_value = p_array_value
            where 
                array_id = array_code
                and
                array_index = index_of_existing_key;
    end if;  
    return array_size(p_array_name);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_shift` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_shift`(
    p_array_name    varchar(50)
) RETURNS text CHARSET latin1
    MODIFIES SQL DATA
begin
    declare array_code int;
    declare ret_value text;
    if ( p_array_name regexp '^[0-9]+$' ) then
        set array_code = p_array_name;
    else
        set array_code = array_get_or_create_id(p_array_name);
    end if;
    set ret_value = (
        select array_value from _array_contents 
            where array_id = array_code
                  and array_index = 0);
    delete from  _array_contents 
            where array_id = array_code
                  and array_index = 0;
    update _array_contents set array_index = array_index -1
            where array_id = array_code
            order by array_index ASC;
    update _arrays set array_size = array_size - 1 where array_id = array_code;
    return ret_value;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_size` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_size`( p_array_name varchar(50) ) RETURNS int(11)
    READS SQL DATA
begin
    return (select array_size from _arrays where array_name = p_array_name and username=library_user());
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_sort` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_sort`(
    p_array_name     varchar(50),
    p_new_array_name varchar(50)
) RETURNS varchar(50) CHARSET latin1
    MODIFIES SQL DATA
begin
    return array_sort_complete(p_array_name, p_new_array_name, 'VK', 'asc');
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_sort_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_sort_complete`(
    p_array_name     varchar(50),
    p_new_array_name varchar(50),
    order_by         enum("K","V","VN","VK"),
    order_direction  enum("asc", "desc")
) RETURNS varchar(50) CHARSET latin1
    MODIFIES SQL DATA
begin
    declare counter int default 0;
    declare done boolean default false;
    declare a_key varchar(50);
    declare a_value text;
    declare walk_array_asc cursor for
        select array_key, array_value
        from _array_contents inner join _arrays using (array_id)
        where array_name = p_array_name and username = library_user()
        order by 
            case order_by
                when 'K'  then array_key
                when 'V'  then array_value
                when 'VN' then lpad(array_value,20,'0')
                when 'VK' then concat(array_value,coalesce(array_key,''))
            else 1
            end ASC;
    declare walk_array_desc cursor for
        select array_key, array_value
        from _array_contents inner join _arrays using (array_id)
        where array_name = p_array_name and username = library_user()
        order by 
            case order_by
                when 'K'  then array_key
                when 'V'  then array_value
                when 'VN' then lpad(array_value,20,'0')
                when 'VK' then concat(array_value,coalesce(array_key,''))
            else 1
            end DESC;
 
    declare continue handler for not found
        set done = true;

    if (p_array_name = p_new_array_name) then
        set @array_error = 'array_sort: source and destination arrays cannot be the same';
        return null;
    end if;
    call array_create(p_new_array_name,0);
    call array_clear(p_new_array_name);
    
    set done = false; 
    if (order_direction = 'desc') then
        open walk_array_desc;
    else
        open walk_array_asc;
    end if;
    WALK:
    loop
        if (order_direction = 'desc') then
            fetch walk_array_desc into a_key, a_value;
        else
            fetch walk_array_asc into a_key, a_value;
        end if;
        if (done) then
            leave WALK;
        end if;
        call array_push(p_new_array_name, a_value);
        call array_set_key_by_index(p_new_array_name, counter, a_key);
        set counter = counter + 1;
    end loop;              
    return p_new_array_name;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_temp_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_temp_name`() RETURNS varchar(50) CHARSET latin1
    READS SQL DATA
begin
    return concat('_sp', 
        date_format(now(),"%d%H%i%s"), 
        floor(rand() * 10000000) );
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_to_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_to_list`(
    p_array_name  varchar(50)
) RETURNS text CHARSET latin1
    READS SQL DATA
begin
    return array_to_list_complete(p_array_name,',');
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_to_list_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_to_list_complete`(
    p_array_name  varchar(50),
    p_separator   varchar(10)
) RETURNS text CHARSET latin1
    READS SQL DATA
begin
    declare templist text;
    declare first_loop boolean default true;
    declare counter int;
    set counter = 0;
    set templist='';
    while counter < array_size(p_array_name) do
        if (first_loop) then
            set first_loop = false;
        else
            set templist = concat(templist, p_separator);
        end if;
        set templist = concat(templist, array_get_value_by_index(p_array_name, counter));
        set counter = counter + 1;
    end while;
    return templist;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_to_pair_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_to_pair_list`(
    p_array_name       varchar(50)
) RETURNS text CHARSET latin1
    READS SQL DATA
begin
    return array_to_pair_list_complete(p_array_name, ',','=>');
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_to_pair_list_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_to_pair_list_complete`(
    p_array_name       varchar(50),
    p_list_separator   varchar(10),
    p_pair_separator   varchar(10)
) RETURNS text CHARSET latin1
    READS SQL DATA
begin
    declare templist text;
    declare first_loop boolean default true;
    declare counter int;
    set counter = 0;
    set templist='';
    while counter < array_size(p_array_name) do
        if (first_loop) then
            set first_loop = false;
        else
            set templist = concat(templist, p_list_separator);
        end if;
        set templist = concat(templist,  
                            array_get_key_by_index(p_array_name, counter),
                            p_pair_separator, 
                            coalesce(array_get_value_by_index(p_array_name, counter),'') );
        set counter = counter + 1;
    end while;
    return templist;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_unshift` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `array_unshift`(
    p_array_name    varchar(50),
    p_array_value   text
) RETURNS int(11)
    MODIFIES SQL DATA
begin
    declare array_code int;
    if ( p_array_name regexp '^[0-9]+$' ) then
        set array_code = p_array_name;
    else
        set array_code = array_get_or_create_id(p_array_name);
    end if;
    update _array_contents set array_index = array_index + 1
        where array_id = array_code
        order by array_index DESC;
    insert into _array_contents (array_id, array_index, array_value)
        values (array_code, 0, p_array_value);
    update _arrays set array_size = array_size + 1 where array_id = array_code;
    return array_size(p_array_name); 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `array_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `array_user`() RETURNS varchar(50) CHARSET latin1
    READS SQL DATA
begin
        
        
        return substring_index(user(),'@',1);
        
        
        
        
    end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fsyntax` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `fsyntax`(
    p_function_name varchar(50)
) RETURNS text CHARSET latin1
    READS SQL DATA
begin
    return routine_syntax('',p_function_name,'function');
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `function_exists` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `function_exists`(
    p_db_name varchar(50), 
    p_function_name varchar(50)
) RETURNS tinyint(1)
    READS SQL DATA
return routine_exists(p_db_name, p_function_name, 'function') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `function_exists_simple` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `function_exists_simple`(
    p_function_name varchar(50)
) RETURNS tinyint(1)
    READS SQL DATA
return routine_exists_simple( p_function_name, 'function') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetErrorMessage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%` FUNCTION `GetErrorMessage`(message_id  INTEGER) RETURNS varchar(255) CHARSET latin1
BEGIN

  DECLARE service_function_name varchar(30) DEFAULT 'RUN ROLES SERVICE*/ /*!50003 PROCEDURES';
  DECLARE category_crit_id integer DEFAULT 210;
  DECLARE function_name_crit_id integer DEFAULT 215;
  DECLARE kerberos_name_crit_id integer DEFAULT 205;
  DECLARE max_function_category_size integer DEFAULT 4;
  DECLARE max_function_name_size integer DEFAULT 30;
  DECLARE max_qualifier_type_size integer DEFAULT 4;
  DECLARE read_auth_function1 varchar(30) DEFAULT 'VIEW AUTH BY CATEGORY';
  DECLARE read_auth_function2 varchar(30) DEFAULT 'CREATE AUTHORIZATIONS';

 
 IF (message_id = -20003) THEN
  RETURN
    CONCAT('Server ID ''<server_id>'' is not authorized to run Roles DB service'
    , ' procedures for category <function_category>.');
  END IF;


 IF (message_id =  -20005) THEN
  RETURN CONCAT(
 	    'User ''<proxy_user>'' is not authorized to look up authorizations'
	    , ' in category ''<function_category>''.');
 END IF;

 IF (message_id =  -20006) THEN
  RETURN CONCAT(
    'User ''<proxy_user>'' is not authorized to look up authorizations'
    , ' in any category using this server (server ID ''<server_id>'').');
 END IF;

    
  
 IF (message_id =  -200210) THEN
  RETURN  
    'Function ID ''<function_id>'' is not a valid function_id number.';
 END IF;

 IF (message_id =  -200211) THEN
  RETURN
    CONCAT('Function name ''<function_name>'' within category'
    ,' ''<function_category>'' was not found.');
 END IF;   

 IF (message_id =  -200212) THEN
    RETURN 'Function name ''<function_name>'' was not found.';
 END IF;   

 IF (message_id =  -200221) THEN
   RETURN CONCAT( 'Qualifier ID ''<qualifier_id>'' is not a valid qualifier_id number'
    , ' for qualifier_type <qualifier_type>.');
   
 END IF;
 
 IF (message_id =  -200222) THEN
    RETURN CONCAT('Qualifier Code ''<qualifier_code>'' is not a valid qualifier code'
    , ' for qualifier_type <qualifier_type>.');
 END IF; 
 
  
  
 IF (message_id =  -20023) THEN
  RETURN CONCAT(  'Since you have specified <argument_name>, you must also specify '
    , 'either qualifier_type, function_name, or function_id as well.');
 END IF;
 
 
 IF (message_id =  -20024) THEN
  RETURN  CONCAT('Bad argument REAL_OR_IMPLIED: ''<arg_value>''. It must be '
     , '''R'', ''I'', ''B'', or null.');
 END IF;
 
 IF (message_id =  -20027) THEN
  RETURN   CONCAT('If a non-null function_name is specified, then a function_category '
    , 'must be specified as well.');
 END IF;   


 IF (message_id =  -20028) THEN
  RETURN CONCAT(  'Function_category ''<function_category>'' has more than ', CAST(max_function_category_size AS CHAR), ' characters.');
 END IF;

 IF (message_id =  -20029) THEN
   RETURN CONCAT('Function_name ''<function_name>'' has more than ', CAST(max_function_name_size AS CHAR) , ' characters.');
  END IF;


 IF (message_id =  -20030) THEN
   RETURN 'Kerberos name must be specified.';
 END IF;
 
 IF (message_id =  -20031) THEN
   RETURN CONCAT( 'Qualifier type ''<qualifier_type>'' has more than '
    , CAST(max_qualifier_type_size AS CHAR) , ' characters.');
 END IF;

 
 IF (message_id =  -20032) THEN
  RETURN 'Result qualifier ''<qualifier_type>'', ''<qualifier_code>'' for ''<rule_type_code>'' do not match the result function ''<function_name>''.';
 END IF;

 IF (message_id =  -20033) THEN
  RETURN '''<for_user>'' is not authorized to create rules for ''<function_category>''.';
 END IF;

 IF (message_id =  -20034) THEN
  RETURN 'Rule type code ''<rule_type_code>''  is not correct.';
 END IF;


 IF (message_id =  -20035) THEN
  RETURN 'Wrong combination of condition_function_category ''<condition_function_category>'' and condition_function_name ''<condition_function_name>''.';
 END IF;

 IF (message_id =  -20036) THEN
  RETURN 'Wrong combination of condition_qualifier_type ''<condition_qualifier_type>'' and condition_qualifier_code ''<condition_qualifier_code>'' for a condition function ''<function_name>''.';
 END IF;
 
 IF (message_id =  -20037) THEN
  RETURN 'Rule short name ''<rule_short_name>'' is not unique.';
 END IF;
 
 IF (message_id =  -20038) THEN
  RETURN  '''<rule_is_in_effect>'' is not allowed for rule_is_in_effect, must be Y or N.';
 END IF;
 
 IF (message_id =  -20039) THEN
 	RETURN  'Condition object type ''<condition_object_type>'' cannot be used with condition function ''<condition_function_name>'' of category ''<condition_function_category>''.';
 END IF;
 

 IF (message_id =  -20040) THEN
 RETURN 'Condition ''<condition_function_name>'' and result ''<result_function_name>'' for the rule of type ''<rule_type_code>'' must have identical qualifiers !'; 
 END IF;
 
 IF (message_id =  -20041) THEN
 	RETURN 'For the rule ''<rule_type_code>'', result qual type should be a parent of condition qaul type. ''<result_qualifier_type>'' is not a parent of  ''<condition_qualifier_type>'' !';
 END IF;
 
 IF (message_id =  -20042) THEN
  RETURN 'Attempt to create a duplicate to rule ''<rule_id>''.';
 END IF;
 

 IF (message_id =  -20043) THEN
  RETURN 'For the rule ''<rule_type_code>'' condition qualifier code should be NULL, it is ''<condition_qualifier_code>''.';
 END IF;
 
 IF (message_id =  -20044) THEN
  RETURN 'For the rule ''<rule_type_code>'' result qualifier code should be NULL, it is ''<result_qualifier_code>''.';
 END IF;
 
 IF (message_id =  -20045) THEN
  RETURN 'For the rule ''<rule_type_code>'' result qualifier type should be NULL, it is ''<result_qualifier_type>''.';
 END IF;

 IF (message_id =  -20046) THEN
  RETURN 'Wrong category (''<function_category>'') for function ''<function_name>''.';
 END IF;

 IF (message_id =  -20047) THEN
  RETURN 'Condition object type ''<condition_object_type>'' cannot be used with result function ''<result_function_name>'' of category ''<result_function_category>''.'; 
 END IF;

 IF (message_id =  -20048) THEN
  RETURN 'Wrong pass number (''<pass_number>'')  found for the condition function ''<function_name>''.';
 END IF;
 
  IF (message_id =  -20049) THEN
   RETURN  'Wrong pass number (''<pass_number>'') found for the result function ''<function_name>''.';
  END IF;
 
 RETURN 'Unknown Error';

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_sql_fragment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `get_sql_fragment`(ai_proxy_user VARCHAR(20),
     ni_id  integer,
     ai_value VARCHAR(100)) RETURNS varchar(512) CHARSET latin1
BEGIN
 
  DECLARE cond_fragment varchar(512) DEFAULT '';
  DECLARE return_fragment varchar(512) DEFAULT '';
  DECLARE v_value varchar(255);
  DECLARE replace_str varchar(10) DEFAULT '?';
  DECLARE sub_str1 varchar(10) DEFAULT '';
  DECLARE sub_str2 varchar(10) DEFAULT '''';

   SET v_value = ai_value;
   SET v_value = upper(replace(v_value, '<me>', ai_proxy_user));
    SET v_value = upper(replace(v_value, '<ME>', ai_proxy_user));
   select rtrim(ltrim(c.sql_fragment)) into cond_fragment 
     from rolesbb.criteria2 c where c.criteria_id = ni_id;
   if cond_fragment != 'NULL' then
     if instr(cond_fragment, '%?%') > 0 then
         SET replace_str = '%?%';
	 SET sub_str1 = '%';
	 SET sub_str2 = '%''';
     elseif instr(cond_fragment, '?%') > 0 then
	 SET replace_str = '?%';
	 SET sub_str2 = '%''';
     elseif instr(cond_fragment, '?') = 0 then
	return cond_fragment;
     end if;
     SET return_fragment = replace(cond_fragment, replace_str,
                        CONCAT('''' , sub_str1 , v_value , sub_str2));
  end if;
  return return_fragment;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_view_category_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%` FUNCTION `get_view_category_list`(ai_server_user VARCHAR(20),
     ai_proxy_user VARCHAR(20)) RETURNS varchar(2000) CHARSET latin1
BEGIN
  
  DECLARE v_server_user VARCHAR(20);
  DECLARE v_proxy_user VARCHAR(20);
  DECLARE v_function_category VARCHAR(4);
  DECLARE v_count INTEGER DEFAULT 0;
  DECLARE v_category_list varchar(2000);
  DECLARE done INT DEFAULT 0;

  DECLARE service_function_name varchar(30) DEFAULT 'RUN ROLES SERVICE*/ /*!50003 PROCEDURES';


  DECLARE curs_get_cat_list1 CURSOR
   FOR
     SELECT function_category from rolesbb.viewable_category
      where kerberos_name = upper(ai_proxy_user) and rolesbb.rolesapi_is_user_authorized(upper(ai_server_user),
                 service_function_name,
                 CONCAT('CAT' ,rtrim(function_category))) = 'Y';

  DECLARE  curs_get_cat_list2 CURSOR
   FOR
     SELECT function_category from rolesbb.viewable_category
      where kerberos_name = upper(ai_proxy_user);

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SET v_server_user = upper(ai_server_user);
  SET v_proxy_user = upper(ai_proxy_user);

  if ( IFNULL(v_server_user, v_proxy_user) = IFNULL(v_proxy_user, v_server_user) )
  then 
    SET v_proxy_user = IFNULL(v_proxy_user, v_server_user);
    OPEN curs_get_cat_list2;
    REPEAT
      FETCH curs_get_cat_list2 INTO v_function_category;
      IF NOT done THEN
      	if (v_count = 0) then
        	SET v_category_list = CONCAT('''' , v_function_category , '''');
      	else
        	SET v_category_list = CONCAT(v_category_list , ', ''' 
                           , v_function_category , '''');
      	end if;
      END IF;	
      SET v_count = v_count + 1;
    UNTIL done END REPEAT;
    CLOSE curs_get_cat_list2;
  else
    OPEN curs_get_cat_list1;
    REPEAT
      FETCH curs_get_cat_list1 INTO v_function_category;
      IF NOT done THEN
      	if (v_count = 0) then
        	SET v_category_list = CONCAT('''' , v_function_category , '''');
      	else
        	SET v_category_list = CONCAT(v_category_list , ',''' 
                           , v_function_category , '''');
      	end if;
      END IF;	
      SET v_count = v_count + 1;
    UNTIL done END REPEAT;
    CLOSE curs_get_cat_list1;
  end if;
  return v_category_list;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `global_var_drop` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `global_var_drop`(
    p_var_name varchar(50)
) RETURNS tinyint(1)
    MODIFIES SQL DATA
begin
    if (global_var_exists(p_var_name)) then
        delete from _globals where user_name = library_user() and var_name = p_var_name;
        return 1;
    else
        return 0;
    end if ;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `global_var_exists` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `global_var_exists`(
    p_var_name varchar(50)
) RETURNS tinyint(1)
    READS SQL DATA
return coalesce(
    (
    select count(*)
    from _globals 
    where user_name = library_user() and var_name = p_var_name
    ), 0) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `global_var_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `global_var_get`(
    p_var_name varchar(50)
) RETURNS text CHARSET latin1
    READS SQL DATA
begin
    declare return_value text default null;
    select the_value  into return_value
    from _globals 
    where user_name = library_user() and var_name = p_var_name;
    return return_value;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `global_var_set` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `global_var_set`(
    p_var_name varchar(50),
    p_value    text
) RETURNS text CHARSET latin1
    MODIFIES SQL DATA
begin
    insert into _globals (user_name, var_name, the_value)  
        values ( library_user(), p_var_name, p_value)
        on duplicate key update the_value = p_value;
    return p_value;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `is_user_authorized` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%` FUNCTION `is_user_authorized`(ai_server_user  VARCHAR(20),
     ai_proxy_user  VARCHAR(20),
     ai_kerberos_name  VARCHAR(20),
     ai_function_id  VARCHAR(12),
     ai_qualifier_id  VARCHAR(12)) RETURNS varchar(1) CHARSET latin1
BEGIN
  DECLARE v_kerberos_name VARCHAR(20);
  DECLARE v_server_user VARCHAR(20);
  DECLARE v_proxy_user VARCHAR(20);
  DECLARE v_function_id INTEGER;
  DECLARE v_function_category VARCHAR(20);
  DECLARE v_qualifier_type VARCHAR(10);
  DECLARE v_qualifier_id VARCHAR(12);
  DECLARE v_count integer;
  DECLARE v_check_auth varchar(1);
  DECLARE v_error_msg varchar(255);
  DECLARE v_error_no integer;
  DECLARE service_function_name varchar(30) DEFAULT 'RUN ROLES SERVICE*/ /*!50003 PROCEDURES';
  DECLARE read_auth_function1 varchar(30) DEFAULT 'VIEW AUTH BY CATEGORY';
  DECLARE read_auth_function2 varchar(30) DEFAULT 'CREATE AUTHORIZATIONS';
  DECLARE p_function_id INTEGER;

  SET v_kerberos_name = upper(ai_kerberos_name);
  SET v_server_user = upper(ai_server_user);
  SET v_proxy_user = upper(ai_proxy_user);

  
  if (not ai_function_id REGEXP '[0-9]*')
  
  
  then
   
    SET v_error_no = -20021;
    SET v_error_msg = replace(GetErrorMessage(-200211),
                          '<function_id>', ai_function_id);
    call permit_signal(v_error_no, v_error_msg);
  end if;

  
  
  

  select count(*) into v_count from rolesbb.function
     where function_id = ai_function_id;

  if (v_count = 0) then
    SET v_error_no = -20021;
    SET v_error_msg = replace(GetErrorMessage(-200211),
                          '<function_id>', ai_function_id);
    call permit_signal(v_error_no, v_error_msg);
  end if;

    select function_id, function_category, qualifier_type
    into v_function_id, v_function_category, v_qualifier_type
    from rolesbb.function
    where function_id = ai_function_id;

  
  select rolesbb.rolesapi_is_user_authorized(ai_server_user,
           service_function_name,
           CONCAT('CAT' , rtrim(v_function_category)))
         into v_check_auth from dual;
  if (v_check_auth <> 'Y') then
    SET v_error_no = -20003;
    SET v_error_msg = replace(GetErrorMessage(-20003),
                          '<server_id>', ai_server_user);
    SET v_error_msg = replace(v_error_msg, '<function_category>',
                           v_function_category);
    call permit_signal(v_error_no, v_error_msg);
  end if;

  
  if (v_proxy_user = v_server_user) then 
    SET v_check_auth = 'Y';
  elseif (v_proxy_user = v_kerberos_name) then
    SET v_check_auth = 'Y';
  else
    select rolesbb.rolesapi_is_user_authorized(v_proxy_user,
             read_auth_function1,
             CONCAT('CAT' , rtrim(v_function_category)))
           into v_check_auth from dual;
    if (v_check_auth <> 'Y') then
      select rolesbb.rolesapi_is_user_authorized(v_proxy_user,
             read_auth_function2,
             CONCAT('CAT' , rtrim(v_function_category)))
           into v_check_auth from dual;
    end if;
  end if;
  if (v_check_auth <> 'Y') then
    SET v_error_no = -20005;
    SET v_error_msg = GetErrorMessaeg(-20005);
    SET v_error_msg = replace(v_error_msg, '<proxy_user>',
                          v_proxy_user);
    SET v_error_msg = replace(v_error_msg, '<function_category>',
                          v_function_category);
    call permit_signal(v_error_no, v_error_msg);
  end if;

  
  if (not ai_qualifier_id REGEXP '[0-9]*')
   
    
  then
    
    SET v_error_no = -20022;
    SET v_error_msg = GetErrorMessaeg(-200221);
    SET v_error_msg = replace(v_error_msg, '<qualifier_id>',
                          ai_qualifier_id);
    SET v_error_msg = replace(v_error_msg, '<qualifier_type>',
                          v_qualifier_type);
    call permit_signal(v_error_no, v_error_msg);
  end if;

  
  select count(*) into v_count
    from rolesbbqualifier
    where qualifier_type = v_qualifier_type
    and qualifier_id = ai_qualifier_id ;

  if v_count = 0 then
    SET v_error_no = -20022;
    SET v_error_msg = GetErrorMessaeg(-200221);
    SET v_error_msg = replace(v_error_msg, '<qualifier_id>',
                          ai_qualifier_id);
    SET v_error_msg = replace(v_error_msg, '<qualifier_type>',
                          v_qualifier_type);
    call permit_signal(v_error_no, v_error_msg);
  end if;
  


  

  select count(*) into v_count from rolesbb.authorization
    where kerberos_name = v_kerberos_name
    and function_id = v_function_id
    and qualifier_id = ai_qualifier_id
    and do_function = 'Y'
    and SYSDATE() between effective_date and IFNULL(expiration_date, SYSDATE());

  IF v_count > 0 THEN
    RETURN 'Y';
  END IF;

  

  select count(*) into v_count
    from rolesbb.authorization a, rolesbb.qualifier_descendent qd
    where a.kerberos_name = v_kerberos_name
    and a.function_id = v_function_id
    and a.do_function = 'Y'
    and a.descend = 'Y'
    and SYSDATE() between a.effective_date and IFNULL(a.expiration_date, SYSDATE())
    and qd.child_id = v_qualifier_id
    and a.qualifier_id = qd.parent_id;
  IF v_count > 0 THEN
    RETURN 'Y';
  END IF;

  
  RETURN 'N';

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `is_user_authorized2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%` FUNCTION `is_user_authorized2`(ai_server_user VARCHAR(40),
     ai_proxy_user VARCHAR(20),
     ai_kerberos_name VARCHAR(20),
     ai_function_category VARCHAR(8),
     ai_function_name VARCHAR(80),
     ai_qualifier_code VARCHAR(10)) RETURNS varchar(1) CHARSET latin1
BEGIN
  DECLARE v_kerberos_name VARCHAR(20);
  DECLARE v_server_user VARCHAR(20);
  DECLARE v_proxy_user VARCHAR(20);
  DECLARE v_function_id INTEGER;
  DECLARE v_function_category VARCHAR(8);
  DECLARE v_function_name VARCHAR(80);
  DECLARE v_qualifier_type VARCHAR(10);
  DECLARE v_qualifier_code VARCHAR(20);
  DECLARE v_qualifier_id INTEGER;
  DECLARE v_count integer;
  DECLARE v_check_auth varchar(1);
  DECLARE v_error_msg varchar(255);
  DECLARE v_error_no integer;
    DECLARE service_function_name varchar(30) DEFAULT 'RUN ROLES SERVICE*/ /*!50003 PROCEDURES';
    DECLARE read_auth_function1 varchar(30) DEFAULT 'VIEW AUTH BY CATEGORY';
    DECLARE read_auth_function2 varchar(30) DEFAULT 'CREATE AUTHORIZATIONS';


  SET v_kerberos_name = upper(ai_kerberos_name);
  SET v_server_user = upper(ai_server_user);
  SET v_proxy_user = upper(ai_proxy_user);
  
  
  if (length(ai_function_category) > 
      roles_service_constant.max_function_category_size) 
  then
    SET v_error_no = -20028;
    SET v_error_msg = replace(GetErrorMessage(-20028), 
                            '<function_category>', ai_function_category);
    call permit_signal(v_error_no, v_error_msg);
  else 
    SET v_function_category = upper(ai_function_category);
  end if;

  
  if (length(ai_function_category) > 
      roles_service_constant.max_function_name_size) 
  then
    SET v_error_no = -20029;
    SET v_error_msg = replace(GetErrorMessage(-20029), 
                            '<function_name>', ai_function_name);
    call permit_signal(v_error_no, v_error_msg);
  else 
    SET v_function_category = upper(ai_function_category);
  end if;

  
  SET v_function_name = upper(ai_function_name);
  select count(*) into v_count from function 
     where function_category = v_function_category
     and function_name = v_function_name;
  if v_count = 0 then
    SET v_error_no = -20021;
    SET v_error_msg = GetErrorMessage(-200212);
    SET v_error_msg = replace(v_error_msg, '<function_name>', 
                          ai_function_name);
    SET v_error_msg = replace(v_error_msg, '<function_category>', 
                          v_function_category);
    call permit_signal(v_error_no, v_error_msg);
  end if;
  select function_id, qualifier_type
    into v_function_id, v_qualifier_type
    from function
    where function_category = v_function_category
    and function_name = v_function_name;

  
  select rolesbb.rolesapi_is_user_authorized(ai_server_user, 
           service_function_name, 
           CONCAT('CAT' , rtrim(v_function_category)))
         into v_check_auth from dual;
  if (v_check_auth <> 'Y') then
    SET v_error_no = -20003;
    SET v_error_msg = GetErrorMessage(-20003);
    SET v_error_msg = replace(v_error_msg, '<server_id>', 
                           ai_server_user);
    SET v_error_msg = replace(v_error_msg, '<function_category>', 
                           v_function_category);
    call permit_signal(v_error_no, v_error_msg);
  end if;

  
  if (v_proxy_user = v_server_user) then 
    SET v_check_auth = 'Y';
  elseif (v_proxy_user = v_kerberos_name) then
    SET v_check_auth = 'Y';
  else
    select rolesbb.rolesapi_is_user_authorized(v_proxy_user, 
             read_auth_function1, 
             CONCAT('CAT' , rtrim(v_function_category)))
           into v_check_auth from dual;
    if (v_check_auth <> 'Y') then
      select rolesbb.rolesapi_is_user_authorized(v_proxy_user, 
             read_auth_function2, 
             CONCAT('CAT' , rtrim(v_function_category)))
             into v_check_auth from dual;
    end if;
  end if;
  if (v_check_auth <> 'Y') then
    SET v_error_no = -20005;
    SET v_error_msg = GetErrorMessage(-20005);
    SET v_error_msg = replace(v_error_msg, '<proxy_user>', 
                          v_proxy_user);
    SET v_error_msg = replace(v_error_msg, '<function_category>', 
                          v_function_category);
    call permit_signal(v_error_no, v_error_msg);
  end if;

  
  SET v_qualifier_code = upper(ai_qualifier_code);
  select count(*) into v_count 
    from rolesbb.qualifier
    where qualifier_type = v_qualifier_type
    and qualifier_code = v_qualifier_code;
  if v_count = 0 then
    SET v_error_no = -20022;
    SET v_error_msg = GetErrorMessage(-200222);
    SET v_error_msg = replace(v_error_msg, '<qualifier_code>', 
                          v_qualifier_code);
    SET v_error_msg = replace(v_error_msg, '<qualifier_type>', 
                          v_qualifier_type);
    call permit_signal(v_error_no, v_error_msg);
  end if;
  select qualifier_id into v_qualifier_id
    from rolesbb.qualifier
    where qualifier_type = v_qualifier_type
    and qualifier_code = v_qualifier_code;

  

  select count(*) into v_count from rolesbb.authorization
    where kerberos_name = v_kerberos_name
    and function_id = v_function_id 
    and qualifier_id = v_qualifier_id
    and do_function = 'Y'
    and sysdate() between effective_date and IFNULL(expiration_date, sysdate());

  IF v_count > 0 THEN
    RETURN 'Y';
  END IF;

  

  select count(*) into v_count 
    from rolesbb.authorization a, rolesbb.qualifier_descendent qd
    where a.kerberos_name = v_kerberos_name
    and a.function_id = v_function_id
    and a.do_function = 'Y'
    and a.descend = 'Y'
    and sysdate() between a.effective_date and IFNULL(a.expiration_date, sysdate())
    and qd.child_id = v_qualifier_id
    and a.qualifier_id = qd.parent_id;
  IF v_count > 0 THEN
    RETURN 'Y';
  END IF;

  
  RETURN 'N';

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `is_user_authorized_extended` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%` FUNCTION `is_user_authorized_extended`(ai_server_user VARCHAR(20),
     ai_proxy_user VARCHAR(20),
     ai_kerberos_name VARCHAR(20),
     ai_function_category VARCHAR(4),
     ai_function_name VARCHAR(80),
     ai_qualifier_code VARCHAR(10),
     ai_real_or_implied VARCHAR(20)) RETURNS varchar(1) CHARSET latin1
BEGIN

  DECLARE v_kerberos_name VARCHAR(20);
  DECLARE v_server_user VARCHAR(20);
  DECLARE v_proxy_user VARCHAR(20);
  DECLARE v_function_id_real INTEGER;
  DECLARE v_function_id_imp INTEGER;
  DECLARE v_function_category VARCHAR(4);
  DECLARE v_function_name VARCHAR(80);
  DECLARE v_star_function_name varchar(31);
  DECLARE v_qualifier_type VARCHAR(10);
  DECLARE v_qualifier_code VARCHAR(10);
  DECLARE v_qualifier_id INTEGER;
  DECLARE v_count integer;
  DECLARE v_found_real_function integer DEFAULT 0;
  DECLARE v_found_imp_function integer  DEFAULT 0;
  DECLARE v_valid_real_implied_arg integer;
  DECLARE v_real_or_implied varchar(1);
  DECLARE v_allow_auth_type1 VARCHAR(10);
  DECLARE v_allow_auth_type2 VARCHAR(10);
  DECLARE v_check_auth varchar(1);
  DECLARE v_error_msg varchar(255);
  DECLARE v_error_no integer;
  DECLARE service_function_name varchar(30) DEFAULT 'RUN ROLES SERVICE*/ /*!50003 PROCEDURES';
  DECLARE read_auth_function1 varchar(30) DEFAULT 'VIEW AUTH BY CATEGORY';
  DECLARE read_auth_function2 varchar(30) DEFAULT 'CREATE AUTHORIZATIONS';



  SET v_kerberos_name = upper(ai_kerberos_name);
  SET v_server_user = upper(ai_server_user);
  SET v_proxy_user = upper(ai_proxy_user);

  
  if length(ai_real_or_implied) > 1 then
    SET v_valid_real_implied_arg = 0;
  else
    SET v_real_or_implied = upper(IFNULL(ai_real_or_implied, 'B'));
    if v_real_or_implied in ('R', 'I', 'B') then
      SET v_valid_real_implied_arg = 1;
    else
      SET v_valid_real_implied_arg = 0;
    end if;
  end if;
  if v_valid_real_implied_arg = 0 then
    SET v_error_no = -20024;
    SET v_error_msg = replace(GetErrorMessage(-20024), 
                            '<arg_value>', ai_real_or_implied);
    call permit_signal(v_error_no, v_error_msg);
  end if;
  
  
  if (length(ai_function_category) > 
      roles_service_constant.max_function_category_size) 
  then
    SET v_error_no = -20028;
    SET v_error_msg = replace(GetErrorMessage(-20028) ,
                            '<function_category>', ai_function_category);
    call permit_signal(v_error_no, v_error_msg);
  else 
    SET v_function_category = upper(ai_function_category);
  end if;

  
  if (length(ai_function_category) > 
      roles_service_constant.max_function_name_size) 
  then
    SET v_error_no = -20029;
    SET v_error_msg = replace(GetErrorMessage(-20029), 
                            '<function_name>', ai_function_name);
    call permit_signal(v_error_no, v_error_msg);
  else 
    SET v_function_category = upper(ai_function_category);
  end if;

  
  SET v_function_name = upper(ai_function_name);
  SET v_star_function_name = CONCAT('*' , v_function_name);
  
  select count(*) into v_found_real_function from rolesbb.function 
     where function_category = v_function_category
     and function_name = v_function_name;
  select count(*) into v_found_imp_function from rolesbb.external_function 
       where function_category = v_function_category
       and function_name = v_star_function_name;
  if v_found_real_function = 1 then
    
    select function_id, qualifier_type
      into v_function_id_real, v_qualifier_type
      from rolesbb.function
      where function_category = v_function_category
      and function_name = v_function_name;
  end if;
  if v_found_imp_function = 1 then
    
    select function_id, qualifier_type
      into v_function_id_imp, v_qualifier_type
      from rolesbb.external_function
      where function_category = v_function_category
      and function_name = v_star_function_name;
  end if;
  if v_found_real_function + v_found_imp_function = 0 then
    SET v_error_no = -20021;
    SET v_error_msg = GetErrorMessage(-200212);
    SET v_error_msg = replace(v_error_msg, '<function_name>', 
                          ai_function_name);
    SET v_error_msg = replace(v_error_msg, '<function_category>', 
                          v_function_category);
    call permit_signal(v_error_no, v_error_msg);
  end if;

  
  select rolesapi_is_user_authorized(ai_server_user,
           roles_service_constant.service_function_name, 
           CONCAT('CAT' , rtrim(v_function_category)))
         into v_check_auth from dual;
  if (v_check_auth <> 'Y') then
    SET v_error_no = -20003;
    SET v_error_msg = GetErrorMessage(-20003);
    SET v_error_msg = replace(v_error_msg, '<server_id>',
                           ai_server_user);
    SET v_error_msg = replace(v_error_msg, '<function_category>',
                           v_function_category);
    call permit_signal(v_error_no, v_error_msg);
  end if;

  
  if (v_proxy_user = v_server_user) then
    SET v_check_auth = 'Y';
  elseif (v_proxy_user = v_kerberos_name) then
    SET v_check_auth = 'Y';
  elseif (v_proxy_user is null) then
    SET v_check_auth = 'Y';
  else
    select rolesapi_is_user_authorized(v_proxy_user,
             read_auth_function1,
             CONCAT('CAT', rtrim(v_function_category)))
           into v_check_auth from dual;
    if (v_check_auth <> 'Y') then
      select rolesbb.rolesapi_is_user_authorized(v_proxy_user,
             read_auth_function2,
             CONCAT('CAT' ,rtrim(v_function_category)))
             into v_check_auth from dual;
    end if;
  end if;
  if (v_check_auth <> 'Y') then
    SET v_error_no = -20005;
    SET v_error_msg = GetErrorMessage(-20005);
    SET v_error_msg = replace(v_error_msg, '<proxy_user>',
                          v_proxy_user);
    SET v_error_msg = replace(v_error_msg, '<function_category>',
                          v_function_category);
    call permit_signal(v_error_no, v_error_msg);
  end if;

  
  SET v_qualifier_code = upper(ai_qualifier_code);
  select count(*) into v_count
    from qualifier
    where qualifier_type = v_qualifier_type
    and qualifier_code = v_qualifier_code;
  if v_count = 0 then
    SET v_error_no = -20022;
    SET v_error_msg = GetErrorMessage(-200222);
    SET v_error_msg = replace(v_error_msg, '<qualifier_code>',
                          v_qualifier_code);
    SET v_error_msg = replace(v_error_msg, '<qualifier_type>',
                          v_qualifier_type);
    call permit_signal(v_error_no, v_error_msg);
  end if;
  select qualifier_id into v_qualifier_id
    from qualifier
    where qualifier_type = v_qualifier_type
    and qualifier_code = v_qualifier_code;

  
  if v_real_or_implied = 'R' then
    SET v_allow_auth_type1 = 'R';
    SET v_allow_auth_type2 = 'R';
  elseif v_real_or_implied = 'I' then
    SET v_allow_auth_type1 = 'E';  
    SET v_allow_auth_type2 = 'E';
  else
    SET v_allow_auth_type1 = 'R';
    SET v_allow_auth_type2 = 'E';
  end if;

  

  select count(*) into v_count from rolesbb.authorization2
    where kerberos_name = v_kerberos_name
    and function_name in (v_function_name, v_star_function_name)
    and function_category = v_function_category
    and qualifier_id = v_qualifier_id
    and do_function = 'Y'
    and sysdate() between effective_date and IFNULL(expiration_date, sysdate())
    and auth_type in (v_allow_auth_type1, v_allow_auth_type2);

  IF v_count > 0 THEN
    RETURN 'Y';
  END IF;

  

  select count(*) into v_count
    from rolesbb.authorization2 a, rolesbb.qualifier_descendent qd
    where a.kerberos_name = v_kerberos_name
    and function_name in (v_function_name, v_star_function_name)
    and function_category = v_function_category
    and a.do_function = 'Y'
    and a.descend = 'Y'
    and sysdate() between a.effective_date and IFNULL(a.expiration_date, sysdate())
    and qd.child_id = v_qualifier_id
    and a.qualifier_id = qd.parent_id
    and auth_type in (v_allow_auth_type1, v_allow_auth_type2);
  IF v_count > 0 THEN
    RETURN 'Y';
  END IF;

  
  select count(*) into v_count
    from rolesbb.function_child
    where child_id in (IFNULL(v_function_id_real, v_function_id_imp),
                       IFNULL(v_function_id_imp, v_function_id_real));
  if v_count = 0 then
    RETURN 'N';
  end if;

  

  select count(*) into v_count from rolesbb.authorization2
    where kerberos_name = v_kerberos_name
    and function_id in
    ( select parent_id from rolesbb.function_child
      where child_id in (IFNULL(v_function_id_real, v_function_id_imp),
                        IFNULL(v_function_id_imp, v_function_id_real)) )
    and function_category = v_function_category
    and qualifier_id = v_qualifier_id
    and do_function = 'Y'
    and sysdate() between effective_date and IFNULL(expiration_date, sysdate())
    and auth_type in (v_allow_auth_type1, v_allow_auth_type2);

  IF v_count > 0 THEN
    RETURN 'Y';
  END IF;

  
  select count(*) into v_count
    from rolesbb.authorization2 a, rolesbb.qualifier_descendent qd
    where a.kerberos_name = v_kerberos_name
    and function_id in
    ( select parent_id from rolesbb.function_child
      where child_id in (IFNULL(v_function_id_real, v_function_id_imp),
                        IFNULL(v_function_id_imp, v_function_id_real)) )
    and function_category = v_function_category
    and a.do_function = 'Y'
    and a.descend = 'Y'
    and sysdate() between a.effective_date and IFNULL(a.expiration_date, sysdate())
    and qd.child_id = v_qualifier_id
    and a.qualifier_id = qd.parent_id
    and auth_type in (v_allow_auth_type1, v_allow_auth_type2);
  IF v_count > 0 THEN
    RETURN 'Y';
  END IF;

  
  RETURN 'N';

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `library_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `library_user`() RETURNS varchar(50) CHARSET latin1
    READS SQL DATA
    COMMENT ' to share arrays among different users, use "return ''all users''"'
return substring_index(user(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `parameter_composer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `parameter_composer`(
    parameters_array varchar(50)
) RETURNS text CHARSET latin1
    READS SQL DATA
begin
    declare retvalue text;
    declare counter  int;
    declare asize    int;
    declare first_loop boolean default true;
    set retvalue = '';
    set counter = 0;
    set asize = array_size(parameters_array);
    while counter < asize do
        if (first_loop) then
            set first_loop = false;
        else
            set retvalue = concat(retvalue, ', ');
        end if;
        set retvalue = 
            concat(retvalue, 
                quote(array_get_value_by_index(parameters_array, counter)));
        set counter = counter + 1;
    end while;
    return retvalue;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `procedure_exists` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `procedure_exists`(
    p_db_name varchar(50), 
    p_procedure_name varchar(50)
) RETURNS tinyint(1)
    READS SQL DATA
return routine_exists(p_db_name, p_procedure_name, 'procedure') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `procedure_exists_simple` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `procedure_exists_simple`(
    p_procedure_name varchar(50)
) RETURNS tinyint(1)
    READS SQL DATA
return routine_exists_simple( p_procedure_name, 'procedure') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `psyntax` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `psyntax`(
    p_procedure_name varchar(50)
) RETURNS text CHARSET latin1
    READS SQL DATA
begin
    return routine_syntax('',p_procedure_name,'procedure');
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `routine_exists` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `routine_exists`(
    p_db_name varchar(50), 
    p_routine_name varchar(50),
    p_routine_type enum('procedure','function')
) RETURNS tinyint(1)
    READS SQL DATA
return coalesce(
        (
        select count(*) 
        from information_schema.routines
        where 
            routine_schema = p_db_name 
            and routine_name = p_routine_name
            and routine_type = p_routine_type
        ), 0) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `routine_exists_simple` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `routine_exists_simple`(
    p_routine_name varchar(50),
    p_routine_type enum('procedure','function')
) RETURNS tinyint(1)
    READS SQL DATA
return coalesce(
        (
        select count(*) 
        from information_schema.routines
        where 
            routine_schema = @database 
            and routine_name = p_routine_name
            and routine_type = p_routine_type
        ), 0) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `routine_syntax` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `routine_syntax`(
    p_db_name       varchar(50),
    p_routine_name  varchar(50),
    p_routine_type enum('function', 'procedure')
) RETURNS text CHARSET latin1
    READS SQL DATA
begin
    declare wanted_routine_id  int;
    declare how_many_routines  int;
    select count(*) into how_many_routines 
        from _routine_syntax 
        where 
                routine_name = p_routine_name 
                and 
                routine_type = p_routine_type ;
    
    
    if ( how_many_routines = 1) then
            select routine_id into wanted_routine_id 
            from _routine_syntax 
            where routine_name = p_routine_name 
            and routine_type = p_routine_type;
    elseif ( how_many_routines = 0 ) then
           return null;
    else
            select routine_id into wanted_routine_id
            from _routine_syntax 
            where routine_type = p_routine_type
                and (   (
                        routine_name = p_routine_name
                        and  
                        routine_schema = p_db_name
                        )   
                        or ( routine_complete_name = p_routine_name) 
                    ) ;
    end if;
            
    return routine_syntax_text(wanted_routine_id);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `routine_syntax_text` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `routine_syntax_text`(
    p_routine_id      int
) RETURNS text CHARSET latin1
    READS SQL DATA
begin
    declare module_descr varchar(50);
    declare rtype        varchar(10);
    declare rschema      varchar(50);
    declare rname        varchar(50);
    declare rdescr       text;
    declare uv           text;
    declare ov           text;
    declare sa           text;
    select module_name into module_descr 
    from _modules inner join _routine_syntax using (module_code) 
        where routine_id = p_routine_id;
    select 
        routine_type, routine_schema, routine_name, 
        routine_description, user_variables ,
        other_variables, see_also
        into
        rtype, rschema, rname, rdescr, uv, ov, sa
    from 
        _routine_syntax
    where 
        routine_id =  p_routine_id ;
    return 
        concat('\n ** ',rtype, 
                ' ', rschema, '.', rname, '\n', rdescr,
                if(uv is null or uv ='', '',
                    concat('\n   --\n   User Variables:\n   ', uv ) ),
                if(ov is null or ov ='', '',
                    concat('\n   --\n   Other variables:\n   ', ov ) ),
                if(sa is null or sa ='', '',
                    concat('\n   --\n   see also: ', sa , '\n   --') ),
                '\n   module : ', coalesce( module_descr, 'UNRECORDED MODULE')
                ) ;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `simple_sp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `simple_sp`(
    calling_procedure varchar(50),
    parameters_array  varchar(50)
) RETURNS text CHARSET latin1
    READS SQL DATA
begin
    declare done            boolean default false;
    declare has_parameters  boolean default false;
    declare par_name        varchar(50);
    declare new_array_name  varchar(30);
    declare retvalue        text;
    declare get_params  cursor for
        select parameter_name
            from        _routine_parameters rp
            inner join  _routine_syntax rs     on (rs.routine_id=rp.routine_id)
            where 
                routine_complete_name = calling_procedure
                or routine_complete_name = concat(database(),'.', calling_procedure)
            order by parameter_sequence;
    declare continue handler for not found
        set done = true;
    set new_array_name = concat('_sp', date_format(now(),"%d%H%i%s"), floor(rand() * 10000000) );
    call array_create(new_array_name,0);
    call array_clear(new_array_name);
    set done = false;
    open get_params;
    GET_PARAMETERS:
    loop
        fetch get_params into par_name;
        if (done) then
            leave GET_PARAMETERS;
        end if;
        call array_set(new_array_name, par_name, array_get(parameters_array,par_name) );
        set has_parameters = true;
    end loop;
    set retvalue = concat( calling_procedure ,'(', parameter_composer(new_array_name),')');
    call array_drop(new_array_name);
    if (has_parameters) then
        return retvalue;
    else
        return NULL;
    end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `simple_spl` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `simple_spl`(
    calling_procedure varchar(50),
    parameters_list   text
) RETURNS text CHARSET latin1
    READS SQL DATA
begin
    declare temp_array varchar(50);
    declare retvalue text;
    declare list_separator varchar(10) default ';';
    declare pair_separator varchar(10) default '=>';
    set temp_array = array_temp_name();
    set parameters_list = replace(parameters_list, '\n',' ');
    if (@pair_separator is not null) then
        set pair_separator = @pair_separator;
    end if;
    if (@list_separator is not null) then
        set list_separator = @list_separator;
    end if;
    set retvalue   = simple_sp( calling_procedure, 
            array_from_pair_list_complete(parameters_list,
                                            temp_array, 
                                            list_separator, 
                                             pair_separator) );
    call array_drop(temp_array);
    return retvalue;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `table_exists` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `table_exists`(
    p_db_name varchar(50), 
    p_table_name varchar(50)
) RETURNS tinyint(1)
    READS SQL DATA
return coalesce( 
        (
        select count(*) 
        from information_schema.tables 
        where 
            table_schema = p_db_name 
            and 
            table_name = p_table_name
            and 
            table_type = 'base table'
        ), 0) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `table_exists_simple` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `table_exists_simple`(
    p_table_name varchar(50)
) RETURNS tinyint(1)
    READS SQL DATA
return if(isnull(@database), null, coalesce( 
        (
        select count(*) 
        from information_schema.tables 
        where 
            table_schema = @database 
            and 
            table_name = p_table_name
            and 
            table_type = 'base table'
        ), 0)) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `table_or_view_exists` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `table_or_view_exists`(
    p_db_name varchar(50), 
    p_table_name varchar(50)
) RETURNS tinyint(1)
    READS SQL DATA
return coalesce(
        (
        select count(*) 
        from information_schema.tables 
        where table_schema = p_db_name and table_name = p_table_name
        ) , 0) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `table_or_view_exists_simple` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `table_or_view_exists_simple`(
    p_table_name varchar(50)
) RETURNS tinyint(1)
    READS SQL DATA
return if(isnull(@database), null, coalesce(
        (
        select count(*) 
        from information_schema.tables 
        where table_schema = @database and table_name = p_table_name
        ) , 0)) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `view_exists` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `view_exists`(
    p_db_name varchar(50), 
    p_view_name varchar(50)
) RETURNS tinyint(1)
    READS SQL DATA
return coalesce( 
        (
        select count(*) 
        from information_schema.tables 
        where 
            table_schema = p_db_name 
            and 
            table_name = p_view_name
            and 
            table_type = 'VIEW'
        ), 0) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `view_exists_simple` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 FUNCTION `view_exists_simple`(
    p_view_name varchar(50)
) RETURNS tinyint(1)
    READS SQL DATA
return if(isnull(@database), null, coalesce( 
        (
        select count(*) 
        from information_schema.tables 
        where 
            table_schema = @database 
            and 
            table_name = p_view_name
            and 
            table_type = 'VIEW'
        ), 0)) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_append` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_append`(
    p_base_array_name     varchar(50),
    p_second_array_name varchar(50)
)
    MODIFIES SQL DATA
begin
   set @array_append = array_append(p_base_array_name, p_second_array_name);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_clear` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_clear`(
    p_array_name varchar(50)
)
    MODIFIES SQL DATA
begin
    set @array_clear = array_clear(p_array_name);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_copy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_copy`(
    p_array_name     varchar(50),
    p_new_array_name varchar(50)
)
    MODIFIES SQL DATA
begin
    set @array_copy = array_copy(p_array_name, p_new_array_name);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_copy_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_copy_complete`(
    p_array_name     varchar(50),
    p_new_array_name varchar(50),
    on_key_conflict  enum("use_first", "use_second"),
    drop_new         boolean,
    key_regexp       varchar(100),
    value_regexp     varchar(100)
)
    MODIFIES SQL DATA
begin
    set @array_copy_complete = array_copy_complete(p_array_name, p_new_array_name,on_key_conflict, drop_new, key_regexp,value_regexp);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_create` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_create`(
    p_array_name varchar(50),
    p_array_size int
)
    MODIFIES SQL DATA
begin
    set @array_create = array_create(p_array_name, p_array_size);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_drop` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_drop`(
    p_array_name varchar(50)
)
    MODIFIES SQL DATA
begin
    set @array_drop = array_drop(p_array_name);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_from_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_from_list`(
    p_list        text,
    p_array_name  varchar(50)
)
    MODIFIES SQL DATA
begin
    set @array_from_list = 
        array_from_list(p_list, p_array_name);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_from_list_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_from_list_complete`(
    p_list        text,
    p_array_name  varchar(50),
    p_separator   varchar(10)
)
    MODIFIES SQL DATA
begin
    set @array_from_list_complete = 
        array_from_list_complete(p_list, p_array_name, p_separator);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_from_pair_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_from_pair_list`(
    p_list             text,
    p_array_name       varchar(50)
)
    MODIFIES SQL DATA
begin
    set @array_from_pair_list= 
        array_from_pair_list(
            p_list, 
            p_array_name );
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_from_pair_list_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_from_pair_list_complete`(
    p_list             text,
    p_array_name       varchar(50),
    p_list_separator   varchar(10),
    p_pair_separator   varchar(10)
)
    MODIFIES SQL DATA
begin
    set @array_from_pair_list_complete = 
        array_from_pair_list_complete(
            p_list, 
            p_array_name, 
            p_list_separator, 
            p_pair_separator);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_full_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_full_list`()
    READS SQL DATA
begin
    select array_id, array_name, array_size
        from 
            _arrays 
        where
            username = library_user()
        order by if(left(array_name,1)='_',0,1), array_name;
        
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_grep` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_grep`(
    p_array_name     varchar(50),
    p_new_array_name varchar(50),
    value_regexp       varchar(100)
)
    MODIFIES SQL DATA
begin
   set @array_grep =  array_grep(p_array_name, p_new_array_name,value_regexp);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_grep_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_grep_complete`(
    p_array_name     varchar(50),
    p_new_array_name varchar(50),
    key_regexp       varchar(100),
    value_regexp     varchar(100)
)
    MODIFIES SQL DATA
begin
   set @array_grep_complete = array_grep_complete(p_array_name, 
                p_new_array_name, key_regexp,value_regexp);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_list`()
    READS SQL DATA
begin
    select array_id, array_name, array_size
        from 
            _arrays 
        where username = library_user() and array_name not like '\_%'
        order by array_name;
        
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_merge` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_merge`(
    p_first_array_name     varchar(50),
    p_second_array_name    varchar(50),
    p_new_array_name       varchar(50)
)
    MODIFIES SQL DATA
begin
    set @array_merge= array_merge(
        p_first_array_name, 
        p_second_array_name, 
        p_new_array_name);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_merge_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_merge_complete`(
    p_first_array_name     varchar(50),
    p_second_array_name    varchar(50),
    p_new_array_name       varchar(50),
    on_key_conflict        enum("use_first", "use_second")
)
    MODIFIES SQL DATA
begin
    set @array_merge_complete= array_merge_complete(
        p_first_array_name, 
        p_second_array_name, 
        p_new_array_name,
        on_key_conflict);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_push` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_push`(
    p_array_name    varchar(50),
    p_array_value   text
)
    MODIFIES SQL DATA
begin
    set @array_push = array_push(p_array_name, p_array_value);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_set` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_set`(
    p_array_name  varchar(50),
    p_array_ndx_key varchar(50),
    p_array_value text
)
    MODIFIES SQL DATA
begin
    set @array_set = array_set( p_array_name, p_array_ndx_key, p_array_value);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_set_key_by_index` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_set_key_by_index`(
    p_array_name  varchar(50),
    p_array_index int,
    p_array_key   varchar(50)
)
    MODIFIES SQL DATA
begin
    set @array_set_key_by_index = 
        array_set_key_by_index(p_array_name,p_array_index,p_array_key);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_set_value_by_index` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_set_value_by_index`(
    p_array_name  varchar(50),
    p_array_index int,
    p_array_value text
)
    MODIFIES SQL DATA
begin
    set @array_set_value_by_index = array_set_value_by_index(
        p_array_name, p_array_index, p_array_value);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_set_value_by_key` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_set_value_by_key`(
    p_array_name  varchar(50),
    p_array_key   varchar(50),
    p_array_value text
)
    MODIFIES SQL DATA
begin
    set @array_set_value_by_key = array_set_value_by_key(
                                        p_array_name, 
                                        p_array_key, 
                                        p_array_value);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_show` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_show`(
    p_array_name varchar(50)
)
    READS SQL DATA
begin
    set @_array_show_query = concat(
    'select array_index, array_key, ',
    '        array_value as `"', p_array_name, '" values` ', 
    '    from ',
    '        _array_contents ',
    '        inner join _arrays using (array_id)',
    '    where array_name = "', p_array_name, '"',
    '          and username = "', library_user(), '"'
    );
    prepare array_query from @_array_show_query;
    execute array_query;    
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_sort` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_sort`(
    p_array_name     varchar(50),
    p_new_array_name varchar(50)
)
    MODIFIES SQL DATA
begin
    set @array_sort = array_sort(p_array_name, p_new_array_name);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_sort_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_sort_complete`(
    p_array_name     varchar(50),
    p_new_array_name varchar(50),
    order_by         enum("K","V","VN","VK"),
    order_direction  enum("asc", "desc")
)
    MODIFIES SQL DATA
begin
    set @array_sort_complete = array_sort_complete(
        p_array_name, p_new_array_name,
        order_by, order_direction);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `array_unshift` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `array_unshift`(
    p_array_name    varchar(50),
    p_array_value   text
)
    MODIFIES SQL DATA
begin
    set @array_unshift = array_unshift(p_array_name, p_array_value);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `check_for_routines_existence` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `check_for_routines_existence`(
    p_db_name       varchar(50)
)
begin
    declare r_name varchar(50);
    declare r_type varchar(50);
    declare routine_exists boolean;
    declare done boolean default false;
    declare get_names cursor for
        select routine_name, routine_type from _routine_list ;
    declare continue handler for not found set done = true;
    
    if (table_exists(p_db_name, '_routine_list')) then

        open get_names;

        GET_ROUTINES:
        loop
            fetch get_names into r_name, r_type;
            if (done) then
                leave GET_ROUTINES;
            end if;
            call check_routine(p_db_name, r_name, r_type);
        end loop;
    else
        select 'table _routine_list NOT FOUND.' as `ERROR`;
        insert  into _test_results ( description, result, expected, outcome)
        values
        ('check_for_routines_existence', 0, 'table _routine_list exists', 0);
    end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `check_routine` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `check_routine`(
    p_db_name       varchar(50),
    p_routine_name  varchar(50),
    p_routine_type  enum('procedure', 'function')
)
    MODIFIES SQL DATA
begin
    declare routine_exists boolean;
    set routine_exists = routine_exists( p_db_name, p_routine_name, p_routine_type);
     
   insert into _test_results( description, result, expected, outcome)
   values 
   (concat(p_routine_name, ' ', left(p_routine_type,1), ' exists'), 
       routine_exists,  'routine_exists = true',   routine_exists );
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `check_routine_simple` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `check_routine_simple`(
    p_routine_name  varchar(50),
    p_routine_type  enum('procedure', 'function')
)
    MODIFIES SQL DATA
begin
    declare routine_exists boolean;
    if (@database is null) then
        call log_test('routine_exists', @database,'@database is not null', @database);
        select 'variable @database must be set when calling check_routine_simple' as `ERROR`;
    else
        call check_routine(@database, p_routine_name, p_routine_type);
    end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `check_table` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `check_table`(
    p_db_name       varchar(50),
    p_table_name    varchar(50)
)
    MODIFIES SQL DATA
begin
    declare table_exists boolean;
    set table_exists = table_exists( p_db_name, p_table_name);
     
   insert into _test_results( description, result, expected, outcome)
   values 
   (concat('table ', p_table_name, ' exists'), 
       table_exists,  'table_exists = true',   table_exists );
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `check_view` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `check_view`(
    p_db_name       varchar(50),
    p_view_name    varchar(50)
)
    MODIFIES SQL DATA
begin
    declare view_exists boolean;
    set view_exists = view_exists( p_db_name, p_view_name);
     
   insert into _test_results( description, result, expected, outcome)
   values 
   (concat('view ', p_view_name, ' exists'), 
       view_exists,  'view_exists = true',   view_exists );
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `for_each_array_item` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `for_each_array_item`(
    array_name   varchar(50),
    min_index    int,
    max_index    int,
    sql_command  text
)
    MODIFIES SQL DATA
begin
    call for_each_array_item_complete(
                array_name,
                min_index,
                max_index,
                sql_command,
                null,
                null,
                'once');
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `for_each_array_item_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `for_each_array_item_complete`(
    array_name   varchar(50),
    min_index    int,
    max_index    int,
    sql_command  text,
    sql_before   text,
    sql_after    text,
    ba_mode      enum('once','many') 
)
    MODIFIES SQL DATA
begin
    declare cur_value  int;
    declare array_item text;
    declare array_key  varchar(50) default '';
    declare has_before boolean default true;
    declare has_after  boolean default true;
    declare key_wanted boolean default false;
    declare counter_placeholder char(20) default '$N';
    declare item_placeholder    char(20) default '$I';
    declare key_placeholder     char(20) default '$K';
    if (@for_counter is not null) then
        set counter_placeholder = @for_counter;
    end if;
    if (@for_item is not null) then
        set item_placeholder = @for_item;
    end if;
    if (@for_key is not null) then
        set key_placeholder = @for_key;
    end if;
    if ( instr(sql_command, key_placeholder) >0 )
       or
       ( instr(sql_before, key_placeholder) >0 )
       or
       ( instr(sql_after, key_placeholder) >0 )
    then
        set key_wanted = true;
    end if;

    if (sql_before is null or sql_before = '') then
        set has_before = false;
    end if;
    if (sql_after is null or sql_after = '') then
        set has_after = false;
    end if;
    if (min_index > max_index) then
        set cur_value = min_index;
        set min_index = max_index;
        set max_index = cur_value; 
    end if;

    if (has_before and (ba_mode = 'once')) then
            set @_sql_before = sql_before;
            prepare before_query from @_sql_before;
            execute before_query;
            deallocate prepare before_query;
    end if;
    set cur_value = min_index;
    MAIN_FOR:
    while (cur_value <= max_index) do
        set array_item= array_get(array_name, cur_value);
        if (key_wanted) then
            set array_key = array_get_key_by_index(array_name, cur_value);
            if (array_key is null) then
                set array_key = '';
            end if;
        end if;
        if (array_item is null) then
            set @for_error= concat('item ', cur_value, ' at array ', array_name, ' is null');
            if (@for_array_continue_on_null is not null) then
                set array_item = '';
            else
                leave MAIN_FOR;
            end if;
        end if;
        set @_for_query = sql_command;
        set @_for_query = replace(@_for_query, counter_placeholder, cur_value);
        set @_for_query = replace(@_for_query, item_placeholder,    array_item);
        set @_for_query = replace(@_for_query, key_placeholder,     array_key);
        if (has_before and ( ba_mode = 'many')) then
            set @_sql_before = sql_before;
            set @_sql_before = replace(@_sql_before, counter_placeholder, cur_value);
            set @_sql_before = replace(@_sql_before, item_placeholder,    array_item);
            set @_sql_before = replace(@_sql_before, key_placeholder,     array_key);
            prepare before_query from @_sql_before;
            execute before_query;
            deallocate prepare before_query;
        end if;
        prepare for_query from @_for_query;
        execute for_query;
        deallocate prepare for_query;
        if (has_after and (ba_mode = 'many')) then
            set @_sql_after = sql_after;
            set @_sql_after = replace(@_sql_after, counter_placeholder, cur_value);
            set @_sql_after = replace(@_sql_after, item_placeholder,    array_item);
            set @_sql_after = replace(@_sql_after, key_placeholder,     array_key);
            prepare after_query from @_sql_after;
            execute after_query;
            deallocate prepare after_query;
        end if;
         set cur_value = cur_value + 1;
    end while;
    if (has_after and (ba_mode = 'once')) then
            set @_sql_after = sql_after;
            prepare after_query from @_sql_after;
            execute after_query;
            deallocate prepare after_query;
    end if;
    set @_sql_after  = null;
    set @_sql_before = null;
    set @_for_query  = null;
 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `for_each_array_item_simple` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `for_each_array_item_simple`(
    array_name   varchar(50),
    sql_command  text
)
    MODIFIES SQL DATA
begin
    call for_each_array_item_complete(
                array_name,
                0,
                array_max_index(array_name),
                sql_command,
                null,
                null,
                'once');
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `for_each_counter` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `for_each_counter`( 
    counter_start   INT,
    counter_end     INT,
    counter_delta   INT,
    sql_command     text
)
    MODIFIES SQL DATA
begin
    declare counter             int;
    declare counter_placeholder char(10) default '$N';
    if (@for_counter is not null) then
        set counter_placeholder = @for_counter;
    end if;
    set counter = counter_start;
    while counter <= counter_end do

        set @_for_query = sql_command;
        set @_for_query = replace(@_for_query, counter_placeholder, counter);
        prepare for_query from @_for_query;
        execute for_query;
        deallocate prepare for_query;

        set counter = counter + counter_delta;
    end while;
    set @_for_query = null;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `for_each_counter_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `for_each_counter_complete`( 
    counter_start   INT,
    counter_end     INT,
    counter_delta   INT,
    sql_command     text,
    sql_before      text,
    sql_after       text,
    ba_mode         enum('once','many') 
)
    MODIFIES SQL DATA
begin
    declare counter int;

    if (sql_before is not null) and (sql_before != '') then
        set @_sql_before = sql_before;
        prepare before_query from @_sql_before;
        set @_sql_before = null;
    else
        prepare before_query from 'set @_dummy = null';
    end if;
    
    if (sql_after is not null) and (sql_after != '') then
        set @_sql_after = sql_after;
        prepare after_query from @_sql_after;
        set @_sql_after = null;
    else
        prepare after_query from 'set @_dummy = null';
    end if;

    if (ba_mode = 'once') then
        execute before_query;
        call for_each_counter(counter_start, counter_end, counter_delta, sql_command);
        execute after_query;
    else
        set counter = counter_start;
        while counter <= counter_end do
            call for_each_counter(counter,counter,1,sql_before);
            call for_each_counter(counter,counter,1,sql_command);
            call for_each_counter(counter,counter,1,sql_after);
            set counter = counter + counter_delta;
        end while;
    end if;
    deallocate prepare before_query;
    deallocate prepare after_query;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `for_each_list_item` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `for_each_list_item`(
    list_value   text,
    sql_command  text
)
    MODIFIES SQL DATA
begin
    declare array_name varchar(50);
    
    set array_name = array_temp_name();
    call array_from_list(list_value, array_name);
    call for_each_array_item_complete(
                array_name,
                0,
                array_max_index(array_name),
                sql_command, 
                null, 
                null, 
                null);
    call array_drop(array_name);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `for_each_list_item_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `for_each_list_item_complete`(
    list_value   text,
    sql_command  text,
    sql_before   text,
    sql_after    text,
    ba_mode      enum('once','many') 
)
    MODIFIES SQL DATA
begin
    declare array_name varchar(50);
    
    set array_name = array_temp_name();
    call array_from_list(list_value, array_name);
    call for_each_array_item_complete(
                array_name,
                0,
                array_max_index(array_name),
                sql_command, 
                sql_before, 
                sql_after, 
                ba_mode);
    call array_drop(array_name);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `for_each_table` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `for_each_table`( 
    db_name         varchar(50), 
    condition_text  varchar(50),
    sql_command     text  
)
    MODIFIES SQL DATA
begin
    call for_each_table_complete(db_name,condition_text,sql_command,null,null,'once');
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `for_each_table_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `for_each_table_complete`( 
    db_name         varchar(50), 
    condition_text  varchar(50),
    sql_command     text,
    sql_before      text,
    sql_after       text,
    ba_mode         enum('once','many') 
)
    MODIFIES SQL DATA
begin
    declare tab_name            varchar(50);
    declare tab_type            varchar(50);
    declare tab_engine          varchar(50);
    declare tab_rows            bigint;
    declare done                boolean  default false;
    declare has_condition       boolean  default true;
    declare has_before          boolean  default true;
    declare has_after           boolean  default true;
    declare db_placeholder      char(10) default '$D';
    declare table_placeholder   char(10) default '$T';
    declare counter_placeholder char(10) default '$N';
    declare type_placeholder    char(10) default '$Y';
    declare engine_placeholder  char(10) default '$E';
    declare rows_placeholder    char(10) default '$R';
    declare counter             int      default 0;
    declare counter_delta       int      default 1;
    declare table_list cursor for
        SELECT table_name, table_type, engine, table_rows 
        FROM   information_schema.tables
        WHERE  table_schema = db_name ;
    declare continue handler for not found
        set done = true;
    open table_list;
    
    if (condition_text is null or condition_text = '') then
        set has_condition = false;
    end if;
    if (sql_before is null or sql_before = '') then
        set has_before = false;
    end if;
    if (sql_after is null or sql_after = '') then
        set has_after = false;
    end if;
    if (@for_counter_delta is not null) 
        and 
       (@for_counter_delta regexp "^[0-9]+$") 
    then
        set counter_delta = @for_counter_delta;
    end if;

    if (@for_db is not null) then
        set db_placeholder = @for_db;
    end if;

    if (@for_table is not null) then
        set table_placeholder = @for_table;
    end if;
    if (@for_counter is not null) then
        set counter_placeholder = @for_counter;
    end if;

    if (@for_engine is not null) then
        set engine_placeholder = @for_engine;
    end if;

    if (@for_type is not null) then
        set type_placeholder = @for_type;
    end if;

    if (@for_rows is not null) then
        set rows_placeholder = @for_rows;
    end if;

    if (has_before = true and (ba_mode = 'once')) then
        set @_sql_before = sql_before;
        set @_sql_before = replace(@_sql_before, db_placeholder, db_name );
        prepare before_query from @_sql_before;
        execute before_query;
        deallocate prepare before_query;
    end if;

    FOR_EACH:
    loop
        fetch table_list into tab_name, tab_type, tab_engine, tab_rows;
        
        if (done) then
            leave FOR_EACH;
        end if; 

        if (has_condition) then
            set @_condquery = CONCAT(
                "set @_table_count = (SELECT count(*) ",
                "FROM information_schema.tables ",
                "WHERE table_schema = '", db_name, "'", 
                " AND table_name = '", tab_name, "'");

            set @_condquery = CONCAT(@_condquery, " AND ", condition_text);
            set @_condquery = CONCAT(@_condquery, ")"); 
            prepare check_condition from @_condquery;
            execute check_condition;
            deallocate prepare check_condition;
        else
            set @_table_count = 1;
        end if;  
        
        if (@_table_count > 0 ) then
            set counter   = counter + counter_delta;
            set @_for_query = sql_command;
            set @_for_query = replace(@_for_query, table_placeholder,   tab_name);
            set @_for_query = replace(@_for_query, db_placeholder,      db_name);
            set @_for_query = replace(@_for_query, counter_placeholder, counter);
            set @_for_query = replace(@_for_query, rows_placeholder,    tab_rows);
            set @_for_query = replace(@_for_query, type_placeholder,    tab_type);
            set @_for_query = replace(@_for_query, engine_placeholder,  tab_engine);
            
            if (has_before and (ba_mode = 'many')) then
                set @_sql_before = sql_before;
                set @_sql_before = replace(@_sql_before, table_placeholder,   tab_name);
                set @_sql_before = replace(@_sql_before, db_placeholder,      db_name);
                set @_sql_before = replace(@_sql_before, counter_placeholder, counter);
                set @_sql_before = replace(@_sql_before, rows_placeholder,    tab_rows);
                set @_sql_before = replace(@_sql_before, type_placeholder,    tab_type);
                set @_sql_before = replace(@_sql_before, engine_placeholder,  tab_engine);
                prepare before_query from @_sql_before;
                execute before_query;
                deallocate prepare before_query;
            end if;
            prepare for_query FROM @_for_query;
            execute for_query;
            if (has_after and (ba_mode = 'many')) then
                set @_sql_after = sql_after;
                set @_sql_after = replace(@_sql_after, table_placeholder,   tab_name);
                set @_sql_after = replace(@_sql_after, db_placeholder,      db_name);
                set @_sql_after = replace(@_sql_after, counter_placeholder, counter);
                set @_sql_after = replace(@_sql_after, rows_placeholder,    tab_rows);
                set @_sql_after = replace(@_sql_after, type_placeholder,    tab_type);
                set @_sql_after = replace(@_sql_after, engine_placeholder,  tab_engine);
                prepare after_query from @_sql_after;
                execute after_query;
                deallocate prepare after_query;
            end if;
 
        end if; 

    end loop; 
    if (has_after and (ba_mode = 'once')) then
        set @_sql_after = sql_after;
        set @_sql_after = replace(@_sql_after, db_placeholder, db_name );
        prepare after_query from @_sql_after;
        execute after_query;
        deallocate prepare after_query;
    end if;
    set @_condquery      = null;
    set @_for_query      = null;
    set @_table_count    = null;
    set @_sql_after      = null;
    set @_sql_before     = null;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `for_each_table_value` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `for_each_table_value`(
    db_name          varchar(50),
    table_name       varchar(50),
    wanted_col1      varchar(50),
    wanted_col2      varchar(50),
    wanted_col3      varchar(50),
    search_condition text,
    sql_command      text
)
    MODIFIES SQL DATA
begin
    call for_each_table_value_complete(
            db_name,
            table_name,
            wanted_col1, wanted_col2, wanted_col3,
            search_condition,
            sql_command,
            null,          
            null,          
            null,          
            'once');
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `for_each_table_value_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `for_each_table_value_complete`(
    db_name          varchar(50),
    table_name       varchar(50),
    wanted_col1      varchar(50),
    wanted_col2      varchar(50),
    wanted_col3      varchar(50),
    
    search_condition text,
    sql_command      text,
    sql_before       text,
    sql_after        text,
    done_cond        text,
    ba_mode          enum('once','many') 
)
    MODIFIES SQL DATA
begin
    declare done       boolean default false;
    declare theitem1   varchar(50);
    declare theitem2   varchar(50);
    declare theitem3   varchar(50);
    
    declare counter    int;
    declare has_before boolean default true;
    declare has_after  boolean default true;
    declare has_done   boolean default true;

    declare db_placeholder      char(20) default '$D';
    declare table_placeholder   char(20) default '$T';
    declare counter_placeholder char(20) default '$N';
    declare item_placeholder1   char(20) default '$I1';
    declare item_placeholder2   char(20) default '$I2';
    declare item_placeholder3   char(20) default '$I3';
    
    declare get_data cursor for
        select thevalue1, thevalue2, thevalue3 from tmpdata;
    declare continue handler for not found
        set done = true;

    
    
    
    

    if ((done_cond is null or done_cond='') 
        and 
        (@for_done is not null and @for_done !='')) 
    then
        set done_cond = @for_done;
    end if;
    if (done_cond is null or done_cond = '') then
        set has_done  = false;
    end if;
    if (sql_before is null or sql_before = '') then
        set has_before = false;
    end if;
    if (sql_after is null or sql_after = '') then
        set has_after = false;
    end if;

    if (@for_db is not null) then
        set db_placeholder = @for_db;
    end if;

    if (@for_table is not null) then
        set table_placeholder = @for_table;
    end if;
    if (@for_counter is not null) then
        set counter_placeholder = @for_counter;
    end if;
    if (@for_item1 is not null) then
        set item_placeholder1 = @for_item1;
    end if;
    if (@for_item2 is not null) then
        set item_placeholder2 = @for_item2;
    end if;
    if (@for_item3 is not null) then
        set item_placeholder3 = @for_item3;
    end if;
 
    
    
    

    if (search_condition is null or trim(search_condition) = '') then
        set search_condition = '';
    else
        if (not search_condition regexp '^\s*where') then
            set search_condition = concat( ' WHERE ', search_condition);
        end if;
    end if;
    drop table if exists tmpdata;
    
    set @get_query = concat('create temporary table tmpdata select ', 
            wanted_col1,' as thevalue1, ',
            if(wanted_col2 is null, '""', wanted_col2), ' as  thevalue2, ',
            if(wanted_col3 is null, '""', wanted_col3), ' as  thevalue3 ',
            
            ' from `',db_name, '`.`',table_name, 
            '`', search_condition );
    prepare get_query from @get_query;
    execute get_query;
    

    if (has_before and (ba_mode = 'once')) then
            set @_sql_before = sql_before;
            set @_sql_before = replace(@_sql_before, db_placeholder,        db_name);
            set @_sql_before = replace(@_sql_before, table_placeholder,     table_name);
            prepare before_query from @_sql_before;
            execute before_query;
            deallocate prepare before_query;
    end if;

    set done    = false;
    set counter = 0;
    open get_data;

    FOR_LOOP:
    loop
        fetch get_data into theitem1, theitem2, theitem3;
        if (done) then
            leave FOR_LOOP;
        end if;
        set counter = counter + 1;
        if (has_done ) then
            set @_done_cond = concat( 'set @IS_DONE = ', done_cond);
            set @_done_cond = replace(@_done_cond, counter_placeholder,   counter);
            set @_done_cond = replace(@_done_cond, db_placeholder,        db_name);
            set @_done_cond = replace(@_done_cond, table_placeholder,     table_name);
            set @_done_cond = replace(@_done_cond, item_placeholder1,     theitem1);
            set @_done_cond = replace(@_done_cond, item_placeholder2,     theitem2);
            set @_done_cond = replace(@_done_cond, item_placeholder3,     theitem3);
            
            prepare done_query from @_done_cond;
            
            execute done_query;
            deallocate prepare done_query;
            if (@IS_DONE) then
                leave FOR_LOOP;
            end if;
        end if;
         if (has_before and ( ba_mode = 'many')) then
            set @_sql_before = sql_before;
            set @_sql_before = replace(@_sql_before, counter_placeholder,   counter);
            set @_sql_before = replace(@_sql_before, db_placeholder,        db_name);
            set @_sql_before = replace(@_sql_before, table_placeholder,     table_name);
            set @_sql_before = replace(@_sql_before, item_placeholder1,     theitem1);
            set @_sql_before = replace(@_sql_before, item_placeholder2,     theitem2);
            set @_sql_before = replace(@_sql_before, item_placeholder3,     theitem3);
            
            prepare before_query from @_sql_before;
            execute before_query;
            deallocate prepare before_query;
        end if;
 
        set @_for_query = sql_command;
        set @_for_query = replace(@_for_query, counter_placeholder, counter);
        set @_for_query = replace(@_for_query, db_placeholder,      db_name);
        set @_for_query = replace(@_for_query, table_placeholder,   table_name);
        set @_for_query = replace(@_for_query, item_placeholder1,   theitem1);
        set @_for_query = replace(@_for_query, item_placeholder2,   theitem2);
        set @_for_query = replace(@_for_query, item_placeholder3,   theitem3);
        
        prepare for_query from @_for_query;
        execute for_query;
        deallocate prepare for_query;
        set @_for_query = NULL;

        if (has_after and (ba_mode = 'many')) then
            set @_sql_after = sql_after;
            set @_sql_after = replace(@_sql_after, counter_placeholder,  counter);
            set @_sql_after = replace(@_sql_after, db_placeholder,       db_name);
            set @_sql_after = replace(@_sql_after, table_placeholder,    table_name);
            set @_sql_after = replace(@_sql_after, counter_placeholder,  counter);
            set @_sql_after = replace(@_sql_after, item_placeholder1,    theitem1);
            set @_sql_after = replace(@_sql_after, item_placeholder2,    theitem2);
            set @_sql_after = replace(@_sql_after, item_placeholder3,    theitem3);
            
            prepare after_query from @_sql_after;
            execute after_query;
            deallocate prepare after_query;
        end if;

    end loop;
    if (has_after and (ba_mode = 'once')) then
            set @_sql_after = sql_after;
            set @_sql_after = replace(@_sql_after, counter_placeholder,  counter);
            set @_sql_after = replace(@_sql_after, db_placeholder,       db_name);
            set @_sql_after = replace(@_sql_after, table_placeholder,    table_name);
            prepare after_query from @_sql_after;
            execute after_query;
            deallocate prepare after_query;
    end if;
 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `for_each_table_value_simple` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `for_each_table_value_simple`(
    db_name          varchar(50),
    table_name       varchar(50),
    wanted_col       varchar(50),
    search_condition text,
    sql_command      text
)
    MODIFIES SQL DATA
begin
    call for_each_table_value_complete(db_name,table_name,
            wanted_col, 
            null,          
            null,          
            search_condition,sql_command,
            null,          
            null,          
            null,          
            'once');
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `for_once` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `for_once`( sql_command text )
    MODIFIES SQL DATA
begin
    call for_each_counter(1,1,1,sql_command);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `for_once_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `for_once_complete`( 
    sql_command text,
    sql_before  text,
    sql_after   text )
    MODIFIES SQL DATA
begin
    call for_each_counter_complete(1,1,1,sql_command,sql_before, sql_after,'once');
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_auth_general_cursor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `get_auth_general_cursor`(IN ai_server_user  VARCHAR(20),
       IN ai_proxy_user  VARCHAR(20),
       IN ai_num_criteria  INTEGER,
       IN ai_id1  VARCHAR(30), IN ai_value1  VARCHAR(255),
       IN ai_id2  VARCHAR(30), IN ai_value2  VARCHAR(255),
       IN ai_id3  VARCHAR(30), IN ai_value3  VARCHAR(255),
       IN ai_id4  VARCHAR(30), IN ai_value4  VARCHAR(255),
       IN ai_id5  VARCHAR(30), IN ai_value5  VARCHAR(255),
       IN ai_id6  VARCHAR(30), IN ai_value6  VARCHAR(255),
       IN ai_id7  VARCHAR(30), IN ai_value7  VARCHAR(255),
       IN ai_id8  VARCHAR(30), IN ai_value8  VARCHAR(255),
       IN ai_id9  VARCHAR(30), IN ai_value9  VARCHAR(255),
       IN ai_id10  VARCHAR(30), IN ai_value10  VARCHAR(255),
       IN ai_id11  VARCHAR(30), IN ai_value11  VARCHAR(255),
       IN ai_id12  VARCHAR(30), IN ai_value12  VARCHAR(255),
       IN ai_id13  VARCHAR(30), IN ai_value13  VARCHAR(255),
       IN ai_id14  VARCHAR(30), IN ai_value14  VARCHAR(255),
       IN ai_id15  VARCHAR(30), IN ai_value15  VARCHAR(255),
       IN ai_id16  VARCHAR(30), IN ai_value16  VARCHAR(255),
       IN ai_id17  VARCHAR(30), IN ai_value17  VARCHAR(255),
       IN ai_id18  VARCHAR(30), IN ai_value18  VARCHAR(255),
       IN ai_id19  VARCHAR(30), IN ai_value19  VARCHAR(255),
       IN ai_id20  VARCHAR(30), IN ai_value20  VARCHAR(255))
BEGIN
    DECLARE v_statement varchar(10000);
    DECLARE v_error_no integer;
    DECLARE v_error_msg varchar(2000);

   CALL rolessrv.get_auth_general_sql
( ai_server_user  ,
        ai_proxy_user  ,
        ai_num_criteria  ,
        ai_id1  ,  ai_value1  ,
        ai_id2  ,  ai_value2  ,
        ai_id3  ,  ai_value3  ,
        ai_id4  ,  ai_value4  ,
        ai_id5  ,  ai_value5  ,
        ai_id6  ,  ai_value6  ,
        ai_id7  ,  ai_value7  ,
        ai_id8  ,  ai_value8  ,
        ai_id9  ,  ai_value9  ,
        ai_id10  ,  ai_value10  ,
        ai_id11  ,  ai_value11  ,
        ai_id12  ,  ai_value12  ,
        ai_id13  ,  ai_value13  ,
        ai_id14  ,  ai_value14  ,
        ai_id15  ,  ai_value15  ,
        ai_id16  ,  ai_value16  ,
        ai_id17  ,  ai_value17  ,
        ai_id18  ,  ai_value18  ,
        ai_id19  ,  ai_value19  ,
        ai_id20  ,  ai_value20  ,
       v_error_no, v_error_msg, v_statement);

   if (v_error_no is not null || v_error_no != 0 ) then
     CALL rolesbb.permit_signal(v_error_no, v_error_msg);
   end if;

   SET @sql1 = v_statement;
   PREPARE s1 FROM @sql1;
   EXECUTE s1;
   DEALLOCATE PREPARE s1;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_auth_general_sql` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `get_auth_general_sql`(IN ai_server_user  VARCHAR(20),
       IN ai_proxy_user  VARCHAR(20),
       IN ai_num_criteria  INTEGER, 
       IN ai_id1  VARCHAR(30), IN ai_value1  VARCHAR(255),
       IN ai_id2  VARCHAR(30), IN ai_value2  VARCHAR(255),
       IN ai_id3  VARCHAR(30), IN ai_value3  VARCHAR(255),
       IN ai_id4  VARCHAR(30), IN ai_value4  VARCHAR(255),
       IN ai_id5  VARCHAR(30), IN ai_value5  VARCHAR(255),
       IN ai_id6  VARCHAR(30), IN ai_value6  VARCHAR(255),
       IN ai_id7  VARCHAR(30), IN ai_value7  VARCHAR(255),
       IN ai_id8  VARCHAR(30), IN ai_value8  VARCHAR(255),
       IN ai_id9  VARCHAR(30), IN ai_value9  VARCHAR(255),
       IN ai_id10  VARCHAR(30), IN ai_value10  VARCHAR(255),
       IN ai_id11  VARCHAR(30), IN ai_value11  VARCHAR(255),
       IN ai_id12  VARCHAR(30), IN ai_value12  VARCHAR(255),
       IN ai_id13  VARCHAR(30), IN ai_value13  VARCHAR(255),
       IN ai_id14  VARCHAR(30), IN ai_value14  VARCHAR(255),
       IN ai_id15  VARCHAR(30), IN ai_value15  VARCHAR(255),
       IN ai_id16  VARCHAR(30), IN ai_value16  VARCHAR(255),
       IN ai_id17  VARCHAR(30), IN ai_value17  VARCHAR(255),
       IN ai_id18  VARCHAR(30), IN ai_value18  VARCHAR(255),
       IN ai_id19  VARCHAR(30), IN ai_value19  VARCHAR(255),
       IN ai_id20  VARCHAR(30), IN ai_value20  VARCHAR(255),
       OUT ao_error_no  VARCHAR(10),
       OUT ao_error_msg  VARCHAR(255),
       OUT ao_sql_statement  VARCHAR(10000))
BEGIN
  
  DECLARE v_server_user VARCHAR(20);
  DECLARE v_proxy_user VARCHAR(20);

  
  
  
  

  DECLARE i integer DEFAULT 0;
  DECLARE v_num_criteria INTEGER;
  DECLARE cond_fragment VARCHAR(350);
  DECLARE b_found_left_par VARCHAR(1) DEFAULT 'F';
  DECLARE b_found_or VARCHAR(1) DEFAULT 'F';
  DECLARE v_function_category varchar(255) ;
  DECLARE v_function_name varchar(255) ;
  DECLARE v_kerberos_name varchar(255) DEFAULT '';
  DECLARE v_check_auth varchar(1);
  DECLARE v_category_string VARCHAR(2000) DEFAULT '';
  DECLARE v_cat_criteria VARCHAR(2040) DEFAULT '';
  DECLARE v_count integer;
  DECLARE v_error_msg varchar(255);
  DECLARE v_error_no integer;
  DECLARE service_function_name varchar(30) DEFAULT 'RUN ROLES SERVICE PROCEDURES';
  DECLARE iloop INTEGER;
  DECLARE query_id INTEGER;
  DECLARE crit_id INTEGER;
  DECLARE crit_array_name VARCHAR(20);
  DECLARE crit_key VARCHAR(30);
  DECLARE crit_value VARCHAR(255);
  DECLARE category_crit_id integer DEFAULT 210;
  DECLARE function_name_crit_id integer DEFAULT 215;
  DECLARE kerberos_name_crit_id integer DEFAULT 205;


  SELECT  RAND() * 10000 INTO  query_id;
  
  SELECT CONCAT('crit_array',query_id) into crit_array_name;
  call array_create(crit_array_name,20);
  		
  
  
  IF (ai_num_criteria > 0) THEN
  call array_set_key_by_index(crit_array_name,1,ai_id1);
  call array_set_value_by_index(crit_array_name,1,ai_value1);
  END IF;

  
  IF (ai_num_criteria > 1) THEN
  call array_set_key_by_index(crit_array_name,2,ai_id2);
  call array_set_value_by_index(crit_array_name,2,ai_value2);
  END IF;

  
  IF (ai_num_criteria > 2) THEN
  call array_set_key_by_index(crit_array_name,3,ai_id3);
  call array_set_value_by_index(crit_array_name,3,ai_value3);
  END IF;

  
  IF (ai_num_criteria > 3) THEN
  call array_set_key_by_index(crit_array_name,4,ai_id4);
  call array_set_value_by_index(crit_array_name,4,ai_value4);
  END IF;

  
  IF (ai_num_criteria > 4) THEN
  call array_set_key_by_index(crit_array_name,5,ai_id5);
  call array_set_value_by_index(crit_array_name,5,ai_value5);
  END IF;

  IF (ai_num_criteria > 5) THEN

  
  call array_set_key_by_index(crit_array_name,6,ai_id6);
  call array_set_value_by_index(crit_array_name,6,ai_value6);
  END IF;

  IF (ai_num_criteria > 6) THEN

  
  call array_set_key_by_index(crit_array_name,7,crit_id);
  call array_set_value_by_index(crit_array_name,7,ai_value7);
  END IF;

  IF (ai_num_criteria > 7) THEN

  
  call array_set_key_by_index(crit_array_name,8,ai_id7);
  call array_set_value_by_index(crit_array_name,8,ai_value8);
  END IF;

  IF (ai_num_criteria > 8) THEN

  
  call array_set_key_by_index(crit_array_name,9,ai_id9);
  call array_set_value_by_index(crit_array_name,9,ai_value9);
  END IF;

  IF (ai_num_criteria > 9) THEN

  
  call array_set_key_by_index(crit_array_name,10,ai_id10);
  call array_set_value_by_index(crit_array_name,10,ai_value10);
  END IF;

  IF (ai_num_criteria > 10) THEN

  
  call array_set_key_by_index(crit_array_name,11,ai_id11);
  call array_set_value_by_index(crit_array_name,11,ai_value11);
  END IF;

  IF (ai_num_criteria > 11) THEN

  
  call array_set_key_by_index(crit_array_name,12,ai_id12);
  call array_set_value_by_index(crit_array_name,12,ai_value12);
  END IF;

  IF (ai_num_criteria > 12) THEN

  
  call array_set_key_by_index(crit_array_name,13,ai_id13);
  call array_set_value_by_index(crit_array_name,13,ai_value13);
  END IF;

  IF (ai_num_criteria > 13) THEN

  
  call array_set_key_by_index(crit_array_name,14,ai_id14);
  call array_set_value_by_index(crit_array_name,14,ai_value14);
  END IF;

  IF (ai_num_criteria > 14) THEN

  
  call array_set_key_by_index(crit_array_name,15,ai_id15);
  call array_set_value_by_index(crit_array_name,15,ai_value15);
  END IF;

  IF (ai_num_criteria > 15) THEN

  
  call array_set_key_by_index(crit_array_name,16,ai_id16);
  call array_set_value_by_index(crit_array_name,16,ai_value16);
  END IF;

  IF (ai_num_criteria > 16) THEN

  
  call array_set_key_by_index(crit_array_name,17,ai_id17);
  call array_set_value_by_index(crit_array_name,17,ai_value17);
  END IF;

  IF (ai_num_criteria > 17) THEN

  
  call array_set_key_by_index(crit_array_name,18,ai_id18);
  call array_set_value_by_index(crit_array_name,18,ai_value18);
  END IF;

  IF (ai_num_criteria > 18) THEN

  
  call array_set_key_by_index(crit_array_name,19,ai_id19);
  call array_set_value_by_index(crit_array_name,19,ai_value19);
  END IF;

  IF (ai_num_criteria > 19) THEN

  
  call array_set_key_by_index(crit_array_name,20,ai_id20);
  call array_set_value_by_index(crit_array_name,20,ai_value20);
  END IF;


  SET v_proxy_user = upper(IFNULL(ai_proxy_user, ai_server_user));
  SET v_server_user = IFNULL(upper(ai_server_user), USER());
  
  SET v_num_criteria = ai_num_criteria;

  SET iloop = 1;

  WHILE iloop <= v_num_criteria DO 

     SELECT array_get_key_by_index(crit_array_name,iloop) INTO crit_key ;
     SELECT array_get_value_by_index(crit_array_name,iloop) INTO crit_value ;

     SELECT get_sql_fragment(v_proxy_user, crit_key, crit_value) INTO cond_fragment from dual;
     IF SUBSTR(COND_FRAGMENT,1,3) = 'OR ' THEN
       SET B_FOUND_OR = 'T';
     END IF;
     IF SUBSTR(COND_FRAGMENT,1,1) = '(' THEN
       SET B_FOUND_LEFT_PAR = 'T';
     END IF;
     SET iloop = iloop+1;
   END WHILE;



  SET ao_sql_statement =
    CONCAT('select a.kerberos_name kerberosName,  a.function_category functionCategory, a.function_name functionName,'
     , ' a.qualifier_code qualifierCode, a.qualifier_name qualfierName , '
     , ' rolesbb.auth_sf_is_auth_active(a.do_function, a.effective_date,'
     , '     a.expiration_date) is_active_now,'
     , ' CASE a.grant_and_view WHEN ''GD'' THEN ''G'' ELSE  ''N'' END grant_authorization,'
     , ' a.authorization_id, a.function_id, a.qualifier_id, '
     , ' a.do_function, a.effective_date, a.expiration_date,'
     , ' a.modified_by, a.modified_date, p.first_name, p.last_name, '
     , ' f.qualifier_type, f.function_description'
    , ' from rolesbb.authorization a, rolesbb.function f, rolesbb.person p ');

  SET iloop = 1;

  WHILE iloop <= v_num_criteria DO 

     SELECT array_get_key_by_index(crit_array_name,iloop) INTO crit_key FROM dual ;
     SELECT array_get_value_by_index(crit_array_name,iloop) INTO crit_value FROM dual;

    if crit_key = category_crit_id then
     SET v_function_category = upper(crit_value);
    elseif crit_key = function_name_crit_id then
     SET v_function_name = upper(crit_value);
    elseif crit_key= kerberos_name_crit_id then
     SET v_kerberos_name = upper(crit_value);
    end if;

    SELECT get_sql_fragment(v_proxy_user, crit_key, crit_value) INTO cond_fragment from dual;

    IF LENGTH(COND_FRAGMENT) > 0 THEN
       
       IF (COND_FRAGMENT =
        'rolesbb.auth_sf_is_auth_current(a.effective_date,a.expiration_date) = ''Y''')
       THEN
         SET COND_FRAGMENT =  'sysdate() between a.effective_date and IFNULL(a.expiration_date,sysdate())';
       END IF;
       IF (COND_FRAGMENT =
        'rolesbb.auth_sf_is_auth_current(a.effective_date,a.expiration_date) = ''N''')
       THEN
         SET COND_FRAGMENT =
         'sysdate() not between a.effective_date and IFNULL(a.expiration_date,sysdate())';
       END IF;
       
       IF (SUBSTR(COND_FRAGMENT,1,7) = '(a.kerb'
           AND (B_FOUND_OR = 'F')) THEN
          SET COND_FRAGMENT = SUBSTR(COND_FRAGMENT,2);
       END IF;
       
       IF (SUBSTR(COND_FRAGMENT,1,3) = 'OR ' AND ( B_FOUND_LEFT_PAR = 'F')) THEN
          SET COND_FRAGMENT = SUBSTR(COND_FRAGMENT,3);
          SET COND_FRAGMENT = SUBSTR(COND_FRAGMENT,1,LENGTH(COND_FRAGMENT)-1);
       END IF;
       
       IF iloop = 1 THEN
         SET ao_sql_statement = CONCAT(ao_sql_statement
           , ' WHERE f.function_id = a.function_id AND'
           , ' p.kerberos_name = a.kerberos_name AND ');
       ELSE 
         IF SUBSTR(COND_FRAGMENT,1,3) != 'OR ' THEN
           SET ao_sql_statement = CONCAT(ao_sql_statement , ' AND ');
         ELSE
           SET ao_sql_statement = CONCAT(ao_sql_statement , ' ');
         END IF;
       END IF;
       SET ao_sql_statement = CONCAT(ao_sql_statement
                           , ' /* crit ' , iloop , ' */ ');
       SET ao_sql_statement = CONCAT(ao_sql_statement , COND_FRAGMENT);
    END IF;
     SET iloop = iloop+1;
   END WHILE;

  
  if (v_function_category is null and v_function_name is not null) then
    select count(*) into v_count from rolesbb.function
      where function_name = v_function_name;
    if v_count = 0 then
      SET v_error_no = -20021;
      SET v_error_msg = GetErrorMessage(-200213);
      SET v_error_msg = replace(v_error_msg, '<function_name>',
                            v_function_name);
      call rolesbb.permit_signal(v_error_no, v_error_msg);
    else
      select min(function_category) into v_function_category from rolesbb.function
        where function_category = v_function_name;
    end if;
  end if;
  if v_function_category is not null then
    
    
    select rolesbb.rolesapi_is_user_authorized(ai_server_user,
           service_function_name,
           CONCAT('CAT' , rtrim(v_function_category)))
         into v_check_auth from dual;
    if (v_check_auth <> 'Y') then
      SET v_error_no = -20003;
      SET v_error_msg = GetErrorMessage(-20003);
      SET v_error_msg = replace(v_error_msg, '<server_id>',
                             ai_server_user);   
      SET v_error_msg = replace(v_error_msg, '<function_category>',
                             v_function_category);
      call rolesbb.permit_signal(v_error_no, v_error_msg);
    end if;
    
    if (v_proxy_user = v_server_user) then
      SET v_check_auth = 'Y';
    elseif (v_proxy_user = v_kerberos_name) then
      SET v_check_auth = 'Y';
    else
      select count(*) into v_count from rolesbb.viewable_category
        where kerberos_name = v_proxy_user
        and function_category = rpad(v_function_category, 4,' ');
      if v_count > 0 then
         SET v_check_auth = 'Y';
      else
         SET v_check_auth = 'N';
      end if;
    end if;
    if (v_check_auth <> 'Y') then
      SET v_error_no = -20005;
      SET v_error_msg = GetErrorMessage(-20005);
      SET v_error_msg = replace(v_error_msg, '<proxy_user>',
                            v_proxy_user);
      SET v_error_msg = replace(v_error_msg, '<function_category>',
                            v_function_category);
      call rolesbb.permit_signal(v_error_no, v_error_msg);
    end if;
  else
  
    SELECT   get_view_category_list(v_server_user,
                                                          v_proxy_user) INTO v_category_string from dual;
    SET v_cat_criteria = CONCAT(' and a.function_category in (' , v_category_string
                        , ')');
  end if;

  SET ao_sql_statement = CONCAT(ao_sql_statement , v_cat_criteria);
  
  if (b_found_or = 'T'	) then
    SET ao_sql_statement = CONCAT(ao_sql_statement
          , ' ORDER BY functionCategory, ');
    SET ao_sql_statement = CONCAT(ao_sql_statement
          , ' functionName, qualifierCode, kerberosName');
  else
    SET ao_sql_statement = CONCAT(ao_sql_statement
          , ' ORDER BY kerberosName, functionCategory, ');
    SET ao_sql_statement = CONCAT(ao_sql_statement
          , ' functionName, qualifierCode');
  end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_auth_person_cursor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `get_auth_person_cursor`(in ai_server_user VARCHAR(20),
       in ai_proxy_user  VARCHAR(20),
       in ai_kerberos_name  VARCHAR(20),
       in ai_function_category  VARCHAR(4),
       in ai_expand_qualifiers  VARCHAR(100),
       in ai_is_active_now  VARCHAR(1),
       in ai_opt_function_name  VARCHAR(100),
       in ai_opt_function_id  VARCHAR(10),
       in ai_opt_qualifier_type  VARCHAR(10),
       in ai_opt_qualifier_code  VARCHAR(20),
       in ai_opt_qualifier_id  VARCHAR(10),
       in ai_opt_base_qual_code  VARCHAR(10),
       in ai_opt_base_qual_id  VARCHAR(10),
       in ai_opt_parent_qual_code  VARCHAR(10),
       in ai_opt_parent_qual_id  VARCHAR(10),
       in ai_opt_child_qual_code  VARCHAR(10),
       in ai_opt_child_qual_id  VARCHAR(10))
BEGIN
    DECLARE v_statement varchar(10000);
    DECLARE v_error_no integer;
    DECLARE v_error_msg varchar(2000);

   CALL get_auth_person_sql
      (ai_server_user, ai_proxy_user, ai_kerberos_name,
       ai_function_category, ai_expand_qualifiers, ai_is_active_now,
       ai_opt_function_name, ai_opt_function_id, ai_opt_qualifier_type,
       ai_opt_qualifier_code, ai_opt_qualifier_id,
       ai_opt_base_qual_code, ai_opt_base_qual_id,
       ai_opt_parent_qual_code, ai_opt_parent_qual_id,
       ai_opt_child_qual_code, ai_opt_child_qual_id,
       v_error_no, v_error_msg, v_statement);

   if (v_error_no is not null || v_error_no != 0 ) then
     CALL rolesbb.permit_signal(v_error_no, v_error_msg);
   end if;

   SET @sql1 = v_statement;
   PREPARE s1 FROM @sql1;
   EXECUTE s1;
   DEALLOCATE PREPARE s1;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_auth_person_cursor2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `get_auth_person_cursor2`(in ai_server_user VARCHAR(20),
       in ai_proxy_user  VARCHAR(20),
       in ai_kerberos_name  VARCHAR(20),
       in ai_function_category  VARCHAR(4),
       in ai_expand_qualifiers  VARCHAR(100),
       in ai_is_active_now  VARCHAR(1),
       in ai_opt_function_name  VARCHAR(100),
       in ai_opt_function_id  VARCHAR(10),
       in ai_opt_qualifier_type  VARCHAR(10),
       in ai_opt_qualifier_code  VARCHAR(20),
       in ai_opt_qualifier_id  VARCHAR(10),
       in ai_opt_base_qual_code  VARCHAR(10),
       in ai_opt_base_qual_id  VARCHAR(10),
       in ai_opt_parent_qual_code  VARCHAR(10),
       in ai_opt_parent_qual_id  VARCHAR(10),
       in ai_opt_child_qual_code  VARCHAR(10),
       in ai_opt_child_qual_id  VARCHAR(10))
BEGIN
    DECLARE v_statement varchar(10000);
    DECLARE v_error_no integer;
    DECLARE v_error_msg varchar(2000);

   CALL get_auth_person_sql2
      (ai_server_user, ai_proxy_user, ai_kerberos_name,
       ai_function_category, ai_expand_qualifiers, ai_is_active_now,
       ai_opt_function_name, ai_opt_function_id, ai_opt_qualifier_type,
       ai_opt_qualifier_code, ai_opt_qualifier_id,
       ai_opt_base_qual_code, ai_opt_base_qual_id,
       ai_opt_parent_qual_code, ai_opt_parent_qual_id,
       ai_opt_child_qual_code, ai_opt_child_qual_id,
       v_error_no, v_error_msg, v_statement);

   if (v_error_no is not null || v_error_no != 0 ) then
     CALL rolesbb.permit_signal(v_error_no, v_error_msg);
   end if;

   SET @sql1 = v_statement;
   PREPARE s1 FROM @sql1;
   EXECUTE s1;
   DEALLOCATE PREPARE s1;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_auth_person_sql` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `get_auth_person_sql`(in ai_server_user VARCHAR(20),
       in ai_proxy_user  VARCHAR(20),
       in ai_kerberos_name  VARCHAR(20),
       in ai_function_category  VARCHAR(4),
       in ai_expand_qualifiers  VARCHAR(100),
       in ai_is_active_now  VARCHAR(1),
       in ai_opt_function_name  VARCHAR(100),
       in ai_opt_function_id  VARCHAR(10),
       in ai_opt_qualifier_type  VARCHAR(10),
       in ai_opt_qualifier_code  VARCHAR(20),
       in ai_opt_qualifier_id  VARCHAR(10),
       in ai_opt_base_qual_code  VARCHAR(10),
       in ai_opt_base_qual_id  VARCHAR(10),
       in ai_opt_parent_qual_code  VARCHAR(10),
       in ai_opt_parent_qual_id  VARCHAR(10),
       in ai_opt_child_qual_code  VARCHAR(10),
       in ai_opt_child_qual_id  VARCHAR(10),
       OUT ao_error_no  INTEGER,
       OUT ao_error_msg  VARCHAR(255),
       OUT ao_sql_statement  VARCHAR(10000))
BEGIN
  DECLARE v_kerberos_name VARCHAR(20);
  DECLARE v_server_user VARCHAR(20);
  DECLARE v_proxy_user VARCHAR(20);
  DECLARE v_function_id INTEGER;
  DECLARE v_function_category VARCHAR(4);
  DECLARE v_eval_function_category VARCHAR(4);
  DECLARE v_function_name VARCHAR(100);
  DECLARE v_function_name_wildcard VARCHAR(100);  
  DECLARE v_qualifier_type VARCHAR(10);
  DECLARE v_qualifier_code VARCHAR(20);
  DECLARE v_qualifier_id INTEGER;
  DECLARE v_error_msg VARCHAR(255);
  DECLARE v_error_no integer;
  DECLARE v_count integer;
  DECLARE v_check_auth VARCHAR(1);
  DECLARE v_location VARCHAR(2);
  DECLARE outstring VARCHAR(10000) DEFAULT '';

  
  DECLARE c_is_active_now_phrase VARCHAR(200) DEFAULT '';
  DECLARE c_function_category_phrase VARCHAR(200) DEFAULT '';
  DECLARE c_function_name_phrase VARCHAR(200) DEFAULT '';
  DECLARE c_function_id_phrase VARCHAR(200) DEFAULT '';
  DECLARE c_kerberos_name_phrase VARCHAR(200) DEFAULT '';
  DECLARE v_select_fields VARCHAR(2000) DEFAULT '';
  DECLARE v_from1f VARCHAR(250) DEFAULT '';
  DECLARE v_from2f VARCHAR(250) DEFAULT '';
  DECLARE v_from1s VARCHAR(250) DEFAULT '';
  DECLARE v_from2s VARCHAR(250) DEFAULT '';
  DECLARE v_from1w VARCHAR(250) DEFAULT ' ';

  DECLARE v_from2w VARCHAR(250) DEFAULT '';

  DECLARE v_counter integer;
  DECLARE v_select_fields_2s VARCHAR(2000);
  DECLARE v_criteria1 VARCHAR(2000) DEFAULT '';
  DECLARE v_criteria2 VARCHAR(2000) DEFAULT '';
  DECLARE v_criteria12 VARCHAR(5000) DEFAULT '';
 DECLARE max_function_category_size INTEGER DEFAULT 4;
   DECLARE max_function_name_size INTEGER DEFAULT 30;

  SET c_is_active_now_phrase = CONCAT('a.do_function = ''Y'' and SYSDATE() between a.effective_date'
                , ' and IFNULL(a.expiration_date,SYSDATE())');

  SET c_function_category_phrase  =
          CONCAT('a.function_category = ''' , upper(ai_function_category), '''');
  SET c_function_name_phrase  =
                CONCAT('a.function_name = ''' , upper(ai_opt_function_name) , '''');
  SET c_function_id_phrase  =
                CONCAT('a.function_id = ''' , ai_opt_function_id , '''');
  SET c_kerberos_name_phrase  =
                CONCAT('a.kerberos_name = ''' , upper(ai_kerberos_name) , '''');
  SET v_select_fields  =
    CONCAT('select a.kerberos_name,  a.function_category, a.function_name,'
     , ' a.qualifier_code, a.qualifier_name, '
     , ' auth_sf_is_auth_active(a.do_function, a.effective_date,'
     , '     a.expiration_date) is_active_now,'
     , ' CASE a.grant_and_view WHEN ''GD'' THEN ''G'' ELSE ''N'' END grant_authorization,'
     , ' a.authorization_id, a.function_id, a.qualifier_id, '
     , ' a.do_function, a.effective_date, a.expiration_date');
  SET v_from1f  = ' from authorization a';
  SET v_from2f  =
       ' from qualifier q, qualifier_descendent qd, authorization a';
  SET v_from1s  = ' from authorization a, qualifier q1';
  SET v_from2s  =
       CONCAT(' from authorization a, qualifier q1, qualifier_descendent qd,'
    , ' qualifier q2');
  SET v_from1w  = ' from authorization a, person p';

  SET v_from2w = CONCAT(
       ' from qualifier q, qualifier_descendent qd, authorization a,'
    ,' person p');

  SET v_select_fields_2s = replace(v_select_fields, 'a.qualifier_code',
                                                 'q2.qualifier_code');
  SET v_select_fields_2s = replace(v_select_fields_2s, 'a.qualifier_name',
                                                    'q2.qualifier_name');
  SET v_select_fields_2s = replace(v_select_fields_2s, 'a.qualifier_id',
                                                    'q2.qualifier_id');

  SET v_kerberos_name = upper(ai_kerberos_name);
  SET v_server_user = upper(ai_server_user);
  SET v_proxy_user = upper(ai_proxy_user);
  SET v_location = 'A';

  
  if (length(ai_function_category) >
      max_function_category_size) then
    SET v_error_no = -20028;
    SET v_error_msg = replace(GetErrorMessage(-20028),
                            '<function_category>', ai_function_category);
  else
    SET v_function_category = upper(ai_function_category);
  end if;

  
  if (length(ai_opt_function_name) >
      max_function_name_size) then
    SET v_error_no = -20029;
    SET v_error_msg = replace(GetErrorMessage(-20029),
                            '<function_name>', ai_opt_function_name);
  else
    if (substr(ai_opt_function_name, -2, 2) = '\*') then
      SET v_function_name =
        CONCAT(substr(upper(ai_opt_function_name), 1, length(ai_opt_function_name)-2)
        ,'*');
      SET c_function_name_phrase =
               CONCAT( 'a.function_name = ''' , v_function_name , '''');
    elseif (substr(ai_opt_function_name, -1, 1) = '*') then
      SET v_function_name_wildcard =
        CONCAT(substr(upper(ai_opt_function_name), 1, length(ai_opt_function_name)-1)
        , '%');
      SET c_function_name_phrase =
                CONCAT('a.function_name like ''' , v_function_name_wildcard , '''');
    else
      SET v_function_name = upper(ai_opt_function_name);
      SET c_function_name_phrase =
                   CONCAT('a.function_name = ''' , v_function_name , '''');
   end if;
  end if;


  if (v_kerberos_name is null) then
    SET v_error_no = -20030;
    SET v_error_msg = GetErrorMessage(-20030);
  end if;

  
  if (v_error_no is null) then 
    if (ai_function_category is null and v_function_name is not null) then
      SET v_error_no = -20027;
      SET v_error_msg = GetErrorMessage(-20027);
    end if;
    
    if (ai_function_category is null and v_function_name_wildcard is not null) 
    then
      SET v_error_no = -20027;
      SET v_error_msg = GetErrorMessage(-20027);
    end if;
    
  end if;
  SET v_location = 'B';

  
  if (v_error_no is null) then
    if (ai_opt_function_id is not null) then
      if ( not ai_opt_function_id REGEXP '[0-9]*')

      
      then

        SET v_error_no = -20021;
        SET v_error_msg = replace(GetErrorMessage(-200211), 
                              '<function_id>', ai_opt_function_id);
      else
        SELECT  CAST(ai_opt_function_id AS UNSIGNED ) AS v_function_id ;
      end if;
    end if;
  end if;


  if (v_error_no is null) then
    if (ai_opt_qualifier_id is not null) then
       if ( not ai_opt_qualifier_id REGEXP '[0-9]*')


      then

        SET v_error_no = -20022;
        SET v_error_msg = GetErrorMessage(-200221);
        SET v_error_msg = replace(v_error_msg, '<qualifier_id>',
                               ai_opt_qualifier_id);
        SET v_error_msg = replace(v_error_msg, '<qualifier_type>',
                               '(any)');
      else
        SELECT CAST(ai_opt_qualifier_id AS UNSIGNED) AS v_qualifier_id ;
      end if;
    end if;
  end if;

  
  
  
  
  
  
  
  if (ai_opt_qualifier_type is not null) then
      if (length(ai_opt_qualifier_type) > 4)
      then

        SET v_error_no = -20031;
        SET v_error_msg = replace(GetErrorMessage(-20031),
                              '<qualifier_type>', ai_opt_qualifier_type);
      else
        SET v_qualifier_type = ai_opt_qualifier_type;
      end if;


  
  
  elseif (v_function_name is not null) then

    select count(*) into v_count from rolesbb.function
       where function_category = upper(ai_function_category)
       and function_name = upper(ai_opt_function_name);
    if v_count = 0 then
      SET v_error_no = -20021;
      SET v_error_msg = GetErrorMessage(-200212);
      SET v_error_msg = replace(v_error_msg, '<function_name>',
                            ai_opt_function_name);
      SET v_error_msg = replace(v_error_msg, '<function_category>',
                            ai_function_category);
    end if;
    select function_id, qualifier_type
      into v_function_id, v_qualifier_type
      from rolesbb.function
      where function_category = upper(ai_function_category)
      and function_name = v_function_name;


  
  elseif (v_function_id is not null) then
    select qualifier_type
      into v_qualifier_type
      from rolesbb.function
      where function_id = v_function_id;
  
  
  elseif (v_qualifier_id is not null) then
    select qualifier_type
      into v_qualifier_type
      from rolesbb.qualifier
      where qualifier_id = v_qualifier_id;
  end if;

  
  if (ai_opt_qualifier_code is not null and v_qualifier_type is null) then
      SET v_error_no = -20023;
      SET v_error_msg = replace(GetErrorMessage(-20023),
                             '<argument_name>', 'Qualifier Code');
  end if;

  
  if (ai_opt_base_qual_code is not null and v_qualifier_type is null) then
      SET v_error_no = -20023;
      SET v_error_msg = replace(GetErrorMessage(-20023),
                             '<argument_name>', 'Base Qualifier Code');
  end if;

  
  if (ai_opt_parent_qual_code is not null and v_qualifier_type is null) then
      SET v_error_no = -20023;
      SET v_error_msg = replace(GetErrorMessage(-20023),
                             '<argument_name>', 'Parent Qualifier Code');
  end if;


  if (ai_opt_child_qual_code is not null and v_qualifier_type is null) then
      SET v_error_no = -20023;
      SET v_error_msg = replace(GetErrorMessage(-20023),
                             '<argument_name>', 'Child Qualifier Code');
  end if;

  

  if (v_error_no is null) then
    
    SET v_function_category = upper(ai_function_category);
    if (v_function_category is not null) then
      SET v_eval_function_category = v_function_category;
    elseif (v_function_id is not null) then
      select count(*) into v_count from rolesbb.function
        where function_id = v_function_id;
      if v_count = 0 then
        SET v_error_no = -20021;
        SET v_error_msg = replace(GetErrorMessage(-200211),
                              '<function_id>', ai_opt_function_id);
      else
        select function_category into v_eval_function_category
          from rolesbb.function
          where function_id = v_function_id;
      end if;
    end if;
  end if;
  SET v_location = 'D';


  if (v_error_no is null) then

    select rolesbb.rolesapi_is_user_authorized(ai_server_user,
             service_function_name,
             CONCAT('CAT' ,rtrim(v_eval_function_category)))
           into v_check_auth from dual;
    if (v_check_auth <> 'Y') then
      SET v_error_no = -20003;
      SET v_error_msg = GetErrorMessage(-20003);
      SET v_error_msg = replace(v_error_msg, '<server_id>',
                             ai_server_user);
      SET v_error_msg = replace(v_error_msg, '<function_category>',
                             v_eval_function_category);
    else

      if (v_proxy_user = v_server_user) then
        SET v_check_auth = 'Y';
      elseif (v_proxy_user = v_kerberos_name) then
        SET v_check_auth = 'Y';
      else
        select rolesbb.rolesapi_is_user_authorized(v_proxy_user,
                read_auth_function1,
                 CONCAT('CAT' , rtrim(v_eval_function_category)))
               into v_check_auth from dual;
        if (v_check_auth <> 'Y') then
          select rolesbb.rolesapi_is_user_authorized(v_proxy_user,
                 read_auth_function2,
                 CONCAT('CAT' , rtrim(v_eval_function_category)))
                 into v_check_auth from dual;
        end if;
      end if;
      if (v_check_auth <> 'Y') then
        SET v_error_no = -20005;
        SET v_error_msg = GetErrorMessage(-20005);
        SET v_error_msg = replace(v_error_msg, '<proxy_user>',
                              v_proxy_user);
        SET v_error_msg = replace(v_error_msg, '<function_category>',
                              v_eval_function_category);
      end if;
    end if;
  end if;
  SET v_location = 'E';

  
  if (v_error_no is null) then

    
    SET v_criteria1 = 'WHERE q1.qualifier_id = a.qualifier_id';
    SET v_criteria2 = CONCAT('WHERE q1.qualifier_id = a.qualifier_id'
                 , ' and a.descend = ''Y'''
                 , ' and qd.parent_id = a.qualifier_id'
                 , ' and q2.qualifier_id = qd.child_id');
    SET v_criteria12 = '';
    if ai_is_active_now in ('y', 'Y') then
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' , c_is_active_now_phrase);
    end if;
    if ai_function_category is not null then
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' , c_function_category_phrase);
    end if;
    
    if (v_function_name is not null) then         
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' , c_function_name_phrase);
    end if;
    
    if v_function_name_wildcard is not null then
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' , c_function_name_phrase);
    end if;
    
    if ai_opt_function_id is not null then
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' , c_function_id_phrase);
    end if;
    if ai_opt_qualifier_type is not null then
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' ,
                 'q1.qualifier_type = ''' , ai_opt_qualifier_type , '''');
    end if;
    if ai_opt_qualifier_code is not null then
    
      
      
      
      
      SET v_criteria1 = CONCAT(v_criteria1 , ' and ' ,
                 'q1.qualifier_code = ''' , ai_opt_qualifier_code , '''');
      SET v_criteria2 = CONCAT(v_criteria2 , ' and ' ,
                 'q2.qualifier_code = ''' , ai_opt_qualifier_code , '''');
    
    end if;
    if ai_opt_qualifier_id is not null then
      SET v_criteria1 = CONCAT(v_criteria1 , ' and ' ,
                 'q1.qualifier_id = ''' , ai_opt_qualifier_id , '''');
      SET v_criteria2 = CONCAT(v_criteria2 , ' and ' ,
                 'q2.qualifier_id = ''' , ai_opt_qualifier_id , '''');
    end if;
    if ai_opt_base_qual_code is not null then
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' ,
                 'q1.qualifier_code = ''' ,ai_opt_qualifier_code , '''');
    end if;
    if ai_opt_base_qual_id is not null then
      SET v_criteria12 = CONCAT(v_criteria1 , ' and ' ,
                 'a.qualifier_id = ''' , ai_opt_qualifier_id , '''');
    end if;
    if ai_kerberos_name is not null then
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' , c_kerberos_name_phrase);
    end if;

    
    SET outstring = CONCAT(v_select_fields , ' ' , v_from1s , ' ' , v_criteria1
                                 , v_criteria12);
    if ai_expand_qualifiers in ('y', 'Y') then
       SET outstring = CONCAT(outstring , ' UNION ' , v_select_fields_2s
                    , ' ' , v_from2s , ' ' , v_criteria2 , v_criteria12);
    end if;
    SET ao_sql_statement = outstring;


  else   
    SET ao_error_no = v_error_no;
    SET ao_error_msg = v_error_msg;
    SET v_location = 'E1';
  end if;
  SET v_location = 'F';

  
  
  
  
  

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_auth_person_sql2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `get_auth_person_sql2`(in ai_server_user VARCHAR(20),
       in ai_proxy_user  VARCHAR(20),
       in ai_kerberos_name  VARCHAR(20),
       in ai_function_category  VARCHAR(4),
       in ai_expand_qualifiers  VARCHAR(100),
       in ai_is_active_now  VARCHAR(1),
       in ai_opt_function_name  VARCHAR(100),
       in ai_opt_function_id  VARCHAR(10),
       in ai_opt_qualifier_type  VARCHAR(10),
       in ai_opt_qualifier_code  VARCHAR(20),
       in ai_opt_qualifier_id  VARCHAR(10),
       in ai_opt_base_qual_code  VARCHAR(10),
       in ai_opt_base_qual_id  VARCHAR(10),
       in ai_opt_parent_qual_code  VARCHAR(10),
       in ai_opt_parent_qual_id  VARCHAR(10),
       in ai_opt_child_qual_code  VARCHAR(10),
       in ai_opt_child_qual_id  VARCHAR(10),
       OUT ao_error_no  INTEGER,
       OUT ao_error_msg  VARCHAR(255),
       OUT ao_sql_statement  VARCHAR(10000))
BEGIN
  DECLARE v_kerberos_name VARCHAR(20);
  DECLARE v_server_user VARCHAR(20);
  DECLARE v_proxy_user VARCHAR(20);
  DECLARE v_function_id INTEGER;
  DECLARE v_function_category VARCHAR(4);
  DECLARE v_eval_function_category VARCHAR(4);
  DECLARE v_function_name VARCHAR(100);
  DECLARE v_function_name_wildcard VARCHAR(100);  
  DECLARE v_qualifier_type VARCHAR(10);
  DECLARE v_qualifier_code VARCHAR(20);
  DECLARE v_qualifier_id INTEGER;
  DECLARE v_error_msg VARCHAR(255);
  DECLARE v_error_no integer;
  DECLARE v_count integer;
  DECLARE v_check_auth VARCHAR(1);
  DECLARE v_location VARCHAR(2);
  DECLARE outstring VARCHAR(10000) DEFAULT '';

  DECLARE c_is_active_now_phrase VARCHAR(200) DEFAULT '';
  DECLARE c_function_category_phrase VARCHAR(200) DEFAULT '';
  DECLARE c_function_name_phrase VARCHAR(200) DEFAULT '';
  DECLARE c_function_id_phrase VARCHAR(200) DEFAULT '';
  DECLARE c_kerberos_name_phrase VARCHAR(200) DEFAULT '';
  DECLARE v_select_fields VARCHAR(2000) DEFAULT '';
  DECLARE v_from1f VARCHAR(250) DEFAULT '';
  DECLARE v_from2f VARCHAR(250) DEFAULT '';
  DECLARE v_from1s VARCHAR(250) DEFAULT '';
  DECLARE v_from2s VARCHAR(250) DEFAULT '';
  DECLARE v_from1w VARCHAR(250) DEFAULT ' ';

  DECLARE v_from2w VARCHAR(250) DEFAULT '';

  DECLARE v_counter integer;
  DECLARE v_select_fields_2s VARCHAR(2000);
  DECLARE v_criteria1 VARCHAR(2000) DEFAULT '';
  DECLARE v_criteria2 VARCHAR(2000) DEFAULT '';
  DECLARE v_criteria12 VARCHAR(5000) DEFAULT '';
  
  DECLARE   v_category_string VARCHAR(2000) DEFAULT '';
  DECLARE v_cat_criteria VARCHAR(2040) DEFAULT '';
  DECLARE max_function_category_size INTEGER DEFAULT 4;
  DECLARE max_function_name_size INTEGER DEFAULT 30;
  DECLARE service_function_name varchar(30) DEFAULT 'RUN ROLES SERVICE PROCEDURES';
  DECLARE read_auth_function2   varchar(30) DEFAULT 'CREATE AUTHORIZATIONS';

  
   /*** "Where" phrases to be used for constructing the SELECT statement ***/
  SET c_is_active_now_phrase = CONCAT('a.do_function = ''Y'' and SYSDATE() between a.effective_date'
                , ' and IFNULL(a.expiration_date,SYSDATE())');

  SET c_function_category_phrase  =
          CONCAT('a.function_category = ''' , upper(ai_function_category), '''');
  SET c_function_name_phrase  =
                CONCAT('a.function_name = ''' , upper(ai_opt_function_name) , '''');
  SET c_function_id_phrase  =
                CONCAT('a.function_id = ''' , ai_opt_function_id , '''');
  SET c_kerberos_name_phrase  =
                CONCAT('a.kerberos_name = ''' , upper(ai_kerberos_name) , '''');
                
  SET v_select_fields  =
    CONCAT('select a.kerberos_name,  a.function_category, a.function_name,'
     , ' a.qualifier_code, IFNULL(a.qualifier_name, '' '') qualifier_name, '
     , ' auth_sf_is_auth_active(a.do_function, a.effective_date,'
     , '     a.expiration_date) is_active_now,'
     , ' CASE a.grant_and_view WHEN ''GD'' THEN ''G'' ELSE ''N'' END grant_authorization,'
     , ' a.authorization_id, a.function_id, a.qualifier_id, '
     , ' a.do_function, a.effective_date, a.expiration_date, '
     , ' a.modified_by, a.modified_date, q1.qualifier_type' );
  
  SET v_from1s  = ' from authorization a, qualifier q1';
  
  SET v_from2s = CONCAT(
       ' from authorization a, qualifier q1, qualifier_descendent qd, '
    ,' qualifier q2');

  SET v_select_fields_2s = replace(v_select_fields, 'a.qualifier_code',
                                                 'q2.qualifier_code');
  SET v_select_fields_2s = replace(v_select_fields_2s, 'a.qualifier_name',
                                                    'q2.qualifier_name');
  SET v_select_fields_2s = replace(v_select_fields_2s, 'a.qualifier_id',
                                                    'q2.qualifier_id');

  SET v_kerberos_name = upper(ai_kerberos_name);
  SET v_server_user = upper(ai_server_user);
  SET v_proxy_user = upper(ai_proxy_user);
  SET v_location = 'A';
  

-- Make sure the given function_category does not exceed maximum length 
 if (length(ai_function_category) >
      max_function_category_size) then
    SET v_error_no = -20028;
    SET v_error_msg = replace(GetErrorMessage(-20028),
                            '<function_category>', ai_function_category);
  else
    SET v_function_category = upper(ai_function_category);
  end if;
  
  
if (length(ai_opt_function_name) >
      max_function_name_size) then
    SET v_error_no = -20029;
    SET v_error_msg = replace(GetErrorMessage(-20029),
                            '<function_name>', ai_opt_function_name);
  else
  
  if (substr(ai_opt_function_name, -2, 2) = '\*') then
      SET v_function_name =
        CONCAT(substr(upper(ai_opt_function_name), 1, length(ai_opt_function_name)-2)
        ,'*');
      SET c_function_name_phrase =      
                CONCAT('a.function_name = ''' , v_function_name , '''');
  elseif (substr(ai_opt_function_name, -1, 1) = '*') then
      SET v_function_name_wildcard = 
        CONCAT(substr(upper(ai_opt_function_name), 1, length(ai_opt_function_name)-1)
        , '%');
      SET c_function_name_phrase =
                CONCAT('a.function_name like ''' , v_function_name_wildcard , '''');
  else
      SET v_function_name = upper(ai_opt_function_name);
      SET c_function_name_phrase =
                CONCAT('a.function_name = ''' , v_function_name , '''');
   
  end if;
end if;

if (v_kerberos_name is null) then
    SET v_error_no = -20030;
    SET v_error_msg = GetErrorMessage(-20030);
  end if;

  
  if (v_error_no is null) then 
    if (ai_function_category is null and v_function_name is not null) then
      SET v_error_no = -20027;
      SET v_error_msg = GetErrorMessage(-20027);
    end if;
    
    if (ai_function_category is null and v_function_name_wildcard is not null) 
    then
      SET v_error_no = -20027;
      SET v_error_msg = GetErrorMessage(-20027);
    end if;
    
  end if;
  
  SET v_location = 'B';
 
 
   if (v_error_no is null) then
     if (ai_opt_function_id is not null) then
       if ( not ai_opt_function_id REGEXP '[0-9]*')
       then
 
         SET v_error_no = -20021;
         SET v_error_msg = replace(GetErrorMessage(-200211), 
                               '<function_id>', ai_opt_function_id);
       else
         SELECT  CAST(ai_opt_function_id AS UNSIGNED ) AS v_function_id ;
       end if;
     end if;
   end if;

 
   
  /* If qualifier_id has been specified but it is not a valid number, 
     then return an error message */
  if (v_error_no is null) then
     if (ai_opt_qualifier_id is not null) then
        if ( not ai_opt_qualifier_id REGEXP '[0-9]*')
 
 
       then
 
         SET v_error_no = -20022;
         SET v_error_msg = GetErrorMessage(-200221);
         SET v_error_msg = replace(v_error_msg, '<qualifier_id>',
                                ai_opt_qualifier_id);
         SET v_error_msg = replace(v_error_msg, '<qualifier_type>',
                                '(any)');
       else
         SELECT CAST(ai_opt_qualifier_id AS UNSIGNED) AS v_qualifier_id ;
       end if;
     end if;
   end if;


  /* If we have sufficient information, then get the qualifier_type */
  /* If the qualifier_type is specified, then set v_qualifier_type */
  if (ai_opt_qualifier_type is not null) then
      if (length(ai_opt_qualifier_type) > 4)
      then

        SET v_error_no = -20031;
        SET v_error_msg = replace(GetErrorMessage(-20031),
                              '<qualifier_type>', ai_opt_qualifier_type);
      else
        SET v_qualifier_type = ai_opt_qualifier_type;
      end if;

  /* else if function_name is specified, then get qualifier_type from */
  /* function table */

 elseif (v_function_name is not null) then

    select count(*) into v_count from rolesbb.function
       where function_category = upper(ai_function_category)
       and function_name = upper(ai_opt_function_name);
    if v_count = 0 then
      SET v_error_no = -20021;
      SET v_error_msg = GetErrorMessage(-200212);
      SET v_error_msg = replace(v_error_msg, '<function_name>',
                            ai_opt_function_name);
      SET v_error_msg = replace(v_error_msg, '<function_category>',
                            ai_function_category);
    end if;
    

  select function_id, qualifier_type
        into v_function_id, v_qualifier_type
        from rolesbb.function
        where function_category = upper(ai_function_category)
        and function_name = v_function_name;
  
  
    
    elseif (v_function_id is not null) then
      select qualifier_type
        into v_qualifier_type
        from rolesbb.function
        where function_id = v_function_id;
  /* else if function_id is specified, then get qualifier_type from */
  /* function table */
    elseif (v_qualifier_id is not null) then
      select qualifier_type
        into v_qualifier_type
        from rolesbb.qualifier
        where qualifier_id = v_qualifier_id;
    end if;
  
  
  /* If base_qualifier_code has been specified, then make sure either 
     function_name, function_id, or qualifier_type has been specified */
  if (ai_opt_base_qual_code is not null and v_qualifier_type is null) then
      SET v_error_no = -20023;
      SET v_error_msg = replace(GetErrorMessage(-20023),
                             '<argument_name>', 'Base Qualifier Code');
  end if;
  
  
   /* If parent_qualifier_code has been specified, then make sure either 
     function_name, function_id, or qualifier_type has been specified */
  if (ai_opt_parent_qual_code is not null and v_qualifier_type is null) then
        SET v_error_no = -20023;
        SET v_error_msg = replace(GetErrorMessage(-20023),
                               '<argument_name>', 'Parent Qualifier Code');
    end if;
  
  
  /* If child_qualifier_code has been specified, then make sure either 
     function_name, function_id, or qualifier_type has been specified */
  if (ai_opt_child_qual_code is not null and v_qualifier_type is null) then
        SET v_error_no = -20023;
        SET v_error_msg = replace(GetErrorMessage(-20023),
                               '<argument_name>', 'Child Qualifier Code');
  end if;
  

  /* We have no errors yet. Check authorizations and keep processing. */
  
  
    if (v_error_no is null) then
    /* Determine what function_category to use, if any, for evaluating 
       the user's authorizations for viewing auths */
      SET v_function_category = upper(ai_function_category);
      if (v_function_category is not null) then
        SET v_eval_function_category = v_function_category;
      elseif (v_function_id is not null) then
        select count(*) into v_count from rolesbb.function
          where function_id = v_function_id;
        if v_count = 0 then
          SET v_error_no = -20021;
          SET v_error_msg = replace(GetErrorMessage(-200211),
                                '<function_id>', ai_opt_function_id);
        else
          select function_category into v_eval_function_category
            from rolesbb.function
            where function_id = v_function_id;
        end if;
      end if;
    end if;
  SET v_location = 'D';
  



  /* If there is no function_category in v_eval_function_category and
     no errors are recorded in v_error_no and v_error_msg, then we
     will construct a SQL where clause to limit the authorization list
     to only those function_categories viewable by both the proxy_user
     and the server_id.  If there are none, then set an error message. */

  if (v_error_no is null and v_eval_function_category is null) then
    SET v_category_string = get_view_category_list(v_server_user,
                                                          v_proxy_user);
    if (v_category_string is null ) then
      SET v_error_no = -20006;
      SET v_error_msg = GetErrorMessage(-20006);
      SET v_error_msg = replace(v_error_msg, '<proxy_user>', v_proxy_user);
      SET v_error_msg = replace(v_error_msg, '<server_id>', v_server_user);
    else
      SET v_cat_criteria = CONCAT(' and a.function_category in (' , v_category_string
                        , ')');
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
    select rolesbb.rolesapi_is_user_authorized(ai_server_user, 
             service_function_name, 
             COCNAT('CAT' || rtrim(v_function_category)))
           into v_check_auth from dual;
    if (v_check_auth <> 'Y') then
      SET v_error_no = -20003;
      SET v_error_msg = GetErrorMessage(-20003);
      SET v_error_msg = replace(v_error_msg, '<server_id>', 
                             ai_server_user);
      SET v_error_msg = replace(v_error_msg, '<function_category>', 
                             v_function_category);
    else
      /* Make sure the proxy_user is authorized to check the authorization, 
         either because proxy_user = kerberos_name or because proxy_user 
         has the authority to look up authorizations in this category */
      if (v_proxy_user = v_server_user) then 
        SET v_check_auth = 'Y';
      elseif (v_proxy_user = v_kerberos_name) then 
        SET v_check_auth = 'Y';
      else
        select rolesbb.rolesapi_is_user_authorized(v_proxy_user, 
                 roles_service_constant.read_auth_function1, 
                 CONCAT('CAT' ,rtrim(v_function_category)))
               into v_check_auth from dual;
        if (v_check_auth <> 'Y') then
          select rolesbb.rolesapi_is_user_authorized(v_proxy_user, 
                 read_auth_function2, 
                 CONCAT('CAT' , rtrim(v_function_category)))
                 into v_check_auth from dual;
        end if;
      end if;
      if (v_check_auth <> 'Y') then
        SET v_error_no = -20005;
        SET v_error_msg = GetErrorMessage(-20005);
        SET v_error_msg = replace(v_error_msg, '<proxy_user>', 
                              v_proxy_user);
        SET v_error_msg = replace(v_error_msg, '<function_category>', 
                              v_function_category);
      end if;
    end if;
  end if;
  SET v_location := 'E';

  /* If we have not recorded an error in v_error_no and v_error_msg,
     then keep going, and generate the select statement */
  if (v_error_no is null) then

    /* 
    **  Build the WHERE clauses.
    */
    SET v_criteria1 = 'WHERE q1.qualifier_id = a.qualifier_id';
    SET v_criteria2 = CONCAT('WHERE q1.qualifier_id = a.qualifier_id'
                 , ' and a.descend = ''Y'''
                 , ' and qd.parent_id = a.qualifier_id'
                 , ' and q2.qualifier_id = qd.child_id');
    SET v_criteria12 := '';
    if ai_is_active_now in ('y', 'Y') then 
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' , c_is_active_now_phrase); 
    end if;
    if ai_function_category is not null then 
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' , c_function_category_phrase);
    end if;
    -- if ai_opt_function_name is not null then    /*** Adjust 6/6/8 ***/
    if (v_function_name is not null               /*** Adjust 6/6/8 ***/
        or v_function_name_wildcard is not null) then  /*** Adjust 6/6/8 ***/
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' , c_function_name_phrase);
    end if;
    /***** Add 6/6/2008 *****/
    if v_function_name_wildcard is not null then
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' , c_function_name_phrase);
    end if;
    /***** End add 6/6/2008 *****/
    if ai_opt_function_id is not null then 
     SET v_criteria12 = CONCAT(v_criteria12 , ' and ' , c_function_id_phrase); 
    end if;
    if ai_opt_qualifier_type is not null then 
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' ,
                 'q1.qualifier_type = ''' , ai_opt_qualifier_type , ''''); 
    end if;
    if ai_opt_qualifier_code is not null then
    /***** Fixed 6/6/2008 *****/
      SET v_criteria1 = CONCAT(v_criteria1 , ' and ' ,
                 'q1.qualifier_code = ''' , ai_opt_qualifier_code , '''');
      SET v_criteria2 = CONCAT(v_criteria2 , ' and ' ,
                 'q2.qualifier_code = ''' , ai_opt_qualifier_code , '''');
    end if;
    if ai_opt_qualifier_id is not null then
      SET v_criteria1 = CONCAT(v_criteria1 , ' and ' ,
                 'q1.qualifier_id = ''' , ai_opt_qualifier_id , '''');
      SET v_criteria2 = CONCAT(v_criteria2 , ' and ' ,
                 'q2.qualifier_id = ''' , ai_opt_qualifier_id , '''');
    end if;
    if ai_opt_base_qual_code is not null then
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' ,
                 'q1.qualifier_code = ''' , ai_opt_qualifier_code , '''');
    end if;
    if ai_opt_base_qual_id is not null then
      SET v_criteria12 = CONCAT(v_criteria1 , ' and ' ,
                 'a.qualifier_id = ''' , ai_opt_qualifier_id , '''');
    end if;
    if ai_kerberos_name is not null then
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' , c_kerberos_name_phrase);
    end if;

    /*
    **  Now, put the pieces together 
    */
    SET outstring = CONCAT(v_select_fields , ' ' , v_from1s , ' ' , v_criteria1
                                 , v_criteria12 , v_cat_criteria);
    if (ai_expand_qualifiers = 'y' OR  ai_expand_qualifiers = 'Y') then
       SET outstring = CONCAT(outstring , ' UNION ' , v_select_fields_2s
                    , ' ' , v_from2s , ' ' , v_criteria2 , v_criteria12
                    , v_cat_criteria);
    end if;
    SET ao_sql_statement = outstring;

  /* If we have recorded an error in v_error_no and v_error_msg, then 
     move these into the output arguments ao_error_no and ao_error_msg */
  else   -- if (v_error_no is not null)
    SET ao_error_no = v_error_no;
    SET ao_error_msg = v_error_msg;
    SET v_location = 'E1';
  end if;
  SET v_location = 'F';

 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_auth_person_sql_extend1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `get_auth_person_sql_extend1`(IN ai_server_user VARCHAR(20),
       IN ai_proxy_user VARCHAR(20),
       IN ai_kerberos_name VARCHAR(20),
       IN ai_function_category VARCHAR(20), 
       IN ai_expand_qualifiers VARCHAR(20), 
       IN ai_is_active_now VARCHAR(20), 
       IN ai_opt_real_or_implied VARCHAR(20), 
       IN ai_opt_function_name VARCHAR(30), 
       IN ai_opt_function_id VARCHAR(20), 
       IN ai_opt_qualifier_type VARCHAR(20), 
       IN ai_opt_qualifier_code VARCHAR(20), 
       IN ai_opt_qualifier_id VARCHAR(20), 
       IN ai_opt_base_qual_code VARCHAR(20),
       IN ai_opt_base_qual_id VARCHAR(20),
       IN ai_opt_parent_qual_code VARCHAR(20),
       IN ai_opt_parent_qual_id VARCHAR(20),
       OUT ao_error_no  INTEGER,
       OUT ao_error_msg  VARCHAR(255),
       OUT ao_sql_statement  VARCHAR(10000))
BEGIN
  
  DECLARE v_kerberos_name VARCHAR(20);
  DECLARE v_server_user VARCHAR(20);
  DECLARE v_proxy_user VARCHAR(20);
  DECLARE v_function_id INTEGER;
  DECLARE v_function_category VARCHAR(10);
  DECLARE v_eval_function_category VARCHAR(10);
  DECLARE v_function_name VARCHAR(30);
  DECLARE v_function_name_wildcard VARCHAR(30);  
  DECLARE v_qualifier_type VARCHAR(10);
  DECLARE v_qualifier_code VARCHAR(10);
  DECLARE v_qualifier_id INTEGER;
  DECLARE v_parent_qualifier_id INTEGER;
  DECLARE v_valid_real_implied_arg integer;
  DECLARE v_real_or_implied varchar(1);
  DECLARE v_error_msg varchar(255);
  DECLARE v_error_no integer;
  DECLARE v_count integer;
  DECLARE v_check_auth varchar(1);
  DECLARE v_location varchar(2);
  DECLARE outstring VARCHAR(10000) DEFAULT '';
  
  
  DECLARE c_is_active_now_phrase VARCHAR(200) ;
  DECLARE c_function_category_phrase VARCHAR(200) ;
  DECLARE c_function_name_phrase VARCHAR(200);
    DECLARE c_function_id_phrase VARCHAR(200);   
  DECLARE c_kerberos_name_phrase VARCHAR(200);
  DECLARE v_select_fields VARCHAR(2000) ;
  DECLARE v_from1s VARCHAR(250) ; 
  DECLARE v_from2s VARCHAR(250);
  
  DECLARE v_order_by VARCHAR(100);

  DECLARE v_counter integer;
  DECLARE v_select_fields_2s VARCHAR(2000);
  DECLARE v_criteria1 VARCHAR(2000) ;
  DECLARE v_criteria2 VARCHAR(2000) ;
  DECLARE v_criteria12 VARCHAR(5000) ;
  DECLARE v_category_string VARCHAR(2000) ;
  DECLARE v_cat_criteria VARCHAR(2040) ;
DECLARE max_function_category_size integer DEFAULT 4;
DECLARE  max_function_name_size integer DEFAULT 30;



  SET c_is_active_now_phrase  = 
                CONCAT('a.do_function = ''Y'' and sysdate() between a.effective_date'
                , ' and IFNULL(a.expiration_date,sysdate())'); 
  SET c_function_category_phrase = 
          CONCAT('a.function_category = ''' , upper(ai_function_category) , '''');
  SET c_function_name_phrase  =      
                CONCAT('a.function_name in (''' , upper(ai_opt_function_name) , ''', ''' , '*' , upper(ai_opt_function_name) , ''')');
  SET c_function_id_phrase =
                CONCAT('a.function_id = ''' ,ai_opt_function_id , '''');
  SET c_kerberos_name_phrase = 
                CONCAT('a.kerberos_name = ''' , upper(ai_kerberos_name) , '''');
  
  
  SET v_select_fields  = 
    CONCAT('select a.kerberos_name, a.function_category,'
     , ' ltrim(a.function_name,''*'') function_name,'
     , ' a.qualifier_code, IFNULL(a.qualifier_name, '' '') qualifier_name, '
     , ' auth_sf_is_auth_active(a.do_function, a.effective_date,'
     , '     a.expiration_date) is_active_now,'
     , ' CASE a.grant_and_view WHEN ''GD'' THEN ''G'' ELSE ''N'' END as grant_authorization,'
     , ' a.authorization_id, a.function_id, a.qualifier_id,'
     , ' a.do_function, a.effective_date, a.expiration_date,'
     , ' a.modified_by, a.modified_date, q1.qualifier_type,'
     , ' q1.qualifier_code base_qualifier_code,');
  SET v_from1s  = ' from authorization2 a, qualifier q1'; 
  SET v_from2s  = 
       CONCAT(' from authorization2 a, qualifier q1, qualifier_descendent qd,' 
    , ' qualifier q2'); 

  SET v_order_by  = ' ORDER BY 1, 2, 3, 4';

  SET v_criteria1 = ''; 
  SET v_criteria2  = ''; 
  SET v_criteria12  = ''; 
  SET v_category_string  = '';
  SET v_cat_criteria = '';

  SET v_select_fields_2s = replace(v_select_fields, 'a.qualifier_code',
                                                 'q2.qualifier_code');
  SET v_select_fields_2s = replace(v_select_fields_2s, 'a.qualifier_name',
                                                    'q2.qualifier_name');
  SET v_select_fields_2s = replace(v_select_fields_2s, 'a.qualifier_id',
                                                    'q2.qualifier_id');

  SET v_kerberos_name = upper(ai_kerberos_name);
  SET v_server_user = upper(ai_server_user);
  SET v_proxy_user = upper(ai_proxy_user);
  if v_proxy_user is null then
    SET v_proxy_user = v_server_user;
  end if;
  SET v_location = 'A';

  
  if length(ai_opt_real_or_implied) > 1 then
    SET v_valid_real_implied_arg = 0;
  else
    SET v_real_or_implied = upper(IFNULL(ai_opt_real_or_implied, 'B'));
    if v_real_or_implied in ('R', 'I', 'B') then
      SET v_valid_real_implied_arg = 1;
    else
      SET v_valid_real_implied_arg = 0;
    end if;
  end if;
  if v_valid_real_implied_arg = 0 then
    SET v_error_no = -20024;
    SET v_error_msg = replace(GetErrorMessage(-20024), 
                            '<arg_value>', ai_opt_real_or_implied);
    call rolesbb.permit_signal(v_error_no, v_error_msg);
  end if;

  
  if v_real_or_implied = 'R' then
    SET v_from1s = replace(v_from1s, 'authorization2', 'authorization');
    SET v_from2s = replace(v_from2s, 'authorization2', 'authorization');
    SET v_select_fields = CONCAT(v_select_fields , '''R'' real_or_implied');
    SET v_select_fields_2s = CONCAT(v_select_fields , '''R'' real_or_implied');
  else 
    SET v_select_fields = CONCAT(v_select_fields 
      , ' CASE a.auth_type WHEN ''E'' THEN ''I'' ELSE  a.auth_type END real_or_implied');
    SET v_select_fields_2s = CONCAT(v_select_fields_2s
      , ' CASE a.auth_type WHEN ''E'' THEN ''I'' ELSE  a.auth_type END real_or_implied ');
  end if;
  
  
  if (length(ai_function_category) > max_function_category_size) then
    SET v_error_no = -20028;
    SET v_error_msg = replace(GetErrorMessage(-20028), 
                            '<function_category>', ai_function_category);
  else 
    SET v_function_category = upper(ai_function_category);
  end if;

  
  if (length(ai_opt_function_name) > 
       max_function_name_size) then
    SET v_error_no = -20029;
    SET v_error_msg = replace(GetErrorMessage(-20029), 
                            '<function_name>', ai_opt_function_name);
  else 
    
    if (substr(ai_opt_function_name, -2, 2) = '\*') then 
      SET v_function_name = 
        CONCAT(substr(upper(ai_opt_function_name), 1, length(ai_opt_function_name)-2)
        , '*');
      SET c_function_name_phrase =      
                CONCAT('a.function_name = ''' , v_function_name , '''');
    elseif (substr(ai_opt_function_name, -1, 1) = '*') then 
      SET v_function_name_wildcard = 
        CONCAT(substr(upper(ai_opt_function_name), 1, length(ai_opt_function_name)-1)
        , '%');
      SET c_function_name_phrase =      
                CONCAT('a.function_name like ''' , v_function_name_wildcard ,'''');
    else
      SET v_function_name = upper(ai_opt_function_name);
      SET c_function_name_phrase =      
                CONCAT('a.function_name = ''' , v_function_name , '''');
    end if;

  end if;

  
  if (v_kerberos_name is null) then
    SET v_error_no = -20030;
    SET v_error_msg = GetErrorMessage(-20030);
  end if;

  
  if (v_error_no is null) then 
    if (ai_function_category is null and v_function_name is not null) then
      SET v_error_no = -20027;
      SET v_error_msg = GetErrorMessage(-20027);
    end if;
    
    if (ai_function_category is null and v_function_name_wildcard is not null) 
    then
      SET v_error_no = -20027;
      SET v_error_msg = GetErrorMessage(-20027);
    end if;
    
  end if;
  SET v_location = 'B';

  
  if (v_error_no is null) then 
    if (ai_opt_function_id is not null) then
      
      
      if (not ai_opt_function_id REGEXP '[0-9]*')
      then
        
        SET v_error_no = -20021;
        SET v_error_msg = replace(GetErrorMessage(-200211), 
                              '<function_id>', ai_opt_function_id);
      else
	SELECT  CAST(ai_opt_function_id AS UNSIGNED ) AS v_function_id ;
      end if;
    end if;
  end if;

  
  if (v_error_no is null) then 
    if (ai_opt_qualifier_id is not null) then
      
      
      if (not ai_opt_qualifier_id REGEXP '[0-9]*')
      then
        
        SET v_error_no = -20022;
        SET v_error_msg = GetErrorMessage(-200221);
        SET v_error_msg = replace(v_error_msg, '<qualifier_id>', 
                               ai_opt_qualifier_id);
        SET v_error_msg = replace(v_error_msg, '<qualifier_type>', 
                               '(any)');
      else
	SELECT  CAST(ai_opt_qualifier_id AS UNSIGNED ) AS v_qualifier_id ;
      end if;
    end if;
  end if;

  
  
  if (ai_opt_qualifier_type is not null) then
      if (length(ai_opt_qualifier_type) 
          > roles_service_constant.max_qualifier_type_size)
      then
        
        SET v_error_no = -20031;
        SET v_error_msg = replace(GetErrorMessage(-20031), 
                              '<qualifier_type>', ai_opt_qualifier_type);
      else
        SET v_qualifier_type = ai_opt_qualifier_type;
      end if;
  
  
  
  
  elseif (v_function_name is not null) then
  
    select count(*) into v_count from rolesbb.function 
       where function_category = upper(ai_function_category)
       and function_name = upper(ai_opt_function_name);
    if v_count > 0 then
     select function_id, qualifier_type
       into v_function_id, v_qualifier_type
       from rolesbb.function
       where function_category = upper(ai_function_category)
       and function_name = v_function_name;              
     
    else
     select count(*) into v_count from rolesbb.external_function 
        where function_category = upper(ai_function_category)
        and function_name = CONCAT('*' , upper(v_function_name))
        and v_real_or_implied in ('B', 'I');
     if v_count > 0 then
       select function_id, qualifier_type
         into v_function_id, v_qualifier_type
         from rolesbb.external_function
         where function_category = upper(ai_function_category)
         and function_name = CONCAT('*' , v_function_name);
     end if;
    end if;
    if v_count = 0 then
      SET v_error_no = -20021;
      SET v_error_msg = GetErrorMessage(-200212);
      SET v_error_msg = replace(v_error_msg, '<function_name>', 
                            ai_opt_function_name);
      SET v_error_msg = replace(v_error_msg, '<function_category>', 
                            ai_function_category);
    end if;
  
  
  elseif (v_function_id is not null) then
    select qualifier_type
      into v_qualifier_type
      from rolesbb.function
      where function_id = v_function_id;
  
  
  elseif (v_qualifier_id is not null) then
    select qualifier_type
      into v_qualifier_type
      from rolesbb.qualifier
      where qualifier_id = v_qualifier_id;
  end if;
  
  
  if (ai_opt_qualifier_code is not null and v_qualifier_type is null) then
      SET v_error_no = -20023;
      SET v_error_msg = replace(GetErrorMessage(-20023), 
                             '<argument_name>', 'Qualifier Code');
  end if;

  
  if (ai_opt_base_qual_code is not null and v_qualifier_type is null) then
      SET v_error_no = -20023;
      SET v_error_msg = replace(GetErrorMessage(-20023), 
                             '<argument_name>', 'Base Qualifier Code');
  end if;

  
  if (ai_opt_parent_qual_code is not null and v_qualifier_type is null) then
      SET v_error_no = -20023;
      SET v_error_msg = replace(GetErrorMessage(-20023), 
                             '<argument_name>', 'Parent Qualifier Code');
  end if;

  
  if (ai_opt_parent_qual_code is not null) then
    select count(*) into v_count from qualifier
      where qualifier_type = v_qualifier_type
      and qualifier_code = ai_opt_parent_qual_code;
    if v_count = 0 then
      SET v_error_no = -20022;
      SET v_error_msg = GetErrorMessage(-200222);
      SET v_error_msg = replace(v_error_msg, '<qualifier_code>', 
                            ai_opt_parent_qual_code);
      SET v_error_msg = replace(v_error_msg, '<qualifier_type>', 
                            v_qualifier_type);
      call rolesbb.permit_signal(v_error_no, v_error_msg);
    else
      select qualifier_id into v_parent_qualifier_id from rolesbb.qualifier
        where qualifier_type = v_qualifier_type
        and qualifier_code = ai_opt_parent_qual_code;
    end if;
  end if;

  
  
  if (v_error_no is null) then 
    
    SET v_function_category = upper(ai_function_category);
    if (v_function_category is not null) then
      SET v_eval_function_category = v_function_category;
    elseif (v_function_id is not null) then
      select count(*) into v_count from rolesbb.function 
        where function_id = v_function_id;
      if v_count = 0 then
        SET v_error_no = -20021;
        SET v_error_msg = replace(GetErrorMessage(-200211), 
                              '<function_id>', ai_opt_function_id);
      else 
        select function_category into v_eval_function_category
          from rolesbb.function 
          where function_id = v_function_id;
      end if;
    end if;
  end if;
  SET v_location = 'D';

  

  if (v_error_no is null and v_eval_function_category is null) then
    SET v_category_string = rolesserv.get_view_category_list(v_server_user,
                                                          v_proxy_user);
    if (v_category_string is null) then
      SET v_error_no = -20006;
      SET v_error_msg = GetErrorMessage(-20006);
      SET v_error_msg = replace(v_error_msg, '<proxy_user>', v_proxy_user);
      SET v_error_msg = replace(v_error_msg, '<server_id>', v_server_user);
    else
      SET v_cat_criteria = CONCAT(' and a.function_category in (' , v_category_string
                        , ')');
    end if;
  end if;

  
  if (v_error_no is null and v_cat_criteria is null) then 
    
    select rolesapi_is_user_authorized(ai_server_user, 
             roles_service_constant.service_function_name, 
             'CAT' || rtrim(v_function_category))
           into v_check_auth from dual;
    if (v_check_auth <> 'Y') then
      SET v_error_no = -20003;
      SET v_error_msg = GetErrorMessage(-20003);
      SET v_error_msg = replace(v_error_msg, '<server_id>', 
                             ai_server_user);
      SET v_error_msg = replace(v_error_msg, '<function_category>', 
                             v_function_category);
    else
      
      if (v_proxy_user = v_server_user) then 
        SET v_check_auth = 'Y';
      elseif (v_proxy_user = v_kerberos_name) then 
        SET v_check_auth = 'Y';
      else
        select rolesbb.rolesapi_is_user_authorized(v_proxy_user, 
                 roles_service_constant.read_auth_function1, 
                 CONCAT('CAT' , rtrim(v_function_category)))
               into v_check_auth from dual;
        if (v_check_auth <> 'Y') then
          select rolesbb.rolesapi_is_user_authorized(v_proxy_user, 
                 roles_service_constant.read_auth_function2, 
                 CONCAT('CAT' , rtrim(v_function_category)))
                 into v_check_auth from dual;
        end if;
      end if;
      if (v_check_auth <> 'Y') then
        SET v_error_no = -20005;
        SET v_error_msg = GetErrorMessage(-20005);
        SET v_error_msg = replace(v_error_msg, '<proxy_user>', 
                              v_proxy_user);
        SET v_error_msg = replace(v_error_msg, '<function_category>', 
                              v_function_category);
      end if;
    end if;
  end if;
  SET v_location = 'E';

  
  if (v_error_no is null) then

    
    SET v_criteria1 = 'WHERE q1.qualifier_id = a.qualifier_id';
    SET v_criteria2 = CONCAT('WHERE q1.qualifier_id = a.qualifier_id'
                 , ' and a.descend = ''Y'''
                 , ' and qd.parent_id = a.qualifier_id'
                 , ' and q2.qualifier_id = qd.child_id');
    SET v_criteria12 = '';
    if ai_is_active_now in ('y', 'Y') then 
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' , c_is_active_now_phrase); 
    end if;
    if v_real_or_implied = 'I' then
      SET v_criteria12 = CONCAT(v_criteria12 , ' and a.auth_type = ''E'' ');
    end if;
    if ai_function_category is not null then 
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' , c_function_category_phrase);
    end if;
    if (v_function_name is not null) then        
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' , c_function_name_phrase);
    end if;
    if v_function_name_wildcard is not null then
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' , c_function_name_phrase);
    end if;
    
    if ai_opt_function_id is not null then 
     SET v_criteria12 = CONCAT(v_criteria12 , ' and ' , c_function_id_phrase); 
    end if;
    if ai_opt_qualifier_type is not null then 
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' ,
                 'q1.qualifier_type = ''' , ai_opt_qualifier_type , ''''); 
    end if;
    if ai_opt_qualifier_code is not null then
      SET v_criteria1 = CONCAT(v_criteria1 , ' and ' ,
                 'q1.qualifier_code = ''' , ai_opt_qualifier_code , '''');
      SET v_criteria2 = CONCAT(v_criteria2 , ' and ' ,
                 'q2.qualifier_code = ''' , ai_opt_qualifier_code , '''');
    end if;
    if ai_opt_qualifier_id is not null then
      SET v_criteria1 = CONCAT(v_criteria1 , ' and ' ,
                 'q1.qualifier_id = ''' , ai_opt_qualifier_id , '''');
      SET v_criteria2 = CONCAT(v_criteria2 , ' and ' ,
                 'q2.qualifier_id = ''' , ai_opt_qualifier_id, '''');
    end if;
    if ai_opt_base_qual_code is not null then
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' ,
            'q1.qualifier_code = ''' , ai_opt_base_qual_code , '''');
    end if;
    if ai_opt_base_qual_id is not null then
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' ,
                 'a.qualifier_id = ''' , ai_opt_base_qual_id , '''');
    end if;
    if ai_opt_parent_qual_id is not null then
      SET v_criteria1 = CONCAT(v_criteria1 , ' and (a.qualifier_id = ''' ,
                 ai_opt_parent_qual_id , ''' or exists' ,
                 ' (select 1 from qualifier_descendent qd1 where' ,
                 ' qd1.child_id = a.qualifier_id and qd1.parent_id = ''' , 
                 ai_opt_parent_qual_id , '''))');
      SET v_criteria2 = CONCAT(v_criteria2 , ' and (q2.qualifier_id = ''' ,
                 ai_opt_parent_qual_id , ''' or exists' ,
                 ' (select 1 from qualifier_descendent qd1 where' ,
                 ' qd1.child_id = q2.qualifier_id and qd1.parent_id = ''' , 
                 ai_opt_parent_qual_id , '''))');
    end if;
    if ai_opt_parent_qual_code is not null then
      SET v_criteria1 = CONCAT(v_criteria1 , ' and (a.qualifier_id = ''' ,
                 v_parent_qualifier_id , ''' or exists',
                 ' (select 1 from qualifier_descendent qd1 where' ,
                 ' qd1.child_id = a.qualifier_id and qd1.parent_id = ''' , 
                 v_parent_qualifier_id , '''))');
      SET v_criteria2 = CONCAT(v_criteria2 , ' and (q2.qualifier_id = ''' ,
                 v_parent_qualifier_id , ''' or exists' ,
                 ' (select 1 from qualifier_descendent qd1 where' ,
                 ' qd1.child_id = q2.qualifier_id and qd1.parent_id = ''' , 
                 v_parent_qualifier_id ,'''))');
    end if;
    if ai_kerberos_name is not null then
      SET v_criteria12 = CONCAT(v_criteria12 , ' and ' , c_kerberos_name_phrase);
    end if;

    
    SET outstring = CONCAT(v_select_fields , ' ' , v_from1s , ' ' , v_criteria1
                                 , v_criteria12 , v_cat_criteria);
    if ai_expand_qualifiers in ('y', 'Y') then
       SET outstring = CONCAT(outstring , ' UNION ' , v_select_fields_2s
                    , ' ' , v_from2s , ' ' , v_criteria2 , v_criteria12
                    , v_cat_criteria);
    end if;
    SET outstring = CONCAT(outstring , v_order_by);
    SET ao_sql_statement = outstring;

  
  else   
    SET ao_error_no = v_error_no;
    SET ao_error_msg = v_error_msg;
    SET v_location = 'E1';
  end if;
  SET v_location = 'F';

  
  
  
  
  

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_auth_person_sql_extend1_cursor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `get_auth_person_sql_extend1_cursor`(IN ai_server_user VARCHAR(20),
       IN ai_proxy_user VARCHAR(20),
       IN ai_kerberos_name VARCHAR(20),
       IN ai_function_category VARCHAR(20),
       IN ai_expand_qualifiers VARCHAR(20),
       IN ai_is_active_now VARCHAR(20),
       IN ai_opt_real_or_implied VARCHAR(20),
       IN ai_opt_function_name VARCHAR(30),
       IN ai_opt_function_id VARCHAR(20),
       IN ai_opt_qualifier_type VARCHAR(20),
       IN ai_opt_qualifier_code VARCHAR(20),
       IN ai_opt_qualifier_id VARCHAR(20),
       IN ai_opt_base_qual_code VARCHAR(20),
       IN ai_opt_base_qual_id VARCHAR(20),
       IN ai_opt_parent_qual_code VARCHAR(20),
       IN ai_opt_parent_qual_id VARCHAR(20))
BEGIN
    DECLARE v_statement varchar(10000);
    DECLARE v_error_no integer;
    DECLARE v_error_msg varchar(2000);

   CALL get_auth_person_sql_extend1
      ( ai_server_user ,
        ai_proxy_user ,
        ai_kerberos_name ,
        ai_function_category ,
        ai_expand_qualifiers ,
        ai_is_active_now ,
        ai_opt_real_or_implied ,
        ai_opt_function_name ,
        ai_opt_function_id ,
        ai_opt_qualifier_type ,
        ai_opt_qualifier_code ,
        ai_opt_qualifier_id ,
        ai_opt_base_qual_code ,
        ai_opt_base_qual_id ,
        ai_opt_parent_qual_code ,
        ai_opt_parent_qual_id ,
       v_error_no, v_error_msg, v_statement);

   if (v_error_no is not null || v_error_no != 0 ) then
     CALL rolesbb.permit_signal(v_error_no, v_error_msg);
   end if;

   SET @sql1 = v_statement;
   PREPARE s1 FROM @sql1;
   EXECUTE s1;
   DEALLOCATE PREPARE s1;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `global_var_drop` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `global_var_drop`(
    p_var_name varchar(50)
)
    MODIFIES SQL DATA
begin
    set @global_var_drop = global_var_drop(p_var_name);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `global_var_set` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `global_var_set`(
    p_var_name varchar(50),
    p_value    text
)
    MODIFIES SQL DATA
begin
    set @global_var_set = global_var_set(p_var_name, p_value) ;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `initialize_tests` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `initialize_tests`()
    DETERMINISTIC
begin
    drop table if exists _routine_list;
    create table _routine_list (
        routine_name varchar(50) not null default '', 
        routine_type enum ('function', 'procedure') not null default 'procedure', 
        primary key (routine_name, routine_type) 
    );
    truncate _test_results;
    
    
    alter table _test_results AUTO_INCREMENT =0;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `log_test` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `log_test`(
    p_description   varchar(200),
    p_result        text,
    p_expected      text,
    p_outcome       boolean
)
begin
    insert into _test_results( description, result, expected, outcome)
    values 
    (p_description, p_result, p_expected, p_outcome);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `my_functions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `my_functions`(pattern varchar(50))
    READS SQL DATA
begin
    select routine_schema, routine_name
    from _routine_syntax
    where 
        routine_type = 'function' 
        and 
        routine_name regexp pattern;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `my_procedures` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `my_procedures`(pattern varchar(50))
    READS SQL DATA
begin
    select routine_schema, routine_name
    from _routine_syntax
    where 
        routine_type = 'procedure' 
        and 
        routine_name regexp pattern;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `my_routines` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `my_routines`(pattern varchar(50))
    READS SQL DATA
begin
    select routine_schema, routine_name, routine_type
    from _routine_syntax
    where routine_name regexp pattern;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `show_test_results` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `show_test_results`()
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
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `simple_sp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `simple_sp`(
    calling_procedure varchar(50),
    parameters_array  varchar(50)
)
    READS SQL DATA
begin
   declare query text;
    set query = simple_sp(calling_procedure, parameters_array);
    if ((query is not null) ) then
        set @_reg_query = concat('call ', query);    
        prepare reg_query from @_reg_query;
        execute reg_query;
        deallocate prepare reg_query;
        
    end if;
 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `simple_spl` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`localhost`*/ /*!50003 PROCEDURE `simple_spl`(
    calling_procedure varchar(50),
    parameters_list   text
)
    READS SQL DATA
begin
   declare query text;
    set query = simple_spl(calling_procedure, parameters_list);
    if ((query is not null) ) then
        set @_reg_query = concat('call ', query);    
        prepare reg_query from @_reg_query;
        execute reg_query;
        deallocate prepare reg_query;
        set @_reg_query = null;
    end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-04-07 12:52:33
