locals {
  #This doesn't look right as per https://developer.hashicorp.com/packer/docs/provisioners/powershell#elevated_execute_command
  execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
}
