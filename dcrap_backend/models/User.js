const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  firebaseUid: {
    type: String,
    required: true,
    unique: true,
    index: true
  },
  name: {
    type: String,
    required: true,
    trim: true
  },
  phone: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  email: {
    type: String,
    trim: true,
    lowercase: true
  },
  vipProgress: {
    type: Number,
    default: 0,
    min: 0,
    max: 1
  },
  vipLevel: {
    type: String,
    enum: ['None', 'Bronze', 'Silver', 'Gold', 'Platinum'],
    default: 'None'
  },
  totalOrders: {
    type: Number,
    default: 0
  },
  totalEarnings: {
    type: Number,
    default: 0
  },
  addresses: [{
    label: String,
    address: String,
    latitude: Number,
    longitude: Number,
    isDefault: Boolean
  }],
  isActive: {
    type: Boolean,
    default: true
  }
}, {
  timestamps: true // Adds createdAt and updatedAt automatically
});

// Index for faster queries
userSchema.index({ phone: 1 });
userSchema.index({ firebaseUid: 1 });

// Virtual for VIP status
userSchema.virtual('vipStatus').get(function() {
  if (this.vipProgress < 0.25) return 'None';
  if (this.vipProgress < 0.5) return 'Bronze';
  if (this.vipProgress < 0.75) return 'Silver';
  if (this.vipProgress < 1.0) return 'Gold';
  return 'Platinum';
});

// Method to update VIP progress based on orders
userSchema.methods.updateVipProgress = function() {
  // Simple formula: 1 order = 0.1 progress, max 1.0
  this.vipProgress = Math.min(this.totalOrders * 0.1, 1.0);
  
  // Update VIP level based on progress
  if (this.vipProgress >= 0.75) {
    this.vipLevel = 'Gold';
  } else if (this.vipProgress >= 0.5) {
    this.vipLevel = 'Silver';
  } else if (this.vipProgress >= 0.25) {
    this.vipLevel = 'Bronze';
  } else {
    this.vipLevel = 'None';
  }
};

const User = mongoose.model('User', userSchema);

module.exports = User;
