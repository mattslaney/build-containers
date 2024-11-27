ARG BASE_IMAGE=ubuntu:latest
FROM ${BASE_IMAGE}

RUN apt update && \
    apt install -y git build-essential gcc cmake autotools-dev \
                   vim tmux

ENV BUILD_CONTAINER=true
ARG GIT_USER_NAME="builder"
ARG GIT_USER_EMAIL="builder@build-container.local"

RUN git config --global pull.rebase false && \
    git config --global user.name "$GIT_USER_NAME" && \
    git config --global user.email "$GIT_USER_EMAIL"

WORKDIR /app

CMD ["/app/build.sh"]

