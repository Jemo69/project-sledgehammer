#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

echo "--- Updating and upgrading apt packages ---"
sudo apt update -y
sudo apt upgrade -y

# Define regular apt packages
apt_packages=(
    "zoxide"
    "git"
    "unzip"
    "fzf"
    "tmux"
    "stow"
    "nodejs"
    "neovim"
    "golang"
    "valkey-server"
    "gh"
    "eza"
    "ripgrep"
    "jq"
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

echo "--- Done with apt packages ---"

echo "--- Installing lazygit ---"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit
rm lazygit.tar.gz


# Add a small delay for clarity
sleep 1

echo "--- Installing curl-based packages ---"

if [ -d "$HOME/.rustup" ]; then
    echo "Removing existing Rustup installation..."
    rm -rf "$HOME/.rustup"
fi

if [ -d "$HOME/.cargo" ]; then
    echo "Removing existing Cargo installation..."
    rm -rf "$HOME/.cargo"
fi

if [ -d "/usr/local/bun" ]; then
    echo "Removing existing bun installation..."
    sudo rm -rf "/usr/local/bun"
fi

# Define curl-based installation commands.
curl_install_commands=(
    "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" # -y to auto-confirm rustup
    "curl -LsSf https://astral.sh/uv/install.sh | sh"
    "curl -fsSL https://bun.sh/install | bash"
    "curl -fsSL https://deno.land/install.sh | sh"
    "bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)"
    # The following atuin commands are commented out as they require interactive user input.
    # "atuin register -u <USERNAME> -e <EMAIL>"
    # "atuin import auto"
    # "atuin sync"
)

for cmd in "${curl_install_commands[@]}"; do
    echo "Executing: ${cmd}"
    if eval "${cmd}"; then
        echo "Command executed successfully."
    else
        echo "Error: Command failed to execute. Aborting."
        exit 1 # Exit if a curl command fails
    fi
done
echo "--- installing thought script --- "
scriptpackages=(
    './install-dart.sh'
    './install-eza.sh'
    )
for script in "${scriptpackages[@]}";do 
    echo "runing script : ${script}"
    if eval "${script}"; then
        echo "Command executed successfully."
    else
        echo "Error: Command failed to execute. Aborting."
        exit 1 # Exit if a curl command fails
    fi
done
    

echo "--- Attempting to source shell configuration for newly installed tools ---"
# Sourcing here makes commands available in the *current script's environment*.
# For interactive sessions, a new terminal or manual sourcing is still required.
if [ -f "$HOME/.zshrc" ]; then
    echo "Sourcing ~/.zshrc..."
    source "$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    echo "Sourcing ~/.bashrc..."
    source "$HOME/.bashrc"
fi

echo "--- All installations attempted. ---"
echo "Please open a new terminal or manually run 'source ~/.bashrc' or 'source ~/.zshrc' to ensure all new commands are in your PATH."
