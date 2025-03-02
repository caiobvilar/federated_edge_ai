
FROM ubuntu:focal

LABEL maintainer="Caio J. B. V. Guimaraes <caio.b.vilar@gmail.com>"

###### ARGUMENTS ######
ARG username
ARG UID
ARG GID
ARG PW=docker

# Update and upgrade packages
RUN apt update && apt upgrade -y

# Configure time zone and tzdata
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt install -y \
    tzdata \
    locales \
    apt-utils \
    build-essential \
    manpages-dev \
    zsh \
    vim \
    cmake \
    python3 \
    libpython3-dev \
    python3-pip \
    python3-venv \
    pipx \
    git \
    sudo \
    curl \
    wget \
    unzip \
    tar \
    xz-utils \
    libtool \
    automake \
    autoconf \
    htop \
    clang-format \
    gdb \
    libusb-1.0-0-dev

RUN locale-gen en_US.UTF-8
RUN pipx install pip && pipx upgrade pip && pipx install conan

###### USER CONFIGURATION ######

# Adding user
RUN useradd --create-home --shell /usr/bin/zsh ${username} --uid=${UID} && echo "${username}:${PW}" | chpasswd && adduser ${username} sudo
RUN usermod --append --groups video ${username}
RUN usermod --append --groups audio ${username}

###### INSTALLATION WITH DOWNLOADS ######

# Setting Downloads folder
WORKDIR /home/${username}
RUN mkdir /home/${username}/Downloads
WORKDIR /home/${username}/Downloads

WORKDIR /root
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN rm /root/.zshrc
RUN ln -s /home/${username}/.zshrc /root/.zshrc
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
RUN chsh -s $(which zsh)

###### USER CONFIGURATION ######

# Changing owner of the home folders
RUN chown ${UID} /home/${username}/Downloads
RUN chgrp ${GID} /home/${username}/Downloads

# Setup SSH keys
RUN mkdir /home/${username}/.ssh
RUN chown ${UID} /home/${username}/.ssh
RUN chgrp ${GID} /home/${username}/.ssh
RUN chmod 700 /home/${username}/.ssh

# Setup user
USER ${UID}:${GID}

# Setup bash
WORKDIR /home/${username}
ENV color_prompt=yes
RUN rm /home/${username}/.bashrc

#Setup OM-MY-ZSH for user
WORKDIR /home/${username}
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN rm /home/${username}/.zshrc
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/${username}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /home/${username}/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# Setup powerline fonts
WORKDIR /home/${username}/Downloads
RUN git clone https://github.com/powerline/fonts.git --depth=1
WORKDIR /home/${username}/Downloads/fonts
RUN ./install.sh
WORKDIR /home/${username}/Downloads
RUN rm -rf /home/${username}/Downloads/fonts

# Setup XAuth
RUN touch /home/${username}/.Xauthority

# Setup user home folder and entrypoint details
WORKDIR /home/${username}
ENTRYPOINT [ "/usr/bin/zsh" ]