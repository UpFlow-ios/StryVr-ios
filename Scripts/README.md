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
- **`setup_mcp_servers.sh`** - MCP (Model Context Protocol) server setup and management

## 🤖 MCP Server Management

The **`setup_mcp_servers.sh`** script manages Model Context Protocol (MCP) servers for enhanced AI assistant capabilities.

### Features
- **Automated Installation**: Installs all required MCP server packages
- **Configuration Management**: Generates and manages MCP configuration files
- **API Key Setup**: Guides through GitHub and Brave Search API setup
- **Validation**: Tests configuration validity
- **Backup**: Creates backups before making changes

### Available MCP Servers
- **Filesystem**: Direct file system access for code analysis
- **GitHub**: Repository management and issue tracking
- **Terminal**: Command execution in project context
- **Brave Search**: Research and development information
- **Client Configuration**: Cross-client MCP management

### Usage
```bash
# Interactive menu
./Scripts/setup_mcp_servers.sh

# Quick commands
./Scripts/setup_mcp_servers.sh install    # Install packages
./Scripts/setup_mcp_servers.sh configure  # Generate config
./Scripts/setup_mcp_servers.sh github     # Setup GitHub token
./Scripts/setup_mcp_servers.sh brave      # Setup Brave Search
./Scripts/setup_mcp_servers.sh test       # Test configuration
./Scripts/setup_mcp_servers.sh show       # Show current config
./Scripts/setup_mcp_servers.sh full       # Complete setup
```

### Integration
The daily maintenance script now includes MCP server status checking and will prompt you to run the setup script if needed.

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