# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

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

source $HOME/.profile
source $ZSH/oh-my-zsh.sh

# User configuration

#========================
# environment
#========================
export EDITOR='nvim'
export MANPAGER='nvim -R +":set ft=man" -'

export FZF_DEFAULT_COMMAND="fd --exclude={.git,.svn,.idea,.vscode,build} --type f"
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview \"head {} -n500\" --preview-window=right:60%"

if cat /proc/version | grep microsoft &>/dev/null; then
    proxy_server="$(cat /etc/resolv.conf | grep nameserver | cut -d' ' -f2)"
    export wsl_version=2
else
    if cat /proc/version | grep Microsoft &>/dev/null; then
        export wsl_version=1
    fi
    proxy_server="192.168.1.104"
#    proxy_server="192.168.31.110"
fi

#========================
# functions
#========================
function proxy_enable() {
    if [ ${1:-1} -eq 0 ]; then
        unset ALL_PROXY
        unset http_proxy
        unset https_proxy
        unset no_proxy
    else
        export ALL_PROXY=http://$proxy_server:7890
        export http_proxy=$ALL_PROXY
        export https_proxy=$ALL_PROXY
        export no_proxy='127.0.0.1,192.6.6.6'
    fi
}
proxy_enable

#========================
# alias
#========================
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias vi=nvim
alias vim=nvim
alias p4=proxychains4
alias xo="xdg-open"
alias ys="yay -Sy"
alias tp="$HOME/Config/template/install.sh"
alias vimf='vim $(fzf)'
alias node=nodejs
if [ -z ${WSL_DISTRO_NAME} ];then
    alias tmux='env TERM=screen-256color tmux'
fi
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
alias leakcheck="valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes"
alias linguist="~/Qt5.14.2/5.14.2/gcc_64/bin/linguist"
alias gs='git status'
alias ga='git add'
alias gc='git commit -a -m'
alias gcd='git checkout'
alias gcb='git checkout -b'

#========================
# keybinding
#========================
bindkey '^ ' autosuggest-accept

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:$HOME/.yarn/bin"
export FZF_DEFAULT_COMMAND=""
