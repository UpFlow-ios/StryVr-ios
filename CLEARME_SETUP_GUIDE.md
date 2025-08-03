# 🔐 ClearMe API Integration Setup Guide

## **Complete Setup for StryVr Biometric Verification**

This guide will walk you through setting up ClearMe API integration for StryVr's biometric identity verification system.

---

## 📋 **Prerequisites**

- ✅ StryVr iOS app with verification system implemented
- ✅ ClearMe developer account (sign up at https://verified.clearme.com)
- ✅ Production environment ready for API integration
- ✅ App Store Connect account for environment variables

---

## 🚀 **Step 1: ClearMe Developer Account Setup**

### **1.1 Create ClearMe Account**
1. Visit [https://verified.clearme.com](https://verified.clearme.com)
2. Click "Sign Up" or "Get Started"
3. Choose "Developer Account" or "API Access"
4. Complete registration with your business information

### **1.2 Verify Your Account**
- Provide business documentation
- Complete identity verification
- Wait for account approval (usually 1-2 business days)

---

## 🔑 **Step 2: Generate API Credentials**

### **2.1 Access API Dashboard**
1. Log into your ClearMe developer account
2. Navigate to "API Credentials" or "Developer Tools"
3. Click "Generate New API Key"

### **2.2 Create API Key**
- **Key Name**: `StryVr-Production`
- **Key Type**: Production
- **Permissions**: Full access to verification endpoints
- **Expiration**: Set to 1 year (renewable)

### **2.3 Save Your Credentials**
**IMPORTANT**: Save these securely - you won't see them again!
- **API Key**: `clearme_prod_xxxxxxxxxxxxxxxx`
- **Client Secret**: `cs_xxxxxxxxxxxxxxxxxxxxxxxx`
- **Webhook Secret**: `whsec_xxxxxxxxxxxxxxxx`

---

## ⚙️ **Step 3: Configure StryVr Integration**

### **3.1 Update Development Credentials**
Edit `StryVr/Config/ClearMeSecrets.swift`:

```swift
#if DEBUG
/// Development API Key
static let developmentAPIKey = "clearme_dev_xxxxxxxxxxxxxxxx"

/// Development Client Secret
static let developmentClientSecret = "cs_xxxxxxxxxxxxxxxxxxxxxxxx"
#endif
```

### **3.2 Test Integration**
1. Build and run StryVr in debug mode
2. Navigate to verification section
3. Test ClearMe verification flow
4. Verify API calls are successful

---

## 🌐 **Step 4: Configure Webhooks (Optional)**

### **4.1 Set Up Webhook Endpoint**
If you want real-time verification updates:

```
Webhook URL: https://stryvr.app/api/clearme/webhook
Events: verification.completed, verification.failed
Secret: whsec_xxxxxxxxxxxxxxxx
```

### **4.2 Webhook Handler**
Create webhook handler in your backend to process verification updates.

---

## 🏭 **Step 5: Production Deployment**

### **5.1 App Store Connect Environment Variables**
1. Go to App Store Connect > Your App > TestFlight > Builds
2. Click "Environment Variables"
3. Add the following variables:

```
CLEARME_API_KEY=clearme_prod_xxxxxxxxxxxxxxxx
CLEARME_CLIENT_SECRET=cs_xxxxxxxxxxxxxxxxxxxxxxxx
```

### **5.2 CI/CD Pipeline (if using)**
Add to your deployment script:

```bash
export CLEARME_API_KEY="clearme_prod_xxxxxxxxxxxxxxxx"
export CLEARME_CLIENT_SECRET="cs_xxxxxxxxxxxxxxxxxxxxxxxx"
```

---

## 🧪 **Step 6: Testing & Validation**

### **6.1 Sandbox Testing**
1. Use ClearMe's sandbox environment first
2. Test with sample data provided by ClearMe
3. Verify all verification levels work correctly

### **6.2 Production Testing**
1. Switch to production API endpoints
2. Test with real user data (with consent)
3. Verify verification accuracy and speed

### **6.3 Error Handling**
Test various error scenarios:
- Invalid API key
- Network timeouts
- User cancellation
- Verification failures

---

## 📊 **Step 7: Monitoring & Analytics**

### **7.1 ClearMe Dashboard**
Monitor verification metrics in ClearMe dashboard:
- Success rates
- Processing times
- Error rates
- User feedback

### **7.2 StryVr Analytics**
Track verification usage in StryVr:
- Verification attempts
- Completion rates
- User satisfaction
- Performance metrics

---

## 🔒 **Step 8: Security Best Practices**

### **8.1 API Key Security**
- ✅ Never commit API keys to version control
- ✅ Use environment variables for production
- ✅ Rotate API keys regularly
- ✅ Monitor API key usage

### **8.2 Data Privacy**
- ✅ Encrypt sensitive verification data
- ✅ Implement proper data retention policies
- ✅ Ensure GDPR/CCPA compliance
- ✅ Get user consent for verification

### **8.3 Error Handling**
- ✅ Don't expose API keys in error messages
- ✅ Log errors securely
- ✅ Implement rate limiting
- ✅ Handle verification failures gracefully

---

## 📱 **Step 9: User Experience**

### **9.1 Clear Instructions**
Provide users with:
- Clear explanation of verification process
- Expected timeframes
- What data is collected
- How data is used

### **9.2 Progress Indicators**
- Show verification progress
- Provide status updates
- Handle timeouts gracefully
- Offer retry options

### **9.3 Success Feedback**
- Celebrate successful verification
- Show verification badges
- Provide next steps
- Encourage sharing

---

## 🚨 **Troubleshooting**

### **Common Issues**

#### **API Key Errors**
```
Error: Invalid API key
Solution: Verify API key is correct and active
```

#### **Network Timeouts**
```
Error: Request timeout
Solution: Check network connectivity and API status
```

#### **Verification Failures**
```
Error: Verification failed
Solution: Check user data quality and ClearMe requirements
```

### **Support Resources**
- ClearMe API Documentation: [https://docs.clearme.com](https://docs.clearme.com)
- ClearMe Support: support@clearme.com
- StryVr Development Team: [Your contact info]

---

## ✅ **Verification Checklist**

- [ ] ClearMe developer account created
- [ ] API credentials generated
- [ ] Development integration tested
- [ ] Production credentials configured
- [ ] Environment variables set
- [ ] Webhooks configured (optional)
- [ ] Error handling implemented
- [ ] User experience optimized
- [ ] Security measures in place
- [ ] Monitoring set up
- [ ] Documentation updated

---

## 🎯 **Next Steps**

1. **Complete ClearMe setup** using this guide
2. **Test verification flow** thoroughly
3. **Deploy to production** with proper credentials
4. **Monitor performance** and user feedback
5. **Optimize based on data** and user experience

---

## 📞 **Support**

If you encounter any issues during setup:

1. **Check ClearMe documentation** first
2. **Review error logs** in StryVr
3. **Contact ClearMe support** for API issues
4. **Contact StryVr team** for integration issues

---

**🎉 Congratulations!** Your ClearMe integration is now ready for production use in StryVr's verification system. 