terraform {
  backend "s3" {
    bucket = "bastion-bucket-terraform"
    key    = "backend/terraform.tfstate"
    region = "us-east-1"
  }
}
