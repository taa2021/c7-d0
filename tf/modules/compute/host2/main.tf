terraform {
  required_providers {
    yandex = { source = "yandex-cloud/yandex", version = "~>0.70.0" }
  }
}

resource "random_id" "hname" {
  count       = 1
  byte_length = 8
}

data "yandex_compute_image" "image" {
  family = var.image-family
}

resource "yandex_compute_instance" "host" {
  zone        = var.region
  platform_id = var.platform

  name = var.name != "" ? var.name : "h${random_id.hname[0].hex}"

  allow_stopping_for_update = true

  resources {
    cores         = var.ncpu
    memory        = var.mem
    core_fraction = var.cpu-fraq
  }

  scheduling_policy {
    preemptible = var.is-preemptible
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      size     = var.boot-disk-size
    }
  }

  secondary_disk {
    disk_id     = var.drive2-id
    device_name = var.drive2-idlocal
  }

  network_interface {
    subnet_id          = var.subnet
    nat                = var.has-eaddr
    security_group_ids = var.vpc-sg != "" ? toset(split(",", var.vpc-sg)) : toset([])
  }

  metadata = {
    user-data = <<EOT
#cloud-config
users:
  - name: ${var.login}
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ${var.ssh}
EOT
  }
  labels = var.cloud-tags
}
