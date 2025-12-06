1. Prerequisites

- Zabbix agent is installed and running on the host.
- The script `/usr/local/bin/log_cleanup.sh` exists and logs to:

  ```text
  /var/log/cleanup_report.log

2. Create custom UserParameter on the agent

vi /etc/zabbix/zabbix_agentd.d/log_cleanup.conf

Add this line:

UserParameter=log.cleanup.status,grep -c "Cleanup complete\." /var/log/cleanup_report.log 2>/dev/null || echo 0

Restart the agent:

systemctl restart zabbix-agent

Test the parameter:

zabbix_agentd -t log.cleanup.status

O/p: log.cleanup.status   [t|3]

3. Configure file permissions

chown zabbix:zabbix /var/log/cleanup_report.log
chmod 644 /var/log/cleanup_report.log
chmod 755 /var/log

Verify as zabbix user:

-u zabbix grep -c "Cleanup complete\." /var/log/cleanup_report.log

4. Create Zabbix item for cleanup status

In the Zabbix Web UI:

Go to Configuration → Hosts → centos-server → Items.

Click Create item.

Fill:

Name: Log Cleanup Status

Type: Zabbix agent

Key: log.cleanup.status

Type of information: Numeric (unsigned)

Update interval: 30m (or 1h in production)

History storage period: leave default

Trend storage period: leave default

Click Add.

Verify the value in:

Monitoring → Latest data → Host: centos-server → filter by Name: log

5. Create trigger for failed cleanup

To receive alerts if cleanup is not running:

Go to Configuration → Hosts → centos-server → Triggers.

Click Create trigger.

Fill:

Name: Log cleanup failed

Expression:

{centos-server:log.cleanup.status.last()}=0


Severity: Warning (or higher if desired)

Click Add.

Now Zabbix will generate a problem event if the last value of log.cleanup.status is 0, meaning no successful cleanup has been recorded.
