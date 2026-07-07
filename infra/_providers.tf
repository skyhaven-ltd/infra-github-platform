provider "github" {
  owner = var.github_owner

  # Authenticates as the platform GitHub App. CI exports the TF_VAR_* values
  # from the platform Key Vault after Azure login.
  app_auth {
    id              = var.github_app_id
    installation_id = var.github_app_installation_id
    pem_file        = var.github_app_pem
  }
}
