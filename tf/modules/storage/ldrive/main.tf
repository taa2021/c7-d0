terraform {
  required_providers {
    yandex = { source = "yandex-cloud/yandex", version = "~>0.70.0" }
  }
}

resource "yandex_compute_disk" "result" {
  size = var.size
  #  zone  = var.region

  labels = var.cloud-tags
}
