#!/usr/bin/env bash
apt-get update
apt-get install -y \
	wget \
	curl \
	htop \
	net-tools \
	ntp

# configure /etc/hosts
echo "server01	10.0.5.31" >> /etc/hosts
echo "server02	10.0.5.32" >> /etc/hosts
echo "server03	10.0.5.33" >> /etc/hosts

# Edit ntp
cat << EOF > /etc/ntp.conf
driftfile /var/lib/ntp/drift
restrict 127.0.0.1
restrict -6 ::1
server 0.id.pool.ntp.org
includefile /etc/ntp/crypto/pw
keys /etc/ntp/keys
EOF

# restart ntpd
systemctl restart ntp

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

# restart ssh service
systemctl restart sshd
