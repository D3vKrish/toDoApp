// This file defines the authentication routes for user login and registration
// Import necessary modules

// Import authentication controllers
const { loginController } = require('../controllers/login.controller');
const { registerController } = require('../controllers/register.controller');
const { passwordResetController } = require('../controllers/passwordReset.controller');

// Initialize router for authentication endpoints
const AuthRouter = require('express').Router();

// Authentication routes
// POST methods are used as these operations modify server state

// Login - Authenticates users and establishes sessions
AuthRouter.post('/login', loginController);

// Registration - Creates new user accounts
AuthRouter.post('/register', registerController);

// Password Reset - Allows users to reset their passwords
AuthRouter.post('/reset', passwordResetController);


// Export router for use in main application
module.exports = { AuthRouter };