#!/usr/bin/env python
# coding: utf-8 
import getpass
from re         import search
from subprocess import Popen, PIPE
from winrm      import Session
from sys        import exit
import click

@click.command()
@click.option('-n', '--name', prompt = 'Host name')
@click.option('-i', '--ip',   prompt = 'IP Address')
@click.option('-z', '--zone', default = 'monad.net')


def addA(name, ip, zone):
    template = "adda {0} {1} {2}"
    command = template.format(
        name,
        ip,
        zone
    )
    run_ps(command)

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

def run_ps(command):
    print "Running command: %s" % command
    sesja = Session(
        'https://jumpbox.monad.net:5986', 
        auth = (None, None), 
        transport = 'kerberos', 
        kerberos_delegation = True,
        server_cert_validation = 'ignore'
    )
    try:
        result = sesja.run_ps(command)
        print result.std_out
        if result.status_code > 0:
            raise PowerShellError(result.std_err)
        else:
            print "%sCommand returned code 0 %s" % (bcolors.OKGREEN, bcolors.ENDC)
    except:
        raise

def loginUser():
    login = "%s@MONAD.NET" % getpass.getuser()
    kinit = Popen(['kinit', login, '-l', '1h', '-f'], stdin = PIPE, stdout = PIPE, stderr = PIPE)
    kinit.stdin.write('%s\n' % getpass.getpass('Enter password: '))
    kinit.wait()

try:
    exitCode = 0
    addA()
except PowerShellError as pse:
    print "PowerShell returned error:\n%s%s%s" % (bcolors.FAIL, pse, bcolors.ENDC)
    exitCode = 1
except Exception as e:
    print "Exception:\n%s%s%s" % (bcolors.FAIL, e, bcolors.ENDC)
    if search('No Kerberos credentials available', e.message):
        print "Error suggests we need to login..."
        try:
            loginUser()
            run_ps(command)
        except Exception as e:
            print "%sFailed to run command '%s'. Check password or user permissions." % (bcolors.FAIL, command)
            print "Error: %s %s" % (e, bcolors.ENDC)
            exitCode = 2
    else:
        exitCode = 3
finally:
   exit(exitCode)
