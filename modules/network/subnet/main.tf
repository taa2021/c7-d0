terraform {
  required_providers {
    yandex = { source = "yandex-cloud/yandex", version = "~>0.70.0" }
  }
}

resource "yandex_vpc_subnet" "subnet" {
  v4_cidr_blocks = [var.cidr]
  zone           = var.region
  network_id     = var.vpc-id

  labels = var.cloud-tags
}
