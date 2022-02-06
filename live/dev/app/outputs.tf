
output "hosts" {
  description = "The deployed hosts' internal IPv4 addresses (separated with '\\n')"

  value = local.hosts-addr-int
}

output "ehost" {
  description = "The deployed border host's external IPv4 address"

  value = local.host0-addr-ext
}

output "ansible-inventory" {
  description = "The ansible inventory file"

  value = local.ansible-inventory
}
