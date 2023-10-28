# Define the provider for us-east-1
provider "aws" {
  alias      = "us_east_1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1"
}

# Create the first VPC in us-east-1
resource "aws_vpc" "us_east_1_vpc" {
  provider = aws.us_east_1
  cidr_block          = "10.10.0.0/16"
  enable_dns_support  = true
  enable_dns_hostnames = true
  tags = {
    Name = "deployment6-vpc-east"
  }
}

# Create an Internet Gateway for the first VPC
resource "aws_internet_gateway" "us_east_1_igw" {
  provider = aws.us_east_1
  vpc_id = aws_vpc.us_east_1_vpc.id
  tags = {
    Name = "D6_East_1_VPC_igw"
  }
}

# Create two subnets in two AZs for the first VPC
resource "aws_subnet" "us_east_1_subnet" {
  provider = aws.us_east_1
  count = 2
  vpc_id           = aws_vpc.us_east_1_vpc.id
  cidr_block       = "10.10.${count.index}.0/24"
  availability_zone = "us-east-1${element(["a", "b"], count.index)}"
  map_public_ip_on_launch = true
    
  tags = {
    Name = "publicSubnet_0${count.index + 1}" # You can customize the naming convention as needed
  }
}

# Create a security group for the first VPC with rules for ports 8000 and 22
resource "aws_security_group" "us_east_1_security_group" {
  provider = aws.us_east_1
  name        = "US_East_1_HttpAcessSG"
  description = "Security Group for US East 1 VPC"
  vpc_id      = aws_vpc.us_east_1_vpc.id
}

# Create inbound rules for ingress
resource "aws_security_group_rule" "ingress_rules_east_1" {
  provider = aws.us_east_1
  count = 2
  type = "ingress"
  from_port = element([8000, 22], count.index)
  to_port = element([8000, 22], count.index)
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.us_east_1_security_group.id
}

# Create an outbound rule for egress
resource "aws_security_group_rule" "egress_rule_east_1" {
  provider = aws.us_east_1
  type = "egress"
  from_port = 0
  to_port = 0  # Allow all outbound traffic
  protocol = "-1"  # All protocols
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.us_east_1_security_group.id
}

# Create a route to the Internet Gateway for the public subnets in the first VPC
resource "aws_route" "us_east_1_internet_route" {
  provider = aws.us_east_1
  route_table_id         = aws_vpc.us_east_1_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.us_east_1_igw.id
}

# Launch two EC2 instances in the public subnets of the first VPC
resource "aws_instance" "us_east_1_ec2_instances" {
  provider = aws.us_east_1
  count           = 2
  ami             = "ami-053b0d53c279acc90"
  instance_type   = "t2.micro"
  vpc_security_group_ids = [aws_security_group.us_east_1_security_group.id]
  subnet_id       = aws_subnet.us_east_1_subnet[count.index].id
  key_name        = "DepKeys"
  user_data = "${file("deploy2.sh")}"
  tags = count.index == 0 ? { Name = "applicationServer01-east" } : { Name = "applicationServer02-east" }
}

# Define the provider for us-west-2
provider "aws" {
  alias      = "us_west_2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-west-2"
}

# Create the second VPC in us-west-2
resource "aws_vpc" "us_west_2_vpc" {
  provider = aws.us_west_2
  cidr_block        = "10.20.0.0/16"
  enable_dns_support  = true
  enable_dns_hostnames = true
  tags = {
    Name = "deployment6-vpc-west"
  }
}

# Create an Internet Gateway for the second VPC
resource "aws_internet_gateway" "us_west_2_igw" {
  provider = aws.us_west_2
  vpc_id = aws_vpc.us_west_2_vpc.id
  tags = {
    Name = "D6_West_2_VPC_igw"
  }
}

# Create two subnets in two AZs for the second VPC
resource "aws_subnet" "us_west_2_subnet" {
  provider = aws.us_west_2
  count = 2
  vpc_id           = aws_vpc.us_west_2_vpc.id
  cidr_block       = "10.20.${count.index}.0/24"
  availability_zone = "us-west-2${element(["a", "b"], count.index)}"
  map_public_ip_on_launch = true
    
  tags = {
    Name = "publicSubnet_0${count.index + 1}" # You can customize the naming convention as needed
  }
}

# Create a security group for the second VPC with rules for ports 8000 and 22
resource "aws_security_group" "us_west_2_security_group" {
  provider = aws.us_west_2
  name        = "US_West_2_HttpAcessSG"
  description = "Security Group for US West 2 VPC"
  vpc_id      = aws_vpc.us_west_2_vpc.id
}

# Create inbound rules for ingress
resource "aws_security_group_rule" "ingress_rules_west_2" {
  provider = aws.us_west_2
  count = 2
  type = "ingress"
  from_port = element([8000, 22], count.index)
  to_port = element([8000, 22], count.index)
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.us_west_2_security_group.id
}

# Create an outbound rule for egress
resource "aws_security_group_rule" "egress_rule_west_2" {
  provider = aws.us_west_2
  type = "egress"
  from_port = 0
  to_port = 0  # Allow all outbound traffic
  protocol = "-1"  # All protocols
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.us_west_2_security_group.id
}

# Create a route to the Internet Gateway for public subnets
resource "aws_route" "us_west_2_internet_route" {
  provider = aws.us_west_2
  route_table_id         = aws_vpc.us_west_2_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.us_west_2_igw.id
}

# Launch two EC2 instances in the public subnets												
resource "aws_instance" "us_west_2_ec2_instances" {
  provider = aws.us_west_2
  count           = 2
  ami             = "ami-0efcece6bed30fd98"
  instance_type   = "t2.micro"
  vpc_security_group_ids = [aws_security_group.us_west_2_security_group.id]
  subnet_id       = aws_subnet.us_west_2_subnet[count.index].id
  key_name        = "DepKeys-West"
  user_data = "${file("deploy2.sh")}"
  tags = count.index == 0 ? { Name = "applicationServer01_West-2" } : { Name = "applicationServer02_West-2" }
}
