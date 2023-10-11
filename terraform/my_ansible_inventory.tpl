[cloud_bastion]
yuliya_sh@${bastion-public-ip}

[cloud_all_but_bastion:children]
cloud_webservers
cloud_elasticsearch
cloud_kibana
cloud_zabbix

[cloud_webservers]
yuliya_sh@${web-server-1-private-ip}
yuliya_sh@${web-server-2-private-ip}

[cloud_elasticsearch]
yuliya_sh@${elasticsearch-private-ip}

[cloud_kibana]
yuliya_sh@${kibana-private-ip}

[cloud_zabbix]
yuliya_sh@${zabbix-private-ip}
