
### App
```
sudo apt update
sudo apt install -y gpg

# install eza 
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza
```
 
|app |command|
|---|---|
|fzf|sudo apt install fzf|
|eza|the code block|
|gnome-stow|sudo apt install stow |
|zoxide|sudo apt install zoxide |
|tmux|sudo apt install tmux|
|node|sudo apt install nodejs npm|
|neovim |sudo apt install neovim|
|go|sudo apt install golang |
|valkey-server|sudo apt install valkey-server|
|lazygit|sudo apt install lazygit|
|git |sudo apt install git|
|pipx |`sudo apt update
sudo apt install pipx
pipx ensurepath
`|
|ripgrep|sudo apt install ripgrep |
|jq |sudo apt install jq |
|yazi |apt install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick|
|||
|rust |curl --proto '=https' --tlsv1.2 -sSf [https://sh.rustup.rs](https://sh.rustup.rs) \| sh|
|uv|curl -LsSf [https://astral.sh/uv/install.sh](https://astral.sh/uv/install.sh) \| sh|
|nvm |`curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh \| bash`|
|bun |curl -fsSL [https://bun.sh/install](https://bun.sh/install) \| bash|
|deno |curl -fsSL [https://deno.land/install.sh](https://deno.land/install.sh) \| sh|
|atuin|curl --proto '=https' --tlsv1.2 -LsSf [https://setup.atuin.sh](https://setup.atuin.sh) \| sh|
|Gemini cli |npm install -g @google/gemini-cli|
|Opencode |curl -fsSL https://opencode.ai/install | bash|
|jj|curl -LO https://github.com/jj-vcs/jj/releases/latest/download/jj-x86_64-unknown-linux-musl.tar.gz && tar -xzf jj-x86_64-unknown-linux-musl.tar.gz && sudo mv jj /usr/local/bin/|
|||
|squall_sql|pipx install squall_sql |
|jemo-admin|pipx install jemo-admin|
|todoist-cli|pipx install todoist-cli-tool|
