#!/usr/bin/bash

BIND_PJ=~/projects
PJ_BASH=${BIND_PJ}/010_bash
PJ_PYTHON=${BIND_PJ}/020_python
PJ_PWSH=${BIND_PJ}/030_pwsh
PJ_SPHINX=${BIND_PJ}/040_sphinx
PJ_HUGO=${BIND_PJ}/050_hugo
PJ_TF=${BIND_PJ}/060_Terraform
PJ_CFN=${BIND_PJ}/070_CloudFormation
PJ_OTHER=${BIND_PJ}/900_other

### ディレクトリ作成
echo "Step1: mkdir"
[ ! -d ${BIND_PJ} ] && mkdir -p ${BIND_PJ}
[ ! -d ${PJ_BASH} ] && mkdir -p ${PJ_BASH}
[ ! -d ${PJ_PYTHON} ] && mkdir -p ${PJ_PYTHON}
[ ! -d ${PJ_PWSH} ] && mkdir -p ${PJ_PWSH}
[ ! -d ${PJ_SPHINX} ] && mkdir -p ${PJ_SPHINX}
[ ! -d ${PJ_HUGO} ] && mkdir -p ${PJ_HUGO}
[ ! -d ${PJ_TF} ] && mkdir -p ${PJ_TF}
[ ! -d ${PJ_CFN} ] && mkdir -p ${PJ_CFN}
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

SPHINX_CONFIG=${PJ_SPHINX}/.vscode
[ -d ${SPHINX_CONFIG} ] && rm -rf ${SPHINX_CONFIG}
mkdir -p ${SPHINX_CONFIG}
cat <<"EOF" >${SPHINX_CONFIG}/settings.json
{
  "VsCodeTaskButtons.showCounter": true,
  "VsCodeTaskButtons.tasks": [
    {
      "label": "🧹Clean",
      "tasks": [
        {
          "label": "📦 Clean-Artifact",
          "task": "Clean-Af"
        }
      ]
    },
    {
      "label": "🌐$(debug-start) Start-SV",
      "task": "Start-SV"
    },
    {
      "label": "🌐$(debug-stop) Stop-SV",
      "task": "Stop-SV"
    },
    {
      "label": "🔧 Build",
      "task": "Build"
    },
    {
      "label": "$(git-fetch)$(mark-github) Sync-Git",
      "task": "Sync-Git"
    }
  ]
}
EOF

cat <<"EOF" >${SPHINX_CONFIG}/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Clean-Af",
      "type": "shell",
      "command": "echo \"rm -rf %BUILDDIR% %LIVEBUILDDIR% %LOCKFILE%\""
    },
    {
      "label": "Start-SV",
      "type": "shell",
      "command": "echo \"sphinx-autobuild -b html %SOURCEDIR% %LIVEBUILDDIR%\""
    },
    {
      "label": "Stop-SV",
      "type": "shell",
      "command": "echo \"killall -9 sphinx-autobuild\""
    },
    {
      "label": "Build",
      "type": "shell",
      "command": "echo \"sphinx-build -b html %SOURCEDIR% %BUILDDIR%\""
    },
    {
      "label": "Sync-Git",
      "type": "shell",
      "command": "echo \"git checkout default && git pull origin main && git checkout %ACTUAL% && git merge default %ACTUAL%\""
    }
  ]
}
EOF

HUGO_CONFIG=${PJ_HUGO}/.vscode
[ -d ${HUGO_CONFIG} ] && rm -rf ${HUGO_CONFIG}
mkdir -p ${HUGO_CONFIG}
cat <<"EOF" >${HUGO_CONFIG}/settings.json
{
  "VsCodeTaskButtons.showCounter": true,
  "VsCodeTaskButtons.tasks": [
    {
      "label": "🧹Clean",
      "tasks": [
        {
          "label": "📦 Clean-Artifact",
          "task": "Clean-Af"
        }
      ]
    },
    {
      "label": "🌐$(debug-start) Start-SV",
      "task": "Start-SV"
    },
    {
      "label": "🌐$(debug-stop) Stop-SV",
      "task": "Stop-SV"
    },
    {
      "label": "$(git-fetch)$(mark-github) Sync-Git",
      "task": "Sync-Git"
    }
  ]
}
EOF

cat <<"EOF" >${HUGO_CONFIG}/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Clean-Af",
      "type": "shell",
      "command": "echo \"rm -rf %LIVEBUILDDIR% .hugo_build.lock\""
    },
    {
      "label": "Start-SV",
      "type": "shell",
      "command": "echo \"hugo server --bind=\\\"0.0.0.0\\\" -b=\\\"%LIVEBUILDURL%\\\" --gc --ignoreCache --watch\""
    },
    {
      "label": "Stop-SV",
      "type": "shell",
      "command": "echo \"killall -9 hugo && rm -rf .hugo_build.lock\""
    },
    {
      "label": "Sync-Git",
      "type": "shell",
      "command": "echo \"git checkout default && git pull origin main && git checkout %ACTUAL% && git merge default %ACTUAL%\""
    }
  ]
}
EOF

exit 0
