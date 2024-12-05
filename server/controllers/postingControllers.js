const db = require("../db");

const allPostings = async (req, res) => {
  let query = `SELECT * FROM posting ORDER BY date_posted DESC`;

  db.query(query, (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      return res.status(500).json({ error: "Database query failed" });
    }

    res.json(results);
  });
};

const applyJob = async (req, res) => {
  const { jobId, username } = req.body;

  if (!jobId || !username) {
    return res
      .status(400)
      .json({ message: "Job ID and username are required" });
  }

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

      
      const query = `INSERT INTO applies (POST_ID, APPLICANT_ID, APPLICATION_DATE) VALUES (?, ?, NOW())`;
      db.query(query, [jobId, applicantId], (err, result) => {
      
      if (err) {
        if (err.code === 'ER_SIGNAL_EXCEPTION' && err.sqlMessage.includes('Duplicate application detected')) {
          return res.status(409).json({ message: "You have already applied for this job." });
        }
      }

        res.status(201).json({
          message: "Application submitted successfully",
          applicationId: result.insertId,
        });
      });
    });
  } catch (error) {
    console.error("Unexpected error:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};
const createPosting = async (req, res) => {
  const { 
      location, 
      term, 
      type, 
      pay, 
      companyName, 
      roleName,
      createdBy,
      description,
      industry 
  } = req.body;

  try {
      let companyNameOut;

      const companyQuery = 'CALL AddCompanyIfNotExists(?, ?, @companyNameOut);';
      db.query(companyQuery, [companyName, industry], (err) => {
          if (err) {
              if (err.code === 'ER_SIGNAL_EXCEPTION' && err.sqlMessage.includes('Existing company found with a different industry.')) {
                  return res.status(409).json({ error: 'Existing company found with a different industry.' });
              }
              console.error('Error checking or adding company:', err);
              return res.status(500).json({ error: 'Failed to check or add company', details: err.message });
          }

          db.query('SELECT @companyNameOut AS companyNameOut;', (err, result) => {
              if (err) {
                  console.error('Error retrieving company name:', err);
                  return res.status(500).json({ error: 'Failed to retrieve company name', details: err.message });
              }

              companyNameOut = result[0].companyNameOut;

              const query = 'CALL CreatePosting(?, ?, ?, ?, ?, ?, ?, ?)';
              db.query(query, [
                  location, 
                  term, 
                  type, 
                  pay, 
                  companyNameOut, 
                  roleName,
                  createdBy,
                  description 
              ], (err, result) => {
                  if (err) {
                      console.error('Error creating posting:', err);
                      return res.status(500).json({ error: 'Failed to create job posting', details: err.message });
                  }

                  res.status(201).json({ 
                      message: 'Job posting created successfully', 
                      postId: result.insertId 
                  });
              });
          });
      });
  } catch (error) {
      console.error('Unexpected error:', error);
      res.status(500).json({ error: 'Internal server error', details: error.message });
  }
};
const getAllPostings = async (req, res) => {
  try {
      const query = 'SELECT * FROM Posting ORDER BY DATE_POSTED DESC';
      
      db.query(query, (err, results) => {
          if (err) {
              console.error('Error fetching postings:', err);
              return res.status(500).json({ error: 'Failed to fetch job postings' });
          }

          res.status(200).json(results);
      });
  } catch (error) {
      console.error('Unexpected error:', error);
      res.status(500).json({ error: 'Internal server error' });
  }
};

const deletePosting = async (req, res) => {
  const { postId } = req.params;

  try {
      const query = 'CALL DeletePosting(?)';
      db.query(query, [postId], (err, result) => {
          if (err) {
              console.error('Error deleting posting:', err);
              return res.status(500).json({ error: 'Failed to delete job posting' });
          }

          res.status(200).json({ message: 'Job posting deleted successfully' });
      });
  } catch (error) {
      console.error('Unexpected error:', error);
      res.status(500).json({ error: 'Internal server error' });
  }
};
const updatePosting = async (req, res) => {
  const { postId } = req.params;
  const { 
      location, 
      term, 
      type, 
      pay, 
      companyName, 
      roleName,
      description,
      industry 
  } = req.body;

  try {
      const query = 'CALL UpdatePosting(?, ?, ?, ?, ?, ?, ?, ?)';
      db.query(query, [
          postId,
          location, 
          term, 
          type, 
          pay, 
          companyName, 
          roleName,
          description
      ], (err, result) => {
          if (err) {
              console.error('Error updating posting:', err);
              return res.status(500).json({ error: 'Failed to update job posting', details: err.message });
          }

          res.status(200).json({ 
              message: 'Job posting updated successfully', 
              postId: postId 
          });
      });
  } catch (error) {
      console.error('Unexpected error:', error);
      res.status(500).json({ error: 'Internal server error', details: error.message });
  }
};
module.exports = {allPostings, applyJob, createPosting,
  getAllPostings,
  deletePosting,updatePosting
};
