terraform {
    required_providers {
      aws ={
        source = "hashicorp/aws"
        version = "~> 6.0"
      }
    }
}





provider "aws" {
    region = "u-east-1"

  
}