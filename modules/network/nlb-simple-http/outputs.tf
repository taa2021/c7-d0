output "id" {
  description = "The deployed network load balancer's cloud ID"

  value = yandex_lb_network_load_balancer.nlb.id
}

output "addr-ext" {
  description = "The deployed network load balancer's external IPv4 address"

  value = one(one(yandex_lb_network_load_balancer.nlb.listener).external_address_spec).address
}

output "port-inner" {
  description = "The deployed network load balancer's backends' inner TCP port (same for all backends)"

  value = var.port-inner
}

output "port-outer" {
  description = "The deployed network load balancer's external Internet TCP-port"

  value = var.port-outer
}
