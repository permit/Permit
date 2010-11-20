-- MySQL dump 10.13  Distrib 5.4.1-beta, for unknown-linux-gnu (x86_64)
--
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
-- Host: localhost    Database: mdept$owner
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
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `department` (
  `dept_id` int(8) NOT NULL AUTO_INCREMENT,
  `d_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `short_name` varchar(25) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `long_name` varchar(70) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `dept_type_id` int(4) NOT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_by` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  `modified_by` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`dept_id`),
  UNIQUE KEY `dept_un_dept_code` (`d_code`),
  KEY `department_fk_dept_id` (`dept_type_id`),
  CONSTRAINT `department_fk_dept_id` FOREIGN KEY (`dept_type_id`) REFERENCES `dept_node_type` (`dept_type_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=14143 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `department_audit`
--

DROP TABLE IF EXISTS `department_audit`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `department_audit` (
  `audit_id` bigint(10) NOT NULL,
  `mod_by_username` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `action_date` datetime NOT NULL,
  `action_type` char(1) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `old_new` char(1) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `dept_id` int(8) NOT NULL,
  `d_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `short_name` varchar(25) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `long_name` varchar(70) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `dept_type_id` int(4) NOT NULL,
  `dept_type_desc` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_by` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  `modified_by` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`audit_id`,`old_new`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `department_child`
--

DROP TABLE IF EXISTS `department_child`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `department_child` (
  `parent_id` int(8) NOT NULL,
  `view_subtype_id` int(5) NOT NULL,
  `child_id` int(8) NOT NULL,
  `created_by` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  UNIQUE KEY `department_child_pk_parent_id` (`parent_id`,`view_subtype_id`,`child_id`),
  KEY `parent_id_index` (`parent_id`),
  KEY `child_id_fk` (`child_id`),
  KEY `view_subtype_id_fk` (`view_subtype_id`),
  CONSTRAINT `child_id_fk` FOREIGN KEY (`child_id`) REFERENCES `department` (`dept_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `parent_id_fk` FOREIGN KEY (`parent_id`) REFERENCES `department` (`dept_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `view_subtype_id_fk` FOREIGN KEY (`view_subtype_id`) REFERENCES `view_subtype` (`view_subtype_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `dept_child_audit`
--

DROP TABLE IF EXISTS `dept_child_audit`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `dept_child_audit` (
  `audit_id` bigint(10) NOT NULL,
  `mod_by_username` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `action_date` datetime NOT NULL,
  `action_type` char(1) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `old_new` char(1) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `parent_id` bigint(12) NOT NULL,
  `parent_d_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `view_subtype_id` int(5) NOT NULL,
  `child_id` bigint(12) NOT NULL,
  `child_d_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `created_by` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  PRIMARY KEY (`audit_id`,`parent_id`,`old_new`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `dept_descendent`
--

DROP TABLE IF EXISTS `dept_descendent`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `dept_descendent` (
  `view_type_code` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `parent_id` bigint(12) NOT NULL,
  `child_id` bigint(12) NOT NULL,
  UNIQUE KEY `department_child_pk` (`view_type_code`,`parent_id`,`child_id`),
  KEY `dd_child_id_idx` (`child_id`),
  KEY `dd_parent_id_idx` (`view_type_code`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `dept_node_type`
--

DROP TABLE IF EXISTS `dept_node_type`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `dept_node_type` (
  `dept_type_id` int(5) NOT NULL,
  `dept_type_desc` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `check_object_link` varchar(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`dept_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `expanded_object_link`
--

DROP TABLE IF EXISTS `expanded_object_link`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `expanded_object_link` (
  `dept_id` int(8) NOT NULL,
  `object_type_code` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `object_code` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `link_by_object_code` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  KEY `xobject_link_by_object_code` (`link_by_object_code`),
  KEY `xobject_link_dept_id` (`dept_id`),
  KEY `xobject_link_object_code` (`object_code`),
  KEY `xol_fk_object_type_code` (`object_type_code`),
  CONSTRAINT `xol_fk_dept_id` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `xol_fk_object_type_code` FOREIGN KEY (`object_type_code`) REFERENCES `object_type` (`object_type_code`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `more_dept_info`
--

DROP TABLE IF EXISTS `more_dept_info`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `more_dept_info` (
  `dept_id` int(8) NOT NULL,
  `ao_mit_id` varchar(9) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `dept_head_mit_id` varchar(9) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  UNIQUE KEY `more_dept_info_un_dept_id` (`dept_id`),
  CONSTRAINT `more_dept_info_fk_dept_id` FOREIGN KEY (`dept_id`) REFERENCES `dept_node_type` (`dept_type_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `object_link`
--

DROP TABLE IF EXISTS `object_link`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `object_link` (
  `dept_id` int(8) NOT NULL,
  `object_type_code` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `object_code` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  KEY `object_link_dept_id` (`dept_id`),
  KEY `object_link_object_code` (`object_code`),
  KEY `fk_object_type_code` (`object_type_code`),
  CONSTRAINT `fk_dept_id` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_object_type_code` FOREIGN KEY (`object_type_code`) REFERENCES `object_type` (`object_type_code`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `object_link_audit`
--

DROP TABLE IF EXISTS `object_link_audit`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `object_link_audit` (
  `audit_id` bigint(10) NOT NULL,
  `mod_by_username` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `action_date` datetime NOT NULL,
  `action_type` char(1) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `old_new` char(1) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `dept_id` int(8) NOT NULL,
  `d_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `object_type_code` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `object_code` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  PRIMARY KEY (`audit_id`,`object_type_code`,`object_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `object_type`
--

DROP TABLE IF EXISTS `object_type`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `object_type` (
  `object_type_code` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `obj_type_desc` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `obj_type_html_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `min_link_count` int(6) DEFAULT NULL,
  `max_link_count` int(6) DEFAULT NULL,
  `import_conversion` varchar(1000) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `export_conversion` varchar(1000) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `validation_table` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `validation_field` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `validation_mask1` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `validation_mask2` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `validation_mask3` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `validation_mask4` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `roles_qualifier_type` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  UNIQUE KEY `object_type_index` (`object_type_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `sequence_table`
--

DROP TABLE IF EXISTS `sequence_table`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `sequence_table` (
  `currval` bigint(20) unsigned zerofill NOT NULL,
  `sequence_name` varchar(255) NOT NULL,
  PRIMARY KEY (`sequence_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `view_subtype`
--

DROP TABLE IF EXISTS `view_subtype`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `view_subtype` (
  `view_subtype_id` int(5) NOT NULL,
  `view_subtype_desc` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  UNIQUE KEY `view_subtype_pk` (`view_subtype_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `view_to_dept_type`
--

DROP TABLE IF EXISTS `view_to_dept_type`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `view_to_dept_type` (
  `view_type_code` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `leaf_dept_type_id` int(4) NOT NULL,
  UNIQUE KEY `view_to_dept_type_pk` (`view_type_code`,`leaf_dept_type_id`),
  KEY `vtdt_dept_type_fk` (`leaf_dept_type_id`),
  KEY `vtdt_view_type_fk` (`view_type_code`),
  CONSTRAINT `vtdt_dept_type_fk` FOREIGN KEY (`leaf_dept_type_id`) REFERENCES `dept_node_type` (`dept_type_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `vtdt_view_type_fk` FOREIGN KEY (`view_type_code`) REFERENCES `view_type` (`view_type_code`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `view_type`
--

DROP TABLE IF EXISTS `view_type`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `view_type` (
  `view_type_code` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `view_type_desc` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `root_dept_id` int(8) DEFAULT NULL,
  UNIQUE KEY `view_type_pk` (`view_type_code`),
  KEY `view_type_fk` (`root_dept_id`),
  CONSTRAINT `view_type_fk` FOREIGN KEY (`root_dept_id`) REFERENCES `department` (`dept_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `view_type_to_subtype`
--

DROP TABLE IF EXISTS `view_type_to_subtype`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `view_type_to_subtype` (
  `view_type_code` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `view_subtype_id` int(5) NOT NULL,
  UNIQUE KEY `view_type_to_subtype_index` (`view_type_code`,`view_subtype_id`),
  KEY `fk_view_subtype_id` (`view_subtype_id`),
  KEY `fk_view_type_code` (`view_type_code`),
  CONSTRAINT `fk_view_subtype_id` FOREIGN KEY (`view_subtype_id`) REFERENCES `view_subtype` (`view_subtype_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_view_type_code` FOREIGN KEY (`view_type_code`) REFERENCES `view_type` (`view_type_code`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `wh_dlc_hierarchy`
--

DROP TABLE IF EXISTS `wh_dlc_hierarchy`;
/*!50001 DROP VIEW IF EXISTS `wh_dlc_hierarchy`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `wh_dlc_hierarchy` (
  `view_type_code` varchar(8),
  `view_type_desc` varchar(50),
  `parent_d_code` varchar(15),
  `d_code` varchar(15),
  `long_name` varchar(70),
  `short_name` varchar(25),
  `dept_type_id` int(4),
  `dept_type_desc` varchar(50),
  `create_date` datetime,
  `create_by` varchar(20),
  `modified_date` datetime,
  `modified_by` varchar(20)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `wh_expanded_object_link`
--

DROP TABLE IF EXISTS `wh_expanded_object_link`;
/*!50001 DROP VIEW IF EXISTS `wh_expanded_object_link`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `wh_expanded_object_link` (
  `view_type_code` varchar(8),
  `d_code` varchar(15),
  `object_type_code` varchar(8),
  `object_code` varchar(20),
  `link_by_object_code` varchar(20),
  `dept_id` int(8)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'mdept$owner'
--
/*!50003 DROP FUNCTION IF EXISTS `can_maintain_any_dept` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `can_maintain_any_dept`( AI_FOR_USER VARCHAR(20)) RETURNS varchar(1) CHARSET latin1
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `can_maintain_dept` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `can_maintain_dept`( AI_FOR_USER  VARCHAR(20),
                              AI_DEPT_ID INTEGER) RETURNS varchar(1) CHARSET latin1
begin
    return can_maintain_any_dept(ai_for_user);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `can_maintain_link` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `can_maintain_link`( AI_FOR_USER  VARCHAR(20),
                              AI_DEPT_ID INTEGER) RETURNS varchar(1) CHARSET latin1
begin
    return can_maintain_any_dept(ai_for_user);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `is_loop` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `is_loop`( AI_DEPT_ID INTEGER,
                         AI_PARENT_ID  INTEGER) RETURNS varchar(1) CHARSET latin1
BEGIN

  DECLARE is_loop_val VARCHAR(1);
  
  CALL is_loop_proc(AI_DEPT_ID,AI_PARENT_ID, is_loop_val);

  RETURN is_loop_val;
  

 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `next_sequence_val` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`mdept$owner`@`%`*/ /*!50003 FUNCTION `next_sequence_val`(seq_name char(255) ) RETURNS bigint(20) unsigned
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `PUT_LINE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`mdept$owner`@`%`*/ /*!50003 FUNCTION `PUT_LINE`(  message     VARCHAR(255)) RETURNS varchar(255) CHARSET latin1
BEGIN

IF (message is null) THEN
  SET message = CONCAT (' Unknown error ', message);
END IF;

INSERT INTO  DBMS_OUTPUT.log  (message) VALUES(message);
RETURN message;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `translate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `translate`(
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_dept` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `add_dept`(IN AI_FOR_USER          VARCHAR(80),
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



END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_dept_parent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `add_dept_parent`(IN AI_FOR_USER            VARCHAR(20),
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_link_to_object` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `add_link_to_object`(IN AI_FOR_USER            VARCHAR(20),
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

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_dept` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `delete_dept`(IN AI_FOR_USER        VARCHAR(20),
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

 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_dept_parent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `delete_dept_parent`(IN AI_FOR_USER             VARCHAR(20),
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

 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_link_to_object` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `delete_link_to_object`(IN  AI_FOR_USER          VARCHAR(20),
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
 
 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `is_loop_proc` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `is_loop_proc`(IN AI_DEPT_ID INTEGER,
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
    
  
  end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `permit_signal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `permit_signal`(error_code INTEGER, error_text VARCHAR(255))
BEGIN

SET @sql = CONCAT('UPDATE `',error_text,'`SET x=1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_dept` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `update_dept`(IN AI_FOR_USER        VARCHAR(20),
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

 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_dept_parent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `update_dept_parent`(IN  AI_FOR_USER           VARCHAR(20),
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

 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `wh_dlc_hierarchy`
--

/*!50001 DROP TABLE `wh_dlc_hierarchy`*/;
/*!50001 DROP VIEW IF EXISTS `wh_dlc_hierarchy`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `wh_dlc_hierarchy` AS select `vt`.`view_type_code` AS `view_type_code`,`vt`.`view_type_desc` AS `view_type_desc`,`d2`.`d_code` AS `parent_d_code`,`d1`.`d_code` AS `d_code`,`d1`.`long_name` AS `long_name`,`d1`.`short_name` AS `short_name`,`d1`.`dept_type_id` AS `dept_type_id`,`dt`.`dept_type_desc` AS `dept_type_desc`,`d1`.`create_date` AS `create_date`,`d1`.`create_by` AS `create_by`,`d1`.`modified_date` AS `modified_date`,`d1`.`modified_by` AS `modified_by` from ((((((`view_type` `vt` join `dept_descendent` `dd`) join `department` `d1`) join `department_child` `dc`) join `department` `d2`) join `view_type_to_subtype` `vtst`) join `dept_node_type` `dt`) where ((`dd`.`view_type_code` = `vt`.`view_type_code`) and (`dd`.`parent_id` = `vt`.`root_dept_id`) and (`d1`.`dept_id` = `dd`.`child_id`) and (`dc`.`parent_id` = `d2`.`dept_id`) and (`d1`.`dept_id` = `dc`.`child_id`) and (`vtst`.`view_type_code` = `vt`.`view_type_code`) and (`dc`.`view_subtype_id` = `vtst`.`view_subtype_id`) and (`dt`.`dept_type_id` = `d1`.`dept_type_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `wh_expanded_object_link`
--

/*!50001 DROP TABLE `wh_expanded_object_link`*/;
/*!50001 DROP VIEW IF EXISTS `wh_expanded_object_link`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `wh_expanded_object_link` AS select `vtst`.`view_type_code` AS `view_type_code`,`d`.`d_code` AS `d_code`,`x`.`object_type_code` AS `object_type_code`,`x`.`object_code` AS `object_code`,`x`.`link_by_object_code` AS `link_by_object_code`,`d`.`dept_id` AS `dept_id` from (((((`expanded_object_link` `x` join `department` `d`) join `department_child` `dc`) join `view_type_to_subtype` `vtst`) join `view_type` `vt`) join `dept_descendent` `dd`) where ((`d`.`dept_id` = `x`.`dept_id`) and (`dc`.`view_subtype_id` = `vtst`.`view_subtype_id`) and (`dc`.`child_id` = `x`.`dept_id`) and (`vt`.`view_type_code` = `vtst`.`view_type_code`) and (`dd`.`view_type_code` = `vtst`.`view_type_code`) and (`dd`.`parent_id` = `vt`.`root_dept_id`) and (`d`.`dept_id` = `dd`.`child_id`) and ((not((`x`.`object_code` like '%.%'))) or (`x`.`object_type_code` <> 'SIS')) and (not(exists(select `dc`.`parent_id` AS `parent_id` from (`department_child` `dc2` join `view_type_to_subtype` `vtst2`) where ((`dc2`.`parent_id` = `x`.`dept_id`) and (`vtst2`.`view_type_code` = `vtst`.`view_type_code`) and (`dc2`.`view_subtype_id` = `vtst2`.`view_subtype_id`)))))) order by `vtst`.`view_type_code`,`d`.`d_code`,`x`.`object_type_code` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-04-07 12:51:36
