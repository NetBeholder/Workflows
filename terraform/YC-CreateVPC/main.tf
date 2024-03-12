resource "yandex_vpc_network" "vpc" {
    name = "${var.vpc}"
    description = "Test VPC Network"
}

#resource "yandex_vpc_subnet" "subnet-10-200-200-0" {
#    name = "subnet-10-200-200-0"
#    zone = lookup(var.zones, "zone_a")
#    network_id = yandex_vpc_network.vpc.id
#    v4_cidr_blocks = ["10.200.200.0/24"]
#}
resource "yandex_vpc_subnet" "subnet-int" {
    #for_each = tomap(local.vpc_subnets)
    # convert list of objects to map
    for_each = { for o in local.vpc_subnets: o.name => o }
    name = each.key
    zone = each.value.az
    network_id = yandex_vpc_network.vpc.id
   # v4_cidr_blocks = ["10.200.200.0/24"]
    v4_cidr_blocks = [each.value.cidr]
    route_table_id = yandex_vpc_route_table.rt[each.value.rt_name].id
}

# One dedicated NAT instace per AZ
#NAT gateway
resource "yandex_vpc_gateway" "egress-gateway" {
  for_each = toset(local.nat_gateways)
  name = each.value
  #name = "egress-gateway"
  shared_egress_gateway {}
}

# Create route tables with attached subnets and nat gateways
resource "yandex_vpc_route_table" "rt" {
  network_id = "${yandex_vpc_network.vpc.id}"
    for_each = { for t in local.rt_with_nat: t.rt_name => t }
    #for_each = toset(local.route_tables)
    name = each.key
    #name = each.value
#  static_route {
#    destination_prefix = "10.2.0.0/16"
#    next_hop_address   = "172.16.10.10"
#  }

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = "${yandex_vpc_gateway.egress-gateway[each.value.nat_name].id}"
    #gateway_id         = "${yandex_vpc_gateway.egress-gateway.id}"
  }
}

#resource "yandex_compute_disk" "vm-1-boot-disk" {
#    name = "boot-disk-1"
#    type = "network-hdd"
#    zone = lookup(var.zones, "zone_a")
#    size = 15
#  
#}

#resource "yandex_compute_instance" "vm-1" {
#  name = "terraform1"
#  platform_id = "standard-v1"
#
#  resources {
#    cores = 2
#    memory = 2
#    
#  }
#  zone = lookup(var.zones, "zone_a")
#    boot_disk {
#      disk_id = yandex_compute_disk.vm-1-boot-disk.id
#    }
#    network_interface {
#        subnet_id = yandex_vpc_subnet.subnet-10-200-200-0.id
#        nat = true
#    }
#}
