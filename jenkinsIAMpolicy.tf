resource "aws_iam_policy" "jenkins_policy" {
  name        = "jenkins-terraform-policy"
  description = "Policy for Jenkins Terraform pipeline"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::terraform-state-kevjenkinstest",
          "arn:aws:s3:::terraform-state-kevjenkinstest/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:UpdateItem"
        ]
        Resource = "arn:aws:dynamodb:us-east-1:590807097479:table/terraform-locks"
      }
    ]
  })
}
