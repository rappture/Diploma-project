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
Application load balancer = http://${yandex_alb_load_balancer.diploma-load-balancer.listener.0.endpoint.0.address.0.external_ipv4_address.0.address}
Zabbix server = http://${yandex_compute_instance.zabbix-server.network_interface.0.nat_ip_address}/zabbix
Kibana server = https://${yandex_compute_instance.kibana-server.network_interface.0.nat_ip_address}:5601
Bastion host = ${yandex_compute_instance.bastion-host.network_interface.0.nat_ip_address}
OUTPUT
}