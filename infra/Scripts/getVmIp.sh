#! /bin/bash
# Script to get the private IP of the VM and set it as an Github workflow variable.

while getopts v:r:e: opts; do
   case ${opts} in
      v) VM_NAME=${OPTARG} ;;
      r) RG_NAME=${OPTARG} ;;
      e) ENV_NAME=${OPTARG} ;;
   esac
done

usage()
{
    echo "Expected 3 inputs"
    echo ""
    echo "sh getVmIp.sh -v vm_name -r resource_group -e env_variable_to_use"
    echo ""
}

if [ -z "$VM_NAME" ] || [ -z "$RG_NAME" ] || [ -z "$ENV_NAME" ]
then
   usage
   exit 1
else  
   VM_IP=`az vm list-ip-addresses --resource-group "$RG_NAME" --name "$VM_NAME" --query "[].virtualMachine.network.privateIpAddresses[0]" --output tsv`
   echo "IP of $VM_NAME is $VM_IP"
   echo "Setting env var for github workflow"
   echo ::set-output name=$ENV_NAME::$VM_IP
   echo "Output from env var set- $ENV_NAME"
fi