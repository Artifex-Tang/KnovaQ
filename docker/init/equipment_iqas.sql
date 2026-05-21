/*
 Navicat Premium Data Transfer

 Source Server         : gaiisf-net
 Source Server Type    : MySQL
 Source Server Version : 50744
 Source Host           : 47.94.197.127:3306
 Source Schema         : equipment_iqas

 Target Server Type    : MySQL
 Target Server Version : 50744
 File Encoding         : 65001

 Date: 08/08/2025 09:57:05
*/

CREATE DATABASE IF NOT EXISTS `equipment_iqas` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `equipment_iqas`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for QRTZ_BLOB_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_BLOB_TRIGGERS`;
CREATE TABLE `QRTZ_BLOB_TRIGGERS`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_BLOB_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_BLOB_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_CALENDARS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_CALENDARS`;
CREATE TABLE `QRTZ_CALENDARS`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '日历信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_CALENDARS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_CRON_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_CRON_TRIGGERS`;
CREATE TABLE `QRTZ_CRON_TRIGGERS`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_CRON_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_CRON_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_FIRED_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_FIRED_TRIGGERS`;
CREATE TABLE `QRTZ_FIRED_TRIGGERS`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint(13) NOT NULL COMMENT '触发的时间',
  `sched_time` bigint(13) NOT NULL COMMENT '定时器制定的时间',
  `priority` int(11) NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '已触发的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_FIRED_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_JOB_DETAILS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_JOB_DETAILS`;
