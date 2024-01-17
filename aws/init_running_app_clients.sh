#!/bin/bash


print_help_message () {
  echo
  echo
  printf "Usage: ./init_running_app_clients.sh [ARG] \n"
  echo
  printf "Required argument: \n"
  printf "  -k / --origin_ssh_private_key: relative or absolute path of the private SSH key to access the Origin instances \n"
  echo
  printf "This script will exit now, please try again. \n"
  echo
  echo
  return
}

# Parse named command-line arguments
SHORT=k:,h
LONG=origin_ssh_private_key:,help
OPTS="$(getopt -o $SHORT -l $LONG -- "$@")"

VALID_ARGUMENTS=$#

if [ "$VALID_ARGUMENTS" -eq 0 ]; then
  echo "ERROR: Missing mandatory parameter"
  print_help_message
  exit 1
fi

eval set -- "$OPTS"
while :
do
  case "$1" in
    -k | --origin_ssh_private_key )
      ORIGIN_SSH_KEY="$2"
      shift 2
      ;;
    -h | --help )
      print_help_message
      exit 1
      ;;
    --)
      shift;
      break
      ;;
    * )
      echo "Unknown option: $1"
      print_help_message
      exit 1
      ;;
  esac
done


# Login using the Astra Conn profile
printf "Logging in the AWS account using the Astra Conn profile - please click on Allow when prompted\n\n"
aws sso login --profile astra-conn

printf "\n\nCreating the app client inventory file...\n"
printf "[clients]\n" > ansible/app_client_inventory

# Retrieve the public IPs of the client instances that are currently running
# Note: these are not EIPs so the public IP of any stopped instance is empty, therefore we filter them out
aws ec2 describe-instances \
 --filter "Name=tag:UsageGroup,Values=client" "Name=instance-state-name,Values=running" \
 --query "Reservations[*].Instances[*].[PublicIpAddress]" \
 --profile=astra-conn \
 --region=us-east-1 \
 --output text >> ansible/app_client_inventory

# Retrieve the private IP of cluster node0
DSE0_IP=$(aws ec2 describe-instances \
                --filter "Name=tag:UsageGroup,Values=cluster" "Name=tag:Name,Values=origin-sideloader-dc1-node0" \
                --query "Reservations[*].Instances[*].[PrivateIpAddress]" \
                --profile=astra-conn \
                --region=us-east-1 \
                --output text)

# Retrieve the private IP of cluster node1
DSE1_IP=$(aws ec2 describe-instances \
 --filter "Name=tag:UsageGroup,Values=cluster" "Name=tag:Name,Values=origin-sideloader-dc1-node1" \
 --query "Reservations[*].Instances[*].[PrivateIpAddress]" \
 --profile=astra-conn \
 --region=us-east-1 \
 --output text)

# Retrieve the private IP of cluster node2
DSE2_IP=$(aws ec2 describe-instances \
 --filter "Name=tag:UsageGroup,Values=cluster" "Name=tag:Name,Values=origin-sideloader-dc1-node2" \
 --query "Reservations[*].Instances[*].[PrivateIpAddress]" \
 --profile=astra-conn \
 --region=us-east-1 \
 --output text)
printf "\nClient inventory file created\n"

printf "\nRunning the client install playbook now\n\n"
cd ansible || return
ansible-playbook app_clients_install.yaml -u ubuntu --private-key "$ORIGIN_SSH_KEY" --extra-vars "dse0_priv_ip=$DSE0_IP dse1_priv_ip=$DSE1_IP dse2_priv_ip=$DSE2_IP" -i app_client_inventory