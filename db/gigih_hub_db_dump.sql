-- MySQL dump 10.13  Distrib 5.7.34, for Linux (x86_64)
--
-- Host: localhost    Database: gigih_hub_db
-- ------------------------------------------------------
-- Server version	5.7.34-0ubuntu0.18.04.1

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
-- Table structure for table `hashtags`
--

DROP TABLE IF EXISTS `hashtags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hashtags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=560 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hashtags`
--

LOCK TABLES `hashtags` WRITE;
/*!40000 ALTER TABLE `hashtags` DISABLE KEYS */;
INSERT INTO `hashtags` VALUES (351,'#gigih1'),(352,'#semangat2'),(353,'#halo3'),(354,'#oke4'),(355,'#santai5'),(546,'#world'),(547,'#hehe');
/*!40000 ALTER TABLE `hashtags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_hashtags`
--

DROP TABLE IF EXISTS `post_hashtags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post_hashtags` (
  `post_id` int(11) DEFAULT NULL,
  `hashtag_id` int(11) DEFAULT NULL,
  KEY `post_id` (`post_id`),
  KEY `hashtag_id` (`hashtag_id`),
  CONSTRAINT `post_hashtags_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  CONSTRAINT `post_hashtags_ibfk_2` FOREIGN KEY (`hashtag_id`) REFERENCES `hashtags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_hashtags`
--

LOCK TABLES `post_hashtags` WRITE;
/*!40000 ALTER TABLE `post_hashtags` DISABLE KEYS */;
INSERT INTO `post_hashtags` VALUES (646,351),(647,351),(648,351),(649,351),(650,351),(651,352),(652,352),(653,352),(654,352),(655,353),(656,353),(657,353),(658,354),(659,354),(660,355),(677,546),(677,547);
/*!40000 ALTER TABLE `post_hashtags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `parent_post_id` int(11) DEFAULT NULL,
  `text` varchar(1000) DEFAULT NULL,
  `attachment` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `parent_post_id` (`parent_post_id`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `posts_ibfk_2` FOREIGN KEY (`parent_post_id`) REFERENCES `posts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=692 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (646,354,NULL,'Ayo kita #gigih1',NULL,'2021-08-20 21:03:46'),(647,354,NULL,'Kapan kelas #gigih1 mulai?',NULL,'2021-08-20 21:03:46'),(648,354,NULL,'Ayo #GiGih1',NULL,'2021-08-20 21:03:46'),(649,354,NULL,'Kapan kita #gigih1 ?',NULL,'2021-08-20 21:03:46'),(650,354,NULL,'#gigih1 itu baik',NULL,'2021-08-20 21:03:46'),(651,354,NULL,'#Semangat2 ya kita',NULL,'2021-08-20 21:03:46'),(652,354,NULL,'#SeMangat2 hore',NULL,'2021-08-20 21:03:46'),(653,354,NULL,'loh #SeMangat2 kakak',NULL,'2021-08-20 21:03:46'),(654,354,NULL,'Yang penting #semangat2',NULL,'2021-08-20 21:03:46'),(655,354,NULL,'#halo3 kakak',NULL,'2021-08-20 21:03:46'),(656,354,NULL,'Kita suka #halo3',NULL,'2021-08-20 21:03:46'),(657,354,NULL,'#halo3 bandung',NULL,'2021-08-20 21:03:46'),(658,354,NULL,'Yey #oke4',NULL,'2021-08-20 21:03:46'),(659,354,NULL,'#oke4 kak kita siap',NULL,'2021-08-20 21:03:46'),(660,354,NULL,'Mari kita #santai5',NULL,'2021-08-20 21:03:46'),(661,1,NULL,'Hello, world! #hello',NULL,'2021-08-20 23:23:12'),(663,1,NULL,'Hello, world! #hello',NULL,'2021-08-20 23:23:12'),(677,1,NULL,'Hello #world #hehe','http://localhost:4567/storage/90066f39d4f54d7d827bf84bef40ae1a.jpg','2021-08-21 16:54:34');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `bio` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=556 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'erma','erma@test.com','Simple.'),(2,'tyo','tyo@test.com',''),(354,'fira','lololo@gmail.com',''),(479,'fira','aaa@chaos.org','');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-08-21 19:04:26
