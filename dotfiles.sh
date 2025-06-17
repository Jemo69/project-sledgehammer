#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

DOT_FILES_REPO="https://github.com/Jemo69/dot-file.git"
DOT_FILES_DIR="dot-file" # The directory git clone will create


if [ -f ~/.zshrc ]; then echo "Backing up existing ~/.zshrc..."
     mv ~/.zshrc ~/.zshrc.bak
fi
echo "--- Checking for 'stow' installation ---"
if ! command -v stow &> /dev/null; then
    echo "'stow' is not installed. Attempting to install 'stow'..."
    if sudo apt install -y stow; then
        echo "'stow' installed successfully."
    else
        echo "Error: Failed to install 'stow'. Please install it manually and try again."
        exit 1 # Exit if stow cannot be installed
    fi
else
    echo "'stow' is already installed."
fi

echo "--- Checking for 'git' installation ---"
if ! command -v git &> /dev/null; then
    echo "'git' is not installed. Attempting to install 'git'..."
    if sudo apt install -y git; then
        echo "'git' installed successfully."
    else
        echo "Error: Failed to install 'git'. Please install it manually and try again."
        exit 1 # Exit if git cannot be installed
    fi
else
    echo "'git' is already installed."
fi

echo "--- Cloning dot-files repository ---"
if [ -d "$HOME/$DOT_FILES_DIR" ]; then
    echo "Dot-files directory '$HOME/$DOT_FILES_DIR' already exists. Pulling latest changes..."
    # If the directory exists, navigate into it and pull
    # Capture output for debugging, but don't print unless error
    (cd "$HOME/$DOT_FILES_DIR" && git pull origin main) || { echo "Error: Failed to pull latest dot-files."; exit 1; }
else
    echo "Cloning '$DOT_FILES_REPO' into '$HOME/$DOT_FILES_DIR'..."
    # Clone into the home directory, then move into it
    git clone "$DOT_FILES_REPO" "$HOME/$DOT_FILES_DIR" || { echo "Error: Failed to clone dot-files repository."; exit 1; }
fi

echo "--- Stowing dot-files ---"
# Navigate to the dot-files directory before running stow
if cd "$HOME/$DOT_FILES_DIR"; then
    echo "Running 'stow .' in '$PWD' with verbose output..."
    echo "This will show you exactly what stow is trying to do and why it might fail."
    echo "Look for messages like 'stow: ERROR: cannot create link ... File exists'."
    echo "If conflicts occur, you may need to manually move or delete existing files in your home directory before running this script again."

    # Run stow with -v (verbose) flag to get detailed output
    # Redirect stderr to stdout so all stow output is captured
    if stow -v . 2>&1; then
        echo "Dot-files stowed successfully."
    else
        echo "Error: Failed to stow dot-files."
        echo "Common reasons for stow failure:"
        echo "1. Conflicts: A target file/directory already exists and is not a symlink created by stow."
        echo "   e.g., if you already have a plain ~/.zshrc file, stow won't overwrite it."
        echo "   Solution: Move or delete the conflicting file(s) in your home directory."
        echo "   Example: mv ~/.zshrc ~/.zshrc.bak"
        echo "2. Permissions: The script user doesn't have write permissions to create symlinks."
        echo "   Solution: Ensure your user owns your home directory and its contents."
        echo "3. Incorrect dot-file structure: Ensure your dot-file repository contains subdirectories for each 'package' you want to stow."
        echo "   e.g., dot-file/zsh/.zshrc for your .zshrc file."
        exit 1 # Exit with an error code
    fi
else
    echo "Error: Could not change directory to '$HOME/$DOT_FILES_DIR'."
    exit 1
fi

echo "--- Dot-file setup complete! ---"

# After successful stowing, if you changed shell configs, you might want to source them.
echo "--- Important: If shell configurations (like .zshrc or .bashrc) were stowed, you might need to run 'source ~/.zshrc' (or your respective shell config) or open a new terminal for changes to take effect. ---"
