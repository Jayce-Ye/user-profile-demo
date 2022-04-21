/*
SQLyog 
MySQL - 5.7.16 : Database - user_profile_manager
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `file_info` */

CREATE TABLE `file_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `file_name` varchar(200) DEFAULT NULL COMMENT '文件名',
  `file_ex_name` varchar(20) DEFAULT NULL COMMENT '扩展名',
  `file_path` varchar(200) DEFAULT NULL COMMENT '文件路径',
  `file_system` varchar(20) DEFAULT NULL COMMENT '文件系统',
  `file_status` bigint(20) DEFAULT NULL COMMENT '文件状态 1 正常 2 弃用',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB    ;

/*Table structure for table `tag_common_task` */

CREATE TABLE `tag_common_task` (
  `id` bigint(20) NOT NULL,
  `task_file_id` bigint(20) DEFAULT NULL,
  `main_class` varchar(200) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  ;

/*Table structure for table `tag_info` */

CREATE TABLE `tag_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tag_code` varchar(200) DEFAULT NULL,
  `tag_name` varchar(200) DEFAULT NULL,
  `tag_level` bigint(20) DEFAULT NULL,
  `parent_tag_id` bigint(20) DEFAULT NULL,
  `tag_type` varchar(20) DEFAULT NULL,
  `tag_value_type` varchar(20) DEFAULT NULL COMMENT '1 整数 2 浮点 3 文本 4 日期',
  `tag_value_limit` decimal(16,2) DEFAULT NULL COMMENT '数值预估上限 数字型填写',
  `tag_value_step` bigint(20) DEFAULT NULL COMMENT '1,10,100,1000',
  `tag_task_id` bigint(20) DEFAULT NULL,
  `tag_comment` varchar(2000) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_tag_level_id` (`tag_level`,`id`)
) ENGINE=InnoDB   ;

/*Table structure for table `task_info` */

CREATE TABLE `task_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_name` varchar(200) DEFAULT NULL COMMENT '任务名称',
  `task_status` varchar(20) DEFAULT NULL COMMENT '任务状态',
  `task_comment` varchar(2000) DEFAULT NULL COMMENT '任务说明',
  `task_time` varchar(10) DEFAULT NULL COMMENT '任务作业时间(小时分)',
  `task_type` varchar(20) DEFAULT NULL COMMENT '任务类型(标签,流程)',
  `exec_type` varchar(20) DEFAULT NULL COMMENT '执行方式(jar,sparksql)',
  `main_class` varchar(200) DEFAULT NULL COMMENT '启动执行的主类',
  `file_id` bigint(200) DEFAULT NULL COMMENT '程序jar文件id',
  `task_args` varchar(500) DEFAULT NULL COMMENT '启动任务的参数',
  `task_sql` varchar(5000) DEFAULT NULL COMMENT '启动的执行的sql',
  `task_exec_level` bigint(20) DEFAULT NULL COMMENT '执行层级',
  `create_time` date DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_task_time` (`task_time`)
) ENGINE=InnoDB   ;

/*Table structure for table `task_process` */

CREATE TABLE `task_process` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_id` bigint(20) DEFAULT NULL COMMENT '任务id',
  `task_name` varchar(100) DEFAULT NULL COMMENT '任务名称',
  `task_exec_time` varchar(10) DEFAULT NULL COMMENT '任务触发时间',
  `task_busi_date` varchar(10) DEFAULT NULL COMMENT '任务执行日期',
  `task_exec_status` varchar(100) DEFAULT NULL COMMENT '任务阶段 TODO ,START,SUBMITTED,RUNNING,FAILED,FINISHED',
  `task_exec_level` bigint(20) DEFAULT NULL COMMENT '任务执行层级',
  `yarn_app_id` varchar(100) DEFAULT NULL COMMENT 'yarn的application_id',
  `batch_id` varchar(100) DEFAULT NULL COMMENT '批次id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `start_time` datetime DEFAULT NULL COMMENT '启动时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间(包括完成和失败)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB    ;

/*Table structure for table `task_tag_rule` */

CREATE TABLE `task_tag_rule` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tag_id` bigint(20) DEFAULT NULL COMMENT '标签主键',
  `task_id` bigint(20) DEFAULT NULL COMMENT '任务id',
  `query_value` varchar(200) DEFAULT NULL COMMENT '查询值',
  `sub_tag_id` bigint(20) DEFAULT NULL COMMENT '对应子标签id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB   ;

/*Table structure for table `user_group` */

CREATE TABLE `user_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_group_name` varchar(200) DEFAULT NULL COMMENT '分群名称',
  `condition_json_str` varchar(2000) DEFAULT NULL COMMENT '分群条件(json)',
  `condition_comment` varchar(2000) DEFAULT NULL COMMENT '分群条件(描述)',
  `user_group_num` bigint(20) DEFAULT NULL COMMENT '分群人数',
  `update_type` varchar(20) DEFAULT NULL COMMENT '更新类型(手动,自动按天)',
  `user_group_comment` varchar(2000) DEFAULT NULL COMMENT '分群说明',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB    ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
