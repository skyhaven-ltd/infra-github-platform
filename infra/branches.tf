resource "github_branch_default" "this" {
  for_each = github_repository.this

  repository = each.value.name
  branch     = "main"
}