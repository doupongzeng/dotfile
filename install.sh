#!/bin/bash
python_version=$(python3 --version)
python_venv=${python_version%.*}-venv

sudo apt install ${python_venv} zsh tmux fuse ssh curl git build-essential libreadline-dev unzip fzf ripgrep -y

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

curl https://sh.rustup.rs -sSf | sh

nvm install --lts

git clone https://github.com/doupongzeng/AstroNvim_v4_config.git ~/.config/nvim

# lua and luarock
wget http://www.lua.org/ftp/lua-5.3.5.tar.gz
tar -zxf lua-5.3.5.tar.gz
cd lua-5.3.5
make linux test
sudo make install
cd ~/dotfile

cd $(dirname $0)

if [ ! -d ~/.oh-my-zsh ]; then
    echo "Install oh-my-zsh first!"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
Z_LUA_PATH=${ZSH_CUSTOM}/plugins/z.lua
ZSH_AUTOSUGGESTIONS=${ZSH_CUSTOM}/plugins/zsh-autosuggestions

if [ ! -d $Z_LUA_PATH ]; then
    git clone https://github.com/skywind3000/z.lua $Z_LUA_PATH
fi

if [ ! -d $ZSH_AUTOSUGGESTIONS ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_AUTOSUGGESTIONS
fi

ln -sf $PWD/.zshrc ~/
ln -sf $PWD/.tmux.conf ~/
ln -sf $PWD/.clang-format ~/

if [ ! -d ~/.config/alacritty ]; then
  mkdir -p ~/.config/alacritty
fi
ln -sf $PWD/config/alacritty.yml ~/.config/alacritty/

if [ ! -d ~/.config/i3 ]; then
    mkdir ~/.config/i3
fi
if [ ! -d ~/.config/i3status ]; then
    mkdir ~/.config/i3status
fi
if [ ! -d ~/.config/clangd ]; then
    mkdir ~/.config/clangd
fi
ln -sf $PWD/config/i3/config ~/.config/i3/
ln -sf $PWD/config/i3status/config ~/.config/i3status/
ln -sf $PWD/config/.ideavimrc ~/.ideavimrc
ln -sf $PWD/config/clangd/config.yaml ~/.config/clangd/config.yaml

# tmux italic support
tic res/screen-256color.terminfo

# konsole colorscheme
if [ -d ~/.local/share/konsole ];then
    cp res/Monokai.colorscheme ~/.local/share/konsole/
fi
