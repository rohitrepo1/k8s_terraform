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
    eu-west-1      = "ami-03aeebbb10c98e3a4"
    ap-northeast-1 = "ami-0a90052ed2cafb2ab"
    ap-south-1     = "ami-0a8074f27bfb82e4c"
    ap-southeast-1 = "ami-01d832e65ada04e08"
    ca-central-1   = "ami-0d3b851d78474b33c"
    eu-central-1   = "ami-09b5d753a3189571f"
    sa-east-1      = "ami-025b32916c29a3dd0"
    us-east-1      = "ami-0bc8e719eef63c6d6"
    us-west-1      = "ami-0cd4c5406e3a0d07b"
    ap-southeast-2 = "ami-05eeaad3a34c2667a"
    eu-west-2      = "ami-0075b759cd7ee5cb3"
    ap-northeast-2 = "ami-066838476a8c6fdab"
    us-west-2      = "ami-0b681e34f0b031a18"
    us-east-2      = "ami-011254f5862de0b16"
	eu-west-3      = "ami-034d370ce4ae52a04"
}
}

variable "k8s" {
  default {
    eu-west-1      = "ami-0b85ea07246fac3fd"
    ap-northeast-1 = "ami-0e41312f132737f31"
    ap-south-1     = "ami-06acd211f61fee87d"
    ap-southeast-1 = "ami-078bb4c792ac9f35b"
    ca-central-1   = "ami-06291eaaa107516ab"
    eu-central-1   = "ami-020226fc2fa1ed0ee"
    sa-east-1      = "ami-0b36f8e46c6c5ae8e"
    us-east-1      = "ami-0ca2b2dcb8f83b23b"
    us-west-1      = "ami-064b034a9054c5b6b"
    ap-southeast-2 = "ami-0ab51bfc1782cb2aa"
    eu-west-2      = "ami-0a4c06da526ca93d6"
    ap-northeast-2 = "ami-0984e6b3611c07594"
    us-west-2      = "ami-033fd2a6046fb490c"
    us-east-2      = "ami-01a8d4e9ee1138b6f"
}
}

