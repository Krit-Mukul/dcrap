const admin = require('../config/firebase');

// Simple admin credentials (in production, use environment variables)
const ADMIN_CREDENTIALS = {
  username: process.env.ADMIN_USERNAME || 'admin',
  password: process.env.ADMIN_PASSWORD || 'dcrap@2025'
};

/**
 * Admin login endpoint
 * POST /api/admin/auth/login
 */
exports.login = async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      return res.status(400).json({
        success: false,
        message: 'Username and password are required'
      });
    }

    // Verify credentials
    if (username === ADMIN_CREDENTIALS.username && password === ADMIN_CREDENTIALS.password) {
      // Create a custom token for admin
      // In a real app, you'd create a proper JWT token
      const adminToken = Buffer.from(`admin:${username}:${Date.now()}`).toString('base64');

      res.json({
        success: true,
        message: 'Login successful',
        token: adminToken,
        username: username
      });
    } else {
      res.status(401).json({
        success: false,
        message: 'Invalid username or password'
      });
    }
  } catch (error) {
    console.error('Admin login error:', error);
    res.status(500).json({
      success: false,
      message: 'Login failed',
      error: error.message
    });
  }
};

/**
 * Middleware to verify admin token
 */
exports.verifyAdminToken = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'No token provided'
      });
    }

    const token = authHeader.split('Bearer ')[1];

    try {
      // Decode the token
      const decoded = Buffer.from(token, 'base64').toString('utf-8');
      const parts = decoded.split(':');

      // Verify it's an admin token
      if (parts[0] === 'admin' && parts[1] === ADMIN_CREDENTIALS.username) {
        // Token is valid
        req.admin = {
          username: parts[1],
          issuedAt: parseInt(parts[2])
        };
        next();
      } else {
        throw new Error('Invalid admin token');
      }
    } catch (error) {
      return res.status(401).json({
        success: false,
        message: 'Invalid or expired token'
      });
    }
  } catch (error) {
    console.error('Admin token verification error:', error);
    res.status(401).json({
      success: false,
      message: 'Authentication failed',
      error: error.message
    });
  }
};
