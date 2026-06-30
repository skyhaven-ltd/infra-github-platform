resource "github_issue_labels" "this" {
  for_each = github_repository.this

  repository = each.value.name

  label {
    name        = "use-type-field-instead"
    color       = "ededed"
    description = "Use the Type field on the project board instead"
  }
}