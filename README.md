# coba-vagrant
This is howto create multi VMs using Vagrant, add second disk to each VMs, and provisioning using different script.

## Usage

Install vagrant
```bash
$ sudo apt-get install vagrant
```

Install VirtualBox
```bash
$ sudo apt-get install virtualbox
```

Clone Repository
```bash
$ git clone https://github.com/invaleed/coba-vagrant
$ cd coba-vagrant
$ vagrant up
$ vagrant status

Current machine states:
master                    running (virtualbox)
server1                   running (virtualbox)
server2                   running (virtualbox)
server3                   running (virtualbox)

This environment represents multiple VMs. The VMs are all listed     
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

Check on server node

```bash
$ vagrant ssh server1

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
Check on master node
```bash
$ vagrant ssh master

vagrant@master:~$ ansible --version
ansible 2.5.1
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/home/vagrant/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.17 (default, Apr 15 2020, 17:20:14) [GCC 7.5.0]
```

Done
