# Terraform configuration for Application load balancer 
##### Создайте Application load balancer для распределения трафика на веб-сервера, созданные ранее. Укажите HTTP router, созданный ранее, задайте listener тип auto, порт 80.


resource "yandex_alb_load_balancer" "diploma-load-balancer" {
  name = "diploma-load-balancer"
  network_id = yandex_vpc_network.diploma-network.id
  security_group_ids = [yandex_vpc_security_group.SG-load-balanser.id]

  allocation_policy {
    location {
      zone_id = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.subnet-4-public.id
    }
  }

  listener {
    name = "listener-1"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ "80" ]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.diploma-http-router.id
      }
    }
  }
}
