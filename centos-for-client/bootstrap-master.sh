#!/usr/bin/env bash

# change repository to buaya.klas.or.id
echo "change repository to buaya.klas.or.id"

cat << EOF > /etc/yum.repos.d/CentOS-Base.repo

[CentOSPlus]
name=CentOS
baseurl=http://buaya.klas.or.id/centos/7.7.1908/centosplus/x86_64/
enabled=1
gpgcheck=1
gpgkey=http://buaya.klas.or.id/centos/RPM-GPG-KEY-CentOS-7

[Extras]
name=CentOS
baseurl=http://buaya.klas.or.id/centos/7.7.1908/extras/x86_64/
enabled=1
gpgcheck=1
gpgkey=http://buaya.klas.or.id/centos/RPM-GPG-KEY-CentOS-7

[Fasttrack]
name=CentOS
baseurl=http://buaya.klas.or.id/centos/7.7.1908/fasttrack/x86_64/
enabled=1
gpgcheck=1
gpgkey=http://buaya.klas.or.id/centos/RPM-GPG-KEY-CentOS-7

[OS]
name=CentOS
baseurl=http://buaya.klas.or.id/centos/7.7.1908/os/x86_64/
enabled=1
gpgcheck=1
gpgkey=http://buaya.klas.or.id/centos/RPM-GPG-KEY-CentOS-7

[Update]
name=CentOS
baseurl=http://buaya.klas.or.id/centos/7.7.1908/updates/x86_64/
enabled=1
gpgcheck=1
gpgkey=http://buaya.klas.or.id/centos/RPM-GPG-KEY-CentOS-7
EOF

# install list of packages
echo "install list of packages"

yum update
yum -y install \
	epel-release \
	wget \
	curl \
	htop \
	net-tools \
	ntp \
	git \
	ansible \
	glances \
	python-bottle
	
# configure timezone
echo "configure timezone"

rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# configure /etc/hosts
echo "configure /etc/hosts"

cat << EOF > /etc/hosts
127.0.0.1 `hostname` `hostname`
127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4
::1       localhost localhost.localdomain localhost6 localhost6.localdomain6

10.0.5.30 master
10.0.5.31 server1
10.0.5.32 server2
10.0.5.33 server3
EOF

# configure ntp
echo "configure ntp"

cat << EOF > /etc/ntp.conf
driftfile /var/lib/ntp/drift
restrict 127.0.0.1
restrict -6 ::1
server 0.id.pool.ntp.org
includefile /etc/ntp/crypto/pw
keys /etc/ntp/keys
EOF

# add ssh banner
echo "add ssh banner"

sed -i 's|^#Banner none|Banner /\etc/\issue|g' /etc/ssh/sshd_config

# create /etc/issue
echo "create /etc/issue"

cat << EOF > /etc/issue
WARNING:  Unauthorized access to this system is forbidden and will be
prosecuted by law. By accessing this system, you agree that your actions
may be monitored if unauthorized usage is suspected.
EOF

# set password auth ssh
echo "set password auth ssh"

sed -i '/^PasswordAuthentication/s/no/yes/' /etc/ssh/sshd_config

# add user sysadmin
echo "add user sysadmin"

adduser -m -d /home/sysadmin -s /bin/bash -c "User sysadmin" sysadmin
echo "sysadmin:supersecret" | chpasswd

# restart ntpd
echo "restart ntpd"

systemctl restart ntpd

# start glances & open port 61208/tcp
echo "start glances & open port 61208/tcp"

firewall-cmd --permanent --add-port=61208/tcp
firewall-cmd --reload
glances -w &

# restart ssh service
echo "restart ssh service"

systemctl restart sshd

echo "Bootstrap Master Done..."
