# 🤝 Contributing to StryVr

Thank you for your interest in contributing to StryVr! We're building the future of professional development, and your contributions are invaluable.

## 🎯 How to Contribute

### **Types of Contributions We Welcome**

- 🐛 **Bug Reports** - Help us squash bugs
- 💡 **Feature Requests** - Suggest new features
- 📝 **Documentation** - Improve our docs
- 🔧 **Code Contributions** - Submit pull requests
- 🎨 **UI/UX Improvements** - Enhance the user experience
- 🧪 **Testing** - Help us test features
- 🌍 **Localization** - Translate to other languages

## 🚀 Getting Started

### **1. Fork the Repository**
```bash
git clone https://github.com/yourusername/stryvr-ios.git
cd stryvr-ios
git remote add upstream https://github.com/joedormond/stryvr-ios.git
```

### **2. Set Up Development Environment**
```bash
# Install dependencies
cd backend && npm install

# Set up environment variables
cp .env.example .env
# Add your API keys to .env

# Open in Xcode
open SupportingFiles/StryVr.xcodeproj
```

### **3. Create a Feature Branch**
```bash
git checkout -b feature/amazing-feature
# or
git checkout -b fix/bug-description
```

## 📋 Development Guidelines

### **Swift/SwiftUI Standards**

- **Swift Version**: 6.1.2
- **iOS Target**: 18.0+
- **Architecture**: MVVM with SwiftUI
- **Logging**: Use Swift's `Logger` (not `os_log`)

### **Code Style**

```swift
// ✅ Good
struct UserProfileView: View {
    @StateObject private var viewModel = UserProfileViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome, \(viewModel.userName)")
                .font(.title)
                .foregroundColor(.primary)
        }
        .padding()
    }
}

// ❌ Avoid
struct UserProfileView: View {
    @State var viewModel = UserProfileViewModel() // Use @StateObject for ViewModels
    
    var body: some View {
        VStack {
            Text("Welcome, " + viewModel.userName) // Use string interpolation
        }
    }
}
```

### **File Organization**

```
StryVr/
├── Models/           # Data models
├── Views/            # SwiftUI views
├── ViewModels/       # MVVM view models
├── Services/         # Business logic
├── Utils/            # Utilities
└── Config/           # Configuration
```

### **Naming Conventions**

- **Views**: `FeatureNameView.swift`
- **ViewModels**: `FeatureNameViewModel.swift`
- **Models**: `FeatureName.swift`
- **Services**: `FeatureNameService.swift`

## 🔧 Development Workflow

### **1. Make Your Changes**
- Follow the coding standards above
- Add tests for new features
- Update documentation as needed

### **2. Test Your Changes**
```bash
# Run backend tests
cd backend && npm test

# Build iOS app in Xcode
# Test on simulator and device
# Verify all features work
```

### **3. Commit Your Changes**
```bash
git add .
git commit -m "feat: add user profile editing functionality

- Add EditProfileView with form validation
- Implement image picker for profile photos
- Add unit tests for UserProfileViewModel
- Update documentation

Closes #123"
```

### **4. Push and Create Pull Request**
```bash
git push origin feature/amazing-feature
```

## 📝 Pull Request Guidelines

### **Before Submitting**

- [ ] Code follows style guidelines
- [ ] Tests pass locally
- [ ] Documentation is updated
- [ ] No console warnings
- [ ] Accessibility features work
- [ ] Dark/Light mode tested

### **Pull Request Template**

```markdown
## 📋 Description
Brief description of changes

## 🎯 Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## 🧪 Testing
- [ ] Tested on iOS Simulator
- [ ] Tested on physical device
- [ ] Unit tests pass
- [ ] UI tests pass

## 📱 Screenshots
Add screenshots if UI changes

## 🔗 Related Issues
Closes #123
```

## 🐛 Bug Reports

### **Bug Report Template**

```markdown
## 🐛 Bug Description
Clear description of the bug

## 🔄 Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. Scroll down to '...'
4. See error

## ✅ Expected Behavior
What should happen

## ❌ Actual Behavior
What actually happens

## 📱 Environment
- iOS Version: 18.0
- Device: iPhone 15 Pro
- App Version: 1.0.0
- Xcode Version: 16.0

## 📸 Screenshots
Add screenshots if applicable

## 📋 Additional Context
Any other context about the problem
```

## 💡 Feature Requests

### **Feature Request Template**

```markdown
## 💡 Feature Description
Clear description of the feature

## 🎯 Problem Statement
What problem does this solve?

## 💭 Proposed Solution
How should this work?

## 🎨 UI/UX Considerations
Any design thoughts?

## 🔗 Related Features
Links to related features or discussions
```

## 🏆 Recognition

### **Contributor Levels**

- **🌱 Newcomer** - First contribution
- **🌿 Regular** - 5+ contributions
- **🌳 Core** - 20+ contributions
- **🏆 Maintainer** - Consistent high-quality contributions

### **Hall of Fame**
We'll feature top contributors in our README and documentation.

## 📞 Getting Help

### **Before Asking**

1. **Check Documentation** - [Docs/](Docs/)
2. **Search Issues** - [GitHub Issues](https://github.com/joedormond/stryvr-ios/issues)
3. **Read Discussions** - [GitHub Discussions](https://github.com/joedormond/stryvr-ios/discussions)

### **Contact Options**

- **📧 Email**: upflowapp@gmail.com
- **💼 LinkedIn**: [Joe Dormond](https://linkedin.com/in/joedormond)
- **🐙 GitHub**: [@joedormond](https://github.com/joedormond)

## 📄 Code of Conduct

### **Our Standards**

- **Respectful** - Be kind and respectful
- **Inclusive** - Welcome all contributors
- **Professional** - Maintain professional behavior
- **Constructive** - Provide constructive feedback

### **Unacceptable Behavior**

- Harassment or discrimination
- Trolling or insulting comments
- Publishing private information
- Any conduct inappropriate for a professional environment

## 📜 License

By contributing to StryVr, you agree that your contributions will be licensed under the MIT License.

---

**🚀 Thank you for helping build the future of professional development!**

[Back to README](README.md) • [Documentation](Docs/) • [Issues](https://github.com/joedormond/stryvr-ios/issues) 