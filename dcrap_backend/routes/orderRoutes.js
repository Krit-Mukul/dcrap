const express = require('express');
const router = express.Router();
const { verifyToken } = require('../middleware/auth');
const orderController = require('../controllers/orderController');

// All routes require authentication
router.use(verifyToken);

// Debug route
router.get('/debug/count', orderController.getOrderCount);

// Order routes
router.post('/', orderController.createOrder);
router.get('/', orderController.getOrders);
router.get('/:orderId', orderController.getOrderById);
router.put('/:orderId/status', orderController.updateOrderStatus);
router.delete('/:orderId', orderController.cancelOrder);

module.exports = router;
