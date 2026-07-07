repositories = {
  ".github"                    = {}
  "infra-engineering-template" = {}
  "infra-landingzone-platform" = {}
  "infra-developer-config" = {
    # Developer-machine config repo: small operational fixes are pushed
    # straight to main from the machines it manages.
    require_pull_request = false
  }
  "infra-homelab-config"                = {}
  "app-learning-review"                 = {}
  "app-certwatch-web"                   = {}
  "app-cvengine-portfolio"              = {}
  "app-powertoggle-vm"                  = {}
  "app-braveart-gallery"                = {}
  "app-stockalert-monitor"              = {}
  "infra-github-platform"               = {}
  "pipeline-engineering-github-actions" = {}
}
