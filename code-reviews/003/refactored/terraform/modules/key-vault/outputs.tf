output "id" {
  value       = azurerm_key_vault_access_policy.terraform_user.key_vault_id
  description = "The Azure Key Vault ID"
}
output "vault_uri" {
  value       = azurerm_key_vault.main.vault_uri
  description = "The Azure Key Vault URI"
}
