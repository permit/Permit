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
-- MySQL dump 10.13  Distrib 5.4.1-beta, for unknown-linux-gnu (x86_64)
--
-- Host: localhost    Database: rolesbb
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
-- Temporary table structure for view `access_to_qualname`
--

DROP TABLE IF EXISTS `access_to_qualname`;
/*!50001 DROP VIEW IF EXISTS `access_to_qualname`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `access_to_qualname` (
  `kerberos_name` varchar(8),
  `qualifier_type` char(4)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `application_version`
--

DROP TABLE IF EXISTS `application_version`;
/*!50001 DROP VIEW IF EXISTS `application_version`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `application_version` (
  `from_platform` varchar(30),
  `to_platform` varchar(30),
  `from_version` varchar(10),
  `to_version` varchar(10),
  `message_type` char(1),
  `message_text` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `auth_audit`
--

DROP TABLE IF EXISTS `auth_audit`;
/*!50001 DROP VIEW IF EXISTS `auth_audit`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `auth_audit` (
  `auth_audit_id` bigint(10),
  `roles_username` varchar(8),
  `action_date` datetime,
  `action_type` char(1),
  `old_new` char(1),
  `authorization_id` bigint(10),
  `function_id` int(6),
  `qualifier_id` bigint(12),
  `kerberos_name` varchar(8),
  `qualifier_code` varchar(15),
  `function_name` varchar(30),
  `function_category` char(4),
  `modified_by` varchar(8),
  `modified_date` datetime,
  `do_function` char(1),
  `grant_and_view` char(2),
  `descend` char(1),
  `effective_date` datetime,
  `expiration_date` datetime,
  `server_username` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `auth_in_qualbranch`
--

DROP TABLE IF EXISTS `auth_in_qualbranch`;
/*!50001 DROP VIEW IF EXISTS `auth_in_qualbranch`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `auth_in_qualbranch` (
  `AUTHORIZATION_ID` bigint(20),
  `FUNCTION_ID` int(11),
  `QUALIFIER_ID` bigint(20),
  `KERBEROS_NAME` varchar(8),
  `QUALIFIER_CODE` varchar(15),
  `FUNCTION_NAME` varchar(30),
  `FUNCTION_CATEGORY` char(4),
  `QUALIFIER_NAME` varchar(50),
  `MODIFIED_BY` varchar(8),
  `MODIFIED_DATE` datetime,
  `DO_FUNCTION` char(1),
  `GRANT_AND_VIEW` char(2),
  `DESCEND` char(1),
  `EFFECTIVE_DATE` datetime,
  `EXPIRATION_DATE` datetime,
  `dept_qual_code` varchar(15),
  `QUALIFIER_TYPE` char(4)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `auth_rule_type`
--

DROP TABLE IF EXISTS `auth_rule_type`;
/*!50001 DROP VIEW IF EXISTS `auth_rule_type`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `auth_rule_type` (
  `rule_type_code` varchar(4),
  `rule_type_short_name` varchar(60),
  `rule_type_description` varchar(2000)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `authorizable_function`
--

DROP TABLE IF EXISTS `authorizable_function`;
/*!50001 DROP VIEW IF EXISTS `authorizable_function`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `authorizable_function` (
  `FUNCTION_ID` int(11)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `authorization`
--

DROP TABLE IF EXISTS `authorization`;
/*!50001 DROP VIEW IF EXISTS `authorization`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `authorization` (
  `authorization_id` bigint(10),
  `function_id` int(6),
  `qualifier_id` bigint(12),
  `kerberos_name` varchar(8),
  `qualifier_code` varchar(15),
  `function_name` varchar(30),
  `function_category` char(4),
  `qualifier_name` varchar(50),
  `modified_by` varchar(8),
  `modified_date` datetime,
  `do_function` char(1),
  `grant_and_view` char(2),
  `descend` char(1),
  `effective_date` datetime,
  `expiration_date` datetime
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `authorization2`
--

DROP TABLE IF EXISTS `authorization2`;
/*!50001 DROP VIEW IF EXISTS `authorization2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `authorization2` (
  `AUTHORIZATION_ID` bigint(20),
  `FUNCTION_ID` int(11),
  `QUALIFIER_ID` bigint(20),
  `KERBEROS_NAME` varchar(8),
  `QUALIFIER_CODE` varchar(15),
  `FUNCTION_NAME` varchar(30),
  `FUNCTION_CATEGORY` char(4),
  `QUALIFIER_NAME` varchar(50),
  `MODIFIED_BY` varchar(8),
  `MODIFIED_DATE` datetime,
  `DO_FUNCTION` char(1),
  `GRANT_AND_VIEW` char(2),
  `DESCEND` char(1),
  `EFFECTIVE_DATE` datetime,
  `EXPIRATION_DATE` datetime,
  `AUTH_TYPE` varchar(1)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `category`
--

DROP TABLE IF EXISTS `category`;
/*!50001 DROP VIEW IF EXISTS `category`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `category` (
  `function_category` char(4),
  `function_category_desc` varchar(15),
  `auths_are_sensitive` char(1)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `connect_log`
--

DROP TABLE IF EXISTS `connect_log`;
/*!50001 DROP VIEW IF EXISTS `connect_log`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `connect_log` (
  `roles_username` varchar(8),
  `connect_date` datetime,
  `client_version` varchar(10),
  `client_platform` varchar(15),
  `last_name` varchar(30),
  `first_name` varchar(30),
  `mit_id` varchar(10)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `criteria`
--

DROP TABLE IF EXISTS `criteria`;
/*!50001 DROP VIEW IF EXISTS `criteria`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `criteria` (
  `criteria_id` decimal(22,0),
  `criteria_name` varchar(255),
  `sql_fragment` varchar(1000)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `criteria2`
--

DROP TABLE IF EXISTS `criteria2`;
/*!50001 DROP VIEW IF EXISTS `criteria2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `criteria2` (
  `criteria_id` decimal(22,0),
  `criteria_name` varchar(255),
  `sql_fragment` varchar(350)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `criteria_instance`
--

DROP TABLE IF EXISTS `criteria_instance`;
/*!50001 DROP VIEW IF EXISTS `criteria_instance`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `criteria_instance` (
  `selection_id` decimal(22,0),
  `criteria_id` decimal(22,0),
  `username` varchar(60),
  `apply` char(1),
  `value` varchar(255),
  `next_scrn_selection_id` decimal(22,0),
  `no_change` char(1),
  `sequence` int(5)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `dept_approver_function`
--

DROP TABLE IF EXISTS `dept_approver_function`;
/*!50001 DROP VIEW IF EXISTS `dept_approver_function`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `dept_approver_function` (
  `dept_code` varchar(15),
  `function_id` int(6)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `dept_people`
--

DROP TABLE IF EXISTS `dept_people`;
/*!50001 DROP VIEW IF EXISTS `dept_people`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `dept_people` (
  `kerberos_name` varchar(8),
  `over_dept_code` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `dept_sap_auth`
--

DROP TABLE IF EXISTS `dept_sap_auth`;
/*!50001 DROP VIEW IF EXISTS `dept_sap_auth`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `dept_sap_auth` (
  `kerberos_name` varchar(8),
  `function_id` int(11),
  `function_name` varchar(30),
  `qualifier_id` bigint(20),
  `qualifier_code` varchar(15),
  `descend` char(1),
  `grant_and_view` char(2),
  `expiration_date` datetime,
  `effective_date` datetime,
  `dept_fc_code` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `dept_sap_auth2`
--

DROP TABLE IF EXISTS `dept_sap_auth2`;
/*!50001 DROP VIEW IF EXISTS `dept_sap_auth2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `dept_sap_auth2` (
  `kerberos_name` varchar(8),
  `function_id` int(11),
  `function_name` varchar(30),
  `qualifier_id` bigint(20),
  `qualifier_code` varchar(15),
  `descend` char(1),
  `grant_and_view` char(2),
  `expiration_date` datetime,
  `effective_date` datetime,
  `dept_sg_code` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `error_kluge`
--

DROP TABLE IF EXISTS `error_kluge`;
/*!50001 DROP VIEW IF EXISTS `error_kluge`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `error_kluge` (
  `qualifier_id` bigint(12),
  `qualifier_code` varchar(15),
  `qualifier_name` varchar(50),
  `qualifier_type` char(4),
  `has_child` char(1),
  `qualifier_level` int(4)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `exp_auth_func_qual_lim_dept`
--

DROP TABLE IF EXISTS `exp_auth_func_qual_lim_dept`;
/*!50001 DROP VIEW IF EXISTS `exp_auth_func_qual_lim_dept`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `exp_auth_func_qual_lim_dept` (
  `AUTHORIZATION_ID` bigint(20),
  `FUNCTION_ID` int(11),
  `QUALIFIER_ID` bigint(20),
  `KERBEROS_NAME` varchar(8),
  `QUALIFIER_CODE` varchar(15),
  `FUNCTION_NAME` varchar(30),
  `FUNCTION_CATEGORY` char(4),
  `QUALIFIER_NAME` varchar(50),
  `MODIFIED_BY` varchar(8),
  `MODIFIED_DATE` datetime,
  `DO_FUNCTION` char(1),
  `GRANT_AND_VIEW` char(2),
  `DESCEND` char(1),
  `EFFECTIVE_DATE` datetime,
  `EXPIRATION_DATE` datetime,
  `parent_auth_id` bigint(20),
  `parent_func_id` int(11),
  `parent_qual_id` bigint(20),
  `parent_qual_code` varchar(15),
  `parent_function_name` varchar(30),
  `parent_qual_name` varchar(50)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `expanded_auth2`
--

DROP TABLE IF EXISTS `expanded_auth2`;
/*!50001 DROP VIEW IF EXISTS `expanded_auth2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `expanded_auth2` (
  `authorization_id` bigint(20),
  `function_id` int(11),
  `qualifier_id` bigint(20),
  `kerberos_name` varchar(8),
  `qualifier_code` varchar(15),
  `function_name` varchar(30),
  `function_category` char(4),
  `qualifier_name` varchar(50),
  `modified_by` varchar(8),
  `modified_date` datetime,
  `do_function` char(1),
  `grant_and_view` char(2),
  `descend` char(1),
  `effective_date` datetime,
  `expiration_date` datetime,
  `qualifier_type` char(4),
  `virtual_or_real` varchar(1)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `expanded_auth_func_qual`
--

DROP TABLE IF EXISTS `expanded_auth_func_qual`;
/*!50001 DROP VIEW IF EXISTS `expanded_auth_func_qual`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `expanded_auth_func_qual` (
  `AUTHORIZATION_ID` bigint(20),
  `FUNCTION_ID` int(11),
  `QUALIFIER_ID` bigint(20),
  `KERBEROS_NAME` varchar(8),
  `QUALIFIER_CODE` varchar(15),
  `FUNCTION_NAME` varchar(30),
  `FUNCTION_CATEGORY` char(4),
  `QUALIFIER_NAME` varchar(50),
  `QUALIFIER_TYPE` char(4),
  `MODIFIED_BY` varchar(8),
  `MODIFIED_DATE` datetime,
  `DO_FUNCTION` char(1),
  `GRANT_AND_VIEW` char(2),
  `DESCEND` char(1),
  `EFFECTIVE_DATE` datetime,
  `EXPIRATION_DATE` datetime,
  `parent_auth_id` bigint(20),
  `parent_func_id` int(11),
  `parent_qual_id` bigint(20),
  `parent_qual_code` varchar(15),
  `parent_function_name` varchar(30),
  `parent_qual_name` varchar(50),
  `is_in_effect` varchar(2)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `expanded_auth_no_root`
--

DROP TABLE IF EXISTS `expanded_auth_no_root`;
/*!50001 DROP VIEW IF EXISTS `expanded_auth_no_root`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `expanded_auth_no_root` (
  `kerberos_name` varchar(8),
  `function_id` int(11),
  `function_name` varchar(30),
  `qualifier_code` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `expanded_authorization`
--

DROP TABLE IF EXISTS `expanded_authorization`;
/*!50001 DROP VIEW IF EXISTS `expanded_authorization`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `expanded_authorization` (
  `kerberos_name` varchar(8),
  `function_id` int(11),
  `function_name` varchar(30),
  `qualifier_code` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `external_auth`
--

DROP TABLE IF EXISTS `external_auth`;
/*!50001 DROP VIEW IF EXISTS `external_auth`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `external_auth` (
  `authorization_id` bigint(10),
  `function_id` int(6),
  `qualifier_id` bigint(12),
  `kerberos_name` varchar(8),
  `qualifier_code` varchar(15),
  `function_name` varchar(30),
  `function_category` char(4),
  `qualifier_name` varchar(50),
  `modified_by` varchar(8),
  `modified_date` datetime,
  `do_function` char(1),
  `grant_and_view` char(2),
  `descend` char(1),
  `effective_date` datetime,
  `expiration_date` datetime
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `external_function`
--

DROP TABLE IF EXISTS `external_function`;
/*!50001 DROP VIEW IF EXISTS `external_function`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `external_function` (
  `function_id` int(6),
  `function_name` varchar(30),
  `function_description` varchar(50),
  `function_category` char(4),
  `creator` varchar(8),
  `modified_by` varchar(8),
  `modified_date` datetime,
  `qualifier_type` char(4),
  `primary_authorizable` char(1)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `extract_auth`
--

DROP TABLE IF EXISTS `extract_auth`;
/*!50001 DROP VIEW IF EXISTS `extract_auth`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `extract_auth` (
  `KERBEROS_NAME` varchar(8),
  `FUNCTION_NAME` varchar(30),
  `QUALIFIER_CODE` varchar(15),
  `FUNCTION_CATEGORY` char(4),
  `DESCEND` char(1),
  `EFFECTIVE_DATE` datetime,
  `EXPIRATION_DATE` datetime
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `extract_category`
--

DROP TABLE IF EXISTS `extract_category`;
/*!50001 DROP VIEW IF EXISTS `extract_category`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `extract_category` (
  `username` varchar(20),
  `function_category` char(4)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `extract_desc`
--

DROP TABLE IF EXISTS `extract_desc`;
/*!50001 DROP VIEW IF EXISTS `extract_desc`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `extract_desc` (
  `PARENT_CODE` varchar(15),
  `CHILD_CODE` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `function`
--

DROP TABLE IF EXISTS `function`;
/*!50001 DROP VIEW IF EXISTS `function`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `function` (
  `function_id` int(6),
  `function_name` varchar(30),
  `function_description` varchar(50),
  `function_category` char(4),
  `creator` varchar(8),
  `modified_by` varchar(8),
  `modified_date` datetime,
  `qualifier_type` char(4),
  `primary_authorizable` char(1),
  `is_primary_auth_parent` varchar(1),
  `primary_auth_group` varchar(4)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `function2`
--

DROP TABLE IF EXISTS `function2`;
/*!50001 DROP VIEW IF EXISTS `function2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `function2` (
  `function_id` int(11),
  `function_name` varchar(30),
  `function_description` varchar(50),
  `function_category` char(4),
  `modified_by` varchar(8),
  `modified_date` datetime,
  `qualifier_type` char(4),
  `primary_authorizable` char(1),
  `is_primary_auth_parent` varchar(1),
  `primary_auth_group` varchar(4),
  `real_or_external` varchar(1)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `function_child`
--

DROP TABLE IF EXISTS `function_child`;
/*!50001 DROP VIEW IF EXISTS `function_child`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `function_child` (
  `parent_id` int(6),
  `child_id` int(6)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `function_group`
--

DROP TABLE IF EXISTS `function_group`;
/*!50001 DROP VIEW IF EXISTS `function_group`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `function_group` (
  `function_group_id` int(6),
  `function_group_name` varchar(30),
  `function_group_desc` varchar(70),
  `function_category` char(4),
  `matches_a_function` varchar(1),
  `qualifier_type` char(4),
  `modified_by` varchar(8),
  `modified_date` datetime
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `function_group_link`
--

DROP TABLE IF EXISTS `function_group_link`;
/*!50001 DROP VIEW IF EXISTS `function_group_link`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `function_group_link` (
  `parent_id` int(6),
  `child_id` int(6)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `function_load_pass`
--

DROP TABLE IF EXISTS `function_load_pass`;
/*!50001 DROP VIEW IF EXISTS `function_load_pass`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `function_load_pass` (
  `function_id` int(6),
  `pass_number` int(6)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `funds_cntr_release_str`
--

DROP TABLE IF EXISTS `funds_cntr_release_str`;
/*!50001 DROP VIEW IF EXISTS `funds_cntr_release_str`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `funds_cntr_release_str` (
  `fund_center_id` varchar(9),
  `release_strategy` varchar(1),
  `modified_by` varchar(8),
  `modified_date` datetime
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `hide_default`
--

DROP TABLE IF EXISTS `hide_default`;
/*!50001 DROP VIEW IF EXISTS `hide_default`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `hide_default` (
  `selection_id` decimal(22,0),
  `apply_username` varchar(60),
  `default_flag` char(1),
  `hide_flag` char(1)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `implied_auth_rule`
--

DROP TABLE IF EXISTS `implied_auth_rule`;
/*!50001 DROP VIEW IF EXISTS `implied_auth_rule`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `implied_auth_rule` (
  `rule_id` int(11),
  `rule_type_code` varchar(4),
  `condition_function_or_group` varchar(1),
  `condition_function_category` varchar(4),
  `condition_function_name` varchar(30),
  `condition_obj_type` varchar(15),
  `condition_qual_code` varchar(15),
  `result_function_category` varchar(4),
  `result_function_name` varchar(30),
  `auth_parent_obj_type` varchar(15),
  `result_qualifier_code` varchar(15),
  `rule_short_name` varchar(50),
  `rule_description` varchar(2000),
  `rule_is_in_effect` varchar(1),
  `modified_by` varchar(8),
  `modified_date` datetime
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `pa_group`
--

DROP TABLE IF EXISTS `pa_group`;
/*!50001 DROP VIEW IF EXISTS `pa_group`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `pa_group` (
  `primary_auth_group` varchar(4),
  `description` varchar(70),
  `web_description` varchar(70),
  `sort_order` int(6)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `people_who_can_spend`
--

DROP TABLE IF EXISTS `people_who_can_spend`;
/*!50001 DROP VIEW IF EXISTS `people_who_can_spend`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `people_who_can_spend` (
  `kerberos_name` varchar(8),
  `function_id` int(11),
  `function_name` varchar(30),
  `qualifier_id` bigint(20),
  `qualifier_code` varchar(15),
  `descend` char(1),
  `grant_and_view` char(2),
  `spendable_fund` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `person`
--

DROP TABLE IF EXISTS `person`;
/*!50001 DROP VIEW IF EXISTS `person`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `person` (
  `mit_id` char(10),
  `last_name` varchar(30),
  `first_name` varchar(30),
  `kerberos_name` varchar(8),
  `email_addr` varchar(60),
  `dept_code` varchar(12),
  `primary_person_type` char(1),
  `org_unit_id` bigint(12),
  `active` char(1),
  `status_code` char(1),
  `status_date` datetime
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `person_history`
--

DROP TABLE IF EXISTS `person_history`;
/*!50001 DROP VIEW IF EXISTS `person_history`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `person_history` (
  `kerberos_name` varchar(8),
  `mit_id` varchar(9),
  `last_name` varchar(30),
  `first_name` varchar(30),
  `middle_name` varchar(30),
  `unit_code` varchar(12),
  `unit_name` varchar(50),
  `person_type` varchar(20),
  `begin_date` datetime,
  `end_date` datetime
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `person_type`
--

DROP TABLE IF EXISTS `person_type`;
/*!50001 DROP VIEW IF EXISTS `person_type`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `person_type` (
  `person_type` char(1),
  `description` varchar(50)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `pickable_auth_category`
--

DROP TABLE IF EXISTS `pickable_auth_category`;
/*!50001 DROP VIEW IF EXISTS `pickable_auth_category`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `pickable_auth_category` (
  `kerberos_name` varchar(8),
  `function_category` char(4),
  `function_category_desc` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `pickable_auth_function`
--

DROP TABLE IF EXISTS `pickable_auth_function`;
/*!50001 DROP VIEW IF EXISTS `pickable_auth_function`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `pickable_auth_function` (
  `kerberos_name` varchar(8),
  `function_id` int(11),
  `function_name` varchar(30),
  `function_category` char(4),
  `qualifier_type` char(4),
  `function_description` varchar(50)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `pickable_auth_qual_top`
--

DROP TABLE IF EXISTS `pickable_auth_qual_top`;
/*!50001 DROP VIEW IF EXISTS `pickable_auth_qual_top`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `pickable_auth_qual_top` (
  `kerberos_name` varchar(8),
  `function_name` varchar(30),
  `function_id` int(11),
  `qualifier_type` char(4),
  `qualifier_code` varchar(15),
  `qualifier_id` bigint(20)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `plan_table`
--

DROP TABLE IF EXISTS `plan_table`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `plan_table` (
  `statement_id` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `remarks` varchar(80) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `operation` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `options` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `object_node` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `object_owner` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `object_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `object_instance` decimal(22,0) DEFAULT NULL,
  `object_type` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `optimizer` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `search_columns` decimal(22,0) DEFAULT NULL,
  `id` decimal(22,0) DEFAULT NULL,
  `parent_id` decimal(22,0) DEFAULT NULL,
  `position` decimal(22,0) DEFAULT NULL,
  `cost` decimal(22,0) DEFAULT NULL,
  `cardinality` decimal(22,0) DEFAULT NULL,
  `bytes` decimal(22,0) DEFAULT NULL,
  `other_tag` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `partition_start` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `partition_stop` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `partition_id` decimal(22,0) DEFAULT NULL,
  `other` longtext CHARACTER SET latin1 COLLATE latin1_bin,
  `distribution` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `primary_auth_descendent`
--

DROP TABLE IF EXISTS `primary_auth_descendent`;
/*!50001 DROP VIEW IF EXISTS `primary_auth_descendent`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `primary_auth_descendent` (
  `parent_id` bigint(12),
  `child_id` bigint(12),
  `is_dlc` char(1)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `qualifier`
--

DROP TABLE IF EXISTS `qualifier`;
/*!50001 DROP VIEW IF EXISTS `qualifier`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `qualifier` (
  `qualifier_id` bigint(12),
  `qualifier_code` varchar(15),
  `qualifier_name` varchar(50),
  `qualifier_type` char(4),
  `has_child` char(1),
  `qualifier_level` int(4),
  `custom_hierarchy` char(1),
  `status` varchar(1),
  `last_modified_date` datetime
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `qualifier2`
--

DROP TABLE IF EXISTS `qualifier2`;
/*!50001 DROP VIEW IF EXISTS `qualifier2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `qualifier2` (
  `QUALIFIER_ID` bigint(12),
  `QUALIFIER_CODE` varchar(15),
  `QUALIFIER_NAME` varchar(50),
  `QUALIFIER_TYPE` char(4),
  `HAS_CHILD` char(1),
  `QUALIFIER_LEVEL` int(4),
  `CUSTOM_HIERARCHY` char(1)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `qualifier_child`
--

DROP TABLE IF EXISTS `qualifier_child`;
/*!50001 DROP VIEW IF EXISTS `qualifier_child`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `qualifier_child` (
  `parent_id` bigint(12),
  `child_id` bigint(12)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `qualifier_descendent`
--

DROP TABLE IF EXISTS `qualifier_descendent`;
/*!50001 DROP VIEW IF EXISTS `qualifier_descendent`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `qualifier_descendent` (
  `parent_id` bigint(12),
  `child_id` bigint(12)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `qualifier_subtype`
--

DROP TABLE IF EXISTS `qualifier_subtype`;
/*!50001 DROP VIEW IF EXISTS `qualifier_subtype`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `qualifier_subtype` (
  `qualifier_subtype_code` varchar(15),
  `parent_qualifier_type` char(4),
  `qualifier_subtype_name` varchar(50),
  `contains_string` varchar(15),
  `min_allowable_qualifier_code` varchar(15),
  `max_allowable_qualifier_code` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `qualifier_type`
--

DROP TABLE IF EXISTS `qualifier_type`;
/*!50001 DROP VIEW IF EXISTS `qualifier_type`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `qualifier_type` (
  `qualifier_type` char(4),
  `qualifier_type_desc` varchar(30),
  `is_sensitive` varchar(1)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_access_to_qualname`
--

DROP TABLE IF EXISTS `rdb_t_access_to_qualname`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_access_to_qualname` (
  `kerberos_name` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `qualifier_type` char(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  PRIMARY KEY (`kerberos_name`,`qualifier_type`),
  KEY `rdb_i_aq_kerbname` (`kerberos_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_application_version`
--

DROP TABLE IF EXISTS `rdb_t_application_version`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_application_version` (
  `from_platform` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `to_platform` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `from_version` varchar(10) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `to_version` varchar(10) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `message_type` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `message_text` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_auth_audit`
--

DROP TABLE IF EXISTS `rdb_t_auth_audit`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_auth_audit` (
  `auth_audit_id` bigint(10) NOT NULL,
  `roles_username` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `action_date` datetime NOT NULL,
  `action_type` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `old_new` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `authorization_id` bigint(10) NOT NULL,
  `function_id` int(6) NOT NULL,
  `qualifier_id` bigint(12) NOT NULL,
  `kerberos_name` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `qualifier_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `function_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `function_category` char(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `modified_by` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  `do_function` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `grant_and_view` char(2) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `descend` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `effective_date` datetime DEFAULT NULL,
  `expiration_date` datetime DEFAULT NULL,
  `server_username` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  KEY `rdb_i_aa_auth_id` (`authorization_id`),
  KEY `roles_user_name` (`roles_username`),
  KEY `kerb_name_idx` (`kerberos_name`),
  KEY `srv_user_idx` (`server_username`),
  KEY `roles_user_idx` (`roles_username`),
  KEY `krb_user_idx` (`kerberos_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_auth_rule_type`
--

DROP TABLE IF EXISTS `rdb_t_auth_rule_type`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_auth_rule_type` (
  `rule_type_code` varchar(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `rule_type_short_name` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `rule_type_description` varchar(2000) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`rule_type_code`),
  KEY `rdb_uk_art_short_name` (`rule_type_short_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_authorization`
--

DROP TABLE IF EXISTS `rdb_t_authorization`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_authorization` (
  `authorization_id` bigint(10) NOT NULL AUTO_INCREMENT,
  `function_id` int(6) NOT NULL,
  `qualifier_id` bigint(12) NOT NULL,
  `kerberos_name` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `qualifier_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `function_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `function_category` char(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `qualifier_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `modified_by` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  `do_function` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `grant_and_view` char(2) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `descend` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `effective_date` datetime DEFAULT NULL,
  `expiration_date` datetime DEFAULT NULL,
  PRIMARY KEY (`authorization_id`),
  UNIQUE KEY `rdb_uk_id` (`function_id`,`qualifier_id`,`kerberos_name`),
  KEY `rdb_fk_a_function_category` (`function_category`),
  KEY `idx_fn` (`function_name`),
  KEY `idx_qid` (`qualifier_id`),
  KEY `idx_qcode` (`qualifier_code`),
  KEY `rdb_i_a_kerberos_name` (`kerberos_name`),
  KEY `rdb_i_a_function_id` (`function_id`),
  KEY `rdb_i_a_qualifier_id` (`qualifier_id`),
  KEY `rdb_i_a_qualifier_code` (`qualifier_code`),
  KEY `rdb_i_a_function_name` (`function_name`),
  KEY `rdb_i_a_function_category` (`function_category`),
  CONSTRAINT `rdb_fk_a_function_category` FOREIGN KEY (`function_category`) REFERENCES `rdb_t_category` (`function_category`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `rdb_fk_a_function_id` FOREIGN KEY (`function_id`) REFERENCES `rdb_t_function` (`function_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `rdb_fk_a_qualifier_id` FOREIGN KEY (`qualifier_id`) REFERENCES `rdb_t_qualifier` (`qualifier_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=477463 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_category`
--

DROP TABLE IF EXISTS `rdb_t_category`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_category` (
  `function_category` char(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `function_category_desc` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `auths_are_sensitive` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`function_category`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_connect_log`
--

DROP TABLE IF EXISTS `rdb_t_connect_log`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_connect_log` (
  `roles_username` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `connect_date` datetime NOT NULL,
  `client_version` varchar(10) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `client_platform` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `last_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `first_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `mit_id` varchar(10) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_criteria`
--

DROP TABLE IF EXISTS `rdb_t_criteria`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_criteria` (
  `criteria_id` decimal(22,0) NOT NULL,
  `criteria_name` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `sql_fragment` varchar(1000) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`criteria_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_criteria2`
--

DROP TABLE IF EXISTS `rdb_t_criteria2`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_criteria2` (
  `criteria_id` decimal(22,0) NOT NULL,
  `criteria_name` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `sql_fragment` varchar(350) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`criteria_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_criteria_instance`
--

DROP TABLE IF EXISTS `rdb_t_criteria_instance`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_criteria_instance` (
  `selection_id` decimal(22,0) NOT NULL,
  `criteria_id` decimal(22,0) NOT NULL,
  `username` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `apply` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `value` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `next_scrn_selection_id` decimal(22,0) DEFAULT NULL,
  `no_change` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `sequence` int(5) DEFAULT NULL,
  PRIMARY KEY (`selection_id`,`criteria_id`,`username`),
  KEY `rdb_fk_ci_criteria_id` (`criteria_id`),
  CONSTRAINT `rdb_fk_ci_criteria_id` FOREIGN KEY (`criteria_id`) REFERENCES `rdb_t_criteria` (`criteria_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `rdb_fk_ci_selection_id` FOREIGN KEY (`selection_id`) REFERENCES `rdb_t_selection_set` (`selection_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_dept_approver_function`
--

DROP TABLE IF EXISTS `rdb_t_dept_approver_function`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_dept_approver_function` (
  `dept_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `function_id` int(6) NOT NULL,
  KEY `rdb_i_af_dept` (`dept_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_error_kluge`
--

DROP TABLE IF EXISTS `rdb_t_error_kluge`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_error_kluge` (
  `qualifier_id` bigint(12) NOT NULL,
  `qualifier_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `qualifier_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `qualifier_type` char(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `has_child` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `qualifier_level` int(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_external_auth`
--

DROP TABLE IF EXISTS `rdb_t_external_auth`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_external_auth` (
  `authorization_id` bigint(10) NOT NULL AUTO_INCREMENT,
  `function_id` int(6) NOT NULL,
  `qualifier_id` bigint(12) NOT NULL,
  `kerberos_name` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `qualifier_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `function_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `function_category` char(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `qualifier_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `modified_by` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  `do_function` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `grant_and_view` char(2) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `descend` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `effective_date` datetime DEFAULT NULL,
  `expiration_date` datetime DEFAULT NULL,
  PRIMARY KEY (`authorization_id`),
  UNIQUE KEY `Index_k_fid_qid` (`kerberos_name`,`function_id`,`qualifier_id`),
  UNIQUE KEY `idx_k_fc_fn_qc` (`kerberos_name`,`function_category`,`function_name`,`qualifier_code`),
  KEY `rdb_i_ea_function_id` (`function_id`),
  KEY `rdb_i_ea_qualifier_id` (`qualifier_id`),
  KEY `rdb_fk_ea_function_category` (`function_category`),
  KEY `rdb_uk_ea_id` (`function_id`),
  KEY `rdb_i_ea_kerberos_name` (`kerberos_name`),
  KEY `rdb_i_ea_function_name` (`function_name`),
  KEY `rdb_i_ea_function_category` (`function_category`),
  KEY `rdb_i_ea_qualifier_code` (`qualifier_code`),
  CONSTRAINT `rdb_fk_ea_function_category` FOREIGN KEY (`function_category`) REFERENCES `rdb_t_category` (`function_category`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `rdb_fk_ea_function_id` FOREIGN KEY (`function_id`) REFERENCES `rdb_t_external_function` (`function_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `rdb_fk_ea_qualifier_id` FOREIGN KEY (`qualifier_id`) REFERENCES `rdb_t_qualifier` (`qualifier_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=548779 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_external_function`
--

DROP TABLE IF EXISTS `rdb_t_external_function`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_external_function` (
  `function_id` int(6) NOT NULL,
  `function_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `function_description` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `function_category` char(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `creator` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `modified_by` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  `qualifier_type` char(4) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `primary_authorizable` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`function_id`),
  KEY `rdb_fk_ef_function_category` (`function_category`),
  KEY `rdb_uk_ef_function_name` (`function_name`),
  CONSTRAINT `rdb_fk_ef_function_category` FOREIGN KEY (`function_category`) REFERENCES `rdb_t_category` (`function_category`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_extract_category`
--

DROP TABLE IF EXISTS `rdb_t_extract_category`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_extract_category` (
  `username` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `function_category` char(4) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  KEY `rdb_i_ec_user` (`username`),
  KEY `rdb_i_ec_category` (`function_category`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_function`
--

DROP TABLE IF EXISTS `rdb_t_function`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_function` (
  `function_id` int(6) NOT NULL AUTO_INCREMENT,
  `function_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `function_description` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `function_category` char(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `creator` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `modified_by` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  `qualifier_type` char(4) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `primary_authorizable` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `is_primary_auth_parent` varchar(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `primary_auth_group` varchar(4) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`function_id`),
  KEY `rdb_fk_f_function_category` (`function_category`),
  KEY `rdb_uk_f_function_name` (`function_name`),
  CONSTRAINT `rdb_fk_f_function_category` FOREIGN KEY (`function_category`) REFERENCES `rdb_t_category` (`function_category`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4042 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_function_child`
--

DROP TABLE IF EXISTS `rdb_t_function_child`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_function_child` (
  `parent_id` int(6) NOT NULL,
  `child_id` int(6) NOT NULL,
  PRIMARY KEY (`parent_id`,`child_id`),
  KEY `rdb_i_fc_child_id` (`child_id`),
  KEY `rdb_i_fc_parent_id` (`parent_id`),
  CONSTRAINT `rdb_fk_fh_child_id` FOREIGN KEY (`child_id`) REFERENCES `rdb_t_function` (`function_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `rdb_fk_fh_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `rdb_t_function` (`function_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_function_group`
--

DROP TABLE IF EXISTS `rdb_t_function_group`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_function_group` (
  `function_group_id` int(6) NOT NULL,
  `function_group_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `function_group_desc` varchar(70) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `function_category` char(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `matches_a_function` varchar(1) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `qualifier_type` char(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `modified_by` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  PRIMARY KEY (`function_group_id`),
  KEY `rdb_fk_xfg_function_category` (`function_category`),
  KEY `rdb_uk_xfg_name` (`function_group_name`),
  CONSTRAINT `rdb_fk_xfg_function_category` FOREIGN KEY (`function_category`) REFERENCES `rdb_t_category` (`function_category`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_function_group_link`
--

DROP TABLE IF EXISTS `rdb_t_function_group_link`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_function_group_link` (
  `parent_id` int(6) NOT NULL,
  `child_id` int(6) NOT NULL,
  PRIMARY KEY (`parent_id`,`child_id`),
  KEY `rdb_i_fgl_child_id` (`child_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_function_load_pass`
--

DROP TABLE IF EXISTS `rdb_t_function_load_pass`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_function_load_pass` (
  `function_id` int(6) NOT NULL,
  `pass_number` int(6) DEFAULT NULL,
  PRIMARY KEY (`function_id`),
  CONSTRAINT `rdb_fk_flp_function2_id` FOREIGN KEY (`function_id`) REFERENCES `rdb_t_external_function` (`function_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_funds_cntr_release_str`
--

DROP TABLE IF EXISTS `rdb_t_funds_cntr_release_str`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_funds_cntr_release_str` (
  `fund_center_id` varchar(9) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `release_strategy` varchar(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `modified_by` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  PRIMARY KEY (`fund_center_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_hide_default`
--

DROP TABLE IF EXISTS `rdb_t_hide_default`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_hide_default` (
  `selection_id` decimal(22,0) NOT NULL,
  `apply_username` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `default_flag` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `hide_flag` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`selection_id`,`apply_username`),
  CONSTRAINT `rdb_fk_hd_selection_id` FOREIGN KEY (`selection_id`) REFERENCES `rdb_t_selection_set` (`selection_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_implied_auth_rule`
--

DROP TABLE IF EXISTS `rdb_t_implied_auth_rule`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_implied_auth_rule` (
  `rule_id` int(11) NOT NULL AUTO_INCREMENT,
  `rule_type_code` varchar(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `condition_function_or_group` varchar(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `condition_function_category` varchar(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `condition_function_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `condition_obj_type` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `condition_qual_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `result_function_category` varchar(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `result_function_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `auth_parent_obj_type` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `result_qualifier_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `rule_short_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `rule_description` varchar(2000) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `rule_is_in_effect` varchar(1) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `modified_by` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  PRIMARY KEY (`rule_id`),
  KEY `rdb_fk_iar_rule_type_code` (`rule_type_code`),
  KEY `rdb_uk_iar_short_name` (`rule_short_name`),
  KEY `rdb_i_iar_10fields` (`rule_type_code`),
  CONSTRAINT `rdb_fk_iar_rule_type_code` FOREIGN KEY (`rule_type_code`) REFERENCES `rdb_t_auth_rule_type` (`rule_type_code`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_log_sql`
--

DROP TABLE IF EXISTS `rdb_t_log_sql`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_log_sql` (
  `sessionid` decimal(22,0) NOT NULL,
  `username` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `log_time` datetime NOT NULL,
  `line_num` decimal(22,0) NOT NULL,
  `sql_line` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`sessionid`,`username`,`log_time`,`line_num`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_pa_group`
--

DROP TABLE IF EXISTS `rdb_t_pa_group`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_pa_group` (
  `primary_auth_group` varchar(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `description` varchar(70) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `web_description` varchar(70) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `sort_order` int(6) DEFAULT NULL,
  PRIMARY KEY (`primary_auth_group`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_person`
--

DROP TABLE IF EXISTS `rdb_t_person`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_person` (
  `mit_id` char(10) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `last_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `first_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `kerberos_name` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `email_addr` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `dept_code` varchar(12) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `primary_person_type` char(1) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `org_unit_id` bigint(12) DEFAULT NULL,
  `active` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `status_code` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `status_date` datetime DEFAULT NULL,
  PRIMARY KEY (`kerberos_name`),
  KEY `rdb_fk_p_person_type` (`primary_person_type`),
  KEY `rdb_i_p_mit_id` (`mit_id`),
  KEY `rdb_i_p_last_name` (`last_name`),
  CONSTRAINT `rdb_fk_p_person_type` FOREIGN KEY (`primary_person_type`) REFERENCES `rdb_t_person_type` (`person_type`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_person_history`
--

DROP TABLE IF EXISTS `rdb_t_person_history`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_person_history` (
  `kerberos_name` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `mit_id` varchar(9) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `last_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `first_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `middle_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `unit_code` varchar(12) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `unit_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `person_type` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `begin_date` datetime NOT NULL,
  `end_date` datetime DEFAULT NULL,
  UNIQUE KEY `kerberos_end_date_idx` (`kerberos_name`,`end_date`),
  KEY `rdb_i_ph_user` (`kerberos_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_person_type`
--

DROP TABLE IF EXISTS `rdb_t_person_type`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_person_type` (
  `person_type` char(1) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `description` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`person_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_primary_auth_descendent`
--

DROP TABLE IF EXISTS `rdb_t_primary_auth_descendent`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_primary_auth_descendent` (
  `parent_id` bigint(12) NOT NULL,
  `child_id` bigint(12) NOT NULL,
  `is_dlc` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  KEY `rdb_i_pad_child` (`child_id`),
  KEY `rdb_i_pad_parent` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_qualifier`
--

DROP TABLE IF EXISTS `rdb_t_qualifier`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_qualifier` (
  `qualifier_id` bigint(12) NOT NULL AUTO_INCREMENT,
  `qualifier_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `qualifier_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `qualifier_type` char(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `has_child` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `qualifier_level` int(4) DEFAULT NULL,
  `custom_hierarchy` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `status` varchar(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `last_modified_date` datetime DEFAULT NULL,
  PRIMARY KEY (`qualifier_id`),
  UNIQUE KEY `idx_qcode_qtype` (`qualifier_code`,`qualifier_type`) USING BTREE,
  KEY `rdb_fk_q_qual_type` (`qualifier_type`),
  KEY `rdb_i_q_qualifier_name` (`qualifier_name`),
  KEY `rdb_i_q_qualifier_type` (`qualifier_type`),
  KEY `rdb_i_q_qualifier_level` (`qualifier_level`),
  KEY `rdb_i_q_qualifier_code` (`qualifier_code`),
  CONSTRAINT `rdb_fk_q_qual_type` FOREIGN KEY (`qualifier_type`) REFERENCES `rdb_t_qualifier_type` (`qualifier_type`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7037199 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_qualifier_child`
--

DROP TABLE IF EXISTS `rdb_t_qualifier_child`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_qualifier_child` (
  `parent_id` bigint(12) NOT NULL,
  `child_id` bigint(12) NOT NULL,
  PRIMARY KEY (`parent_id`,`child_id`),
  KEY `rdb_i_qc_child` (`child_id`),
  KEY `rdb_i_qc_parent` (`parent_id`),
  KEY `child_id_idx` (`child_id`),
  KEY `parent_id_idx` (`parent_id`),
  CONSTRAINT `rdb_fk_qh_child_id` FOREIGN KEY (`child_id`) REFERENCES `rdb_t_qualifier` (`qualifier_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `rdb_fk_qh_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `rdb_t_qualifier` (`qualifier_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_qualifier_descendent`
--

DROP TABLE IF EXISTS `rdb_t_qualifier_descendent`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_qualifier_descendent` (
  `parent_id` bigint(12) NOT NULL,
  `child_id` bigint(12) NOT NULL,
  KEY `idx_pid1` (`parent_id`),
  KEY `idx_cid1` (`child_id`),
  KEY `parent_id_idx` (`parent_id`),
  KEY `child_id_idx` (`child_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_qualifier_subtype`
--

DROP TABLE IF EXISTS `rdb_t_qualifier_subtype`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_qualifier_subtype` (
  `qualifier_subtype_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `parent_qualifier_type` char(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `qualifier_subtype_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `contains_string` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `min_allowable_qualifier_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `max_allowable_qualifier_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`qualifier_subtype_code`),
  KEY `rdb_fk_qs_qualtype` (`parent_qualifier_type`),
  KEY `rdb_uk_qs_name` (`qualifier_subtype_name`),
  CONSTRAINT `rdb_fk_qs_qualtype` FOREIGN KEY (`parent_qualifier_type`) REFERENCES `rdb_t_qualifier_type` (`qualifier_type`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_qualifier_type`
--

DROP TABLE IF EXISTS `rdb_t_qualifier_type`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_qualifier_type` (
  `qualifier_type` char(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `qualifier_type_desc` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `is_sensitive` varchar(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`qualifier_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_roles_parameters`
--

DROP TABLE IF EXISTS `rdb_t_roles_parameters`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_roles_parameters` (
  `parameter` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `value` varchar(100) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `description` varchar(100) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `default_value` varchar(100) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `is_number` varchar(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `update_user` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `update_timestamp` datetime DEFAULT NULL,
  KEY `rdb_i_parameter` (`parameter`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_roles_users`
--

DROP TABLE IF EXISTS `rdb_t_roles_users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_roles_users` (
  `username` varchar(32) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `action_type` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `action_date` datetime DEFAULT NULL,
  `action_user` varchar(32) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `notes` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  KEY `rdb_i_ru_user` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_screen`
--

DROP TABLE IF EXISTS `rdb_t_screen`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_screen` (
  `screen_id` decimal(22,0) NOT NULL,
  `screen_name` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`screen_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_screen2`
--

DROP TABLE IF EXISTS `rdb_t_screen2`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_screen2` (
  `screen_id` decimal(22,0) NOT NULL,
  `screen_name` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`screen_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_selection_criteria2`
--

DROP TABLE IF EXISTS `rdb_t_selection_criteria2`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_selection_criteria2` (
  `selection_id` decimal(22,0) NOT NULL,
  `criteria_id` decimal(22,0) NOT NULL,
  `default_apply` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `default_value` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `next_scrn_selection_id` decimal(22,0) DEFAULT NULL,
  `no_change` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `sequence` int(5) DEFAULT NULL,
  PRIMARY KEY (`selection_id`,`criteria_id`),
  KEY `rdb_fk_sc2_criteria_id` (`criteria_id`),
  CONSTRAINT `rdb_fk_sc2_criteria_id` FOREIGN KEY (`criteria_id`) REFERENCES `rdb_t_criteria2` (`criteria_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `rdb_fk_sc2_selection_id` FOREIGN KEY (`selection_id`) REFERENCES `rdb_t_selection_set2` (`selection_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_selection_set`
--

DROP TABLE IF EXISTS `rdb_t_selection_set`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_selection_set` (
  `selection_id` decimal(22,0) NOT NULL,
  `selection_name` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `screen_id` decimal(22,0) NOT NULL,
  PRIMARY KEY (`selection_id`),
  KEY `rdb_fk_ss_screen_id` (`screen_id`),
  CONSTRAINT `rdb_fk_ss_screen_id` FOREIGN KEY (`screen_id`) REFERENCES `rdb_t_screen` (`screen_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_selection_set2`
--

DROP TABLE IF EXISTS `rdb_t_selection_set2`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_selection_set2` (
  `selection_id` decimal(22,0) NOT NULL,
  `selection_name` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `screen_id` decimal(22,0) NOT NULL,
  `sequence` int(5) DEFAULT NULL,
  PRIMARY KEY (`selection_id`),
  KEY `rdb_fk_ss2_screen_id` (`screen_id`),
  CONSTRAINT `rdb_fk_ss2_screen_id` FOREIGN KEY (`screen_id`) REFERENCES `rdb_t_screen2` (`screen_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_special_sel_set2`
--

DROP TABLE IF EXISTS `rdb_t_special_sel_set2`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_special_sel_set2` (
  `selection_id` decimal(22,0) NOT NULL,
  `program_widget_id` decimal(22,0) NOT NULL,
  `program_widget_name` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`selection_id`),
  CONSTRAINT `rdb_fk_sss_sel_id` FOREIGN KEY (`selection_id`) REFERENCES `rdb_t_selection_set2` (`selection_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_special_username`
--

DROP TABLE IF EXISTS `rdb_t_special_username`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_special_username` (
  `username` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `first_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `last_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_subt_descendent_subt`
--

DROP TABLE IF EXISTS `rdb_t_subt_descendent_subt`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_subt_descendent_subt` (
  `parent_subtype_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `child_subtype_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  PRIMARY KEY (`parent_subtype_code`,`child_subtype_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_suppressed_qualname`
--

DROP TABLE IF EXISTS `rdb_t_suppressed_qualname`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_suppressed_qualname` (
  `qualifier_id` bigint(12) NOT NULL,
  `qualifier_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`qualifier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_temp_qual_id`
--

DROP TABLE IF EXISTS `rdb_t_temp_qual_id`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_temp_qual_id` (
  `qualifier_id` bigint(12) NOT NULL,
  `session_id` bigint(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_user_sel_criteria2`
--

DROP TABLE IF EXISTS `rdb_t_user_sel_criteria2`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_user_sel_criteria2` (
  `selection_id` decimal(22,0) NOT NULL,
  `criteria_id` decimal(22,0) NOT NULL,
  `username` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `apply` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `value` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`selection_id`,`criteria_id`,`username`),
  CONSTRAINT `rdb_fk_usc_sel_crit_id` FOREIGN KEY (`selection_id`, `criteria_id`) REFERENCES `rdb_t_selection_criteria2` (`selection_id`, `criteria_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_user_selection_set2`
--

DROP TABLE IF EXISTS `rdb_t_user_selection_set2`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_user_selection_set2` (
  `selection_id` decimal(22,0) NOT NULL,
  `apply_username` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `default_flag` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `hide_flag` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`selection_id`,`apply_username`),
  CONSTRAINT `rdb_fk_uss_selection_id` FOREIGN KEY (`selection_id`) REFERENCES `rdb_t_selection_set2` (`selection_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rdb_t_wh_cost_collector`
--

DROP TABLE IF EXISTS `rdb_t_wh_cost_collector`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rdb_t_wh_cost_collector` (
  `cost_collector_id_with_type` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `cost_collector_id` varchar(7) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `cost_collector_type_desc` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `cost_collector_name` varchar(40) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `organization_id` varchar(6) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `organization_name` varchar(40) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `is_closed_cost_collector` varchar(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `profit_center_id` varchar(7) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `profit_center_name` varchar(40) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `fund_id` varchar(7) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `fund_center_id` varchar(6) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `supervisor` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `cost_collector_effective_date` datetime DEFAULT NULL,
  `cost_collector_expiration_date` datetime DEFAULT NULL,
  `term_code` varchar(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `release_strategy` varchar(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `supervisor_room` varchar(10) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `addressee` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `addressee_room` varchar(10) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `supervisor_mit_id` varchar(9) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `addressee_mit_id` varchar(9) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `company_code` varchar(4) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `admin_flag` varchar(2) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  KEY `rdb_i_cc_ccid` (`cost_collector_id`),
  KEY `rdb_i_cc_ccidt` (`cost_collector_id_with_type`),
  KEY `rdb_i_cc_fc` (`fund_center_id`),
  KEY `rdb_i_cc_spid` (`supervisor_mit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_auth_in_qualbranch`
--

DROP TABLE IF EXISTS `rdb_v_auth_in_qualbranch`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_auth_in_qualbranch`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_auth_in_qualbranch` (
  `AUTHORIZATION_ID` bigint(20),
  `FUNCTION_ID` int(11),
  `QUALIFIER_ID` bigint(20),
  `KERBEROS_NAME` varchar(8),
  `QUALIFIER_CODE` varchar(15),
  `FUNCTION_NAME` varchar(30),
  `FUNCTION_CATEGORY` char(4),
  `QUALIFIER_NAME` varchar(50),
  `MODIFIED_BY` varchar(8),
  `MODIFIED_DATE` datetime,
  `DO_FUNCTION` char(1),
  `GRANT_AND_VIEW` char(2),
  `DESCEND` char(1),
  `EFFECTIVE_DATE` datetime,
  `EXPIRATION_DATE` datetime,
  `dept_qual_code` varchar(15),
  `QUALIFIER_TYPE` char(4)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_authorizable_function`
--

DROP TABLE IF EXISTS `rdb_v_authorizable_function`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_authorizable_function`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_authorizable_function` (
  `FUNCTION_ID` int(11)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_authorization2`
--

DROP TABLE IF EXISTS `rdb_v_authorization2`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_authorization2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_authorization2` (
  `AUTHORIZATION_ID` bigint(20),
  `FUNCTION_ID` int(11),
  `QUALIFIER_ID` bigint(20),
  `KERBEROS_NAME` varchar(8),
  `QUALIFIER_CODE` varchar(15),
  `FUNCTION_NAME` varchar(30),
  `FUNCTION_CATEGORY` char(4),
  `QUALIFIER_NAME` varchar(50),
  `MODIFIED_BY` varchar(8),
  `MODIFIED_DATE` datetime,
  `DO_FUNCTION` char(1),
  `GRANT_AND_VIEW` char(2),
  `DESCEND` char(1),
  `EFFECTIVE_DATE` datetime,
  `EXPIRATION_DATE` datetime,
  `AUTH_TYPE` varchar(1)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_dept_people`
--

DROP TABLE IF EXISTS `rdb_v_dept_people`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_dept_people`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_dept_people` (
  `kerberos_name` varchar(8),
  `over_dept_code` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_dept_sap_auth`
--

DROP TABLE IF EXISTS `rdb_v_dept_sap_auth`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_dept_sap_auth`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_dept_sap_auth` (
  `kerberos_name` varchar(8),
  `function_id` int(11),
  `function_name` varchar(30),
  `qualifier_id` bigint(20),
  `qualifier_code` varchar(15),
  `descend` char(1),
  `grant_and_view` char(2),
  `expiration_date` datetime,
  `effective_date` datetime,
  `dept_fc_code` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_dept_sap_auth2`
--

DROP TABLE IF EXISTS `rdb_v_dept_sap_auth2`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_dept_sap_auth2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_dept_sap_auth2` (
  `kerberos_name` varchar(8),
  `function_id` int(11),
  `function_name` varchar(30),
  `qualifier_id` bigint(20),
  `qualifier_code` varchar(15),
  `descend` char(1),
  `grant_and_view` char(2),
  `expiration_date` datetime,
  `effective_date` datetime,
  `dept_sg_code` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_exp_auth_f_q_lim_dept`
--

DROP TABLE IF EXISTS `rdb_v_exp_auth_f_q_lim_dept`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_exp_auth_f_q_lim_dept`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_exp_auth_f_q_lim_dept` (
  `AUTHORIZATION_ID` bigint(20),
  `FUNCTION_ID` int(11),
  `QUALIFIER_ID` bigint(20),
  `KERBEROS_NAME` varchar(8),
  `QUALIFIER_CODE` varchar(15),
  `FUNCTION_NAME` varchar(30),
  `FUNCTION_CATEGORY` char(4),
  `QUALIFIER_NAME` varchar(50),
  `MODIFIED_BY` varchar(8),
  `MODIFIED_DATE` datetime,
  `DO_FUNCTION` char(1),
  `GRANT_AND_VIEW` char(2),
  `DESCEND` char(1),
  `EFFECTIVE_DATE` datetime,
  `EXPIRATION_DATE` datetime,
  `parent_auth_id` bigint(20),
  `parent_func_id` int(11),
  `parent_qual_id` bigint(20),
  `parent_qual_code` varchar(15),
  `parent_function_name` varchar(30),
  `parent_qual_name` varchar(50)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_expanded_auth2`
--

DROP TABLE IF EXISTS `rdb_v_expanded_auth2`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_expanded_auth2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_expanded_auth2` (
  `authorization_id` bigint(20),
  `function_id` int(11),
  `qualifier_id` bigint(20),
  `kerberos_name` varchar(8),
  `qualifier_code` varchar(15),
  `function_name` varchar(30),
  `function_category` char(4),
  `qualifier_name` varchar(50),
  `modified_by` varchar(8),
  `modified_date` datetime,
  `do_function` char(1),
  `grant_and_view` char(2),
  `descend` char(1),
  `effective_date` datetime,
  `expiration_date` datetime,
  `qualifier_type` char(4),
  `virtual_or_real` varchar(1)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_expanded_auth_func_qual`
--

DROP TABLE IF EXISTS `rdb_v_expanded_auth_func_qual`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_expanded_auth_func_qual`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_expanded_auth_func_qual` (
  `AUTHORIZATION_ID` bigint(20),
  `FUNCTION_ID` int(11),
  `QUALIFIER_ID` bigint(20),
  `KERBEROS_NAME` varchar(8),
  `QUALIFIER_CODE` varchar(15),
  `FUNCTION_NAME` varchar(30),
  `FUNCTION_CATEGORY` char(4),
  `QUALIFIER_NAME` varchar(50),
  `QUALIFIER_TYPE` char(4),
  `MODIFIED_BY` varchar(8),
  `MODIFIED_DATE` datetime,
  `DO_FUNCTION` char(1),
  `GRANT_AND_VIEW` char(2),
  `DESCEND` char(1),
  `EFFECTIVE_DATE` datetime,
  `EXPIRATION_DATE` datetime,
  `parent_auth_id` bigint(20),
  `parent_func_id` int(11),
  `parent_qual_id` bigint(20),
  `parent_qual_code` varchar(15),
  `parent_function_name` varchar(30),
  `parent_qual_name` varchar(50),
  `is_in_effect` varchar(2)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_expanded_auth_func_root`
--

DROP TABLE IF EXISTS `rdb_v_expanded_auth_func_root`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_expanded_auth_func_root`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_expanded_auth_func_root` (
  `AUTHORIZATION_ID` bigint(20),
  `FUNCTION_ID` int(11),
  `QUALIFIER_ID` bigint(20),
  `KERBEROS_NAME` varchar(8),
  `QUALIFIER_CODE` varchar(15),
  `FUNCTION_NAME` varchar(30),
  `FUNCTION_CATEGORY` char(4),
  `QUALIFIER_NAME` varchar(50),
  `MODIFIED_BY` varchar(8),
  `MODIFIED_DATE` datetime,
  `DO_FUNCTION` char(1),
  `GRANT_AND_VIEW` char(2),
  `DESCEND` char(1),
  `EFFECTIVE_DATE` datetime,
  `EXPIRATION_DATE` datetime,
  `parent_auth_id` bigint(20),
  `parent_func_id` int(11),
  `parent_qual_id` bigint(20),
  `parent_qual_code` varchar(15),
  `parent_function_name` varchar(30),
  `parent_qual_name` varchar(50)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_expanded_auth_no_root`
--

DROP TABLE IF EXISTS `rdb_v_expanded_auth_no_root`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_expanded_auth_no_root`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_expanded_auth_no_root` (
  `kerberos_name` varchar(8),
  `function_id` int(11),
  `function_name` varchar(30),
  `qualifier_code` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_expanded_authorization`
--

DROP TABLE IF EXISTS `rdb_v_expanded_authorization`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_expanded_authorization`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_expanded_authorization` (
  `kerberos_name` varchar(8),
  `function_id` int(11),
  `function_name` varchar(30),
  `qualifier_code` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_extract_auth`
--

DROP TABLE IF EXISTS `rdb_v_extract_auth`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_extract_auth`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_extract_auth` (
  `KERBEROS_NAME` varchar(8),
  `FUNCTION_NAME` varchar(30),
  `QUALIFIER_CODE` varchar(15),
  `FUNCTION_CATEGORY` char(4),
  `DESCEND` char(1),
  `EFFECTIVE_DATE` datetime,
  `EXPIRATION_DATE` datetime
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_extract_desc`
--

DROP TABLE IF EXISTS `rdb_v_extract_desc`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_extract_desc`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_extract_desc` (
  `PARENT_CODE` varchar(15),
  `CHILD_CODE` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_function2`
--

DROP TABLE IF EXISTS `rdb_v_function2`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_function2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_function2` (
  `function_id` int(11),
  `function_name` varchar(30),
  `function_description` varchar(50),
  `function_category` char(4),
  `modified_by` varchar(8),
  `modified_date` datetime,
  `qualifier_type` char(4),
  `primary_authorizable` char(1),
  `is_primary_auth_parent` varchar(1),
  `primary_auth_group` varchar(4),
  `real_or_external` varchar(1)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_people_who_can_spend`
--

DROP TABLE IF EXISTS `rdb_v_people_who_can_spend`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_people_who_can_spend`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_people_who_can_spend` (
  `kerberos_name` varchar(8),
  `function_id` int(11),
  `function_name` varchar(30),
  `qualifier_id` bigint(20),
  `qualifier_code` varchar(15),
  `descend` char(1),
  `grant_and_view` char(2),
  `spendable_fund` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_person`
--

DROP TABLE IF EXISTS `rdb_v_person`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_person`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_person` (
  `MIT_ID` varchar(6),
  `LAST_NAME` varchar(9),
  `FIRST_NAME` varchar(10),
  `KERBEROS_NAME` varchar(13),
  `EMAIL_ADDR` varchar(10),
  `DEPT_CODE` varchar(9),
  `PRIMARY_PERSON_TYPE` varchar(19),
  `ORG_UNIT_ID` varchar(11),
  `ACTIVE` varchar(6),
  `STATUS_CODE` varchar(11),
  `STATUS_DATE` varchar(11)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_pickable_auth_category`
--

DROP TABLE IF EXISTS `rdb_v_pickable_auth_category`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_pickable_auth_category`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_pickable_auth_category` (
  `kerberos_name` varchar(8),
  `function_category` char(4),
  `function_category_desc` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_pickable_auth_function`
--

DROP TABLE IF EXISTS `rdb_v_pickable_auth_function`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_pickable_auth_function`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_pickable_auth_function` (
  `kerberos_name` varchar(8),
  `function_id` int(11),
  `function_name` varchar(30),
  `function_category` char(4),
  `qualifier_type` char(4),
  `function_description` varchar(50)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_pickable_auth_qual_top`
--

DROP TABLE IF EXISTS `rdb_v_pickable_auth_qual_top`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_pickable_auth_qual_top`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_pickable_auth_qual_top` (
  `kerberos_name` varchar(8),
  `function_name` varchar(30),
  `function_id` int(11),
  `qualifier_type` char(4),
  `qualifier_code` varchar(15),
  `qualifier_id` bigint(20)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_qualifier2`
--

DROP TABLE IF EXISTS `rdb_v_qualifier2`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_qualifier2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_qualifier2` (
  `QUALIFIER_ID` bigint(12),
  `QUALIFIER_CODE` varchar(15),
  `QUALIFIER_NAME` varchar(50),
  `QUALIFIER_TYPE` char(4),
  `HAS_CHILD` char(1),
  `QUALIFIER_LEVEL` int(4),
  `CUSTOM_HIERARCHY` char(1)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_viewable_category`
--

DROP TABLE IF EXISTS `rdb_v_viewable_category`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_viewable_category`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_viewable_category` (
  `kerberos_name` varchar(8),
  `function_category` varchar(4),
  `function_category_desc` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rdb_v_xexpanded_auth_func_qual`
--

DROP TABLE IF EXISTS `rdb_v_xexpanded_auth_func_qual`;
/*!50001 DROP VIEW IF EXISTS `rdb_v_xexpanded_auth_func_qual`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rdb_v_xexpanded_auth_func_qual` (
  `AUTHORIZATION_ID` bigint(20),
  `FUNCTION_ID` int(11),
  `QUALIFIER_ID` bigint(20),
  `KERBEROS_NAME` varchar(8),
  `QUALIFIER_CODE` varchar(15),
  `FUNCTION_NAME` varchar(30),
  `FUNCTION_CATEGORY` char(4),
  `QUALIFIER_NAME` varchar(50),
  `QUALIFIER_TYPE` char(4),
  `MODIFIED_BY` varchar(8),
  `MODIFIED_DATE` datetime,
  `DO_FUNCTION` char(1),
  `GRANT_AND_VIEW` char(2),
  `DESCEND` char(1),
  `EFFECTIVE_DATE` datetime,
  `EXPIRATION_DATE` datetime,
  `parent_auth_id` bigint(20),
  `parent_func_id` int(11),
  `parent_qual_id` bigint(20),
  `parent_qual_code` varchar(15),
  `parent_function_name` varchar(30),
  `parent_qual_name` varchar(50)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `roles_error_msg`
--

DROP TABLE IF EXISTS `roles_error_msg`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `roles_error_msg` (
  `err_no` int(10) NOT NULL DEFAULT '0',
  `err_msg` varchar(255) NOT NULL,
  PRIMARY KEY (`err_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `roles_parameters`
--

DROP TABLE IF EXISTS `roles_parameters`;
/*!50001 DROP VIEW IF EXISTS `roles_parameters`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `roles_parameters` (
  `parameter` varchar(30),
  `value` varchar(100),
  `description` varchar(100),
  `default_value` varchar(100),
  `is_number` varchar(1),
  `update_user` varchar(8),
  `update_timestamp` datetime
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `roles_users`
--

DROP TABLE IF EXISTS `roles_users`;
/*!50001 DROP VIEW IF EXISTS `roles_users`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `roles_users` (
  `username` varchar(32),
  `action_type` char(1),
  `action_date` datetime,
  `action_user` varchar(32),
  `notes` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `screen`
--

DROP TABLE IF EXISTS `screen`;
/*!50001 DROP VIEW IF EXISTS `screen`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `screen` (
  `screen_id` decimal(22,0),
  `screen_name` varchar(60)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `screen2`
--

DROP TABLE IF EXISTS `screen2`;
/*!50001 DROP VIEW IF EXISTS `screen2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `screen2` (
  `screen_id` decimal(22,0),
  `screen_name` varchar(60)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `selection_criteria2`
--

DROP TABLE IF EXISTS `selection_criteria2`;
/*!50001 DROP VIEW IF EXISTS `selection_criteria2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `selection_criteria2` (
  `selection_id` decimal(22,0),
  `criteria_id` decimal(22,0),
  `default_apply` char(1),
  `default_value` varchar(255),
  `next_scrn_selection_id` decimal(22,0),
  `no_change` char(1),
  `sequence` int(5)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `selection_set`
--

DROP TABLE IF EXISTS `selection_set`;
/*!50001 DROP VIEW IF EXISTS `selection_set`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `selection_set` (
  `selection_id` decimal(22,0),
  `selection_name` varchar(60),
  `screen_id` decimal(22,0)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `selection_set2`
--

DROP TABLE IF EXISTS `selection_set2`;
/*!50001 DROP VIEW IF EXISTS `selection_set2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `selection_set2` (
  `selection_id` decimal(22,0),
  `selection_name` varchar(60),
  `screen_id` decimal(22,0),
  `sequence` int(5)
) ENGINE=MyISAM */;
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
-- Temporary table structure for view `special_selection_set2`
--