CREATE TABLE `QRTZ_JOB_DETAILS`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '任务详细信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_JOB_DETAILS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_LOCKS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_LOCKS`;
CREATE TABLE `QRTZ_LOCKS`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_LOCKS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_PAUSED_TRIGGER_GRPS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_PAUSED_TRIGGER_GRPS`;
CREATE TABLE `QRTZ_PAUSED_TRIGGER_GRPS`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '暂停的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_PAUSED_TRIGGER_GRPS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_SCHEDULER_STATE
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SCHEDULER_STATE`;
CREATE TABLE `QRTZ_SCHEDULER_STATE`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint(13) NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint(13) NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '调度器状态表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_SCHEDULER_STATE
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_SIMPLE_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SIMPLE_TRIGGERS`;
CREATE TABLE `QRTZ_SIMPLE_TRIGGERS`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint(7) NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint(12) NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint(10) NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPLE_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_SIMPLE_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_SIMPROP_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SIMPROP_TRIGGERS`;
CREATE TABLE `QRTZ_SIMPROP_TRIGGERS`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int(11) NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int(11) NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint(20) NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint(20) NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPROP_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_SIMPROP_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_TRIGGERS`;
CREATE TABLE `QRTZ_TRIGGERS`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint(13) NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint(13) NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int(11) NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint(13) NOT NULL COMMENT '开始时间',
  `end_time` bigint(13) NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint(2) NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name`, `job_name`, `job_group`) USING BTREE,
  CONSTRAINT `QRTZ_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `QRTZ_JOB_DETAILS` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '触发器详细信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (4, 'rs_repair_service_spare_parts', '维修服务商备件表管理', NULL, NULL, 'RsRepairServiceSpareParts', 'crud', 'element-plus', 'com.gaisoft.repair', 'repair', 'provider', '维修服务商备件管理', 'Jack H', '0', '/', '{\"parentMenuId\":5}', 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:41:51', NULL);
INSERT INTO `gen_table` VALUES (5, 'rs_repair_service_provider', '维修服务商管理', NULL, NULL, 'RsRepairServiceProvider', 'crud', 'element-plus', 'com.gaisoft.repair', 'repair', 'spareparts', '维修服务商管理', 'Jack H', '0', '/', '{\"parentMenuId\":5}', 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:42:14', NULL);
INSERT INTO `gen_table` VALUES (7, 'ir_issue_recode', '售后问题登记', NULL, NULL, 'IrIssueRecode', 'crud', 'element-plus', 'com.gaisoft.repair', 'repair', 'recode', '售后问题登记', 'Jack H', '0', '/', '{\"parentMenuId\":5}', 'admin', '2025-05-19 01:42:24', '', '2025-05-19 01:42:54', NULL);
INSERT INTO `gen_table` VALUES (15, 'ir_shelf_life', '销售订单产品保质期维护', NULL, NULL, 'IrShelfLife', 'crud', 'element-plus', 'com.gaisoft.repair', 'repair', 'life', '销售订单产品保质期维护', 'ruoyi', '0', '/', '{}', 'admin', '2025-05-22 08:24:44', '', '2025-05-22 08:29:13', NULL);
INSERT INTO `gen_table` VALUES (17, 'rs_device_detial', '备件明细表', NULL, NULL, 'RsDeviceDetial', 'crud', 'element-plus', 'com.gaisoft.repair', 'repair', 'detial', '备件明细信息', 'ruoyi', '0', '/', '{}', 'admin', '2025-05-22 08:24:45', '', '2025-05-22 08:28:22', NULL);
INSERT INTO `gen_table` VALUES (18, 'rs_device_inventory', '备件库存表', NULL, NULL, 'RsDeviceInventory', 'crud', 'element-plus', 'com.gaisoft.repair', 'repair', 'inventory', '备件库存信息', 'ruoyi', '0', '/', '{}', 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:02', NULL);
INSERT INTO `gen_table` VALUES (19, 'rs_device_master', '备件主表', NULL, NULL, 'RsDeviceMaster', 'crud', 'element-plus', 'com.gaisoft.repair', 'repair', 'master', '备件主表信息', 'ruoyi', '0', '/', '{}', 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:27:38', NULL);
INSERT INTO `gen_table` VALUES (20, 'kb_chat', '聊天记录同步表', NULL, NULL, 'KbChat', 'crud', 'element-plus', 'com.gaisoft.kb', 'aftersales', 'chat', '聊天记录同步', 'ruoyi', '0', '/', '{}', 'admin', '2025-06-30 05:05:29', '', '2025-06-30 06:42:37', NULL);
INSERT INTO `gen_table` VALUES (21, 'kb_session', 'session', NULL, NULL, 'KbSession', 'crud', 'element-plus', 'com.gaisoft.kb', 'aftersales', 'session', 'session', 'ruoyi', '0', '/', '{}', 'admin', '2025-06-30 06:40:11', '', '2025-06-30 06:42:05', NULL);
INSERT INTO `gen_table` VALUES (22, 'kb_icon', '图标管理', NULL, NULL, 'KbIcon', 'crud', 'element-plus', 'com.gaisoft.kb', 'kb', 'icon', '图标管理', 'ruoyi', '0', '/', '{}', 'admin', '2025-07-04 01:00:37', '', '2025-07-04 01:02:02', NULL);
INSERT INTO `gen_table` VALUES (23, 'kb_source_type', '文件分类', '', '', 'KbSourceType', 'tree', 'element-plus', 'com.gaisoft.kb', 'kb', 'type', '文件分类', 'eric', '0', '/', '{\"treeCode\":\"id\",\"treeName\":\"source_type\",\"treeParentCode\":\"parent_id\"}', 'admin', '2025-07-11 05:25:12', '', '2025-07-11 05:26:55', NULL);
INSERT INTO `gen_table` VALUES (24, 'kb_source_dept', '关联表', NULL, NULL, 'KbSourceDept', 'crud', 'element-plus', 'com.gaisoft.kb', 'kb', 'dept', 'gl', 'Eric', '0', '/', '{}', 'admin', '2025-07-15 02:02:20', '', '2025-07-15 02:05:52', NULL);
INSERT INTO `gen_table` VALUES (25, 'kb_source_file', '文件配置', 'kb_source_type', 'id', 'KbSourceFile', 'sub', 'element-plus', 'com.gaisoft.kb', 'kb', 'file', '文件配置', 'Eric', '0', '/', '{\"parentMenuId\":5}', 'admin', '2025-07-22 07:52:57', '', '2025-07-22 07:55:01', NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint(20) NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int(11) NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 519 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (86, 4, 'spare_part_id', '主键', 'bigint(20)', 'Long', 'sparePartId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:41:51');
INSERT INTO `gen_table_column` VALUES (87, 4, 'provider_id', '维修服务商ID', 'bigint(20)', 'Long', 'providerId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:41:51');
INSERT INTO `gen_table_column` VALUES (89, 4, 'provider_code', '维修服务商编码', 'varchar(64)', 'String', 'providerCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:41:51');
INSERT INTO `gen_table_column` VALUES (91, 4, 'provider_name', '维修服务商名称', 'varchar(200)', 'String', 'providerName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:41:51');
INSERT INTO `gen_table_column` VALUES (92, 4, 'warehouse_code', '维修服务商仓库编码', 'varchar(64)', 'String', 'warehouseCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:41:51');
INSERT INTO `gen_table_column` VALUES (93, 5, 'provider_id', '主键', 'bigint(20)', 'Long', 'providerId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:42:14');
INSERT INTO `gen_table_column` VALUES (94, 4, 'warehouse_name', '维修服务商仓库名称', 'varchar(200)', 'String', 'warehouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:41:51');
INSERT INTO `gen_table_column` VALUES (95, 5, 'provider_code', '维修服务商编码', 'varchar(64)', 'String', 'providerCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:42:14');
INSERT INTO `gen_table_column` VALUES (96, 4, 'spare_part_name', '备件名称', 'varchar(200)', 'String', 'sparePartName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:41:51');
INSERT INTO `gen_table_column` VALUES (97, 5, 'provider_name', '维修服务商名称', 'varchar(200)', 'String', 'providerName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:42:14');
INSERT INTO `gen_table_column` VALUES (98, 4, 'spare_part_unit', '备件单位', 'varchar(64)', 'String', 'sparePartUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:41:51');
INSERT INTO `gen_table_column` VALUES (99, 5, 'provider_charge', '维修服务商负责人', 'varchar(200)', 'String', 'providerCharge', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:42:15');
INSERT INTO `gen_table_column` VALUES (100, 4, 'spare_part_spec', '备件型号', 'varchar(64)', 'String', 'sparePartSpec', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:41:51');
INSERT INTO `gen_table_column` VALUES (101, 5, 'provider_contact_person', '维修服务商联系人', 'varchar(64)', 'String', 'providerContactPerson', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:42:15');
INSERT INTO `gen_table_column` VALUES (102, 4, 'spare_part_code', '备件编码', 'varchar(64)', 'String', 'sparePartCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:41:51');
INSERT INTO `gen_table_column` VALUES (103, 5, 'provider_contact_phone', '维修服务商联系方式', 'varchar(64)', 'String', 'providerContactPhone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:42:15');
INSERT INTO `gen_table_column` VALUES (104, 4, 'transfer_by', '调拨人', 'varchar(64)', 'String', 'transferBy', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:41:51');
INSERT INTO `gen_table_column` VALUES (105, 5, 'province_id', '省ID', 'bigint(20)', 'Long', 'provinceId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:42:15');
INSERT INTO `gen_table_column` VALUES (106, 4, 'transfer_phone', '调拨人联系方式', 'varchar(64)', 'String', 'transferPhone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:41:51');
INSERT INTO `gen_table_column` VALUES (107, 4, 'transfer_time', '调拨时间', 'datetime', 'Date', 'transferTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 13, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:41:52');
INSERT INTO `gen_table_column` VALUES (108, 5, 'province', '省', 'varchar(64)', 'String', 'province', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-05-19 01:34:12', '', '2025-05-19 01:42:15');
INSERT INTO `gen_table_column` VALUES (109, 4, 'receive_by', '接收人', 'varchar(64)', 'String', 'receiveBy', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:41:52');
INSERT INTO `gen_table_column` VALUES (110, 5, 'city_id', '市ID', 'bigint(20)', 'Long', 'cityId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:42:15');
INSERT INTO `gen_table_column` VALUES (111, 5, 'city', '市', 'varchar(64)', 'String', 'city', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:42:15');
INSERT INTO `gen_table_column` VALUES (112, 4, 'receive_phone', '接收人联系方式', 'varchar(64)', 'String', 'receivePhone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:41:52');
INSERT INTO `gen_table_column` VALUES (113, 5, 'district_id', '区(县)ID', 'bigint(20)', 'Long', 'districtId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:42:15');
INSERT INTO `gen_table_column` VALUES (114, 4, 'receive_time', '接收时间', 'datetime', 'Date', 'receiveTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 16, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:41:52');
INSERT INTO `gen_table_column` VALUES (115, 5, 'district', '区(县)', 'varchar(64)', 'String', 'district', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:42:15');
INSERT INTO `gen_table_column` VALUES (116, 4, 'remark', '说明', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 17, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:41:52');
INSERT INTO `gen_table_column` VALUES (117, 5, 'service_region', '维修服务商归属区域', 'varchar(64)', 'String', 'serviceRegion', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:42:15');
INSERT INTO `gen_table_column` VALUES (118, 4, 'attr1', '备用字段1', 'varchar(200)', 'String', 'attr1', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:41:52');
INSERT INTO `gen_table_column` VALUES (119, 5, 'is_del', '是否删除(0:正常,1:删除)', 'varchar(64)', 'String', 'isDel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:42:15');
INSERT INTO `gen_table_column` VALUES (120, 4, 'attr2', '备用字段2', 'varchar(200)', 'String', 'attr2', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:41:52');
INSERT INTO `gen_table_column` VALUES (121, 5, 'remark', '说明', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 15, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:42:16');
INSERT INTO `gen_table_column` VALUES (122, 4, 'attr3', '备用字段3', 'int(11)', 'Long', 'attr3', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:41:52');
INSERT INTO `gen_table_column` VALUES (123, 5, 'attr1', '备用字段1', 'varchar(200)', 'String', 'attr1', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:42:16');
INSERT INTO `gen_table_column` VALUES (124, 4, 'attr4', '备用字段4', 'int(11)', 'Long', 'attr4', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:41:52');
INSERT INTO `gen_table_column` VALUES (125, 5, 'attr2', '备用字段2', 'varchar(200)', 'String', 'attr2', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:42:16');
INSERT INTO `gen_table_column` VALUES (126, 4, 'create_id', '创建人id', 'bigint(20)', 'Long', 'createId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:41:52');
INSERT INTO `gen_table_column` VALUES (127, 5, 'attr3', '备用字段3', 'int(11)', 'Long', 'attr3', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:42:16');
INSERT INTO `gen_table_column` VALUES (128, 4, 'create_by', '创建人', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 23, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:41:52');
INSERT INTO `gen_table_column` VALUES (129, 5, 'attr4', '备用字段4', 'int(11)', 'Long', 'attr4', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:42:16');
INSERT INTO `gen_table_column` VALUES (130, 4, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 24, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:41:52');
INSERT INTO `gen_table_column` VALUES (131, 5, 'create_id', '创建人id', 'bigint(20)', 'Long', 'createId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:42:16');
INSERT INTO `gen_table_column` VALUES (132, 4, 'update_id', '修改人id', 'bigint(20)', 'Long', 'updateId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:41:52');
INSERT INTO `gen_table_column` VALUES (133, 5, 'create_by', '创建人', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 21, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:42:16');
INSERT INTO `gen_table_column` VALUES (134, 4, 'update_by', '修改人', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 26, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:41:52');
INSERT INTO `gen_table_column` VALUES (135, 5, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 22, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:42:16');
INSERT INTO `gen_table_column` VALUES (136, 4, 'update_time', '修改时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 27, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:41:52');
INSERT INTO `gen_table_column` VALUES (137, 5, 'update_id', '修改人id', 'bigint(20)', 'Long', 'updateId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:42:16');
INSERT INTO `gen_table_column` VALUES (138, 5, 'update_by', '修改人', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 24, 'admin', '2025-05-19 01:34:13', '', '2025-05-19 01:42:16');
INSERT INTO `gen_table_column` VALUES (139, 5, 'update_time', '修改时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 25, 'admin', '2025-05-19 01:34:14', '', '2025-05-19 01:42:16');
INSERT INTO `gen_table_column` VALUES (167, 7, 'issue_id', '主键', 'bigint(20)', 'Long', 'issueId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-05-19 01:42:24', '', '2025-05-19 01:42:54');
INSERT INTO `gen_table_column` VALUES (168, 7, 'issue_code', '问题编码', 'varchar(64)', 'String', 'issueCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-05-19 01:42:24', '', '2025-05-19 01:42:55');
INSERT INTO `gen_table_column` VALUES (169, 7, 'issue_name', '问题名称', 'varchar(200)', 'String', 'issueName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2025-05-19 01:42:24', '', '2025-05-19 01:42:55');
INSERT INTO `gen_table_column` VALUES (170, 7, 'receive_time', '问题接收时间', 'datetime', 'Date', 'receiveTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 4, 'admin', '2025-05-19 01:42:24', '', '2025-05-19 01:42:55');
INSERT INTO `gen_table_column` VALUES (171, 7, 'receive_id', '接收人ID', 'bigint(20)', 'Long', 'receiveId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-05-19 01:42:24', '', '2025-05-19 01:42:55');
INSERT INTO `gen_table_column` VALUES (172, 7, 'receive_by', '接收人', 'varchar(200)', 'String', 'receiveBy', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-05-19 01:42:24', '', '2025-05-19 01:42:55');
INSERT INTO `gen_table_column` VALUES (173, 7, 'dept_name', '接收人所属部门或公司', 'varchar(200)', 'String', 'deptName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2025-05-19 01:42:24', '', '2025-05-19 01:42:55');
INSERT INTO `gen_table_column` VALUES (174, 7, 'customer_name', '问题反馈客户名称', 'varchar(200)', 'String', 'customerName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2025-05-19 01:42:24', '', '2025-05-19 01:42:55');
INSERT INTO `gen_table_column` VALUES (175, 7, 'contact_person', '问题反馈人', 'varchar(200)', 'String', 'contactPerson', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-05-19 01:42:24', '', '2025-05-19 01:42:55');
INSERT INTO `gen_table_column` VALUES (176, 7, 'contact_phone', '反馈人联系方式', 'varchar(200)', 'String', 'contactPhone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2025-05-19 01:42:25', '', '2025-05-19 01:42:55');
INSERT INTO `gen_table_column` VALUES (177, 7, 'product_id', '关联产品ID', 'bigint(20)', 'Long', 'productId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2025-05-19 01:42:25', '', '2025-05-19 01:42:55');
INSERT INTO `gen_table_column` VALUES (178, 7, 'product_sn', '产品SN', 'varchar(200)', 'String', 'productSn', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2025-05-19 01:42:25', '', '2025-05-19 01:42:55');
INSERT INTO `gen_table_column` VALUES (179, 7, 'product_name', '产品名称', 'varchar(200)', 'String', 'productName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 13, 'admin', '2025-05-19 01:42:25', '', '2025-05-19 01:42:55');
INSERT INTO `gen_table_column` VALUES (180, 7, 'product_spec', '产品型号', 'varchar(200)', 'String', 'productSpec', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2025-05-19 01:42:25', '', '2025-05-19 01:42:55');
INSERT INTO `gen_table_column` VALUES (181, 7, 'issue_type', '问题类别', 'varchar(200)', 'String', 'issueType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 15, 'admin', '2025-05-19 01:42:25', '', '2025-05-19 01:42:55');
INSERT INTO `gen_table_column` VALUES (182, 7, 'issue_level', '问题等级', 'varchar(200)', 'String', 'issueLevel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2025-05-19 01:42:25', '', '2025-05-19 01:42:55');
INSERT INTO `gen_table_column` VALUES (183, 7, 'service_engineer', '负责工程师', 'varchar(200)', 'String', 'serviceEngineer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2025-05-19 01:42:26', '', '2025-05-19 01:42:55');
INSERT INTO `gen_table_column` VALUES (184, 7, 'device_sn', '问题设备SN码', 'varchar(200)', 'String', 'deviceSn', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2025-05-19 01:42:26', '', '2025-05-19 01:42:55');
INSERT INTO `gen_table_column` VALUES (185, 7, 'device_name', '问题设备名称', 'varchar(200)', 'String', 'deviceName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 19, 'admin', '2025-05-19 01:42:26', '', '2025-05-19 01:42:55');
INSERT INTO `gen_table_column` VALUES (186, 7, 'status', '问题状态(0:待处理,1:处理中,2:已解决,3:已关闭)', 'varchar(64)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 20, 'admin', '2025-05-19 01:42:26', '', '2025-05-19 01:42:56');
INSERT INTO `gen_table_column` VALUES (187, 7, 'remark', '说明', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 21, 'admin', '2025-05-19 01:42:26', '', '2025-05-19 01:42:56');
INSERT INTO `gen_table_column` VALUES (188, 7, 'attr1', '备用字段1', 'varchar(200)', 'String', 'attr1', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2025-05-19 01:42:26', '', '2025-05-19 01:42:56');
INSERT INTO `gen_table_column` VALUES (189, 7, 'attr2', '备用字段2', 'varchar(200)', 'String', 'attr2', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2025-05-19 01:42:26', '', '2025-05-19 01:42:56');
INSERT INTO `gen_table_column` VALUES (190, 7, 'attr3', '备用字段3', 'int(11)', 'Long', 'attr3', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2025-05-19 01:42:26', '', '2025-05-19 01:42:56');
INSERT INTO `gen_table_column` VALUES (191, 7, 'attr4', '备用字段4', 'int(11)', 'Long', 'attr4', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2025-05-19 01:42:26', '', '2025-05-19 01:42:56');
INSERT INTO `gen_table_column` VALUES (192, 7, 'create_id', '创建人id', 'bigint(20)', 'Long', 'createId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2025-05-19 01:42:26', '', '2025-05-19 01:42:56');
INSERT INTO `gen_table_column` VALUES (193, 7, 'create_by', '创建人', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 27, 'admin', '2025-05-19 01:42:26', '', '2025-05-19 01:42:56');
INSERT INTO `gen_table_column` VALUES (194, 7, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 28, 'admin', '2025-05-19 01:42:27', '', '2025-05-19 01:42:56');
INSERT INTO `gen_table_column` VALUES (195, 7, 'update_id', '修改人id', 'bigint(20)', 'Long', 'updateId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2025-05-19 01:42:27', '', '2025-05-19 01:42:56');
INSERT INTO `gen_table_column` VALUES (196, 7, 'update_by', '修改人', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 30, 'admin', '2025-05-19 01:42:27', '', '2025-05-19 01:42:56');
INSERT INTO `gen_table_column` VALUES (197, 7, 'update_time', '修改时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 31, 'admin', '2025-05-19 01:42:27', '', '2025-05-19 01:42:56');
INSERT INTO `gen_table_column` VALUES (350, 15, 'shelf_life_id', '主键', 'bigint(20)', 'Long', 'shelfLifeId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-05-22 08:24:44', '', '2025-05-22 08:29:13');
INSERT INTO `gen_table_column` VALUES (352, 15, 'provider_id', '维修服务商ID', 'bigint(20)', 'Long', 'providerId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-05-22 08:24:44', '', '2025-05-22 08:29:13');
INSERT INTO `gen_table_column` VALUES (354, 15, 'provider_code', '维修服务商编码', 'varchar(64)', 'String', 'providerCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-05-22 08:24:44', '', '2025-05-22 08:29:13');
INSERT INTO `gen_table_column` VALUES (356, 15, 'provider_name', '维修服务商名称', 'varchar(200)', 'String', 'providerName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2025-05-22 08:24:44', '', '2025-05-22 08:29:14');
INSERT INTO `gen_table_column` VALUES (358, 15, 'product_id', '产品ID', 'bigint(20)', 'Long', 'productId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-05-22 08:24:44', '', '2025-05-22 08:29:14');
INSERT INTO `gen_table_column` VALUES (360, 15, 'product_sn', '产品SN', 'varchar(200)', 'String', 'productSn', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-05-22 08:24:44', '', '2025-05-22 08:29:14');
INSERT INTO `gen_table_column` VALUES (362, 15, 'product_name', '产品名称', 'varchar(200)', 'String', 'productName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2025-05-22 08:24:44', '', '2025-05-22 08:29:14');
INSERT INTO `gen_table_column` VALUES (364, 15, 'product_spec', '产品型号', 'varchar(200)', 'String', 'productSpec', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-05-22 08:24:44', '', '2025-05-22 08:29:14');
INSERT INTO `gen_table_column` VALUES (366, 15, 'sqare_part_sn', '备件SN', 'varchar(200)', 'String', 'sqarePartSn', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-05-22 08:24:44', '', '2025-05-22 08:29:14');
INSERT INTO `gen_table_column` VALUES (368, 15, 'spare_part_name', '备件名称', 'varchar(200)', 'String', 'sparePartName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2025-05-22 08:24:44', '', '2025-05-22 08:29:14');
INSERT INTO `gen_table_column` VALUES (370, 15, 'spare_part_spec', '备件型号', 'varchar(200)', 'String', 'sparePartSpec', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2025-05-22 08:24:44', '', '2025-05-22 08:29:14');
INSERT INTO `gen_table_column` VALUES (372, 15, 'product_sellby_date', '产品包质期', 'datetime', 'Date', 'productSellbyDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 12, 'admin', '2025-05-22 08:24:44', '', '2025-05-22 08:29:14');
INSERT INTO `gen_table_column` VALUES (374, 15, 'spare_sellby_date', '备件保质期', 'datetime', 'Date', 'spareSellbyDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 13, 'admin', '2025-05-22 08:24:45', '', '2025-05-22 08:29:14');
INSERT INTO `gen_table_column` VALUES (376, 15, 'remark', '说明', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 14, 'admin', '2025-05-22 08:24:45', '', '2025-05-22 08:29:14');
INSERT INTO `gen_table_column` VALUES (378, 15, 'attr1', '备用字段1', 'varchar(200)', 'String', 'attr1', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2025-05-22 08:24:45', '', '2025-05-22 08:29:14');
INSERT INTO `gen_table_column` VALUES (379, 15, 'attr2', '备用字段2', 'varchar(200)', 'String', 'attr2', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2025-05-22 08:24:45', '', '2025-05-22 08:29:14');
INSERT INTO `gen_table_column` VALUES (380, 15, 'attr3', '备用字段3', 'int(11)', 'Long', 'attr3', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2025-05-22 08:24:45', '', '2025-05-22 08:29:14');
INSERT INTO `gen_table_column` VALUES (382, 15, 'attr4', '备用字段4', 'int(11)', 'Long', 'attr4', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2025-05-22 08:24:45', '', '2025-05-22 08:29:14');
INSERT INTO `gen_table_column` VALUES (384, 15, 'create_id', '创建人id', 'bigint(20)', 'Long', 'createId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2025-05-22 08:24:45', '', '2025-05-22 08:29:14');
INSERT INTO `gen_table_column` VALUES (386, 15, 'create_by', '创建人', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 20, 'admin', '2025-05-22 08:24:45', '', '2025-05-22 08:29:14');
INSERT INTO `gen_table_column` VALUES (388, 15, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 21, 'admin', '2025-05-22 08:24:45', '', '2025-05-22 08:29:15');
INSERT INTO `gen_table_column` VALUES (390, 15, 'update_id', '修改人id', 'bigint(20)', 'Long', 'updateId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2025-05-22 08:24:45', '', '2025-05-22 08:29:15');
INSERT INTO `gen_table_column` VALUES (392, 15, 'update_by', '修改人', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 23, 'admin', '2025-05-22 08:24:45', '', '2025-05-22 08:29:15');
INSERT INTO `gen_table_column` VALUES (394, 15, 'update_time', '修改时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 24, 'admin', '2025-05-22 08:24:45', '', '2025-05-22 08:29:15');
INSERT INTO `gen_table_column` VALUES (397, 17, 'spare_part_detailid', '主键', 'bigint(20)', 'Long', 'sparePartDetailid', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-05-22 08:24:45', '', '2025-05-22 08:28:22');
INSERT INTO `gen_table_column` VALUES (399, 17, 'provider_id', '维修服务商ID', 'bigint(20)', 'Long', 'providerId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-05-22 08:24:45', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (401, 17, 'provider_code', '维修服务商编码', 'varchar(64)', 'String', 'providerCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-05-22 08:24:45', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (403, 17, 'provider_name', '维修服务商名称', 'varchar(200)', 'String', 'providerName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2025-05-22 08:24:45', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (405, 17, 'warehouse_code', '维修服务商仓库编码', 'varchar(64)', 'String', 'warehouseCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-05-22 08:24:45', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (407, 17, 'warehouse_name', '维修服务商仓库名称', 'varchar(200)', 'String', 'warehouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (409, 17, 'spare_part_unit', '备件单位', 'varchar(64)', 'String', 'sparePartUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (411, 17, 'spare_part_spec', '备件型号', 'varchar(64)', 'String', 'sparePartSpec', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (413, 17, 'nspare_part_name', '新备件名称', 'varchar(200)', 'String', 'nsparePartName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (415, 17, 'nspare_part_code', '新备件sn', 'varchar(64)', 'String', 'nsparePartCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (417, 17, 'ospare_part_code', '旧备件sn', 'varchar(64)', 'String', 'osparePartCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (419, 17, 'abstract', '操作摘要(0.备件调拨、1.销售出库、2.备件替换）', 'varchar(10)', 'String', 'abstract', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (421, 17, 'transfer_by', '调拨人', 'varchar(64)', 'String', 'transferBy', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (423, 17, 'transfer_phone', '调拨人联系方式', 'varchar(64)', 'String', 'transferPhone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (424, 17, 'transfer_time', '调拨时间', 'datetime', 'Date', 'transferTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 15, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (425, 17, 'receive_by', '接收人', 'varchar(64)', 'String', 'receiveBy', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (426, 17, 'receive_phone', '接收人联系方式', 'varchar(64)', 'String', 'receivePhone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (427, 17, 'receive_time', '接收时间', 'datetime', 'Date', 'receiveTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 18, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (428, 17, 'remark', '说明', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 19, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (429, 17, 'attr1', '备用字段1', 'varchar(200)', 'String', 'attr1', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:23');
INSERT INTO `gen_table_column` VALUES (430, 17, 'attr2', '备用字段2', 'varchar(200)', 'String', 'attr2', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:24');
INSERT INTO `gen_table_column` VALUES (431, 17, 'attr3', '备用字段3', 'int(11)', 'Long', 'attr3', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:24');
INSERT INTO `gen_table_column` VALUES (432, 17, 'attr4', '备用字段4', 'int(11)', 'Long', 'attr4', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:24');
INSERT INTO `gen_table_column` VALUES (433, 17, 'create_id', '创建人id', 'bigint(20)', 'Long', 'createId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:24');
INSERT INTO `gen_table_column` VALUES (434, 17, 'create_by', '创建人', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 25, 'admin', '2025-05-22 08:24:46', '', '2025-05-22 08:28:24');
INSERT INTO `gen_table_column` VALUES (435, 17, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 26, 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:24');
INSERT INTO `gen_table_column` VALUES (436, 17, 'update_id', '修改人id', 'bigint(20)', 'Long', 'updateId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:24');
INSERT INTO `gen_table_column` VALUES (437, 17, 'update_by', '修改人', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 28, 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:24');
INSERT INTO `gen_table_column` VALUES (438, 17, 'update_time', '修改时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 29, 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:24');
INSERT INTO `gen_table_column` VALUES (439, 18, 'inventory_id', '主键', 'bigint(20)', 'Long', 'inventoryId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:02');
INSERT INTO `gen_table_column` VALUES (440, 18, 'provider_id', '维修服务商ID', 'bigint(20)', 'Long', 'providerId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:02');
INSERT INTO `gen_table_column` VALUES (441, 18, 'provider_code', '维修服务商编码', 'varchar(64)', 'String', 'providerCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:02');
INSERT INTO `gen_table_column` VALUES (442, 18, 'provider_name', '维修服务商名称', 'varchar(200)', 'String', 'providerName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:02');
INSERT INTO `gen_table_column` VALUES (443, 18, 'spare_part_name', '备件名称', 'varchar(200)', 'String', 'sparePartName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:02');
INSERT INTO `gen_table_column` VALUES (444, 18, 'spare_part_unit', '备件单位', 'varchar(64)', 'String', 'sparePartUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:02');
INSERT INTO `gen_table_column` VALUES (445, 18, 'spare_part_num', '备件本期数量', 'int(12)', 'Long', 'sparePartNum', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:02');
INSERT INTO `gen_table_column` VALUES (446, 18, 'spare_part_pnum', '备件上期数量', 'int(12)', 'Long', 'sparePartPnum', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:02');
INSERT INTO `gen_table_column` VALUES (447, 18, 'remark', '说明', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 9, 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:02');
INSERT INTO `gen_table_column` VALUES (448, 18, 'attr1', '备用字段1', 'varchar(200)', 'String', 'attr1', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:02');
INSERT INTO `gen_table_column` VALUES (449, 18, 'attr2', '备用字段2', 'varchar(200)', 'String', 'attr2', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:02');
INSERT INTO `gen_table_column` VALUES (450, 18, 'attr3', '备用字段3', 'int(11)', 'Long', 'attr3', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:02');
INSERT INTO `gen_table_column` VALUES (451, 18, 'attr4', '备用字段4', 'int(11)', 'Long', 'attr4', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:02');
INSERT INTO `gen_table_column` VALUES (452, 18, 'create_id', '创建人id', 'bigint(20)', 'Long', 'createId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2025-05-22 08:24:47', '', '2025-05-22 08:28:02');
INSERT INTO `gen_table_column` VALUES (453, 18, 'create_by', '创建人', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 15, 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:28:02');
INSERT INTO `gen_table_column` VALUES (454, 18, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 16, 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:28:02');
INSERT INTO `gen_table_column` VALUES (455, 18, 'update_id', '修改人id', 'bigint(20)', 'Long', 'updateId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:28:03');
INSERT INTO `gen_table_column` VALUES (456, 18, 'update_by', '修改人', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 18, 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:28:03');
INSERT INTO `gen_table_column` VALUES (457, 18, 'update_time', '修改时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 19, 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:28:03');
INSERT INTO `gen_table_column` VALUES (458, 19, 'spare_part_masterid', '主键', 'bigint(20)', 'Long', 'sparePartMasterid', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:27:38');
INSERT INTO `gen_table_column` VALUES (459, 19, 'provider_id', '维修服务商ID', 'bigint(20)', 'Long', 'providerId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:27:38');
INSERT INTO `gen_table_column` VALUES (460, 19, 'provider_code', '维修服务商编码', 'varchar(64)', 'String', 'providerCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:27:39');
INSERT INTO `gen_table_column` VALUES (461, 19, 'provider_name', '维修服务商名称', 'varchar(200)', 'String', 'providerName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:27:39');
INSERT INTO `gen_table_column` VALUES (462, 19, 'warehouse_code', '维修服务商仓库编码', 'varchar(64)', 'String', 'warehouseCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:27:39');
INSERT INTO `gen_table_column` VALUES (463, 19, 'warehouse_name', '维修服务商仓库名称', 'varchar(200)', 'String', 'warehouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:27:39');
INSERT INTO `gen_table_column` VALUES (464, 19, 'spare_part_name', '备件名称', 'varchar(200)', 'String', 'sparePartName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:27:39');
INSERT INTO `gen_table_column` VALUES (465, 19, 'spare_part_unit', '备件单位', 'varchar(64)', 'String', 'sparePartUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:27:39');
INSERT INTO `gen_table_column` VALUES (466, 19, 'spare_part_spec', '备件型号', 'varchar(64)', 'String', 'sparePartSpec', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:27:39');
INSERT INTO `gen_table_column` VALUES (467, 19, 'spare_part_code', '备件sn', 'varchar(64)', 'String', 'sparePartCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:27:39');
INSERT INTO `gen_table_column` VALUES (468, 19, 'spare_part_status', '备件状态(0:正常1:作废)', 'varchar(2)', 'String', 'sparePartStatus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 11, 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:27:39');
INSERT INTO `gen_table_column` VALUES (469, 19, 'remark', '说明', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 12, 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:27:39');
INSERT INTO `gen_table_column` VALUES (470, 19, 'attr1', '备用字段1', 'varchar(200)', 'String', 'attr1', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2025-05-22 08:24:48', '', '2025-05-22 08:27:39');
INSERT INTO `gen_table_column` VALUES (471, 19, 'attr2', '备用字段2', 'varchar(200)', 'String', 'attr2', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2025-05-22 08:24:49', '', '2025-05-22 08:27:39');
INSERT INTO `gen_table_column` VALUES (472, 19, 'attr3', '备用字段3', 'int(11)', 'Long', 'attr3', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2025-05-22 08:24:49', '', '2025-05-22 08:27:39');
INSERT INTO `gen_table_column` VALUES (473, 19, 'attr4', '备用字段4', 'int(11)', 'Long', 'attr4', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2025-05-22 08:24:49', '', '2025-05-22 08:27:39');
INSERT INTO `gen_table_column` VALUES (474, 19, 'create_id', '创建人id', 'bigint(20)', 'Long', 'createId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2025-05-22 08:24:49', '', '2025-05-22 08:27:39');
INSERT INTO `gen_table_column` VALUES (475, 19, 'create_by', '创建人', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 18, 'admin', '2025-05-22 08:24:49', '', '2025-05-22 08:27:39');
INSERT INTO `gen_table_column` VALUES (476, 19, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 19, 'admin', '2025-05-22 08:24:49', '', '2025-05-22 08:27:39');
INSERT INTO `gen_table_column` VALUES (477, 19, 'update_id', '修改人id', 'bigint(20)', 'Long', 'updateId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2025-05-22 08:24:49', '', '2025-05-22 08:27:39');
INSERT INTO `gen_table_column` VALUES (478, 19, 'update_by', '修改人', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 21, 'admin', '2025-05-22 08:24:49', '', '2025-05-22 08:27:40');
INSERT INTO `gen_table_column` VALUES (479, 19, 'update_time', '修改时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 22, 'admin', '2025-05-22 08:24:49', '', '2025-05-22 08:27:40');
INSERT INTO `gen_table_column` VALUES (480, 20, 'id', 'ID', 'int(11)', 'Long', 'id', '1', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-06-30 05:05:29', '', '2025-06-30 06:42:37');
INSERT INTO `gen_table_column` VALUES (481, 20, 'chat_id', '聊天窗_ID', 'int(11)', 'Long', 'chatId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-06-30 05:05:29', '', '2025-06-30 06:42:37');
INSERT INTO `gen_table_column` VALUES (482, 20, 'session_id', 'SESSION_ID', 'int(11)', 'Long', 'sessionId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-06-30 05:05:29', '', '2025-06-30 06:42:37');
INSERT INTO `gen_table_column` VALUES (483, 20, 'content', '原始对话json字符', 'blob', 'String', 'content', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'editor', '', 5, 'admin', '2025-06-30 05:05:29', '', '2025-06-30 06:42:37');
INSERT INTO `gen_table_column` VALUES (484, 20, 'create_by', '创建人', 'varchar(255)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 8, 'admin', '2025-06-30 05:05:29', '', '2025-06-30 06:42:37');
INSERT INTO `gen_table_column` VALUES (485, 20, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', '2025-06-30 05:05:30', '', '2025-06-30 06:42:38');
INSERT INTO `gen_table_column` VALUES (486, 20, 'update_by', '更新人', 'varchar(255)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 10, 'admin', '2025-06-30 05:05:30', '', '2025-06-30 06:42:38');
INSERT INTO `gen_table_column` VALUES (487, 20, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 11, 'admin', '2025-06-30 05:05:30', '', '2025-06-30 06:42:38');
INSERT INTO `gen_table_column` VALUES (488, 21, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-06-30 06:40:11', '', '2025-06-30 06:42:05');
INSERT INTO `gen_table_column` VALUES (489, 21, 'session_id', NULL, 'int(11)', 'Long', 'sessionId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-06-30 06:40:11', '', '2025-06-30 06:42:05');
INSERT INTO `gen_table_column` VALUES (490, 21, 'chat_id', NULL, 'int(11)', 'Long', 'chatId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-06-30 06:40:11', '', '2025-06-30 06:42:05');
INSERT INTO `gen_table_column` VALUES (491, 21, 'create_date', NULL, 'datetime', 'Date', 'createDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 4, 'admin', '2025-06-30 06:40:11', '', '2025-06-30 06:42:05');
INSERT INTO `gen_table_column` VALUES (492, 21, 'create_time', NULL, 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 5, 'admin', '2025-06-30 06:40:11', '', '2025-06-30 06:42:05');
INSERT INTO `gen_table_column` VALUES (493, 21, 'update_date', NULL, 'datetime', 'Date', 'updateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 6, 'admin', '2025-06-30 06:40:12', '', '2025-06-30 06:42:05');
INSERT INTO `gen_table_column` VALUES (494, 21, 'update_time', NULL, 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 7, 'admin', '2025-06-30 06:40:12', '', '2025-06-30 06:42:05');
INSERT INTO `gen_table_column` VALUES (495, 21, 'user_id', NULL, 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-06-30 06:40:12', '', '2025-06-30 06:42:06');
INSERT INTO `gen_table_column` VALUES (496, 20, 'message_id', '对话ID', 'int(11)', 'Long', 'messageId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, '', '2025-06-30 06:42:11', '', '2025-06-30 06:42:37');
INSERT INTO `gen_table_column` VALUES (497, 20, 'package_content', '打包原始对话json字符串后的 json字符串', 'blob', 'String', 'packageContent', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'editor', '', 6, '', '2025-06-30 06:42:12', '', '2025-06-30 06:42:37');
INSERT INTO `gen_table_column` VALUES (498, 20, 'reference', '大json字符串', 'varchar(255)', 'String', 'reference', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, '', '2025-06-30 06:42:12', '', '2025-06-30 06:42:37');
INSERT INTO `gen_table_column` VALUES (499, 22, 'id', 'ID', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-07-04 01:00:37', '', '2025-07-04 01:02:02');
INSERT INTO `gen_table_column` VALUES (500, 22, 'icon', '图标', 'varchar(255)', 'String', 'icon', '0', '0', '0', '1', '1', '1', '0', 'EQ', 'imageUpload', '', 2, 'admin', '2025-07-04 01:00:37', '', '2025-07-04 01:02:02');
INSERT INTO `gen_table_column` VALUES (501, 22, 'name', '名称', 'varchar(255)', 'String', 'name', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2025-07-04 01:00:37', '', '2025-07-04 01:02:02');
INSERT INTO `gen_table_column` VALUES (502, 23, 'id', 'ID', 'int(11)', 'Long', 'id', '1', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-07-11 05:25:12', '', '2025-07-11 05:26:55');
INSERT INTO `gen_table_column` VALUES (503, 23, 'parent_id', '父类', 'int(11)', 'Long', 'parentId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-07-11 05:25:12', '', '2025-07-11 05:26:55');
INSERT INTO `gen_table_column` VALUES (504, 23, 'source_type', '类别', 'varchar(255)', 'String', 'sourceType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2025-07-11 05:25:12', '', '2025-07-11 05:26:55');
INSERT INTO `gen_table_column` VALUES (505, 23, 'create_by', '创建人', 'varchar(255)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 4, 'admin', '2025-07-11 05:25:12', '', '2025-07-11 05:26:55');
INSERT INTO `gen_table_column` VALUES (506, 23, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 5, 'admin', '2025-07-11 05:25:12', '', '2025-07-11 05:26:55');
INSERT INTO `gen_table_column` VALUES (507, 23, 'update_by', '更新人', 'varchar(255)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 6, 'admin', '2025-07-11 05:25:12', '', '2025-07-11 05:26:55');
INSERT INTO `gen_table_column` VALUES (508, 23, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 7, 'admin', '2025-07-11 05:25:12', '', '2025-07-11 05:26:55');
INSERT INTO `gen_table_column` VALUES (509, 24, 'source_id', NULL, 'int(11)', 'Long', 'sourceId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 1, 'admin', '2025-07-15 02:02:20', '', '2025-07-15 02:05:52');
INSERT INTO `gen_table_column` VALUES (510, 24, 'dept_id', NULL, 'int(11)', 'Long', 'deptId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-07-15 02:02:20', '', '2025-07-15 02:05:52');
INSERT INTO `gen_table_column` VALUES (511, 25, 'id', 'ID', 'int(11)', 'Long', 'id', '1', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-07-22 07:52:57', '', '2025-07-22 07:55:01');
INSERT INTO `gen_table_column` VALUES (512, 25, 'name', '文件名称', 'varchar(255)', 'String', 'name', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-07-22 07:52:57', '', '2025-07-22 07:55:01');
INSERT INTO `gen_table_column` VALUES (513, 25, 'type_id', '文件类型', 'int(11)', 'Long', 'typeId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2025-07-22 07:52:57', '', '2025-07-22 07:55:01');
INSERT INTO `gen_table_column` VALUES (514, 25, 'tenant_id', NULL, 'int(11)', 'Long', 'tenantId', '0', '0', '0', '1', '0', '0', '0', 'EQ', 'input', '', 4, 'admin', '2025-07-22 07:52:57', '', '2025-07-22 07:55:01');
INSERT INTO `gen_table_column` VALUES (515, 25, 'parent_id', NULL, 'int(11)', 'Long', 'parentId', '0', '0', '0', '1', '0', '0', '0', 'EQ', 'input', '', 5, 'admin', '2025-07-22 07:52:57', '', '2025-07-22 07:55:01');
INSERT INTO `gen_table_column` VALUES (516, 25, 'size', '文件大小', 'double', 'Long', 'size', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-07-22 07:52:57', '', '2025-07-22 07:55:01');
INSERT INTO `gen_table_column` VALUES (517, 25, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 7, 'admin', '2025-07-22 07:52:57', '', '2025-07-22 07:55:01');
INSERT INTO `gen_table_column` VALUES (518, 25, 'create_by', '创建人', 'varchar(255)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 8, 'admin', '2025-07-22 07:52:57', '', '2025-07-22 07:55:01');

-- ----------------------------
-- Table structure for ir_issue_recode
-- ----------------------------
DROP TABLE IF EXISTS `ir_issue_recode`;
CREATE TABLE `ir_issue_recode`  (
  `issue_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `issue_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '问题编码',
  `issue_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '问题名称',
  `receive_time` datetime(0) NULL DEFAULT NULL COMMENT '问题接收时间',
  `receive_id` bigint(20) NULL DEFAULT NULL COMMENT '接收人ID',
  `receive_by` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '接收人',
  `dept_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '接收人所属部门或公司',
  `customer_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '问题反馈客户名称',
  `contact_person` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '问题反馈人',
  `contact_phone` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '反馈人联系方式',
  `product_id` bigint(20) NULL DEFAULT NULL COMMENT '关联产品ID',
  `product_sn` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品SN',
  `product_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品名称',
  `product_spec` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品型号',
  `issue_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '问题类别',
  `issue_level` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '问题等级',
  `service_engineer` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '负责工程师',
  `device_sn` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '问题设备SN码',
  `device_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '问题设备名称',
  `status` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '问题状态(0:待处理,1:处理中,2:已解决,3:已关闭)',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '说明',
  `attr1` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段1',
  `attr2` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段2',
  `attr3` int(11) NULL DEFAULT NULL COMMENT '备用字段3',
  `attr4` int(11) NULL DEFAULT NULL COMMENT '备用字段4',
  `create_id` bigint(20) NULL DEFAULT NULL COMMENT '创建人id',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_id` bigint(20) NULL DEFAULT NULL COMMENT '修改人id',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`issue_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '售后问题登记' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ir_issue_recode
-- ----------------------------
INSERT INTO `ir_issue_recode` VALUES (5, NULL, 'xxxx', '2025-06-25 00:00:00', NULL, NULL, NULL, 'xyyyy', '5656', '45545', NULL, '020020010007ZJ310006', '490型球台接口扩展板半成品板', 'PTIEB板，490PTIEB', '0', '1', '4554', '333', '44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-06-07 19:21:44', NULL, NULL, NULL);
INSERT INTO `ir_issue_recode` VALUES (6, NULL, 'xxxx3', '2025-06-10 00:00:00', 103, 'admin', NULL, 'dsdds', 'ewwe', '3222233', NULL, '020020010007ZJ310006', '490型球台接口扩展板半成品板', 'PTIEB板，490PTIEB', '0', '3', '32332', '2332', '343', '0', NULL, NULL, NULL, NULL, NULL, 1, 'admin', '2025-06-07 19:54:58', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for ir_shelf_life
-- ----------------------------
DROP TABLE IF EXISTS `ir_shelf_life`;
CREATE TABLE `ir_shelf_life`  (
  `shelf_life_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `provider_id` bigint(20) NULL DEFAULT NULL COMMENT '维修服务商ID',
  `provider_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商编码',
  `provider_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商名称',
  `product_id` bigint(20) NULL DEFAULT NULL COMMENT '产品ID',
  `product_sn` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品SN',
  `product_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品名称',
  `product_spec` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品型号',
  `sqare_part_sn` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备件SN',
  `spare_part_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备件名称',
  `spare_part_spec` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备件型号',
  `product_sellby_date` datetime(0) NULL DEFAULT NULL COMMENT '产品包质期',
  `spare_sellby_date` datetime(0) NULL DEFAULT NULL COMMENT '备件保质期',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '说明',
  `attr1` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段1',
  `attr2` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段2',
  `attr3` int(11) NULL DEFAULT NULL COMMENT '备用字段3',
  `attr4` int(11) NULL DEFAULT NULL COMMENT '备用字段4',
  `create_id` bigint(20) NULL DEFAULT NULL COMMENT '创建人id',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_id` bigint(20) NULL DEFAULT NULL COMMENT '修改人id',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`shelf_life_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 378 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '销售订单产品保质期维护' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ir_shelf_life
