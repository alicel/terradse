#
# The AWS profile to be used to provision the infrastructure
#
variable "aws_profile" {
   default = "ds-zdm-immersion-day"
}

#
# The local directory where the SSH key files are stored
#
variable "ssh_key_localpath" {
   default = "..."
}

#
# The local private SSH key file name
#
variable "ssh_key_filename" {
   default = "..."
}

#
# AWS EC2 key-pair name
#
variable "keyname" {
   default = "dse-sshkey"
}

#
# Default AWS region
#
variable "region" {
   default = "us-west-2"
}

#
# Default OS image: Ubuntu
#
variable "ami_id" {
   
  # Ubuntu Server 18.04 LTS (HVM), SSD Volume Type (64-bit x86)

  // us-east-1
  //default = "ami-0bcc094591f354be2"

  // us-east-2
  //default = "ami-0e82959d4ed12de3f"

  // eu-west-1
  //default = "ami-0e66021c377d8c8b4"

  // us-west-1
  //default = "ami-0e17790f211795d99"

   // us-west-2
   default = "ami-0a97be4c4be6d6cc4"
}

#
# AWS resource tag identifier
#
variable "tag_identifier" {
   default = "origin"
} 

#
# Environment description
#
variable "env" {
   default = "automation_test"
}

## CIDR for VPC and subnets
variable "vpc_cidr_str_vpc" {
   default = "191.100.0.0/16"
}
variable "vpc_cidr_str_cassapp" {
   default = "191.100.20.0/24"
}
//variable "vpc_cidr_str_solrspark" {
//   default = "191.100.30.0/24"
//}
variable "vpc_cidr_str_userapp" {
   default = "191.100.40.0/24"
}

#
# OpsCenter and DSE workload type string for
# - "OpsCenter server node"
# - "DSE metrics cluster node"
# - "DSE application cluster node - DC1"
# - "DSE application cluster node - DC2"
# NOTE: make sure the type string matches the "key" string
#       in variable "instance_count/instance_type" map
# 

variable "dse_app_dc1_type" {
   default = "dc1"
}
/*
variable "dse_app_dc2_type" {
   default = "dse_app_dc2"
}
*/
variable "user_application_client_type" {
   default = "app_client"
}

variable "instance_count" {
   type = map
   default = {
      dc1 = 3
      //dse_app_dc2 = 3
      app_client = 10
   }
}

variable "instance_type" {
   type = map
   default = {
      dc1 = "t2.2xlarge"
      //dse_app_dc2 = "t2.2xlarge"
      app_client = "t2.large"
   }
}

variable "dse_node_root_volume_size_gb" {
   // NOTE the default is 2TB - adjust as needed
   default = 2000
}

variable "cluster_owner" {
   default = "shared"
}

variable "client_app_server_owner" {
   default = "user"
}


