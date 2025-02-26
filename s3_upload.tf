provider "aws" {
  region = "us-west-2"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to put Ansible files"
  type        = string
  default     = "jcorkins-carpathia-ec2"
}

data "aws_s3_bucket" "target_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_object" "ansible_role_upload" {
  for_each = fileset("ansible/", "**")

  bucket = data.aws_s3_bucket.target_bucket.id
  key    = "bootstrap/${each.value}"
  source = "ansible/${each.value}"
  etag   = filemd5("ansible/${each.value}")
}