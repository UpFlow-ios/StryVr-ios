# stryvr - AI-Powered Professional Development

[![Swift](https://img.shields.io/badge/Swift-6.1.2-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-18.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> Real-time skill assessment during video calls. Track progress, earn achievements, and accelerate your career with AI-driven insights.

## 🚀 About stryvr

stryvr is an iOS app that revolutionizes professional development by providing real-time AI-powered skill assessment during video calls. Our mission is to make learning measurable, engaging, and effective.

### ✨ Key Features

- **🎯 Real-Time Assessment** - AI analyzes communication skills during calls
- **🚀 Career Path Guidance** - Personalized skill recommendations
- **🏆 Gamified Learning** - Complete challenges to earn badges
- **📊 Enterprise Analytics** - Team performance insights and skill gap identification
- **🔒 Secure & Private** - Enterprise-grade encryption and data protection

### 🛠 Tech Stack

- **Frontend**: Swift 6.1.2, SwiftUI, Core Data
- **Backend**: Node.js, Express.js, Firebase
- **AI/ML**: OpenAI API, HuggingFace, Custom ML models
- **Security**: AES-GCM 256-bit encryption, Keychain integration
- **Database**: Firebase Firestore, Core Data
- **Authentication**: Firebase Auth, SecureStorageManager

## 📱 Screenshots

*[App screenshots will be added here]*

## 🚀 Getting Started

### Prerequisites

- Xcode 16.0+
- iOS 18.0+
- Swift 6.1.2
- Node.js 18+ (for backend)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/UpFlow-ios/StryVr-ios.git
   cd StryVr-ios
   ```

2. **Setup iOS App**
   ```bash
   cd SupportingFiles
   open StryVr.xcodeproj
   ```

3. **Setup Backend (Optional)**
   ```bash
   cd backend
   npm install
   cp .env.example .env
   # Add your API keys to .env
   npm start
   ```

4. **Run the App**
   - Open Xcode
   - Select your target device/simulator
   - Press Cmd+R to build and run

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the `backend` directory:

```env
# Firebase Configuration
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_PRIVATE_KEY=your_private_key
FIREBASE_CLIENT_EMAIL=your_client_email
FIREBASE_STORAGE_BUCKET=your_storage_bucket

# API Keys
OPENAI_API_KEY=your_openai_key
HUGGINGFACE_API_KEY=your_huggingface_key

# Server Configuration
PORT=5000
NODE_ENV=development
```

### iOS Configuration

1. Add your `GoogleService-Info.plist` to the project
2. Configure Firebase in your iOS app
3. Set up your API keys in the app configuration

## 📁 Project Structure

```
stryvr-ios/
├── StryVr/                    # iOS App Source
│   ├── App/                   # App configuration
│   ├── Models/                # Data models
│   ├── Views/                 # SwiftUI views
│   ├── Services/              # Business logic
│   └── Utils/                 # Utilities and helpers
├── backend/                   # Node.js backend
│   ├── server.js             # Express server
│   ├── functions/            # Firebase functions
│   └── package.json          # Dependencies
├── Marketing/                # Marketing assets and guides
├── Scripts/                  # Automation scripts
└── Docs/                     # Documentation
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📊 Roadmap

- [ ] **Phase 1**: Core skill assessment features
- [ ] **Phase 2**: Advanced AI analytics
- [ ] **Phase 3**: Enterprise team features
- [ ] **Phase 4**: Integration marketplace
- [ ] **Phase 5**: Mobile apps (Android)

## 🔒 Security

We take security seriously. StryVr implements:

- **AES-GCM 256-bit encryption** for all sensitive data
- **Secure Keychain integration** for credential storage
- **Environment variable management** for API keys
- **Regular security audits** and updates
- **GDPR compliance** for data privacy

## 📈 Analytics & Privacy

- **No personal data collection** without consent
- **Anonymous analytics** for app improvement
- **Local data processing** where possible
- **Transparent privacy policy** and data handling

## 🏆 Achievements

- **🏗️ Built in Public** - Transparent development process
- **🔒 Enterprise Security** - Bank-level encryption
- **📱 Native iOS** - Optimized for Apple ecosystem
- **🤖 AI-Powered** - Cutting-edge machine learning
- **🎯 User-Centric** - Designed for real user needs

## 📞 Support & Contact

### **Get in Touch**

- **📧 Email**: [upflowapp@gmail.com](mailto:upflowapp@gmail.com)
- **💼 LinkedIn**: [Joe Dormond](https://linkedin.com/in/joedormond)
- **🐙 GitHub**: [@joedormond](https://github.com/joedormond)
- **🐦 Twitter/X**: [@josephdormond](https://twitter.com/josephdormond)
- **📋 Full Contact Info**: [CONTACT.md](CONTACT.md) - Detailed contact information and availability

### **Business Inquiries**

- **🤝 Partnerships**: [partnerships@stryvr.app](mailto:partnerships@stryvr.app)
- **💼 Enterprise Sales**: [enterprise@stryvr.app](mailto:enterprise@stryvr.app)
- **📊 Investor Relations**: [investors@stryvr.app](mailto:investors@stryvr.app)
- **🔧 Technical Support**: [support@stryvr.app](mailto:support@stryvr.app)

### **Resources**

- **📚 Documentation**: [Docs/](Docs/)
- **🐛 Bug Reports**: [GitHub Issues](https://github.com/UpFlow-ios/StryVr-ios/issues)
- **💡 Feature Requests**: [GitHub Discussions](https://github.com/UpFlow-ios/StryVr-ios/discussions)
- **🌐 Website**: [stryvr.app](https://stryvr.app)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **OpenAI** for AI capabilities
- **Firebase** for backend services
- **Apple** for iOS development tools
- **Open Source Community** for inspiration and tools

---

**Built with ❤️ for the future of professional development**

[Website](https://stryvr.app) • [LinkedIn](https://linkedin.com/company/stryvr-ios) • [Instagram](https://instagram.com/stryvr_app) • [Twitter](https://twitter.com/josephdormond) 