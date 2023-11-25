# Region
variable "aws_region" {
  default = "us-east-1"
}

# Profile
variable "aws_profile" {
    default = "default"
}
//archivo local, cambiar según la ubicación
variable "shared_credentials_file" {
  default = "/Users/Usuario/.aws/credentials"
}

# VPC CIDR Block
variable "vpc_cidr" {
  default = "172.40.0.0/16"
}

# Subnet 1 CIDR Block
variable "subnet_public_cidr" {
  default = "172.40.1.0/24"
}

# Subnet 2 CIDR Block
variable "subnet_private_cidr" {
  default = "172.40.2.0/24"
}

# Subnet 3 CIDR Block
variable "subnet_public2_cidr" {
  default = "172.40.3.0/24"
}

# Subnet 4 CIDR Block
variable "subnet_private2_cidr" {
  default = "172.40.4.0/24"
}

########## EC2 Instance #########

# KeyPair
variable "aws_keypair" { //la keypair que se crea en EC2
  default = "KP-labITM-1"
}
# Amazon Linux 2 AMI
variable "ec2_terraform_ami" {
  default = "ami-09988af04120b3591"
}
# EC2  Instance quantity
variable "ec2_terraform_instance_quantity" {
  default = 1
}
# EC2 Joomla Instance Name
variable "ec2_terraform_instance_name" {
  default = "Amazon Linux Terraform ITMLab VSCode"
}
# EC2  Instance Type
variable "ec2_joomla_instance_type" {
  default = "t2.micro"
}
# EC2  EBS Name
variable "ec2_joomla_ebs_name" {
  default = "/dev/sda1"
}
# EC2  EBS Size
variable "ec2_joomla_ebs_size" {
  default = 10
}
#EC2 Joomla EBS Type
variable "ec2_joomla_ebs_type" {
  default = "gp2"
}
# RDS Allocated Storage
variable "rds_allocated_storage" {
  default = 20
}
# RDS DB Name
variable "rds_db_name" {
  default = "dbvscodeterraform"
}
# RDS Identifier
variable "rds_identifier" {
  default = "dbvscodeterraform"
}
# RDS DB Engine
variable "rds_engine" {
  default = "mysql"
}
# RDS DB Engine Version
variable "rds_engine_version" {
  default = "5.7.37"
}
# RDS Instance Class
variable "rds_instance_class" {
  default = "db.t3.micro"
}
# RDS Master Username
variable "rds_username" {
  default = "LaboratorioITM"
}
# RDS Master User Password
variable "rds_password" {
  default = "itm2000iac"
}
# RDS Subnet Group
variable "rds_db_subnet_group_name" {
  default = "sng_labitm_terraform"
}
# RDS Multi AZ
variable "rds_multi_az" {
  default = false
}
# RDS Publicly Accessible
variable "rds_publicly_accessible" {
  default = true
}

##cambiar la direccion de acuerdo a la ip publica {
variable "public_ip" {
  default     = "181.128.36.55/32"
}