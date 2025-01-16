# 呼叫 VPC、EKS、EC2 等模組 (modules),大部分參數都透過variables傳入, 完成變數化及模組化的設計


# 建立VPC module
module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  subnet_cidr  = var.subnet_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# 建立 EKS Cluster 以及 Node Group
module "eks" {
  source       = "./modules/eks"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids    = module.vpc.private_subnet_ids
}

# 建立 EC2 instance當做連進EKS的Bastion
module "ec2" {
  source       = "./modules/ec2"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  subnet_id    = module.vpc.public_subnet_ids
}