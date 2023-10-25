resource "yandex_vpc_gateway" "diploma-nat-gateway" {
  name = "diploma-nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "nat-route-table" {
  name       = "nat-route-table"
  network_id = yandex_vpc_network.diploma-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.diploma-nat-gateway.id
  }
}
