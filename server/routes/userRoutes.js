const express = require('express');
const {registerUser,loginUser, userAppInfo} = require('../controllers/userControllers')
const router = express.Router();

router.route('/register').post(registerUser);
router.route('/login').post(loginUser);
router.route('/:username').get(userAppInfo);


module.exports = router;