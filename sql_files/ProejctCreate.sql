-- Creating a Database For tracking Intern Applications
DROP DATABASE IF EXISTS Internship_Tracking_Application;
CREATE DATABASE IF NOT EXISTS Internship_Tracking_Application;
USE Internship_Tracking_Application;

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
    USERNAME VARCHAR(255) PRIMARY KEY,
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
    TYPE ENUM('Public','Private','Co-owned')
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
    FOREIGN KEY (APPLICANT_ID) REFERENCES Applicant(APPLICANT_ID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (POST_ID) REFERENCES Posting(POST_ID) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (APPLICANT_ID, POST_ID)
);


-- Table that stores the applicant's skill and required skills
CREATE TABLE IF NOT EXISTS Skill (
    SKILL_NAME VARCHAR(255) NOT NULL,
    DESCRIPTION TEXT,
    CATEGORY VARCHAR(255) NOT NULL,
    PRIMARY KEY (SKILL_NAME)
);

-- Create a table that stores handles many to many relationship of Postings And Skills
CREATE TABLE IF NOT EXISTS REQUIRES(
	SKILL_NAME VARCHAR(255),
    LEVEL ENUM('Beginner','Advanced','Intermediate') NOT NULL,
    POST_ID INT AUTO_INCREMENT,
    PRIMARY KEY(SKILL_NAME,POST_ID),
    FOREIGN KEY (SKILL_NAME) REFERENCES Skill(SKILL_NAME) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(POST_ID) REFERENCES POSTING(POST_ID) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Table to denote relation between Applicant and Skill
CREATE TABLE IF NOT EXISTS Applicant_Skills (
    SKILL_NAME VARCHAR(255) NOT NULL,
    SKILL_LEVEL ENUM('Beginner','Advanced','Intermediate') NOT NULL,
    APPLICANT_ID INT,
    FOREIGN KEY (APPLICANT_ID) REFERENCES Applicant(APPLICANT_ID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (SKILL_NAME) REFERENCES Skill(SKILL_NAME) ON UPDATE CASCADE ON DELETE CASCADE
);
    
    
-- ------------------------------------------------------------------------------------------------------------
-- PROCEDURES

-- Admin Deletes Posting
DELIMITER $$
CREATE PROCEDURE DeletePosting(IN postId INT)
BEGIN
    -- Delete associated applications
    DELETE FROM Applies WHERE POST_ID = postId;

    -- Now delete the posting
    DELETE FROM Posting WHERE POST_ID = postId;
END $$
DELIMITER ;




-- Admin Edits Posting
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




-- Admin creates posting with this procedure
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





-- Procedure to add a company if it does not exist
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




-- Admin Updates posting using this procedure
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




-- Procedure to get company names
DELIMITER $$
CREATE PROCEDURE GetCompanyNames()
BEGIN
	SELECT NAME FROM Company;
END $$
DELIMITER ;



-- Procedure to update user profile information
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




-- Procedure to get work experience of an applicant
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



-- Procedure to get applicant study experience 
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


-- Procedure to Get Applicant Information for user profile
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

-- Procedure to get Admin Information for Admin Profile
DELIMITER $$
CREATE PROCEDURE GetAdminData(IN adminUsername VARCHAR(255))
BEGIN
    SELECT * FROM appAdmin WHERE USERNAME = adminUsername;
END $$
-- -------------------------------------------------------------------------------------\
-- TRIGGER to prevent duplicate Applications
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


-- ------------------------------------------------------------------------------
-- INSERT data into tables

INSERT INTO University (NAME, FOUNDED_ON, ADDRESS_STREET, ADDRESS_CITY, ADDRESS_ZIP, RANKING, TYPE) VALUES
('Princeton U', '1746-01-01', '1 Nassau Hall', 'Princeton', '08544', 2, 'Private'),
('Northeastern U', '1898-05-15', '360 Huntington Av', 'Boston', '02115', 3, 'Private'),
('Harvard University', '1636-09-08', 'Massachusetts Hall', 'Cambridge', '02138', 1, 'Private'),
('Stanford University', '1885-11-11', '450 Serra Mall', 'Stanford', '94305', 4, 'Private'),
('University of California, Berkeley', '1868-03-23', '200 California Hall', 'Berkeley', '94720', 5, 'Public'),
('Massachusetts Institute of Technology', '1861-04-10', '77 Massachusetts Ave', 'Cambridge', '02139', 6, 'Private'),
('University of Texas at Austin', '1883-09-15', '110 Inner Campus Drive', 'Austin', '78712', 7, 'Public'),
('Yale University', '1701-10-09', 'Woodbridge Hall', 'New Haven', '06520', 8, 'Private'),
('University of Chicago', '1890-07-01', '5801 S Ellis Ave', 'Chicago', '60637', 9, 'Private'),
('California Institute of Technology', '1891-11-11', '1200 E California Blvd', 'Pasadena', '91125', 10, 'Private'),
('University of Michigan', '1817-08-26', '500 S State St', 'Ann Arbor', '48109', 11, 'Public'),
('University of Washington', '1861-11-04', '1410 NE Campus Parkway', 'Seattle', '98195', 12, 'Public');



INSERT INTO AppUser (USERNAME, PASSWORD, FIRST_NAME, LAST_NAME, EMAIL) VALUES
('john_doe','password','John','Doe','john.doe@gmail.com'),
('jane_smith','Hello123!','Jane','Smith','jane.smith@gmail.com'),
('saranj', 'password123', 'saran', 'jagadeesan', 'jagadeesanuma.s@northeastern.edu'),
('vaibhavthalanki', 'editor123', 'vaibhav', 'thalanki','thalanki.v@northeastern.edu');


INSERT INTO AppAdmin (USERNAME, ROLE, ACCESS_LEVEL, DEPARTMENT) VALUES
('saranj', 'Administrator', 'FULL', 'Engineering'),
('vaibhavthalanki', 'Editor', 'EDIT', 'Engineering');


INSERT INTO Applicant (USERNAME, GENDER, DATE_OF_BIRTH, ADDRESS_STREET_NAME, ADDRESS_STREET_NUM, ADDRESS_TOWN, ADDRESS_STATE, ADDRESS_ZIPCODE, RACE, VETERAN_STATUS, DISABILITY_STATUS, CITIZENSHIP_STATUS) VALUES
('john_doe', 'Male', '1998-06-15', 'Main St', 101, 'Example Town', 'Example State', '12345', 'White', false, false, 'India'),
('jane_smith', 'Female', '1999-02-20', 'Second St', 202, 'Sample Town', 'Sample State', '67890', 'Asian', true, false, 'USA');


INSERT INTO Company (NAME, WEBSITE, INDUSTRY, FOUNDED_ON) VALUES
('Google', 'https://www.google.com/', 'Technology', '1998-09-04'),
('Facebook', 'https://www.facebook.com/', 'Technology', '2004-02-04'),
('Amazon', 'https://www.amazon.com/', 'E-commerce', '1994-07-05'),
('Apple', 'https://www.apple.com/', 'Technology', '1976-04-01'),
('Netflix', 'https://www.netflix.com/', 'Entertainment', '1997-08-29'),
('Microsoft', 'https://www.microsoft.com/', 'Technology', '1975-04-04'),
('Tesla', 'https://www.tesla.com/', 'Automotive', '2003-07-01'),
('IBM', 'https://www.ibm.com/', 'Technology', '1911-06-16'),
('Intel', 'https://www.intel.com/', 'Technology', '1968-07-18'),
('Adobe', 'https://www.adobe.com/', 'Software', '1982-12-01'),
('Salesforce', 'https://www.salesforce.com/', 'Technology', '1999-02-03'),
('Twitter', 'https://www.twitter.com/', 'Social Media', '2006-03-21'),
('Snap Inc.', 'https://www.snapchat.com/', 'Social Media', '2011-09-16'),
('Oracle', 'https://www.oracle.com/', 'Technology', '1977-06-16'),
('Spotify', 'https://www.spotify.com/', 'Music Streaming', '2006-04-23');

INSERT INTO Posting (LOCATION, TERM, TYPE, DATE_POSTED, PAY, ROLE_NAME, CREATED_BY, COMPANY_NAME, DESCRIPTION) VALUES
('Remote', 'Summer', 'Internship', '2023-04-01', 20.00, 'Software Development Intern', 'saranj', 'Google', 'Intern will assist in developing web applications using JavaScript and React.'),
('Seattle, WA', 'Fall', 'Internship', '2023-08-15', 25.00, 'Cloud Engineer Intern', 'vaibhavthalanki', 'Amazon', 'Work on scalable cloud solutions and assist in AWS infrastructure projects.'),
('Cupertino, CA', 'Spring', 'Internship', '2024-01-20', 30.00, 'Hardware Engineering Intern', 'saranj', 'Apple', 'Support in designing and testing new hardware components for consumer devices.'),
('Menlo Park, CA', 'Summer', 'Internship', '2023-03-12', 22.00, 'Data Analyst Intern', 'vaibhavthalanki', 'Facebook', 'Analyze large datasets to derive actionable insights for improving platform engagement.'),
('Los Gatos, CA', 'Summer', 'Internship', '2023-04-10', 27.50, 'Machine Learning Intern', 'saranj', 'Netflix', 'Build and optimize recommendation algorithms for streaming services.'),
('Redmond, WA', 'Winter', 'Internship', '2023-11-01', 28.00, 'Product Manager Intern', 'vaibhavthalanki', 'Microsoft', 'Collaborate with cross-functional teams to define product roadmaps and launch features.'),
('Palo Alto, CA', 'Summer', 'Internship', '2023-05-01', 35.00, 'Autonomous Driving Intern', 'saranj', 'Tesla', 'Develop and test software for Tesla’s autonomous vehicle systems.'),
('San Jose, CA', 'Fall', 'Internship', '2023-09-15', 26.00, 'Software Engineer Intern', 'saranj', 'Adobe', 'Contribute to the development of cutting-edge creative software solutions.'),
('Austin, TX', 'Spring', 'Internship', '2024-02-01', 23.00, 'Marketing Analytics Intern', 'vaibhavthalanki', 'Oracle', 'Work on data-driven strategies to enhance marketing campaigns and performance.'),
('Boston, MA', 'Summer', 'Internship', '2023-06-01', 20.00, 'Business Analyst Intern', 'vaibhavthalanki', 'Salesforce', 'Assist in business analysis, including financial modeling and market research.'),
('New York, NY', 'Spring', 'Internship', '2024-02-10', 24.00, 'Cybersecurity Intern', 'saranj', 'IBM', 'Enhance security measures and perform vulnerability assessments on critical systems.'),
('Remote', 'Winter', 'Internship', '2023-12-01', 21.50, 'Frontend Development Intern', 'vaibhavthalanki', 'Snap Inc.', 'Design and implement user-friendly web interfaces using modern frameworks.'),
('San Francisco, CA', 'Summer', 'Internship', '2023-07-01', 22.50, 'Software Engineer Intern', 'vaibhavthalanki', 'Spotify', 'Build and maintain APIs and features for the Spotify music platform.');


INSERT INTO Skill (SKILL_NAME, DESCRIPTION, CATEGORY) VALUES
('Python', 'Programming language', 'Programming'),
('Java', 'Programming language', 'Programming'),
('SQL', 'Database language', 'Database'),
('JavaScript', 'Programming language for web development', 'Programming'),
('HTML', 'Markup language for structuring web content', 'Web Development'),
('CSS', 'Stylesheet language for designing web pages', 'Web Development'),
('React', 'JavaScript library for building user interfaces', 'Web Development'),
('Node.js', 'JavaScript runtime environment for backend development', 'Backend Development'),
('C++', 'Programming language for system-level and competitive programming', 'Programming'),
('C#', 'Programming language commonly used in game development and enterprise applications', 'Programming'),
('PHP', 'Server-side scripting language for web development', 'Web Development'),
('Ruby', 'Programming language for web development, often used with Rails', 'Programming'),
('Go', 'Programming language for building scalable systems', 'Programming'),
('R', 'Programming language for statistical computing and graphics', 'Data Science'),
('Matlab', 'Numerical computing environment and programming language', 'Engineering'),
('AWS', 'Cloud platform offering computing and storage services', 'Cloud Computing'),
('Docker', 'Tool for containerizing applications', 'DevOps'),
('Kubernetes', 'Orchestration tool for managing containerized applications', 'DevOps'),
('Linux', 'Open-source operating system', 'System Administration'),
('Git', 'Version control system for tracking changes in code', 'Version Control'),
('TensorFlow', 'Open-source library for machine learning', 'Machine Learning'),
('PyTorch', 'Deep learning framework', 'Machine Learning'),
('Tableau', 'Data visualization tool', 'Data Analytics'),
('Power BI', 'Business analytics tool by Microsoft', 'Data Analytics');


INSERT INTO Applies (APPLICANT_ID, POST_ID, APPLICATION_DATE, APPLICATION_STATUS) VALUES
(1, 1, '2023-08-15', 'ON PROGRESS'),
(2, 2, '2023-08-20', 'ON PROGRESS');


INSERT INTO Applicant_Skills (SKILL_NAME, SKILL_LEVEL, APPLICANT_ID) VALUES
-- Applicant 1 Skills
('Python', 'Intermediate', 1),
('C++', 'Advanced', 1),
('Java', 'Intermediate', 1),
('SQL', 'Beginner', 1),
('JavaScript', 'Beginner', 1),
-- Applicant 2 Skills
('Python', 'Advanced', 2),
('React', 'Intermediate', 2),
('HTML', 'Advanced', 2),
('CSS', 'Advanced', 2),
('Node.js', 'Intermediate', 2),
('Git', 'Beginner', 2),
('Docker', 'Beginner', 2);


INSERT INTO Applicant_University (USERNAME,UNIVERSITY,GPA,MAJOR,DEGREE, GRAD_DATE) VALUES
('john_doe', 'Stanford University',3.9,'CS','Bachelors','2026-09-30'),
('jane_smith', 'California Institute of Technology',4.0,'ECE','Bachelors','2024-09-30'),
('jane_smith', 'Northeastern U',4.0,'EEE','Masters','2028-09-30');

INSERT INTO WorksIn (USERNAME, COMPANY_NAME, SALARY, MONTHS, POSITION,DESCRIPTION)
VALUES
    ('john_doe', 'Intel', 85000.00, 24, 'Software Engineer','Developed backend systems and services in golang.'),
    ('jane_smith', 'Oracle', 65000.00, 18, 'Business Analyst',null),
    ('john_doe', 'Adobe', 75000.00, 12, 'Data Scientist','Developed ETL pipelines and focused on model building.');