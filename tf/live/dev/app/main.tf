terraform {
  required_version = "= 1.1.3"

  backend "s3" {
    skip_region_validation      = true
    skip_credentials_validation = true
  }

  required_providers {
    yandex = { source = "yandex-cloud/yandex", version = "~>0.70.0" }
  }
}

provider "yandex" {
  token     = var.yc_iam_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
}

# The network for the deployable infrastructure
module "vpc-network" {
  source     = "../../../modules/network/vpc"
  cloud-tags = var.cloud-tags
}

#  The subnet for the deployable hosts
module "vpc-subnet" {
  source = "../../../modules/network/subnet"

  cidr       = var.subnet
  region     = var.yc_zone
  vpc-id     = module.vpc-network.id
  cloud-tags = var.cloud-tags
}


# The deployable hosts
module "hosts" {
  source = "../../../modules/compute/host"
  count  = length(var.hosts)

  region       = var.yc_zone
  subnet       = module.vpc-subnet.id
  image-family = var.hosts[count.index].image-family
  has-eaddr    = var.hosts[count.index].has-eaddr
  login        = var.hosts[count.index].login
  ssh          = var.ssh_pub_key_default

  cloud-tags = var.cloud-tags
}
