terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = "${var.YC_TOKEN}"
  cloud_id  = "${var.YC_CLOUD_ID}"
  folder_id = "${var.YC_FOLDER_ID}"
}

