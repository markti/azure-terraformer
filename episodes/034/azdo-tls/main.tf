resource tls_private_key azdo_pipelines {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource local_file public_key {
  content = tls_private_key.azdo_pipelines.public_key_openssh
  filename = "${path.module}/terraform-id_rsa.pub"
}

resource local_file private_key {
  content = tls_private_key.azdo_pipelines.private_key_openssh
  filename = "${path.module}/terraform-id_rsa"
}