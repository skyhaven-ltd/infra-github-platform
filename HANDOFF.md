# Handoff — infra-github-platform

Terraform-manages the `skyhaven-ltd` GitHub org's repositories, branch protection,
security, and labels. Replaces the imperative `config-repo-gh` skill.

## Status

- **Phase 1 — DONE.** As of 2026-06-29 all 11 repos are transferred to `skyhaven-ltd`
  and under Terraform management (66 resources in state: 11 repos × 6). Plan is clean.
- **Phase 2 — prepared, pending your action.** The config now self-manages a 12th repo
  (`infra-github-platform`), an `azurerm` remote-state backend block is in place, and
  the CI/CD workflows are committed. Three things remain, all yours (see
  "Phase 2 — remaining steps" below): create Azure OIDC + secrets, migrate state to
  Azure, and run the first apply to adopt the self repo.

State is still **local** (`infra/terraform.tfstate`) until you run the migration.

## Decisions made

- **Owner target:** all 11 repos transferred from personal `liam-goodchild` to the
  `skyhaven-ltd` org. (Transfers leave redirects behind; old URLs still resolve.)
- **Scope:** all 11 repos managed at once.
- **Branch protection:** a single `github_repository_ruleset` resource defined once and
  applied to every repo's default branch via `for_each` (one ruleset per repo).
  - **Why per-repo, not org-wide:** `github_organization_ruleset` requires a paid
    GitHub plan (Team+). `skyhaven-ltd` is on the free plan — the org-ruleset apply
    returned `403 Upgrade to GitHub Team`. Repository rulesets are free on public repos.
  - The 11 pre-existing legacy `main-branch-protection` rulesets were **adopted**
    (imported), not deleted — so their IDs are now TF-managed. `ops-developer-config`'s
    legacy ruleset was weaker (no PR rule, `non_fast_forward=false`) and was standardized.
- **Module:** the `modules/repository/` module was inlined into `infra/main.tf` (it was
  never going to be reused). No module remains.
- **State:** local for now; Azure backend + CI/CD is a later swap of the `backend` block.
- **Out of scope:** issue creation (`raise-bug` / `raise-feature`) stays as skills.
  Org membership/teams/settings deferred (phase 2).

## Layout (`infra/`)

- `_terraform.tf`, `_providers.tf`, `_variables.tf` — provider + variable wiring.
- `main.tf` — the repo baseline (squash-only merges, issues/projects/wiki on, default
  branch `main`, vulnerability alerts, dependabot security updates, secret scanning +
  push protection, the single `use-type-field-instead` label) and the per-repo
  `github_repository_ruleset`. All resources `for_each` over `var.repositories`.
- `vars/global.tfvars` — the 11 repos (map keyed by repo name) + `github_owner`.
- `terraform.tfstate` — local state (gitignored).

`imports.tf` and `modules/` have been removed (adoption complete).

## Running it

```powershell
$env:GITHUB_TOKEN = (gh auth token)   # token needs `repo`; `admin:org` no longer required
terraform -chdir=infra plan -var-file=vars/global.tfvars
```

> Note: `admin:org` was only needed for the org-wide ruleset, which we dropped. The
> current per-repo design works with a plain `repo`-scoped token.

## Adding a repo

Add a line to `vars/global.tfvars` (`"<name>" = {}` for the full baseline), then
`terraform -chdir=infra apply`. New repos get the baseline + ruleset automatically.

## CI/CD (`.github/`)

Copied from the org `infra-engineering-template` pattern and adapted:

- `workflows/terraform.yml` — plan on push to `major|minor|patch/**` branches touching
  `infra/**`; `apply`/`destroy` via manual `workflow_dispatch`. Single `prd` environment.
  Authenticates to **Azure** via OIDC (backend) and to **GitHub** via a **GitHub App**
  token (the `github` provider needs org-admin rights; the default `GITHUB_TOKEN` can't
  manage org repos). Cloudflare vars from the template were dropped (not used here).
- `workflows/tag.yml` — on PR merge to `main`, tags `vX.Y.Z` from the branch prefix.
- `actions/ensure-tfstate-container`, `actions/break-tfstate-lease` — composite actions
  used by `terraform.yml` (verbatim copies).

## Phase 2 — remaining steps (yours)

1. **GitHub App** (org-owned) for CI provider auth: create it with Repository
   *Administration: read/write*, *Contents: read/write*, *Issues: read/write* perms,
   install on `skyhaven-ltd`, then set repo/env secrets `GH_APP_ID` and
   `GH_APP_PRIVATE_KEY`.
2. **Azure OIDC + secrets**: add a federated credential on the platform app registration
   for `repo:skyhaven-ltd/infra-github-platform:environment:prd`, and set secrets
   `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_PLATFORM_SUBSCRIPTION_ID` (the sub holding
   `sttfsplatformprduks01`).
3. **Migrate state to Azure** (locally, in the platform Azure context):
   ```powershell
   $env:GITHUB_TOKEN = (gh auth token)
   terraform -chdir=infra init -migrate-state `
     -backend-config="resource_group_name=rg-tfs-platform-prd-uks-01" `
     -backend-config="storage_account_name=sttfsplatformprduks01" `
     -backend-config="container_name=infra-github-platform" `
     -backend-config="key=terraform.tfstate" `
     -backend-config="subscription_id=<platform-sub-id>"
   ```
   (Create the `infra-github-platform` container first if it doesn't exist — CI's
   `ensure-tfstate-container` does this automatically on its first run.)
4. **First apply** to adopt the self repo (`_imports.tf` imports it; its ruleset is
   created): `terraform -chdir=infra apply -var-file=vars/global.tfvars`.
5. **Delete `infra/_imports.tf`**, then plan again to confirm steady state.
6. **Update local clones'** `origin` remotes from `liam-goodchild/*` to `skyhaven-ltd/*`.
7. Confirm the Project V2 board still links the repos after the transfer.

## Notes / risks

- Secret scanning + push protection are enabled on all 11 (was disabled). The
  `security_and_analysis` block has not caused a perpetual diff.
- `template` and `auto_init` are in `ignore_changes` — 3 repos were generated from
  `infra-engineering-template` and would otherwise show a perpetual no-op diff.
- Applying the label set is authoritative: it deleted the default/dependabot labels on
  `app-learning-review`, `solution-certwatch-web`, and `solution-powertoggle-vm`,
  leaving only `use-type-field-instead`.
