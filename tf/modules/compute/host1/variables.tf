variable "name" {
  description = "Cloud name for the deployable host"

  type    = string
  default = ""
}


variable "region" {
  description = "Cloud zone/region for the deployable host"

  type = string
}

variable "subnet" {
  description = "Cloud subnet's ID for the deployable host"

  type = string
}

variable "vpc-sg" {
  description = "Cloud vpc security groups IDs for the deployable host"

  type    = string
  default = ""
}

variable "image-family" {
  description = "Cloud image family for the deployable host"

  type = string
}

variable "platform" {
  description = "Cloud platform for the deployable host"

  type    = string
  default = "standard-v1"
}

variable "mem" {
  description = "RAM size (GiB) for the deployable host"

  type    = number
  default = 4
}

variable "ncpu" {
  description = "Amount of CPU's for the deployable host"

  type    = number
  default = 2
}

variable "cpu-fraq" {
  description = "The reserved share of processor (%) for the deployable host"

  type    = number
  default = 20
}

variable "boot-disk-size" {
  description = "The reserved size of boot disk for the deployable host"

  type    = number
  default = 20 # GB
}

variable "is-preemptible" {
  description = "Predicate: is cheaper setup config with sudden shutdown for the deployable host?"

  type    = bool
  default = false
}

variable "has-eaddr" {
  description = "Predicate: is needed external Internet IP-address for the deployable host?"

  type    = bool
  default = false
}

variable "login" {
  description = "The (ssh) user login-name for the deployable host's default user account"

  type    = string
  default = "user"
}

variable "ssh" {
  description = "The ssh public key for the deployable host's default user account"

  type = string
}

variable "cloud-tags" {
  description = "The Terraform object's cloud tags/labels"

  type    = map(any)
  default = {}
}
