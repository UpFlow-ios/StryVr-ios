# stryvr - AI-Powered Professional Development

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-18.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> Professional development platform for workplace performance tracking and skill analytics.

## 🚀 About stryvr

stryvr is an iOS app that provides professional development tools for workplace performance tracking and skill analytics. Our mission is to help users track their progress and improve their professional skills. The app features a modern Liquid Glass + Apple Glow UI design with premium visual effects and Apple-native aesthetics.

### ✨ Key Features

- **🎯 Skill Tracking** - Monitor and track professional skill development
- **🚀 Career Path Guidance** - Personalized skill recommendations
- **🏆 Gamified Learning** - Complete challenges to earn badges
- **📊 Enterprise Analytics** - Team performance insights and skill gap identification
- **🔒 Secure & Private** - Enterprise-grade encryption and data protection
- **🎨 Liquid Glass UI** - Modern Apple-native design with premium visual effects

### 🛠 Tech Stack

- **Frontend**: Swift 6.0, SwiftUI, Core Data
- **Backend**: Node.js, Express.js, Firebase
- **AI/ML**: OpenAI API, HuggingFace, Custom ML models
- **Security**: AES-GCM 256-bit encryption, Keychain integration
- **Database**: Firebase Firestore, Core Data
- **Authentication**: Firebase Auth, SecureStorageManager
- **Development**: Oh My Zsh, SwiftLint, SwiftFormat, VS Code

## 📱 Screenshots

*[App screenshots will be added here]*

## 🚀 Getting Started

### Prerequisites

- Xcode 16.0+
- iOS 16.0+
- Swift 6.0
- Node.js 18+ (for backend)
- Homebrew (for development tools)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/upflow-ios/stryvr-ios.git
   cd stryvr-ios
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

4. **Setup Development Environment (Optional but Recommended)**
   ```bash
   # Install development tools
   brew install swiftlint swiftformat fzf ripgrep bat eza git-delta lazygit
   
   # Install terminal enhancements
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   
   # Install VS Code extensions
   code --install-extension ms-vscode.vscode-swift
   code --install-extension vknabel.vscode-swift-development-environment
   ```

5. **Run the App**
   - Open Xcode
   - Select your target device/simulator
   - Press Cmd+R to build and run
   - Or use our build script: `./build-stryvr.sh`
   - Or use our custom commands: `build`, `clean`, `lint`, `format`

## 🛠️ Development Environment

### **Professional Setup** ✅ **RECOMMENDED**

StryVr comes with a complete professional development environment setup that includes:

#### **Terminal Enhancement**
- **Oh My Zsh** + **Powerlevel10k** theme for a beautiful terminal experience
- **iTerm2** with syntax highlighting and auto-suggestions
- **FZF** for fuzzy file finding and command history

#### **Code Quality Tools**
- **SwiftLint** for code style enforcement
- **SwiftFormat** for automatic code formatting
- **Custom aliases** for streamlined development workflow

#### **Enhanced File Management**
- **Bat** for syntax-highlighted file viewing
- **Eza** for modern file listing with icons
- **Ripgrep** for fast text search across the codebase

#### **Git Workflow Optimization**
- **Git Delta** for enhanced diff viewing
- **LazyGit** for terminal-based Git GUI
- **Custom shortcuts**: `gs`, `ga`, `gc`, `gp`, `gl`, `gd`

#### **StryVr-Specific Commands**
```bash
stryvr-dev          # Show all development commands
stryvr              # Navigate to project directory
build               # Build the iOS app
clean               # Clean build folder
lint                # Run SwiftLint
format              # Run SwiftFormat
test                # Run tests
stryvr-commit "msg" # Quick commit and push
```

### **Quick Setup**
```bash
# Install all development tools at once
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
brew install swiftlint swiftformat fzf ripgrep bat eza git-delta lazygit
```

---

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
├── Docs/                     # Documentation
└── build-stryvr.sh           # Safe build script
```

## 🔧 Build & Development

### **Quick Build**
```bash
./build-stryvr.sh
```

### **Build Documentation**
- [Build Status & Recent Fixes](Docs/BUILD_STATUS.md)
- [Quick Start Guide](Docs/QUICK_START.md)
- [Contributing Guidelines](CONTRIBUTING.md)

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
- **🤖 AI-Powered** - Machine learning integration
- **🎯 User-Centric** - Designed for real user needs

## 📞 Support & Contact

### **Get in Touch**

- **📧 Email**: [joedormond@stryvr.app](mailto:joedormond@stryvr.app)
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
- **🐛 Bug Reports**: [GitHub Issues](https://github.com/upflow-ios/stryvr-ios/issues)
- **💡 Feature Requests**: [GitHub Discussions](https://github.com/upflow-ios/stryvr-ios/discussions)
- **🌐 Website**: [stryvr.app](https://stryvr.app)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **OpenAI** for AI capabilities
- **Firebase** for backend services
- **Apple** for iOS development tools
- **Open Source Community** for inspiration and tools

---

**Built with ❤️ for professional development**

[Website](https://stryvr.app) • [LinkedIn](https://linkedin.com/company/stryvr-ios) • [Instagram](https://instagram.com/stryvr_app) • [Twitter](https://twitter.com/josephdormond) 