# echo parameters
echo "Storage Account Name: "${storage_account_name}
echo "Storage Container Name: "${storage_container_name}

# save parameters as environment variables
storageAccountName=${storage_account_name}
storageContainerName=${storage_container_name}

# update blobfuse-config.yaml
sed -i 's@AZURE_STORAGE_ACCOUNT_NAME@'"$storageAccountName"'@' /home/mcserver/blobfuse-config.yaml
sed -i 's@AZURE_STORAGE_CONTAINER_NAME@'"$storageContainerName"'@' /home/mcserver/blobfuse-config.yaml

# the /tmp directory will be deleted anytime the VM is deallocated on azure, therefore any directory structure that we need in here needs to be re-created everytime
# blobfuse uses a file-cache to store temporary files that are uploaded /downloaded from Azure Blob Storage, this /tmp directory is the ideal place to keep these transient files
mkdir -p /tmp/minecraft/worlds

# now we are ready to use blobfuse to mount the Azure Blob Storage container to our miencraft worlds folder
blobfuse2 mount /home/mcserver/minecraft_bedrock/worlds --config-file=/home/mcserver/blobfuse-config.yaml

# we need to change the name of the world
sed -i 's@Bedrock level@'"AZTF"'@' /home/mcserver/minecraft_bedrock/server.properties

# sleep while files are synchronized from Blob storage
sleep 30

# make sure minecraft user has access to all the files in its home folder
chown -R mcserver: /home/mcserver/

# enable and start minecraft background service
systemctl enable mcbedrock
systemctl start mcbedrock
