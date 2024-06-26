######################################################
# Create a custom VPC. 
#
resource "aws_vpc" "vpc_dse" {
   cidr_block           = var.vpc_cidr_str_vpc
   enable_dns_hostnames = true

   tags = {
     Name = "${var.tag_identifier}-vpc_dse"  
   }
}

######################################################
# Create an internet gateway for public/internet access
#
resource "aws_internet_gateway" "ig_dse" {
   vpc_id                   = aws_vpc.vpc_dse.id

   tags = {
     Name = "${var.tag_identifier}-ig_dse"  
   }
}

######################################################
# Create a custom route table for the cluster
#
resource "aws_route_table" "rt_dse" {
    vpc_id                  = aws_vpc.vpc_dse.id
    tags = {
        Name = "${var.tag_identifier}-rt_dse"
    }
}

resource "aws_route" "dse_to_igw" {
  route_table_id = aws_route_table.rt_dse.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ig_dse.id
}


######################################################
# Create a custom route table for the user application
# It is identical to the cluster one, but it simulates the user app having a different rt
#
resource "aws_route_table" "rt_user_app" {
  vpc_id                  = aws_vpc.vpc_dse.id
  tags = {
    Name = "${var.tag_identifier}-rt_user_app"
  }
}

resource "aws_route" "user_app_to_igw" {
  route_table_id = aws_route_table.rt_user_app.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ig_dse.id
}

######################################################
# Create subnets
#

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Subnet for DSE core - application cluster
resource "aws_subnet" "sn_dse_cassapp" {    
    vpc_id                  = aws_vpc.vpc_dse.id
    cidr_block              = var.vpc_cidr_str_cassapp
    availability_zone       = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.tag_identifier}-sn_dse_cassapp"
    }
}
resource "aws_route_table_association" "rt_assoc_sn_dse_cassapp" {
    route_table_id          = aws_route_table.rt_dse.id
    subnet_id               = aws_subnet.sn_dse_cassapp.id
}

# Subnet for user application client
resource "aws_subnet" "sn_user_app" {
  vpc_id                  = aws_vpc.vpc_dse.id
  cidr_block              = var.vpc_cidr_str_userapp
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.tag_identifier}-sn_user_app"
  }
}
resource "aws_route_table_association" "rt_assoc_sn_user_app" {
  route_table_id          = aws_route_table.rt_user_app.id
  subnet_id               = aws_subnet.sn_user_app.id
}
