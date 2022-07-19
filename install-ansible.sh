#!/usr/bin/env bash


# Definitions and variables
readonly SHOULD_UPGRADE_PIP=false
readonly SHOULD_UPGRADE_ANSIBLE=true
readonly SHOULD_UPGRADE_ANSIBLE_LINT=true

# Exit shell script immediately if failed and trace it
set -xe
# Available OS: Linux, MacOS
if [ "$(uname)" == 'Darwin' ]; then
  OS='Mac'
#elif [ $(expr substr "$os_name" 1 5) == 'Linux' ]; then
elif [ "$(printf %s, "$(uname -s)" | cut -c 1-5)" == 'Linux' ]; then
  OS='Linux'
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

# Installing pip
## To verify whether Python is already installed on your local system
which python3 >/dev/null 2>&1
if test $? -ne 0; then
    echo 'Unexpected error occurred: Failed to find python3 command'
    exit 1
fi
## To verify whether pip is already installed for your preferred Python
python3 -m pip -V >/dev/null 2>&1
if test $? -ne 0; then
    ## To enable a user to execute pip command if its command was not found
    echo 'Not found pip command and install it'
    python3 -m ensurepip >/dev/null
fi
## To upgrade pip if you want
if [ "${SHOULD_UPGRADE_PIP}" ]; then
    echo 'Upgarde pip if possible'
    python3 -m ensurepip --upgrade >/dev/null
fi
## Set systems python path
if test $OS = 'Mac'; then
    #python_version=$(ls "$HOME"/Library/Python/ | grep -e '3.*')
    python_version=$(find "$HOME"/Library/Python -type d -maxdepth 1 -not -name './*' | grep -o '[1-9].[1-9]*')
    export PATH="$HOME/Library/Python/${python_version}/bin:$PATH"
else
    export PATH="$HOME/.local/bin:$PATH"
fi

# Installing Ansible-base
## To verify whether ansible-base is already installed on your preferred Python
ansible --version >/dev/null 2>&1
if test $? -ne 0; then
    ## To enable a user to execute ansible-base command if its command was not found
    echo 'Not found ansible command and install it'
    python3 -m pip install --user ansible-base >/dev/null
fi
## To upgrade ansible-base if you want
if [ "${SHOULD_UPGRADE_ANSIBLE}" ]; then
    echo 'Upgrade ansible-base if possible'
    python3 -m pip install --upgrade --user ansible-base >/dev/null
fi
python3 -m pip list -v | grep ansible
ansible --version

# Installing Ansible-lint
has_ansible_lint=$(python3 -m pip show ansible-lint | grep -c 'Name: ansible-lint')
if test "$has_ansible_lint" -ne 1; then
    ## To enable a user to execute ansible-lint command if its command was not found
    echo 'Not found ansible-lint command and install it'
    python3 -m pip install --user ansible-lint >/dev/null
fi
## To upgrade ansible-lint if you want
if [ "${SHOULD_UPGRADE_ANSIBLE_LINT}" ]; then
    echo 'Upgrade ansible-lint if possible'
    python3 -m pip install --upgrade --user ansible-lint >/dev/null
fi
python3 -m pip show ansible-lint
