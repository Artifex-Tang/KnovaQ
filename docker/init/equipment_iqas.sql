
-- MySQL dump 10.13  Distrib 8.0.39, for Linux (x86_64)
--
-- Host: localhost    Database: equipment_iqas
-- ------------------------------------------------------
-- Server version	8.0.39

-- KnovaQ: mysqldump omits CREATE DATABASE/USE; add them so initdb.d has a target schema
CREATE DATABASE IF NOT EXISTS `equipment_iqas` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `equipment_iqas`;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `QRTZ_BLOB_TRIGGERS`
--

DROP TABLE IF EXISTS `QRTZ_BLOB_TRIGGERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `QRTZ_BLOB_TRIGGERS` (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_BLOB_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='Blob类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_BLOB_TRIGGERS`
--

LOCK TABLES `QRTZ_BLOB_TRIGGERS` WRITE;
/*!40000 ALTER TABLE `QRTZ_BLOB_TRIGGERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_BLOB_TRIGGERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `QRTZ_CALENDARS`
--

DROP TABLE IF EXISTS `QRTZ_CALENDARS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `QRTZ_CALENDARS` (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`,`calendar_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='日历信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_CALENDARS`
--

LOCK TABLES `QRTZ_CALENDARS` WRITE;
/*!40000 ALTER TABLE `QRTZ_CALENDARS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_CALENDARS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `QRTZ_CRON_TRIGGERS`
--

DROP TABLE IF EXISTS `QRTZ_CRON_TRIGGERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `QRTZ_CRON_TRIGGERS` (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_CRON_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='Cron类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_CRON_TRIGGERS`
--

LOCK TABLES `QRTZ_CRON_TRIGGERS` WRITE;
/*!40000 ALTER TABLE `QRTZ_CRON_TRIGGERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_CRON_TRIGGERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `QRTZ_FIRED_TRIGGERS`
--

DROP TABLE IF EXISTS `QRTZ_FIRED_TRIGGERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `QRTZ_FIRED_TRIGGERS` (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`,`entry_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='已触发的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_FIRED_TRIGGERS`
--

LOCK TABLES `QRTZ_FIRED_TRIGGERS` WRITE;
/*!40000 ALTER TABLE `QRTZ_FIRED_TRIGGERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_FIRED_TRIGGERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `QRTZ_JOB_DETAILS`
--

DROP TABLE IF EXISTS `QRTZ_JOB_DETAILS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `QRTZ_JOB_DETAILS` (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`job_name`,`job_group`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='任务详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_JOB_DETAILS`
--

LOCK TABLES `QRTZ_JOB_DETAILS` WRITE;
/*!40000 ALTER TABLE `QRTZ_JOB_DETAILS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_JOB_DETAILS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `QRTZ_LOCKS`
--

DROP TABLE IF EXISTS `QRTZ_LOCKS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `QRTZ_LOCKS` (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`,`lock_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='存储的悲观锁信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_LOCKS`
--

LOCK TABLES `QRTZ_LOCKS` WRITE;
/*!40000 ALTER TABLE `QRTZ_LOCKS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_LOCKS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `QRTZ_PAUSED_TRIGGER_GRPS`
--

DROP TABLE IF EXISTS `QRTZ_PAUSED_TRIGGER_GRPS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `QRTZ_PAUSED_TRIGGER_GRPS` (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`,`trigger_group`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='暂停的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_PAUSED_TRIGGER_GRPS`
--

LOCK TABLES `QRTZ_PAUSED_TRIGGER_GRPS` WRITE;
/*!40000 ALTER TABLE `QRTZ_PAUSED_TRIGGER_GRPS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_PAUSED_TRIGGER_GRPS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `QRTZ_SCHEDULER_STATE`
--

DROP TABLE IF EXISTS `QRTZ_SCHEDULER_STATE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `QRTZ_SCHEDULER_STATE` (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`,`instance_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='调度器状态表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_SCHEDULER_STATE`
--

LOCK TABLES `QRTZ_SCHEDULER_STATE` WRITE;
/*!40000 ALTER TABLE `QRTZ_SCHEDULER_STATE` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_SCHEDULER_STATE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `QRTZ_SIMPLE_TRIGGERS`
--

DROP TABLE IF EXISTS `QRTZ_SIMPLE_TRIGGERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `QRTZ_SIMPLE_TRIGGERS` (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPLE_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='简单触发器的信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_SIMPLE_TRIGGERS`
--

LOCK TABLES `QRTZ_SIMPLE_TRIGGERS` WRITE;
/*!40000 ALTER TABLE `QRTZ_SIMPLE_TRIGGERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_SIMPLE_TRIGGERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `QRTZ_SIMPROP_TRIGGERS`
--

DROP TABLE IF EXISTS `QRTZ_SIMPROP_TRIGGERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `QRTZ_SIMPROP_TRIGGERS` (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPROP_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='同步机制的行锁表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_SIMPROP_TRIGGERS`
--

LOCK TABLES `QRTZ_SIMPROP_TRIGGERS` WRITE;
/*!40000 ALTER TABLE `QRTZ_SIMPROP_TRIGGERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_SIMPROP_TRIGGERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `QRTZ_TRIGGERS`
--

DROP TABLE IF EXISTS `QRTZ_TRIGGERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `QRTZ_TRIGGERS` (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  KEY `sched_name` (`sched_name`,`job_name`,`job_group`) USING BTREE,
  CONSTRAINT `QRTZ_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `QRTZ_JOB_DETAILS` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='触发器详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_TRIGGERS`
--

LOCK TABLES `QRTZ_TRIGGERS` WRITE;
/*!40000 ALTER TABLE `QRTZ_TRIGGERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_TRIGGERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table`
--

DROP TABLE IF EXISTS `gen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table` (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--


--
-- Table structure for table `gen_table_column`
--

DROP TABLE IF EXISTS `gen_table_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table_column` (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=519 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--


--
-- Table structure for table `ir_issue_recode`
--

DROP TABLE IF EXISTS `ir_issue_recode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ir_issue_recode` (
  `issue_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `issue_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '问题编码',
  `issue_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '问题名称',
  `receive_time` datetime DEFAULT NULL COMMENT '问题接收时间',
  `receive_id` bigint DEFAULT NULL COMMENT '接收人ID',
  `receive_by` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '接收人',
  `dept_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '接收人所属部门或公司',
  `customer_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '问题反馈客户名称',
  `contact_person` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '问题反馈人',
  `contact_phone` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '反馈人联系方式',
  `product_id` bigint DEFAULT NULL COMMENT '关联产品ID',
  `product_sn` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '产品SN',
  `product_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '产品名称',
  `product_spec` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '产品型号',
  `issue_type` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '问题类别',
  `issue_level` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '问题等级',
  `service_engineer` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '负责工程师',
  `device_sn` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '问题设备SN码',
  `device_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '问题设备名称',
  `status` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '问题状态(0:待处理,1:处理中,2:已解决,3:已关闭)',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '说明',
  `attr1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备用字段1',
  `attr2` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备用字段2',
  `attr3` int DEFAULT NULL COMMENT '备用字段3',
  `attr4` int DEFAULT NULL COMMENT '备用字段4',
  `create_id` bigint DEFAULT NULL COMMENT '创建人id',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_id` bigint DEFAULT NULL COMMENT '修改人id',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`issue_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='售后问题登记';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ir_issue_recode`
--


--
-- Table structure for table `ir_shelf_life`
--

DROP TABLE IF EXISTS `ir_shelf_life`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ir_shelf_life` (
  `shelf_life_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `provider_id` bigint DEFAULT NULL COMMENT '维修服务商ID',
  `provider_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商编码',
  `provider_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商名称',
  `product_id` bigint DEFAULT NULL COMMENT '产品ID',
  `product_sn` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '产品SN',
  `product_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '产品名称',
  `product_spec` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '产品型号',
  `sqare_part_sn` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备件SN',
  `spare_part_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备件名称',
  `spare_part_spec` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备件型号',
  `product_sellby_date` datetime DEFAULT NULL COMMENT '产品包质期',
  `spare_sellby_date` datetime DEFAULT NULL COMMENT '备件保质期',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '说明',
  `attr1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备用字段1',
  `attr2` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备用字段2',
  `attr3` int DEFAULT NULL COMMENT '备用字段3',
  `attr4` int DEFAULT NULL COMMENT '备用字段4',
  `create_id` bigint DEFAULT NULL COMMENT '创建人id',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_id` bigint DEFAULT NULL COMMENT '修改人id',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`shelf_life_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=378 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='销售订单产品保质期维护';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ir_shelf_life`
--

LOCK TABLES `ir_shelf_life` WRITE;
/*!40000 ALTER TABLE `ir_shelf_life` DISABLE KEYS */;
INSERT INTO `ir_shelf_life` VALUES (343,NULL,NULL,NULL,2289,'020020010007ZJ310006','490型球台接口扩展板半成品板','PTIEB板，490PTIEB','02.002.001.0007',NULL,NULL,'2025-06-23 00:00:00',NULL,NULL,NULL,NULL,0,NULL,1,'admin','2025-06-12 13:07:40',NULL,NULL,NULL),(344,NULL,NULL,NULL,3592,'020020010007ZJ310006','10kΩ，0603，1%，1/10W贴片电阻','0603 F1002T5E','02.002.001.0007 V1.2',NULL,NULL,'2025-06-15 00:00:00',NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:40',NULL,NULL,NULL),(345,NULL,NULL,NULL,3600,'020020010007ZJ310006','100Ω，0603，1%，1/10W贴片电阻','0603 F1000T5E','02.002.001.0007 V1.2',NULL,NULL,'2025-06-28 00:00:00',NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:40',NULL,NULL,NULL),(346,NULL,NULL,NULL,3601,'020020010007ZJ310006','120Ω，0603，1%，1/10W贴片电阻','0603 F1200T5E','02.002.001.0007 V1.2',NULL,NULL,'2025-06-04 00:00:00',NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:40',NULL,NULL,'2025-06-12 14:20:27'),(347,NULL,NULL,NULL,3609,'020020010007ZJ310006','2.2kΩ，0603，1%，1/10W贴片电阻','0603 F2201T5E','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:40',NULL,NULL,NULL),(348,NULL,NULL,NULL,3618,'020020010007ZJ310006','15Ω ，2512，5%，2W贴片电阻','CR2512J15RE042W','02.002.001.0007 V1.2',NULL,NULL,'2025-06-11 00:00:00',NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:40',NULL,NULL,NULL),(349,NULL,NULL,NULL,3739,'020020010007ZJ310006','470uF+/-20%，50V插件铝电解电容','CD282-50V-470uF+/-20%或者ECR1HXX471MLL125020','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:40',NULL,NULL,NULL),(350,NULL,NULL,NULL,3741,'020020010007ZJ310006','0.1uF，0603，50V陶瓷电容','GRM188R71H104KA93D','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:40',NULL,NULL,NULL),(351,NULL,NULL,NULL,3749,'020020010007ZJ310006','22uF，0805，10V陶瓷电容','GRM21BR61A226ME51L','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:40',NULL,NULL,NULL),(352,NULL,NULL,NULL,3754,'020020010007ZJ310006','3300pF，1812，2KV陶瓷电容','CC1812KKX7RDBB332','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:40',NULL,NULL,NULL),(353,NULL,NULL,NULL,3760,'020020010007ZJ310006','0.01uF，0603，100V陶瓷电容','GRM188R72A103KA01D','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:40',NULL,NULL,NULL),(354,NULL,NULL,NULL,3764,'020020010007ZJ310006','1000pF，1206，2000V陶瓷电容','CC1206KKX7RDBB102','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:40',NULL,NULL,NULL),(355,NULL,NULL,NULL,3765,'020020010007ZJ310006','10uF，1206，25V陶瓷电容','GRM31CR61E106KA12L','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:40',NULL,NULL,NULL),(356,NULL,NULL,NULL,3910,'020020010007ZJ310006','3.3V，UART转422转换器','ADM3490EARZ','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:40',NULL,NULL,NULL),(357,NULL,NULL,NULL,3911,'020020010007ZJ310006','UART转RS232芯片','ADM3202ARN','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:40',NULL,NULL,NULL),(358,NULL,NULL,NULL,3922,'020020010007ZJ310006','3.3V，2K米通讯距离RS-485芯片','SN65HVD72D','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:41',NULL,NULL,NULL),(359,NULL,NULL,NULL,3997,'020020010007ZJ310006','开关二极管','LL4148-GS08','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:41',NULL,NULL,NULL),(360,NULL,NULL,NULL,4000,'020020010007ZJ310006','NPN晶体管','MMBT3904LT1G','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:41',NULL,NULL,NULL),(361,NULL,NULL,NULL,4004,'020020010007ZJ310006','贴片光耦','PS2501L-1-F3-A','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:41',NULL,NULL,NULL),(362,NULL,NULL,NULL,4050,'020020010007ZJ310006','490型球台接口扩展板PCB板','490PTIEB_V1.2_180601','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:41',NULL,NULL,NULL),(363,NULL,NULL,NULL,4071,'020020010007ZJ310006','12V，1A单极性继电器','G6K-2F-Y-DC12V','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:41',NULL,NULL,NULL),(364,NULL,NULL,NULL,4111,'020020010007ZJ310006','3端90V气体放电管','B3D090M-C','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:41',NULL,NULL,NULL),(365,NULL,NULL,NULL,4112,'020020010007ZJ310006','2端6V半导体放电管','BS0060N-C-F','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:41',NULL,NULL,NULL),(366,NULL,NULL,NULL,4115,'020020010007ZJ310006','4A自恢复保险丝','JK30-400','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:41',NULL,NULL,NULL),(367,NULL,NULL,NULL,4118,'020020010007ZJ310006','1.5kW，6V开启TVS管','SMCJ6.0CA','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:41',NULL,NULL,NULL),(368,NULL,NULL,NULL,4119,'020020010007ZJ310006','3端20V半导体放电管','BV-SMBT-20CA','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:41',NULL,NULL,NULL),(369,NULL,NULL,NULL,4120,'020020010007ZJ310006','3端ESD防护','BV-SM712','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:41',NULL,NULL,NULL),(370,NULL,NULL,NULL,4282,'020020010007ZJ310006','2芯3.81间距凤凰端子立式插座','TBP1381S-2P','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:41',NULL,NULL,NULL),(371,NULL,NULL,NULL,4283,'020020010007ZJ310006','3芯3.81间距凤凰端子立式插座','TBP1381S-3P','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:41',NULL,NULL,NULL),(372,NULL,NULL,NULL,4284,'020020010007ZJ310006','4芯3.81间距凤凰端子立式插座','TBP1381S-4P','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:41',NULL,NULL,NULL),(373,NULL,NULL,NULL,4285,'020020010007ZJ310006','6芯3.81间距凤凰端子立式插座','TBP1381S-6P','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:41',NULL,NULL,NULL),(374,NULL,NULL,NULL,4290,'020020010007ZJ310006','2芯2.54间距插针用跳帽','206-6A','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:41',NULL,NULL,NULL),(375,NULL,NULL,NULL,4295,'020020010007ZJ310006','双排2.54间距2x3插针','201S-2x3P-NS','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:41',NULL,NULL,NULL),(376,NULL,NULL,NULL,4340,'020020010007ZJ310006','2X15 2.54间距立式插针','201S-2X15P','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:42',NULL,NULL,NULL),(377,NULL,NULL,NULL,4079,'020020010007ZJ310006','12V，2A单极性继电器','G6S-2F-DC12V','02.002.001.0007 V1.2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2289,NULL,NULL,'admin','2025-06-12 13:07:42',NULL,NULL,NULL);
/*!40000 ALTER TABLE `ir_shelf_life` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kb_chat`
--

DROP TABLE IF EXISTS `kb_chat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kb_chat` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `message_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '对话ID',
  `chat_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '聊天窗_ID',
  `session_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'SESSION_ID',
  `content` blob COMMENT '原始对话json字符',
  `package_content` blob COMMENT '打包原始对话json字符串后的 json字符串',
  `reference` blob COMMENT '大json字符串',
  `create_by` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `role` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='聊天记录同步表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kb_chat`
--


--
-- Table structure for table `kb_icon`
--

DROP TABLE IF EXISTS `kb_icon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kb_icon` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `icon` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '图标',
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='图标管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kb_icon`
--

LOCK TABLES `kb_icon` WRITE;
/*!40000 ALTER TABLE `kb_icon` DISABLE KEYS */;
INSERT INTO `kb_icon` VALUES (1,'/profile/upload/2025/07/15/defaultChatAssistant_20250715163153A001.png','助理默认头像'),(2,'/profile/upload/2025/08/01/2e2c5c846f5251264d0b893b0a1008b_20250801155133A001.png','管理端菜单栏上方图标');
/*!40000 ALTER TABLE `kb_icon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kb_session`
--

DROP TABLE IF EXISTS `kb_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kb_session` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `session_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `chat_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kb_session`
--


--
-- Table structure for table `kb_source_dept`
--

DROP TABLE IF EXISTS `kb_source_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kb_source_dept` (
  `source_id` int DEFAULT NULL,
  `dept_id` int DEFAULT NULL,
  `ancestors` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '祖级列表'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kb_source_dept`
--

LOCK TABLES `kb_source_dept` WRITE;
/*!40000 ALTER TABLE `kb_source_dept` DISABLE KEYS */;
INSERT INTO `kb_source_dept` VALUES (2,105,'1,2'),(7,105,'1,7'),(7,101,'1,7'),(5,101,'3,5'),(6,101,'4,6'),(7,103,'1,7'),(5,103,'3,5');
/*!40000 ALTER TABLE `kb_source_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kb_source_file`
--

DROP TABLE IF EXISTS `kb_source_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kb_source_file` (
  `id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'ID',
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '文件名称',
  `type_id` int DEFAULT NULL COMMENT '文件类型',
  `tenant_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `parent_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `size` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '文件大小',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '文件类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kb_source_file`
--


--
-- Table structure for table `kb_source_type`
--

DROP TABLE IF EXISTS `kb_source_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kb_source_type` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `parent_id` int DEFAULT NULL COMMENT '父类',
  `source_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '类别',
  `create_by` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='文件分类';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kb_source_type`
--

LOCK TABLES `kb_source_type` WRITE;
/*!40000 ALTER TABLE `kb_source_type` DISABLE KEYS */;
INSERT INTO `kb_source_type` VALUES (1,0,'产品文档',NULL,'2025-07-11 13:38:25',NULL,'2025-08-01 09:14:42'),(2,1,'产品设计',NULL,'2025-07-11 13:38:36',NULL,'2025-08-01 09:14:50'),(3,0,'技术文档',NULL,'2025-07-11 13:38:54',NULL,'2025-08-01 09:15:10'),(4,0,'项目资料',NULL,'2025-07-11 13:39:14',NULL,'2025-08-01 09:15:25'),(5,3,'API接口文档',NULL,'2025-07-11 13:41:32',NULL,'2025-08-01 09:15:17'),(6,4,'项目过程文档',NULL,'2025-07-11 13:41:35',NULL,'2025-08-01 09:15:37'),(7,1,'原型',NULL,'2025-07-15 09:58:45',NULL,'2025-08-01 09:15:00');
/*!40000 ALTER TABLE `kb_source_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rs_device_detial`
--

DROP TABLE IF EXISTS `rs_device_detial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rs_device_detial` (
  `spare_part_detailid` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `provider_id` bigint DEFAULT NULL COMMENT '维修服务商ID',
  `provider_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商编码',
  `provider_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商名称',
  `warehouse_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商仓库编码',
  `warehouse_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商仓库名称',
  `spare_part_unit` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备件单位',
  `spare_part_spec` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备件型号',
  `nspare_part_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '新备件名称',
  `nspare_part_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '新备件sn',
  `ospare_part_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '旧备件sn',
  `abstract` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作摘要(0.备件调拨、1.销售出库、2.备件替换）',
  `transfer_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '调拨人',
  `transfer_phone` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '调拨人联系方式',
  `transfer_time` datetime DEFAULT NULL COMMENT '调拨时间',
  `receive_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '接收人',
  `receive_phone` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '接收人联系方式',
  `receive_time` datetime DEFAULT NULL COMMENT '接收时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '说明',
  `attr1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备用字段1',
  `attr2` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备用字段2',
  `attr3` int DEFAULT NULL COMMENT '备用字段3',
  `attr4` int DEFAULT NULL COMMENT '备用字段4',
  `create_id` bigint DEFAULT NULL COMMENT '创建人id',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_id` bigint DEFAULT NULL COMMENT '修改人id',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`spare_part_detailid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='备件明细表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rs_device_detial`
--


--
-- Table structure for table `rs_device_inventory`
--

DROP TABLE IF EXISTS `rs_device_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rs_device_inventory` (
  `inventory_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `provider_id` bigint DEFAULT NULL COMMENT '维修服务商ID',
  `provider_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商编码',
  `provider_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商名称',
  `spare_part_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备件名称',
  `spare_part_unit` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备件单位',
  `spare_part_num` int DEFAULT NULL COMMENT '备件本期数量',
  `spare_part_pnum` int DEFAULT NULL COMMENT '备件上期数量',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '说明',
  `attr1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备用字段1',
  `attr2` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备用字段2',
  `attr3` int DEFAULT NULL COMMENT '备用字段3',
  `attr4` int DEFAULT NULL COMMENT '备用字段4',
  `create_id` bigint DEFAULT NULL COMMENT '创建人id',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_id` bigint DEFAULT NULL COMMENT '修改人id',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`inventory_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='备件库存表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rs_device_inventory`
--


--
-- Table structure for table `rs_device_master`
--

DROP TABLE IF EXISTS `rs_device_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rs_device_master` (
  `spare_part_masterid` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `provider_id` bigint DEFAULT NULL COMMENT '维修服务商ID',
  `provider_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商编码',
  `provider_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商名称',
  `warehouse_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商仓库编码',
  `warehouse_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商仓库名称',
  `spare_part_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备件名称',
  `spare_part_unit` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备件单位',
  `spare_part_spec` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备件型号',
  `spare_part_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备件sn',
  `spare_part_status` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备件状态(0:正常1:作废)',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '说明',
  `attr1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备用字段1',
  `attr2` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备用字段2',
  `attr3` int DEFAULT NULL COMMENT '备用字段3',
  `attr4` int DEFAULT NULL COMMENT '备用字段4',
  `create_id` bigint DEFAULT NULL COMMENT '创建人id',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_id` bigint DEFAULT NULL COMMENT '修改人id',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`spare_part_masterid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='备件主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rs_device_master`
--


--
-- Table structure for table `rs_repair_service_provider`
--

DROP TABLE IF EXISTS `rs_repair_service_provider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rs_repair_service_provider` (
  `provider_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `provider_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商编码',
  `provider_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商名称',
  `provider_charge` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商负责人',
  `provider_contact_person` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商联系人',
  `provider_contact_phone` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商联系方式',
  `province_id` bigint DEFAULT NULL COMMENT '省ID',
  `province` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '省',
  `city_id` bigint DEFAULT NULL COMMENT '市ID',
  `city` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '市',
  `district_id` bigint DEFAULT NULL COMMENT '区(县)ID',
  `district` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '区(县)',
  `service_region` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商归属区域',
  `is_del` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否删除(0:正常,1:删除)',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '说明',
  `attr1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备用字段1',
  `attr2` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备用字段2',
  `attr3` int DEFAULT NULL COMMENT '备用字段3',
  `attr4` int DEFAULT NULL COMMENT '备用字段4',
  `create_id` bigint DEFAULT NULL COMMENT '创建人id',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_id` bigint DEFAULT NULL COMMENT '修改人id',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`provider_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='维修服务商管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rs_repair_service_provider`
--


--
-- Table structure for table `rs_repair_service_spare_parts`
--

DROP TABLE IF EXISTS `rs_repair_service_spare_parts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rs_repair_service_spare_parts` (
  `spare_part_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `provider_id` bigint DEFAULT NULL COMMENT '维修服务商ID',
  `provider_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商编码',
  `provider_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商名称',
  `warehouse_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商仓库编码',
  `warehouse_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商仓库名称',
  `spare_part_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备件名称',
  `spare_part_unit` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备件单位',
  `spare_part_spec` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备件型号',
  `spare_part_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备件编码',
  `transfer_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '调拨人',
  `transfer_phone` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '调拨人联系方式',
  `transfer_time` datetime DEFAULT NULL COMMENT '调拨时间',
  `receive_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '接收人',
  `receive_phone` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '接收人联系方式',
  `receive_time` datetime DEFAULT NULL COMMENT '接收时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '说明',
  `attr1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备用字段1',
  `attr2` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备用字段2',
  `attr3` int DEFAULT NULL COMMENT '备用字段3',
  `attr4` int DEFAULT NULL COMMENT '备用字段4',
  `create_id` bigint DEFAULT NULL COMMENT '创建人id',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_id` bigint DEFAULT NULL COMMENT '修改人id',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`spare_part_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='维修服务商备件表管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rs_repair_service_spare_parts`
--


--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y','admin','2025-05-18 09:13:55','',NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),(2,'用户管理-账号初始密码','sys.user.initPassword','123456','Y','admin','2025-05-18 09:13:55','',NULL,'初始化密码 123456'),(3,'主框架页-侧边栏主题','sys.index.sideTheme','theme-dark','Y','admin','2025-05-18 09:13:55','',NULL,'深色主题theme-dark，浅色主题theme-light'),(4,'账号自助-验证码开关','sys.account.captchaEnabled','true','Y','admin','2025-05-18 09:13:55','',NULL,'是否开启验证码功能（true开启，false关闭）'),(5,'账号自助-是否开启用户注册功能','sys.account.registerUser','false','Y','admin','2025-05-18 09:13:55','',NULL,'是否开启注册用户功能（true开启，false关闭）'),(6,'用户登录-黑名单列表','sys.login.blackIPList','','Y','admin','2025-05-18 09:13:55','',NULL,'设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）'),(100,'RagFlowKey','RagFlowKey','ragflow-E5ODdhM2I2MTZiMjExZjBiMGU3NjJhM2','Y','admin','2025-06-27 05:18:56','admin','2025-09-09 10:43:42',NULL),(101,'RagFlowServerBaseUrl','RagFlowServerBaseUrl','http://ragflow-server','Y','admin','2025-06-30 07:35:00','admin','2026-05-29 09:41:56',NULL),(102,'BaseServerUrl','BaseServerUrl','http://127.0.0.1:8088','Y','admin','2025-07-04 07:13:30','admin','2026-05-29 09:41:58',NULL),(103,'Ragflow登录密码(RSA加密)','password','Z6zUlnzX92IzS6hJZFAzum1cITDj1KsX/TFFYgLN5c5UR/X/9gLgpyijMBkPFVi0zZnf5ulb7soJ+vzRfGL6HUVCwTdcb1Zxpz1C8PYj0BjYVCuWQWuV52NKQW0ODQM5Ilp++wqZk4v8li1JpxfnSsLWOitj7MvBn2yB5KO9qTR0+YLzkCPozsY9jWsadsckhJ1XcDZUhRn0ueRNv9BPh1wT6JTbdZHizDsp6+RzdW/wfYxVhKmuCQYwO7uTmfD4Tp4dwwh2gtqy1QLmCqrgFIeWW4lwl3bxiYnkowJEqCVqIxElbmZIXUwMT7b/Qghcsk5Wm5SGHYt0+egrVZtHHw==','Y','admin','2025-07-15 07:31:00','admin','2025-09-09 10:57:18',NULL),(104,'Ragflow登录邮箱','email','wanglun000330@163.com','Y','admin','2025-07-15 07:31:53','admin','2025-09-09 10:38:01',NULL),(105,'RagFlow认证过期时间','CACHE_EXPIRE_TIME','30','Y','admin','2025-07-17 08:46:11','admin','2025-07-17 08:51:01','单位：分钟');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept`
--

DROP TABLE IF EXISTS `sys_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dept` (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '部门名称',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `provider_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商编码',
  `provider_contact_person` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商联系人',
  `province_id` bigint DEFAULT NULL COMMENT '省ID',
  `province` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '省',
  `city_id` bigint DEFAULT NULL COMMENT '市ID',
  `city` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '市',
  `district_id` bigint DEFAULT NULL COMMENT '区(县)ID',
  `district` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '区(县)',
  `service_region` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '维修服务商归属区域',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '说明',
  `attr1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备用字段1',
  `attr2` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备用字段2',
  `attr3` int DEFAULT NULL COMMENT '备用字段3',
  `attr4` int DEFAULT NULL COMMENT '备用字段4',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='部门表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept`
--

LOCK TABLES `sys_dept` WRITE;
/*!40000 ALTER TABLE `sys_dept` DISABLE KEYS */;
INSERT INTO `sys_dept` VALUES (100,0,'0','总公司',0,'','','','0','0','admin','2025-05-18 09:13:55','admin','2025-07-04 08:54:33',NULL,NULL,0,NULL,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(101,100,'0,100','大模型',1,'若依','15888888888','ry@qq.com','0','0','admin','2025-05-18 09:13:55','admin','2025-07-04 08:54:44',NULL,NULL,0,NULL,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(102,100,'0,100','长沙分公司',2,'若依','15888888888','ry@qq.com','0','2','admin','2025-05-18 09:13:55','',NULL,NULL,NULL,0,NULL,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(103,101,'0,100,101','研发部门1',1,'ffff','15888888888','','0','0','admin','2025-05-18 09:13:55','admin','2025-07-04 08:54:55',NULL,'ccc',0,NULL,0,NULL,0,NULL,'333',NULL,NULL,NULL,NULL,NULL),(104,101,'0,100,101','市场部门',2,'若依','15888888888','ry@qq.com','0','2','admin','2025-05-18 09:13:55','',NULL,NULL,NULL,0,NULL,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(105,101,'0,100,101','研发部门2',3,'','15888888888','','0','0','admin','2025-05-18 09:13:55','admin','2025-07-04 08:55:03',NULL,NULL,0,NULL,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(106,101,'0,100,101','财务部门',4,'若依','15888888888','ry@qq.com','0','2','admin','2025-05-18 09:13:55','',NULL,NULL,NULL,0,NULL,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(107,101,'0,100,101','运维部门',5,'若依','15888888888','ry@qq.com','0','2','admin','2025-05-18 09:13:55','',NULL,NULL,NULL,0,NULL,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(108,102,'0,100,102','市场部门',1,'若依','15888888888','ry@qq.com','0','2','admin','2025-05-18 09:13:55','',NULL,NULL,NULL,0,NULL,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(109,102,'0,100,102','财务部门',2,'若依','15888888888','ry@qq.com','0','2','admin','2025-05-18 09:13:55','',NULL,NULL,NULL,0,NULL,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `sys_dept` ENABLE KEYS */;
UNLOCK TABLES;



--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` VALUES (1,1,'男','0','sys_user_sex','','','Y','0','admin','2025-05-18 09:13:55','',NULL,'性别男'),(2,2,'女','1','sys_user_sex','','','N','0','admin','2025-05-18 09:13:55','',NULL,'性别女'),(3,3,'未知','2','sys_user_sex','','','N','0','admin','2025-05-18 09:13:55','',NULL,'性别未知'),(4,1,'显示','0','sys_show_hide','','primary','Y','0','admin','2025-05-18 09:13:55','',NULL,'显示菜单'),(5,2,'隐藏','1','sys_show_hide','','danger','N','0','admin','2025-05-18 09:13:55','',NULL,'隐藏菜单'),(6,1,'正常','0','sys_normal_disable','','primary','Y','0','admin','2025-05-18 09:13:55','',NULL,'正常状态'),(7,2,'停用','1','sys_normal_disable','','danger','N','0','admin','2025-05-18 09:13:55','',NULL,'停用状态'),(8,1,'正常','0','sys_job_status','','primary','Y','0','admin','2025-05-18 09:13:55','',NULL,'正常状态'),(9,2,'暂停','1','sys_job_status','','danger','N','0','admin','2025-05-18 09:13:55','',NULL,'停用状态'),(10,1,'默认','DEFAULT','sys_job_group','','','Y','0','admin','2025-05-18 09:13:55','',NULL,'默认分组'),(11,2,'系统','SYSTEM','sys_job_group','','','N','0','admin','2025-05-18 09:13:55','',NULL,'系统分组'),(12,1,'是','Y','sys_yes_no','','primary','Y','0','admin','2025-05-18 09:13:55','',NULL,'系统默认是'),(13,2,'否','N','sys_yes_no','','danger','N','0','admin','2025-05-18 09:13:55','',NULL,'系统默认否'),(14,1,'通知','1','sys_notice_type','','warning','Y','0','admin','2025-05-18 09:13:55','',NULL,'通知'),(15,2,'公告','2','sys_notice_type','','success','N','0','admin','2025-05-18 09:13:55','',NULL,'公告'),(16,1,'正常','0','sys_notice_status','','primary','Y','0','admin','2025-05-18 09:13:55','',NULL,'正常状态'),(17,2,'关闭','1','sys_notice_status','','danger','N','0','admin','2025-05-18 09:13:55','',NULL,'关闭状态'),(18,99,'其他','0','sys_oper_type','','info','N','0','admin','2025-05-18 09:13:55','',NULL,'其他操作'),(19,1,'新增','1','sys_oper_type','','info','N','0','admin','2025-05-18 09:13:55','',NULL,'新增操作'),(20,2,'修改','2','sys_oper_type','','info','N','0','admin','2025-05-18 09:13:55','',NULL,'修改操作'),(21,3,'删除','3','sys_oper_type','','danger','N','0','admin','2025-05-18 09:13:55','',NULL,'删除操作'),(22,4,'授权','4','sys_oper_type','','primary','N','0','admin','2025-05-18 09:13:55','',NULL,'授权操作'),(23,5,'导出','5','sys_oper_type','','warning','N','0','admin','2025-05-18 09:13:55','',NULL,'导出操作'),(24,6,'导入','6','sys_oper_type','','warning','N','0','admin','2025-05-18 09:13:55','',NULL,'导入操作'),(25,7,'强退','7','sys_oper_type','','danger','N','0','admin','2025-05-18 09:13:55','',NULL,'强退操作'),(26,8,'生成代码','8','sys_oper_type','','warning','N','0','admin','2025-05-18 09:13:55','',NULL,'生成操作'),(27,9,'清空数据','9','sys_oper_type','','danger','N','0','admin','2025-05-18 09:13:55','',NULL,'清空操作'),(28,1,'成功','0','sys_common_status','','primary','N','0','admin','2025-05-18 09:13:55','',NULL,'正常状态'),(29,2,'失败','1','sys_common_status','','danger','N','0','admin','2025-05-18 09:13:55','',NULL,'停用状态'),(100,1,'产品','0','issue_type',NULL,'default','N','0','admin','2025-06-07 09:03:54','',NULL,NULL),(101,2,'备件','1','issue_type',NULL,'default','N','0','admin','2025-06-07 09:04:07','',NULL,NULL),(102,1,'一般','1','issue_level',NULL,'default','N','0','admin','2025-06-07 09:12:59','',NULL,NULL),(103,2,'严重','2','issue_level',NULL,'default','N','0','admin','2025-06-07 09:13:11','',NULL,NULL),(104,0,'非常严重','3','issue_level',NULL,'default','N','0','admin','2025-06-07 09:13:20','',NULL,NULL),(105,1,'待处理','0','issue_status',NULL,'default','N','0','admin','2025-06-07 11:34:18','',NULL,NULL),(106,2,'处理中','1','issue_status',NULL,'default','N','0','admin','2025-06-07 11:34:33','',NULL,NULL),(107,3,'已解决','3','issue_status',NULL,'default','N','0','admin','2025-06-07 11:34:50','',NULL,NULL);
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE KEY `dict_type` (`dict_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (1,'用户性别','sys_user_sex','0','admin','2025-05-18 09:13:55','',NULL,'用户性别列表'),(2,'菜单状态','sys_show_hide','0','admin','2025-05-18 09:13:55','',NULL,'菜单状态列表'),(3,'系统开关','sys_normal_disable','0','admin','2025-05-18 09:13:55','',NULL,'系统开关列表'),(4,'任务状态','sys_job_status','0','admin','2025-05-18 09:13:55','',NULL,'任务状态列表'),(5,'任务分组','sys_job_group','0','admin','2025-05-18 09:13:55','',NULL,'任务分组列表'),(6,'系统是否','sys_yes_no','0','admin','2025-05-18 09:13:55','',NULL,'系统是否列表'),(7,'通知类型','sys_notice_type','0','admin','2025-05-18 09:13:55','',NULL,'通知类型列表'),(8,'通知状态','sys_notice_status','0','admin','2025-05-18 09:13:55','',NULL,'通知状态列表'),(9,'操作类型','sys_oper_type','0','admin','2025-05-18 09:13:55','',NULL,'操作类型列表'),(10,'系统状态','sys_common_status','0','admin','2025-05-18 09:13:55','',NULL,'登录状态列表'),(100,'问题类型','issue_type','0','admin','2025-06-07 09:01:24','admin','2025-06-07 09:01:47',NULL),(101,'问题等级','issue_level','0','admin','2025-06-07 09:12:29','',NULL,NULL),(102,'问题状态','issue_status','0','admin','2025-06-07 11:33:56','',NULL,NULL);
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job`
--

DROP TABLE IF EXISTS `sys_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job` (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='定时任务调度表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job`
--

LOCK TABLES `sys_job` WRITE;
/*!40000 ALTER TABLE `sys_job` DISABLE KEYS */;
INSERT INTO `sys_job` VALUES (1,'系统默认（无参）','DEFAULT','ryTask.ryNoParams','0/10 * * * * ?','3','1','1','admin','2025-05-18 09:13:55','',NULL,''),(2,'系统默认（有参）','DEFAULT','ryTask.ryParams(\'ry\')','0/15 * * * * ?','3','1','1','admin','2025-05-18 09:13:55','',NULL,''),(3,'系统默认（多参）','DEFAULT','ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)','0/20 * * * * ?','3','1','1','admin','2025-05-18 09:13:55','',NULL,'');
/*!40000 ALTER TABLE `sys_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job_log`
--

DROP TABLE IF EXISTS `sys_job_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '异常信息',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='定时任务调度日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job_log`
--


--
-- Table structure for table `sys_logininfor`
--

DROP TABLE IF EXISTS `sys_logininfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  KEY `idx_sys_logininfor_s` (`status`) USING BTREE,
  KEY `idx_sys_logininfor_lt` (`login_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--


--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '路由名称',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2078 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'系统管理',0,1,'system',NULL,'','',1,0,'M','0','0','','system','admin','2025-05-18 09:13:55','',NULL,'系统管理目录'),(2,'系统监控',0,2,'monitor',NULL,'','',1,0,'M','0','0','','monitor','admin','2025-05-18 09:13:55','',NULL,'系统监控目录'),(3,'系统工具',0,3,'tool',NULL,'','',1,0,'M','0','0','','tool','admin','2025-05-18 09:13:55','',NULL,'系统工具目录'),(5,'智能问答助手',0,1,'assistant',NULL,'','',1,0,'M','0','0','','documentation','admin','2025-05-18 09:13:55','admin','2025-08-01 03:05:23','售后管理目录'),(100,'用户管理',1,1,'user','system/user/index','','',1,0,'C','0','0','system:user:list','user','admin','2025-05-18 09:13:55','',NULL,'用户管理菜单'),(101,'角色管理',1,2,'role','system/role/index','','',1,0,'C','0','0','system:role:list','peoples','admin','2025-05-18 09:13:55','',NULL,'角色管理菜单'),(102,'菜单管理',1,3,'menu','system/menu/index','','',1,0,'C','0','0','system:menu:list','tree-table','admin','2025-05-18 09:13:55','',NULL,'菜单管理菜单'),(103,'部门管理',1,4,'dept','system/dept/index','','',1,0,'C','0','0','system:dept:list','tree','admin','2025-05-18 09:13:55','',NULL,'部门管理菜单'),(104,'岗位管理',1,5,'post','system/post/index','','',1,0,'C','0','0','system:post:list','post','admin','2025-05-18 09:13:55','',NULL,'岗位管理菜单'),(105,'字典管理',1,6,'dict','system/dict/index','','',1,0,'C','0','0','system:dict:list','dict','admin','2025-05-18 09:13:55','',NULL,'字典管理菜单'),(106,'参数设置',1,7,'config','system/config/index','','',1,0,'C','0','0','system:config:list','edit','admin','2025-05-18 09:13:55','',NULL,'参数设置菜单'),(107,'通知公告',1,8,'notice','system/notice/index','','',1,0,'C','0','0','system:notice:list','message','admin','2025-05-18 09:13:55','',NULL,'通知公告菜单'),(108,'日志管理',1,9,'log','','','',1,0,'M','0','0','','log','admin','2025-05-18 09:13:55','',NULL,'日志管理菜单'),(109,'在线用户',2,1,'online','monitor/online/index','','',1,0,'C','0','0','monitor:online:list','online','admin','2025-05-18 09:13:55','',NULL,'在线用户菜单'),(110,'定时任务',2,2,'job','monitor/job/index','','',1,0,'C','0','0','monitor:job:list','job','admin','2025-05-18 09:13:55','',NULL,'定时任务菜单'),(111,'数据监控',2,3,'druid','monitor/druid/index','','',1,0,'C','0','0','monitor:druid:list','druid','admin','2025-05-18 09:13:55','',NULL,'数据监控菜单'),(112,'服务监控',2,4,'server','monitor/server/index','','',1,0,'C','0','0','monitor:server:list','server','admin','2025-05-18 09:13:55','',NULL,'服务监控菜单'),(113,'缓存监控',2,5,'cache','monitor/cache/index','','',1,0,'C','0','0','monitor:cache:list','redis','admin','2025-05-18 09:13:55','',NULL,'缓存监控菜单'),(114,'缓存列表',2,6,'cacheList','monitor/cache/list','','',1,0,'C','0','0','monitor:cache:list','redis-list','admin','2025-05-18 09:13:55','',NULL,'缓存列表菜单'),(115,'表单构建',3,1,'build','tool/build/index','','',1,0,'C','0','0','tool:build:list','build','admin','2025-05-18 09:13:55','',NULL,'表单构建菜单'),(116,'代码生成',3,2,'gen','tool/gen/index','','',1,0,'C','0','0','tool:gen:list','code','admin','2025-05-18 09:13:55','',NULL,'代码生成菜单'),(117,'系统接口',3,3,'swagger','tool/swagger/index','','',1,0,'C','0','0','tool:swagger:list','swagger','admin','2025-05-18 09:13:55','',NULL,'系统接口菜单'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','','',1,0,'C','0','0','monitor:operlog:list','form','admin','2025-05-18 09:13:55','',NULL,'操作日志菜单'),(501,'登录日志',108,2,'logininfor','monitor/logininfor/index','','',1,0,'C','0','0','monitor:logininfor:list','logininfor','admin','2025-05-18 09:13:55','',NULL,'登录日志菜单'),(1000,'用户查询',100,1,'','','','',1,0,'F','0','0','system:user:query','#','admin','2025-05-18 09:13:55','',NULL,''),(1001,'用户新增',100,2,'','','','',1,0,'F','0','0','system:user:add','#','admin','2025-05-18 09:13:55','',NULL,''),(1002,'用户修改',100,3,'','','','',1,0,'F','0','0','system:user:edit','#','admin','2025-05-18 09:13:55','',NULL,''),(1003,'用户删除',100,4,'','','','',1,0,'F','0','0','system:user:remove','#','admin','2025-05-18 09:13:55','',NULL,''),(1004,'用户导出',100,5,'','','','',1,0,'F','0','0','system:user:export','#','admin','2025-05-18 09:13:55','',NULL,''),(1005,'用户导入',100,6,'','','','',1,0,'F','0','0','system:user:import','#','admin','2025-05-18 09:13:55','',NULL,''),(1006,'重置密码',100,7,'','','','',1,0,'F','0','0','system:user:resetPwd','#','admin','2025-05-18 09:13:55','',NULL,''),(1007,'角色查询',101,1,'','','','',1,0,'F','0','0','system:role:query','#','admin','2025-05-18 09:13:55','',NULL,''),(1008,'角色新增',101,2,'','','','',1,0,'F','0','0','system:role:add','#','admin','2025-05-18 09:13:55','',NULL,''),(1009,'角色修改',101,3,'','','','',1,0,'F','0','0','system:role:edit','#','admin','2025-05-18 09:13:55','',NULL,''),(1010,'角色删除',101,4,'','','','',1,0,'F','0','0','system:role:remove','#','admin','2025-05-18 09:13:55','',NULL,''),(1011,'角色导出',101,5,'','','','',1,0,'F','0','0','system:role:export','#','admin','2025-05-18 09:13:55','',NULL,''),(1012,'菜单查询',102,1,'','','','',1,0,'F','0','0','system:menu:query','#','admin','2025-05-18 09:13:55','',NULL,''),(1013,'菜单新增',102,2,'','','','',1,0,'F','0','0','system:menu:add','#','admin','2025-05-18 09:13:55','',NULL,''),(1014,'菜单修改',102,3,'','','','',1,0,'F','0','0','system:menu:edit','#','admin','2025-05-18 09:13:55','',NULL,''),(1015,'菜单删除',102,4,'','','','',1,0,'F','0','0','system:menu:remove','#','admin','2025-05-18 09:13:55','',NULL,''),(1016,'部门查询',103,1,'','','','',1,0,'F','0','0','system:dept:query','#','admin','2025-05-18 09:13:55','',NULL,''),(1017,'部门新增',103,2,'','','','',1,0,'F','0','0','system:dept:add','#','admin','2025-05-18 09:13:55','',NULL,''),(1018,'部门修改',103,3,'','','','',1,0,'F','0','0','system:dept:edit','#','admin','2025-05-18 09:13:55','',NULL,''),(1019,'部门删除',103,4,'','','','',1,0,'F','0','0','system:dept:remove','#','admin','2025-05-18 09:13:55','',NULL,''),(1020,'岗位查询',104,1,'','','','',1,0,'F','0','0','system:post:query','#','admin','2025-05-18 09:13:55','',NULL,''),(1021,'岗位新增',104,2,'','','','',1,0,'F','0','0','system:post:add','#','admin','2025-05-18 09:13:55','',NULL,''),(1022,'岗位修改',104,3,'','','','',1,0,'F','0','0','system:post:edit','#','admin','2025-05-18 09:13:55','',NULL,''),(1023,'岗位删除',104,4,'','','','',1,0,'F','0','0','system:post:remove','#','admin','2025-05-18 09:13:55','',NULL,''),(1024,'岗位导出',104,5,'','','','',1,0,'F','0','0','system:post:export','#','admin','2025-05-18 09:13:55','',NULL,''),(1025,'字典查询',105,1,'#','','','',1,0,'F','0','0','system:dict:query','#','admin','2025-05-18 09:13:55','',NULL,''),(1026,'字典新增',105,2,'#','','','',1,0,'F','0','0','system:dict:add','#','admin','2025-05-18 09:13:55','',NULL,''),(1027,'字典修改',105,3,'#','','','',1,0,'F','0','0','system:dict:edit','#','admin','2025-05-18 09:13:55','',NULL,''),(1028,'字典删除',105,4,'#','','','',1,0,'F','0','0','system:dict:remove','#','admin','2025-05-18 09:13:55','',NULL,''),(1029,'字典导出',105,5,'#','','','',1,0,'F','0','0','system:dict:export','#','admin','2025-05-18 09:13:55','',NULL,''),(1030,'参数查询',106,1,'#','','','',1,0,'F','0','0','system:config:query','#','admin','2025-05-18 09:13:55','',NULL,''),(1031,'参数新增',106,2,'#','','','',1,0,'F','0','0','system:config:add','#','admin','2025-05-18 09:13:55','',NULL,''),(1032,'参数修改',106,3,'#','','','',1,0,'F','0','0','system:config:edit','#','admin','2025-05-18 09:13:55','',NULL,''),(1033,'参数删除',106,4,'#','','','',1,0,'F','0','0','system:config:remove','#','admin','2025-05-18 09:13:55','',NULL,''),(1034,'参数导出',106,5,'#','','','',1,0,'F','0','0','system:config:export','#','admin','2025-05-18 09:13:55','',NULL,''),(1035,'公告查询',107,1,'#','','','',1,0,'F','0','0','system:notice:query','#','admin','2025-05-18 09:13:55','',NULL,''),(1036,'公告新增',107,2,'#','','','',1,0,'F','0','0','system:notice:add','#','admin','2025-05-18 09:13:55','',NULL,''),(1037,'公告修改',107,3,'#','','','',1,0,'F','0','0','system:notice:edit','#','admin','2025-05-18 09:13:55','',NULL,''),(1038,'公告删除',107,4,'#','','','',1,0,'F','0','0','system:notice:remove','#','admin','2025-05-18 09:13:55','',NULL,''),(1039,'操作查询',500,1,'#','','','',1,0,'F','0','0','monitor:operlog:query','#','admin','2025-05-18 09:13:55','',NULL,''),(1040,'操作删除',500,2,'#','','','',1,0,'F','0','0','monitor:operlog:remove','#','admin','2025-05-18 09:13:55','',NULL,''),(1041,'日志导出',500,3,'#','','','',1,0,'F','0','0','monitor:operlog:export','#','admin','2025-05-18 09:13:55','',NULL,''),(1042,'登录查询',501,1,'#','','','',1,0,'F','0','0','monitor:logininfor:query','#','admin','2025-05-18 09:13:55','',NULL,''),(1043,'登录删除',501,2,'#','','','',1,0,'F','0','0','monitor:logininfor:remove','#','admin','2025-05-18 09:13:55','',NULL,''),(1044,'日志导出',501,3,'#','','','',1,0,'F','0','0','monitor:logininfor:export','#','admin','2025-05-18 09:13:55','',NULL,''),(1045,'账户解锁',501,4,'#','','','',1,0,'F','0','0','monitor:logininfor:unlock','#','admin','2025-05-18 09:13:55','',NULL,''),(1046,'在线查询',109,1,'#','','','',1,0,'F','0','0','monitor:online:query','#','admin','2025-05-18 09:13:55','',NULL,''),(1047,'批量强退',109,2,'#','','','',1,0,'F','0','0','monitor:online:batchLogout','#','admin','2025-05-18 09:13:55','',NULL,''),(1048,'单条强退',109,3,'#','','','',1,0,'F','0','0','monitor:online:forceLogout','#','admin','2025-05-18 09:13:55','',NULL,''),(1049,'任务查询',110,1,'#','','','',1,0,'F','0','0','monitor:job:query','#','admin','2025-05-18 09:13:55','',NULL,''),(1050,'任务新增',110,2,'#','','','',1,0,'F','0','0','monitor:job:add','#','admin','2025-05-18 09:13:55','',NULL,''),(1051,'任务修改',110,3,'#','','','',1,0,'F','0','0','monitor:job:edit','#','admin','2025-05-18 09:13:55','',NULL,''),(1052,'任务删除',110,4,'#','','','',1,0,'F','0','0','monitor:job:remove','#','admin','2025-05-18 09:13:55','',NULL,''),(1053,'状态修改',110,5,'#','','','',1,0,'F','0','0','monitor:job:changeStatus','#','admin','2025-05-18 09:13:55','',NULL,''),(1054,'任务导出',110,6,'#','','','',1,0,'F','0','0','monitor:job:export','#','admin','2025-05-18 09:13:55','',NULL,''),(1055,'生成查询',116,1,'#','','','',1,0,'F','0','0','tool:gen:query','#','admin','2025-05-18 09:13:55','',NULL,''),(1056,'生成修改',116,2,'#','','','',1,0,'F','0','0','tool:gen:edit','#','admin','2025-05-18 09:13:55','',NULL,''),(1057,'生成删除',116,3,'#','','','',1,0,'F','0','0','tool:gen:remove','#','admin','2025-05-18 09:13:55','',NULL,''),(1058,'导入代码',116,4,'#','','','',1,0,'F','0','0','tool:gen:import','#','admin','2025-05-18 09:13:55','',NULL,''),(1059,'预览代码',116,5,'#','','','',1,0,'F','0','0','tool:gen:preview','#','admin','2025-05-18 09:13:55','',NULL,''),(1060,'生成代码',116,6,'#','','','',1,0,'F','0','0','tool:gen:code','#','admin','2025-05-18 09:13:55','',NULL,''),(2046,'知识库管理',5,9,'manual','customApp/manual',NULL,'manual',1,0,'C','0','0','','pdf','admin','2025-06-16 02:18:58','admin','2025-07-25 01:31:12',''),(2047,'代码测试页',5,999,'deepseek','ai/chat/index-deepseek',NULL,'',1,0,'C','0','0','','star','admin','2025-06-18 10:33:36','admin','2025-07-24 08:11:04',''),(2050,'配置助理',5,2,'assistantConfig','customApp/assistantConfig',NULL,'assistantConfig',1,0,'C','0','0','','validCode','admin','2025-06-26 07:25:43','admin','2025-07-25 01:29:39',''),(2051,'智能问答',0,6,'ops_solutions','customApp/ops_solutions',NULL,'ops_solutions',1,0,'C','0','0','ops_solutions','education','admin','2025-06-26 07:33:56','admin','2025-08-05 01:44:40',''),(2052,'知识检索',0,7,'fault_tracing','customApp/faultTracing',NULL,'fault_tracing',1,0,'C','0','0','fault_tracing','bug','admin','2025-06-26 07:41:29','admin','2025-08-05 01:44:47',''),(2053,'模型管理',5,8,'model','customApp/model',NULL,'model',1,0,'C','0','0','','code','admin','2025-06-26 07:59:49','admin','2025-07-25 01:31:17',''),(2054,'智能问答(记录)',5,2,'assitantSession','customApp/assitantSession',NULL,'assitantSession',1,0,'C','1','1','','build','admin','2025-06-27 08:51:45','admin','2025-07-10 00:59:25',''),(2055,'智能问答(对话)',5,3,'ops_solutions_chat','customApp/ops_solutions_chat',NULL,'ops_solutions_chat',1,0,'C','1','1','','build','admin','2025-06-27 09:23:10','admin','2025-07-10 00:59:28',''),(2056,'图标管理',1,1,'icon','kb/icon/index',NULL,'',1,0,'C','0','0','kb:icon:list','icon','admin','2025-07-04 01:03:07','admin','2025-07-09 05:56:43','图标管理菜单'),(2057,'图标管理查询',2056,1,'#','',NULL,'',1,0,'F','0','0','kb:icon:query','#','admin','2025-07-04 01:03:07','admin','2025-07-04 10:18:15',''),(2058,'图标管理新增',2056,2,'#','',NULL,'',1,0,'F','0','0','kb:icon:add','#','admin','2025-07-04 01:03:07','',NULL,''),(2059,'图标管理修改',2056,3,'#','',NULL,'',1,0,'F','0','0','kb:icon:edit','#','admin','2025-07-04 01:03:07','',NULL,''),(2060,'图标管理删除',2056,4,'#','',NULL,'',1,0,'F','0','0','kb:icon:remove','#','admin','2025-07-04 01:03:07','',NULL,''),(2061,'图标管理导出',2056,5,'#','',NULL,'',1,0,'F','0','0','kb:icon:export','#','admin','2025-07-04 01:03:07','',NULL,''),(2064,'手册文件',5,7,'fileManage','customApp/fileManage',NULL,'fileManage',1,0,'C','1','0','fileManage','documentation','admin','2025-07-04 10:32:16','admin','2025-08-04 05:31:47',''),(2065,'文件分类',5,6,'type','kb/type/index',NULL,'',1,0,'C','0','0','kb:type:list','tree','admin','2025-07-11 05:29:28','admin','2025-07-25 01:30:29','文件分类菜单'),(2066,'文件分类查询',2065,1,'#','',NULL,'',1,0,'F','0','0','kb:type:query','#','admin','2025-07-11 05:29:28','',NULL,''),(2067,'文件分类新增',2065,2,'#','',NULL,'',1,0,'F','0','0','kb:type:add','#','admin','2025-07-11 05:29:28','',NULL,''),(2068,'文件分类修改',2065,3,'#','',NULL,'',1,0,'F','0','0','kb:type:edit','#','admin','2025-07-11 05:29:28','',NULL,''),(2069,'文件分类删除',2065,4,'#','',NULL,'',1,0,'F','0','0','kb:type:remove','#','admin','2025-07-11 05:29:28','',NULL,''),(2070,'文件分类导出',2065,5,'#','',NULL,'',1,0,'F','0','0','kb:type:export','#','admin','2025-07-11 05:29:28','',NULL,''),(2071,'文件管理',5,5,'fileConfig','customApp/fileManager/fileConfig',NULL,'',1,0,'C','0','0','','documentation','admin','2025-07-21 06:11:26','admin','2025-07-25 01:30:24',''),(2072,'文件查看',5,4,'file','kb/file/index',NULL,'',1,0,'C','0','0','kb:file:list','component','admin','2025-07-22 07:55:30','admin','2025-07-25 01:30:15','文件配置菜单'),(2073,'文件查看查询',2072,1,'#','',NULL,'',1,0,'F','0','0','kb:file:query','#','admin','2025-07-22 07:55:30','admin','2025-07-23 01:16:00',''),(2074,'文件查看新增',2072,2,'#','',NULL,'',1,0,'F','0','0','kb:file:add','#','admin','2025-07-22 07:55:30','admin','2025-07-23 01:16:05',''),(2075,'文件查看修改',2072,3,'#','',NULL,'',1,0,'F','0','0','kb:file:edit','#','admin','2025-07-22 07:55:30','admin','2025-07-23 01:16:13',''),(2076,'文件查看删除',2072,4,'#','',NULL,'',1,0,'F','0','0','kb:file:remove','#','admin','2025-07-22 07:55:30','admin','2025-07-23 01:16:17',''),(2077,'文件查看导出',2072,5,'#','',NULL,'',1,0,'F','0','0','kb:file:export','#','admin','2025-07-22 07:55:30','admin','2025-07-23 01:16:22','');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` VALUES (1,'温馨提醒：2018-07-01 若依新版本发布啦','2',_binary '新版本内容','0','admin','2025-05-18 09:13:55','',NULL,'管理员'),(2,'维护通知：2018-07-01 若依系统凌晨维护','1',_binary '维护内容','0','admin','2025-05-18 09:13:55','',NULL,'管理员');
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oper_log`
--

DROP TABLE IF EXISTS `sys_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  KEY `idx_sys_oper_log_bt` (`business_type`) USING BTREE,
  KEY `idx_sys_oper_log_s` (`status`) USING BTREE,
  KEY `idx_sys_oper_log_ot` (`oper_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--


--
-- Table structure for table `sys_post`
--

DROP TABLE IF EXISTS `sys_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_post` (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='岗位信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_post`
--

LOCK TABLES `sys_post` WRITE;
/*!40000 ALTER TABLE `sys_post` DISABLE KEYS */;
INSERT INTO `sys_post` VALUES (1,'ceo','董事长',1,'0','admin','2025-05-18 09:13:55','',NULL,''),(2,'se','项目经理',2,'0','admin','2025-05-18 09:13:55','',NULL,''),(3,'hr','人力资源',3,'0','admin','2025-05-18 09:13:55','',NULL,''),(4,'user','普通员工',4,'0','admin','2025-05-18 09:13:55','',NULL,'');
/*!40000 ALTER TABLE `sys_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'超级管理员','admin',1,'1',1,1,'0','0','admin','2025-05-18 09:13:55','',NULL,'超级管理员'),(2,'管理员','system',2,'2',1,1,'0','0','admin','2025-05-18 09:13:55','admin','2025-07-16 00:38:20','普通角色'),(100,'普通用户','common',2,'1',1,1,'0','0','admin','2025-08-01 03:00:46','admin','2025-08-06 00:47:35',NULL);
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_dept`
--

DROP TABLE IF EXISTS `sys_role_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='角色和部门关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_dept`
--

LOCK TABLES `sys_role_dept` WRITE;
/*!40000 ALTER TABLE `sys_role_dept` DISABLE KEYS */;
INSERT INTO `sys_role_dept` VALUES (2,100),(2,101),(2,105);
/*!40000 ALTER TABLE `sys_role_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (2,1),(2,5),(2,100),(2,101),(2,102),(2,103),(2,104),(2,105),(2,106),(2,108),(2,500),(2,501),(2,1000),(2,1001),(2,1002),(2,1003),(2,1004),(2,1005),(2,1006),(2,1007),(2,1008),(2,1009),(2,1010),(2,1011),(2,1012),(2,1013),(2,1014),(2,1015),(2,1016),(2,1017),(2,1018),(2,1019),(2,1020),(2,1021),(2,1022),(2,1023),(2,1024),(2,1025),(2,1026),(2,1027),(2,1028),(2,1029),(2,1030),(2,1031),(2,1032),(2,1033),(2,1034),(2,1039),(2,1040),(2,1041),(2,1042),(2,1043),(2,1044),(2,1045),(2,2046),(2,2050),(2,2051),(2,2052),(2,2053),(2,2054),(2,2055),(2,2056),(2,2057),(2,2058),(2,2059),(2,2060),(2,2061),(2,2065),(2,2066),(2,2067),(2,2068),(2,2069),(2,2070),(100,2051),(100,2052);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,103,'admin','管理员','00','admin@163.com','15888888888','0','/profile/avatar/2025/07/21/homeImg_20250721133845A001.png','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','172.22.0.1','2026-05-29 11:36:26','admin','2025-05-18 09:13:55','','2026-05-29 11:36:26','管理员'),(2,105,'ry','张小明','00','ry@qq.com','15666666666','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','2','127.0.0.1','2025-05-18 09:13:55','admin','2025-05-18 09:13:55','admin','2025-05-19 22:09:20','测试员'),(100,103,'system','system','00','','','0','','$2a$10$lhzL56PQ7Sb/sjCx2rmijOCS9pOoi3lJkQjLKMuZQLAJWS4xlC/N.','0','0','122.139.63.162','2025-08-05 08:26:03','admin','2025-07-04 08:55:44','','2025-08-05 00:26:02',NULL),(101,103,'test1','test1','00','','','0','','$2a$10$U7MXyXp.Dy4Lg1BbUyl49eMzlowWpwCXxpcIxTDbk9LXUg9URY35u','0','0','172.22.107.47','2025-09-09 11:05:14','admin','2025-08-01 03:01:27','','2025-09-09 11:05:14',NULL);
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_post`
--

DROP TABLE IF EXISTS `sys_user_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_post` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='用户与岗位关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_post`
--

LOCK TABLES `sys_user_post` WRITE;
/*!40000 ALTER TABLE `sys_user_post` DISABLE KEYS */;
INSERT INTO `sys_user_post` VALUES (1,1);
/*!40000 ALTER TABLE `sys_user_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1),(100,2),(101,100);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-29 11:37:46
