[cloud_bastion]
${bastion-public-ip} ansible_user=yuliya_sh

[cloud_all_but_bastion:children]
cloud_webservers
cloud_elasticsearch
cloud_kibana
cloud_zabbix

[cloud_webservers]
${web-server-1-private-ip} ansible_user=yuliya_sh
${web-server-2-private-ip} ansible_user=yuliya_sh

[cloud_elasticsearch]
${elasticsearch-private-ip} ansible_user=yuliya_sh

[cloud_kibana]
${kibana-private-ip} ansible_user=yuliya_sh

[cloud_zabbix]
${zabbix-private-ip} ansible_user=yuliya_sh

[all:vars]
zabbixPRIVATEip=${zabbix-private-ip}
elasticsearchPRIVATEip=${elasticsearch-private-ip}
kibanaPRIVATEip=${kibana-private-ip}
web1PRIVATEip=${web-server-1-private-ip}
web2PRIVATEip=${web-server-2-private-ip}

[cloud_all_but_bastion:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q bastion-host"'


