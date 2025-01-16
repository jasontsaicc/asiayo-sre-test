# 將建立後的 VPC, EKS, ec2重要資訊輸出，方便確認資源的ID, Name, Endpoint
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_ids" {
  value       = module.vpc.nat_gateway_ids
}

output "vpc_cidr_block" {
  value       = module.vpc.vpc_cidr_block
}

# EKS Outputs
output "eks_cluster_name" {
  value       = module.eks.eks_cluster_name
}

output "eks_cluster_endpoint" {
  value       = module.eks.eks_cluster_endpoint
}

output "eks_node_group_name" {
  value       = module.eks.eks_node_group_name
}
