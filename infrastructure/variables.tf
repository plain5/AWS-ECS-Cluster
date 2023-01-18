variable "public_subnets_cidr_blocks" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}



variable "certificate_arn" {
  type    = string
  default = ""
}



variable "account_id" {
  type    = string
  default = ""
}



variable "ecr_uri" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = ""
}
#

