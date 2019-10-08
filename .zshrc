# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000000000
SAVEHIST=$HISTSIZE
setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/akeller/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

bindkey '^R' history-incremental-search-backward

###########################################################
# From https://wiki.archlinux.org/index.php/Zsh#Key_bindings
############################################################
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[ShiftTab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[ShiftTab]}"  ]] && bindkey -- "${key[ShiftTab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start {
		echoti smkx
	}
	function zle_application_mode_stop {
		echoti rmkx
	}
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi
######################
# End key bindings fix
######################

function aws-env {
	##########################################################################
	# Convenience function for setting aws environment variables from
	#  ~/.aws/credentials
	###########################################################################

	local USAGE="$0 <profile-name>\nFor example: $0 default"

	if [ -z "$1" ]; then
		echo $USAGE
		return 1
	elif [[ $* == *-h* ]]; then
		echo $USAGE
		return 0
	else
		local PROFILE=$1
	fi

	export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id --profile $PROFILE)
	export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key --profile $PROFILE)
	export AWS_DEFAULT_REGION=$(aws configure get region --profile $PROFILE)
	# Set this so that powerlevel10k can display the current AWS profile
	export AWS_DEFAULT_PROFILE=$PROFILE
}

function aws-unset {
        unset AWS_ACCESS_KEY_ID
        unset AWS_SECRET_ACCESS_KEY
        unset AWS_DEFAULT_REGION
        unset AWS_DEFAULT_PROFILE
}

alias ls='ls --color -N'
alias ll='ls -lah --color=auto'

function is_bin_in_path {
  builtin whence -p "$1" &> /dev/null
}

# Add diff-highlight to path and verify
export PATH=$PATH:/usr/share/git/diff-highlight
is_bin_in_path diff-highlight || echo "diff-highlight not found, fix your .zshrc"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ~/.p10k.zsh

# Add local bin
export PATH=$PATH:$HOME/.local/bin

# setting for pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  export PYENV_ROOT="${HOME}/.pyenv"
  export PATH=${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}
  eval "$(pyenv init -)"
fi
# setting for pyenv-virtualenv
if command -v pyenv-virtualenv-init 1> /dev/null 2>&1; then eval "$(pyenv virtualenv-init -)"; fi

############################################################################
# Add custom zsh configurations that only apply to this system
############################################################################
[[ -f ~/.zshrc_conda ]] && . ~/.zshrc_conda || true

############################################################################
# Smartsheet-specific configuration
############################################################################
[[ -f ~/.zshrc_smartsheet ]] && . ~/.zshrc_smartsheet || true
