#!/bin/bash

# StryVr Demo Account Setup for App Store Review
# Creates reviewer account with sample data

set -e

echo "🎯 Setting up StryVr Demo Account for App Store Review"
echo ""

# Demo Account Credentials
DEMO_EMAIL="reviewer@stryvr.app"
DEMO_PASSWORD="StryVrReviewer2025!"
DEMO_NAME="App Store Reviewer"
DEMO_COMPANY="Apple Inc."
DEMO_TITLE="App Review Specialist"

echo "📋 Demo Account Details:"
echo "Email: $DEMO_EMAIL"
echo "Password: $DEMO_PASSWORD"
echo "Name: $DEMO_NAME"
echo "Company: $DEMO_COMPANY"
echo "Title: $DEMO_TITLE"
echo ""

# Create demo data JSON
create_demo_data() {
    cat > demo_account_data.json << EOF
{
  "account": {
    "email": "$DEMO_EMAIL",
    "name": "$DEMO_NAME",
    "company": "$DEMO_COMPANY",
    "jobTitle": "$DEMO_TITLE",
    "profileImage": "https://api.stryvr.app/demo/reviewer-avatar.jpg",
    "verified": true,
    "premiumMember": true,
    "joinDate": "2024-01-15"
  },
  "professionalProfile": {
    "summary": "Experienced App Review Specialist with 8+ years in mobile app evaluation and quality assurance. Expert in iOS development standards and App Store guidelines compliance.",
    "employmentHistory": [
      {
        "company": "Apple Inc.",
        "position": "Senior App Review Specialist",
        "startDate": "2020-01-01",
        "endDate": null,
        "verified": true,
        "responsibilities": [
          "Review iOS applications for App Store compliance",
          "Evaluate user experience and interface design",
          "Ensure privacy and security standards"
        ]
      },
      {
        "company": "Tech Innovations Corp",
        "position": "Mobile QA Engineer",
        "startDate": "2016-06-01",
        "endDate": "2019-12-31",
        "verified": true,
        "responsibilities": [
          "Mobile application testing and validation",
          "Automated testing framework development",
          "Cross-platform compatibility testing"
        ]
      }
    ],
    "skills": [
      {
        "name": "iOS Development",
        "level": 95,
        "verified": true,
        "category": "Technical"
      },
      {
        "name": "App Store Guidelines",
        "level": 98,
        "verified": true,
        "category": "Technical"
      },
      {
        "name": "Quality Assurance",
        "level": 92,
        "verified": true,
        "category": "Technical"
      },
      {
        "name": "Team Leadership",
        "level": 88,
        "verified": true,
        "category": "Leadership"
      },
      {
        "name": "Communication",
        "level": 90,
        "verified": true,
        "category": "Soft Skills"
      }
    ],
    "achievements": [
      {
        "title": "App Store Excellence Award",
        "description": "Recognized for outstanding app review quality",
        "date": "2023-12-01",
        "verified": true
      },
      {
        "title": "iOS Certification",
        "description": "Advanced iOS Development Certification",
        "date": "2023-06-15",
        "verified": true
      }
    ]
  },
  "aiInsights": [
    {
      "type": "skill_recommendation",
      "title": "Enhance SwiftUI Expertise",
      "description": "Consider deepening SwiftUI knowledge to stay current with latest iOS development trends",
      "priority": "medium",
      "estimatedTime": "2 weeks"
    },
    {
      "type": "career_opportunity",
      "title": "Senior Technical Lead Role",
      "description": "Your experience qualifies you for senior technical leadership positions",
      "priority": "high",
      "confidence": 0.89
    },
    {
      "type": "networking",
      "title": "iOS Developer Conferences",
      "description": "Attending WWDC and similar events could expand your professional network",
      "priority": "low"
    }
  ],
  "analytics": {
    "skillProgress": {
      "lastMonth": "+3.2%",
      "thisQuarter": "+12.5%",
      "yearOverYear": "+28.7%"
    },
    "performanceMetrics": {
      "productivityScore": 94,
      "collaborationScore": 88,
      "innovationScore": 91,
      "leadershipScore": 85
    },
    "teamMetrics": {
      "teamSize": 12,
      "teamHealthScore": 92,
      "avgTeamPerformance": 89,
      "teamGrowthRate": "+15.3%"
    }
  },
  "subscription": {
    "tier": "Professional",
    "status": "active",
    "renewalDate": "2025-02-15",
    "features": [
      "Unlimited AI Insights",
      "Advanced Team Analytics",
      "Priority Support",
      "Export Capabilities",
      "Custom Reporting"
    ]
  }
}
EOF
}

