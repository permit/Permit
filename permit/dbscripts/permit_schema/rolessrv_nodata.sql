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

DROP TABLE IF EXISTS `rolessrv`.`_array_contents`;
CREATE TABLE  `rolessrv`.`_array_contents` (
  `array_id` int(11) NOT NULL,
  `array_key` varchar(50) DEFAULT NULL,
  `array_index` int(11) NOT NULL,
  `array_value` text,
  PRIMARY KEY (`array_id`,`array_index`),
  UNIQUE KEY `array_id` (`array_id`,`array_key`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolessrv`.`_arrays`;
CREATE TABLE  `rolessrv`.`_arrays` (
  `array_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 NOT NULL,
  `array_name` varchar(50) NOT NULL,
  `array_size` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`array_id`),
  UNIQUE KEY `username` (`username`,`array_name`)
) ENGINE=MyISAM AUTO_INCREMENT=123 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolessrv`.`_globals`;
CREATE TABLE  `rolessrv`.`_globals` (
  `user_name` varchar(50) NOT NULL,
  `var_name` varchar(50) NOT NULL,
  `the_value` text,
  `TS` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_name`,`var_name`),
  KEY `var_name` (`var_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolessrv`.`_modules`;
CREATE TABLE  `rolessrv`.`_modules` (
  `module_code` varchar(10) NOT NULL,
  `module_name` varchar(50) NOT NULL,
  `module_version` varchar(10) NOT NULL DEFAULT '1.0',
  PRIMARY KEY (`module_code`),
  UNIQUE KEY `module_name` (`module_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolessrv`.`_routine_parameters`;
CREATE TABLE  `rolessrv`.`_routine_parameters` (
  `routine_id` int(11) NOT NULL,
  `parameter_name` varchar(50) NOT NULL,
  `parameter_type` varchar(50) NOT NULL,
  `parameter_sequence` int(11) NOT NULL,
  PRIMARY KEY (`routine_id`,`parameter_name`,`parameter_sequence`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolessrv`.`_routine_syntax`;
CREATE TABLE  `rolessrv`.`_routine_syntax` (
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

DROP TABLE IF EXISTS `rolessrv`.`_test_results`;
CREATE TABLE  `rolessrv`.`_test_results` (
  `num` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(200) NOT NULL,
  `result` text,
  `expected` text,
  `outcome` tinyint(1) DEFAULT '0',
  `TS` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`num`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolessrv`.`temp_criteria`;
CREATE TABLE  `rolessrv`.`temp_criteria` (
  `key` int(10) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `seq` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL,
  `value` varchar(255) NOT NULL,
  `query_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `rolessrv`.`test_outcome`;
CREATE TABLE  `rolessrv`.`test_outcome` (
  `test no` int(11) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `result` text,
  `expected` text,
  `outcome` varchar(10) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;