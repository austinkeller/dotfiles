#
# History and core shell options
#

HISTFILE=~/.zsh_history
HISTSIZE=1000000000
SAVEHIST=$HISTSIZE
setopt appendhistory autocd nomatch notify
unsetopt beep
bindkey -e

# For Python Poetry completions
fpath+=~/.zfunc
