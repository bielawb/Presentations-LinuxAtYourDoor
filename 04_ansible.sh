#!/bin/bash
. ~/PSConfAsia/demo-magic/demo-magic.sh
. /usr/bin/virtualenvwrapper.sh
DEMO_PROMPT="${GREEN}➜ ${CYAN}[\t] ${RED}⌘  > "
TYPE_SPEED=50
clear
cd ~/PSConfAsia-Demo/Scripts
p "${GREEN}# Before we can use ansible - we need to install it."
pe 'sudo yum -y install ansible'
p "${GREEN}# At the very base there is inventory - we need to make it windows-aware..."
pe 'cat windows'
p "${GREEN}# Finally, we need a playbook that will define what remote box should do (can have parameters)."
pe 'cat test.yml'
wait
clear
p "${GREEN}# Time to add some DNS A records."
p "${GREEN}# First - we initialize kerberos token..."
pe 'kinit BOFH@MONAD.NET'
p "${GREEN}# Next, we need to run ansible-playbook with inventory, playbook and variables."
pe 'ansible-playbook -i windows test.yml --extra-vars "hostName=FromAnsible ip=192.168.7.123"'
