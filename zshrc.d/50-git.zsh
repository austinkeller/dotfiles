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
