terraform {
  required_version = "= 1.1.3"

  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket   = "tf--c2-b6-pr6--0"
    region   = "ru-central1-a"
    key      = "dev/app/terraform.tfstate"

    # env AWS_ACCESS_KEY_ID
    #    access_key=""
    # env AWS_SECRET_ACCESS_KEY
    #    secret_key=""

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
  ssh          = var.hosts[count.index].ssh

  cloud-tags = var.cloud-tags
}

locals {
  hosts-addr-int = join("\n", module.hosts[*].addr-int)
  host0-addr-ext = module.hosts[0].addr-ext
  host0-addr-int = module.hosts[0].addr-int

  ansible-configs = [
    {
      src = "${path.module}/templates/inventory.tftpl"
      dst = "${path.module}/conf/inventory"
    },
    {
      src = "${path.module}/templates/bootstrap-bastion-0.yml.tfpl"
      dst = "${path.module}/conf/bootstrap-bastion-0.yml"
    },
    {
      src = "${path.module}/templates/bootstrap-bastion-1.yml.tfpl"
      dst = "${path.module}/conf/bootstrap-bastion-1.yml"
    },
    {
      src = "${path.module}/templates/bootstrap-bastion-2.yml.tfpl"
      dst = "${path.module}/conf/bootstrap-bastion-2.yml"
    },
    {
      src = "${path.module}/templates/bootstrap-bastion-3.yml.tfpl"
      dst = "${path.module}/conf/bootstrap-bastion-3.yml"
    },
  ]

  etc-configs = [
    {
      src = "${path.module}/templates/iptables-rules-v4.tfpl"
      dst = "${path.module}/conf/iptables-rules-v4"
    },
    {
      src = "${path.module}/templates/ssh-via-bastion.config.tfpl"
      dst = "${path.module}/conf/ssh-via-bastion.config"
    },
    {
      src = "${path.module}/templates/00-apt-proxy.conf.tfpl"
      dst = "${path.module}/conf/roles/common/files/00-apt-proxy.conf"
    },
    {
      src = "${path.module}/templates/common-vars-main.yml.tfpl"
      dst = "${path.module}/conf/roles/common/vars/main.yml"
    },

  ]
}

resource "local_file" "ansible-configs" {
  count = length(local.ansible-configs)
  content = templatefile(local.ansible-configs[count.index].src, {
    hosts    = module.hosts[*].addr-int,
    bastion  = local.host0-addr-ext,
    bastionl = local.host0-addr-int,
    ulogin   = var.hosts[0].login,
    subnet   = var.subnet,
  })
  file_permission = "0644"
  filename        = local.ansible-configs[count.index].dst
}

resource "local_file" "etc-configs" {
  count = length(local.etc-configs)
  content = templatefile(local.etc-configs[count.index].src, {
    hosts    = module.hosts[*].addr-int,
    bastion  = local.host0-addr-ext,
    bastionl = local.host0-addr-int,
    ulogin   = var.hosts[0].login,
    subnet   = var.subnet,
  })
  file_permission = "0644"
  filename        = local.etc-configs[count.index].dst
}


locals {
  ansible-inventory = resource.local_file.ansible-configs[0].filename
}




# The visual verification of deployment results
resource "null_resource" "wait" {
  provisioner "local-exec" { command = "sleep 180" }
  depends_on = [
    module.hosts,
    local.ansible-configs,
  ]
}

# The hosts' provision
resource "null_resource" "provision" {
  triggers = { always_run = timestamp() }

  provisioner "local-exec" {
    command     = "--"
    interpreter = concat(["ansible-playbook", "-i"], local.ansible-configs[*].dst)
  }

  depends_on = [
    null_resource.wait,
  ]
}
