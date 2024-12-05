CREATE DATABASE  IF NOT EXISTS `internship_tracking_application` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `internship_tracking_application`;
-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: internship_tracking_application
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `appadmin`
--

DROP TABLE IF EXISTS `appadmin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appadmin` (
  `USERNAME` varchar(255) NOT NULL,
  `ROLE` varchar(255) NOT NULL,
  `ACCESS_LEVEL` enum('FULL','EDIT','VIEW') NOT NULL,
  `DEPARTMENT` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`USERNAME`),
  CONSTRAINT `appadmin_ibfk_1` FOREIGN KEY (`USERNAME`) REFERENCES `appuser` (`USERNAME`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appadmin`
--

LOCK TABLES `appadmin` WRITE;
/*!40000 ALTER TABLE `appadmin` DISABLE KEYS */;
INSERT INTO `appadmin` (`USERNAME`, `ROLE`, `ACCESS_LEVEL`, `DEPARTMENT`) VALUES ('saranj','Administrator','FULL','Engineering'),('vaibhavthalanki','Editor','EDIT','Engineering');
/*!40000 ALTER TABLE `appadmin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicant`
--

DROP TABLE IF EXISTS `applicant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applicant` (
  `USERNAME` varchar(255) DEFAULT NULL,
  `APPLICANT_ID` int NOT NULL AUTO_INCREMENT,
  `GENDER` enum('Male','Female','Other') NOT NULL,
  `DATE_OF_BIRTH` date DEFAULT NULL,
  `ADDRESS_STREET_NAME` varchar(255) NOT NULL,
  `ADDRESS_STREET_NUM` int NOT NULL,
  `ADDRESS_TOWN` varchar(255) NOT NULL,
  `ADDRESS_STATE` varchar(50) NOT NULL,
  `ADDRESS_ZIPCODE` varchar(20) NOT NULL,
  `RACE` enum('Asian','Black','Hispanic','White','Native American','Other') DEFAULT NULL,
  `VETERAN_STATUS` tinyint(1) DEFAULT NULL,
  `DISABILITY_STATUS` tinyint(1) DEFAULT NULL,
  `CITIZENSHIP_STATUS` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`APPLICANT_ID`),
  UNIQUE KEY `USERNAME` (`USERNAME`),
  CONSTRAINT `applicant_ibfk_1` FOREIGN KEY (`USERNAME`) REFERENCES `appuser` (`USERNAME`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicant`
--

LOCK TABLES `applicant` WRITE;
/*!40000 ALTER TABLE `applicant` DISABLE KEYS */;
INSERT INTO `applicant` (`USERNAME`, `APPLICANT_ID`, `GENDER`, `DATE_OF_BIRTH`, `ADDRESS_STREET_NAME`, `ADDRESS_STREET_NUM`, `ADDRESS_TOWN`, `ADDRESS_STATE`, `ADDRESS_ZIPCODE`, `RACE`, `VETERAN_STATUS`, `DISABILITY_STATUS`, `CITIZENSHIP_STATUS`) VALUES ('john_doe',1,'Male','1998-06-15','Main St',101,'Example Town','Example State','12345','White',0,0,'India'),('jane_smith',2,'Female','1999-02-20','Second St',202,'Sample Town','Sample State','67890','Asian',1,0,'USA');
/*!40000 ALTER TABLE `applicant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicant_skills`
--

DROP TABLE IF EXISTS `applicant_skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applicant_skills` (
  `SKILL_NAME` varchar(255) NOT NULL,
  `SKILL_LEVEL` enum('Beginner','Advanced','Intermediate') NOT NULL,
  `APPLICANT_ID` int DEFAULT NULL,
  KEY `APPLICANT_ID` (`APPLICANT_ID`),
  KEY `SKILL_NAME` (`SKILL_NAME`),
  CONSTRAINT `applicant_skills_ibfk_1` FOREIGN KEY (`APPLICANT_ID`) REFERENCES `applicant` (`APPLICANT_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `applicant_skills_ibfk_2` FOREIGN KEY (`SKILL_NAME`) REFERENCES `skill` (`SKILL_NAME`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicant_skills`
--

LOCK TABLES `applicant_skills` WRITE;
/*!40000 ALTER TABLE `applicant_skills` DISABLE KEYS */;
INSERT INTO `applicant_skills` (`SKILL_NAME`, `SKILL_LEVEL`, `APPLICANT_ID`) VALUES ('Python','Intermediate',1),('C++','Advanced',1),('Java','Intermediate',1),('SQL','Beginner',1),('JavaScript','Beginner',1),('Python','Advanced',2),('React','Intermediate',2),('HTML','Advanced',2),('CSS','Advanced',2),('Node.js','Intermediate',2),('Git','Beginner',2),('Docker','Beginner',2);
/*!40000 ALTER TABLE `applicant_skills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicant_university`
--

DROP TABLE IF EXISTS `applicant_university`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applicant_university` (
  `USERNAME` varchar(255) NOT NULL,
  `UNIVERSITY` varchar(255) NOT NULL,
  `GPA` float DEFAULT NULL,
  `DEGREE` varchar(100) NOT NULL,
  `MAJOR` varchar(100) NOT NULL,
  `GRAD_DATE` date DEFAULT NULL,
  PRIMARY KEY (`USERNAME`,`UNIVERSITY`,`MAJOR`,`DEGREE`),
  KEY `UNIVERSITY` (`UNIVERSITY`),
  CONSTRAINT `applicant_university_ibfk_1` FOREIGN KEY (`USERNAME`) REFERENCES `applicant` (`USERNAME`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `applicant_university_ibfk_2` FOREIGN KEY (`UNIVERSITY`) REFERENCES `university` (`NAME`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicant_university`
--

LOCK TABLES `applicant_university` WRITE;
/*!40000 ALTER TABLE `applicant_university` DISABLE KEYS */;
INSERT INTO `applicant_university` (`USERNAME`, `UNIVERSITY`, `GPA`, `DEGREE`, `MAJOR`, `GRAD_DATE`) VALUES ('jane_smith','California Institute of Technology',4,'Bachelors','ECE','2024-09-30'),('jane_smith','Northeastern U',4,'Masters','EEE','2028-09-30'),('john_doe','Stanford University',3.9,'Bachelors','CS','2026-09-30');
/*!40000 ALTER TABLE `applicant_university` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applies`
--

DROP TABLE IF EXISTS `applies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applies` (
  `APPLICANT_ID` int NOT NULL,
  `POST_ID` int NOT NULL,
  `APPLICATION_DATE` date NOT NULL,
  `APPLICATION_STATUS` varchar(255) NOT NULL DEFAULT 'ON PROGRESS',
  PRIMARY KEY (`APPLICANT_ID`,`POST_ID`),
  KEY `POST_ID` (`POST_ID`),
  CONSTRAINT `applies_ibfk_1` FOREIGN KEY (`APPLICANT_ID`) REFERENCES `applicant` (`APPLICANT_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `applies_ibfk_2` FOREIGN KEY (`POST_ID`) REFERENCES `posting` (`POST_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applies`
--

LOCK TABLES `applies` WRITE;
/*!40000 ALTER TABLE `applies` DISABLE KEYS */;
INSERT INTO `applies` (`APPLICANT_ID`, `POST_ID`, `APPLICATION_DATE`, `APPLICATION_STATUS`) VALUES (1,1,'2023-08-15','ON PROGRESS'),(2,2,'2023-08-20','ON PROGRESS');
/*!40000 ALTER TABLE `applies` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Prevent_Duplicate_Applications` BEFORE INSERT ON `applies` FOR EACH ROW BEGIN
    IF EXISTS (
        SELECT 1 FROM Applies
        WHERE APPLICANT_ID = NEW.APPLICANT_ID AND POST_ID = NEW.POST_ID
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Duplicate application detected';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `appuser`
--

DROP TABLE IF EXISTS `appuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appuser` (
  `USERNAME` varchar(255) NOT NULL,
  `PASSWORD` varchar(255) NOT NULL,
  `FIRST_NAME` varchar(255) NOT NULL,
  `LAST_NAME` varchar(255) NOT NULL,
  `EMAIL` varchar(255) NOT NULL,
  PRIMARY KEY (`USERNAME`),
  UNIQUE KEY `EMAIL` (`EMAIL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appuser`
--

LOCK TABLES `appuser` WRITE;
/*!40000 ALTER TABLE `appuser` DISABLE KEYS */;
INSERT INTO `appuser` (`USERNAME`, `PASSWORD`, `FIRST_NAME`, `LAST_NAME`, `EMAIL`) VALUES ('jane_smith','Hello123!','Jane','Smith','jane.smith@gmail.com'),('john_doe','password','John','Doe','john.doe@gmail.com'),('saranj','password123','saran','jagadeesan','jagadeesanuma.s@northeastern.edu'),('vaibhavthalanki','editor123','vaibhav','thalanki','thalanki.v@northeastern.edu');
/*!40000 ALTER TABLE `appuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company` (
  `NAME` varchar(255) NOT NULL,
  `WEBSITE` varchar(255) DEFAULT NULL,
  `INDUSTRY` varchar(255) NOT NULL,
  `FOUNDED_ON` date DEFAULT NULL,
  PRIMARY KEY (`NAME`),
  UNIQUE KEY `NAME` (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` (`NAME`, `WEBSITE`, `INDUSTRY`, `FOUNDED_ON`) VALUES ('Adobe','https://www.adobe.com/','Software','1982-12-01'),('Amazon','https://www.amazon.com/','E-commerce','1994-07-05'),('Apple','https://www.apple.com/','Technology','1976-04-01'),('Facebook','https://www.facebook.com/','Technology','2004-02-04'),('Google','https://www.google.com/','Technology','1998-09-04'),('IBM','https://www.ibm.com/','Technology','1911-06-16'),('Intel','https://www.intel.com/','Technology','1968-07-18'),('Microsoft','https://www.microsoft.com/','Technology','1975-04-04'),('Netflix','https://www.netflix.com/','Entertainment','1997-08-29'),('Oracle','https://www.oracle.com/','Technology','1977-06-16'),('Salesforce','https://www.salesforce.com/','Technology','1999-02-03'),('Snap Inc.','https://www.snapchat.com/','Social Media','2011-09-16'),('Spotify','https://www.spotify.com/','Music Streaming','2006-04-23'),('Tesla','https://www.tesla.com/','Automotive','2003-07-01'),('Twitter','https://www.twitter.com/','Social Media','2006-03-21');
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posting`
--

DROP TABLE IF EXISTS `posting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posting` (
  `POST_ID` int NOT NULL AUTO_INCREMENT,
  `LOCATION` varchar(255) NOT NULL,
  `TERM` enum('Fall','Spring','Summer','Winter') NOT NULL,
  `TYPE` varchar(255) NOT NULL,
  `DATE_POSTED` date NOT NULL,
  `PAY` decimal(10,2) NOT NULL,
  `ROLE_NAME` varchar(255) NOT NULL,
  `CREATED_BY` varchar(255) NOT NULL,
  `COMPANY_NAME` varchar(255) NOT NULL,
  `DESCRIPTION` text NOT NULL,
  PRIMARY KEY (`POST_ID`),
  KEY `CREATED_BY` (`CREATED_BY`),
  KEY `COMPANY_NAME` (`COMPANY_NAME`),
  CONSTRAINT `posting_ibfk_1` FOREIGN KEY (`CREATED_BY`) REFERENCES `appadmin` (`USERNAME`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `posting_ibfk_2` FOREIGN KEY (`COMPANY_NAME`) REFERENCES `company` (`NAME`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posting`
--

LOCK TABLES `posting` WRITE;
/*!40000 ALTER TABLE `posting` DISABLE KEYS */;
INSERT INTO `posting` (`POST_ID`, `LOCATION`, `TERM`, `TYPE`, `DATE_POSTED`, `PAY`, `ROLE_NAME`, `CREATED_BY`, `COMPANY_NAME`, `DESCRIPTION`) VALUES (1,'Remote','Summer','Internship','2023-04-01',20.00,'Software Development Intern','saranj','Google','Intern will assist in developing web applications using JavaScript and React.'),(2,'Seattle, WA','Fall','Internship','2023-08-15',25.00,'Cloud Engineer Intern','vaibhavthalanki','Amazon','Work on scalable cloud solutions and assist in AWS infrastructure projects.'),(3,'Cupertino, CA','Spring','Internship','2024-01-20',30.00,'Hardware Engineering Intern','saranj','Apple','Support in designing and testing new hardware components for consumer devices.'),(4,'Menlo Park, CA','Summer','Internship','2023-03-12',22.00,'Data Analyst Intern','vaibhavthalanki','Facebook','Analyze large datasets to derive actionable insights for improving platform engagement.'),(5,'Los Gatos, CA','Summer','Internship','2023-04-10',27.50,'Machine Learning Intern','saranj','Netflix','Build and optimize recommendation algorithms for streaming services.'),(6,'Redmond, WA','Winter','Internship','2023-11-01',28.00,'Product Manager Intern','vaibhavthalanki','Microsoft','Collaborate with cross-functional teams to define product roadmaps and launch features.'),(7,'Palo Alto, CA','Summer','Internship','2023-05-01',35.00,'Autonomous Driving Intern','saranj','Tesla','Develop and test software for Tesla’s autonomous vehicle systems.'),(8,'San Jose, CA','Fall','Internship','2023-09-15',26.00,'Software Engineer Intern','saranj','Adobe','Contribute to the development of cutting-edge creative software solutions.'),(9,'Austin, TX','Spring','Internship','2024-02-01',23.00,'Marketing Analytics Intern','vaibhavthalanki','Oracle','Work on data-driven strategies to enhance marketing campaigns and performance.'),(10,'Boston, MA','Summer','Internship','2023-06-01',20.00,'Business Analyst Intern','vaibhavthalanki','Salesforce','Assist in business analysis, including financial modeling and market research.'),(11,'New York, NY','Spring','Internship','2024-02-10',24.00,'Cybersecurity Intern','saranj','IBM','Enhance security measures and perform vulnerability assessments on critical systems.'),(12,'Remote','Winter','Internship','2023-12-01',21.50,'Frontend Development Intern','vaibhavthalanki','Snap Inc.','Design and implement user-friendly web interfaces using modern frameworks.'),(13,'San Francisco, CA','Summer','Internship','2023-07-01',22.50,'Software Engineer Intern','vaibhavthalanki','Spotify','Build and maintain APIs and features for the Spotify music platform.');
/*!40000 ALTER TABLE `posting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requires`
--

DROP TABLE IF EXISTS `requires`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requires` (
  `SKILL_NAME` varchar(255) NOT NULL,
  `LEVEL` enum('Beginner','Advanced','Intermediate') NOT NULL,
  `POST_ID` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`SKILL_NAME`,`POST_ID`),
  KEY `POST_ID` (`POST_ID`),
  CONSTRAINT `requires_ibfk_1` FOREIGN KEY (`SKILL_NAME`) REFERENCES `skill` (`SKILL_NAME`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `requires_ibfk_2` FOREIGN KEY (`POST_ID`) REFERENCES `posting` (`POST_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requires`
--

LOCK TABLES `requires` WRITE;
/*!40000 ALTER TABLE `requires` DISABLE KEYS */;
/*!40000 ALTER TABLE `requires` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skill`
--

DROP TABLE IF EXISTS `skill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skill` (
  `SKILL_NAME` varchar(255) NOT NULL,
  `DESCRIPTION` text,
  `CATEGORY` varchar(255) NOT NULL,
  PRIMARY KEY (`SKILL_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skill`
--

LOCK TABLES `skill` WRITE;
/*!40000 ALTER TABLE `skill` DISABLE KEYS */;
INSERT INTO `skill` (`SKILL_NAME`, `DESCRIPTION`, `CATEGORY`) VALUES ('AWS','Cloud platform offering computing and storage services','Cloud Computing'),('C#','Programming language commonly used in game development and enterprise applications','Programming'),('C++','Programming language for system-level and competitive programming','Programming'),('CSS','Stylesheet language for designing web pages','Web Development'),('Docker','Tool for containerizing applications','DevOps'),('Git','Version control system for tracking changes in code','Version Control'),('Go','Programming language for building scalable systems','Programming'),('HTML','Markup language for structuring web content','Web Development'),('Java','Programming language','Programming'),('JavaScript','Programming language for web development','Programming'),('Kubernetes','Orchestration tool for managing containerized applications','DevOps'),('Linux','Open-source operating system','System Administration'),('Matlab','Numerical computing environment and programming language','Engineering'),('Node.js','JavaScript runtime environment for backend development','Backend Development'),('PHP','Server-side scripting language for web development','Web Development'),('Power BI','Business analytics tool by Microsoft','Data Analytics'),('Python','Programming language','Programming'),('PyTorch','Deep learning framework','Machine Learning'),('R','Programming language for statistical computing and graphics','Data Science'),('React','JavaScript library for building user interfaces','Web Development'),('Ruby','Programming language for web development, often used with Rails','Programming'),('SQL','Database language','Database'),('Tableau','Data visualization tool','Data Analytics'),('TensorFlow','Open-source library for machine learning','Machine Learning');
/*!40000 ALTER TABLE `skill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `university`
--

DROP TABLE IF EXISTS `university`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `university` (
  `NAME` varchar(255) NOT NULL,
  `FOUNDED_ON` date DEFAULT NULL,
  `ADDRESS_STREET` varchar(255) DEFAULT NULL,
  `ADDRESS_CITY` varchar(255) DEFAULT NULL,
  `ADDRESS_ZIP` varchar(20) DEFAULT NULL,
  `RANKING` int DEFAULT NULL,
  `TYPE` enum('Public','Private','Co-owned') DEFAULT NULL,
  PRIMARY KEY (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `university`
--

LOCK TABLES `university` WRITE;
/*!40000 ALTER TABLE `university` DISABLE KEYS */;
INSERT INTO `university` (`NAME`, `FOUNDED_ON`, `ADDRESS_STREET`, `ADDRESS_CITY`, `ADDRESS_ZIP`, `RANKING`, `TYPE`) VALUES ('California Institute of Technology','1891-11-11','1200 E California Blvd','Pasadena','91125',10,'Private'),('Harvard University','1636-09-08','Massachusetts Hall','Cambridge','02138',1,'Private'),('Massachusetts Institute of Technology','1861-04-10','77 Massachusetts Ave','Cambridge','02139',6,'Private'),('Northeastern U','1898-05-15','360 Huntington Av','Boston','02115',3,'Private'),('Princeton U','1746-01-01','1 Nassau Hall','Princeton','08544',2,'Private'),('Stanford University','1885-11-11','450 Serra Mall','Stanford','94305',4,'Private'),('University of California, Berkeley','1868-03-23','200 California Hall','Berkeley','94720',5,'Public'),('University of Chicago','1890-07-01','5801 S Ellis Ave','Chicago','60637',9,'Private'),('University of Michigan','1817-08-26','500 S State St','Ann Arbor','48109',11,'Public'),('University of Texas at Austin','1883-09-15','110 Inner Campus Drive','Austin','78712',7,'Public'),('University of Washington','1861-11-04','1410 NE Campus Parkway','Seattle','98195',12,'Public'),('Yale University','1701-10-09','Woodbridge Hall','New Haven','06520',8,'Private');
/*!40000 ALTER TABLE `university` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `worksin`
--

DROP TABLE IF EXISTS `worksin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `worksin` (
  `USERNAME` varchar(255) NOT NULL,
  `COMPANY_NAME` varchar(255) NOT NULL,
  `SALARY` decimal(10,2) DEFAULT NULL,
  `MONTHS` int NOT NULL,
  `POSITION` varchar(255) NOT NULL,
  `DESCRIPTION` text,
  PRIMARY KEY (`USERNAME`,`COMPANY_NAME`,`POSITION`),
  KEY `COMPANY_NAME` (`COMPANY_NAME`),
  CONSTRAINT `worksin_ibfk_1` FOREIGN KEY (`USERNAME`) REFERENCES `applicant` (`USERNAME`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `worksin_ibfk_2` FOREIGN KEY (`COMPANY_NAME`) REFERENCES `company` (`NAME`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `worksin`
--

LOCK TABLES `worksin` WRITE;
/*!40000 ALTER TABLE `worksin` DISABLE KEYS */;
INSERT INTO `worksin` (`USERNAME`, `COMPANY_NAME`, `SALARY`, `MONTHS`, `POSITION`, `DESCRIPTION`) VALUES ('jane_smith','Oracle',65000.00,18,'Business Analyst',NULL),('john_doe','Adobe',75000.00,12,'Data Scientist','Developed ETL pipelines and focused on model building.'),('john_doe','Intel',85000.00,24,'Software Engineer','Developed backend systems and services in golang.');
/*!40000 ALTER TABLE `worksin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'internship_tracking_application'
--

--
-- Dumping routines for database 'internship_tracking_application'
--
/*!50003 DROP FUNCTION IF EXISTS `CalculateAge` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `CalculateAge`(dob DATE) RETURNS int
    DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, dob, CURDATE());
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AddCompanyIfNotExists` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddCompanyIfNotExists`(IN companyName VARCHAR(255), IN industry VARCHAR(255), OUT companyNameOut VARCHAR(255))
BEGIN
    DECLARE existingIndustry VARCHAR(255);
    SELECT INDUSTRY INTO existingIndustry FROM Company WHERE NAME = companyName LIMIT 1;
    IF existingIndustry IS NOT NULL THEN
        IF existingIndustry != industry THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Existing company found with a different industry.';
        END IF;
    ELSE
        INSERT INTO Company (NAME, INDUSTRY) VALUES (companyName, industry);
    END IF;
    SET companyNameOut = companyName;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreatePosting` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreatePosting`(
    IN location VARCHAR(255),
    IN term ENUM('Fall', 'Spring', 'Summer', 'Winter'),
    IN type VARCHAR(50),
    IN pay DECIMAL(10, 2),
    IN companyName VARCHAR(255),
    IN roleName VARCHAR(255),
    IN createdBy VARCHAR(255),
    IN description TEXT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Company WHERE NAME = companyName) THEN
        INSERT INTO Company (NAME) VALUES (companyName);
    END IF;

    INSERT INTO Posting (LOCATION, TERM, TYPE, DATE_POSTED, PAY, ROLE_NAME, CREATED_BY, COMPANY_NAME, DESCRIPTION)
    VALUES (location, term, type, NOW(), pay, roleName, createdBy, companyName, description);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DeletePosting` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeletePosting`(IN postId INT)
BEGIN
    -- Delete associated applications
    DELETE FROM Applies WHERE POST_ID = postId;

    -- Now delete the posting
    DELETE FROM Posting WHERE POST_ID = postId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `EditPosting` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EditPosting`(
    IN postId INT,
    IN location VARCHAR(255),
    IN term ENUM('Fall', 'Spring', 'Summer', 'Winter'),
    IN type VARCHAR(50),
    IN pay DECIMAL(10, 2),
    IN companyName VARCHAR(255),
    IN roleName VARCHAR(255),
    IN description TEXT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Company WHERE NAME = companyName) THEN
        INSERT INTO Company (NAME) VALUES (companyName);
    END IF;
    UPDATE Posting
    SET 
        LOCATION = location,
        TERM = term,
        TYPE = type,
        PAY = pay,
        ROLE_NAME = roleName,
        COMPANY_NAME = companyName,
        DESCRIPTION = description
    WHERE POST_ID = postId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAdminData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAdminData`(IN adminUsername VARCHAR(255))
BEGIN
    SELECT * FROM appAdmin WHERE USERNAME = adminUsername;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetApplicantInfo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetApplicantInfo`(IN input_username VARCHAR(255))
BEGIN
    SELECT 
        A.*,
        U.* 
    FROM 
        Applicant A
    JOIN 
        AppUser  U ON A.USERNAME = U.USERNAME
    WHERE 
        A.USERNAME = input_username;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetApplicantUniversityDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetApplicantUniversityDetails`(
    IN p_username VARCHAR(255)
)
BEGIN
    SELECT 
        *
    FROM 
        Applicant_University
    WHERE 
        USERNAME = p_username;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetCompanyNames` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCompanyNames`()
BEGIN
	SELECT NAME FROM Company;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetWorksInInfoByUsername` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetWorksInInfoByUsername`(
    IN input_username VARCHAR(255)
)
BEGIN
    SELECT 
        w.USERNAME,
        w.COMPANY_NAME,
        w.SALARY,
        w.MONTHS,
        w.DESCRIPTION,
        w.POSITION,
        c.WEBSITE,
        c.INDUSTRY
    FROM 
        WorksIn w
    INNER JOIN 
        Company c ON w.COMPANY_NAME = c.NAME
    WHERE 
        w.USERNAME = input_username;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdatePosting` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdatePosting`(
    IN p_post_id INT,
    IN p_location VARCHAR(255),
    IN p_term VARCHAR(50),
    IN p_type VARCHAR(50),
    IN p_pay DECIMAL(10, 2),
    IN p_company_name VARCHAR(255),
    IN p_role_name VARCHAR(255),
    IN p_description TEXT
)
BEGIN
    UPDATE posting
    SET 
        LOCATION = p_location,
        TERM = p_term,
        TYPE = p_type,
        PAY = p_pay,
        COMPANY_NAME = p_company_name,
        ROLE_NAME = p_role_name,
        DESCRIPTION = p_description
    WHERE POST_ID = p_post_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_user_app_info` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user_app_info`(
    IN p_username VARCHAR(255),
    IN p_first_name VARCHAR(255),
    IN p_last_name VARCHAR(255),
    IN p_gender ENUM('Male', 'Female', 'Other'),
    IN p_date_of_birth DATE,
    IN p_address_street_name VARCHAR(255),
    IN p_address_street_num INT,
    IN p_address_town VARCHAR(255),
    IN p_address_state VARCHAR(50),
    IN p_address_zipcode VARCHAR(20),
    IN p_race ENUM('Asian', 'Black', 'Hispanic', 'White', 'Native American', 'Other'),
    IN p_veteran_status BOOLEAN,
    IN p_disability_status BOOLEAN,
    IN p_citizenship_status VARCHAR(50)
)
BEGIN
    START TRANSACTION;
    UPDATE Applicant
    SET 
        GENDER = p_gender, 
        DATE_OF_BIRTH = p_date_of_birth, 
        ADDRESS_STREET_NAME = p_address_street_name, 
        ADDRESS_STREET_NUM = p_address_street_num, 
        ADDRESS_TOWN = p_address_town, 
        ADDRESS_STATE = p_address_state, 
        ADDRESS_ZIPCODE = p_address_zipcode, 
        RACE = p_race, 
        VETERAN_STATUS = p_veteran_status, 
        DISABILITY_STATUS = p_disability_status, 
        CITIZENSHIP_STATUS = p_citizenship_status
    WHERE USERNAME = p_username;
    UPDATE AppUser
    SET 
        FIRST_NAME = p_first_name, 
        LAST_NAME = p_last_name
    WHERE USERNAME = p_username;
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-05 13:11:26


