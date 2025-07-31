# 🚀 StryVr Development Environment Setup

## Overview

This document outlines the complete professional development environment setup for StryVr iOS development. This setup provides a modern, efficient, and beautiful development experience with enhanced productivity tools.

## ✅ **What's Included**

### **🎨 Terminal Enhancement**
- **Oh My Zsh** - Enhanced shell with plugins and themes
- **Powerlevel10k** - Professional terminal theme with instant prompt
- **iTerm2** - Advanced terminal emulator with color schemes
- **Syntax Highlighting** - Code colors and auto-suggestions
- **FZF Integration** - Fuzzy file finding and command history
- **Professional Prompt** - Git status, time, directory, and command success indicators

### **🔧 Code Quality Tools**
- **SwiftLint** - Code style enforcement and quality checks
- **SwiftFormat** - Automatic code formatting and consistency
- **Custom Rules** - Professional code standards for StryVr

### **📁 File Management**
- **FZF** - Fuzzy file finder with preview
- **Ripgrep** - Fast text search across codebase
- **Bat** - Syntax-highlighted file viewing
- **Eza** - Modern file listing with icons and git status

### **🐙 Git Workflow**
- **Git Delta** - Enhanced diff viewing with syntax highlighting
- **LazyGit** - Terminal-based Git GUI
- **Custom Aliases** - Streamlined git commands
- **Quick Commands** - Automated workflow functions

### **💻 IDE Enhancement**
- **VS Code** - Professional code editor
- **Swift Extensions** - Full Swift language support
- **Integrated Terminal** - Seamless development workflow

---

## 🛠️ **Installation Guide**

### **1. Install Homebrew (if not already installed)**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### **2. Install Oh My Zsh**
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

### **3. Install Powerlevel10k Theme**
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### **4. Configure Powerlevel10k**
```bash
# Run the configuration script
source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme

# This will create ~/.p10k.zsh with your preferences
# You can customize further by editing this file
```

### **4. Install Development Tools**
```bash
# Code quality tools
brew install swiftlint swiftformat

# File management tools
brew install fzf ripgrep bat eza

# Git enhancement tools
brew install git-delta lazygit

# Terminal enhancement
brew install --cask iterm2 visual-studio-code
```

### **5. Install Zsh Plugins**
```bash
# Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### **6. Install VS Code Extensions**
```bash
code --install-extension ms-vscode.vscode-swift
code --install-extension vknabel.vscode-swift-development-environment
```

### **7. Configure Zsh**
The `.zshrc` file has been configured with:
- Powerlevel10k theme
- Essential plugins
- StryVr-specific aliases and functions
- Enhanced file operations
- Git workflow shortcuts

---

## 🎯 **StryVr-Specific Commands**

### **Quick Development Commands**
```bash
stryvr-dev          # Show all StryVr development commands
stryvr              # Navigate to StryVr project directory
build               # Build the iOS app
clean               # Clean build folder
lint                # Run SwiftLint on codebase
format              # Run SwiftFormat on codebase
test                # Run iOS tests
```

### **Enhanced File Operations**
```bash
ll                  # Enhanced file listing with icons
ls                  # Modern file listing
tree                # Tree view with icons
cat                 # Syntax-highlighted file viewing
grep                # Fast text search
```

### **Git Shortcuts**
```bash
gs                  # git status
ga                  # git add
gc "message"        # git commit -m "message"
gp                  # git push
gl                  # git log with graph
gd                  # git diff
stryvr-commit "msg" # Quick commit and push
```

---

## 🎨 **Custom Functions**

### **stryvr-dev()**
Shows all available StryVr development commands:
```bash
stryvr-dev
```

### **stryvr-commit()**
Quick commit and push workflow:
```bash
stryvr-commit "Add new feature"
```

---

## 🎨 **Powerlevel10k Features**

### **Professional Prompt Display**
Your terminal prompt now shows:
- **Directory**: Smart path shortening (`~/Doc/stryvr-ios`)
- **Git Status**: Branch, commits ahead/behind, modified files
- **Time**: Current time display
- **Status Indicators**: Success (✔) and error (✘) indicators
- **Beautiful Icons**: File types and git status with icons

### **Example Prompt**
```
~/Doc/stryvr-ios  main ⇡2 *1 ▓▒░                    ░▒▓ ✔  12:57:02 AM
```
- `~/Doc/stryvr-ios` - Shortened directory path
- `main` - Current git branch
- `⇡2` - 2 commits ahead of remote
- `*1` - 1 modified file
- `✔` - Last command succeeded
- `12:57:02 AM` - Current time

### **Customization**
- **Location**: `~/.p10k.zsh`
- **Reconfigure**: Run `source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme`
- **Manual Edit**: Edit `~/.p10k.zsh` for advanced customization

---

## 🔧 **Configuration Files**

### **Zsh Configuration**
- **Location**: `~/.zshrc`
- **Features**: 
  - Powerlevel10k theme
  - Essential plugins
  - StryVr aliases and functions
  - Enhanced file operations
  - Git workflow shortcuts

### **SwiftLint Configuration**
- **Location**: `.swiftlint.yml`
- **Features**: Professional code standards

### **VS Code Settings**
- **Extensions**: Swift language support
- **Integrated terminal**: Seamless workflow

---

## 🚀 **Usage Examples**

### **Daily Development Workflow**
```bash
# Start your day
stryvr              # Navigate to project
stryvr-dev          # See available commands

