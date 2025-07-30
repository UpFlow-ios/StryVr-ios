#!/bin/bash
# Enterprise Analytics Dashboard

echo "📊 Enterprise Analytics Dashboard"
echo "================================"

# Enterprise Services Status
echo "🏢 Enterprise Services:"
[ -f "StryVr/Services/EmployeeProgressService.swift" ] && echo "  ✅ Employee Progress Service" || echo "  ❌ Employee Progress Service"
[ -f "StryVr/Services/BehaviorFeedbackService.swift" ] && echo "  ✅ Behavior Feedback Service" || echo "  ❌ Behavior Feedback Service"
[ -f "StryVr/Services/SkillMatrixService.swift" ] && echo "  ✅ Skill Matrix Service" || echo "  ❌ Skill Matrix Service"
[ -f "StryVr/Services/ReportGeneration.swift" ] && echo "  ✅ Report Generation Service" || echo "  ❌ Report Generation Service"

# Payment System Status
echo ""
echo "💳 Payment System:"
[ -f "StryVr/Services/PaymentService.swift" ] && echo "  ✅ Payment Service" || echo "  ❌ Payment Service"
[ -f "StryVr/Views/PaywallView.swift" ] && echo "  ✅ Paywall View" || echo "  ❌ Paywall View"

# Analytics Features
echo ""
echo "📈 Analytics Features:"
[ -d "StryVr/Views/EmployeeInsights" ] && echo "  ✅ Employee Insights" || echo "  ❌ Employee Insights"
[ -d "StryVr/Views/Reports" ] && echo "  ✅ Reports" || echo "  ❌ Reports"
[ -d "StryVr/Views/Analytics" ] && echo "  ✅ Analytics" || echo "  ❌ Analytics"

# Security Features
echo ""
echo "🔒 Security Features:"
[ -f "StryVr/Services/SecureStorageService.swift" ] && echo "  ✅ Secure Storage Service" || echo "  ❌ Secure Storage Service"
[ -d "StryVr/Views/Security" ] && echo "  ✅ Security Views" || echo "  ❌ Security Views"

# Performance Metrics
echo ""
echo "📊 Performance Metrics:"
echo "  Enterprise Files: $(find StryVr -name "*.swift" -exec grep -l -i "enterprise\|team\|employee" {} \; 2>/dev/null | wc -l)"
echo "  Analytics Patterns: $(grep -r -i "analytics\|metrics\|report" StryVr/ 2>/dev/null | wc -l)"
echo "  Security Patterns: $(grep -r -i "security\|encryption\|keychain" StryVr/ 2>/dev/null | wc -l)"
