#!/bin/bash

cd terraform

echo
echo "##################################"
echo "# initialize terraform ..."
echo "##################################"
echo
terraform init
echo

echo -n "Which cluster do you want to create? Type O for Origin or T for Target. O or T? "
echo
read modeIdentifier
if [[ "$modeIdentifier" == "T" ]]; then
  echo
  echo "##################################"
  echo "# Creating a Target cluster ..."
  echo "##################################"
  echo
  cluster_mode="target"
  cidr_str_vpc="200.100.0.0/16"
  cidr_str_cassapp="200.100.20.0/24"
  cidr_str_userapp="200.100.40.0/24"
else
  echo
  echo "##################################"
  echo "# Creating an Origin cluster ..."
  echo "##################################"
  echo
  cluster_mode="origin"
  cidr_str_vpc="190.100.0.0/16"
  cidr_str_cassapp="190.100.20.0/24"
  cidr_str_userapp="190.100.40.0/24"
fi

echo
echo "##################################"
echo "# calculate the terraform plan ..."
echo "##################################"
echo
terraform plan -var "tag_identifier=$cluster_mode" -var "vpc_cidr_str_vpc=$cidr_str_vpc" -var "vpc_cidr_str_cassapp=$cidr_str_cassapp" -var "vpc_cidr_str_userapp=$cidr_str_userapp" -out myplan
echo

echo -n "Do you want to apply the plan and continue (yes or no)? "
echo 
read yesno
if [[ "$yesno" == "yes" ]]; then
   echo
   echo "##################################"
   echo "# apply the terraform plan ..."
   echo "##################################"
   echo
   terraform apply myplan
fi

terraform output > cluster_output.txt
cd ..