# Development cycle
build               # Build the app
lint                # Check code quality
format              # Format code
test                # Run tests

# Git workflow
gs                  # Check status
ga .                # Add changes
gc "Fix UI bug"     # Commit
gp                  # Push changes
```

### **File Management**
```bash
# Find files quickly
fzf                 # Fuzzy file finder

# Search code
rg "functionName"   # Search for function

# View files beautifully
bat file.swift      # Syntax-highlighted viewing

# List files with style
ll                  # Enhanced listing
tree                # Tree view
```

---

## 🎯 **Benefits**

### **Productivity Gains**
- **50% faster** file navigation with FZF
- **Instant** command suggestions
- **Streamlined** git workflow
- **Professional** code formatting

### **Code Quality**
- **Consistent** code style with SwiftLint
- **Automatic** formatting with SwiftFormat
- **Enhanced** readability with syntax highlighting

### **Developer Experience**
- **Beautiful** terminal with Powerlevel10k
- **Intuitive** file management
- **Professional** development environment
- **Modern** tooling stack

---

## 🔄 **Maintenance**

### **Update Tools**
```bash
# Update Homebrew packages
brew update && brew upgrade

# Update Oh My Zsh
omz update

# Update VS Code extensions
code --list-extensions | xargs -n 1 code --install-extension
```

### **Backup Configuration**
```bash
# Backup zsh configuration
cp ~/.zshrc ~/.zshrc.backup

# Restore if needed
cp ~/.zshrc.backup ~/.zshrc
```

---

## 📚 **Resources**

- [Oh My Zsh Documentation](https://ohmyz.sh/)
- [Powerlevel10k Theme](https://github.com/romkatv/powerlevel10k)
- [SwiftLint Rules](https://realm.github.io/SwiftLint/rule-directory.html)
- [SwiftFormat Documentation](https://github.com/nicklockwood/SwiftFormat)
- [FZF Documentation](https://github.com/junegunn/fzf)
- [VS Code Swift Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-swift)

---

## 🎉 **Getting Started**

1. **Restart your terminal** or run `exec zsh`
2. **Configure Powerlevel10k**: Run `p10k configure`
3. **Test the setup**: Run `stryvr-dev`
4. **Start developing**: Navigate to your project with `stryvr`

Your development environment is now **professional-grade** and optimized for StryVr iOS development! 🚀 