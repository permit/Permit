-- -----------------------
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
-- ------------------------

DROP TABLE IF EXISTS `mdept$owner`.`department`;
CREATE TABLE  `mdept$owner`.`department` (
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

DROP TABLE IF EXISTS `mdept$owner`.`department_audit`;
CREATE TABLE  `mdept$owner`.`department_audit` (
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

DROP TABLE IF EXISTS `mdept$owner`.`department_child`;
CREATE TABLE  `mdept$owner`.`department_child` (
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

DROP TABLE IF EXISTS `mdept$owner`.`dept_child_audit`;
CREATE TABLE  `mdept$owner`.`dept_child_audit` (
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

DROP TABLE IF EXISTS `mdept$owner`.`dept_descendent`;
CREATE TABLE  `mdept$owner`.`dept_descendent` (
  `view_type_code` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `parent_id` bigint(12) NOT NULL,
  `child_id` bigint(12) NOT NULL,
  UNIQUE KEY `department_child_pk` (`view_type_code`,`parent_id`,`child_id`),
  KEY `dd_child_id_idx` (`child_id`),
  KEY `dd_parent_id_idx` (`view_type_code`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `mdept$owner`.`dept_node_type`;
CREATE TABLE  `mdept$owner`.`dept_node_type` (
  `dept_type_id` int(5) NOT NULL,
  `dept_type_desc` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `check_object_link` varchar(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`dept_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `mdept$owner`.`expanded_object_link`;
CREATE TABLE  `mdept$owner`.`expanded_object_link` (
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

DROP TABLE IF EXISTS `mdept$owner`.`more_dept_info`;
CREATE TABLE  `mdept$owner`.`more_dept_info` (
  `dept_id` int(8) NOT NULL,
  `ao_mit_id` varchar(9) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `dept_head_mit_id` varchar(9) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  UNIQUE KEY `more_dept_info_un_dept_id` (`dept_id`),
  CONSTRAINT `more_dept_info_fk_dept_id` FOREIGN KEY (`dept_id`) REFERENCES `dept_node_type` (`dept_type_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `mdept$owner`.`object_link`;
CREATE TABLE  `mdept$owner`.`object_link` (
  `dept_id` int(8) NOT NULL,
  `object_type_code` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `object_code` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  KEY `object_link_dept_id` (`dept_id`),
  KEY `object_link_object_code` (`object_code`),
  KEY `fk_object_type_code` (`object_type_code`),
  CONSTRAINT `fk_dept_id` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_object_type_code` FOREIGN KEY (`object_type_code`) REFERENCES `object_type` (`object_type_code`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `mdept$owner`.`object_link_audit`;
CREATE TABLE  `mdept$owner`.`object_link_audit` (
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

DROP TABLE IF EXISTS `mdept$owner`.`object_type`;
CREATE TABLE  `mdept$owner`.`object_type` (
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

DROP TABLE IF EXISTS `mdept$owner`.`sequence_table`;
CREATE TABLE  `mdept$owner`.`sequence_table` (
  `currval` bigint(20) unsigned zerofill NOT NULL,
  `sequence_name` varchar(255) NOT NULL,
  PRIMARY KEY (`sequence_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `mdept$owner`.`view_subtype`;
CREATE TABLE  `mdept$owner`.`view_subtype` (
  `view_subtype_id` int(5) NOT NULL,
  `view_subtype_desc` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  UNIQUE KEY `view_subtype_pk` (`view_subtype_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `mdept$owner`.`view_to_dept_type`;
CREATE TABLE  `mdept$owner`.`view_to_dept_type` (
  `view_type_code` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `leaf_dept_type_id` int(4) NOT NULL,
  UNIQUE KEY `view_to_dept_type_pk` (`view_type_code`,`leaf_dept_type_id`),
  KEY `vtdt_dept_type_fk` (`leaf_dept_type_id`),
  KEY `vtdt_view_type_fk` (`view_type_code`),
  CONSTRAINT `vtdt_dept_type_fk` FOREIGN KEY (`leaf_dept_type_id`) REFERENCES `dept_node_type` (`dept_type_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `vtdt_view_type_fk` FOREIGN KEY (`view_type_code`) REFERENCES `view_type` (`view_type_code`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `mdept$owner`.`view_type`;
CREATE TABLE  `mdept$owner`.`view_type` (
  `view_type_code` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `view_type_desc` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `root_dept_id` int(8) DEFAULT NULL,
  UNIQUE KEY `view_type_pk` (`view_type_code`),
  KEY `view_type_fk` (`root_dept_id`),
  CONSTRAINT `view_type_fk` FOREIGN KEY (`root_dept_id`) REFERENCES `department` (`dept_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `mdept$owner`.`view_type_to_subtype`;
CREATE TABLE  `mdept$owner`.`view_type_to_subtype` (
  `view_type_code` varchar(8) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `view_subtype_id` int(5) NOT NULL,
  UNIQUE KEY `view_type_to_subtype_index` (`view_type_code`,`view_subtype_id`),
  KEY `fk_view_subtype_id` (`view_subtype_id`),
  KEY `fk_view_type_code` (`view_type_code`),
  CONSTRAINT `fk_view_subtype_id` FOREIGN KEY (`view_subtype_id`) REFERENCES `view_subtype` (`view_subtype_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_view_type_code` FOREIGN KEY (`view_type_code`) REFERENCES `view_type` (`view_type_code`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP VIEW IF EXISTS `mdept$owner`.`wh_dlc_hierarchy`;
CREATE ALGORITHM=UNDEFINED DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER VIEW `mdept$owner`.`wh_dlc_hierarchy` AS select `vt`.`view_type_code` AS `view_type_code`,`vt`.`view_type_desc` AS `view_type_desc`,`d2`.`d_code` AS `parent_d_code`,`d1`.`d_code` AS `d_code`,`d1`.`long_name` AS `long_name`,`d1`.`short_name` AS `short_name`,`d1`.`dept_type_id` AS `dept_type_id`,`dt`.`dept_type_desc` AS `dept_type_desc`,`d1`.`create_date` AS `create_date`,`d1`.`create_by` AS `create_by`,`d1`.`modified_date` AS `modified_date`,`d1`.`modified_by` AS `modified_by` from ((((((`mdept$owner`.`view_type` `vt` join `mdept$owner`.`dept_descendent` `dd`) join `mdept$owner`.`department` `d1`) join `mdept$owner`.`department_child` `dc`) join `mdept$owner`.`department` `d2`) join `mdept$owner`.`view_type_to_subtype` `vtst`) join `mdept$owner`.`dept_node_type` `dt`) where ((`dd`.`view_type_code` = `vt`.`view_type_code`) and (`dd`.`parent_id` = `vt`.`root_dept_id`) and (`d1`.`dept_id` = `dd`.`child_id`) and (`dc`.`parent_id` = `d2`.`dept_id`) and (`d1`.`dept_id` = `dc`.`child_id`) and (`vtst`.`view_type_code` = `vt`.`view_type_code`) and (`dc`.`view_subtype_id` = `vtst`.`view_subtype_id`) and (`dt`.`dept_type_id` = `d1`.`dept_type_id`));

DROP VIEW IF EXISTS `mdept$owner`.`wh_expanded_object_link`;
CREATE ALGORITHM=UNDEFINED DEFINER=`rolesbb`@`%` SQL SECURITY DEFINER VIEW `mdept$owner`.`wh_expanded_object_link` AS select `vtst`.`view_type_code` AS `view_type_code`,`d`.`d_code` AS `d_code`,`x`.`object_type_code` AS `object_type_code`,`x`.`object_code` AS `object_code`,`x`.`link_by_object_code` AS `link_by_object_code`,`d`.`dept_id` AS `dept_id` from (((((`mdept$owner`.`expanded_object_link` `x` join `mdept$owner`.`department` `d`) join `mdept$owner`.`department_child` `dc`) join `mdept$owner`.`view_type_to_subtype` `vtst`) join `mdept$owner`.`view_type` `vt`) join `mdept$owner`.`dept_descendent` `dd`) where ((`d`.`dept_id` = `x`.`dept_id`) and (`dc`.`view_subtype_id` = `vtst`.`view_subtype_id`) and (`dc`.`child_id` = `x`.`dept_id`) and (`vt`.`view_type_code` = `vtst`.`view_type_code`) and (`dd`.`view_type_code` = `vtst`.`view_type_code`) and (`dd`.`parent_id` = `vt`.`root_dept_id`) and (`d`.`dept_id` = `dd`.`child_id`) and ((not((`x`.`object_code` like '%.%'))) or (`x`.`object_type_code` <> 'SIS')) and (not(exists(select `dc`.`parent_id` AS `parent_id` from (`mdept$owner`.`department_child` `dc2` join `mdept$owner`.`view_type_to_subtype` `vtst2`) where ((`dc2`.`parent_id` = `x`.`dept_id`) and (`vtst2`.`view_type_code` = `vtst`.`view_type_code`) and (`dc2`.`view_subtype_id` = `vtst2`.`view_subtype_id`)))))) order by `vtst`.`view_type_code`,`d`.`d_code`,`x`.`object_type_code`;