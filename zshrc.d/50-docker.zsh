#
# Docker
#

alias dcl='docker-compose logs -f --tail=1 &'
alias dup='docker-compose up -d && dcl'

function docker-compose() {
  docker compose --compatibility "$@"
}
