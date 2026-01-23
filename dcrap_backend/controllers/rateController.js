const Rate = require('../models/Rate');

/**
 * Get all rates
 * GET /api/admin/rates
 */
exports.getAllRates = async (req, res) => {
  try {
    const rates = await Rate.find().sort({ scrapType: 1 });

    res.json({
      success: true,
      data: rates
    });
  } catch (error) {
    console.error('Get all rates error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve rates',
      error: error.message
    });
  }
};

/**
 * Update rate for a scrap type
 * PUT /api/rates/:scrapType
 */
exports.updateRate = async (req, res) => {
  try {
    const { scrapType } = req.params;
    const { pricePerKg, description, isActive } = req.body;
    const adminUid = req.user?.uid || 'admin'; // Use 'admin' if no user

    let rate = await Rate.findOne({ scrapType });

    if (!rate) {
      // Create new rate if doesn't exist
      rate = new Rate({
        scrapType,
        pricePerKg,
        description: description || '',
        isActive: isActive !== undefined ? isActive : true,
        lastUpdatedBy: adminUid
      });
    } else {
      // Update existing rate
      if (pricePerKg !== undefined) rate.pricePerKg = pricePerKg;
      if (description !== undefined) rate.description = description;
      if (isActive !== undefined) rate.isActive = isActive;
      rate.lastUpdatedBy = adminUid;
    }

    await rate.save();

    res.json({
      success: true,
      message: 'Rate updated successfully',
      data: rate
    });
  } catch (error) {
    console.error('Update rate error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to update rate',
      error: error.message
    });
  }
};

/**
 * Initialize default rates (run once)
 * POST /api/rates/initialize
 */
exports.initializeRates = async (req, res) => {
  try {
    const defaultRates = [
      { scrapType: 'Plastic', pricePerKg: 15, description: 'All types of plastic waste' },
      { scrapType: 'Paper', pricePerKg: 10, description: 'Newspapers, magazines, cardboard' },
      { scrapType: 'Metal', pricePerKg: 45, description: 'Iron, aluminum, copper' },
      { scrapType: 'Glass', pricePerKg: 5, description: 'Bottles, jars, glass items' },
      { scrapType: 'Electronics', pricePerKg: 30, description: 'Old electronics, circuit boards' },
      { scrapType: 'Cardboard', pricePerKg: 8, description: 'Cardboard boxes, packaging' },
      { scrapType: 'Other', pricePerKg: 12, description: 'Other recyclable materials' }
    ];

    const results = [];
    for (const rateData of defaultRates) {
      const existingRate = await Rate.findOne({ scrapType: rateData.scrapType });
      if (!existingRate) {
        const rate = new Rate(rateData);
        await rate.save();
        results.push(rate);
      } else {
        results.push(existingRate);
      }
    }

    res.json({
      success: true,
      message: 'Rates initialized successfully',
      data: results
    });
  } catch (error) {
    console.error('Initialize rates error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to initialize rates',
      error: error.message
    });
  }
};

/**
 * Get public rates (for users to view)
 * GET /api/rates
 */
exports.getPublicRates = async (req, res) => {
  try {
    const rates = await Rate.find({ isActive: true })
      .select('scrapType pricePerKg description isActive')
      .sort({ scrapType: 1 });

    res.json({
      success: true,
      data: rates
    });
  } catch (error) {
    console.error('Get public rates error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve rates',
      error: error.message
    });
  }
};
