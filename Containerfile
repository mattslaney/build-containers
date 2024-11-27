ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

RUN apt update && \
    apt install -y git build-essential gcc cmake autotools-dev \
                   vim tmux

WORKDIR /app

CMD ["/app/build.sh"]

