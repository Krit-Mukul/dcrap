const mongoose = require('mongoose');
const UserData = require('./models/UserData');

mongoose.connect('mongodb://localhost:27017/dcrap', {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(async () => {
  console.log('Connected to MongoDB');
  
  // Find the first user and update
  const userData = await UserData.findOne();
  
  if (userData) {
    console.log('Current VIP Progress:', userData.vipProgress);
    userData.vipProgress = 0.3;
    userData.vipLevel = 'Bronze';
    await userData.save();
    console.log('✅ Updated VIP Progress to 30% (0.3)');
    console.log('New data:', userData);
  } else {
    console.log('No user data found');
  }
  
  process.exit(0);
}).catch(err => {
  console.error('Error:', err);
  process.exit(1);
});
