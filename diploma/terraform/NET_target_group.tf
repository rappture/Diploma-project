# Terraform configuration for Target Group of web-servers
#### Создайте Target Group, включите в неё две созданных ВМ. (alb = application load balancer) Проверить подсети.

resource "yandex_alb_target_group" "diploma-target-group" {
  name = "diploma-target-group"

  target {
    subnet_id = yandex_vpc_subnet.subnet-1-web.id
    ip_address   = yandex_compute_instance.web-server-1.network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet-2-web.id
    ip_address   = yandex_compute_instance.web-server-2.network_interface.0.ip_address
  }
}
