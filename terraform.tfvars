vpc_id              = "vpc-1cf14366"
Instance_type       = "t2.micro"
minsize             = 1
maxsize             = 1
public_subnets     = ["subnet-f40533be", "subnet-5641220a"] # Service Subnet
elb_public_subnets = ["subnet-f40533be", "subnet-5641220a"] # ELB Subnet
tier = "WebServer"
solution_stack_name= "64bit Amazon Linux 2 v3.2.13 running Corretto 11"