#!/bin/bash
. ~/PSConfAsia/demo-magic/demo-magic.sh
. /usr/bin/virtualenvwrapper.sh
DEMO_PROMPT="${GREEN}➜ ${CYAN}[\t] ${RED}⌘  > "
TYPE_SPEED=50
clear
cd ~/PSConfAsia-Demo/Scripts
p "${GREEN}# Using SSL - we have to change endpoint"
pe 'cat bin/withSsl.py'
p "${GREEN}# The problem: CA is not easy to configure... "
pe './withSsl ls'
wait
clear
p "${GREEN}# Three options:"
p "${GREEN}# -- ignore cert validation"
p "${GREEN}# -- modify requests and add our CA"
p "${GREEN}# -- modify pywinrm to allow seperate cert"
pe './httpsWinRM ls'
wait
clear
p "${GREEN}# To make it more convenient - we can wrap python around it and expose as a single command"
pe 'cat adda.py | less'
pe 'adda --help'
p "${GREEN}# Let's see it in action!"
pe 'adda -n PSRocks -i 192.168.7.150'
pe 'nslookup PSRocks.monad.net 192.168.7.1'
