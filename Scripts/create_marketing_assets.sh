#!/bin/bash

# StryVr Marketing Assets Creation Script
# Creates marketing materials and sets up social media presence

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎨 StryVr Marketing Assets Creator${NC}"
echo "======================================"

# Create marketing assets directory
mkdir -p Marketing/Assets
mkdir -p Marketing/Social
mkdir -p Marketing/Website

echo -e "${GREEN}✅ Created marketing directories${NC}"

# Create app store screenshots template
cat > Marketing/Assets/screenshots_guide.md << 'EOF'
# App Store Screenshots Guide

## Required Screenshots (6.7" iPhone 15 Pro Max - 1290x2796)
1. **Hero Shot** - Main app interface with skill tracking
2. **AI Insights** - Career recommendations screen
3. **Challenges** - Gamified learning interface
4. **Analytics** - Performance dashboard
5. **Video Call Integration** - Real-time assessment
6. **Achievements** - Badges and progress

## Screenshot Tips:
- Use real data, not placeholder text
- Show key features clearly
- Include compelling headlines
- Use consistent branding
- Test on different backgrounds

## Tools to Use:
- **Screenshot Tool**: Xcode Simulator
- **Design Tool**: Canva, Figma, or Sketch
- **Text Overlay**: Add feature descriptions
- **Background**: Clean, professional look
EOF

# Create social media content calendar
cat > Marketing/Social/content_calendar.md << 'EOF'
# StryVr Social Media Content Calendar

## Weekly Post Schedule

### Monday - Motivation Monday
- Career development tips
- Skill-building insights
- Professional growth stories

### Tuesday - Tech Tuesday
- AI in professional development
- App features and updates
- Behind-the-scenes development

### Wednesday - Work Wednesday
- Remote work best practices
- Team collaboration tips
- Productivity hacks

### Thursday - Thought Leadership
- Industry insights
- Expert interviews
- Future of work trends

### Friday - Feature Friday
- App demonstrations
- User success stories
- New feature announcements

### Weekend - Community
- User-generated content
- Industry news
- Fun facts about work

## Content Types:
- **Images**: Screenshots, infographics, quotes
- **Videos**: App demos, tutorials, testimonials
- **Text**: Tips, insights, announcements
- **Stories**: Behind-the-scenes, user stories
- **Polls**: Engagement questions
- **Live**: Q&A sessions, demos

## Hashtags:
- #StryVr #ProfessionalDevelopment #SkillTracking
- #AI #CareerGrowth #RemoteWork
- #HR #LearningAndDevelopment #Productivity
- #FutureOfWork #TechForGood #Innovation
EOF

# Create email templates
cat > Marketing/Assets/email_templates.md << 'EOF'
# Email Outreach Templates

## 1. HR Professional Outreach

**Subject:** Transform Your Team's Skill Development with AI

Hi [Name],

I hope this email finds you well! I'm reaching out because I noticed your work in [specific area] and thought you might be interested in a new AI-powered tool we've developed.

StryVr is an iOS app that provides real-time skill assessment during video calls, helping teams track professional development more effectively. We're seeing companies reduce training costs by 40% while improving employee engagement.

Would you be interested in a 15-minute demo to see how it could benefit your organization?

Best regards,
[Your Name]

---

## 2. Tech Influencer Outreach

**Subject:** AI-Powered Professional Development App - Exclusive Preview

Hi [Name],

I'm a huge fan of your content on [specific topic] and thought you might be interested in StryVr, an AI-powered professional development app we're launching.

What makes it unique is real-time skill assessment during video calls, providing instant feedback on communication, leadership, and technical skills. It's like having a career coach in every meeting.

Would you be interested in an exclusive preview and demo? I'd love to get your thoughts on the technology and potential use cases.

Thanks!
[Your Name]

---

## 3. Partnership Inquiry

**Subject:** Partnership Opportunity - AI Professional Development

Hi [Name],

