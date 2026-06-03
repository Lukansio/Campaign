terraform {
  backend "s3" {
    bucket         = "luk4-campaign-storage"
    key            = "dev/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}