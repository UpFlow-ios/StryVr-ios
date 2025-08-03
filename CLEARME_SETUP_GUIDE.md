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
4. Note: ClearMe API uses GET requests to list verification sessions

### **2.2 Create Sandbox API Key**
- **Key Name**: `StryVr-Sandbox`
- **Key Type**: Sandbox (for testing)
- **Permissions**: Full access to verification endpoints
- **Expiration**: Set to 1 year (renewable)

### **2.3 Save Your Credentials**
**IMPORTANT**: Save these securely - you won't see them again!
- **Sandbox API Key**: `clearme_sandbox_xxxxxxxxxxxxxxxx`
- **Sandbox Project ID**: `proj_xxxxxxxxxxxxxxxx`
- **Production API Key**: Contact ClearMe support when ready
- **Production Project ID**: Contact ClearMe support when ready

---

## ⚙️ **Step 3: Configure StryVr Integration**

### **3.1 Update Development Credentials**
Edit `StryVr/Config/ClearMeSecrets.swift`:

```swift
#if DEBUG
/// Sandbox API Key
static let developmentAPIKey = "clearme_sandbox_xxxxxxxxxxxxxxxx"

/// Sandbox Project ID
static let developmentProjectId = "proj_xxxxxxxxxxxxxxxx"
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
CLEARME_PROJECT_ID=proj_xxxxxxxxxxxxxxxx
```

### **5.2 CI/CD Pipeline (if using)**
Add to your deployment script:

```bash
export CLEARME_API_KEY="clearme_prod_xxxxxxxxxxxxxxxx"
export CLEARME_PROJECT_ID="proj_xxxxxxxxxxxxxxxx"
```

---

## 🧪 **Step 6: Testing & Validation**

### **6.1 Sandbox Testing**
1. Use ClearMe's sandbox environment first
2. **Magic OTP Code**: Use `123456` for testing
3. **Default Behavior**: All verifications succeed in sandbox
4. **Test Failures**: Check "Reject verification" to test failure scenarios

### **6.2 Production Testing**
1. Contact ClearMe support for production API key
2. Test with real user data (with consent)
3. Verify verification accuracy and speed

### **6.3 Error Handling**
Test various error scenarios:
- Network connectivity issues
- Invalid API keys
- Rate limiting
- Verification timeouts

---

## 🔐 **Step 7: Security & Compliance**

### **7.1 Data Protection**
- All API calls use HTTPS
- API keys are stored securely
- User consent is required for verification
- Data retention policies are followed

### **7.2 Privacy Compliance**
- GDPR compliance for EU users
- CCPA compliance for California users
- Clear privacy policy and terms of service
- User data deletion capabilities

---

## 📊 **Step 8: Monitoring & Analytics**

### **8.1 Verification Metrics**
Track the following metrics:
- Verification success rate
- Average verification time
- User drop-off points
- Error rates and types

### **8.2 Performance Monitoring**
- API response times
- Network latency
- Error handling effectiveness
- User experience metrics

---

## 🚀 **Step 9: Go Live Checklist**

### **9.1 Pre-Launch**
- [ ] Sandbox testing completed
- [ ] Production API key obtained
- [ ] Environment variables configured
- [ ] Error handling tested
- [ ] Privacy policy updated
- [ ] Terms of service updated

### **9.2 Launch Day**
- [ ] Monitor verification success rates
- [ ] Check for any API errors
- [ ] Verify user experience
- [ ] Monitor performance metrics

---

## 📞 **Support & Resources**

### **ClearMe Support**
- **Documentation**: https://verified.clearme.com/docs
- **API Reference**: https://verified.clearme.com/api
- **Support Email**: support@clearme.com
- **Developer Community**: https://community.clearme.com

### **StryVr Integration Support**
- **Technical Issues**: Check the verification service logs
- **Configuration Help**: Review ClearMeConfig.swift
- **Testing Assistance**: Use sandbox environment first

### **API Documentation**
- **Base URL**: https://verified.clearme.com/v1
- **Authentication**: Bearer token
- **Method**: GET for listing verification sessions
- **Rate Limits**: Check ClearMe documentation
- **Webhooks**: Configure for real-time verification updates

---

## ✅ **Success Metrics**

### **Verification Success Rate**
- Target: >95% successful verifications
- Monitor: Failed verification reasons
- Optimize: User experience and error handling

### **User Adoption**
- Track: Number of users completing verification
- Measure: Time to complete verification
- Improve: Onboarding and user guidance

### **Performance**
- Target: <5 seconds average verification time
- Monitor: API response times
- Optimize: Network requests and caching

---

**🎉 Congratulations!** Your ClearMe integration is now ready for production use. The biometric verification system will provide your users with secure, reliable identity verification while maintaining the highest standards of privacy and security. 