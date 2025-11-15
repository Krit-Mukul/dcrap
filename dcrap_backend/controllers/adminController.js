const Order = require('../models/Order');
const UserData = require('../models/UserData');
const User = require('firebase-admin').auth();

/**
 * Get all orders with filters
 * GET /api/admin/orders
 */
exports.getAllOrders = async (req, res) => {
  try {
    const { status, page = 1, limit = 50, sortBy = 'createdAt', order = 'desc' } = req.query;

    const query = {};
    if (status) query.status = status;

    const skip = (page - 1) * limit;
    const sortOrder = order === 'desc' ? -1 : 1;

    const orders = await Order.find(query)
      .sort({ [sortBy]: sortOrder })
      .skip(skip)
      .limit(parseInt(limit));

    const total = await Order.countDocuments(query);

    res.json({
      success: true,
      data: {
        orders,
        pagination: {
          total,
          page: parseInt(page),
          limit: parseInt(limit),
          totalPages: Math.ceil(total / limit)
        }
      }
    });
  } catch (error) {
    console.error('Get all orders error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve orders',
      error: error.message
    });
  }
};

/**
 * Get order statistics
 * GET /api/admin/orders/stats
 */
exports.getOrderStats = async (req, res) => {
  try {
    const totalOrders = await Order.countDocuments();
    const pendingOrders = await Order.countDocuments({ status: 'Pending' });
    const completedOrders = await Order.countDocuments({ status: 'Completed' });
    const cancelledOrders = await Order.countDocuments({ status: 'Cancelled' });

    // Calculate total revenue from completed orders
    const revenueData = await Order.aggregate([
      { $match: { status: 'Completed' } },
      {
        $group: {
          _id: null,
          totalRevenue: { $sum: '$payment.amount' },
          totalWeight: { $sum: '$scrap.weight' }
        }
      }
    ]);

    const revenue = revenueData.length > 0 ? revenueData[0] : { totalRevenue: 0, totalWeight: 0 };

    res.json({
      success: true,
      data: {
        totalOrders,
        pendingOrders,
        completedOrders,
        cancelledOrders,
        totalRevenue: revenue.totalRevenue,
        totalWeight: revenue.totalWeight
      }
    });
  } catch (error) {
    console.error('Get order stats error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve order statistics',
      error: error.message
    });
  }
};

/**
 * Get leaderboard (top users by orders and earnings)
 * GET /api/admin/leaderboard
 */
exports.getLeaderboard = async (req, res) => {
  try {
    const { sortBy = 'totalOrders', limit = 50 } = req.query;

    const sortField = sortBy === 'earnings' ? 'totalEarnings' : 'totalOrders';
    
    const leaderboard = await UserData.find()
      .sort({ [sortField]: -1 })
      .limit(parseInt(limit));

    // Enrich with user details from Firebase
    const enrichedLeaderboard = await Promise.all(
      leaderboard.map(async (userData, index) => {
        try {
          const userRecord = await User.getUser(userData.firebaseUid);
          return {
            rank: index + 1,
            uid: userData.firebaseUid,
            phoneNumber: userRecord.phoneNumber || 'N/A',
            displayName: userRecord.displayName || 'Anonymous',
            totalOrders: userData.totalOrders,
            totalEarnings: userData.totalEarnings,
            vipProgress: userData.vipProgress,
            vipLevel: userData.vipLevel
          };
        } catch (error) {
          // If user not found in Firebase, return basic info
          return {
            rank: index + 1,
            uid: userData.firebaseUid,
            phoneNumber: 'N/A',
            displayName: 'User',
            totalOrders: userData.totalOrders,
            totalEarnings: userData.totalEarnings,
            vipProgress: userData.vipProgress,
            vipLevel: userData.vipLevel
          };
        }
      })
    );

    res.json({
      success: true,
      data: enrichedLeaderboard
    });
  } catch (error) {
    console.error('Get leaderboard error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve leaderboard',
      error: error.message
    });
  }
};

/**
 * Get all users with their data
 * GET /api/admin/users
 */
exports.getAllUsers = async (req, res) => {
  try {
    const { page = 1, limit = 50 } = req.query;

    const skip = (page - 1) * limit;

    const usersData = await UserData.find()
      .skip(skip)
      .limit(parseInt(limit));

    const total = await UserData.countDocuments();

    // Enrich with Firebase user details
    const enrichedUsers = await Promise.all(
      usersData.map(async (userData) => {
        try {
          const userRecord = await User.getUser(userData.firebaseUid);
          return {
            uid: userData.firebaseUid,
            phoneNumber: userRecord.phoneNumber || 'N/A',
            displayName: userRecord.displayName || 'Anonymous',
            email: userRecord.email || 'N/A',
            createdAt: userRecord.metadata.creationTime,
            lastSignIn: userRecord.metadata.lastSignInTime,
            totalOrders: userData.totalOrders,
            totalEarnings: userData.totalEarnings,
            vipProgress: userData.vipProgress,
            vipLevel: userData.vipLevel
          };
        } catch (error) {
          return {
            uid: userData.firebaseUid,
            phoneNumber: 'N/A',
            displayName: 'User',
            email: 'N/A',
            totalOrders: userData.totalOrders,
            totalEarnings: userData.totalEarnings,
            vipProgress: userData.vipProgress,
            vipLevel: userData.vipLevel
          };
        }
      })
    );

    res.json({
      success: true,
      data: {
        users: enrichedUsers,
        pagination: {
          total,
          page: parseInt(page),
          limit: parseInt(limit),
          totalPages: Math.ceil(total / limit)
        }
      }
    });
  } catch (error) {
    console.error('Get all users error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve users',
      error: error.message
    });
  }
};

/**
 * Update order status (admin action)
 * PUT /api/admin/orders/:orderId/status
 */
exports.updateOrderStatus = async (req, res) => {
  try {
    const { orderId } = req.params;
    const { status, driverName, driverPhone, notes } = req.body;

    const order = await Order.findOne({ orderId });
    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found'
      });
    }

    order.status = status;
    if (driverName) order.driver.name = driverName;
    if (driverPhone) order.driver.phone = driverPhone;
    if (notes) order.notes = notes;

    // Set timestamp based on status
    if (status === 'Accepted') order.acceptedAt = new Date();
    if (status === 'In Transit') order.pickedUpAt = new Date();
    if (status === 'Completed') {
      order.completedAt = new Date();
      
      // Update user VIP progress
      const userData = await UserData.findOne({ firebaseUid: order.userId });
      if (userData) {
        userData.totalOrders += 1;
        userData.totalEarnings += order.payment.amount;
        userData.updateVipProgress();
        await userData.save();
      }
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
