terraform {
  required_providers {
    yandex = { source = "yandex-cloud/yandex", version = "~>0.70.0" }
  }
}

resource "yandex_dns_zone" "zone" {
  name        = "zone0${join("0", reverse(split(".", var.name)))}"
  description = "desc"

  zone             = var.name
  public           = var.is-public
  private_networks = [var.vpc-id, ]

  labels = var.cloud-tags
}
