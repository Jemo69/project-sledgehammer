#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

echo "--- Installing zsh ---"
if sudo apt install -y zsh; then
    echo "Zsh installed successfully."
else
    echo "Error: Failed to install zsh. Aborting."
    exit 1
fi

echo "--- Installing Oh My Zsh ---"
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Removing existing Oh My Zsh installation..."
    rm -rf "$HOME/.oh-my-zsh"
fi
# The 'sh -c' part is necessary because the curl output is piped to sh.
# We use the '--unattended' flag to make the installation non-interactive.
if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) "" --unattended"; then
    echo "Oh My Zsh installation script executed successfully."
    echo "You may need to log out and log back in, or open a new terminal, for Zsh and Oh My Zsh to take effect."
else
    echo "Error: Oh My Zsh installation failed or was interrupted."
    echo "Please check the output above for details."
    exit 1
fi

echo "--- Zsh and Oh My Zsh setup complete (or attempted) ---"
