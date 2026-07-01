# Rename grandfathered repositories to the naming standard in place.
#
# github_repository.this has prevent_destroy, so changing its map key would
# otherwise force a destroy/recreate. These moved blocks preserve each
# instance's identity across the key change so Terraform renames the repository
# (and re-keys its dependent resources) instead of recreating it.
#
# Safe to delete once the rename apply has completed and state is settled.

# solution-braveart-gallery -> app-braveart-gallery
moved {
  from = github_repository.this["solution-braveart-gallery"]
  to   = github_repository.this["app-braveart-gallery"]
}

moved {
  from = github_repository_vulnerability_alerts.this["solution-braveart-gallery"]
  to   = github_repository_vulnerability_alerts.this["app-braveart-gallery"]
}

moved {
  from = github_repository_dependabot_security_updates.this["solution-braveart-gallery"]
  to   = github_repository_dependabot_security_updates.this["app-braveart-gallery"]
}

moved {
  from = github_repository_ruleset.default_branch["solution-braveart-gallery"]
  to   = github_repository_ruleset.default_branch["app-braveart-gallery"]
}

moved {
  from = github_repository_ruleset.branch_naming["solution-braveart-gallery"]
  to   = github_repository_ruleset.branch_naming["app-braveart-gallery"]
}

moved {
  from = github_branch_default.this["solution-braveart-gallery"]
  to   = github_branch_default.this["app-braveart-gallery"]
}

# solution-certwatch-web -> app-certwatch-web
moved {
  from = github_repository.this["solution-certwatch-web"]
  to   = github_repository.this["app-certwatch-web"]
}

moved {
  from = github_repository_vulnerability_alerts.this["solution-certwatch-web"]
  to   = github_repository_vulnerability_alerts.this["app-certwatch-web"]
}

moved {
  from = github_repository_dependabot_security_updates.this["solution-certwatch-web"]
  to   = github_repository_dependabot_security_updates.this["app-certwatch-web"]
}

moved {
  from = github_repository_ruleset.default_branch["solution-certwatch-web"]
  to   = github_repository_ruleset.default_branch["app-certwatch-web"]
}

moved {
  from = github_repository_ruleset.branch_naming["solution-certwatch-web"]
  to   = github_repository_ruleset.branch_naming["app-certwatch-web"]
}

moved {
  from = github_branch_default.this["solution-certwatch-web"]
  to   = github_branch_default.this["app-certwatch-web"]
}

# solution-cvengine-portfolio -> app-cvengine-portfolio
moved {
  from = github_repository.this["solution-cvengine-portfolio"]
  to   = github_repository.this["app-cvengine-portfolio"]
}

moved {
  from = github_repository_vulnerability_alerts.this["solution-cvengine-portfolio"]
  to   = github_repository_vulnerability_alerts.this["app-cvengine-portfolio"]
}

moved {
  from = github_repository_dependabot_security_updates.this["solution-cvengine-portfolio"]
  to   = github_repository_dependabot_security_updates.this["app-cvengine-portfolio"]
}

moved {
  from = github_repository_ruleset.default_branch["solution-cvengine-portfolio"]
  to   = github_repository_ruleset.default_branch["app-cvengine-portfolio"]
}

moved {
  from = github_repository_ruleset.branch_naming["solution-cvengine-portfolio"]
  to   = github_repository_ruleset.branch_naming["app-cvengine-portfolio"]
}

moved {
  from = github_branch_default.this["solution-cvengine-portfolio"]
  to   = github_branch_default.this["app-cvengine-portfolio"]
}

# solution-powertoggle-vm -> app-powertoggle-vm
moved {
  from = github_repository.this["solution-powertoggle-vm"]
  to   = github_repository.this["app-powertoggle-vm"]
}

moved {
  from = github_repository_vulnerability_alerts.this["solution-powertoggle-vm"]
  to   = github_repository_vulnerability_alerts.this["app-powertoggle-vm"]
}

moved {
  from = github_repository_dependabot_security_updates.this["solution-powertoggle-vm"]
  to   = github_repository_dependabot_security_updates.this["app-powertoggle-vm"]
}

moved {
  from = github_repository_ruleset.default_branch["solution-powertoggle-vm"]
  to   = github_repository_ruleset.default_branch["app-powertoggle-vm"]
}

moved {
  from = github_repository_ruleset.branch_naming["solution-powertoggle-vm"]
  to   = github_repository_ruleset.branch_naming["app-powertoggle-vm"]
}

moved {
  from = github_branch_default.this["solution-powertoggle-vm"]
  to   = github_branch_default.this["app-powertoggle-vm"]
}

# ops-homelab-config -> infra-homelab-config
moved {
  from = github_repository.this["ops-homelab-config"]
  to   = github_repository.this["infra-homelab-config"]
}

moved {
  from = github_repository_vulnerability_alerts.this["ops-homelab-config"]
  to   = github_repository_vulnerability_alerts.this["infra-homelab-config"]
}

moved {
  from = github_repository_dependabot_security_updates.this["ops-homelab-config"]
  to   = github_repository_dependabot_security_updates.this["infra-homelab-config"]
}

moved {
  from = github_repository_ruleset.default_branch["ops-homelab-config"]
  to   = github_repository_ruleset.default_branch["infra-homelab-config"]
}

moved {
  from = github_repository_ruleset.branch_naming["ops-homelab-config"]
  to   = github_repository_ruleset.branch_naming["infra-homelab-config"]
}

moved {
  from = github_branch_default.this["ops-homelab-config"]
  to   = github_branch_default.this["infra-homelab-config"]
}

# ops-developer-config -> infra-developer-config
moved {
  from = github_repository.this["ops-developer-config"]
  to   = github_repository.this["infra-developer-config"]
}

moved {
  from = github_repository_vulnerability_alerts.this["ops-developer-config"]
  to   = github_repository_vulnerability_alerts.this["infra-developer-config"]
}

moved {
  from = github_repository_dependabot_security_updates.this["ops-developer-config"]
  to   = github_repository_dependabot_security_updates.this["infra-developer-config"]
}

moved {
  from = github_repository_ruleset.default_branch["ops-developer-config"]
  to   = github_repository_ruleset.default_branch["infra-developer-config"]
}

moved {
  from = github_repository_ruleset.branch_naming["ops-developer-config"]
  to   = github_repository_ruleset.branch_naming["infra-developer-config"]
}

moved {
  from = github_branch_default.this["ops-developer-config"]
  to   = github_branch_default.this["infra-developer-config"]
}
