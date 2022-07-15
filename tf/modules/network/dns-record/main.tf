terraform {
  required_providers {
    yandex = { source = "yandex-cloud/yandex", version = "~>0.70.0" }
  }
}

resource "yandex_dns_recordset" "rs" {
  zone_id = var.zone-id
  name    = var.name
  type    = var.type
  data    = var.data
  ttl     = 600
}
