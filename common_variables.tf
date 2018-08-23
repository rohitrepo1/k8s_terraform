provider "aws" {
  region = "eu-west-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

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

variable "ubuntu" {
  default {
    eu-west-1      = "ami-2a7d75c0"
    ap-northeast-1 = "ami-5a28993c"
    ap-south-1     = "ami-10eea17f"
    ap-southeast-1 = "ami-0ca4f16f"
    ca-central-1   = "ami-318b3055"
    eu-central-1   = "ami-712cac1e"
    sa-east-1      = "ami-560a4f3a"
    us-east-1      = "ami-759bc50a"
    us-west-1      = "ami-3892ab58"
    ap-southeast-2 = "ami-b0cb20d2"
    eu-west-2      = "ami-07c6d963"
    us-west-2      = "ami-78c81b00"
    us-east-2      = "ami-3af9d75f"
 }
}
