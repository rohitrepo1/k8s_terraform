resource "aws_route53_zone" "main" {
  name          = "${var.client}.devops"
  vpc_id        = "${aws_vpc.main.id}"
#  type          = "CNAME"
#  ttl           = "300"
#  records       = ["${var.client}.devops.com"]
  force_destroy = true

  tags {
    Name      = "${var.client}-${var.env}-zone-public"
    client    = "${var.client}"
  }
}
