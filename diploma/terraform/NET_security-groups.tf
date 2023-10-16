#Terraform configuration for Security Groups

## -----Security Group Bastion host-----

resource "yandex_vpc_security_group" "SG-bastion-host" {
  name        = "SG-bastion-host"
  description = "This rule allows SSH connection and any egress traffic for bastion host"
  network_id  = yandex_vpc_network.diploma-network.id
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

## -----Security Group SSH and ICMP traffic-----

resource "yandex_vpc_security_group" "SG-ssh-icmp-traffic" {
  name        = "SG-ssh-icmp-traffic"
  description = "This rule allows SSH access from the bastion host's internal interface IPs to the internal hosts"
  network_id  = yandex_vpc_network.diploma-network.id
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["10.153.0.0/24"]
  }
  ingress {
    protocol       = "ICMP"
    v4_cidr_blocks = ["10.153.0.0/24"]
  }
}

## -----Security Group Web-servers-----

resource "yandex_vpc_security_group" "SG-web-servers" {
  name        = "SG-web-servers"
  network_id  = yandex_vpc_network.diploma-network.id

  ingress {
    description = "Health checks from NLB"
    protocol = "TCP"
    predefined_target = "loadbalancer_healthchecks"
  }

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["10.153.0.0/24"]
  }

  ingress {
    protocol       = "TCP"
    port           = 10050
    v4_cidr_blocks = ["10.153.0.0/24"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

## -----Security Group Zabbix-----

resource "yandex_vpc_security_group" "SG-zabbix" {
  name        = "SG-zabbix"
  network_id  = yandex_vpc_network.diploma-network.id

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 10051
    v4_cidr_blocks = ["10.150.0.0/24", "10.151.0.0/24"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

}

## -----Security Group ElasticSearch-----

resource "yandex_vpc_security_group" "SG-elasticsearch" {
  name        = "SG-elasticsearch"
  network_id  = yandex_vpc_network.diploma-network.id

  ingress {
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = ["10.150.0.0/24", "10.151.0.0/24", "10.153.0.0/24"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

## -----Security Group Kibana-----

resource "yandex_vpc_security_group" "SG-kibana" {
  name        = "SG-kibana"
  network_id  = yandex_vpc_network.diploma-network.id

  ingress {
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

## -----Security Group Application load balancer-----

resource "yandex_vpc_security_group" "SG-load-balanser" {
  name        = "SG-load-balanser"
  network_id  = yandex_vpc_network.diploma-network.id

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
