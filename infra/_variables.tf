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
      can(regex("^(app|infra|data|docs)-(braveart|certwatch|cvengine|powertoggle|learning|stockalert|landingzone|github|homelab|developer|engineering)-([a-z0-9]+(-[a-z0-9]+)*)$", name)) ||
      can(regex("^(module|pipeline)-(braveart|certwatch|cvengine|powertoggle|learning|stockalert|landingzone|github|homelab|developer|engineering)-([a-z0-9]+(-[a-z0-9]+)*)-(terraform|bicep|ansible|kubernetes|helm|docker|node|dotnet|python|powershell|actions)$", name))
    ])
    error_message = "One or more repository names violate the naming standard <type>-<domain>-<component>[-<qualifier>]. type: app|infra|module|pipeline|data|docs; domain and qualifier must come from the registered vocabularies; module and pipeline require a technology qualifier. See skyhaven-ltd/.github/standards/repo-naming.md."
  }
}
