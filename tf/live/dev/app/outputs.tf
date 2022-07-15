output "bastions" {
  description = "The deployed hosts - bastions"

  value = module.bastions[*]
}

output "k8s_masters" {
  description = "The deployed hosts - k8s masters"

  value = module.k8s-masters[*]
}

output "k8s_workers" {
  description = "The deployed hosts - k8s workers"

  value = module.k8s-workers[*]
}

output "cidr_subnet" {
  description = "Local subnet's cidr"

  value = var.subnet
}

output "app_ext_access" {
  description = "The App's params for the external access"

  value = { addr = module.k8s-nlb.addr-ext, port = module.k8s-nlb.port-outer, }
}
