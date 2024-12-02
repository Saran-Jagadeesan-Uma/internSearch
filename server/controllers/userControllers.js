const db = require('../db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const loginUser = async (req, res) => {
    const { username, password } = req.body;

    db.query('SELECT * FROM AppUser WHERE USERNAME = ?', [username], async (err, results) => {

        if (err) return res.status(500).json({ error: err.message });
        if (results.length === 0) return res.status(400).json({ message: 'Invalid username or password' });

        const user = results[0];

        const isMatch = await bcrypt.compare(password, user.PASSWORD);

        if (!isMatch && password != user.PASSWORD) return res.status(400).json({ message: 'Invalid username or password' });

        // Create JWT token
        const token = jwt.sign({ username: user.USERNAME }, process.env.JWT_SECRET, { expiresIn: '1h' });
        return res.json({ token, username });
    });
}

const userAppInfo = async (req, res) => {
    const { username } = req.params;
    console.log(username);

    db.query("CALL GetApplicantInfo(?)", [username], async (err, results) => {

        if (err) return res.status(500).json({ error: err.message });
        if (results.length === 0) return res.status(400).json({ message: 'Invalid username or password' });

        const user = results[0][0];

        return res.json(user);
    });

}

const registerUser = async (req, res) => {
    const { username, password, first_name, last_name, email } = req.body;
    try {

        db.query('SELECT * FROM AppUser  WHERE USERNAME = ?', [username], async (err, results) => {
            if (err) return res.status(500).json({ error: err.message });
            if (results.length > 0) return res.status(400).json({ message: 'Username already exists' });

            // Hash password
            const hashedPassword = await bcrypt.hash(password, 10);

            // Insert new user
            db.query('INSERT INTO AppUser  (USERNAME, PASSWORD, FIRST_NAME, LAST_NAME, EMAIL) VALUES (?, ?, ?, ?, ?)',
                [username, hashedPassword, first_name, last_name, email], (err, results) => {
                    if (err) return res.status(500).json({ error: err.message });
                    return db.query('INSERT INTO Applicant  (USERNAME, GENDER, DATE_OF_BIRTH, ADDRESS_STREET_NAME, ADDRESS_STREET_NUM, ADDRESS_TOWN, ADDRESS_STATE, ADDRESS_ZIPCODE, RACE, VETERAN_STATUS, DISABILITY_STATUS, CITIZENSHIP_STATUS) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                        [username, 'Other', null, '', 0, '', '', '', null, null, null, 'USA'], (err, results) => {
                            if (err) return res.status(500).json({ error: err.message });
                            return res.status(201).json({ message: 'User  registered successfully', username, email });
                        });
                });
        });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
}

const userEduAppInfo = async (req, res) => {
    const { username } = req.params;
    db.query("CALL GetApplicantUniversityDetails(?)", [username], async (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        if (results.length === 0) return res.status(400).json({ message: 'Invalid username or password' });

        const user = results[0];

        return res.json(user);
    });
}

const userWorkAppInfo = async (req, res) => {
    const { username } = req.params;
    db.query("CALL GetWorksInInfoByUsername(?)", [username], async (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        if (results.length === 0) return res.status(400).json({ message: 'Invalid username or password' });

        const user = results[0];

        return res.json(user);
    });
}

