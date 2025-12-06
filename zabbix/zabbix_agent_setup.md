1. Install Zabbix agent

yum install -y zabbix-agent

2. Configure Zabbix agent

vi /etc/zabbix/zabbix_agentd.conf

Set the following values (adjust to your environment):

Server=127.0.0.1
ServerActive=127.0.0.1
Hostname=centos-server

3. Start and enable the agent

systemctl enable --now zabbix-agent
systemctl status zabbix-agent

4. Open agent port in firewall (if using firewalld)

firewall-cmd --permanent --add-port=10050/tcp
firewall-cmd --reload

5. Add host in Zabbix Web UI

Go to: Configuration → Hosts → Create host

Fill:

Host name: centos-server

Groups: Linux servers (or create your own group)

Interfaces:

Type: Agent

IP: (agent IP, e.g. 127.0.0.1 or 10.x.x.x)

Port: 10050

Under Templates, click Select and choose:

Template OS Linux by Zabbix agent

Click Add.

After 1–2 minutes, the host should show ZBX: green (available) in the host list.

You can then view metrics under:

Monitoring → Hosts → centos-server → Graphs

Monitoring → Latest data
