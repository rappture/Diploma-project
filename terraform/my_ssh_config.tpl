### ---------- The Bastion Host ----------

Host bastion-host
  user yuliya_sh
  HostName ${bastion-public-ip}

### ---------- The Remote Hosts ----------

Host web-server-1
  user yuliya_sh
  HostName ${web-server-1-fqdn}
  ProxyJump bastion-host

Host web-server-2
  user yuliya_sh	
  HostName ${web-server-2-fqdn}
  ProxyJump bastion-host

Host elasticsearch-server
  user yuliya_sh
  HostName ${elasticsearch-fqdn}
  ProxyJump bastion-host

Host kibana-server
  user yuliya_sh
  HostName ${kibana-fqdn}
  ProxyJump bastion-host

Host zabbix-server
  user yuliya_sh
  HostName ${zabbix-fqdn}
  ProxyJump bastion-host
