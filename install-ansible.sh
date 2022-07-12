#!/usr/bin/env bash
# Available OS: Linux, MacOS 

# Definitions and variables
readonly SHOULD_UPGRADE_PIP=false
readonly SHOULD_UPGRADE_ANSIBLE=true


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

# Installing Ansible
## To verify whether ansible is already installed on your preferred Python
ansible --version >/dev/null 2>&1
if test $? -ne 0; then
    ## To enable a user to execute ansible command if its command was not found
    echo 'Not found ansible command and install it'
    python3 -m pip install --user ansible >/dev/null
fi
## To upgrade ansible if you want
if [ "${SHOULD_UPGRADE_ANSIBLE}" ]; then
    echo 'Upgarde ansible if possible'
    python3 -m pip install --upgrade --user ansible >/dev/null
fi
python3 -m pip show ansible
