output "cluster_name" {
  value = "euwest.${var.client}.${var.env}"
}

output "state_store" {
  value = "s3://${aws_s3_bucket.kbclusters_s3_bucket.id}"
}

output "name" {
  value = "${var.client}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "dns_zone" {
  value = "${aws_route53_zone.main.id}"
}

output "availability_zones" {
  value = "${var.availability_zone}"
}
