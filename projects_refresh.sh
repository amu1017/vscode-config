#!/bin/bash

BIND_PJ=~/projects
PJ_BASH=${BIND_PJ}/01_bash
PJ_PYTHON=${BIND_PJ}/02_python
PJ_PWSH=${BIND_PJ}/03_pwsh
PJ_TF=${BIND_PJ}/04_tf
PJ_CFN=${BIND_PJ}/05_cfn
PJ_SPHINX=${BIND_PJ}/11_sphinx
PJ_M_PROD=${BIND_PJ}/12_masaru-prod
PJ_M_STA=${BIND_PJ}/13_masaru-staging
PJ_OTHER=${BIND_PJ}/99_other

### ディレクトリ作成
echo "Step1: mkdir"
[ ! -d ${BIND_PJ} ] && mkdir -p ${BIND_PJ}
[ ! -d ${PJ_BASH} ] && mkdir -p ${PJ_BASH}
[ ! -d ${PJ_PYTHON} ] && mkdir -p ${PJ_PYTHON}
[ ! -d ${PJ_PWSH} ] && mkdir -p ${PJ_PWSH}
[ ! -d ${PJ_TF} ] && mkdir -p ${PJ_TF}
[ ! -d ${PJ_CFN} ] && mkdir -p ${PJ_CFN}
[ ! -d ${PJ_SPHINX} ] && mkdir -p ${PJ_SPHINX}
[ ! -d ${PJ_M_PROD} ] && mkdir -p ${PJ_M_PROD}
[ ! -d ${PJ_M_STA} ] && mkdir -p ${PJ_M_STA}
[ ! -d ${PJ_OTHER} ] && mkdir -p ${PJ_OTHER}

# プロジェクト毎設定ファイル生成
echo "Step2: projects config create"
BASH_CONFIG=${PJ_BASH}/.vscode
[ -d ${BASH_CONFIG} ] && rm -rf ${BASH_CONFIG}
mkdir -p ${BASH_CONFIG}
cat <<"EOF" >${BASH_CONFIG}/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Bash: Current",
      "type": "bashdb",
      "request": "launch",
      "program": "${file}",
      "cwd": "${cwd}",
      "terminalKind": "integrated",
      "args": []
    }
  ]
}
EOF

PYTHON_CONFIG=${PJ_PYTHON}/.vscode
[ -d ${PYTHON_CONFIG} ] && rm -rf ${PYTHON_CONFIG}
mkdir -p ${PYTHON_CONFIG}
cat <<"EOF" >${PYTHON_CONFIG}/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Current",
      "type": "python",
      "request": "launch",
      "program": "${file}",
      "cwd": "${cwd}",
      "console": "integratedTerminal",
      "args": []
    }
  ]
}
EOF

PWSH_CONFIG=${PJ_PWSH}/.vscode
[ -d ${PWSH_CONFIG} ] && rm -rf ${PWSH_CONFIG}
mkdir -p ${PWSH_CONFIG}
cat <<"EOF" >${PWSH_CONFIG}/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Pwsh: Current",
      "type": "PowerShell",
      "request": "launch",
      "script": "${file}",
      "cwd": "${cwd}",
      "createTemporaryIntegratedConsole": false,
      "args": []
    }
  ]
}
EOF

M_PROD_CONFIG=${PJ_M_PROD}/.vscode
[ -d ${M_PROD_CONFIG} ] && rm -rf ${M_PROD_CONFIG}
mkdir -p ${M_PROD_CONFIG}
cat <<"EOF" >${M_PROD_CONFIG}/settings.json
{
  "VsCodeTaskButtons.showCounter": true, // タスクバーボタン数の表示を無効化
  "VsCodeTaskButtons.tasks": [
    // タスクバーボタンの設定
    {
      "label": "🧹Clean",
      "tasks": [
        {
          "label": "📦 Clean artifact",
          "task": "clean-af"
        }
      ]
    },
    {
      "label": "🌐$(debug-start) Start-SV",
      "task": "start-dev-sv"
    },
    {
      "label": "🌐$(debug-stop) Stop-SV",
      "task": "stop-dev-sv"
    },
    {
      "label": "$(git-fetch)$(mark-github) Sync-git",
      "task": "sync-git"
    }
  ]
}
EOF

