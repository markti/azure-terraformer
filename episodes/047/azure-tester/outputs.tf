output "healthprobe_url" {
  value = "https://${azurerm_public_ip.gateway.ip_address}:8081/healthprobe"
}