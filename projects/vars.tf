variable "elasticapp" {
  default = "la-cabana-avicola-service"
}
variable "beanstalkappenv" {
  default = "la-cabana-avicola-service-dev"
}
variable "solution_stack_name" {
  type = string
  default = "64bit Amazon Linux 2 v3.2.13 running Corretto 11"
}
variable "tier" {
  type = string
  default = "WebServer"
}
 
variable "vpc_id" {
  default = "vpc-1cf14366"
}
variable "public_subnets" {
  default = ["subnet-f40533be", "subnet-5641220a"]
}
variable "elb_public_subnets" {
  default = ["subnet-f40533be", "subnet-5641220a"]
}
