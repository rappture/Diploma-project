# Terraform configuration for snapshots
##### Создайте snapshot дисков всех ВМ. Ограничьте время жизни snaphot в неделю. Сами snaphot настройте на ежедневное копирование.

#resource "yandex_compute_snapshot" "diploma-snapshot" {
#  name           = "diploma-snapshot"
#  source_disk_id = "test_disk_id"
#}

resource "yandex_compute_snapshot_schedule" "diploma-snapshot-schedule" {
  name = "diploma-snapshot-schedule"

  schedule_policy {
	expression = "30 4 * * *"
  }

  retention_period = "168h"

}