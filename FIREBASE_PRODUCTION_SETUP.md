# 🔥 Firebase Production Setup Guide for StryVr

## 📋 **Current Status**
✅ **Development Firebase** - Configured and working  
🔄 **Production Firebase** - Needs setup  
🔄 **App Store Configuration** - Pending  

---

## 🚀 **Step 1: Create Production Firebase Project**

### **1.1 Go to Firebase Console**
1. Visit: https://console.firebase.google.com/
2. Sign in with your Google account
3. Click **"Create a project"** or **"Add project"**

### **1.2 Project Setup**
- **Project name:** `stryvr-production` (or `stryvr-prod`)
- **Project ID:** `stryvr-production-xxxxx` (Firebase will suggest)
- **Google Analytics:** ✅ **Enable** (required for App Store)
- **Analytics account:** Create new or use existing

### **1.3 Project Configuration**
- **Location:** Choose closest to your target users
- **Default account:** Your Google account
- **Billing:** Set up billing (required for production)

---

## 🔧 **Step 2: Configure iOS App in Production**

### **2.1 Add iOS App**
1. In Firebase Console, click **"Add app"** → **iOS**
2. **Bundle ID:** `com.stryvr.app` (must match your Xcode project)
3. **App nickname:** `StryVr Production`
4. **App Store ID:** Leave blank (will add after App Store submission)

### **2.2 Download Production Config**
1. Download the new `GoogleService-Info.plist`
2. **IMPORTANT:** This is different from your development config
3. Replace the existing file in your Xcode project

### **2.3 Update Bundle Identifier**
Ensure your Xcode project uses: `com.stryvr.app`

---

## 🔐 **Step 3: Configure Authentication**

### **3.1 Enable Authentication Methods**
In Firebase Console → Authentication → Sign-in method:

✅ **Email/Password** - Enable  
✅ **Google Sign-In** - Enable (if using)  
✅ **Apple Sign-In** - Enable (recommended for iOS)  
✅ **Anonymous Auth** - Enable (if needed)  

### **3.2 Configure OAuth Providers**
- **Google:** Add your OAuth client ID
- **Apple:** Configure Apple Developer Team ID
- **Authorized domains:** Add `stryvr.app`

---

## 📊 **Step 4: Configure Firestore Database**

### **4.1 Create Production Database**
1. Go to **Firestore Database** → **Create database**
2. **Security rules:** Start in **production mode**
3. **Location:** Choose same as project location

### **4.2 Set Up Security Rules**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User data - users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Skills data - users can only access their own skills
    match /users/{userId}/skills/{skillId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Verification data - users can only access their own verifications
    match /verifications/{verificationId} {
      allow read, write: if request.auth != null && 
        resource.data.userID == request.auth.uid;
    }
    
    // Team data - only accessible by team members
    match /teams/{teamId} {
      allow read, write: if request.auth != null && 
        request.auth.uid in resource.data.members;
    }
  }
}
```

### **4.3 Create Initial Collections**
- `users` - User profiles and data
- `skills` - Skill progress tracking
- `verifications` - Employment verification data
- `teams` - Enterprise team data
- `analytics` - App usage analytics

---

## 🔔 **Step 5: Configure Cloud Messaging**

### **5.1 Enable Cloud Messaging**
1. Go to **Project Settings** → **Cloud Messaging**
2. **iOS app configuration:**
   - **APNs Authentication Key:** Upload your key
   - **Key ID:** Your Apple Key ID
   - **Team ID:** Your Apple Team ID (6741892723)

### **5.2 APNs Key Setup**
1. Go to Apple Developer Console
2. **Certificates, Identifiers & Profiles** → **Keys**
3. Create new key with **Apple Push Notifications service**
4. Download and upload to Firebase

---

## 📈 **Step 6: Configure Analytics**

### **6.1 Enable Google Analytics**
1. **Project Settings** → **Integrations** → **Google Analytics**
2. **Enable** Google Analytics for Firebase
3. **Property:** Create new or use existing

### **6.2 Configure Events**
Set up custom events for:
- User registration
- Skill completion
- Verification requests
- App usage patterns

---

## 🔒 **Step 7: Security & Compliance**

### **7.1 Data Retention**
- **User data:** 7 years (for verification compliance)
- **Analytics data:** 2 years
- **Logs:** 30 days

### **7.2 Privacy Settings**
- **Data collection:** Enable for App Store compliance
- **Crash reporting:** Enable for production monitoring
- **Performance monitoring:** Enable

---

## 🧪 **Step 8: Testing Production Setup**

### **8.1 Update Xcode Configuration**
1. Replace `GoogleService-Info.plist` with production version
2. **Build Configuration:** Ensure production uses production Firebase
3. **Scheme:** Create separate production scheme

### **8.2 Test Authentication**
```swift
// Test production authentication
Auth.auth().signIn(withEmail: "test@stryvr.app", password: "testpass") { result, error in
    if let error = error {
        print("❌ Auth error: \(error)")
    } else {
        print("✅ Production auth working")
    }
}
```

### **8.3 Test Firestore**
```swift
// Test production Firestore
let db = Firestore.firestore()
db.collection("test").addDocument(data: ["test": "production"]) { error in
    if let error = error {
        print("❌ Firestore error: \(error)")
    } else {
        print("✅ Production Firestore working")
    }
}
```

---

## 📱 **Step 9: App Store Integration**

### **9.1 App Store Connect Setup**
1. Go to **App Store Connect**
2. **My Apps** → **"+"** → **New App**
3. **Platform:** iOS
4. **Bundle ID:** `com.stryvr.app`
5. **SKU:** `stryvr-ios-2024`
6. **User Access:** Full Access

### **9.2 Firebase App Store Integration**
1. In Firebase Console → **Project Settings** → **Your apps**
2. Click on your iOS app
3. **App Store ID:** Add your App Store ID (after submission)

---

## ✅ **Step 10: Final Verification**

### **10.1 Production Checklist**
- [ ] Production Firebase project created
- [ ] Production `GoogleService-Info.plist` downloaded and added
- [ ] Authentication methods configured
- [ ] Firestore security rules implemented
- [ ] Cloud Messaging configured
- [ ] Analytics enabled
- [ ] App Store Connect app created
- [ ] Production build tested

### **10.2 Environment Variables**
```bash
# Production Firebase
FIREBASE_PROJECT_ID=stryvr-production
FIREBASE_API_KEY=your-production-api-key
FIREBASE_APP_ID=your-production-app-id

# App Store
APP_STORE_ID=your-app-store-id
APP_STORE_BUNDLE_ID=com.stryvr.app
```

---

## 🚨 **Important Notes**

### **Security**
- Never commit production `GoogleService-Info.plist` to git
- Use environment variables for sensitive data
- Regularly rotate API keys

### **Compliance**
- Ensure GDPR compliance for EU users
- Implement data deletion requests
- Maintain audit logs

### **Monitoring**
- Set up Firebase Crashlytics
- Monitor Firestore usage and costs
- Track authentication failures

---

## 📞 **Support**

**Firebase Support:** https://firebase.google.com/support  
**Apple Developer Support:** https://developer.apple.com/support/  
**StryVr Tech Support:** tech@stryvr.app  

---

**Last Updated:** [Current Date]  
**Version:** 1.0  
**Status:** Ready for Production Setup 