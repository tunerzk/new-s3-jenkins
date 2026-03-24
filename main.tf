resource "aws_s3_bucket" "frontend" {
    bucket_prefix = "theo-jenkins-s3-test"
    force_destroy = true
    
    tags = {
        Name        = "theo-jenkins-s3-test"
        Environment = "Dev"
    }
  
}