provider "aws" {
  region = "###AWS_LOCATION###"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

variable "aws_access_key" {
  default = "###ACCESS_KEY###"
}

variable "aws_secret_key" {
  default = "###SECRET_KEY###"
}

variable "node_type" {
  default = "###NODE_TYPE###"
}

variable "innersource_password" {
  default = "###PASSWORD###"
}

resource "aws_key_pair" "ethankey" {
  key_name   = "${var.client}-key"
  public_key = "${file("./ssh_key/###SSH_KEY_NAME###.pub")}"
}

variable "private_key" {
  default = "./ssh_key/###SSH_KEY_NAME###"
}

variable "pub_key" {
  default = "./ssh_key/###SSH_KEY_NAME###.pub"
}

variable "client" {
  description = "Name of the client"
  #TO DO: Find a way to update this based on Client Name
  default = "###CLIENT###"
}

variable "env" {
  default = "devops"
}

variable "vpc" {
  description = "VPC Vars"

  default = {
    cidr_block = "###IP_RANGE###.0.0/16"
    cidr_half  = "###IP_RANGE###"
  }
}

variable "region" {
  type        = "string"
  description = "AWS Region"
  default     = "###AWS_LOCATION###"
}

variable "availability_zone" {
  default = {
    zone1 = "a"
    zone2 = "b"
  }
}

variable "bastion" {
  default = {
    volume_size   = 20
    instance_type = "t2.micro"
    Service = "Bastion"
    ServiceComponent = "Bastion"
    NetworkTier = "Public"
  }
}

variable "node_count" {
  default = "###NODE_COUNT###"
}

variable "tools_list" {
  default = "###TOOLS###"
}

variable "ubuntu" {
  default {
    eu-west-1      = "ami-0773391ae604c49a4"
    ap-northeast-1 = "ami-06c43a7df16e8213c"
    ap-south-1     = "ami-04ea996e7a3e7ad6b"
    ap-southeast-1 = "ami-0eb1f21bbd66347fe"
    ca-central-1   = "ami-0f2cb2729acf8f494"
    eu-central-1   = "ami-086a09d5b9fa35dc7"
    sa-east-1      = "ami-0318cb6e2f90d688b"
    us-east-1      = "ami-059eeca93cf09eebd"
    us-west-1      = "ami-0ad16744583f21877"
    ap-southeast-2 = "ami-0789a5fb42dcccc10"
    eu-west-2      = "ami-061a2d878e5754b62"
    ap-northeast-2 = "ami-0e0f4ff1154834540"
    us-west-2      = "ami-0e32ec5bc225539f5"
    us-east-2      = "ami-0782e9ee97725263d"
    eu-west-3      = "ami-075b44448d2276521"
}
}
