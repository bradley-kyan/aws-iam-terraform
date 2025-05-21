terraform {
  backend "s3" {}
  required_version = "~>1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
  default_tags {
    tags = {
      IaCRepoURL  = "https://github.com/bradley-kyan/aws-iam-terraform"
      IacRepoName = "aws-iam-terraform"
      IacInfraRef = "website"
    }
  }
}
