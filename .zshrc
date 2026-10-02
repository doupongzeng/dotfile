# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Keep PATH entries unique (collapses duplicates from re-sourcing this file)
typeset -gU path PATH

if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="ys"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sudo extract colored-man-pages fzf z.lua zsh-autosuggestions)

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#767676"

if command -v brew &>/dev/null; then
    FZF_BREW_PREFIX="$(brew --prefix fzf 2>/dev/null)"
    if [[ -n "$FZF_BREW_PREFIX" && -d "$FZF_BREW_PREFIX" ]]; then
        export FZF_BASE="$FZF_BREW_PREFIX"
    fi
fi

[ -f "$HOME/.profile" ] && source "$HOME/.profile"
source $ZSH/oh-my-zsh.sh

# User configuration

#========================
# environment
#========================
export EDITOR='nvim'
#  export MANPAGER='nvim -R +":set ft=man" -' #这在会man颜色会乱码 neovim 5.0+
export MANPAGER='nvim +Man!'

if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND="fd --exclude={.git,.svn,.idea,.vscode,build} --type f"
fi
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview \"head {} -n500\" --preview-window=right:60%"

if [[ -f /proc/version ]]; then
    if grep -qi microsoft /proc/version 2>/dev/null; then
        proxy_server="$(hostname -I 2>/dev/null | cut -d" " -f1)"
        export wsl_version=2
    fi
fi

#========================
# functions
#========================
function proxy_enable() {
    if [ ${1:-1} -eq 0 ]; then
        unset ALL_PROXY
        unset all_proxy
        unset http_proxy
        unset https_proxy
        unset no_proxy
    else
        export ALL_PROXY=http://$proxy_server:7890
        export all_proxy=$ALL_PROXY
        export http_proxy=$ALL_PROXY
        export https_proxy=$ALL_PROXY
        export no_proxy='127.0.0.1,192.6.6.6'
    fi
}
# proxy_enable

#========================
# alias
#========================
alias vi=nvim
alias vim=nvim
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias vimrc="vim ~/.config/nvim/init.lua"
alias p4=proxychains4
if [[ "$(uname)" == "Darwin" ]]; then
    alias xo="open"
    alias leakcheck="leaks -atExit --"
else
    alias xo="xdg-open"
    command -v yay &>/dev/null && alias ys="yay -Sy"
    alias leakcheck="valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes"
fi
alias tp="$HOME/Config/template/install.sh"
alias vimf='vim $(fzf)'
# # if [ -z ${WSL_DISTRO_NAME} ];then
# #     alias tmux='env TERM=screen-256color tmux'
# # fi
# export TERM=screen-256color
alias ta="tmux attach || tmux"
alias zz='z -c' # 严格匹配当前路径的子路径
alias zi='z -i' # 使用交互式选择模式
alias zf='z -I' # 使用 fzf 对多个结果进行选择
alias zb='z -b' # 快速回到父目录
alias zh='z -I -t .' # fzf选择历史路径

alias cmakeg="[ -f CMakeLists.txt ] && ln -sf build/compile_commands.json ./;\
    cmake -S. -Bbuild -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Release"
alias cmakegd="[ -f CMakeLists.txt ] && ln -sf build/compile_commands.json ./;\
    cmake -S. -Bbuild -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Debug"
alias cmakeb="cmakeg && cmake --build build"
alias cmaker="cmakeg && cmake --build build --target run"
[[ -d "$HOME/Qt5.14.2/5.14.2/gcc_64/bin" ]] && alias linguist="$HOME/Qt5.14.2/5.14.2/gcc_64/bin/linguist"
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gcd='git checkout'
alias gcb='git checkout -b'

# alias adb='~/Android/Sdk/platform-tools/adb'
alias fish='/usr/local/bin/asciiquarium'
alias getidf='. $HOME/esp/esp-idf/export.sh'
if [[ "$(uname)" == "Darwin" ]]; then
    alias ob="open -a 'Obsidian'"
    alias edge="open -a 'Microsoft Edge'"
    alias androidstudio="open -a 'Android Studio'"
else
    alias ob='/usr/bin/obsidian > /dev/null 2>&1 &'
    alias edge='/usr/bin/microsoft-edge > /dev/null 2>&1 &'
    alias androidstudio='~/android-studio/bin/studio.sh > /dev/null 2>&1 &'
    alias shot='flameshot gui'
fi

#========================
# keybinding
#========================
bindkey '^ ' autosuggest-accept

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$HOME/.rvm/bin:$PATH"
export PATH="$PATH:$HOME/.yarn/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.local/bin/repo"

if [[ "$(uname)" == "Linux" ]]; then
    [[ -d /opt/nvim-linux-x86_64/bin ]] && export PATH="/opt/nvim-linux-x86_64/bin:$PATH"
    [[ -d /usr/local/cuda/bin ]] && export PATH="/usr/local/cuda/bin:$PATH"
    [[ -d /usr/local/cuda/lib64 ]] && export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
fi
# export USE_BAZEL_VERSION=6.4.0
export USE_BAZEL_VERSION=5.1.0
# export USE_BAZEL_VERSION=5.4.1

fpath+=~/.zsh_functions

#screenfetch

# NVM: keep shell startup fast while making the default Node immediately available.
export NVM_DIR="$HOME/.nvm"
if [[ -d "$NVM_DIR/versions/node" ]]; then
    _latest_node="$(ls -d "$NVM_DIR"/versions/node/* 2>/dev/null | tail -n 1)"
    [[ -n "$_latest_node" && -d "$_latest_node/bin" ]] && export PATH="$_latest_node/bin:$PATH"
    unset _latest_node
fi

# Load full nvm only when the nvm command is used.
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm "$@"
}

if [[ "$(uname)" == "Linux" ]]; then
    [[ -d "$HOME/Qt/Tools/QtCreator/bin" ]] && export PATH="$HOME/Qt/Tools/QtCreator/bin:$PATH"
    [[ -d "$HOME/Qt/5.12.11/gcc_64/bin" ]] && export PATH="$HOME/Qt/5.12.11/gcc_64/bin:$PATH"
fi

[[ -o interactive && -t 1 ]] && command -v cowsay &>/dev/null && cowsay "Less Search, More Try"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"


# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ── 图片查看：tmux 内强制 sixel 避免降级成字符糊块，tmux 外自动探测最优协议 ──
img() {
  if [[ -n "$TMUX" ]]; then
    chafa -f sixels "$@"     # tmux 内：强制 sixel
  else
    chafa "$@"               # 直连 WezTerm：自动探测（iterm/kitty/sixel）
  fi
}

# timg 同理（已安装 1.5.2），tmux 内用 sixel
timgi() {
  if [[ -n "$TMUX" ]]; then
    timg -p sixel "$@"
  else
    timg "$@"
  fi
}

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# QODER_DISPATCHER_PATH v1
path=("$HOME/.qoder/entry" ${path:#"$HOME/.qoder/entry"})
export PATH
# END QODER_DISPATCHER_PATH v1
