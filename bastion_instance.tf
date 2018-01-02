resource "aws_eip" "bastion_eip" {
    vpc = true
    instance = "${aws_instance.bastion.id}"
}

resource "aws_instance" "bastion" {
  ami                    = "${lookup(var.ubuntu, var.region)}"
  instance_type          = "${var.bastion["instance_type"]}"
  key_name               = "${aws_key_pair.ethankey.key_name}"
#  associate_public_ip_address = "true"
  subnet_id              = "${aws_subnet.public.id}"
  private_ip             = "${var.vpc["cidr_half"]}.148.10"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]

  user_data = <<EOF
#!/bin/bash
printf "${var.client}bastion.localdomain" > /etc/hostname
printf "\npreserve_hostname: true" >> /etc/cloud/cloud.cfg
export AWS_REGION=${var.region}
export AWS_ACCESS_KEY=${var.aws_access_key}
export AWS_SECRET_KEY=${var.aws_secret_key}
export VPC=${aws_vpc.main.id}
export KOPS_STATE_STORE="s3://${aws_s3_bucket.kbclusters_s3_bucket.id}"
export DNS_ZONE=${aws_route53_zone.main.id}
export CLIENT=${var.client}
printf -- "${file("${var.private_key}")}" > /home/ubuntu/id_rsa
printf -- "${file("${var.pub_key}")}" > "/home/ubuntu/id_rsa.pub"
curl -fsSL https://s3-${var.region}.amazonaws.com/${aws_s3_bucket.script_s3_bucket.id}/setup.sh | sh
curl -fsSL https://s3-${var.region}.amazonaws.com/${aws_s3_bucket.script_s3_bucket.id}/createCluster.sh -o /opt/createCluster.sh
EOF

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.bastion["volume_size"]}"
  }

  provisioner "remote-exec" {
   inline = [
     "cd /opt",
     "chmod +x /opt/createCluster.sh",
     "./createCluster.sh",
     "git clone https://github.com/projectethan007/wrappers.git",
     "cd wrappers",
     "chmod +x *",
     "./createStack core",
   ]
 }

  tags {
    Name             = "${var.client}-bastion"
    customer         = "${var.client}"
    Service          = "${var.bastion["Service"]}"
    ServiceComponent = "${var.bastion["ServiceComponent"]}"
    NetworkTier      = "${var.bastion["NetworkTier"]}"

  }
}
