const express = require('express');
const router = express.Router();
const { verifyToken } = require('../middleware/auth');
const userController = require('../controllers/userController');

// All routes require authentication
router.use(verifyToken);

// Address routes
router.get('/addresses', userController.getAddresses);
router.get('/addresses/debug/all', userController.getAllAddressesDebug);
router.post('/addresses', userController.addAddress);
router.delete('/addresses/:addressId', userController.deleteAddress);

// VIP progress routes
router.get('/vip-progress', userController.getVipProgress);
router.put('/vip-progress', userController.updateVipProgress);

// Delete all user data (for account deletion)
router.delete('/data', userController.deleteUserData);

module.exports = router;
