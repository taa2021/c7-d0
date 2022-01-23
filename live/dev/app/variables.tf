
variable "hosts" {
  description = "The setting templates for the cloud hosts"

  type = list(
    object({
      region       = string
      subnet       = string
      image-family = string
      has-eaddr    = bool
      ssh          = string
  }))

  default = [
    {
      region       = "ru-central1-a"
      subnet       = "192.168.1.0/28"
      image-family = "lemp"
      has-eaddr    = true
      ssh          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAHvfDvfxMVMfxvWVHoVik+m7xVfUC7RpThrDJAFpkc6qQHM/n3CV8aPny8b5zG86F7vuV0RxlOOLJZPEBeHW4MnCLE9uH+8kssioLyBekF/N8poewkzeNMAsx+rXt8PmZuLqthhdvjJaC9FNuqmjDzermNPv9RXR7FOpC6kKk3KlOszyiL0+/dIenQzyz//DG2AsAnnB3zKDEGAg+Nyo2Z0NFmuRKHNa0D0ezFMB34FPjw7eyBoYb/UwX46ANmPdqZGsi13up3tOAZ/uZdyZ2ksJ90vXrxEwi8J+8kEoKi+UYNpAjYAb4KVuPG+7aNgorC6i0nYHHJ7JJnsHbbNY+28="
    },
    {
      region       = "ru-central1-b"
      subnet       = "192.168.1.16/28"
      image-family = "lamp"
      has-eaddr    = true
      ssh          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAHvfDvfxMVMfxvWVHoVik+m7xVfUC7RpThrDJAFpkc6qQHM/n3CV8aPny8b5zG86F7vuV0RxlOOLJZPEBeHW4MnCLE9uH+8kssioLyBekF/N8poewkzeNMAsx+rXt8PmZuLqthhdvjJaC9FNuqmjDzermNPv9RXR7FOpC6kKk3KlOszyiL0+/dIenQzyz//DG2AsAnnB3zKDEGAg+Nyo2Z0NFmuRKHNa0D0ezFMB34FPjw7eyBoYb/UwX46ANmPdqZGsi13up3tOAZ/uZdyZ2ksJ90vXrxEwi8J+8kEoKi+UYNpAjYAb4KVuPG+7aNgorC6i0nYHHJ7JJnsHbbNY+28="
    },
  ]
}


variable "yc_iam_token" {
  description = "Yandex.Cloud IAM-token for the provider auth. Attention: don't set directly in a tracked git-file"

  type      = string
  sensitive = true
}

variable "yc_zone" {
  description = "Yandex.Cloud zone default"

  type    = string
  default = "ru-central1-a"
}

variable "yc_cloud_id" {
  description = "Yandex.Cloud ID default"

  type    = string
  default = "b1gjilr27b0mqp90rj46"
}

variable "yc_folder_id" {
  description = "Yandex.Cloud Folder ID default"

  type    = string
  default = "b1gjo8k8qajfr6ftho2n"
}

variable "cloud-tags" {
  description = "The Terraform object's cloud tags/labels"

  type    = map(any)
  default = { terraform = true, environment = "dev" }
}
