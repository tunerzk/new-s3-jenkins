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

