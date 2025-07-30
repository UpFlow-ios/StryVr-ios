# 🚀 Quick Start Guide

## ⚡ Get StryVr Running in 5 Minutes

### Prerequisites
- Xcode 16.0+ 
- iOS 18.0+ Simulator
- Swift 6.1.2
- Git

### 1. Clone & Setup
```bash
git clone https://github.com/UpFlow-ios/StryVr-ios.git
cd stryvr-ios
```

### 2. Open in Xcode
```bash
open SupportingFiles/StryVr.xcodeproj
```

### 3. Build & Run
- Select iOS Simulator (iPhone 15 Pro recommended)
- Press `Cmd+R` to build and run
- App should launch with onboarding flow

### 4. Backend (Optional)
```bash
cd backend
npm install
cp .env.example .env
# Add your API keys
npm start
```

## 🎯 Key Features to Test

### **Onboarding Flow**
- Complete the intro screens
- Set up your profile
- Grant necessary permissions

### **Core Features**
- **Skill Dashboard** - View your skill matrix
- **AI Coach** - Get personalized recommendations  
- **Challenges** - Complete skill-building tasks
- **Reports** - Generate performance insights

### **Enterprise Features**
- **Team Analytics** - View team health metrics
- **Behavior Feedback** - AI-powered insights
- **Learning Paths** - Personalized skill development

## 🐛 Common Issues

### **Build Errors**
- Clean build folder: `Cmd+Shift+K`
- Reset package caches: `File > Packages > Reset Package Caches`
- Check Swift version: Ensure Xcode uses Swift 6.1.2

### **Firebase Issues**
- Verify `GoogleService-Info.plist` is in project
- Check Firebase console for configuration
- Ensure proper bundle ID matches

### **API Keys**
- Add keys to `backend/.env` file
- Restart backend server after changes
- Check network connectivity

## 📱 Testing Checklist

- [ ] App launches without crashes
- [ ] Onboarding flow completes
- [ ] Firebase authentication works
- [ ] Skill dashboard loads data
- [ ] AI recommendations appear
- [ ] Challenges can be completed
- [ ] Reports generate properly
- [ ] Push notifications work
- [ ] Dark/Light mode toggle
- [ ] Accessibility features work

## 🔧 Development Tips

### **SwiftUI Best Practices**
- Use `@StateObject` for ViewModels
- Implement proper error handling
- Follow Apple HIG guidelines
- Test on multiple device sizes

### **Performance**
- Use `LazyVStack` for large lists
- Implement proper image caching
- Monitor memory usage
- Profile with Instruments

### **Security**
- Never commit API keys
- Use environment variables
- Implement proper data validation
- Follow OWASP guidelines

## 📞 Need Help?

- **🐛 Bugs**: [GitHub Issues](https://github.com/UpFlow-ios/StryVr-ios/issues)
- **💡 Ideas**: [GitHub Discussions](https://github.com/UpFlow-ios/StryVr-ios/discussions)
- **📧 Email**: joedormond@stryvr.app
- **💼 LinkedIn**: [Joe Dormond](https://linkedin.com/in/joedormond)

---

**🎉 Welcome to the StryVr community! Let's build the future of professional development together.** 