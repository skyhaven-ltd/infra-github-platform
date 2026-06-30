# infra-github-platform

Terraform configuration that manages the `skyhaven-ltd` GitHub organisation's repositories and their branch-protection rulesets, security settings, and label standards from a single baseline applied to every repo. It manages its own repository alongside the others, with state held in Azure Storage and changes planned and applied through a GitHub Actions workflow.
