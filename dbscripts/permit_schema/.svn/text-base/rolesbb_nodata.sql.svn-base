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

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_access_to_qualname`;
CREATE TABLE  `rolesbb`.`rdb_t_access_to_qualname` (
  `kerberos_name` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `qualifier_type` char(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  PRIMARY KEY (`kerberos_name`,`qualifier_type`),
  KEY `rdb_i_aq_kerbname` (`kerberos_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_application_version`;
CREATE TABLE  `rolesbb`.`rdb_t_application_version` (
  `from_platform` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `to_platform` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `from_version` varchar(10) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `to_version` varchar(10) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `message_type` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `message_text` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_auth_audit`;
CREATE TABLE  `rolesbb`.`rdb_t_auth_audit` (
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

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_auth_rule_type`;
CREATE TABLE  `rolesbb`.`rdb_t_auth_rule_type` (
  `rule_type_code` varchar(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `rule_type_short_name` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `rule_type_description` varchar(2000) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`rule_type_code`),
  KEY `rdb_uk_art_short_name` (`rule_type_short_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_authorization`;
CREATE TABLE  `rolesbb`.`rdb_t_authorization` (
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

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_category`;
CREATE TABLE  `rolesbb`.`rdb_t_category` (
  `function_category` char(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `function_category_desc` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `auths_are_sensitive` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`function_category`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_connect_log`;
CREATE TABLE  `rolesbb`.`rdb_t_connect_log` (
  `roles_username` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `connect_date` datetime NOT NULL,
  `client_version` varchar(10) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `client_platform` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `last_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `first_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `mit_id` varchar(10) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_criteria`;
CREATE TABLE  `rolesbb`.`rdb_t_criteria` (
  `criteria_id` decimal(22,0) NOT NULL,
  `criteria_name` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `sql_fragment` varchar(1000) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`criteria_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_criteria_instance`;
CREATE TABLE  `rolesbb`.`rdb_t_criteria_instance` (
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

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_criteria2`;
CREATE TABLE  `rolesbb`.`rdb_t_criteria2` (
  `criteria_id` decimal(22,0) NOT NULL,
  `criteria_name` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `sql_fragment` varchar(350) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`criteria_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_dept_approver_function`;
CREATE TABLE  `rolesbb`.`rdb_t_dept_approver_function` (
  `dept_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `function_id` int(6) NOT NULL,
  KEY `rdb_i_af_dept` (`dept_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_error_kluge`;
CREATE TABLE  `rolesbb`.`rdb_t_error_kluge` (
  `qualifier_id` bigint(12) NOT NULL,
  `qualifier_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `qualifier_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `qualifier_type` char(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `has_child` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `qualifier_level` int(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_external_auth`;
CREATE TABLE  `rolesbb`.`rdb_t_external_auth` (
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

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_external_function`;
CREATE TABLE  `rolesbb`.`rdb_t_external_function` (
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

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_extract_category`;
CREATE TABLE  `rolesbb`.`rdb_t_extract_category` (
  `username` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `function_category` char(4) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  KEY `rdb_i_ec_user` (`username`),
  KEY `rdb_i_ec_category` (`function_category`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_function`;
CREATE TABLE  `rolesbb`.`rdb_t_function` (
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

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_function_child`;
CREATE TABLE  `rolesbb`.`rdb_t_function_child` (
  `parent_id` int(6) NOT NULL,
  `child_id` int(6) NOT NULL,
  PRIMARY KEY (`parent_id`,`child_id`),
  KEY `rdb_i_fc_child_id` (`child_id`),
  KEY `rdb_i_fc_parent_id` (`parent_id`),
  CONSTRAINT `rdb_fk_fh_child_id` FOREIGN KEY (`child_id`) REFERENCES `rdb_t_function` (`function_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `rdb_fk_fh_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `rdb_t_function` (`function_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_function_group`;
CREATE TABLE  `rolesbb`.`rdb_t_function_group` (
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

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_function_group_link`;
CREATE TABLE  `rolesbb`.`rdb_t_function_group_link` (
  `parent_id` int(6) NOT NULL,
  `child_id` int(6) NOT NULL,
  PRIMARY KEY (`parent_id`,`child_id`),
  KEY `rdb_i_fgl_child_id` (`child_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_function_load_pass`;
CREATE TABLE  `rolesbb`.`rdb_t_function_load_pass` (
  `function_id` int(6) NOT NULL,
  `pass_number` int(6) DEFAULT NULL,
  PRIMARY KEY (`function_id`),
  CONSTRAINT `rdb_fk_flp_function2_id` FOREIGN KEY (`function_id`) REFERENCES `rdb_t_external_function` (`function_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_funds_cntr_release_str`;
CREATE TABLE  `rolesbb`.`rdb_t_funds_cntr_release_str` (
  `fund_center_id` varchar(9) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `release_strategy` varchar(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `modified_by` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  PRIMARY KEY (`fund_center_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_hide_default`;
CREATE TABLE  `rolesbb`.`rdb_t_hide_default` (
  `selection_id` decimal(22,0) NOT NULL,
  `apply_username` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `default_flag` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `hide_flag` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`selection_id`,`apply_username`),
  CONSTRAINT `rdb_fk_hd_selection_id` FOREIGN KEY (`selection_id`) REFERENCES `rdb_t_selection_set` (`selection_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_implied_auth_rule`;
CREATE TABLE  `rolesbb`.`rdb_t_implied_auth_rule` (
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

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_log_sql`;
CREATE TABLE  `rolesbb`.`rdb_t_log_sql` (
  `sessionid` decimal(22,0) NOT NULL,
  `username` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `log_time` datetime NOT NULL,
  `line_num` decimal(22,0) NOT NULL,
  `sql_line` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`sessionid`,`username`,`log_time`,`line_num`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_pa_group`;
CREATE TABLE  `rolesbb`.`rdb_t_pa_group` (
  `primary_auth_group` varchar(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `description` varchar(70) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `web_description` varchar(70) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `sort_order` int(6) DEFAULT NULL,
  PRIMARY KEY (`primary_auth_group`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_person`;
CREATE TABLE  `rolesbb`.`rdb_t_person` (
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

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_person_history`;
CREATE TABLE  `rolesbb`.`rdb_t_person_history` (
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

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_person_type`;
CREATE TABLE  `rolesbb`.`rdb_t_person_type` (
  `person_type` char(1) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `description` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`person_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_primary_auth_descendent`;
CREATE TABLE  `rolesbb`.`rdb_t_primary_auth_descendent` (
  `parent_id` bigint(12) NOT NULL,
  `child_id` bigint(12) NOT NULL,
  `is_dlc` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  KEY `rdb_i_pad_child` (`child_id`),
  KEY `rdb_i_pad_parent` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_qualifier`;
CREATE TABLE  `rolesbb`.`rdb_t_qualifier` (
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

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_qualifier_child`;
CREATE TABLE  `rolesbb`.`rdb_t_qualifier_child` (
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

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_qualifier_descendent`;
CREATE TABLE  `rolesbb`.`rdb_t_qualifier_descendent` (
  `parent_id` bigint(12) NOT NULL,
  `child_id` bigint(12) NOT NULL,
  KEY `idx_pid1` (`parent_id`),
  KEY `idx_cid1` (`child_id`),
  KEY `parent_id_idx` (`parent_id`),
  KEY `child_id_idx` (`child_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_qualifier_subtype`;
CREATE TABLE  `rolesbb`.`rdb_t_qualifier_subtype` (
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

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_qualifier_type`;
CREATE TABLE  `rolesbb`.`rdb_t_qualifier_type` (
  `qualifier_type` char(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `qualifier_type_desc` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `is_sensitive` varchar(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`qualifier_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_roles_parameters`;
CREATE TABLE  `rolesbb`.`rdb_t_roles_parameters` (
  `parameter` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `value` varchar(100) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `description` varchar(100) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `default_value` varchar(100) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `is_number` varchar(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `update_user` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `update_timestamp` datetime DEFAULT NULL,
  KEY `rdb_i_parameter` (`parameter`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_roles_users`;
CREATE TABLE  `rolesbb`.`rdb_t_roles_users` (
  `username` varchar(32) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `action_type` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `action_date` datetime DEFAULT NULL,
  `action_user` varchar(32) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `notes` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  KEY `rdb_i_ru_user` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_screen`;
CREATE TABLE  `rolesbb`.`rdb_t_screen` (
  `screen_id` decimal(22,0) NOT NULL,
  `screen_name` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`screen_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_screen2`;
CREATE TABLE  `rolesbb`.`rdb_t_screen2` (
  `screen_id` decimal(22,0) NOT NULL,
  `screen_name` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`screen_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_selection_criteria2`;
CREATE TABLE  `rolesbb`.`rdb_t_selection_criteria2` (
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

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_selection_set`;
CREATE TABLE  `rolesbb`.`rdb_t_selection_set` (
  `selection_id` decimal(22,0) NOT NULL,
  `selection_name` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `screen_id` decimal(22,0) NOT NULL,
  PRIMARY KEY (`selection_id`),
  KEY `rdb_fk_ss_screen_id` (`screen_id`),
  CONSTRAINT `rdb_fk_ss_screen_id` FOREIGN KEY (`screen_id`) REFERENCES `rdb_t_screen` (`screen_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_selection_set2`;
CREATE TABLE  `rolesbb`.`rdb_t_selection_set2` (
  `selection_id` decimal(22,0) NOT NULL,
  `selection_name` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `screen_id` decimal(22,0) NOT NULL,
  `sequence` int(5) DEFAULT NULL,
  PRIMARY KEY (`selection_id`),
  KEY `rdb_fk_ss2_screen_id` (`screen_id`),
  CONSTRAINT `rdb_fk_ss2_screen_id` FOREIGN KEY (`screen_id`) REFERENCES `rdb_t_screen2` (`screen_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_special_sel_set2`;
CREATE TABLE  `rolesbb`.`rdb_t_special_sel_set2` (
  `selection_id` decimal(22,0) NOT NULL,
  `program_widget_id` decimal(22,0) NOT NULL,
  `program_widget_name` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`selection_id`),
  CONSTRAINT `rdb_fk_sss_sel_id` FOREIGN KEY (`selection_id`) REFERENCES `rdb_t_selection_set2` (`selection_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_special_username`;
CREATE TABLE  `rolesbb`.`rdb_t_special_username` (
  `username` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `first_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `last_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_subt_descendent_subt`;
CREATE TABLE  `rolesbb`.`rdb_t_subt_descendent_subt` (
  `parent_subtype_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `child_subtype_code` varchar(15) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  PRIMARY KEY (`parent_subtype_code`,`child_subtype_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_suppressed_qualname`;
CREATE TABLE  `rolesbb`.`rdb_t_suppressed_qualname` (
  `qualifier_id` bigint(12) NOT NULL,
  `qualifier_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`qualifier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_temp_qual_id`;
CREATE TABLE  `rolesbb`.`rdb_t_temp_qual_id` (
  `qualifier_id` bigint(12) NOT NULL,
  `session_id` bigint(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_user_sel_criteria2`;
CREATE TABLE  `rolesbb`.`rdb_t_user_sel_criteria2` (
  `selection_id` decimal(22,0) NOT NULL,
  `criteria_id` decimal(22,0) NOT NULL,
  `username` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `apply` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `value` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`selection_id`,`criteria_id`,`username`),
  CONSTRAINT `rdb_fk_usc_sel_crit_id` FOREIGN KEY (`selection_id`, `criteria_id`) REFERENCES `rdb_t_selection_criteria2` (`selection_id`, `criteria_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_user_selection_set2`;
CREATE TABLE  `rolesbb`.`rdb_t_user_selection_set2` (
  `selection_id` decimal(22,0) NOT NULL,
  `apply_username` varchar(60) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `default_flag` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `hide_flag` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`selection_id`,`apply_username`),
  CONSTRAINT `rdb_fk_uss_selection_id` FOREIGN KEY (`selection_id`) REFERENCES `rdb_t_selection_set2` (`selection_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`rdb_t_wh_cost_collector`;
CREATE TABLE  `rolesbb`.`rdb_t_wh_cost_collector` (
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

DROP TABLE IF EXISTS `rolesbb`.`roles_error_msg`;
CREATE TABLE  `rolesbb`.`roles_error_msg` (
  `err_no` int(10) NOT NULL DEFAULT '0',
  `err_msg` varchar(255) NOT NULL,
  PRIMARY KEY (`err_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`sequence_table`;
CREATE TABLE  `rolesbb`.`sequence_table` (
  `currval` bigint(20) unsigned zerofill NOT NULL,
  `sequence_name` varchar(255) NOT NULL,
  PRIMARY KEY (`sequence_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolesbb`.`toad_plan_table`;
CREATE TABLE  `rolesbb`.`toad_plan_table` (
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

DROP VIEW IF EXISTS `rolesbb`.`access_to_qualname`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`access_to_qualname` AS select `rdb_t_access_to_qualname`.`kerberos_name` AS `kerberos_name`,`rdb_t_access_to_qualname`.`qualifier_type` AS `qualifier_type` from `rdb_t_access_to_qualname`;

DROP VIEW IF EXISTS `rolesbb`.`application_version`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`application_version` AS select `rdb_t_application_version`.`from_platform` AS `from_platform`,`rdb_t_application_version`.`to_platform` AS `to_platform`,`rdb_t_application_version`.`from_version` AS `from_version`,`rdb_t_application_version`.`to_version` AS `to_version`,`rdb_t_application_version`.`message_type` AS `message_type`,`rdb_t_application_version`.`message_text` AS `message_text` from `rdb_t_application_version`;

DROP VIEW IF EXISTS `rolesbb`.`auth_audit`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`auth_audit` AS select `rdb_t_auth_audit`.`auth_audit_id` AS `auth_audit_id`,`rdb_t_auth_audit`.`roles_username` AS `roles_username`,`rdb_t_auth_audit`.`action_date` AS `action_date`,`rdb_t_auth_audit`.`action_type` AS `action_type`,`rdb_t_auth_audit`.`old_new` AS `old_new`,`rdb_t_auth_audit`.`authorization_id` AS `authorization_id`,`rdb_t_auth_audit`.`function_id` AS `function_id`,`rdb_t_auth_audit`.`qualifier_id` AS `qualifier_id`,`rdb_t_auth_audit`.`kerberos_name` AS `kerberos_name`,`rdb_t_auth_audit`.`qualifier_code` AS `qualifier_code`,`rdb_t_auth_audit`.`function_name` AS `function_name`,`rdb_t_auth_audit`.`function_category` AS `function_category`,`rdb_t_auth_audit`.`modified_by` AS `modified_by`,`rdb_t_auth_audit`.`modified_date` AS `modified_date`,`rdb_t_auth_audit`.`do_function` AS `do_function`,`rdb_t_auth_audit`.`grant_and_view` AS `grant_and_view`,`rdb_t_auth_audit`.`descend` AS `descend`,`rdb_t_auth_audit`.`effective_date` AS `effective_date`,`rdb_t_auth_audit`.`expiration_date` AS `expiration_date`,`rdb_t_auth_audit`.`server_username` AS `server_username` from `rdb_t_auth_audit`;

DROP VIEW IF EXISTS `rolesbb`.`auth_in_qualbranch`;
CREATE ALGORITHM=UNDEFINED DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER VIEW  `rolesbb`.`auth_in_qualbranch` AS select `rdb_v_auth_in_qualbranch`.`AUTHORIZATION_ID` AS `AUTHORIZATION_ID`,`rdb_v_auth_in_qualbranch`.`FUNCTION_ID` AS `FUNCTION_ID`,`rdb_v_auth_in_qualbranch`.`QUALIFIER_ID` AS `QUALIFIER_ID`,`rdb_v_auth_in_qualbranch`.`KERBEROS_NAME` AS `KERBEROS_NAME`,`rdb_v_auth_in_qualbranch`.`QUALIFIER_CODE` AS `QUALIFIER_CODE`,`rdb_v_auth_in_qualbranch`.`FUNCTION_NAME` AS `FUNCTION_NAME`,`rdb_v_auth_in_qualbranch`.`FUNCTION_CATEGORY` AS `FUNCTION_CATEGORY`,`rdb_v_auth_in_qualbranch`.`QUALIFIER_NAME` AS `QUALIFIER_NAME`,`rdb_v_auth_in_qualbranch`.`MODIFIED_BY` AS `MODIFIED_BY`,`rdb_v_auth_in_qualbranch`.`MODIFIED_DATE` AS `MODIFIED_DATE`,`rdb_v_auth_in_qualbranch`.`DO_FUNCTION` AS `DO_FUNCTION`,`rdb_v_auth_in_qualbranch`.`GRANT_AND_VIEW` AS `GRANT_AND_VIEW`,`rdb_v_auth_in_qualbranch`.`DESCEND` AS `DESCEND`,`rdb_v_auth_in_qualbranch`.`EFFECTIVE_DATE` AS `EFFECTIVE_DATE`,`rdb_v_auth_in_qualbranch`.`EXPIRATION_DATE` AS `EXPIRATION_DATE`,`rdb_v_auth_in_qualbranch`.`dept_qual_code` AS `dept_qual_code`,`rdb_v_auth_in_qualbranch`.`QUALIFIER_TYPE` AS `QUALIFIER_TYPE` from `rdb_v_auth_in_qualbranch`;

DROP VIEW IF EXISTS `rolesbb`.`auth_rule_type`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`auth_rule_type` AS select `rdb_t_auth_rule_type`.`rule_type_code` AS `rule_type_code`,`rdb_t_auth_rule_type`.`rule_type_short_name` AS `rule_type_short_name`,`rdb_t_auth_rule_type`.`rule_type_description` AS `rule_type_description` from `rdb_t_auth_rule_type`;

DROP VIEW IF EXISTS `rolesbb`.`authorizable_function`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`authorizable_function` AS select `rdb_v_authorizable_function`.`FUNCTION_ID` AS `FUNCTION_ID` from `rdb_v_authorizable_function`;

DROP VIEW IF EXISTS `rolesbb`.`authorization`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`authorization` AS select `rdb_t_authorization`.`authorization_id` AS `authorization_id`,`rdb_t_authorization`.`function_id` AS `function_id`,`rdb_t_authorization`.`qualifier_id` AS `qualifier_id`,`rdb_t_authorization`.`kerberos_name` AS `kerberos_name`,`rdb_t_authorization`.`qualifier_code` AS `qualifier_code`,`rdb_t_authorization`.`function_name` AS `function_name`,`rdb_t_authorization`.`function_category` AS `function_category`,`rdb_t_authorization`.`qualifier_name` AS `qualifier_name`,`rdb_t_authorization`.`modified_by` AS `modified_by`,`rdb_t_authorization`.`modified_date` AS `modified_date`,`rdb_t_authorization`.`do_function` AS `do_function`,`rdb_t_authorization`.`grant_and_view` AS `grant_and_view`,`rdb_t_authorization`.`descend` AS `descend`,`rdb_t_authorization`.`effective_date` AS `effective_date`,`rdb_t_authorization`.`expiration_date` AS `expiration_date` from `rdb_t_authorization`;

DROP VIEW IF EXISTS `rolesbb`.`authorization2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`authorization2` AS select `rdb_v_authorization2`.`AUTHORIZATION_ID` AS `AUTHORIZATION_ID`,`rdb_v_authorization2`.`FUNCTION_ID` AS `FUNCTION_ID`,`rdb_v_authorization2`.`QUALIFIER_ID` AS `QUALIFIER_ID`,`rdb_v_authorization2`.`KERBEROS_NAME` AS `KERBEROS_NAME`,`rdb_v_authorization2`.`QUALIFIER_CODE` AS `QUALIFIER_CODE`,`rdb_v_authorization2`.`FUNCTION_NAME` AS `FUNCTION_NAME`,`rdb_v_authorization2`.`FUNCTION_CATEGORY` AS `FUNCTION_CATEGORY`,`rdb_v_authorization2`.`QUALIFIER_NAME` AS `QUALIFIER_NAME`,`rdb_v_authorization2`.`MODIFIED_BY` AS `MODIFIED_BY`,`rdb_v_authorization2`.`MODIFIED_DATE` AS `MODIFIED_DATE`,`rdb_v_authorization2`.`DO_FUNCTION` AS `DO_FUNCTION`,`rdb_v_authorization2`.`GRANT_AND_VIEW` AS `GRANT_AND_VIEW`,`rdb_v_authorization2`.`DESCEND` AS `DESCEND`,`rdb_v_authorization2`.`EFFECTIVE_DATE` AS `EFFECTIVE_DATE`,`rdb_v_authorization2`.`EXPIRATION_DATE` AS `EXPIRATION_DATE`,`rdb_v_authorization2`.`AUTH_TYPE` AS `AUTH_TYPE` from `rdb_v_authorization2`;

DROP VIEW IF EXISTS `rolesbb`.`category`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`category` AS select `rdb_t_category`.`function_category` AS `function_category`,`rdb_t_category`.`function_category_desc` AS `function_category_desc`,`rdb_t_category`.`auths_are_sensitive` AS `auths_are_sensitive` from `rdb_t_category`;

DROP VIEW IF EXISTS `rolesbb`.`connect_log`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`connect_log` AS select `rdb_t_connect_log`.`roles_username` AS `roles_username`,`rdb_t_connect_log`.`connect_date` AS `connect_date`,`rdb_t_connect_log`.`client_version` AS `client_version`,`rdb_t_connect_log`.`client_platform` AS `client_platform`,`rdb_t_connect_log`.`last_name` AS `last_name`,`rdb_t_connect_log`.`first_name` AS `first_name`,`rdb_t_connect_log`.`mit_id` AS `mit_id` from `rdb_t_connect_log`;

DROP VIEW IF EXISTS `rolesbb`.`criteria`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`criteria` AS select `rdb_t_criteria`.`criteria_id` AS `criteria_id`,`rdb_t_criteria`.`criteria_name` AS `criteria_name`,`rdb_t_criteria`.`sql_fragment` AS `sql_fragment` from `rdb_t_criteria`;

DROP VIEW IF EXISTS `rolesbb`.`criteria_instance`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`criteria_instance` AS select `rdb_t_criteria_instance`.`selection_id` AS `selection_id`,`rdb_t_criteria_instance`.`criteria_id` AS `criteria_id`,`rdb_t_criteria_instance`.`username` AS `username`,`rdb_t_criteria_instance`.`apply` AS `apply`,`rdb_t_criteria_instance`.`value` AS `value`,`rdb_t_criteria_instance`.`next_scrn_selection_id` AS `next_scrn_selection_id`,`rdb_t_criteria_instance`.`no_change` AS `no_change`,`rdb_t_criteria_instance`.`sequence` AS `sequence` from `rdb_t_criteria_instance`;

DROP VIEW IF EXISTS `rolesbb`.`criteria2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`criteria2` AS select `rdb_t_criteria2`.`criteria_id` AS `criteria_id`,`rdb_t_criteria2`.`criteria_name` AS `criteria_name`,`rdb_t_criteria2`.`sql_fragment` AS `sql_fragment` from `rdb_t_criteria2`;

DROP VIEW IF EXISTS `rolesbb`.`dept_approver_function`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`dept_approver_function` AS select `rdb_t_dept_approver_function`.`dept_code` AS `dept_code`,`rdb_t_dept_approver_function`.`function_id` AS `function_id` from `rdb_t_dept_approver_function`;

DROP VIEW IF EXISTS `rolesbb`.`dept_people`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`dept_people` AS select `rdb_v_dept_people`.`kerberos_name` AS `kerberos_name`,`rdb_v_dept_people`.`over_dept_code` AS `over_dept_code` from `rdb_v_dept_people`;

DROP VIEW IF EXISTS `rolesbb`.`dept_sap_auth`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`dept_sap_auth` AS select `rdb_v_dept_sap_auth`.`kerberos_name` AS `kerberos_name`,`rdb_v_dept_sap_auth`.`function_id` AS `function_id`,`rdb_v_dept_sap_auth`.`function_name` AS `function_name`,`rdb_v_dept_sap_auth`.`qualifier_id` AS `qualifier_id`,`rdb_v_dept_sap_auth`.`qualifier_code` AS `qualifier_code`,`rdb_v_dept_sap_auth`.`descend` AS `descend`,`rdb_v_dept_sap_auth`.`grant_and_view` AS `grant_and_view`,`rdb_v_dept_sap_auth`.`expiration_date` AS `expiration_date`,`rdb_v_dept_sap_auth`.`effective_date` AS `effective_date`,`rdb_v_dept_sap_auth`.`dept_fc_code` AS `dept_fc_code` from `rdb_v_dept_sap_auth`;

DROP VIEW IF EXISTS `rolesbb`.`dept_sap_auth2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`dept_sap_auth2` AS select `rdb_v_dept_sap_auth2`.`kerberos_name` AS `kerberos_name`,`rdb_v_dept_sap_auth2`.`function_id` AS `function_id`,`rdb_v_dept_sap_auth2`.`function_name` AS `function_name`,`rdb_v_dept_sap_auth2`.`qualifier_id` AS `qualifier_id`,`rdb_v_dept_sap_auth2`.`qualifier_code` AS `qualifier_code`,`rdb_v_dept_sap_auth2`.`descend` AS `descend`,`rdb_v_dept_sap_auth2`.`grant_and_view` AS `grant_and_view`,`rdb_v_dept_sap_auth2`.`expiration_date` AS `expiration_date`,`rdb_v_dept_sap_auth2`.`effective_date` AS `effective_date`,`rdb_v_dept_sap_auth2`.`dept_sg_code` AS `dept_sg_code` from `rdb_v_dept_sap_auth2`;

DROP VIEW IF EXISTS `rolesbb`.`error_kluge`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`error_kluge` AS select `rdb_t_error_kluge`.`qualifier_id` AS `qualifier_id`,`rdb_t_error_kluge`.`qualifier_code` AS `qualifier_code`,`rdb_t_error_kluge`.`qualifier_name` AS `qualifier_name`,`rdb_t_error_kluge`.`qualifier_type` AS `qualifier_type`,`rdb_t_error_kluge`.`has_child` AS `has_child`,`rdb_t_error_kluge`.`qualifier_level` AS `qualifier_level` from `rdb_t_error_kluge`;

DROP VIEW IF EXISTS `rolesbb`.`exp_auth_func_qual_lim_dept`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`exp_auth_func_qual_lim_dept` AS select `rdb_v_exp_auth_f_q_lim_dept`.`AUTHORIZATION_ID` AS `AUTHORIZATION_ID`,`rdb_v_exp_auth_f_q_lim_dept`.`FUNCTION_ID` AS `FUNCTION_ID`,`rdb_v_exp_auth_f_q_lim_dept`.`QUALIFIER_ID` AS `QUALIFIER_ID`,`rdb_v_exp_auth_f_q_lim_dept`.`KERBEROS_NAME` AS `KERBEROS_NAME`,`rdb_v_exp_auth_f_q_lim_dept`.`QUALIFIER_CODE` AS `QUALIFIER_CODE`,`rdb_v_exp_auth_f_q_lim_dept`.`FUNCTION_NAME` AS `FUNCTION_NAME`,`rdb_v_exp_auth_f_q_lim_dept`.`FUNCTION_CATEGORY` AS `FUNCTION_CATEGORY`,`rdb_v_exp_auth_f_q_lim_dept`.`QUALIFIER_NAME` AS `QUALIFIER_NAME`,`rdb_v_exp_auth_f_q_lim_dept`.`MODIFIED_BY` AS `MODIFIED_BY`,`rdb_v_exp_auth_f_q_lim_dept`.`MODIFIED_DATE` AS `MODIFIED_DATE`,`rdb_v_exp_auth_f_q_lim_dept`.`DO_FUNCTION` AS `DO_FUNCTION`,`rdb_v_exp_auth_f_q_lim_dept`.`GRANT_AND_VIEW` AS `GRANT_AND_VIEW`,`rdb_v_exp_auth_f_q_lim_dept`.`DESCEND` AS `DESCEND`,`rdb_v_exp_auth_f_q_lim_dept`.`EFFECTIVE_DATE` AS `EFFECTIVE_DATE`,`rdb_v_exp_auth_f_q_lim_dept`.`EXPIRATION_DATE` AS `EXPIRATION_DATE`,`rdb_v_exp_auth_f_q_lim_dept`.`parent_auth_id` AS `parent_auth_id`,`rdb_v_exp_auth_f_q_lim_dept`.`parent_func_id` AS `parent_func_id`,`rdb_v_exp_auth_f_q_lim_dept`.`parent_qual_id` AS `parent_qual_id`,`rdb_v_exp_auth_f_q_lim_dept`.`parent_qual_code` AS `parent_qual_code`,`rdb_v_exp_auth_f_q_lim_dept`.`parent_function_name` AS `parent_function_name`,`rdb_v_exp_auth_f_q_lim_dept`.`parent_qual_name` AS `parent_qual_name` from `rdb_v_exp_auth_f_q_lim_dept`;

DROP VIEW IF EXISTS `rolesbb`.`expanded_auth_func_qual`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`expanded_auth_func_qual` AS select `rdb_v_expanded_auth_func_qual`.`AUTHORIZATION_ID` AS `AUTHORIZATION_ID`,`rdb_v_expanded_auth_func_qual`.`FUNCTION_ID` AS `FUNCTION_ID`,`rdb_v_expanded_auth_func_qual`.`QUALIFIER_ID` AS `QUALIFIER_ID`,`rdb_v_expanded_auth_func_qual`.`KERBEROS_NAME` AS `KERBEROS_NAME`,`rdb_v_expanded_auth_func_qual`.`QUALIFIER_CODE` AS `QUALIFIER_CODE`,`rdb_v_expanded_auth_func_qual`.`FUNCTION_NAME` AS `FUNCTION_NAME`,`rdb_v_expanded_auth_func_qual`.`FUNCTION_CATEGORY` AS `FUNCTION_CATEGORY`,`rdb_v_expanded_auth_func_qual`.`QUALIFIER_NAME` AS `QUALIFIER_NAME`,`rdb_v_expanded_auth_func_qual`.`QUALIFIER_TYPE` AS `QUALIFIER_TYPE`,`rdb_v_expanded_auth_func_qual`.`MODIFIED_BY` AS `MODIFIED_BY`,`rdb_v_expanded_auth_func_qual`.`MODIFIED_DATE` AS `MODIFIED_DATE`,`rdb_v_expanded_auth_func_qual`.`DO_FUNCTION` AS `DO_FUNCTION`,`rdb_v_expanded_auth_func_qual`.`GRANT_AND_VIEW` AS `GRANT_AND_VIEW`,`rdb_v_expanded_auth_func_qual`.`DESCEND` AS `DESCEND`,`rdb_v_expanded_auth_func_qual`.`EFFECTIVE_DATE` AS `EFFECTIVE_DATE`,`rdb_v_expanded_auth_func_qual`.`EXPIRATION_DATE` AS `EXPIRATION_DATE`,`rdb_v_expanded_auth_func_qual`.`parent_auth_id` AS `parent_auth_id`,`rdb_v_expanded_auth_func_qual`.`parent_func_id` AS `parent_func_id`,`rdb_v_expanded_auth_func_qual`.`parent_qual_id` AS `parent_qual_id`,`rdb_v_expanded_auth_func_qual`.`parent_qual_code` AS `parent_qual_code`,`rdb_v_expanded_auth_func_qual`.`parent_function_name` AS `parent_function_name`,`rdb_v_expanded_auth_func_qual`.`parent_qual_name` AS `parent_qual_name`,`rdb_v_expanded_auth_func_qual`.`is_in_effect` AS `is_in_effect` from `rdb_v_expanded_auth_func_qual`;

DROP VIEW IF EXISTS `rolesbb`.`expanded_auth_no_root`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`expanded_auth_no_root` AS select `rdb_v_expanded_auth_no_root`.`kerberos_name` AS `kerberos_name`,`rdb_v_expanded_auth_no_root`.`function_id` AS `function_id`,`rdb_v_expanded_auth_no_root`.`function_name` AS `function_name`,`rdb_v_expanded_auth_no_root`.`qualifier_code` AS `qualifier_code` from `rdb_v_expanded_auth_no_root`;

DROP VIEW IF EXISTS `rolesbb`.`expanded_auth2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`expanded_auth2` AS select `rdb_v_expanded_auth2`.`authorization_id` AS `authorization_id`,`rdb_v_expanded_auth2`.`function_id` AS `function_id`,`rdb_v_expanded_auth2`.`qualifier_id` AS `qualifier_id`,`rdb_v_expanded_auth2`.`kerberos_name` AS `kerberos_name`,`rdb_v_expanded_auth2`.`qualifier_code` AS `qualifier_code`,`rdb_v_expanded_auth2`.`function_name` AS `function_name`,`rdb_v_expanded_auth2`.`function_category` AS `function_category`,`rdb_v_expanded_auth2`.`qualifier_name` AS `qualifier_name`,`rdb_v_expanded_auth2`.`modified_by` AS `modified_by`,`rdb_v_expanded_auth2`.`modified_date` AS `modified_date`,`rdb_v_expanded_auth2`.`do_function` AS `do_function`,`rdb_v_expanded_auth2`.`grant_and_view` AS `grant_and_view`,`rdb_v_expanded_auth2`.`descend` AS `descend`,`rdb_v_expanded_auth2`.`effective_date` AS `effective_date`,`rdb_v_expanded_auth2`.`expiration_date` AS `expiration_date`,`rdb_v_expanded_auth2`.`qualifier_type` AS `qualifier_type`,`rdb_v_expanded_auth2`.`virtual_or_real` AS `virtual_or_real` from `rdb_v_expanded_auth2`;

DROP VIEW IF EXISTS `rolesbb`.`expanded_authorization`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`expanded_authorization` AS select `rdb_v_expanded_authorization`.`kerberos_name` AS `kerberos_name`,`rdb_v_expanded_authorization`.`function_id` AS `function_id`,`rdb_v_expanded_authorization`.`function_name` AS `function_name`,`rdb_v_expanded_authorization`.`qualifier_code` AS `qualifier_code` from `rdb_v_expanded_authorization`;

DROP VIEW IF EXISTS `rolesbb`.`external_auth`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`external_auth` AS select `rdb_t_external_auth`.`authorization_id` AS `authorization_id`,`rdb_t_external_auth`.`function_id` AS `function_id`,`rdb_t_external_auth`.`qualifier_id` AS `qualifier_id`,`rdb_t_external_auth`.`kerberos_name` AS `kerberos_name`,`rdb_t_external_auth`.`qualifier_code` AS `qualifier_code`,`rdb_t_external_auth`.`function_name` AS `function_name`,`rdb_t_external_auth`.`function_category` AS `function_category`,`rdb_t_external_auth`.`qualifier_name` AS `qualifier_name`,`rdb_t_external_auth`.`modified_by` AS `modified_by`,`rdb_t_external_auth`.`modified_date` AS `modified_date`,`rdb_t_external_auth`.`do_function` AS `do_function`,`rdb_t_external_auth`.`grant_and_view` AS `grant_and_view`,`rdb_t_external_auth`.`descend` AS `descend`,`rdb_t_external_auth`.`effective_date` AS `effective_date`,`rdb_t_external_auth`.`expiration_date` AS `expiration_date` from `rdb_t_external_auth`;

DROP VIEW IF EXISTS `rolesbb`.`external_function`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`external_function` AS select `rdb_t_external_function`.`function_id` AS `function_id`,`rdb_t_external_function`.`function_name` AS `function_name`,`rdb_t_external_function`.`function_description` AS `function_description`,`rdb_t_external_function`.`function_category` AS `function_category`,`rdb_t_external_function`.`creator` AS `creator`,`rdb_t_external_function`.`modified_by` AS `modified_by`,`rdb_t_external_function`.`modified_date` AS `modified_date`,`rdb_t_external_function`.`qualifier_type` AS `qualifier_type`,`rdb_t_external_function`.`primary_authorizable` AS `primary_authorizable` from `rdb_t_external_function`;

DROP VIEW IF EXISTS `rolesbb`.`extract_auth`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`extract_auth` AS select `rdb_v_extract_auth`.`KERBEROS_NAME` AS `KERBEROS_NAME`,`rdb_v_extract_auth`.`FUNCTION_NAME` AS `FUNCTION_NAME`,`rdb_v_extract_auth`.`QUALIFIER_CODE` AS `QUALIFIER_CODE`,`rdb_v_extract_auth`.`FUNCTION_CATEGORY` AS `FUNCTION_CATEGORY`,`rdb_v_extract_auth`.`DESCEND` AS `DESCEND`,`rdb_v_extract_auth`.`EFFECTIVE_DATE` AS `EFFECTIVE_DATE`,`rdb_v_extract_auth`.`EXPIRATION_DATE` AS `EXPIRATION_DATE` from `rdb_v_extract_auth`;

DROP VIEW IF EXISTS `rolesbb`.`extract_category`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`extract_category` AS select `rdb_t_extract_category`.`username` AS `username`,`rdb_t_extract_category`.`function_category` AS `function_category` from `rdb_t_extract_category`;

DROP VIEW IF EXISTS `rolesbb`.`extract_desc`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`extract_desc` AS select `rdb_v_extract_desc`.`PARENT_CODE` AS `PARENT_CODE`,`rdb_v_extract_desc`.`CHILD_CODE` AS `CHILD_CODE` from `rdb_v_extract_desc`;

DROP VIEW IF EXISTS `rolesbb`.`function`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`function` AS select `rdb_t_function`.`function_id` AS `function_id`,`rdb_t_function`.`function_name` AS `function_name`,`rdb_t_function`.`function_description` AS `function_description`,`rdb_t_function`.`function_category` AS `function_category`,`rdb_t_function`.`creator` AS `creator`,`rdb_t_function`.`modified_by` AS `modified_by`,`rdb_t_function`.`modified_date` AS `modified_date`,`rdb_t_function`.`qualifier_type` AS `qualifier_type`,`rdb_t_function`.`primary_authorizable` AS `primary_authorizable`,`rdb_t_function`.`is_primary_auth_parent` AS `is_primary_auth_parent`,`rdb_t_function`.`primary_auth_group` AS `primary_auth_group` from `rdb_t_function`;

DROP VIEW IF EXISTS `rolesbb`.`function_child`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`function_child` AS select `rdb_t_function_child`.`parent_id` AS `parent_id`,`rdb_t_function_child`.`child_id` AS `child_id` from `rdb_t_function_child`;

DROP VIEW IF EXISTS `rolesbb`.`function_group`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`function_group` AS select `rdb_t_function_group`.`function_group_id` AS `function_group_id`,`rdb_t_function_group`.`function_group_name` AS `function_group_name`,`rdb_t_function_group`.`function_group_desc` AS `function_group_desc`,`rdb_t_function_group`.`function_category` AS `function_category`,`rdb_t_function_group`.`matches_a_function` AS `matches_a_function`,`rdb_t_function_group`.`qualifier_type` AS `qualifier_type`,`rdb_t_function_group`.`modified_by` AS `modified_by`,`rdb_t_function_group`.`modified_date` AS `modified_date` from `rdb_t_function_group`;

DROP VIEW IF EXISTS `rolesbb`.`function_group_link`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`function_group_link` AS select `rdb_t_function_group_link`.`parent_id` AS `parent_id`,`rdb_t_function_group_link`.`child_id` AS `child_id` from `rdb_t_function_group_link`;

DROP VIEW IF EXISTS `rolesbb`.`function_load_pass`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`function_load_pass` AS select `rdb_t_function_load_pass`.`function_id` AS `function_id`,`rdb_t_function_load_pass`.`pass_number` AS `pass_number` from `rdb_t_function_load_pass`;

DROP VIEW IF EXISTS `rolesbb`.`function2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`function2` AS select `rdb_v_function2`.`function_id` AS `function_id`,`rdb_v_function2`.`function_name` AS `function_name`,`rdb_v_function2`.`function_description` AS `function_description`,`rdb_v_function2`.`function_category` AS `function_category`,`rdb_v_function2`.`modified_by` AS `modified_by`,`rdb_v_function2`.`modified_date` AS `modified_date`,`rdb_v_function2`.`qualifier_type` AS `qualifier_type`,`rdb_v_function2`.`primary_authorizable` AS `primary_authorizable`,`rdb_v_function2`.`is_primary_auth_parent` AS `is_primary_auth_parent`,`rdb_v_function2`.`primary_auth_group` AS `primary_auth_group`,`rdb_v_function2`.`real_or_external` AS `real_or_external` from `rdb_v_function2`;

DROP VIEW IF EXISTS `rolesbb`.`funds_cntr_release_str`;
CREATE ALGORITHM=UNDEFINED DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER VIEW  `rolesbb`.`funds_cntr_release_str` AS select `rdb_t_funds_cntr_release_str`.`fund_center_id` AS `fund_center_id`,`rdb_t_funds_cntr_release_str`.`release_strategy` AS `release_strategy`,`rdb_t_funds_cntr_release_str`.`modified_by` AS `modified_by`,`rdb_t_funds_cntr_release_str`.`modified_date` AS `modified_date` from `rdb_t_funds_cntr_release_str`;

DROP VIEW IF EXISTS `rolesbb`.`hide_default`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`hide_default` AS select `rdb_t_hide_default`.`selection_id` AS `selection_id`,`rdb_t_hide_default`.`apply_username` AS `apply_username`,`rdb_t_hide_default`.`default_flag` AS `default_flag`,`rdb_t_hide_default`.`hide_flag` AS `hide_flag` from `rdb_t_hide_default`;

DROP VIEW IF EXISTS `rolesbb`.`implied_auth_rule`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`implied_auth_rule` AS select `rdb_t_implied_auth_rule`.`rule_id` AS `rule_id`,`rdb_t_implied_auth_rule`.`rule_type_code` AS `rule_type_code`,`rdb_t_implied_auth_rule`.`condition_function_or_group` AS `condition_function_or_group`,`rdb_t_implied_auth_rule`.`condition_function_category` AS `condition_function_category`,`rdb_t_implied_auth_rule`.`condition_function_name` AS `condition_function_name`,`rdb_t_implied_auth_rule`.`condition_obj_type` AS `condition_obj_type`,`rdb_t_implied_auth_rule`.`condition_qual_code` AS `condition_qual_code`,`rdb_t_implied_auth_rule`.`result_function_category` AS `result_function_category`,`rdb_t_implied_auth_rule`.`result_function_name` AS `result_function_name`,`rdb_t_implied_auth_rule`.`auth_parent_obj_type` AS `auth_parent_obj_type`,`rdb_t_implied_auth_rule`.`result_qualifier_code` AS `result_qualifier_code`,`rdb_t_implied_auth_rule`.`rule_short_name` AS `rule_short_name`,`rdb_t_implied_auth_rule`.`rule_description` AS `rule_description`,`rdb_t_implied_auth_rule`.`rule_is_in_effect` AS `rule_is_in_effect`,`rdb_t_implied_auth_rule`.`modified_by` AS `modified_by`,`rdb_t_implied_auth_rule`.`modified_date` AS `modified_date` from `rdb_t_implied_auth_rule`;

DROP VIEW IF EXISTS `rolesbb`.`pa_group`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`pa_group` AS select `rdb_t_pa_group`.`primary_auth_group` AS `primary_auth_group`,`rdb_t_pa_group`.`description` AS `description`,`rdb_t_pa_group`.`web_description` AS `web_description`,`rdb_t_pa_group`.`sort_order` AS `sort_order` from `rdb_t_pa_group`;

DROP VIEW IF EXISTS `rolesbb`.`people_who_can_spend`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`people_who_can_spend` AS select `rdb_v_people_who_can_spend`.`kerberos_name` AS `kerberos_name`,`rdb_v_people_who_can_spend`.`function_id` AS `function_id`,`rdb_v_people_who_can_spend`.`function_name` AS `function_name`,`rdb_v_people_who_can_spend`.`qualifier_id` AS `qualifier_id`,`rdb_v_people_who_can_spend`.`qualifier_code` AS `qualifier_code`,`rdb_v_people_who_can_spend`.`descend` AS `descend`,`rdb_v_people_who_can_spend`.`grant_and_view` AS `grant_and_view`,`rdb_v_people_who_can_spend`.`spendable_fund` AS `spendable_fund` from `rdb_v_people_who_can_spend`;

DROP VIEW IF EXISTS `rolesbb`.`person`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`person` AS select `rdb_t_person`.`mit_id` AS `mit_id`,`rdb_t_person`.`last_name` AS `last_name`,`rdb_t_person`.`first_name` AS `first_name`,`rdb_t_person`.`kerberos_name` AS `kerberos_name`,`rdb_t_person`.`email_addr` AS `email_addr`,`rdb_t_person`.`dept_code` AS `dept_code`,`rdb_t_person`.`primary_person_type` AS `primary_person_type`,`rdb_t_person`.`org_unit_id` AS `org_unit_id`,`rdb_t_person`.`active` AS `active`,`rdb_t_person`.`status_code` AS `status_code`,`rdb_t_person`.`status_date` AS `status_date` from `rdb_t_person`;

DROP VIEW IF EXISTS `rolesbb`.`person_history`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`person_history` AS select `rdb_t_person_history`.`kerberos_name` AS `kerberos_name`,`rdb_t_person_history`.`mit_id` AS `mit_id`,`rdb_t_person_history`.`last_name` AS `last_name`,`rdb_t_person_history`.`first_name` AS `first_name`,`rdb_t_person_history`.`middle_name` AS `middle_name`,`rdb_t_person_history`.`unit_code` AS `unit_code`,`rdb_t_person_history`.`unit_name` AS `unit_name`,`rdb_t_person_history`.`person_type` AS `person_type`,`rdb_t_person_history`.`begin_date` AS `begin_date`,`rdb_t_person_history`.`end_date` AS `end_date` from `rdb_t_person_history`;

DROP VIEW IF EXISTS `rolesbb`.`person_type`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`person_type` AS select `rdb_t_person_type`.`person_type` AS `person_type`,`rdb_t_person_type`.`description` AS `description` from `rdb_t_person_type`;

DROP VIEW IF EXISTS `rolesbb`.`pickable_auth_category`;
CREATE ALGORITHM=UNDEFINED DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER VIEW  `rolesbb`.`pickable_auth_category` AS select `rdb_v_pickable_auth_category`.`kerberos_name` AS `kerberos_name`,`rdb_v_pickable_auth_category`.`function_category` AS `function_category`,`rdb_v_pickable_auth_category`.`function_category_desc` AS `function_category_desc` from `rdb_v_pickable_auth_category`;

DROP VIEW IF EXISTS `rolesbb`.`pickable_auth_function`;
CREATE ALGORITHM=UNDEFINED DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER VIEW  `rolesbb`.`pickable_auth_function` AS select `rdb_v_pickable_auth_function`.`kerberos_name` AS `kerberos_name`,`rdb_v_pickable_auth_function`.`function_id` AS `function_id`,`rdb_v_pickable_auth_function`.`function_name` AS `function_name`,`rdb_v_pickable_auth_function`.`function_category` AS `function_category`,`rdb_v_pickable_auth_function`.`qualifier_type` AS `qualifier_type`,`rdb_v_pickable_auth_function`.`function_description` AS `function_description` from `rdb_v_pickable_auth_function`;

DROP VIEW IF EXISTS `rolesbb`.`pickable_auth_qual_top`;
CREATE ALGORITHM=UNDEFINED DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER VIEW  `rolesbb`.`pickable_auth_qual_top` AS select `rdb_v_pickable_auth_qual_top`.`kerberos_name` AS `kerberos_name`,`rdb_v_pickable_auth_qual_top`.`function_name` AS `function_name`,`rdb_v_pickable_auth_qual_top`.`function_id` AS `function_id`,`rdb_v_pickable_auth_qual_top`.`qualifier_type` AS `qualifier_type`,`rdb_v_pickable_auth_qual_top`.`qualifier_code` AS `qualifier_code`,`rdb_v_pickable_auth_qual_top`.`qualifier_id` AS `qualifier_id` from `rdb_v_pickable_auth_qual_top`;

DROP VIEW IF EXISTS `rolesbb`.`primary_auth_descendent`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`primary_auth_descendent` AS select `rdb_t_primary_auth_descendent`.`parent_id` AS `parent_id`,`rdb_t_primary_auth_descendent`.`child_id` AS `child_id`,`rdb_t_primary_auth_descendent`.`is_dlc` AS `is_dlc` from `rdb_t_primary_auth_descendent`;

DROP VIEW IF EXISTS `rolesbb`.`qualifier`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`qualifier` AS select `rdb_t_qualifier`.`qualifier_id` AS `qualifier_id`,`rdb_t_qualifier`.`qualifier_code` AS `qualifier_code`,`rdb_t_qualifier`.`qualifier_name` AS `qualifier_name`,`rdb_t_qualifier`.`qualifier_type` AS `qualifier_type`,`rdb_t_qualifier`.`has_child` AS `has_child`,`rdb_t_qualifier`.`qualifier_level` AS `qualifier_level`,`rdb_t_qualifier`.`custom_hierarchy` AS `custom_hierarchy`,`rdb_t_qualifier`.`status` AS `status`,`rdb_t_qualifier`.`last_modified_date` AS `last_modified_date` from `rdb_t_qualifier`;

DROP VIEW IF EXISTS `rolesbb`.`qualifier_child`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`qualifier_child` AS select `rdb_t_qualifier_child`.`parent_id` AS `parent_id`,`rdb_t_qualifier_child`.`child_id` AS `child_id` from `rdb_t_qualifier_child`;

DROP VIEW IF EXISTS `rolesbb`.`qualifier_descendent`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`qualifier_descendent` AS select `rdb_t_qualifier_descendent`.`parent_id` AS `parent_id`,`rdb_t_qualifier_descendent`.`child_id` AS `child_id` from `rdb_t_qualifier_descendent`;

DROP VIEW IF EXISTS `rolesbb`.`qualifier_subtype`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`qualifier_subtype` AS select `rdb_t_qualifier_subtype`.`qualifier_subtype_code` AS `qualifier_subtype_code`,`rdb_t_qualifier_subtype`.`parent_qualifier_type` AS `parent_qualifier_type`,`rdb_t_qualifier_subtype`.`qualifier_subtype_name` AS `qualifier_subtype_name`,`rdb_t_qualifier_subtype`.`contains_string` AS `contains_string`,`rdb_t_qualifier_subtype`.`min_allowable_qualifier_code` AS `min_allowable_qualifier_code`,`rdb_t_qualifier_subtype`.`max_allowable_qualifier_code` AS `max_allowable_qualifier_code` from `rdb_t_qualifier_subtype`;

DROP VIEW IF EXISTS `rolesbb`.`qualifier_type`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`qualifier_type` AS select `rdb_t_qualifier_type`.`qualifier_type` AS `qualifier_type`,`rdb_t_qualifier_type`.`qualifier_type_desc` AS `qualifier_type_desc`,`rdb_t_qualifier_type`.`is_sensitive` AS `is_sensitive` from `rdb_t_qualifier_type`;

DROP VIEW IF EXISTS `rolesbb`.`qualifier2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`qualifier2` AS select `rdb_v_qualifier2`.`QUALIFIER_ID` AS `QUALIFIER_ID`,`rdb_v_qualifier2`.`QUALIFIER_CODE` AS `QUALIFIER_CODE`,`rdb_v_qualifier2`.`QUALIFIER_NAME` AS `QUALIFIER_NAME`,`rdb_v_qualifier2`.`QUALIFIER_TYPE` AS `QUALIFIER_TYPE`,`rdb_v_qualifier2`.`HAS_CHILD` AS `HAS_CHILD`,`rdb_v_qualifier2`.`QUALIFIER_LEVEL` AS `QUALIFIER_LEVEL`,`rdb_v_qualifier2`.`CUSTOM_HIERARCHY` AS `CUSTOM_HIERARCHY` from `rdb_v_qualifier2`;

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_auth_in_qualbranch`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_auth_in_qualbranch` AS select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`a`.`function_id` AS `FUNCTION_ID`,`a`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`a`.`qualifier_code` AS `QUALIFIER_CODE`,`a`.`function_name` AS `FUNCTION_NAME`,`a`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`q`.`qualifier_code` AS `dept_qual_code`,`q`.`qualifier_type` AS `QUALIFIER_TYPE` from (`authorization` `a` join `qualifier` `q`) where (`a`.`qualifier_id` = `q`.`qualifier_id`) union select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`a`.`function_id` AS `FUNCTION_ID`,`a`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`a`.`qualifier_code` AS `QUALIFIER_CODE`,`a`.`function_name` AS `FUNCTION_NAME`,`a`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`q`.`qualifier_code` AS `dept_qual_code`,`q`.`qualifier_type` AS `QUALIFIER_TYPE` from ((`authorization` `a` join `qualifier_descendent` `qd`) join `qualifier` `q`) where ((`a`.`descend` = _latin1'Y') and (`a`.`qualifier_id` = `qd`.`child_id`) and (`qd`.`parent_id` = `q`.`qualifier_id`));

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_authorizable_function`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_authorizable_function` AS select distinct `function`.`function_id` AS `FUNCTION_ID` from `function` where exists(select `authorization`.`kerberos_name` AS `kerberos_name` from `authorization` where ((`authorization`.`function_category` = _latin1'META') and (`authorization`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and (`authorization`.`kerberos_name` = current_user()) and (`authorization`.`qualifier_code` = _latin1'CATALL') and (`authorization`.`effective_date` <= now()) and (ifnull(`authorization`.`expiration_date`,now()) >= now()))) union select distinct `function`.`function_id` AS `function_id` from `function` where `function`.`function_category` in (select rpad(substr(`authorization`.`qualifier_code`,4),4,_latin1' ') AS `rpad(substr(qualifier_code,4),4,' ')` from `authorization` where ((`authorization`.`function_category` = _latin1'META') and (`authorization`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and (`authorization`.`kerberos_name` = current_user()) and (`authorization`.`effective_date` <= now()) and (ifnull(`authorization`.`expiration_date`,now()) >= now()))) union select `f`.`function_id` AS `function_id` from `function` `f` where ((`f`.`primary_authorizable` = _latin1'Y') and exists(select `a`.`authorization_id` AS `authorization_id` from `authorization` `a` where ((`a`.`kerberos_name` = current_user()) and (`a`.`function_name` = _latin1'PRIMARY AUTHORIZOR') and (`a`.`effective_date` <= now()) and (ifnull(`a`.`expiration_date`,now()) >= now()) and (`a`.`do_function` = _latin1'Y')))) union select `f`.`function_id` AS `function_id` from ((`authorization` `a` join `dept_approver_function` `d`) join `function` `f`) where ((`a`.`kerberos_name` = current_user()) and (`a`.`function_name` = _latin1'PRIMARY AUTHORIZOR') and (`a`.`effective_date` <= now()) and (ifnull(`a`.`expiration_date`,now()) >= now()) and (`a`.`do_function` = _latin1'Y') and (`d`.`dept_code` = `a`.`qualifier_code`) and (`f`.`function_id` = `d`.`function_id`)) union select `f2`.`function_id` AS `function_id` from ((`authorization` `a` join `function` `f1`) join `function` `f2`) where ((`f1`.`function_name` = `a`.`function_name`) and (`f1`.`is_primary_auth_parent` = _latin1'Y') and (`a`.`kerberos_name` = current_user()) and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`f2`.`primary_authorizable` = _latin1'Y') and (`f2`.`primary_auth_group` = `f1`.`primary_auth_group`)) union select `f2`.`function_id` AS `function_id` from (((`authorization` `a` join `dept_approver_function` `d`) join `function` `f1`) join `function` `f2`) where ((`f1`.`function_name` = `a`.`function_name`) and (`f1`.`is_primary_auth_parent` = _latin1'Y') and (`a`.`kerberos_name` = current_user()) and (`a`.`effective_date` <= now()) and (ifnull(`a`.`expiration_date`,now()) >= now()) and (`a`.`do_function` = _latin1'Y') and (`f2`.`primary_auth_group` = `f1`.`primary_auth_group`) and (`d`.`dept_code` = `a`.`qualifier_code`) and (`f2`.`function_id` = `d`.`function_id`)) union select distinct `authorization`.`function_id` AS `function_id` from `authorization` where ((`authorization`.`kerberos_name` = current_user()) and (`authorization`.`grant_and_view` in (_latin1'GV',_latin1'GD')) and (`authorization`.`effective_date` <= now()) and (ifnull(`authorization`.`expiration_date`,now()) >= now()));

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_authorization2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_authorization2` AS select `rdb_t_authorization`.`authorization_id` AS `AUTHORIZATION_ID`,`rdb_t_authorization`.`function_id` AS `FUNCTION_ID`,`rdb_t_authorization`.`qualifier_id` AS `QUALIFIER_ID`,`rdb_t_authorization`.`kerberos_name` AS `KERBEROS_NAME`,`rdb_t_authorization`.`qualifier_code` AS `QUALIFIER_CODE`,`rdb_t_authorization`.`function_name` AS `FUNCTION_NAME`,`rdb_t_authorization`.`function_category` AS `FUNCTION_CATEGORY`,`rdb_t_authorization`.`qualifier_name` AS `QUALIFIER_NAME`,`rdb_t_authorization`.`modified_by` AS `MODIFIED_BY`,`rdb_t_authorization`.`modified_date` AS `MODIFIED_DATE`,`rdb_t_authorization`.`do_function` AS `DO_FUNCTION`,`rdb_t_authorization`.`grant_and_view` AS `GRANT_AND_VIEW`,`rdb_t_authorization`.`descend` AS `DESCEND`,`rdb_t_authorization`.`effective_date` AS `EFFECTIVE_DATE`,`rdb_t_authorization`.`expiration_date` AS `EXPIRATION_DATE`,_utf8'R' AS `AUTH_TYPE` from `rdb_t_authorization` union all select `rdb_t_external_auth`.`authorization_id` AS `authorization_id`,`rdb_t_external_auth`.`function_id` AS `function_id`,`rdb_t_external_auth`.`qualifier_id` AS `qualifier_id`,`rdb_t_external_auth`.`kerberos_name` AS `kerberos_name`,`rdb_t_external_auth`.`qualifier_code` AS `qualifier_code`,`rdb_t_external_auth`.`function_name` AS `function_name`,`rdb_t_external_auth`.`function_category` AS `function_category`,`rdb_t_external_auth`.`qualifier_name` AS `qualifier_name`,`rdb_t_external_auth`.`modified_by` AS `modified_by`,`rdb_t_external_auth`.`modified_date` AS `modified_date`,`rdb_t_external_auth`.`do_function` AS `do_function`,`rdb_t_external_auth`.`grant_and_view` AS `grant_and_view`,`rdb_t_external_auth`.`descend` AS `descend`,`rdb_t_external_auth`.`effective_date` AS `effective_date`,`rdb_t_external_auth`.`expiration_date` AS `expiration_date`,_utf8'E' AS `auth_type` from `rdb_t_external_auth`;

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_dept_people`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_dept_people` AS select `p`.`kerberos_name` AS `kerberos_name`,`q1`.`qualifier_code` AS `over_dept_code` from (((`person` `p` join `qualifier` `q1`) join `qualifier_descendent` `qd`) join `qualifier` `q2`) where ((`p`.`dept_code` = `q2`.`qualifier_code`) and (`q1`.`qualifier_id` = `qd`.`parent_id`) and (`qd`.`child_id` = `q2`.`qualifier_id`) and (`q1`.`qualifier_type` = _latin1'ORGU')) union select `p`.`kerberos_name` AS `kerberos_name`,`p`.`dept_code` AS `over_dept_code` from `person` `p`;

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_dept_sap_auth`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_dept_sap_auth` AS select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`a`.`qualifier_id` AS `qualifier_id`,`a`.`qualifier_code` AS `qualifier_code`,`a`.`descend` AS `descend`,`a`.`grant_and_view` AS `grant_and_view`,`a`.`expiration_date` AS `expiration_date`,`a`.`effective_date` AS `effective_date`,`q`.`qualifier_code` AS `dept_fc_code` from ((`authorization` `a` join `qualifier` `q`) join `qualifier_descendent` `qd`) where ((`a`.`function_category` = _latin1'SAP') and (`a`.`function_name` = _latin1'CAN SPEND OR COMMIT FUNDS') and (`a`.`qualifier_id` = `qd`.`child_id`) and (`qd`.`parent_id` = `q`.`qualifier_id`) and (`q`.`qualifier_type` = _latin1'FUND')) union select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`a`.`qualifier_id` AS `qualifier_id`,`a`.`qualifier_code` AS `qualifier_code`,`a`.`descend` AS `descend`,`a`.`grant_and_view` AS `grant_and_view`,`a`.`expiration_date` AS `expiration_date`,`a`.`effective_date` AS `effective_date`,`a`.`qualifier_code` AS `dept_fc_code` from `authorization` `a` where ((`a`.`function_category` = _latin1'SAP') and (`a`.`function_name` = _latin1'CAN SPEND OR COMMIT FUNDS'));

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_dept_sap_auth2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_dept_sap_auth2` AS select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`a`.`qualifier_id` AS `qualifier_id`,`a`.`qualifier_code` AS `qualifier_code`,`a`.`descend` AS `descend`,`a`.`grant_and_view` AS `grant_and_view`,`a`.`expiration_date` AS `expiration_date`,`a`.`effective_date` AS `effective_date`,`q`.`qualifier_code` AS `dept_sg_code` from ((`authorization` `a` join `qualifier` `q`) join `qualifier_descendent` `qd`) where ((`a`.`function_category` = _latin1'SAP') and (`a`.`function_name` like _latin1'%APPROVER%') and (`a`.`qualifier_id` = `qd`.`child_id`) and (`qd`.`parent_id` = `q`.`qualifier_id`) and (`q`.`qualifier_type` = _latin1'SPGP')) union select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`a`.`qualifier_id` AS `qualifier_id`,`a`.`qualifier_code` AS `qualifier_code`,`a`.`descend` AS `descend`,`a`.`grant_and_view` AS `grant_and_view`,`a`.`expiration_date` AS `expiration_date`,`a`.`effective_date` AS `effective_date`,`a`.`qualifier_code` AS `dept_sg_code` from `authorization` `a` where ((`a`.`function_category` = _latin1'SAP') and (`a`.`function_name` like _latin1'%APPROVER%'));

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_exp_auth_f_q_lim_dept`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_exp_auth_f_q_lim_dept` AS select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`a`.`function_id` AS `FUNCTION_ID`,`a`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`a`.`qualifier_code` AS `QUALIFIER_CODE`,`a`.`function_name` AS `FUNCTION_NAME`,`a`.`function_category` AS `FUNCTION_CATEGORY`,`a`.`qualifier_name` AS `QUALIFIER_NAME`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`a`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`a`.`qualifier_name` AS `parent_qual_name` from `authorization` `a` union select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`a`.`function_id` AS `FUNCTION_ID`,`q`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`q`.`qualifier_code` AS `QUALIFIER_CODE`,`a`.`function_name` AS `FUNCTION_NAME`,`a`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`a`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`a`.`qualifier_name` AS `parent_qual_name` from ((`authorization` `a` join `qualifier_descendent` `qd`) join `qualifier` `q`) where ((`qd`.`parent_id` = `a`.`qualifier_id`) and (`q`.`qualifier_id` = `qd`.`child_id`) and (substr(`q`.`qualifier_code`,1,2) in (_latin1'D_',_latin1'NU'))) union select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`f2`.`function_id` AS `FUNCTION_ID`,`a`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`a`.`qualifier_code` AS `QUALIFIER_CODE`,`f2`.`function_name` AS `FUNCTION_NAME`,`f2`.`function_category` AS `FUNCTION_CATEGORY`,`a`.`qualifier_name` AS `QUALIFIER_NAME`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`a`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`a`.`qualifier_name` AS `parent_qual_name` from ((`authorization` `a` join `function_child` `fc`) join `function` `f2`) where ((`fc`.`parent_id` = `a`.`function_id`) and (`f2`.`function_id` = `fc`.`child_id`)) union select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`f2`.`function_id` AS `FUNCTION_ID`,`q`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`q`.`qualifier_code` AS `QUALIFIER_CODE`,`f2`.`function_name` AS `FUNCTION_NAME`,`f2`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`a`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`a`.`qualifier_name` AS `parent_qual_name` from ((((`function` `f2` join `function_child` `fc`) join `authorization` `a`) join `qualifier_descendent` `qd`) join `qualifier` `q`) where ((`qd`.`parent_id` = `a`.`qualifier_id`) and (`q`.`qualifier_id` = `qd`.`child_id`) and (substr(`q`.`qualifier_code`,1,2) in (_latin1'D_',_latin1'NU')) and (`fc`.`parent_id` = `a`.`function_id`) and (`f2`.`function_id` = `fc`.`child_id`));

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_expanded_auth_func_qual`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_expanded_auth_func_qual` AS select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`a`.`function_id` AS `FUNCTION_ID`,`a`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`q`.`qualifier_code` AS `QUALIFIER_CODE`,`a`.`function_name` AS `FUNCTION_NAME`,`a`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`q`.`qualifier_type` AS `QUALIFIER_TYPE`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`q`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`q`.`qualifier_name` AS `parent_qual_name`,elt(sign((now() - `a`.`effective_date`)),-(1),_latin1'N',elt(sign((ifnull(`a`.`expiration_date`,now()) - now())),-(1),_latin1'N',`a`.`do_function`)) AS `is_in_effect` from (`authorization` `a` join `qualifier` `q`) where (`q`.`qualifier_id` = `a`.`qualifier_id`) union select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`a`.`function_id` AS `FUNCTION_ID`,`q`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`q`.`qualifier_code` AS `QUALIFIER_CODE`,`a`.`function_name` AS `FUNCTION_NAME`,`a`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`q`.`qualifier_type` AS `QUALIFIER_TYPE`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`a`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`a`.`qualifier_name` AS `parent_qual_name`,elt(sign((now() - `a`.`effective_date`)),-(1),_latin1'N',elt(sign((ifnull(`a`.`expiration_date`,now()) - now())),-(1),_latin1'N',`a`.`do_function`)) AS `is_in_effect` from ((`authorization` `a` join `qualifier_descendent` `qd`) join `qualifier` `q`) where ((`qd`.`parent_id` = `a`.`qualifier_id`) and (`q`.`qualifier_id` = `qd`.`child_id`)) union select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`f2`.`function_id` AS `FUNCTION_ID`,`a`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`q`.`qualifier_code` AS `QUALIFIER_CODE`,`f2`.`function_name` AS `FUNCTION_NAME`,`f2`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`q`.`qualifier_type` AS `QUALIFIER_TYPE`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`q`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`q`.`qualifier_name` AS `parent_qual_name`,elt(sign((now() - `a`.`effective_date`)),-(1),_latin1'N',elt(sign((ifnull(`a`.`expiration_date`,now()) - now())),-(1),_latin1'N',`a`.`do_function`)) AS `is_in_effect` from (((`authorization` `a` join `function_child` `fc`) join `function` `f2`) join `qualifier` `q`) where ((`fc`.`parent_id` = `a`.`function_id`) and (`f2`.`function_id` = `fc`.`child_id`) and (`q`.`qualifier_id` = `a`.`qualifier_id`) and (`q`.`qualifier_type` = `f2`.`qualifier_type`)) union select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`f2`.`function_id` AS `FUNCTION_ID`,`q`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`q`.`qualifier_code` AS `QUALIFIER_CODE`,`f2`.`function_name` AS `FUNCTION_NAME`,`f2`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`q`.`qualifier_type` AS `QUALIFIER_TYPE`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`a`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`a`.`qualifier_name` AS `parent_qual_name`,elt(sign((now() - `a`.`effective_date`)),-(1),_latin1'N',elt(sign((ifnull(`a`.`expiration_date`,now()) - now())),-(1),_latin1'N',`a`.`do_function`)) AS `is_in_effect` from ((((`function` `f2` join `function_child` `fc`) join `authorization` `a`) join `qualifier_descendent` `qd`) join `qualifier` `q`) where ((`qd`.`parent_id` = `a`.`qualifier_id`) and (`q`.`qualifier_id` = `qd`.`child_id`) and (`fc`.`parent_id` = `a`.`function_id`) and (`f2`.`function_id` = `fc`.`child_id`) and (`q`.`qualifier_type` = `f2`.`qualifier_type`) and (`a`.`descend` = _latin1'Y'));

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_expanded_auth_func_root`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_expanded_auth_func_root` AS select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`a`.`function_id` AS `FUNCTION_ID`,`a`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`a`.`qualifier_code` AS `QUALIFIER_CODE`,`a`.`function_name` AS `FUNCTION_NAME`,`a`.`function_category` AS `FUNCTION_CATEGORY`,`a`.`qualifier_name` AS `QUALIFIER_NAME`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`a`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`a`.`qualifier_name` AS `parent_qual_name` from (`authorization` `a` join `qualifier` `q`) where ((`a`.`qualifier_id` = `q`.`qualifier_id`) and (`q`.`qualifier_level` = 1)) union select `a`.`authorization_id` AS `AUTHORIZATION_ID`,`f2`.`function_id` AS `FUNCTION_ID`,`a`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`a`.`qualifier_code` AS `QUALIFIER_CODE`,`f2`.`function_name` AS `FUNCTION_NAME`,`f2`.`function_category` AS `FUNCTION_CATEGORY`,`a`.`qualifier_name` AS `QUALIFIER_NAME`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`a`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`a`.`qualifier_name` AS `parent_qual_name` from (((`authorization` `a` join `qualifier` `q`) join `function_child` `fc`) join `function` `f2`) where ((`q`.`qualifier_id` = `a`.`qualifier_id`) and (`q`.`qualifier_level` = 1) and (`fc`.`parent_id` = `a`.`function_id`) and (`f2`.`function_id` = `fc`.`child_id`));

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_expanded_auth_no_root`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_expanded_auth_no_root` AS select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`q`.`qualifier_code` AS `qualifier_code` from (`rdb_t_authorization` `a` join `rdb_t_qualifier` `q`) where (`a`.`function_category` in (select `rdb_t_extract_category`.`function_category` AS `function_category` from `rdb_t_extract_category` where (`rdb_t_extract_category`.`username` = current_user())) and (`a`.`qualifier_id` = `q`.`qualifier_id`) and (`a`.`descend` = _latin1'Y') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`q`.`qualifier_level` <> 1) and (`q`.`has_child` = _latin1'N')) union select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`q`.`qualifier_code` AS `qualifier_code` from ((((`rdb_t_authorization` `a` join `rdb_t_qualifier_descendent` `qd`) join `rdb_t_qualifier` `q`) join `rdb_t_qualifier` `q0`) join `rdb_t_extract_category` `e`) where ((`q0`.`qualifier_id` = `a`.`qualifier_id`) and (`q0`.`qualifier_level` <> 1) and (`e`.`username` = current_user()) and (`a`.`function_category` = `e`.`function_category`) and (`a`.`qualifier_id` = `qd`.`parent_id`) and (`a`.`descend` = _latin1'Y') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`qd`.`child_id` = `q`.`qualifier_id`) and (`q`.`has_child` = _latin1'N'));

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_expanded_auth2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_expanded_auth2` AS select `a`.`authorization_id` AS `authorization_id`,`a`.`function_id` AS `function_id`,`a`.`qualifier_id` AS `qualifier_id`,`a`.`kerberos_name` AS `kerberos_name`,`q0`.`qualifier_code` AS `qualifier_code`,`a`.`function_name` AS `function_name`,`a`.`function_category` AS `function_category`,`q0`.`qualifier_name` AS `qualifier_name`,`a`.`modified_by` AS `modified_by`,`a`.`modified_date` AS `modified_date`,`a`.`do_function` AS `do_function`,`a`.`grant_and_view` AS `grant_and_view`,`a`.`descend` AS `descend`,`a`.`effective_date` AS `effective_date`,`a`.`expiration_date` AS `expiration_date`,`q0`.`qualifier_type` AS `qualifier_type`,_utf8'R' AS `virtual_or_real` from (`rdb_t_authorization` `a` join `rdb_t_qualifier` `q0`) where (`q0`.`qualifier_id` = `a`.`qualifier_id`) union select `a`.`authorization_id` AS `authorization_id`,`a`.`function_id` AS `function_id`,`q`.`qualifier_id` AS `qualifier_id`,`a`.`kerberos_name` AS `kerberos_name`,`q`.`qualifier_code` AS `qualifier_code`,`a`.`function_name` AS `function_name`,`a`.`function_category` AS `function_category`,`q`.`qualifier_name` AS `qualifier_name`,`a`.`modified_by` AS `modified_by`,`a`.`modified_date` AS `modified_date`,`a`.`do_function` AS `do_function`,`a`.`grant_and_view` AS `grant_and_view`,`a`.`descend` AS `descend`,`a`.`effective_date` AS `effective_date`,`a`.`expiration_date` AS `expiration_date`,`q0`.`qualifier_type` AS `qualifier_type`,_utf8'V' AS `virtual_or_real` from (((`rdb_t_authorization` `a` join `rdb_t_qualifier` `q0`) join `rdb_t_qualifier_descendent` `qd`) join `rdb_t_qualifier` `q`) where ((`q0`.`qualifier_id` = `a`.`qualifier_id`) and (`q0`.`qualifier_level` <> 1) and (`qd`.`parent_id` = `a`.`qualifier_id`) and (`a`.`descend` = _latin1'Y') and (`q`.`qualifier_id` = `qd`.`child_id`));

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_expanded_authorization`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_expanded_authorization` AS select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`q`.`qualifier_code` AS `qualifier_code` from ((`rdb_t_authorization` `a` join `rdb_t_qualifier` `q`) join `rdb_t_extract_category` `e`) where ((`a`.`function_category` = `e`.`function_category`) and (`e`.`username` = current_user()) and (`a`.`qualifier_id` = `q`.`qualifier_id`) and (`a`.`descend` = _latin1'Y') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`q`.`has_child` = _latin1'N')) union select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`q`.`qualifier_code` AS `qualifier_code` from (((`rdb_t_authorization` `a` join `rdb_t_qualifier_descendent` `qd`) join `rdb_t_qualifier` `q`) join `rdb_t_extract_category` `e`) where ((`a`.`function_category` = `e`.`function_category`) and (`e`.`username` = current_user()) and (`a`.`qualifier_id` = `qd`.`parent_id`) and (`a`.`descend` = _latin1'Y') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`qd`.`child_id` = `q`.`qualifier_id`) and (`q`.`has_child` = _latin1'N'));

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_extract_auth`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_extract_auth` AS select `authorization`.`kerberos_name` AS `KERBEROS_NAME`,`authorization`.`function_name` AS `FUNCTION_NAME`,`authorization`.`qualifier_code` AS `QUALIFIER_CODE`,`authorization`.`function_category` AS `FUNCTION_CATEGORY`,`authorization`.`descend` AS `DESCEND`,`authorization`.`effective_date` AS `EFFECTIVE_DATE`,`authorization`.`expiration_date` AS `EXPIRATION_DATE` from `authorization` where ((`authorization`.`do_function` = _latin1'Y') and `authorization`.`function_category` in (select `rdb_t_extract_category`.`function_category` AS `function_category` from `rdb_t_extract_category` where (current_user() = `rdb_t_extract_category`.`username`)));

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_extract_desc`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_extract_desc` AS select `p`.`qualifier_code` AS `PARENT_CODE`,`c`.`qualifier_code` AS `CHILD_CODE` from ((`qualifier` `p` join `qualifier_descendent` `d`) join `qualifier` `c`) where ((`p`.`qualifier_id` = `d`.`parent_id`) and (`c`.`qualifier_id` = `d`.`child_id`) and `d`.`parent_id` in (select distinct `authorization`.`qualifier_id` AS `QUALIFIER_ID` from `authorization` where `authorization`.`function_category` in (select `rdb_t_extract_category`.`function_category` AS `function_category` from `rdb_t_extract_category` where (current_user() = `rdb_t_extract_category`.`username`))));

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_function2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_function2` AS select `rdb_t_function`.`function_id` AS `function_id`,`rdb_t_function`.`function_name` AS `function_name`,`rdb_t_function`.`function_description` AS `function_description`,`rdb_t_function`.`function_category` AS `function_category`,`rdb_t_function`.`modified_by` AS `modified_by`,`rdb_t_function`.`modified_date` AS `modified_date`,`rdb_t_function`.`qualifier_type` AS `qualifier_type`,`rdb_t_function`.`primary_authorizable` AS `primary_authorizable`,`rdb_t_function`.`is_primary_auth_parent` AS `is_primary_auth_parent`,`rdb_t_function`.`primary_auth_group` AS `primary_auth_group`,_utf8'R' AS `real_or_external` from `rdb_t_function` union all select `rdb_t_external_function`.`function_id` AS `function_id`,`rdb_t_external_function`.`function_name` AS `function_name`,`rdb_t_external_function`.`function_description` AS `function_description`,`rdb_t_external_function`.`function_category` AS `function_category`,`rdb_t_external_function`.`modified_by` AS `modified_by`,`rdb_t_external_function`.`modified_date` AS `modified_date`,`rdb_t_external_function`.`qualifier_type` AS `qualifier_type`,`rdb_t_external_function`.`primary_authorizable` AS `primary_authorizable`,NULL AS `is_primary_auth_parent`,NULL AS `primary_auth_group`,_utf8'X' AS `real_or_external` from `rdb_t_external_function`;

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_people_who_can_spend`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_people_who_can_spend` AS select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`a`.`qualifier_id` AS `qualifier_id`,`a`.`qualifier_code` AS `qualifier_code`,`a`.`descend` AS `descend`,`a`.`grant_and_view` AS `grant_and_view`,`q`.`qualifier_code` AS `spendable_fund` from ((`authorization` `a` join `qualifier` `q`) join `qualifier_descendent` `qd`) where ((`a`.`function_category` = _latin1'SAP') and (`a`.`function_name` = _latin1'CAN SPEND OR COMMIT FUNDS') and (`a`.`qualifier_id` = `qd`.`parent_id`) and (`qd`.`child_id` = `q`.`qualifier_id`) and (`q`.`qualifier_type` = _latin1'FUND') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`a`.`do_function` = _latin1'Y')) union select `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_id` AS `function_id`,`a`.`function_name` AS `function_name`,`a`.`qualifier_id` AS `qualifier_id`,`a`.`qualifier_code` AS `qualifier_code`,`a`.`descend` AS `descend`,`a`.`grant_and_view` AS `grant_and_view`,`a`.`qualifier_code` AS `spendable_fund` from `authorization` `a` where ((`a`.`function_category` = _latin1'SAP') and (`a`.`function_name` = _latin1'CAN SPEND OR COMMIT FUNDS') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`a`.`do_function` = _latin1'Y'));

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_person`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_person` AS select _utf8'MIT_ID' AS `MIT_ID`,_utf8'LAST_NAME' AS `LAST_NAME`,_utf8'FIRST_NAME' AS `FIRST_NAME`,_utf8'KERBEROS_NAME' AS `KERBEROS_NAME`,_utf8'EMAIL_ADDR' AS `EMAIL_ADDR`,_utf8'DEPT_CODE' AS `DEPT_CODE`,_utf8'PRIMARY_PERSON_TYPE' AS `PRIMARY_PERSON_TYPE`,_utf8'ORG_UNIT_ID' AS `ORG_UNIT_ID`,_utf8'ACTIVE' AS `ACTIVE`,_utf8'STATUS_CODE' AS `STATUS_CODE`,_utf8'STATUS_DATE' AS `STATUS_DATE` from `rdb_t_person`;

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_pickable_auth_category`;
CREATE ALGORITHM=UNDEFINED DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_pickable_auth_category` AS select `a`.`kerberos_name` AS `kerberos_name`,`c`.`function_category` AS `function_category`,`c`.`function_category_desc` AS `function_category_desc` from (`authorization` `a` join `category` `c`) where ((`a`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and (`a`.`qualifier_code` <> _latin1'CATALL') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`c`.`function_category` = substr(concat(`a`.`qualifier_code`,_latin1'   '),4,4))) union select `a`.`kerberos_name` AS `kerberos_name`,`c`.`function_category` AS `function_category`,`c`.`function_category_desc` AS `function_category_desc` from (((`authorization` `a` join `qualifier_descendent` `qd`) join `qualifier` `q`) join `category` `c`) where ((`a`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`qd`.`parent_id` = `a`.`qualifier_id`) and (`q`.`qualifier_id` = `qd`.`child_id`) and (`c`.`function_category` = substr(concat(`q`.`qualifier_code`,_latin1'   '),4,4))) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`f2`.`function_category` AS `function_category`,`c`.`function_category_desc` AS `function_category_desc` from (((`authorization` `a` join `function` `f1`) join `function` `f2`) join `category` `c`) where ((`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`f1`.`function_id` = `a`.`function_id`) and (`f1`.`is_primary_auth_parent` = _latin1'Y') and (`f2`.`primary_authorizable` in (_latin1'Y',_latin1'D')) and (`f2`.`primary_auth_group` = `f1`.`primary_auth_group`) and (`c`.`function_category` = `f2`.`function_category`)) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`a`.`function_category` AS `function_category`,`c`.`function_category_desc` AS `function_category_desc` from (`authorization` `a` join `category` `c`) where ((`a`.`grant_and_view` in (_latin1'GV',_latin1'GD')) and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`c`.`function_category` = `a`.`function_category`));

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_pickable_auth_function`;
CREATE ALGORITHM=UNDEFINED DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_pickable_auth_function` AS select distinct `a`.`kerberos_name` AS `kerberos_name`,`f`.`function_id` AS `function_id`,`f`.`function_name` AS `function_name`,`f`.`function_category` AS `function_category`,`f`.`qualifier_type` AS `qualifier_type`,`f`.`function_description` AS `function_description` from (`authorization` `a` join `function` `f`) where ((`a`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and (`a`.`qualifier_code` <> _latin1'CATALL') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`f`.`function_category` = substr(concat(`a`.`qualifier_code`,_latin1'  '),4,4))) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`f`.`function_id` AS `function_id`,`f`.`function_name` AS `function_name`,`f`.`function_category` AS `function_category`,`f`.`qualifier_type` AS `qualifier_type`,`f`.`function_description` AS `function_description` from (((`authorization` `a` join `qualifier_descendent` `qd`) join `qualifier` `q`) join `function` `f`) where ((`a`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`qd`.`parent_id` = `a`.`qualifier_id`) and (`q`.`qualifier_id` = `qd`.`child_id`) and (`f`.`function_category` = substr(concat(`q`.`qualifier_code`,_latin1'  '),4,4))) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`f2`.`function_id` AS `function_id`,`f2`.`function_name` AS `function_name`,`f2`.`function_category` AS `function_category`,`f2`.`qualifier_type` AS `qualifier_type`,`f2`.`function_description` AS `function_description` from ((`authorization` `a` join `function` `f1`) join `function` `f2`) where ((`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`f1`.`function_id` = `a`.`function_id`) and (`f1`.`is_primary_auth_parent` = _latin1'Y') and (`f2`.`primary_authorizable` in (_latin1'Y',_latin1'D')) and (`f2`.`primary_auth_group` = `f1`.`primary_auth_group`)) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`f`.`function_id` AS `function_id`,`f`.`function_name` AS `function_name`,`f`.`function_category` AS `function_category`,`f`.`qualifier_type` AS `qualifier_type`,`f`.`function_description` AS `function_description` from (`authorization` `a` join `function` `f`) where ((`a`.`grant_and_view` in (_latin1'GV',_latin1'GD')) and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`f`.`function_id` = `a`.`function_id`));

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_pickable_auth_qual_top`;
CREATE ALGORITHM=UNDEFINED DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_pickable_auth_qual_top` AS select distinct `a`.`kerberos_name` AS `kerberos_name`,`f`.`function_name` AS `function_name`,`f`.`function_id` AS `function_id`,`f`.`qualifier_type` AS `qualifier_type`,`q`.`qualifier_code` AS `qualifier_code`,`q`.`qualifier_id` AS `qualifier_id` from ((`authorization` `a` join `function` `f`) join `qualifier` `q`) where ((`a`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and (`a`.`qualifier_code` <> _latin1'CATALL') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`f`.`function_category` = substr(concat(`a`.`qualifier_code`,_latin1'   '),4,4)) and (`q`.`qualifier_type` = `f`.`qualifier_type`) and (`q`.`qualifier_level` = 1)) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`f`.`function_name` AS `function_name`,`f`.`function_id` AS `function_id`,`f`.`qualifier_type` AS `qualifier_type`,`q`.`qualifier_code` AS `qualifier_code`,`q`.`qualifier_id` AS `qualifier_id` from ((((`authorization` `a` join `qualifier_descendent` `qd`) join `qualifier` `q0`) join `function` `f`) join `qualifier` `q`) where ((`a`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`qd`.`parent_id` = `a`.`qualifier_id`) and (`q0`.`qualifier_id` = `qd`.`child_id`) and (`f`.`function_category` = substr(concat(`q0`.`qualifier_code`,_latin1'   '),4,4)) and (`q`.`qualifier_type` = `f`.`qualifier_type`) and (`q`.`qualifier_level` = 1)) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`f2`.`function_name` AS `function_name`,`f2`.`function_id` AS `function_id`,`f2`.`qualifier_type` AS `qualifier_type`,`q`.`qualifier_code` AS `qualifier_code`,`q`.`qualifier_id` AS `qualifier_id` from ((((((`authorization` `a` join `function` `f1`) join `function` `f2`) join `qualifier` `q0`) join `qualifier_descendent` `qd`) join `qualifier` `q1`) join `qualifier` `q`) where ((`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`f1`.`function_id` = `a`.`function_id`) and (`f1`.`is_primary_auth_parent` = _latin1'Y') and (`f2`.`primary_authorizable` in (_latin1'Y',_latin1'D')) and (`f2`.`primary_auth_group` = `f1`.`primary_auth_group`) and (`q0`.`qualifier_type` = _latin1'DEPT') and (`q0`.`qualifier_code` = `a`.`qualifier_code`) and (`qd`.`parent_id` = `q0`.`qualifier_id`) and (`q1`.`qualifier_id` = `qd`.`child_id`) and (`q`.`qualifier_type` = `f2`.`qualifier_type`) and (`q`.`qualifier_code` = `q1`.`qualifier_code`) and (not(exists(select 1 AS `1` from `authorization` `a2` where ((`a2`.`kerberos_name` = `a`.`kerberos_name`) and (`a2`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and ((`a2`.`qualifier_code` = concat(_latin1'CAT',rtrim(`f2`.`function_category`))) or (`a2`.`qualifier_code` = _latin1'CATALL')) and (`a2`.`do_function` = _latin1'Y') and (now() between `a2`.`effective_date` and ifnull(`a2`.`expiration_date`,now()))))))) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`f2`.`function_name` AS `function_name`,`f2`.`function_id` AS `function_id`,`f2`.`qualifier_type` AS `qualifier_type`,`q`.`qualifier_code` AS `qualifier_code`,`q`.`qualifier_id` AS `qualifier_id` from (((`authorization` `a` join `function` `f1`) join `function` `f2`) join `qualifier` `q`) where ((`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`f1`.`function_id` = `a`.`function_id`) and (`f1`.`is_primary_auth_parent` = _latin1'Y') and (`f2`.`primary_authorizable` in (_latin1'Y',_latin1'D')) and (`f2`.`primary_auth_group` = `f1`.`primary_auth_group`) and (`f2`.`qualifier_type` = _latin1'NULL') and (`q`.`qualifier_type` = `f2`.`qualifier_type`) and (`q`.`qualifier_code` = _latin1'NULL') and (not(exists(select 1 AS `1` from `authorization` `a2` where ((`a2`.`kerberos_name` = `a`.`kerberos_name`) and (`a2`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and ((`a2`.`qualifier_code` = concat(_latin1'CAT',rtrim(`f2`.`function_category`))) or (`a2`.`qualifier_code` = _latin1'CATALL')) and (`a2`.`do_function` = _latin1'Y') and (now() between `a2`.`effective_date` and ifnull(`a2`.`expiration_date`,now()))))))) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`f`.`function_name` AS `function_name`,`f`.`function_id` AS `function_id`,`f`.`qualifier_type` AS `qualifier_type`,`q`.`qualifier_code` AS `qualifier_code`,`q`.`qualifier_id` AS `qualifier_id` from ((`authorization` `a` join `function` `f`) join `qualifier` `q`) where ((`a`.`grant_and_view` in (_latin1'GV',_latin1'GD')) and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`f`.`function_id` = `a`.`function_id`) and (`q`.`qualifier_id` = `a`.`qualifier_id`) and (not(exists(select 1 AS `1` from `authorization` `a2` where ((`a2`.`kerberos_name` = `a`.`kerberos_name`) and (`a2`.`function_name` = _latin1'CREATE AUTHORIZATIONS') and ((`a2`.`qualifier_code` = concat(_latin1'CAT',rtrim(`f`.`function_category`))) or (`a2`.`qualifier_code` = _latin1'CATALL')) and (`a2`.`do_function` = _latin1'Y') and (now() between `a2`.`effective_date` and ifnull(`a2`.`expiration_date`,now())))))));

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_qualifier2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_qualifier2` AS select `q`.`qualifier_id` AS `QUALIFIER_ID`,`q`.`qualifier_code` AS `QUALIFIER_CODE`,elt(ifnull(`aq`.`kerberos_name`,_latin1' '),current_user(),`sqn`.`qualifier_name`,`q`.`qualifier_name`) AS `QUALIFIER_NAME`,`q`.`qualifier_type` AS `QUALIFIER_TYPE`,`q`.`has_child` AS `HAS_CHILD`,`q`.`qualifier_level` AS `QUALIFIER_LEVEL`,`q`.`custom_hierarchy` AS `CUSTOM_HIERARCHY` from (`suppressed_qualname` `sqn` join (`access_to_qualname` `aq` left join `qualifier` `q` on((`aq`.`qualifier_type` = `q`.`qualifier_type`)))) where ((`sqn`.`qualifier_id` = `q`.`qualifier_id`) and (`aq`.`kerberos_name` = current_user()));

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_viewable_category`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_viewable_category` AS select `a`.`kerberos_name` AS `kerberos_name`,rpad(substr(`a`.`qualifier_code`,4),4,_latin1' ') AS `function_category`,`c`.`function_category_desc` AS `function_category_desc` from (`authorization` `a` join `category` `c`) where ((`a`.`function_name` in (_latin1'VIEW AUTH BY CATEGORY',_latin1'CREATE AUTHORIZATIONS')) and (`a`.`do_function` = _latin1'Y') and (`a`.`qualifier_code` <> _latin1'CATALL') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`c`.`function_category` = rpad(substr(`a`.`qualifier_code`,4),4,_latin1' '))) union select `a`.`kerberos_name` AS `kerberos_name`,rpad(substr(`q`.`qualifier_code`,4),4,_latin1' ') AS `function_category`,`c`.`function_category_desc` AS `function_category_desc` from (((`authorization` `a` join `qualifier_descendent` `qd`) join `qualifier` `q`) join `category` `c`) where ((`a`.`function_name` in (_latin1'VIEW AUTH BY CATEGORY',_latin1'CREATE AUTHORIZATIONS')) and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`qd`.`parent_id` = `a`.`qualifier_id`) and (`q`.`qualifier_id` = `qd`.`child_id`) and (`c`.`function_category` = rpad(substr(`q`.`qualifier_code`,4),4,_latin1' '))) union select distinct `a`.`kerberos_name` AS `kerberos_name`,rpad(`c`.`function_category`,4,_latin1' ') AS `function_category`,`c`.`function_category_desc` AS `function_category_desc` from (`authorization` `a` join `category` `c`) where ((`a`.`function_category` in (_latin1'SAP',_latin1'HR',_latin1'PAYR')) and (`a`.`do_function` = _latin1'Y') and (now() between `a`.`effective_date` and ifnull(`a`.`expiration_date`,now())) and (`c`.`function_category` in (_latin1'SAP',_latin1'LABD',_latin1'ADMN',_latin1'HR',_latin1'META',_latin1'PAYR'))) union select distinct `a`.`kerberos_name` AS `kerberos_name`,`f2`.`function_category` AS `function_category`,`c`.`function_category_desc` AS `function_category_desc` from (((`authorization` `a` join `function` `f1`) join `function` `f2`) join `category` `c`) where ((`f1`.`function_id` = `a`.`function_id`) and (`f1`.`is_primary_auth_parent` = _latin1'Y') and (`f2`.`primary_auth_group` = `f1`.`primary_auth_group`) and (`f2`.`primary_authorizable` in (_latin1'D',_latin1'Y')) and (`c`.`function_category` = `f2`.`function_category`));

DROP VIEW IF EXISTS `rolesbb`.`rdb_v_xexpanded_auth_func_qual`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`rdb_v_xexpanded_auth_func_qual` AS select distinct `a`.`authorization_id` AS `AUTHORIZATION_ID`,`f2`.`function_id` AS `FUNCTION_ID`,`a`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`q`.`qualifier_code` AS `QUALIFIER_CODE`,`f2`.`function_name` AS `FUNCTION_NAME`,`f2`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`q`.`qualifier_type` AS `QUALIFIER_TYPE`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`q`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`q`.`qualifier_name` AS `parent_qual_name` from ((((`authorization` `a` join `function_child` `fc`) join `function` `f2`) join `qualifier` `q`) join `function` `f1`) where ((`fc`.`parent_id` = `a`.`function_id`) and (`f2`.`function_id` = `fc`.`child_id`) and (`q`.`qualifier_code` = `a`.`qualifier_code`) and (`q`.`qualifier_type` = `f2`.`qualifier_type`) and (`f1`.`function_id` = `a`.`function_id`) and (`f1`.`qualifier_type` <> `f2`.`qualifier_type`)) union select distinct `a`.`authorization_id` AS `AUTHORIZATION_ID`,`f2`.`function_id` AS `FUNCTION_ID`,`q`.`qualifier_id` AS `QUALIFIER_ID`,`a`.`kerberos_name` AS `KERBEROS_NAME`,`q`.`qualifier_code` AS `QUALIFIER_CODE`,`f2`.`function_name` AS `FUNCTION_NAME`,`f2`.`function_category` AS `FUNCTION_CATEGORY`,`q`.`qualifier_name` AS `QUALIFIER_NAME`,`q`.`qualifier_type` AS `QUALIFIER_TYPE`,`a`.`modified_by` AS `MODIFIED_BY`,`a`.`modified_date` AS `MODIFIED_DATE`,`a`.`do_function` AS `DO_FUNCTION`,`a`.`grant_and_view` AS `GRANT_AND_VIEW`,`a`.`descend` AS `DESCEND`,`a`.`effective_date` AS `EFFECTIVE_DATE`,`a`.`expiration_date` AS `EXPIRATION_DATE`,`a`.`authorization_id` AS `parent_auth_id`,`a`.`function_id` AS `parent_func_id`,`a`.`qualifier_id` AS `parent_qual_id`,`q`.`qualifier_code` AS `parent_qual_code`,`a`.`function_name` AS `parent_function_name`,`q`.`qualifier_name` AS `parent_qual_name` from ((((((`authorization` `a` join `function_child` `fc`) join `function` `f2`) join `qualifier` `q0`) join `qualifier_descendent` `qd`) join `qualifier` `q`) join `function` `f1`) where ((`fc`.`parent_id` = `a`.`function_id`) and (`f2`.`function_id` = `fc`.`child_id`) and (`q0`.`qualifier_code` = `a`.`qualifier_code`) and (`q0`.`qualifier_type` = `f2`.`qualifier_type`) and (`qd`.`parent_id` = `q0`.`qualifier_id`) and (`q`.`qualifier_id` = `qd`.`child_id`) and (`f1`.`function_id` = `a`.`function_id`) and (`f1`.`qualifier_type` <> `f2`.`qualifier_type`));

DROP VIEW IF EXISTS `rolesbb`.`roles_parameters`;
CREATE ALGORITHM=UNDEFINED DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER VIEW  `rolesbb`.`roles_parameters` AS select `rdb_t_roles_parameters`.`parameter` AS `parameter`,`rdb_t_roles_parameters`.`value` AS `value`,`rdb_t_roles_parameters`.`description` AS `description`,`rdb_t_roles_parameters`.`default_value` AS `default_value`,`rdb_t_roles_parameters`.`is_number` AS `is_number`,`rdb_t_roles_parameters`.`update_user` AS `update_user`,`rdb_t_roles_parameters`.`update_timestamp` AS `update_timestamp` from `rdb_t_roles_parameters`;

DROP VIEW IF EXISTS `rolesbb`.`roles_users`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`roles_users` AS select `rdb_t_roles_users`.`username` AS `username`,`rdb_t_roles_users`.`action_type` AS `action_type`,`rdb_t_roles_users`.`action_date` AS `action_date`,`rdb_t_roles_users`.`action_user` AS `action_user`,`rdb_t_roles_users`.`notes` AS `notes` from `rdb_t_roles_users`;

DROP VIEW IF EXISTS `rolesbb`.`screen`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`screen` AS select `rdb_t_screen`.`screen_id` AS `screen_id`,`rdb_t_screen`.`screen_name` AS `screen_name` from `rdb_t_screen`;

DROP VIEW IF EXISTS `rolesbb`.`screen2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`screen2` AS select `rdb_t_screen2`.`screen_id` AS `screen_id`,`rdb_t_screen2`.`screen_name` AS `screen_name` from `rdb_t_screen2`;

DROP VIEW IF EXISTS `rolesbb`.`selection_criteria2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`selection_criteria2` AS select `rdb_t_selection_criteria2`.`selection_id` AS `selection_id`,`rdb_t_selection_criteria2`.`criteria_id` AS `criteria_id`,`rdb_t_selection_criteria2`.`default_apply` AS `default_apply`,`rdb_t_selection_criteria2`.`default_value` AS `default_value`,`rdb_t_selection_criteria2`.`next_scrn_selection_id` AS `next_scrn_selection_id`,`rdb_t_selection_criteria2`.`no_change` AS `no_change`,`rdb_t_selection_criteria2`.`sequence` AS `sequence` from `rdb_t_selection_criteria2`;

DROP VIEW IF EXISTS `rolesbb`.`selection_set`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`selection_set` AS select `rdb_t_selection_set`.`selection_id` AS `selection_id`,`rdb_t_selection_set`.`selection_name` AS `selection_name`,`rdb_t_selection_set`.`screen_id` AS `screen_id` from `rdb_t_selection_set`;

DROP VIEW IF EXISTS `rolesbb`.`selection_set2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`selection_set2` AS select `rdb_t_selection_set2`.`selection_id` AS `selection_id`,`rdb_t_selection_set2`.`selection_name` AS `selection_name`,`rdb_t_selection_set2`.`screen_id` AS `screen_id`,`rdb_t_selection_set2`.`sequence` AS `sequence` from `rdb_t_selection_set2`;

DROP VIEW IF EXISTS `rolesbb`.`special_selection_set2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`special_selection_set2` AS select `rdb_t_special_sel_set2`.`selection_id` AS `selection_id`,`rdb_t_special_sel_set2`.`program_widget_id` AS `program_widget_id`,`rdb_t_special_sel_set2`.`program_widget_name` AS `program_widget_name` from `rdb_t_special_sel_set2`;

DROP VIEW IF EXISTS `rolesbb`.`special_username`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`special_username` AS select `rdb_t_special_username`.`username` AS `username`,`rdb_t_special_username`.`first_name` AS `first_name`,`rdb_t_special_username`.`last_name` AS `last_name` from `rdb_t_special_username`;

DROP VIEW IF EXISTS `rolesbb`.`subtype_descendent_subtype`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`subtype_descendent_subtype` AS select `rdb_t_subt_descendent_subt`.`parent_subtype_code` AS `parent_subtype_code`,`rdb_t_subt_descendent_subt`.`child_subtype_code` AS `child_subtype_code` from `rdb_t_subt_descendent_subt`;

DROP VIEW IF EXISTS `rolesbb`.`suppressed_qualname`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`suppressed_qualname` AS select `rdb_t_suppressed_qualname`.`qualifier_id` AS `qualifier_id`,`rdb_t_suppressed_qualname`.`qualifier_name` AS `qualifier_name` from `rdb_t_suppressed_qualname`;

DROP VIEW IF EXISTS `rolesbb`.`user_sel_criteria2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`user_sel_criteria2` AS select `rdb_t_user_sel_criteria2`.`selection_id` AS `selection_id`,`rdb_t_user_sel_criteria2`.`criteria_id` AS `criteria_id`,`rdb_t_user_sel_criteria2`.`username` AS `username`,`rdb_t_user_sel_criteria2`.`apply` AS `apply`,`rdb_t_user_sel_criteria2`.`value` AS `value` from `rdb_t_user_sel_criteria2`;

DROP VIEW IF EXISTS `rolesbb`.`user_selection_criteria2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`user_selection_criteria2` AS select `rdb_t_user_sel_criteria2`.`selection_id` AS `selection_id`,`rdb_t_user_sel_criteria2`.`criteria_id` AS `criteria_id`,`rdb_t_user_sel_criteria2`.`username` AS `username`,`rdb_t_user_sel_criteria2`.`apply` AS `apply`,`rdb_t_user_sel_criteria2`.`value` AS `value` from `rdb_t_user_sel_criteria2`;

DROP VIEW IF EXISTS `rolesbb`.`user_selection_set2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`user_selection_set2` AS select `rdb_t_user_selection_set2`.`selection_id` AS `selection_id`,`rdb_t_user_selection_set2`.`apply_username` AS `apply_username`,`rdb_t_user_selection_set2`.`default_flag` AS `default_flag`,`rdb_t_user_selection_set2`.`hide_flag` AS `hide_flag` from `rdb_t_user_selection_set2`;

DROP VIEW IF EXISTS `rolesbb`.`viewable_category`;
CREATE ALGORITHM=UNDEFINED DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER VIEW  `rolesbb`.`viewable_category` AS select `rdb_v_viewable_category`.`kerberos_name` AS `kerberos_name`,`rdb_v_viewable_category`.`function_category` AS `function_category`,`rdb_v_viewable_category`.`function_category_desc` AS `function_category_desc` from `rdb_v_viewable_category`;

DROP VIEW IF EXISTS `rolesbb`.`wh_cost_collector`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW  `rolesbb`.`wh_cost_collector` AS select `rdb_t_wh_cost_collector`.`cost_collector_id_with_type` AS `cost_collector_id_with_type`,`rdb_t_wh_cost_collector`.`cost_collector_id` AS `cost_collector_id`,`rdb_t_wh_cost_collector`.`cost_collector_type_desc` AS `cost_collector_type_desc`,`rdb_t_wh_cost_collector`.`cost_collector_name` AS `cost_collector_name`,`rdb_t_wh_cost_collector`.`organization_id` AS `organization_id`,`rdb_t_wh_cost_collector`.`organization_name` AS `organization_name`,`rdb_t_wh_cost_collector`.`is_closed_cost_collector` AS `is_closed_cost_collector`,`rdb_t_wh_cost_collector`.`profit_center_id` AS `profit_center_id`,`rdb_t_wh_cost_collector`.`profit_center_name` AS `profit_center_name`,`rdb_t_wh_cost_collector`.`fund_id` AS `fund_id`,`rdb_t_wh_cost_collector`.`fund_center_id` AS `fund_center_id`,`rdb_t_wh_cost_collector`.`supervisor` AS `supervisor`,`rdb_t_wh_cost_collector`.`cost_collector_effective_date` AS `cost_collector_effective_date`,`rdb_t_wh_cost_collector`.`cost_collector_expiration_date` AS `cost_collector_expiration_date`,`rdb_t_wh_cost_collector`.`term_code` AS `term_code`,`rdb_t_wh_cost_collector`.`release_strategy` AS `release_strategy`,`rdb_t_wh_cost_collector`.`supervisor_room` AS `supervisor_room`,`rdb_t_wh_cost_collector`.`addressee` AS `addressee`,`rdb_t_wh_cost_collector`.`addressee_room` AS `addressee_room`,`rdb_t_wh_cost_collector`.`supervisor_mit_id` AS `supervisor_mit_id`,`rdb_t_wh_cost_collector`.`addressee_mit_id` AS `addressee_mit_id`,`rdb_t_wh_cost_collector`.`company_code` AS `company_code`,`rdb_t_wh_cost_collector`.`admin_flag` AS `admin_flag` from `rdb_t_wh_cost_collector`;