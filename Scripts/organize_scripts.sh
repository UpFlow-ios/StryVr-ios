#!/bin/bash

# 📁 Script Organization Helper
# Creates categorized symlinks for better organization

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}📁 Organizing StryVr Scripts${NC}"
echo "================================"

# Create category directories
mkdir -p Scripts/categories/{development,monitoring,security,appstore,ai,docs,enterprise,utils}

echo -e "${GREEN}✅ Created category directories${NC}"

# Development scripts
echo -e "${YELLOW}🔧 Development Scripts:${NC}"
ln -sf ../start_stryvr.sh Scripts/categories/development/
ln -sf ../safe_build.sh Scripts/categories/development/
ln -sf ../fix_build_cache.sh Scripts/categories/development/
ln -sf ../ios_build_optimizer.sh Scripts/categories/development/
ln -sf ../xcode_build_manager.sh Scripts/categories/development/

# Monitoring scripts
echo -e "${YELLOW}📊 Monitoring Scripts:${NC}"
ln -sf ../daily_maintenance.sh Scripts/categories/monitoring/
ln -sf ../weekly_maintenance.sh Scripts/categories/monitoring/
ln -sf ../monitor_project.sh Scripts/categories/monitoring/
ln -sf ../monitor_backend.sh Scripts/categories/monitoring/
ln -sf ../monitor_build.sh Scripts/categories/monitoring/
ln -sf ../monitoring_dashboard.sh Scripts/categories/monitoring/
ln -sf ../backend_health_agent.sh Scripts/categories/monitoring/
ln -sf ../automated_monitoring.sh Scripts/categories/monitoring/

# Security scripts
echo -e "${YELLOW}🔐 Security Scripts:${NC}"
ln -sf ../security_update.sh Scripts/categories/security/
ln -sf ../test_security.sh Scripts/categories/security/
ln -sf ../rotate_firebase_keys.sh Scripts/categories/security/
ln -sf ../update_api_keys.sh Scripts/categories/security/
ln -sf ../setup_env.sh Scripts/categories/security/

# App Store scripts
echo -e "${YELLOW}📱 App Store Scripts:${NC}"
ln -sf ../app_store_workflow.sh Scripts/categories/appstore/
ln -sf ../app_store_optimizer.sh Scripts/categories/appstore/
ln -sf ../app_store_dashboard.sh Scripts/categories/appstore/
ln -sf ../generate_appstore_assets.sh Scripts/categories/appstore/
ln -sf ../create_marketing_assets.sh Scripts/categories/appstore/
ln -sf ../marketing_automation_agent.sh Scripts/categories/appstore/

# AI scripts
echo -e "${YELLOW}🤖 AI Scripts:${NC}"
ln -sf ../ai_dashboard.sh Scripts/categories/ai/
ln -sf ../ai_service_monitor.sh Scripts/categories/ai/
ln -sf ../agent_dashboard.sh Scripts/categories/ai/
ln -sf ../test_ai_services.sh Scripts/categories/ai/

# Documentation scripts
echo -e "${YELLOW}📚 Documentation Scripts:${NC}"
ln -sf ../documentation_agent.sh Scripts/categories/docs/
ln -sf ../validate_docs.sh Scripts/categories/docs/
ln -sf ../auto_document.sh Scripts/categories/docs/
ln -sf ../professional_dev_setup.sh Scripts/categories/docs/
ln -sf ../setup_monitoring.sh Scripts/categories/docs/

# Enterprise scripts
echo -e "${YELLOW}🏢 Enterprise Scripts:${NC}"
ln -sf ../enterprise_analytics.sh Scripts/categories/enterprise/
ln -sf ../enterprise_dashboard.sh Scripts/categories/enterprise/
ln -sf ../test_enterprise_features.sh Scripts/categories/enterprise/
ln -sf ../test_consumer_features.sh Scripts/categories/enterprise/

# Utility scripts
echo -e "${YELLOW}🔧 Utility Scripts:${NC}"
ln -sf ../cleanup_logs.sh Scripts/categories/utils/
ln -sf ../cleanup_project.sh Scripts/categories/utils/
ln -sf ../backup_env.sh Scripts/categories/utils/
ln -sf ../fix_backend.sh Scripts/categories/utils/
ln -sf ../restart_backend.sh Scripts/categories/utils/
ln -sf ../optimize_assets.sh Scripts/categories/utils/
ln -sf ../optimize_xcode_performance.sh Scripts/categories/utils/
ln -sf ../send_alert.sh Scripts/categories/utils/
ln -sf ../auto_screenshot.sh Scripts/categories/utils/
ln -sf ../github_profile_setup.sh Scripts/categories/utils/
ln -sf ../deployment_agent.sh Scripts/categories/utils/

echo -e "${GREEN}✅ Scripts organized into categories!${NC}"
echo ""
echo -e "${BLUE}📁 Category Structure:${NC}"
echo "  Scripts/categories/development/  - Build & development"
echo "  Scripts/categories/monitoring/   - Health & monitoring"
echo "  Scripts/categories/security/     - Security & compliance"
echo "  Scripts/categories/appstore/     - App Store & marketing"
echo "  Scripts/categories/ai/           - AI & automation"
echo "  Scripts/categories/docs/         - Documentation"
echo "  Scripts/categories/enterprise/   - Enterprise features"
echo "  Scripts/categories/utils/        - Utilities"
