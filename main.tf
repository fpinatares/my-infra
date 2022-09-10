terraform {
  required_providers {
    aws = {
      version = "~> 4.10.0"
    }
  }
}

# Create elastic beanstalk application
 
resource "aws_elastic_beanstalk_application" "la-cabana-avicola-service" {
  /*depends_on = [
    aws_db_instance.la-cabana-avicola-db-dev
  ]*/
  name = var.elasticapp
  //role = aws-elasticbeanstalk-ec2-role

  tags = {
    organization = "alfave"
    project      = "la-cabana-avicola"
    service      = "la-cabana-avicola-service"
  }

  tags_all = {
    organization = "alfave"
    project      = "la-cabana-avicola"
    service      = "la-cabana-avicola-service"
  }
}

# Create elastic beanstalk Environment
resource "aws_elastic_beanstalk_environment" "la-cabana-avicola-service-dev"  {
  depends_on = [
    aws_elastic_beanstalk_application.la-cabana-avicola-service
  ]
  name                = var.beanstalkappenv
  application         = aws_elastic_beanstalk_application.la-cabana-avicola-service.name
  solution_stack_name = var.solution_stack_name
  tier                = var.tier

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     =  "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     =  "True"
  }
 
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.public_subnets)
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "internet facing"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = 1
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = 1
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = "sg-3c7e8179"
  }
}
/*
resource "aws_db_instance" "la-cabana-avicola-db-dev" {
  identifier           = "la-cabana-avicola-db-dev"
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "14"
  instance_class       = "db.t4g.micro"
  db_name              = "postgres"
  username             = "fpinatares"
  password             = "fpinatares"
  parameter_group_name = "default.postgres14"
  skip_final_snapshot  = true
  publicly_accessible  = true
 // vpc_security_group_ids = [ "sg-3c7e8179" ]
  vpc_security_group_ids = [ "db-sg-id" ]
//  subnet_ids     = var.public_subnets

  tags = {
    organization = "alfave"
    project      = "la-cabana-avicola"
    service      = "la-cabana-avicola-service"
  }
}
*/
/*
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
*/
/*
module "db" {
  source  = "terraform-aws-modules/rds/aws"

  identifier = "la-cabana-avicola-db-dev"

  engine            = "postgres"
  engine_version    = "13"
  instance_class    = "db.t4g.micro"
  allocated_storage = 20

  db_name  = "postgres"
  username = "fpinatares"
  password = "fpinatares"
  port     = "5432"

  iam_database_authentication_enabled = true

  tags = {
    organization = "alfave"
    project      = "la-cabana-avicola"
    service      = "la-cabana-avicola-service"
  }

  # DB subnet group
  subnet_ids     = var.public_subnets

  # DB parameter group
  family = "postgres13"

  # DB option group
  major_engine_version = "13"

}
*/
/*
provider "aws" {
  profile = "default"
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami = "ami-0f9fc25dd2506cf6d"
  instance_type = "t3.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}*/