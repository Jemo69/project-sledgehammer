# Project Sledgehammer 🔨

A modern, automated setup script for a high-productivity development environment.

## Overview

This project automates the installation of essential tools and the configuration of dotfiles for a Debian-based system (Ubuntu, etc.). It aligns with the specifications in `thing.md`.

## Features

- **Package Management**: Automated installation of APT packages, Pipx apps, and curl-based tools.
- **Modern CLI Tools**: Installs `eza`, `zoxide`, `fzf`, `lazygit`, `yazi`, and more.
- **Runtimes**: Sets up `rust`, `go`, `node` (via `nvm`), `bun`, `deno`, and `uv`.
- **Shell**: Configures `zsh` with Oh My Zsh and `atuin` for shell history.
- **Dotfiles**: Automatically clones and stows dotfiles from `Jemo69/dot-file`.

## Usage

To start the full installation and setup process, run:

```bash
chmod +x run.sh
./run.sh
```

## Included Applications

Refer to [thing.md](thing.md) for the full list of applications and their installation sources.

## Project Structure

- `run.sh`: Main entry point.
- `installer.sh`: Handles application installations.
- `zshsetup.sh`: Sets up ZSH and Oh My Zsh.
- `dotfiles.sh`: Manages dotfiles using GNU Stow.
- `art.sh`: ASCII art for the installer.
- `thing.md`: The source of truth for required applications.
