# StryVr Development Rules & Guidelines

## 🚨 **CRITICAL DEVELOPMENT RULES**

### **1. App Store Submission Priority**
- **NEVER** break App Store submission readiness
- **ALWAYS** test production builds before committing
- **MAINTAIN** environment configuration integrity
- **PRESERVE** debug code isolation with `#if DEBUG`

### **2. Liquid Glass UI Standards**
- **ALL** new views must use Liquid Glass styling
- **APPLY** `.liquidGlassCard()` to all cards and containers
- **USE** `.liquidGlassButton()` for interactive elements
- **MAINTAIN** glow effects and depth blur consistency
- **FOLLOW** established color palette in `ThemeManager`

### **3. Architecture Compliance**
- **MVVM** pattern is mandatory
- **ViewModels** handle all business logic
- **Views** are presentation-only
- **Services** manage external integrations
- **Models** define data structures

### **4. Code Quality Standards**
- **NO** unused imports or dead code
- **ALWAYS** handle errors gracefully
- **USE** proper logging with OSLog
- **MAINTAIN** comprehensive documentation
- **FOLLOW** Swift naming conventions

---

## 🎨 **Liquid Glass UI Implementation**

### **Required Styling**
```swift
// Cards
.liquidGlassCard()
.liquidGlassGlow(color: Theme.Colors.glowPrimary)

// Buttons
.liquidGlassButton()
.liquidGlassGlow(color: Theme.Colors.glowAccent)

// Backgrounds
.liquidGlassDepth()
```

### **Color Palette**
- **Primary**: `Theme.Colors.glassPrimary`
- **Secondary**: `Theme.Colors.glassSecondary`
- **Accent**: `Theme.Colors.glassAccent`
- **Glow Effects**: `Theme.Colors.glowPrimary`, `Theme.Colors.glowSecondary`

### **Animation Standards**
- **Spring animations** for interactions
- **Smooth transitions** between states
- **Responsive feedback** for user actions
- **Performance optimized** animations

---

## 🔧 **Development Workflow**

### **Before Committing**
1. **Test** on simulator and device
2. **Verify** Liquid Glass UI consistency
3. **Check** for build warnings/errors
4. **Ensure** debug code is properly gated
5. **Validate** App Store compliance

### **Code Review Checklist**
- [ ] Follows MVVM architecture
- [ ] Uses Liquid Glass UI styling
- [ ] Proper error handling
- [ ] No debug code in production
- [ ] Performance optimized
- [ ] Documentation updated

### **Testing Requirements**
- **Unit tests** for ViewModels
- **UI tests** for critical flows
- **Performance testing** for animations
- **Accessibility testing** for all views

---

## 🚫 **Forbidden Practices**

### **NEVER DO**
- ❌ Remove `#if DEBUG` guards
- ❌ Hardcode development URLs
- ❌ Skip error handling
- ❌ Use UIKit in new views
- ❌ Break existing Liquid Glass styling
- ❌ Commit without testing
- ❌ Ignore build warnings

### **AVOID**
- 🔶 Complex animations without performance testing
- 🔶 Deep nesting in SwiftUI views
- 🔶 Large ViewModels (split if needed)
- 🔶 Hardcoded strings (use localization)
- 🔶 Memory leaks in animations

---

## ✅ **Best Practices**

### **SwiftUI Views**
```swift
struct MyView: View {
    @StateObject private var viewModel = MyViewModel()
    
    var body: some View {
        VStack {
            // Content
        }
        .liquidGlassCard()
        .liquidGlassGlow()
    }
}
```

### **ViewModels**
```swift
@MainActor
final class MyViewModel: ObservableObject {
    @Published var state: ViewState = .loading
    
    func performAction() {
        // Business logic
    }
}
```

### **Services**
```swift
final class MyService {
    static let shared = MyService()
    
    func fetchData() async throws -> Data {
        // API calls
    }
}
```

---

## 🎯 **Performance Guidelines**

### **Animation Performance**
- **Use** `withAnimation(.spring())` for interactions
- **Avoid** complex animations in lists
- **Optimize** for 60fps performance
- **Test** on older devices

### **Memory Management**
- **Properly** dispose of subscriptions
- **Use** weak references in closures
- **Avoid** retain cycles
- **Monitor** memory usage

### **Build Performance**
- **Minimize** file dependencies
- **Use** proper import statements
- **Avoid** circular dependencies
- **Optimize** asset catalogs

---

## 📱 **App Store Compliance**

### **Required Checks**
- [ ] Production environment active
- [ ] Debug features properly gated
- [ ] App Transport Security configured
- [ ] All permissions declared
- [ ] No test data in production
- [ ] Proper error messages
- [ ] Accessibility support

### **Privacy Requirements**
- **Clear** privacy descriptions
- **Minimal** data collection
- **Secure** data handling
- **User** consent for features

---

## 🚀 **Deployment Checklist**

### **Pre-Submission**
- [ ] Production build successful
- [ ] All features tested
- [ ] Performance validated
- [ ] Documentation updated
- [ ] AGENTS.md current
- [ ] No debug code visible
- [ ] App Store metadata ready

### **Post-Launch**
- [ ] Monitor crash reports
- [ ] Track user feedback
- [ ] Plan feature updates
- [ ] Maintain code quality
- [ ] Update documentation

---

## 📞 **Support & Resources**

### **Documentation**
- **AGENTS.md**: System architecture
- **API_REFERENCE.md**: Integration guides
- **FIREBASE_SWIFT6_FIX.md**: Firebase setup

### **Development Tools**
- **DevDebugView**: Debug panel (DEBUG only)
- **ThemeManager**: Liquid Glass styling
- **AIGreetingManager**: AI features

### **Contact**
**Developer**: Joseph Dormond  
**App**: StryVr - Workplace Performance Platform  
**Status**: App Store submission preparation

---

*These rules ensure StryVr maintains its premium quality and App Store readiness.*
