output "id" {
  description = "The yandex.cloud deployed host's ID"

  value = yandex_compute_instance.host.id
}

output "addr-int" {
  description = "The yandex.cloud deployed host's internal Intranet IP-address"

  value = yandex_compute_instance.host.network_interface.0.ip_address
}

output "addr-ext" {
  description = "The yandex.cloud deployed host's external Internet IP-address"

  value = var.has-eaddr ? yandex_compute_instance.host.network_interface.0.nat_ip_address : "-"
}
