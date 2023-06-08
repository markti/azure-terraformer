az login

az account set -s 00000000-0000-0000-0000-000000000000

az deployment sub create \
    --location eastus \
    --template-file main.bicep
