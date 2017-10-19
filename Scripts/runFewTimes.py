#!/usr/bin/env python
from winrm      import Session
from sys        import exit, argv

if len(argv) < 3 :
    exit('Usage: %s times command' % argv[0])

times = int(argv[1])
command = " ".join(argv[2:]) * times
print "Command length: %d" % len(command)
mySession = Session(
    'jumpbox.monad.net', 
    auth = (None, None), 
    transport = 'kerberos', 
)

result = mySession.run_ps(command)
print "Output length: %d" % len(result.std_out)
if result.status_code > 0:
    print "Error: %s" % result.std_err
