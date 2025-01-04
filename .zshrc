# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"

# Load and initialise completion system
autoload -Uz compinit
compinit

# Initialisations
eval "$(starship init zsh)"

# Lines configured by zsh-newuser-install
setopt autocd notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/n1h41/.zshrc'

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# myenv wrapper
# ----------------start----------------

# include following in .bashrc / .bash_profile / .zshrc
# usage
# $ mkvenv myvirtualenv # creates venv under ~/.virtualenvs/
# $ venv myvirtualenv   # activates venv
# $ deactivate          # deactivates venv
# $ rmvenv myvirtualenv # removes venv

export VENV_HOME="$HOME/.virtualenvs"
[[ -d $VENV_HOME ]] || mkdir $VENV_HOME

lsvenv() {
  ls -1 $VENV_HOME
}

venv() {
  if [ $# -eq 0 ]
    then
      echo "Please provide venv name"
    else
      source "$VENV_HOME/$1/bin/activate"
  fi
}

mkvenv() {
  if [ $# -eq 0 ]
    then
      echo "Please provide venv name"
    else
      python3 -m venv $VENV_HOME/$1
  fi
}

rmvenv() {
  if [ $# -eq 0 ]
    then
      echo "Please provide venv name"
    else
      rm -r $VENV_HOME/$1
  fi
}

# ----------------end----------------

# Plugins
ZSH_AUTOSUGGEST_STRATEGY="match_prev_cmd"
bindkey '^ ' autosuggest-accept

# INFO: Personal aliases
alias cls="clear"
alias vim="nvim"
alias lg="lazygit"
alias  l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias gt="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all"
alias g="git"
alias tmux="tmux -u"
alias cat="bat"
alias lzd="lazydocker"
# alias tr="tmuxinator"
alias mk="make"
alias tx="tmux"


# source /home/n1h41/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Update path with flutter binaries
export PATH="$PATH:/home/n1h41/development/flutter/bin"
export PATH="$PATH:/home/n1h41/Android/Sdk/platform-tools"

# Go path
# export PATH="$PATH:/usr/local/go/bin"

# Go executables path
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"


export PATH="$PATH:/opt/mssql-tools/bin"

# cargo installed apps path
export PATH="$PATH:/home/n1h41/.cargo/bin"

# Android Studio Emulator
export PATH="$PATH:/home/n1h41/Android/Sdk/emulator"

# initialise zoxide
eval "$(zoxide init zsh)"

source <(fzf --zsh)

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

export EDITOR="nvim"

export CHROME_EXECUTABLE="/opt/google/chrome/chrome"

#Display Pokemon
pokemon-colorscripts --no-title -r 1,3,6

zstyle ':completion:*' menu select
fpath+=~/.zfunc

# Setup keychain
eval $(keychain --eval --quiet ~/.ssh/id_ed25519)

# Ollama Aliases
alias orz="docker exec -it ollama ollama run zephyr"
alias orl="docker exec -it ollama ollama run llama3.2"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
