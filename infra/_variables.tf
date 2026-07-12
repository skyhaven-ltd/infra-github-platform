variable "github_owner" {
  description = "GitHub organisation that owns the managed repositories."
  type        = string
  default     = "skyhaven-ltd"
}

variable "github_app_id" {
  description = "GitHub App ID used by the github provider (Key Vault: github-platform-gh-app-id)."
  type        = string
}

variable "github_app_installation_id" {
  description = "Installation ID of the GitHub App on the organisation (Key Vault: github-platform-gh-app-installation-id)."
  type        = string
}

variable "github_app_pem" {
  description = "PEM private key of the GitHub App (Key Vault: github-platform-gh-app-private-key)."
  type        = string
  sensitive   = true
}

variable "repositories" {
  description = "Repositories managed under the organisation. Map key is the repository name; each repo inherits the standard baseline defined in main.tf unless a field is overridden here."
  type = map(object({
    description          = optional(string, "")
    visibility           = optional(string, "public")
    require_pull_request = optional(bool, true)
  }))

  validation {
    condition = alltrue([
      for name in keys(var.repositories) :
      contains([".github"], name) ||
      can(regex("^(app|infra|module|pipeline|data|docs)-([a-z0-9]+(-[a-z0-9]+)*)$", name))
    ])
    error_message = "One or more repository names must start with a registered type (app|infra|module|pipeline|data|docs) followed by kebab-case segments. Domain and qualifier guidance lives in skyhaven-ltd/.github/standards/repo-naming.md."
  }
}
