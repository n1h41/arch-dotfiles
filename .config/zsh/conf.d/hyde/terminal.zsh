#!/usr/bin/env zsh

#! ██████╗░░█████╗░  ███╗░░██╗░█████╗░████████╗  ███████╗██████╗░██╗████████╗
#! ██╔══██╗██╔══██╗  ████╗░██║██╔══██╗╚══██╔══╝  ██╔════╝██╔══██╗██║╚══██╔══╝
#! ██║░░██║██║░░██║  ██╔██╗██║██║░░██║░░░██║░░░  █████╗░░██║░░██║██║░░░██║░░░
#! ██║░░██║██║░░██║  ██║╚████║██║░░██║░░░██║░░░  ██╔══╝░░██║░░██║██║░░░██║░░░
#! ██████╔╝╚█████╔╝  ██║░╚███║╚█████╔╝░░░██║░░░  ███████╗██████╔╝██║░░░██║░░░
#! ╚═════╝░░╚════╝░  ╚═╝░░╚══╝░╚════╝░░░░╚═╝░░░  ╚══════╝╚═════╝░╚═╝░░░╚═╝░░░

# HyDE's ZSH env configuration
# This file is sourced by ZSH on startup
# And ensures that we have an obstruction-free .zshrc file
# This also ensures that the proper HyDE $ENVs are loaded

# Detect OS (reuse from env.zsh if already set)
if [[ -z $IS_MACOS && -z $IS_LINUX ]]; then
    case "$(uname -s)" in
        Darwin) IS_MACOS=1 ;;
        Linux)  IS_LINUX=1 ;;
    esac
fi

function _load_functions() {
    # Load all custom function files // Directories are ignored
    for file in "${ZDOTDIR:-$HOME/.config/zsh}/functions/"*.zsh; do
        [ -r "$file" ] && source "$file"
    done
}

function _load_completions() {
    for file in "${ZDOTDIR:-$HOME/.config/zsh}/completions/"*.zsh; do
        [ -r "$file" ] && source "$file"
    done
}

function _dedup_zsh_plugins {
    unset -f _dedup_zsh_plugins
    # Oh-my-zsh installation path (OS-specific)
    if [[ -n $IS_MACOS ]]; then
        zsh_paths=(
            "$HOME/.oh-my-zsh"
            "/opt/homebrew/share/oh-my-zsh"
            "/usr/local/share/oh-my-zsh"
        )
    else
        zsh_paths=(
            "/usr/share/oh-my-zsh"
            "/usr/local/share/oh-my-zsh"
            "$HOME/.oh-my-zsh"
        )
    fi
    for zsh_path in "${zsh_paths[@]}"; do [[ -d $zsh_path ]] && export ZSH=$zsh_path && break; done
    # Load Plugins
    hyde_plugins=(git zsh-256color zsh-autosuggestions zsh-syntax-highlighting)
    plugins+=("${plugins[@]}" "${hyde_plugins[@]}")
    # Deduplicate plugins
    plugins=("${plugins[@]}")
    plugins=($(printf "%s\n" "${plugins[@]}" | sort -u))
    # Defer oh-my-zsh loading until after prompt appears
    typeset -g DEFER_OMZ_LOAD=1
}

