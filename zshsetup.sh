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
# The 'sh -c' part is necessary because the curl output is piped to sh
# The -y flag to the install script (if supported) can make it non-interactive,
# but the Oh My Zsh installer is usually interactive by default,
# prompting you to change your default shell.
if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
    echo "Oh My Zsh installation script executed successfully."
    echo "You may need to log out and log back in, or open a new terminal, for Zsh and Oh My Zsh to take effect."
else
    echo "Error: Oh My Zsh installation failed or was interrupted."
    echo "Please check the output above for details."
    exit 1
fi

echo "--- Zsh and Oh My Zsh setup complete (or attempted) ---"
