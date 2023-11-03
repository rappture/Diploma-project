# Terraform configuration for ELK-servers 

resource "yandex_compute_instance" "elasticsearch-server" {

  zone = "ru-central1-b"
  name = "elasticsearch-server"
  hostname = "elasticsearch-server"

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
#      size = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-3-elasticsearch.id
    nat       = false
    security_group_ids = [yandex_vpc_security_group.SG-ssh-icmp-traffic.id, yandex_vpc_security_group.SG-elasticsearch.id]
  }
  
  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}

resource "yandex_compute_instance" "kibana-server" {

  zone = "ru-central1-b"
  name = "kibana-server"
  hostname = "kibana-server"

  platform_id = "standard-v3"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 2
#    memory = 4
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
    security_group_ids = [yandex_vpc_security_group.SG-ssh-icmp-traffic.id, yandex_vpc_security_group.SG-kibana.id]
  }
  
  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}
