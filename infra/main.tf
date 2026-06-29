# Standard repository baseline shared by every repo in the organisation.
resource "github_repository" "this" {
  for_each = var.repositories

  name        = each.key
  description = each.value.description
  visibility  = each.value.visibility

  has_issues   = true
  has_projects = true
  has_wiki     = true

  allow_squash_merge     = true
  allow_merge_commit     = false
  allow_rebase_merge     = false
  allow_auto_merge       = true
  delete_branch_on_merge = true
  allow_update_branch    = true

  # Squash commits default to the pull request title (no body).
  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "BLANK"

  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }

  lifecycle {
    prevent_destroy = true
    # auto_init and template are create-time-only; some repos were generated
    # from a template, so ignore both to avoid a perpetual no-op diff.
    ignore_changes = [auto_init, template]
  }
}

# Default branch (already main on every repo; managed for completeness).
resource "github_branch_default" "this" {
  for_each = github_repository.this

  repository = each.value.name
  branch     = "main"
}

# Dependabot vulnerability alerts (prerequisite for security updates).
resource "github_repository_vulnerability_alerts" "this" {
  for_each = github_repository.this

  repository = each.value.name
  enabled    = true
}

# Dependabot security updates (requires vulnerability alerts to be enabled).
resource "github_repository_dependabot_security_updates" "this" {
  for_each = github_repository_vulnerability_alerts.this

  repository = each.value.repository
  enabled    = true
}

# Authoritative label set: only the project-board pointer label is kept.
resource "github_issue_labels" "this" {
  for_each = github_repository.this

  repository = each.value.name

  label {
    name        = "use-type-field-instead"
    color       = "ededed"
    description = "Use the Type field on the project board instead"
  }
}

# Default-branch protection. Defined once and applied to every repository's
# default branch via for_each, so new repos are protected by adding them to the
# repositories map. Repository rulesets are free on public repos; organisation
# rulesets require a paid GitHub plan. Adopts the existing legacy per-repo
# rulesets (imported in _imports.tf).
resource "github_repository_ruleset" "default_branch" {
  for_each = github_repository.this

  name        = "main-branch-protection"
  repository  = each.value.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    deletion         = true
    non_fast_forward = true

    pull_request {
      # Solo org: no required reviewer count, but enforce the review hygiene rules.
      required_approving_review_count   = 0
      require_code_owner_review         = false
      dismiss_stale_reviews_on_push     = true
      require_last_push_approval        = true
      required_review_thread_resolution = true
      allowed_merge_methods             = ["squash"]
    }
  }
}

# Branch-naming convention: every non-default branch must start with one of the
# allowed prefixes. Enforced as a separate ruleset because name-pattern rules
# cannot target the default branch (main is excluded below).
resource "github_repository_ruleset" "branch_naming" {
  for_each = github_repository.this

  name        = "branch-naming-convention"
  repository  = each.value.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~ALL"]
      exclude = ["~DEFAULT_BRANCH"]
    }
  }

  rules {
    branch_name_pattern {
      operator = "regex"
      pattern  = "^(major|minor|patch|feature|hotfix)/"
    }
  }
}
