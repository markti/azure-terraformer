echo 'Packer Image Version:'$PKR_VAR_image_version
echo 'Build Agent IP Address:'$PKR_VAR_agent_ipaddress

packer init ./
packer build ./