DROP TABLE IF EXISTS `special_selection_set2`;
/*!50001 DROP VIEW IF EXISTS `special_selection_set2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `special_selection_set2` (
  `selection_id` decimal(22,0),
  `program_widget_id` decimal(22,0),
  `program_widget_name` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `special_username`
--

DROP TABLE IF EXISTS `special_username`;
/*!50001 DROP VIEW IF EXISTS `special_username`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `special_username` (
  `username` varchar(30),
  `first_name` varchar(30),
  `last_name` varchar(30)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `subtype_descendent_subtype`
--

DROP TABLE IF EXISTS `subtype_descendent_subtype`;
/*!50001 DROP VIEW IF EXISTS `subtype_descendent_subtype`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `subtype_descendent_subtype` (
  `parent_subtype_code` varchar(15),
  `child_subtype_code` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `suppressed_qualname`
--

DROP TABLE IF EXISTS `suppressed_qualname`;
/*!50001 DROP VIEW IF EXISTS `suppressed_qualname`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `suppressed_qualname` (
  `qualifier_id` bigint(12),
  `qualifier_name` varchar(50)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `toad_plan_table`
--

DROP TABLE IF EXISTS `toad_plan_table`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `toad_plan_table` (
  `statement_id` varchar(32) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `remarks` varchar(80) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `operation` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `options` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `object_node` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `object_owner` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `object_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `object_instance` decimal(22,0) DEFAULT NULL,
  `object_type` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `search_columns` decimal(22,0) DEFAULT NULL,
  `id` decimal(22,0) DEFAULT NULL,
  `cost` decimal(22,0) DEFAULT NULL,
  `parent_id` decimal(22,0) DEFAULT NULL,
  `position` decimal(22,0) DEFAULT NULL,
  `cardinality` decimal(22,0) DEFAULT NULL,
  `optimizer` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `bytes` decimal(22,0) DEFAULT NULL,
  `other_tag` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `partition_id` decimal(22,0) DEFAULT NULL,
  `partition_start` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `partition_stop` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `distribution` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `other` longtext CHARACTER SET latin1 COLLATE latin1_bin
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `user_sel_criteria2`
--

DROP TABLE IF EXISTS `user_sel_criteria2`;
/*!50001 DROP VIEW IF EXISTS `user_sel_criteria2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `user_sel_criteria2` (
  `selection_id` decimal(22,0),
  `criteria_id` decimal(22,0),
  `username` varchar(60),
  `apply` char(1),
  `value` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `user_selection_criteria2`
--

DROP TABLE IF EXISTS `user_selection_criteria2`;
/*!50001 DROP VIEW IF EXISTS `user_selection_criteria2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `user_selection_criteria2` (
  `selection_id` decimal(22,0),
  `criteria_id` decimal(22,0),
  `username` varchar(60),
  `apply` char(1),
  `value` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `user_selection_set2`
--

DROP TABLE IF EXISTS `user_selection_set2`;
/*!50001 DROP VIEW IF EXISTS `user_selection_set2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `user_selection_set2` (
  `selection_id` decimal(22,0),
  `apply_username` varchar(60),
  `default_flag` char(1),
  `hide_flag` char(1)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `viewable_category`
--

DROP TABLE IF EXISTS `viewable_category`;
/*!50001 DROP VIEW IF EXISTS `viewable_category`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `viewable_category` (
  `kerberos_name` varchar(8),
  `function_category` varchar(4),
  `function_category_desc` varchar(15)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `wh_cost_collector`
--

DROP TABLE IF EXISTS `wh_cost_collector`;
/*!50001 DROP VIEW IF EXISTS `wh_cost_collector`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `wh_cost_collector` (
  `cost_collector_id_with_type` varchar(8),
  `cost_collector_id` varchar(7),
  `cost_collector_type_desc` varchar(20),
  `cost_collector_name` varchar(40),
  `organization_id` varchar(6),
  `organization_name` varchar(40),
  `is_closed_cost_collector` varchar(1),
  `profit_center_id` varchar(7),
  `profit_center_name` varchar(40),
  `fund_id` varchar(7),
  `fund_center_id` varchar(6),
  `supervisor` varchar(30),
  `cost_collector_effective_date` datetime,
  `cost_collector_expiration_date` datetime,
  `term_code` varchar(1),
  `release_strategy` varchar(1),
  `supervisor_room` varchar(10),
  `addressee` varchar(30),
  `addressee_room` varchar(10),
  `supervisor_mit_id` varchar(9),
  `addressee_mit_id` varchar(9),
  `company_code` varchar(4),
  `admin_flag` varchar(2)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'rolesbb'
--
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_can_create_auth` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_can_create_auth`(AI_USER  VARCHAR(20),
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
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_can_create_function` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_can_create_function`(  a_user  varchar(20), a_category_code  VARCHAR(20)) RETURNS varchar(1) CHARSET latin1
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
 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_can_create_rule` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_can_create_rule`(AI_USER  VARCHAR(20),
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
 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_check_auth2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_check_auth2`(a_function  VARCHAR(255),
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_check_date_mmddyyyy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_check_date_mmddyyyy`(in_date VARCHAR(20)) RETURNS varchar(1) CHARSET latin1
begin
 
 DECLARE v_date DATE;
 DECLARE CONTINUE HANDLER FOR SQLEXCEPTION RETURN '0';

    SET v_date = str_to_date(in_date, "%m/%d/%Y");
   if SUBSTRING(in_date, 7, 4)  between '1980' and '2100' then
     return '1';
   else
     return '0';
   end if;	
 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_check_date_noslash` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_check_date_noslash`(in_date VARCHAR(20)) RETURNS varchar(1) CHARSET latin1
begin
 
 DECLARE v_date varchar(10);
 DECLARE EXIT HANDLER FOR SQLEXCEPTION RETURN '0';

   SET v_date = str_to_date(in_date, "%m%d%Y");
   if SUBSTRING(in_date, 5, 4)  between '1980' and '2100' then
     return '1';
   else
     return '0';
   end if;
      
     
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_check_number` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_check_number`(in_number VARCHAR(20)) RETURNS varchar(1) CHARSET latin1
begin
   DECLARE v_number INT;
   DECLARE EXIT HANDLER FOR SQLEXCEPTION RETURN '0';


   SET v_number = CAST(in_number AS UNSIGNED);
   return '1';
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_check_version` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_check_version`(a_version  VARCHAR(10),
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
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_convert_date_to_str` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_convert_date_to_str`(a_source_date DATE) RETURNS varchar(255) CHARSET latin1
begin
	DECLARE  v_target_date_format VARCHAR(255) DEFAULT '%m/%d/%Y %H:%i:%s';

   if a_source_date = null then /* if 8 spaces are used */
 	return null;
   end if;
   return date_format(a_source_date,v_target_date_format) ;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_convert_str_to_date` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_convert_str_to_date`(a_source_date VARCHAR(25)) RETURNS date
