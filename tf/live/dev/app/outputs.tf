output "hosts" {
  description = "The deployed hosts' external IPv4 addresses (separated with '\\n')"

  value = join("\n", module.hosts[*].addr-ext)
}

/*
output "ehost" {
  description = "The deployed border host's external IPv4 address"

  value = local.host0-addr-ext
}

output "ansible-inventory" {
  description = "The ansible inventory file"

  value = local.ansible-inventory
}
*/
