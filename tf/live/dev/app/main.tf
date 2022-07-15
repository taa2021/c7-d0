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
  zone      = var.yc_zone
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

#  The secure group for the deployable hosts
module "vpc-sg-self" {
  source = "../../../modules/network/vpc-sg-self"

  vpc-id     = module.vpc-network.id
  cloud-tags = var.cloud-tags
}

#  The secure group for the deployable hosts
module "vpc-sg" {
  source = "../../../modules/network/vpc-sg"

  vpc-id     = module.vpc-network.id
  cloud-tags = var.cloud-tags
}

#  The secure group for the deployable hosts
module "vpc-sg-app" {
  source = "../../../modules/network/vpc-sg"

  rules = [
    {
      predef_tgt = "cidr"
      direction  = "ingress"
      v4_cidrs   = ["0.0.0.0/0"]
      proto      = "TCP"
      from_port  = var.app_inner_port
      to_port    = var.app_inner_port
    },
  ]

  vpc-id     = module.vpc-network.id
  cloud-tags = var.cloud-tags
}


# The deployable hosts
module "bastions" {
  source = "../../../modules/compute/host1"
  count  = length(var.bastions)

  name         = "${var.deploy_stage}-bastion${count.index}l"
  region       = var.yc_zone
  subnet       = module.vpc-subnet.id
  ssh          = var.ssh_pub_key_default
  login        = var.ssh_login_default
  image-family = var.bastions[count.index].image-family
  has-eaddr    = var.bastions[count.index].has-eaddr
  mem          = var.bastions[count.index].mem
  ncpu         = var.bastions[count.index].ncpu
  vpc-sg       = "${module.vpc-sg-self.id},${module.vpc-sg.id}"

  cloud-tags = merge(var.cloud-tags, { role = "bastion", })
}

# The additional drives for k8s nodes
module "k8s-masters-drives" {
  source = "../../../modules/storage/ldrive"
  count  = length(var.k8s_masters)
  #  region     = var.yc_zone

  size       = var.dev_k8s_nbd_size
  cloud-tags = var.cloud-tags
}

# The additional drives for k8s nodes
module "k8s-workers-drives" {
  source = "../../../modules/storage/ldrive"
  count  = length(var.k8s_workers)
  #  region     = var.yc_zone

  size       = var.dev_k8s_nbd_size
  cloud-tags = var.cloud-tags
}


# The deployable hosts
module "k8s-masters" {
  source = "../../../modules/compute/host2"
  count  = length(var.k8s_masters)

  name         = "${var.deploy_stage}-master${count.index}"
  region       = var.yc_zone
  subnet       = module.vpc-subnet.id
  ssh          = var.ssh_pub_key_default
  login        = var.ssh_login_default
  image-family = var.k8s_masters[count.index].image-family
  has-eaddr    = var.k8s_masters[count.index].has-eaddr
  mem          = var.k8s_masters[count.index].mem
  ncpu         = var.k8s_masters[count.index].ncpu
  vpc-sg       = "${module.vpc-sg-self.id},${module.vpc-sg-app.id}"

  drive2-id      = module.k8s-masters-drives[count.index].id
  drive2-idlocal = "nbd0pool0"

  cloud-tags = merge(var.cloud-tags, { role = "k8s-master", k8s-node = "yes", })
}

# The deployable hosts
module "k8s-workers" {
  source = "../../../modules/compute/host2"
  count  = length(var.k8s_workers)

  name         = "${var.deploy_stage}-worker${count.index}"
  region       = var.yc_zone
  subnet       = module.vpc-subnet.id
  ssh          = var.ssh_pub_key_default
  login        = var.ssh_login_default
  image-family = var.k8s_workers[count.index].image-family
  has-eaddr    = var.k8s_workers[count.index].has-eaddr
  mem          = var.k8s_workers[count.index].mem
  ncpu         = var.k8s_workers[count.index].ncpu
  vpc-sg       = "${module.vpc-sg-self.id},${module.vpc-sg-app.id}"

  drive2-id      = module.k8s-workers-drives[count.index].id
  drive2-idlocal = "nbd0pool0"

  cloud-tags = merge(var.cloud-tags, { role = "k8s-worker", k8s-node = "yes", })
}

# The srv dns zone
module "dns-zone-srv" {
  source = "../../../modules/network/dns-zone"

  name   = var.dns_zone_srv
  vpc-id = module.vpc-network.id

  cloud-tags = var.cloud-tags
}

module "dns-srv-rs0" {
  source = "../../../modules/network/dns-record"
  count  = length(var.bastions)

  zone-id = module.dns-zone-srv.id
  name    = "${var.deploy_stage}-bastion${count.index}l"
  type    = "A"
  data    = [module.bastions[count.index].addr-int]
}

locals {
  b0_cnames = split(",", var.dns_bastion0_aliases)
}
module "dns-srv-rs1" {
  source = "../../../modules/network/dns-record"
  count  = length(local.b0_cnames)

  zone-id = module.dns-zone-srv.id
  name    = local.b0_cnames[count.index]
  type    = "CNAME"
  data    = ["${var.deploy_stage}-bastion0l.${var.dns_zone_srv}"]
}

# The k8s dns zone
module "dns-zone-k8s" {
  source = "../../../modules/network/dns-zone"

  name   = var.dns_zone_k8s
  vpc-id = module.vpc-network.id

  cloud-tags = var.cloud-tags
}

module "dns-k8s-rs0" {
  source = "../../../modules/network/dns-record"
  count  = length(var.k8s_masters)

  zone-id = module.dns-zone-k8s.id
  name    = "${var.deploy_stage}-master${count.index}"
  type    = "A"
  data    = [module.k8s-masters[count.index].addr-int]
}

module "dns-k8s-rs1" {
  source = "../../../modules/network/dns-record"
  count  = length(var.k8s_workers)

  zone-id = module.dns-zone-k8s.id
  name    = "${var.deploy_stage}-worker${count.index}"
  type    = "A"
  data    = [module.k8s-workers[count.index].addr-int]
}

# external (Internet) network load balancer
module "k8s-nlb" {
  source = "../../../modules/network/nlb-simple-http"

  hosts0-ids = module.k8s-masters[*].id
  hosts1-ids = module.k8s-workers[*].id
  port-inner = var.app_inner_port
  port-outer = 80

  cloud-tags = var.cloud-tags
  depends_on = [module.k8s-masters, module.k8s-workers]
}
