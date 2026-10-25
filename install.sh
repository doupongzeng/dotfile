#!/bin/bash
set -e

DOTFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

echo "==> Configuring dotfiles for OS: $OS"

if [ "$OS" = "Darwin" ]; then
    if ! command -v brew &>/dev/null; then
        echo "Error: Homebrew is required on macOS. Please install brew first."
        exit 1
    fi
    echo "==> Installing macOS packages via Homebrew..."
    brew install neovim tmux curl git unzip fzf ripgrep fd lua luarocks cowsay || true
    brew install --cask font-maple-mono-normal-nl-nf-cn || true
elif [ "$OS" = "Linux" ]; then
    if command -v apt &>/dev/null; then
        echo "==> Installing Linux packages via apt..."
        python_version=$(python3 --version 2>/dev/null || true)
        python_venv=python$(echo "$python_version" | cut -d " " -f 2 | cut -d "." -f 1,2)-venv
        sudo apt update
        sudo apt install ${python_venv} zsh tmux fuse ssh curl git build-essential libreadline-dev unzip fzf ripgrep lua5.3 luarocks -y || true
    fi
fi

if [ "$OS" = "Linux" ]; then
    if [ ! -d ~/.nvm ]; then
        echo "==> Installing nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    fi

    if [ ! -d ~/.cargo ]; then
        echo "==> Installing rustup..."
        curl https://sh.rustup.rs -sSf | sh -s -- -y || true
    fi
fi

if [ ! -d ~/.config/nvim ]; then
    echo "==> Cloning nvim config..."
    git clone https://github.com/doupongzeng/AstroNvim_v5_config.git ~/.config/nvim || true
fi

if [ ! -d ~/.oh-my-zsh ]; then
    echo "==> Installing oh-my-zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
Z_LUA_PATH=${ZSH_CUSTOM}/plugins/z.lua
ZSH_AUTOSUGGESTIONS=${ZSH_CUSTOM}/plugins/zsh-autosuggestions

if [ ! -d "$Z_LUA_PATH" ]; then
    echo "==> Cloning z.lua plugin..."
    git clone https://github.com/skywind3000/z.lua "$Z_LUA_PATH"
fi

if [ ! -d "$ZSH_AUTOSUGGESTIONS" ]; then
    echo "==> Cloning zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGESTIONS"
fi

echo "==> Linking dotfiles..."
ln -sf "$DOTFILE_DIR/.zshrc" ~/
ln -sf "$DOTFILE_DIR/.tmux.conf" ~/
ln -sf "$DOTFILE_DIR/.clang-format" ~/
ln -sf "$DOTFILE_DIR/config/.ideavimrc" ~/

mkdir -p ~/.config/clangd
ln -sf "$DOTFILE_DIR/config/clangd/config.yaml" ~/.config/clangd/config.yaml

mkdir -p ~/.config/wezterm
ln -sf "$DOTFILE_DIR/config/wezterm/wezterm.lua" ~/.config/wezterm/wezterm.lua

mkdir -p ~/.config/herdr
ln -sf "$DOTFILE_DIR/config/herdr/config.toml" ~/.config/herdr/config.toml

if [ "$OS" = "Darwin" ]; then
    mkdir -p "$HOME/Library/Preferences/clangd"
    ln -sf "$DOTFILE_DIR/config/clangd/config.yaml" "$HOME/Library/Preferences/clangd/config.yaml"
fi

if [ "$OS" = "Linux" ]; then
    mkdir -p ~/.config/alacritty ~/.config/ghostty
    [ -L ~/.config/alacritty/alacritty.yml ] && rm -f ~/.config/alacritty/alacritty.yml
    ln -sf "$DOTFILE_DIR/config/alacritty.toml" ~/.config/alacritty/alacritty.toml
    ln -sf "$DOTFILE_DIR/config/ghostty/config" ~/.config/ghostty/config

    mkdir -p ~/.config/i3 ~/.config/i3status
    ln -sf "$DOTFILE_DIR/config/i3/config" ~/.config/i3/
    ln -sf "$DOTFILE_DIR/config/i3status/config" ~/.config/i3status/

    if [ -d ~/.local/share/konsole ]; then
        cp "$DOTFILE_DIR/res/Monokai.colorscheme" ~/.local/share/konsole/
    fi
fi

# tmux italic support
tic -x "$DOTFILE_DIR/res/screen-256color.terminfo" 2>/dev/null || tic "$DOTFILE_DIR/res/screen-256color.terminfo" 2>/dev/null || true

echo "==> Done!"
