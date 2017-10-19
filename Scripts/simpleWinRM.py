#!/usr/bin/env python
from winrm      import Session
from sys        import exit, argv

if len(argv) < 2 :
    exit('Usage: %s command' % argv[0])

command = " ".join(argv[1:])
mySession = Session(
    'jumpbox.monad.net', 
    auth = (None, None), 
    transport = 'kerberos', 
)

result = mySession.run_ps(command)
print result.std_out
if result.status_code > 0:
    print "Error: %s" % result.std_err
