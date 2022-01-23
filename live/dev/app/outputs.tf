
output "hosts" {
  description = "The deployed hosts' external IPv4 addresses (separated with '\\n')"

  value = local.hosts-addr-ext
}

output "hosts-port" {
  description = "The deployed hosts' external TCP port"

  value = local.hosts-port
}

output "nlb" {
  description = "The deployed network load balancer's external IPv4 address"

  value = local.nlb-addr-ext
}

output "nlb-port" {
  description = "The deployed network load balancer's external TCP port"

  value = local.nlb-port
}
