#!/usr/bin/env bash

cat << EOF > /etc/apt/sources.list
deb http://kambing.ui.ac.id/ubuntu/ bionic main restricted
deb http://kambing.ui.ac.id/ubuntu/ bionic-updates main restricted
deb http://kambing.ui.ac.id/ubuntu/ bionic universe
deb http://kambing.ui.ac.id/ubuntu/ bionic-updates universe
deb http://kambing.ui.ac.id/ubuntu/ bionic multiverse
deb http://kambing.ui.ac.id/ubuntu/ bionic-updates multiverse
deb http://kambing.ui.ac.id/ubuntu/ bionic-backports main restricted universe multiverse
deb http://kambing.ui.ac.id/ubuntu/ bionic-security main restricted
deb http://kambing.ui.ac.id/ubuntu/ bionic-security universe
deb http://kambing.ui.ac.id/ubuntu/ bionic-security multiverse
EOF

apt-get update
apt-get install -y \
	wget \
	curl \
	htop \
	net-tools \
	ntp \
    	ansible

# configure /etc/hosts
echo "10.0.5.31	server1" >> /etc/hosts
echo "10.0.5.32	server2" >> /etc/hosts
echo "10.0.5.33	server3" >> /etc/hosts
echo "10.0.5.30	master" >> /etc/hosts

# Edit ntp
cat << EOF > /etc/ntp.conf
driftfile /var/lib/ntp/drift
restrict 127.0.0.1
restrict -6 ::1
server 0.id.pool.ntp.org
includefile /etc/ntp/crypto/pw
keys /etc/ntp/keys
EOF

# add ssh banner
sed -i 's|^#Banner none|Banner /\etc/\issue|g' /etc/ssh/sshd_config

cat << EOF > /etc/issue
WARNING:  Unauthorized access to this system is forbidden and will be
prosecuted by law. By accessing this system, you agree that your actions
may be monitored if unauthorized usage is suspected.
EOF

# set password auth ssh
sed -i '/^PasswordAuthentication/s/no/yes/' /etc/ssh/sshd_config

# add user sysadmin
adduser --quiet --disabled-password --shell /bin/bash --home /home/sysadmin --gecos "User sysadmin" sysadmin
echo "sysadmin:supersecret" | chpasswd

# restart ntpd
systemctl restart ntp

# restart ssh service
systemctl restart sshd

echo "Bootstrap Master Done..."
