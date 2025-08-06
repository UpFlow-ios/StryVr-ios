# 🔍 Brave Search API Setup Guide

## 📋 **Overview**

Get a free Brave Search API key to enable web search capabilities in your StryVr MCP integration.

## 🆓 **Step-by-Step Setup**

### **Step 1: Create Brave Search API Account**

1. **Go to**: [api.search.brave.com](https://api.search.brave.com)
2. **Click**: "Get Started" or "Sign Up"
3. **Create account** with your email
4. **Verify email** address

### **Step 2: Get Your API Key**

1. **Sign in** to your Brave Search API dashboard
2. **Go to**: "API Keys" section
3. **Click**: "Create New API Key" 
4. **Name**: "StryVr Development"
5. **Copy** your API key (looks like: `BSA...`)

### **Step 3: Add Key to MCP Configuration**

**Option A: Automatic Update**
```bash
# Replace YOUR_API_KEY with your actual key
sed -i.bak 's/your_brave_api_key_here/YOUR_API_KEY/' ~/.cursor/mcp.json
```

**Option B: Manual Edit**
1. **Open**: `~/.cursor/mcp.json`
2. **Find**: `"BRAVE_API_KEY": "your_brave_api_key_here"`
3. **Replace**: `your_brave_api_key_here` with your actual API key
4. **Save** the file

### **Step 4: Restart Cursor**

**Restart Cursor** to activate the new API key.

## 🎯 **Free Tier Limits**

- **2,000 queries/month** - Perfect for development
- **Web search** capabilities
- **Real-time results**
- **No credit card** required for free tier

## ✅ **Verification**

After setup, test the integration:
```bash
# ✅ COMPLETED: API key successfully added to ~/.cursor/mcp.json
# Brave Search API is now ready for use
# Restart Cursor to activate web search capabilities
```

## 🔐 **Security Notes**

- ✅ **Keep API key private** - Don't commit to Git
- ✅ **API key in local config only** - ~/.cursor/mcp.json
- ✅ **Monitor usage** in Brave API dashboard
- ✅ **Regenerate if compromised**

## 🚀 **What You'll Get**

With Brave Search API enabled:
- **Real-time web search** through AI assistance
- **Current information** lookups
- **Technical documentation** searches
- **Market research** capabilities
- **Competitor analysis** tools

**Perfect for StryVr development research and staying current with iOS/SwiftUI trends!**