resource "aws_s3_bucket" "one" {
  bucket = "sumanth78.devops.battagiri"
}

resource "aws_s3_bucket_ownership_controls" "two" {
  bucket = aws_s3_bucket.one.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "three" {
  depends_on = [aws_s3_bucket_ownership_controls.two]

  bucket = aws_s3_bucket.one.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "three" {
bucket = aws_s3_bucket.one.id
versioning_configuration {
status = "Enabled"
}
}

terraform {
backend "s3" {
region = "ap-south-1"
bucket = "sumanth78.devops.battagiri"
key = "prod/terraform.tfstate"
}
}





