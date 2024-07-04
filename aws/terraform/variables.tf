#
# The local directory where the SSH key files are stored
#
variable "ssh_key_localpath" {
   default = "~/.ssh"
}

#
# The local private SSH key file name 
#
variable "ssh_key_filename" {
   default = "origin_key"
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
   default = "us-east-1"
}

#
# Default OS image: Ubuntu
#
variable "ami_id" {
   
  # Ubuntu Server 22.04 LTS (HVM), SSD Volume Type (64-bit x86), AMD

  // us-east-1
  default = "ami-0a0e5d9c7acc336f1"

  // us-east-2
  //default = "ami-003932de22c285676"

  // eu-west-1
  //default = "ami-0932dacac40965a65"

  // us-west-1
  //default = "ami-0ecaad63ed3668fca"

  // us-west-2
  //default = "	ami-0075013580f6322a1"

   // eu-west-3
   // default = "ami-0062b622072515714"
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

variable "user_application_client_type" {
   default = "client_app_server"
}

variable "instance_count" {
   type = map
   default = {
      dc1 = 3
      client_app_server = 1
   }
}

variable "instance_type" {
   type = map
   default = {
      dc1 = "t2.2xlarge"
      client_app_server = "t2.large"
   }
}

variable "dse_node_root_volume_size_gb" {
   default = 100
}

variable "cluster_owner" {
   default = "all"
}

variable "client_app_server_owner" {
   default = "user"
}


