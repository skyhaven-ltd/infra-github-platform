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

  # Enforce the organisation repository naming standard. Source of truth:
  # skyhaven-ltd/.github/standards/repo-naming.spec.yml — keep the vocabularies
  # and grammar below in sync with that file.
  #
  # A name is valid when it is exempt (.github) or matches the grammar:
  #   module/pipeline: <type>-<domain>-<component>-<qualifier>   (qualifier required)
  #   app/infra/data/docs: <type>-<domain>-<component>           (qualifier optional)
  validation {
    condition = alltrue([
      for name in keys(var.repositories) :
      # Special GitHub repository, exempt from the convention.
      contains([".github"], name) ||
      # app / infra / data / docs — qualifier optional.
      can(regex("^(app|infra|data|docs)-(braveart|certwatch|cvengine|powertoggle|learning|landingzone|github|homelab|developer|engineering)-([a-z0-9]+(-[a-z0-9]+)*)$", name)) ||
      # module / pipeline — technology qualifier mandatory.
      can(regex("^(module|pipeline)-(braveart|certwatch|cvengine|powertoggle|learning|landingzone|github|homelab|developer|engineering)-([a-z0-9]+(-[a-z0-9]+)*)-(terraform|bicep|ansible|kubernetes|helm|docker|node|dotnet|python|powershell)$", name))
    ])
    error_message = "One or more repository names violate the naming standard <type>-<domain>-<component>[-<qualifier>]. type: app|infra|module|pipeline|data|docs; domain and qualifier must come from the registered vocabularies; module and pipeline require a technology qualifier. See skyhaven-ltd/.github/standards/repo-naming.md."
  }
}
