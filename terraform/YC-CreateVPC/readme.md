# Terraform script dedicated for creating VPC in Yandex Cloud

## Scenario:
1. Create VPC with 3 subnets:
   - VPC: my-yc-vpc-network
   - subnet-10-200-0-0:
     - AZ: zone_a
      - cidr: 10-200-0-0/24
      - routing table: "${var.vpc}-rt-zone-a"
   - subnet-10-200-50-0:
     - AZ: zone_b
     - cidr: 10-200-50-0/24
     - routing table: "${var.vpc}-rt-zone-b"
   - subnet-10-200-100-0:
     - AZ: zone_b
     - cidr: 10-200-50-0/24
     - routing table: "${var.vpc}-rt-zone-d"
3. All subnets are in different availability zones
4. Each subnet is routed through its own dedicated NAT gateway and routing table
## How to start:
1. Configure access to the cloud according to the [instructions](https://cloud.yandex.ru/ru/docs/tutorials/infrastructure-management/terraform-quickstart)
2. Load environment variables:
   ```
   source .prepare
   ```
3. And execute shell commands from working directory:
   ```
   terraform init
   terraform plan
   terraform apply
   ...
   terraform destroy
   ```
