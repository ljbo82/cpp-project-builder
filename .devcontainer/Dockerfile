FROM ubuntu:22.04

ARG USER=developer

# -- Base system ---------------------------------------------------------------
RUN apt update && \
    apt install -y \
        sudo \
        locales \
        locales-all \
        bash-completion \
        nano && \
    apt clean

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

RUN useradd -ms /bin/bash $USER && \
    usermod -aG sudo $USER && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# ------------------------------------------------------------------------------

# -- Project dependencies ------------------------------------------------------
RUN apt install -y \
        build-essential \
        python3 \
        python3-pip \
        gcc-mingw-w64-x86-64 \
        gdb \
        graphviz \
        git \
        libcpputest-dev

RUN pip3 install \
    mkdocs \
    mkdocs-mermaid2-plugin
# ------------------------------------------------------------------------------

# -- User setup ----------------------------------------------------------------
USER $USER
ENV USER=$USER
ENV HOME=/home/$USER
WORKDIR $HOME

RUN echo "PATH=\"\$HOME/.local/bin:\$PATH\"" >> ~/.bashrc && \
    echo "alias ls='ls -l --color=auto --group-directories-first'" >> ~/.bashrc
# ------------------------------------------------------------------------------

CMD /bin/bash
