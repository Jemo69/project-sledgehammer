#!/bin/bash
set -e

# Logging functions
log_info() { echo -e "\e[34m[INFO]\e[0m $1"; }
log_success() { echo -e "\e[32m[SUCCESS]\e[0m $1"; }
log_error() { echo -e "\e[31m[ERROR]\e[0m $1"; }

DOT_FILES_REPO="https://github.com/Jemo69/dot-file.git"
DOT_FILES_DIR="$HOME/dot-file"

log_info "Setting up dotfiles..."

# Ensure stow and git are installed
for pkg in stow git; do
    if ! command -v $pkg &> /dev/null; then
        log_info "Installing $pkg..."
        sudo apt install -y $pkg
    fi
done

# Clone or pull dotfiles
if [ -d "$DOT_FILES_DIR" ]; then
    log_info "Updating existing dotfiles repo..."
    (cd "$DOT_FILES_DIR" && git pull origin main)
else
    log_info "Cloning dotfiles repo..."
    git clone "$DOT_FILES_REPO" "$DOT_FILES_DIR"
fi

# Backup existing config to avoid conflicts with stow
log_info "Backing up existing configurations..."
configs=(.zshrc .bashrc .tmux.conf)
for cfg in "${configs[@]}"; do
    if [ -f "$HOME/$cfg" ] && [ ! -L "$HOME/$cfg" ]; then
        log_info "Backing up $HOME/$cfg to $HOME/$cfg.bak"
        mv "$HOME/$cfg" "$HOME/$cfg.bak"
    fi
done

# Stow dotfiles
log_info "Stowing dotfiles..."
cd "$DOT_FILES_DIR"

# Run stow for each top-level directory (assuming typical stow structure)
# If the repo has a flat structure, 'stow .' might be enough.
# Let's try to be smart about it.
for dir in */; do
    dir=${dir%/} # Remove trailing slash
    if [ -d "$dir" ] && [ "$dir" != ".git" ]; then
        log_info "Stowing $dir..."
        stow -v "$dir" 2>&1 | grep -v "already stowed" || true
    fi
done

# Fallback to stowing everything if no subdirectories were found (except .git)
if [ "$(ls -d */ 2>/dev/null | grep -v ".git" | wc -l)" -eq 0 ]; then
    log_info "No subdirectories found, stowing root..."
    stow -v . 2>&1 | grep -v "already stowed" || true
fi

log_success "Dotfiles stowed successfully."
