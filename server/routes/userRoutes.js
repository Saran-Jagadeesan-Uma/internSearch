const express = require('express');
const {registerUser,loginUser, userAppInfo,userEduAppInfo,userWorkAppInfo,updateUserAppInfo,UserAppHistoryInfo, deleteUserAppInfo,getAdminData} = require('../controllers/userControllers')
const router = express.Router();

router.route('/register').post(registerUser);
router.route('/login').post(loginUser);
router.route('/education/:username').get(userEduAppInfo);
router.route('/workexp/:username').get(userWorkAppInfo);
router.route('/update/:username').put(updateUserAppInfo);
router.route('/history/delete').delete(deleteUserAppInfo);
router.route('/history/:username').get(UserAppHistoryInfo);
router.route('/:username').get(userAppInfo);
router.route('/admin/:username').get(getAdminData);

module.exports = router;