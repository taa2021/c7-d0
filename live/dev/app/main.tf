terraform {
  required_version = "= 1.1.3"

  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket   = "tf--c2-br-7--2"
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

#  The subnets for the deployable hosts
module "vpc-subnets" {
  source = "../../../modules/network/subnet"
  count  = length(var.hosts)

  cidr       = var.hosts[count.index].subnet
  region     = var.hosts[count.index].region
  vpc-id     = module.vpc-network.id
  cloud-tags = var.cloud-tags
}

/*
# The external reserved IPv4-addresses fo the deployable hosts
module "vpc-ipv4eaddrs" {
    source = "../../../modules/network/ipv4eaddr"
    count = length(var.hosts)

    region = var.hosts[count.index].region
    cloud-tags = var.cloud-tags
}
*/

# The deployable hosts
module "web-servers" {
  source = "../../../modules/compute/host"
  count  = length(var.hosts)

  region       = var.hosts[count.index].region
  subnet       = module.vpc-subnets[count.index].id
  image-family = var.hosts[count.index].image-family
  has-eaddr    = var.hosts[count.index].has-eaddr
  ssh          = var.hosts[count.index].ssh

  cloud-tags = var.cloud-tags
}

# The deployable network load balancer
module "nlb" {
  source    = "../../../modules/network/nlb-simple-http"
  hosts-ids = module.web-servers[*].id

  cloud-tags = var.cloud-tags
}

locals {
  hosts-addr-ext = join("\n", module.web-servers[*].addr-ext)
  hosts-port     = module.nlb.port-inner
  nlb-addr-ext   = module.nlb.addr-ext
  nlb-port       = module.nlb.port-outer
}

# The visual verification of deployment results
resource "null_resource" "check-results" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
        echo "!!!-> `date` start checking..."

        function webprint() {
            descr=$1
            addr=$2
            port=$3
            num=$4
            seq $num | while read I; do
                /usr/bin/echo -e "==================================\n`date` $${descr} addr: $${addr}"
                curl -L http://$addr:$port 2>/dev/null | html2text |  grep -v "^$" | head -n 2
            done
        }

        echo "${local.hosts-addr-ext}" | while read A; do webprint hst $A "${local.hosts-port}" 1; done;
        echo "${local.nlb-addr-ext}"   | while read A; do webprint nlb $A "${local.nlb-port}"  10; done;

        echo "!!!<- `date` end checking!"
        EOT
  }
}
