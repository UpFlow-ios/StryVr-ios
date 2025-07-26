🧠 Project Overview – StryVr
StryVr is an iOS app that helps entrepreneurs monitor employee performance and helps employees track their workplace growth, skills, and behavior. The app is being developed in Swift 6.1.2 with SwiftUI, Firebase, and many modern libraries (Charts, OSLog, Lottie, etc.). We are using modern logging with Swift's Logger, not os_log.

✅ Main Features
Skill Dashboards (Charts + Analysis)
AI Career Coach and Personalized Insights
Team Health Overview
Workplace Behavior Feedback
Gamified Learning Challenges
Secure Resume Builder + Report Generator
Enterprise Analytics for Founders
Push Notifications, In-App Paywall, and Conference Call Support

🛠️ Architecture Notes
SwiftUI + MVVM
Firebase for Auth, Storage, Firestore
HuggingFace AI Integration
Modular folder structure:
StryVr/Views/, StryVr/Models/, StryVr/Services/, StryVr/Utils/
Separate StryVrModule/ folder exists
Using .ultraThinMaterial for Liquid Glass UI

🧾 Code Rules for Cursor
Replace all os_log with Swift 6 Logger and string interpolation.
Always add proper import Charts, import OSLog, import FirebaseFirestore, import Lottie, etc. if those APIs are used.
Fix missing types or modules by checking they're added to the correct target.
Ensure all optionals are explicitly typed. No implicit nils.
Use Swift 6-compatible syntax everywhere.
Ensure Preview errors do not block production builds.
Follow clean code practices and proper Swift formatting.

🔧 Current Tasks
Fix all errors in the current build log
Modernize old syntax
Make the build pass on Swift 6.1.2
Help finalize archive and App Store–ready version

🚨 CRITICAL BUILD ISSUES TO FIX:
1. Lottie AnimationView Scope Issues:
   - Files using Lottie need: import Lottie
   - Custom LottieAnimationView wrapper exists in Utils/LottieAnimationManager.swift
   - Usage: LottieAnimationView(animationName: "confetti", loopMode: .playOnce)
   - Animation files should be in Assets.xcassets or app bundle

2. LearningReport Scope Issues:
   - LearningReport model exists in StryVr/Models/LearningReport.swift
   - Files using it need proper imports or be in same module
   - Check UserData.swift, BusinessAnalyticsDashboard.swift, EnterprisePerformanceDashboard.swift

3. Missing Import Patterns:
   - Charts usage → import Charts
   - Firebase usage → import FirebaseFirestore  
   - Lottie usage → import Lottie
   - Custom models in same module → no import needed

🎬 Lottie Animation Setup:
- Animation files (.json) go in Assets.xcassets or app bundle
- Use LottieAnimationView wrapper for SwiftUI compatibility
- Common animations: "confetti", "success", "loading"
- Loop modes: .playOnce, .loop, .autoReverse
- Example: LottieAnimationView(animationName: "confetti", loopMode: .playOnce) 