public_subnets = {
  subnet-1 = {
    name       = "public_subnet_1"
    cidr_block = "10.0.1.0/24"
    az         = "us-east-1a"
  }
  subnet-2 = {
    name       = "public_subnet_2"
    cidr_block = "10.0.2.0/24"
    az         = "us-east-1b"
  }
}
private_subnets = {
  subnet-3 = {
    name = "web_private_subnet_1"
    cidr_block = "10.0.3.0/24"
    az = "us-east-1a"
  }
  subnet-4 = {
    name = "web_private_subnet_2"
    cidr_block = "10.0.4.0/24"
    az = "us-east-1b"
  }
  subnet-5 = {
    name = "app_private_subnet_1"
    cidr_block = "10.0.5.0/24"
    az = "us-east-1a"
  }
  subnet-6 = {
    name = "app_private_subnet_2"
    cidr_block = "10.0.6.0/24"
    az = "us-east-1b"
  }
  subnet-7 = {
    name = "db_private_subnet_1"
    cidr_block = "10.0.7.0/24"
    az = "us-east-1a"
  }
  subnet-8 = {
    name = "db_private_subnet_2"
    cidr_block = "10.0.8.0/24"
    az = "us-east-1b"
  }
}