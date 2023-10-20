# Terraform configuration for bastion host

resource "yandex_compute_instance" "bastion-host" {

  zone = "ru-central1-b"
  name = "bastion-host"
  hostname = "bastion-host"

  platform_id = "standard-v3"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8s17cfki4sd4l6oa59"
#      size = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-4-public.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.SG-bastion-host.id]
  }
  
  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}