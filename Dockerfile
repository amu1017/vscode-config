# syntax=docker/dockerfile:1.7
FROM debian:12

# ============パッケージインストール作業============
USER root

# OSパッケージリポジトリ設定
COPY <<-EOF /etc/apt/sources.list
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware
EOF
RUN rm -rf /etc/apt/sources.list.d/debian.sources

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
    ttf-mscorefonts-installer \
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

# OSパッケージインストール -汎用開発編-
RUN apt-get update && apt-get install -y \
    build-essential 

# OSパッケージインストール -python編-
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    python-is-python3

# OSパッケージインストール -Go編-
RUN apt-get update && apt-get install -y \
    golang \
    delve

# Pwshインストール
RUN wget -q https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb \
 && dpkg -i ./packages-microsoft-prod.deb \
 && apt-get update && apt-get install -y powershell \
 && rm -rf ./packages-microsoft-prod.deb

# AWS CLIインストール
RUN wget -q https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
 && unzip ./awscli-exe-linux-x86_64.zip \
 && ./aws/install -i /usr/local/aws-cli -b /usr/local/bin \
 && rm -rf ./awscli-exe-linux-x86_64.zip ./aws

# Hugoインストール
RUN wget -q https://github.com/gohugoio/hugo/releases/download/v0.128.0/hugo_extended_0.128.0_linux-amd64.deb \
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
RUN wget -q https://github.com/negset/Firple/releases/download/4.000/Firple.zip \
 && unzip ./Firple.zip  \
 && wget -q https://github.com/negset/Firple/releases/download/4.000/FirpleSlim.zip \
 && unzip ./FirpleSlim.zip  \
 && cp -vf ./Firple*.ttf /usr/local/share/fonts/ \
 && rm -rf ./Firple* \
 && fc-cache -r

# pandocインストール
RUN wget -q https://github.com/jgm/pandoc/releases/download/3.2.1/pandoc-3.2.1-linux-amd64.tar.gz \
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
RUN pip install --break-system-packages -r pip-common

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
RUN pip install --break-system-packages -r pip-sphinx

# pipインストール -Cfn-lint編-
COPY <<-EOF pip-cfn
cfn-lint
pydot
EOF
RUN pip install --break-system-packages -r pip-cfn

# ============OS基本設定作業============
USER root

# OS日本語設定

RUN apt-get update && apt-get install -y locales \
 && sed -i 's/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/g' /etc/locale.gen \
 && locale-gen \
 && echo "export LANG='ja_JP.UTF-8'" > /etc/profile.d/lang-jp.sh \
 && echo "export LC_ALL='ja_JP.UTF-8'" >> /etc/profile.d/lang-jp.sh \
 && echo "export LANGUAGE='ja_JP:ja'" >> /etc/profile.d/lang-jp.sh \
 && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# sudo可能な一般ユーザー作成
RUN groupadd -g 1000 group \
 && useradd -m -s /bin/bash -u 1000 -g 1000 -G sudo user \
 && echo "user:P@ssw0rd" | chpasswd \
 && echo "user   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# SSHサーバーの準備
RUN mkdir -p /var/run/sshd \
 && chmod 755 /var/run/sshd \
 && chown root.root /var/run/sshd \
 && ssh-keygen -A

# ホストOSとの共有フォルダ作成
RUN mkdir /host && chmod 1777 /host


# ============実行ユーザー作業============
USER user

# ホストOSとの共有フォルダのリンク
RUN ln -s /projects /home/user/projects

# SSHディレクトリの用意
RUN mkdir /home/user/.ssh/ \
 && chmod 700 /home/user/.ssh/ \
 && chown user:group /home/user/.ssh/

# ============起動設定============
USER root

# OSパッケージの不要ファイル掃除
RUN apt-get upgrade -y \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# 起動スクリプトを生成する。
COPY <<-EOF /etc/docker-entrypoint.sh
#!/bin/bash
# ----------------Start---------------
[ -n "$(cat /run/secrets/CHANGE_PW)" ] && echo "set user passwd" && echo "user:$(cat /run/secrets/CHANGE_PW)" | chpasswd
[ -n "$(cat /run/secrets/SSH_PUBKEY)" ] && echo "set ssh pubkey1" && echo "$(cat /run/secrets/SSH_PUBKEY)" > /home/user/.ssh/authorized_keys
[ -n "$(cat /run/secrets/SSH_PUBKEY)" ] && echo "set ssh pubkey2" && chmod 600 /home/user/.ssh/authorized_keys ; chown user:group /home/user/.ssh/authorized_keys
echo "start sshd"
/usr/sbin/sshd -D
# ----------------End-----------------
EOF
RUN chmod +x /etc/docker-entrypoint.sh

# 公開するポート
EXPOSE 22

# 起動時に実行するコマンド
CMD ["/etc/docker-entrypoint.sh"]
