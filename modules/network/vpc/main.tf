terraform {
  required_providers {
    yandex = { source = "yandex-cloud/yandex", version = "~>0.70.0" }
  }
}
resource "yandex_vpc_network" "vpc" {
  labels = var.cloud-tags
}
