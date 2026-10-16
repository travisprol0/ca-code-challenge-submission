/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.6-MariaDB, for debian-linux-gnu (aarch64)
--
-- Host: localhost    Database: wp
-- ------------------------------------------------------
-- Server version	11.8.6-MariaDB-ubu2404

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `wp_commentmeta`
--

DROP TABLE IF EXISTS `wp_commentmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_commentmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `comment_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL,
  PRIMARY KEY (`meta_id`),
  KEY `comment_id` (`comment_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_commentmeta`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `wp_commentmeta` WRITE;
/*!40000 ALTER TABLE `wp_commentmeta` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_commentmeta` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `wp_comments`
--

DROP TABLE IF EXISTS `wp_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_comments` (
  `comment_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `comment_post_ID` bigint(20) unsigned NOT NULL DEFAULT 0,
  `comment_author` tinytext NOT NULL,
  `comment_author_email` varchar(100) NOT NULL DEFAULT '',
  `comment_author_url` varchar(200) NOT NULL DEFAULT '',
  `comment_author_IP` varchar(100) NOT NULL DEFAULT '',
  `comment_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_content` text NOT NULL,
  `comment_karma` int(11) NOT NULL DEFAULT 0,
  `comment_approved` varchar(20) NOT NULL DEFAULT '1',
  `comment_agent` varchar(255) NOT NULL DEFAULT '',
  `comment_type` varchar(20) NOT NULL DEFAULT 'comment',
  `comment_parent` bigint(20) unsigned NOT NULL DEFAULT 0,
  `user_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`comment_ID`),
  KEY `comment_post_ID` (`comment_post_ID`),
  KEY `comment_approved_date_gmt` (`comment_approved`,`comment_date_gmt`),
  KEY `comment_date_gmt` (`comment_date_gmt`),
  KEY `comment_parent` (`comment_parent`),
  KEY `comment_author_email` (`comment_author_email`(10))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_comments`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `wp_comments` WRITE;
/*!40000 ALTER TABLE `wp_comments` DISABLE KEYS */;
INSERT INTO `wp_comments` VALUES (1,1,'A WordPress Commenter','wapuu@wordpress.example','https://wordpress.org/','','2026-05-19 20:28:55','2026-05-19 20:28:55','Hi, this is a comment.\nTo get started with moderating, editing, and deleting comments, please visit the Comments screen in the dashboard.\nCommenter avatars come from <a href=\"https://gravatar.com/\">Gravatar</a>.',0,'1','','comment',0,0);
/*!40000 ALTER TABLE `wp_comments` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `wp_links`
--

DROP TABLE IF EXISTS `wp_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_links` (
  `link_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `link_url` varchar(255) NOT NULL DEFAULT '',
  `link_name` varchar(255) NOT NULL DEFAULT '',
  `link_image` varchar(255) NOT NULL DEFAULT '',
  `link_target` varchar(25) NOT NULL DEFAULT '',
  `link_description` varchar(255) NOT NULL DEFAULT '',
  `link_visible` varchar(20) NOT NULL DEFAULT 'Y',
  `link_owner` bigint(20) unsigned NOT NULL DEFAULT 1,
  `link_rating` int(11) NOT NULL DEFAULT 0,
  `link_updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `link_rel` varchar(255) NOT NULL DEFAULT '',
  `link_notes` mediumtext NOT NULL,
  `link_rss` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`link_id`),
  KEY `link_visible` (`link_visible`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_links`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `wp_links` WRITE;
/*!40000 ALTER TABLE `wp_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_links` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `wp_options`
--

DROP TABLE IF EXISTS `wp_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_options` (
  `option_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `option_name` varchar(191) NOT NULL DEFAULT '',
  `option_value` longtext NOT NULL,
  `autoload` varchar(20) NOT NULL DEFAULT 'yes',
  PRIMARY KEY (`option_id`),
  UNIQUE KEY `option_name` (`option_name`),
  KEY `autoload` (`autoload`)
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_options`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `wp_options` WRITE;
/*!40000 ALTER TABLE `wp_options` DISABLE KEYS */;
INSERT INTO `wp_options` VALUES (1,'cron','a:7:{i:1779222535;a:3:{s:32:\"recovery_mode_clean_expired_keys\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:5:\"daily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:86400;}}s:34:\"wp_privacy_delete_old_export_files\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:6:\"hourly\";s:4:\"args\";a:0:{}s:8:\"interval\";i:3600;}}s:27:\"acf_update_site_health_data\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:5:\"daily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:86400;}}}i:1779222536;a:1:{s:31:\"wpseo_permalink_structure_check\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:5:\"daily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:86400;}}}i:1779226135;a:1:{s:16:\"wp_version_check\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:10:\"twicedaily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:43200;}}}i:1779227935;a:1:{s:17:\"wp_update_plugins\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:10:\"twicedaily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:43200;}}}i:1779229735;a:1:{s:16:\"wp_update_themes\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:10:\"twicedaily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:43200;}}}i:1779308935;a:1:{s:30:\"wp_site_health_scheduled_check\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:6:\"weekly\";s:4:\"args\";a:0:{}s:8:\"interval\";i:604800;}}}s:7:\"version\";i:2;}','on');
INSERT INTO `wp_options` VALUES (2,'siteurl','http://localhost:8080','on');
INSERT INTO `wp_options` VALUES (3,'home','http://localhost:8080','on');
INSERT INTO `wp_options` VALUES (4,'blogname','Brand Reviews Challenge','on');
INSERT INTO `wp_options` VALUES (5,'blogdescription','','on');
INSERT INTO `wp_options` VALUES (6,'users_can_register','0','on');
INSERT INTO `wp_options` VALUES (7,'admin_email','admin@example.com','on');
INSERT INTO `wp_options` VALUES (8,'start_of_week','1','on');
INSERT INTO `wp_options` VALUES (9,'use_balanceTags','0','on');
INSERT INTO `wp_options` VALUES (10,'use_smilies','1','on');
INSERT INTO `wp_options` VALUES (11,'require_name_email','1','on');
INSERT INTO `wp_options` VALUES (12,'comments_notify','1','on');
INSERT INTO `wp_options` VALUES (13,'posts_per_rss','10','on');
INSERT INTO `wp_options` VALUES (14,'rss_use_excerpt','0','on');
INSERT INTO `wp_options` VALUES (15,'mailserver_url','mail.example.com','on');
INSERT INTO `wp_options` VALUES (16,'mailserver_login','login@example.com','on');
INSERT INTO `wp_options` VALUES (17,'mailserver_pass','','on');
INSERT INTO `wp_options` VALUES (18,'mailserver_port','110','on');
INSERT INTO `wp_options` VALUES (19,'default_category','1','on');
INSERT INTO `wp_options` VALUES (20,'default_comment_status','open','on');
INSERT INTO `wp_options` VALUES (21,'default_ping_status','open','on');
INSERT INTO `wp_options` VALUES (22,'default_pingback_flag','1','on');
INSERT INTO `wp_options` VALUES (23,'posts_per_page','10','on');
INSERT INTO `wp_options` VALUES (24,'date_format','F j, Y','on');
INSERT INTO `wp_options` VALUES (25,'time_format','g:i a','on');
INSERT INTO `wp_options` VALUES (26,'links_updated_date_format','F j, Y g:i a','on');
INSERT INTO `wp_options` VALUES (27,'comment_moderation','0','on');
INSERT INTO `wp_options` VALUES (28,'moderation_notify','1','on');
INSERT INTO `wp_options` VALUES (29,'permalink_structure','/%postname%/','on');
INSERT INTO `wp_options` VALUES (30,'rewrite_rules','a:146:{s:11:\"^wp-json/?$\";s:22:\"index.php?rest_route=/\";s:14:\"^wp-json/(.*)?\";s:33:\"index.php?rest_route=/$matches[1]\";s:21:\"^index.php/wp-json/?$\";s:22:\"index.php?rest_route=/\";s:24:\"^index.php/wp-json/(.*)?\";s:33:\"index.php?rest_route=/$matches[1]\";s:17:\"^wp-sitemap\\.xml$\";s:23:\"index.php?sitemap=index\";s:17:\"^wp-sitemap\\.xsl$\";s:36:\"index.php?sitemap-stylesheet=sitemap\";s:23:\"^wp-sitemap-index\\.xsl$\";s:34:\"index.php?sitemap-stylesheet=index\";s:48:\"^wp-sitemap-([a-z]+?)-([a-z\\d_-]+?)-(\\d+?)\\.xml$\";s:75:\"index.php?sitemap=$matches[1]&sitemap-subtype=$matches[2]&paged=$matches[3]\";s:34:\"^wp-sitemap-([a-z]+?)-(\\d+?)\\.xml$\";s:47:\"index.php?sitemap=$matches[1]&paged=$matches[2]\";s:8:\"brand/?$\";s:25:\"index.php?post_type=brand\";s:38:\"brand/feed/(feed|rdf|rss|rss2|atom)/?$\";s:42:\"index.php?post_type=brand&feed=$matches[1]\";s:33:\"brand/(feed|rdf|rss|rss2|atom)/?$\";s:42:\"index.php?post_type=brand&feed=$matches[1]\";s:25:\"brand/page/([0-9]{1,})/?$\";s:43:\"index.php?post_type=brand&paged=$matches[1]\";s:9:\"review/?$\";s:26:\"index.php?post_type=review\";s:39:\"review/feed/(feed|rdf|rss|rss2|atom)/?$\";s:43:\"index.php?post_type=review&feed=$matches[1]\";s:34:\"review/(feed|rdf|rss|rss2|atom)/?$\";s:43:\"index.php?post_type=review&feed=$matches[1]\";s:26:\"review/page/([0-9]{1,})/?$\";s:44:\"index.php?post_type=review&paged=$matches[1]\";s:47:\"category/(.+?)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:52:\"index.php?category_name=$matches[1]&feed=$matches[2]\";s:42:\"category/(.+?)/(feed|rdf|rss|rss2|atom)/?$\";s:52:\"index.php?category_name=$matches[1]&feed=$matches[2]\";s:23:\"category/(.+?)/embed/?$\";s:46:\"index.php?category_name=$matches[1]&embed=true\";s:35:\"category/(.+?)/page/?([0-9]{1,})/?$\";s:53:\"index.php?category_name=$matches[1]&paged=$matches[2]\";s:17:\"category/(.+?)/?$\";s:35:\"index.php?category_name=$matches[1]\";s:44:\"tag/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:42:\"index.php?tag=$matches[1]&feed=$matches[2]\";s:39:\"tag/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:42:\"index.php?tag=$matches[1]&feed=$matches[2]\";s:20:\"tag/([^/]+)/embed/?$\";s:36:\"index.php?tag=$matches[1]&embed=true\";s:32:\"tag/([^/]+)/page/?([0-9]{1,})/?$\";s:43:\"index.php?tag=$matches[1]&paged=$matches[2]\";s:14:\"tag/([^/]+)/?$\";s:25:\"index.php?tag=$matches[1]\";s:45:\"type/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:50:\"index.php?post_format=$matches[1]&feed=$matches[2]\";s:40:\"type/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:50:\"index.php?post_format=$matches[1]&feed=$matches[2]\";s:21:\"type/([^/]+)/embed/?$\";s:44:\"index.php?post_format=$matches[1]&embed=true\";s:33:\"type/([^/]+)/page/?([0-9]{1,})/?$\";s:51:\"index.php?post_format=$matches[1]&paged=$matches[2]\";s:15:\"type/([^/]+)/?$\";s:33:\"index.php?post_format=$matches[1]\";s:33:\"brand/[^/]+/attachment/([^/]+)/?$\";s:32:\"index.php?attachment=$matches[1]\";s:43:\"brand/[^/]+/attachment/([^/]+)/trackback/?$\";s:37:\"index.php?attachment=$matches[1]&tb=1\";s:63:\"brand/[^/]+/attachment/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:58:\"brand/[^/]+/attachment/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:58:\"brand/[^/]+/attachment/([^/]+)/comment-page-([0-9]{1,})/?$\";s:50:\"index.php?attachment=$matches[1]&cpage=$matches[2]\";s:39:\"brand/[^/]+/attachment/([^/]+)/embed/?$\";s:43:\"index.php?attachment=$matches[1]&embed=true\";s:22:\"brand/([^/]+)/embed/?$\";s:38:\"index.php?brand=$matches[1]&embed=true\";s:26:\"brand/([^/]+)/trackback/?$\";s:32:\"index.php?brand=$matches[1]&tb=1\";s:46:\"brand/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:44:\"index.php?brand=$matches[1]&feed=$matches[2]\";s:41:\"brand/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:44:\"index.php?brand=$matches[1]&feed=$matches[2]\";s:34:\"brand/([^/]+)/page/?([0-9]{1,})/?$\";s:45:\"index.php?brand=$matches[1]&paged=$matches[2]\";s:41:\"brand/([^/]+)/comment-page-([0-9]{1,})/?$\";s:45:\"index.php?brand=$matches[1]&cpage=$matches[2]\";s:30:\"brand/([^/]+)(?:/([0-9]+))?/?$\";s:44:\"index.php?brand=$matches[1]&page=$matches[2]\";s:22:\"brand/[^/]+/([^/]+)/?$\";s:32:\"index.php?attachment=$matches[1]\";s:32:\"brand/[^/]+/([^/]+)/trackback/?$\";s:37:\"index.php?attachment=$matches[1]&tb=1\";s:52:\"brand/[^/]+/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:47:\"brand/[^/]+/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:47:\"brand/[^/]+/([^/]+)/comment-page-([0-9]{1,})/?$\";s:50:\"index.php?attachment=$matches[1]&cpage=$matches[2]\";s:28:\"brand/[^/]+/([^/]+)/embed/?$\";s:43:\"index.php?attachment=$matches[1]&embed=true\";s:34:\"review/[^/]+/attachment/([^/]+)/?$\";s:32:\"index.php?attachment=$matches[1]\";s:44:\"review/[^/]+/attachment/([^/]+)/trackback/?$\";s:37:\"index.php?attachment=$matches[1]&tb=1\";s:64:\"review/[^/]+/attachment/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:59:\"review/[^/]+/attachment/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:59:\"review/[^/]+/attachment/([^/]+)/comment-page-([0-9]{1,})/?$\";s:50:\"index.php?attachment=$matches[1]&cpage=$matches[2]\";s:40:\"review/[^/]+/attachment/([^/]+)/embed/?$\";s:43:\"index.php?attachment=$matches[1]&embed=true\";s:23:\"review/([^/]+)/embed/?$\";s:39:\"index.php?review=$matches[1]&embed=true\";s:27:\"review/([^/]+)/trackback/?$\";s:33:\"index.php?review=$matches[1]&tb=1\";s:47:\"review/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:45:\"index.php?review=$matches[1]&feed=$matches[2]\";s:42:\"review/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:45:\"index.php?review=$matches[1]&feed=$matches[2]\";s:35:\"review/([^/]+)/page/?([0-9]{1,})/?$\";s:46:\"index.php?review=$matches[1]&paged=$matches[2]\";s:42:\"review/([^/]+)/comment-page-([0-9]{1,})/?$\";s:46:\"index.php?review=$matches[1]&cpage=$matches[2]\";s:31:\"review/([^/]+)(?:/([0-9]+))?/?$\";s:45:\"index.php?review=$matches[1]&page=$matches[2]\";s:23:\"review/[^/]+/([^/]+)/?$\";s:32:\"index.php?attachment=$matches[1]\";s:33:\"review/[^/]+/([^/]+)/trackback/?$\";s:37:\"index.php?attachment=$matches[1]&tb=1\";s:53:\"review/[^/]+/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:48:\"review/[^/]+/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:48:\"review/[^/]+/([^/]+)/comment-page-([0-9]{1,})/?$\";s:50:\"index.php?attachment=$matches[1]&cpage=$matches[2]\";s:29:\"review/[^/]+/([^/]+)/embed/?$\";s:43:\"index.php?attachment=$matches[1]&embed=true\";s:49:\"industry/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:47:\"index.php?industry=$matches[1]&feed=$matches[2]\";s:44:\"industry/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:47:\"index.php?industry=$matches[1]&feed=$matches[2]\";s:25:\"industry/([^/]+)/embed/?$\";s:41:\"index.php?industry=$matches[1]&embed=true\";s:37:\"industry/([^/]+)/page/?([0-9]{1,})/?$\";s:48:\"index.php?industry=$matches[1]&paged=$matches[2]\";s:19:\"industry/([^/]+)/?$\";s:30:\"index.php?industry=$matches[1]\";s:12:\"robots\\.txt$\";s:18:\"index.php?robots=1\";s:13:\"favicon\\.ico$\";s:19:\"index.php?favicon=1\";s:12:\"sitemap\\.xml\";s:23:\"index.php?sitemap=index\";s:48:\".*wp-(atom|rdf|rss|rss2|feed|commentsrss2)\\.php$\";s:18:\"index.php?feed=old\";s:20:\".*wp-app\\.php(/.*)?$\";s:19:\"index.php?error=403\";s:18:\".*wp-register.php$\";s:23:\"index.php?register=true\";s:32:\"feed/(feed|rdf|rss|rss2|atom)/?$\";s:27:\"index.php?&feed=$matches[1]\";s:27:\"(feed|rdf|rss|rss2|atom)/?$\";s:27:\"index.php?&feed=$matches[1]\";s:8:\"embed/?$\";s:21:\"index.php?&embed=true\";s:20:\"page/?([0-9]{1,})/?$\";s:28:\"index.php?&paged=$matches[1]\";s:27:\"comment-page-([0-9]{1,})/?$\";s:38:\"index.php?&page_id=4&cpage=$matches[1]\";s:41:\"comments/feed/(feed|rdf|rss|rss2|atom)/?$\";s:42:\"index.php?&feed=$matches[1]&withcomments=1\";s:36:\"comments/(feed|rdf|rss|rss2|atom)/?$\";s:42:\"index.php?&feed=$matches[1]&withcomments=1\";s:17:\"comments/embed/?$\";s:21:\"index.php?&embed=true\";s:44:\"search/(.+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:40:\"index.php?s=$matches[1]&feed=$matches[2]\";s:39:\"search/(.+)/(feed|rdf|rss|rss2|atom)/?$\";s:40:\"index.php?s=$matches[1]&feed=$matches[2]\";s:20:\"search/(.+)/embed/?$\";s:34:\"index.php?s=$matches[1]&embed=true\";s:32:\"search/(.+)/page/?([0-9]{1,})/?$\";s:41:\"index.php?s=$matches[1]&paged=$matches[2]\";s:14:\"search/(.+)/?$\";s:23:\"index.php?s=$matches[1]\";s:47:\"author/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:50:\"index.php?author_name=$matches[1]&feed=$matches[2]\";s:42:\"author/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:50:\"index.php?author_name=$matches[1]&feed=$matches[2]\";s:23:\"author/([^/]+)/embed/?$\";s:44:\"index.php?author_name=$matches[1]&embed=true\";s:35:\"author/([^/]+)/page/?([0-9]{1,})/?$\";s:51:\"index.php?author_name=$matches[1]&paged=$matches[2]\";s:17:\"author/([^/]+)/?$\";s:33:\"index.php?author_name=$matches[1]\";s:69:\"([0-9]{4})/([0-9]{1,2})/([0-9]{1,2})/feed/(feed|rdf|rss|rss2|atom)/?$\";s:80:\"index.php?year=$matches[1]&monthnum=$matches[2]&day=$matches[3]&feed=$matches[4]\";s:64:\"([0-9]{4})/([0-9]{1,2})/([0-9]{1,2})/(feed|rdf|rss|rss2|atom)/?$\";s:80:\"index.php?year=$matches[1]&monthnum=$matches[2]&day=$matches[3]&feed=$matches[4]\";s:45:\"([0-9]{4})/([0-9]{1,2})/([0-9]{1,2})/embed/?$\";s:74:\"index.php?year=$matches[1]&monthnum=$matches[2]&day=$matches[3]&embed=true\";s:57:\"([0-9]{4})/([0-9]{1,2})/([0-9]{1,2})/page/?([0-9]{1,})/?$\";s:81:\"index.php?year=$matches[1]&monthnum=$matches[2]&day=$matches[3]&paged=$matches[4]\";s:39:\"([0-9]{4})/([0-9]{1,2})/([0-9]{1,2})/?$\";s:63:\"index.php?year=$matches[1]&monthnum=$matches[2]&day=$matches[3]\";s:56:\"([0-9]{4})/([0-9]{1,2})/feed/(feed|rdf|rss|rss2|atom)/?$\";s:64:\"index.php?year=$matches[1]&monthnum=$matches[2]&feed=$matches[3]\";s:51:\"([0-9]{4})/([0-9]{1,2})/(feed|rdf|rss|rss2|atom)/?$\";s:64:\"index.php?year=$matches[1]&monthnum=$matches[2]&feed=$matches[3]\";s:32:\"([0-9]{4})/([0-9]{1,2})/embed/?$\";s:58:\"index.php?year=$matches[1]&monthnum=$matches[2]&embed=true\";s:44:\"([0-9]{4})/([0-9]{1,2})/page/?([0-9]{1,})/?$\";s:65:\"index.php?year=$matches[1]&monthnum=$matches[2]&paged=$matches[3]\";s:26:\"([0-9]{4})/([0-9]{1,2})/?$\";s:47:\"index.php?year=$matches[1]&monthnum=$matches[2]\";s:43:\"([0-9]{4})/feed/(feed|rdf|rss|rss2|atom)/?$\";s:43:\"index.php?year=$matches[1]&feed=$matches[2]\";s:38:\"([0-9]{4})/(feed|rdf|rss|rss2|atom)/?$\";s:43:\"index.php?year=$matches[1]&feed=$matches[2]\";s:19:\"([0-9]{4})/embed/?$\";s:37:\"index.php?year=$matches[1]&embed=true\";s:31:\"([0-9]{4})/page/?([0-9]{1,})/?$\";s:44:\"index.php?year=$matches[1]&paged=$matches[2]\";s:13:\"([0-9]{4})/?$\";s:26:\"index.php?year=$matches[1]\";s:27:\".?.+?/attachment/([^/]+)/?$\";s:32:\"index.php?attachment=$matches[1]\";s:37:\".?.+?/attachment/([^/]+)/trackback/?$\";s:37:\"index.php?attachment=$matches[1]&tb=1\";s:57:\".?.+?/attachment/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:52:\".?.+?/attachment/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:52:\".?.+?/attachment/([^/]+)/comment-page-([0-9]{1,})/?$\";s:50:\"index.php?attachment=$matches[1]&cpage=$matches[2]\";s:33:\".?.+?/attachment/([^/]+)/embed/?$\";s:43:\"index.php?attachment=$matches[1]&embed=true\";s:16:\"(.?.+?)/embed/?$\";s:41:\"index.php?pagename=$matches[1]&embed=true\";s:20:\"(.?.+?)/trackback/?$\";s:35:\"index.php?pagename=$matches[1]&tb=1\";s:40:\"(.?.+?)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:47:\"index.php?pagename=$matches[1]&feed=$matches[2]\";s:35:\"(.?.+?)/(feed|rdf|rss|rss2|atom)/?$\";s:47:\"index.php?pagename=$matches[1]&feed=$matches[2]\";s:28:\"(.?.+?)/page/?([0-9]{1,})/?$\";s:48:\"index.php?pagename=$matches[1]&paged=$matches[2]\";s:35:\"(.?.+?)/comment-page-([0-9]{1,})/?$\";s:48:\"index.php?pagename=$matches[1]&cpage=$matches[2]\";s:24:\"(.?.+?)(?:/([0-9]+))?/?$\";s:47:\"index.php?pagename=$matches[1]&page=$matches[2]\";s:27:\"[^/]+/attachment/([^/]+)/?$\";s:32:\"index.php?attachment=$matches[1]\";s:37:\"[^/]+/attachment/([^/]+)/trackback/?$\";s:37:\"index.php?attachment=$matches[1]&tb=1\";s:57:\"[^/]+/attachment/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:52:\"[^/]+/attachment/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:52:\"[^/]+/attachment/([^/]+)/comment-page-([0-9]{1,})/?$\";s:50:\"index.php?attachment=$matches[1]&cpage=$matches[2]\";s:33:\"[^/]+/attachment/([^/]+)/embed/?$\";s:43:\"index.php?attachment=$matches[1]&embed=true\";s:16:\"([^/]+)/embed/?$\";s:37:\"index.php?name=$matches[1]&embed=true\";s:20:\"([^/]+)/trackback/?$\";s:31:\"index.php?name=$matches[1]&tb=1\";s:40:\"([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:43:\"index.php?name=$matches[1]&feed=$matches[2]\";s:35:\"([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:43:\"index.php?name=$matches[1]&feed=$matches[2]\";s:28:\"([^/]+)/page/?([0-9]{1,})/?$\";s:44:\"index.php?name=$matches[1]&paged=$matches[2]\";s:35:\"([^/]+)/comment-page-([0-9]{1,})/?$\";s:44:\"index.php?name=$matches[1]&cpage=$matches[2]\";s:24:\"([^/]+)(?:/([0-9]+))?/?$\";s:43:\"index.php?name=$matches[1]&page=$matches[2]\";s:16:\"[^/]+/([^/]+)/?$\";s:32:\"index.php?attachment=$matches[1]\";s:26:\"[^/]+/([^/]+)/trackback/?$\";s:37:\"index.php?attachment=$matches[1]&tb=1\";s:46:\"[^/]+/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:41:\"[^/]+/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:41:\"[^/]+/([^/]+)/comment-page-([0-9]{1,})/?$\";s:50:\"index.php?attachment=$matches[1]&cpage=$matches[2]\";s:22:\"[^/]+/([^/]+)/embed/?$\";s:43:\"index.php?attachment=$matches[1]&embed=true\";}','on');
INSERT INTO `wp_options` VALUES (31,'hack_file','0','on');
INSERT INTO `wp_options` VALUES (32,'blog_charset','UTF-8','on');
INSERT INTO `wp_options` VALUES (33,'moderation_keys','','off');
INSERT INTO `wp_options` VALUES (34,'active_plugins','a:2:{i:0;s:30:\"advanced-custom-fields/acf.php\";i:1;s:24:\"wordpress-seo/wp-seo.php\";}','on');
INSERT INTO `wp_options` VALUES (35,'category_base','','on');
INSERT INTO `wp_options` VALUES (36,'ping_sites','https://rpc.pingomatic.com/','on');
INSERT INTO `wp_options` VALUES (37,'comment_max_links','2','on');
INSERT INTO `wp_options` VALUES (38,'gmt_offset','0','on');
INSERT INTO `wp_options` VALUES (39,'default_email_category','1','on');
INSERT INTO `wp_options` VALUES (40,'recently_edited','','off');
INSERT INTO `wp_options` VALUES (41,'template','consumer-reviews','on');
INSERT INTO `wp_options` VALUES (42,'stylesheet','consumer-reviews','on');
INSERT INTO `wp_options` VALUES (43,'comment_registration','0','on');
INSERT INTO `wp_options` VALUES (44,'html_type','text/html','on');
INSERT INTO `wp_options` VALUES (45,'use_trackback','0','on');
INSERT INTO `wp_options` VALUES (46,'default_role','subscriber','on');
INSERT INTO `wp_options` VALUES (47,'db_version','60717','on');
INSERT INTO `wp_options` VALUES (48,'uploads_use_yearmonth_folders','1','on');
INSERT INTO `wp_options` VALUES (49,'upload_path','','on');
INSERT INTO `wp_options` VALUES (50,'blog_public','1','on');
INSERT INTO `wp_options` VALUES (51,'default_link_category','2','on');
INSERT INTO `wp_options` VALUES (52,'show_on_front','page','on');
INSERT INTO `wp_options` VALUES (53,'tag_base','','on');
INSERT INTO `wp_options` VALUES (54,'show_avatars','1','on');
INSERT INTO `wp_options` VALUES (55,'avatar_rating','G','on');
INSERT INTO `wp_options` VALUES (56,'upload_url_path','','on');
INSERT INTO `wp_options` VALUES (57,'thumbnail_size_w','150','on');
INSERT INTO `wp_options` VALUES (58,'thumbnail_size_h','150','on');
INSERT INTO `wp_options` VALUES (59,'thumbnail_crop','1','on');
INSERT INTO `wp_options` VALUES (60,'medium_size_w','300','on');
INSERT INTO `wp_options` VALUES (61,'medium_size_h','300','on');
INSERT INTO `wp_options` VALUES (62,'avatar_default','mystery','on');
INSERT INTO `wp_options` VALUES (63,'large_size_w','1024','on');
INSERT INTO `wp_options` VALUES (64,'large_size_h','1024','on');
INSERT INTO `wp_options` VALUES (65,'image_default_link_type','none','on');
INSERT INTO `wp_options` VALUES (66,'image_default_size','','on');
INSERT INTO `wp_options` VALUES (67,'image_default_align','','on');
INSERT INTO `wp_options` VALUES (68,'close_comments_for_old_posts','0','on');
INSERT INTO `wp_options` VALUES (69,'close_comments_days_old','14','on');
INSERT INTO `wp_options` VALUES (70,'thread_comments','1','on');
INSERT INTO `wp_options` VALUES (71,'thread_comments_depth','5','on');
INSERT INTO `wp_options` VALUES (72,'page_comments','0','on');
INSERT INTO `wp_options` VALUES (73,'comments_per_page','50','on');
INSERT INTO `wp_options` VALUES (74,'default_comments_page','newest','on');
INSERT INTO `wp_options` VALUES (75,'comment_order','asc','on');
INSERT INTO `wp_options` VALUES (76,'sticky_posts','a:0:{}','on');
INSERT INTO `wp_options` VALUES (77,'widget_categories','a:0:{}','on');
INSERT INTO `wp_options` VALUES (78,'widget_text','a:0:{}','on');
INSERT INTO `wp_options` VALUES (79,'widget_rss','a:0:{}','on');
INSERT INTO `wp_options` VALUES (80,'uninstall_plugins','a:1:{s:24:\"wordpress-seo/wp-seo.php\";s:14:\"__return_false\";}','off');
INSERT INTO `wp_options` VALUES (81,'timezone_string','','on');
INSERT INTO `wp_options` VALUES (82,'page_for_posts','0','on');
INSERT INTO `wp_options` VALUES (83,'page_on_front','4','on');
INSERT INTO `wp_options` VALUES (84,'default_post_format','0','on');
INSERT INTO `wp_options` VALUES (85,'link_manager_enabled','0','on');
INSERT INTO `wp_options` VALUES (86,'finished_splitting_shared_terms','1','on');
INSERT INTO `wp_options` VALUES (87,'site_icon','0','on');
INSERT INTO `wp_options` VALUES (88,'medium_large_size_w','768','on');
INSERT INTO `wp_options` VALUES (89,'medium_large_size_h','0','on');
INSERT INTO `wp_options` VALUES (90,'wp_page_for_privacy_policy','3','on');
INSERT INTO `wp_options` VALUES (91,'show_comments_cookies_opt_in','1','on');
INSERT INTO `wp_options` VALUES (92,'admin_email_lifespan','1794774535','on');
INSERT INTO `wp_options` VALUES (93,'disallowed_keys','','off');
INSERT INTO `wp_options` VALUES (94,'comment_previously_approved','1','on');
INSERT INTO `wp_options` VALUES (95,'auto_plugin_theme_update_emails','a:0:{}','off');
INSERT INTO `wp_options` VALUES (96,'auto_update_core_dev','enabled','on');
INSERT INTO `wp_options` VALUES (97,'auto_update_core_minor','enabled','on');
INSERT INTO `wp_options` VALUES (98,'auto_update_core_major','enabled','on');
INSERT INTO `wp_options` VALUES (99,'wp_force_deactivated_plugins','a:0:{}','on');
INSERT INTO `wp_options` VALUES (100,'wp_attachment_pages_enabled','0','on');
INSERT INTO `wp_options` VALUES (101,'wp_notes_notify','1','on');
INSERT INTO `wp_options` VALUES (102,'initial_db_version','60717','on');
INSERT INTO `wp_options` VALUES (103,'wp_user_roles','a:7:{s:13:\"administrator\";a:2:{s:4:\"name\";s:13:\"Administrator\";s:12:\"capabilities\";a:62:{s:13:\"switch_themes\";b:1;s:11:\"edit_themes\";b:1;s:16:\"activate_plugins\";b:1;s:12:\"edit_plugins\";b:1;s:10:\"edit_users\";b:1;s:10:\"edit_files\";b:1;s:14:\"manage_options\";b:1;s:17:\"moderate_comments\";b:1;s:17:\"manage_categories\";b:1;s:12:\"manage_links\";b:1;s:12:\"upload_files\";b:1;s:6:\"import\";b:1;s:15:\"unfiltered_html\";b:1;s:10:\"edit_posts\";b:1;s:17:\"edit_others_posts\";b:1;s:20:\"edit_published_posts\";b:1;s:13:\"publish_posts\";b:1;s:10:\"edit_pages\";b:1;s:4:\"read\";b:1;s:8:\"level_10\";b:1;s:7:\"level_9\";b:1;s:7:\"level_8\";b:1;s:7:\"level_7\";b:1;s:7:\"level_6\";b:1;s:7:\"level_5\";b:1;s:7:\"level_4\";b:1;s:7:\"level_3\";b:1;s:7:\"level_2\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:17:\"edit_others_pages\";b:1;s:20:\"edit_published_pages\";b:1;s:13:\"publish_pages\";b:1;s:12:\"delete_pages\";b:1;s:19:\"delete_others_pages\";b:1;s:22:\"delete_published_pages\";b:1;s:12:\"delete_posts\";b:1;s:19:\"delete_others_posts\";b:1;s:22:\"delete_published_posts\";b:1;s:20:\"delete_private_posts\";b:1;s:18:\"edit_private_posts\";b:1;s:18:\"read_private_posts\";b:1;s:20:\"delete_private_pages\";b:1;s:18:\"edit_private_pages\";b:1;s:18:\"read_private_pages\";b:1;s:12:\"delete_users\";b:1;s:12:\"create_users\";b:1;s:17:\"unfiltered_upload\";b:1;s:14:\"edit_dashboard\";b:1;s:14:\"update_plugins\";b:1;s:14:\"delete_plugins\";b:1;s:15:\"install_plugins\";b:1;s:13:\"update_themes\";b:1;s:14:\"install_themes\";b:1;s:11:\"update_core\";b:1;s:10:\"list_users\";b:1;s:12:\"remove_users\";b:1;s:13:\"promote_users\";b:1;s:18:\"edit_theme_options\";b:1;s:13:\"delete_themes\";b:1;s:6:\"export\";b:1;s:20:\"wpseo_manage_options\";b:1;}}s:6:\"editor\";a:2:{s:4:\"name\";s:6:\"Editor\";s:12:\"capabilities\";a:36:{s:17:\"moderate_comments\";b:1;s:17:\"manage_categories\";b:1;s:12:\"manage_links\";b:1;s:12:\"upload_files\";b:1;s:15:\"unfiltered_html\";b:1;s:10:\"edit_posts\";b:1;s:17:\"edit_others_posts\";b:1;s:20:\"edit_published_posts\";b:1;s:13:\"publish_posts\";b:1;s:10:\"edit_pages\";b:1;s:4:\"read\";b:1;s:7:\"level_7\";b:1;s:7:\"level_6\";b:1;s:7:\"level_5\";b:1;s:7:\"level_4\";b:1;s:7:\"level_3\";b:1;s:7:\"level_2\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:17:\"edit_others_pages\";b:1;s:20:\"edit_published_pages\";b:1;s:13:\"publish_pages\";b:1;s:12:\"delete_pages\";b:1;s:19:\"delete_others_pages\";b:1;s:22:\"delete_published_pages\";b:1;s:12:\"delete_posts\";b:1;s:19:\"delete_others_posts\";b:1;s:22:\"delete_published_posts\";b:1;s:20:\"delete_private_posts\";b:1;s:18:\"edit_private_posts\";b:1;s:18:\"read_private_posts\";b:1;s:20:\"delete_private_pages\";b:1;s:18:\"edit_private_pages\";b:1;s:18:\"read_private_pages\";b:1;s:15:\"wpseo_bulk_edit\";b:1;s:28:\"wpseo_edit_advanced_metadata\";b:1;}}s:6:\"author\";a:2:{s:4:\"name\";s:6:\"Author\";s:12:\"capabilities\";a:10:{s:12:\"upload_files\";b:1;s:10:\"edit_posts\";b:1;s:20:\"edit_published_posts\";b:1;s:13:\"publish_posts\";b:1;s:4:\"read\";b:1;s:7:\"level_2\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:12:\"delete_posts\";b:1;s:22:\"delete_published_posts\";b:1;}}s:11:\"contributor\";a:2:{s:4:\"name\";s:11:\"Contributor\";s:12:\"capabilities\";a:5:{s:10:\"edit_posts\";b:1;s:4:\"read\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:12:\"delete_posts\";b:1;}}s:10:\"subscriber\";a:2:{s:4:\"name\";s:10:\"Subscriber\";s:12:\"capabilities\";a:2:{s:4:\"read\";b:1;s:7:\"level_0\";b:1;}}s:13:\"wpseo_manager\";a:2:{s:4:\"name\";s:11:\"SEO Manager\";s:12:\"capabilities\";a:38:{s:17:\"moderate_comments\";b:1;s:17:\"manage_categories\";b:1;s:12:\"manage_links\";b:1;s:12:\"upload_files\";b:1;s:15:\"unfiltered_html\";b:1;s:10:\"edit_posts\";b:1;s:17:\"edit_others_posts\";b:1;s:20:\"edit_published_posts\";b:1;s:13:\"publish_posts\";b:1;s:10:\"edit_pages\";b:1;s:4:\"read\";b:1;s:7:\"level_7\";b:1;s:7:\"level_6\";b:1;s:7:\"level_5\";b:1;s:7:\"level_4\";b:1;s:7:\"level_3\";b:1;s:7:\"level_2\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:17:\"edit_others_pages\";b:1;s:20:\"edit_published_pages\";b:1;s:13:\"publish_pages\";b:1;s:12:\"delete_pages\";b:1;s:19:\"delete_others_pages\";b:1;s:22:\"delete_published_pages\";b:1;s:12:\"delete_posts\";b:1;s:19:\"delete_others_posts\";b:1;s:22:\"delete_published_posts\";b:1;s:20:\"delete_private_posts\";b:1;s:18:\"edit_private_posts\";b:1;s:18:\"read_private_posts\";b:1;s:20:\"delete_private_pages\";b:1;s:18:\"edit_private_pages\";b:1;s:18:\"read_private_pages\";b:1;s:15:\"wpseo_bulk_edit\";b:1;s:28:\"wpseo_edit_advanced_metadata\";b:1;s:20:\"wpseo_manage_options\";b:1;s:23:\"view_site_health_checks\";b:1;}}s:12:\"wpseo_editor\";a:2:{s:4:\"name\";s:10:\"SEO Editor\";s:12:\"capabilities\";a:36:{s:17:\"moderate_comments\";b:1;s:17:\"manage_categories\";b:1;s:12:\"manage_links\";b:1;s:12:\"upload_files\";b:1;s:15:\"unfiltered_html\";b:1;s:10:\"edit_posts\";b:1;s:17:\"edit_others_posts\";b:1;s:20:\"edit_published_posts\";b:1;s:13:\"publish_posts\";b:1;s:10:\"edit_pages\";b:1;s:4:\"read\";b:1;s:7:\"level_7\";b:1;s:7:\"level_6\";b:1;s:7:\"level_5\";b:1;s:7:\"level_4\";b:1;s:7:\"level_3\";b:1;s:7:\"level_2\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:17:\"edit_others_pages\";b:1;s:20:\"edit_published_pages\";b:1;s:13:\"publish_pages\";b:1;s:12:\"delete_pages\";b:1;s:19:\"delete_others_pages\";b:1;s:22:\"delete_published_pages\";b:1;s:12:\"delete_posts\";b:1;s:19:\"delete_others_posts\";b:1;s:22:\"delete_published_posts\";b:1;s:20:\"delete_private_posts\";b:1;s:18:\"edit_private_posts\";b:1;s:18:\"read_private_posts\";b:1;s:20:\"delete_private_pages\";b:1;s:18:\"edit_private_pages\";b:1;s:18:\"read_private_pages\";b:1;s:15:\"wpseo_bulk_edit\";b:1;s:28:\"wpseo_edit_advanced_metadata\";b:1;}}}','on');
INSERT INTO `wp_options` VALUES (104,'fresh_site','0','off');
INSERT INTO `wp_options` VALUES (105,'user_count','9','off');
INSERT INTO `wp_options` VALUES (106,'widget_block','a:6:{i:2;a:1:{s:7:\"content\";s:19:\"<!-- wp:search /-->\";}i:3;a:1:{s:7:\"content\";s:154:\"<!-- wp:group --><div class=\"wp-block-group\"><!-- wp:heading --><h2>Recent Posts</h2><!-- /wp:heading --><!-- wp:latest-posts /--></div><!-- /wp:group -->\";}i:4;a:1:{s:7:\"content\";s:227:\"<!-- wp:group --><div class=\"wp-block-group\"><!-- wp:heading --><h2>Recent Comments</h2><!-- /wp:heading --><!-- wp:latest-comments {\"displayAvatar\":false,\"displayDate\":false,\"displayExcerpt\":false} /--></div><!-- /wp:group -->\";}i:5;a:1:{s:7:\"content\";s:146:\"<!-- wp:group --><div class=\"wp-block-group\"><!-- wp:heading --><h2>Archives</h2><!-- /wp:heading --><!-- wp:archives /--></div><!-- /wp:group -->\";}i:6;a:1:{s:7:\"content\";s:150:\"<!-- wp:group --><div class=\"wp-block-group\"><!-- wp:heading --><h2>Categories</h2><!-- /wp:heading --><!-- wp:categories /--></div><!-- /wp:group -->\";}s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (107,'sidebars_widgets','a:2:{s:19:\"wp_inactive_widgets\";a:5:{i:0;s:7:\"block-2\";i:1;s:7:\"block-3\";i:2;s:7:\"block-4\";i:3;s:7:\"block-5\";i:4;s:7:\"block-6\";}s:13:\"array_version\";i:3;}','auto');
INSERT INTO `wp_options` VALUES (108,'widget_pages','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (109,'widget_calendar','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (110,'widget_archives','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (111,'widget_media_audio','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (112,'widget_media_image','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (113,'widget_media_gallery','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (114,'widget_media_video','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (115,'widget_meta','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (116,'widget_search','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (117,'widget_recent-posts','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (118,'widget_recent-comments','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (119,'widget_tag_cloud','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (120,'widget_nav_menu','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (121,'widget_custom_html','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (122,'_transient_wp_core_block_css_files','a:2:{s:7:\"version\";s:5:\"6.9.4\";s:5:\"files\";a:584:{i:0;s:31:\"accordion-heading/style-rtl.css\";i:1;s:35:\"accordion-heading/style-rtl.min.css\";i:2;s:27:\"accordion-heading/style.css\";i:3;s:31:\"accordion-heading/style.min.css\";i:4;s:28:\"accordion-item/style-rtl.css\";i:5;s:32:\"accordion-item/style-rtl.min.css\";i:6;s:24:\"accordion-item/style.css\";i:7;s:28:\"accordion-item/style.min.css\";i:8;s:29:\"accordion-panel/style-rtl.css\";i:9;s:33:\"accordion-panel/style-rtl.min.css\";i:10;s:25:\"accordion-panel/style.css\";i:11;s:29:\"accordion-panel/style.min.css\";i:12;s:23:\"accordion/style-rtl.css\";i:13;s:27:\"accordion/style-rtl.min.css\";i:14;s:19:\"accordion/style.css\";i:15;s:23:\"accordion/style.min.css\";i:16;s:23:\"archives/editor-rtl.css\";i:17;s:27:\"archives/editor-rtl.min.css\";i:18;s:19:\"archives/editor.css\";i:19;s:23:\"archives/editor.min.css\";i:20;s:22:\"archives/style-rtl.css\";i:21;s:26:\"archives/style-rtl.min.css\";i:22;s:18:\"archives/style.css\";i:23;s:22:\"archives/style.min.css\";i:24;s:20:\"audio/editor-rtl.css\";i:25;s:24:\"audio/editor-rtl.min.css\";i:26;s:16:\"audio/editor.css\";i:27;s:20:\"audio/editor.min.css\";i:28;s:19:\"audio/style-rtl.css\";i:29;s:23:\"audio/style-rtl.min.css\";i:30;s:15:\"audio/style.css\";i:31;s:19:\"audio/style.min.css\";i:32;s:19:\"audio/theme-rtl.css\";i:33;s:23:\"audio/theme-rtl.min.css\";i:34;s:15:\"audio/theme.css\";i:35;s:19:\"audio/theme.min.css\";i:36;s:21:\"avatar/editor-rtl.css\";i:37;s:25:\"avatar/editor-rtl.min.css\";i:38;s:17:\"avatar/editor.css\";i:39;s:21:\"avatar/editor.min.css\";i:40;s:20:\"avatar/style-rtl.css\";i:41;s:24:\"avatar/style-rtl.min.css\";i:42;s:16:\"avatar/style.css\";i:43;s:20:\"avatar/style.min.css\";i:44;s:21:\"button/editor-rtl.css\";i:45;s:25:\"button/editor-rtl.min.css\";i:46;s:17:\"button/editor.css\";i:47;s:21:\"button/editor.min.css\";i:48;s:20:\"button/style-rtl.css\";i:49;s:24:\"button/style-rtl.min.css\";i:50;s:16:\"button/style.css\";i:51;s:20:\"button/style.min.css\";i:52;s:22:\"buttons/editor-rtl.css\";i:53;s:26:\"buttons/editor-rtl.min.css\";i:54;s:18:\"buttons/editor.css\";i:55;s:22:\"buttons/editor.min.css\";i:56;s:21:\"buttons/style-rtl.css\";i:57;s:25:\"buttons/style-rtl.min.css\";i:58;s:17:\"buttons/style.css\";i:59;s:21:\"buttons/style.min.css\";i:60;s:22:\"calendar/style-rtl.css\";i:61;s:26:\"calendar/style-rtl.min.css\";i:62;s:18:\"calendar/style.css\";i:63;s:22:\"calendar/style.min.css\";i:64;s:25:\"categories/editor-rtl.css\";i:65;s:29:\"categories/editor-rtl.min.css\";i:66;s:21:\"categories/editor.css\";i:67;s:25:\"categories/editor.min.css\";i:68;s:24:\"categories/style-rtl.css\";i:69;s:28:\"categories/style-rtl.min.css\";i:70;s:20:\"categories/style.css\";i:71;s:24:\"categories/style.min.css\";i:72;s:19:\"code/editor-rtl.css\";i:73;s:23:\"code/editor-rtl.min.css\";i:74;s:15:\"code/editor.css\";i:75;s:19:\"code/editor.min.css\";i:76;s:18:\"code/style-rtl.css\";i:77;s:22:\"code/style-rtl.min.css\";i:78;s:14:\"code/style.css\";i:79;s:18:\"code/style.min.css\";i:80;s:18:\"code/theme-rtl.css\";i:81;s:22:\"code/theme-rtl.min.css\";i:82;s:14:\"code/theme.css\";i:83;s:18:\"code/theme.min.css\";i:84;s:22:\"columns/editor-rtl.css\";i:85;s:26:\"columns/editor-rtl.min.css\";i:86;s:18:\"columns/editor.css\";i:87;s:22:\"columns/editor.min.css\";i:88;s:21:\"columns/style-rtl.css\";i:89;s:25:\"columns/style-rtl.min.css\";i:90;s:17:\"columns/style.css\";i:91;s:21:\"columns/style.min.css\";i:92;s:33:\"comment-author-name/style-rtl.css\";i:93;s:37:\"comment-author-name/style-rtl.min.css\";i:94;s:29:\"comment-author-name/style.css\";i:95;s:33:\"comment-author-name/style.min.css\";i:96;s:29:\"comment-content/style-rtl.css\";i:97;s:33:\"comment-content/style-rtl.min.css\";i:98;s:25:\"comment-content/style.css\";i:99;s:29:\"comment-content/style.min.css\";i:100;s:26:\"comment-date/style-rtl.css\";i:101;s:30:\"comment-date/style-rtl.min.css\";i:102;s:22:\"comment-date/style.css\";i:103;s:26:\"comment-date/style.min.css\";i:104;s:31:\"comment-edit-link/style-rtl.css\";i:105;s:35:\"comment-edit-link/style-rtl.min.css\";i:106;s:27:\"comment-edit-link/style.css\";i:107;s:31:\"comment-edit-link/style.min.css\";i:108;s:32:\"comment-reply-link/style-rtl.css\";i:109;s:36:\"comment-reply-link/style-rtl.min.css\";i:110;s:28:\"comment-reply-link/style.css\";i:111;s:32:\"comment-reply-link/style.min.css\";i:112;s:30:\"comment-template/style-rtl.css\";i:113;s:34:\"comment-template/style-rtl.min.css\";i:114;s:26:\"comment-template/style.css\";i:115;s:30:\"comment-template/style.min.css\";i:116;s:42:\"comments-pagination-numbers/editor-rtl.css\";i:117;s:46:\"comments-pagination-numbers/editor-rtl.min.css\";i:118;s:38:\"comments-pagination-numbers/editor.css\";i:119;s:42:\"comments-pagination-numbers/editor.min.css\";i:120;s:34:\"comments-pagination/editor-rtl.css\";i:121;s:38:\"comments-pagination/editor-rtl.min.css\";i:122;s:30:\"comments-pagination/editor.css\";i:123;s:34:\"comments-pagination/editor.min.css\";i:124;s:33:\"comments-pagination/style-rtl.css\";i:125;s:37:\"comments-pagination/style-rtl.min.css\";i:126;s:29:\"comments-pagination/style.css\";i:127;s:33:\"comments-pagination/style.min.css\";i:128;s:29:\"comments-title/editor-rtl.css\";i:129;s:33:\"comments-title/editor-rtl.min.css\";i:130;s:25:\"comments-title/editor.css\";i:131;s:29:\"comments-title/editor.min.css\";i:132;s:23:\"comments/editor-rtl.css\";i:133;s:27:\"comments/editor-rtl.min.css\";i:134;s:19:\"comments/editor.css\";i:135;s:23:\"comments/editor.min.css\";i:136;s:22:\"comments/style-rtl.css\";i:137;s:26:\"comments/style-rtl.min.css\";i:138;s:18:\"comments/style.css\";i:139;s:22:\"comments/style.min.css\";i:140;s:20:\"cover/editor-rtl.css\";i:141;s:24:\"cover/editor-rtl.min.css\";i:142;s:16:\"cover/editor.css\";i:143;s:20:\"cover/editor.min.css\";i:144;s:19:\"cover/style-rtl.css\";i:145;s:23:\"cover/style-rtl.min.css\";i:146;s:15:\"cover/style.css\";i:147;s:19:\"cover/style.min.css\";i:148;s:22:\"details/editor-rtl.css\";i:149;s:26:\"details/editor-rtl.min.css\";i:150;s:18:\"details/editor.css\";i:151;s:22:\"details/editor.min.css\";i:152;s:21:\"details/style-rtl.css\";i:153;s:25:\"details/style-rtl.min.css\";i:154;s:17:\"details/style.css\";i:155;s:21:\"details/style.min.css\";i:156;s:20:\"embed/editor-rtl.css\";i:157;s:24:\"embed/editor-rtl.min.css\";i:158;s:16:\"embed/editor.css\";i:159;s:20:\"embed/editor.min.css\";i:160;s:19:\"embed/style-rtl.css\";i:161;s:23:\"embed/style-rtl.min.css\";i:162;s:15:\"embed/style.css\";i:163;s:19:\"embed/style.min.css\";i:164;s:19:\"embed/theme-rtl.css\";i:165;s:23:\"embed/theme-rtl.min.css\";i:166;s:15:\"embed/theme.css\";i:167;s:19:\"embed/theme.min.css\";i:168;s:19:\"file/editor-rtl.css\";i:169;s:23:\"file/editor-rtl.min.css\";i:170;s:15:\"file/editor.css\";i:171;s:19:\"file/editor.min.css\";i:172;s:18:\"file/style-rtl.css\";i:173;s:22:\"file/style-rtl.min.css\";i:174;s:14:\"file/style.css\";i:175;s:18:\"file/style.min.css\";i:176;s:23:\"footnotes/style-rtl.css\";i:177;s:27:\"footnotes/style-rtl.min.css\";i:178;s:19:\"footnotes/style.css\";i:179;s:23:\"footnotes/style.min.css\";i:180;s:23:\"freeform/editor-rtl.css\";i:181;s:27:\"freeform/editor-rtl.min.css\";i:182;s:19:\"freeform/editor.css\";i:183;s:23:\"freeform/editor.min.css\";i:184;s:22:\"gallery/editor-rtl.css\";i:185;s:26:\"gallery/editor-rtl.min.css\";i:186;s:18:\"gallery/editor.css\";i:187;s:22:\"gallery/editor.min.css\";i:188;s:21:\"gallery/style-rtl.css\";i:189;s:25:\"gallery/style-rtl.min.css\";i:190;s:17:\"gallery/style.css\";i:191;s:21:\"gallery/style.min.css\";i:192;s:21:\"gallery/theme-rtl.css\";i:193;s:25:\"gallery/theme-rtl.min.css\";i:194;s:17:\"gallery/theme.css\";i:195;s:21:\"gallery/theme.min.css\";i:196;s:20:\"group/editor-rtl.css\";i:197;s:24:\"group/editor-rtl.min.css\";i:198;s:16:\"group/editor.css\";i:199;s:20:\"group/editor.min.css\";i:200;s:19:\"group/style-rtl.css\";i:201;s:23:\"group/style-rtl.min.css\";i:202;s:15:\"group/style.css\";i:203;s:19:\"group/style.min.css\";i:204;s:19:\"group/theme-rtl.css\";i:205;s:23:\"group/theme-rtl.min.css\";i:206;s:15:\"group/theme.css\";i:207;s:19:\"group/theme.min.css\";i:208;s:21:\"heading/style-rtl.css\";i:209;s:25:\"heading/style-rtl.min.css\";i:210;s:17:\"heading/style.css\";i:211;s:21:\"heading/style.min.css\";i:212;s:19:\"html/editor-rtl.css\";i:213;s:23:\"html/editor-rtl.min.css\";i:214;s:15:\"html/editor.css\";i:215;s:19:\"html/editor.min.css\";i:216;s:20:\"image/editor-rtl.css\";i:217;s:24:\"image/editor-rtl.min.css\";i:218;s:16:\"image/editor.css\";i:219;s:20:\"image/editor.min.css\";i:220;s:19:\"image/style-rtl.css\";i:221;s:23:\"image/style-rtl.min.css\";i:222;s:15:\"image/style.css\";i:223;s:19:\"image/style.min.css\";i:224;s:19:\"image/theme-rtl.css\";i:225;s:23:\"image/theme-rtl.min.css\";i:226;s:15:\"image/theme.css\";i:227;s:19:\"image/theme.min.css\";i:228;s:29:\"latest-comments/style-rtl.css\";i:229;s:33:\"latest-comments/style-rtl.min.css\";i:230;s:25:\"latest-comments/style.css\";i:231;s:29:\"latest-comments/style.min.css\";i:232;s:27:\"latest-posts/editor-rtl.css\";i:233;s:31:\"latest-posts/editor-rtl.min.css\";i:234;s:23:\"latest-posts/editor.css\";i:235;s:27:\"latest-posts/editor.min.css\";i:236;s:26:\"latest-posts/style-rtl.css\";i:237;s:30:\"latest-posts/style-rtl.min.css\";i:238;s:22:\"latest-posts/style.css\";i:239;s:26:\"latest-posts/style.min.css\";i:240;s:18:\"list/style-rtl.css\";i:241;s:22:\"list/style-rtl.min.css\";i:242;s:14:\"list/style.css\";i:243;s:18:\"list/style.min.css\";i:244;s:22:\"loginout/style-rtl.css\";i:245;s:26:\"loginout/style-rtl.min.css\";i:246;s:18:\"loginout/style.css\";i:247;s:22:\"loginout/style.min.css\";i:248;s:19:\"math/editor-rtl.css\";i:249;s:23:\"math/editor-rtl.min.css\";i:250;s:15:\"math/editor.css\";i:251;s:19:\"math/editor.min.css\";i:252;s:18:\"math/style-rtl.css\";i:253;s:22:\"math/style-rtl.min.css\";i:254;s:14:\"math/style.css\";i:255;s:18:\"math/style.min.css\";i:256;s:25:\"media-text/editor-rtl.css\";i:257;s:29:\"media-text/editor-rtl.min.css\";i:258;s:21:\"media-text/editor.css\";i:259;s:25:\"media-text/editor.min.css\";i:260;s:24:\"media-text/style-rtl.css\";i:261;s:28:\"media-text/style-rtl.min.css\";i:262;s:20:\"media-text/style.css\";i:263;s:24:\"media-text/style.min.css\";i:264;s:19:\"more/editor-rtl.css\";i:265;s:23:\"more/editor-rtl.min.css\";i:266;s:15:\"more/editor.css\";i:267;s:19:\"more/editor.min.css\";i:268;s:30:\"navigation-link/editor-rtl.css\";i:269;s:34:\"navigation-link/editor-rtl.min.css\";i:270;s:26:\"navigation-link/editor.css\";i:271;s:30:\"navigation-link/editor.min.css\";i:272;s:29:\"navigation-link/style-rtl.css\";i:273;s:33:\"navigation-link/style-rtl.min.css\";i:274;s:25:\"navigation-link/style.css\";i:275;s:29:\"navigation-link/style.min.css\";i:276;s:33:\"navigation-submenu/editor-rtl.css\";i:277;s:37:\"navigation-submenu/editor-rtl.min.css\";i:278;s:29:\"navigation-submenu/editor.css\";i:279;s:33:\"navigation-submenu/editor.min.css\";i:280;s:25:\"navigation/editor-rtl.css\";i:281;s:29:\"navigation/editor-rtl.min.css\";i:282;s:21:\"navigation/editor.css\";i:283;s:25:\"navigation/editor.min.css\";i:284;s:24:\"navigation/style-rtl.css\";i:285;s:28:\"navigation/style-rtl.min.css\";i:286;s:20:\"navigation/style.css\";i:287;s:24:\"navigation/style.min.css\";i:288;s:23:\"nextpage/editor-rtl.css\";i:289;s:27:\"nextpage/editor-rtl.min.css\";i:290;s:19:\"nextpage/editor.css\";i:291;s:23:\"nextpage/editor.min.css\";i:292;s:24:\"page-list/editor-rtl.css\";i:293;s:28:\"page-list/editor-rtl.min.css\";i:294;s:20:\"page-list/editor.css\";i:295;s:24:\"page-list/editor.min.css\";i:296;s:23:\"page-list/style-rtl.css\";i:297;s:27:\"page-list/style-rtl.min.css\";i:298;s:19:\"page-list/style.css\";i:299;s:23:\"page-list/style.min.css\";i:300;s:24:\"paragraph/editor-rtl.css\";i:301;s:28:\"paragraph/editor-rtl.min.css\";i:302;s:20:\"paragraph/editor.css\";i:303;s:24:\"paragraph/editor.min.css\";i:304;s:23:\"paragraph/style-rtl.css\";i:305;s:27:\"paragraph/style-rtl.min.css\";i:306;s:19:\"paragraph/style.css\";i:307;s:23:\"paragraph/style.min.css\";i:308;s:35:\"post-author-biography/style-rtl.css\";i:309;s:39:\"post-author-biography/style-rtl.min.css\";i:310;s:31:\"post-author-biography/style.css\";i:311;s:35:\"post-author-biography/style.min.css\";i:312;s:30:\"post-author-name/style-rtl.css\";i:313;s:34:\"post-author-name/style-rtl.min.css\";i:314;s:26:\"post-author-name/style.css\";i:315;s:30:\"post-author-name/style.min.css\";i:316;s:25:\"post-author/style-rtl.css\";i:317;s:29:\"post-author/style-rtl.min.css\";i:318;s:21:\"post-author/style.css\";i:319;s:25:\"post-author/style.min.css\";i:320;s:33:\"post-comments-count/style-rtl.css\";i:321;s:37:\"post-comments-count/style-rtl.min.css\";i:322;s:29:\"post-comments-count/style.css\";i:323;s:33:\"post-comments-count/style.min.css\";i:324;s:33:\"post-comments-form/editor-rtl.css\";i:325;s:37:\"post-comments-form/editor-rtl.min.css\";i:326;s:29:\"post-comments-form/editor.css\";i:327;s:33:\"post-comments-form/editor.min.css\";i:328;s:32:\"post-comments-form/style-rtl.css\";i:329;s:36:\"post-comments-form/style-rtl.min.css\";i:330;s:28:\"post-comments-form/style.css\";i:331;s:32:\"post-comments-form/style.min.css\";i:332;s:32:\"post-comments-link/style-rtl.css\";i:333;s:36:\"post-comments-link/style-rtl.min.css\";i:334;s:28:\"post-comments-link/style.css\";i:335;s:32:\"post-comments-link/style.min.css\";i:336;s:26:\"post-content/style-rtl.css\";i:337;s:30:\"post-content/style-rtl.min.css\";i:338;s:22:\"post-content/style.css\";i:339;s:26:\"post-content/style.min.css\";i:340;s:23:\"post-date/style-rtl.css\";i:341;s:27:\"post-date/style-rtl.min.css\";i:342;s:19:\"post-date/style.css\";i:343;s:23:\"post-date/style.min.css\";i:344;s:27:\"post-excerpt/editor-rtl.css\";i:345;s:31:\"post-excerpt/editor-rtl.min.css\";i:346;s:23:\"post-excerpt/editor.css\";i:347;s:27:\"post-excerpt/editor.min.css\";i:348;s:26:\"post-excerpt/style-rtl.css\";i:349;s:30:\"post-excerpt/style-rtl.min.css\";i:350;s:22:\"post-excerpt/style.css\";i:351;s:26:\"post-excerpt/style.min.css\";i:352;s:34:\"post-featured-image/editor-rtl.css\";i:353;s:38:\"post-featured-image/editor-rtl.min.css\";i:354;s:30:\"post-featured-image/editor.css\";i:355;s:34:\"post-featured-image/editor.min.css\";i:356;s:33:\"post-featured-image/style-rtl.css\";i:357;s:37:\"post-featured-image/style-rtl.min.css\";i:358;s:29:\"post-featured-image/style.css\";i:359;s:33:\"post-featured-image/style.min.css\";i:360;s:34:\"post-navigation-link/style-rtl.css\";i:361;s:38:\"post-navigation-link/style-rtl.min.css\";i:362;s:30:\"post-navigation-link/style.css\";i:363;s:34:\"post-navigation-link/style.min.css\";i:364;s:27:\"post-template/style-rtl.css\";i:365;s:31:\"post-template/style-rtl.min.css\";i:366;s:23:\"post-template/style.css\";i:367;s:27:\"post-template/style.min.css\";i:368;s:24:\"post-terms/style-rtl.css\";i:369;s:28:\"post-terms/style-rtl.min.css\";i:370;s:20:\"post-terms/style.css\";i:371;s:24:\"post-terms/style.min.css\";i:372;s:31:\"post-time-to-read/style-rtl.css\";i:373;s:35:\"post-time-to-read/style-rtl.min.css\";i:374;s:27:\"post-time-to-read/style.css\";i:375;s:31:\"post-time-to-read/style.min.css\";i:376;s:24:\"post-title/style-rtl.css\";i:377;s:28:\"post-title/style-rtl.min.css\";i:378;s:20:\"post-title/style.css\";i:379;s:24:\"post-title/style.min.css\";i:380;s:26:\"preformatted/style-rtl.css\";i:381;s:30:\"preformatted/style-rtl.min.css\";i:382;s:22:\"preformatted/style.css\";i:383;s:26:\"preformatted/style.min.css\";i:384;s:24:\"pullquote/editor-rtl.css\";i:385;s:28:\"pullquote/editor-rtl.min.css\";i:386;s:20:\"pullquote/editor.css\";i:387;s:24:\"pullquote/editor.min.css\";i:388;s:23:\"pullquote/style-rtl.css\";i:389;s:27:\"pullquote/style-rtl.min.css\";i:390;s:19:\"pullquote/style.css\";i:391;s:23:\"pullquote/style.min.css\";i:392;s:23:\"pullquote/theme-rtl.css\";i:393;s:27:\"pullquote/theme-rtl.min.css\";i:394;s:19:\"pullquote/theme.css\";i:395;s:23:\"pullquote/theme.min.css\";i:396;s:39:\"query-pagination-numbers/editor-rtl.css\";i:397;s:43:\"query-pagination-numbers/editor-rtl.min.css\";i:398;s:35:\"query-pagination-numbers/editor.css\";i:399;s:39:\"query-pagination-numbers/editor.min.css\";i:400;s:31:\"query-pagination/editor-rtl.css\";i:401;s:35:\"query-pagination/editor-rtl.min.css\";i:402;s:27:\"query-pagination/editor.css\";i:403;s:31:\"query-pagination/editor.min.css\";i:404;s:30:\"query-pagination/style-rtl.css\";i:405;s:34:\"query-pagination/style-rtl.min.css\";i:406;s:26:\"query-pagination/style.css\";i:407;s:30:\"query-pagination/style.min.css\";i:408;s:25:\"query-title/style-rtl.css\";i:409;s:29:\"query-title/style-rtl.min.css\";i:410;s:21:\"query-title/style.css\";i:411;s:25:\"query-title/style.min.css\";i:412;s:25:\"query-total/style-rtl.css\";i:413;s:29:\"query-total/style-rtl.min.css\";i:414;s:21:\"query-total/style.css\";i:415;s:25:\"query-total/style.min.css\";i:416;s:20:\"query/editor-rtl.css\";i:417;s:24:\"query/editor-rtl.min.css\";i:418;s:16:\"query/editor.css\";i:419;s:20:\"query/editor.min.css\";i:420;s:19:\"quote/style-rtl.css\";i:421;s:23:\"quote/style-rtl.min.css\";i:422;s:15:\"quote/style.css\";i:423;s:19:\"quote/style.min.css\";i:424;s:19:\"quote/theme-rtl.css\";i:425;s:23:\"quote/theme-rtl.min.css\";i:426;s:15:\"quote/theme.css\";i:427;s:19:\"quote/theme.min.css\";i:428;s:23:\"read-more/style-rtl.css\";i:429;s:27:\"read-more/style-rtl.min.css\";i:430;s:19:\"read-more/style.css\";i:431;s:23:\"read-more/style.min.css\";i:432;s:18:\"rss/editor-rtl.css\";i:433;s:22:\"rss/editor-rtl.min.css\";i:434;s:14:\"rss/editor.css\";i:435;s:18:\"rss/editor.min.css\";i:436;s:17:\"rss/style-rtl.css\";i:437;s:21:\"rss/style-rtl.min.css\";i:438;s:13:\"rss/style.css\";i:439;s:17:\"rss/style.min.css\";i:440;s:21:\"search/editor-rtl.css\";i:441;s:25:\"search/editor-rtl.min.css\";i:442;s:17:\"search/editor.css\";i:443;s:21:\"search/editor.min.css\";i:444;s:20:\"search/style-rtl.css\";i:445;s:24:\"search/style-rtl.min.css\";i:446;s:16:\"search/style.css\";i:447;s:20:\"search/style.min.css\";i:448;s:20:\"search/theme-rtl.css\";i:449;s:24:\"search/theme-rtl.min.css\";i:450;s:16:\"search/theme.css\";i:451;s:20:\"search/theme.min.css\";i:452;s:24:\"separator/editor-rtl.css\";i:453;s:28:\"separator/editor-rtl.min.css\";i:454;s:20:\"separator/editor.css\";i:455;s:24:\"separator/editor.min.css\";i:456;s:23:\"separator/style-rtl.css\";i:457;s:27:\"separator/style-rtl.min.css\";i:458;s:19:\"separator/style.css\";i:459;s:23:\"separator/style.min.css\";i:460;s:23:\"separator/theme-rtl.css\";i:461;s:27:\"separator/theme-rtl.min.css\";i:462;s:19:\"separator/theme.css\";i:463;s:23:\"separator/theme.min.css\";i:464;s:24:\"shortcode/editor-rtl.css\";i:465;s:28:\"shortcode/editor-rtl.min.css\";i:466;s:20:\"shortcode/editor.css\";i:467;s:24:\"shortcode/editor.min.css\";i:468;s:24:\"site-logo/editor-rtl.css\";i:469;s:28:\"site-logo/editor-rtl.min.css\";i:470;s:20:\"site-logo/editor.css\";i:471;s:24:\"site-logo/editor.min.css\";i:472;s:23:\"site-logo/style-rtl.css\";i:473;s:27:\"site-logo/style-rtl.min.css\";i:474;s:19:\"site-logo/style.css\";i:475;s:23:\"site-logo/style.min.css\";i:476;s:27:\"site-tagline/editor-rtl.css\";i:477;s:31:\"site-tagline/editor-rtl.min.css\";i:478;s:23:\"site-tagline/editor.css\";i:479;s:27:\"site-tagline/editor.min.css\";i:480;s:26:\"site-tagline/style-rtl.css\";i:481;s:30:\"site-tagline/style-rtl.min.css\";i:482;s:22:\"site-tagline/style.css\";i:483;s:26:\"site-tagline/style.min.css\";i:484;s:25:\"site-title/editor-rtl.css\";i:485;s:29:\"site-title/editor-rtl.min.css\";i:486;s:21:\"site-title/editor.css\";i:487;s:25:\"site-title/editor.min.css\";i:488;s:24:\"site-title/style-rtl.css\";i:489;s:28:\"site-title/style-rtl.min.css\";i:490;s:20:\"site-title/style.css\";i:491;s:24:\"site-title/style.min.css\";i:492;s:26:\"social-link/editor-rtl.css\";i:493;s:30:\"social-link/editor-rtl.min.css\";i:494;s:22:\"social-link/editor.css\";i:495;s:26:\"social-link/editor.min.css\";i:496;s:27:\"social-links/editor-rtl.css\";i:497;s:31:\"social-links/editor-rtl.min.css\";i:498;s:23:\"social-links/editor.css\";i:499;s:27:\"social-links/editor.min.css\";i:500;s:26:\"social-links/style-rtl.css\";i:501;s:30:\"social-links/style-rtl.min.css\";i:502;s:22:\"social-links/style.css\";i:503;s:26:\"social-links/style.min.css\";i:504;s:21:\"spacer/editor-rtl.css\";i:505;s:25:\"spacer/editor-rtl.min.css\";i:506;s:17:\"spacer/editor.css\";i:507;s:21:\"spacer/editor.min.css\";i:508;s:20:\"spacer/style-rtl.css\";i:509;s:24:\"spacer/style-rtl.min.css\";i:510;s:16:\"spacer/style.css\";i:511;s:20:\"spacer/style.min.css\";i:512;s:20:\"table/editor-rtl.css\";i:513;s:24:\"table/editor-rtl.min.css\";i:514;s:16:\"table/editor.css\";i:515;s:20:\"table/editor.min.css\";i:516;s:19:\"table/style-rtl.css\";i:517;s:23:\"table/style-rtl.min.css\";i:518;s:15:\"table/style.css\";i:519;s:19:\"table/style.min.css\";i:520;s:19:\"table/theme-rtl.css\";i:521;s:23:\"table/theme-rtl.min.css\";i:522;s:15:\"table/theme.css\";i:523;s:19:\"table/theme.min.css\";i:524;s:24:\"tag-cloud/editor-rtl.css\";i:525;s:28:\"tag-cloud/editor-rtl.min.css\";i:526;s:20:\"tag-cloud/editor.css\";i:527;s:24:\"tag-cloud/editor.min.css\";i:528;s:23:\"tag-cloud/style-rtl.css\";i:529;s:27:\"tag-cloud/style-rtl.min.css\";i:530;s:19:\"tag-cloud/style.css\";i:531;s:23:\"tag-cloud/style.min.css\";i:532;s:28:\"template-part/editor-rtl.css\";i:533;s:32:\"template-part/editor-rtl.min.css\";i:534;s:24:\"template-part/editor.css\";i:535;s:28:\"template-part/editor.min.css\";i:536;s:27:\"template-part/theme-rtl.css\";i:537;s:31:\"template-part/theme-rtl.min.css\";i:538;s:23:\"template-part/theme.css\";i:539;s:27:\"template-part/theme.min.css\";i:540;s:24:\"term-count/style-rtl.css\";i:541;s:28:\"term-count/style-rtl.min.css\";i:542;s:20:\"term-count/style.css\";i:543;s:24:\"term-count/style.min.css\";i:544;s:30:\"term-description/style-rtl.css\";i:545;s:34:\"term-description/style-rtl.min.css\";i:546;s:26:\"term-description/style.css\";i:547;s:30:\"term-description/style.min.css\";i:548;s:23:\"term-name/style-rtl.css\";i:549;s:27:\"term-name/style-rtl.min.css\";i:550;s:19:\"term-name/style.css\";i:551;s:23:\"term-name/style.min.css\";i:552;s:28:\"term-template/editor-rtl.css\";i:553;s:32:\"term-template/editor-rtl.min.css\";i:554;s:24:\"term-template/editor.css\";i:555;s:28:\"term-template/editor.min.css\";i:556;s:27:\"term-template/style-rtl.css\";i:557;s:31:\"term-template/style-rtl.min.css\";i:558;s:23:\"term-template/style.css\";i:559;s:27:\"term-template/style.min.css\";i:560;s:27:\"text-columns/editor-rtl.css\";i:561;s:31:\"text-columns/editor-rtl.min.css\";i:562;s:23:\"text-columns/editor.css\";i:563;s:27:\"text-columns/editor.min.css\";i:564;s:26:\"text-columns/style-rtl.css\";i:565;s:30:\"text-columns/style-rtl.min.css\";i:566;s:22:\"text-columns/style.css\";i:567;s:26:\"text-columns/style.min.css\";i:568;s:19:\"verse/style-rtl.css\";i:569;s:23:\"verse/style-rtl.min.css\";i:570;s:15:\"verse/style.css\";i:571;s:19:\"verse/style.min.css\";i:572;s:20:\"video/editor-rtl.css\";i:573;s:24:\"video/editor-rtl.min.css\";i:574;s:16:\"video/editor.css\";i:575;s:20:\"video/editor.min.css\";i:576;s:19:\"video/style-rtl.css\";i:577;s:23:\"video/style-rtl.min.css\";i:578;s:15:\"video/style.css\";i:579;s:19:\"video/style.min.css\";i:580;s:19:\"video/theme-rtl.css\";i:581;s:23:\"video/theme-rtl.min.css\";i:582;s:15:\"video/theme.css\";i:583;s:19:\"video/theme.min.css\";}}','on');
INSERT INTO `wp_options` VALUES (125,'_transient_doing_cron','1779222661.6901481151580810546875','on');
INSERT INTO `wp_options` VALUES (126,'acf_first_activated_version','6.8.1','on');
INSERT INTO `wp_options` VALUES (127,'acf_site_health','{\"event_first_activated\":1779222535,\"last_updated\":1779222535}','off');
INSERT INTO `wp_options` VALUES (128,'yoast_migrations_free','a:1:{s:7:\"version\";s:4:\"27.6\";}','auto');
INSERT INTO `wp_options` VALUES (129,'wpseo','a:124:{s:8:\"tracking\";b:0;s:16:\"toggled_tracking\";b:0;s:22:\"license_server_version\";b:0;s:15:\"ms_defaults_set\";b:0;s:40:\"ignore_search_engines_discouraged_notice\";b:0;s:19:\"indexing_first_time\";b:1;s:16:\"indexing_started\";b:0;s:15:\"indexing_reason\";s:13:\"first_install\";s:29:\"indexables_indexing_completed\";b:0;s:13:\"index_now_key\";s:0:\"\";s:7:\"version\";s:4:\"27.6\";s:16:\"previous_version\";s:0:\"\";s:20:\"disableadvanced_meta\";b:1;s:30:\"enable_headless_rest_endpoints\";b:1;s:17:\"ryte_indexability\";b:0;s:11:\"baiduverify\";s:0:\"\";s:12:\"googleverify\";s:0:\"\";s:8:\"msverify\";s:0:\"\";s:12:\"yandexverify\";s:0:\"\";s:12:\"ahrefsverify\";s:0:\"\";s:9:\"site_type\";s:0:\"\";s:20:\"has_multiple_authors\";s:0:\"\";s:16:\"environment_type\";s:0:\"\";s:23:\"content_analysis_active\";b:1;s:23:\"keyword_analysis_active\";b:1;s:34:\"inclusive_language_analysis_active\";b:0;s:21:\"enable_admin_bar_menu\";b:1;s:26:\"enable_cornerstone_content\";b:1;s:18:\"enable_xml_sitemap\";b:1;s:24:\"enable_text_link_counter\";b:1;s:16:\"enable_index_now\";b:1;s:19:\"enable_ai_generator\";b:1;s:22:\"ai_enabled_pre_default\";b:0;s:22:\"show_onboarding_notice\";b:1;s:18:\"first_activated_on\";i:1779222536;s:13:\"myyoast-oauth\";b:0;s:26:\"semrush_integration_active\";b:1;s:14:\"semrush_tokens\";a:0:{}s:20:\"semrush_country_code\";s:2:\"us\";s:19:\"permalink_structure\";s:0:\"\";s:8:\"home_url\";s:0:\"\";s:18:\"dynamic_permalinks\";b:0;s:17:\"category_base_url\";s:0:\"\";s:12:\"tag_base_url\";s:0:\"\";s:21:\"custom_taxonomy_slugs\";a:0:{}s:29:\"enable_enhanced_slack_sharing\";b:1;s:23:\"enable_metabox_insights\";b:1;s:23:\"enable_link_suggestions\";b:1;s:26:\"algolia_integration_active\";b:0;s:14:\"import_cursors\";a:0:{}s:13:\"workouts_data\";a:1:{s:13:\"configuration\";a:1:{s:13:\"finishedSteps\";a:0:{}}}s:28:\"configuration_finished_steps\";a:0:{}s:36:\"dismiss_configuration_workout_notice\";b:0;s:34:\"dismiss_premium_deactivated_notice\";b:0;s:19:\"importing_completed\";a:0:{}s:26:\"wincher_integration_active\";b:1;s:14:\"wincher_tokens\";a:0:{}s:36:\"wincher_automatically_add_keyphrases\";b:0;s:18:\"wincher_website_id\";s:0:\"\";s:18:\"first_time_install\";b:1;s:34:\"should_redirect_after_install_free\";b:0;s:34:\"activation_redirect_timestamp_free\";i:1779222536;s:18:\"remove_feed_global\";b:0;s:27:\"remove_feed_global_comments\";b:0;s:25:\"remove_feed_post_comments\";b:0;s:19:\"remove_feed_authors\";b:0;s:22:\"remove_feed_categories\";b:0;s:16:\"remove_feed_tags\";b:0;s:29:\"remove_feed_custom_taxonomies\";b:0;s:22:\"remove_feed_post_types\";b:0;s:18:\"remove_feed_search\";b:0;s:21:\"remove_atom_rdf_feeds\";b:0;s:17:\"remove_shortlinks\";b:0;s:21:\"remove_rest_api_links\";b:0;s:20:\"remove_rsd_wlw_links\";b:0;s:19:\"remove_oembed_links\";b:0;s:16:\"remove_generator\";b:0;s:20:\"remove_emoji_scripts\";b:0;s:24:\"remove_powered_by_header\";b:0;s:22:\"remove_pingback_header\";b:0;s:28:\"clean_campaign_tracking_urls\";b:0;s:16:\"clean_permalinks\";b:0;s:32:\"clean_permalinks_extra_variables\";s:0:\"\";s:14:\"search_cleanup\";b:0;s:20:\"search_cleanup_emoji\";b:0;s:23:\"search_cleanup_patterns\";b:0;s:22:\"search_character_limit\";i:50;s:20:\"deny_search_crawling\";b:0;s:21:\"deny_wp_json_crawling\";b:0;s:20:\"deny_adsbot_crawling\";b:0;s:19:\"deny_ccbot_crawling\";b:0;s:29:\"deny_google_extended_crawling\";b:0;s:20:\"deny_gptbot_crawling\";b:0;s:27:\"redirect_search_pretty_urls\";b:0;s:29:\"least_readability_ignore_list\";a:0:{}s:27:\"least_seo_score_ignore_list\";a:0:{}s:23:\"most_linked_ignore_list\";a:0:{}s:24:\"least_linked_ignore_list\";a:0:{}s:28:\"indexables_page_reading_list\";a:5:{i:0;b:0;i:1;b:0;i:2;b:0;i:3;b:0;i:4;b:0;}s:25:\"indexables_overview_state\";s:21:\"dashboard-not-visited\";s:28:\"last_known_public_post_types\";a:0:{}s:28:\"last_known_public_taxonomies\";a:0:{}s:23:\"last_known_no_unindexed\";a:0:{}s:14:\"new_post_types\";a:0:{}s:14:\"new_taxonomies\";a:0:{}s:34:\"show_new_content_type_notification\";b:0;s:44:\"site_kit_configuration_permanently_dismissed\";b:0;s:18:\"site_kit_connected\";b:0;s:37:\"site_kit_tracking_setup_widget_loaded\";s:2:\"no\";s:41:\"site_kit_tracking_first_interaction_stage\";s:0:\"\";s:40:\"site_kit_tracking_last_interaction_stage\";s:0:\"\";s:52:\"site_kit_tracking_setup_widget_temporarily_dismissed\";s:2:\"no\";s:52:\"site_kit_tracking_setup_widget_permanently_dismissed\";s:2:\"no\";s:31:\"google_site_kit_feature_enabled\";b:0;s:25:\"ai_free_sparks_started_on\";N;s:15:\"enable_llms_txt\";b:0;s:15:\"last_updated_on\";b:0;s:17:\"default_seo_title\";a:0:{}s:21:\"default_seo_meta_desc\";a:0:{}s:18:\"first_activated_by\";i:0;s:34:\"enable_schema_aggregation_endpoint\";b:0;s:38:\"schema_aggregation_endpoint_enabled_on\";N;s:16:\"enable_task_list\";b:1;s:13:\"enable_schema\";b:1;}','auto');
INSERT INTO `wp_options` VALUES (130,'wpseo_titles','a:176:{s:17:\"forcerewritetitle\";b:0;s:9:\"separator\";s:7:\"sc-dash\";s:16:\"title-home-wpseo\";s:42:\"%%sitename%% %%page%% %%sep%% %%sitedesc%%\";s:18:\"title-author-wpseo\";s:41:\"%%name%%, Author at %%sitename%% %%page%%\";s:19:\"title-archive-wpseo\";s:38:\"%%date%% %%page%% %%sep%% %%sitename%%\";s:18:\"title-search-wpseo\";s:63:\"You searched for %%searchphrase%% %%page%% %%sep%% %%sitename%%\";s:15:\"title-404-wpseo\";s:35:\"Page not found %%sep%% %%sitename%%\";s:25:\"social-title-author-wpseo\";s:8:\"%%name%%\";s:26:\"social-title-archive-wpseo\";s:8:\"%%date%%\";s:31:\"social-description-author-wpseo\";s:0:\"\";s:32:\"social-description-archive-wpseo\";s:0:\"\";s:29:\"social-image-url-author-wpseo\";s:0:\"\";s:30:\"social-image-url-archive-wpseo\";s:0:\"\";s:28:\"social-image-id-author-wpseo\";i:0;s:29:\"social-image-id-archive-wpseo\";i:0;s:19:\"metadesc-home-wpseo\";s:0:\"\";s:21:\"metadesc-author-wpseo\";s:0:\"\";s:22:\"metadesc-archive-wpseo\";s:0:\"\";s:9:\"rssbefore\";s:0:\"\";s:8:\"rssafter\";s:53:\"The post %%POSTLINK%% appeared first on %%BLOGLINK%%.\";s:20:\"noindex-author-wpseo\";b:0;s:28:\"noindex-author-noposts-wpseo\";b:1;s:21:\"noindex-archive-wpseo\";b:1;s:14:\"disable-author\";b:0;s:12:\"disable-date\";b:0;s:19:\"disable-post_format\";b:0;s:18:\"disable-attachment\";b:1;s:20:\"breadcrumbs-404crumb\";s:25:\"Error 404: Page not found\";s:29:\"breadcrumbs-display-blog-page\";b:1;s:20:\"breadcrumbs-boldlast\";b:0;s:25:\"breadcrumbs-archiveprefix\";s:12:\"Archives for\";s:18:\"breadcrumbs-enable\";b:1;s:16:\"breadcrumbs-home\";s:4:\"Home\";s:18:\"breadcrumbs-prefix\";s:0:\"\";s:24:\"breadcrumbs-searchprefix\";s:16:\"You searched for\";s:15:\"breadcrumbs-sep\";s:2:\"»\";s:12:\"website_name\";s:0:\"\";s:11:\"person_name\";s:0:\"\";s:11:\"person_logo\";s:0:\"\";s:22:\"alternate_website_name\";s:0:\"\";s:12:\"company_logo\";s:0:\"\";s:12:\"company_name\";s:0:\"\";s:22:\"company_alternate_name\";s:0:\"\";s:17:\"company_or_person\";s:7:\"company\";s:25:\"company_or_person_user_id\";b:0;s:17:\"stripcategorybase\";b:0;s:26:\"open_graph_frontpage_title\";s:12:\"%%sitename%%\";s:25:\"open_graph_frontpage_desc\";s:0:\"\";s:26:\"open_graph_frontpage_image\";s:0:\"\";s:24:\"publishing_principles_id\";i:0;s:25:\"ownership_funding_info_id\";i:0;s:29:\"actionable_feedback_policy_id\";i:0;s:21:\"corrections_policy_id\";i:0;s:16:\"ethics_policy_id\";i:0;s:19:\"diversity_policy_id\";i:0;s:28:\"diversity_staffing_report_id\";i:0;s:15:\"org-description\";s:0:\"\";s:9:\"org-email\";s:0:\"\";s:9:\"org-phone\";s:0:\"\";s:14:\"org-legal-name\";s:0:\"\";s:17:\"org-founding-date\";s:0:\"\";s:20:\"org-number-employees\";s:0:\"\";s:10:\"org-vat-id\";s:0:\"\";s:10:\"org-tax-id\";s:0:\"\";s:7:\"org-iso\";s:0:\"\";s:8:\"org-duns\";s:0:\"\";s:11:\"org-leicode\";s:0:\"\";s:9:\"org-naics\";s:0:\"\";s:10:\"title-post\";s:39:\"%%title%% %%page%% %%sep%% %%sitename%%\";s:13:\"metadesc-post\";s:0:\"\";s:12:\"noindex-post\";b:0;s:23:\"display-metabox-pt-post\";b:1;s:23:\"post_types-post-maintax\";i:0;s:21:\"schema-page-type-post\";s:7:\"WebPage\";s:24:\"schema-article-type-post\";s:7:\"Article\";s:17:\"social-title-post\";s:9:\"%%title%%\";s:23:\"social-description-post\";s:0:\"\";s:21:\"social-image-url-post\";s:0:\"\";s:20:\"social-image-id-post\";i:0;s:10:\"title-page\";s:39:\"%%title%% %%page%% %%sep%% %%sitename%%\";s:13:\"metadesc-page\";s:0:\"\";s:12:\"noindex-page\";b:0;s:23:\"display-metabox-pt-page\";b:1;s:23:\"post_types-page-maintax\";i:0;s:21:\"schema-page-type-page\";s:7:\"WebPage\";s:24:\"schema-article-type-page\";s:4:\"None\";s:17:\"social-title-page\";s:9:\"%%title%%\";s:23:\"social-description-page\";s:0:\"\";s:21:\"social-image-url-page\";s:0:\"\";s:20:\"social-image-id-page\";i:0;s:16:\"title-attachment\";s:39:\"%%title%% %%page%% %%sep%% %%sitename%%\";s:19:\"metadesc-attachment\";s:0:\"\";s:18:\"noindex-attachment\";b:0;s:29:\"display-metabox-pt-attachment\";b:1;s:29:\"post_types-attachment-maintax\";i:0;s:27:\"schema-page-type-attachment\";s:7:\"WebPage\";s:30:\"schema-article-type-attachment\";s:4:\"None\";s:11:\"title-brand\";s:39:\"%%title%% %%page%% %%sep%% %%sitename%%\";s:14:\"metadesc-brand\";s:0:\"\";s:13:\"noindex-brand\";b:0;s:24:\"display-metabox-pt-brand\";b:1;s:24:\"post_types-brand-maintax\";i:0;s:22:\"schema-page-type-brand\";s:7:\"WebPage\";s:25:\"schema-article-type-brand\";s:4:\"None\";s:18:\"social-title-brand\";s:9:\"%%title%%\";s:24:\"social-description-brand\";s:0:\"\";s:22:\"social-image-url-brand\";s:0:\"\";s:21:\"social-image-id-brand\";i:0;s:21:\"title-ptarchive-brand\";s:51:\"%%pt_plural%% Archive %%page%% %%sep%% %%sitename%%\";s:24:\"metadesc-ptarchive-brand\";s:0:\"\";s:23:\"bctitle-ptarchive-brand\";s:0:\"\";s:23:\"noindex-ptarchive-brand\";b:0;s:28:\"social-title-ptarchive-brand\";s:21:\"%%pt_plural%% Archive\";s:34:\"social-description-ptarchive-brand\";s:0:\"\";s:32:\"social-image-url-ptarchive-brand\";s:0:\"\";s:31:\"social-image-id-ptarchive-brand\";i:0;s:12:\"title-review\";s:39:\"%%title%% %%page%% %%sep%% %%sitename%%\";s:15:\"metadesc-review\";s:0:\"\";s:14:\"noindex-review\";b:0;s:25:\"display-metabox-pt-review\";b:1;s:25:\"post_types-review-maintax\";i:0;s:23:\"schema-page-type-review\";s:7:\"WebPage\";s:26:\"schema-article-type-review\";s:4:\"None\";s:19:\"social-title-review\";s:9:\"%%title%%\";s:25:\"social-description-review\";s:0:\"\";s:23:\"social-image-url-review\";s:0:\"\";s:22:\"social-image-id-review\";i:0;s:22:\"title-ptarchive-review\";s:51:\"%%pt_plural%% Archive %%page%% %%sep%% %%sitename%%\";s:25:\"metadesc-ptarchive-review\";s:0:\"\";s:24:\"bctitle-ptarchive-review\";s:0:\"\";s:24:\"noindex-ptarchive-review\";b:0;s:29:\"social-title-ptarchive-review\";s:21:\"%%pt_plural%% Archive\";s:35:\"social-description-ptarchive-review\";s:0:\"\";s:33:\"social-image-url-ptarchive-review\";s:0:\"\";s:32:\"social-image-id-ptarchive-review\";i:0;s:18:\"title-tax-category\";s:53:\"%%term_title%% Archives %%page%% %%sep%% %%sitename%%\";s:21:\"metadesc-tax-category\";s:0:\"\";s:28:\"display-metabox-tax-category\";b:1;s:20:\"noindex-tax-category\";b:0;s:25:\"social-title-tax-category\";s:23:\"%%term_title%% Archives\";s:31:\"social-description-tax-category\";s:0:\"\";s:29:\"social-image-url-tax-category\";s:0:\"\";s:28:\"social-image-id-tax-category\";i:0;s:26:\"taxonomy-category-ptparent\";i:0;s:18:\"title-tax-post_tag\";s:53:\"%%term_title%% Archives %%page%% %%sep%% %%sitename%%\";s:21:\"metadesc-tax-post_tag\";s:0:\"\";s:28:\"display-metabox-tax-post_tag\";b:1;s:20:\"noindex-tax-post_tag\";b:0;s:25:\"social-title-tax-post_tag\";s:23:\"%%term_title%% Archives\";s:31:\"social-description-tax-post_tag\";s:0:\"\";s:29:\"social-image-url-tax-post_tag\";s:0:\"\";s:28:\"social-image-id-tax-post_tag\";i:0;s:26:\"taxonomy-post_tag-ptparent\";i:0;s:21:\"title-tax-post_format\";s:53:\"%%term_title%% Archives %%page%% %%sep%% %%sitename%%\";s:24:\"metadesc-tax-post_format\";s:0:\"\";s:31:\"display-metabox-tax-post_format\";b:1;s:23:\"noindex-tax-post_format\";b:1;s:28:\"social-title-tax-post_format\";s:23:\"%%term_title%% Archives\";s:34:\"social-description-tax-post_format\";s:0:\"\";s:32:\"social-image-url-tax-post_format\";s:0:\"\";s:31:\"social-image-id-tax-post_format\";i:0;s:29:\"taxonomy-post_format-ptparent\";i:0;s:18:\"title-tax-industry\";s:53:\"%%term_title%% Archives %%page%% %%sep%% %%sitename%%\";s:21:\"metadesc-tax-industry\";s:0:\"\";s:28:\"display-metabox-tax-industry\";b:1;s:20:\"noindex-tax-industry\";b:0;s:25:\"social-title-tax-industry\";s:23:\"%%term_title%% Archives\";s:31:\"social-description-tax-industry\";s:0:\"\";s:29:\"social-image-url-tax-industry\";s:0:\"\";s:28:\"social-image-id-tax-industry\";i:0;s:26:\"taxonomy-industry-ptparent\";i:0;s:14:\"person_logo_id\";i:0;s:15:\"company_logo_id\";i:0;s:17:\"company_logo_meta\";b:0;s:16:\"person_logo_meta\";b:0;s:29:\"open_graph_frontpage_image_id\";i:0;}','auto');
INSERT INTO `wp_options` VALUES (131,'wpseo_social','a:20:{s:13:\"facebook_site\";s:0:\"\";s:13:\"instagram_url\";s:0:\"\";s:12:\"linkedin_url\";s:0:\"\";s:11:\"myspace_url\";s:0:\"\";s:16:\"og_default_image\";s:0:\"\";s:19:\"og_default_image_id\";s:0:\"\";s:18:\"og_frontpage_title\";s:0:\"\";s:17:\"og_frontpage_desc\";s:0:\"\";s:18:\"og_frontpage_image\";s:0:\"\";s:21:\"og_frontpage_image_id\";s:0:\"\";s:9:\"opengraph\";b:1;s:13:\"pinterest_url\";s:0:\"\";s:15:\"pinterestverify\";s:0:\"\";s:7:\"twitter\";b:1;s:12:\"twitter_site\";s:0:\"\";s:17:\"twitter_card_type\";s:19:\"summary_large_image\";s:11:\"youtube_url\";s:0:\"\";s:13:\"wikipedia_url\";s:0:\"\";s:17:\"other_social_urls\";a:0:{}s:12:\"mastodon_url\";s:0:\"\";}','auto');
INSERT INTO `wp_options` VALUES (132,'wpseo_llmstxt','a:7:{s:23:\"llms_txt_selection_mode\";s:4:\"auto\";s:13:\"about_us_page\";i:0;s:12:\"contact_page\";i:0;s:10:\"terms_page\";i:0;s:19:\"privacy_policy_page\";i:0;s:9:\"shop_page\";i:0;s:20:\"other_included_pages\";a:0:{}}','auto');
INSERT INTO `wp_options` VALUES (133,'wpseo_tracking_only','a:3:{s:25:\"task_list_first_opened_on\";s:0:\"\";s:22:\"task_first_actioned_on\";s:0:\"\";s:36:\"frontend_inspector_first_actioned_on\";s:0:\"\";}','auto');
INSERT INTO `wp_options` VALUES (134,'_site_transient_timeout_theme_roots','1779224336','off');
INSERT INTO `wp_options` VALUES (135,'_site_transient_theme_roots','a:4:{s:16:\"consumer-reviews\";s:7:\"/themes\";s:16:\"twentytwentyfive\";s:7:\"/themes\";s:16:\"twentytwentyfour\";s:7:\"/themes\";s:17:\"twentytwentythree\";s:7:\"/themes\";}','off');
INSERT INTO `wp_options` VALUES (136,'theme_mods_twentytwentyfive','a:1:{s:16:\"sidebars_widgets\";a:2:{s:4:\"time\";i:1779222536;s:4:\"data\";a:3:{s:19:\"wp_inactive_widgets\";a:0:{}s:9:\"sidebar-1\";a:3:{i:0;s:7:\"block-2\";i:1;s:7:\"block-3\";i:2;s:7:\"block-4\";}s:9:\"sidebar-2\";a:2:{i:0;s:7:\"block-5\";i:1;s:7:\"block-6\";}}}}','off');
INSERT INTO `wp_options` VALUES (137,'current_theme','Consumer Reviews','auto');
INSERT INTO `wp_options` VALUES (138,'theme_switched','','auto');
INSERT INTO `wp_options` VALUES (139,'_site_transient_timeout_wp_theme_files_patterns-5aa9a434e14effa365522e65affdfa56','1779224336','off');
INSERT INTO `wp_options` VALUES (140,'_site_transient_wp_theme_files_patterns-5aa9a434e14effa365522e65affdfa56','a:2:{s:7:\"version\";s:5:\"1.0.0\";s:8:\"patterns\";a:0:{}}','off');
INSERT INTO `wp_options` VALUES (141,'theme_mods_consumer-reviews','a:2:{s:18:\"nav_menu_locations\";a:0:{}s:18:\"custom_css_post_id\";i:-1;}','auto');
INSERT INTO `wp_options` VALUES (142,'_site_transient_update_themes','O:8:\"stdClass\":5:{s:12:\"last_checked\";i:1779222654;s:7:\"checked\";a:4:{s:16:\"consumer-reviews\";s:5:\"1.0.0\";s:16:\"twentytwentyfive\";s:3:\"1.4\";s:16:\"twentytwentyfour\";s:3:\"1.4\";s:17:\"twentytwentythree\";s:3:\"1.6\";}s:8:\"response\";a:0:{}s:9:\"no_update\";a:3:{s:16:\"twentytwentyfive\";a:6:{s:5:\"theme\";s:16:\"twentytwentyfive\";s:11:\"new_version\";s:3:\"1.4\";s:3:\"url\";s:46:\"https://wordpress.org/themes/twentytwentyfive/\";s:7:\"package\";s:62:\"https://downloads.wordpress.org/theme/twentytwentyfive.1.4.zip\";s:8:\"requires\";s:3:\"6.7\";s:12:\"requires_php\";s:3:\"7.2\";}s:16:\"twentytwentyfour\";a:6:{s:5:\"theme\";s:16:\"twentytwentyfour\";s:11:\"new_version\";s:3:\"1.4\";s:3:\"url\";s:46:\"https://wordpress.org/themes/twentytwentyfour/\";s:7:\"package\";s:62:\"https://downloads.wordpress.org/theme/twentytwentyfour.1.4.zip\";s:8:\"requires\";s:3:\"6.4\";s:12:\"requires_php\";s:3:\"7.0\";}s:17:\"twentytwentythree\";a:6:{s:5:\"theme\";s:17:\"twentytwentythree\";s:11:\"new_version\";s:3:\"1.6\";s:3:\"url\";s:47:\"https://wordpress.org/themes/twentytwentythree/\";s:7:\"package\";s:63:\"https://downloads.wordpress.org/theme/twentytwentythree.1.6.zip\";s:8:\"requires\";s:3:\"6.1\";s:12:\"requires_php\";s:3:\"5.6\";}}s:12:\"translations\";a:0:{}}','off');
INSERT INTO `wp_options` VALUES (143,'_transient_wp_styles_for_blocks','a:2:{s:4:\"hash\";s:32:\"4ad6ed4956ef7f814db220c22a123393\";s:6:\"blocks\";a:6:{s:11:\"core/button\";s:0:\"\";s:14:\"core/site-logo\";s:0:\"\";s:18:\"core/post-template\";s:120:\":where(.wp-block-post-template.is-layout-flex){gap: 1.25em;}:where(.wp-block-post-template.is-layout-grid){gap: 1.25em;}\";s:18:\"core/term-template\";s:120:\":where(.wp-block-term-template.is-layout-flex){gap: 1.25em;}:where(.wp-block-term-template.is-layout-grid){gap: 1.25em;}\";s:12:\"core/columns\";s:102:\":where(.wp-block-columns.is-layout-flex){gap: 2em;}:where(.wp-block-columns.is-layout-grid){gap: 2em;}\";s:14:\"core/pullquote\";s:69:\":root :where(.wp-block-pullquote){font-size: 1.5em;line-height: 1.6;}\";}}','on');
/*!40000 ALTER TABLE `wp_options` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `wp_postmeta`
--

DROP TABLE IF EXISTS `wp_postmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_postmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL,
  PRIMARY KEY (`meta_id`),
  KEY `post_id` (`post_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB AUTO_INCREMENT=533 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_postmeta`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `wp_postmeta` WRITE;
/*!40000 ALTER TABLE `wp_postmeta` DISABLE KEYS */;
INSERT INTO `wp_postmeta` VALUES (1,2,'_wp_page_template','default');
INSERT INTO `wp_postmeta` VALUES (2,3,'_wp_page_template','default');
INSERT INTO `wp_postmeta` VALUES (3,7,'website_url','https://acme-insurance.example.com');
INSERT INTO `wp_postmeta` VALUES (4,7,'_website_url','field_brand_website_url');
INSERT INTO `wp_postmeta` VALUES (5,7,'founded_year','1985');
INSERT INTO `wp_postmeta` VALUES (6,7,'_founded_year','field_brand_founded_year');
INSERT INTO `wp_postmeta` VALUES (7,7,'headquarters','Hartford, CT');
INSERT INTO `wp_postmeta` VALUES (8,7,'_headquarters','field_brand_headquarters');
INSERT INTO `wp_postmeta` VALUES (9,7,'average_rating','4.2');
INSERT INTO `wp_postmeta` VALUES (10,7,'_average_rating','field_brand_average_rating');
INSERT INTO `wp_postmeta` VALUES (11,7,'_yoast_wpseo_title','Acme Insurance Reviews - Auto, Home & Umbrella Coverage');
INSERT INTO `wp_postmeta` VALUES (12,7,'_yoast_wpseo_metadesc','Read 12 independent customer reviews of Acme Insurance, a Hartford-based insurer offering auto, home, and umbrella policies in 38 US states.');
INSERT INTO `wp_postmeta` VALUES (13,8,'website_url','https://primepath-bank.example.com');
INSERT INTO `wp_postmeta` VALUES (14,8,'_website_url','field_brand_website_url');
INSERT INTO `wp_postmeta` VALUES (15,8,'founded_year','1978');
INSERT INTO `wp_postmeta` VALUES (16,8,'_founded_year','field_brand_founded_year');
INSERT INTO `wp_postmeta` VALUES (17,8,'headquarters','New York, NY');
INSERT INTO `wp_postmeta` VALUES (18,8,'_headquarters','field_brand_headquarters');
INSERT INTO `wp_postmeta` VALUES (19,8,'average_rating','4.0');
INSERT INTO `wp_postmeta` VALUES (20,8,'_average_rating','field_brand_average_rating');
INSERT INTO `wp_postmeta` VALUES (21,8,'_yoast_wpseo_title','PrimePath Bank Reviews - Checking, Savings, Loans');
INSERT INTO `wp_postmeta` VALUES (22,8,'_yoast_wpseo_metadesc','PrimePath Bank customer reviews. Northeast regional bank offering checking, savings, and loans across 220 branches.');
INSERT INTO `wp_postmeta` VALUES (23,9,'website_url','https://homeshield-pro.example.com');
INSERT INTO `wp_postmeta` VALUES (24,9,'_website_url','field_brand_website_url');
INSERT INTO `wp_postmeta` VALUES (25,9,'founded_year','1999');
INSERT INTO `wp_postmeta` VALUES (26,9,'_founded_year','field_brand_founded_year');
INSERT INTO `wp_postmeta` VALUES (27,9,'headquarters','Atlanta, GA');
INSERT INTO `wp_postmeta` VALUES (28,9,'_headquarters','field_brand_headquarters');
INSERT INTO `wp_postmeta` VALUES (29,9,'average_rating','3.9');
INSERT INTO `wp_postmeta` VALUES (30,9,'_average_rating','field_brand_average_rating');
INSERT INTO `wp_postmeta` VALUES (31,9,'_yoast_wpseo_title','HomeShield Pro Home Warranty Reviews');
INSERT INTO `wp_postmeta` VALUES (32,9,'_yoast_wpseo_metadesc','Read real customer reviews of HomeShield Pro home warranty plans covering HVAC, appliances, and plumbing.');
INSERT INTO `wp_postmeta` VALUES (33,10,'website_url','https://swiftstream-internet.example.com');
INSERT INTO `wp_postmeta` VALUES (34,10,'_website_url','field_brand_website_url');
INSERT INTO `wp_postmeta` VALUES (35,10,'founded_year','2014');
INSERT INTO `wp_postmeta` VALUES (36,10,'_founded_year','field_brand_founded_year');
INSERT INTO `wp_postmeta` VALUES (37,10,'headquarters','Austin, TX');
INSERT INTO `wp_postmeta` VALUES (38,10,'_headquarters','field_brand_headquarters');
INSERT INTO `wp_postmeta` VALUES (39,10,'average_rating','3.5');
INSERT INTO `wp_postmeta` VALUES (40,10,'_average_rating','field_brand_average_rating');
INSERT INTO `wp_postmeta` VALUES (41,10,'_yoast_wpseo_title','SwiftStream Internet Reviews - Rural Fixed Wireless ISP');
INSERT INTO `wp_postmeta` VALUES (42,10,'_yoast_wpseo_metadesc','Read reviews of SwiftStream Internet, a Texas-based fixed wireless ISP for suburban and rural Southwest customers.');
INSERT INTO `wp_postmeta` VALUES (43,11,'website_url','https://urbanretail-co.example.com');
INSERT INTO `wp_postmeta` VALUES (44,11,'_website_url','field_brand_website_url');
INSERT INTO `wp_postmeta` VALUES (45,11,'founded_year','2005');
INSERT INTO `wp_postmeta` VALUES (46,11,'_founded_year','field_brand_founded_year');
INSERT INTO `wp_postmeta` VALUES (47,11,'headquarters','Seattle, WA');
INSERT INTO `wp_postmeta` VALUES (48,11,'_headquarters','field_brand_headquarters');
INSERT INTO `wp_postmeta` VALUES (49,11,'average_rating','4.4');
INSERT INTO `wp_postmeta` VALUES (50,11,'_average_rating','field_brand_average_rating');
INSERT INTO `wp_postmeta` VALUES (51,11,'_yoast_wpseo_title','UrbanRetail Co. Reviews - Apparel, Home, Electronics');
INSERT INTO `wp_postmeta` VALUES (52,11,'_yoast_wpseo_metadesc','Customer reviews of UrbanRetail Co., a Seattle-based online retailer carrying apparel, home goods, and small electronics.');
INSERT INTO `wp_postmeta` VALUES (53,12,'rating','5');
INSERT INTO `wp_postmeta` VALUES (54,12,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (55,12,'reviewer_name','Sarah K.');
INSERT INTO `wp_postmeta` VALUES (56,12,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (57,12,'reviewer_location','Denver, CO');
INSERT INTO `wp_postmeta` VALUES (58,12,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (59,12,'brand','7');
INSERT INTO `wp_postmeta` VALUES (60,12,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (61,13,'rating','3');
INSERT INTO `wp_postmeta` VALUES (62,13,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (63,13,'reviewer_name','Mike T.');
INSERT INTO `wp_postmeta` VALUES (64,13,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (65,13,'reviewer_location','Albany, NY');
INSERT INTO `wp_postmeta` VALUES (66,13,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (67,13,'brand','7');
INSERT INTO `wp_postmeta` VALUES (68,13,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (69,14,'rating','5');
INSERT INTO `wp_postmeta` VALUES (70,14,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (71,14,'reviewer_name','Jenny W.');
INSERT INTO `wp_postmeta` VALUES (72,14,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (73,14,'reviewer_location','Cedar Rapids, IA');
INSERT INTO `wp_postmeta` VALUES (74,14,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (75,14,'brand','7');
INSERT INTO `wp_postmeta` VALUES (76,14,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (77,15,'rating','2');
INSERT INTO `wp_postmeta` VALUES (78,15,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (79,15,'reviewer_name','David L.');
INSERT INTO `wp_postmeta` VALUES (80,15,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (81,15,'reviewer_location','Hartford, CT');
INSERT INTO `wp_postmeta` VALUES (82,15,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (83,15,'brand','7');
INSERT INTO `wp_postmeta` VALUES (84,15,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (85,16,'rating','5');
INSERT INTO `wp_postmeta` VALUES (86,16,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (87,16,'reviewer_name','Anna R.');
INSERT INTO `wp_postmeta` VALUES (88,16,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (89,16,'reviewer_location','Portland, OR');
INSERT INTO `wp_postmeta` VALUES (90,16,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (91,16,'brand','7');
INSERT INTO `wp_postmeta` VALUES (92,16,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (93,17,'rating','3');
INSERT INTO `wp_postmeta` VALUES (94,17,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (95,17,'reviewer_name','Roberto G.');
INSERT INTO `wp_postmeta` VALUES (96,17,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (97,17,'reviewer_location','Charlotte, NC');
INSERT INTO `wp_postmeta` VALUES (98,17,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (99,17,'brand','7');
INSERT INTO `wp_postmeta` VALUES (100,17,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (101,18,'rating','5');
INSERT INTO `wp_postmeta` VALUES (102,18,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (103,18,'reviewer_name','Maya P.');
INSERT INTO `wp_postmeta` VALUES (104,18,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (105,18,'reviewer_location','Oklahoma City, OK');
INSERT INTO `wp_postmeta` VALUES (106,18,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (107,18,'brand','7');
INSERT INTO `wp_postmeta` VALUES (108,18,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (109,19,'rating','3');
INSERT INTO `wp_postmeta` VALUES (110,19,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (111,19,'reviewer_name','Kenji O.');
INSERT INTO `wp_postmeta` VALUES (112,19,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (113,19,'reviewer_location','Boston, MA');
INSERT INTO `wp_postmeta` VALUES (114,19,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (115,19,'brand','7');
INSERT INTO `wp_postmeta` VALUES (116,19,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (117,20,'rating','5');
INSERT INTO `wp_postmeta` VALUES (118,20,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (119,20,'reviewer_name','Sarah K.');
INSERT INTO `wp_postmeta` VALUES (120,20,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (121,20,'reviewer_location','Denver, CO');
INSERT INTO `wp_postmeta` VALUES (122,20,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (123,20,'brand','7');
INSERT INTO `wp_postmeta` VALUES (124,20,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (125,21,'rating','3');
INSERT INTO `wp_postmeta` VALUES (126,21,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (127,21,'reviewer_name','Mike T.');
INSERT INTO `wp_postmeta` VALUES (128,21,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (129,21,'reviewer_location','Albany, NY');
INSERT INTO `wp_postmeta` VALUES (130,21,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (131,21,'brand','7');
INSERT INTO `wp_postmeta` VALUES (132,21,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (133,22,'rating','4');
INSERT INTO `wp_postmeta` VALUES (134,22,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (135,22,'reviewer_name','Jenny W.');
INSERT INTO `wp_postmeta` VALUES (136,22,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (137,22,'reviewer_location','Cedar Rapids, IA');
INSERT INTO `wp_postmeta` VALUES (138,22,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (139,22,'brand','7');
INSERT INTO `wp_postmeta` VALUES (140,22,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (141,23,'rating','4');
INSERT INTO `wp_postmeta` VALUES (142,23,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (143,23,'reviewer_name','David L.');
INSERT INTO `wp_postmeta` VALUES (144,23,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (145,23,'reviewer_location','Hartford, CT');
INSERT INTO `wp_postmeta` VALUES (146,23,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (147,23,'brand','7');
INSERT INTO `wp_postmeta` VALUES (148,23,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (149,24,'rating','5');
INSERT INTO `wp_postmeta` VALUES (150,24,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (151,24,'reviewer_name','Anna R.');
INSERT INTO `wp_postmeta` VALUES (152,24,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (153,24,'reviewer_location','Boston, MA');
INSERT INTO `wp_postmeta` VALUES (154,24,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (155,24,'brand','8');
INSERT INTO `wp_postmeta` VALUES (156,24,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (157,25,'rating','3');
INSERT INTO `wp_postmeta` VALUES (158,25,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (159,25,'reviewer_name','Mike T.');
INSERT INTO `wp_postmeta` VALUES (160,25,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (161,25,'reviewer_location','Albany, NY');
INSERT INTO `wp_postmeta` VALUES (162,25,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (163,25,'brand','8');
INSERT INTO `wp_postmeta` VALUES (164,25,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (165,26,'rating','5');
INSERT INTO `wp_postmeta` VALUES (166,26,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (167,26,'reviewer_name','Sarah K.');
INSERT INTO `wp_postmeta` VALUES (168,26,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (169,26,'reviewer_location','Stamford, CT');
INSERT INTO `wp_postmeta` VALUES (170,26,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (171,26,'brand','8');
INSERT INTO `wp_postmeta` VALUES (172,26,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (173,27,'rating','2');
INSERT INTO `wp_postmeta` VALUES (174,27,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (175,27,'reviewer_name','Roberto G.');
INSERT INTO `wp_postmeta` VALUES (176,27,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (177,27,'reviewer_location','Charlotte, NC');
INSERT INTO `wp_postmeta` VALUES (178,27,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (179,27,'brand','8');
INSERT INTO `wp_postmeta` VALUES (180,27,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (181,28,'rating','5');
INSERT INTO `wp_postmeta` VALUES (182,28,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (183,28,'reviewer_name','Jenny W.');
INSERT INTO `wp_postmeta` VALUES (184,28,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (185,28,'reviewer_location','Albany, NY');
INSERT INTO `wp_postmeta` VALUES (186,28,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (187,28,'brand','8');
INSERT INTO `wp_postmeta` VALUES (188,28,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (189,29,'rating','2');
INSERT INTO `wp_postmeta` VALUES (190,29,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (191,29,'reviewer_name','David L.');
INSERT INTO `wp_postmeta` VALUES (192,29,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (193,29,'reviewer_location','Hartford, CT');
INSERT INTO `wp_postmeta` VALUES (194,29,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (195,29,'brand','8');
INSERT INTO `wp_postmeta` VALUES (196,29,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (197,30,'rating','4');
INSERT INTO `wp_postmeta` VALUES (198,30,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (199,30,'reviewer_name','Maya P.');
INSERT INTO `wp_postmeta` VALUES (200,30,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (201,30,'reviewer_location','Oklahoma City, OK');
INSERT INTO `wp_postmeta` VALUES (202,30,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (203,30,'brand','8');
INSERT INTO `wp_postmeta` VALUES (204,30,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (205,31,'rating','3');
INSERT INTO `wp_postmeta` VALUES (206,31,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (207,31,'reviewer_name','Kenji O.');
INSERT INTO `wp_postmeta` VALUES (208,31,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (209,31,'reviewer_location','Boston, MA');
INSERT INTO `wp_postmeta` VALUES (210,31,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (211,31,'brand','8');
INSERT INTO `wp_postmeta` VALUES (212,31,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (213,32,'rating','5');
INSERT INTO `wp_postmeta` VALUES (214,32,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (215,32,'reviewer_name','Anna R.');
INSERT INTO `wp_postmeta` VALUES (216,32,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (217,32,'reviewer_location','Boston, MA');
INSERT INTO `wp_postmeta` VALUES (218,32,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (219,32,'brand','8');
INSERT INTO `wp_postmeta` VALUES (220,32,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (221,33,'rating','3');
INSERT INTO `wp_postmeta` VALUES (222,33,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (223,33,'reviewer_name','Sarah K.');
INSERT INTO `wp_postmeta` VALUES (224,33,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (225,33,'reviewer_location','Stamford, CT');
INSERT INTO `wp_postmeta` VALUES (226,33,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (227,33,'brand','8');
INSERT INTO `wp_postmeta` VALUES (228,33,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (229,34,'rating','4');
INSERT INTO `wp_postmeta` VALUES (230,34,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (231,34,'reviewer_name','Mike T.');
INSERT INTO `wp_postmeta` VALUES (232,34,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (233,34,'reviewer_location','Albany, NY');
INSERT INTO `wp_postmeta` VALUES (234,34,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (235,34,'brand','8');
INSERT INTO `wp_postmeta` VALUES (236,34,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (237,35,'rating','5');
INSERT INTO `wp_postmeta` VALUES (238,35,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (239,35,'reviewer_name','Roberto G.');
INSERT INTO `wp_postmeta` VALUES (240,35,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (241,35,'reviewer_location','Charlotte, NC');
INSERT INTO `wp_postmeta` VALUES (242,35,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (243,35,'brand','8');
INSERT INTO `wp_postmeta` VALUES (244,35,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (245,36,'rating','5');
INSERT INTO `wp_postmeta` VALUES (246,36,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (247,36,'reviewer_name','Sarah K.');
INSERT INTO `wp_postmeta` VALUES (248,36,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (249,36,'reviewer_location','Denver, CO');
INSERT INTO `wp_postmeta` VALUES (250,36,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (251,36,'brand','9');
INSERT INTO `wp_postmeta` VALUES (252,36,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (253,37,'rating','2');
INSERT INTO `wp_postmeta` VALUES (254,37,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (255,37,'reviewer_name','David L.');
INSERT INTO `wp_postmeta` VALUES (256,37,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (257,37,'reviewer_location','Hartford, CT');
INSERT INTO `wp_postmeta` VALUES (258,37,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (259,37,'brand','9');
INSERT INTO `wp_postmeta` VALUES (260,37,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (261,38,'rating','4');
INSERT INTO `wp_postmeta` VALUES (262,38,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (263,38,'reviewer_name','Jenny W.');
INSERT INTO `wp_postmeta` VALUES (264,38,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (265,38,'reviewer_location','Chicago, IL');
INSERT INTO `wp_postmeta` VALUES (266,38,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (267,38,'brand','9');
INSERT INTO `wp_postmeta` VALUES (268,38,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (269,39,'rating','2');
INSERT INTO `wp_postmeta` VALUES (270,39,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (271,39,'reviewer_name','Mike T.');
INSERT INTO `wp_postmeta` VALUES (272,39,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (273,39,'reviewer_location','Albany, NY');
INSERT INTO `wp_postmeta` VALUES (274,39,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (275,39,'brand','9');
INSERT INTO `wp_postmeta` VALUES (276,39,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (277,40,'rating','4');
INSERT INTO `wp_postmeta` VALUES (278,40,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (279,40,'reviewer_name','Anna R.');
INSERT INTO `wp_postmeta` VALUES (280,40,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (281,40,'reviewer_location','Portland, OR');
INSERT INTO `wp_postmeta` VALUES (282,40,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (283,40,'brand','9');
INSERT INTO `wp_postmeta` VALUES (284,40,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (285,41,'rating','3');
INSERT INTO `wp_postmeta` VALUES (286,41,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (287,41,'reviewer_name','Roberto G.');
INSERT INTO `wp_postmeta` VALUES (288,41,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (289,41,'reviewer_location','Charlotte, NC');
INSERT INTO `wp_postmeta` VALUES (290,41,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (291,41,'brand','9');
INSERT INTO `wp_postmeta` VALUES (292,41,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (293,42,'rating','2');
INSERT INTO `wp_postmeta` VALUES (294,42,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (295,42,'reviewer_name','Maya P.');
INSERT INTO `wp_postmeta` VALUES (296,42,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (297,42,'reviewer_location','Oklahoma City, OK');
INSERT INTO `wp_postmeta` VALUES (298,42,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (299,42,'brand','9');
INSERT INTO `wp_postmeta` VALUES (300,42,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (301,43,'rating','5');
INSERT INTO `wp_postmeta` VALUES (302,43,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (303,43,'reviewer_name','Kenji O.');
INSERT INTO `wp_postmeta` VALUES (304,43,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (305,43,'reviewer_location','Boston, MA');
INSERT INTO `wp_postmeta` VALUES (306,43,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (307,43,'brand','9');
INSERT INTO `wp_postmeta` VALUES (308,43,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (309,44,'rating','1');
INSERT INTO `wp_postmeta` VALUES (310,44,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (311,44,'reviewer_name','David L.');
INSERT INTO `wp_postmeta` VALUES (312,44,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (313,44,'reviewer_location','Hartford, CT');
INSERT INTO `wp_postmeta` VALUES (314,44,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (315,44,'brand','9');
INSERT INTO `wp_postmeta` VALUES (316,44,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (317,45,'rating','5');
INSERT INTO `wp_postmeta` VALUES (318,45,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (319,45,'reviewer_name','Jenny W.');
INSERT INTO `wp_postmeta` VALUES (320,45,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (321,45,'reviewer_location','Chicago, IL');
INSERT INTO `wp_postmeta` VALUES (322,45,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (323,45,'brand','9');
INSERT INTO `wp_postmeta` VALUES (324,45,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (325,46,'rating','2');
INSERT INTO `wp_postmeta` VALUES (326,46,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (327,46,'reviewer_name','Sarah K.');
INSERT INTO `wp_postmeta` VALUES (328,46,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (329,46,'reviewer_location','Denver, CO');
INSERT INTO `wp_postmeta` VALUES (330,46,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (331,46,'brand','9');
INSERT INTO `wp_postmeta` VALUES (332,46,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (333,47,'rating','2');
INSERT INTO `wp_postmeta` VALUES (334,47,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (335,47,'reviewer_name','Roberto G.');
INSERT INTO `wp_postmeta` VALUES (336,47,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (337,47,'reviewer_location','Charlotte, NC');
INSERT INTO `wp_postmeta` VALUES (338,47,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (339,47,'brand','9');
INSERT INTO `wp_postmeta` VALUES (340,47,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (341,48,'rating','5');
INSERT INTO `wp_postmeta` VALUES (342,48,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (343,48,'reviewer_name','Sarah K.');
INSERT INTO `wp_postmeta` VALUES (344,48,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (345,48,'reviewer_location','Marble Falls, TX');
INSERT INTO `wp_postmeta` VALUES (346,48,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (347,48,'brand','10');
INSERT INTO `wp_postmeta` VALUES (348,48,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (349,49,'rating','2');
INSERT INTO `wp_postmeta` VALUES (350,49,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (351,49,'reviewer_name','Mike T.');
INSERT INTO `wp_postmeta` VALUES (352,49,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (353,49,'reviewer_location','Liberty Hill, TX');
INSERT INTO `wp_postmeta` VALUES (354,49,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (355,49,'brand','10');
INSERT INTO `wp_postmeta` VALUES (356,49,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (357,50,'rating','3');
INSERT INTO `wp_postmeta` VALUES (358,50,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (359,50,'reviewer_name','David L.');
INSERT INTO `wp_postmeta` VALUES (360,50,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (361,50,'reviewer_location','Fredericksburg, TX');
INSERT INTO `wp_postmeta` VALUES (362,50,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (363,50,'brand','10');
INSERT INTO `wp_postmeta` VALUES (364,50,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (365,51,'rating','4');
INSERT INTO `wp_postmeta` VALUES (366,51,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (367,51,'reviewer_name','Jenny W.');
INSERT INTO `wp_postmeta` VALUES (368,51,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (369,51,'reviewer_location','Boerne, TX');
INSERT INTO `wp_postmeta` VALUES (370,51,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (371,51,'brand','10');
INSERT INTO `wp_postmeta` VALUES (372,51,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (373,52,'rating','2');
INSERT INTO `wp_postmeta` VALUES (374,52,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (375,52,'reviewer_name','Anna R.');
INSERT INTO `wp_postmeta` VALUES (376,52,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (377,52,'reviewer_location','Las Cruces, NM');
INSERT INTO `wp_postmeta` VALUES (378,52,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (379,52,'brand','10');
INSERT INTO `wp_postmeta` VALUES (380,52,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (381,53,'rating','5');
INSERT INTO `wp_postmeta` VALUES (382,53,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (383,53,'reviewer_name','Roberto G.');
INSERT INTO `wp_postmeta` VALUES (384,53,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (385,53,'reviewer_location','Tucson, AZ');
INSERT INTO `wp_postmeta` VALUES (386,53,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (387,53,'brand','10');
INSERT INTO `wp_postmeta` VALUES (388,53,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (389,54,'rating','3');
INSERT INTO `wp_postmeta` VALUES (390,54,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (391,54,'reviewer_name','Maya P.');
INSERT INTO `wp_postmeta` VALUES (392,54,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (393,54,'reviewer_location','Marfa, TX');
INSERT INTO `wp_postmeta` VALUES (394,54,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (395,54,'brand','10');
INSERT INTO `wp_postmeta` VALUES (396,54,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (397,55,'rating','4');
INSERT INTO `wp_postmeta` VALUES (398,55,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (399,55,'reviewer_name','Kenji O.');
INSERT INTO `wp_postmeta` VALUES (400,55,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (401,55,'reviewer_location','Sedona, AZ');
INSERT INTO `wp_postmeta` VALUES (402,55,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (403,55,'brand','10');
INSERT INTO `wp_postmeta` VALUES (404,55,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (405,56,'rating','2');
INSERT INTO `wp_postmeta` VALUES (406,56,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (407,56,'reviewer_name','Sarah K.');
INSERT INTO `wp_postmeta` VALUES (408,56,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (409,56,'reviewer_location','Marble Falls, TX');
INSERT INTO `wp_postmeta` VALUES (410,56,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (411,56,'brand','10');
INSERT INTO `wp_postmeta` VALUES (412,56,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (413,57,'rating','4');
INSERT INTO `wp_postmeta` VALUES (414,57,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (415,57,'reviewer_name','Jenny W.');
INSERT INTO `wp_postmeta` VALUES (416,57,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (417,57,'reviewer_location','Boerne, TX');
INSERT INTO `wp_postmeta` VALUES (418,57,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (419,57,'brand','10');
INSERT INTO `wp_postmeta` VALUES (420,57,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (421,58,'rating','3');
INSERT INTO `wp_postmeta` VALUES (422,58,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (423,58,'reviewer_name','David L.');
INSERT INTO `wp_postmeta` VALUES (424,58,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (425,58,'reviewer_location','Fredericksburg, TX');
INSERT INTO `wp_postmeta` VALUES (426,58,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (427,58,'brand','10');
INSERT INTO `wp_postmeta` VALUES (428,58,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (429,59,'rating','5');
INSERT INTO `wp_postmeta` VALUES (430,59,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (431,59,'reviewer_name','Mike T.');
INSERT INTO `wp_postmeta` VALUES (432,59,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (433,59,'reviewer_location','Liberty Hill, TX');
INSERT INTO `wp_postmeta` VALUES (434,59,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (435,59,'brand','10');
INSERT INTO `wp_postmeta` VALUES (436,59,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (437,60,'rating','5');
INSERT INTO `wp_postmeta` VALUES (438,60,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (439,60,'reviewer_name','Sarah K.');
INSERT INTO `wp_postmeta` VALUES (440,60,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (441,60,'reviewer_location','Denver, CO');
INSERT INTO `wp_postmeta` VALUES (442,60,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (443,60,'brand','11');
INSERT INTO `wp_postmeta` VALUES (444,60,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (445,61,'rating','3');
INSERT INTO `wp_postmeta` VALUES (446,61,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (447,61,'reviewer_name','David L.');
INSERT INTO `wp_postmeta` VALUES (448,61,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (449,61,'reviewer_location','Hartford, CT');
INSERT INTO `wp_postmeta` VALUES (450,61,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (451,61,'brand','11');
INSERT INTO `wp_postmeta` VALUES (452,61,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (453,62,'rating','5');
INSERT INTO `wp_postmeta` VALUES (454,62,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (455,62,'reviewer_name','Anna R.');
INSERT INTO `wp_postmeta` VALUES (456,62,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (457,62,'reviewer_location','Portland, OR');
INSERT INTO `wp_postmeta` VALUES (458,62,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (459,62,'brand','11');
INSERT INTO `wp_postmeta` VALUES (460,62,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (461,63,'rating','2');
INSERT INTO `wp_postmeta` VALUES (462,63,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (463,63,'reviewer_name','Jenny W.');
INSERT INTO `wp_postmeta` VALUES (464,63,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (465,63,'reviewer_location','Chicago, IL');
INSERT INTO `wp_postmeta` VALUES (466,63,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (467,63,'brand','11');
INSERT INTO `wp_postmeta` VALUES (468,63,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (469,64,'rating','4');
INSERT INTO `wp_postmeta` VALUES (470,64,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (471,64,'reviewer_name','Mike T.');
INSERT INTO `wp_postmeta` VALUES (472,64,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (473,64,'reviewer_location','Albany, NY');
INSERT INTO `wp_postmeta` VALUES (474,64,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (475,64,'brand','11');
INSERT INTO `wp_postmeta` VALUES (476,64,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (477,65,'rating','3');
INSERT INTO `wp_postmeta` VALUES (478,65,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (479,65,'reviewer_name','Roberto G.');
INSERT INTO `wp_postmeta` VALUES (480,65,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (481,65,'reviewer_location','Charlotte, NC');
INSERT INTO `wp_postmeta` VALUES (482,65,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (483,65,'brand','11');
INSERT INTO `wp_postmeta` VALUES (484,65,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (485,66,'rating','5');
INSERT INTO `wp_postmeta` VALUES (486,66,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (487,66,'reviewer_name','Maya P.');
INSERT INTO `wp_postmeta` VALUES (488,66,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (489,66,'reviewer_location','Oklahoma City, OK');
INSERT INTO `wp_postmeta` VALUES (490,66,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (491,66,'brand','11');
INSERT INTO `wp_postmeta` VALUES (492,66,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (493,67,'rating','4');
INSERT INTO `wp_postmeta` VALUES (494,67,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (495,67,'reviewer_name','Kenji O.');
INSERT INTO `wp_postmeta` VALUES (496,67,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (497,67,'reviewer_location','Boston, MA');
INSERT INTO `wp_postmeta` VALUES (498,67,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (499,67,'brand','11');
INSERT INTO `wp_postmeta` VALUES (500,67,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (501,68,'rating','2');
INSERT INTO `wp_postmeta` VALUES (502,68,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (503,68,'reviewer_name','Sarah K.');
INSERT INTO `wp_postmeta` VALUES (504,68,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (505,68,'reviewer_location','Denver, CO');
INSERT INTO `wp_postmeta` VALUES (506,68,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (507,68,'brand','11');
INSERT INTO `wp_postmeta` VALUES (508,68,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (509,69,'rating','4');
INSERT INTO `wp_postmeta` VALUES (510,69,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (511,69,'reviewer_name','Anna R.');
INSERT INTO `wp_postmeta` VALUES (512,69,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (513,69,'reviewer_location','Portland, OR');
INSERT INTO `wp_postmeta` VALUES (514,69,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (515,69,'brand','11');
INSERT INTO `wp_postmeta` VALUES (516,69,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (517,70,'rating','3');
INSERT INTO `wp_postmeta` VALUES (518,70,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (519,70,'reviewer_name','David L.');
INSERT INTO `wp_postmeta` VALUES (520,70,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (521,70,'reviewer_location','Hartford, CT');
INSERT INTO `wp_postmeta` VALUES (522,70,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (523,70,'brand','11');
INSERT INTO `wp_postmeta` VALUES (524,70,'_brand','field_review_brand');
INSERT INTO `wp_postmeta` VALUES (525,71,'rating','4');
INSERT INTO `wp_postmeta` VALUES (526,71,'_rating','field_review_rating');
INSERT INTO `wp_postmeta` VALUES (527,71,'reviewer_name','Mike T.');
INSERT INTO `wp_postmeta` VALUES (528,71,'_reviewer_name','field_review_reviewer_name');
INSERT INTO `wp_postmeta` VALUES (529,71,'reviewer_location','Albany, NY');
INSERT INTO `wp_postmeta` VALUES (530,71,'_reviewer_location','field_review_reviewer_location');
INSERT INTO `wp_postmeta` VALUES (531,71,'brand','11');
INSERT INTO `wp_postmeta` VALUES (532,71,'_brand','field_review_brand');
/*!40000 ALTER TABLE `wp_postmeta` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `wp_posts`
--

DROP TABLE IF EXISTS `wp_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_posts` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_author` bigint(20) unsigned NOT NULL DEFAULT 0,
  `post_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content` longtext NOT NULL,
  `post_title` text NOT NULL,
  `post_excerpt` text NOT NULL,
  `post_status` varchar(20) NOT NULL DEFAULT 'publish',
  `comment_status` varchar(20) NOT NULL DEFAULT 'open',
  `ping_status` varchar(20) NOT NULL DEFAULT 'open',
  `post_password` varchar(255) NOT NULL DEFAULT '',
  `post_name` varchar(200) NOT NULL DEFAULT '',
  `to_ping` text NOT NULL,
  `pinged` text NOT NULL,
  `post_modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_modified_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content_filtered` longtext NOT NULL,
  `post_parent` bigint(20) unsigned NOT NULL DEFAULT 0,
  `guid` varchar(255) NOT NULL DEFAULT '',
  `menu_order` int(11) NOT NULL DEFAULT 0,
  `post_type` varchar(20) NOT NULL DEFAULT 'post',
  `post_mime_type` varchar(100) NOT NULL DEFAULT '',
  `comment_count` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`),
  KEY `post_name` (`post_name`(191)),
  KEY `type_status_date` (`post_type`,`post_status`,`post_date`,`ID`),
  KEY `post_parent` (`post_parent`),
  KEY `post_author` (`post_author`),
  KEY `type_status_author` (`post_type`,`post_status`,`post_author`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_posts`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `wp_posts` WRITE;
/*!40000 ALTER TABLE `wp_posts` DISABLE KEYS */;
INSERT INTO `wp_posts` VALUES (1,1,'2026-05-19 20:28:55','2026-05-19 20:28:55','<!-- wp:paragraph -->\n<p>Welcome to WordPress. This is your first post. Edit or delete it, then start writing!</p>\n<!-- /wp:paragraph -->','Hello world!','','publish','open','open','','hello-world','','','2026-05-19 20:28:55','2026-05-19 20:28:55','',0,'http://localhost:8080/?p=1',0,'post','',1);
INSERT INTO `wp_posts` VALUES (2,1,'2026-05-19 20:28:55','2026-05-19 20:28:55','<!-- wp:paragraph -->\n<p>This is an example page. It\'s different from a blog post because it will stay in one place and will show up in your site navigation (in most themes). Most people start with an About page that introduces them to potential site visitors. It might say something like this:</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:quote -->\n<blockquote class=\"wp-block-quote\">\n<!-- wp:paragraph -->\n<p>Hi there! I\'m a bike messenger by day, aspiring actor by night, and this is my website. I live in Los Angeles, have a great dog named Jack, and I like pi&#241;a coladas. (And gettin\' caught in the rain.)</p>\n<!-- /wp:paragraph -->\n</blockquote>\n<!-- /wp:quote -->\n\n<!-- wp:paragraph -->\n<p>...or something like this:</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:quote -->\n<blockquote class=\"wp-block-quote\">\n<!-- wp:paragraph -->\n<p>The XYZ Doohickey Company was founded in 1971, and has been providing quality doohickeys to the public ever since. Located in Gotham City, XYZ employs over 2,000 people and does all kinds of awesome things for the Gotham community.</p>\n<!-- /wp:paragraph -->\n</blockquote>\n<!-- /wp:quote -->\n\n<!-- wp:paragraph -->\n<p>As a new WordPress user, you should go to <a href=\"http://localhost:8080/wp-admin/\">your dashboard</a> to delete this page and create new pages for your content. Have fun!</p>\n<!-- /wp:paragraph -->','Sample Page','','publish','closed','open','','sample-page','','','2026-05-19 20:28:55','2026-05-19 20:28:55','',0,'http://localhost:8080/?page_id=2',0,'page','',0);
INSERT INTO `wp_posts` VALUES (3,1,'2026-05-19 20:28:55','2026-05-19 20:28:55','<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Who we are</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>Our website address is: http://localhost:8080.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Comments</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>When visitors leave comments on the site we collect the data shown in the comments form, and also the visitor&#8217;s IP address and browser user agent string to help spam detection.</p>\n<!-- /wp:paragraph -->\n<!-- wp:paragraph -->\n<p>An anonymized string created from your email address (also called a hash) may be provided to the Gravatar service to see if you are using it. The Gravatar service privacy policy is available here: https://automattic.com/privacy/. After approval of your comment, your profile picture is visible to the public in the context of your comment.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Media</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>If you upload images to the website, you should avoid uploading images with embedded location data (EXIF GPS) included. Visitors to the website can download and extract any location data from images on the website.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Cookies</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>If you leave a comment on our site you may opt-in to saving your name, email address and website in cookies. These are for your convenience so that you do not have to fill in your details again when you leave another comment. These cookies will last for one year.</p>\n<!-- /wp:paragraph -->\n<!-- wp:paragraph -->\n<p>If you visit our login page, we will set a temporary cookie to determine if your browser accepts cookies. This cookie contains no personal data and is discarded when you close your browser.</p>\n<!-- /wp:paragraph -->\n<!-- wp:paragraph -->\n<p>When you log in, we will also set up several cookies to save your login information and your screen display choices. Login cookies last for two days, and screen options cookies last for a year. If you select &quot;Remember Me&quot;, your login will persist for two weeks. If you log out of your account, the login cookies will be removed.</p>\n<!-- /wp:paragraph -->\n<!-- wp:paragraph -->\n<p>If you edit or publish an article, an additional cookie will be saved in your browser. This cookie includes no personal data and simply indicates the post ID of the article you just edited. It expires after 1 day.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Embedded content from other websites</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>Articles on this site may include embedded content (e.g. videos, images, articles, etc.). Embedded content from other websites behaves in the exact same way as if the visitor has visited the other website.</p>\n<!-- /wp:paragraph -->\n<!-- wp:paragraph -->\n<p>These websites may collect data about you, use cookies, embed additional third-party tracking, and monitor your interaction with that embedded content, including tracking your interaction with the embedded content if you have an account and are logged in to that website.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Who we share your data with</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>If you request a password reset, your IP address will be included in the reset email.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">How long we retain your data</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>If you leave a comment, the comment and its metadata are retained indefinitely. This is so we can recognize and approve any follow-up comments automatically instead of holding them in a moderation queue.</p>\n<!-- /wp:paragraph -->\n<!-- wp:paragraph -->\n<p>For users that register on our website (if any), we also store the personal information they provide in their user profile. All users can see, edit, or delete their personal information at any time (except they cannot change their username). Website administrators can also see and edit that information.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">What rights you have over your data</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>If you have an account on this site, or have left comments, you can request to receive an exported file of the personal data we hold about you, including any data you have provided to us. You can also request that we erase any personal data we hold about you. This does not include any data we are obliged to keep for administrative, legal, or security purposes.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Where your data is sent</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>Visitor comments may be checked through an automated spam detection service.</p>\n<!-- /wp:paragraph -->\n','Privacy Policy','','draft','closed','open','','privacy-policy','','','2026-05-19 20:28:55','2026-05-19 20:28:55','',0,'http://localhost:8080/?page_id=3',0,'page','',0);
INSERT INTO `wp_posts` VALUES (4,0,'2026-05-19 20:29:00','2026-05-19 20:29:00','<p>Welcome to our independent brand reviews directory.</p>','Home','','publish','closed','closed','','home','','','2026-05-19 20:29:00','2026-05-19 20:29:00','',0,'http://localhost:8080/home/',0,'page','',0);
INSERT INTO `wp_posts` VALUES (5,0,'2026-05-19 20:29:01','2026-05-19 20:29:01','<p>We collect honest customer reviews of consumer brands across insurance, telecom, finance, home services, and retail. All reviews are written by real users and are not influenced by the brands themselves.</p><p>This site is sample data for an interview challenge.</p>','About','','publish','closed','closed','','about','','','2026-05-19 20:29:01','2026-05-19 20:29:01','',0,'http://localhost:8080/about/',0,'page','',0);
INSERT INTO `wp_posts` VALUES (6,0,'2026-05-19 20:29:01','2026-05-19 20:29:01','<p>Email us at hello@example.com</p>','Contact','','publish','closed','closed','','contact','','','2026-05-19 20:29:01','2026-05-19 20:29:01','',0,'http://localhost:8080/contact/',0,'page','',0);
INSERT INTO `wp_posts` VALUES (7,0,'2026-05-19 20:29:02','2026-05-19 20:29:02','<p>Acme Insurance is a long-running general-lines insurer offering auto, home, and umbrella coverage across 38 US states. The company was founded in Hartford, Connecticut in 1985 and operates through a network of approximately 1,200 independent agents.</p><p>Acme is best known for its agent-led model and strong claims response times. Their flagship product is the bundled auto + home policy, which accounts for roughly 60% of their book of business. The company also writes commercial lines for small businesses, though that\'s a smaller segment.</p><p>Acme is rated A (Excellent) by AM Best and has paid dividends to policyholders in 38 of the last 40 years through its participating insurance products.</p>','Acme Insurance Co.','','publish','closed','closed','','acme-insurance','','','2026-05-19 20:29:02','2026-05-19 20:29:02','',0,'http://localhost:8080/brand/acme-insurance/',0,'brand','',0);
INSERT INTO `wp_posts` VALUES (8,0,'2026-05-19 20:29:04','2026-05-19 20:29:04','<p>PrimePath Bank is a regional retail bank operating 220 branches across the Northeast United States. Founded in 1978 and headquartered in New York City, PrimePath offers personal checking, savings, mortgages, auto loans, and small-business banking.</p><p>The bank is FDIC-insured and is considered a mid-tier regional player with approximately $48 billion in assets. PrimePath has invested significantly in mobile banking over the past three years, though customer reviews suggest the app still trails the national banks in polish.</p><p>PrimePath is known for relatively competitive mortgage rates and a strong physical branch network in markets where the major banks have been closing locations.</p>','PrimePath Bank','','publish','closed','closed','','primepath-bank','','','2026-05-19 20:29:04','2026-05-19 20:29:04','',0,'http://localhost:8080/brand/primepath-bank/',0,'brand','',0);
INSERT INTO `wp_posts` VALUES (9,0,'2026-05-19 20:29:06','2026-05-19 20:29:06','<p>HomeShield Pro sells home warranty contracts that cover repair and replacement costs for HVAC systems, major appliances, and plumbing. The company was founded in 1999 in Atlanta, Georgia and serves homeowners in 47 states.</p><p>HomeShield Pro offers three tiers of coverage: a basic systems plan, a basic appliances plan, and a combined plan that bundles both. Service is delivered through a network of approximately 25,000 pre-vetted contractors. Customers pay a flat service fee (typically $75-$125) per claim regardless of the actual repair cost.</p><p>The company is one of the largest home warranty providers in the United States and is a frequent subject of consumer complaints related to claim denials and contract exclusions — themes that show up in the customer reviews below.</p>','HomeShield Pro','','publish','closed','closed','','homeshield-pro','','','2026-05-19 20:29:06','2026-05-19 20:29:06','',0,'http://localhost:8080/brand/homeshield-pro/',0,'brand','',0);
INSERT INTO `wp_posts` VALUES (10,0,'2026-05-19 20:29:08','2026-05-19 20:29:08','<p>SwiftStream Internet is a fixed wireless ISP serving suburban and rural markets in the American Southwest. Founded in 2014 and headquartered in Austin, Texas, SwiftStream operates approximately 400 wireless tower sites across Texas, New Mexico, Arizona, and parts of Oklahoma.</p><p>SwiftStream\'s value proposition is bringing reliable broadband to areas that don\'t have cable or fiber service. Speeds range from 25 Mbps on the entry tier to 100 Mbps on the top residential plan. The technology requires line-of-sight to a tower, which limits availability within their nominal coverage areas.</p><p>Customer reviews are bimodal: rural customers without cable alternatives tend to rate them highly, while reviewers who compare them to wired broadband are more critical, particularly around weather-related outages.</p>','SwiftStream Internet','','publish','closed','closed','','swiftstream-internet','','','2026-05-19 20:29:08','2026-05-19 20:29:08','',0,'http://localhost:8080/brand/swiftstream-internet/',0,'brand','',0);
INSERT INTO `wp_posts` VALUES (11,0,'2026-05-19 20:29:10','2026-05-19 20:29:10','<p>UrbanRetail Co. is a multi-category online retailer offering apparel, home goods, kitchen products, and small electronics. The company was founded in 2005 in Seattle and ships to customers throughout North America from three regional fulfillment centers.</p><p>UrbanRetail operates a marketplace model where roughly 70% of inventory is supplied by third-party brands and 30% is their own private-label products. The company is known for fast shipping (typically two-day standard) and a relatively generous return policy.</p><p>Customer sentiment in reviews tends to vary by category — home goods and kitchen products score consistently well, while private-label apparel is more frequently cited as inconsistent in quality. Promotional pricing practices around major shopping events are a recurring complaint.</p>','UrbanRetail Co.','','publish','closed','closed','','urbanretail-co','','','2026-05-19 20:29:10','2026-05-19 20:29:10','',0,'http://localhost:8080/brand/urbanretail-co/',0,'brand','',0);
INSERT INTO `wp_posts` VALUES (12,2,'2026-05-19 20:29:13','2026-05-19 20:29:13','<p>Got rear-ended in a grocery store parking lot last March. Filed the claim online in about 10 minutes — uploaded photos, described what happened, and that was it. An adjuster called me the next morning. Rental car was set up that afternoon. The body shop they recommended was professional and the car came back looking new. Total time from accident to having my car back was 11 days, which felt reasonable for the amount of damage. Rate stayed flat at renewal. No complaints.</p>','Smooth auto claim after a parking-lot fender bender','','publish','closed','closed','','smooth-auto-claim-after-a-parking-lot-fender-bender','','','2026-05-19 20:29:13','2026-05-19 20:29:13','',0,'http://localhost:8080/review/smooth-auto-claim-after-a-parking-lot-fender-bender/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (13,3,'2026-05-19 20:29:15','2026-05-19 20:29:15','<p>Acme has been fine for me personally, but when I added my 22-year-old son to the policy the quote came in 40% higher than two other carriers I checked. I get that young drivers are expensive, but the gap was too big to ignore. He\'s now insured elsewhere. The split isn\'t ideal for paperwork but it\'s saving us about $1,800/year.</p>','Decent coverage but pricey for younger drivers','','publish','closed','closed','','decent-coverage-but-pricey-for-younger-drivers','','','2026-05-19 20:29:15','2026-05-19 20:29:15','',0,'http://localhost:8080/review/decent-coverage-but-pricey-for-younger-drivers/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (14,4,'2026-05-19 20:29:16','2026-05-19 20:29:16','<p>A tree came down on our detached garage during a derecho last summer. My local Acme agent walked me through everything personally — called twice in the first 48 hours to check in, helped me find a tree service that could handle the removal, and made sure the adjuster had everything they needed. That kind of service is hard to find now. We\'ve been with this agent for 14 years and I won\'t switch.</p>','Agent was a lifesaver during the storm','','publish','closed','closed','','agent-was-a-lifesaver-during-the-storm','','','2026-05-19 20:29:16','2026-05-19 20:29:16','',0,'http://localhost:8080/review/agent-was-a-lifesaver-during-the-storm/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (15,5,'2026-05-19 20:29:18','2026-05-19 20:29:18','<p>No claims, no tickets, exactly the same coverage I\'ve had for six years. Renewal came in 18% higher than last year. Called the agent and the answer was basically \"the whole market is up.\" Maybe true but I expected a more substantive explanation given the loyalty. Shopping around this cycle.</p>','Renewal sticker shock with no explanation','','publish','closed','closed','','renewal-sticker-shock-with-no-explanation','','','2026-05-19 20:29:18','2026-05-19 20:29:18','',0,'http://localhost:8080/review/renewal-sticker-shock-with-no-explanation/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (16,6,'2026-05-19 20:29:19','2026-05-19 20:29:19','<p>We had a separate home and auto carrier for years and finally bundled with Acme. The savings were genuine — about $640 a year combined. The transition was painless; their team handled cancellation of the old policies. The home policy is actually broader than what we had before. I\'d recommend this to anyone with both a home and a car.</p>','Bundled home and auto, saved real money','','publish','closed','closed','','bundled-home-and-auto-saved-real-money','','','2026-05-19 20:29:19','2026-05-19 20:29:19','',0,'http://localhost:8080/review/bundled-home-and-auto-saved-real-money/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (17,7,'2026-05-19 20:29:21','2026-05-19 20:29:21','<p>Coverage is fine but every time I need to call the 800 number I\'m on hold 25+ minutes. Local agent is responsive but not always available for billing questions. They need to staff up the call center or push more self-service.</p>','Long hold times on the support line','','publish','closed','closed','','long-hold-times-on-the-support-line','','','2026-05-19 20:29:21','2026-05-19 20:29:21','',0,'http://localhost:8080/review/long-hold-times-on-the-support-line/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (18,8,'2026-05-19 20:29:22','2026-05-19 20:29:22','<p>My car was totaled in a hailstorm. I had a check in hand 14 days after the inspection. The number was fair — within $200 of what KBB suggested. The whole process was easier than I expected for a total loss claim. Switched my newer car to Acme too.</p>','Quick payout on a totaled vehicle','','publish','closed','closed','','quick-payout-on-a-totaled-vehicle','','','2026-05-19 20:29:22','2026-05-19 20:29:22','',0,'http://localhost:8080/review/quick-payout-on-a-totaled-vehicle/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (19,9,'2026-05-19 20:29:24','2026-05-19 20:29:24','<p>Coverage and pricing are competitive. The online portal is a disaster — slow, ugly, missing features the app has. I do everything through the mobile app or by calling. They should retire the portal entirely or rebuild it.</p>','Online portal feels like 2010','','publish','closed','closed','','online-portal-feels-like-2010','','','2026-05-19 20:29:24','2026-05-19 20:29:24','',0,'http://localhost:8080/review/online-portal-feels-like-2010/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (20,2,'2026-05-19 20:29:26','2026-05-19 20:29:26','<p>Added a $1M umbrella policy. The process was completely painless — about 15 minutes on a phone call with my agent, paperwork emailed for e-signature the same day. Pricing was competitive with what I\'d seen quoted elsewhere. Peace of mind for not much money.</p>','Umbrella policy was easy to add','','publish','closed','closed','','umbrella-policy-was-easy-to-add','','','2026-05-19 20:29:26','2026-05-19 20:29:26','',0,'http://localhost:8080/review/umbrella-policy-was-easy-to-add/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (21,3,'2026-05-19 20:29:27','2026-05-19 20:29:27','<p>Cracked windshield. Got bounced between the glass shop and Acme three different times trying to figure out who was paying what. Eventually got fixed but I shouldn\'t have to coordinate that myself. Two stars docked for the experience even though it ultimately got resolved.</p>','Glass claim handling was confusing','','publish','closed','closed','','glass-claim-handling-was-confusing','','','2026-05-19 20:29:27','2026-05-19 20:29:27','',0,'http://localhost:8080/review/glass-claim-handling-was-confusing/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (22,4,'2026-05-19 20:29:29','2026-05-19 20:29:29','<p>Enrolled in their telematics program. Drove the way I always drive. After six months my premium dropped 14%. That\'s real money. The app is just OK but it does the job and isn\'t intrusive.</p>','Discount for safe driving was real','','publish','closed','closed','','discount-for-safe-driving-was-real','','','2026-05-19 20:29:29','2026-05-19 20:29:29','',0,'http://localhost:8080/review/discount-for-safe-driving-was-real/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (23,5,'2026-05-19 20:29:31','2026-05-19 20:29:31','<p>I\'ve had Acme for three years. Never filed a claim. Premium is on the higher side of fair. App works. Agent is responsive enough. I don\'t have strong feelings either way, which I guess is what you want from insurance.</p>','Fine but nothing special','','publish','closed','closed','','fine-but-nothing-special','','','2026-05-19 20:29:31','2026-05-19 20:29:31','',0,'http://localhost:8080/review/fine-but-nothing-special/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (24,6,'2026-05-19 20:29:32','2026-05-19 20:29:32','<p>I do most banking online but having a real branch I can walk into for the unusual stuff makes a difference. Tellers at my local branch know my name. When I needed a notarized document and a cashier\'s check the same day, it was a 15-minute visit. That\'s increasingly hard to find.</p>','Branches still matter and they have them','','publish','closed','closed','','branches-still-matter-and-they-have-them','','','2026-05-19 20:29:32','2026-05-19 20:29:32','',0,'http://localhost:8080/review/branches-still-matter-and-they-have-them/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (25,3,'2026-05-19 20:29:34','2026-05-19 20:29:34','<p>App is functional but feels like 2014. Mobile deposit fails about 1 in 5 times for me — usually it can\'t read the back endorsement. Login flow is slow. Big banks have spoiled me on apps and PrimePath is noticeably behind.</p>','Mobile app feels dated','','publish','closed','closed','','mobile-app-feels-dated','','','2026-05-19 20:29:34','2026-05-19 20:29:34','',0,'http://localhost:8080/review/mobile-app-feels-dated/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (26,2,'2026-05-19 20:29:36','2026-05-19 20:29:36','<p>Our loan officer was excellent — patient with first-time-buyer questions, transparent on fees, and the final rate came in 0.5% under the best online lender we were comparing against. Close-of-loan went smoothly. Their mortgage operation is one of the strongest things about this bank.</p>','Got a great rate on our mortgage','','publish','closed','closed','','got-a-great-rate-on-our-mortgage','','','2026-05-19 20:29:36','2026-05-19 20:29:36','',0,'http://localhost:8080/review/got-a-great-rate-on-our-mortgage/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (27,7,'2026-05-19 20:29:38','2026-05-19 20:29:38','<p>Got hit with two $35 overdraft fees in one weekend on transactions that posted out of order. Bank\'s position is that this is standard practice. It might be standard but it doesn\'t feel right. Looking at credit unions now.</p>','Overdraft policy is aggressive','','publish','closed','closed','','overdraft-policy-is-aggressive','','','2026-05-19 20:29:38','2026-05-19 20:29:38','',0,'http://localhost:8080/review/overdraft-policy-is-aggressive/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (28,4,'2026-05-19 20:29:40','2026-05-19 20:29:40','<p>When we opened our accounts they assigned us a personal banker. I assumed this was theater. Turns out he actually answers his direct line and remembers our situation. Set up a HELOC with him over two short calls. The relationship-banking thing is real here, at least at this branch.</p>','Personal banker actually returns calls','','publish','closed','closed','','personal-banker-actually-returns-calls','','','2026-05-19 20:29:40','2026-05-19 20:29:40','',0,'http://localhost:8080/review/personal-banker-actually-returns-calls/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (29,5,'2026-05-19 20:29:41','2026-05-19 20:29:41','<p>Their savings rate is 0.05% while online banks are offering 4%+. PrimePath knows their depositors are sticky and prices accordingly. I keep my emergency fund elsewhere now and just use PrimePath for checking. Decent bank, bad savings product.</p>','Savings rate is uncompetitive','','publish','closed','closed','','savings-rate-is-uncompetitive','','','2026-05-19 20:29:41','2026-05-19 20:29:41','',0,'http://localhost:8080/review/savings-rate-is-uncompetitive/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (30,8,'2026-05-19 20:29:43','2026-05-19 20:29:43','<p>Opened a small business account two years ago. The branch handles cash deposits, the business cards arrive promptly, fees are predictable. Their cash-management product isn\'t cutting-edge but it works. We\'ve been happy enough to stay.</p>','Small business banking has been solid','','publish','closed','closed','','small-business-banking-has-been-solid','','','2026-05-19 20:29:43','2026-05-19 20:29:43','',0,'http://localhost:8080/review/small-business-banking-has-been-solid/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (31,9,'2026-05-19 20:29:45','2026-05-19 20:29:45','<p>Pre-approved online, then the dealer ran into issues uploading documents to their portal, which delayed closing by three days. Eventually got the car. The rate was fine. The friction with the dealer was not.</p>','Auto loan process was painful','','publish','closed','closed','','auto-loan-process-was-painful','','','2026-05-19 20:29:45','2026-05-19 20:29:45','',0,'http://localhost:8080/review/auto-loan-process-was-painful/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (32,6,'2026-05-19 20:29:46','2026-05-19 20:29:46','<p>Needed three documents notarized for an estate. Walked into the branch, the banker did it on the spot, didn\'t charge me. Try getting that anywhere else. Little things matter.</p>','Free notary services at the branch','','publish','closed','closed','','free-notary-services-at-the-branch','','','2026-05-19 20:29:46','2026-05-19 20:29:46','',0,'http://localhost:8080/review/free-notary-services-at-the-branch/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (33,2,'2026-05-19 20:29:48','2026-05-19 20:29:48','<p>$35 for a domestic outgoing wire, $50 for international. That\'s well above what online banks charge. Most of the time it doesn\'t matter, but for closing a real estate transaction it adds up. Negotiated it down twice with my banker but it shouldn\'t require that.</p>','Wire transfer fees are high','','publish','closed','closed','','wire-transfer-fees-are-high','','','2026-05-19 20:29:48','2026-05-19 20:29:48','',0,'http://localhost:8080/review/wire-transfer-fees-are-high/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (34,3,'2026-05-19 20:29:50','2026-05-19 20:29:50','<p>Approved for a HELOC in under two weeks. Documentation was reasonable. The rate is variable, which I knew going in. Funded for a kitchen reno and it\'s been straightforward to draw on. Customer service has been responsive when I\'ve called.</p>','Quick HELOC approval','','publish','closed','closed','','quick-heloc-approval','','','2026-05-19 20:29:50','2026-05-19 20:29:50','',0,'http://localhost:8080/review/quick-heloc-approval/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (35,7,'2026-05-19 20:29:51','2026-05-19 20:29:51','<p>Walked into a branch on vacation in another state. They handled my issue (replacing a debit card lost in a rental car) in 20 minutes. Pleasant, professional, didn\'t try to upsell. The branch experience is genuinely good.</p>','Tellers and managers are well-trained','','publish','closed','closed','','tellers-and-managers-are-well-trained','','','2026-05-19 20:29:51','2026-05-19 20:29:51','',0,'http://localhost:8080/review/tellers-and-managers-are-well-trained/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (36,2,'2026-05-19 20:29:53','2026-05-19 20:29:53','<p>The compressor on our AC died during a heat wave. HomeShield dispatched a contractor within 48 hours and approved a full replacement of the outdoor unit. With the service fee we paid about $125 for a repair that would have cost us roughly $4,200 out of pocket. The plan has paid for itself many times over already.</p>','Covered a dead AC unit in July — worth the cost','','publish','closed','closed','','covered-a-dead-ac-unit-in-july-worth-the-cost','','','2026-05-19 20:29:53','2026-05-19 20:29:53','',0,'http://localhost:8080/review/covered-a-dead-ac-unit-in-july-worth-the-cost/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (37,5,'2026-05-19 20:29:55','2026-05-19 20:29:55','<p>They denied my dishwasher claim citing pre-existing wear. The contractor\'s inspection notes were vague and didn\'t really support the denial. Appealed and got nowhere. Read the contract very carefully before signing — the list of exclusions is long.</p>','Lots of exclusions buried in the fine print','','publish','closed','closed','','lots-of-exclusions-buried-in-the-fine-print','','','2026-05-19 20:29:55','2026-05-19 20:29:55','',0,'http://localhost:8080/review/lots-of-exclusions-buried-in-the-fine-print/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (38,4,'2026-05-19 20:29:57','2026-05-19 20:29:57','<p>Used HomeShield three times in two years — garbage disposal, dryer heating element, kitchen faucet. All handled, all under the service fee. The contractors they sent were on time and professional. Not flashy, but it works for the routine stuff.</p>','Reliable for routine appliance failures','','publish','closed','closed','','reliable-for-routine-appliance-failures','','','2026-05-19 20:29:57','2026-05-19 20:29:57','',0,'http://localhost:8080/review/reliable-for-routine-appliance-failures/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (39,3,'2026-05-19 20:30:00','2026-05-19 20:30:00','<p>Filed a claim for a leaking water heater. Waited four days for the plumber to come out. By then I\'d already had to shut the water off and arrange alternate hot water. The plumber was fine when they finally arrived but the dispatch SLA needs work.</p>','Long wait for plumber dispatch','','publish','closed','closed','','long-wait-for-plumber-dispatch','','','2026-05-19 20:30:00','2026-05-19 20:30:00','',0,'http://localhost:8080/review/long-wait-for-plumber-dispatch/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (40,6,'2026-05-19 20:30:02','2026-05-19 20:30:02','<p>Compressor went on a 9-year-old fridge. The technician determined it was non-repairable. HomeShield approved a replacement and gave us a check for the depreciated value, plus credits toward delivery and removal. The new fridge cost us about $400 out of pocket. Acceptable outcome.</p>','Refrigerator replacement was approved','','publish','closed','closed','','refrigerator-replacement-was-approved','','','2026-05-19 20:30:02','2026-05-19 20:30:02','',0,'http://localhost:8080/review/refrigerator-replacement-was-approved/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (41,7,'2026-05-19 20:30:04','2026-05-19 20:30:04','<p>Of the four contractors HomeShield has sent us over two years, two were excellent and two were sloppy. One left a worse mess than they fixed (don\'t ask). The hit rate is too random for what we pay.</p>','Contractor quality is inconsistent','','publish','closed','closed','','contractor-quality-is-inconsistent','','','2026-05-19 20:30:04','2026-05-19 20:30:04','',0,'http://localhost:8080/review/contractor-quality-is-inconsistent/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (42,8,'2026-05-19 20:30:05','2026-05-19 20:30:05','<p>Tried to cancel after our coverage year ended. They had auto-enrolled us in a new term at a higher rate three weeks before the renewal date. Eventually got the cancellation processed but it required a phone call and a strongly worded email. Read your renewal letter.</p>','Cancellation policy is sneaky','','publish','closed','closed','','cancellation-policy-is-sneaky','','','2026-05-19 20:30:05','2026-05-19 20:30:05','',0,'http://localhost:8080/review/cancellation-policy-is-sneaky/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (43,9,'2026-05-19 20:30:07','2026-05-19 20:30:07','<p>The annual HVAC tune-up included in our plan is worth about half the premium on its own. Technician this year caught a capacitor that was starting to bulge and replaced it as part of the visit. Probably saved us a summer service call.</p>','HVAC tune-up included is a real perk','','publish','closed','closed','','hvac-tune-up-included-is-a-real-perk','','','2026-05-19 20:30:07','2026-05-19 20:30:07','',0,'http://localhost:8080/review/hvac-tune-up-included-is-a-real-perk/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (44,5,'2026-05-19 20:30:08','2026-05-19 20:30:08','<p>Garbage disposal stopped working. Contractor said the unit needed replacement. HomeShield denied the claim citing improper installation by a prior owner. There is no way for me to prove or disprove that. Felt like a pretextual denial. Eventually fixed it myself.</p>','Denied a clearly covered claim','','publish','closed','closed','','denied-a-clearly-covered-claim','','','2026-05-19 20:30:08','2026-05-19 20:30:08','',0,'http://localhost:8080/review/denied-a-clearly-covered-claim/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (45,4,'2026-05-19 20:30:10','2026-05-19 20:30:10','<p>Added the optional pool/spa coverage. The pool pump died in year one. Replacement plus labor would have been $2,800 out of pocket. We paid the service fee and a small upgrade differential. The pool coverage tier specifically has been a great value for us.</p>','Pool equipment add-on saved us a fortune','','publish','closed','closed','','pool-equipment-add-on-saved-us-a-fortune','','','2026-05-19 20:30:10','2026-05-19 20:30:10','',0,'http://localhost:8080/review/pool-equipment-add-on-saved-us-a-fortune/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (46,2,'2026-05-19 20:30:12','2026-05-19 20:30:12','<p>Hold times average 35-45 minutes whenever I call. Chat is no faster. Filed claims and follow-ups via email are at least answered the next business day. If you have time-sensitive issues this is frustrating.</p>','Customer service hold times are brutal','','publish','closed','closed','','customer-service-hold-times-are-brutal','','','2026-05-19 20:30:12','2026-05-19 20:30:12','',0,'http://localhost:8080/review/customer-service-hold-times-are-brutal/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (47,7,'2026-05-19 20:30:13','2026-05-19 20:30:13','<p>Our first-year price was $48/mo. Renewal came in at $104/mo with no changes to coverage. When I called, the rep offered to bring it down to $78 if I committed for two years. Felt like a car-dealership negotiation. Switched to a competitor.</p>','Renewal pricing more than doubled','','publish','closed','closed','','renewal-pricing-more-than-doubled','','','2026-05-19 20:30:13','2026-05-19 20:30:13','',0,'http://localhost:8080/review/renewal-pricing-more-than-doubled/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (48,2,'2026-05-19 20:30:15','2026-05-19 20:30:15','<p>I\'m 12 miles outside town with no cable. SwiftStream is night-and-day better than the satellite service we suffered with for years. Video calls work, the kids can stream, and we don\'t get throttled to dial-up speeds after 50GB. It\'s not gigabit but for our area it\'s transformational.</p>','Finally an option that isn\'t satellite','','publish','closed','closed','','finally-an-option-that-isnt-satellite','','','2026-05-19 20:30:15','2026-05-19 20:30:15','',0,'http://localhost:8080/review/finally-an-option-that-isnt-satellite/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (49,3,'2026-05-19 20:30:17','2026-05-19 20:30:17','<p>Speeds are fine when it works. But any storm and we\'re offline for hours. Tech says that\'s just how fixed wireless behaves. I get that, but it makes anything time-sensitive (work calls, telehealth) unreliable.</p>','Drops out every time it rains','','publish','closed','closed','','drops-out-every-time-it-rains','','','2026-05-19 20:30:17','2026-05-19 20:30:17','',0,'http://localhost:8080/review/drops-out-every-time-it-rains/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (50,5,'2026-05-19 20:30:18','2026-05-19 20:30:18','<p>Pings are higher than wired connections. Gaming and video calls are usable but not great. For browsing and streaming it\'s perfectly adequate. If you have an alternative, evaluate carefully; if you don\'t, SwiftStream is the best you\'ll do.</p>','Acceptable rural option, not a city replacement','','publish','closed','closed','','acceptable-rural-option-not-a-city-replacement','','','2026-05-19 20:30:18','2026-05-19 20:30:18','',0,'http://localhost:8080/review/acceptable-rural-option-not-a-city-replacement/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (51,4,'2026-05-19 20:30:20','2026-05-19 20:30:20','<p>The install took about 3 hours. Crew was on time, walked me through the antenna placement options, mounted it cleanly, and made sure I had a stable signal before they left. The price is what it is for rural service — install was the bright spot.</p>','Install crew was professional','','publish','closed','closed','','install-crew-was-professional','','','2026-05-19 20:30:20','2026-05-19 20:30:20','',0,'http://localhost:8080/review/install-crew-was-professional/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (52,6,'2026-05-19 20:30:22','2026-05-19 20:30:22','<p>I pay for the 100 Mbps tier. Most days I see 45-60 Mbps. Tech told me the tower is oversubscribed. They keep saying they\'ll add capacity. I have been hearing that for 14 months.</p>','Speed advertised vs delivered','','publish','closed','closed','','speed-advertised-vs-delivered','','','2026-05-19 20:30:22','2026-05-19 20:30:22','',0,'http://localhost:8080/review/speed-advertised-vs-delivered/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (53,7,'2026-05-19 20:30:23','2026-05-19 20:30:23','<p>Called support twice in the last year. Both reps were patient, knowledgeable, and didn\'t read from a script. They sent a tech out to re-aim my antenna when speeds dropped and refused to charge me for the visit. Refreshing.</p>','Customer service is unusually helpful','','publish','closed','closed','','customer-service-is-unusually-helpful','','','2026-05-19 20:30:23','2026-05-19 20:30:23','',0,'http://localhost:8080/review/customer-service-is-unusually-helpful/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (54,8,'2026-05-19 20:30:25','2026-05-19 20:30:25','<p>The plan I\'m on caps at 750 GB. Between two adults working from home with Zoom all day, plus normal evening streaming, we blow past that consistently. Overage charges aren\'t insane but the unlimited plan is significantly more expensive. Wish there was a middle tier.</p>','Data caps make remote work hard','','publish','closed','closed','','data-caps-make-remote-work-hard','','','2026-05-19 20:30:25','2026-05-19 20:30:25','',0,'http://localhost:8080/review/data-caps-make-remote-work-hard/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (55,9,'2026-05-19 20:30:26','2026-05-19 20:30:26','<p>I assumed fixed wireless would be terrible for online gaming. Pings to most US servers run 35-55 ms. That\'s perfectly playable. Not as low as the cable I had in the city but well within the acceptable range. Pleasantly surprised.</p>','Better latency than expected','','publish','closed','closed','','better-latency-than-expected','','','2026-05-19 20:30:26','2026-05-19 20:30:26','',0,'http://localhost:8080/review/better-latency-than-expected/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (56,2,'2026-05-19 20:30:28','2026-05-19 20:30:28','<p>Big outage during a winter storm took down our entire area for almost 18 hours. Their status page wasn\'t updated for the first 8 hours of that. When I finally got a person on the line they were apologetic and credited the day. The communication during outages needs work.</p>','Outage support could be better','','publish','closed','closed','','outage-support-could-be-better','','','2026-05-19 20:30:28','2026-05-19 20:30:28','',0,'http://localhost:8080/review/outage-support-could-be-better/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (57,4,'2026-05-19 20:30:30','2026-05-19 20:30:30','<p>If my only choice is SwiftStream or no usable internet, I\'ll pick SwiftStream every time. They are doing the work of bringing real broadband to places the big telecoms have ignored for 25 years. That\'s worth a lot to me.</p>','Reasonable for the alternative','','publish','closed','closed','','reasonable-for-the-alternative','','','2026-05-19 20:30:30','2026-05-19 20:30:30','',0,'http://localhost:8080/review/reasonable-for-the-alternative/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (58,5,'2026-05-19 20:30:32','2026-05-19 20:30:32','<p>The monthly equipment rental for the antenna/router is $15. Over the 24-month minimum that\'s $360 to lease hardware. I asked to buy it outright and they wouldn\'t sell it. Annoying.</p>','Equipment fee feels excessive','','publish','closed','closed','','equipment-fee-feels-excessive','','','2026-05-19 20:30:32','2026-05-19 20:30:32','',0,'http://localhost:8080/review/equipment-fee-feels-excessive/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (59,3,'2026-05-19 20:30:33','2026-05-19 20:30:33','<p>I had AT&T 6 Mbps DSL before this. SwiftStream is roughly 12x faster for similar money. I would not choose them in a market with cable or fiber, but they have been a meaningful upgrade for my rural address.</p>','Best ISP option in my zip code','','publish','closed','closed','','best-isp-option-in-my-zip-code','','','2026-05-19 20:30:33','2026-05-19 20:30:33','',0,'http://localhost:8080/review/best-isp-option-in-my-zip-code/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (60,2,'2026-05-19 20:30:35','2026-05-19 20:30:35','<p>I order most weeks. Standard shipping reliably arrives in 2 business days. Returns are easy through the app — print the label, drop it off, money back in 3-4 days. The selection runs deep across the categories I care about.</p>','Selection is huge, shipping is fast','','publish','closed','closed','','selection-is-huge-shipping-is-fast','','','2026-05-19 20:30:35','2026-05-19 20:30:35','',0,'http://localhost:8080/review/selection-is-huge-shipping-is-fast/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (61,5,'2026-05-19 20:30:36','2026-05-19 20:30:36','<p>Their house-brand t-shirts shrink badly after one wash. Outside brands sold on the same site are perfectly fine. Read the brand before you buy — if it\'s their private label, expect inconsistent sizing and durability.</p>','Quality is hit or miss on private-label apparel','','publish','closed','closed','','quality-is-hit-or-miss-on-private-label-apparel','','','2026-05-19 20:30:36','2026-05-19 20:30:36','',0,'http://localhost:8080/review/quality-is-hit-or-miss-on-private-label-apparel/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (62,6,'2026-05-19 20:30:38','2026-05-19 20:30:38','<p>A pair of headphones arrived DOA. I emailed support and the replacement was at my door before I\'d even shipped the broken pair back. They sent a return label with the replacement and didn\'t ask me to do anything more. Service like that earns loyalty.</p>','Customer service won me back','','publish','closed','closed','','customer-service-won-me-back','','','2026-05-19 20:30:38','2026-05-19 20:30:38','',0,'http://localhost:8080/review/customer-service-won-me-back/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (63,4,'2026-05-19 20:30:39','2026-05-19 20:30:39','<p>I tracked a coffee maker for two weeks leading up to their Black Friday sale. The \'Black Friday\' price was actually $8 higher than the regular price the week before. I get that this is common practice but it\'s still frustrating to watch in real time.</p>','Pricing games on Black Friday','','publish','closed','closed','','pricing-games-on-black-friday','','','2026-05-19 20:30:39','2026-05-19 20:30:39','',0,'http://localhost:8080/review/pricing-games-on-black-friday/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (64,3,'2026-05-19 20:30:41','2026-05-19 20:30:41','<p>Bedding, kitchen tools, small appliances — consistently great quality and pricing. I now buy almost all my home category items here. Sticking to those categories and ignoring their apparel has been a winning strategy.</p>','Solid for home goods specifically','','publish','closed','closed','','solid-for-home-goods-specifically','','','2026-05-19 20:30:41','2026-05-19 20:30:41','',0,'http://localhost:8080/review/solid-for-home-goods-specifically/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (65,7,'2026-05-19 20:30:43','2026-05-19 20:30:43','<p>Bought what turned out to be a counterfeit electronics accessory from a marketplace seller listed on UrbanRetail. They processed the refund without much hassle, but it was clear the QA on third-party sellers is thin. I now stick to items sold and shipped by UrbanRetail directly.</p>','Counterfeit risk with marketplace sellers','','publish','closed','closed','','counterfeit-risk-with-marketplace-sellers','','','2026-05-19 20:30:43','2026-05-19 20:30:43','',0,'http://localhost:8080/review/counterfeit-risk-with-marketplace-sellers/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (66,8,'2026-05-19 20:30:44','2026-05-19 20:30:44','<p>The mobile app is well designed. Search is fast, filters work, checkout is one tap. The notifications about deliveries are accurate. I have very few complaints about the digital experience.</p>','App is genuinely good','','publish','closed','closed','','app-is-genuinely-good','','','2026-05-19 20:30:44','2026-05-19 20:30:44','',0,'http://localhost:8080/review/app-is-genuinely-good/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (67,9,'2026-05-19 20:30:46','2026-05-19 20:30:46','<p>Their membership program at $129/year pays for itself if you order monthly. Free 2-day shipping, occasional member-only pricing, easy returns. Not as comprehensive as you might expect, but worth it for regular customers.</p>','Subscription program is decent value','','publish','closed','closed','','subscription-program-is-decent-value','','','2026-05-19 20:30:46','2026-05-19 20:30:46','',0,'http://localhost:8080/review/subscription-program-is-decent-value/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (68,2,'2026-05-19 20:30:47','2026-05-19 20:30:47','<p>The package was photographed sitting on top of a snowbank at the end of my driveway instead of on the porch. The carrier is technically the issue, but the customer-service rep took a while to understand why \"delivered\" wasn\'t acceptable. Eventually they resent the item.</p>','Delivery was left in a snowbank','','publish','closed','closed','','delivery-was-left-in-a-snowbank','','','2026-05-19 20:30:47','2026-05-19 20:30:47','',0,'http://localhost:8080/review/delivery-was-left-in-a-snowbank/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (69,6,'2026-05-19 20:30:49','2026-05-19 20:30:49','<p>Two-day shipping has saved me on two birthday situations this year. Wide enough selection that I can usually find something reasonable. The gift-wrap option is overpriced but functional.</p>','Good for last-minute gifts','','publish','closed','closed','','good-for-last-minute-gifts','','','2026-05-19 20:30:49','2026-05-19 20:30:49','',0,'http://localhost:8080/review/good-for-last-minute-gifts/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (70,5,'2026-05-19 20:30:50','2026-05-19 20:30:50','<p>I bought one item once for a specific purpose. For the next six months their entire homepage was variations of that item. The recommendation algorithm doesn\'t seem to understand that one purchase isn\'t a long-term signal. Minor gripe but ongoing.</p>','Recommendation engine is too pushy','','publish','closed','closed','','recommendation-engine-is-too-pushy','','','2026-05-19 20:30:50','2026-05-19 20:30:50','',0,'http://localhost:8080/review/recommendation-engine-is-too-pushy/',0,'review','',0);
INSERT INTO `wp_posts` VALUES (71,3,'2026-05-19 20:30:52','2026-05-19 20:30:52','<p>90-day returns on most items is excellent. But certain categories (large appliances, custom items) have shorter windows and restocking fees that aren\'t obvious at checkout. Read the return terms for big-ticket items before you buy.</p>','Return policy is generous, with caveats','','publish','closed','closed','','return-policy-is-generous-with-caveats','','','2026-05-19 20:30:52','2026-05-19 20:30:52','',0,'http://localhost:8080/review/return-policy-is-generous-with-caveats/',0,'review','',0);
/*!40000 ALTER TABLE `wp_posts` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `wp_term_relationships`
--

DROP TABLE IF EXISTS `wp_term_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_term_relationships` (
  `object_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `term_taxonomy_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `term_order` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`object_id`,`term_taxonomy_id`),
  KEY `term_taxonomy_id` (`term_taxonomy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_term_relationships`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `wp_term_relationships` WRITE;
/*!40000 ALTER TABLE `wp_term_relationships` DISABLE KEYS */;
INSERT INTO `wp_term_relationships` VALUES (1,1,0);
INSERT INTO `wp_term_relationships` VALUES (7,2,0);
INSERT INTO `wp_term_relationships` VALUES (8,5,0);
INSERT INTO `wp_term_relationships` VALUES (9,4,0);
INSERT INTO `wp_term_relationships` VALUES (10,3,0);
INSERT INTO `wp_term_relationships` VALUES (11,6,0);
/*!40000 ALTER TABLE `wp_term_relationships` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `wp_term_taxonomy`
--

DROP TABLE IF EXISTS `wp_term_taxonomy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_term_taxonomy` (
  `term_taxonomy_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `term_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `taxonomy` varchar(32) NOT NULL DEFAULT '',
  `description` longtext NOT NULL,
  `parent` bigint(20) unsigned NOT NULL DEFAULT 0,
  `count` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`term_taxonomy_id`),
  UNIQUE KEY `term_id_taxonomy` (`term_id`,`taxonomy`),
  KEY `taxonomy` (`taxonomy`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_term_taxonomy`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `wp_term_taxonomy` WRITE;
/*!40000 ALTER TABLE `wp_term_taxonomy` DISABLE KEYS */;
INSERT INTO `wp_term_taxonomy` VALUES (1,1,'category','',0,1);
INSERT INTO `wp_term_taxonomy` VALUES (2,2,'industry','',0,1);
INSERT INTO `wp_term_taxonomy` VALUES (3,3,'industry','',0,1);
INSERT INTO `wp_term_taxonomy` VALUES (4,4,'industry','',0,1);
INSERT INTO `wp_term_taxonomy` VALUES (5,5,'industry','',0,1);
INSERT INTO `wp_term_taxonomy` VALUES (6,6,'industry','',0,1);
/*!40000 ALTER TABLE `wp_term_taxonomy` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `wp_termmeta`
--

DROP TABLE IF EXISTS `wp_termmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_termmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `term_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL,
  PRIMARY KEY (`meta_id`),
  KEY `term_id` (`term_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_termmeta`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `wp_termmeta` WRITE;
/*!40000 ALTER TABLE `wp_termmeta` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_termmeta` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `wp_terms`
--

DROP TABLE IF EXISTS `wp_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_terms` (
  `term_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL DEFAULT '',
  `slug` varchar(200) NOT NULL DEFAULT '',
  `term_group` bigint(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`term_id`),
  KEY `slug` (`slug`(191)),
  KEY `name` (`name`(191))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_terms`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `wp_terms` WRITE;
/*!40000 ALTER TABLE `wp_terms` DISABLE KEYS */;
INSERT INTO `wp_terms` VALUES (1,'Uncategorized','uncategorized',0);
INSERT INTO `wp_terms` VALUES (2,'Insurance','insurance',0);
INSERT INTO `wp_terms` VALUES (3,'Telecom','telecom',0);
INSERT INTO `wp_terms` VALUES (4,'Home Services','home-services',0);
INSERT INTO `wp_terms` VALUES (5,'Finance','finance',0);
INSERT INTO `wp_terms` VALUES (6,'Retail','retail',0);
/*!40000 ALTER TABLE `wp_terms` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `wp_usermeta`
--

DROP TABLE IF EXISTS `wp_usermeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_usermeta` (
  `umeta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL,
  PRIMARY KEY (`umeta_id`),
  KEY `user_id` (`user_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_usermeta`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `wp_usermeta` WRITE;
/*!40000 ALTER TABLE `wp_usermeta` DISABLE KEYS */;
INSERT INTO `wp_usermeta` VALUES (1,1,'nickname','admin');
INSERT INTO `wp_usermeta` VALUES (2,1,'first_name','');
INSERT INTO `wp_usermeta` VALUES (3,1,'last_name','');
INSERT INTO `wp_usermeta` VALUES (4,1,'description','');
INSERT INTO `wp_usermeta` VALUES (5,1,'rich_editing','true');
INSERT INTO `wp_usermeta` VALUES (6,1,'syntax_highlighting','true');
INSERT INTO `wp_usermeta` VALUES (7,1,'comment_shortcuts','false');
INSERT INTO `wp_usermeta` VALUES (8,1,'admin_color','fresh');
INSERT INTO `wp_usermeta` VALUES (9,1,'use_ssl','0');
INSERT INTO `wp_usermeta` VALUES (10,1,'show_admin_bar_front','true');
INSERT INTO `wp_usermeta` VALUES (11,1,'locale','');
INSERT INTO `wp_usermeta` VALUES (12,1,'wp_capabilities','a:1:{s:13:\"administrator\";b:1;}');
INSERT INTO `wp_usermeta` VALUES (13,1,'wp_user_level','10');
INSERT INTO `wp_usermeta` VALUES (14,1,'dismissed_wp_pointers','');
INSERT INTO `wp_usermeta` VALUES (15,1,'show_welcome_panel','1');
INSERT INTO `wp_usermeta` VALUES (16,2,'nickname','sarah_k');
INSERT INTO `wp_usermeta` VALUES (17,2,'first_name','');
INSERT INTO `wp_usermeta` VALUES (18,2,'last_name','');
INSERT INTO `wp_usermeta` VALUES (19,2,'description','');
INSERT INTO `wp_usermeta` VALUES (20,2,'rich_editing','true');
INSERT INTO `wp_usermeta` VALUES (21,2,'syntax_highlighting','true');
INSERT INTO `wp_usermeta` VALUES (22,2,'comment_shortcuts','false');
INSERT INTO `wp_usermeta` VALUES (23,2,'admin_color','fresh');
INSERT INTO `wp_usermeta` VALUES (24,2,'use_ssl','0');
INSERT INTO `wp_usermeta` VALUES (25,2,'show_admin_bar_front','true');
INSERT INTO `wp_usermeta` VALUES (26,2,'locale','');
INSERT INTO `wp_usermeta` VALUES (27,2,'wp_capabilities','a:1:{s:10:\"subscriber\";b:1;}');
INSERT INTO `wp_usermeta` VALUES (28,2,'wp_user_level','0');
INSERT INTO `wp_usermeta` VALUES (29,2,'_yoast_wpseo_profile_updated','1779222538');
INSERT INTO `wp_usermeta` VALUES (30,2,'dismissed_wp_pointers','');
INSERT INTO `wp_usermeta` VALUES (31,3,'nickname','mike_t');
INSERT INTO `wp_usermeta` VALUES (32,3,'first_name','');
INSERT INTO `wp_usermeta` VALUES (33,3,'last_name','');
INSERT INTO `wp_usermeta` VALUES (34,3,'description','');
INSERT INTO `wp_usermeta` VALUES (35,3,'rich_editing','true');
INSERT INTO `wp_usermeta` VALUES (36,3,'syntax_highlighting','true');
INSERT INTO `wp_usermeta` VALUES (37,3,'comment_shortcuts','false');
INSERT INTO `wp_usermeta` VALUES (38,3,'admin_color','fresh');
INSERT INTO `wp_usermeta` VALUES (39,3,'use_ssl','0');
INSERT INTO `wp_usermeta` VALUES (40,3,'show_admin_bar_front','true');
INSERT INTO `wp_usermeta` VALUES (41,3,'locale','');
INSERT INTO `wp_usermeta` VALUES (42,3,'wp_capabilities','a:1:{s:10:\"subscriber\";b:1;}');
INSERT INTO `wp_usermeta` VALUES (43,3,'wp_user_level','0');
INSERT INTO `wp_usermeta` VALUES (44,3,'_yoast_wpseo_profile_updated','1779222538');
INSERT INTO `wp_usermeta` VALUES (45,3,'dismissed_wp_pointers','');
INSERT INTO `wp_usermeta` VALUES (46,4,'nickname','jenny_w');
INSERT INTO `wp_usermeta` VALUES (47,4,'first_name','');
INSERT INTO `wp_usermeta` VALUES (48,4,'last_name','');
INSERT INTO `wp_usermeta` VALUES (49,4,'description','');
INSERT INTO `wp_usermeta` VALUES (50,4,'rich_editing','true');
INSERT INTO `wp_usermeta` VALUES (51,4,'syntax_highlighting','true');
INSERT INTO `wp_usermeta` VALUES (52,4,'comment_shortcuts','false');
INSERT INTO `wp_usermeta` VALUES (53,4,'admin_color','fresh');
INSERT INTO `wp_usermeta` VALUES (54,4,'use_ssl','0');
INSERT INTO `wp_usermeta` VALUES (55,4,'show_admin_bar_front','true');
INSERT INTO `wp_usermeta` VALUES (56,4,'locale','');
INSERT INTO `wp_usermeta` VALUES (57,4,'wp_capabilities','a:1:{s:10:\"subscriber\";b:1;}');
INSERT INTO `wp_usermeta` VALUES (58,4,'wp_user_level','0');
INSERT INTO `wp_usermeta` VALUES (59,4,'_yoast_wpseo_profile_updated','1779222538');
INSERT INTO `wp_usermeta` VALUES (60,4,'dismissed_wp_pointers','');
INSERT INTO `wp_usermeta` VALUES (61,5,'nickname','david_l');
INSERT INTO `wp_usermeta` VALUES (62,5,'first_name','');
INSERT INTO `wp_usermeta` VALUES (63,5,'last_name','');
INSERT INTO `wp_usermeta` VALUES (64,5,'description','');
INSERT INTO `wp_usermeta` VALUES (65,5,'rich_editing','true');
INSERT INTO `wp_usermeta` VALUES (66,5,'syntax_highlighting','true');
INSERT INTO `wp_usermeta` VALUES (67,5,'comment_shortcuts','false');
INSERT INTO `wp_usermeta` VALUES (68,5,'admin_color','fresh');
INSERT INTO `wp_usermeta` VALUES (69,5,'use_ssl','0');
INSERT INTO `wp_usermeta` VALUES (70,5,'show_admin_bar_front','true');
INSERT INTO `wp_usermeta` VALUES (71,5,'locale','');
INSERT INTO `wp_usermeta` VALUES (72,5,'wp_capabilities','a:1:{s:10:\"subscriber\";b:1;}');
INSERT INTO `wp_usermeta` VALUES (73,5,'wp_user_level','0');
INSERT INTO `wp_usermeta` VALUES (74,5,'_yoast_wpseo_profile_updated','1779222539');
INSERT INTO `wp_usermeta` VALUES (75,5,'dismissed_wp_pointers','');
INSERT INTO `wp_usermeta` VALUES (76,6,'nickname','anna_r');
INSERT INTO `wp_usermeta` VALUES (77,6,'first_name','');
INSERT INTO `wp_usermeta` VALUES (78,6,'last_name','');
INSERT INTO `wp_usermeta` VALUES (79,6,'description','');
INSERT INTO `wp_usermeta` VALUES (80,6,'rich_editing','true');
INSERT INTO `wp_usermeta` VALUES (81,6,'syntax_highlighting','true');
INSERT INTO `wp_usermeta` VALUES (82,6,'comment_shortcuts','false');
INSERT INTO `wp_usermeta` VALUES (83,6,'admin_color','fresh');
INSERT INTO `wp_usermeta` VALUES (84,6,'use_ssl','0');
INSERT INTO `wp_usermeta` VALUES (85,6,'show_admin_bar_front','true');
INSERT INTO `wp_usermeta` VALUES (86,6,'locale','');
INSERT INTO `wp_usermeta` VALUES (87,6,'wp_capabilities','a:1:{s:10:\"subscriber\";b:1;}');
INSERT INTO `wp_usermeta` VALUES (88,6,'wp_user_level','0');
INSERT INTO `wp_usermeta` VALUES (89,6,'_yoast_wpseo_profile_updated','1779222539');
INSERT INTO `wp_usermeta` VALUES (90,6,'dismissed_wp_pointers','');
INSERT INTO `wp_usermeta` VALUES (91,7,'nickname','roberto_g');
INSERT INTO `wp_usermeta` VALUES (92,7,'first_name','');
INSERT INTO `wp_usermeta` VALUES (93,7,'last_name','');
INSERT INTO `wp_usermeta` VALUES (94,7,'description','');
INSERT INTO `wp_usermeta` VALUES (95,7,'rich_editing','true');
INSERT INTO `wp_usermeta` VALUES (96,7,'syntax_highlighting','true');
INSERT INTO `wp_usermeta` VALUES (97,7,'comment_shortcuts','false');
INSERT INTO `wp_usermeta` VALUES (98,7,'admin_color','fresh');
INSERT INTO `wp_usermeta` VALUES (99,7,'use_ssl','0');
INSERT INTO `wp_usermeta` VALUES (100,7,'show_admin_bar_front','true');
INSERT INTO `wp_usermeta` VALUES (101,7,'locale','');
INSERT INTO `wp_usermeta` VALUES (102,7,'wp_capabilities','a:1:{s:10:\"subscriber\";b:1;}');
INSERT INTO `wp_usermeta` VALUES (103,7,'wp_user_level','0');
INSERT INTO `wp_usermeta` VALUES (104,7,'_yoast_wpseo_profile_updated','1779222539');
INSERT INTO `wp_usermeta` VALUES (105,7,'dismissed_wp_pointers','');
INSERT INTO `wp_usermeta` VALUES (106,8,'nickname','maya_p');
INSERT INTO `wp_usermeta` VALUES (107,8,'first_name','');
INSERT INTO `wp_usermeta` VALUES (108,8,'last_name','');
INSERT INTO `wp_usermeta` VALUES (109,8,'description','');
INSERT INTO `wp_usermeta` VALUES (110,8,'rich_editing','true');
INSERT INTO `wp_usermeta` VALUES (111,8,'syntax_highlighting','true');
INSERT INTO `wp_usermeta` VALUES (112,8,'comment_shortcuts','false');
INSERT INTO `wp_usermeta` VALUES (113,8,'admin_color','fresh');
INSERT INTO `wp_usermeta` VALUES (114,8,'use_ssl','0');
INSERT INTO `wp_usermeta` VALUES (115,8,'show_admin_bar_front','true');
INSERT INTO `wp_usermeta` VALUES (116,8,'locale','');
INSERT INTO `wp_usermeta` VALUES (117,8,'wp_capabilities','a:1:{s:10:\"subscriber\";b:1;}');
INSERT INTO `wp_usermeta` VALUES (118,8,'wp_user_level','0');
INSERT INTO `wp_usermeta` VALUES (119,8,'_yoast_wpseo_profile_updated','1779222540');
INSERT INTO `wp_usermeta` VALUES (120,8,'dismissed_wp_pointers','');
INSERT INTO `wp_usermeta` VALUES (121,9,'nickname','kenji_o');
INSERT INTO `wp_usermeta` VALUES (122,9,'first_name','');
INSERT INTO `wp_usermeta` VALUES (123,9,'last_name','');
INSERT INTO `wp_usermeta` VALUES (124,9,'description','');
INSERT INTO `wp_usermeta` VALUES (125,9,'rich_editing','true');
INSERT INTO `wp_usermeta` VALUES (126,9,'syntax_highlighting','true');
INSERT INTO `wp_usermeta` VALUES (127,9,'comment_shortcuts','false');
INSERT INTO `wp_usermeta` VALUES (128,9,'admin_color','fresh');
INSERT INTO `wp_usermeta` VALUES (129,9,'use_ssl','0');
INSERT INTO `wp_usermeta` VALUES (130,9,'show_admin_bar_front','true');
INSERT INTO `wp_usermeta` VALUES (131,9,'locale','');
INSERT INTO `wp_usermeta` VALUES (132,9,'wp_capabilities','a:1:{s:10:\"subscriber\";b:1;}');
INSERT INTO `wp_usermeta` VALUES (133,9,'wp_user_level','0');
INSERT INTO `wp_usermeta` VALUES (134,9,'_yoast_wpseo_profile_updated','1779222540');
INSERT INTO `wp_usermeta` VALUES (135,9,'dismissed_wp_pointers','');
/*!40000 ALTER TABLE `wp_usermeta` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `wp_users`
--

DROP TABLE IF EXISTS `wp_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_users` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_login` varchar(60) NOT NULL DEFAULT '',
  `user_pass` varchar(255) NOT NULL DEFAULT '',
  `user_nicename` varchar(50) NOT NULL DEFAULT '',
  `user_email` varchar(100) NOT NULL DEFAULT '',
  `user_url` varchar(100) NOT NULL DEFAULT '',
  `user_registered` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_activation_key` varchar(255) NOT NULL DEFAULT '',
  `user_status` int(11) NOT NULL DEFAULT 0,
  `display_name` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `user_login_key` (`user_login`),
  KEY `user_nicename` (`user_nicename`),
  KEY `user_email` (`user_email`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_users`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `wp_users` WRITE;
/*!40000 ALTER TABLE `wp_users` DISABLE KEYS */;
INSERT INTO `wp_users` VALUES (1,'admin','$wp$2y$10$UpoCiOx5f0cvBvZXvokzSeDLPZhnBXxN/Bak5RFVHAYalQIzhR1GS','admin','admin@example.com','http://localhost:8080','2026-05-19 20:28:55','',0,'admin');
INSERT INTO `wp_users` VALUES (2,'sarah_k','$wp$2y$10$Bq5L2OfrIcvdrv.UniuFv.VcPL9.qAN4MdhoiYGTbYszBEkzhVVSy','sarah_k','sarah@example.com','','2026-05-19 20:28:57','',0,'Sarah K.');
INSERT INTO `wp_users` VALUES (3,'mike_t','$wp$2y$10$WiuPNDGFHwzJHU/O/f/FIOh5DCdrxMlfsGSMmAZ4mZiKg0VBaXPvK','mike_t','mike@example.com','','2026-05-19 20:28:58','',0,'Mike T.');
INSERT INTO `wp_users` VALUES (4,'jenny_w','$wp$2y$10$Mokj342/ZECsbupKF/SHU.ekKf99noogT5ZAwbkcfGcUWUqonjeia','jenny_w','jenny@example.com','','2026-05-19 20:28:58','',0,'Jenny W.');
INSERT INTO `wp_users` VALUES (5,'david_l','$wp$2y$10$DRalSDGyY3QRvOd0CLon4uphcB.v4RfAJoQNsYJlH8QoNt.zXkl5q','david_l','david@example.com','','2026-05-19 20:28:59','',0,'David L.');
INSERT INTO `wp_users` VALUES (6,'anna_r','$wp$2y$10$tAMi2IHi5.8kOrQtJ/Y9jODmxmR0fnLjEuPKU2fRVitQXpD8fPbba','anna_r','anna@example.com','','2026-05-19 20:28:59','',0,'Anna R.');
INSERT INTO `wp_users` VALUES (7,'roberto_g','$wp$2y$10$cbAukm3//P1zyMHXjg6jjuEYsOnlcC//O8mMkX9sFYjSdUQqsCVCi','roberto_g','roberto@example.com','','2026-05-19 20:28:59','',0,'Roberto G.');
INSERT INTO `wp_users` VALUES (8,'maya_p','$wp$2y$10$/ZHuyUItcDOOntOCT/akUuPJQM4IN4X5kJpDVHvQeKwHhKDh4nAvm','maya_p','maya@example.com','','2026-05-19 20:29:00','',0,'Maya P.');
INSERT INTO `wp_users` VALUES (9,'kenji_o','$wp$2y$10$2XTomJuywkaGGTURh2ja4eXTmSSRu6CkrzhnA3B6fMFGl0KcFJj9O','kenji_o','kenji@example.com','','2026-05-19 20:29:00','',0,'Kenji O.');
/*!40000 ALTER TABLE `wp_users` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `wp_yoast_indexable`
--

DROP TABLE IF EXISTS `wp_yoast_indexable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_yoast_indexable` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `permalink` longtext DEFAULT NULL,
  `permalink_hash` varchar(40) DEFAULT NULL,
  `object_id` bigint(20) DEFAULT NULL,
  `object_type` varchar(32) NOT NULL,
  `object_sub_type` varchar(32) DEFAULT NULL,
  `author_id` bigint(20) DEFAULT NULL,
  `post_parent` bigint(20) DEFAULT NULL,
  `title` text DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `breadcrumb_title` text DEFAULT NULL,
  `post_status` varchar(20) DEFAULT NULL,
  `is_public` tinyint(1) DEFAULT NULL,
  `is_protected` tinyint(1) DEFAULT 0,
  `has_public_posts` tinyint(1) DEFAULT NULL,
  `number_of_pages` int(11) unsigned DEFAULT NULL,
  `canonical` longtext DEFAULT NULL,
  `primary_focus_keyword` varchar(191) DEFAULT NULL,
  `primary_focus_keyword_score` int(3) DEFAULT NULL,
  `readability_score` int(3) DEFAULT NULL,
  `is_cornerstone` tinyint(1) DEFAULT 0,
  `is_robots_noindex` tinyint(1) DEFAULT 0,
  `is_robots_nofollow` tinyint(1) DEFAULT 0,
  `is_robots_noarchive` tinyint(1) DEFAULT 0,
  `is_robots_noimageindex` tinyint(1) DEFAULT 0,
  `is_robots_nosnippet` tinyint(1) DEFAULT 0,
  `twitter_title` text DEFAULT NULL,
  `twitter_image` longtext DEFAULT NULL,
  `twitter_description` longtext DEFAULT NULL,
  `twitter_image_id` varchar(191) DEFAULT NULL,
  `twitter_image_source` text DEFAULT NULL,
  `open_graph_title` text DEFAULT NULL,
  `open_graph_description` longtext DEFAULT NULL,
  `open_graph_image` longtext DEFAULT NULL,
  `open_graph_image_id` varchar(191) DEFAULT NULL,
  `open_graph_image_source` text DEFAULT NULL,
  `open_graph_image_meta` mediumtext DEFAULT NULL,
  `link_count` int(11) DEFAULT NULL,
  `incoming_link_count` int(11) DEFAULT NULL,
  `prominent_words_version` int(11) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `blog_id` bigint(20) NOT NULL DEFAULT 1,
  `language` varchar(32) DEFAULT NULL,
  `region` varchar(32) DEFAULT NULL,
  `schema_page_type` varchar(64) DEFAULT NULL,
  `schema_article_type` varchar(64) DEFAULT NULL,
  `has_ancestors` tinyint(1) DEFAULT 0,
  `estimated_reading_time_minutes` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT 1,
  `object_last_modified` datetime DEFAULT NULL,
  `object_published_at` datetime DEFAULT NULL,
  `inclusive_language_score` int(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `object_type_and_sub_type` (`object_type`,`object_sub_type`),
  KEY `object_id_and_type` (`object_id`,`object_type`),
  KEY `permalink_hash_and_object_type` (`permalink_hash`,`object_type`),
  KEY `subpages` (`post_parent`,`object_type`,`post_status`,`object_id`),
  KEY `prominent_words` (`prominent_words_version`,`object_type`,`object_sub_type`,`post_status`),
  KEY `published_sitemap_index` (`object_published_at`,`is_robots_noindex`,`object_type`,`object_sub_type`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_yoast_indexable`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `wp_yoast_indexable` WRITE;
/*!40000 ALTER TABLE `wp_yoast_indexable` DISABLE KEYS */;
INSERT INTO `wp_yoast_indexable` VALUES (1,'http://localhost:8080/industry/insurance/','41:6a60ff6a7e4cdb1077fff0ec07a6824d',2,'term','industry',NULL,NULL,NULL,NULL,'Insurance',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:28:56','2026-05-19 20:29:03',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:02',NULL,NULL);
INSERT INTO `wp_yoast_indexable` VALUES (2,'http://localhost:8080/industry/telecom/','39:45ebb577b29683bbcb9e737f29e65273',3,'term','industry',NULL,NULL,NULL,NULL,'Telecom',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:28:57','2026-05-19 20:29:10',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:08',NULL,NULL);
INSERT INTO `wp_yoast_indexable` VALUES (3,'http://localhost:8080/industry/home-services/','45:a96bc0b4943ab1dd34202f9bccfdfb7a',4,'term','industry',NULL,NULL,NULL,NULL,'Home Services',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:28:57','2026-05-19 20:29:08',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:06',NULL,NULL);
INSERT INTO `wp_yoast_indexable` VALUES (4,'http://localhost:8080/industry/finance/','39:b22cc89ad8a6f1a2a552597210c457b9',5,'term','industry',NULL,NULL,NULL,NULL,'Finance',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:28:57','2026-05-19 20:29:06',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:04',NULL,NULL);
INSERT INTO `wp_yoast_indexable` VALUES (5,'http://localhost:8080/industry/retail/','38:ac23e13d63a72845148b769d1f41975b',6,'term','industry',NULL,NULL,NULL,NULL,'Retail',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:28:57','2026-05-19 20:29:12',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:10',NULL,NULL);
INSERT INTO `wp_yoast_indexable` VALUES (6,'http://localhost:8080/home/','27:c96cb823643e6c967b616cea68927e13',4,'post','page',0,0,NULL,NULL,'Home','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:00','2026-05-19 20:29:00',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:00','2026-05-19 20:29:00',0);
INSERT INTO `wp_yoast_indexable` VALUES (7,'http://localhost:8080/about/','28:1004d11ba6defe8a75ddf4b3dc0a05c0',5,'post','page',0,0,NULL,NULL,'About','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:01','2026-05-19 20:29:01',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:01','2026-05-19 20:29:01',0);
INSERT INTO `wp_yoast_indexable` VALUES (8,'http://localhost:8080/contact/','30:fd16b2481692d4335875ddbe0cb7545b',6,'post','page',0,0,NULL,NULL,'Contact','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:01','2026-05-19 20:29:01',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:01','2026-05-19 20:29:01',0);
INSERT INTO `wp_yoast_indexable` VALUES (9,'http://localhost:8080/brand/acme-insurance/','43:25b803aebaaa965508997f0546a9a9cd',7,'post','brand',0,0,'Acme Insurance Reviews - Auto, Home & Umbrella Coverage','Read 12 independent customer reviews of Acme Insurance, a Hartford-based insurer offering auto, home, and umbrella policies in 38 US states.','Acme Insurance Co.','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:02','2026-05-19 20:29:03',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:02','2026-05-19 20:29:02',0);
INSERT INTO `wp_yoast_indexable` VALUES (10,'http://localhost:8080/brand/primepath-bank/','43:2dfea89f989b38094e964e1c0d5b19c9',8,'post','brand',0,0,'PrimePath Bank Reviews - Checking, Savings, Loans','PrimePath Bank customer reviews. Northeast regional bank offering checking, savings, and loans across 220 branches.','PrimePath Bank','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:04','2026-05-19 20:29:06',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:04','2026-05-19 20:29:04',0);
INSERT INTO `wp_yoast_indexable` VALUES (11,'http://localhost:8080/brand/homeshield-pro/','43:660b97557f1664e9fed7c9408fca9574',9,'post','brand',0,0,'HomeShield Pro Home Warranty Reviews','Read real customer reviews of HomeShield Pro home warranty plans covering HVAC, appliances, and plumbing.','HomeShield Pro','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:06','2026-05-19 20:29:08',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:06','2026-05-19 20:29:06',0);
INSERT INTO `wp_yoast_indexable` VALUES (12,'http://localhost:8080/brand/swiftstream-internet/','49:619cabcc2869312f423b3ff0464bc7cb',10,'post','brand',0,0,'SwiftStream Internet Reviews - Rural Fixed Wireless ISP','Read reviews of SwiftStream Internet, a Texas-based fixed wireless ISP for suburban and rural Southwest customers.','SwiftStream Internet','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:08','2026-05-19 20:29:10',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:08','2026-05-19 20:29:08',0);
INSERT INTO `wp_yoast_indexable` VALUES (13,'http://localhost:8080/brand/urbanretail-co/','43:a3312d30c3a963e35570834ac26e6e26',11,'post','brand',0,0,'UrbanRetail Co. Reviews - Apparel, Home, Electronics','Customer reviews of UrbanRetail Co., a Seattle-based online retailer carrying apparel, home goods, and small electronics.','UrbanRetail Co.','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:10','2026-05-19 20:29:12',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:10','2026-05-19 20:29:10',0);
INSERT INTO `wp_yoast_indexable` VALUES (14,'http://localhost:8080/review/smooth-auto-claim-after-a-parking-lot-fender-bender/','81:0d68086429a29cd7797ab623a2c5450d',12,'post','review',2,0,NULL,NULL,'Smooth auto claim after a parking-lot fender bender','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:13','2026-05-19 20:29:13',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:13','2026-05-19 20:29:13',0);
INSERT INTO `wp_yoast_indexable` VALUES (15,'http://localhost:8080/review/decent-coverage-but-pricey-for-younger-drivers/','76:97fa16b9ebfa632f26f5fcbe9cd57dba',13,'post','review',3,0,NULL,NULL,'Decent coverage but pricey for younger drivers','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:15','2026-05-19 20:29:15',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:15','2026-05-19 20:29:15',0);
INSERT INTO `wp_yoast_indexable` VALUES (16,'http://localhost:8080/review/agent-was-a-lifesaver-during-the-storm/','68:4a98c868fbd3dfd5b8e77d893f3fb240',14,'post','review',4,0,NULL,NULL,'Agent was a lifesaver during the storm','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:16','2026-05-19 20:29:16',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:16','2026-05-19 20:29:16',0);
INSERT INTO `wp_yoast_indexable` VALUES (17,'http://localhost:8080/review/renewal-sticker-shock-with-no-explanation/','71:0bed000c7d2c1d7420832f079c3c93b7',15,'post','review',5,0,NULL,NULL,'Renewal sticker shock with no explanation','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:18','2026-05-19 20:29:18',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:18','2026-05-19 20:29:18',0);
INSERT INTO `wp_yoast_indexable` VALUES (18,'http://localhost:8080/review/bundled-home-and-auto-saved-real-money/','68:1d126411ee32dd008ee31b6a7bc775e5',16,'post','review',6,0,NULL,NULL,'Bundled home and auto, saved real money','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:19','2026-05-19 20:29:19',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:19','2026-05-19 20:29:19',0);
INSERT INTO `wp_yoast_indexable` VALUES (19,'http://localhost:8080/review/long-hold-times-on-the-support-line/','65:ecdecb1f68df6b4cc5b55c34b76f8b24',17,'post','review',7,0,NULL,NULL,'Long hold times on the support line','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:21','2026-05-19 20:29:21',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:21','2026-05-19 20:29:21',0);
INSERT INTO `wp_yoast_indexable` VALUES (20,'http://localhost:8080/review/quick-payout-on-a-totaled-vehicle/','63:2fb030c175685e72e483f9b0ec4f74ad',18,'post','review',8,0,NULL,NULL,'Quick payout on a totaled vehicle','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:22','2026-05-19 20:29:22',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:22','2026-05-19 20:29:22',0);
INSERT INTO `wp_yoast_indexable` VALUES (21,'http://localhost:8080/review/online-portal-feels-like-2010/','59:0bccfb245f6cac33e5c1763c94a39590',19,'post','review',9,0,NULL,NULL,'Online portal feels like 2010','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:24','2026-05-19 20:29:24',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:24','2026-05-19 20:29:24',0);
INSERT INTO `wp_yoast_indexable` VALUES (22,'http://localhost:8080/review/umbrella-policy-was-easy-to-add/','61:cc834e49956808526e36212a78ecaf6b',20,'post','review',2,0,NULL,NULL,'Umbrella policy was easy to add','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:26','2026-05-19 20:29:26',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:26','2026-05-19 20:29:26',0);
INSERT INTO `wp_yoast_indexable` VALUES (23,'http://localhost:8080/review/glass-claim-handling-was-confusing/','64:6991db277990f3d0a0bd9d9cd2bd9818',21,'post','review',3,0,NULL,NULL,'Glass claim handling was confusing','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:27','2026-05-19 20:29:27',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:27','2026-05-19 20:29:27',0);
INSERT INTO `wp_yoast_indexable` VALUES (24,'http://localhost:8080/review/discount-for-safe-driving-was-real/','64:dd0911b0e70d65e30e209ed71f1c84b2',22,'post','review',4,0,NULL,NULL,'Discount for safe driving was real','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:29','2026-05-19 20:29:29',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:29','2026-05-19 20:29:29',0);
INSERT INTO `wp_yoast_indexable` VALUES (25,'http://localhost:8080/review/fine-but-nothing-special/','54:fb6f2f6c1d0ba20eafc307b7c9362adb',23,'post','review',5,0,NULL,NULL,'Fine but nothing special','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:31','2026-05-19 20:29:31',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:31','2026-05-19 20:29:31',0);
INSERT INTO `wp_yoast_indexable` VALUES (26,'http://localhost:8080/review/branches-still-matter-and-they-have-them/','70:42a476cfad93a78657ec3e85499ec482',24,'post','review',6,0,NULL,NULL,'Branches still matter and they have them','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:32','2026-05-19 20:29:32',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:32','2026-05-19 20:29:32',0);
INSERT INTO `wp_yoast_indexable` VALUES (27,'http://localhost:8080/review/mobile-app-feels-dated/','52:4ef1a8d124bae8cb0b9241285502c1ae',25,'post','review',3,0,NULL,NULL,'Mobile app feels dated','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:34','2026-05-19 20:29:34',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:34','2026-05-19 20:29:34',0);
INSERT INTO `wp_yoast_indexable` VALUES (28,'http://localhost:8080/review/got-a-great-rate-on-our-mortgage/','62:49a35f03d870d6fbed5a178f20c212c8',26,'post','review',2,0,NULL,NULL,'Got a great rate on our mortgage','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:36','2026-05-19 20:29:36',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:36','2026-05-19 20:29:36',0);
INSERT INTO `wp_yoast_indexable` VALUES (29,'http://localhost:8080/review/overdraft-policy-is-aggressive/','60:44bebae884fecdbd48a5021f3350b6ef',27,'post','review',7,0,NULL,NULL,'Overdraft policy is aggressive','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:38','2026-05-19 20:29:38',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:38','2026-05-19 20:29:38',0);
INSERT INTO `wp_yoast_indexable` VALUES (30,'http://localhost:8080/review/personal-banker-actually-returns-calls/','68:b548fcbaf953011e9a4f256ace713100',28,'post','review',4,0,NULL,NULL,'Personal banker actually returns calls','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:40','2026-05-19 20:29:40',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:40','2026-05-19 20:29:40',0);
INSERT INTO `wp_yoast_indexable` VALUES (31,'http://localhost:8080/review/savings-rate-is-uncompetitive/','59:9200cf0076bc29b707f0886f80959485',29,'post','review',5,0,NULL,NULL,'Savings rate is uncompetitive','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:41','2026-05-19 20:29:41',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:41','2026-05-19 20:29:41',0);
INSERT INTO `wp_yoast_indexable` VALUES (32,'http://localhost:8080/review/small-business-banking-has-been-solid/','67:b06e3bb29b97e32b0a09d2113a7f97ee',30,'post','review',8,0,NULL,NULL,'Small business banking has been solid','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:43','2026-05-19 20:29:43',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:43','2026-05-19 20:29:43',0);
INSERT INTO `wp_yoast_indexable` VALUES (33,'http://localhost:8080/review/auto-loan-process-was-painful/','59:3f56a1bb62f8d0ad4bce06f466d00051',31,'post','review',9,0,NULL,NULL,'Auto loan process was painful','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:45','2026-05-19 20:29:45',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:45','2026-05-19 20:29:45',0);
INSERT INTO `wp_yoast_indexable` VALUES (34,'http://localhost:8080/review/free-notary-services-at-the-branch/','64:b4a50dcb411098dbd7da4607a4380233',32,'post','review',6,0,NULL,NULL,'Free notary services at the branch','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:46','2026-05-19 20:29:46',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:46','2026-05-19 20:29:46',0);
INSERT INTO `wp_yoast_indexable` VALUES (35,'http://localhost:8080/review/wire-transfer-fees-are-high/','57:b0f48c080fab168f51fec2ba2d537a76',33,'post','review',2,0,NULL,NULL,'Wire transfer fees are high','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:48','2026-05-19 20:29:48',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:48','2026-05-19 20:29:48',0);
INSERT INTO `wp_yoast_indexable` VALUES (36,'http://localhost:8080/review/quick-heloc-approval/','50:f099d21b34784d45e160db5a3e45f0cf',34,'post','review',3,0,NULL,NULL,'Quick HELOC approval','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:50','2026-05-19 20:29:50',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:50','2026-05-19 20:29:50',0);
INSERT INTO `wp_yoast_indexable` VALUES (37,'http://localhost:8080/review/tellers-and-managers-are-well-trained/','67:08251b54aeaff7b20b29de1d9400a504',35,'post','review',7,0,NULL,NULL,'Tellers and managers are well-trained','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:51','2026-05-19 20:29:51',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:51','2026-05-19 20:29:51',0);
INSERT INTO `wp_yoast_indexable` VALUES (38,'http://localhost:8080/review/covered-a-dead-ac-unit-in-july-worth-the-cost/','75:0c72ab022983822ae1c9d783b78dc2a4',36,'post','review',2,0,NULL,NULL,'Covered a dead AC unit in July — worth the cost','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:53','2026-05-19 20:29:53',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:53','2026-05-19 20:29:53',0);
INSERT INTO `wp_yoast_indexable` VALUES (39,'http://localhost:8080/review/lots-of-exclusions-buried-in-the-fine-print/','73:76893779bc0ec1ff3f775f151e7922d3',37,'post','review',5,0,NULL,NULL,'Lots of exclusions buried in the fine print','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:55','2026-05-19 20:29:55',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:55','2026-05-19 20:29:55',0);
INSERT INTO `wp_yoast_indexable` VALUES (40,'http://localhost:8080/review/reliable-for-routine-appliance-failures/','69:54621fc267b7a3f2e4da807b5a4fb4be',38,'post','review',4,0,NULL,NULL,'Reliable for routine appliance failures','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:29:57','2026-05-19 20:29:57',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:57','2026-05-19 20:29:57',0);
INSERT INTO `wp_yoast_indexable` VALUES (41,'http://localhost:8080/review/long-wait-for-plumber-dispatch/','60:3e22a4407fb58ca7d36cce9693eea3bd',39,'post','review',3,0,NULL,NULL,'Long wait for plumber dispatch','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:00','2026-05-19 20:30:00',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:00','2026-05-19 20:30:00',0);
INSERT INTO `wp_yoast_indexable` VALUES (42,'http://localhost:8080/review/refrigerator-replacement-was-approved/','67:c29f55f930fdc2e9a7cbcdf528a041a5',40,'post','review',6,0,NULL,NULL,'Refrigerator replacement was approved','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:02','2026-05-19 20:30:02',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:02','2026-05-19 20:30:02',0);
INSERT INTO `wp_yoast_indexable` VALUES (43,'http://localhost:8080/review/contractor-quality-is-inconsistent/','64:b5028477710d8e9fa27181de3da4bc44',41,'post','review',7,0,NULL,NULL,'Contractor quality is inconsistent','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:04','2026-05-19 20:30:04',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:04','2026-05-19 20:30:04',0);
INSERT INTO `wp_yoast_indexable` VALUES (44,'http://localhost:8080/review/cancellation-policy-is-sneaky/','59:44d54db31163c6ff21b304150412b06a',42,'post','review',8,0,NULL,NULL,'Cancellation policy is sneaky','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:05','2026-05-19 20:30:05',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:05','2026-05-19 20:30:05',0);
INSERT INTO `wp_yoast_indexable` VALUES (45,'http://localhost:8080/review/hvac-tune-up-included-is-a-real-perk/','66:f48353872ba72a9656724954d0ba7207',43,'post','review',9,0,NULL,NULL,'HVAC tune-up included is a real perk','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:07','2026-05-19 20:30:07',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:07','2026-05-19 20:30:07',0);
INSERT INTO `wp_yoast_indexable` VALUES (46,'http://localhost:8080/review/denied-a-clearly-covered-claim/','60:a2c8346f656cbe1b5051a9715dcaa3d0',44,'post','review',5,0,NULL,NULL,'Denied a clearly covered claim','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:08','2026-05-19 20:30:08',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:08','2026-05-19 20:30:08',0);
INSERT INTO `wp_yoast_indexable` VALUES (47,'http://localhost:8080/review/pool-equipment-add-on-saved-us-a-fortune/','70:b862a18bdd13ab573e2ee5b7113edd18',45,'post','review',4,0,NULL,NULL,'Pool equipment add-on saved us a fortune','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:10','2026-05-19 20:30:10',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:10','2026-05-19 20:30:10',0);
INSERT INTO `wp_yoast_indexable` VALUES (48,'http://localhost:8080/review/customer-service-hold-times-are-brutal/','68:8514a2d114640fd8fa53a0998f2b0e55',46,'post','review',2,0,NULL,NULL,'Customer service hold times are brutal','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:12','2026-05-19 20:30:12',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:12','2026-05-19 20:30:12',0);
INSERT INTO `wp_yoast_indexable` VALUES (49,'http://localhost:8080/review/renewal-pricing-more-than-doubled/','63:7f88e07f3304ca8a313c56de9cd974cf',47,'post','review',7,0,NULL,NULL,'Renewal pricing more than doubled','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:13','2026-05-19 20:30:13',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:13','2026-05-19 20:30:13',0);
INSERT INTO `wp_yoast_indexable` VALUES (50,'http://localhost:8080/review/finally-an-option-that-isnt-satellite/','67:e9bce5f152446bf03f0130bb21dbc8c5',48,'post','review',2,0,NULL,NULL,'Finally an option that isn&#8217;t satellite','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:15','2026-05-19 20:30:15',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:15','2026-05-19 20:30:15',0);
INSERT INTO `wp_yoast_indexable` VALUES (51,'http://localhost:8080/review/drops-out-every-time-it-rains/','59:696ab02aa5aff06c0f4a5419adcdcd52',49,'post','review',3,0,NULL,NULL,'Drops out every time it rains','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:17','2026-05-19 20:30:17',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:17','2026-05-19 20:30:17',0);
INSERT INTO `wp_yoast_indexable` VALUES (52,'http://localhost:8080/review/acceptable-rural-option-not-a-city-replacement/','76:0dc18238eb796b86fae5ea1732a345fd',50,'post','review',5,0,NULL,NULL,'Acceptable rural option, not a city replacement','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:18','2026-05-19 20:30:18',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:18','2026-05-19 20:30:18',0);
INSERT INTO `wp_yoast_indexable` VALUES (53,'http://localhost:8080/review/install-crew-was-professional/','59:e8be55067a2f9e823b7ae8e546fb512c',51,'post','review',4,0,NULL,NULL,'Install crew was professional','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:20','2026-05-19 20:30:20',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:20','2026-05-19 20:30:20',0);
INSERT INTO `wp_yoast_indexable` VALUES (54,'http://localhost:8080/review/speed-advertised-vs-delivered/','59:d65c2b44abfd1da6a0d546feaab20459',52,'post','review',6,0,NULL,NULL,'Speed advertised vs delivered','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:22','2026-05-19 20:30:22',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:22','2026-05-19 20:30:22',0);
INSERT INTO `wp_yoast_indexable` VALUES (55,'http://localhost:8080/review/customer-service-is-unusually-helpful/','67:350b9f0223e9a2af6a534ffc393312ed',53,'post','review',7,0,NULL,NULL,'Customer service is unusually helpful','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:23','2026-05-19 20:30:23',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:23','2026-05-19 20:30:23',0);
INSERT INTO `wp_yoast_indexable` VALUES (56,'http://localhost:8080/review/data-caps-make-remote-work-hard/','61:481a648e13ae43bd1c94a9daf3374474',54,'post','review',8,0,NULL,NULL,'Data caps make remote work hard','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:25','2026-05-19 20:30:25',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:25','2026-05-19 20:30:25',0);
INSERT INTO `wp_yoast_indexable` VALUES (57,'http://localhost:8080/review/better-latency-than-expected/','58:d2e91d154afa84eec7c4d15bfe3b665e',55,'post','review',9,0,NULL,NULL,'Better latency than expected','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:26','2026-05-19 20:30:26',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:26','2026-05-19 20:30:26',0);
INSERT INTO `wp_yoast_indexable` VALUES (58,'http://localhost:8080/review/outage-support-could-be-better/','60:9887979b22b52bd589f5b1d09ef88478',56,'post','review',2,0,NULL,NULL,'Outage support could be better','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:28','2026-05-19 20:30:28',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:28','2026-05-19 20:30:28',0);
INSERT INTO `wp_yoast_indexable` VALUES (59,'http://localhost:8080/review/reasonable-for-the-alternative/','60:d403caa29030944ce299d746c05cb218',57,'post','review',4,0,NULL,NULL,'Reasonable for the alternative','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:30','2026-05-19 20:30:30',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:30','2026-05-19 20:30:30',0);
INSERT INTO `wp_yoast_indexable` VALUES (60,'http://localhost:8080/review/equipment-fee-feels-excessive/','59:112d10792c75ebd1e8a4a21b23d4d293',58,'post','review',5,0,NULL,NULL,'Equipment fee feels excessive','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:32','2026-05-19 20:30:32',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:32','2026-05-19 20:30:32',0);
INSERT INTO `wp_yoast_indexable` VALUES (61,'http://localhost:8080/review/best-isp-option-in-my-zip-code/','60:d9b5e87532dcb2655fb97c588c57a733',59,'post','review',3,0,NULL,NULL,'Best ISP option in my zip code','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:33','2026-05-19 20:30:33',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:33','2026-05-19 20:30:33',0);
INSERT INTO `wp_yoast_indexable` VALUES (62,'http://localhost:8080/review/selection-is-huge-shipping-is-fast/','64:d51759eb90df7c5e9d110f507a0d1231',60,'post','review',2,0,NULL,NULL,'Selection is huge, shipping is fast','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:35','2026-05-19 20:30:35',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:35','2026-05-19 20:30:35',0);
INSERT INTO `wp_yoast_indexable` VALUES (63,'http://localhost:8080/review/quality-is-hit-or-miss-on-private-label-apparel/','77:de45e4a7799b8b185c16d1283a567969',61,'post','review',5,0,NULL,NULL,'Quality is hit or miss on private-label apparel','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:36','2026-05-19 20:30:36',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:36','2026-05-19 20:30:36',0);
INSERT INTO `wp_yoast_indexable` VALUES (64,'http://localhost:8080/review/customer-service-won-me-back/','58:328dff728dc941d76cebfefff61a099f',62,'post','review',6,0,NULL,NULL,'Customer service won me back','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:38','2026-05-19 20:30:38',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:38','2026-05-19 20:30:38',0);
INSERT INTO `wp_yoast_indexable` VALUES (65,'http://localhost:8080/review/pricing-games-on-black-friday/','59:16eae65c9ae512fb48a6942496f4695f',63,'post','review',4,0,NULL,NULL,'Pricing games on Black Friday','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:39','2026-05-19 20:30:39',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:39','2026-05-19 20:30:39',0);
INSERT INTO `wp_yoast_indexable` VALUES (66,'http://localhost:8080/review/solid-for-home-goods-specifically/','63:293928f41d450a97c4ed6b87e33e367d',64,'post','review',3,0,NULL,NULL,'Solid for home goods specifically','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:41','2026-05-19 20:30:41',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:41','2026-05-19 20:30:41',0);
INSERT INTO `wp_yoast_indexable` VALUES (67,'http://localhost:8080/review/counterfeit-risk-with-marketplace-sellers/','71:753b814d95acc217a9d165cb10db105f',65,'post','review',7,0,NULL,NULL,'Counterfeit risk with marketplace sellers','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:43','2026-05-19 20:30:43',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:43','2026-05-19 20:30:43',0);
INSERT INTO `wp_yoast_indexable` VALUES (68,'http://localhost:8080/review/app-is-genuinely-good/','51:755670701c4546dadc13c722e1cc5ed0',66,'post','review',8,0,NULL,NULL,'App is genuinely good','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:44','2026-05-19 20:30:44',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:44','2026-05-19 20:30:44',0);
INSERT INTO `wp_yoast_indexable` VALUES (69,'http://localhost:8080/review/subscription-program-is-decent-value/','66:f9aeba45870eec3e12729fabb86eaffe',67,'post','review',9,0,NULL,NULL,'Subscription program is decent value','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:46','2026-05-19 20:30:46',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:46','2026-05-19 20:30:46',0);
INSERT INTO `wp_yoast_indexable` VALUES (70,'http://localhost:8080/review/delivery-was-left-in-a-snowbank/','61:f347372ceee48aa7bc9b970d2c55988a',68,'post','review',2,0,NULL,NULL,'Delivery was left in a snowbank','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:47','2026-05-19 20:30:47',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:47','2026-05-19 20:30:47',0);
INSERT INTO `wp_yoast_indexable` VALUES (71,'http://localhost:8080/review/good-for-last-minute-gifts/','56:1053f5a5a56ce08d1be54f8b453b4829',69,'post','review',6,0,NULL,NULL,'Good for last-minute gifts','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:49','2026-05-19 20:30:49',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:49','2026-05-19 20:30:49',0);
INSERT INTO `wp_yoast_indexable` VALUES (72,'http://localhost:8080/review/recommendation-engine-is-too-pushy/','64:841e9c9e7dbc49675f5da56d7570a254',70,'post','review',5,0,NULL,NULL,'Recommendation engine is too pushy','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:50','2026-05-19 20:30:50',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:50','2026-05-19 20:30:50',0);
INSERT INTO `wp_yoast_indexable` VALUES (73,'http://localhost:8080/review/return-policy-is-generous-with-caveats/','68:da1b41dce899b0e3bc563b2b8ceb4dbf',71,'post','review',3,0,NULL,NULL,'Return policy is generous, with caveats','publish',NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-05-19 20:30:52','2026-05-19 20:30:52',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:52','2026-05-19 20:30:52',0);
INSERT INTO `wp_yoast_indexable` VALUES (74,'http://localhost:8080/','22:9825c2a542dd888e55b9b0e06b04f672',NULL,'home-page',NULL,NULL,NULL,'%%sitename%% %%page%% %%sep%% %%sitedesc%%','','Home',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,'%%sitename%%','','','0',NULL,NULL,NULL,NULL,NULL,'2026-05-19 20:31:01','2026-05-19 20:31:01',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:28:55','2026-05-19 20:28:55',NULL);
INSERT INTO `wp_yoast_indexable` VALUES (75,'http://localhost:8080/brand/','28:dc10ff6894452733438ca97c3a2fdbf6',NULL,'post-type-archive','brand',NULL,NULL,'%%pt_plural%% Archive %%page%% %%sep%% %%sitename%%','','Brands',NULL,1,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-19 20:31:01','2026-05-19 20:31:01',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:29:10','2026-05-19 20:29:02',NULL);
INSERT INTO `wp_yoast_indexable` VALUES (76,'http://localhost:8080/review/','29:326f0194122beb0bae85b888f314e4cc',NULL,'post-type-archive','review',NULL,NULL,'%%pt_plural%% Archive %%page%% %%sep%% %%sitename%%','','Reviews',NULL,1,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-19 20:31:01','2026-05-19 20:31:01',1,NULL,NULL,NULL,NULL,0,NULL,2,'2026-05-19 20:30:52','2026-05-19 20:29:13',NULL);
/*!40000 ALTER TABLE `wp_yoast_indexable` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `wp_yoast_indexable_hierarchy`
--

DROP TABLE IF EXISTS `wp_yoast_indexable_hierarchy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_yoast_indexable_hierarchy` (
  `indexable_id` int(11) unsigned NOT NULL,
  `ancestor_id` int(11) unsigned NOT NULL,
  `depth` int(11) unsigned DEFAULT NULL,
  `blog_id` bigint(20) NOT NULL DEFAULT 1,
  PRIMARY KEY (`indexable_id`,`ancestor_id`),
  KEY `indexable_id` (`indexable_id`),
  KEY `ancestor_id` (`ancestor_id`),
  KEY `depth` (`depth`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_yoast_indexable_hierarchy`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `wp_yoast_indexable_hierarchy` WRITE;
/*!40000 ALTER TABLE `wp_yoast_indexable_hierarchy` DISABLE KEYS */;
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (1,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (2,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (3,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (4,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (5,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (6,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (7,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (8,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (9,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (10,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (11,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (12,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (13,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (14,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (15,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (16,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (17,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (18,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (19,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (20,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (21,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (22,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (23,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (24,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (25,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (26,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (27,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (28,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (29,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (30,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (31,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (32,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (33,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (34,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (35,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (36,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (37,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (38,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (39,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (40,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (41,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (42,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (43,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (44,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (45,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (46,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (47,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (48,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (49,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (50,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (51,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (52,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (53,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (54,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (55,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (56,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (57,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (58,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (59,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (60,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (61,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (62,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (63,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (64,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (65,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (66,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (67,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (68,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (69,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (70,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (71,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (72,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (73,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (75,0,0,1);
INSERT INTO `wp_yoast_indexable_hierarchy` VALUES (76,0,0,1);
/*!40000 ALTER TABLE `wp_yoast_indexable_hierarchy` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `wp_yoast_migrations`
--

DROP TABLE IF EXISTS `wp_yoast_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_yoast_migrations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `version` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `wp_yoast_migrations_version` (`version`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_yoast_migrations`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `wp_yoast_migrations` WRITE;
/*!40000 ALTER TABLE `wp_yoast_migrations` DISABLE KEYS */;
INSERT INTO `wp_yoast_migrations` VALUES (1,'20171228151840');
INSERT INTO `wp_yoast_migrations` VALUES (2,'20171228151841');
INSERT INTO `wp_yoast_migrations` VALUES (3,'20190529075038');
INSERT INTO `wp_yoast_migrations` VALUES (4,'20191011111109');
INSERT INTO `wp_yoast_migrations` VALUES (5,'20200408101900');
INSERT INTO `wp_yoast_migrations` VALUES (6,'20200420073606');
INSERT INTO `wp_yoast_migrations` VALUES (7,'20200428123747');
INSERT INTO `wp_yoast_migrations` VALUES (8,'20200428194858');
INSERT INTO `wp_yoast_migrations` VALUES (9,'20200429105310');
INSERT INTO `wp_yoast_migrations` VALUES (10,'20200430075614');
INSERT INTO `wp_yoast_migrations` VALUES (11,'20200430150130');
INSERT INTO `wp_yoast_migrations` VALUES (12,'20200507054848');
INSERT INTO `wp_yoast_migrations` VALUES (13,'20200513133401');
INSERT INTO `wp_yoast_migrations` VALUES (14,'20200609154515');
INSERT INTO `wp_yoast_migrations` VALUES (15,'20200616130143');
INSERT INTO `wp_yoast_migrations` VALUES (16,'20200617122511');
INSERT INTO `wp_yoast_migrations` VALUES (17,'20200702141921');
INSERT INTO `wp_yoast_migrations` VALUES (18,'20200728095334');
INSERT INTO `wp_yoast_migrations` VALUES (19,'20201202144329');
INSERT INTO `wp_yoast_migrations` VALUES (20,'20201216124002');
INSERT INTO `wp_yoast_migrations` VALUES (21,'20201216141134');
INSERT INTO `wp_yoast_migrations` VALUES (22,'20210817092415');
INSERT INTO `wp_yoast_migrations` VALUES (23,'20211020091404');
INSERT INTO `wp_yoast_migrations` VALUES (24,'20230417083836');
INSERT INTO `wp_yoast_migrations` VALUES (25,'20260105111111');
/*!40000 ALTER TABLE `wp_yoast_migrations` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `wp_yoast_primary_term`
--

DROP TABLE IF EXISTS `wp_yoast_primary_term`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_yoast_primary_term` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) DEFAULT NULL,
  `term_id` bigint(20) DEFAULT NULL,
  `taxonomy` varchar(32) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `blog_id` bigint(20) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `post_taxonomy` (`post_id`,`taxonomy`),
  KEY `post_term` (`post_id`,`term_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_yoast_primary_term`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `wp_yoast_primary_term` WRITE;
/*!40000 ALTER TABLE `wp_yoast_primary_term` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_yoast_primary_term` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `wp_yoast_seo_links`
--

DROP TABLE IF EXISTS `wp_yoast_seo_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_yoast_seo_links` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT NULL,
  `post_id` bigint(20) unsigned DEFAULT NULL,
  `target_post_id` bigint(20) unsigned DEFAULT NULL,
  `type` varchar(8) DEFAULT NULL,
  `indexable_id` int(11) unsigned DEFAULT NULL,
  `target_indexable_id` int(11) unsigned DEFAULT NULL,
  `height` int(11) unsigned DEFAULT NULL,
  `width` int(11) unsigned DEFAULT NULL,
  `size` int(11) unsigned DEFAULT NULL,
  `language` varchar(32) DEFAULT NULL,
  `region` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `link_direction` (`post_id`,`type`),
  KEY `indexable_link_direction` (`indexable_id`,`type`),
  KEY `url_index` (`url`),
  KEY `target_indexable_id_index` (`target_indexable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_yoast_seo_links`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `wp_yoast_seo_links` WRITE;
/*!40000 ALTER TABLE `wp_yoast_seo_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_yoast_seo_links` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-05-19 20:31:22
