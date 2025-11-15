const mongoose = require('mongoose');

const addressSchema = new mongoose.Schema({
  firebaseUid: {
    type: String,
    required: true,
    index: true // Index for faster queries by user
  },
  label: {
    type: String,
    required: true,
    trim: true
  },
  address: {
    type: String,
    required: true,
    trim: true
  },
  latitude: {
    type: Number
  },
  longitude: {
    type: Number
  },
  isDefault: {
    type: Boolean,
    default: false
  }
}, {
  timestamps: true
});

// Compound index for user's addresses
addressSchema.index({ firebaseUid: 1, isDefault: -1 });

const Address = mongoose.model('Address', addressSchema);

module.exports = Address;
