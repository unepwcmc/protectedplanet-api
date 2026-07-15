# protectedplanet-api GitHub Actions deploy handover (staging)

This document explains what remains to be done so DevOps can automate staging deploys for `protectedplanet-api` via GitHub Actions + Kamal.

## 1) Current state in `protectedplanet-api`

Kamal deployment config already exists:

- Base Kamal config: `config/deploy.yml`
- Staging target: `config/deploy.staging.yml`
- Production target: `config/deploy.production.yml`

What is **not** present yet:

- No GitHub Actions workflow is defined in this repo (`.github/workflows` missing).
- Production host label still has a placeholder in `config/deploy.production.yml`:
  - `traefik.http.routers.protectedplanet-api-web-production.rule: Host(`TODO_PRODUCTION_DOMAIN`)`
- Staging host needs updating `config/deploy.staing.yml`

## 2) Working reference to follow

Use this repository as the implementation reference:

- `wdpa-data-management-portal/.github/workflows/deploy.yml`

Key patterns from that workflow:

1. Trigger on `push` to `staging`/`production` and on `release.published`.
2. Determine environment in a dedicated job (`determine-environment`).
3. Use a reusable deploy action (`unepwcmc/devops-actions/.github/actions/rails-kamal-v1-deploy@v1`).
4. Send start/success/failure Slack notifications (`unepwcmc/devops-actions/.github/actions/slack-notify@v1`).
5. Set `DOCKER_BUILDKIT=1` and run on self-hosted runners.

## 3) Remaining work checklist (DevOps)

### A. Create workflow

- Add `.github/workflows/deploy.yml` to `protectedplanet-api`.
- Start with staging deploy trigger:
  - `on.push.branches: [staging]`
- Optionally include production/release triggers once staging is validated.

### B. Add environment resolution job

- Add a `determine-environment` job (same pattern as wdpa repo).
- Output at least:
  - `environment` (`staging` or `production`)
  - `deploy-type` (`branch` or `release`)

### C. Add deploy job

- Use `unepwcmc/devops-actions/.github/actions/rails-kamal-v1-deploy@v1`.
- Use versions compatible with this repo (example values):
  - `ruby-version: '4.0.2'`
  - `kamal-version: '1.9.3'`
- Ensure `environment` matches Kamal target (`staging` for now).

### D. Configure secrets/variables in GitHub

Define secrets in repository/environment settings (see matrix below).

### E. Remove in-repo sensitive env usage

- Ensure CI/CD uses GitHub secrets, not committed `.env` files.
- If any staging credentials are still in repository files, rotate and move them to GitHub secrets.

### F. Validate production readiness placeholders

Before enabling production workflow path:

- Replace `TODO_PRODUCTION_DOMAIN` in `config/deploy.production.yml`.
- Verify production host/labels and required production secrets exist.

## 4) Required secrets and variables matrix

## Core deploy/auth

- `GH_TOKEN`
- `SSH_PRIVATE_KEY`
- `KAMAL_REGISTRY_USERNAME`
- `KAMAL_REGISTRY_PASSWORD`

## Runtime/app secrets (from `config/deploy.yml`)

- `RACK_SESSION_SECRET`
- `POSTGRES_HOST`
- `POSTGRES_PORT`
- `POSTGRES_DBNAME`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `CORS_ORIGINS`
- `ADMIN_USERNAME`
- `ADMIN_PASSWORD`
- `MAILER_AUTHENTICATION`
- `MAILER_ADDRESS`
- `MAILER_DOMAIN`
- `MAILER_USERNAME`
- `MAILER_PASSWORD`
- `MAILER_HOST`
- `MAILER_PORT`
- `APPSIGNAL_API_TOKEN`

## Environment-scoped clear vars

- Staging: `RACK_ENV=staging`
- Production: `RACK_ENV=production`

### Kamal/platform checks

- New image published to GHCR.
- Container is healthy at Kamal health endpoint (`/`, port `9292`).
- Traefik route from `config/deploy.staging.yml` responds correctly.

### App checks

- Authentication and DB-backed endpoints respond correctly.


## 5) Final go-live criteria for automated staging deploys

- Workflow file merged and active.
- All required secrets configured.
- At least one successful staging deployment from GitHub Actions.
- Documented owner for workflow maintenance and secret rotation.
