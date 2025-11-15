const Address = require('../models/Address');
const UserData = require('../models/UserData');

/**
 * Get all addresses for the authenticated user
 * GET /api/users/addresses
 */
exports.getAddresses = async (req, res) => {
  try {
    const { uid } = req.user; // From Firebase token

    console.log('📍 Getting addresses for user:', uid);

    const addresses = await Address.find({ firebaseUid: uid }).sort({ isDefault: -1, createdAt: -1 });

    console.log(`✅ Found ${addresses.length} addresses for user ${uid}`);

    res.json({
      success: true,
      message: 'Addresses retrieved successfully',
      data: addresses
    });
  } catch (error) {
    console.error('Get addresses error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve addresses',
      error: error.message
    });
  }
};

/**
 * Add new address
 * POST /api/users/addresses
 */
exports.addAddress = async (req, res) => {
  try {
    const { uid } = req.user;
    const { label, address, latitude, longitude, isDefault } = req.body;

    console.log('📍 Adding address for user:', uid);
    console.log('📍 Address data:', { label, address, isDefault });

    // Validate required fields
    if (!label || !address) {
      return res.status(400).json({
        success: false,
        message: 'Label and address are required'
      });
    }

    // If this is set as default, remove default from other addresses
    if (isDefault) {
      await Address.updateMany(
        { firebaseUid: uid },
        { $set: { isDefault: false } }
      );
    }

    // Create new address
    const newAddress = new Address({
      firebaseUid: uid,
      label,
      address,
      latitude,
      longitude,
      isDefault: isDefault || false
    });

    await newAddress.save();

    console.log('✅ Address saved successfully with ID:', newAddress._id);

    res.status(201).json({
      success: true,
      message: 'Address added successfully',
      data: newAddress
    });
  } catch (error) {
    console.error('Add address error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to add address',
      error: error.message
    });
  }
};

/**
 * Delete address
 * DELETE /api/users/addresses/:addressId
 */
exports.deleteAddress = async (req, res) => {
  try {
    const { uid } = req.user;
    const { addressId } = req.params;

    const address = await Address.findOneAndDelete({
      _id: addressId,
      firebaseUid: uid // Ensure user owns this address
    });

    if (!address) {
      return res.status(404).json({
        success: false,
        message: 'Address not found or you do not have permission to delete it'
      });
    }

    res.json({
      success: true,
      message: 'Address deleted successfully'
    });
  } catch (error) {
    console.error('Delete address error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to delete address',
      error: error.message
    });
  }
};

/**
 * Get VIP progress
 * GET /api/users/vip-progress
 */
exports.getVipProgress = async (req, res) => {
  try {
    const { uid } = req.user;

    let userData = await UserData.findOne({ firebaseUid: uid });

    // Create default if doesn't exist
    if (!userData) {
      userData = new UserData({ firebaseUid: uid });
      await userData.save();
    }

    res.json({
      success: true,
      message: 'VIP progress retrieved successfully',
      data: {
        vipProgress: userData.vipProgress,
        vipLevel: userData.vipLevel,
        totalOrders: userData.totalOrders,
        totalEarnings: userData.totalEarnings
      }
    });
  } catch (error) {
    console.error('Get VIP progress error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve VIP progress',
      error: error.message
    });
  }
};

/**
 * Update VIP progress (called when order is completed)
 * PUT /api/users/vip-progress
 */
exports.updateVipProgress = async (req, res) => {
  try {
    const { uid } = req.user;
    const { totalOrders, totalEarnings, vipProgress } = req.body;

    let userData = await UserData.findOne({ firebaseUid: uid });

    if (!userData) {
      userData = new UserData({ firebaseUid: uid });
    }

    // Update values if provided
    if (totalOrders !== undefined) userData.totalOrders = totalOrders;
    if (totalEarnings !== undefined) userData.totalEarnings = totalEarnings;
    
    // Allow manual VIP progress update
    if (vipProgress !== undefined) {
      userData.vipProgress = Math.max(0, Math.min(1, vipProgress)); // Clamp between 0-1
      
      // Update VIP level based on progress
      if (userData.vipProgress >= 0.75) {
        userData.vipLevel = 'Gold';
      } else if (userData.vipProgress >= 0.5) {
        userData.vipLevel = 'Silver';
      } else if (userData.vipProgress >= 0.25) {
        userData.vipLevel = 'Bronze';
      } else {
        userData.vipLevel = 'None';
      }
    } else {
      // Recalculate VIP progress from orders
      userData.updateVipProgress();
    }

    await userData.save();

    res.json({
      success: true,
      message: 'VIP progress updated successfully',
      data: {
        vipProgress: userData.vipProgress,
        vipLevel: userData.vipLevel,
        totalOrders: userData.totalOrders,
        totalEarnings: userData.totalEarnings
      }
    });
  } catch (error) {
    console.error('Update VIP progress error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to update VIP progress',
      error: error.message
    });
  }
};

/**
 * Delete all user data (for account deletion)
 * DELETE /api/users/data
 */
exports.deleteUserData = async (req, res) => {
  try {
    const { uid } = req.user;

    // Delete all addresses
    await Address.deleteMany({ firebaseUid: uid });

    // Delete user data
    await UserData.findOneAndDelete({ firebaseUid: uid });

    res.json({
      success: true,
      message: 'All user data deleted successfully. Note: Firebase account must be deleted separately.'
    });
  } catch (error) {
    console.error('Delete user data error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to delete user data',
      error: error.message
    });
  }
};

/**
 * Debug endpoint - Get all addresses in database (no filtering)
 * GET /api/users/addresses/debug/all
 */
exports.getAllAddressesDebug = async (req, res) => {
  try {
    const allAddresses = await Address.find().sort({ createdAt: -1 });
    
    // Group by firebaseUid
    const grouped = {};
    allAddresses.forEach(addr => {
      if (!grouped[addr.firebaseUid]) {
        grouped[addr.firebaseUid] = [];
      }
      grouped[addr.firebaseUid].push({
        id: addr._id,
        label: addr.label,
        address: addr.address,
        isDefault: addr.isDefault,
        createdAt: addr.createdAt
      });
    });

    res.json({
      success: true,
      totalAddresses: allAddresses.length,
      uniqueUsers: Object.keys(grouped).length,
      addressesByUser: grouped,
      currentUser: req.user.uid
    });
  } catch (error) {
    console.error('Debug addresses error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve debug data',
      error: error.message
    });
  }
};
