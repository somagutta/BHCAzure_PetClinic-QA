#! /bin/bash
# Script to assign roles for VM managed identity to Storage account where the artifacts and scripts are stored.This is required to execute custom script extension on VM

RBAC_ROLE="Storage Blob Data Contributor"
SCOPE=""

while getopts v:r:s:b: opts; do
   case ${opts} in
      v) VM_NAME=${OPTARG} ;;
      r) RG_NAME=${OPTARG} ;;
      s) SCOPE=${OPTARG} ;;
      b) RBAC_ROLE=${OPTARG} ;;
   esac
done

usage()
{
    echo "Expected 4 inputs"
    echo ""
    echo "sh assignRbacSa.sh -v vm_name -r resource_group -s rbac_role_assignment_scope -b rbac_role"
    echo ""
}

if [ -z "$VM_NAME" ] || [ -z "$RG_NAME" ] || [ -z "$SCOPE" ] || [ -z "$RBAC_ROLE" ]
then
   usage
   exit 1
else  

spID=$(az vm identity show --name  "$VM_NAME"  --resource-group "$RG_NAME" --query principalId -o tsv)
  if [ -z "$spID" ]
   then
     echo "Managed ID not set for the VM"
   exit 1
  else   
    az role assignment create --assignee-object-id $spID --assignee-principal-type ServicePrincipal --role "$RBAC_ROLE" --scope "$SCOPE"
    status=$?
    [ $status -eq 0 ] && echo "Role assignment done" || ( echo "Role assignment not done" && exit 1 )
  fi
fi