-- ----------------------------
INSERT INTO `ir_shelf_life` VALUES (343, NULL, NULL, NULL, 2289, '020020010007ZJ310006', '490型球台接口扩展板半成品板', 'PTIEB板，490PTIEB', '02.002.001.0007', NULL, NULL, '2025-06-23 00:00:00', NULL, NULL, NULL, NULL, 0, NULL, 1, 'admin', '2025-06-12 13:07:40', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (344, NULL, NULL, NULL, 3592, '020020010007ZJ310006', '10kΩ，0603，1%，1/10W贴片电阻', '0603 F1002T5E', '02.002.001.0007 V1.2', NULL, NULL, '2025-06-15 00:00:00', NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:40', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (345, NULL, NULL, NULL, 3600, '020020010007ZJ310006', '100Ω，0603，1%，1/10W贴片电阻', '0603 F1000T5E', '02.002.001.0007 V1.2', NULL, NULL, '2025-06-28 00:00:00', NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:40', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (346, NULL, NULL, NULL, 3601, '020020010007ZJ310006', '120Ω，0603，1%，1/10W贴片电阻', '0603 F1200T5E', '02.002.001.0007 V1.2', NULL, NULL, '2025-06-04 00:00:00', NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:40', NULL, NULL, '2025-06-12 14:20:27');
INSERT INTO `ir_shelf_life` VALUES (347, NULL, NULL, NULL, 3609, '020020010007ZJ310006', '2.2kΩ，0603，1%，1/10W贴片电阻', '0603 F2201T5E', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:40', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (348, NULL, NULL, NULL, 3618, '020020010007ZJ310006', '15Ω ，2512，5%，2W贴片电阻', 'CR2512J15RE042W', '02.002.001.0007 V1.2', NULL, NULL, '2025-06-11 00:00:00', NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:40', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (349, NULL, NULL, NULL, 3739, '020020010007ZJ310006', '470uF+/-20%，50V插件铝电解电容', 'CD282-50V-470uF+/-20%或者ECR1HXX471MLL125020', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:40', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (350, NULL, NULL, NULL, 3741, '020020010007ZJ310006', '0.1uF，0603，50V陶瓷电容', 'GRM188R71H104KA93D', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:40', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (351, NULL, NULL, NULL, 3749, '020020010007ZJ310006', '22uF，0805，10V陶瓷电容', 'GRM21BR61A226ME51L', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:40', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (352, NULL, NULL, NULL, 3754, '020020010007ZJ310006', '3300pF，1812，2KV陶瓷电容', 'CC1812KKX7RDBB332', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:40', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (353, NULL, NULL, NULL, 3760, '020020010007ZJ310006', '0.01uF，0603，100V陶瓷电容', 'GRM188R72A103KA01D', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:40', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (354, NULL, NULL, NULL, 3764, '020020010007ZJ310006', '1000pF，1206，2000V陶瓷电容', 'CC1206KKX7RDBB102', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:40', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (355, NULL, NULL, NULL, 3765, '020020010007ZJ310006', '10uF，1206，25V陶瓷电容', 'GRM31CR61E106KA12L', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:40', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (356, NULL, NULL, NULL, 3910, '020020010007ZJ310006', '3.3V，UART转422转换器', 'ADM3490EARZ', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:40', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (357, NULL, NULL, NULL, 3911, '020020010007ZJ310006', 'UART转RS232芯片', 'ADM3202ARN', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:40', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (358, NULL, NULL, NULL, 3922, '020020010007ZJ310006', '3.3V，2K米通讯距离RS-485芯片', 'SN65HVD72D', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:41', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (359, NULL, NULL, NULL, 3997, '020020010007ZJ310006', '开关二极管', 'LL4148-GS08', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:41', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (360, NULL, NULL, NULL, 4000, '020020010007ZJ310006', 'NPN晶体管', 'MMBT3904LT1G', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:41', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (361, NULL, NULL, NULL, 4004, '020020010007ZJ310006', '贴片光耦', 'PS2501L-1-F3-A', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:41', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (362, NULL, NULL, NULL, 4050, '020020010007ZJ310006', '490型球台接口扩展板PCB板', '490PTIEB_V1.2_180601', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:41', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (363, NULL, NULL, NULL, 4071, '020020010007ZJ310006', '12V，1A单极性继电器', 'G6K-2F-Y-DC12V', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:41', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (364, NULL, NULL, NULL, 4111, '020020010007ZJ310006', '3端90V气体放电管', 'B3D090M-C', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:41', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (365, NULL, NULL, NULL, 4112, '020020010007ZJ310006', '2端6V半导体放电管', 'BS0060N-C-F', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:41', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (366, NULL, NULL, NULL, 4115, '020020010007ZJ310006', '4A自恢复保险丝', 'JK30-400', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:41', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (367, NULL, NULL, NULL, 4118, '020020010007ZJ310006', '1.5kW，6V开启TVS管', 'SMCJ6.0CA', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:41', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (368, NULL, NULL, NULL, 4119, '020020010007ZJ310006', '3端20V半导体放电管', 'BV-SMBT-20CA', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:41', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (369, NULL, NULL, NULL, 4120, '020020010007ZJ310006', '3端ESD防护', 'BV-SM712', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:41', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (370, NULL, NULL, NULL, 4282, '020020010007ZJ310006', '2芯3.81间距凤凰端子立式插座', 'TBP1381S-2P', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:41', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (371, NULL, NULL, NULL, 4283, '020020010007ZJ310006', '3芯3.81间距凤凰端子立式插座', 'TBP1381S-3P', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:41', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (372, NULL, NULL, NULL, 4284, '020020010007ZJ310006', '4芯3.81间距凤凰端子立式插座', 'TBP1381S-4P', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:41', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (373, NULL, NULL, NULL, 4285, '020020010007ZJ310006', '6芯3.81间距凤凰端子立式插座', 'TBP1381S-6P', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:41', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (374, NULL, NULL, NULL, 4290, '020020010007ZJ310006', '2芯2.54间距插针用跳帽', '206-6A', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:41', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (375, NULL, NULL, NULL, 4295, '020020010007ZJ310006', '双排2.54间距2x3插针', '201S-2x3P-NS', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:41', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (376, NULL, NULL, NULL, 4340, '020020010007ZJ310006', '2X15 2.54间距立式插针', '201S-2X15P', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:42', NULL, NULL, NULL);
INSERT INTO `ir_shelf_life` VALUES (377, NULL, NULL, NULL, 4079, '020020010007ZJ310006', '12V，2A单极性继电器', 'G6S-2F-DC12V', '02.002.001.0007 V1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2289, NULL, NULL, 'admin', '2025-06-12 13:07:42', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for kb_chat
-- ----------------------------
DROP TABLE IF EXISTS `kb_chat`;
CREATE TABLE `kb_chat`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `message_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对话ID',
  `chat_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '聊天窗_ID',
  `session_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'SESSION_ID',
  `content` blob NULL COMMENT '原始对话json字符',
  `package_content` blob NULL COMMENT '打包原始对话json字符串后的 json字符串',
  `reference` blob NULL COMMENT '大json字符串',
  `create_by` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `role` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 589 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '聊天记录同步表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of kb_chat
-- ----------------------------

-- ----------------------------
-- Table structure for kb_icon
-- ----------------------------
DROP TABLE IF EXISTS `kb_icon`;
CREATE TABLE `kb_icon`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `icon` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图标',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '图标管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of kb_icon
-- ----------------------------
INSERT INTO `kb_icon` VALUES (1, '/profile/upload/2025/07/15/defaultChatAssistant_20250715163153A001.png', '助理默认头像');
INSERT INTO `kb_icon` VALUES (2, '/profile/upload/2025/08/01/2e2c5c846f5251264d0b893b0a1008b_20250801155133A001.png', '管理端菜单栏上方图标');

-- ----------------------------
-- Table structure for kb_session
-- ----------------------------
DROP TABLE IF EXISTS `kb_session`;
CREATE TABLE `kb_session`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `session_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `chat_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_date` datetime(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_date` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 118 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of kb_session
-- ----------------------------
INSERT INTO `kb_session` VALUES (108, 'ljuzg1bdnlk2v7uyvxpsyzvycn2bxxwz', 'typescript中文简介', '1b036bf46e7611f0b8900242ac120003', NULL, '2025-08-06 09:01:59', NULL, NULL, NULL, 'admin');
INSERT INTO `kb_session` VALUES (109, 'qvi1utob0yjwxjg2cx1cks4njdu1ghvf', 'typescript有啥优势', '1b036bf46e7611f0b8900242ac120003', NULL, '2025-08-06 09:04:44', NULL, NULL, NULL, NULL);
INSERT INTO `kb_session` VALUES (110, 'sf6gyj2xva2fq7ezp7vscdvmhwl2pwjn', 'typescript有啥优势', '1b036bf46e7611f0b8900242ac120003', NULL, '2025-08-06 09:07:28', NULL, NULL, NULL, 'admin');
INSERT INTO `kb_session` VALUES (112, '6onrnlayhppeybsqfbvasals6eqrf6jl', '你好', '0a7ff4186e8111f091c60242ac120003', NULL, '2025-08-07 09:40:02', NULL, NULL, NULL, 'admin');
INSERT INTO `kb_session` VALUES (113, 'clnfbcgjualtqxptykbo94ehrz1mjbbr', '什么是TN800', '0a7ff4186e8111f091c60242ac120003', NULL, '2025-08-07 15:50:06', NULL, NULL, NULL, 'admin');
INSERT INTO `kb_session` VALUES (114, '2aurq3umurt03yqufmdxbctxfu93oft0', '什么是typescript', '1b036bf46e7611f0b8900242ac120003', NULL, '2025-08-07 15:54:25', NULL, NULL, NULL, 'admin');
INSERT INTO `kb_session` VALUES (115, 'wrzjxaqfn0m1fgdykrnupshj7eegwkod', '什么是typescript', '2ce75c026e5f11f0bc6c0242ac120003', NULL, '2025-08-07 15:55:45', NULL, NULL, NULL, 'admin');
INSERT INTO `kb_session` VALUES (116, 'kkdbbxlng9uymhtiuxhrk1oelgmzqxit', 'typescript中文简介', '0a7ff4186e8111f091c60242ac120003', NULL, '2025-08-07 16:50:37', NULL, NULL, NULL, 'test1');
INSERT INTO `kb_session` VALUES (117, '3jv5oenkhugevwtttbhxdaldesy3hnyt', '请使用中文简单介绍一下typescript', '1b036bf46e7611f0b8900242ac120003', NULL, '2025-08-07 16:51:35', NULL, NULL, NULL, 'test1');

-- ----------------------------
-- Table structure for kb_source_dept
-- ----------------------------
DROP TABLE IF EXISTS `kb_source_dept`;
CREATE TABLE `kb_source_dept`  (
  `source_id` int(11) NULL DEFAULT NULL,
  `dept_id` int(11) NULL DEFAULT NULL,
  `ancestors` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '祖级列表'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of kb_source_dept
-- ----------------------------
INSERT INTO `kb_source_dept` VALUES (2, 105, '1,2');
INSERT INTO `kb_source_dept` VALUES (7, 105, '1,7');
INSERT INTO `kb_source_dept` VALUES (7, 101, '1,7');
INSERT INTO `kb_source_dept` VALUES (5, 101, '3,5');
INSERT INTO `kb_source_dept` VALUES (6, 101, '4,6');
INSERT INTO `kb_source_dept` VALUES (7, 103, '1,7');
INSERT INTO `kb_source_dept` VALUES (5, 103, '3,5');

-- ----------------------------
-- Table structure for kb_source_file
-- ----------------------------
DROP TABLE IF EXISTS `kb_source_file`;
CREATE TABLE `kb_source_file`  (
  `id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'ID',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件名称',
  `type_id` int(20) NULL DEFAULT NULL COMMENT '文件类型',
  `tenant_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `parent_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `size` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件大小',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of kb_source_file
-- ----------------------------
INSERT INTO `kb_source_file` VALUES ('046d2a14660711f0a6d70242ac120006', 'TypeScript 极速梳理1.pdf', 1, 'f3b59dc65af011f0a5d20242ac120006', 'f3b59ed45af011f0a5d20242ac120006', '715924', '2025-07-22 17:32:36', 'admin', 'pdf');
INSERT INTO `kb_source_file` VALUES ('277a817c6dec11f0834a0242ac120003', '代理系统数据API.docx', 5, '76eeab28588b11f08ed30242ac120006', '76eeac5e588b11f08ed30242ac120006', '436166', '2025-08-01 08:52:43', 'admin', 'doc');
INSERT INTO `kb_source_file` VALUES ('513c33946deb11f09dcc0242ac120003', '表格.xls', 1, '76eeab28588b11f08ed30242ac120006', '76eeac5e588b11f08ed30242ac120006', '408064', '2025-08-01 08:32:28', 'admin', 'doc');
INSERT INTO `kb_source_file` VALUES ('911e310066d011f0b4b90242ac120006', 'a12.xls', 3, 'f3b59dc65af011f0a5d20242ac120006', 'f3b59ed45af011f0a5d20242ac120006', '701440', '2025-07-24 15:27:46', 'admin', 'doc');
INSERT INTO `kb_source_file` VALUES ('d2161d5e6c3d11f089b90242ac120003', '新建文本文档.txt', 1, '76eeab28588b11f08ed30242ac120006', '76eeac5e588b11f08ed30242ac120006', '3718', '2025-08-01 07:55:33', 'admin', 'doc');
INSERT INTO `kb_source_file` VALUES ('d95814ea6e8211f0bebf0242ac120003', '服务器说明.txt', 3, '76eeab28588b11f08ed30242ac120006', '76eeac5e588b11f08ed30242ac120006', '46', '2025-08-01 10:55:33', 'admin', 'doc');

-- ----------------------------
-- Table structure for kb_source_type
-- ----------------------------
DROP TABLE IF EXISTS `kb_source_type`;
CREATE TABLE `kb_source_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `parent_id` int(11) NULL DEFAULT NULL COMMENT '父类',
  `source_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '类别',
  `create_by` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '文件分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of kb_source_type
-- ----------------------------
INSERT INTO `kb_source_type` VALUES (1, 0, '产品文档', NULL, '2025-07-11 13:38:25', NULL, '2025-08-01 09:14:42');
INSERT INTO `kb_source_type` VALUES (2, 1, '产品设计', NULL, '2025-07-11 13:38:36', NULL, '2025-08-01 09:14:50');
INSERT INTO `kb_source_type` VALUES (3, 0, '技术文档', NULL, '2025-07-11 13:38:54', NULL, '2025-08-01 09:15:10');
INSERT INTO `kb_source_type` VALUES (4, 0, '项目资料', NULL, '2025-07-11 13:39:14', NULL, '2025-08-01 09:15:25');
INSERT INTO `kb_source_type` VALUES (5, 3, 'API接口文档', NULL, '2025-07-11 13:41:32', NULL, '2025-08-01 09:15:17');
INSERT INTO `kb_source_type` VALUES (6, 4, '项目过程文档', NULL, '2025-07-11 13:41:35', NULL, '2025-08-01 09:15:37');
INSERT INTO `kb_source_type` VALUES (7, 1, '原型', NULL, '2025-07-15 09:58:45', NULL, '2025-08-01 09:15:00');

-- ----------------------------
-- Table structure for rs_device_detial
-- ----------------------------
DROP TABLE IF EXISTS `rs_device_detial`;
CREATE TABLE `rs_device_detial`  (
  `spare_part_detailid` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `provider_id` bigint(20) NULL DEFAULT NULL COMMENT '维修服务商ID',
  `provider_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商编码',
  `provider_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商名称',
  `warehouse_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商仓库编码',
  `warehouse_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商仓库名称',
  `spare_part_unit` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备件单位',
  `spare_part_spec` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备件型号',
  `nspare_part_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '新备件名称',
  `nspare_part_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '新备件sn',
  `ospare_part_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '旧备件sn',
  `abstract` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作摘要(0.备件调拨、1.销售出库、2.备件替换）',
  `transfer_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '调拨人',
  `transfer_phone` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '调拨人联系方式',
  `transfer_time` datetime(0) NULL DEFAULT NULL COMMENT '调拨时间',
  `receive_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '接收人',
  `receive_phone` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '接收人联系方式',
  `receive_time` datetime(0) NULL DEFAULT NULL COMMENT '接收时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '说明',
  `attr1` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段1',
  `attr2` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段2',
  `attr3` int(11) NULL DEFAULT NULL COMMENT '备用字段3',
  `attr4` int(11) NULL DEFAULT NULL COMMENT '备用字段4',
  `create_id` bigint(20) NULL DEFAULT NULL COMMENT '创建人id',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_id` bigint(20) NULL DEFAULT NULL COMMENT '修改人id',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`spare_part_detailid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '备件明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rs_device_detial
-- ----------------------------
INSERT INTO `rs_device_detial` VALUES (1, 109, NULL, NULL, NULL, NULL, '43', '43', 'cfff', '443344', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', '2025-05-28 15:36:38', NULL, NULL, NULL);
INSERT INTO `rs_device_detial` VALUES (2, 108, NULL, NULL, NULL, NULL, '33', '4334', '43', '3323', NULL, '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', '2025-05-30 08:42:05', NULL, NULL, NULL);
INSERT INTO `rs_device_detial` VALUES (3, 109, NULL, NULL, NULL, NULL, '3', '4', '4', '5414', '3243', NULL, NULL, NULL, NULL, '32', '233232', '2025-05-29 00:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-30 14:00:20', NULL, NULL, NULL);
INSERT INTO `rs_device_detial` VALUES (4, 104, NULL, '研发部门11', NULL, NULL, '4343', '4343', '444', '3333', NULL, '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'admin', '2025-06-07 20:20:55', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for rs_device_inventory
-- ----------------------------
DROP TABLE IF EXISTS `rs_device_inventory`;
CREATE TABLE `rs_device_inventory`  (
  `inventory_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `provider_id` bigint(20) NULL DEFAULT NULL COMMENT '维修服务商ID',
  `provider_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商编码',
  `provider_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商名称',
  `spare_part_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备件名称',
  `spare_part_unit` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备件单位',
  `spare_part_num` int(12) NULL DEFAULT NULL COMMENT '备件本期数量',
  `spare_part_pnum` int(12) NULL DEFAULT NULL COMMENT '备件上期数量',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '说明',
  `attr1` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段1',
  `attr2` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段2',
  `attr3` int(11) NULL DEFAULT NULL COMMENT '备用字段3',
  `attr4` int(11) NULL DEFAULT NULL COMMENT '备用字段4',
  `create_id` bigint(20) NULL DEFAULT NULL COMMENT '创建人id',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_id` bigint(20) NULL DEFAULT NULL COMMENT '修改人id',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`inventory_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '备件库存表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rs_device_inventory
-- ----------------------------
INSERT INTO `rs_device_inventory` VALUES (1, 109, NULL, NULL, 'cfff', '43', 1, 1, NULL, NULL, NULL, NULL, NULL, 1, 'admin', '2025-05-28 15:36:38', NULL, NULL, NULL);
INSERT INTO `rs_device_inventory` VALUES (2, 108, NULL, NULL, '43', '33', 1, 1, NULL, NULL, NULL, NULL, NULL, 1, 'admin', '2025-05-30 08:42:05', NULL, NULL, NULL);
INSERT INTO `rs_device_inventory` VALUES (3, 104, NULL, '研发部门11', '444', '4343', 1, 1, NULL, NULL, NULL, NULL, NULL, 1, 'admin', '2025-06-07 20:20:55', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for rs_device_master
-- ----------------------------
DROP TABLE IF EXISTS `rs_device_master`;
CREATE TABLE `rs_device_master`  (
  `spare_part_masterid` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `provider_id` bigint(20) NULL DEFAULT NULL COMMENT '维修服务商ID',
  `provider_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商编码',
  `provider_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商名称',
  `warehouse_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商仓库编码',
  `warehouse_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商仓库名称',
  `spare_part_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备件名称',
  `spare_part_unit` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备件单位',
  `spare_part_spec` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备件型号',
  `spare_part_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备件sn',
  `spare_part_status` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备件状态(0:正常1:作废)',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '说明',
  `attr1` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段1',
  `attr2` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段2',
  `attr3` int(11) NULL DEFAULT NULL COMMENT '备用字段3',
  `attr4` int(11) NULL DEFAULT NULL COMMENT '备用字段4',
  `create_id` bigint(20) NULL DEFAULT NULL COMMENT '创建人id',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_id` bigint(20) NULL DEFAULT NULL COMMENT '修改人id',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`spare_part_masterid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '备件主表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rs_device_master
-- ----------------------------
INSERT INTO `rs_device_master` VALUES (1, 104, NULL, NULL, NULL, NULL, '432', '33', '33', '22', '01', '3232', NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-28 15:14:53', NULL, NULL, NULL);
INSERT INTO `rs_device_master` VALUES (2, 104, NULL, NULL, NULL, NULL, 'xxx', '33', '22', 'dds', '01', '333', NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-28 15:21:10', NULL, NULL, NULL);
INSERT INTO `rs_device_master` VALUES (3, 109, NULL, NULL, NULL, NULL, 'cfff', '43', '43', '443344', '01', '3tt', NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-28 15:36:38', NULL, NULL, NULL);
INSERT INTO `rs_device_master` VALUES (4, 108, NULL, NULL, NULL, NULL, '433', '33', '4334', '3323', '02', 'dds', NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-30 08:42:05', NULL, NULL, '2025-05-30 08:42:15');
INSERT INTO `rs_device_master` VALUES (5, 104, NULL, '研发部门11', NULL, NULL, '444', '4343', '4343', '3333', '01', NULL, NULL, NULL, NULL, NULL, 103, 'admin', '2025-06-07 20:20:55', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for rs_repair_service_provider
-- ----------------------------
DROP TABLE IF EXISTS `rs_repair_service_provider`;
CREATE TABLE `rs_repair_service_provider`  (
  `provider_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `provider_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商编码',
  `provider_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商名称',
  `provider_charge` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商负责人',
  `provider_contact_person` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商联系人',
  `provider_contact_phone` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商联系方式',
  `province_id` bigint(20) NULL DEFAULT NULL COMMENT '省ID',
  `province` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '省',
  `city_id` bigint(20) NULL DEFAULT NULL COMMENT '市ID',
  `city` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '市',
  `district_id` bigint(20) NULL DEFAULT NULL COMMENT '区(县)ID',
  `district` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '区(县)',
  `service_region` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商归属区域',
  `is_del` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否删除(0:正常,1:删除)',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '说明',
  `attr1` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段1',
  `attr2` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段2',
  `attr3` int(11) NULL DEFAULT NULL COMMENT '备用字段3',
  `attr4` int(11) NULL DEFAULT NULL COMMENT '备用字段4',
  `create_id` bigint(20) NULL DEFAULT NULL COMMENT '创建人id',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_id` bigint(20) NULL DEFAULT NULL COMMENT '修改人id',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`provider_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '维修服务商管理' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rs_repair_service_provider
-- ----------------------------

-- ----------------------------
-- Table structure for rs_repair_service_spare_parts
-- ----------------------------
DROP TABLE IF EXISTS `rs_repair_service_spare_parts`;
CREATE TABLE `rs_repair_service_spare_parts`  (
  `spare_part_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `provider_id` bigint(20) NULL DEFAULT NULL COMMENT '维修服务商ID',
  `provider_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商编码',
  `provider_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商名称',
  `warehouse_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商仓库编码',
  `warehouse_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商仓库名称',
  `spare_part_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备件名称',
  `spare_part_unit` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备件单位',
  `spare_part_spec` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备件型号',
  `spare_part_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备件编码',
  `transfer_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '调拨人',
  `transfer_phone` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '调拨人联系方式',
  `transfer_time` datetime(0) NULL DEFAULT NULL COMMENT '调拨时间',
  `receive_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '接收人',
  `receive_phone` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '接收人联系方式',
  `receive_time` datetime(0) NULL DEFAULT NULL COMMENT '接收时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '说明',
  `attr1` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段1',
  `attr2` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段2',
  `attr3` int(11) NULL DEFAULT NULL COMMENT '备用字段3',
  `attr4` int(11) NULL DEFAULT NULL COMMENT '备用字段4',
  `create_id` bigint(20) NULL DEFAULT NULL COMMENT '创建人id',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_id` bigint(20) NULL DEFAULT NULL COMMENT '修改人id',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`spare_part_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '维修服务商备件表管理' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rs_repair_service_spare_parts
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int(5) NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 106 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2025-05-18 09:13:55', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2025-05-18 09:13:55', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2025-05-18 09:13:55', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2025-05-18 09:13:55', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2025-05-18 09:13:55', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2025-05-18 09:13:55', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (100, 'RagFlowKey', 'RagFlowKey', 'ragflow-IzYmQzNjQyNThhNzExZjBiZWJjMDI0Mm', 'Y', 'admin', '2025-06-27 05:18:56', 'admin', '2025-07-04 07:19:07', NULL);
INSERT INTO `sys_config` VALUES (101, 'RagFlowServerBaseUrl', 'RagFlowServerBaseUrl', 'http://115.190.113.86', 'Y', 'admin', '2025-06-30 07:35:00', 'admin', '2025-07-24 07:42:11', NULL);
INSERT INTO `sys_config` VALUES (102, 'BaseServerUrl', 'BaseServerUrl', 'http://192.168.0.22:8099', 'Y', 'admin', '2025-07-04 07:13:30', 'admin', '2025-07-04 07:19:11', NULL);
INSERT INTO `sys_config` VALUES (103, 'Ragflow登录密码', 'password', 'LkNlN/YAg/wGNDriVL/EnYLQr7/1FfFkG5HNfZNPZ5EeswrxCgd2Uh8ldxf1TUbZYrpwvjPejnZV5BS2ZZATIuyr4peqbRUZTv3Ca91LdUE8KytpEQgiCs31+/Gm/i00ixRJAC9x3z6PLZxNQeXEUO22AZ/wy85HKtxlHprgGLtGsCSLwUc1booMR3GRaoLU+7NASQCNyOAEHoJFkPCYVreRPiNzrPUrzTVEqQdSx9qKdmLtdMG5paF3FCxkZdnPEKAPTctNxcaqcpLk2sWPX0vtvucrjORh1ze+ean8lOTRpGpViv8eklkY86CtaB+3LDxJS541Yq6jWHMwrZItPA==', 'Y', 'admin', '2025-07-15 07:31:00', 'admin', '2025-07-31 22:29:40', NULL);
INSERT INTO `sys_config` VALUES (104, 'Ragflow登录邮箱', 'email', 'ssrtzpw@126.com', 'Y', 'admin', '2025-07-15 07:31:53', 'admin', '2025-07-31 22:29:56', NULL);
INSERT INTO `sys_config` VALUES (105, 'RagFlow认证过期时间', 'CACHE_EXPIRE_TIME', '30', 'Y', 'admin', '2025-07-17 08:46:11', 'admin', '2025-07-17 08:51:01', '单位：分钟');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `provider_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商编码',
  `provider_contact_person` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商联系人',
  `province_id` bigint(20) NULL DEFAULT NULL COMMENT '省ID',
  `province` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '省',
  `city_id` bigint(20) NULL DEFAULT NULL COMMENT '市ID',
  `city` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '市',
  `district_id` bigint(20) NULL DEFAULT NULL COMMENT '区(县)ID',
  `district` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '区(县)',
  `service_region` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '维修服务商归属区域',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '说明',
  `attr1` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段1',
  `attr2` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段2',
  `attr3` int(11) NULL DEFAULT NULL COMMENT '备用字段3',
  `attr4` int(11) NULL DEFAULT NULL COMMENT '备用字段4',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '总公司', 0, '', '', '', '0', '0', 'admin', '2025-05-18 09:13:55', 'admin', '2025-07-04 08:54:33', NULL, NULL, 0, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '大模型', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-05-18 09:13:55', 'admin', '2025-07-04 08:54:44', NULL, NULL, 0, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2025-05-18 09:13:55', '', NULL, NULL, NULL, 0, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门1', 1, 'ffff', '15888888888', '', '0', '0', 'admin', '2025-05-18 09:13:55', 'admin', '2025-07-04 08:54:55', NULL, 'ccc', 0, NULL, 0, NULL, 0, NULL, '333', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2025-05-18 09:13:55', '', NULL, NULL, NULL, 0, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '研发部门2', 3, '', '15888888888', '', '0', '0', 'admin', '2025-05-18 09:13:55', 'admin', '2025-07-04 08:55:03', NULL, NULL, 0, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2025-05-18 09:13:55', '', NULL, NULL, NULL, 0, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2025-05-18 09:13:55', '', NULL, NULL, NULL, 0, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2025-05-18 09:13:55', '', NULL, NULL, NULL, 0, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2025-05-18 09:13:55', '', NULL, NULL, NULL, 0, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for sys_dept_copy1
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept_copy1`;
CREATE TABLE `sys_dept_copy1`  (
  `dept_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept_copy1
-- ----------------------------
INSERT INTO `sys_dept_copy1` VALUES (100, 0, '0', '环球电池集团', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-05-18 09:13:55', 'admin', '2025-05-19 22:08:43');
INSERT INTO `sys_dept_copy1` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-05-18 09:13:55', '', NULL);
INSERT INTO `sys_dept_copy1` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-05-18 09:13:55', '', NULL);
INSERT INTO `sys_dept_copy1` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-05-18 09:13:55', '', NULL);
INSERT INTO `sys_dept_copy1` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-05-18 09:13:55', '', NULL);
INSERT INTO `sys_dept_copy1` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-05-18 09:13:55', '', NULL);
INSERT INTO `sys_dept_copy1` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-05-18 09:13:55', '', NULL);
INSERT INTO `sys_dept_copy1` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-05-18 09:13:55', '', NULL);
INSERT INTO `sys_dept_copy1` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-05-18 09:13:55', '', NULL);
INSERT INTO `sys_dept_copy1` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-05-18 09:13:55', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int(4) NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 109 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (100, 1, '产品', '0', 'issue_type', NULL, 'default', 'N', '0', 'admin', '2025-06-07 09:03:54', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (101, 2, '备件', '1', 'issue_type', NULL, 'default', 'N', '0', 'admin', '2025-06-07 09:04:07', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (102, 1, '一般', '1', 'issue_level', NULL, 'default', 'N', '0', 'admin', '2025-06-07 09:12:59', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (103, 2, '严重', '2', 'issue_level', NULL, 'default', 'N', '0', 'admin', '2025-06-07 09:13:11', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (104, 0, '非常严重', '3', 'issue_level', NULL, 'default', 'N', '0', 'admin', '2025-06-07 09:13:20', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (105, 1, '待处理', '0', 'issue_status', NULL, 'default', 'N', '0', 'admin', '2025-06-07 11:34:18', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (106, 2, '处理中', '1', 'issue_status', NULL, 'default', 'N', '0', 'admin', '2025-06-07 11:34:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (107, 3, '已解决', '3', 'issue_status', NULL, 'default', 'N', '0', 'admin', '2025-06-07 11:34:50', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 103 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (100, '问题类型', 'issue_type', '0', 'admin', '2025-06-07 09:01:24', 'admin', '2025-06-07 09:01:47', NULL);
INSERT INTO `sys_dict_type` VALUES (101, '问题等级', 'issue_level', '0', 'admin', '2025-06-07 09:12:29', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (102, '问题状态', 'issue_status', '0', 'admin', '2025-06-07 11:33:56', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '定时任务调度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2025-05-18 09:13:55', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime(0) NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status`) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1036 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统访问记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int(1) NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int(1) NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2078 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2025-05-18 09:13:55', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2025-05-18 09:13:55', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2025-05-18 09:13:55', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (5, '智能问答助手', 0, 1, 'assistant', NULL, '', '', 1, 0, 'M', '0', '0', '', 'documentation', 'admin', '2025-05-18 09:13:55', 'admin', '2025-08-01 03:05:23', '售后管理目录');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2025-05-18 09:13:55', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2025-05-18 09:13:55', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2025-05-18 09:13:55', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2025-05-18 09:13:55', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2025-05-18 09:13:55', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2025-05-18 09:13:55', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2025-05-18 09:13:55', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2025-05-18 09:13:55', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2025-05-18 09:13:55', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2025-05-18 09:13:55', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2025-05-18 09:13:55', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2025-05-18 09:13:55', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2025-05-18 09:13:55', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2025-05-18 09:13:55', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2025-05-18 09:13:55', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2025-05-18 09:13:55', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2025-05-18 09:13:55', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2025-05-18 09:13:55', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2025-05-18 09:13:55', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2025-05-18 09:13:55', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2046, '知识库管理', 5, 9, 'manual', 'customApp/manual', NULL, 'manual', 1, 0, 'C', '0', '0', '', 'pdf', 'admin', '2025-06-16 02:18:58', 'admin', '2025-07-25 01:31:12', '');
INSERT INTO `sys_menu` VALUES (2047, '代码测试页', 5, 999, 'deepseek', 'ai/chat/index-deepseek', NULL, '', 1, 0, 'C', '0', '0', '', 'star', 'admin', '2025-06-18 10:33:36', 'admin', '2025-07-24 08:11:04', '');
INSERT INTO `sys_menu` VALUES (2050, '配置助理', 5, 2, 'assistantConfig', 'customApp/assistantConfig', NULL, 'assistantConfig', 1, 0, 'C', '0', '0', '', 'validCode', 'admin', '2025-06-26 07:25:43', 'admin', '2025-07-25 01:29:39', '');
INSERT INTO `sys_menu` VALUES (2051, '智能问答', 0, 6, 'ops_solutions', 'customApp/ops_solutions', NULL, 'ops_solutions', 1, 0, 'C', '0', '0', 'ops_solutions', 'education', 'admin', '2025-06-26 07:33:56', 'admin', '2025-08-05 01:44:40', '');
INSERT INTO `sys_menu` VALUES (2052, '知识检索', 0, 7, 'fault_tracing', 'customApp/faultTracing', NULL, 'fault_tracing', 1, 0, 'C', '0', '0', 'fault_tracing', 'bug', 'admin', '2025-06-26 07:41:29', 'admin', '2025-08-05 01:44:47', '');
INSERT INTO `sys_menu` VALUES (2053, '模型管理', 5, 8, 'model', 'customApp/model', NULL, 'model', 1, 0, 'C', '0', '0', '', 'code', 'admin', '2025-06-26 07:59:49', 'admin', '2025-07-25 01:31:17', '');
INSERT INTO `sys_menu` VALUES (2054, '智能问答(记录)', 5, 2, 'assitantSession', 'customApp/assitantSession', NULL, 'assitantSession', 1, 0, 'C', '1', '1', '', 'build', 'admin', '2025-06-27 08:51:45', 'admin', '2025-07-10 00:59:25', '');
INSERT INTO `sys_menu` VALUES (2055, '智能问答(对话)', 5, 3, 'ops_solutions_chat', 'customApp/ops_solutions_chat', NULL, 'ops_solutions_chat', 1, 0, 'C', '1', '1', '', 'build', 'admin', '2025-06-27 09:23:10', 'admin', '2025-07-10 00:59:28', '');
INSERT INTO `sys_menu` VALUES (2056, '图标管理', 1, 1, 'icon', 'kb/icon/index', NULL, '', 1, 0, 'C', '0', '0', 'kb:icon:list', 'icon', 'admin', '2025-07-04 01:03:07', 'admin', '2025-07-09 05:56:43', '图标管理菜单');
INSERT INTO `sys_menu` VALUES (2057, '图标管理查询', 2056, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'kb:icon:query', '#', 'admin', '2025-07-04 01:03:07', 'admin', '2025-07-04 10:18:15', '');
INSERT INTO `sys_menu` VALUES (2058, '图标管理新增', 2056, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'kb:icon:add', '#', 'admin', '2025-07-04 01:03:07', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2059, '图标管理修改', 2056, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'kb:icon:edit', '#', 'admin', '2025-07-04 01:03:07', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2060, '图标管理删除', 2056, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'kb:icon:remove', '#', 'admin', '2025-07-04 01:03:07', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2061, '图标管理导出', 2056, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'kb:icon:export', '#', 'admin', '2025-07-04 01:03:07', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2064, '手册文件', 5, 7, 'fileManage', 'customApp/fileManage', NULL, 'fileManage', 1, 0, 'C', '1', '0', 'fileManage', 'documentation', 'admin', '2025-07-04 10:32:16', 'admin', '2025-08-04 05:31:47', '');
INSERT INTO `sys_menu` VALUES (2065, '文件分类', 5, 6, 'type', 'kb/type/index', NULL, '', 1, 0, 'C', '0', '0', 'kb:type:list', 'tree', 'admin', '2025-07-11 05:29:28', 'admin', '2025-07-25 01:30:29', '文件分类菜单');
INSERT INTO `sys_menu` VALUES (2066, '文件分类查询', 2065, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'kb:type:query', '#', 'admin', '2025-07-11 05:29:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2067, '文件分类新增', 2065, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'kb:type:add', '#', 'admin', '2025-07-11 05:29:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2068, '文件分类修改', 2065, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'kb:type:edit', '#', 'admin', '2025-07-11 05:29:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2069, '文件分类删除', 2065, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'kb:type:remove', '#', 'admin', '2025-07-11 05:29:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2070, '文件分类导出', 2065, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'kb:type:export', '#', 'admin', '2025-07-11 05:29:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2071, '文件管理', 5, 5, 'fileConfig', 'customApp/fileManager/fileConfig', NULL, '', 1, 0, 'C', '0', '0', '', 'documentation', 'admin', '2025-07-21 06:11:26', 'admin', '2025-07-25 01:30:24', '');
INSERT INTO `sys_menu` VALUES (2072, '文件查看', 5, 4, 'file', 'kb/file/index', NULL, '', 1, 0, 'C', '0', '0', 'kb:file:list', 'component', 'admin', '2025-07-22 07:55:30', 'admin', '2025-07-25 01:30:15', '文件配置菜单');
INSERT INTO `sys_menu` VALUES (2073, '文件查看查询', 2072, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'kb:file:query', '#', 'admin', '2025-07-22 07:55:30', 'admin', '2025-07-23 01:16:00', '');
INSERT INTO `sys_menu` VALUES (2074, '文件查看新增', 2072, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'kb:file:add', '#', 'admin', '2025-07-22 07:55:30', 'admin', '2025-07-23 01:16:05', '');
INSERT INTO `sys_menu` VALUES (2075, '文件查看修改', 2072, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'kb:file:edit', '#', 'admin', '2025-07-22 07:55:30', 'admin', '2025-07-23 01:16:13', '');
INSERT INTO `sys_menu` VALUES (2076, '文件查看删除', 2072, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'kb:file:remove', '#', 'admin', '2025-07-22 07:55:30', 'admin', '2025-07-23 01:16:17', '');
INSERT INTO `sys_menu` VALUES (2077, '文件查看导出', 2072, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'kb:file:export', '#', 'admin', '2025-07-22 07:55:30', 'admin', '2025-07-23 01:16:22', '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int(4) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2025-05-18 09:13:55', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2025-05-18 09:13:55', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int(2) NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int(1) NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int(1) NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime(0) NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint(20) NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type`) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status`) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1143 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '操作日志记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int(4) NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '岗位信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2025-05-18 09:13:55', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2025-05-18 09:13:55', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(4) NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2025-05-18 09:13:55', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '管理员', 'system', 2, '2', 1, 1, '0', '0', 'admin', '2025-05-18 09:13:55', 'admin', '2025-07-16 00:38:20', '普通角色');
INSERT INTO `sys_role` VALUES (100, '普通用户', 'common', 2, '1', 1, 1, '0', '0', 'admin', '2025-08-01 03:00:46', 'admin', '2025-08-06 00:47:35', NULL);

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `dept_id` bigint(20) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色和部门关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 5);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 2046);
INSERT INTO `sys_role_menu` VALUES (2, 2050);
INSERT INTO `sys_role_menu` VALUES (2, 2051);
INSERT INTO `sys_role_menu` VALUES (2, 2052);
INSERT INTO `sys_role_menu` VALUES (2, 2053);
INSERT INTO `sys_role_menu` VALUES (2, 2054);
INSERT INTO `sys_role_menu` VALUES (2, 2055);
INSERT INTO `sys_role_menu` VALUES (2, 2056);
INSERT INTO `sys_role_menu` VALUES (2, 2057);
INSERT INTO `sys_role_menu` VALUES (2, 2058);
INSERT INTO `sys_role_menu` VALUES (2, 2059);
INSERT INTO `sys_role_menu` VALUES (2, 2060);
INSERT INTO `sys_role_menu` VALUES (2, 2061);
INSERT INTO `sys_role_menu` VALUES (2, 2065);
INSERT INTO `sys_role_menu` VALUES (2, 2066);
INSERT INTO `sys_role_menu` VALUES (2, 2067);
INSERT INTO `sys_role_menu` VALUES (2, 2068);
INSERT INTO `sys_role_menu` VALUES (2, 2069);
INSERT INTO `sys_role_menu` VALUES (2, 2070);
INSERT INTO `sys_role_menu` VALUES (100, 2051);
INSERT INTO `sys_role_menu` VALUES (100, 2052);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint(20) NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime(0) NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '管理员', '00', 'admin@163.com', '15888888888', '0', '/profile/avatar/2025/07/21/homeImg_20250721133845A001.png', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '122.139.63.162', '2025-08-07 16:14:31', 'admin', '2025-05-18 09:13:55', '', '2025-08-07 08:14:30', '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '张小明', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '2', '127.0.0.1', '2025-05-18 09:13:55', 'admin', '2025-05-18 09:13:55', 'admin', '2025-05-19 22:09:20', '测试员');
INSERT INTO `sys_user` VALUES (100, 103, 'system', 'system', '00', '', '', '0', '', '$2a$10$lhzL56PQ7Sb/sjCx2rmijOCS9pOoi3lJkQjLKMuZQLAJWS4xlC/N.', '0', '0', '122.139.63.162', '2025-08-05 08:26:03', 'admin', '2025-07-04 08:55:44', '', '2025-08-05 00:26:02', NULL);
INSERT INTO `sys_user` VALUES (101, 103, 'test1', 'test1', '00', '', '', '0', '', '$2a$10$U7MXyXp.Dy4Lg1BbUyl49eMzlowWpwCXxpcIxTDbk9LXUg9URY35u', '0', '0', '122.139.63.162', '2025-08-07 16:50:08', 'admin', '2025-08-01 03:01:27', '', '2025-08-07 08:50:08', NULL);

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `post_id` bigint(20) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (100, 2);
INSERT INTO `sys_user_role` VALUES (101, 100);

SET FOREIGN_KEY_CHECKS = 1;
