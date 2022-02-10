variable "subnet" {
  description = "Yandex.Cloud zone default"

  type    = string
  default = "192.168.1.0/28"
}

#      ssh          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAHvfDvfxMVMfxvWVHoVik+m7xVfUC7RpThrDJAFpkc6qQHM/n3CV8aPny8b5zG86F7vuV0RxlOOLJZPEBeHW4MnCLE9uH+8kssioLyBekF/N8poewkzeNMAsx+rXt8PmZuLqthhdvjJaC9FNuqmjDzermNPv9RXR7FOpC6kKk3KlOszyiL0+/dIenQzyz//DG2AsAnnB3zKDEGAg+Nyo2Z0NFmuRKHNa0D0ezFMB34FPjw7eyBoYb/UwX46ANmPdqZGsi13up3tOAZ/uZdyZ2ksJ90vXrxEwi8J+8kEoKi+UYNpAjYAb4KVuPG+7aNgorC6i0nYHHJ7JJnsHbbNY+28="

variable "ssh_pub_key_default" {
  description = "The ssh public key for the cloud hosts"

  type = string
}


variable "hosts" {
  description = "The setting templates for the cloud hosts"

  type = list(
    object({
      image-family = string
      has-eaddr    = bool
      login        = string
  }))

  default = [
    {
      image-family = "ubuntu-2004-lts"
      has-eaddr    = true
      login        = "ruser0"
    },
  ]
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
