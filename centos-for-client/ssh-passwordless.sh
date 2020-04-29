#!/bin/bash

# Exit script on Error
set -e

# Check for SSH Directory
if [ ! -d ~/.ssh ]; then
   mkdir -p ~/.ssh/
fi


# Check for existence of passphrase
if [ ! -f ~/.ssh/id_rsa.pub ]; then
        ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
        echo "Execute ssh-keygen --[done]"
fi

# Copy key to all server
for i in `cat /etc/hosts | grep server | awk '{print $2}'`; do ssh-keyscan -t rsa -H $i >> ~/.ssh/known_hosts; done
for i in `cat /etc/hosts | grep server | awk '{print $2}'`; do sshpass -p 'vagrant' ssh-copy-id vagrant@${i}; done
