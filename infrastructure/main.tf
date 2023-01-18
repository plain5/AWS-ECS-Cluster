#-------------------- Providers definition -----------------------

provider "aws" {
  region = var.region
}



#-------------------- Backend initialization -----------------------

terraform {
  backend "s3" {
    bucket = "your_bucket"
    key    = "folder_name/terraform.tfstate"
    region = "eu-central-1"
  }
}
