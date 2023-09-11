locals {
  name     = "denzelrr"
  rds_name = "denzelrr_rds"
  region   = var.regionset

}

# VPC Config - From Terraform Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2"

  name = local.name
  cidr = var.vpc-cidr

  azs            = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets = [var.pubsub1cidr, var.pubsub2cidr, var.pubsub3cidr]

  create_database_subnet_group = true
  enable_dns_hostnames         = true
  enable_nat_gateway           = false
  # single_nat_gateway  = false
  # reuse_nat_ips       = true
  # external_nat_ip_ids = aws_eip.eip_nat.*.id

}

#Elastic IP for NAT Gateway
# resource "aws_eip" "eip_nat" {
#   vpc = true
# }

# resource "aws_internet_gateway" "IGW" {
# vpc_id =  module.vpc.id
# }

# # Create EIP for the IGW
# resource "aws_eip" "myEIP" {
#    vpc   = true
#  }