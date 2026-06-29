# One-time adoption of the self-managed infra-github-platform repo into state.
# The other 11 repos are already in state; only this repo needs importing.
# Its branch-protection ruleset does not exist yet, so Terraform creates it.
# DELETE THIS FILE after the first apply that adopts the repo.
locals {
  self_repo = "infra-github-platform"
}

import {
  to = github_repository.this[local.self_repo]
  id = local.self_repo
}

import {
  to = github_branch_default.this[local.self_repo]
  id = local.self_repo
}

import {
  to = github_repository_vulnerability_alerts.this[local.self_repo]
  id = local.self_repo
}

import {
  to = github_repository_dependabot_security_updates.this[local.self_repo]
  id = local.self_repo
}

import {
  to = github_issue_labels.this[local.self_repo]
  id = local.self_repo
}
