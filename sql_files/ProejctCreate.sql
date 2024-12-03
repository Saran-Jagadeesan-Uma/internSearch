-- Creating a Database For tracking Intern Applications
-- Creating a Database For tracking Intern Applications
DROP DATABASE IF EXISTS Internship_Tracking_Application;
CREATE DATABASE IF NOT EXISTS Internship_Tracking_Application;
USE Internship_Tracking_Application;

DROP TABLE IF EXISTS AppUser;
-- Creating a table for handling App user
CREATE TABLE IF NOT EXISTS AppUser (
    USERNAME VARCHAR(255) PRIMARY KEY,
    PASSWORD VARCHAR(255) NOT NULL,
    FIRST_NAME VARCHAR(255) NOT NULL,
    LAST_NAME VARCHAR(255) NOT NULL,
    EMAIL VARCHAR(255) NOT NULL UNIQUE
);

-- Creating a table for App Admin's Detail
CREATE TABLE IF NOT EXISTS AppAdmin (
    USERNAME VARCHAR(255) UNIQUE,
	PASSWORD VARCHAR(255) NOT NULL,
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
    DATE_OF_BIRTH DATE,
    ADDRESS_STREET_NAME VARCHAR(255) NOT NULL,
    ADDRESS_STREET_NUM INT NOT NULL,
    ADDRESS_TOWN VARCHAR(255) NOT NULL,
    ADDRESS_STATE VARCHAR(50) NOT NULL,
    ADDRESS_ZIPCODE VARCHAR(20) NOT NULL,
    RACE ENUM('Asian', 'Black', 'Hispanic', 'White', 'Native American', 'Other'),
    VETERAN_STATUS BOOLEAN,
    DISABILITY_STATUS BOOLEAN,
    CITIZENSHIP_STATUS VARCHAR(50),
    FOREIGN KEY (USERNAME) REFERENCES AppUser (USERNAME) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS Applicant_University;
CREATE TABLE IF NOT EXISTS Applicant_University (
	USERNAME VARCHAR(255),
    UNIVERSITY VARCHAR(255),
    GPA FLOAT,
    DEGREE VARCHAR(100) NOT NULL,
    MAJOR VARCHAR(100) NOT NULL,
    GRAD_DATE DATE,
    PRIMARY KEY (USERNAME,UNIVERSITY,MAJOR, DEGREE),
    FOREIGN KEY (USERNAME) REFERENCES Applicant(USERNAME) ON UPDATE CASCADE ON DELETE CASCADE,
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
    FOUNDED_ON DATE,
    PRIMARY KEY (NAME)
);

DROP TABLE IF EXISTS WorksIn;
-- Table to denote the many-to-many relationship between Applicant and Company
CREATE TABLE IF NOT EXISTS WorksIn (
    USERNAME VARCHAR(255),
    COMPANY_NAME VARCHAR(255),
    SALARY DECIMAL(10, 2),
    MONTHS INT NOT NULL,
    POSITION VARCHAR(255) NOT NULL,
    DESCRIPTION TEXT,
    FOREIGN KEY (USERNAME) REFERENCES Applicant(USERNAME) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (COMPANY_NAME) REFERENCES Company(NAME) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (USERNAME, COMPANY_NAME,POSITION)
);

-- Create A table that stores Postings
CREATE TABLE IF NOT EXISTS Posting (
    POST_ID INT PRIMARY KEY AUTO_INCREMENT,
    LOCATION VARCHAR(255) NOT NULL,
    TERM ENUM('Fall', 'Spring', 'Summer', 'Winter') NOT NULL,
    TYPE VARCHAR(255) NOT NULL,
    DATE_POSTED DATE NOT NULL,
    PAY DECIMAL(10, 2) NOT NULL,
    ROLE_NAME VARCHAR(255) NOT NULL,
    CREATED_BY VARCHAR(255) NOT NULL ,
    COMPANY_NAME VARCHAR(255) NOT NULL,
	DESCRIPTION TEXT NOT NULL,
    FOREIGN KEY (CREATED_BY) REFERENCES AppAdmin(USERNAME) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (COMPANY_NAME) REFERENCES Company(NAME) ON UPDATE CASCADE ON DELETE CASCADE
);

-- To denote the many-to-many relationship between Applicant and Posting
CREATE TABLE IF NOT EXISTS Applies (
    APPLICANT_ID INT,
    POST_ID INT,
    APPLICATION_DATE DATE NOT NULL,
    APPLICATION_STATUS VARCHAR(255) NOT NULL DEFAULT 'ON PROGRESS',
    FOREIGN KEY (APPLICANT_ID) REFERENCES Applicant(APPLICANT_ID),
    FOREIGN KEY (POST_ID) REFERENCES Posting(POST_ID),
    PRIMARY KEY (APPLICANT_ID, POST_ID)
);


-- Table that stores the applicant's skill and required skills
CREATE TABLE IF NOT EXISTS Skill (
    SKILL_NAME VARCHAR(255) NOT NULL,
    DESCRIPTION TEXT,
    LEVEL VARCHAR(50) NOT NULL,
    CATEGORY VARCHAR(255) NOT NULL,
    PRIMARY KEY (SKILL_NAME, LEVEL)
);

-- Create a table that stores handles many to many relationship of Postings And Skills
CREATE TABLE IF NOT EXISTS REQUIRES(
	SKILL_NAME VARCHAR(255),
    LEVEL VARCHAR(255),
    POST_ID INT AUTO_INCREMENT,
    PRIMARY KEY(SKILL_NAME,LEVEL,POST_ID),
    FOREIGN KEY (SKILL_NAME, LEVEL) REFERENCES Skill(SKILL_NAME, LEVEL),
    FOREIGN KEY(POST_ID) REFERENCES POSTING(POST_ID)
);

-- Table to denote relation between Applicant and Skill
CREATE TABLE IF NOT EXISTS Applicant_Skills (
    SKILL_NAME VARCHAR(255) NOT NULL,
    SKILL_LEVEL VARCHAR(50) NOT NULL,
    APPLICANT_ID INT,
    FOREIGN KEY (APPLICANT_ID) REFERENCES Applicant(APPLICANT_ID),
    FOREIGN KEY (SKILL_NAME, SKILL_LEVEL) REFERENCES Skill(SKILL_NAME, LEVEL)
);

-- ---------------------------------------
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

-- ----------------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE GetApplicantUniversityDetails (
    IN p_username VARCHAR(255)
)
BEGIN
    SELECT 
        *
    FROM 
        Applicant_University
    WHERE 
        USERNAME = p_username;
END $$

DELIMITER ;

-- ---------------------------------------
DROP PROCEDURE IF EXISTS GetWorksInInfoByUsername;
DELIMITER $$

CREATE PROCEDURE GetWorksInInfoByUsername (
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
END $$

DELIMITER ;
-- -----------------------------
DELIMITER $$
CREATE TRIGGER Prevent_Duplicate_Applications
BEFORE INSERT ON Applies
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Applies
        WHERE APPLICANT_ID = NEW.APPLICANT_ID AND POST_ID = NEW.POST_ID
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Duplicate application detected';
    END IF;
END $$
DELIMITER ;
-- ----------------------------------
DELIMITER $$

CREATE PROCEDURE update_user_app_info (
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
    -- Start a transaction
    START TRANSACTION;

    -- Update Applicant table
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

    -- Update AppUser table
    UPDATE AppUser
    SET 
        FIRST_NAME = p_first_name, 
        LAST_NAME = p_last_name
    WHERE USERNAME = p_username;

    -- Commit the transaction
    COMMIT;
END$$

DELIMITER ;

-- -------------------------------


INSERT INTO University (NAME, FOUNDED_ON, ADDRESS_STREET, ADDRESS_CITY, ADDRESS_ZIP, RANKING, TYPE) VALUES
('Example University', '2000-01-01', '123 University St', 'Example City', '12345', 1, 'Public'),
('Sample College', '1995-05-15', '456 College Ave', 'Sample Town', '67890', 2, 'Private');


INSERT INTO AppUser (USERNAME, PASSWORD, FIRST_NAME, LAST_NAME, EMAIL) VALUES
('john_doe', 'password123', 'John', 'Doe', 'john.doe@example.com'),
('jane_smith', 'password456', 'Jane', 'Smith', 'jane.smith@example.com'),
('alice_jones', 'password789', 'Alice', 'Jones', 'alice.jones@example.com'),
('admin_user', 'admin123', 'shrey', 'shah','shreyshah@exampledomain.com'),
('editor_user', 'editor123', 'vaibhav', 'thalanki','thalanki.v@northeastern.edu');

INSERT INTO AppAdmin (USERNAME,PASSWORD, ROLE, ACCESS_LEVEL, DEPARTMENT) VALUES
('admin_user','admin123', 'Administrator', 'FULL', 'HR'),
('editor_user','editor123', 'Editor', 'EDIT', 'Recruitment');


INSERT INTO Applicant (USERNAME, GENDER, DATE_OF_BIRTH, ADDRESS_STREET_NAME, ADDRESS_STREET_NUM, ADDRESS_TOWN, ADDRESS_STATE, ADDRESS_ZIPCODE, RACE, VETERAN_STATUS, DISABILITY_STATUS, CITIZENSHIP_STATUS) VALUES
('john_doe', 'Male', '1998-06-15', 'Main St', 101, 'Example Town', 'Example State', '12345', 'White', false, false, 'USA'),
('jane_smith', 'Female', '1999-02-20', 'Second St', 202, 'Sample Town', 'Sample State', '67890', 'Asian', false, false, 'USA'),
('alice_jones', 'Female', '2000-03-30', 'Third St', 303, 'Example City', 'Example State', '12345', 'Hispanic', false, false, 'USA');

INSERT INTO Company (NAME, WEBSITE, INDUSTRY, FOUNDED_ON) VALUES
('Tech Solutions', 'https://techsolutions.com', 'Technology', '2012-07-15'),
('Green Energy', 'https://greenenergy.com', 'Renewable Energy', '2018-03-20'),
('Tech Innovations', 'https://techinnovations.com', 'Technology', '2015-05-01'),
('Marketing Solutions', 'https://marketingsolutions.com', 'Marketing', '2019-01-10'),	
('Tech Corp', 'https://techcorp.com', 'Technology', '2010-01-01'),
('Innovate Inc', 'https://innovateinc.com', 'Technology', '2015-06-15');

INSERT INTO Posting (LOCATION, TERM, TYPE, DATE_POSTED, PAY, ROLE_NAME, CREATED_BY, COMPANY_NAME, DESCRIPTION) VALUES
('Remote', 'Summer', 'Internship', '2023-04-01', 20.00, 'Software Development Intern', 'admin_user', 'Tech Solutions', 'Intern will assist in developing web applications using JavaScript and React.'),
('New York', 'Fall', 'Internship', '2023-05-01', 25.00, 'Research Intern', 'admin_user', 'Green Energy', 'Intern will support research projects focusing on renewable energy technologies.'),
('San Francisco', 'Spring', 'Internship', '2023-06-01', 30.00, 'Data Analyst Intern', 'admin_user', 'Tech Innovations', 'Intern will analyze data sets and assist in generating reports for stakeholders.'),
('Chicago', 'Winter', 'Internship', '2023-07-01', 22.00, 'Marketing Intern', 'admin_user', 'Marketing Solutions', 'Intern will help in creating marketing campaigns and analyzing their effectiveness.');

-- Inserting dummy data into Skill
INSERT INTO Skill (SKILL_NAME, DESCRIPTION, LEVEL, CATEGORY) VALUES
('Python', 'Programming language', 'Intermediate', 'Programming'),
('Java', 'Programming language', 'Beginner', 'Programming'),
('SQL', 'Database language', 'Advanced', 'Database');

-- Inserting dummy data into Applies
INSERT INTO Applies (APPLICANT_ID, POST_ID, APPLICATION_DATE, APPLICATION_STATUS) VALUES
(1, 1, '2023-08-15', 'ON PROGRESS'),
(2, 2, '2023-08-20', 'ON PROGRESS');

-- Inserting dummy data into Applicant_Skills
INSERT INTO Applicant_Skills (SKILL_NAME, SKILL_LEVEL, APPLICANT_ID) VALUES
('Python', 'Intermediate', 1),
('SQL', 'Advanced', 2);

-- Inserting dummy data into Intern_Role
INSERT INTO Applicant_University (USERNAME,UNIVERSITY,GPA,MAJOR,DEGREE, GRAD_DATE) VALUES
('john_doe', 'Example University',4.0,'CS','Bachelors','2026-09-30'),
('john_doe', 'Example University',4.0,'EEE','Masters','2028-09-30');

INSERT INTO WorksIn (USERNAME, COMPANY_NAME, SALARY, MONTHS, POSITION,DESCRIPTION)
VALUES
    ('john_doe', 'Tech Corp', 85000.00, 24, 'Software Engineer','Developed backend systems and services in golang.'),
    ('jane_smith', 'Innovate Inc', 65000.00, 18, 'Business Analyst',null),
    ('alice_jones', 'Tech Corp', 75000.00, 12, 'Data Scientist','Developed ETL pipelines and focused on model building.');
    
INSERT INTO AppUser  (USERNAME, PASSWORD, FIRST_NAME, LAST_NAME, EMAIL) VALUES
('ouewbfu', 'password123', 'John', 'Doe', 'john.dbi_boe@example.com');

INSERT INTO Applicant (USERNAME, GENDER, DATE_OF_BIRTH, ADDRESS_STREET_NAME, ADDRESS_STREET_NUM, ADDRESS_TOWN, ADDRESS_STATE, ADDRESS_ZIPCODE, RACE, VETERAN_STATUS, DISABILITY_STATUS, CITIZENSHIP_STATUS) VALUES
('ouewbfu', 'Other', null, '', 0, '', '', '', null, null, null, 'USA');

DELIMITER $$

CREATE PROCEDURE DeletePosting(IN postId INT)
BEGIN
    -- Delete associated applications
    DELETE FROM Applies WHERE POST_ID = postId;

    -- Now delete the posting
    DELETE FROM Posting WHERE POST_ID = postId;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE EditPosting(
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
    -- Check if the company exists
    IF NOT EXISTS (SELECT 1 FROM Company WHERE NAME = companyName) THEN
        -- Insert the company if it doesn't exist
        INSERT INTO Company (NAME) VALUES (companyName);
    END IF;

    -- Update the posting
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
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE CreatePosting(
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
    -- Check if the company exists
    IF NOT EXISTS (SELECT 1 FROM Company WHERE NAME = companyName) THEN
        -- Insert the company if it doesn't exist
        INSERT INTO Company (NAME) VALUES (companyName);
    END IF;

    -- Now insert the posting
    INSERT INTO Posting (LOCATION, TERM, TYPE, DATE_POSTED, PAY, ROLE_NAME, CREATED_BY, COMPANY_NAME, DESCRIPTION)
    VALUES (location, term, type, NOW(), pay, roleName, createdBy, companyName, description);
END $$

DELIMITER ;

DELIMITER //

DELIMITER //

CREATE PROCEDURE AddCompanyIfNotExists(IN companyName VARCHAR(255), IN industry VARCHAR(255), OUT companyNameOut VARCHAR(255))
BEGIN
    DECLARE existingIndustry VARCHAR(255);
    
    -- Check if the company already exists
    SELECT INDUSTRY INTO existingIndustry FROM Company WHERE NAME = companyName LIMIT 1;

    IF existingIndustry IS NOT NULL THEN
        -- If the company exists, check if the industry matches
        IF existingIndustry != industry THEN
            -- Throw an error if the industry does not match
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Existing company found with a different industry.';
        END IF;
    ELSE
        -- Insert the new company if it doesn't exist
        INSERT INTO Company (NAME, INDUSTRY) VALUES (companyName, industry);
    END IF;

    -- Set the output variable
    SET companyNameOut = companyName;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE UpdatePosting(
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
END //

DELIMITER ;
DELIMITER ;
	DELIMITER $$

	CREATE PROCEDURE GetCompanyNames()
	BEGIN
		SELECT NAME FROM Company;
	END $$

	DELIMITER ;