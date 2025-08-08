# 🚀 StryVr - AI-Powered Professional Development Platform

[![Swift](https://img.shields.io/badge/Swift-6.1.2-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0+-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> **Professional HR-Verified Resume Platform** - Helping professionals showcase their verified employment history, earnings, and performance metrics to employers.

## 🌟 About StryVr

**StryVr** is an AI-powered professional development platform that helps professionals track, measure, and accelerate career growth. Built for individuals and organizations, StryVr combines AI technology with intuitive design to deliver skill assessment and personalized career guidance.

### 🎯 **The Core Vision (November 2024)**

StryVr was born from a simple idea: **What if resumes could be completely verified and trusted?** The **ReportsView** - our HR-verified professional resume system - is the foundation that started it all. It transforms traditional "trust me" resumes into **verified, data-driven professional profiles** that employers can rely on.

### 🎯 What Makes StryVr Different

- **📊 HR-Verified Professional Resume System**: The core feature that started StryVr - verified employment history, performance metrics, and earnings transparency
- **🤖 AI-Powered Insights**: Real-time analysis of workplace interactions during video calls
- **📈 Personalized Analytics**: Data-driven career path recommendations and skill assessments
- **🎮 Gamified Learning**: Achievement systems, challenges, and progress tracking
- **🏢 Enterprise Ready**: Team health monitoring and performance analytics for organizations
- **🔐 Secure & Private**: End-to-end encryption with biometric authentication
- **📱 Modern UI**: iOS 18 Liquid Glass effects with clean visual design

## ✨ Key Features

### **📊 ReportsView - The Foundation That Started StryVr**

#### **HR-Verified Professional Resume System**
- **Verified Employment History** - Past companies verify all data with HR integration
- **Real Performance Metrics** - Actual ratings, achievements, and responsibilities
- **Earnings Transparency** - Verified salary history and hourly rates
- **Skills Assessment** - Proven competencies with verification badges
- **Privacy Control** - Users can hide weak points while maintaining employer trust
- **Professional Sharing** - PDF generation for job applications and networking
- **ClearMe Integration** - Biometric identity verification for complete transparency
- **Company Verification** - HR-verified company associations and employment history
- **Okta Integration** - Seamless HR data sync for enterprise employers

#### **Professional Profile Features**
- **Professional Header** - Name, title, verification badge with HR trust
- **Quick Stats Dashboard** - Experience, companies, ratings overview
- **Employment Cards** - Verified jobs with performance metrics
- **Performance Metrics** - Leadership, technical skills, communication analysis
- **Skills & Competencies** - Verified skill assessments with proof
- **Earnings History** - Year-by-year verified salary data
- **Verification Status** - Real-time verification tracking
- **StryVr Pro Resume** - Premium PDF generation with enhanced features

### For Professionals
- **Real-Time Skill Assessment**: AI analyzes communication, leadership, and technical skills
- **Personalized Career Paths**: Data-driven recommendations for skill development
- **Achievement System**: Gamified progress tracking with badges and milestones
- **Secure Resume Builder**: Professional report generation with insights
- **Learning Challenges**: Interactive skill-building exercises and goals

### For Organizations
- **Team Health Analytics**: Monitor employee engagement and growth potential
- **Performance Insights**: Data-driven feedback on team dynamics
- **Behavioral Analytics**: Track workplace interactions and communication patterns
- **Enterprise Dashboard**: Comprehensive reporting and analytics suite

## 🛠️ Technical Stack

### Core Technologies
- **Swift 6.1.2** - Latest Swift language features and performance optimizations
- **SwiftUI 5.0+** - Modern declarative UI framework
- **iOS 18 Liquid Glass** - Modern visual effects and interactions
- **Firebase** - Authentication, Firestore, and real-time data
- **HuggingFace AI** - Advanced natural language processing

### Key Libraries
- **Swift Charts** - Beautiful data visualization and analytics
- **Lottie** - Smooth animations and micro-interactions
- **ConfettiSwiftUI** - Celebration effects and user engagement
- **OSLog** - Modern logging and debugging
- **Keychain Services** - Secure biometric authentication

### Architecture
- **MVVM Pattern** - Clean separation of concerns
- **Modular Design** - Scalable and maintainable codebase
- **Protocol-Oriented** - Swift best practices and testability
- **Dependency Injection** - Flexible and testable architecture

## 📱 Screenshots

<div align="center">
  <img src="Marketing/Assets/Screenshots/dashboard.png" width="200" alt="StryVr Dashboard">
  <img src="Marketing/Assets/Screenshots/analytics.png" width="200" alt="Analytics View">
  <img src="Marketing/Assets/Screenshots/career-path.png" width="200" alt="Career Path">
  <img src="Marketing/Assets/Screenshots/achievements.png" width="200" alt="Achievements">
</div>

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 16.0+ deployment target
- Apple Developer Account
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/upflow-ios/stryvr-ios.git
   cd stryvr-ios
   ```

2. **Install dependencies**
   ```bash
   # Install Swift Package Manager dependencies
   # (Automatically managed by Xcode)
   ```

3. **Configure Firebase**
   ```bash
   # Add your Firebase configuration files
   # GoogleService-Info.plist for iOS
   ```

4. **Build and run**
   ```bash
   # Open StryVr.xcodeproj in Xcode
   # Select your target device or simulator
   # Press Cmd+R to build and run
   ```

## 🏗️ Project Structure

```
StryVr/
├── App/                    # App configuration and lifecycle
├── Views/                  # SwiftUI views and UI components
│   ├── AI/                # AI-powered features and insights
│   ├── Analytics/         # Data visualization and charts
│   ├── Auth/              # Authentication and onboarding
│   ├── Challenges/        # Gamified learning features
│   ├── Enterprise/        # Business analytics and team features
│   ├── Home/              # Main dashboard and navigation
│   ├── Insights/          # Performance insights and feedback
│   ├── Profile/           # User profiles and settings
│   ├── Reports/           # 🎯 HR-Verified Professional Resume System (The Core Vision)
│   └── UIComponents/      # Reusable UI components
├── Models/                 # Data models and structures
├── Services/              # Business logic and external services
├── ViewModels/            # MVVM view models
├── Utils/                 # Utilities and helpers
└── Config/                # Configuration files
```

## 🎨 Design System

StryVr features a premium design system built with:

- **Liquid Glass UI**: iOS 18's latest visual effects
- **Dark Mode Support**: Optimized for all lighting conditions
- **Accessibility**: Full VoiceOver and Dynamic Type support
- **Responsive Design**: Adapts to all iOS device sizes
- **Premium Animations**: Smooth transitions and micro-interactions

## 🔧 Development

### Code Style
- **Swift 6.1.2** syntax and best practices
- **SwiftLint** for consistent code formatting
- **Documentation** for all public APIs
- **Unit Tests** for critical business logic

### Building
```bash
# Clean build
xcodebuild clean -project StryVr.xcodeproj -scheme StryVr

# Build for release
xcodebuild archive -project StryVr.xcodeproj -scheme StryVr -archivePath StryVr.xcarchive
```

### Testing
```bash
# Run unit tests
xcodebuild test -project StryVr.xcodeproj -scheme StryVr -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

## 📊 Performance

- **60 FPS animations** across all interactions
- **Optimized memory usage** for smooth performance
- **Efficient data loading** with intelligent caching
- **Background processing** for AI analysis
- **Battery optimization** for extended use

## 🔐 Security & Privacy

- **End-to-end encryption** for all user data
- **Biometric authentication** with Face ID/Touch ID
- **Secure keychain storage** for sensitive information
- **Privacy-first design** with local data processing
- **GDPR compliance** for European users

## 🌟 Contributing

We welcome contributions from the community! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Support

- **Website**: [stryvr.app](https://stryvr.app)
- **Documentation**: [docs.stryvr.app](https://docs.stryvr.app)
- **Issues**: [GitHub Issues](https://github.com/upflow-ios/stryvr-ios/issues)
- **Contact**: joedormond@stryvr.app

## 🙏 Acknowledgments

- **Apple** for SwiftUI and iOS development tools
- **Firebase** for backend infrastructure
- **HuggingFace** for AI capabilities
- **Open Source Community** for amazing libraries and tools

---

<div align="center">
  <strong>Built with ❤️ by Joseph Dormond</strong><br>
  <em>Transforming professional development through AI</em>
</div> 