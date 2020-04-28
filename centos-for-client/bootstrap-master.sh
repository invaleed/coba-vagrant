#!/usr/bin/env bash

cat << EOF > /etc/yum.repos.d/CentOS-Base.repo

[base]
name=CentOS-$releasever - Base
baseurl=http://buaya.klas.or.id/centos/$releasever/os/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[updates]
name=CentOS-$releasever - Updates
baseurl=http://buaya.klas.or.id/centos/$releasever/updates/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[extras]
name=CentOS-$releasever - Extras
baseurl=http://buaya.klas.or.id/centos/$releasever/extras/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[centosplus]
name=CentOS-$releasever - Plus
baseurl=http://buaya.klas.or.id/centos/$releasever/centosplus/$basearch/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[contrib]
name=CentOS-$releasever - Contrib
baseurl=http://buaya.klas.or.id/centos/$releasever/contrib/$basearch/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

EOF

yum update
yum -y install \
	epel-release \
	wget \
	curl \
	htop \
	net-tools \
	ntp \
	git \
	ansible
yum update

# configure /etc/hosts
echo "10.0.5.31	server1" >> /etc/hosts
echo "10.0.5.32	server2" >> /etc/hosts
echo "10.0.5.33	server3" >> /etc/hosts
echo "10.0.5.34	server4" >> /etc/hosts
echo "10.0.5.35	server5" >> /etc/hosts
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
adduser -m -d /home/sysadmin -s /bin/bash -c "User sysadmin" sysadmin
echo "sysadmin:supersecret" | chpasswd

# restart ntpd
systemctl restart ntpd

# restart ssh service
systemctl restart sshd

echo "Bootstrap Master Done..."
