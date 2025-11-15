const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  firebaseUid: {
    type: String,
    required: true,
    index: true
  },
  orderId: {
    type: String,
    required: true,
    unique: true
  },
  // Pickup details
  pickupAddress: {
    type: String,
    required: true
  },
  pickupLatitude: Number,
  pickupLongitude: Number,
  
  // Customer details
  customerName: String,
  customerPhone: String,
  
  // Scrap details
  scrapType: {
    type: String,
    required: true,
    enum: ['Newspaper', 'Cardboard', 'Plastic', 'Metal', 'E-waste', 'Glass', 'E-Waste', 'Mixed']
  },
  weight: {
    type: Number,
    required: true // in kg
  },
  estimatedPrice: {
    type: Number,
    required: true // in rupees
  },
  finalPrice: Number, // Actual price after weighing
  
  // Image URLs for scrap items (optional)
  imageUrls: {
    type: [String],
    default: []
  },
  
  // Order status
  status: {
    type: String,
    enum: ['Pending', 'Accepted', 'In Transit', 'Completed', 'Cancelled'],
    default: 'Pending'
  },
  
  // Timestamps for each status
  orderedAt: {
    type: Date,
    default: Date.now
  },
  acceptedAt: Date,
  pickupAt: Date,
  completedAt: Date,
  cancelledAt: Date,
  
  // Driver details (if assigned)
  driverId: String,
  driverName: String,
  driverPhone: String,
  
  // Payment details
  paymentStatus: {
    type: String,
    enum: ['Pending', 'Paid', 'Failed'],
    default: 'Pending'
  },
  paymentMethod: {
    type: String,
    enum: ['Cash', 'UPI', 'Bank Transfer'],
    default: 'Cash'
  },
  
  // Notes
  customerNotes: String,
  cancellationReason: String
}, {
  timestamps: true
});

// Compound indexes
orderSchema.index({ firebaseUid: 1, status: 1 });
orderSchema.index({ firebaseUid: 1, orderedAt: -1 });
orderSchema.index({ orderId: 1 });

const Order = mongoose.model('Order', orderSchema);

module.exports = Order;
