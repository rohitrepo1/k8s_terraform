#resource "aws_eip" "bastion_eip" {
#    vpc = true
#    instance = "${aws_instance.bastion.id}"
#}

resource "aws_instance" "bastion" {
  ami                    = "${lookup(var.ubuntu, var.region)}"
  instance_type          = "${var.bastion["instance_type"]}"
  key_name               = "${aws_key_pair.ethankey.key_name}"
  subnet_id              = "${aws_subnet.public.id}"
  private_ip             = "${var.vpc["cidr_half"]}.148.10"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]

  user_data = <<EOF
#!/bin/bash
sudo su
printf "${var.client}bastion.localdomain" > /etc/hostname
printf "\npreserve_hostname: true" >> /etc/cloud/cloud.cfg
export AWS_REGION=${var.region}
export AWS_ACCESS_KEY=${var.aws_access_key}
export AWS_SECRET_KEY=${var.aws_secret_key}
export VPC=${aws_vpc.main.id}
export KOPS_STATE_STORE="s3://${aws_s3_bucket.kbclusters_s3_bucket.id}"
export DNS_ZONE=${aws_route53_zone.main.id}
export CLIENT=${var.client}
export NODE_COUNT=${var.node_count}
export TOOLS=${var.tools_list}
export INNERSOURCE=${var.innersource_password}
export NODE_TYPE=${var.node_type}
printf -- "${file("${var.private_key}")}" > /home/ubuntu/id_rsa
printf -- "${file("${var.pub_key}")}" > "/home/ubuntu/id_rsa.pub"
curl -fsSL https://s3-${var.region}.amazonaws.com/${aws_s3_bucket.script_s3_bucket.id}/setup.sh | sh
pip install shyaml yamllint
EOF

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.bastion["volume_size"]}"
  }

  provisioner "remote-exec" {
   inline = [
     "sleep 120",
     "cd /home/ubuntu",
     "sleep 50",
     "sudo chmod +x vars.sh",
     "curl -fsSL https://s3-${var.region}.amazonaws.com/${aws_s3_bucket.script_s3_bucket.id}/storageClass.yaml -o /home/ubuntu/storageClass.yaml",
     "curl -fsSL https://s3-${var.region}.amazonaws.com/${aws_s3_bucket.script_s3_bucket.id}/createCluster.sh -o /home/ubuntu/createCluster.sh",
     "sudo chmod +x /home/ubuntu/createCluster.sh",
     "./createCluster.sh",
     "openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj '/CN=foo.bar.com'",
     "kubectl create secret tls nginx-ssl-cert --cert=tls.crt --key=tls.key",
     "git clone -b test --single-branch https://github.com/projectethan007/wrappers.git",
     "cd wrappers",
     "sudo chmod +x *",
     "./createStack.sh core",
     "./createStack.sh tools",
     "./reloadNginx.sh",
     "kubectl get svc | grep -i nginx | awk '{print $4}' > Details",
     "kubectl get cm pass -o yaml | grep INITIAL_ADMIN | sed -n 1,2p >> Details",
   ]

   connection {
    type         = "ssh"
    user         = "ubuntu"
    private_key  = "${file("${var.private_key}")}"
  }
 }

  tags {
    Name             = "${var.client}-bastion"
    customer         = "${var.client}"
    Service          = "${var.bastion["Service"]}"
    ServiceComponent = "${var.bastion["ServiceComponent"]}"
    NetworkTier      = "${var.bastion["NetworkTier"]}"

  }
}
