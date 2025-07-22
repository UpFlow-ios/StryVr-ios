const express = require('express');
const cors = require('cors');
const admin = require('firebase-admin');
const dotenv = require('dotenv');

// Load environment variables
dotenv.config();

// Initialize Firebase Admin SDK
const serviceAccount = require('./firebase-adminsdk.json'); // Make sure this matches your file name

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://stryvr.firebaseio.com" // Ensure this is your actual Firebase database URL
});

const app = express();
app.use(cors());
app.use(express.json());

// Test Route
app.get('/', (req, res) => {
  res.send('🔥 StryVr Backend is running successfully! 🔥');
});

// Start the Server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});

