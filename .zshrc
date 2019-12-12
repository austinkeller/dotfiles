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

function rl() {
    ## rl: read log
    ## journalctl wrapper with nice output format and colors based on log event severity.
    ## The order is for human consumption only so they are just based on RFC 5424 (without being compliant) and the default journalctl short-iso format.
    ## The syslog severity is added. This one is missing in all common log formats or not human readable (RFC 5424).
    ## The time format is based on systemd.time(7) and RFC 3339.
    ## The colors are made up by ypid because I could not find a proper standard.
    ## Ref: https://serverfault.com/questions/59262/bash-print-stderr-in-red-color/502019#502019
    ## Ref: https://serverfault.com/questions/801514/systemd-default-log-output-format

    # shellcheck disable=SC2016
    command journalctl "$@" -o json \
        | jq --unbuffered --raw-output '"echo \(.PRIORITY|tonumber|@sh) \"$(date --date @\((._SOURCE_REALTIME_TIMESTAMP // .__REALTIME_TIMESTAMP) |tonumber | ./ 1000000 | tostring) '\''+%F %T %Z'\'')\" \(._HOSTNAME|@sh) \(.SYSLOG_IDENTIFIER|@sh): \(.MESSAGE|@sh) "' \
        | sh \
        | perl -e 'my $c_to_sev = {0 => "48;5;9", 1 => "48;5;5", 2 => "38;5;9", 3 => "38;5;1", 4 => "38;5;5", 5 => "38;5;2", 6 => "38;5;2"}; while (<>) { s#^(([0-6])(?: [^ ]+){5})(.*)#\e[$c_to_sev->{$2}m$1\e[m$3#; print; }'
}

# Docker commands
alias dcl='docker-compose logs -f --tail=1 &'
alias dup='docker-compose up -d && dcl'

# Git commands
alias g='git'
alias ga='git add'
alias gb='git branch -va'
alias gc='git commit'
alias gca='git commit -a'
alias gcam='git commit -a -m'
alias gcm='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gdh='git diff HEAD'
alias gds='git diff --staged'
alias gpl='git pull'
alias glt='git ls-tree --full-tree -r HEAD'
alias gp='git push'
alias gpu='branch=$(git branch | grep "\*" | awk "{ print \$2 }"); git push --set-upstream origin $branch'
alias gr='git remote -v'
alias gst='git status'

# Useful test for breaking dependencies
function is_bin_in_path {
  builtin whence -p "$1" &> /dev/null
}

############################################################################
# pacman wrappers
############################################################################
if is_bin_in_path powerpill
then
  # Speed up yay with concurrent downloads using powerpill
  alias yay='yay --pacman powerpill'

  # Add alias `pac` for running pacmatic wrapping yay wrapping powerpill
  # See https://unix.stackexchange.com/questions/384101/have-pacmatic-wrap-yay-wrap-powerpill-wrap-pacman
  if is_bin_in_path pacmatic
  then
    # pacmatic needs to be run as root: https://github.com/keenerd/pacmatic/issues/35
    alias pacmatic='sudo --preserve-env=pacman_program /usr/bin/pacmatic'

    # Downgrade permissions as AUR helpers expect to be run as a non-root user. $UID is read-only in {ba,z}sh.
    alias pac='pacman_program="sudo -u #$UID /usr/bin/yay --pacman powerpill" pacmatic'
  else
    echo "Install pacmatic. See ~/.zshrc for more detail."
  fi
else
  echo "Install powerpill. See ~/.zshrc for more detail."
fi
############################################################################

# Add diff-highlight to path and verify
export PATH=$PATH:/usr/share/git/diff-highlight
is_bin_in_path diff-highlight || echo "diff-highlight not found, fix your .zshrc"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ~/.p10k.zsh

# Add local bin
export PATH=$PATH:$HOME/.local/bin

function source_asdf {
  # Setting for [asdf-vm](https://github.com/asdf-vm/asdf)
  . $HOME/.asdf/asdf.sh
  . $HOME/.asdf/completions/asdf.bash
}

if source_asdf
then
  # Make poetry work with asdf install
  alias poetry='python -m poetry'
else
  echo "Missing asdf"
  echo "See ~/.zshrc"
  echo "To install, see https://asdf-vm.com/#/core-manage-asdf-vm?id=install-asdf-vm"
fi

############################################################################
# Add custom zsh configurations that only apply to this system
############################################################################
[[ -f ~/.zshrc_conda ]] && . ~/.zshrc_conda || true

############################################################################
# Smartsheet-specific configuration
############################################################################
[[ -f ~/.zshrc_smartsheet ]] && . ~/.zshrc_smartsheet || true
