variable "vpc_name" {
  description = "This is the VPC name"
  type        = string
}

variable "aws_region" {
  description = "The region to deploy resources"
  type        = string
}

variable "vpc_cidr" {
  description = "This is the CIDR of VPC"
}


variable "cidr_public_1" {
  description = "This is the CIDR of the public subnet_1"
}

variable "cidr_public_2" {
  description = "This is the CIDR of the public subnet_2"
}

variable "cidr_private_1" {
  description = "This is the CIRD block of the private subnet_1"
}

variable "cidr_private_2" {
  description = "This is the CIRD block of the private subnet_2"
}

variable "az_1" {
  description = "The region to deploy resources"
  type        = string
}

variable "az_2" {
  description = "The region to deploy resources"
  type        = string
}