### General Variables ###

variable "regionset" {
  type        = string
  description = "The Region name "
  default     = "us-west-2"
}

variable "aws_account" {
  type        = string
  description = "AWS account"
  default     = "725605092983"
}


variable "domain_name" {
  type        = string
  description = "The domain name for the website."
  default     = "renanzinsite.com"
}

variable "r53_zone_id" {
  type        = string
  description = "The zone ID of the domain you are deploying to, you can get it from R53 DNS Dashboard"
  default     = "Z002051618M4QHG4VM3M6"
}

### EC2 Values ###
variable "instance_type" {
  type        = string
  description = "Define the EC2 Instance type for the ecs cluster"
  default     = "t3.medium"
}

### ECS ###
variable "container_image" {
  type        = string
  description = "Define what docker image will be deployed to the ECS task"
  default     = "725605092983.dkr.ecr.us-west-2.amazonaws.com/ecrrepo2:latest"
}

# variable "container_image" {
#   type        = string
#   description = "Define what docker image will be deployed to the ECS task"
#   default     = "nginx"
# }
#Temporary credentials / lack of permission on acg Lab 

variable "accessKey" {
  type        = string
  description = "acess key statica"
  default     = "AKIA4USHVNXFYMIFZ56A"
}

variable "secretKey" {
  type        = string
  description = "Secret key statica"
  default     = "cBeCnbDsbGfetp+xj58w6FECh9+kEwejCiMs071V"
}


variable "vpc-cidr" {
  type    = string
  default = "172.31.0.0/16"
}

variable "pubsub1cidr" {
  default = "172.31.0.0/20"
}

variable "pubsub2cidr" {
  default = "172.31.16.0/20"
}

variable "pubsub3cidr" {
  default = "172.31.32.0/20"
}

variable "image_id" {
  default = "ami-04e35eeae7a7c5883"
}

variable "image_ecs_id" {
  default = "ami-02a4b44230bc8650a"

}


variable "key_name" {
  type    = string
  default = "denzelkeyname"
}



### RDS

variable "namedb" {
  description = "Name of DB"
  type        = string
  sensitive   = true
  default     = "DBNAMEPOSTGRES"
}


variable "usernameDB" {
  description = "The master username for the database."
  type        = string
  sensitive   = true

}

variable "passwordDB" {
  description = "The master password for the database."
  type        = string
  sensitive   = true
}