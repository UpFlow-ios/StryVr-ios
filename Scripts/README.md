# 🛠️ StryVr Scripts Directory

This directory contains all automation scripts for StryVr development, deployment, and maintenance.

## 🚀 Quick Start

```bash
# Start StryVr development environment
./Scripts/start_stryvr.sh

# Run daily maintenance with TODO integration
./Scripts/daily_maintenance.sh

# Safe build with lock protection
./Scripts/safe_build.sh
```

## 📋 Script Categories

### 🚀 Development & Build
- **`start_stryvr.sh`** - Complete development environment startup
- **`safe_build.sh`** - Safe Xcode build with lock protection
- **`fix_build_cache.sh`** - Fix Xcode build cache issues
- **`ios_build_optimizer.sh`** - Optimize iOS build performance
- **`xcode_build_manager.sh`** - Advanced Xcode build management

### 📊 Monitoring & Health
- **`daily_maintenance.sh`** - Daily project maintenance with TODO integration
- **`weekly_maintenance.sh`** - Weekly deep maintenance
- **`monitor_project.sh`** - Real-time project monitoring
- **`monitor_backend.sh`** - Backend monitoring
- **`monitor_build.sh`** - Build monitoring
- **`monitoring_dashboard.sh`** - Monitoring dashboard
- **`backend_health_agent.sh`** - Backend health monitoring
- **`automated_monitoring.sh`** - Automated monitoring system

### 🔐 Security & Compliance
- **`security_update.sh`** - Security updates and checks
- **`test_security.sh`** - Security testing
- **`rotate_firebase_keys.sh`** - Rotate Firebase keys
- **`update_api_keys.sh`** - Update API keys
- **`setup_env.sh`** - Environment setup

### 📱 App Store & Marketing
- **`app_store_workflow.sh`** - App Store submission workflow
- **`app_store_optimizer.sh`** - App Store optimization
- **`app_store_dashboard.sh`** - App Store dashboard
- **`generate_appstore_assets.sh`** - Generate App Store assets
- **`create_marketing_assets.sh`** - Create marketing materials
- **`marketing_automation_agent.sh`** - Marketing automation

### 🤖 AI & Automation
- **`ai_dashboard.sh`** - AI service dashboard
- **`ai_service_monitor.sh`** - AI service monitoring
- **`agent_dashboard.sh`** - Agent system dashboard
- **`test_ai_services.sh`** - Test AI services

### 📚 Documentation & Setup
- **`documentation_agent.sh`** - Documentation management
- **`validate_docs.sh`** - Validate documentation
- **`auto_document.sh`** - Auto-documentation
- **`professional_dev_setup.sh`** - Professional development setup
- **`setup_monitoring.sh`** - Setup monitoring

### 🏢 Enterprise & Analytics
- **`enterprise_analytics.sh`** - Enterprise analytics
- **`enterprise_dashboard.sh`** - Enterprise dashboard
- **`test_enterprise_features.sh`** - Test enterprise features
- **`test_consumer_features.sh`** - Test consumer features

### 🔧 Utilities
- **`cleanup_logs.sh`** - Clean up logs
- **`cleanup_project.sh`** - Clean up project
- **`backup_env.sh`** - Backup environment
- **`fix_backend.sh`** - Fix backend issues
- **`restart_backend.sh`** - Restart backend
- **`optimize_assets.sh`** - Optimize assets
- **`optimize_xcode_performance.sh`** - Optimize Xcode performance
- **`send_alert.sh`** - Send alerts
- **`auto_screenshot.sh`** - Auto-screenshot
- **`github_profile_setup.sh`** - GitHub profile setup
- **`deployment_agent.sh`** - Deployment agent

## 🎯 TODO Integration

The following scripts integrate with your `TODO_APP_STORE_READY.md` file:

- **`daily_maintenance.sh`** - Shows TODO progress and critical tasks
- **`weekly_maintenance.sh`** - Deep TODO analysis and task prioritization
- **`project_manager.sh`** - Master script for TODO-based development workflow

## 📊 Usage Examples

### Daily Development Workflow
```bash
# 1. Start development environment
./Scripts/start_stryvr.sh

# 2. Run daily maintenance (includes TODO check)
./Scripts/daily_maintenance.sh

# 3. Safe build
./Scripts/safe_build.sh
```

### App Store Preparation
```bash
# 1. Generate App Store assets
./Scripts/generate_appstore_assets.sh

# 2. Run App Store workflow
./Scripts/app_store_workflow.sh

# 3. Optimize for App Store
./Scripts/app_store_optimizer.sh
```

### Security & Compliance
```bash
# 1. Security check
./Scripts/test_security.sh

# 2. Update API keys
./Scripts/update_api_keys.sh

# 3. Rotate Firebase keys
./Scripts/rotate_firebase_keys.sh
```

## 🔧 Script Development

When adding new scripts:

1. **Use consistent naming**: `category_action.sh`
2. **Include proper error handling**: Use `set -e` and trap cleanup
3. **Add colored output**: Use the color variables defined in existing scripts
4. **Include logging**: Log to appropriate files
5. **Add TODO integration**: Check TODO status when relevant

## 📝 Logging

Scripts log to:
- `daily_maintenance_YYYY-MM-DD.log` - Daily maintenance logs
- `build-YYYYMMDD-HHMMSS.log` - Build logs
- `server.log` - Backend server logs

## 🚨 Troubleshooting

### Common Issues
- **Build lock**: Remove `/tmp/stryvr_safe_build.lock`
- **Backend issues**: Run `./Scripts/fix_backend.sh`
- **Cache problems**: Run `./Scripts/fix_build_cache.sh`

### Getting Help
```bash
# Show all available scripts
ls -la Scripts/

# Check script help (if available)
./Scripts/script_name.sh --help

# Run with verbose output
bash -x ./Scripts/script_name.sh
``` 