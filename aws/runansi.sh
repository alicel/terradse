#!/bin/bash

cd ansible

"$(pwd)"

#echo
#echo ">>>> Configure recommended OS/Kernel parameters for DSE nodes <<<<"
#echo
#ansible-playbook -i hosts osparm_change.yaml --private-key=~/.ssh/cluster_key -u ubuntu
#echo

echo -n "Which cluster do you want to create? Type O for Origin or T for Target. O or T? "
echo
read modeIdentifier
if [[ "$modeIdentifier" == "T" ]]; then
  echo
  echo "##################################"
  echo "# Creating a Target cluster ..."
  echo "##################################"
  echo
  clustermode="target"
else
  clustermode="origin"
fi

echo
echo ">>>> Setup DSE application cluster <<<<"
echo
ansible-playbook -i hosts dse_app_install.yaml --private-key=~/.ssh/cluster_key --extra-vars "cluster_mode=$clustermode" -u ubuntu
echo

cd ..
