#!/bin/bash
set -e

# Logging functions for a modern feel
log_info() { echo -e "\e[34m[INFO]\e[0m $1"; }
log_success() { echo -e "\e[32m[SUCCESS]\e[0m $1"; }
log_error() { echo -e "\e[31m[ERROR]\e[0m $1"; }

log_info "Starting modernization installer..."

# ==========================================
# LEVEL 1: APT (System Packages)
# ==========================================
log_info "Updating system packages..."
sudo apt update && sudo apt upgrade -y

log_info "Installing core prerequisites..."
sudo apt install -y gpg curl wget git unzip

# Install Eza (Special APT repo)
if ! command -v eza &> /dev/null; then
    log_info "Installing eza..."
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
fi

apt_packages=(
    fzf stow zoxide tmux nodejs npm neovim golang valkey-server 
    lazygit ripgrep jq ffmpeg 7zip poppler-utils fd-find imagemagick gh
)

log_info "Installing APT packages..."
for pkg in "${apt_packages[@]}"; do
    if ! dpkg -l | grep -q "^ii  $pkg " &> /dev/null; then
        sudo apt install -y "$pkg"
    fi
done

# ==========================================
# LEVEL 2: CURL (Installers & Binaries)
# ==========================================
log_info "Running CURL-based installers..."

# Rust
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# uv
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Bun
if ! command -v bun &> /dev/null; then
    curl -fsSL https://bun.sh/install | bash
fi

# Deno
if ! command -v deno &> /dev/null; then
    curl -fsSL https://deno.land/install.sh | sh
fi

# Atuin
if ! command -v atuin &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi

# NVM
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
fi

# pnpm
if ! command -v pnpm &> /dev/null; then
    curl -fsSL https://get.pnpm.io/install.sh | sh -
fi

# Opencode
if ! command -v opencode &> /dev/null; then
    curl -fsSL https://opencode.ai/install | bash
fi

# jj (Jujutsu)
if ! command -v jj &> /dev/null; then
    log_info "Installing jj (Jujutsu)..."
    CURR_DIR=$(pwd)
    cd /tmp
    curl -LO https://github.com/jj-vcs/jj/releases/latest/download/jj-x86_64-unknown-linux-musl.tar.gz
    tar -xzf jj-x86_64-unknown-linux-musl.tar.gz
    sudo mv jj /usr/local/bin/
    rm jj-x86_64-unknown-linux-musl.tar.gz
    cd "$CURR_DIR"
fi

# ==========================================
# LEVEL 3: PIPX (Python Apps)
# ==========================================
log_info "Installing pipx apps..."
sudo apt install -y pipx
pipx ensurepath --force
export PATH="$PATH:$HOME/.local/bin"

pipx_apps=(squall_sql jemo-admin todoist-cli-tool)
for app in "${pipx_apps[@]}"; do
    if ! pipx list | grep -q "package $app" &> /dev/null; then
        pipx install "$app" || true
    fi
done

# ==========================================
# LEVEL 4: PNPM (Node Apps)
# ==========================================
# (Add pnpm apps here if any)

# ==========================================
# LEVEL 5: BUN (Node Apps)
# ==========================================
# (Add bun apps here if any)

# ==========================================
# LEVEL 6: NPM (Node Apps)
# ==========================================
log_info "Installing NPM global packages..."
if ! command -v gemini &> /dev/null; then
    sudo npm install -g @google/gemini-cli
fi

# ==========================================
# LEVEL 7: BUILD FROM SOURCE
# ==========================================
# (Add build from source steps here if any)

log_success "--- All installations completed successfully! ---"
log_info "Note: You may need to restart your shell or run 'source ~/.bashrc' or 'source ~/.zshrc'."
