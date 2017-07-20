# My ~/.zshrc file
#
# Many functions taken or modified from online sources, including:
#   https://gist.github.com/zanshin/1142739
#   https://stackoverflow.com/questions/171563/whats-in-your-zshrc
#   https://matt.blissett.me.uk/linux/zsh/zshrc
#   https://wiki.archlinux.org/index.php/zsh
#
# Some functions copied from the default .bashrc on my Ubuntu 16.04
#
#
# Remember to always check your TODO's! :)
#
# Last updated: 2017-07-19
#


# Skip everything for non-interactive shells (from .bashrc)
case $- in
    *i*) ;;
      *) return ;;
esac
# better than the following?
#[[ -z "$PS1" ]] && return


# a note on "autoload" syntax:
#   "autoload": marks a name as being a function rather than an external program
#   "-U": marks the function for autoloading and suppresses alias expansion
#   "-z": means use zsh (rather than ksh) style
# (pretty much always use "autoload -Uz")




# ----------------------------------------------------------------------
# misc options:
# ----------------------------------------------------------------------
# for some reason some of these options need to be called at the beginning
#   for history searching to work right (TODO: figure that out)

# use in vim mode
bindkey -v

# beep on error in zle
setopt beep

# DON'T:
#   cd into a directory with "$ valid-dir" (instead of "$ cd valid-dir") 
#   if "valid-dir" is not a normal command
unsetopt auto_cd

# treat the "#", "~" and "^" characters as part of patterns for filename generation, etc
#   (An initial unquoted "~" always produces named directory expansion)
setopt extended_glob

# if a pattern for filename generation has no matches, print an error,
#   instead of leaving it unchanged in the argument list.
#   this also applies to file expansion of an initial "~" or "="
setopt nomatch

# report the status of background jobs immediately, rather than waiting until
#   just before printing a prompt
setopt notify


# make less more friendly for non-text input files, see lesspipe(1) (from .bashrc)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

watch=notme
export LOGCHECK=60



export PATH="$PATH:$HOME/.local/bin"





# ----------------------------------------------------------------------
# enable "help":
# ----------------------------------------------------------------------
# zsh's "help" (called "run-help") is not enabled by default

# run-help will invoke man for external commands
autoload -Uz run-help
unalias run-help 2> /dev/null
alias help="run-help"
# run-help has helper functions, they need to be enabled separately
# For example "run-help git commit" command will now open the man page "git-commit(1)" instead of "git(1)"
autoload -Uz run-help-git
autoload -Uz run-help-ip
autoload -Uz run-help-openssl
autoload -Uz run-help-p4
autoload -Uz run-help-sudo
autoload -Uz run-help-svk
autoload -Uz run-help-svn




# ----------------------------------------------------------------------
# history:
# ----------------------------------------------------------------------

HISTFILE=~/.zsh_hist
HISTSIZE=8192
SAVEHIST=8192


# searching history:
#   commands are added to $HISTFILE immediately as they are executed (actually, just before execution)
#   Up/Down searches local history (TODO: how is this done?)
#   Up/Down with a non-empty buffer searches (local) history only for strings starting with buffer

# saves history entries as ": <beginning time>:<elapsed seconds>;<command>"
setopt extended_history
# append every command to history as it's entered (but before executed)
setopt inc_append_history

# searching the history:
# only the past commands matching the current line up to the current cursor position will be shown with up/down
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "$key[Up]"   ]] && bindkey -- "$key[Up]"   up-line-or-beginning-search
[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search

# TODO: figure out keybindings ("$key[...]" or "$terminfo[...]"??)
# TODO: made [Shift+Up/Down] search global history (might need to re-import $HISTFILE? does this break local history?)


# -- NOT USED RIGHT NOW. JUST FOR REFERENCE: --
# like INC_APPEND_HISTORY and EXTENDED_HISTORY and all terminals share history
#setopt share_history


# ----------------------------------------------------------------------
# prompt themes:
# ----------------------------------------------------------------------

autoload -Uz promptinit
promptinit
prompt adam1

# TODO: get better prompts with oh-my-zsh!!


# ----------------------------------------------------------------------
# enable some color support:
# ----------------------------------------------------------------------

# copied from .bashrc
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval `dircolors -b ~/.dircolors` || eval `dircolors -b`
    alias ls="ls --color=auto"
    alias grep="grep --color=auto"
fi



# ----------------------------------------------------------------------
# ease of use aliases and functions:
# ----------------------------------------------------------------------

alias ll="ls -halF"
alias quit="exit"
alias qq="quit"
alias dus="du -cksx | sort -nr"
alias cd..="cd .."

# a simple save/recall directory
sd() { pwd > ~/.save-dir ; }
rd() { cd "$(cat ~/.save-dir)" ; }



# just for fun
alias adventure="emacs -batch -l dunnet"




# ----------------------------------------------------------------------
# set default editor:
# ----------------------------------------------------------------------

if [[ -x `which vim 2> /dev/null` ]]; then
    export EDITOR="vim"
    export USE_EDITOR=$EDITOR
    export VISUAL=$EDITOR
fi
# use "sudo update-alternatives --config editor" to change /usr/bin/editor



# ----------------------------------------------------------------------
# say how long a command took if more than __ seconds:
# ----------------------------------------------------------------------

export REPORTTIME=10



# ----------------------------------------------------------------------
# make some things less dangerous:
# ----------------------------------------------------------------------

# prompt for confirmation after "rm *..."
# helps avoid "rm * o" when "rm *.o" was intended
setopt rm_star_wait

# require some interactivity and verbose-ness for some "dangerous" GNU fileutils
alias rm="rm -iv"
alias mv="mv -iv"
alias cp="cp -iv"
alias chmod="chmod -v"
alias chown="chown -v"
alias rename="rename -v"

# zmv allows mv with pattern matching (man zshcontrib)
autoload -Uz zmv
alias zmv="zmv -iv"


# disable "r" (repeat last command) in zsh
alias r="echo Sorry, \'r\' is disabled in this \"~/.zshrc\". Please use the full \'fc -e -\'. Consult \'man zshbuiltins\'."



# ----------------------------------------------------------------------
# completion options:
# ----------------------------------------------------------------------

zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit



