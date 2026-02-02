#
# Miscellaneous tools
#

#
# GPG
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

#
# SSH
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

# Skip rl function in Claude Code due to shell snapshot parsing issues with jq interpolation syntax
if [[ -z "${CLAUDECODE}" ]]; then
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
fi
