# Authentication: export a token before running Terraform, e.g.
#   $env:GITHUB_TOKEN = (gh auth token)
# The token owner must be an org admin, and the token needs the `repo` and
# `admin:org` scopes (admin:org is required for github_organization_ruleset).
provider "github" {
  owner = var.github_owner
}
