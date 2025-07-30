# App Store Deployment Guide

## 🚀 **StryVr App Store Deployment Configuration**

This document outlines the complete App Store deployment setup for StryVr, including Apple Developer account configuration, certificates, and submission process.

## 📱 **App Store Connect Configuration**

### **App Details**
- **App Name**: stryvr
- **Bundle ID**: `com.stryvr.app`
- **Apple ID**: `6741892723`
- **SKU**: `com.stryvr.app`
- **Primary Language**: English (U.S.)

### **App Store Connect URL**
- **Production**: https://appstoreconnect.apple.com/app/6741892723

## 👨‍💻 **Apple Developer Account**

### **Account Information**
- **Developer**: Joseph Dormond
- **Email**: josephdormond6550@hotmail.com
- **Team ID**: `69Y49KN8KD`
- **Program**: Apple Developer Program (Individual)
- **Enrollment**: Active until February 12, 2026
- **Annual Fee**: US$99

### **Contact Information**
- **Phone**: 13239949569
- **Address**: 
  - 727 W 7TH ST, APT 721
  - Los Angeles, California 77082
  - United States

## 🔐 **Development Certificates**

### **Apple Development Certificate**
- **Certificate ID**: `8SKVRG3B6Q`
- **User ID**: `3N4658FXUL`
- **Common Name**: Apple Development: josephdormond6550@hotmail.com
- **Organizational Unit**: `69Y49KN8KD`
- **Organization**: Joseph Dormond
- **Country**: US
- **Valid Period**: January 13, 2025 - January 13, 2026
- **Issuer**: Apple Worldwide Developer Relations Certification Authority

### **Serial Number**
```
7A 54 07 40 47 E6 05 7A 2B C8 77 83 3B 4F B9 C8
```

## 🏗️ **Xcode Project Configuration**

### **Build Settings**
- **Development Team**: `69Y49KN8KD`
- **Bundle Identifier**: `com.stryvr.app`
- **Code Signing Style**: Automatic
- **Code Sign Identity**: Apple Development
- **iOS Deployment Target**: 16.0+

### **Info.plist Configuration**
- **CFBundleDisplayName**: StryVr
- **CFBundleIdentifier**: com.stryvr.app
- **CFBundleVersion**: 1.0.0
- **CFBundleShortVersionString**: 1.0

## 📋 **Pre-Deployment Checklist**

### **App Store Connect Setup** ✅
- [x] App created in App Store Connect
- [x] Bundle ID configured correctly
- [x] App name and metadata set
- [x] Primary language configured

### **Developer Account** ✅
- [x] Apple Developer Program active
- [x] Development certificate valid
- [x] Team ID configured in Xcode
- [x] Provisioning profiles set up

### **App Configuration** ✅
- [x] Bundle identifier matches App Store Connect
- [x] App icons configured
- [x] Launch screen implemented
- [x] Required permissions documented

## 🚀 **Deployment Process**

### **Step 1: Build and Archive**
```bash
# In Xcode:
# 1. Select "Any iOS Device" as target
# 2. Product → Archive
# 3. Verify archive in Organizer
```

### **Step 2: Upload to App Store Connect**
```bash
# In Xcode Organizer:
# 1. Select latest archive
# 2. Click "Distribute App"
# 3. Choose "App Store Connect"
# 4. Upload and wait for processing
```

### **Step 3: App Store Listing**
- **Screenshots**: 6.7" iPhone, 5.5" iPhone, 12.9" iPad
- **App Description**: Professional workplace performance platform
- **Keywords**: workplace, performance, analytics, skills, productivity
- **Category**: Productivity
- **Age Rating**: 4+

### **Step 4: Submit for Review**
- [ ] Complete app metadata
- [ ] Upload screenshots
- [ ] Set app description
- [ ] Configure pricing
- [ ] Submit for review

## 🔧 **Troubleshooting**

### **Common Issues**
1. **Bundle ID Mismatch**: Ensure `com.stryvr.app` matches everywhere
2. **Certificate Expired**: Renew before January 13, 2026
3. **Team ID Issues**: Verify `69Y49KN8KD` in Xcode settings
4. **Upload Failures**: Check code signing and provisioning profiles

### **Support Resources**
- **Apple Developer Documentation**: https://developer.apple.com/documentation
- **App Store Connect Help**: https://help.apple.com/app-store-connect
- **Xcode Documentation**: https://developer.apple.com/xcode

## 📞 **Emergency Contacts**

### **Apple Developer Support**
- **Phone**: 1-800-633-2152
- **Hours**: Monday-Friday, 6:00 AM - 6:00 PM PST

### **App Store Connect Support**
- **Email**: appstoreconnect@apple.com
- **Response Time**: 24-48 hours

## 🔄 **Maintenance Schedule**

### **Certificate Renewal**
- **Next Renewal**: January 13, 2026
- **Reminder**: Set calendar alert for December 2025
- **Process**: Automatic renewal through Xcode

### **App Updates**
- **Version Strategy**: Semantic versioning (1.0.0, 1.1.0, etc.)
- **Update Frequency**: Monthly feature updates
- **Review Process**: 24-48 hours typical

---

**Last Updated**: January 2025  
**Next Review**: February 2025  
**Maintained By**: Joseph Dormond 