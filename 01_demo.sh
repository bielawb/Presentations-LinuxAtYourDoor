#!/bin/bash
. ~/PSConfAsia/demo-magic/demo-magic.sh
DEMO_PROMPT="${GREEN}➜ ${CYAN}[\t] ${RED}⌘  > "
TYPE_SPEED=50
clear
cd ~
p "${GREEN}# First, we need to be able to use pip"
pe 'sudo yum -y install epel-release'
p "${GREEN}# Next, we can install packages required for pywinrm w/ kerberos"
pe 'sudo yum -y install python-pip gcc krb5-devel krb5-workstation python-devel'
p "${GREEN}# Time to install pywinrm!"
pe 'sudo pip install pywinrm[kerberos]'
p "${GREEN}# Our scripts - time to see them!"
code /home/bielawb/PSConfAsia/Scripts
