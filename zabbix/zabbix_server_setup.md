1. Install basic packages

yum update -y
yum install -y epel-release nano curl wget

2. Install and start MariaDB + Apache

yum install -y mariadb-server httpd php php-mysqlnd php-xml php-json php-mbstring php-gd
systemctl enable --now mariadb httpd

3. Fix system time (important for SSL and Zabbix)

date
# If wrong, set:
timedatectl set-time "2025-11-04 12:00:00"
timedatectl set-ntp true

4. Install Zabbix Repository (for RHEL/CentOS 9)

cd /tmp
curl -L -O https://repo.zabbix.com/zabbix/6.0/rhel/9/x86_64/zabbix-release-6.0-4.el9.noarch.rpm
yum localinstall -y zabbix-release-6.0-4.el9.noarch.rpm
yum clean all
yum makecache

5. Install Zabbix server, web, SQL scripts, SELinux policy, and agent

 yum install -y \
  zabbix-server-mysql \
  zabbix-web-mysql \
  zabbix-apache-conf \
  zabbix-sql-scripts \
  zabbix-selinux-policy \
  zabbix-agent

6. Create Zabbix database and user

mysql -uroot -p

Inside MySQL:

CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'Zabbix@123';

GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';

FLUSH PRIVILEGES;
EXIT;

7. Import initial Zabbix schema

zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql -uzabbix -p zabbix
# Enter password: Zabbix@123

8. Configure Zabbix server to use this database

vi /etc/zabbix/zabbix_server.conf

Find and set:

DBPassword=Zabbix@123

9. Enable Zabbix server, agent and Apache

systemctl enable --now zabbix-server zabbix-agent httpd
systemctl restart zabbix-server zabbix-agent httpd

Check:

systemctl status zabbix-server

10. SELinux: allow Apache to connect to Zabbix server

setsebool -P httpd_can_network_connect 1

11. Open firewall ports (if firewalld is used)

firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=10051/tcp
firewall-cmd --permanent --add-port=10050/tcp
firewall-cmd --reload

12. Zabbix Web UI initial setup

ip addr show

Open in browser: http://ip address/Zabbix



Follow the wizard:

1.Check pre-requisites → Next

2.Database:

Database type: MySQL

Host: localhost

DB name: zabbix

User: zabbix

Password: Zabbix@123

3.Zabbix server details:

Host: localhost

Port: 10051

Name: Zabbix server on CentOS 9

4.Confirm and Finish.

Login with default:

Username: Admin

Password: zabbix

Then change the Admin password from the UI.
