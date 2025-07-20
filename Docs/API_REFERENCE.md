# StryVr API Reference

## 🔗 **Current API Integrations**

### **Firebase Authentication**
- **Service**: `AuthViewModel`
- **Location**: `StryVr/ViewModels/AuthViewModel.swift`
- **Features**:
  - Email/password authentication
  - Password reset functionality
  - Real-time auth state management
  - Session persistence

### **Firebase Crashlytics**
- **Service**: `CrashHandlingService`
- **Location**: `StryVr/Services/CrashHandlingService.swift`
- **Features**:
  - Error logging and crash reporting
  - Custom error context logging
  - Debug crash simulation (DEBUG only)

### **AIGreetingManager**
- **Service**: `AIGreetingManager`
- **Location**: `StryVr/Services/AIGreetingManager.swift`
- **Features**:
  - Time-based personalized greetings
  - Goal suggestions and motivation tips
  - Contextual updates based on user actions
  - Performance insights generation

---

## 🌐 **Environment Configuration**

### **Production Environment**
```swift
// AppConfig.swift
static let currentEnvironment: AppEnvironment = .production
static var apiBaseURL: String = "https://api.stryvr.app"
```

### **API Endpoints**
```swift
enum Endpoints {
    static let skills = "/api/skills"
    static let recommendations = "/api/recommendations"
    static let userProfile = "/api/user"
    static let achievements = "/api/achievements"
    static let challenges = "/api/challenges"
}
```

### **App Transport Security**
```xml
<!-- Info.plist -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>api.stryvr.app</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <false/>
            <key>NSExceptionMinimumTLSVersion</key>
            <string>TLSv1.2</string>
        </dict>
    </dict>
</dict>
```

---

## 🔧 **Service Architecture**

### **Service Pattern**
All services follow the singleton pattern for consistency:

```swift
final class MyService {
    static let shared = MyService()
    private init() {}
    
    func performAction() async throws -> Result {
        // Implementation
    }
}
```

### **Error Handling**
```swift
enum APIError: Error {
    case networkError
    case invalidResponse
    case authenticationFailed
    case serverError(String)
}
```

### **Logging Standards**
```swift
private let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr.app", 
    category: "ServiceName"
)
```

---

## 📱 **Current API Usage**

### **Authentication Flow**
1. **Sign In**: `AuthViewModel.signIn(email:password:)`
2. **Sign Up**: `AuthViewModel.createUser(email:password:)`
3. **Password Reset**: `AuthViewModel.resetPassword(email:)`
4. **Sign Out**: `AuthViewModel.signOut()`

### **AI Greeting Flow**
1. **Initialize**: `AIGreetingManager.shared.generateGreeting()`
2. **Update Context**: `AIGreetingManager.shared.updateContext(userAction:)`
3. **Get Insights**: `AIGreetingManager.shared.generateInsights()`

### **Crash Reporting**
1. **Log Error**: `CrashHandlingService.shared.log(error:context:)`
2. **Log Message**: `CrashHandlingService.shared.log(message:)`
3. **Simulate Crash**: `CrashHandlingService.shared.simulateCrash()` (DEBUG only)

---

## 🚀 **Future API Integrations**

### **Planned Services**
- **FoundationModel**: On-device AI for advanced personalization
- **ActivityKit**: Live Activities for goal tracking
- **VisionKit**: Contextual visual intelligence
- **CloudKit**: Data synchronization
- **Push Notifications**: User engagement

### **API Expansion**
- **User Analytics**: Performance tracking and insights
- **Social Features**: Team collaboration and sharing
- **Content Management**: Learning materials and resources
- **Gamification**: Achievements and leaderboards

---

## 🔒 **Security & Privacy**

### **Data Protection**
- **Encryption**: All data transmitted over HTTPS
- **Authentication**: Firebase Auth with secure tokens
- **Privacy**: Minimal data collection with user consent
- **Compliance**: GDPR and App Store privacy requirements

### **Permission Requirements**
```xml
<!-- Camera -->
<key>NSCameraUsageDescription</key>
<string>This allows StryVr to access your camera to record your resume video or scan a document.</string>

<!-- Photo Library -->
<key>NSPhotoLibraryUsageDescription</key>
<string>Used to upload your video resume or company documents from your photo library.</string>

<!-- Microphone -->
<key>NSMicrophoneUsageDescription</key>
<string>Allows StryVr to capture your audio for recording a voice pitch or feedback.</string>

<!-- Face ID -->
<key>NSFaceIDUsageDescription</key>
<string>Used for quick and secure login via Face ID.</string>
```

---

## 📊 **Performance Monitoring**

### **Metrics Tracked**
- **App Launch Time**: Performance optimization
- **Authentication Success Rate**: User experience
- **Crash Frequency**: Stability monitoring
- **Feature Usage**: User engagement
- **API Response Times**: Network performance

### **Analytics Integration**
- **Firebase Analytics**: User behavior tracking
- **Crashlytics**: Error monitoring
- **Performance Monitoring**: App performance metrics

---

## 🛠️ **Development & Testing**

### **API Testing**
- **DevDebugView**: Built-in API testing interface
- **Simulator Testing**: Local development testing
- **Device Testing**: Real-world performance validation
- **Production Testing**: Live environment verification

### **Mock Data**
```swift
// FeatureFlags.swift
static var enableMockData: Bool = false
```

### **Environment Switching**
```swift
// AppConfig.swift
static let currentEnvironment: AppEnvironment = .production
```

---

## 📞 **Support & Documentation**

### **Resources**
- **Firebase Console**: Authentication and crash monitoring
- **Apple Developer**: App Store Connect and certificates
- **Xcode**: Development and debugging tools

### **Contact**
**Developer**: Joseph Dormond  
**App**: StryVr - Workplace Performance Platform  
**Status**: App Store submission preparation

---

*This API reference reflects the current state of StryVr's integrations and services.*
