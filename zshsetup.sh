#!/bin/bash
set -e

# Logging functions
log_info() { echo -e "\e[34m[INFO]\e[0m $1"; }
log_success() { echo -e "\e[32m[SUCCESS]\e[0m $1"; }

log_info "Setting up ZSH and Oh My Zsh..."

# Install zsh
if ! command -v zsh &> /dev/null; then
    log_info "Installing ZSH..."
    sudo apt install -y zsh
else
    log_info "ZSH is already installed."
fi

# Install Oh My Zsh (non-interactive)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Installing Oh My Zsh..."
    CHSH=no RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    log_success "Oh My Zsh installed."
else
    log_info "Oh My Zsh is already installed."
fi

log_success "ZSH setup complete."
