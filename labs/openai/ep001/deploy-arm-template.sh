#!/bin/bash
az account set -s 00000000-0000-0000-0000-000000000000

# Generate a random string with lowercase letters and numbers only
random_string=$(LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom | dd bs=8 count=1 2>/dev/null)

echo "Random string: $random_string"

resource_group_name="rg-$random_string"
location="eastus"

echo "Random string: $resource_group_name"

az group create --name $resource_group_name --location $location

deployment_name="deployment-name-$random_string"

az deployment group create \
  --name $deployment_name \
  --resource-group $resource_group_name \
  --template-file template.json \
  --parameters @template-parameters.json

