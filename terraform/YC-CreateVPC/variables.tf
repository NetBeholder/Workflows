variable "project_name" {
  description = "Name of the project. Used in resource names and tags."
  type        = string
  default     = "test-app"
}

variable "environment" {
  description = "Value of the 'Environment' tag."
  type        = string
  default     = "dev"
}

variable "yc_zones" {
    type = list(string)
    default = ["ru-central1-a",
            "ru-central1-b",
            "ru-central1-c",
            "ru-central1-d"]
    description = "YC availability zones list"
}

#variable "public_subnets_per_vpc" {
#  description = "Number of public subnets. Maximum of 16."
#  type        = number
#  default     = 2
#}
#
#variable "private_subnets_per_vpc" {
#  description = "Number of private subnets. Maximum of 16."
#  type        = number
#  default     = 2
#}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "zones" {
    type = map
    default = {
    "zone-a" = "ru-central1-a"
    "zone-b" = "ru-central1-b"
    "zone-c" = "ru-central1-c"
    "zone-d" = "ru-central1-d"
    }
  description = "Yandex Cloud availability zones"
}

variable "vpc" {
    type = string
    default = "my-yc-vpc-network"
  
}

locals {
    vpc_subnets = [
    {    
        name = "subnet-10-200-0-0"
        az = lookup(var.zones, "zone-a")
        rt_name = format("%s-%s-%s", "${var.vpc}", "rt", "zone-a")
        cidr = "10.200.0.0/24"     
    },
    {    
        name = "subnet-10-200-50-0"
        az = lookup(var.zones, "zone-b")
        rt_name = format("%s-%s-%s", "${var.vpc}", "rt", "zone-b")
        cidr = "10.200.50.0/24"     
    },
    {    
        name = "subnet-10-200-100-0"
        az = lookup(var.zones, "zone-d")
        rt_name = format("%s-%s-%s", "${var.vpc}", "rt", "zone-d")
        cidr = "10.200.100.0/24"     
    }
    ]
    route_tables = [
        "${var.vpc}-rt-zone-a",
        "${var.vpc}-rt-zone-b",
        "${var.vpc}-rt-zone-d"
    ]
    nat_gateways = [
        "nat-gw-zone-a",
        "nat-gw-zone-b",
        "nat-gw-zone-d"
    ]
    rt_with_nat = [ for k,v in zipmap(local.route_tables, local.nat_gateways): {
        rt_name = k
        nat_name = v
    }]
}

#locals "vpc_subnets" {
#    description = "List of VPC's subnets"
#    type = list(object({
#        name = string
#        zone = string
#        #network_id = string
#        v4_cidr_blocks = list(string)
#    }))
#    default = [ {
#        name = "subnet-10-200-200-0"
#        zone = lookup(var.zones, "zone_a")
#        #network_id = yandex_vpc_network.my-vpc-network.id
#        v4_cidr_blocks = ["10.200.200.0/24", "10.200.220.0/24"]
#    }]
#}
