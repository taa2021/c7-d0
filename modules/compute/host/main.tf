terraform {
  required_providers {
    yandex = { source = "yandex-cloud/yandex", version = "~>0.70.0" }
  }
}

data "yandex_compute_image" "image" {
  family = var.image-family
}

resource "yandex_compute_instance" "host" {
  zone        = var.region
  platform_id = var.platform

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
    }
  }

  network_interface {
    subnet_id = var.subnet
    nat       = var.has-eaddr
  }

  metadata = {
    ssh-keys = "${var.login}:${var.ssh}"
  }

  labels = var.cloud-tags
}
