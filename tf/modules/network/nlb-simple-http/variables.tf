variable "port-inner" {
  description = "The deployable network load balancer's backends' inner TCP port (same for all backends)"

  type    = number
  default = 80
}

variable "port-outer" {
  description = "The deployable network load balancer's external Internet TCP-port"

  type    = number
  default = 80
}

variable "healthcheck-path" {
  description = "The deployable network load balancer backend hosts' (http) health check path"

  type    = string
  default = "/"
}

variable "hosts-ids" {
  description = "The deployable network load balancer backend hosts' cloud IDs"

  type = list(string)
}

variable "cloud-tags" {
  description = "The Terraform object's cloud tags/labels"

  type    = map(any)
  default = {}
}
