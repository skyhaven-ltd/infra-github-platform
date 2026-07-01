output "repository_names" {
  description = "Names of the repositories managed by this configuration."
  value       = sort([for repo in github_repository.this : repo.name])
}
