terraform init \
  -backend-config="resource_group_name=$BACKEND_RG"
  -backend-config="storage_account_name=$BACKEND_STORAGE_NAME"
  -backend-config="container_name=$BACKEND_STORAGE_CONTAINER"
  -backend-config="key=$BACKEND_KEY"

terraform workspace new $WORKSPACE_NAME || true
terraform workspace select $WORKSPACE_NAME

terraform apply -auto-approve