function _defer_omz_after_prompt_before_input() {

    [[ -r $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh
    #! Never load time consuming functions here

    # Add your completions directory to fpath
    fpath=($ZDOTDIR/completions "${fpath[@]}")

    _load_compinit
    _load_functions
    _load_completions

    # zsh-autosuggestions won't work on first prompt when deferred
    if typeset -f _zsh_autosuggest_start >/dev/null; then
        _zsh_autosuggest_start
    fi

    chmod +r $ZDOTDIR/.zshrc # Make sure .zshrc is readable
    [[ -r $ZDOTDIR/.zshrc ]] && source $ZDOTDIR/.zshrc
}

function _load_deferred_plugin_system_by_hyde() {

    # Exit early if HYDE_ZSH_DEFER is not set to 1
    if [[ "${HYDE_ZSH_DEFER}" != "1" ]]; then
        unset -f _load_deferred_plugin_system_by_hyde
        return
    fi

    # Defer oh-my-zsh loading until after prompt appears
    # Load oh-my-zsh when line editor initializes // before user input
    if [[ -n $DEFER_OMZ_LOAD ]]; then
        unset DEFER_OMZ_LOAD
        [[ ${VSCODE_INJECTION} == 1 ]] || chmod -r $ZDOTDIR/.zshrc # let vscode read .zshrc
        zle -N zle-line-init _defer_omz_after_prompt_before_input  # Loads when the line editor initializes // The best option
    fi
    #  Below this line are the commands that are executed after the prompt appears

    # autoload -Uz add-zsh-hook
    # add-zsh-hook zshaddhistory load_omz_deferred # loads after the first command is added to history
    # add-zsh-hook precmd load_omz_deferred # Loads when shell is ready to accept commands
    # add-zsh-hook preexec load_omz_deferred # Loads before the first command executes

    # TODO: add handlers in pm.sh
    # for these aliases please manually add the following lines to your .zshrc file.(Using yay as the aur helper)
    # pc='yay -Sc' # remove all cached packages
    # po='yay -Qtdq | ${PM_COMMAND[@]} -Rns -' # remove orphaned packages

    # zsh-autosuggestions won't work on first prompt when deferred
    if typeset -f _zsh_autosuggest_start >/dev/null; then
        _zsh_autosuggest_start
    fi

    # Some binds won't work on first prompt when deferred
    bindkey '\e[H' beginning-of-line
    bindkey '\e[F' end-of-line

}

function do_render {
    # Check if the terminal supports images
    local type="${1:-image}"
    # TODO: update this list if needed
    TERMINAL_IMAGE_SUPPORT=(kitty konsole ghostty WezTerm)
    local terminal_no_art=(vscode code codium)
    TERMINAL_NO_ART="${TERMINAL_NO_ART:-${terminal_no_art[@]}}"
    CURRENT_TERMINAL="${TERM_PROGRAM:-$(ps -o comm= -p $(ps -o ppid= -p $$))}"

    case "${type}" in
    image)
        if [[ " ${TERMINAL_IMAGE_SUPPORT[@]} " =~ " ${CURRENT_TERMINAL} " ]]; then
            return 0
        else
            return 1
        fi
        ;;
    art)
        if [[ " ${TERMINAL_NO_ART[@]} " =~ " ${CURRENT_TERMINAL} " ]]; then
            return 1
        else
            return 0
        fi
        ;;
    *)
        return 1
        ;;
    esac
}

function _load_compinit() {
    # Initialize completions with optimized performance
    autoload -Uz compinit

    # Enable extended glob for the qualifier to work
    setopt EXTENDED_GLOB

    # Fastest - use glob qualifiers on directory pattern
    if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+${HYDE_ZSH_COMPINIT_CHECK:-1}) ]]; then
        compinit
    else
        compinit -C
    fi

    _comp_options+=(globdots) # tab complete hidden files
}

function _load_prompt() {
    # Try to load prompts immediately
    if ! source ${ZDOTDIR}/prompt.zsh >/dev/null 2>&1; then
        [[ -f $ZDOTDIR/conf.d/hyde/prompt.zsh ]] && source $ZDOTDIR/conf.d/hyde/prompt.zsh
    fi
}

# Override this environment variable in ~/.zshrc
# cleaning up home folder
# ZSH Plugin Configuration

HYDE_ZSH_DEFER="1"      #Unset this variable in $ZDOTDIR/user.zsh to disable HyDE's deferred Zsh loading.
HYDE_ZSH_PROMPT="1"     #Unset this variable in $ZDOTDIR/user.zsh to disable HyDE's prompt customization.
HYDE_ZSH_NO_PLUGINS="0" #Set this variable to "1" in $ZDOTDIR/user.zsh to disable HyDE's Zsh plugin loading.

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# # History configuration
HISTFILE=${HISTFILE:-$ZDOTDIR/.zsh_history}
if [[ -f $HOME/.zsh_history ]] && [[ ! -f $HISTFILE ]]; then
    echo "Please manually move $HOME/.zsh_history to $HISTFILE"
    echo "Or move it somewhere else to avoid conflicts"
