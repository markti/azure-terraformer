resource random_string rando {
  length           = 8
  special          = true
  override_special = "/@$"
}