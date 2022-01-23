output "id" {
  description = "The cloud ID for external Internet IPv4-address"

  value = yandex_vpc_address.addr.id
}

output "address" {
  description = "The cloud external Internet IPv4-address"

  value = yandex_vpc_address.addr.external_ipv4_address[0].address
}
