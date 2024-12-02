// adminController.js
const db = require('../db');

const createJobPosting = async (req, res) => {
    const { companyName, roleName, term, type, location, minGPA, pay, deadline } = req.body;
    const query = 'INSERT INTO JobPostings (CompanyName, RoleName, Term, Type, Location, MinGPA, Pay, Deadline) VALUES (?, ?, ?, ?, ?, ?, ?, ?)';
    const values = [companyName, roleName, term, type, location, minGPA, pay, deadline];

    db.query(query, values, (err, results) => {
        if (err) return res.status(500).json({ error: 'Failed to create job posting' });
        res.status(201).json({ message: 'Job posting created successfully' });
    });
};

const deleteJobPosting = async (req, res) => {
    const { id } = req.params;
    db.query('DELETE FROM JobPostings WHERE id = ?', [id], (err, results) => {
        if (err) return res.status(500).json({ error: 'Failed to delete job posting' });
        res.status(200).json({ message: 'Job posting deleted successfully' });
    });
};

const getAllJobPostings = async (req, res) => {
    db.query('SELECT * FROM JobPostings', (err, results) => {
        if (err) return res.status(500).json({ error: 'Failed to retrieve job postings' });
        res.json(results);
    });
};

module.exports = {
    createJobPosting,
    deleteJobPosting,
    getAllJobPostings
};