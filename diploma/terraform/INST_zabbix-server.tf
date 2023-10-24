# Terrafiorm configuration for monitoring server (Zabbix)

resource "yandex_compute_instance" "zabbix-server" {

  zone = "ru-central1-b"
  name = "zabbix-server"
  hostname = "zabbix-server"

  platform_id = "standard-v3"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 2
#    memory = 8
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd8s17cfki4sd4l6oa59"
      size = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-4-public.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.SG-ssh-icmp-traffic.id, yandex_vpc_security_group.SG-zabbix.id]
  }
  
  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}
