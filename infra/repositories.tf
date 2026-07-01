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
    ignore_changes = [auto_init, template]
  }
}

resource "github_repository_vulnerability_alerts" "this" {
  for_each = github_repository.this

  repository = each.value.name
  enabled    = true
}

resource "github_repository_dependabot_security_updates" "this" {
  for_each = github_repository_vulnerability_alerts.this

  repository = each.value.repository
  enabled    = true
}

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
      required_approving_review_count   = 0
      require_code_owner_review         = false
      dismiss_stale_reviews_on_push     = true
      require_last_push_approval        = false
      required_review_thread_resolution = true
      allowed_merge_methods             = ["squash"]
    }
  }
}

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