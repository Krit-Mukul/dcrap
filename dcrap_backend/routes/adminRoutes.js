const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
const rateController = require('../controllers/rateController');
const { verifyToken } = require('../middleware/auth');

// Note: In production, add admin role verification middleware
// For now, all authenticated users can access admin routes

// Get all orders with filters
router.get('/orders', verifyToken, adminController.getAllOrders);

// Get order statistics
router.get('/orders/stats', verifyToken, adminController.getOrderStats);

// Update order status
router.put('/orders/:orderId/status', verifyToken, adminController.updateOrderStatus);

// Get leaderboard
router.get('/leaderboard', verifyToken, adminController.getLeaderboard);

// Get all users
router.get('/users', verifyToken, adminController.getAllUsers);

// Rate management
router.get('/rates', verifyToken, rateController.getAllRates);
router.put('/rates/:scrapType', verifyToken, rateController.updateRate);
router.post('/rates/initialize', verifyToken, rateController.initializeRates);

module.exports = router;
