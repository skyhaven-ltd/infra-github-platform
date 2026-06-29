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
}
