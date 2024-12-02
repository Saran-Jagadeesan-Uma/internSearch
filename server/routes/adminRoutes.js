const express = require('express');
const {
    createJobPosting,
    updateJobPosting,
    deleteJobPosting,
    getAllJobPostings,
    getJobPostingById
} = require('../controllers/adminControllers'); // Adjust the path as needed
const auth = require('../middleware/auth'); // Import authentication middleware
const router = express.Router();

// Route to create a new job posting
router.route('/postings').post(auth, createJobPosting);

// Route to update a job posting by ID
router.route('/postings/:id').put(auth, updateJobPosting);

// Route to delete a job posting by ID
router.route('/postings/:id').delete(auth, deleteJobPosting);

// Route to get all job postings
router.route('/postings').get(auth, getAllJobPostings);

// Route to get a specific job posting by ID
router.route('/postings/:id').get(auth, getJobPostingById);

module.exports = router;