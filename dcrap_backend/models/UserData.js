const mongoose = require('mongoose');

const userDataSchema = new mongoose.Schema({
  firebaseUid: {
    type: String,
    required: true,
    unique: true,
    index: true
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
  }
}, {
  timestamps: true
});

// Method to update VIP progress based on orders
userDataSchema.methods.updateVipProgress = function() {
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

const UserData = mongoose.model('UserData', userDataSchema);

module.exports = UserData;
