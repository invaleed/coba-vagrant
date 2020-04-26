# coba-vagrant
This is howto create multiple VMs using Vagrant and add second disk to each VMs.

## Usage

Install vagrant
Install VirtualBox

Clone Repository
```bash
$ git clone https://github.com/invaleed/coba-vagrant
$ cd coba-vagrant
$ vagrant up
$ vagrant status
$ vagrant ssh server1
```
Crosscheck

```bash
vagrant@server1:~$ cat /etc/passwd | grep sysadmin
sysadmin:x:1002:1002:User sysadmin,,,:/home/sysadmin:/bin/bash

vagrant@server1:~$ cat /etc/ntp.conf 
driftfile /var/lib/ntp/drift
restrict 127.0.0.1
restrict -6 ::1
server 0.id.pool.ntp.org
includefile /etc/ntp/crypto/pw
keys /etc/ntp/keys

vagrant@server1:~$ cat /etc/issue
WARNING:  Unauthorized access to this system is forbidden and will be   
prosecuted by law. By accessing this system, you agree that your actions
may be monitored if unauthorized usage is suspected.

```

Done
