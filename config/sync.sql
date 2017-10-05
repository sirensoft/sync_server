/*
Navicat MySQL Data Transfer

Source Server         : dhdc เมือง
Source Server Version : 50505
Source Database       : sync

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2017-10-05 22:20:39
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for command
-- ----------------------------
DROP TABLE IF EXISTS `command`;
CREATE TABLE `command` (
  `id` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `table` varchar(255) DEFAULT NULL,
  `sql` longtext,
  `active` enum('1','0') DEFAULT NULL,
  `sync_all` enum('0','1') DEFAULT NULL,
  `cstatus` enum('on','off') DEFAULT NULL,
  `update` datetime DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of command
-- ----------------------------
INSERT INTO `command` VALUES ('act-1', 'ตรวจสอบกิจกรรมบนระบบ DHDC', 'dhdc_activity', ' SELECT \r\n(SELECT t.district_code FROM sys_config_main t) dist\r\n,(SELECT t.district_name FROM sys_config_main t) amp\r\n,(SELECT  version FROM sys_db_version) ver\r\n,(SELECT COUNT(*) FROM user) users\r\n,(SELECT * from last_transform) tran\r\n,(SELECT * from last_err_check ) qc', '1', '1', 'on', '2017-08-30 22:43:40', 'การตรวจสอบ');
INSERT INTO `command` VALUES ('data-1', 'รายชื่อเด็ก 0-5 ปี ในเขตรับผิดชอบ(ตัดอายุ ณ วันปัจจุบัน)', 'person_age5', 'SELECT t.HOSPCODE,t.PID,t.CID,t.`NAME`\r\n,t.LNAME,t.BIRTH\r\n,t.SEX\r\n,TIMESTAMPDIFF(MONTH, date(t.BIRTH), CURDATE()) AS AGE_M \r\n,t.vhid ADDR\r\n,t.addr HOUSE\r\nFROM t_person_cid t\r\nWHERE t.TYPEAREA in (1,3,5) AND t.DISCHARGE = 9\r\nHAVING AGE_M <=60', '1', '0', 'on', '2017-09-03 15:46:52', 'PMจังหวัด ขอข้อมูล');
INSERT INTO `command` VALUES ('data-2', 'หลังคาเรือน HOME', 'home', 'select * from home where trim(HOUSE) <> \'\' or HOUSE is not NULL', '1', '0', 'on', '2017-09-14 11:09:33', 'อุเทน ขอข้อมูลแฟ้ม HOME');
INSERT INTO `command` VALUES ('epi-1', 'ดึง EPI ย้อน 5 ปี', 'epi', 'SELECT * FROM epi WHERE HOSPCODE <> \'\' AND PID <> \'\' AND VACCINETYPE <> \'\'\r\nAND  date(DATE_SERV) >= DATE_SUB(\'2017-01-01\',INTERVAL 5 YEAR) \r\n', '1', '0', 'on', '2017-09-21 12:22:41', 'ดึง EPI ย้อน 5 ปี');
INSERT INTO `command` VALUES ('gis-1', 'จำนวนหลังคาเรือนที่มีการบันทึกพิกัดภูมิศาสตร์', 'home_gis', 'SELECT t.hospcode,t.b,t.a,ROUND(t.a*100/t.b,2) rate,t.dupdate from (\r\nSELECT t.HOSPCODE hospcode\r\n,count(t.HOSPCODE) b\r\n,count(if(t.LATITUDE*1>=13 AND t.LONGITUDE*1>90,t.HOSPCODE,NULL)) a\r\n,CURDATE() dupdate\r\nFROM home t\r\nGROUP BY t.HOSPCODE\r\n) t', '1', '1', 'on', '2017-08-30 21:56:44', 'นโยบายพิษณุโลก 4.0 (ผจว)');
INSERT INTO `command` VALUES ('psyco-1', 'จังหวัดดึงข้อมูลผู้ป่วยด้านจิตเวช', 'plk_psyco', 'SELECT (SELECT c.district_code FROM sys_config_main c) AMP\r\n,(SELECT c.district_name FROM sys_config_main c) AMP_NAME\r\n,t.HOSPCODE,t.CID,t.`NAME`,t.LNAME,t.SEX,t.age_y AGE\r\n,d.DIAGCODE,max(d.DATE_SERV) LAST_DX_DATE FROM t_person_cid  t\r\nINNER JOIN diagnosis_opd d ON d.HOSPCODE = t.HOSPCODE AND d.PID = t.PID\r\n\r\nAND (d.DIAGCODE  LIKE \'F%\' OR d.DIAGCODE  BETWEEN \'X60\' AND \'X849\')\r\nWHERE t.TYPEAREA in (1,3) AND t.DISCHARGE = 9\r\nGROUP BY t.CID,d.DIAGCODE\r\nORDER BY t.CID ASC ,d.DIAGCODE ASC', '1', '0', 'on', '2017-10-02 09:35:54', 'กลุ่มงานส่งเสริมฯขอข้อมูล');
INSERT INTO `command` VALUES ('qc-1', 'ประชากร TYPE 1,3 มีการบันทึกที่อยู่', 'homeless', 'SELECT t.hospcode,t.b,t.a,ROUND((t.a*100/t.b),2) rate from (\r\nSELECT t.HOSPCODE hospcode\r\n,COUNT(t.HOSPCODE) b \r\n,COUNT(if(h.HID IS NOT NULL,1,NULL)) a\r\nfrom t_person_cid  t\r\nLEFT JOIN home h ON t.HOSPCODE = h.HOSPCODE AND t.HID = h.HID\r\nWHERE t.TYPEAREA in (1,3) AND t.DISCHARGE = 9\r\nGROUP BY t.HOSPCODE\r\n) t', '1', '1', 'on', '2017-08-31 14:03:47', 'ตรวจสอบคุณภาพ');
INSERT INTO `command` VALUES ('qc-2', 'ประชากรTYPE1,3 มีอายุติดลบ', 'age_err', 'SELECT t.hospcode,t.b,t.a,ROUND(t.a*100/t.b,2) rate from (\r\nSELECT t.HOSPCODE hospcode\r\n,COUNT(t.HOSPCODE) b\r\n,COUNT(if(date(t.birth) > CURDATE(),1,NULL)) a \r\nFROM t_person_cid t\r\nWHERE t.TYPEAREA in (1,3) AND t.DISCHARGE = 9\r\nGROUP BY t.HOSPCODE\r\n) t', '1', '1', 'on', '2017-09-01 15:40:14', 'ตรวจสอบคุณภาพ');
INSERT INTO `command` VALUES ('qof-1', 'ฝากครรภ์ครั้งแรก 12 สัปดาห์', 'qof_anc12', 'select 	q.hospcode\r\n	,count(DISTINCT concat(q.pid, q.hospcode)) b\r\n	,count(if(q.DATE_SERV BETWEEN \'2017-04-01\' and \'2018-03-31\' and q.ANCNO = 1 and q.GA <= 12,1,null)) a\r\n  ,round((count(if(q.DATE_SERV BETWEEN \'2017-04-01\' and \'2018-03-31\' and q.ANCNO = 1 and q.GA <= 12,1,null))/\r\ncount(DISTINCT concat(q.pid, q.hospcode)))*100,2) rate\r\nfrom nhso_tmpqof003_anc q\r\ngroup by q.HOSPCODE', '1', '1', 'on', '2017-08-31 16:56:08', 'QOF-2561');
