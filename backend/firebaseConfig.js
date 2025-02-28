  const admin = require("firebase-admin");
  const serviceAccount = require("./serviceAccountKey.json"); // This is your Firebase Admin SDK key
     admin.initializeApp({ credential: admin.credential.cert(serviceAccount),
     storageBucket: "your-project-id.appspot.com" // Replace with your Firebase Storage bucket name
  });
   const db = admin.firestore();
   const bucket = admin.storage().bucket();
  
    module.exports = { admin, db, bucket };
