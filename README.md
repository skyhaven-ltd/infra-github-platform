# infra-github-platform

Terraform configuration that manages the `skyhaven-ltd` GitHub organisation's
repositories and their branch protection, security, and label standards.

## What it manages

Each repository inherits a standard baseline (defined in `infra/main.tf`, applied to
every repo via `for_each`):

- Squash-only merges, no merge commits / rebase, no auto-merge.
- Issues, projects, and wiki enabled.
- Dependabot vulnerability alerts + security updates, secret scanning + push protection.
- A per-repo `main-branch-protection` `github_repository_ruleset` — defined once and
  applied to every repo's default branch — that blocks deletion and force-push and
  requires a pull request. New repos are protected automatically when added to the map.
  (Repository rulesets are free on public repos; org-wide rulesets need a paid plan, so
  the per-repo form is used.)
- A single `use-type-field-instead` label (the project board's Type field is the
  real classification).

Issue creation (bug/feature reports) is **not** managed here — that stays in the
`raise-bug` / `raise-feature` skills, which work unchanged against these repos.
Organisation-level settings (membership, teams) are out of scope (phase 2).

## Prerequisites

- Terraform >= 1.7
- A GitHub token for an **admin** of `skyhaven-ltd`, with the `repo` scope:

  ```powershell
  $env:GITHUB_TOKEN = (gh auth token)
  ```

## Usage

```powershell
terraform -chdir=infra init
terraform -chdir=infra plan  -var-file=vars/global.tfvars
terraform -chdir=infra apply -var-file=vars/global.tfvars
```

### Adding a repository

Add a line to `repositories` in `infra/vars/global.tfvars`:

```hcl
"solution-new-thing" = {}            # full standard baseline
"private-thing"      = { visibility = "private" }
```

Then `terraform -chdir=infra apply -var-file=vars/global.tfvars`.

## State

Local state for now (`infra/terraform.tfstate`, git-ignored). Migrating to an Azure
Storage backend with CI/CD is a later change: add a `backend "azurerm"` block to
`infra/_terraform.tf` and run `terraform init -migrate-state`. Nothing else changes.
