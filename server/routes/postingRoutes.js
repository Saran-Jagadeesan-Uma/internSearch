const express = require("express");
const { 
    allPostings, 
    applyJob, 
    createPosting, 
    getAllPostings, 
    deletePosting,
    updatePosting, 
    getSkills   
} = require("../controllers/postingControllers");
const postingRoutes = express.Router()

postingRoutes.get('/allPostings', allPostings)
postingRoutes.post('/applyJob', applyJob)
postingRoutes.post('/create', createPosting)
postingRoutes.get('/all', getAllPostings)
postingRoutes.delete('/:postId', deletePosting)
postingRoutes.put('/:postId', updatePosting) 
postingRoutes.get('/skills', getSkills); 
module.exports = postingRoutes