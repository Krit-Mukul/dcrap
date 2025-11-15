const admin = require('firebase-admin');
require('dotenv').config();

// Initialize Firebase Admin SDK
// You need to download your Firebase service account key JSON file
// from Firebase Console > Project Settings > Service Accounts
// and save it as 'serviceAccountKey.json' in the config folder

let serviceAccount;

try {
  // Try to load service account from file
  serviceAccount = require('./serviceAccountKey.json');
} catch (error) {
  console.log('⚠️  Service account file not found, using environment variables');
  
  // Alternative: Use environment variables
  serviceAccount = {
    type: process.env.FIREBASE_TYPE,
    project_id: process.env.FIREBASE_PROJECT_ID,
    private_key_id: process.env.FIREBASE_PRIVATE_KEY_ID,
    private_key: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n'),
    client_email: process.env.FIREBASE_CLIENT_EMAIL,
    client_id: process.env.FIREBASE_CLIENT_ID,
    auth_uri: process.env.FIREBASE_AUTH_URI,
    token_uri: process.env.FIREBASE_TOKEN_URI,
    auth_provider_x509_cert_url: process.env.FIREBASE_AUTH_PROVIDER_CERT_URL,
    client_x509_cert_url: process.env.FIREBASE_CLIENT_CERT_URL
  };
}

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: process.env.FIREBASE_DATABASE_URL
});

console.log('✅ Firebase Admin initialized');

module.exports = admin;
