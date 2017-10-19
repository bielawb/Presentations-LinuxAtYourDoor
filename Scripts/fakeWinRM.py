#!/usr/bin/env python
# coding: utf-8 
import getpass
from re         import search
from subprocess import Popen, PIPE
from winrm      import Session
from sys        import exit, argv

if len(argv) < 2 :
    exit('Usage: %s command' % argv[0])

polecenie = " ".join(argv[1:])
exitCode = 0

class PowerShellError(Exception):
    pass

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def uruchom_ps(polecenie):
    sesja = Session(
        'https://jumpbox.monad.net:5986', 
        auth = (None, None), 
        transport = 'kerberos', 
        kerberos_delegation = True,
        server_cert_validation = 'ignore'
    )
    try:
        wynik = sesja.run_ps(polecenie)
        print wynik.std_out
        if wynik.status_code > 0:
            raise PowerShellError(wynik.std_err)
        else:
            print "%sCommand return code 0 %s" % (bcolors.OKGREEN, bcolors.ENDC)
    except:
        raise

def zaloguj():
    login = "BOFH@MONAD.NET" 
    kinit = Popen(['kinit', login, '-l', '1h', '-f'], stdin = PIPE, stdout = PIPE, stderr = PIPE)
    kinit.stdin.write('%s\n' % getpass.getpass('Password for user BOFH: '))
    kinit.wait()

try:
    uruchom_ps(polecenie)
except PowerShellError as pse:
    print "PowerShell return error:\n%s%s%s" % (bcolors.FAIL, pse, bcolors.ENDC)
    exitCode = 1
except Exception as e:
    print "Wyjątek:\n%s%s%s" % (bcolors.FAIL, e, bcolors.ENDC)
    if search('No Kerberos credentials available', e.message):
        print "Looks like we need to login..."
        try:
            zaloguj()
            uruchom_ps(polecenie)
        except Exception as e:
            print "%sFailed to run command '%s'." % (bcolors.FAIL, polecenie)
            print "Error message: %s %s" % (e, bcolors.ENDC)
            exitCode = 2
    else:
        exitCode = 3
finally:
   exit(exitCode)
