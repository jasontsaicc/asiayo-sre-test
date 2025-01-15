variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "eks_version" {
  type        = string
  default     = "1.31"  
}
variable "node_instance_types" {
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_disk_size" {
  type        = number
  default     = 20
}

variable "node_scaling_config" {
  type = object({
    desired_size = number
    min_size     = number
    max_size     = number
  })
  description = "Scaling configuration for the EKS node group."
  default = {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }
}
