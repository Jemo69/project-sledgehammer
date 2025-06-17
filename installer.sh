#!/bin/bash 
sudo apt update -y

sudo apt upgrade -y



#!/usr/bin/env zsh
set -e

# Define regular apt packages
apt_packages=(
    "git"
    "fzf"
    "eza"
    "zoxide"
    "tmux"
    "stow"
    "nodejs"
    "neovim"
    "golang"
    "valkey-server" 
    "lazygit"
)

echo "--- Installing apt packages ---"

for package in "${apt_packages[@]}"; do
    echo "Installing ${package}..."
    if sudo apt install -y "${package}"; then
        echo "${package} installed successfully."
    else
        echo "Error: Failed to install ${package}. Aborting."
        exit 1 # Exit if an apt package fails to install
    fi
done

echo "--- Done with non-curl packages ---"

# Add a small delay for clarity, using correct sleep syntax
sleep 3

echo "--- Installing curl-based packages ---"

# Define curl-based installation commands.
# Each command should be executable as is.
# Note: For uv, bun, and deno, their install scripts often handle PATH setup.
# Rustup also handles PATH setup and suggests sourcing.
curl_install_commands=(
    "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" # -y to auto-confirm rustup
    "curl -LsSf https://astral.sh/uv/install.sh | sh"
    "curl -fsSL https://bun.sh/install | bash"
    "curl -fsSL https://deno.land/install.sh | sh"
)

for cmd in "${curl_install_commands[@]}"; do
    echo "Executing: ${cmd}"
    # Use 'eval' for commands that include pipes or complex expansions,
    # but be cautious with untrusted input if this were user-facing.
    # For predefined commands like these, it's generally safe.
    if eval "${cmd}"; then
        echo "Command executed successfully."
    else
        echo "Error: Command failed to execute. Aborting."
        exit 1 # Exit if a curl command fails
    fi
done

echo "--- Attempting to source shell configuration for newly installed tools ---"
# Most of these installers modify .bashrc or .zshrc.
# Sourcing it here will make the commands available in the *current script's environment*.
# For interactive sessions, you'll still need to open a new terminal or manually source.
if [ -f "$HOME/.bashrc" ]; then
    echo "Sourcing ~/.bashrc..."
    source "$HOME/.bashrc"
elif [ -f "$HOME/.zshrc" ]; then
    echo "Sourcing ~/.zshrc..."
    source "$HOME/.zshrc"
fi
echo "Install github cli"
     (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
     && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
     && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y

echo "--- All installations attempted. ---"
echo "Please open a new terminal or manually run 'source ~/.bashrc' or 'source ~/.zshrc' to ensure all new commands are in your PATH."