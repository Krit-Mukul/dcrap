const mongoose = require('mongoose');

const rateSchema = new mongoose.Schema({
  scrapType: {
    type: String,
    required: true,
    unique: true,
    enum: ['Plastic', 'Paper', 'Metal', 'Glass', 'Electronics', 'Cardboard', 'Other']
  },
  pricePerKg: {
    type: Number,
    required: true,
    min: 0
  },
  description: {
    type: String,
    default: ''
  },
  isActive: {
    type: Boolean,
    default: true
  },
  lastUpdatedBy: {
    type: String, // Admin UID who last updated
    default: 'system'
  }
}, {
  timestamps: true
});

const Rate = mongoose.model('Rate', rateSchema);

module.exports = Rate;
