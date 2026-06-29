# One-time adoption of the self-managed infra-github-platform repo into state.
# The other 11 repos are already in state; only this repo needs importing.
# Its branch-protection rulesets do not exist yet, so Terraform creates them.
# DELETE THIS FILE after the first apply that adopts the repo.
import {
  to = github_repository.this["infra-github-platform"]
  id = "infra-github-platform"
}

import {
  to = github_branch_default.this["infra-github-platform"]
  id = "infra-github-platform"
}

import {
  to = github_repository_vulnerability_alerts.this["infra-github-platform"]
  id = "infra-github-platform"
}

import {
  to = github_repository_dependabot_security_updates.this["infra-github-platform"]
  id = "infra-github-platform"
}

import {
  to = github_issue_labels.this["infra-github-platform"]
  id = "infra-github-platform"
}
