variable "deploy_stage" {
  description = "Deploy stage"

  type    = string
  default = "dev"
}

variable "subnet" {
  description = "Yandex.Cloud zone default"

  type = string
}

variable "ssh_login_default" {
  description = "The ssh login for the cloud hosts"

  type = string
}

variable "ssh_pub_key_default" {
  description = "The ssh public key for the cloud hosts"

  type = string
}

variable "dev_k8s_nbd_size" {
  description = "The k8s dev cluster drive's size"

  type = number
}

variable "bastions" {
  description = "The setting templates for the cloud hosts"

  type = list(
    object({
      image-family = string
      has-eaddr    = bool
      mem          = number
      ncpu         = number
  }))

  default = [
    {
      image-family = "ubuntu-2004-lts"
      has-eaddr    = true
      mem          = 6
      ncpu         = 4
    },
  ]
}


variable "k8s_masters" {
  description = "The setting templates for the cloud hosts"

  type = list(
    object({
      image-family = string
      has-eaddr    = bool
      mem          = number
      ncpu         = number
  }))

  default = [
    {
      image-family = "ubuntu-2004-lts"
      has-eaddr    = false
      mem          = 4
      ncpu         = 4
    },
  ]
}


variable "k8s_workers" {
  description = "The setting templates for the cloud hosts"

  type = list(
    object({
      image-family = string
      has-eaddr    = bool
      mem          = number
      ncpu         = number
  }))

  default = [
    {
      image-family = "ubuntu-2004-lts"
      has-eaddr    = false
      mem          = 4
      ncpu         = 4
    },
    #    {
    #      image-family = "ubuntu-2004-lts"
    #      has-eaddr    = false
    #      mem          = 4
    #      ncpu         = 4
    #    },
  ]
}


variable "dns_zone_k8s" {
  description = "DNS-name of the k8s zone"

  type = string
}


variable "dns_zone_srv" {
  description = "DNS-name of the srv zone"

  type = string
}

variable "dns_bastion0_aliases" {
  description = "DNS-name of the cnames for the bastion0l host"

  type = string
}


variable "app_inner_port" {
  description = "The inner port on k8s nodes for the app"

  type = number
}



variable "yc_iam_token" {
  description = "Yandex.Cloud IAM-token for the provider auth. Attention: don't set directly in a tracked git-file"

  type      = string
  sensitive = true
}

variable "yc_cloud_id" {
  description = "Yandex.Cloud ID default"

  type = string
}

variable "yc_folder_id" {
  description = "Yandex.Cloud Folder ID default"

  type = string
}

variable "yc_zone" {
  description = "Yandex.Cloud zone default"

  type    = string
  default = "ru-central1-a"
}
variable "cloud-tags" {
  description = "The Terraform object's cloud tags/labels"

  type    = map(any)
  default = { terraform = true, environment = "dev" }
}
