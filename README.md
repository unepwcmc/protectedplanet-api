# Protected Planet API

The public REST API at [api.protectedplanet.net](https://api.protectedplanet.net) serving
WDPA / WD-OECM data. **Using** the API? Go to the
[API documentation](https://api.protectedplanet.net/documentation). This README is for
people who run or change the code.

**New to the product family?** Read the
[Protected Planet wiki](https://github.com/unepwcmc/protected-planet-wiki) first.

---

## What this app is

Not a Rails app. It is a plain **Rack** stack with two mounted applications, cascaded in
[`config.ru`](config.ru) as `Rack::Cascade.new([Web::Root, API::Root])` — documentation
first, API second.

| Path | Framework | Role |
|---|---|---|
| `api/` | [Grape](https://github.com/ruby-grape/grape) 3.2 | The REST API — `v3` and `v4` namespaces |
| `web/` | [Sinatra](https://www.sinatrarb.com/) 4.2 | Documentation site and admin UI (ERB + Kramdown) |
| `models/` | ActiveRecord | Shared models, shaped for API output |

Ruby 4.0.2, Puma 8. JSON is built by serialiser classes in `api/serialisers/`, not RABL.
Middleware (in `config.ru`): cookie sessions, CSRF, CORS, AppSignal, AR connection
management, rate limiting (`config/rack_attack.rb`, see caveat below), and a code reloader
in development.

### It shares Protected Planet's database

`db/` is a git **submodule** of
[protectedplanet-db](https://github.com/unepwcmc/protectedplanet-db), the same one
[ProtectedPlanet](https://github.com/unepwcmc/ProtectedPlanet) uses. This app **never
runs migrations** — all schema changes happen in the Rails app. Models here mirror the
ones there; cross-check before changing behaviour.

```bash
cd db && git fetch && git merge origin/master && cd ..
```

Because the two apps share a Postgres cluster, they also cannot diverge on Postgres or
PostGIS version.

## What it depends on outside this repo

- **PP Postgres + PostGIS** — the same database ProtectedPlanet uses (`POSTGRES_*` in `.env`).
- **AppSignal** — optional, enabled by env.
- **Cloudflare** — in front of production.
- **SMTP** — API-user signup and token mail.
- Secrets live in **Keeper**.

### `CORS_ORIGINS`

Comma-separated list of allowed browser origins. In **staging and production it must be
set** or the app refuses to boot. In development/test an empty value behaves like `*`.

### Rate limiting

`config/rack_attack.rb` throttles each API token (or IP, if no token) on `/v3` and `/v4` paths. **Caveat:** the counter store is an in-process
`ActiveSupport::Cache::MemoryStore`, not Redis — each Puma worker counts independently, so
the real ceiling for one client is closer to `limit * PUMA_WORKERS`, not a hard cluster-wide
cap. Move to a shared store if a tighter, exact limit is ever needed.

---

## Running it locally

### With the ProtectedPlanet stack (recommended)

This app is a service in ProtectedPlanet's `docker-compose.yml`, behind the `api` profile.

1. Clone and configure [ProtectedPlanet](https://github.com/unepwcmc/ProtectedPlanet) per
   its [Docker docs](https://github.com/unepwcmc/ProtectedPlanet/blob/master/docs/docker.md).
2. Set `API_PATH` in that repo's `.env` to the absolute path of this checkout.
3. In Protected Planet folder run `docker compose --profile api up`
4. Open <http://localhost:9292> (MailHog/Mailpit on <http://localhost:8025>).

### Standalone

Needs Ruby 4.0.2 (`.tool-versions`) and a Postgres already migrated by the Rails app.

```bash
bundle install
cp .env.example .env      # then fill in RACK_ENV + POSTGRES_*
sh ./bin/docker-dev-server
```

`RACK_ENV` is **required** — it becomes the `RACK_ENV` constant in
[`config/environment.rb`](config/environment.rb) and boot fails without it.

```bash
RACK_ENV=development bundle exec bin/console   # IRB, not rails console
bundle exec rake test                          # tests (RACK_ENV defaults to test)
RACK_ENV=development bundle exec rake -T       # all tasks
```

---

## Adding a field to the API

1. Add it to the model's `api_attributes` array (e.g. `models/protected_area.rb`).
2. Run the permission reset, or **existing API users will not see it**:
   ```bash
   RACK_ENV=production bundle exec rake api_users:reset_permissions
   ```
   As of Apr 2026 every user gets every field; if that policy changes, change the task.

Do the same after any migration that exposes a new API column.

### Other user tasks

```bash
RACK_ENV=production bundle exec rake api_users:remove[inactive]
RACK_ENV=production bundle exec rake api_users:remove[archived]
RACK_ENV=production bundle exec rake api_users:remove[archived_or_inactive]
```

---

## Trying endpoints

A [Bruno](https://www.usebruno.com/) collection covering all **v4** endpoints is in
[`bruno/`](bruno/) — open the folder, pick the `local` or `production` environment, and
set the `token` secret var. Auth is `Authorization: Bearer {{token}}` at collection level
(the `?token=` query param still works but is deprecated). Optional search filters are
pre-written but disabled — `/search` returns `400` with no filters.

---

## Deploying

Kamal 2, from `config/deploy.yml` with `deploy.staging.yml` / `deploy.production.yml`.
Staging runs on the internal Proxmox VM `pp-web-staging-01.internal.unep-wcmc.org` (served
as `api-pp-web-staging-01.internal.unep-wcmc.org`), with the image built on that host and
no registry. Production is still the Linode box
`new-web.pp-production.linode.protectedplanet.net`.

## Troubleshooting

- **Can't connect to the database** — `POSTGRES_*` host/port differ between Docker and localhost.
- **Missing tables or columns** — run migrations in ProtectedPlanet, not here.
- **`RACK_ENV` missing** — set it for anything that loads `config/environment.rb`.
- **New field not visible to users** — you skipped `api_users:reset_permissions`.
