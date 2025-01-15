resource "aws_security_group" "ec2_public_sg" {
  name        = "${var.project_name}-ec2-public-sg"
  vpc_id      = var.vpc_id

  # Ingress: Allow SSH from anywhere (adjust as needed)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress: Allow access to EKS nodes (adjust ports if needed)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-public-sg"
  }
}

resource "aws_instance" "ec2_public" {
  ami           = var.ami_id
  instance_type = var.instance_type                  
  subnet_id     = var.subnet_id [0]
#   key_name      = var.ssh_key_name               # SSH Key，用於連接 EC2

  # 指定 Security Group
  vpc_security_group_ids = [
    aws_security_group.ec2_public_sg.id
  ]

  # 自動分配公共 IP
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-public-ec2"
  }
}