
# Label

output "id" {
  value       = module.label.enabled ? module.label.id : ""
  description = "Disambiguated ID restricted to `id_length_limit` characters in total"
}

output "id_full" {
  value       = module.label.enabled ? module.label.id_full : ""
  description = "Disambiguated ID not restricted in length"
}

# VPC

output "database_internet_gateway_route_id" {
  value = module.vpc.database_internet_gateway_route_id
}

output "database_subnets_ids" {
  value = module.vpc.database_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

output "database_subnet_group" {
  value = module.vpc.database_subnet_group
}

output "database_subnet_arns" {
  value = module.vpc.database_subnet_arns
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "default_vpc_arn" {
  value = module.vpc.default_vpc_id
}

output "default_vpc_id" {
  value = module.vpc.default_vpc_id
}

output "default_vpc_main_route_table_id" {
  value = module.vpc.default_vpc_main_route_table_id
}

output "default_vpc_default_route_table_id" {
  value = module.vpc.default_vpc_default_route_table_id
}

output "vpc_endpoint_elasticbeanstalk_id" {
  value = module.vpc.vpc_endpoint_elasticbeanstalk_id
}

output "vpc_endpoint_elasticbeanstalk_network_interface_ids" {
  value = module.vpc.vpc_endpoint_elasticbeanstalk_network_interface_ids
}

output "vpc_endpoint_elasticbeanstalk_dns_entry" {
  value = module.vpc.vpc_endpoint_elasticbeanstalk_dns_entry
}

output "vpc_endpoint_ec2_id" {
  value = module.vpc.vpc_endpoint_ec2_id
}

output "vpc_endpoint_ec2_dns_entry" {
  value = module.vpc.vpc_endpoint_ec2_dns_entry
}

output "vpc_endpoint_ec2_network_interface_ids" {
  value = module.vpc.vpc_endpoint_ec2_network_interface_ids
}

output "vpc_arn" {
  value = module.vpc.vpc_arn
}

output "vgw_id" {
  value = module.vpc.vgw_id
  description = "The ID of the VPN Gateway"
}

output "vgw_arn" {
  value = module.vpc.vgw_arn
  description = "The arn of the VPN Gateway"
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "public_subnet_arns" {
  value = module.vpc.public_subnet_arns
}

output "public_subnets_cidr_blocks" {
  value = module.vpc.public_subnets_cidr_blocks
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "private_subnet_arns" {
  value = module.vpc.private_subnet_arns
}

output "private_subnets_cidr_blocks" {
  value = module.vpc.private_subnets_cidr_blocks	
}

output "public_internet_gateway_route_id" {
  value = module.vpc.public_internet_gateway_route_id
}

output "natgw_ids" {
  value = module.vpc.natgw_ids
}

output "nat_public_ips" {
  value = module.vpc.nat_public_ips
}

output "nat_ids" {
  value = module.vpc.nat_ids
}

output "name" {
  value = module.vpc.name
}

output "igw_arn" {
  value = module.vpc.igw_arn
  description = "The ARN of the Internet Gateway"
}

output "igw_id" {
  value = module.vpc.igw_id
  description = "The ID of the Internet Gateway"
}




