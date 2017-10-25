#!/bin/bash
. ~/PSConfAsia/demo-magic/demo-magic.sh
DEMO_PROMPT="${GREEN}➜ ${CYAN}[\t] ${RED}⌘  > "
TYPE_SPEED=50
clear
cd ~/PSConfAsia/Scripts
p "${GREEN}# Let's take a look at basic scripts first"
pe 'cat simpleWinRM.py'
p "${GREEN}# But before we run it - we will need to run kinit"
pe 'kinit bielawb@MONAD.NET'
p "${GREEN}# Mind CAPS in domain - it's not me being rude, it's required..."
wait
clear
p "${GREEN}# Time to give ls a try..."
pe './simpleWinRM.py ls'
p "${GREEN}# But double-hop can bite us here too..."
pe './simpleWinRM.py icm dc { hostname }'
p "${GREEN}# To fix it - we need to add kerberos_delegation = True...."
pe 'grep delegation delegatedWinRM.py'
pe './delegatedWinRM.py icm dc { hostname }'
wait
clear
p "${RED}# Issue - length of the command!"
p "${GREEN}# When we run shorter script - all works fine..."
pe './runFewTimes.py 300 Get-Date\;'
p "${GREEN}# When we run something a bit longer - fails..."
pe './runFewTimes.py 400 Get-Date\;'
p "${GREEN}# Easiest solution - have a script on the remote box"
pe './simpleWinRM.py cat demo-pywinrm/WindowsScript/loremIpsum.ps1 \| measure -character'
p "${GREEN}# Our script is not very interesting, but still - way longer. And it works just fine"
pe './runFewTimes.py 1 ./demo-pywinrm/WindowsScript/loremIpsum.ps1'
wait
clear
p "${RED}# Issue - data not protected!"
p "${GREEN}# Kerberos helps with password protection, but leaves data plain-text"
p "${GREEN}# Simple tcpdump and we can see secrets send back from winrm..."
pe 'cat ./decodeWinRM'
sudo echo dupa > /dev/null
pe './decodeWinRM&'
pe './simpleWinRM.py echo m@ypr0tectedData'
p "${GREEN}# To solve it - we can use SSL... But first, we need to configure our Windows node."
