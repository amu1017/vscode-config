# syntax=docker/dockerfile:1.7
FROM ubuntu:22.04

# ============パッケージインストール作業============
USER root

# 一時的にaptのインタラクティブモードをOFFにする
ARG DEBIAN_FRONTEND=noninteractive

# 通常版Ubuntuへ復元
RUN yes | unminimize

# OSパッケージインストール -基本編-
RUN apt-get update && apt-get install -y \
    vim \
    less \
    sudo \
    htop \
    expect \
    tree \
    acl \
    bash-completion \
    zip \
    unzip \
    gawk \
    psmisc \
    dos2unix \
    binutils \
    apt-utils \
    software-properties-common \
    apt-transport-https

# OSパッケージインストール -ネットワーク設定編-
RUN apt-get update && apt-get install -y \
    iputils-tracepath \
    iputils-ping \
    ca-certificates \
    bind9-utils \
    network-manager \
    net-tools \
    traceroute \
    nmap \
    netcat-openbsd \
    dnsutils

# OSパッケージインストール -ネットワークツール編-
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    telnet \
    nfs-common \
    smbclient \
    openssh-client \
    openssh-server \
    lynx

# OSパッケージインストール -フォント編-
RUN apt-get update && apt-get install -y \
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
 && fc-cache -r

# OSパッケージインストール -python編-
RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    python3-pip \
    python3-dev \
    python-is-python3

# OSパッケージインストール -Go編-
RUN apt-get update && apt-get install -y \
    golang \
    delve

# Pwshインストール
RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb \
 && dpkg -i ./packages-microsoft-prod.deb \
 && apt-get update && apt-get install -y powershell \
 && rm -rf ./packages-microsoft-prod.deb

# AWS CLIインストール
RUN wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
 && unzip ./awscli-exe-linux-x86_64.zip \
 && ./aws/install -i /usr/local/aws-cli -b /usr/local/bin \
 && rm -rf ./awscli-exe-linux-x86_64.zip ./aws

# Hugoインストール
RUN wget https://github.com/gohugoio/hugo/releases/download/v0.128.0/hugo_extended_0.128.0_linux-amd64.deb \
 && dpkg -i ./hugo_extended_0.128.0_linux-amd64.deb \
 && rm -rf ./hugo_extended_0.128.0_linux-amd64.deb

# Github CLIインストール
RUN mkdir -p -m 755 /etc/apt/keyrings \
 && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
 && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
 && apt-get update && apt-get install -y gh \
 && echo "eval \"\$(gh completion -s bash)\"" > /etc/profile.d/githubcli-completion.sh

# Terraform インストール
RUN wget -qO- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null  \
 && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list > /dev/null \
 && apt-get update && apt-get install -y terraform

# Firpleフォントインストール
RUN wget https://github.com/negset/Firple/releases/download/4.000/Firple.zip \
 && unzip ./Firple.zip  \
 && wget https://github.com/negset/Firple/releases/download/4.000/FirpleSlim.zip \
 && unzip ./FirpleSlim.zip  \
 && cp -vf ./Firple*.ttf /usr/local/share/fonts/ \
 && rm -rf ./Firple* \
 && fc-cache -r

# pandocインストール
RUN wget https://github.com/jgm/pandoc/releases/download/3.2.1/pandoc-3.2.1-linux-amd64.tar.gz \
 && tar xvzf ./pandoc-3.2.1-linux-amd64.tar.gz --strip-components 1 -C /usr/local/ \
 && rm -rf ./pandoc-3.2.1-linux-amd64.tar.gz

# wkhtmltopdfインストール
RUN apt-get update && apt-get install -y \
    wkhtmltopdf

# pipインストール -common編-
COPY <<-EOF pip-common
pip-search
numpy
pandas
matplotlib
seaborn
openpyxl
Pillow
EOF
RUN pip install -r pip-common \
 && rm -rf pip-common

# pipインストール -sphinx編-
COPY <<-EOF pip-sphinx
esbonio
Sphinx
sphinx-autobuild
sphinx-rtd-theme
mystmd
myst-parser
rst-to-myst
EOF
RUN pip install -r pip-sphinx \
 && rm -rf pip-sphinx

# pipインストール -Cfn-lint編-
COPY <<-EOF pip-cfn
cfn-lint
pydot
EOF
RUN pip install -r pip-cfn \
 && rm -rf pip-cfn

# ============OS設定============
USER root

# OS日本語設定
RUN apt-get update && apt-get install -y \
    language-pack-ja-base \
    language-pack-ja \
    locales \
    tzdata \
 && update-locale LANG=ja_JP.UTF8 \
 && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
 && dpkg-reconfigure --frontend noninteractive tzdata

# sudo可能な一般ユーザー作成
RUN groupadd -g 9999 group \
 && useradd -m -s /bin/bash -u 9999 -g 9999 -G sudo user \
 && echo "user:P@ssw0rd" | chpasswd \
 && echo "user   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# SSHサーバーの準備
RUN mkdir -p /var/run/sshd \
 && chmod 755 /var/run/sshd \
 && chown root:root /var/run/sshd \
 && ssh-keygen -A

# ユーザー用のSSHディレクトリ作成
RUN mkdir /home/user/.ssh/ \
 && chmod 0700 /home/user/.ssh/ \
 && chown user:group /home/user/.ssh/


# ============起動設定============
# OSパッケージの不要ファイル掃除
RUN apt-get upgrade -y \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# 起動スクリプトを生成する。
COPY <<-EOF /entrypoint.sh
#!/bin/bash
# ----------------Start---------------
if [ "$(stat -c '%u' /projects)" -ne 0 ] && [ "$(stat -c '%g' /projects)" -ne 9999 ]; then
    echo "set gid"
    groupmod -g "$(stat -c '%g' /projects)" "group"
    chgrp -R "$(stat -c '%g' /projects)" "/home/user"
fi
if [ "$(stat -c '%u' /projects)" -ne 0 ] && [ "$(stat -c '%u' /projects)" -ne 9999 ]; then
    echo "set uid"
    usermod -u "$(stat -c '%u' /projects)" "user"
fi
if [ -n "$(cat /run/secrets/CHANGE_PW)" ]; then
    echo "set user passwd"
    echo "user:$(cat /run/secrets/CHANGE_PW)" | chpasswd
fi
if [ -n "$(cat /run/secrets/SSH_PUBKEY)" ]; then
    echo "set ssh pubkey"
    echo "$(cat /run/secrets/SSH_PUBKEY)" > /home/user/.ssh/authorized_keys
    chmod 600 /home/user/.ssh/authorized_keys
    chown "$(stat -c '%u' /projects):$(stat -c '%g' /projects)" /home/user/.ssh/authorized_keys
fi
ln -s /projects /home/user/projects
echo "start sshd"
/usr/sbin/sshd -D
# ----------------End-----------------
EOF
RUN chmod +x /entrypoint.sh

# 公開するポート
EXPOSE 22

# 起動時に実行するコマンド
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
