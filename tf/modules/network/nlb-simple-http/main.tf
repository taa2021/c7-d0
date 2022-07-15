terraform {
  required_providers {
    yandex = { source = "yandex-cloud/yandex", version = "~>0.70.0" }
  }
}

data "yandex_compute_instance" "hosts0" {
  count = length(var.hosts0-ids)

  instance_id = var.hosts0-ids[count.index]
}

data "yandex_compute_instance" "hosts1" {
  count = length(var.hosts1-ids)

  instance_id = var.hosts1-ids[count.index]
}

data "yandex_compute_instance" "hosts2" {
  count = length(var.hosts2-ids)

  instance_id = var.hosts2-ids[count.index]
}

resource "yandex_lb_target_group" "nlb-tg" {
  dynamic "target" {
    for_each = range(length(var.hosts0-ids))
    content {
      subnet_id = data.yandex_compute_instance.hosts0[target.key].network_interface.0.subnet_id
      address   = data.yandex_compute_instance.hosts0[target.key].network_interface.0.ip_address
    }
  }

  dynamic "target" {
    for_each = range(length(var.hosts1-ids))
    content {
      subnet_id = data.yandex_compute_instance.hosts1[target.key].network_interface.0.subnet_id
      address   = data.yandex_compute_instance.hosts1[target.key].network_interface.0.ip_address
    }
  }

  dynamic "target" {
    for_each = range(length(var.hosts2-ids))
    content {
      subnet_id = data.yandex_compute_instance.hosts2[target.key].network_interface.0.subnet_id
      address   = data.yandex_compute_instance.hosts2[target.key].network_interface.0.ip_address
    }
  }

  labels = var.cloud-tags
}

resource "random_id" "rname" {
  count       = 2
  byte_length = 8
}

resource "yandex_lb_network_load_balancer" "nlb" {
  listener {
    name = "n${random_id.rname[0].hex}"

    port        = var.port-outer
    target_port = var.port-inner
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.nlb-tg.id

    healthcheck {
      name = "n${random_id.rname[1].hex}"
      http_options {
        port = var.port-inner
        path = var.healthcheck-path
      }
    }
  }

  labels = var.cloud-tags
}
