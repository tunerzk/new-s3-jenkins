terraform {
  backend "s3" {
    bucket         = "terraform-state-kevjenkinstest"
    key            = "jenkins/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    use_lockfile   = true
  }
}

locals {
  upload_files = fileset("uploads/", "**")
}

resource "aws_s3_object" "uploads" {
  for_each = { for f in local.upload_files : f => f }

  bucket = "terraform-state-kevjenkinstest"
  key    = "uploads/${each.value}"
  source = "uploads/${each.value}"
  etag   = filemd5("uploads/${each.value}")
}

resource "aws_s3_object" "upload_image" {
  bucket = "terraform-state-kevjenkinstest"
  key    = "uploads/8978169.jpg"
  source = "uploads/8978169.jpg"
  etag   = filemd5("uploads/8978169.jpg")
}