fi
HISTSIZE=10000
SAVEHIST=10000


export HISTFILE ZSH_AUTOSUGGEST_STRATEGY HISTSIZE SAVEHIST

# HyDE Package Manager (Linux only - hyde-shell pm doesn't exist on macOS)
if [[ -n $IS_LINUX ]]; then
    PM_COMMAND=(hyde-shell pm)
else
    # macOS: Use brew as the package manager
    PM_COMMAND=(brew)
fi

# Optionally load user configuration // useful for customizing the shell without modifying the main file
if [[ -f $HOME/.hyde.zshrc ]]; then
    source $HOME/.hyde.zshrc # for backward compatibility
elif [[ -f $HOME/.user.zsh ]]; then
    source $HOME/.user.zsh # renamed to .user.zsh for intuitiveness that it is a user config
elif [[ -f $ZDOTDIR/user.zsh ]]; then
    source $ZDOTDIR/user.zsh
fi

_load_compinit

if [[ ${HYDE_ZSH_NO_PLUGINS} != "1" ]]; then
    _dedup_zsh_plugins
    if [[ "$HYDE_ZSH_OMZ_DEFER" == "1" ]] && [[ -r $ZSH/oh-my-zsh.sh ]]; then
        # Loads the buggy deferred oh-my-zsh plugin system by HyDE // This is only for oh-my-zsh and compatibility
        _load_deferred_plugin_system_by_hyde
        _load_prompt # This disables transient prompts sadly
    elif source $ZDOTDIR/plugin.zsh >/dev/null 2>&1; then
        # Load plugins from the user's plugin.zsh file
        # This is useful for users who want to use their own plugin system
        source $ZDOTDIR/plugin.zsh
        _load_prompt
        _load_functions
        _load_completions
    elif [[ -r $ZSH/oh-my-zsh.sh ]]; then
        # Load oh-my-zsh if it exists in the ZSH directory
        #  Default if the $ZDOTDIR/plugin.zsh file does not exist or returns an error
        source $ZSH/oh-my-zsh.sh
        _load_prompt
        _load_functions
        _load_completions
    else
        echo "No plugin system found. Please install a plugin system or create a $ZDOTDIR/plugin.zsh file."
        echo "You can use $ZDOTDIR/plugin.zsh file to load your own plugins."
    fi
else
    # Load user plugins if they exist
    # Assumes user has a plugin.zsh file in their $ZDOTDIR
    [[ -r $ZDOTDIR/plugin.zsh ]] && source $ZDOTDIR/plugin.zsh
    _load_prompt
    _load_functions
    _load_completions
fi

__package_manager () { 
    ${PM_COMMAND[@]} "$@"
}

# OS-specific aliases
if [[ -n $IS_LINUX ]]; then
    # Linux: hyde-shell pm aliases
    alias in='__package_manager install' \
          un='__package_manager remove' \
          up='__package_manager upgrade' \
          pl='__package_manager search installed' \
          pa='__package_manager search all'
else
    # macOS: brew aliases
    alias in='brew install' \
          un='brew uninstall' \
          up='brew upgrade' \
          pl='brew list' \
          pa='brew search'
fi

# Common aliases (both platforms)
alias c='clear' \
    vc='code' \
    ..='cd ..' \
    ...='cd ../..' \
    .3='cd ../../..' \
    .4='cd ../../../..' \
    .5='cd ../../../../..' \
    mkdir='mkdir -p'

# fastfetch alias (check if installed and adjust for terminal)
if command -v fastfetch >/dev/null 2>&1; then
    if [[ -n $IS_MACOS ]]; then
        alias fastfetch='fastfetch'
    else
        alias fastfetch='fastfetch --logo-type kitty'
    fi
fi

