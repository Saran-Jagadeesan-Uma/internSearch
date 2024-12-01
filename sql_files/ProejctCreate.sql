-- Creating a Database For tracking Intern Applications
DROP DATABASE IF EXISTS Internship_Tracking_Application;
CREATE DATABASE IF NOT EXISTS Internship_Tracking_Application;
USE Internship_Tracking_Application;

-- Creating a table for handling App user
CREATE TABLE IF NOT EXISTS AppUser (
    USERNAME VARCHAR(255) PRIMARY KEY,
    PASSWORD VARCHAR(255) NOT NULL UNIQUE,
    FIRST_NAME VARCHAR(255) NOT NULL,
    LAST_NAME VARCHAR(255) NOT NULL,
    EMAIL VARCHAR(255) NOT NULL UNIQUE
);


-- Creating a table for App Admin's Detail
CREATE TABLE IF NOT EXISTS AppAdmin (
    USERNAME VARCHAR(255) UNIQUE,
    ROLE VARCHAR(255) NOT NULL,
    ACCESS_LEVEL ENUM('FULL', 'EDIT', 'VIEW') NOT NULL,
    DEPARTMENT VARCHAR(255),
    FOREIGN KEY (USERNAME) REFERENCES AppUser (USERNAME) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Create a table that stores the Current University Details
CREATE TABLE IF NOT EXISTS University (
    NAME VARCHAR(255) PRIMARY KEY,
    FOUNDED_ON DATE,
    ADDRESS_STREET VARCHAR(255),
    ADDRESS_CITY VARCHAR(255),
    ADDRESS_ZIP VARCHAR(20),
    RANKING INT,
    TYPE VARCHAR(50) NOT NULL
);

-- Creating a table for Applicant Details
CREATE TABLE IF NOT EXISTS Applicant (
    USERNAME VARCHAR(255) UNIQUE,
    APPLICANT_ID INT PRIMARY KEY AUTO_INCREMENT,
    GENDER ENUM('Male', 'Female', 'Other') NOT NULL,
    DATE_OF_BIRTH DATE NOT NULL,
    ADDRESS_STREET_NAME VARCHAR(255) NOT NULL,
    ADDRESS_STREET_NUM INT NOT NULL,
    ADDRESS_TOWN VARCHAR(255) NOT NULL,
    ADDRESS_STATE VARCHAR(50) NOT NULL,
    ADDRESS_ZIPCODE VARCHAR(20) NOT NULL,
    RACE ENUM('Asian', 'Black', 'Hispanic', 'White', 'Native American', 'Other') NOT NULL,
    VETERAN_STATUS BOOLEAN,
    DISABILITY_STATUS BOOLEAN,
    CITIZENSHIP_STATUS VARCHAR(50),
    FOREIGN KEY (USERNAME) REFERENCES AppUser (USERNAME) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Applicant_University (
	USERNAME VARCHAR(255),
    UNIVERSITY VARCHAR(255),
    GPA FLOAT,
    DEGREE VARCHAR(100),
    MAJOR VARCHAR(100),
    GRAD_DATE DATE,
    PRIMARY KEY (USERNAME,UNIVERSITY,MAJOR, DEGREE),
    FOREIGN KEY (USERNAME) REFERENCES Applicant (USERNAME) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (UNIVERSITY) REFERENCES University(NAME) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Create A function that returns the age based on date of birth
DELIMITER $$
CREATE FUNCTION CalculateAge(dob DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, dob, CURDATE());
END $$
DELIMITER ;

-- Create A table that stores Company Details
CREATE TABLE IF NOT EXISTS Company (
    NAME VARCHAR(255) NOT NULL UNIQUE,
    WEBSITE VARCHAR(255),
    INDUSTRY VARCHAR(255) NOT NULL,
    FOUNDED_ON DATE NOT NULL,
    PRIMARY KEY (NAME, FOUNDED_ON)
);

-- Table to denote the many-to-many relationship between Applicant and Company
CREATE TABLE IF NOT EXISTS WorksIn (
    APPLICANT_ID INT,
    COMPANY_NAME VARCHAR(255),
    COMPANY_FOUNDED_ON DATE,
    SALARY DECIMAL(10, 2) NOT NULL,
    MONTHS INT NOT NULL,
    POSITION VARCHAR(255) NOT NULL,
    FOREIGN KEY (APPLICANT_ID) REFERENCES Applicant(APPLICANT_ID),
    FOREIGN KEY (COMPANY_NAME, COMPANY_FOUNDED_ON) REFERENCES Company(NAME, FOUNDED_ON),
    PRIMARY KEY (APPLICANT_ID, COMPANY_NAME, COMPANY_FOUNDED_ON)
);

-- Create A table that stores Postings
CREATE TABLE IF NOT EXISTS Posting (
    POST_ID INT PRIMARY KEY AUTO_INCREMENT,
    LOCATION VARCHAR(255) NOT NULL,
    TERM ENUM('Fall', 'Spring', 'Summer', ' Winter') NOT NULL,
    TYPE VARCHAR(255) NOT NULL,
    DATE_POSTED DATE NOT NULL,
    MIN_GPA FLOAT NOT NULL,
    DEADLINE DATE NOT NULL,
    PAY DECIMAL(10, 2) NOT NULL,
    COMPANY_NAME VARCHAR(255) NOT NULL,
    ROLE_NAME VARCHAR(255) NOT NULL,
    CREATED_BY VARCHAR(255),
    FOREIGN KEY (CREATED_BY) REFERENCES AppAdmin(USERNAME) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Table to denote the many-to-many relationship between AppUser  and Posting
CREATE TABLE IF NOT EXISTS VIEWS (
    USERNAME VARCHAR(255),
    POST_ID INT,
    PRIMARY KEY (USERNAME, POST_ID),
    FOREIGN KEY (USERNAME) REFERENCES AppUser (USERNAME) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (POST_ID) REFERENCES Posting(POST_ID) ON UPDATE CASCADE ON DELETE CASCADE
);

-- To denote the many-to-many relationship between Applicant and Posting
CREATE TABLE IF NOT EXISTS Applies (
    APPLICANT_ID INT,
    POST_ID INT,
    APPLICATION_DATE DATE NOT NULL,
    APPLICATION_STATUS VARCHAR(255) NOT NULL DEFAULT 'ON PROGRESS',
    SPONSORSHIP_NEEDED BOOLEAN NOT NULL,
    RELOCATION_PREFERENCE BOOLEAN NOT NULL,
    FOREIGN KEY (APPLICANT_ID) REFERENCES Applicant(APPLICANT_ID),
    FOREIGN KEY (POST_ID) REFERENCES Posting(POST_ID),
    PRIMARY KEY (APPLICANT_ID, POST_ID)
);

-- Create a table that stores specific descriptions on the internship
CREATE TABLE IF NOT EXISTS Intern_Role (
    ROLE_NAME VARCHAR(255) PRIMARY KEY,
    DESCRIPTION TEXT NOT NULL
);

-- Table Representing Ternary Relationship
CREATE TABLE IF NOT EXISTS Posts (
    POST_ID INT,
    ROLE_NAME VARCHAR(255) NOT NULL,
    COMPANY_NAME VARCHAR(255) NOT NULL,
    COMPANY_FOUNDED_ON DATE NOT NULL,
    PRIMARY KEY (POST_ID, ROLE_NAME, COMPANY_NAME, COMPANY_FOUNDED_ON),
    FOREIGN KEY (POST_ID) REFERENCES Posting(POST_ID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ROLE_NAME) REFERENCES Intern_Role(ROLE_NAME) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (COMPANY_NAME, COMPANY_FOUNDED_ON) REFERENCES Company(NAME, FOUNDED_ON) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Table that stores the applicant's skill and required skills
CREATE TABLE IF NOT EXISTS Skill (
    SKILL_NAME VARCHAR(255) NOT NULL,
    DESCRIPTION TEXT,
    LEVEL VARCHAR(50) NOT NULL,
    CATEGORY VARCHAR(255) NOT NULL,
    PRIMARY KEY (SKILL_NAME, LEVEL)
);

-- Table to denote the many-to-many relationship between InternRole and Skill
CREATE TABLE IF NOT EXISTS Requires (
    ROLE_NAME VARCHAR(255),
    SKILL_NAME VARCHAR(255) NOT NULL,
    SKILL_LEVEL VARCHAR(50) NOT NULL,
    FOREIGN KEY (ROLE_NAME) REFERENCES Intern_Role(ROLE_NAME),
    FOREIGN KEY (SKILL_NAME, SKILL_LEVEL) REFERENCES Skill(SKILL_NAME, LEVEL),
    PRIMARY KEY (ROLE_NAME, SKILL_NAME, SKILL_LEVEL)
);

-- Table to denote relation between Applicant and Skill
CREATE TABLE IF NOT EXISTS Applicant_Skills (
    SKILL_NAME VARCHAR(255) NOT NULL,
    SKILL_LEVEL VARCHAR(50) NOT NULL,
    APPLICANT_ID INT,
    FOREIGN KEY (APPLICANT_ID) REFERENCES Applicant(APPLICANT_ID),
    FOREIGN KEY (SKILL_NAME, SKILL_LEVEL) REFERENCES Skill(SKILL_NAME, LEVEL)
);

INSERT INTO University (NAME, FOUNDED_ON, ADDRESS_STREET, ADDRESS_CITY, ADDRESS_ZIP, RANKING, TYPE) VALUES
('Example University', '2000-01-01', '123 University St', 'Example City', '12345', 1, 'Public'),
('Sample College', '1995-05-15', '456 College Ave', 'Sample Town', '67890', 2, 'Private');


INSERT INTO AppUser  (USERNAME, PASSWORD, FIRST_NAME, LAST_NAME, EMAIL) VALUES
('john_doe', 'password123', 'John', 'Doe', 'john.doe@example.com'),
('jane_smith', 'password456', 'Jane', 'Smith', 'jane.smith@example.com'),
('alice_jones', 'password789', 'Alice', 'Jones', 'alice.jones@example.com'),
('admin_user', 'xxxx', 'shrey', 'shah','shreyshah@exampledomain.com'),
('editor_user', 'dbms_project', 'vaibhav', 'thalanki','thalanki.v@northeastern.edu');

INSERT INTO AppAdmin (USERNAME, ROLE, ACCESS_LEVEL, DEPARTMENT) VALUES
('admin_user', 'Administrator', 'FULL', 'HR'),
('editor_user', 'Editor', 'EDIT', 'Recruitment');


INSERT INTO Applicant (USERNAME, GENDER, DATE_OF_BIRTH, ADDRESS_STREET_NAME, ADDRESS_STREET_NUM, ADDRESS_TOWN, ADDRESS_STATE, ADDRESS_ZIPCODE, RACE, VETERAN_STATUS, DISABILITY_STATUS, CITIZENSHIP_STATUS) VALUES
('john_doe', 'Male', '1998-06-15', 'Main St', 101, 'Example Town', 'Example State', '12345', 'White', false, false, 'USA'),
('jane_smith', 'Female', '1999-02-20', 'Second St', 202, 'Sample Town', 'Sample State', '67890', 'Asian', false, false, 'USA'),
('alice_jones', 'Female', '2000-03-30', 'Third St', 303, 'Example City', 'Example State', '12345', 'Hispanic', false, false, 'USA');


INSERT INTO Company (NAME, WEBSITE, INDUSTRY, FOUNDED_ON) VALUES
('Tech Innovations', 'https://techinnovations.com', 'Technology', '2010-04-01'),
('Green Solutions', 'https://greensolutions.com', 'Environmental', '2015-08-15');

INSERT INTO Intern_Role (ROLE_NAME, DESCRIPTION) VALUES
('Software Intern', 'Intern working on software development projects.'),
('Environmental Intern', 'Intern assisting with environmental research and projects.');

INSERT INTO Posting ( LOCATION, TERM, TYPE, DATE_POSTED, MIN_GPA, DEADLINE, PAY, COMPANY_NAME, ROLE_NAME, CREATED_BY) VALUES
('New York', 'Summer', 'Internship', '2023-01-01', 3.0, '2023-04-01', 20.00, 'Tech Innovations', 'Software Intern', 'admin_user'),
('San Francisco', 'Fall', 'Internship', '2023-02-01', 3.5, '2023-05-01', 25.00, 'Green Solutions', 'Environmental Intern', 'editor_user');


DELIMITER $$

CREATE PROCEDURE GetApplicantInfo(IN input_username VARCHAR(255))
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
END $$

DELIMITER ;


CALL GetApplicantInfo('john_doe');
-- -----------------------------


-- Inserting dummy data into CurrentUniversity
INSERT INTO University (NAME, FOUNDED_ON, ADDRESS_STREET, ADDRESS_CITY, ADDRESS_ZIP, RANKING, TYPE) VALUES
('University A', '2000-01-01', '123 Main St', 'City A', '12345', 1, 'Public'),
('University B', '1995-05-15', '456 Elm St', 'City B', '67890', 2, 'Private');

-- Inserting dummy data into Company
INSERT INTO Company (NAME, WEBSITE, INDUSTRY, FOUNDED_ON) VALUES
('Tech Corp', 'www.techcorp.com', 'Technology', '2010-01-01'),
('Innovate Inc', 'www.innovateinc.com', 'Consulting', '2015-05-05');

-- Inserting dummy data into Skill
INSERT INTO Skill (SKILL_NAME, DESCRIPTION, LEVEL, CATEGORY) VALUES
('Python', 'Programming language', 'Intermediate', 'Programming'),
('Java', 'Programming language', 'Beginner', 'Programming'),
('SQL', 'Database language', 'Advanced', 'Database');

-- Inserting dummy data into Intern_Role
INSERT INTO Intern_Role (ROLE_NAME, DESCRIPTION) VALUES
('Software Engineer', 'Develops software applications.'),
('Data Analyst Intern', 'Analyzes data and provides insights.');

-- Inserting dummy data into Requires
INSERT INTO Requires (ROLE_NAME, SKILL_NAME, SKILL_LEVEL) VALUES
('Software Engineer', 'Python', 'Intermediate'),
('Data Analyst Intern', 'SQL', 'Advanced');

-- Inserting dummy data into Applies
INSERT INTO Applies (APPLICANT_ID, POST_ID, APPLICATION_DATE, APPLICATION_STATUS, SPONSORSHIP_NEEDED, RELOCATION_PREFERENCE) VALUES
(1, 1, '2023-08-15', 'ON PROGRESS', FALSE, TRUE),
(2, 2, '2023-08-20', 'ON PROGRESS', TRUE, FALSE);

-- Inserting dummy data into Applicant_Skills
INSERT INTO Applicant_Skills (SKILL_NAME, SKILL_LEVEL, APPLICANT_ID) VALUES
('Python', 'Intermediate', 1),
('SQL', 'Advanced', 2);

-- Inserting dummy data into Intern_Role
INSERT INTO Applicant_University (USERNAME,UNIVERSITY,GPA,MAJOR,DEGREE, GRAD_DATE) VALUES
('john_doe', 'University A',4.0,'CS','Bachelors','2026-09-30'),
('john_doe', 'University A',4.0,'EEE','Masters','2028-09-30');