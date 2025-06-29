# Raspberry Pi Setup Script

This repository contains an automated setup script for configuring a fresh Raspberry Pi installation with essential development tools and configurations.

## What This Script Installs

- **Tailscale** - VPN mesh network for secure remote access
- **neovim** - Modern text editor with basic configuration
- **oh-my-zsh** - Enhanced shell framework with themes and plugins
- **Rust** - Programming language and package manager
- **uv** - Fast Python package installer and resolver
- **Terminal color support** - Configured for Kitty terminal compatibility
- **Additional development tools** - git, curl, wget, htop, tree, tmux, build tools, Python

## Prerequisites

- Raspberry Pi running Raspberry Pi OS (headless or with GUI)
- Internet connection
- sudo privileges

## Usage

1. **Clone or download this repository to your Raspberry Pi:**
   ```bash
   git clone <your-repo-url>
   cd pi
   ```

2. **Make the script executable (if not already):**
   ```bash
   chmod +x install.sh
   ```

3. **Run the installation script:**
   ```bash
   ./install.sh
   ```

   The script will:
   - Update system packages
   - Install all requested tools
   - Configure zsh with oh-my-zsh
   - Set up terminal color support
   - Add useful aliases
   - Provide post-installation instructions

## Post-Installation Steps

After running the script:

1. **Restart your terminal or reload zsh configuration:**
   ```bash
   source ~/.zshrc
   ```

2. **Authenticate Tailscale:**
   ```bash
   sudo tailscale up
   ```
   Follow the authentication link to connect to your Tailnet.

3. **Restart your system** to ensure all changes take effect:
   ```bash
   sudo reboot
   ```

## Features

### Tailscale
- Installs the official Tailscale package
- Provides instructions for authentication
- Enables secure remote access to your Pi

### neovim
- Installs neovim with a basic configuration
- Includes syntax highlighting, line numbers, and other essential features
- Creates `~/.config/nvim/init.vim` with sensible defaults

### oh-my-zsh
- Installs zsh if not present
- Installs oh-my-zsh framework
- Sets zsh as the default shell

### Terminal Colors
- Adds `export TERM=xterm-256color` to `.zshrc`
- Ensures proper color support in Kitty terminal and other terminals

### Rust
- Installs Rust using rustup
- Includes cargo package manager
- Sources the Rust environment

### uv
- Installs uv using the official installer
- Fast Python package installer and resolver
- Alternative to pip with better dependency resolution
- Sources the uv environment

### Additional Tools
- **git** - Version control
- **curl/wget** - File downloading
- **htop** - Process monitoring
- **tree** - Directory tree visualization
- **tmux** - Terminal multiplexer
- **build-essential** - Compilation tools
- **python3-pip** - Python package manager
- **python3-venv** - Python virtual environments

### Useful Aliases
The script adds several helpful aliases to your `.zshrc`:
- `ll`, `la`, `l` - Enhanced ls commands
- `..`, `...`, `....` - Quick directory navigation
- `vim`, `vi` - Point to neovim
- Color-enabled versions of grep, diff, ip

## Customization

You can modify the script to:
- Add more packages to the `packages` array in `install_additional_packages()`
- Customize neovim configuration in `install_neovim()`
- Add more aliases in `setup_aliases()`
- Install additional oh-my-zsh plugins or themes

## Troubleshooting

### Script fails with permission errors
Ensure you have sudo privileges and the script is executable:
```bash
sudo chmod +x install.sh
```

### Tailscale authentication issues
If Tailscale doesn't connect properly:
```bash
sudo tailscale status
sudo tailscale up --reset
```

### zsh not working after installation
If zsh isn't working as expected:
```bash
chsh -s $(which zsh)
# Then log out and log back in
```

### Rust not found after installation
If Rust commands aren't available:
```bash
source ~/.cargo/env
# Or restart your terminal
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Feel free to submit issues and enhancement requests! 