cat <<"EOF" >${M_PROD_CONFIG}/page.code-snippets
{
  "Hugo Front Matter Default": {
    "prefix": ["hugo-dfm"],
    "description": "Default",
    "body": [
      "+++",
      "#テンプレート：デフォルト",
      "title = \"${1:***your title***}\"",
      "date = ${CURRENT_YEAR}-${CURRENT_MONTH}-${CURRENT_DATE}T${CURRENT_HOUR}:${CURRENT_MINUTE}:${CURRENT_SECOND}${CURRENT_TIMEZONE_OFFSET}",
      "draft = false",
      "#weight = 99 # 順番を意図的に変更したい場合は変更する",
      "categories = [\"General\", \"Tutorial\", \"Server\", \"Network\", \"Cloud\", \"Other\"]",
      "tags = [\"Author:あゆむ\", \"Level:${2|初級,中級,上級,超上級|}\", \"Type:${3|Handson,Knowledge|}\", \"${4:***tags***}\"]",
      "+++",
      "",
      "- [概要](#概要)",
      "",
      "## 概要",
      "",
      "xxx"
    ]
  },
  "Hugo Front Matter Handson": {
    "prefix": ["hugo-hfm"],
    "description": "Handson",
    "body": [
      "+++",
      "#テンプレート：ハンズオン",
      "title = \"${1:***your title***}\"",
      "date = ${CURRENT_YEAR}-${CURRENT_MONTH}-${CURRENT_DATE}T${CURRENT_HOUR}:${CURRENT_MINUTE}:${CURRENT_SECOND}${CURRENT_TIMEZONE_OFFSET}",
      "draft = false",
      "#weight = 99 # 順番を意図的に変更したい場合は変更する",
      "categories = [\"Tutorial\", \"Server\", \"Network\", \"Cloud\", \"Other\"]",
      "tags = [\"Author:あゆむ\", \"Level:${2|初級,中級,上級,超上級|}\", \"Type:Handson\", \"${3:***tags***}\"]",
      "+++",
      "",
      "- [概要](#概要)",
      "  - [本ハンズオンで身につくこと](#本ハンズオンで身につくこと)",
      "  - [出てくるコマンド／操作](#出てくるコマンド操作)",
      "  - [事前準備](#事前準備)",
      "- [ハンズオン](#ハンズオン)",
      "  - [xxx](#xxx)",
      "  - [yyy](#yyy)",
      "  - [zzz](#zzz)",
      "",
      "## 概要",
      "",
      "xxx",
      "",
      "### 本ハンズオンで身につくこと",
      "",
      "- xxx",
      "- yyy",
      "- zzz",
      "",
      "### 出てくるコマンド／操作",
      "",
      "- xxx",
      "- yyy",
      "- zzz",
      "",
      "### 事前準備",
      "",
      "- xxx",
      "- yyy",
      "- zzz",
      "",
      "## ハンズオン",
      "",
      "### xxx",
      "",
      "### yyy",
      "",
      "### zzz"
    ]
  },
  "Hugo Front Matter Knowledge": {
    "prefix": ["hugo-kfm"],
    "description": "Knowledge",
    "body": [
      "+++",
      "#テンプレート：ナレッジ",
      "title = \"${1:***your title***}\"",
      "date = ${CURRENT_YEAR}-${CURRENT_MONTH}-${CURRENT_DATE}T${CURRENT_HOUR}:${CURRENT_MINUTE}:${CURRENT_SECOND}${CURRENT_TIMEZONE_OFFSET}",
      "draft = false",
      "#weight = 99 # 順番を意図的に変更したい場合は変更する",
      "categories = [\"Tutorial\", \"Server\", \"Network\", \"Cloud\", \"Other\"]",
      "tags = [\"Author:あゆむ\", \"Level:${2|初級,中級,上級,超上級|}\", \"Type:Knowledge\", \"${3:***tags***}\"]",
      "+++",
      "",
      "- [概要](#概要)",
      "",
      "## 概要",
      "",
      "xxx"
    ]
  }
}
EOF

cat <<"EOF" >${M_PROD_CONFIG}/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "clean-af",
      "type": "shell",
      "command": "rm -rf public/* .hugo_build.lock"
    },
    {
      "label": "start-dev-sv",
      "type": "shell",
      "command": "hugo server --bind=\"0.0.0.0\" -b=\"https://vscode-hugo.home.xdr-s.net/\" --gc --ignoreCache --watch"
    },
    {
      "label": "stop-dev-sv",
      "type": "shell",
      "command": " killall -9 hugo && rm -rf .hugo_build.lock"
    },
    {
      "label": "sync-git",
      "type": "shell",
      "command": "git checkout default && git pull origin main && git checkout post/ayumu && git merge default post/ayumu"
    }
  ]
}
EOF

M_STA_CONFIG=${PJ_M_STA}/.vscode
[ -d ${M_STA_CONFIG} ] && rm -rf ${M_STA_CONFIG}
mkdir -p ${M_STA_CONFIG}
cat <<"EOF" >${M_STA_CONFIG}/settings.json
{
  "VsCodeTaskButtons.showCounter": true, // タスクバーボタン数の表示を無効化
  "VsCodeTaskButtons.tasks": [
    // タスクバーボタンの設定
    {
      "label": "🧹Clean",
      "tasks": [
        {
          "label": "📦 Clean artifact",
          "task": "clean-af"
        }
      ]
    },
    {
      "label": "🌐$(debug-start) Start-SV",
      "task": "start-dev-sv"
    },
    {
      "label": "🌐$(debug-stop) Stop-SV",
      "task": "stop-dev-sv"
    },
    {
      "label": "$(git-fetch)$(mark-github) Sync-git",
      "task": "sync-git"
    }
  ]
}
EOF

