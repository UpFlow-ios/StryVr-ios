#!/bin/bash

# 🚀 StryVr MCP Server Setup Script
# This script helps manage MCP (Model Context Protocol) servers for StryVr development

set -e

echo "🔧 StryVr MCP Server Setup"
echo "=========================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MCP_CONFIG_PATH="$HOME/.cursor/mcp.json"
PROJECT_ROOT="/Users/joedormond/Documents/stryvr-ios"

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if Node.js and npm are installed
check_dependencies() {
    print_info "Checking dependencies..."
    
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js first."
        exit 1
    fi
    
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed. Please install npm first."
        exit 1
    fi
    
    print_status "Node.js and npm are available"
}

# Install MCP server packages
install_mcp_servers() {
    print_info "Installing MCP server packages..."
    
    # List of MCP servers to install
    servers=(
        "@modelcontextprotocol/server-filesystem"
        "@modelcontextprotocol/server-github"
        "@modelcontextprotocol/server-terminal"
        "@modelcontextprotocol/server-brave-search"
        "@landicefu/mcp-client-configuration-server"
    )
    
    for server in "${servers[@]}"; do
        print_info "Installing $server..."
        npm install -g "$server" || print_warning "Failed to install $server globally, trying with npx..."
    done
    
    print_status "MCP server packages installation completed"
}

# Create backup of current MCP config
backup_config() {
    if [ -f "$MCP_CONFIG_PATH" ]; then
        backup_path="$MCP_CONFIG_PATH.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$MCP_CONFIG_PATH" "$backup_path"
        print_status "Backup created: $backup_path"
    fi
}

# Generate MCP configuration
generate_config() {
    print_info "Generating MCP configuration..."
    
    cat > "$MCP_CONFIG_PATH" << 'EOF'
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "env": {
        "MCP_SERVER_FILESYSTEM_ROOT": "/Users/joedormond/Documents/stryvr-ios"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your_github_token_here"
      }
    },
    "terminal": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-terminal"],
      "env": {
        "MCP_SERVER_TERMINAL_CWD": "/Users/joedormond/Documents/stryvr-ios"
      }
    },
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "your_brave_api_key_here"
      }
    },
    "mcp-client-configuration": {
      "command": "npx",
      "args": ["-y", "@landicefu/mcp-client-configuration-server"],
      "env": {},
      "disabled": false,
      "alwaysAllow": []
    }
  }
}
EOF
    
    print_status "MCP configuration generated at $MCP_CONFIG_PATH"
}

# Setup GitHub token
setup_github_token() {
    print_info "GitHub Token Setup Instructions:"
    echo "1. Go to: https://github.com/settings/tokens"
    echo "2. Click 'Generate new token (classic)'"
    echo "3. Select scopes: repo, read:org, read:user"
    echo "4. Copy the generated token"
    echo "5. Replace 'your_github_token_here' in $MCP_CONFIG_PATH"
    echo ""
    read -p "Press Enter when you have your GitHub token ready..."
}

# Setup Brave Search API key
setup_brave_search() {
    print_info "Brave Search API Setup Instructions:"
    echo "1. Go to: https://api.search.brave.com/"
    echo "2. Sign up for a free API key"
    echo "3. Copy the API key"
    echo "4. Replace 'your_brave_api_key_here' in $MCP_CONFIG_PATH"
    echo ""
    read -p "Press Enter when you have your Brave API key ready..."
}

# Test MCP configuration
test_config() {
    print_info "Testing MCP configuration..."
    
    if [ -f "$MCP_CONFIG_PATH" ]; then
        if jq empty "$MCP_CONFIG_PATH" 2>/dev/null; then
            print_status "MCP configuration is valid JSON"
        else
            print_error "MCP configuration contains invalid JSON"
            return 1
        fi
    else
        print_error "MCP configuration file not found"
        return 1
    fi
}

# Show current configuration
show_config() {
    print_info "Current MCP Configuration:"
    if [ -f "$MCP_CONFIG_PATH" ]; then
        cat "$MCP_CONFIG_PATH" | jq '.' 2>/dev/null || cat "$MCP_CONFIG_PATH"
    else
        print_warning "No MCP configuration file found"
    fi
}

# Main menu
show_menu() {
    echo ""
    echo "🔧 MCP Server Management Menu"
    echo "============================="
    echo "1. Install MCP server packages"
    echo "2. Generate MCP configuration"
    echo "3. Setup GitHub token"
    echo "4. Setup Brave Search API"
    echo "5. Test configuration"
    echo "6. Show current configuration"
    echo "7. Full setup (install + configure)"
    echo "8. Exit"
    echo ""
}

# Main function
main() {
    case "${1:-}" in
        "install")
            check_dependencies
            install_mcp_servers
            ;;
        "configure")
            backup_config
            generate_config
            ;;
        "github")
            setup_github_token
            ;;
        "brave")
            setup_brave_search
            ;;
        "test")
            test_config
            ;;
        "show")
            show_config
            ;;
        "full")
            check_dependencies
            install_mcp_servers
            backup_config
            generate_config
            setup_github_token
            setup_brave_search
            test_config
            print_status "Full MCP setup completed!"
            print_info "Remember to restart Cursor to activate the new configuration"
            ;;
        *)
            while true; do
                show_menu
                read -p "Select an option (1-8): " choice
                case $choice in
                    1) check_dependencies; install_mcp_servers ;;
                    2) backup_config; generate_config ;;
                    3) setup_github_token ;;
                    4) setup_brave_search ;;
                    5) test_config ;;
                    6) show_config ;;
                    7) main "full" ;;
                    8) print_info "Exiting..."; exit 0 ;;
                    *) print_error "Invalid option. Please try again." ;;
                esac
                echo ""
                read -p "Press Enter to continue..."
            done
            ;;
    esac
}

# Run main function
main "$@" 