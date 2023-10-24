# Terraform configuration for web-server-1 and web-server-2

resource "yandex_compute_instance" "web-server-1" {

  zone = "ru-central1-a"
  name = "web-server-1"
  hostname = "web-server-1"

  platform_id = "standard-v3"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 2
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
    subnet_id = yandex_vpc_subnet.subnet-1-web.id
    nat       = false
    security_group_ids = [yandex_vpc_security_group.SG-ssh-icmp-traffic.id, yandex_vpc_security_group.SG-web-servers.id]
  }
  
  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}

resource "yandex_compute_instance" "web-server-2" {

  zone = "ru-central1-b"
  name = "web-server-2"
  hostname = "web-server-2"

  platform_id = "standard-v3"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 2
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
    subnet_id = yandex_vpc_subnet.subnet-2-web.id
    nat       = false
    security_group_ids = [yandex_vpc_security_group.SG-ssh-icmp-traffic.id, yandex_vpc_security_group.SG-web-servers.id]
  }
  
  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}
