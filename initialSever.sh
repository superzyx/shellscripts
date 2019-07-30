#!/usr/bin/env bash
#
#author: superzyx
#date: 2019/07/30
#usage: initial server


systemctl stop firewalld && systemctl disable firewalld
sed -ri s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
setenforce 0

mkdir /tasks
echo '* * */7 * * bash /tasks/ntpDate.sh' >> /var/spool/cron/$(whoami)
cat << EOF > /tasks/ntpDate.sh
#!/usr/bin/env bash
#
#author: superzyx
#date: 2019/07/30
#usage: update time


if [! -f /usr/bin/ntpdate]; then
	yum -y install ntpdate
	ntpdate -b ntp1.aliyun.com
else 
	ntpdate -b ntp1.aliyun.com
fi
EOF

echo "export HISTSIZE=10000" >> /etc/profile
echo "export HISTTIMEFORMAT=\"%Y-%m-%d %H-%M-%S\"" >> /etc/profile

chattr +ai /etc/passwd /etc/shadow /etc/group

yum -y install vim bash-completion net-tools

if [ $? -eq 0 ];then
	exit 0
else 
	exit 12
fi
