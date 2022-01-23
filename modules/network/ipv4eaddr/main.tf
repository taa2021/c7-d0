# Примечания к реализации
# Ожидаемый эффект - как можно более простой переход на иную облачную платформу.


terraform {
  required_providers {
    yandex = { source = "yandex-cloud/yandex", version = "~>0.70.0" }
  }
}
resource "yandex_vpc_address" "addr" {
  external_ipv4_address {
    zone_id = var.region
  }

  labels = var.cloud-tags
}
