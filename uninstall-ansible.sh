#!/usr/bin/env bash


# Definitions and variables
readonly SHOULD_UPGRADE_PIP=false

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

## Set systems python path
if test $OS = 'Mac'; then
    #python_version=$(ls "$HOME"/Library/Python/ | grep -e '3.*')
    python_version=$(find "$HOME"/Library/Python -type d -maxdepth 1 -not -name './*' | grep -o '[1-9].[1-9]*')
    export PATH="$HOME/Library/Python/${python_version}/bin:$PATH"
else
    export PATH="$HOME/.local/bin:$PATH"
fi

# Uninstalling ansible packages
python3 -m pip uninstall -y ansible >/dev/null 2>&1
python3 -m pip uninstall -y ansible-base >/dev/null 2>&1
python3 -m pip uninstall -y ansible-core >/dev/null 2>&1
python3 -m pip uninstall -y ansible-compat >/dev/null 2>&1
python3 -m pip uninstall -y ansible-lint >/dev/null 2>&1
## List ansible packages
python3 -m pip list -v | grep ansible