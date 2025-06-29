#!/bin/bash

# Raspberry Pi Initial Setup Script
# This script installs and configures essential tools for a headless Raspberry Pi setup

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to update system packages
update_system() {
    print_status "Updating system packages..."
    sudo apt update && sudo apt upgrade -y
    print_success "System packages updated"
}

# Function to install Tailscale
install_tailscale() {
    print_status "Installing Tailscale..."
    
    if command_exists tailscale; then
        print_warning "Tailscale is already installed"
        return
    fi
    
    # Add Tailscale repository
    curl -fsSL https://pkgs.tailscale.com/stable/raspbian/bullseye.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
    curl -fsSL https://pkgs.tailscale.com/stable/raspbian/bullseye.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
    
    # Update package list and install Tailscale
    sudo apt update
    sudo apt install tailscale -y
    
    print_success "Tailscale installed successfully"
    print_warning "Run 'sudo tailscale up' to authenticate and connect to your Tailnet"
}

# Function to install neovim
install_neovim() {
    print_status "Installing neovim..."
    
    if command_exists nvim; then
        print_warning "neovim is already installed"
        return
    fi
    
    # Install neovim from package manager
    sudo apt install neovim -y
    
    # Create basic neovim configuration
    mkdir -p ~/.config/nvim
    cat > ~/.config/nvim/init.vim << 'EOF'
" Basic neovim configuration
set number
set relativenumber
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
set mouse=a
set clipboard=unnamedplus
set termguicolors
syntax on
EOF
    
    print_success "neovim installed and configured"
}

# Function to install oh-my-zsh
install_ohmyzsh() {
    print_status "Installing oh-my-zsh..."
    
    if [ -d ~/.oh-my-zsh ]; then
        print_warning "oh-my-zsh is already installed"
        return
    fi
    
    # Install zsh if not already installed
    if ! command_exists zsh; then
        sudo apt install zsh -y
    fi
    
    # Install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    print_success "oh-my-zsh installed"
}

# Function to configure zsh
configure_zsh() {
    print_status "Configuring zsh..."
    
    # Add terminal color configuration to .zshrc
    if ! grep -q "export TERM=xterm-256color" ~/.zshrc; then
        echo "" >> ~/.zshrc
        echo "# Terminal color configuration for Kitty terminal" >> ~/.zshrc
        echo "export TERM=xterm-256color" >> ~/.zshrc
        print_success "Added TERM=xterm-256color to .zshrc"
    else
        print_warning "TERM=xterm-256color already configured in .zshrc"
    fi
}

# Function to install Rust
install_rust() {
    print_status "Installing Rust..."
    
    if command_exists rustc; then
        print_warning "Rust is already installed"
        return
    fi
    
    # Install Rust using rustup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    
    # Source rust environment for current session
    source ~/.cargo/env
    
    print_success "Rust installed successfully"
    print_status "Rust version: $(rustc --version)"
}

# Function to install uv
install_uv() {
    print_status "Installing uv..."
    
    if command_exists uv; then
        print_warning "uv is already installed"
        return
    fi
    
    # Install uv using the official installer
    curl -LsSf https://astral.sh/uv/install.sh | sh
    
    # Source uv environment for current session
    source ~/.cargo/env
    
    print_success "uv installed successfully"
    print_status "uv version: $(uv --version)"
}

# Function to install additional useful packages
install_additional_packages() {
    print_status "Installing additional useful packages..."
    
    # List of useful packages for development
    packages=(
        "git"
        "curl"
        "wget"
        "htop"
        "tree"
        "tmux"
        "build-essential"
        "python3-pip"
        "python3-venv"
    )
    
    for package in "${packages[@]}"; do
        if ! dpkg -l | grep -q "^ii  $package "; then
            print_status "Installing $package..."
            sudo apt install -y "$package"
        else
            print_warning "$package is already installed"
        fi
    done
    
    print_success "Additional packages installed"
}

# Function to create useful aliases
setup_aliases() {
    print_status "Setting up useful aliases..."
    
    # Add useful aliases to .zshrc
    cat >> ~/.zshrc << 'EOF'

# Useful aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias vim='nvim'
alias vi='nvim'
EOF
    
    print_success "Useful aliases added to .zshrc"
}

# Function to display final instructions
show_final_instructions() {
    echo ""
    echo "=========================================="
    echo "🎉 Installation Complete!"
    echo "=========================================="
    echo ""
    echo "Next steps:"
    echo "1. Restart your terminal or run: source ~/.zshrc"
    echo "2. Authenticate Tailscale: sudo tailscale up"
    echo "3. Restart your system to ensure all changes take effect"
    echo ""
    echo "Installed tools:"
    echo "✅ Tailscale"
    echo "✅ neovim"
    echo "✅ oh-my-zsh"
    echo "✅ Rust"
    echo "✅ uv"
    echo "✅ Terminal color support for Kitty"
    echo ""
    echo "Your Raspberry Pi is now ready for development!"
    echo "=========================================="
}

# Main installation function
main() {
    echo "🚀 Starting Raspberry Pi Setup Script"
    echo "=========================================="
    echo ""
    
    # Check if running on Raspberry Pi
    if ! grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null; then
        print_warning "This script is designed for Raspberry Pi. Continue anyway? (y/N)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_error "Installation cancelled"
            exit 1
        fi
    fi
    
    # Run installation steps
    update_system
    install_tailscale
    install_neovim
    install_ohmyzsh
    configure_zsh
    install_rust
    install_uv
    install_additional_packages
    setup_aliases
    
    show_final_instructions
}

# Run main function
main "$@"