cat <<"EOF" >${M_STA_CONFIG}/page.code-snippets
{
  "Hugo Front Matter Default": {
    "prefix": ["hugo-dfm"],
    "description": "Default",
    "body": [
      "+++",
      "#テンプレート：デフォルト",
      "title = \"${1:***your title***}\"",
      "date = ${CURRENT_YEAR}-${CURRENT_MONTH}-${CURRENT_DATE}T${CURRENT_HOUR}:${CURRENT_MINUTE}:${CURRENT_SECOND}${CURRENT_TIMEZONE_OFFSET}",
      "draft = false",
      "#weight = 99 # 順番を意図的に変更したい場合は変更する",
      "categories = [\"General\", \"Tutorial\", \"Server\", \"Network\", \"Cloud\", \"Other\"]",
      "tags = [\"Author:あゆむ\", \"Level:${2|初級,中級,上級,超上級|}\", \"Type:${3|Handson,Knowledge|}\", \"${4:***tags***}\"]",
      "+++",
      "",
      "- [概要](#概要)",
      "",
      "## 概要",
      "",
      "xxx"
    ]
  },
  "Hugo Front Matter Handson": {
    "prefix": ["hugo-hfm"],
    "description": "Handson",
    "body": [
      "+++",
      "#テンプレート：ハンズオン",
      "title = \"${1:***your title***}\"",
      "date = ${CURRENT_YEAR}-${CURRENT_MONTH}-${CURRENT_DATE}T${CURRENT_HOUR}:${CURRENT_MINUTE}:${CURRENT_SECOND}${CURRENT_TIMEZONE_OFFSET}",
      "draft = false",
      "#weight = 99 # 順番を意図的に変更したい場合は変更する",
      "categories = [\"Tutorial\", \"Server\", \"Network\", \"Cloud\", \"Other\"]",
      "tags = [\"Author:あゆむ\", \"Level:${2|初級,中級,上級,超上級|}\", \"Type:Handson\", \"${3:***tags***}\"]",
      "+++",
      "",
      "- [概要](#概要)",
      "  - [本ハンズオンで身につくこと](#本ハンズオンで身につくこと)",
      "  - [出てくるコマンド／操作](#出てくるコマンド操作)",
      "  - [事前準備](#事前準備)",
      "- [ハンズオン](#ハンズオン)",
      "  - [xxx](#xxx)",
      "  - [yyy](#yyy)",
      "  - [zzz](#zzz)",
      "",
      "## 概要",
      "",
      "xxx",
      "",
      "### 本ハンズオンで身につくこと",
      "",
      "- xxx",
      "- yyy",
      "- zzz",
      "",
      "### 出てくるコマンド／操作",
      "",
      "- xxx",
      "- yyy",
      "- zzz",
      "",
      "### 事前準備",
      "",
      "- xxx",
      "- yyy",
      "- zzz",
      "",
      "## ハンズオン",
      "",
      "### xxx",
      "",
      "### yyy",
      "",
      "### zzz"
    ]
  },
  "Hugo Front Matter Knowledge": {
    "prefix": ["hugo-kfm"],
    "description": "Knowledge",
    "body": [
      "+++",
      "#テンプレート：ナレッジ",
      "title = \"${1:***your title***}\"",
      "date = ${CURRENT_YEAR}-${CURRENT_MONTH}-${CURRENT_DATE}T${CURRENT_HOUR}:${CURRENT_MINUTE}:${CURRENT_SECOND}${CURRENT_TIMEZONE_OFFSET}",
      "draft = false",
      "#weight = 99 # 順番を意図的に変更したい場合は変更する",
      "categories = [\"Tutorial\", \"Server\", \"Network\", \"Cloud\", \"Other\"]",
      "tags = [\"Author:あゆむ\", \"Level:${2|初級,中級,上級,超上級|}\", \"Type:Knowledge\", \"${3:***tags***}\"]",
      "+++",
      "",
      "- [概要](#概要)",
      "",
      "## 概要",
      "",
      "xxx"
    ]
  }
}
EOF

cat <<"EOF" >${M_STA_CONFIG}/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "clean-af",
      "type": "shell",
      "command": "rm -rf public/* .hugo_build.lock"
    },
    {
      "label": "start-dev-sv",
      "type": "shell",
      "command": "hugo server --bind=\"0.0.0.0\" -b=\"https://vscode-hugo.home.xdr-s.net/\" --gc --ignoreCache --watch"
    },
    {
      "label": "stop-dev-sv",
      "type": "shell",
      "command": " killall -9 hugo && rm -rf .hugo_build.lock"
    },
    {
      "label": "sync-git",
      "type": "shell",
      "command": "git checkout default && git pull origin main && git checkout post/ayumu && git merge default post/ayumu"
    }
  ]
}
EOF

exit 0
