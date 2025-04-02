# syntax=docker/dockerfile:1.7
FROM ubuntu:24.04

# ============パッケージインストール作業============
USER root

# 一時的にaptのインタラクティブモードをOFFにする
ARG DEBIAN_FRONTEND=noninteractive

# 日本語ミラーへ取得しに行く
RUN sed -ie 's#\/archive\.ubuntu#/jp.archive.ubuntu#g' /etc/apt/sources.list.d/ubuntu.sources \
    && rm -rf  /etc/apt/sources.list.d/ubuntu.sourcese

# 通常版Ubuntuへ復元
RUN yes | unminimize \
    && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/*

# OSパッケージインストール -基本編-
RUN apt update && apt install -y \
    vim \
    less \
    sudo \
    htop \
    expect \
    tree \
    acl \
    bash-completion \
    jq \
    zip \
    unzip \
    nkf \
    gawk \
    psmisc \
    dos2unix \
    sysstat \
    binutils \
    lsb-release \
    jq \
    gnupg \
    apt-utils \
    software-properties-common \
    apt-transport-https \
    && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/*

# OSパッケージインストール -ネットワーク編-
RUN apt update && apt install -y \
    iputils-tracepath \
    iputils-ping \
    ca-certificates \
    bind9-utils \
    net-tools \
    traceroute \
    nmap \
    netcat-openbsd \
    dnsutils \
    telnet \
    nfs-common \
    smbclient \
    cifs-utils \
    lynx \
    curl \
    git \
    wget \
    openssh-client \
    #openssh-server \
    && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/*

# OSパッケージインストール -フォント編-
RUN apt update && apt install -y \
    build-essential \
    fontconfig \
    fonts-noto-cjk \
    fonts-noto-cjk-extra \
    fonts-noto-color-emoji \
    fonts-ipaexfont \
    fonts-ipaexfont-gothic \
    fonts-ipaexfont-mincho \
    fonts-ipafont \
    fonts-ipafont-gothic \
    fonts-ipafont-mincho \
    fonts-ipamj-mincho \
    && fc-cache -r \
    && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/*

# OSパッケージインストール -python編-
RUN apt update && apt install -y \
    build-essential \
    python3 \
    python3-pip \
    python3-dev \
    python-is-python3 \
    && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/*

# OSパッケージインストール -Go編-
RUN apt update && apt install -y \
    golang \
    delve \
    && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/*

# Pwshインストール
RUN wget -q https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb \
    && dpkg -i ./packages-microsoft-prod.deb \
    && rm -rf ./packages-microsoft-prod.deb \
    && apt update && apt install -y powershell \
    && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/*

# AWS CLIインストール
RUN wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
    && unzip ./awscli-exe-linux-x86_64.zip \
    && ./aws/install -i /usr/local/aws-cli -b /usr/local/bin \
    && rm -rf ./awscli-exe-linux-x86_64.zip ./aws

# Github CLIインストール
RUN mkdir -p -m 755 /etc/apt/keyrings \
    && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update && apt install -y gh \
    && echo "eval \"\$(gh completion -s bash)\"" > /etc/profile.d/githubcli-completion.sh \
    && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/*

# Terraform インストール
RUN wget -qO- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null  \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list > /dev/null \
    && apt update && apt install -y terraform \
    && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/*

# Docker CLIインストール
RUN mkdir -p -m 755 /etc/apt/keyrings \
    && wget -qO- https://download.docker.com/linux/ubuntu/gpg | tee /etc/apt/keyrings/docker.asc > /dev/null \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt update && apt install -y --no-install-recommends docker-ce-cli docker-buildx-plugin \
    && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/*

# Firpleフォントインストール
RUN wget https://github.com/negset/Firple/releases/download/5.000/Firple.zip \
    && unzip ./Firple.zip  \
    && wget https://github.com/negset/Firple/releases/download/5.000/FirpleSlim.zip \
    && unzip ./FirpleSlim.zip  \
    && cp -vf ./Firple*.ttf /usr/local/share/fonts/ \
    && rm -rf ./Firple* \
    && fc-cache -r

# ============OS設定============
USER root

# OS日本語設定
RUN apt update && apt install -y \
    language-pack-ja-base \
    language-pack-ja \
    locales \
    tzdata \
    && update-locale LANG=ja_JP.UTF8 \
    && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/*

# sudo可能な一般ユーザー作成
RUN groupadd -g 9999 group \
    && useradd -m -s /bin/bash -u 9999 -g 9999 -G sudo user \
    && echo "user   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# ============起動設定============
# OSパッケージの不要ファイル掃除
RUN apt update \
    && apt upgrade -y \
    && apt autoremove -y \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# VSCODE用のフォルダ作成
RUN mkdir -p /home/user/.vscode-server \
    && chmod 0755 /home/user/.vscode-server \
    && chown user:group /home/user/.vscode-server

# 起動スクリプトを生成する。
COPY <<-"EOF" /onCreate.sh
#!/bin/bash
# ----------------Start---------------
DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)
PJ_UID=$(stat -c '%u' /workspace)
PJ_GID=$(stat -c '%g' /workspace)

if grep -q "docker" /etc/group; then
    echo "doceker groupmod"
    groupmod -g "${DOCKER_GID}" "docker"
else
    echo "docker groupadd"
    groupadd -g "${DOCKER_GID}" "docker"
    echo "docker usermod"
    usermod -aG docker user
fi
if [ "${PJ_GID}" -ne 0 ] && [ "${PJ_GID}" -ne 9999 ]; then
    echo "set gid ${PJ_GID}"
    groupmod -g "${PJ_GID}" "group"
    chgrp -R "${PJ_GID}" "/home/user"
fi
if [ "${PJ_UID}" -ne 0 ] && [ "${PJ_UID}" -ne 9999 ]; then
    echo "set uid ${PJ_UID}"
    usermod -u "${PJ_UID}" "user"
    # Home dir is auto change
fi
# ----------------End-----------------
EOF
RUN chmod +x /onCreate.sh
