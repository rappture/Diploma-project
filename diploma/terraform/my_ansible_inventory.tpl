[cloud_bastion]
BASTION ansible_host=${bastion-public-ip}

[cloud_all_but_bastion:children]
cloud_webservers
cloud_elasticsearch
cloud_kibana
cloud_zabbix

[cloud_webservers]
WEB1 ansible_host=${web-server-1-private-ip} 
WEB2 ansible_host=${web-server-2-private-ip}

[cloud_elasticsearch]
ELASTICSEARCH ansible_host=${elasticsearch-private-ip}

[cloud_kibana]
KIBANA ansible_host=${kibana-private-ip}

[cloud_zabbix]
ZABBIX ansible_host=${zabbix-private-ip}

[all:vars]
ansible_user=yuliya_sh

[cloud_all_but_bastion:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q bastion-host"'