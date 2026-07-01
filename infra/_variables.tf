variable "github_owner" {
  description = "GitHub organisation that owns the managed repositories."
  type        = string
  default     = "skyhaven-ltd"
}

variable "repositories" {
  description = "Repositories managed under the organisation. Map key is the repository name; each repo inherits the standard baseline defined in main.tf unless a field is overridden here."
  type = map(object({
    description = optional(string, "")
    visibility  = optional(string, "public")
  }))

  validation {
    condition = alltrue([
      for name in keys(var.repositories) :
      # Special GitHub repository, exempt from the convention.
      contains([".github"], name) ||
      can(regex("^(app|infra|data|docs)-(braveart|certwatch|cvengine|powertoggle|learning|landingzone|github|homelab|developer|engineering)-([a-z0-9]+(-[a-z0-9]+)*)$", name)) ||
      can(regex("^(module|pipeline)-(braveart|certwatch|cvengine|powertoggle|learning|landingzone|github|homelab|developer|engineering)-([a-z0-9]+(-[a-z0-9]+)*)-(terraform|bicep|ansible|kubernetes|helm|docker|node|dotnet|python|powershell)$", name))
    ])
    error_message = "One or more repository names violate the naming standard <type>-<domain>-<component>[-<qualifier>]. type: app|infra|module|pipeline|data|docs; domain and qualifier must come from the registered vocabularies; module and pipeline require a technology qualifier. See skyhaven-ltd/.github/standards/repo-naming.md."
  }
}