# Create instructions for App Review team
create_review_instructions() {
    cat > APP_REVIEW_INSTRUCTIONS.md << EOF
# 🍎 App Store Review Instructions for StryVr

## 📱 Demo Account Access

**Login Credentials:**
- **Email**: $DEMO_EMAIL
- **Password**: $DEMO_PASSWORD

## 🎯 Key Features to Test

### 1. **Home Dashboard**
- View personalized AI insights
- Check skill progress metrics
- Navigate through team health overview
- Test quick action buttons

### 2. **AI Insights View**
- Explore career recommendations
- View skill development suggestions
- Test priority filtering
- Check confidence scores

### 3. **Professional Resume/Reports**
- View verified employment history
- Check skill verification badges
- Test PDF export functionality
- Review privacy controls

### 4. **Analytics Dashboard**
- Explore team performance metrics
- View individual productivity scores
- Test date range filtering
- Check data visualization

### 5. **Subscription Management**
- View current Professional plan
- Test feature access (all premium features enabled)
- Check billing information (test mode)
- Review subscription benefits

## 🔧 Technical Testing

### **Permissions Testing**
- **Camera**: Test professional video resume feature
- **Face ID**: Test biometric authentication
- **Notifications**: Test career insight alerts
- **Background**: Test analytics processing

### **Performance Testing**
- App launch time (target: <3 seconds)
- Navigation smoothness
- Memory usage efficiency
- Battery optimization

### **Accessibility Testing**
- VoiceOver compatibility
- Dynamic Type support
- High contrast mode
- Voice Control compatibility

## 💼 Enterprise Features

The demo account includes simulated team data to showcase:
- Team health dashboards
- Performance analytics
- Behavior feedback systems
- HR verification workflows

## 🎨 UI/UX Evaluation

### **iOS 18 Liquid Glass Design**
- Premium glass card effects
- Smooth animations and transitions
- Professional color scheme
- Native iOS design patterns

### **User Experience**
- Intuitive navigation flow
- Clear information hierarchy
- Responsive design elements
- Professional polish

## 🔐 Privacy & Security

### **Data Protection**
- All demo data is anonymized
- No real personal information
- Secure authentication flow
- Privacy controls functional

### **App Transport Security**
- HTTPS-only communications
- TLS 1.2+ enforcement
- Certificate pinning
- Secure data transmission

## ❓ Common Questions

**Q: Why does the app request camera access?**
A: For professional video resume creation and document scanning

**Q: What is the "HR Verification" feature?**
A: Allows employers to verify employee skills and achievements

**Q: Is this a social networking app?**
A: No, it's a professional development platform focused on career growth

**Q: What data does the app collect?**
A: Professional development data, usage analytics, and career metrics (see Privacy Policy)

## 📞 Contact Information

For any questions during review:
- **Email**: josephdormond6550@hotmail.com
- **Response Time**: Within 24 hours
- **Emergency Contact**: Available via email

## 🚀 Post-Review

After approval, the production app will include:
- Real user onboarding flow
- Live AI recommendation engine
- Enterprise customer integrations
- Full subscription billing

---

**Thank you for reviewing StryVr! We're excited to bring this professional development platform to the App Store.**
EOF
}

echo "📝 Creating demo account data..."
create_demo_data
echo "✅ Demo data created: demo_account_data.json"

echo ""
echo "📋 Creating review instructions..."
create_review_instructions
echo "✅ Review instructions created: APP_REVIEW_INSTRUCTIONS.md"

echo ""
echo "🔐 Demo Account Summary:"
echo "┌─────────────────────────────────────────┐"
echo "│  Email: $DEMO_EMAIL          │"
echo "│  Password: $DEMO_PASSWORD        │" 
echo "│  Status: Premium Professional Account   │"
echo "│  Features: All premium features enabled │"
echo "└─────────────────────────────────────────┘"

echo ""
echo "📤 Next Steps:"
echo "1. Upload demo_account_data.json to your backend"
echo "2. Configure demo account in your authentication system"
echo "3. Add APP_REVIEW_INSTRUCTIONS.md to App Store Connect"
echo "4. Test demo account functionality before submission"

echo ""
echo "✅ Demo account setup complete!"
