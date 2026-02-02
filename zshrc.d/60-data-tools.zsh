#
# Data engineering and analysis tools
#

function dbt {
  docker run -it --rm -v $PWD:/usr/app fishtownanalytics/dbt:0.16.1 dbt "$@"
}

# Skip these in Claude Code due to shell snapshot parsing issues with multi-line aliases and heredocs
if [[ -z "${CLAUDECODE}" ]]; then
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
fi

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
