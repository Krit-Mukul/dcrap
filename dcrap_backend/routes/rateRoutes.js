const express = require('express');
const router = express.Router();
const rateController = require('../controllers/rateController');

// Public endpoints - no authentication required
// Note: In production, you should secure the update/initialize endpoints
router.get('/', rateController.getPublicRates);
router.put('/:scrapType', rateController.updateRate);
router.post('/initialize', rateController.initializeRates);

module.exports = router;
