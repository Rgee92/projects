variable "environment" {
  type    = "string"
  default = "prod"
}

variable "instance_type" {
  type    = "string"
  default = "t2.micro"
}

variable "max_instance" {
  type    = "string"
  default = "1"
}

variable "min_instance" {
  type    = "string"
  default = "1"
}
