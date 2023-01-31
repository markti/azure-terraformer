
echo '=== AzureRM Backend Config ==='
echo 'Resource Group Name: '$BACKEND_RESOURCE_GROUP_NAME
echo 'Storage Account Name: '$BACKEND_STORAGE_ACCOUNT_NAME
echo 'Storage Account Container Name: '$BACKEND_STORAGE_ACCOUNT_CONTAINER_NAME
echo 'Key: '$TF_BACKEND_KEY

terraform init \
  -backend-config="resource_group_name=$BACKEND_RESOURCE_GROUP_NAME" \
  -backend-config="storage_account_name=$BACKEND_STORAGE_ACCOUNT_NAME" \
  -backend-config="container_name=$BACKEND_STORAGE_ACCOUNT_CONTAINER_NAME" \
  -backend-config="key=$TF_BACKEND_KEY"

terraform $1 $2 $3