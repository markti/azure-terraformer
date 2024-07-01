data amazon-ami ubuntu1804 {
  filters = {
    virtualization-type = "hvm"
    name                = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
    root-device-type    = "ebs"
  }
  owners      = ["099720109477"]
  most_recent = true
  region      = var.aws_primary_region
}

source amazon-ebs vm {
  region        = var.aws_primary_region
  ami_name      = "${var.image_name}-${var.image_version}"
  instance_type = "t2.small"
  ssh_username  = "ubuntu"
  ssh_interface = "public_ip"
  communicator  = "ssh"
  source_ami    = data.amazon-ami.ubuntu1804.id
}