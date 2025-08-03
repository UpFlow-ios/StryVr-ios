# StryVr - AI-Powered Professional Development Platform

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> **The Revolutionary HR-Verified Professional Resume Platform** - Transforming how professionals showcase their verified employment history, earnings, and performance metrics to employers.

## 🚀 About StryVr

**StryVr** is the next-generation AI-powered professional development platform that revolutionizes how professionals track, measure, and accelerate their career growth. Built for ambitious individuals and forward-thinking organizations, StryVr combines cutting-edge AI technology with intuitive design to deliver real-time skill assessment and personalized career guidance.

## 💰 **Monetization Strategy**

StryVr features a comprehensive **freemium model** with AI-powered user tracking and personalized recommendations:

### **Subscription Tiers:**
- **Free**: Basic skill tracking, limited AI insights, 3 career goals
- **Premium ($7.99/month)**: Unlimited AI insights, professional reports, skill assessments
- **Team ($29.99/month)**: Team analytics, manager dashboard, collaboration features
- **Enterprise ($99.99/month)**: White-label options, custom branding, dedicated support

### **AI-Powered User Tracking:**
- **Behavior Analysis**: Tracks feature usage, skill interactions, goal progress
- **Personalized Recommendations**: AI-generated career paths and skill suggestions
- **Revenue Optimization**: Converts insights to subscription upgrades and additional services

### **Additional Revenue Streams:**
- **Certification Programs**: Industry-recognized certifications
- **Career Coaching**: Professional coaching services
- **Premium Content**: Exclusive learning materials
- **Consulting Services**: Implementation consulting
- **White Label Solutions**: Custom branded versions

### 🎯 **The Core Vision (November 2024)**

StryVr was born from a simple yet revolutionary idea: **What if resumes could be completely verified and trusted?** The **ReportsView** - our HR-verified professional resume system - is the foundation that started it all. It transforms traditional "trust me" resumes into **verified, data-driven professional profiles** that employers can rely on.

### ✨ **Revolutionary Features**

#### **📊 HR-Verified Professional Resume System**
- **Verified Employment History** - Past companies verify all data
- **Real Performance Metrics** - Actual ratings, achievements, responsibilities
- **Earnings Transparency** - Verified salary history and hourly rates
- **Skills Assessment** - Proven competencies with verification badges
- **Privacy Control** - Users can hide weak points while maintaining employer trust
- **Professional Sharing** - PDF generation for job applications and networking
- **ClearMe Integration** - Biometric identity verification for complete transparency
- **Company Verification** - HR-verified company associations and employment history
- **Okta Integration** - Seamless HR data sync for enterprise employers

#### **🤖 AI-Powered Professional Development**
- **Real-Time Skill Assessment** - AI analyzes workplace interactions
- **Personalized Career Guidance** - Data-driven recommendations
- **Performance Analytics** - Track improvement over time
- **Goal Tracking** - Gamified learning with achievements and challenges

#### **🏢 Enterprise Analytics**
- **Team Performance Insights** - Comprehensive team health overview
- **Skill Gap Identification** - Data-driven training recommendations
- **Behavior Feedback System** - Real-time workplace behavior analysis
- **Growth Potential Analysis** - Predictive career trajectory insights

#### **🎨 Liquid Glass UI**
- **Modern Apple-Native Design** - Dark gradient backgrounds with frosted glass cards
- **Enhanced Glow Effects** - Pulsing animations and depth blur
- **Professional Aesthetics** - Premium visual effects throughout
- **Smooth Animations** - Spring-based transitions and scale effects

### 🛠 **Professional Tech Stack**

- **Frontend**: Swift 6.0, SwiftUI, Core Data
- **Backend**: Node.js, Express.js, Firebase
- **AI/ML**: OpenAI API, HuggingFace, Custom ML models
- **Security**: AES-GCM 256-bit encryption, Keychain integration
- **Database**: Firebase Firestore, Core Data
- **Authentication**: Firebase Auth, SecureStorageManager
- **Development**: Oh My Zsh, SwiftLint, SwiftFormat, VS Code

## 📱 **Core Views & Features**

### **🏠 Home Dashboard**
- AI-powered personalized greetings
- Today's Goal tracking with visual progress
- Skill Streak monitoring
- Active Challenges overview
- Recent Achievements showcase

### **📊 ReportsView (The Core Vision)**
- **HR-Verified Employment History** - The revolutionary feature that started StryVr
- **Professional Profile Header** - Name, title, verification badge
- **Quick Stats Dashboard** - Experience, companies, ratings
- **Employment Cards** - Verified jobs with performance metrics
- **Performance Metrics** - Leadership, technical skills, communication
- **Skills & Competencies** - Verified skill assessments
- **Earnings History** - Year-by-year verified salary data
- **Verification Status** - Real-time verification tracking
- **ClearMe Integration** - Biometric identity verification dashboard
- **Company Verification** - HR-verified company associations
- **Okta HR Sync** - Enterprise HR data integration

