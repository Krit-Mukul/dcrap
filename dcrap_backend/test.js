const admin = require('./config/firebase');
const User = require('./models/User');
const mongoose = require('mongoose');
require('dotenv').config();

/**
 * Test script to verify Firebase token and create a test user
 * 
 * Usage:
 * 1. Get Firebase ID token from your Flutter app
 * 2. Run: node test.js <your-firebase-token>
 */

async function testBackend() {
  try {
    // Connect to MongoDB
    const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/dcrap';
    await mongoose.connect(MONGODB_URI);
    console.log('✅ MongoDB Connected');

    // Get token from command line argument
    const token = process.argv[2];
    
    if (!token) {
      console.log('❌ Please provide a Firebase token');
      console.log('Usage: node test.js <your-firebase-token>');
      process.exit(1);
    }

    // Verify token
    console.log('\n🔐 Verifying Firebase token...');
    const decodedToken = await admin.auth().verifyIdToken(token);
    console.log('✅ Token verified!');
    console.log('   UID:', decodedToken.uid);
    console.log('   Phone:', decodedToken.phone_number);
    console.log('   Email:', decodedToken.email);

    // Create or update test user
    console.log('\n👤 Creating/Updating test user...');
    let user = await User.findOne({ firebaseUid: decodedToken.uid });

    if (user) {
      console.log('✅ User already exists:', user.name);
    } else {
      user = new User({
        firebaseUid: decodedToken.uid,
        name: 'Test User',
        phone: decodedToken.phone_number || '+919876543210',
        email: decodedToken.email || 'test@example.com',
        vipProgress: 0.3,
        totalOrders: 3,
        totalEarnings: 1500
      });
      await user.save();
      console.log('✅ Test user created:', user.name);
    }

    console.log('\n📊 User Data:');
    console.log(JSON.stringify(user, null, 2));

    console.log('\n✅ All tests passed!');
    console.log('\n📡 You can now use this token to test API endpoints:');
    console.log(`   Authorization: Bearer ${token.substring(0, 50)}...`);

  } catch (error) {
    console.error('❌ Test failed:', error.message);
  } finally {
    await mongoose.disconnect();
    process.exit(0);
  }
}

testBackend();
