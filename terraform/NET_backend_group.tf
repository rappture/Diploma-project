# Terraform configuration for web-servers Backend Group

resource "yandex_alb_backend_group" "diploma-backend-group" {
  name = "diploma-backend-group"
#optional  session_affinity {
#optional    connection {
#optional      source_ip = <true_OR_false>
#optional    }
#optional  }

  http_backend {
    name = "diploma-backend"
#optional    weight = 1
    port = 80
    target_group_ids = ["${yandex_alb_target_group.diploma-target-group.id}"]
#optional    load_balancing_config {
#optional      panic_threshold = 90
#optional    } 
    healthcheck {
      timeout = "10s"
      interval = "2s"
#optional      healthy_threshold = 10
#optional      unhealthy_threshold = 15 
      http_healthcheck {
        path = "/"
      }
    }
  }
}