# Terraform configuration for network and subnets
######Разверните один VPC. Сервера web, Elasticsearch поместите в приватные подсети. Сервера Zabbix, Kibana, application load balancer определите в публичную подсеть.

resource "yandex_vpc_network" "diploma-network" {
  name = "diploma-network"
}

resource "yandex_vpc_subnet" "subnet-1-web" {
  name           = "subnet-1-web"
  description    = "Subnet for web-server-1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.diploma-network.id
  v4_cidr_blocks = ["10.150.0.0/24"]
  route_table_id = yandex_vpc_route_table.nat-route-table.id
}

resource "yandex_vpc_subnet" "subnet-2-web" {
  name           = "subnet-2-web"
  description    = "Subnet for web-server-1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.diploma-network.id
  v4_cidr_blocks = ["10.151.0.0/24"]
  route_table_id = yandex_vpc_route_table.nat-route-table.id
}

resource "yandex_vpc_subnet" "subnet-3-elasticsearch" {
  name           = "subnet-3-elasticsearch"
  description    = "Subnet for Elasticsearch"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.diploma-network.id
  v4_cidr_blocks = ["10.152.0.0/24"]
  route_table_id = yandex_vpc_route_table.nat-route-table.id
}

resource "yandex_vpc_subnet" "subnet-4-public" {
  name           = "subnet-4-public"
  description    = "Subnet for Zabbix, Kibana, application load balancer (diploma-load-balancer)"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.diploma-network.id
  v4_cidr_blocks = ["10.153.0.0/24"]
  route_table_id = yandex_vpc_route_table.nat-route-table.id
}