I'm reaching out about a potential partnership opportunity. We've developed StryVr, an AI-powered professional development app that could complement [Company's] offerings perfectly.

Our app provides real-time skill assessment during video calls, which could enhance your existing [specific product/service] by adding measurable skill tracking.

Would you be open to a brief call to explore potential collaboration opportunities?

Best regards,
[Your Name]
EOF

# Create landing page content
cat > Marketing/Website/landing_page_content.md << 'EOF'
# StryVr Landing Page Content

## Hero Section
**Headline:** "AI-Powered Professional Development That Actually Works"

**Subheadline:** "Get real-time skill assessment during video calls. Track progress, earn achievements, and accelerate your career with AI-driven insights."

**CTA Button:** "Download for Free"

## Key Features Section
1. **Real-Time Assessment**
   - AI analyzes communication skills during calls
   - Instant feedback on leadership and technical abilities
   - Track improvement over time

2. **Career Path Guidance**
   - Personalized skill recommendations
   - AI-driven career path suggestions
   - Industry-specific insights

3. **Gamified Learning**
   - Complete challenges to earn badges
   - Compete with colleagues
   - Visual progress tracking

4. **Enterprise Analytics**
   - Team performance insights
   - Skill gap identification
   - ROI measurement tools

## Social Proof Section
- "StryVr helped our team improve communication skills by 60% in just 3 months"
- "The AI insights are incredibly accurate and actionable"
- "Finally, a tool that makes professional development measurable"

## Pricing Section
- **Free Tier**: Basic skill tracking, 5 assessments/month
- **Pro Tier**: $9.99/month - Unlimited assessments, detailed analytics
- **Enterprise**: Custom pricing - Team management, advanced reporting

## FAQ Section
Q: How does the AI assessment work?
A: Our AI analyzes video call interactions to assess communication, leadership, and technical skills in real-time.

Q: Is my data secure?
A: Yes, we use enterprise-grade encryption and never share personal data.

Q: Can I use it with any video platform?
A: Currently supports Zoom, Teams, and Google Meet with more platforms coming soon.
EOF

# Create brand guidelines
cat > Marketing/Assets/brand_guidelines.md << 'EOF'
# StryVr Brand Guidelines

## Brand Colors
- **Primary Blue**: #2563EB (Professional, trustworthy)
- **Secondary Green**: #10B981 (Growth, success)
- **Accent Orange**: #F59E0B (Energy, innovation)
- **Neutral Gray**: #6B7280 (Balance, sophistication)

## Typography
- **Headings**: SF Pro Display (iOS system font)
- **Body Text**: SF Pro Text (iOS system font)
- **Code**: SF Mono (for technical content)

## Logo Usage
- Minimum size: 24px height
- Clear space: 1x logo height on all sides
- Never stretch or distort
- Use on light or dark backgrounds

## Tone of Voice
- **Professional but approachable**
- **Data-driven but human**
- **Innovative but practical**
- **Confident but humble**

## Key Messages
- "AI-powered professional development"
- "Real-time skill assessment"
- "Measurable career growth"
- "Gamified learning experience"

## Visual Style
- Clean, modern interface
- Subtle animations
- Professional photography
- Consistent spacing and alignment
EOF

# Create social media setup checklist
cat > Marketing/Social/setup_checklist.md << 'EOF'
# Social Media Setup Checklist

## LinkedIn (Primary B2B Platform)
- [ ] Create StryVr company page
- [ ] Add company logo and banner
- [ ] Write compelling company description
- [ ] Post first content (company announcement)
- [ ] Join relevant groups:
  - [ ] HR Professionals Network
  - [ ] Learning & Development
  - [ ] Remote Work Community
  - [ ] AI in Business
  - [ ] Startup Founders

## Twitter/X (Tech Community)
- [ ] Create @StryVrApp account
- [ ] Add profile picture and header
- [ ] Write bio with key value proposition
- [ ] Follow relevant accounts:
  - [ ] HR influencers
  - [ ] Tech journalists
  - [ ] AI researchers
  - [ ] Startup accelerators
- [ ] Post first tweet

## Instagram (Visual Content)
- [ ] Create @stryvr.app account
- [ ] Design profile grid layout
- [ ] Create highlight stories
- [ ] Post app screenshots
- [ ] Share behind-the-scenes content

## TikTok (Viral Potential)
- [ ] Create @stryvr account
- [ ] Post quick app demos
- [ ] Share career tips
- [ ] Create trending content

## YouTube (Long-form Content)
- [ ] Create StryVr channel
- [ ] Upload app demo video
- [ ] Create tutorial series
- [ ] Share user testimonials

## Content Calendar Setup
- [ ] Set up content calendar
- [ ] Create posting schedule
- [ ] Prepare first week of content
- [ ] Set up automation tools
EOF

echo -e "${GREEN}✅ Created all marketing asset templates${NC}"

# Create quick action script
cat > Marketing/quick_actions.sh << 'EOF'
#!/bin/bash

# Quick Marketing Actions

echo "🚀 Quick Marketing Actions:"
echo "1. Take app screenshots"
echo "2. Record demo video"
echo "3. Set up social media accounts"
echo "4. Create landing page"
echo "5. Research contacts"

echo ""
echo "📱 To take screenshots:"
echo "   - Open Xcode Simulator"
echo "   - Run StryVr app"
echo "   - Use Cmd+S to screenshot"
echo "   - Save to Marketing/Assets/"

echo ""
echo "🎥 To record demo video:"
echo "   - Use QuickTime Screen Recording"
echo "   - Show key features"
echo "   - Keep under 2 minutes"
echo "   - Add captions"

echo ""
echo "🌐 To create landing page:"
echo "   - Use Carrd.co or Webflow"
echo "   - Include demo video"
echo "   - Add download links"
echo "   - Include contact form"
EOF

chmod +x Marketing/quick_actions.sh

echo -e "${GREEN}✅ Created quick actions script${NC}"

echo ""
echo -e "${BLUE}🎯 Marketing Assets Created Successfully!${NC}"
echo "=============================================="
echo ""
echo -e "${YELLOW}📁 Files Created:${NC}"
echo "   📄 Marketing/Assets/screenshots_guide.md"
echo "   📄 Marketing/Social/content_calendar.md"
echo "   📄 Marketing/Assets/email_templates.md"
echo "   📄 Marketing/Website/landing_page_content.md"
echo "   📄 Marketing/Assets/brand_guidelines.md"
echo "   📄 Marketing/Social/setup_checklist.md"
echo "   📄 Marketing/quick_actions.sh"
echo ""
echo -e "${GREEN}🚀 Next Steps:${NC}"
echo "1. Run: ./Marketing/quick_actions.sh"
echo "2. Take app screenshots in Xcode Simulator"
echo "3. Set up social media accounts"
echo "4. Create landing page"
echo "5. Start content creation"
echo ""
echo -e "${BLUE}💡 Pro Tip: Focus on one platform first (LinkedIn) before expanding${NC}" 