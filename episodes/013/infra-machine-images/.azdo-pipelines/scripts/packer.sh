echo 'Packer Image Version:'$PKR_VAR_image_version
echo 'Build Agent IP Address:'$PKR_VAR_agent_ipaddress

varFilePath=$1

packer init ./
packer build $varFilePath ./
