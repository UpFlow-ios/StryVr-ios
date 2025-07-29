const express = require("express");
const admin = require("firebase-admin");
const multer = require("multer");
const cors = require("cors");
const fs = require("fs");
const enforce = require("express-sslify");
require("dotenv").config();

// ✅ Initialize Firebase Admin SDK with Environment Variables
const serviceAccount = {
  type: "service_account",
  project_id: process.env.FIREBASE_PROJECT_ID,
  private_key_id: process.env.FIREBASE_PRIVATE_KEY_ID,
  private_key: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n'),
  client_email: process.env.FIREBASE_CLIENT_EMAIL,
  client_id: process.env.FIREBASE_CLIENT_ID,
  auth_uri: "https://accounts.google.com/o/oauth2/auth",
  token_uri: "https://oauth2.googleapis.com/token",
  auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs",
  client_x509_cert_url: `https://www.googleapis.com/robot/v1/metadata/x509/${process.env.FIREBASE_CLIENT_EMAIL}`,
  universe_domain: "googleapis.com"
};

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
});

const app = express();
app.use(cors());
app.use(express.json());
app.use(enforce.HTTPS({ trustProtoHeader: true })); // 🔐 Forces HTTPS

const bucket = admin.storage().bucket();

// ✅ Secure Multer for Handling File Uploads
const upload = multer({ dest: "uploads/", limits: { fileSize: 50 * 1024 * 1024 } }); // 50MB limit

// ✅ Health Check Route
app.get("/api/test", (req, res) => {
  res.json({ message: "🔥 StryVr Backend is Secure & Running!" });
});

// ✅ Firebase Storage Test Route
app.get("/api/test-storage", async (req, res) => {
  try {
    await bucket.file("test.txt").save("Hello, Firebase!");
    res.json({ message: "✅ Firebase Storage is Connected!" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ✅ Secure Video Upload Route (Requires Firebase Authentication)
app.post("/upload", upload.single("video"), async (req, res) => {
  try {
    const idToken = req.headers.authorization?.split("Bearer ")[1]; 
    if (!idToken) return res.status(401).json({ error: "Unauthorized" });

    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const userId = decodedToken.uid;

    if (!req.file) {
      return res.status(400).json({ error: "No file uploaded." });
    }

    const filePath = req.file.path;
    const fileName = `videos/${userId}/${Date.now()}-${req.file.originalname}`;
    const file = bucket.file(fileName);

    await bucket.upload(filePath, {
      destination: fileName,
      metadata: { contentType: req.file.mimetype },
    });

    const videoUrl = `https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/${encodeURIComponent(fileName)}?alt=media`;
    fs.unlinkSync(filePath);

    res.status(200).json({ message: "✅ Video uploaded successfully!", videoUrl });
  } catch (error) {
    console.error("Upload error:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

// ✅ Secure Video Retrieval (Only Owner Can Access)
app.get("/videos/:userId", async (req, res) => {
  try {
    const idToken = req.headers.authorization?.split("Bearer ")[1];
    if (!idToken) return res.status(401).json({ error: "Unauthorized" });

    const decodedToken = await admin.auth().verifyIdToken(idToken);
    if (decodedToken.uid !== req.params.userId) {
      return res.status(403).json({ error: "Access Denied" });
    }

    const [files] = await bucket.getFiles({ prefix: `videos/${req.params.userId}/` });
    const videoUrls = files.map(file => `https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/${encodeURIComponent(file.name)}?alt=media`);

    res.status(200).json({ videos: videoUrls });
  } catch (error) {
    console.error("Retrieval error:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

// ✅ Start Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`🚀 StryVr Secure Server Running on Port ${PORT}`);
});
