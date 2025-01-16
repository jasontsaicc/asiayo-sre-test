module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  subnet_cidr  = var.subnet_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "eks" {
  source       = "./modules/eks"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids    = module.vpc.private_subnet_ids
}


module "ec2" {
  source       = "./modules/ec2"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  subnet_id    = module.vpc.public_subnet_ids
}