const updateUserAppInfo = async (req, res) => {
    const { username } = req.params;
    const {
        FIRST_NAME,
        LAST_NAME,
        GENDER,
        DATE_OF_BIRTH,
        ADDRESS_STREET_NAME,
        ADDRESS_STREET_NUM,
        ADDRESS_TOWN,
        ADDRESS_STATE,
        ADDRESS_ZIPCODE,
        RACE,
        VETERAN_STATUS,
        DISABILITY_STATUS,
        CITIZENSHIP_STATUS,
        education,
        workExperience
    } = req.body;

    const connection = db.promise(); // Assuming db is the database connection object

    try {
        await connection.query('START TRANSACTION');
        // Call the stored procedure
        await connection.query('CALL update_user_app_info(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)', [
            username,
            FIRST_NAME,
            LAST_NAME,
            GENDER,
            DATE_OF_BIRTH,
            ADDRESS_STREET_NAME,
            ADDRESS_STREET_NUM,
            ADDRESS_TOWN,
            ADDRESS_STATE,
            ADDRESS_ZIPCODE,
            RACE,
            VETERAN_STATUS,
            DISABILITY_STATUS,
            CITIZENSHIP_STATUS
        ]);

        await connection.query('DELETE FROM Applicant_University WHERE USERNAME = ?', [username]);

        const insertEducationPromises = education.map(async (edu) => {
            gradDate = edu.gradDate;
            if (edu.graddate == '') {
                gradDate = null;
            }
            gpa = edu.gpa;
            if (gpa == ''){
                gpa = null;
            }
            
            await connection.query('INSERT INTO Applicant_University (USERNAME, UNIVERSITY, GPA, DEGREE, MAJOR, GRAD_DATE) VALUES (?, ?, ?, ?, ?, ?)', [
                username,
                edu.universityName,
                gpa,
                edu.degree,
                edu.major,
                gradDate
            ]);
        });

        await connection.query('DELETE FROM WorksIn WHERE USERNAME = ?', [username]);

        const insertWorkExpPromises = workExperience.map(async (we) => {
            salary = we.salary;
            if (salary == ''){
                salary = null;
            }
            description = we.description;
            if (description == ''){
                description = null;
            }
            await connection.query('INSERT INTO WorksIn (USERNAME, COMPANY_NAME, SALARY, MONTHS, POSITION,DESCRIPTION) VALUES (?, ?, ?, ?, ?, ?)', [
                username,
                we.company,
                salary,
                we.months,
                we.role,
                description
            ]);
        });


        // Wait for all insert queries to finish
        await Promise.all(insertEducationPromises);
        await Promise.all(insertWorkExpPromises);

        await connection.query('COMMIT');

        // Send success response
        res.status(200).json({ message: 'User Profile information updated successfully.' });
    } catch (error) {
        console.error('Error updating User Profile info:', error);
        res.status(500).json({ message: 'Failed to update User Profile information.' });
    }
};


const UserAppHistoryInfo = async(req,res)=>{
    const { username } = req.params;

    try {
        const applicantQuery = `SELECT APPLICANT_ID FROM applicant WHERE username = ? LIMIT 1`;
    
        db.query(applicantQuery, [username], (err, results) => {
          if (err) {
            console.error("Error fetching applicant info:", err);
            return res.status(500).json({ error: "Internal server error" });
          }
    
          if (!results || results.length === 0) {
            return res.status(400).json({ message: "Invalid username" });
          }
    
          const applicantId = results[0].APPLICANT_ID;
    
          
          db.query('select * from Applies WHERE APPLICANT_ID = ?', [applicantId], async (err, results) => {
            if (err) {
                return res.status(500).json({ error: 'Database query error' });
            }
            res.json(results);
        });

        });
      } catch (error) {
        console.error("Unexpected error:", error);
        res.status(500).json({ message: "Internal server error" });
      }
}

const deleteUserAppInfo = async(req,res)=>{
    const { username, postId } = req.body;
    if (!postId || !username) {
        return res
          .status(400)
          .json({ message: "Post ID and username are required" });
      }
    try{
        const applicantQuery = `SELECT APPLICANT_ID FROM applicant WHERE username = ? LIMIT 1`;
    
    db.query(applicantQuery, [username], (err, results) => {
        if (err) {
          console.error("Error fetching applicant info:", err);
          return res.status(500).json({ error: "Internal server error" });
        }
  
        if (!results || results.length === 0) {
          return res.status(400).json({ message: "Invalid username" });
        }
  
        const applicantId = results[0].APPLICANT_ID;       
  
        
        db.query('DELETE FROM Applies WHERE APPLICANT_ID = ? AND POST_ID = ?', [applicantId, postId], async (err, results) => {
          if (err) {
              return res.status(500).json({ error: 'Database query error' });
          }
          res.json(results);
      });

      });
    } catch (error) {
      console.error("Unexpected error:", error);
      res.status(500).json({ message: "Internal server error" });
    }
}


module.exports = {
    registerUser,
    loginUser,
    userAppInfo,
    userEduAppInfo,
    userWorkAppInfo,
    updateUserAppInfo,
    UserAppHistoryInfo,
    deleteUserAppInfo
}