# Add user configurations here
# For HyDE to not touch your beloved configurations,
# we added a config file for you to customize HyDE before loading zshrc
# Edit $ZDOTDIR/.user.zsh to customize HyDE before loading zshrc

#  Plugins 
# oh-my-zsh plugins are loaded  in $ZDOTDIR/.user.zsh file, see the file for more information

#  Aliases 
# Override aliases here in '$ZDOTDIR/.zshrc' (already set in .zshenv)

# # Helpful aliases
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

bindkey '^@' autosuggest-accept

# # Directory navigation shortcuts
# alias ..='cd ..'
# alias ...='cd ../..'
# alias .3='cd ../../..'
# alias .4='cd ../../../..'
# alias .5='cd ../../../../..'

# # Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'

#  This is your file 
# Add your configurations here
export EDITOR=nvim

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Flutter (OS-specific paths)
if [[ -n $IS_MACOS ]]; then
    export PATH="$PATH:/Users/tabaqtech/Documents/flutter/bin:$HOME/.pub-cache/bin"
else
    export PATH="$PATH:$HOME/develop/flutter/bin:$HOME/.pub-cache/bin"
fi

# Android Studio (OS-specific paths)
if [[ -n $IS_MACOS ]]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator"
    export ANDROID_AVD_HOME="$HOME/.android/avd"
else
    export PATH="$PATH:$HOME/Android/Sdk/platform-tools:$HOME/Android/Sdk/cmdline-tools/latest/bin:$HOME/Android/Sdk/emulator"
    export ANDROID_AVD_HOME=$HOME/.config/.android/avd/
fi

export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Claude Code - Litellm
export ANTHROPIC_BASE_URL="http://localhost:4000"
export ANTHROPIC_AUTH_TOKEN="sk-1234"

# Gemini
export GOOGLE_GEMINI_BASE_URL="http://localhost:4000"
export GEMINI_API_KEY="sk-1234"

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

# NVM (OS-specific paths)
if [[ -n $IS_MACOS ]]; then
    export NVM_DIR="$HOME/.nvm"
    # Homebrew NVM (Apple Silicon)
    if [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
        source "/opt/homebrew/opt/nvm/nvm.sh"
    # Homebrew NVM (Intel)
    elif [[ -s "/usr/local/opt/nvm/nvm.sh" ]]; then
        source "/usr/local/opt/nvm/nvm.sh"
    # Manual install
    elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
        source "$NVM_DIR/nvm.sh"
    fi
else
    # Linux NVM path
    [[ -s "/usr/share/nvm/init-nvm.sh" ]] && source /usr/share/nvm/init-nvm.sh
fi

# bun completions (OS-agnostic path)
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# opencode (OS-specific binary)
if [[ -n $IS_MACOS ]]; then
    export PATH="$HOME/dev/projects/opencode/packages/opencode/dist/opencode-darwin-arm64/bin:$PATH"
else
    export PATH="$HOME/dev/projects/opencode/packages/opencode/dist/opencode-linux-x64/bin:$PATH"
fi

# macOS-specific: Java (if needed)
if [[ -n $IS_MACOS ]]; then
    # Uncomment if you need Java 17
    # export JAVA_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null)
    
    # Starship prompt (if installed via brew)
    if command -v starship >/dev/null 2>&1; then
        eval "$(starship init zsh)"
    fi
fi

# bun completions
[ -s "/Users/tabaqtech/.bun/_bun" ] && source "/Users/tabaqtech/.bun/_bun"
