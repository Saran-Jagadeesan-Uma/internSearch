const express = require("express");
const { 
    allPostings, 
    applyJob, 
    createPosting, 
    getAllPostings, 
    deletePosting,
    updatePosting   
} = require("../controllers/postingControllers");
const postingRoutes = express.Router()

postingRoutes.get('/allPostings', allPostings)
postingRoutes.post('/applyJob', applyJob)
postingRoutes.post('/create', createPosting)
postingRoutes.get('/all', getAllPostings)
postingRoutes.delete('/:postId', deletePosting)
postingRoutes.put('/:postId', updatePosting)  
module.exports = postingRoutes