### **👤 Profile Management**
- Glass profile section with circular image
- Skills/Badges/Goals metrics with neon glow icons
- Professional achievements showcase
- Privacy controls and settings

### **🎯 Learning & Development**
- AI-generated learning paths
- Gamified challenges and achievements
- Skill visualization dashboards
- Progress tracking and analytics

### **🏢 Enterprise Features**
- Team health overview
- Employee performance analytics
- Behavior feedback system
- Growth potential analysis

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
   
   # Install Powerlevel10k theme
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
   
   # Install VS Code extensions
   code --install-extension ms-vscode.vscode-swift
   code --install-extension vknabel.vscode-swift-development-environment
   
   # Configure Powerlevel10k (run this after installation)
   source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
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
- **Professional Prompt**: Git status, time, directory, and command success indicators

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

#### **Powerlevel10k Features**
- **Git Integration**: Shows branch, commits ahead/behind, and file status
- **Time Display**: Current time in the prompt
- **Status Indicators**: Success (✔) and error (✘) indicators
- **Directory Shortening**: Smart path display
- **Professional Appearance**: Beautiful icons and colors

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
│   ├── App/                   # App configuration & lifecycle
│   ├── Models/                # Data models & enums
│   ├── Views/                 # SwiftUI views with Liquid Glass UI
│   │   ├── Home/             # Premium dashboard with AI greetings
│   │   ├── Reports/          # HR-verified professional resume system
│   │   ├── Profile/          # User profile management
│   │   ├── Auth/             # Authentication flows
│   │   ├── UITheme/          # Liquid Glass styling system
│   │   └── Debug/            # Development tools (DEBUG only)
│   ├── Services/              # Business logic & external integrations
│   ├── ViewModels/            # MVVM view models
│   ├── Utils/                 # Utilities & helpers
│   ├── Protocols/             # Service protocols for abstraction
│   └── Config/                # Environment configuration
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

### **Phase 1: Core Platform** ✅ **COMPLETED**
- [x] HR-verified professional resume system
- [x] AI-powered skill assessment
- [x] Liquid Glass UI implementation
- [x] Enterprise analytics dashboard
- [x] Professional development tracking

### **Phase 2: Advanced Features** 🚧 **IN PROGRESS**
- [ ] Enhanced AI recommendations
- [ ] Advanced team analytics
- [ ] Integration marketplace
- [ ] Mobile apps (Android)

### **Phase 3: Enterprise Expansion** 📋 **PLANNED**
- [ ] Advanced HR tools
- [ ] Custom reporting
- [ ] API integrations
- [ ] White-label solutions

## 🔒 Security

We take security seriously. StryVr implements:

- **AES-GCM 256-bit encryption** for all sensitive data
- **Secure Keychain integration** for credential storage
- **Environment variable management** for API keys
- **Regular security audits** and updates
- **GDPR compliance** for data privacy
- **HR verification system** for data integrity
- **ClearMe biometric verification** for identity transparency
- **Okta OIDC integration** for enterprise HR data sync

## 📈 Analytics & Privacy

- **No personal data collection** without consent
- **Anonymous analytics** for app improvement
- **Local data processing** where possible
- **Transparent privacy policy** and data handling
- **Verified data integrity** through HR partnerships

## 🏆 Achievements

- **🏗️ Built in Public** - Transparent development process
- **🔒 Enterprise Security** - Bank-level encryption
- **📱 Native iOS** - Optimized for Apple ecosystem
- **🤖 AI-Powered** - Machine learning integration
- **🎯 User-Centric** - Designed for real user needs
- **✅ HR-Verified** - Revolutionary resume verification system
- **🔐 ClearMe-Integrated** - Biometric identity verification for complete transparency
- **🔗 Okta-Connected** - Enterprise HR data integration for seamless verification

## 📞 Support & Contact

### **Get in Touch**

- **📧 Email**: [joedormond@stryvr.app](mailto:joedormond@stryvr.app)
- **💼 LinkedIn**: [Joe Dormond](https://linkedin.com/injoedormond)
- **🐙 GitHub**: [@upflow-ios](https://github.com/upflow-ios)
- **🌐 Website**: [stryvr.app](https://stryvr.app)

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
- **HR Professionals** for insights into verification needs

---

**Built with ❤️ for professional development**

[Website](https://stryvr.app) • [LinkedIn](https://linkedin.com/injoedormond) • [GitHub](https://github.com/upflow-ios) 