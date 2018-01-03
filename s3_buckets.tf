resource "aws_s3_bucket" "script_s3_bucket" {
    bucket = "${var.client}-${var.region}-bucket"
    acl = "private"

    tags {
        Name = "${var.client}_${var.region}_bucket"
        customer = "${var.client}"
    }
}

resource "aws_s3_bucket_object" "setup" {
    bucket = "${aws_s3_bucket.script_s3_bucket.id}"
    acl    = "public-read"
    key = "setup.sh"
    source = "./scripts/setup.sh"
    etag = "${md5(file("./scripts/setup.sh"))}"
}


resource "aws_s3_bucket_object" "cluster" {
    bucket = "${aws_s3_bucket.script_s3_bucket.id}"
    acl    = "public-read"
    key = "createCluster.sh"
    source = "./scripts/createCluster.sh"
    etag = "${md5(file("./scripts/createCluster.sh"))}"
}

resource "aws_s3_bucket_object" "sclass" {
    bucket = "${aws_s3_bucket.script_s3_bucket.id}"
    acl    = "public-read"
    key = "storageClass.yaml"
    source = "./scripts/storageClass.yaml"
    etag = "${md5(file("./scripts/storageClass.yaml"))}"
}

resource "aws_s3_bucket" "kbclusters_s3_bucket" {
    bucket        = "clusters.${var.client}.devops"
    acl           = "private"
    force_destroy = true

    versioning {
        enabled = true
   }

    tags {
        Name     = "${var.client}_${var.region}_bucket"
        customer = "${var.client}"
    }
}
