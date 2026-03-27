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
