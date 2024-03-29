# Uncomment to run zsh profiling. Run `zprof` to see results
#zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000000000
SAVEHIST=$HISTSIZE
setopt appendhistory autocd nomatch notify
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

# For Python Poetry completions
fpath+=~/.zfunc

if is_arch
then
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
fi

# Add local bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/bin

# Add snap bin
export PATH=$PATH:/snap/bin

# Useful test for breaking dependencies
function is_bin_in_path {
  builtin whence -p "$1" &> /dev/null
}

# Allows for overriding shell functions
function save_function {
  # Usage: save_function func new_func
  # From https://mharrison.org/post/bashfunctionoverride/
  local ORIG_FUNC="$(declare -f $1)"
  local NEWNAME_FUNC="$2${ORIG_FUNC#$1}"
  eval "$NEWNAME_FUNC"
}

#
# Add Android tools
#
export PATH=$PATH:$HOME/Android/Sdk/cmdline-tools/latest/bin

#
# AWS tools
#
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

# Enable shell autocompletion for eksctl
if is_bin_in_path eksctl; then
    source <(eksctl completion zsh)
fi



#
# System aliases and helpers
#

alias ls='ls --color -N'
alias ll='ls -lah --color=auto'

function rl {
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

#
# Docker
#
alias dcl='docker-compose logs -f --tail=1 &'
alias dup='docker-compose up -d && dcl'

function docker-compose() {
  docker compose --compatibility "$@"
}

#
# direnv
#
function _direnv_hook() {
  trap -- '' SIGINT;
  eval "$(direnv export zsh)";
  trap - SIGINT;
}
typeset -ag precmd_functions;
if [[ -z ${precmd_functions[(r)_direnv_hook]} ]]; then
  precmd_functions=( _direnv_hook ${precmd_functions[@]} )
fi
typeset -ag chpwd_functions;
if [[ -z ${chpwd_functions[(r)_direnv_hook]} ]]; then
  chpwd_functions=( _direnv_hook ${chpwd_functions[@]} )
fi

#
# Fzf
#
if is_arch
then
  if [[ -r /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
  fi

  if [[ -r /usr/share/fzf/completion.zsh ]]; then
    source /usr/share/fzf/completion.zsh
  fi
elif is_mac
then
  if [ -n "${commands[fzf-share]}" ]; then
    source "$(fzf-share)/key-bindings.zsh"
    source "$(fzf-share)/completion.zsh"
  fi
else
  if [[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
  fi

  if [[ -r /usr/share/doc/fzf/examples/completion.zsh ]]; then
    source /usr/share/doc/fzf/examples/completion.zsh
  fi
fi

#
# Git
#

# Fix so that zsh extendedglob doesn't interfere when using characters like ^
alias git='noglob git'

alias g='git'
alias gi='git'

function git-delete-merged-branches() {
  git --no-pager branch --format=%(refname:lstrip=2) --merged | egrep -v '^(\*|develop)$' | egrep -v "^($(git main))$" | xargs git branch -d
}

function git-issue-title-to-branch() {
  echo -n "Issue Title: "
  read _issue_title
  echo $_issue_title \
    | tr '[:upper:]' '[:lower:]' \
    | tr -d '`~!@#$%^&*()=+[]{}\|;:''",.<>/?\\' \
    | sed -E 's/[-_]/ /g' \
    | xargs \
    | sed -E 's/[[:space:]]/-/g'
}

#
# Go
#
export GOPATH=$HOME/go
# Add all $GOPATH/bin directories to path
export PATH="$PATH:${GOPATH//://bin:}/bin"

#
# Gpg
#
export GPG_TTY=$TTY

#
# IntelliJ Idea
#

if is_mac
then
  function intellij-idea {
    open -na "IntelliJ IDEA.app" --args "$@"
  }
fi


#
# Kubernetes
#
alias k='kubectl'

#
# Todoist
#
# Add completions for fzf
if [[ -r /usr/share/todoist/todoist_functions_fzf.sh ]]; then
    source /usr/share/todoist/todoist_functions_fzf.sh
fi

function todoist-review {
  curl https://gist.githubusercontent.com/austinkeller/7dfa4c39832c32c2246fbd32a2b9ef0b/raw/e851ae0a6172527f7cf5db59b18c17ecd4cae999/todoist_completed_tasks.sh | \
    sh -s $@
}

############################################################################
# Misc
############################################################################

#
# ssh
#
function ssh-keygen-ez {
  SCRIPT_NAME=$(basename $0)

  USAGE="$SCRIPT_NAME <key_name>\nFor example: $SCRIPT_NAME github ed25519-sk"

  if [ -z "$2" ]; then
    echo -e $USAGE
    return 1
  elif [[ $* == *-h* ]]; then
    echo $USAGE
    return 0
  fi
  _key_name="$1"
  _key_type="$2"
  ssh-keygen -o -t ${_key_type} -f ~/.ssh/id_${_key_type}_${_key_name} -C "${USER}@$(hostname) ${_key_name}"
}

#
# tmux
#
function tmux-fixssh {
  eval $(tmux show-env -s |grep '^SSH_')
}

#
# python-direnv-init
#
# Initializes directory with a new python virtualenv that is automatically
# loaded within the dir
function python-direnv-init {
  cat > .envrc << 'EOF'
export VIRTUAL_ENV=${XDG_CACHE_HOME:-~/.cache}/virtualenvs/$(basename $PWD)
export PATH="${VIRTUAL_ENV}/bin:$PATH"
python3 -m venv $VIRTUAL_ENV
EOF
}

#
# Data engineering
#

function dbt {
  docker run -it --rm -v $PWD:/usr/app fishtownanalytics/dbt:0.16.1 dbt "$@"
}

#
# Data analysis tools
#
alias rstudio='docker run \
  --rm \
  -d \
  -e PASSWORD=donthackmebro \
  -v $(pwd):/home/rstudio/work \
  -p 8787:8787 \
  rocker/verse:3.6.1'

function jupyter {
  docker build -t jupyter-akeller-zshrc:1.0.0 -<<'EOF'
FROM jupyter/scipy-notebook:latest
USER root

RUN apt-get update \
      && apt-get install -y \
      ssh \
      curl \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN fix-permissions $CONDA_DIR && \
          fix-permissions /home/$NB_USER

USER $NB_UID
EOF

  __PORT=${JUPYTER_PORT:=8888}

  docker run -it -d --rm \
    --name jupyter_zshrc_${__PORT} \
    -p ${__PORT}:8888 \
    -e JUPYTER_ENABLE_LAB=${JUPYTER_ENABLE_LAB:=yes} \
    -v "${SSH_AUTH_SOCK}":/ssh-agent \
    -e SSH_AUTH_SOCK=/ssh-agent \
     -v "${PWD}:/home/jovyan/work" \
    -w "/home/jovyan/work" \
    --shm-size 512m \
    jupyter-akeller-zshrc:1.0.0 "$@"
}

function jupyter-url {
  __PORT=${JUPYTER_PORT:=8888}
  docker logs jupyter_zshrc_${__PORT} | \
    command grep -m1 -o 'http://127.0.0.1:[0-9]*/.*?token=[0-9a-z]*' | \
    sed "s/127.0.0.1:[0-9]*/127.0.0.1:${__PORT}/"
}

function ml-workspace {
  __PORT=${ML_WORKSPACE_PORT:=8788}
  docker run \
    -d \
    --name "ml-workspace" \
    -v "${SSH_AUTH_SOCK}":/ssh-agent \
    -e SSH_AUTH_SOCK=/ssh-agent \
    -v "${PWD}:/workspace" \
    -e AUTHENTICATE_VIA_JUPYTER="donthackmebro" \
    --shm-size 512m \
    --restart always \
    -p ${__PORT}:8080 \
    mltooling/ml-workspace:0.8.7

  echo "starting ml-workspace at http://127.0.0.1:${__PORT}"
  xdg-open http://127.0.0.1:${__PORT}
}

############################################################################
# Add custom zsh configurations that only apply to this system
############################################################################
[[ -f ~/.zshrc_conda ]] && . ~/.zshrc_conda || true

############################################################################
# Smartsheet-specific configuration
############################################################################
[[ -f ~/.zshrc_smartsheet ]] && . ~/.zshrc_smartsheet || true

# To customize prompt, run `p10k configure` or edit ~/.dotfiles/.p10k.zsh.
[[ ! -f ~/.dotfiles/.p10k.zsh ]] || source ~/.dotfiles/.p10k.zsh
