# Add user configurations here
# For HyDE to not touch your beloved configurations,
# we added a config file for you to customize HyDE before loading zshrc
# Edit $ZDOTDIR/.user.zsh to customize HyDE before loading zshrc

#  Plugins 
# oh-my-zsh plugins are loaded  in $ZDOTDIR/.user.zsh file, see the file for more information

#  Aliases 
# Override aliases here in '$ZDOTDIR/.zshrc' (already set in .zshenv)

#  Helpful aliases 
alias cls="clear"
alias vim="nvim"
alias lg="lazygit"
alias l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias lt='eza --icons=auto --tree' # list folder as tree
alias gt="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all"
alias g="git"
alias tmux="tmux -u"
alias cat="bat"
alias lzd="lazydocker"
alias mk="make"
alias tx="tmux"

#  Kubernetes 
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgs="kubectl get svc"
alias kga="kubectl get all"
alias kgc="kubectl get configmap"
alias kgvs="kubectl get virtualserver"
alias kgi="kubectl get ingress"
alias kgsc="kubectl get secret"
alias kns="kubens"
alias ktx="kubectx"
alias kCreateDebugPod="k run debug-pod --image=busybox -n mysql-sprint --restart=Never -- /bin/sh -c \"sleep 3600\""
alias kDeleteDebugPod="k delete pod debug-pod -n mysql-sprint"
alias kExecDebugPod="k exec -it debug-pod -n mysql-sprint -- /bin/sh"

bindkey '^@' autosuggest-accept        # Ctrl+Space - accept full suggestion
bindkey '\e[Z' forward-word            # Shift+Tab - accept word-by-word

# # Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'

#  This is your file 
# Add your configurations here
export EDITOR=nvim

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Flutter
export PATH="$PATH:$HOME/develop/flutter/bin:$HOME/.pub-cache/bin"

# Shorebird
export PATH="$PATH:$HOME/develop/shorebird/bin"

# Android Studio
export PATH="$PATH:$HOME/Android/Sdk/platform-tools:$HOME/Android/Sdk/cmdline-tools/latest/bin:$HOME/Android/Sdk/emulator"
#export ANDROID_AVD_HOME=$HOME/.config/.android/avd/
export ANDROID_AVD_HOME=$HOME/.android/avd/

export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Claude Code - Litellm
#export ANTHROPIC_BASE_URL="http://localhost:4000"
#export ANTHROPIC_AUTH_TOKEN="sk-1234"

# Gemini
#export GOOGLE_GEMINI_BASE_URL="http://localhost:4000"
#export GEMINI_API_KEY="sk-1234"

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

# Zoxide
eval "$(zoxide init zsh)"

unset -f command_not_found_handler # Uncomment to prevent searching for commands not found in package manager

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "/home/n1h41/.bun/_bun" ] && source "/home/n1h41/.bun/_bun"

# opencode
export PATH=/home/n1h41/.opencode/bin:$PATH

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk


export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"


unalias go 2>/dev/null

# Golang
export PATH=$PATH:/usr/local/go/bin

unalias gh 2>/dev/null

#OCI
## Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

export PATH=/home/n1h41/bin:$PATH

export JIRA_API_TOKEN=ATATT3xFfGF02Wwn8FAjyoslj0af63XE646Sx_4TzOzDK3urn58-IyNks2IchSbAZ-Dn6D07h0i11Pmi_3P9OWwiCQR1VWkXHdLLdC0pVQ8engkK3rvus5Ar4H2bTC21-_fJ6VcUQJSs25HO0mwYlaZaUmpEI2LFhvl6aIjBDbQSvGJR1OBwxVg=418D912B

[[ -e "/home/n1h41/lib/oracle-cli/lib/python3.14/site-packages/oci_cli/bin/oci_autocomplete.sh" ]] && source "/home/n1h41/lib/oracle-cli/lib/python3.14/site-packages/oci_cli/bin/oci_autocomplete.sh"
