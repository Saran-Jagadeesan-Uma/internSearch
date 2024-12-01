const express = require('express');
const {registerUser,loginUser, userAppInfo,userEduAppInfo,userWorkAppInfo,updateUserAppInfo} = require('../controllers/userControllers')
const router = express.Router();

router.route('/register').post(registerUser);
router.route('/login').post(loginUser);
router.route('/education/:username').get(userEduAppInfo);
router.route('/workexp/:username').get(userWorkAppInfo);
router.route('/update/:username').put(updateUserAppInfo);
router.route('/:username').get(userAppInfo);



module.exports = router;