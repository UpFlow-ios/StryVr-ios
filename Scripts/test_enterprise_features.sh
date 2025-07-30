#!/bin/bash
# Test enterprise features and analytics

echo "🧪 Testing enterprise features..."

# Test payment system
echo "Testing payment system..."
if [ -f "StryVr/Services/PaymentService.swift" ]; then
    echo "✅ Payment Service available"
else
    echo "❌ Payment Service not found"
fi

# Test analytics services
echo "Testing analytics services..."
if [ -f "StryVr/Services/EmployeeProgressService.swift" ]; then
    echo "✅ Employee Progress Service available"
else
    echo "❌ Employee Progress Service not found"
fi

# Test reporting features
echo "Testing reporting features..."
if [ -f "StryVr/Services/ReportGeneration.swift" ]; then
    echo "✅ Report Generation Service available"
else
    echo "❌ Report Generation Service not found"
fi

# Test team health features
echo "Testing team health features..."
if [ -d "StryVr/Views/EmployeeInsights" ]; then
    echo "✅ Employee Insights views available"
else
    echo "❌ Employee Insights views not found"
fi