begin
	DECLARE  v_target_date_format VARCHAR(255) DEFAULT '%m%d%Y %H:%i:%s';

   if a_source_date = '        ' then 
 	return null;
   end if;
   return str_to_date(CONCAT(a_source_date , ' 00:00:00'), v_target_date_format) ;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_convert_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_convert_user`(a_user VARCHAR(30)) RETURNS varchar(16) CHARSET latin1
begin
 DECLARE v_username VARCHAR(16);
 SET v_username = UPPER(a_user);
 IF  SUBSTRING(v_username, 1, 4) = 'OPS$' THEN
     SET v_username = substring(v_username, 5);
 END IF;
   return v_username;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_edit_function` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_edit_function`(a_function_name  VARCHAR(255),
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_get_1st_token` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_get_1st_token`(a_list VARCHAR(1000)) RETURNS varchar(20) CHARSET latin1
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
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_get_correct_value` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_get_correct_value`(a_value VARCHAR(255)) RETURNS varchar(255) CHARSET latin1
begin
   if RTRIM(LOWER(a_value)) = '<me>' then
      return UC_USER_WITHOUT_HOST() ;
   else
      return a_value;
   end if;
 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_get_fragment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_get_fragment`(C_ID  INTEGER, C_VALUE  VARCHAR(255) 	) RETURNS varchar(255) CHARSET latin1
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
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_get_scrn_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_get_scrn_id`(a_selection_id INTEGER) RETURNS int(11)
begin
 DECLARE scrn_id integer DEFAULT 0;
	DECLARE EXIT HANDLER FOR NOT FOUND RETURN 0;

 
   select ss.screen_id into scrn_id from selection_set ss
 	where ss.selection_id = a_selection_id and ROWNUM < 2;
   return scrn_id;
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_is_auth_active` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_is_auth_active`(a_do_function VARCHAR(1),
                  a_effective_date date,
                  a_expiration_date date) RETURNS varchar(1) CHARSET latin1
begin
   if (a_do_function = 'Y') and (a_effective_date <= NOW())
       and (IFNULL(a_expiration_date,NOW()) >= NOW()) then
     return 'Y';
   else
     return 'N';
   end if;
 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_is_auth_current` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_is_auth_current`(a_effective_date  date,
                  a_expiration_date  date) RETURNS char(1) CHARSET latin1
begin
   if (a_effective_date <= NOW())
       and (IFNULL(a_expiration_date,NOW()) >= NOW()) then
     return 'Y';
   else
     return 'N';
   end if;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_qual_subtype` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_qual_subtype`(a_qual_type  VARCHAR(30),
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
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_remove_token` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_remove_token`(a_token  VARCHAR(10),
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
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `auth_sf_user_priv_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `auth_sf_user_priv_list`(ai_user VARCHAR(20)) RETURNS varchar(255) CHARSET latin1
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
 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `initcap` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `initcap`(str varchar(255)) RETURNS varchar(255) CHARSET latin1
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
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `next_sequence_val`(seq_name char(255) ) RETURNS bigint(20) unsigned
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
/*!50003 DROP FUNCTION IF EXISTS `rolesapi_is_user_authorized` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `rolesapi_is_user_authorized`(ai_kerberos_name varchar(20),ai_function_name varchar(255),ai_qualifier_code varchar(30)) RETURNS varchar(1) CHARSET latin1
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

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `roles_msg` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `roles_msg`(err_number INTEGER) RETURNS varchar(255) CHARSET latin1
begin

DECLARE a_msg VARCHAR(255) DEFAULT '';
DECLARE EXIT HANDLER FOR NOT FOUND
 RETURN 'Unknown error code';
 
SELECT err_msg INTO a_msg FROM roles_error_msg WHERE err_no = error_number;

RETURN a_msg;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `uc_user_without_host` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `uc_user_without_host`() RETURNS varchar(50) CHARSET latin1
begin

DECLARE a_user VARCHAR(100) DEFAULT '';
DECLARE idx INTEGER DEFAULT 0;

SET a_user = UPPER(USER());

SET  idx = LOCATE('@',a_user);

IF (idx != 0) THEN
  SET a_user = SUBSTRING(a_user,1,idx-1);
END IF;

RETURN a_user;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `uppercase` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 FUNCTION `uppercase`(str varchar(255)) RETURNS varchar(255) CHARSET latin1
BEGIN
  return concat(upper(left(str,1)),lower(right(str,length(str)-1)));
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_ancestors_qc` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_ancestors_qc`(  IN a_qual_id  VARCHAR(100),  IN a_list     VARCHAR(500), OUT v_out_list VARCHAR(1000))
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

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_ancestors_qd` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_ancestors_qd`(  IN a_qual_id  VARCHAR(100), OUT v_out_list VARCHAR(1000))
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

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_check_version` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_check_version`(IN a_version  VARCHAR(20),
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_copy_authorizations` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_copy_authorizations`(IN ai_category VARCHAR(30),
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
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_create_auth2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_create_auth2`(IN  AI_FUNCTION_NAME VARCHAR(60),
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
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_create_authorizations` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_create_authorizations`(IN AI_FUNCTION_NAME VARCHAR(50),
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

 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_create_function` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_create_function`(IN ai_function_name  VARCHAR(255),
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
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_delete_authorizations` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_delete_authorizations`( IN a_auth_id INTEGER)
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
  end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_delete_function` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_delete_function`(a_function_id INTEGER)
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
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_delete_qual` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_delete_qual`(IN ai_qualtype     VARCHAR(20),
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
 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_delete_sql_lines` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_delete_sql_lines`()
begin
   
   
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_duplicate_sys_criteria` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_duplicate_sys_criteria`()
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
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_fix_qd_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_fix_qd_add`(IN a_qual_id VARCHAR(30))
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
   
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_fix_qd_for_1_qual` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_fix_qd_for_1_qual`(IN a_qual_id VARCHAR(10))
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
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_fix_qd_for_many_qual` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_fix_qd_for_many_qual`(IN a_qual_id  VARCHAR(20))
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
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_insert_qual` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_insert_qual`(IN  ai_qualtype     VARCHAR(30),
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

 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_update_authorizations` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_update_authorizations`(IN AI_AUTHORIZATION_ID INTEGER,
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
 
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_update_auth_dates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_update_auth_dates`(IN ai_category  VARCHAR(14),
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
  end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_update_criteria` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_update_criteria`(IN a_selection_id INTEGER,
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
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_update_def_sel_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_update_def_sel_id`(IN a_cur_selection_id  INTEGER,
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
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_update_function` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_update_function`(IN ai_orig_function_name VARCHAR(50),
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

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_update_qualcode` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_update_qualcode`(IN ai_qualtype     VARCHAR(30),
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
 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_update_qualname` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_update_qualname`(IN ai_qualtype     VARCHAR(30),
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
 
 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_update_qualpar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_update_qualpar`(IN ai_qualtype     VARCHAR(30),
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auth_sp_update_test` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `auth_sp_update_test`(IN AI_AUTHORIZATION_ID VARCHAR(20),
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

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_fund_centers_rel_str` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `delete_fund_centers_rel_str`(
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

 
 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Insert_Fund_Centers_Rel_Str` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `Insert_Fund_Centers_Rel_Str`(
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


 END */;;
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
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `permit_signal`(error_text VARCHAR(255), error_code INTEGER)
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
/*!50003 DROP PROCEDURE IF EXISTS `rolesapi_batch_create_auth` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `rolesapi_batch_create_auth`(IN AI_SERVER_USER  VARCHAR(20),
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

 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rolesapi_batch_update_auth` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `rolesapi_batch_update_auth`(IN AI_SERVER_USER  VARCHAR(20),
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
 
  
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rolesapi_create_auth` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `rolesapi_create_auth`(IN AI_SERVER_USER  VARCHAR(20),
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

 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rolesapi_create_imprule` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `rolesapi_create_imprule`( IN AI_FOR_USER VARCHAR(20),
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
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rolesapi_delete_auth` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `rolesapi_delete_auth`(IN AI_SERVER_USER  VARCHAR(20),
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
 
 end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rolesapi_delete_imprule` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `rolesapi_delete_imprule`( IN AI_FOR_USER VARCHAR(20),
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
 

 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rolesapi_update_auth1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `rolesapi_update_auth1`(IN AI_SERVER_USER VARCHAR(20),
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rolesapi_update_imprule` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `rolesapi_update_imprule`( IN AI_FOR_USER  VARCHAR(20),
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
/*!50003 DROP PROCEDURE IF EXISTS `update_parameter_value` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `update_parameter_value`(
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
    

 
 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_roles_parameters_all` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`rolesbb`@`%`*/ /*!50003 PROCEDURE `update_roles_parameters_all`(
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
 
  
 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `access_to_qualname`
--

/*!50001 DROP TABLE `access_to_qualname`*/;
/*!50001 DROP VIEW IF EXISTS `access_to_qualname`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_to_qualname` AS select `rdb_t_access_to_qualname`.`kerberos_name` AS `kerberos_name`,`rdb_t_access_to_qualname`.`qualifier_type` AS `qualifier_type` from `rdb_t_access_to_qualname` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `application_version`
--

/*!50001 DROP TABLE `application_version`*/;
/*!50001 DROP VIEW IF EXISTS `application_version`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `application_version` AS select `rdb_t_application_version`.`from_platform` AS `from_platform`,`rdb_t_application_version`.`to_platform` AS `to_platform`,`rdb_t_application_version`.`from_version` AS `from_version`,`rdb_t_application_version`.`to_version` AS `to_version`,`rdb_t_application_version`.`message_type` AS `message_type`,`rdb_t_application_version`.`message_text` AS `message_text` from `rdb_t_application_version` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `auth_audit`
--

/*!50001 DROP TABLE `auth_audit`*/;
/*!50001 DROP VIEW IF EXISTS `auth_audit`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `auth_audit` AS select `rdb_t_auth_audit`.`auth_audit_id` AS `auth_audit_id`,`rdb_t_auth_audit`.`roles_username` AS `roles_username`,`rdb_t_auth_audit`.`action_date` AS `action_date`,`rdb_t_auth_audit`.`action_type` AS `action_type`,`rdb_t_auth_audit`.`old_new` AS `old_new`,`rdb_t_auth_audit`.`authorization_id` AS `authorization_id`,`rdb_t_auth_audit`.`function_id` AS `function_id`,`rdb_t_auth_audit`.`qualifier_id` AS `qualifier_id`,`rdb_t_auth_audit`.`kerberos_name` AS `kerberos_name`,`rdb_t_auth_audit`.`qualifier_code` AS `qualifier_code`,`rdb_t_auth_audit`.`function_name` AS `function_name`,`rdb_t_auth_audit`.`function_category` AS `function_category`,`rdb_t_auth_audit`.`modified_by` AS `modified_by`,`rdb_t_auth_audit`.`modified_date` AS `modified_date`,`rdb_t_auth_audit`.`do_function` AS `do_function`,`rdb_t_auth_audit`.`grant_and_view` AS `grant_and_view`,`rdb_t_auth_audit`.`descend` AS `descend`,`rdb_t_auth_audit`.`effective_date` AS `effective_date`,`rdb_t_auth_audit`.`expiration_date` AS `expiration_date`,`rdb_t_auth_audit`.`server_username` AS `server_username` from `rdb_t_auth_audit` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `auth_in_qualbranch`
--

/*!50001 DROP TABLE `auth_in_qualbranch`*/;
/*!50001 DROP VIEW IF EXISTS `auth_in_qualbranch`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `auth_in_qualbranch` AS select `rdb_v_auth_in_qualbranch`.`AUTHORIZATION_ID` AS `AUTHORIZATION_ID`,`rdb_v_auth_in_qualbranch`.`FUNCTION_ID` AS `FUNCTION_ID`,`rdb_v_auth_in_qualbranch`.`QUALIFIER_ID` AS `QUALIFIER_ID`,`rdb_v_auth_in_qualbranch`.`KERBEROS_NAME` AS `KERBEROS_NAME`,`rdb_v_auth_in_qualbranch`.`QUALIFIER_CODE` AS `QUALIFIER_CODE`,`rdb_v_auth_in_qualbranch`.`FUNCTION_NAME` AS `FUNCTION_NAME`,`rdb_v_auth_in_qualbranch`.`FUNCTION_CATEGORY` AS `FUNCTION_CATEGORY`,`rdb_v_auth_in_qualbranch`.`QUALIFIER_NAME` AS `QUALIFIER_NAME`,`rdb_v_auth_in_qualbranch`.`MODIFIED_BY` AS `MODIFIED_BY`,`rdb_v_auth_in_qualbranch`.`MODIFIED_DATE` AS `MODIFIED_DATE`,`rdb_v_auth_in_qualbranch`.`DO_FUNCTION` AS `DO_FUNCTION`,`rdb_v_auth_in_qualbranch`.`GRANT_AND_VIEW` AS `GRANT_AND_VIEW`,`rdb_v_auth_in_qualbranch`.`DESCEND` AS `DESCEND`,`rdb_v_auth_in_qualbranch`.`EFFECTIVE_DATE` AS `EFFECTIVE_DATE`,`rdb_v_auth_in_qualbranch`.`EXPIRATION_DATE` AS `EXPIRATION_DATE`,`rdb_v_auth_in_qualbranch`.`dept_qual_code` AS `dept_qual_code`,`rdb_v_auth_in_qualbranch`.`QUALIFIER_TYPE` AS `QUALIFIER_TYPE` from `rdb_v_auth_in_qualbranch` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `auth_rule_type`
--

/*!50001 DROP TABLE `auth_rule_type`*/;
/*!50001 DROP VIEW IF EXISTS `auth_rule_type`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `auth_rule_type` AS select `rdb_t_auth_rule_type`.`rule_type_code` AS `rule_type_code`,`rdb_t_auth_rule_type`.`rule_type_short_name` AS `rule_type_short_name`,`rdb_t_auth_rule_type`.`rule_type_description` AS `rule_type_description` from `rdb_t_auth_rule_type` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `authorizable_function`
--

/*!50001 DROP TABLE `authorizable_function`*/;
/*!50001 DROP VIEW IF EXISTS `authorizable_function`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `authorizable_function` AS select `rdb_v_authorizable_function`.`FUNCTION_ID` AS `FUNCTION_ID` from `rdb_v_authorizable_function` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `authorization`
--

/*!50001 DROP TABLE `authorization`*/;
/*!50001 DROP VIEW IF EXISTS `authorization`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `authorization` AS select `rdb_t_authorization`.`authorization_id` AS `authorization_id`,`rdb_t_authorization`.`function_id` AS `function_id`,`rdb_t_authorization`.`qualifier_id` AS `qualifier_id`,`rdb_t_authorization`.`kerberos_name` AS `kerberos_name`,`rdb_t_authorization`.`qualifier_code` AS `qualifier_code`,`rdb_t_authorization`.`function_name` AS `function_name`,`rdb_t_authorization`.`function_category` AS `function_category`,`rdb_t_authorization`.`qualifier_name` AS `qualifier_name`,`rdb_t_authorization`.`modified_by` AS `modified_by`,`rdb_t_authorization`.`modified_date` AS `modified_date`,`rdb_t_authorization`.`do_function` AS `do_function`,`rdb_t_authorization`.`grant_and_view` AS `grant_and_view`,`rdb_t_authorization`.`descend` AS `descend`,`rdb_t_authorization`.`effective_date` AS `effective_date`,`rdb_t_authorization`.`expiration_date` AS `expiration_date` from `rdb_t_authorization` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `authorization2`
--

/*!50001 DROP TABLE `authorization2`*/;
/*!50001 DROP VIEW IF EXISTS `authorization2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `authorization2` AS select `rdb_v_authorization2`.`AUTHORIZATION_ID` AS `AUTHORIZATION_ID`,`rdb_v_authorization2`.`FUNCTION_ID` AS `FUNCTION_ID`,`rdb_v_authorization2`.`QUALIFIER_ID` AS `QUALIFIER_ID`,`rdb_v_authorization2`.`KERBEROS_NAME` AS `KERBEROS_NAME`,`rdb_v_authorization2`.`QUALIFIER_CODE` AS `QUALIFIER_CODE`,`rdb_v_authorization2`.`FUNCTION_NAME` AS `FUNCTION_NAME`,`rdb_v_authorization2`.`FUNCTION_CATEGORY` AS `FUNCTION_CATEGORY`,`rdb_v_authorization2`.`QUALIFIER_NAME` AS `QUALIFIER_NAME`,`rdb_v_authorization2`.`MODIFIED_BY` AS `MODIFIED_BY`,`rdb_v_authorization2`.`MODIFIED_DATE` AS `MODIFIED_DATE`,`rdb_v_authorization2`.`DO_FUNCTION` AS `DO_FUNCTION`,`rdb_v_authorization2`.`GRANT_AND_VIEW` AS `GRANT_AND_VIEW`,`rdb_v_authorization2`.`DESCEND` AS `DESCEND`,`rdb_v_authorization2`.`EFFECTIVE_DATE` AS `EFFECTIVE_DATE`,`rdb_v_authorization2`.`EXPIRATION_DATE` AS `EXPIRATION_DATE`,`rdb_v_authorization2`.`AUTH_TYPE` AS `AUTH_TYPE` from `rdb_v_authorization2` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `category`
--

/*!50001 DROP TABLE `category`*/;
/*!50001 DROP VIEW IF EXISTS `category`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `category` AS select `rdb_t_category`.`function_category` AS `function_category`,`rdb_t_category`.`function_category_desc` AS `function_category_desc`,`rdb_t_category`.`auths_are_sensitive` AS `auths_are_sensitive` from `rdb_t_category` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `connect_log`
--

/*!50001 DROP TABLE `connect_log`*/;
/*!50001 DROP VIEW IF EXISTS `connect_log`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `connect_log` AS select `rdb_t_connect_log`.`roles_username` AS `roles_username`,`rdb_t_connect_log`.`connect_date` AS `connect_date`,`rdb_t_connect_log`.`client_version` AS `client_version`,`rdb_t_connect_log`.`client_platform` AS `client_platform`,`rdb_t_connect_log`.`last_name` AS `last_name`,`rdb_t_connect_log`.`first_name` AS `first_name`,`rdb_t_connect_log`.`mit_id` AS `mit_id` from `rdb_t_connect_log` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `criteria`
--

/*!50001 DROP TABLE `criteria`*/;
/*!50001 DROP VIEW IF EXISTS `criteria`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `criteria` AS select `rdb_t_criteria`.`criteria_id` AS `criteria_id`,`rdb_t_criteria`.`criteria_name` AS `criteria_name`,`rdb_t_criteria`.`sql_fragment` AS `sql_fragment` from `rdb_t_criteria` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `criteria2`
--

/*!50001 DROP TABLE `criteria2`*/;
/*!50001 DROP VIEW IF EXISTS `criteria2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `criteria2` AS select `rdb_t_criteria2`.`criteria_id` AS `criteria_id`,`rdb_t_criteria2`.`criteria_name` AS `criteria_name`,`rdb_t_criteria2`.`sql_fragment` AS `sql_fragment` from `rdb_t_criteria2` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `criteria_instance`
--

/*!50001 DROP TABLE `criteria_instance`*/;
/*!50001 DROP VIEW IF EXISTS `criteria_instance`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `criteria_instance` AS select `rdb_t_criteria_instance`.`selection_id` AS `selection_id`,`rdb_t_criteria_instance`.`criteria_id` AS `criteria_id`,`rdb_t_criteria_instance`.`username` AS `username`,`rdb_t_criteria_instance`.`apply` AS `apply`,`rdb_t_criteria_instance`.`value` AS `value`,`rdb_t_criteria_instance`.`next_scrn_selection_id` AS `next_scrn_selection_id`,`rdb_t_criteria_instance`.`no_change` AS `no_change`,`rdb_t_criteria_instance`.`sequence` AS `sequence` from `rdb_t_criteria_instance` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `dept_approver_function`
--

/*!50001 DROP TABLE `dept_approver_function`*/;
/*!50001 DROP VIEW IF EXISTS `dept_approver_function`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `dept_approver_function` AS select `rdb_t_dept_approver_function`.`dept_code` AS `dept_code`,`rdb_t_dept_approver_function`.`function_id` AS `function_id` from `rdb_t_dept_approver_function` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `dept_people`
--

/*!50001 DROP TABLE `dept_people`*/;
/*!50001 DROP VIEW IF EXISTS `dept_people`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `dept_people` AS select `rdb_v_dept_people`.`kerberos_name` AS `kerberos_name`,`rdb_v_dept_people`.`over_dept_code` AS `over_dept_code` from `rdb_v_dept_people` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `dept_sap_auth`
--

/*!50001 DROP TABLE `dept_sap_auth`*/;
/*!50001 DROP VIEW IF EXISTS `dept_sap_auth`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `dept_sap_auth` AS select `rdb_v_dept_sap_auth`.`kerberos_name` AS `kerberos_name`,`rdb_v_dept_sap_auth`.`function_id` AS `function_id`,`rdb_v_dept_sap_auth`.`function_name` AS `function_name`,`rdb_v_dept_sap_auth`.`qualifier_id` AS `qualifier_id`,`rdb_v_dept_sap_auth`.`qualifier_code` AS `qualifier_code`,`rdb_v_dept_sap_auth`.`descend` AS `descend`,`rdb_v_dept_sap_auth`.`grant_and_view` AS `grant_and_view`,`rdb_v_dept_sap_auth`.`expiration_date` AS `expiration_date`,`rdb_v_dept_sap_auth`.`effective_date` AS `effective_date`,`rdb_v_dept_sap_auth`.`dept_fc_code` AS `dept_fc_code` from `rdb_v_dept_sap_auth` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `dept_sap_auth2`
--

/*!50001 DROP TABLE `dept_sap_auth2`*/;
/*!50001 DROP VIEW IF EXISTS `dept_sap_auth2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `dept_sap_auth2` AS select `rdb_v_dept_sap_auth2`.`kerberos_name` AS `kerberos_name`,`rdb_v_dept_sap_auth2`.`function_id` AS `function_id`,`rdb_v_dept_sap_auth2`.`function_name` AS `function_name`,`rdb_v_dept_sap_auth2`.`qualifier_id` AS `qualifier_id`,`rdb_v_dept_sap_auth2`.`qualifier_code` AS `qualifier_code`,`rdb_v_dept_sap_auth2`.`descend` AS `descend`,`rdb_v_dept_sap_auth2`.`grant_and_view` AS `grant_and_view`,`rdb_v_dept_sap_auth2`.`expiration_date` AS `expiration_date`,`rdb_v_dept_sap_auth2`.`effective_date` AS `effective_date`,`rdb_v_dept_sap_auth2`.`dept_sg_code` AS `dept_sg_code` from `rdb_v_dept_sap_auth2` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_kluge`
--

/*!50001 DROP TABLE `error_kluge`*/;
/*!50001 DROP VIEW IF EXISTS `error_kluge`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_kluge` AS select `rdb_t_error_kluge`.`qualifier_id` AS `qualifier_id`,`rdb_t_error_kluge`.`qualifier_code` AS `qualifier_code`,`rdb_t_error_kluge`.`qualifier_name` AS `qualifier_name`,`rdb_t_error_kluge`.`qualifier_type` AS `qualifier_type`,`rdb_t_error_kluge`.`has_child` AS `has_child`,`rdb_t_error_kluge`.`qualifier_level` AS `qualifier_level` from `rdb_t_error_kluge` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `exp_auth_func_qual_lim_dept`
--

/*!50001 DROP TABLE `exp_auth_func_qual_lim_dept`*/;
/*!50001 DROP VIEW IF EXISTS `exp_auth_func_qual_lim_dept`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `exp_auth_func_qual_lim_dept` AS select `rdb_v_exp_auth_f_q_lim_dept`.`AUTHORIZATION_ID` AS `AUTHORIZATION_ID`,`rdb_v_exp_auth_f_q_lim_dept`.`FUNCTION_ID` AS `FUNCTION_ID`,`rdb_v_exp_auth_f_q_lim_dept`.`QUALIFIER_ID` AS `QUALIFIER_ID`,`rdb_v_exp_auth_f_q_lim_dept`.`KERBEROS_NAME` AS `KERBEROS_NAME`,`rdb_v_exp_auth_f_q_lim_dept`.`QUALIFIER_CODE` AS `QUALIFIER_CODE`,`rdb_v_exp_auth_f_q_lim_dept`.`FUNCTION_NAME` AS `FUNCTION_NAME`,`rdb_v_exp_auth_f_q_lim_dept`.`FUNCTION_CATEGORY` AS `FUNCTION_CATEGORY`,`rdb_v_exp_auth_f_q_lim_dept`.`QUALIFIER_NAME` AS `QUALIFIER_NAME`,`rdb_v_exp_auth_f_q_lim_dept`.`MODIFIED_BY` AS `MODIFIED_BY`,`rdb_v_exp_auth_f_q_lim_dept`.`MODIFIED_DATE` AS `MODIFIED_DATE`,`rdb_v_exp_auth_f_q_lim_dept`.`DO_FUNCTION` AS `DO_FUNCTION`,`rdb_v_exp_auth_f_q_lim_dept`.`GRANT_AND_VIEW` AS `GRANT_AND_VIEW`,`rdb_v_exp_auth_f_q_lim_dept`.`DESCEND` AS `DESCEND`,`rdb_v_exp_auth_f_q_lim_dept`.`EFFECTIVE_DATE` AS `EFFECTIVE_DATE`,`rdb_v_exp_auth_f_q_lim_dept`.`EXPIRATION_DATE` AS `EXPIRATION_DATE`,`rdb_v_exp_auth_f_q_lim_dept`.`parent_auth_id` AS `parent_auth_id`,`rdb_v_exp_auth_f_q_lim_dept`.`parent_func_id` AS `parent_func_id`,`rdb_v_exp_auth_f_q_lim_dept`.`parent_qual_id` AS `parent_qual_id`,`rdb_v_exp_auth_f_q_lim_dept`.`parent_qual_code` AS `parent_qual_code`,`rdb_v_exp_auth_f_q_lim_dept`.`parent_function_name` AS `parent_function_name`,`rdb_v_exp_auth_f_q_lim_dept`.`parent_qual_name` AS `parent_qual_name` from `rdb_v_exp_auth_f_q_lim_dept` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `expanded_auth2`
--

/*!50001 DROP TABLE `expanded_auth2`*/;
/*!50001 DROP VIEW IF EXISTS `expanded_auth2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `expanded_auth2` AS select `rdb_v_expanded_auth2`.`authorization_id` AS `authorization_id`,`rdb_v_expanded_auth2`.`function_id` AS `function_id`,`rdb_v_expanded_auth2`.`qualifier_id` AS `qualifier_id`,`rdb_v_expanded_auth2`.`kerberos_name` AS `kerberos_name`,`rdb_v_expanded_auth2`.`qualifier_code` AS `qualifier_code`,`rdb_v_expanded_auth2`.`function_name` AS `function_name`,`rdb_v_expanded_auth2`.`function_category` AS `function_category`,`rdb_v_expanded_auth2`.`qualifier_name` AS `qualifier_name`,`rdb_v_expanded_auth2`.`modified_by` AS `modified_by`,`rdb_v_expanded_auth2`.`modified_date` AS `modified_date`,`rdb_v_expanded_auth2`.`do_function` AS `do_function`,`rdb_v_expanded_auth2`.`grant_and_view` AS `grant_and_view`,`rdb_v_expanded_auth2`.`descend` AS `descend`,`rdb_v_expanded_auth2`.`effective_date` AS `effective_date`,`rdb_v_expanded_auth2`.`expiration_date` AS `expiration_date`,`rdb_v_expanded_auth2`.`qualifier_type` AS `qualifier_type`,`rdb_v_expanded_auth2`.`virtual_or_real` AS `virtual_or_real` from `rdb_v_expanded_auth2` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `expanded_auth_func_qual`
--

/*!50001 DROP TABLE `expanded_auth_func_qual`*/;
/*!50001 DROP VIEW IF EXISTS `expanded_auth_func_qual`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `expanded_auth_func_qual` AS select `rdb_v_expanded_auth_func_qual`.`AUTHORIZATION_ID` AS `AUTHORIZATION_ID`,`rdb_v_expanded_auth_func_qual`.`FUNCTION_ID` AS `FUNCTION_ID`,`rdb_v_expanded_auth_func_qual`.`QUALIFIER_ID` AS `QUALIFIER_ID`,`rdb_v_expanded_auth_func_qual`.`KERBEROS_NAME` AS `KERBEROS_NAME`,`rdb_v_expanded_auth_func_qual`.`QUALIFIER_CODE` AS `QUALIFIER_CODE`,`rdb_v_expanded_auth_func_qual`.`FUNCTION_NAME` AS `FUNCTION_NAME`,`rdb_v_expanded_auth_func_qual`.`FUNCTION_CATEGORY` AS `FUNCTION_CATEGORY`,`rdb_v_expanded_auth_func_qual`.`QUALIFIER_NAME` AS `QUALIFIER_NAME`,`rdb_v_expanded_auth_func_qual`.`QUALIFIER_TYPE` AS `QUALIFIER_TYPE`,`rdb_v_expanded_auth_func_qual`.`MODIFIED_BY` AS `MODIFIED_BY`,`rdb_v_expanded_auth_func_qual`.`MODIFIED_DATE` AS `MODIFIED_DATE`,`rdb_v_expanded_auth_func_qual`.`DO_FUNCTION` AS `DO_FUNCTION`,`rdb_v_expanded_auth_func_qual`.`GRANT_AND_VIEW` AS `GRANT_AND_VIEW`,`rdb_v_expanded_auth_func_qual`.`DESCEND` AS `DESCEND`,`rdb_v_expanded_auth_func_qual`.`EFFECTIVE_DATE` AS `EFFECTIVE_DATE`,`rdb_v_expanded_auth_func_qual`.`EXPIRATION_DATE` AS `EXPIRATION_DATE`,`rdb_v_expanded_auth_func_qual`.`parent_auth_id` AS `parent_auth_id`,`rdb_v_expanded_auth_func_qual`.`parent_func_id` AS `parent_func_id`,`rdb_v_expanded_auth_func_qual`.`parent_qual_id` AS `parent_qual_id`,`rdb_v_expanded_auth_func_qual`.`parent_qual_code` AS `parent_qual_code`,`rdb_v_expanded_auth_func_qual`.`parent_function_name` AS `parent_function_name`,`rdb_v_expanded_auth_func_qual`.`parent_qual_name` AS `parent_qual_name`,`rdb_v_expanded_auth_func_qual`.`is_in_effect` AS `is_in_effect` from `rdb_v_expanded_auth_func_qual` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `expanded_auth_no_root`
--

/*!50001 DROP TABLE `expanded_auth_no_root`*/;
/*!50001 DROP VIEW IF EXISTS `expanded_auth_no_root`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `expanded_auth_no_root` AS select `rdb_v_expanded_auth_no_root`.`kerberos_name` AS `kerberos_name`,`rdb_v_expanded_auth_no_root`.`function_id` AS `function_id`,`rdb_v_expanded_auth_no_root`.`function_name` AS `function_name`,`rdb_v_expanded_auth_no_root`.`qualifier_code` AS `qualifier_code` from `rdb_v_expanded_auth_no_root` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `expanded_authorization`
--

/*!50001 DROP TABLE `expanded_authorization`*/;
/*!50001 DROP VIEW IF EXISTS `expanded_authorization`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `expanded_authorization` AS select `rdb_v_expanded_authorization`.`kerberos_name` AS `kerberos_name`,`rdb_v_expanded_authorization`.`function_id` AS `function_id`,`rdb_v_expanded_authorization`.`function_name` AS `function_name`,`rdb_v_expanded_authorization`.`qualifier_code` AS `qualifier_code` from `rdb_v_expanded_authorization` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `external_auth`
--

/*!50001 DROP TABLE `external_auth`*/;
/*!50001 DROP VIEW IF EXISTS `external_auth`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `external_auth` AS select `rdb_t_external_auth`.`authorization_id` AS `authorization_id`,`rdb_t_external_auth`.`function_id` AS `function_id`,`rdb_t_external_auth`.`qualifier_id` AS `qualifier_id`,`rdb_t_external_auth`.`kerberos_name` AS `kerberos_name`,`rdb_t_external_auth`.`qualifier_code` AS `qualifier_code`,`rdb_t_external_auth`.`function_name` AS `function_name`,`rdb_t_external_auth`.`function_category` AS `function_category`,`rdb_t_external_auth`.`qualifier_name` AS `qualifier_name`,`rdb_t_external_auth`.`modified_by` AS `modified_by`,`rdb_t_external_auth`.`modified_date` AS `modified_date`,`rdb_t_external_auth`.`do_function` AS `do_function`,`rdb_t_external_auth`.`grant_and_view` AS `grant_and_view`,`rdb_t_external_auth`.`descend` AS `descend`,`rdb_t_external_auth`.`effective_date` AS `effective_date`,`rdb_t_external_auth`.`expiration_date` AS `expiration_date` from `rdb_t_external_auth` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `external_function`
--

/*!50001 DROP TABLE `external_function`*/;
/*!50001 DROP VIEW IF EXISTS `external_function`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `external_function` AS select `rdb_t_external_function`.`function_id` AS `function_id`,`rdb_t_external_function`.`function_name` AS `function_name`,`rdb_t_external_function`.`function_description` AS `function_description`,`rdb_t_external_function`.`function_category` AS `function_category`,`rdb_t_external_function`.`creator` AS `creator`,`rdb_t_external_function`.`modified_by` AS `modified_by`,`rdb_t_external_function`.`modified_date` AS `modified_date`,`rdb_t_external_function`.`qualifier_type` AS `qualifier_type`,`rdb_t_external_function`.`primary_authorizable` AS `primary_authorizable` from `rdb_t_external_function` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `extract_auth`
--

/*!50001 DROP TABLE `extract_auth`*/;
/*!50001 DROP VIEW IF EXISTS `extract_auth`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `extract_auth` AS select `rdb_v_extract_auth`.`KERBEROS_NAME` AS `KERBEROS_NAME`,`rdb_v_extract_auth`.`FUNCTION_NAME` AS `FUNCTION_NAME`,`rdb_v_extract_auth`.`QUALIFIER_CODE` AS `QUALIFIER_CODE`,`rdb_v_extract_auth`.`FUNCTION_CATEGORY` AS `FUNCTION_CATEGORY`,`rdb_v_extract_auth`.`DESCEND` AS `DESCEND`,`rdb_v_extract_auth`.`EFFECTIVE_DATE` AS `EFFECTIVE_DATE`,`rdb_v_extract_auth`.`EXPIRATION_DATE` AS `EXPIRATION_DATE` from `rdb_v_extract_auth` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `extract_category`
--

/*!50001 DROP TABLE `extract_category`*/;
/*!50001 DROP VIEW IF EXISTS `extract_category`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `extract_category` AS select `rdb_t_extract_category`.`username` AS `username`,`rdb_t_extract_category`.`function_category` AS `function_category` from `rdb_t_extract_category` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `extract_desc`
--

/*!50001 DROP TABLE `extract_desc`*/;
/*!50001 DROP VIEW IF EXISTS `extract_desc`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `extract_desc` AS select `rdb_v_extract_desc`.`PARENT_CODE` AS `PARENT_CODE`,`rdb_v_extract_desc`.`CHILD_CODE` AS `CHILD_CODE` from `rdb_v_extract_desc` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `function`
--

/*!50001 DROP TABLE `function`*/;
/*!50001 DROP VIEW IF EXISTS `function`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `function` AS select `rdb_t_function`.`function_id` AS `function_id`,`rdb_t_function`.`function_name` AS `function_name`,`rdb_t_function`.`function_description` AS `function_description`,`rdb_t_function`.`function_category` AS `function_category`,`rdb_t_function`.`creator` AS `creator`,`rdb_t_function`.`modified_by` AS `modified_by`,`rdb_t_function`.`modified_date` AS `modified_date`,`rdb_t_function`.`qualifier_type` AS `qualifier_type`,`rdb_t_function`.`primary_authorizable` AS `primary_authorizable`,`rdb_t_function`.`is_primary_auth_parent` AS `is_primary_auth_parent`,`rdb_t_function`.`primary_auth_group` AS `primary_auth_group` from `rdb_t_function` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `function2`
--

/*!50001 DROP TABLE `function2`*/;
/*!50001 DROP VIEW IF EXISTS `function2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `function2` AS select `rdb_v_function2`.`function_id` AS `function_id`,`rdb_v_function2`.`function_name` AS `function_name`,`rdb_v_function2`.`function_description` AS `function_description`,`rdb_v_function2`.`function_category` AS `function_category`,`rdb_v_function2`.`modified_by` AS `modified_by`,`rdb_v_function2`.`modified_date` AS `modified_date`,`rdb_v_function2`.`qualifier_type` AS `qualifier_type`,`rdb_v_function2`.`primary_authorizable` AS `primary_authorizable`,`rdb_v_function2`.`is_primary_auth_parent` AS `is_primary_auth_parent`,`rdb_v_function2`.`primary_auth_group` AS `primary_auth_group`,`rdb_v_function2`.`real_or_external` AS `real_or_external` from `rdb_v_function2` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `function_child`
--

/*!50001 DROP TABLE `function_child`*/;
/*!50001 DROP VIEW IF EXISTS `function_child`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `function_child` AS select `rdb_t_function_child`.`parent_id` AS `parent_id`,`rdb_t_function_child`.`child_id` AS `child_id` from `rdb_t_function_child` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `function_group`
--

/*!50001 DROP TABLE `function_group`*/;
/*!50001 DROP VIEW IF EXISTS `function_group`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `function_group` AS select `rdb_t_function_group`.`function_group_id` AS `function_group_id`,`rdb_t_function_group`.`function_group_name` AS `function_group_name`,`rdb_t_function_group`.`function_group_desc` AS `function_group_desc`,`rdb_t_function_group`.`function_category` AS `function_category`,`rdb_t_function_group`.`matches_a_function` AS `matches_a_function`,`rdb_t_function_group`.`qualifier_type` AS `qualifier_type`,`rdb_t_function_group`.`modified_by` AS `modified_by`,`rdb_t_function_group`.`modified_date` AS `modified_date` from `rdb_t_function_group` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `function_group_link`
--

/*!50001 DROP TABLE `function_group_link`*/;
/*!50001 DROP VIEW IF EXISTS `function_group_link`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `function_group_link` AS select `rdb_t_function_group_link`.`parent_id` AS `parent_id`,`rdb_t_function_group_link`.`child_id` AS `child_id` from `rdb_t_function_group_link` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `function_load_pass`
--

/*!50001 DROP TABLE `function_load_pass`*/;
/*!50001 DROP VIEW IF EXISTS `function_load_pass`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `function_load_pass` AS select `rdb_t_function_load_pass`.`function_id` AS `function_id`,`rdb_t_function_load_pass`.`pass_number` AS `pass_number` from `rdb_t_function_load_pass` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `funds_cntr_release_str`
--

/*!50001 DROP TABLE `funds_cntr_release_str`*/;
/*!50001 DROP VIEW IF EXISTS `funds_cntr_release_str`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `funds_cntr_release_str` AS select `rdb_t_funds_cntr_release_str`.`fund_center_id` AS `fund_center_id`,`rdb_t_funds_cntr_release_str`.`release_strategy` AS `release_strategy`,`rdb_t_funds_cntr_release_str`.`modified_by` AS `modified_by`,`rdb_t_funds_cntr_release_str`.`modified_date` AS `modified_date` from `rdb_t_funds_cntr_release_str` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `hide_default`
--

/*!50001 DROP TABLE `hide_default`*/;
/*!50001 DROP VIEW IF EXISTS `hide_default`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `hide_default` AS select `rdb_t_hide_default`.`selection_id` AS `selection_id`,`rdb_t_hide_default`.`apply_username` AS `apply_username`,`rdb_t_hide_default`.`default_flag` AS `default_flag`,`rdb_t_hide_default`.`hide_flag` AS `hide_flag` from `rdb_t_hide_default` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `implied_auth_rule`
--

/*!50001 DROP TABLE `implied_auth_rule`*/;
/*!50001 DROP VIEW IF EXISTS `implied_auth_rule`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `implied_auth_rule` AS select `rdb_t_implied_auth_rule`.`rule_id` AS `rule_id`,`rdb_t_implied_auth_rule`.`rule_type_code` AS `rule_type_code`,`rdb_t_implied_auth_rule`.`condition_function_or_group` AS `condition_function_or_group`,`rdb_t_implied_auth_rule`.`condition_function_category` AS `condition_function_category`,`rdb_t_implied_auth_rule`.`condition_function_name` AS `condition_function_name`,`rdb_t_implied_auth_rule`.`condition_obj_type` AS `condition_obj_type`,`rdb_t_implied_auth_rule`.`condition_qual_code` AS `condition_qual_code`,`rdb_t_implied_auth_rule`.`result_function_category` AS `result_function_category`,`rdb_t_implied_auth_rule`.`result_function_name` AS `result_function_name`,`rdb_t_implied_auth_rule`.`auth_parent_obj_type` AS `auth_parent_obj_type`,`rdb_t_implied_auth_rule`.`result_qualifier_code` AS `result_qualifier_code`,`rdb_t_implied_auth_rule`.`rule_short_name` AS `rule_short_name`,`rdb_t_implied_auth_rule`.`rule_description` AS `rule_description`,`rdb_t_implied_auth_rule`.`rule_is_in_effect` AS `rule_is_in_effect`,`rdb_t_implied_auth_rule`.`modified_by` AS `modified_by`,`rdb_t_implied_auth_rule`.`modified_date` AS `modified_date` from `rdb_t_implied_auth_rule` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pa_group`
--

/*!50001 DROP TABLE `pa_group`*/;
/*!50001 DROP VIEW IF EXISTS `pa_group`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `pa_group` AS select `rdb_t_pa_group`.`primary_auth_group` AS `primary_auth_group`,`rdb_t_pa_group`.`description` AS `description`,`rdb_t_pa_group`.`web_description` AS `web_description`,`rdb_t_pa_group`.`sort_order` AS `sort_order` from `rdb_t_pa_group` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `people_who_can_spend`
--

/*!50001 DROP TABLE `people_who_can_spend`*/;
/*!50001 DROP VIEW IF EXISTS `people_who_can_spend`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `people_who_can_spend` AS select `rdb_v_people_who_can_spend`.`kerberos_name` AS `kerberos_name`,`rdb_v_people_who_can_spend`.`function_id` AS `function_id`,`rdb_v_people_who_can_spend`.`function_name` AS `function_name`,`rdb_v_people_who_can_spend`.`qualifier_id` AS `qualifier_id`,`rdb_v_people_who_can_spend`.`qualifier_code` AS `qualifier_code`,`rdb_v_people_who_can_spend`.`descend` AS `descend`,`rdb_v_people_who_can_spend`.`grant_and_view` AS `grant_and_view`,`rdb_v_people_who_can_spend`.`spendable_fund` AS `spendable_fund` from `rdb_v_people_who_can_spend` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `person`
--

/*!50001 DROP TABLE `person`*/;
/*!50001 DROP VIEW IF EXISTS `person`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `person` AS select `rdb_t_person`.`mit_id` AS `mit_id`,`rdb_t_person`.`last_name` AS `last_name`,`rdb_t_person`.`first_name` AS `first_name`,`rdb_t_person`.`kerberos_name` AS `kerberos_name`,`rdb_t_person`.`email_addr` AS `email_addr`,`rdb_t_person`.`dept_code` AS `dept_code`,`rdb_t_person`.`primary_person_type` AS `primary_person_type`,`rdb_t_person`.`org_unit_id` AS `org_unit_id`,`rdb_t_person`.`active` AS `active`,`rdb_t_person`.`status_code` AS `status_code`,`rdb_t_person`.`status_date` AS `status_date` from `rdb_t_person` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `person_history`
--

/*!50001 DROP TABLE `person_history`*/;
/*!50001 DROP VIEW IF EXISTS `person_history`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `person_history` AS select `rdb_t_person_history`.`kerberos_name` AS `kerberos_name`,`rdb_t_person_history`.`mit_id` AS `mit_id`,`rdb_t_person_history`.`last_name` AS `last_name`,`rdb_t_person_history`.`first_name` AS `first_name`,`rdb_t_person_history`.`middle_name` AS `middle_name`,`rdb_t_person_history`.`unit_code` AS `unit_code`,`rdb_t_person_history`.`unit_name` AS `unit_name`,`rdb_t_person_history`.`person_type` AS `person_type`,`rdb_t_person_history`.`begin_date` AS `begin_date`,`rdb_t_person_history`.`end_date` AS `end_date` from `rdb_t_person_history` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `person_type`
--

/*!50001 DROP TABLE `person_type`*/;
/*!50001 DROP VIEW IF EXISTS `person_type`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `person_type` AS select `rdb_t_person_type`.`person_type` AS `person_type`,`rdb_t_person_type`.`description` AS `description` from `rdb_t_person_type` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pickable_auth_category`
--

/*!50001 DROP TABLE `pickable_auth_category`*/;
/*!50001 DROP VIEW IF EXISTS `pickable_auth_category`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `pickable_auth_category` AS select `rdb_v_pickable_auth_category`.`kerberos_name` AS `kerberos_name`,`rdb_v_pickable_auth_category`.`function_category` AS `function_category`,`rdb_v_pickable_auth_category`.`function_category_desc` AS `function_category_desc` from `rdb_v_pickable_auth_category` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pickable_auth_function`
--

/*!50001 DROP TABLE `pickable_auth_function`*/;
/*!50001 DROP VIEW IF EXISTS `pickable_auth_function`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `pickable_auth_function` AS select `rdb_v_pickable_auth_function`.`kerberos_name` AS `kerberos_name`,`rdb_v_pickable_auth_function`.`function_id` AS `function_id`,`rdb_v_pickable_auth_function`.`function_name` AS `function_name`,`rdb_v_pickable_auth_function`.`function_category` AS `function_category`,`rdb_v_pickable_auth_function`.`qualifier_type` AS `qualifier_type`,`rdb_v_pickable_auth_function`.`function_description` AS `function_description` from `rdb_v_pickable_auth_function` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pickable_auth_qual_top`
--

/*!50001 DROP TABLE `pickable_auth_qual_top`*/;
/*!50001 DROP VIEW IF EXISTS `pickable_auth_qual_top`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `pickable_auth_qual_top` AS select `rdb_v_pickable_auth_qual_top`.`kerberos_name` AS `kerberos_name`,`rdb_v_pickable_auth_qual_top`.`function_name` AS `function_name`,`rdb_v_pickable_auth_qual_top`.`function_id` AS `function_id`,`rdb_v_pickable_auth_qual_top`.`qualifier_type` AS `qualifier_type`,`rdb_v_pickable_auth_qual_top`.`qualifier_code` AS `qualifier_code`,`rdb_v_pickable_auth_qual_top`.`qualifier_id` AS `qualifier_id` from `rdb_v_pickable_auth_qual_top` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `primary_auth_descendent`
--

/*!50001 DROP TABLE `primary_auth_descendent`*/;
/*!50001 DROP VIEW IF EXISTS `primary_auth_descendent`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `primary_auth_descendent` AS select `rdb_t_primary_auth_descendent`.`parent_id` AS `parent_id`,`rdb_t_primary_auth_descendent`.`child_id` AS `child_id`,`rdb_t_primary_auth_descendent`.`is_dlc` AS `is_dlc` from `rdb_t_primary_auth_descendent` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `qualifier`
--

/*!50001 DROP TABLE `qualifier`*/;
/*!50001 DROP VIEW IF EXISTS `qualifier`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `qualifier` AS select `rdb_t_qualifier`.`qualifier_id` AS `qualifier_id`,`rdb_t_qualifier`.`qualifier_code` AS `qualifier_code`,`rdb_t_qualifier`.`qualifier_name` AS `qualifier_name`,`rdb_t_qualifier`.`qualifier_type` AS `qualifier_type`,`rdb_t_qualifier`.`has_child` AS `has_child`,`rdb_t_qualifier`.`qualifier_level` AS `qualifier_level`,`rdb_t_qualifier`.`custom_hierarchy` AS `custom_hierarchy`,`rdb_t_qualifier`.`status` AS `status`,`rdb_t_qualifier`.`last_modified_date` AS `last_modified_date` from `rdb_t_qualifier` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `qualifier2`
--

/*!50001 DROP TABLE `qualifier2`*/;
/*!50001 DROP VIEW IF EXISTS `qualifier2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `qualifier2` AS select `rdb_v_qualifier2`.`QUALIFIER_ID` AS `QUALIFIER_ID`,`rdb_v_qualifier2`.`QUALIFIER_CODE` AS `QUALIFIER_CODE`,`rdb_v_qualifier2`.`QUALIFIER_NAME` AS `QUALIFIER_NAME`,`rdb_v_qualifier2`.`QUALIFIER_TYPE` AS `QUALIFIER_TYPE`,`rdb_v_qualifier2`.`HAS_CHILD` AS `HAS_CHILD`,`rdb_v_qualifier2`.`QUALIFIER_LEVEL` AS `QUALIFIER_LEVEL`,`rdb_v_qualifier2`.`CUSTOM_HIERARCHY` AS `CUSTOM_HIERARCHY` from `rdb_v_qualifier2` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `qualifier_child`
--

/*!50001 DROP TABLE `qualifier_child`*/;
/*!50001 DROP VIEW IF EXISTS `qualifier_child`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `qualifier_child` AS select `rdb_t_qualifier_child`.`parent_id` AS `parent_id`,`rdb_t_qualifier_child`.`child_id` AS `child_id` from `rdb_t_qualifier_child` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `qualifier_descendent`
--

/*!50001 DROP TABLE `qualifier_descendent`*/;
/*!50001 DROP VIEW IF EXISTS `qualifier_descendent`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `qualifier_descendent` AS select `rdb_t_qualifier_descendent`.`parent_id` AS `parent_id`,`rdb_t_qualifier_descendent`.`child_id` AS `child_id` from `rdb_t_qualifier_descendent` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `qualifier_subtype`
--

/*!50001 DROP TABLE `qualifier_subtype`*/;
/*!50001 DROP VIEW IF EXISTS `qualifier_subtype`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `qualifier_subtype` AS select `rdb_t_qualifier_subtype`.`qualifier_subtype_code` AS `qualifier_subtype_code`,`rdb_t_qualifier_subtype`.`parent_qualifier_type` AS `parent_qualifier_type`,`rdb_t_qualifier_subtype`.`qualifier_subtype_name` AS `qualifier_subtype_name`,`rdb_t_qualifier_subtype`.`contains_string` AS `contains_string`,`rdb_t_qualifier_subtype`.`min_allowable_qualifier_code` AS `min_allowable_qualifier_code`,`rdb_t_qualifier_subtype`.`max_allowable_qualifier_code` AS `max_allowable_qualifier_code` from `rdb_t_qualifier_subtype` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `qualifier_type`
--

/*!50001 DROP TABLE `qualifier_type`*/;
/*!50001 DROP VIEW IF EXISTS `qualifier_type`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `qualifier_type` AS select `rdb_t_qualifier_type`.`qualifier_type` AS `qualifier_type`,`rdb_t_qualifier_type`.`qualifier_type_desc` AS `qualifier_type_desc`,`rdb_t_qualifier_type`.`is_sensitive` AS `is_sensitive` from `rdb_t_qualifier_type` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_auth_in_qualbranch`
--

/*!50001 DROP TABLE `rdb_v_auth_in_qualbranch`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_auth_in_qualbranch`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_auth_in_qualbranch` AS select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`a`.`function_id` AS `FUNCTION_ID`,`a`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`a`.`qualifier_code` AS `QUALIFIER_CODE`,`a`.`function_name` AS `FUNCTION_NAME`,`a`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`q`.`qualifier_code` AS `dept_qual_code`,`q`.`qualifier_type` AS `QUALIFIER_TYPE` from (`authorization` `a` join `qualifier` `q`) where (`a`.`qualifier_id` = `q`.`qualifier_id`) union select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`a`.`function_id` AS `FUNCTION_ID`,`a`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`a`.`qualifier_code` AS `QUALIFIER_CODE`,`a`.`function_name` AS `FUNCTION_NAME`,`a`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`q`.`qualifier_code` AS `dept_qual_code`,`q`.`qualifier_type` AS `QUALIFIER_TYPE` from ((`authorization` `a` join `qualifier_descendent` `qd`) join `qualifier` `q`) where ((`a`.`descend` = _latin1'Y') and (`a`.`qualifier_id` = `qd`.`child_id`) and (`qd`.`parent_id` = `q`.`qualifier_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_authorizable_function`
--

/*!50001 DROP TABLE `rdb_v_authorizable_function`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_authorizable_function`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_authorizable_function` AS select distinct `function`.`function_id` AS `FUNCTION_ID` from `function` where exists(select `authorization`.`kerberos_name` AS `kerberos_name` from `authorization` where ((`authorization`.`function_category` = _latin1'META') and (`authorization`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and (`authorization`.`kerberos_name` = current_user()) and (`authorization`.`qualifier_code` = _latin1'CATALL') and (`authorization`.`effective_date` <= now()) and (ifnull(`authorization`.`expiration_date`,now()) >= now()))) union select distinct `function`.`function_id` AS `function_id` from `function` where `function`.`function_category` in (select rpad(substr(`authorization`.`qualifier_code`,4),4,_latin1' ') AS `rpad(substr(qualifier_code,4),4,' ')` from `authorization` where ((`authorization`.`function_category` = _latin1'META') and (`authorization`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and (`authorization`.`kerberos_name` = current_user()) and (`authorization`.`effective_date` <= now()) and (ifnull(`authorization`.`expiration_date`,now()) >= now()))) union select `f`.`function_id` AS `function_id` from `function` `f` where ((`f`.`primary_authorizable` = _latin1'Y') and exists(select `a`.`authorization_id` AS `authorization_id` from `authorization` `a` where ((`a`.`kerberos_name` = current_user()) and (`a`.`function_name` = _latin1'PRIMARY AUTHORIZOR') and (`a`.`effective_date` <= now()) and (ifnull(`a`.`expiration_date`,now()) >= now()) and (`a`.`do_function` = _latin1'Y')))) union select `f`.`function_id` AS `function_id` from ((`authorization` `a` join `dept_approver_function` `d`) join `function` `f`) where ((`a`.`kerberos_name` = current_user()) and (`a`.`function_name` = _latin1'PRIMARY AUTHORIZOR') and (`a`.`effective_date` <= now()) and (ifnull(`a`.`expiration_date`,now()) >= now()) and (`a`.`do_function` = _latin1'Y') and (`d`.`dept_code` = `a`.`qualifier_code`) and (`f`.`function_id` = `d`.`function_id`)) union select `f2`.`function_id` AS `function_id` from ((`authorization` `a` join `function` `f1`) join `function` `f2`) where ((`f1`.`function_name` = `a`.`function_name`) and (`f1`.`is_primary_auth_parent` = _latin1'Y') and (`a`.`kerberos_name` = current_user()) and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`f2`.`primary_authorizable` = _latin1'Y') and (`f2`.`primary_auth_group` = `f1`.`primary_auth_group`)) union select `f2`.`function_id` AS `function_id` from (((`authorization` `a` join `dept_approver_function` `d`) join `function` `f1`) join `function` `f2`) where ((`f1`.`function_name` = `a`.`function_name`) and (`f1`.`is_primary_auth_parent` = _latin1'Y') and (`a`.`kerberos_name` = current_user()) and (`a`.`effective_date` <= now()) and (ifnull(`a`.`expiration_date`,now()) >= now()) and (`a`.`do_function` = _latin1'Y') and (`f2`.`primary_auth_group` = `f1`.`primary_auth_group`) and (`d`.`dept_code` = `a`.`qualifier_code`) and (`f2`.`function_id` = `d`.`function_id`)) union select distinct `authorization`.`function_id` AS `function_id` from `authorization` where ((`authorization`.`kerberos_name` = current_user()) and (`authorization`.`grant_and_view` in (_latin1'GV',_latin1'GD')) and (`authorization`.`effective_date` <= now()) and (ifnull(`authorization`.`expiration_date`,now()) >= now())) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_authorization2`
--

/*!50001 DROP TABLE `rdb_v_authorization2`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_authorization2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_authorization2` AS select `rdb_t_authorization`.`authorization_id` AS `AUTHORIZATION_ID`,`rdb_t_authorization`.`function_id` AS `FUNCTION_ID`,`rdb_t_authorization`.`qualifier_id` AS `QUALIFIER_ID`,`rdb_t_authorization`.`kerberos_name` AS `KERBEROS_NAME`,`rdb_t_authorization`.`qualifier_code` AS `QUALIFIER_CODE`,`rdb_t_authorization`.`function_name` AS `FUNCTION_NAME`,`rdb_t_authorization`.`function_category` AS `FUNCTION_CATEGORY`,`rdb_t_authorization`.`qualifier_name` AS `QUALIFIER_NAME`,`rdb_t_authorization`.`modified_by` AS `MODIFIED_BY`,`rdb_t_authorization`.`modified_date` AS `MODIFIED_DATE`,`rdb_t_authorization`.`do_function` AS `DO_FUNCTION`,`rdb_t_authorization`.`grant_and_view` AS `GRANT_AND_VIEW`,`rdb_t_authorization`.`descend` AS `DESCEND`,`rdb_t_authorization`.`effective_date` AS `EFFECTIVE_DATE`,`rdb_t_authorization`.`expiration_date` AS `EXPIRATION_DATE`,_utf8'R' AS `AUTH_TYPE` from `rdb_t_authorization` union all select `rdb_t_external_auth`.`authorization_id` AS `authorization_id`,`rdb_t_external_auth`.`function_id` AS `function_id`,`rdb_t_external_auth`.`qualifier_id` AS `qualifier_id`,`rdb_t_external_auth`.`kerberos_name` AS `kerberos_name`,`rdb_t_external_auth`.`qualifier_code` AS `qualifier_code`,`rdb_t_external_auth`.`function_name` AS `function_name`,`rdb_t_external_auth`.`function_category` AS `function_category`,`rdb_t_external_auth`.`qualifier_name` AS `qualifier_name`,`rdb_t_external_auth`.`modified_by` AS `modified_by`,`rdb_t_external_auth`.`modified_date` AS `modified_date`,`rdb_t_external_auth`.`do_function` AS `do_function`,`rdb_t_external_auth`.`grant_and_view` AS `grant_and_view`,`rdb_t_external_auth`.`descend` AS `descend`,`rdb_t_external_auth`.`effective_date` AS `effective_date`,`rdb_t_external_auth`.`expiration_date` AS `expiration_date`,_utf8'E' AS `auth_type` from `rdb_t_external_auth` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_dept_people`
--

/*!50001 DROP TABLE `rdb_v_dept_people`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_dept_people`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_dept_people` AS select `p`.`kerberos_name` AS `kerberos_name`,`q1`.`qualifier_code` AS `over_dept_code` from (((`person` `p` join `qualifier` `q1`) join `qualifier_descendent` `qd`) join `qualifier` `q2`) where ((`p`.`dept_code` = `q2`.`qualifier_code`) and (`q1`.`qualifier_id` = `qd`.`parent_id`) and (`qd`.`child_id` = `q2`.`qualifier_id`) and (`q1`.`qualifier_type` = _latin1'ORGU')) union select `p`.`kerberos_name` AS `kerberos_name`,`p`.`dept_code` AS `over_dept_code` from `person` `p` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_dept_sap_auth`
--

/*!50001 DROP TABLE `rdb_v_dept_sap_auth`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_dept_sap_auth`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_dept_sap_auth` AS select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`a`.`qualifier_id` AS `qualifier_id`,`a`.`qualifier_code` AS `qualifier_code`,`a`.`descend` AS `descend`,`a`.`grant_and_view` AS `grant_and_view`,`a`.`expiration_date` AS `expiration_date`,`a`.`effective_date` AS `effective_date`,`q`.`qualifier_code` AS `dept_fc_code` from ((`authorization` `a` join `qualifier` `q`) join `qualifier_descendent` `qd`) where ((`a`.`function_category` = _latin1'SAP') and (`a`.`function_name` = _latin1'CAN SPEND OR COMMIT FUNDS') and (`a`.`qualifier_id` = `qd`.`child_id`) and (`qd`.`parent_id` = `q`.`qualifier_id`) and (`q`.`qualifier_type` = _latin1'FUND')) union select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`a`.`qualifier_id` AS `qualifier_id`,`a`.`qualifier_code` AS `qualifier_code`,`a`.`descend` AS `descend`,`a`.`grant_and_view` AS `grant_and_view`,`a`.`expiration_date` AS `expiration_date`,`a`.`effective_date` AS `effective_date`,`a`.`qualifier_code` AS `dept_fc_code` from `authorization` `a` where ((`a`.`function_category` = _latin1'SAP') and (`a`.`function_name` = _latin1'CAN SPEND OR COMMIT FUNDS')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_dept_sap_auth2`
--

/*!50001 DROP TABLE `rdb_v_dept_sap_auth2`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_dept_sap_auth2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_dept_sap_auth2` AS select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`a`.`qualifier_id` AS `qualifier_id`,`a`.`qualifier_code` AS `qualifier_code`,`a`.`descend` AS `descend`,`a`.`grant_and_view` AS `grant_and_view`,`a`.`expiration_date` AS `expiration_date`,`a`.`effective_date` AS `effective_date`,`q`.`qualifier_code` AS `dept_sg_code` from ((`authorization` `a` join `qualifier` `q`) join `qualifier_descendent` `qd`) where ((`a`.`function_category` = _latin1'SAP') and (`a`.`function_name` like _latin1'%APPROVER%') and (`a`.`qualifier_id` = `qd`.`child_id`) and (`qd`.`parent_id` = `q`.`qualifier_id`) and (`q`.`qualifier_type` = _latin1'SPGP')) union select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`a`.`qualifier_id` AS `qualifier_id`,`a`.`qualifier_code` AS `qualifier_code`,`a`.`descend` AS `descend`,`a`.`grant_and_view` AS `grant_and_view`,`a`.`expiration_date` AS `expiration_date`,`a`.`effective_date` AS `effective_date`,`a`.`qualifier_code` AS `dept_sg_code` from `authorization` `a` where ((`a`.`function_category` = _latin1'SAP') and (`a`.`function_name` like _latin1'%APPROVER%')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_exp_auth_f_q_lim_dept`
--

/*!50001 DROP TABLE `rdb_v_exp_auth_f_q_lim_dept`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_exp_auth_f_q_lim_dept`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_exp_auth_f_q_lim_dept` AS select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`a`.`function_id` AS `FUNCTION_ID`,`a`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`a`.`qualifier_code` AS `QUALIFIER_CODE`,`a`.`function_name` AS `FUNCTION_NAME`,`a`.`function_category` AS `FUNCTION_CATEGORY`,`a`.`qualifier_name` AS `QUALIFIER_NAME`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`a`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`a`.`qualifier_name` AS `parent_qual_name` from `authorization` `a` union select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`a`.`function_id` AS `FUNCTION_ID`,`q`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`q`.`qualifier_code` AS `QUALIFIER_CODE`,`a`.`function_name` AS `FUNCTION_NAME`,`a`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`a`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`a`.`qualifier_name` AS `parent_qual_name` from ((`authorization` `a` join `qualifier_descendent` `qd`) join `qualifier` `q`) where ((`qd`.`parent_id` = `a`.`qualifier_id`) and (`q`.`qualifier_id` = `qd`.`child_id`) and (substr(`q`.`qualifier_code`,1,2) in (_latin1'D_',_latin1'NU'))) union select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`f2`.`function_id` AS `FUNCTION_ID`,`a`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`a`.`qualifier_code` AS `QUALIFIER_CODE`,`f2`.`function_name` AS `FUNCTION_NAME`,`f2`.`function_category` AS `FUNCTION_CATEGORY`,`a`.`qualifier_name` AS `QUALIFIER_NAME`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`a`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`a`.`qualifier_name` AS `parent_qual_name` from ((`authorization` `a` join `function_child` `fc`) join `function` `f2`) where ((`fc`.`parent_id` = `a`.`function_id`) and (`f2`.`function_id` = `fc`.`child_id`)) union select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`f2`.`function_id` AS `FUNCTION_ID`,`q`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`q`.`qualifier_code` AS `QUALIFIER_CODE`,`f2`.`function_name` AS `FUNCTION_NAME`,`f2`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`a`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`a`.`qualifier_name` AS `parent_qual_name` from ((((`function` `f2` join `function_child` `fc`) join `authorization` `a`) join `qualifier_descendent` `qd`) join `qualifier` `q`) where ((`qd`.`parent_id` = `a`.`qualifier_id`) and (`q`.`qualifier_id` = `qd`.`child_id`) and (substr(`q`.`qualifier_code`,1,2) in (_latin1'D_',_latin1'NU')) and (`fc`.`parent_id` = `a`.`function_id`) and (`f2`.`function_id` = `fc`.`child_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_expanded_auth2`
--

/*!50001 DROP TABLE `rdb_v_expanded_auth2`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_expanded_auth2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_expanded_auth2` AS select `a`.`authorization_id` AS `authorization_id`,`a`.`function_id` AS `function_id`,`a`.`qualifier_id` AS `qualifier_id`,`a`.`kerberos_name` AS `kerberos_name`,`q0`.`qualifier_code` AS `qualifier_code`,`a`.`function_name` AS `function_name`,`a`.`function_category` AS `function_category`,`q0`.`qualifier_name` AS `qualifier_name`,`a`.`modified_by` AS `modified_by`,`a`.`modified_date` AS `modified_date`,`a`.`do_function` AS `do_function`,`a`.`grant_and_view` AS `grant_and_view`,`a`.`descend` AS `descend`,`a`.`effective_date` AS `effective_date`,`a`.`expiration_date` AS `expiration_date`,`q0`.`qualifier_type` AS `qualifier_type`,_utf8'R' AS `virtual_or_real` from (`rdb_t_authorization` `a` join `rdb_t_qualifier` `q0`) where (`q0`.`qualifier_id` = `a`.`qualifier_id`) union select `a`.`authorization_id` AS `authorization_id`,`a`.`function_id` AS `function_id`,`q`.`qualifier_id` AS `qualifier_id`,`a`.`kerberos_name` AS `kerberos_name`,`q`.`qualifier_code` AS `qualifier_code`,`a`.`function_name` AS `function_name`,`a`.`function_category` AS `function_category`,`q`.`qualifier_name` AS `qualifier_name`,`a`.`modified_by` AS `modified_by`,`a`.`modified_date` AS `modified_date`,`a`.`do_function` AS `do_function`,`a`.`grant_and_view` AS `grant_and_view`,`a`.`descend` AS `descend`,`a`.`effective_date` AS `effective_date`,`a`.`expiration_date` AS `expiration_date`,`q0`.`qualifier_type` AS `qualifier_type`,_utf8'V' AS `virtual_or_real` from (((`rdb_t_authorization` `a` join `rdb_t_qualifier` `q0`) join `rdb_t_qualifier_descendent` `qd`) join `rdb_t_qualifier` `q`) where ((`q0`.`qualifier_id` = `a`.`qualifier_id`) and (`q0`.`qualifier_level` <> 1) and (`qd`.`parent_id` = `a`.`qualifier_id`) and (`a`.`descend` = _latin1'Y') and (`q`.`qualifier_id` = `qd`.`child_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_expanded_auth_func_qual`
--

/*!50001 DROP TABLE `rdb_v_expanded_auth_func_qual`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_expanded_auth_func_qual`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_expanded_auth_func_qual` AS select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`a`.`function_id` AS `FUNCTION_ID`,`a`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`q`.`qualifier_code` AS `QUALIFIER_CODE`,`a`.`function_name` AS `FUNCTION_NAME`,`a`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`q`.`qualifier_type` AS `QUALIFIER_TYPE`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`q`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`q`.`qualifier_name` AS `parent_qual_name`,elt(sign((now() - `a`.`effective_date`)),-(1),_latin1'N',elt(sign((ifnull(`a`.`expiration_date`,now()) - now())),-(1),_latin1'N',`a`.`do_function`)) AS `is_in_effect` from (`authorization` `a` join `qualifier` `q`) where (`q`.`qualifier_id` = `a`.`qualifier_id`) union select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`a`.`function_id` AS `FUNCTION_ID`,`q`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`q`.`qualifier_code` AS `QUALIFIER_CODE`,`a`.`function_name` AS `FUNCTION_NAME`,`a`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`q`.`qualifier_type` AS `QUALIFIER_TYPE`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`a`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`a`.`qualifier_name` AS `parent_qual_name`,elt(sign((now() - `a`.`effective_date`)),-(1),_latin1'N',elt(sign((ifnull(`a`.`expiration_date`,now()) - now())),-(1),_latin1'N',`a`.`do_function`)) AS `is_in_effect` from ((`authorization` `a` join `qualifier_descendent` `qd`) join `qualifier` `q`) where ((`qd`.`parent_id` = `a`.`qualifier_id`) and (`q`.`qualifier_id` = `qd`.`child_id`)) union select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`f2`.`function_id` AS `FUNCTION_ID`,`a`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`q`.`qualifier_code` AS `QUALIFIER_CODE`,`f2`.`function_name` AS `FUNCTION_NAME`,`f2`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`q`.`qualifier_type` AS `QUALIFIER_TYPE`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`q`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`q`.`qualifier_name` AS `parent_qual_name`,elt(sign((now() - `a`.`effective_date`)),-(1),_latin1'N',elt(sign((ifnull(`a`.`expiration_date`,now()) - now())),-(1),_latin1'N',`a`.`do_function`)) AS `is_in_effect` from (((`authorization` `a` join `function_child` `fc`) join `function` `f2`) join `qualifier` `q`) where ((`fc`.`parent_id` = `a`.`function_id`) and (`f2`.`function_id` = `fc`.`child_id`) and (`q`.`qualifier_id` = `a`.`qualifier_id`) and (`q`.`qualifier_type` = `f2`.`qualifier_type`)) union select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`f2`.`function_id` AS `FUNCTION_ID`,`q`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`q`.`qualifier_code` AS `QUALIFIER_CODE`,`f2`.`function_name` AS `FUNCTION_NAME`,`f2`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`q`.`qualifier_type` AS `QUALIFIER_TYPE`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`a`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`a`.`qualifier_name` AS `parent_qual_name`,elt(sign((now() - `a`.`effective_date`)),-(1),_latin1'N',elt(sign((ifnull(`a`.`expiration_date`,now()) - now())),-(1),_latin1'N',`a`.`do_function`)) AS `is_in_effect` from ((((`function` `f2` join `function_child` `fc`) join `authorization` `a`) join `qualifier_descendent` `qd`) join `qualifier` `q`) where ((`qd`.`parent_id` = `a`.`qualifier_id`) and (`q`.`qualifier_id` = `qd`.`child_id`) and (`fc`.`parent_id` = `a`.`function_id`) and (`f2`.`function_id` = `fc`.`child_id`) and (`q`.`qualifier_type` = `f2`.`qualifier_type`) and (`a`.`descend` = _latin1'Y')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_expanded_auth_func_root`
--

/*!50001 DROP TABLE `rdb_v_expanded_auth_func_root`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_expanded_auth_func_root`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_expanded_auth_func_root` AS select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`a`.`function_id` AS `FUNCTION_ID`,`a`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`a`.`qualifier_code` AS `QUALIFIER_CODE`,`a`.`function_name` AS `FUNCTION_NAME`,`a`.`function_category` AS `FUNCTION_CATEGORY`,`a`.`qualifier_name` AS `QUALIFIER_NAME`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`a`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`a`.`qualifier_name` AS `parent_qual_name` from (`authorization` `a` join `qualifier` `q`) where ((`a`.`qualifier_id` = `q`.`qualifier_id`) and (`q`.`qualifier_level` = 1)) union select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`f2`.`function_id` AS `FUNCTION_ID`,`a`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`a`.`qualifier_code` AS `QUALIFIER_CODE`,`f2`.`function_name` AS `FUNCTION_NAME`,`f2`.`function_category` AS `FUNCTION_CATEGORY`,`a`.`qualifier_name` AS `QUALIFIER_NAME`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`a`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`a`.`qualifier_name` AS `parent_qual_name` from (((`authorization` `a` join `qualifier` `q`) join `function_child` `fc`) join `function` `f2`) where ((`q`.`qualifier_id` = `a`.`qualifier_id`) and (`q`.`qualifier_level` = 1) and (`fc`.`parent_id` = `a`.`function_id`) and (`f2`.`function_id` = `fc`.`child_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_expanded_auth_no_root`
--

/*!50001 DROP TABLE `rdb_v_expanded_auth_no_root`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_expanded_auth_no_root`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_expanded_auth_no_root` AS select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`q`.`qualifier_code` AS `qualifier_code` from (`rdb_t_authorization` `a` join `rdb_t_qualifier` `q`) where (`a`.`function_category` in (select `rdb_t_extract_category`.`function_category` AS `function_category` from `rdb_t_extract_category` where (`rdb_t_extract_category`.`username` = current_user())) and (`a`.`qualifier_id` = `q`.`qualifier_id`) and (`a`.`descend` = _latin1'Y') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`q`.`qualifier_level` <> 1) and (`q`.`has_child` = _latin1'N')) union select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`q`.`qualifier_code` AS `qualifier_code` from ((((`rdb_t_authorization` `a` join `rdb_t_qualifier_descendent` `qd`) join `rdb_t_qualifier` `q`) join `rdb_t_qualifier` `q0`) join `rdb_t_extract_category` `e`) where ((`q0`.`qualifier_id` = `a`.`qualifier_id`) and (`q0`.`qualifier_level` <> 1) and (`e`.`username` = current_user()) and (`a`.`function_category` = `e`.`function_category`) and (`a`.`qualifier_id` = `qd`.`parent_id`) and (`a`.`descend` = _latin1'Y') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`qd`.`child_id` = `q`.`qualifier_id`) and (`q`.`has_child` = _latin1'N')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_expanded_authorization`
--

/*!50001 DROP TABLE `rdb_v_expanded_authorization`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_expanded_authorization`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_expanded_authorization` AS select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`q`.`qualifier_code` AS `qualifier_code` from ((`rdb_t_authorization` `a` join `rdb_t_qualifier` `q`) join `rdb_t_extract_category` `e`) where ((`a`.`function_category` = `e`.`function_category`) and (`e`.`username` = current_user()) and (`a`.`qualifier_id` = `q`.`qualifier_id`) and (`a`.`descend` = _latin1'Y') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`q`.`has_child` = _latin1'N')) union select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`q`.`qualifier_code` AS `qualifier_code` from (((`rdb_t_authorization` `a` join `rdb_t_qualifier_descendent` `qd`) join `rdb_t_qualifier` `q`) join `rdb_t_extract_category` `e`) where ((`a`.`function_category` = `e`.`function_category`) and (`e`.`username` = current_user()) and (`a`.`qualifier_id` = `qd`.`parent_id`) and (`a`.`descend` = _latin1'Y') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`qd`.`child_id` = `q`.`qualifier_id`) and (`q`.`has_child` = _latin1'N')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_extract_auth`
--

/*!50001 DROP TABLE `rdb_v_extract_auth`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_extract_auth`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_extract_auth` AS select `authorization`.`kerberos_name` AS `KERBEROS_NAME`,`authorization`.`function_name` AS `FUNCTION_NAME`,`authorization`.`qualifier_code` AS `QUALIFIER_CODE`,`authorization`.`function_category` AS `FUNCTION_CATEGORY`,`authorization`.`descend` AS `DESCEND`,`authorization`.`effective_date` AS `EFFECTIVE_DATE`,`authorization`.`expiration_date` AS `EXPIRATION_DATE` from `authorization` where ((`authorization`.`do_function` = _latin1'Y') and `authorization`.`function_category` in (select `rdb_t_extract_category`.`function_category` AS `function_category` from `rdb_t_extract_category` where (current_user() = `rdb_t_extract_category`.`username`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_extract_desc`
--

/*!50001 DROP TABLE `rdb_v_extract_desc`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_extract_desc`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_extract_desc` AS select `p`.`qualifier_code` AS `PARENT_CODE`,`c`.`qualifier_code` AS `CHILD_CODE` from ((`qualifier` `p` join `qualifier_descendent` `d`) join `qualifier` `c`) where ((`p`.`qualifier_id` = `d`.`parent_id`) and (`c`.`qualifier_id` = `d`.`child_id`) and `d`.`parent_id` in (select distinct `authorization`.`qualifier_id` AS `QUALIFIER_ID` from `authorization` where `authorization`.`function_category` in (select `rdb_t_extract_category`.`function_category` AS `function_category` from `rdb_t_extract_category` where (current_user() = `rdb_t_extract_category`.`username`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_function2`
--

/*!50001 DROP TABLE `rdb_v_function2`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_function2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_function2` AS select `rdb_t_function`.`function_id` AS `function_id`,`rdb_t_function`.`function_name` AS `function_name`,`rdb_t_function`.`function_description` AS `function_description`,`rdb_t_function`.`function_category` AS `function_category`,`rdb_t_function`.`modified_by` AS `modified_by`,`rdb_t_function`.`modified_date` AS `modified_date`,`rdb_t_function`.`qualifier_type` AS `qualifier_type`,`rdb_t_function`.`primary_authorizable` AS `primary_authorizable`,`rdb_t_function`.`is_primary_auth_parent` AS `is_primary_auth_parent`,`rdb_t_function`.`primary_auth_group` AS `primary_auth_group`,_utf8'R' AS `real_or_external` from `rdb_t_function` union all select `rdb_t_external_function`.`function_id` AS `function_id`,`rdb_t_external_function`.`function_name` AS `function_name`,`rdb_t_external_function`.`function_description` AS `function_description`,`rdb_t_external_function`.`function_category` AS `function_category`,`rdb_t_external_function`.`modified_by` AS `modified_by`,`rdb_t_external_function`.`modified_date` AS `modified_date`,`rdb_t_external_function`.`qualifier_type` AS `qualifier_type`,`rdb_t_external_function`.`primary_authorizable` AS `primary_authorizable`,NULL AS `is_primary_auth_parent`,NULL AS `primary_auth_group`,_utf8'X' AS `real_or_external` from `rdb_t_external_function` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_people_who_can_spend`
--

/*!50001 DROP TABLE `rdb_v_people_who_can_spend`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_people_who_can_spend`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_people_who_can_spend` AS select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`a`.`qualifier_id` AS `qualifier_id`,`a`.`qualifier_code` AS `qualifier_code`,`a`.`descend` AS `descend`,`a`.`grant_and_view` AS `grant_and_view`,`q`.`qualifier_code` AS `spendable_fund` from ((`authorization` `a` join `qualifier` `q`) join `qualifier_descendent` `qd`) where ((`a`.`function_category` = _latin1'SAP') and (`a`.`function_name` = _latin1'CAN SPEND OR COMMIT FUNDS') and (`a`.`qualifier_id` = `qd`.`parent_id`) and (`qd`.`child_id` = `q`.`qualifier_id`) and (`q`.`qualifier_type` = _latin1'FUND') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`a`.`do_function` = _latin1'Y')) union select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`a`.`qualifier_id` AS `qualifier_id`,`a`.`qualifier_code` AS `qualifier_code`,`a`.`descend` AS `descend`,`a`.`grant_and_view` AS `grant_and_view`,`a`.`qualifier_code` AS `spendable_fund` from `authorization` `a` where ((`a`.`function_category` = _latin1'SAP') and (`a`.`function_name` = _latin1'CAN SPEND OR COMMIT FUNDS') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`a`.`do_function` = _latin1'Y')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_person`
--

/*!50001 DROP TABLE `rdb_v_person`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_person`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_person` AS select _utf8'MIT_ID' AS `MIT_ID`,_utf8'LAST_NAME' AS `LAST_NAME`,_utf8'FIRST_NAME' AS `FIRST_NAME`,_utf8'KERBEROS_NAME' AS `KERBEROS_NAME`,_utf8'EMAIL_ADDR' AS `EMAIL_ADDR`,_utf8'DEPT_CODE' AS `DEPT_CODE`,_utf8'PRIMARY_PERSON_TYPE' AS `PRIMARY_PERSON_TYPE`,_utf8'ORG_UNIT_ID' AS `ORG_UNIT_ID`,_utf8'ACTIVE' AS `ACTIVE`,_utf8'STATUS_CODE' AS `STATUS_CODE`,_utf8'STATUS_DATE' AS `STATUS_DATE` from `rdb_t_person` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_pickable_auth_category`
--

/*!50001 DROP TABLE `rdb_v_pickable_auth_category`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_pickable_auth_category`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_pickable_auth_category` AS select `a`.`kerberos_name` AS `kerberos_name`,`c`.`function_category` AS `function_category`,`c`.`function_category_desc` AS `function_category_desc` from (`authorization` `a` join `category` `c`) where ((`a`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and (`a`.`qualifier_code` <> _latin1'CATALL') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`c`.`function_category` = substr(concat(`a`.`qualifier_code`,_latin1'   '),4,4))) union select `a`.`kerberos_name` AS `kerberos_name`,`c`.`function_category` AS `function_category`,`c`.`function_category_desc` AS `function_category_desc` from (((`authorization` `a` join `qualifier_descendent` `qd`) join `qualifier` `q`) join `category` `c`) where ((`a`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`qd`.`parent_id` = `a`.`qualifier_id`) and (`q`.`qualifier_id` = `qd`.`child_id`) and (`c`.`function_category` = substr(concat(`q`.`qualifier_code`,_latin1'   '),4,4))) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`f2`.`function_category` AS `function_category`,`c`.`function_category_desc` AS `function_category_desc` from (((`authorization` `a` join `function` `f1`) join `function` `f2`) join `category` `c`) where ((`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`f1`.`function_id` = `a`.`function_id`) and (`f1`.`is_primary_auth_parent` = _latin1'Y') and (`f2`.`primary_authorizable` in (_latin1'Y',_latin1'D')) and (`f2`.`primary_auth_group` = `f1`.`primary_auth_group`) and (`c`.`function_category` = `f2`.`function_category`)) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_category` AS `function_category`,`c`.`function_category_desc` AS `function_category_desc` from (`authorization` `a` join `category` `c`) where ((`a`.`grant_and_view` in (_latin1'GV',_latin1'GD')) and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`c`.`function_category` = `a`.`function_category`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_pickable_auth_function`
--

/*!50001 DROP TABLE `rdb_v_pickable_auth_function`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_pickable_auth_function`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_pickable_auth_function` AS select distinct `a`.`kerberos_name` AS `kerberos_name`,`f`.`function_id` AS `function_id`,`f`.`function_name` AS `function_name`,`f`.`function_category` AS `function_category`,`f`.`qualifier_type` AS `qualifier_type`,`f`.`function_description` AS `function_description` from (`authorization` `a` join `function` `f`) where ((`a`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and (`a`.`qualifier_code` <> _latin1'CATALL') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`f`.`function_category` = substr(concat(`a`.`qualifier_code`,_latin1'  '),4,4))) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`f`.`function_id` AS `function_id`,`f`.`function_name` AS `function_name`,`f`.`function_category` AS `function_category`,`f`.`qualifier_type` AS `qualifier_type`,`f`.`function_description` AS `function_description` from (((`authorization` `a` join `qualifier_descendent` `qd`) join `qualifier` `q`) join `function` `f`) where ((`a`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`qd`.`parent_id` = `a`.`qualifier_id`) and (`q`.`qualifier_id` = `qd`.`child_id`) and (`f`.`function_category` = substr(concat(`q`.`qualifier_code`,_latin1'  '),4,4))) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`f2`.`function_id` AS `function_id`,`f2`.`function_name` AS `function_name`,`f2`.`function_category` AS `function_category`,`f2`.`qualifier_type` AS `qualifier_type`,`f2`.`function_description` AS `function_description` from ((`authorization` `a` join `function` `f1`) join `function` `f2`) where ((`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`f1`.`function_id` = `a`.`function_id`) and (`f1`.`is_primary_auth_parent` = _latin1'Y') and (`f2`.`primary_authorizable` in (_latin1'Y',_latin1'D')) and (`f2`.`primary_auth_group` = `f1`.`primary_auth_group`)) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`f`.`function_id` AS `function_id`,`f`.`function_name` AS `function_name`,`f`.`function_category` AS `function_category`,`f`.`qualifier_type` AS `qualifier_type`,`f`.`function_description` AS `function_description` from (`authorization` `a` join `function` `f`) where ((`a`.`grant_and_view` in (_latin1'GV',_latin1'GD')) and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`f`.`function_id` = `a`.`function_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_pickable_auth_qual_top`
--

/*!50001 DROP TABLE `rdb_v_pickable_auth_qual_top`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_pickable_auth_qual_top`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_pickable_auth_qual_top` AS select distinct `a`.`kerberos_name` AS `kerberos_name`,`f`.`function_name` AS `function_name`,`f`.`function_id` AS `function_id`,`f`.`qualifier_type` AS `qualifier_type`,`q`.`qualifier_code` AS `qualifier_code`,`q`.`qualifier_id` AS `qualifier_id` from ((`authorization` `a` join `function` `f`) join `qualifier` `q`) where ((`a`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and (`a`.`qualifier_code` <> _latin1'CATALL') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`f`.`function_category` = substr(concat(`a`.`qualifier_code`,_latin1'   '),4,4)) and (`q`.`qualifier_type` = `f`.`qualifier_type`) and (`q`.`qualifier_level` = 1)) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`f`.`function_name` AS `function_name`,`f`.`function_id` AS `function_id`,`f`.`qualifier_type` AS `qualifier_type`,`q`.`qualifier_code` AS `qualifier_code`,`q`.`qualifier_id` AS `qualifier_id` from ((((`authorization` `a` join `qualifier_descendent` `qd`) join `qualifier` `q0`) join `function` `f`) join `qualifier` `q`) where ((`a`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`qd`.`parent_id` = `a`.`qualifier_id`) and (`q0`.`qualifier_id` = `qd`.`child_id`) and (`f`.`function_category` = substr(concat(`q0`.`qualifier_code`,_latin1'   '),4,4)) and (`q`.`qualifier_type` = `f`.`qualifier_type`) and (`q`.`qualifier_level` = 1)) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`f2`.`function_name` AS `function_name`,`f2`.`function_id` AS `function_id`,`f2`.`qualifier_type` AS `qualifier_type`,`q`.`qualifier_code` AS `qualifier_code`,`q`.`qualifier_id` AS `qualifier_id` from ((((((`authorization` `a` join `function` `f1`) join `function` `f2`) join `qualifier` `q0`) join `qualifier_descendent` `qd`) join `qualifier` `q1`) join `qualifier` `q`) where ((`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`f1`.`function_id` = `a`.`function_id`) and (`f1`.`is_primary_auth_parent` = _latin1'Y') and (`f2`.`primary_authorizable` in (_latin1'Y',_latin1'D')) and (`f2`.`primary_auth_group` = `f1`.`primary_auth_group`) and (`q0`.`qualifier_type` = _latin1'DEPT') and (`q0`.`qualifier_code` = `a`.`qualifier_code`) and (`qd`.`parent_id` = `q0`.`qualifier_id`) and (`q1`.`qualifier_id` = `qd`.`child_id`) and (`q`.`qualifier_type` = `f2`.`qualifier_type`) and (`q`.`qualifier_code` = `q1`.`qualifier_code`) and (not(exists(select 1 AS `1` from `authorization` `a2` where ((`a2`.`kerberos_name` = `a`.`kerberos_name`) and (`a2`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and ((`a2`.`qualifier_code` = concat(_latin1'CAT',rtrim(`f2`.`function_category`))) or (`a2`.`qualifier_code` = _latin1'CATALL')) and (`a2`.`do_function` = _latin1'Y') and (now() between `a2`.`effective_date` and ifnull(`a2`.`expiration_date`,now()))))))) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`f2`.`function_name` AS `function_name`,`f2`.`function_id` AS `function_id`,`f2`.`qualifier_type` AS `qualifier_type`,`q`.`qualifier_code` AS `qualifier_code`,`q`.`qualifier_id` AS `qualifier_id` from (((`authorization` `a` join `function` `f1`) join `function` `f2`) join `qualifier` `q`) where ((`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`f1`.`function_id` = `a`.`function_id`) and (`f1`.`is_primary_auth_parent` = _latin1'Y') and (`f2`.`primary_authorizable` in (_latin1'Y',_latin1'D')) and (`f2`.`primary_auth_group` = `f1`.`primary_auth_group`) and (`f2`.`qualifier_type` = _latin1'NULL') and (`q`.`qualifier_type` = `f2`.`qualifier_type`) and (`q`.`qualifier_code` = _latin1'NULL') and (not(exists(select 1 AS `1` from `authorization` `a2` where ((`a2`.`kerberos_name` = `a`.`kerberos_name`) and (`a2`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and ((`a2`.`qualifier_code` = concat(_latin1'CAT',rtrim(`f2`.`function_category`))) or (`a2`.`qualifier_code` = _latin1'CATALL')) and (`a2`.`do_function` = _latin1'Y') and (now() between `a2`.`effective_date` and ifnull(`a2`.`expiration_date`,now()))))))) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`f`.`function_name` AS `function_name`,`f`.`function_id` AS `function_id`,`f`.`qualifier_type` AS `qualifier_type`,`q`.`qualifier_code` AS `qualifier_code`,`q`.`qualifier_id` AS `qualifier_id` from ((`authorization` `a` join `function` `f`) join `qualifier` `q`) where ((`a`.`grant_and_view` in (_latin1'GV',_latin1'GD')) and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`f`.`function_id` = `a`.`function_id`) and (`q`.`qualifier_id` = `a`.`qualifier_id`) and (not(exists(select 1 AS `1` from `authorization` `a2` where ((`a2`.`kerberos_name` = `a`.`kerberos_name`) and (`a2`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and ((`a2`.`qualifier_code` = concat(_latin1'CAT',rtrim(`f`.`function_category`))) or (`a2`.`qualifier_code` = _latin1'CATALL')) and (`a2`.`do_function` = _latin1'Y') and (now() between `a2`.`effective_date` and ifnull(`a2`.`expiration_date`,now()))))))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_qualifier2`
--

/*!50001 DROP TABLE `rdb_v_qualifier2`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_qualifier2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_qualifier2` AS select `q`.`qualifier_id` AS `QUALIFIER_ID`,`q`.`qualifier_code` AS `QUALIFIER_CODE`,elt(ifnull(`aq`.`kerberos_name`,_latin1' '),current_user(),`sqn`.`qualifier_name`,`q`.`qualifier_name`) AS `QUALIFIER_NAME`,`q`.`qualifier_type` AS `QUALIFIER_TYPE`,`q`.`has_child` AS `HAS_CHILD`,`q`.`qualifier_level` AS `QUALIFIER_LEVEL`,`q`.`custom_hierarchy` AS `CUSTOM_HIERARCHY` from (`suppressed_qualname` `sqn` join (`access_to_qualname` `aq` left join `qualifier` `q` on((`aq`.`qualifier_type` = `q`.`qualifier_type`)))) where ((`sqn`.`qualifier_id` = `q`.`qualifier_id`) and (`aq`.`kerberos_name` = current_user())) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_viewable_category`
--

/*!50001 DROP TABLE `rdb_v_viewable_category`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_viewable_category`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_viewable_category` AS select `a`.`kerberos_name` AS `kerberos_name`,rpad(substr(`a`.`qualifier_code`,4),4,_latin1' ') AS `function_category`,`c`.`function_category_desc` AS `function_category_desc` from (`authorization` `a` join `category` `c`) where ((`a`.`function_name` in (_latin1'VIEW AUTH BY CATEGORY',_latin1'CREATE AUTHORIZATIONS')) and (`a`.`do_function` = _latin1'Y') and (`a`.`qualifier_code` <> _latin1'CATALL') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`c`.`function_category` = rpad(substr(`a`.`qualifier_code`,4),4,_latin1' '))) union select `a`.`kerberos_name` AS `kerberos_name`,rpad(substr(`q`.`qualifier_code`,4),4,_latin1' ') AS `function_category`,`c`.`function_category_desc` AS `function_category_desc` from (((`authorization` `a` join `qualifier_descendent` `qd`) join `qualifier` `q`) join `category` `c`) where ((`a`.`function_name` in (_latin1'VIEW AUTH BY CATEGORY',_latin1'CREATE AUTHORIZATIONS')) and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`qd`.`parent_id` = `a`.`qualifier_id`) and (`q`.`qualifier_id` = `qd`.`child_id`) and (`c`.`function_category` = rpad(substr(`q`.`qualifier_code`,4),4,_latin1' '))) union select distinct `a`.`kerberos_name` AS `kerberos_name`,rpad(`c`.`function_category`,4,_latin1' ') AS `function_category`,`c`.`function_category_desc` AS `function_category_desc` from (`authorization` `a` join `category` `c`) where ((`a`.`function_category` in (_latin1'SAP',_latin1'HR',_latin1'PAYR')) and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`c`.`function_category` in (_latin1'SAP',_latin1'LABD',_latin1'ADMN',_latin1'HR',_latin1'META',_latin1'PAYR'))) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`f2`.`function_category` AS `function_category`,`c`.`function_category_desc` AS `function_category_desc` from (((`authorization` `a` join `function` `f1`) join `function` `f2`) join `category` `c`) where ((`f1`.`function_id` = `a`.`function_id`) and (`f1`.`is_primary_auth_parent` = _latin1'Y') and (`f2`.`primary_auth_group` = `f1`.`primary_auth_group`) and (`f2`.`primary_authorizable` in (_latin1'D',_latin1'Y')) and (`c`.`function_category` = `f2`.`function_category`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rdb_v_xexpanded_auth_func_qual`
--

/*!50001 DROP TABLE `rdb_v_xexpanded_auth_func_qual`*/;
/*!50001 DROP VIEW IF EXISTS `rdb_v_xexpanded_auth_func_qual`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rdb_v_xexpanded_auth_func_qual` AS select distinct `a`.`authorization_id` AS `AUTHORIZATION_ID`,`f2`.`function_id` AS `FUNCTION_ID`,`a`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`q`.`qualifier_code` AS `QUALIFIER_CODE`,`f2`.`function_name` AS `FUNCTION_NAME`,`f2`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`q`.`qualifier_type` AS `QUALIFIER_TYPE`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`q`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`q`.`qualifier_name` AS `parent_qual_name` from ((((`authorization` `a` join `function_child` `fc`) join `function` `f2`) join `qualifier` `q`) join `function` `f1`) where ((`fc`.`parent_id` = `a`.`function_id`) and (`f2`.`function_id` = `fc`.`child_id`) and (`q`.`qualifier_code` = `a`.`qualifier_code`) and (`q`.`qualifier_type` = `f2`.`qualifier_type`) and (`f1`.`function_id` = `a`.`function_id`) and (`f1`.`qualifier_type` <> `f2`.`qualifier_type`)) union select distinct `a`.`authorization_id` AS `AUTHORIZATION_ID`,`f2`.`function_id` AS `FUNCTION_ID`,`q`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`q`.`qualifier_code` AS `QUALIFIER_CODE`,`f2`.`function_name` AS `FUNCTION_NAME`,`f2`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`q`.`qualifier_type` AS `QUALIFIER_TYPE`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`q`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`q`.`qualifier_name` AS `parent_qual_name` from ((((((`authorization` `a` join `function_child` `fc`) join `function` `f2`) join `qualifier` `q0`) join `qualifier_descendent` `qd`) join `qualifier` `q`) join `function` `f1`) where ((`fc`.`parent_id` = `a`.`function_id`) and (`f2`.`function_id` = `fc`.`child_id`) and (`q0`.`qualifier_code` = `a`.`qualifier_code`) and (`q0`.`qualifier_type` = `f2`.`qualifier_type`) and (`qd`.`parent_id` = `q0`.`qualifier_id`) and (`q`.`qualifier_id` = `qd`.`child_id`) and (`f1`.`function_id` = `a`.`function_id`) and (`f1`.`qualifier_type` <> `f2`.`qualifier_type`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `roles_parameters`
--

/*!50001 DROP TABLE `roles_parameters`*/;
/*!50001 DROP VIEW IF EXISTS `roles_parameters`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `roles_parameters` AS select `rdb_t_roles_parameters`.`parameter` AS `parameter`,`rdb_t_roles_parameters`.`value` AS `value`,`rdb_t_roles_parameters`.`description` AS `description`,`rdb_t_roles_parameters`.`default_value` AS `default_value`,`rdb_t_roles_parameters`.`is_number` AS `is_number`,`rdb_t_roles_parameters`.`update_user` AS `update_user`,`rdb_t_roles_parameters`.`update_timestamp` AS `update_timestamp` from `rdb_t_roles_parameters` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `roles_users`
--

/*!50001 DROP TABLE `roles_users`*/;
/*!50001 DROP VIEW IF EXISTS `roles_users`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `roles_users` AS select `rdb_t_roles_users`.`username` AS `username`,`rdb_t_roles_users`.`action_type` AS `action_type`,`rdb_t_roles_users`.`action_date` AS `action_date`,`rdb_t_roles_users`.`action_user` AS `action_user`,`rdb_t_roles_users`.`notes` AS `notes` from `rdb_t_roles_users` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `screen`
--

/*!50001 DROP TABLE `screen`*/;
/*!50001 DROP VIEW IF EXISTS `screen`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `screen` AS select `rdb_t_screen`.`screen_id` AS `screen_id`,`rdb_t_screen`.`screen_name` AS `screen_name` from `rdb_t_screen` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `screen2`
--

/*!50001 DROP TABLE `screen2`*/;
/*!50001 DROP VIEW IF EXISTS `screen2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `screen2` AS select `rdb_t_screen2`.`screen_id` AS `screen_id`,`rdb_t_screen2`.`screen_name` AS `screen_name` from `rdb_t_screen2` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `selection_criteria2`
--

/*!50001 DROP TABLE `selection_criteria2`*/;
/*!50001 DROP VIEW IF EXISTS `selection_criteria2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `selection_criteria2` AS select `rdb_t_selection_criteria2`.`selection_id` AS `selection_id`,`rdb_t_selection_criteria2`.`criteria_id` AS `criteria_id`,`rdb_t_selection_criteria2`.`default_apply` AS `default_apply`,`rdb_t_selection_criteria2`.`default_value` AS `default_value`,`rdb_t_selection_criteria2`.`next_scrn_selection_id` AS `next_scrn_selection_id`,`rdb_t_selection_criteria2`.`no_change` AS `no_change`,`rdb_t_selection_criteria2`.`sequence` AS `sequence` from `rdb_t_selection_criteria2` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `selection_set`
--

/*!50001 DROP TABLE `selection_set`*/;
/*!50001 DROP VIEW IF EXISTS `selection_set`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `selection_set` AS select `rdb_t_selection_set`.`selection_id` AS `selection_id`,`rdb_t_selection_set`.`selection_name` AS `selection_name`,`rdb_t_selection_set`.`screen_id` AS `screen_id` from `rdb_t_selection_set` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `selection_set2`
--

/*!50001 DROP TABLE `selection_set2`*/;
/*!50001 DROP VIEW IF EXISTS `selection_set2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `selection_set2` AS select `rdb_t_selection_set2`.`selection_id` AS `selection_id`,`rdb_t_selection_set2`.`selection_name` AS `selection_name`,`rdb_t_selection_set2`.`screen_id` AS `screen_id`,`rdb_t_selection_set2`.`sequence` AS `sequence` from `rdb_t_selection_set2` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `special_selection_set2`
--

/*!50001 DROP TABLE `special_selection_set2`*/;
/*!50001 DROP VIEW IF EXISTS `special_selection_set2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `special_selection_set2` AS select `rdb_t_special_sel_set2`.`selection_id` AS `selection_id`,`rdb_t_special_sel_set2`.`program_widget_id` AS `program_widget_id`,`rdb_t_special_sel_set2`.`program_widget_name` AS `program_widget_name` from `rdb_t_special_sel_set2` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `special_username`
--

/*!50001 DROP TABLE `special_username`*/;
/*!50001 DROP VIEW IF EXISTS `special_username`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `special_username` AS select `rdb_t_special_username`.`username` AS `username`,`rdb_t_special_username`.`first_name` AS `first_name`,`rdb_t_special_username`.`last_name` AS `last_name` from `rdb_t_special_username` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `subtype_descendent_subtype`
--

/*!50001 DROP TABLE `subtype_descendent_subtype`*/;
/*!50001 DROP VIEW IF EXISTS `subtype_descendent_subtype`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `subtype_descendent_subtype` AS select `rdb_t_subt_descendent_subt`.`parent_subtype_code` AS `parent_subtype_code`,`rdb_t_subt_descendent_subt`.`child_subtype_code` AS `child_subtype_code` from `rdb_t_subt_descendent_subt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `suppressed_qualname`
--

/*!50001 DROP TABLE `suppressed_qualname`*/;
/*!50001 DROP VIEW IF EXISTS `suppressed_qualname`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `suppressed_qualname` AS select `rdb_t_suppressed_qualname`.`qualifier_id` AS `qualifier_id`,`rdb_t_suppressed_qualname`.`qualifier_name` AS `qualifier_name` from `rdb_t_suppressed_qualname` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `user_sel_criteria2`
--

/*!50001 DROP TABLE `user_sel_criteria2`*/;
/*!50001 DROP VIEW IF EXISTS `user_sel_criteria2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `user_sel_criteria2` AS select `rdb_t_user_sel_criteria2`.`selection_id` AS `selection_id`,`rdb_t_user_sel_criteria2`.`criteria_id` AS `criteria_id`,`rdb_t_user_sel_criteria2`.`username` AS `username`,`rdb_t_user_sel_criteria2`.`apply` AS `apply`,`rdb_t_user_sel_criteria2`.`value` AS `value` from `rdb_t_user_sel_criteria2` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `user_selection_criteria2`
--

/*!50001 DROP TABLE `user_selection_criteria2`*/;
/*!50001 DROP VIEW IF EXISTS `user_selection_criteria2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `user_selection_criteria2` AS select `rdb_t_user_sel_criteria2`.`selection_id` AS `selection_id`,`rdb_t_user_sel_criteria2`.`criteria_id` AS `criteria_id`,`rdb_t_user_sel_criteria2`.`username` AS `username`,`rdb_t_user_sel_criteria2`.`apply` AS `apply`,`rdb_t_user_sel_criteria2`.`value` AS `value` from `rdb_t_user_sel_criteria2` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `user_selection_set2`
--

/*!50001 DROP TABLE `user_selection_set2`*/;
/*!50001 DROP VIEW IF EXISTS `user_selection_set2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `user_selection_set2` AS select `rdb_t_user_selection_set2`.`selection_id` AS `selection_id`,`rdb_t_user_selection_set2`.`apply_username` AS `apply_username`,`rdb_t_user_selection_set2`.`default_flag` AS `default_flag`,`rdb_t_user_selection_set2`.`hide_flag` AS `hide_flag` from `rdb_t_user_selection_set2` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `viewable_category`
--

/*!50001 DROP TABLE `viewable_category`*/;
/*!50001 DROP VIEW IF EXISTS `viewable_category`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `viewable_category` AS select `rdb_v_viewable_category`.`kerberos_name` AS `kerberos_name`,`rdb_v_viewable_category`.`function_category` AS `function_category`,`rdb_v_viewable_category`.`function_category_desc` AS `function_category_desc` from `rdb_v_viewable_category` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `wh_cost_collector`
--

/*!50001 DROP TABLE `wh_cost_collector`*/;
/*!50001 DROP VIEW IF EXISTS `wh_cost_collector`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `wh_cost_collector` AS select `rdb_t_wh_cost_collector`.`cost_collector_id_with_type` AS `cost_collector_id_with_type`,`rdb_t_wh_cost_collector`.`cost_collector_id` AS `cost_collector_id`,`rdb_t_wh_cost_collector`.`cost_collector_type_desc` AS `cost_collector_type_desc`,`rdb_t_wh_cost_collector`.`cost_collector_name` AS `cost_collector_name`,`rdb_t_wh_cost_collector`.`organization_id` AS `organization_id`,`rdb_t_wh_cost_collector`.`organization_name` AS `organization_name`,`rdb_t_wh_cost_collector`.`is_closed_cost_collector` AS `is_closed_cost_collector`,`rdb_t_wh_cost_collector`.`profit_center_id` AS `profit_center_id`,`rdb_t_wh_cost_collector`.`profit_center_name` AS `profit_center_name`,`rdb_t_wh_cost_collector`.`fund_id` AS `fund_id`,`rdb_t_wh_cost_collector`.`fund_center_id` AS `fund_center_id`,`rdb_t_wh_cost_collector`.`supervisor` AS `supervisor`,`rdb_t_wh_cost_collector`.`cost_collector_effective_date` AS `cost_collector_effective_date`,`rdb_t_wh_cost_collector`.`cost_collector_expiration_date` AS `cost_collector_expiration_date`,`rdb_t_wh_cost_collector`.`term_code` AS `term_code`,`rdb_t_wh_cost_collector`.`release_strategy` AS `release_strategy`,`rdb_t_wh_cost_collector`.`supervisor_room` AS `supervisor_room`,`rdb_t_wh_cost_collector`.`addressee` AS `addressee`,`rdb_t_wh_cost_collector`.`addressee_room` AS `addressee_room`,`rdb_t_wh_cost_collector`.`supervisor_mit_id` AS `supervisor_mit_id`,`rdb_t_wh_cost_collector`.`addressee_mit_id` AS `addressee_mit_id`,`rdb_t_wh_cost_collector`.`company_code` AS `company_code`,`rdb_t_wh_cost_collector`.`admin_flag` AS `admin_flag` from `rdb_t_wh_cost_collector` */;
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

-- Dump completed on 2010-04-07 11:48:30
