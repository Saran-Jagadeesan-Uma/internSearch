const express = require("express");
const { allPostings, applyJob } = require("../controllers/postingControllers");
const postingRoutes = express.Router()

console.log("inside");

postingRoutes.get('/allPostings', allPostings)
postingRoutes.post('/applyJob', applyJob)

module.exports = postingRoutes