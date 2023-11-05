# Terraform configuration for HTTP router

resource "yandex_alb_http_router" "diploma-http-router" {
  name = "diploma-http-router"
}

resource "yandex_alb_virtual_host" "http-router-virtual-host" {
  name = "http-router-virtual-host"
  http_router_id = yandex_alb_http_router.diploma-http-router.id
  route {
    name = "diploma-route"
    http_route {
#optional      http_match {
#optional        path {
#optional          prefix = "/"
#optional        }  
#optional      }
      http_route_action {
        backend_group_id = yandex_alb_backend_group.diploma-backend-group.id
#optional        timeout = "60s"
      }
    }
  }
}