/*
 Navicat Premium Dump SQL

 Source Server         : picture
 Source Server Type    : MySQL
 Source Server Version : 80409 (8.4.9)
 Source Host           : 127.0.0.1:3306
 Source Schema         : picture

 Target Server Type    : MySQL
 Target Server Version : 80409 (8.4.9)
 File Encoding         : 65001

 Date: 04/05/2026 18:42:42
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for picture
-- ----------------------------
DROP TABLE IF EXISTS `picture`;
CREATE TABLE `picture` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `url` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片 url',
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片名称',
  `introduction` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '简介',
  `category` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '分类',
  `tags` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签（JSON 数组）',
  `picSize` bigint DEFAULT NULL COMMENT '图片体积',
  `picWidth` int DEFAULT NULL COMMENT '图片宽度',
  `picHeight` int DEFAULT NULL COMMENT '图片高度',
  `picScale` double DEFAULT NULL COMMENT '图片宽高比例',
  `picFormat` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片格式',
  `userId` bigint NOT NULL COMMENT '创建用户 id',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `editTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '编辑时间',
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `isDelete` tinyint NOT NULL DEFAULT '0' COMMENT '是否删除',
  `reviewStatus` int NOT NULL DEFAULT '0' COMMENT '审核状态：0-待审核; 1-通过; 2-拒绝',
  `reviewMessage` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '审核信息',
  `reviewerId` bigint DEFAULT NULL COMMENT '审核人 ID',
  `reviewTime` datetime DEFAULT NULL COMMENT '审核时间',
  `thumbnailUrl` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '缩略图 url',
  `spaceId` bigint DEFAULT NULL COMMENT '空间 id（为空表示公共空间）',
  `picColor` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片主色调',
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`),
  KEY `idx_introduction` (`introduction`),
  KEY `idx_category` (`category`),
  KEY `idx_tags` (`tags`),
  KEY `idx_userId` (`userId`),
  KEY `idx_reviewStatus` (`reviewStatus`),
  KEY `idx_spaceId` (`spaceId`)
) ENGINE=InnoDB AUTO_INCREMENT=2050836771100954627 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='图片';

-- ----------------------------
-- Table structure for picture_history
-- ----------------------------
DROP TABLE IF EXISTS `picture_history`;
CREATE TABLE `picture_history` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `pictureId` bigint NOT NULL COMMENT '图片 id',
  `spaceId` bigint NOT NULL COMMENT '空间 id',
  `versionNo` int NOT NULL COMMENT '版本号',
  `operatorUserId` bigint DEFAULT NULL COMMENT '操作人 id',
  `pictureData` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片快照 JSON',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_pictureId_versionNo` (`pictureId`,`versionNo`),
  KEY `idx_pictureId_createTime` (`pictureId`,`createTime`)
) ENGINE=InnoDB AUTO_INCREMENT=2050485404096372738 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='图片历史版本';

-- ----------------------------
-- Table structure for picture_recycle
-- ----------------------------
DROP TABLE IF EXISTS `picture_recycle`;
CREATE TABLE `picture_recycle` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `pictureId` bigint NOT NULL COMMENT '原图片 id',
  `spaceId` bigint NOT NULL COMMENT '空间 id',
  `deletedBy` bigint NOT NULL COMMENT '删除操作人 id',
  `originUserId` bigint DEFAULT NULL COMMENT '原上传者 id',
  `pictureData` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '删除前图片快照 JSON',
  `expireTime` datetime DEFAULT NULL COMMENT '过期时间',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_spaceId_createTime` (`spaceId`,`createTime`),
  KEY `idx_pictureId` (`pictureId`)
) ENGINE=InnoDB AUTO_INCREMENT=2050486490169450499 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='空间图片回收站';

-- ----------------------------
-- Table structure for picture_review_log
-- ----------------------------
DROP TABLE IF EXISTS `picture_review_log`;
CREATE TABLE `picture_review_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `pictureId` bigint NOT NULL COMMENT '图片 id',
  `pictureName` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片名称',
  `pictureUserId` bigint NOT NULL COMMENT '上传用户 id',
  `reviewerId` bigint NOT NULL COMMENT '审核管理员 id',
  `reviewStatus` int NOT NULL COMMENT '审核结果：1-通过; 2-拒绝',
  `oldReviewStatus` int NOT NULL COMMENT '审核前状态',
  `reviewMessage` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '审核意见',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_pictureId_createTime` (`pictureId`,`createTime`),
  KEY `idx_pictureUserId` (`pictureUserId`),
  KEY `idx_reviewerId_createTime` (`reviewerId`,`createTime`),
  KEY `idx_reviewStatus_createTime` (`reviewStatus`,`createTime`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='图片审核日志';

-- ----------------------------
-- Table structure for space
-- ----------------------------
DROP TABLE IF EXISTS `space`;
CREATE TABLE `space` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `spaceName` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '空间名称',
  `spaceLevel` int DEFAULT '0' COMMENT '空间级别：0-普通版 1-专业版 2-旗舰版',
  `maxSize` bigint DEFAULT '0' COMMENT '空间图片的最大总大小',
  `maxCount` bigint DEFAULT '0' COMMENT '空间图片的最大数量',
  `totalSize` bigint DEFAULT '0' COMMENT '当前空间下图片的总大小',
  `totalCount` bigint DEFAULT '0' COMMENT '当前空间下的图片数量',
  `userId` bigint NOT NULL COMMENT '创建用户 id',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `editTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '编辑时间',
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `isDelete` tinyint NOT NULL DEFAULT '0' COMMENT '是否删除',
  `spaceType` int NOT NULL DEFAULT '0' COMMENT '空间类型：0-私有 1-团队',
  PRIMARY KEY (`id`),
  KEY `idx_userId` (`userId`),
  KEY `idx_spaceName` (`spaceName`),
  KEY `idx_spaceLevel` (`spaceLevel`),
  KEY `idx_spaceType` (`spaceType`)
) ENGINE=InnoDB AUTO_INCREMENT=2050229476809887746 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='空间';

-- ----------------------------
-- Table structure for space_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `space_operation_log`;
CREATE TABLE `space_operation_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `spaceId` bigint NOT NULL COMMENT '空间 id',
  `userId` bigint NOT NULL COMMENT '操作用户 id',
  `operationType` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型',
  `targetType` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作对象类型',
  `targetId` bigint DEFAULT NULL COMMENT '操作对象 id',
  `operationContent` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作内容',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_spaceId_createTime` (`spaceId`,`createTime`),
  KEY `idx_userId` (`userId`),
  KEY `idx_operationType` (`operationType`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='空间操作日志';

-- ----------------------------
-- Table structure for space_user
-- ----------------------------
DROP TABLE IF EXISTS `space_user`;
CREATE TABLE `space_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `spaceId` bigint NOT NULL COMMENT '空间 id',
  `userId` bigint NOT NULL COMMENT '用户 id',
  `spaceRole` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT 'viewer' COMMENT '空间角色：viewer/editor/admin',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_spaceId_userId` (`spaceId`,`userId`),
  KEY `idx_spaceId` (`spaceId`),
  KEY `idx_userId` (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='空间用户关联';

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `userAccount` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '账号',
  `userPassword` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `userName` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户昵称',
  `userAvatar` varchar(1024) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户头像',
  `userProfile` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户简介',
  `userRole` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user' COMMENT '用户角色：user/admin',
  `editTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '编辑时间',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `isDelete` tinyint NOT NULL DEFAULT '0' COMMENT '是否删除',
  `vipExpireTime` datetime DEFAULT NULL COMMENT '会员过期时间',
  `vipCode` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '会员兑换码',
  `vipNumber` bigint DEFAULT NULL COMMENT '会员编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_userAccount` (`userAccount`),
  KEY `idx_userName` (`userName`)
) ENGINE=InnoDB AUTO_INCREMENT=2050082358199623682 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户';

SET FOREIGN_KEY_CHECKS = 1;
