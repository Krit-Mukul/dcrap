const Order = require('../models/Order');
const UserData = require('../models/UserData');

/**
 * Create new order
 * POST /api/orders
 */
exports.createOrder = async (req, res) => {
  try {
    const { uid } = req.user;
    const {
      pickupAddress,
      pickupLatitude,
      pickupLongitude,
      scrapType,
      weight,
      estimatedPrice,
      customerNotes,
      customerName,
      customerPhone,
      imageUrls
    } = req.body;

    console.log('📥 Received order creation request:');
    console.log('  User UID:', uid);
    console.log('  Pickup Address:', pickupAddress);
    console.log('  Scrap Type:', scrapType);
    console.log('  Weight:', weight);
    console.log('  Estimated Price:', estimatedPrice);
    console.log('  Customer Name:', customerName);
    console.log('  Customer Phone:', customerPhone);
    console.log('  Image URLs:', imageUrls);

    // Validate required fields
    if (!pickupAddress || !scrapType || !weight || !estimatedPrice) {
      console.log('❌ Validation failed: Missing required fields');
      return res.status(400).json({
        success: false,
        message: 'Pickup address, scrap type, weight, and estimated price are required'
      });
    }

    // Generate unique order ID
    const orderId = `ORD${Date.now()}${Math.floor(Math.random() * 1000)}`;
    console.log('🆔 Generated Order ID:', orderId);

    // Create new order
    const order = new Order({
      firebaseUid: uid,
      orderId,
      pickupAddress,
      pickupLatitude,
      pickupLongitude,
      scrapType,
      weight,
      estimatedPrice,
      customerNotes,
      customerName,
      customerPhone,
      imageUrls: imageUrls || []
    });

    console.log('💾 Saving order to database...');
    const savedOrder = await order.save();
    console.log('✅ Order saved successfully:', savedOrder._id);

    res.status(201).json({
      success: true,
      message: 'Order created successfully',
      data: savedOrder
    });
  } catch (error) {
    console.error('❌ Create order error:', error);
    console.error('Error stack:', error.stack);
    res.status(500).json({
      success: false,
      message: 'Failed to create order',
      error: error.message
    });
  }
};

/**
 * Debug endpoint - Get total order count
 * GET /api/orders/debug/count
 */
exports.getOrderCount = async (req, res) => {
  try {
    const totalCount = await Order.countDocuments();
    const userCount = await Order.countDocuments({ firebaseUid: req.user.uid });
    
    console.log('📊 Order counts:', { total: totalCount, forUser: userCount });
    
    res.json({
      success: true,
      data: {
        totalOrders: totalCount,
        userOrders: userCount,
        userId: req.user.uid
      }
    });
  } catch (error) {
    console.error('Count error:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
};

/**
 * Get all orders for user
 * GET /api/orders
 */
exports.getOrders = async (req, res) => {
  try {
    const { uid } = req.user;
    const { status } = req.query; // Optional filter by status

    const query = { firebaseUid: uid };
    if (status) {
      query.status = status;
    }

    const orders = await Order.find(query).sort({ orderedAt: -1 });

    res.json({
      success: true,
      message: 'Orders retrieved successfully',
      data: orders
    });
  } catch (error) {
    console.error('Get orders error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve orders',
      error: error.message
    });
  }
};

/**
 * Get single order by ID
 * GET /api/orders/:orderId
 */
exports.getOrderById = async (req, res) => {
  try {
    const { uid } = req.user;
    const { orderId } = req.params;

    const order = await Order.findOne({
      orderId,
      firebaseUid: uid // Ensure user owns this order
    });

    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found'
      });
    }

    res.json({
      success: true,
      data: order
    });
  } catch (error) {
    console.error('Get order error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve order',
      error: error.message
    });
  }
};

/**
 * Update order status
 * PUT /api/orders/:orderId/status
 */
exports.updateOrderStatus = async (req, res) => {
  try {
    const { uid } = req.user;
    const { orderId } = req.params;
    const { status, finalPrice } = req.body;

    if (!status) {
      return res.status(400).json({
        success: false,
        message: 'Status is required'
      });
    }

    const order = await Order.findOne({
      orderId,
      firebaseUid: uid
    });

    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found'
      });
    }

    // Update status and corresponding timestamp
    order.status = status;
    
    switch (status) {
      case 'Accepted':
        order.acceptedAt = new Date();
        break;
      case 'In Transit':
        order.pickupAt = new Date();
        break;
      case 'Completed':
        order.completedAt = new Date();
        if (finalPrice) order.finalPrice = finalPrice;
        
        // Update user's VIP progress
        await updateUserProgress(uid, order.finalPrice || order.estimatedPrice);
        break;
      case 'Cancelled':
        order.cancelledAt = new Date();
        break;
    }

    await order.save();

    res.json({
      success: true,
      message: 'Order status updated successfully',
      data: order
    });
  } catch (error) {
    console.error('Update order status error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to update order status',
      error: error.message
    });
  }
};

/**
 * Cancel order
 * DELETE /api/orders/:orderId
 */
exports.cancelOrder = async (req, res) => {
  try {
    const { uid } = req.user;
    const { orderId } = req.params;
    const { cancellationReason } = req.body;

    const order = await Order.findOne({
      orderId,
      firebaseUid: uid
    });

    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found'
      });
    }

    // Only allow cancellation if order is Pending or Accepted
    if (!['Pending', 'Accepted'].includes(order.status)) {
      return res.status(400).json({
        success: false,
        message: `Cannot cancel order with status: ${order.status}`
      });
    }

    order.status = 'Cancelled';
    order.cancelledAt = new Date();
    order.cancellationReason = cancellationReason || 'User cancelled';

    await order.save();

    res.json({
      success: true,
      message: 'Order cancelled successfully',
      data: order
    });
  } catch (error) {
    console.error('Cancel order error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to cancel order',
      error: error.message
    });
  }
};

/**
 * Helper function to update user's VIP progress
 */
async function updateUserProgress(uid, earnings) {
  try {
    let userData = await UserData.findOne({ firebaseUid: uid });
    
    if (!userData) {
      userData = new UserData({ firebaseUid: uid });
    }

    userData.totalOrders += 1;
    userData.totalEarnings += earnings;
    userData.updateVipProgress();

    await userData.save();
    
    console.log(`✅ Updated VIP progress for user ${uid}: ${userData.totalOrders} orders, ₹${userData.totalEarnings}`);
  } catch (error) {
    console.error('Error updating user progress:', error);
  }
}

module.exports = exports;
