output "_ssh-config" {
  description = "Is used in main-diploma-script.sh to create SSH configuration file using template"
  value = templatefile("my_ssh_config.tpl", {
    bastion-public-ip = yandex_compute_instance.bastion-host.network_interface.0.nat_ip_address,
    elasticsearch-private-ip = yandex_compute_instance.elasticsearch-server.network_interface.0.ip_address,
    kibana-private-ip = yandex_compute_instance.kibana-server.network_interface.0.ip_address,
    zabbix-private-ip = yandex_compute_instance.zabbix-server.network_interface.0.ip_address,
    web-server-1-private-ip = yandex_compute_instance.web-server-1.network_interface.0.ip_address,
    web-server-2-private-ip = yandex_compute_instance.web-server-2.network_interface.0.ip_address
  })
}

output "ansible-inventory" {
  description = "Is used in main-diploma-script.sh to create ansible inventory file using template"
  value = templatefile("my_ansible_inventory.tpl", {
    bastion-public-ip = yandex_compute_instance.bastion-host.network_interface.0.nat_ip_address,
    elasticsearch-private-ip = yandex_compute_instance.elasticsearch-server.network_interface.0.ip_address,
    kibana-private-ip = yandex_compute_instance.kibana-server.network_interface.0.ip_address,
    zabbix-private-ip = yandex_compute_instance.zabbix-server.network_interface.0.ip_address,
    web-server-1-private-ip = yandex_compute_instance.web-server-1.network_interface.0.ip_address,
    web-server-2-private-ip = yandex_compute_instance.web-server-2.network_interface.0.ip_address
  })
}

output "public-ip-addresses" {
  value = <<OUTPUT
Application load balancer = ${yandex_alb_load_balancer.diploma-load-balancer.listener.0.endpoint.0.address.0.external_ipv4_address.0.address}
Zabbix server = ${yandex_compute_instance.zabbix-server.network_interface.0.nat_ip_address}
Kibana server = ${yandex_compute_instance.kibana-server.network_interface.0.nat_ip_address}
Bastion host = ${yandex_compute_instance.bastion-host.network_interface.0.nat_ip_address}
OUTPUT
}

output "zabbix-server-private-ip" {
  description = "Is used in main-diploma-script.sh to create additional configuration file for zabbix-agent"
  value = <<OUTPUT
#Additional configuration file for zabbix-agent
Server=${yandex_compute_instance.zabbix-server.network_interface.0.ip_address}
OUTPUT
}