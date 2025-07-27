# 🚀 StryVr Single Build Management System

## Overview
This system ensures only **one build runs at a time** to prevent system slowdowns and resource conflicts.

## 📋 Available Commands

### 🔍 Check Build Status
```bash
./check-build-status.sh
```
- Shows if a build is currently running
- Displays PID and lock file location
- Indicates if lock file is stale

### 🔨 Start New Build
```bash
./build-stryvr.sh
```
- **Prevents multiple builds** from running simultaneously
- Creates a lock file to track the build process
- Automatically cleans up when build completes
- Logs output to `current-build.log`

### 🚫 Force Clear Lock (if needed)
```bash
rm /tmp/stryvr_build.lock
```
- Only use if build process crashed and left stale lock
- Check status first with `./check-build-status.sh`

## 🛡️ Safety Features

1. **Lock File Protection**: Prevents multiple builds
2. **Automatic Cleanup**: Removes lock file when build completes
3. **Process Validation**: Checks if PID is actually running
4. **Stale Lock Detection**: Identifies orphaned lock files

## 📊 Build Output

- **Log File**: `current-build.log`
- **Lock File**: `/tmp/stryvr_build.lock`
- **Exit Codes**: 0 = success, non-zero = failure

## 🎯 Best Practices

1. **Always check status first**: `./check-build-status.sh`
2. **Wait for current build to complete** before starting new one
3. **Use the provided scripts** instead of direct xcodebuild commands
4. **Monitor system resources** during builds

## 🚨 Troubleshooting

### Build Won't Start
```bash
./check-build-status.sh
# If stale lock found:
rm /tmp/stryvr_build.lock
```

### System Still Slow
```bash
ps aux | grep -E "(xcodebuild|swift)" | grep -v grep
# Kill any rogue processes if needed
```

---

**Remember**: Only one build at a time! This keeps your system fast and prevents resource conflicts. 🚀 