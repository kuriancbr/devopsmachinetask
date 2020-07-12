variable "aws_region" {
  description = "EC2 Region for the VPC "
  default     = "us-east-1"
}

variable "amis" {
  description = "AMIs by region"
  default = {
    us-east-1 = "ami-02ae530dacc099fc9" # Amazon Linux AMI 2018.03.0
  }
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the Public Subnet"
  default     = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the Private Subnet"
  default     = "10.0.1.0/24"
}