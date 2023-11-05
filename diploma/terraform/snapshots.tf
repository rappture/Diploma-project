# Terraform configuration for snapshots

#resource "yandex_compute_snapshot" "diploma-snapshot" {
#  name           = "diploma-snapshot"
#  source_disk_id = "disk_id"
#}

resource "yandex_compute_snapshot_schedule" "diploma-snapshot-schedule" {
  name = "diploma-snapshot-schedule"

  schedule_policy {
	expression = "30 4 * * *"
  }

  retention_period = "168h"
#  snapshot_count = 7

  disk_ids = [
    yandex_compute_instance.bastion-host.boot_disk[0].disk_id,
    yandex_compute_instance.elasticsearch-server.boot_disk[0].disk_id,
    yandex_compute_instance.kibana-server.boot_disk[0].disk_id,
    yandex_compute_instance.zabbix-server.boot_disk[0].disk_id,
    yandex_compute_instance.web-server-1.boot_disk[0].disk_id,
    yandex_compute_instance.web-server-2.boot_disk[0].disk_id
  ]
}