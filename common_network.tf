resource "aws_vpc" "main" {
  cidr_block = "${var.vpc["cidr_block"]}"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
      Name              = "${var.client}-vpc"
      KubernetesCluster = "${var.env}.${var.client}"
  }
}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.client}-Internet-Gateway"
  }
}

resource "aws_subnet" "public" {
  depends_on        = ["aws_vpc.main"]
  cidr_block        = "${cidrsubnet(var.vpc["cidr_block"], 8, 148)}"
  vpc_id            = "${aws_vpc.main.id}"
  availability_zone = "${var.region}${var.availability_zone["zone1"]}"

  tags {
    Name              = "${var.client}-zone1-${var.availability_zone["zone1"]}"
    KubernetesCluster = "${var.env}.${var.client}"
      }
}

/*
resource "aws_subnet" "zone2" {
  depends_on        = ["aws_vpc.main"]
  cidr_block        = "${cidrsubnet(var.vpc["cidr_block"], 8, 48)}"
  vpc_id            = "${aws_vpc.main.id}"
  availability_zone = "${var.region}${var.availability_zone["zone2"]}"

  tags {
    Name              = "${var.client}-zone2-${var.availability_zone["zone2"]}"
    KubernetesCluster = "${var.env}.${var.client}"
      }
}

resource "aws_eip" "nat_zone_1_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_zone_1" {
  depends_on    = ["aws_internet_gateway.internet_gw"]
  allocation_id = "${aws_eip.nat_zone_1_eip.id}"
  subnet_id     = "${aws_subnet.zone1.id}"
}
i
*/
resource "aws_route_table" "route_table_public" {
  depends_on = ["aws_internet_gateway.internet_gw"]
  vpc_id     = "${aws_vpc.main.id}"

  tags {
    Name = "${var.client}-route-table-public"
    }
}

resource "aws_route" "route_table_public" {
  route_table_id         = "${aws_route_table.route_table_public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet_gw.id}"
  depends_on             = ["aws_route_table.route_table_public"]
}

/*
resource "aws_route_table" "route_table_private_zone_1" {
  depends_on = ["aws_nat_gateway.nat_zone_1"]
  vpc_id     = "${aws_vpc.main.id}"

  tags {
    Name = "${var.client}-route-table-private-${var.availability_zone["zone1"]}"
  }
}

resource "aws_route" "route_table_private_zone_1" {
  route_table_id         = "${aws_route_table.route_table_private_zone_1.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat_zone_1.id}"
  depends_on             = ["aws_route_table.route_table_private_zone_1"]
}
*/
resource "aws_route_table_association" "route_table_association_zone_1" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.route_table_public.id}"
}

/*
resource "aws_route_table_association" "route_table_association_zone_2" {
  subnet_id      = "${aws_subnet.zone2.id}"
  route_table_id = "${aws_route_table.route_table_private_zone_1.id}"
}
*/
resource "aws_main_route_table_association" "route_table_main" {
  vpc_id         = "${aws_vpc.main.id}"
  route_table_id = "${aws_route_table.route_table_public.id}"
}

