#!/bin/bash
set -e

# Logging functions
log_info() { echo -e "\e[34m[INFO]\e[0m $1"; }
log_success() { echo -e "\e[32m[SUCCESS]\e[0m $1"; }

# Display Art
if [ -f "./art.sh" ]; then
    bash ./art.sh
fi

log_info "=========================================="
log_info "   Automating Jemo Modern Setup"
log_info "=========================================="

# 1. System and Apps Installation
log_info "[Step 1/3] Installing applications..."
bash ./installer.sh

# 2. ZSH Setup
log_info "[Step 2/3] Setting up ZSH..."
bash ./zshsetup.sh

# 3. Dotfiles Setup
log_info "[Step 3/3] Stowing dotfiles..."
bash ./dotfiles.sh

log_success "=========================================="
log_success "   Setup completed successfully!"
log_success "=========================================="
log_info "Please restart your terminal to enjoy the modern setup."
