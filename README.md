# Protected Planet API

The official API for accessing global protected area data from the World Database on Protected Areas (WDPA).

> **All Protected Planet projects in one workspace:** If you use VS Code, clone [ProtectedPlanet](https://github.com/unepwcmc/ProtectedPlanet) and open [protected-planet-family-apps.code-workspace](https://github.com/unepwcmc/ProtectedPlanet/blob/master/protected-planet-family-apps.code-workspace) so related apps load together.

## For API users

To **use** the API, see [API Documentation](https://api.protectedplanet.net/documentation).

## For developers

This guide is for people who **run or contribute to** this codebase locally.

## Architecture overview

The app is a **Ruby Rack** stack with two mounted applications:

| Area | Framework | Role |
|------|-----------|------|
| `api/**/*` | [Grape](https://github.com/ruby-grape/grape) | REST API (v3 and v4 namespaces) |
| `web/**/*` | [Sinatra](https://www.sinatrarb.com/) | Documentation and admin UI |

### How it fits together

1. **Rack::Cascade** in [`config.ru`](config.ru) runs **documentation first**, then the API: `[Web::Root, API::Root]`.
2. **Shared ActiveRecord models** under `models/` mirror [ProtectedPlanet](https://github.com/unepwcmc/ProtectedPlanet/tree/master/app/models) but are shaped for API output. Cross-check the main app when changing behaviour; for new models, copy from ProtectedPlanet and adapt.
3. **JSON responses** are built with **Grape serialiser classes** in [`api/serialisers/`](api/serialisers/) (not RABL).
4. **Docs** use ERB views and Markdown (via Kramdown).
5. **Middleware** (see `config.ru`): cookie sessions, CSRF, CORS, optional AppSignal, ActiveRecord connection management, and in development a code reloader.

### Database

The `db/` directory is a **git submodule** pointing at [protectedplanet-db](https://github.com/unepwcmc/protectedplanet-db) (schemas and migrations live there). Connection settings come from `POSTGRES_*` variables in `.env` (see [`.env.example`](.env.example)).

All database migrations are ran in ProtectedPlanet using rails. This project is purely for serving APIs

## Environment variables

Boot **requires** `RACK_ENV` (e.g. `development`, `test`, or `production`). That value becomes the Ruby constant `RACK_ENV`—see [`config/environment.rb`](config/environment.rb).

Copy [`.env.example`](.env.example) to `.env` and fill in values (team secrets are typically stored in Keeper). Database fields must match a running Postgres instance (often the one from the main ProtectedPlanet Docker stack).

## Available tasks

### Reset API user permissions

```bash
RACK_ENV=production bundle exec rake api_users:reset_permissions
```

- **Purpose:** Give all API users access to every field listed in each model’s `api_attributes`.
- **When:** After adding or changing fields in `api_attributes`, or after migrations expose new API columns.

### Remove API users

```bash
RACK_ENV=production bundle exec rake api_users:remove[inactive]
RACK_ENV=production bundle exec rake api_users:remove[archived]
RACK_ENV=production bundle exec rake api_users:remove[archived_or_inactive]
```

- **Purpose:** Remove inactive or archived API users (with confirmation and a preview).

### Other tasks

```bash
RACK_ENV=development bundle exec rake -T
```

## Getting started

### Option 1: Docker with ProtectedPlanet (recommended)

The API shares the Rails app database. The parent repo’s Compose file defines an optional **`api`** service (profile `api`) that builds this project.

1. Clone [ProtectedPlanet](https://github.com/unepwcmc/ProtectedPlanet) and configure its `.env` (including Postgres) and continue following all steps inside ProtectedPlanet project.
2. Set **`API_PATH`** in that `.env` to your local **absolute path** to this `protectedplanet-api` checkout.
3. Run migrations from the Rails app when needed (`bundle exec rails db:migrate` inside the `web` container or local Rails), and restore or seed data per [ProtectedPlanet Docker docs](https://github.com/unepwcmc/ProtectedPlanet/blob/master/docs/docker.md).
4. Start the stack **with the API profile**:

   ```bash
   SSH_AUTH_SOCK=$SSH_AUTH_SOCK docker compose --profile api up
   ```

5. Open **`http://localhost:9292`**.

For more detail (including running only `api` and `db`), see **Step 4** in [`docs/docker.md` in ProtectedPlanet](https://github.com/unepwcmc/ProtectedPlanet/blob/master/docs/docker.md).

### Option 2: Local Ruby

Use this when you already have Postgres and env vars configured.

1. Install **Ruby 4.0.2** (see [`.tool-versions`](.tool-versions)), e.g. with [asdf](https://asdf-vm.com/).
2. Install gems: `bundle install`
3. Configure `.env` from `.env.example` and set `RACK_ENV=development` plus `POSTGRES_*` (and other required keys).
4. Ensure the database exists and migrations have been applied from the main ProtectedPlanet Rails app (this repo is not a Rails app and does not run `rails db:migrate` here).
5. Start the app on port **9292**:

   ```bash
    sh ./bin/docker-dev-server
   ```

6. Visit **`http://localhost:9292`**.

## Updating the database submodule

```bash
cd db/
git fetch
git merge origin/master
cd ..
```

## Development console

Use **IRB** (not Rails console). From the **project root**, load the app in one step:

```bash
RACK_ENV=development bundle exec bin/console
```


## API development: new attributes

### 1. Add the field to `api_attributes`

```ruby
# e.g. models/protected_area.rb
def api_attributes
  [
    'name', 'wdpa_id', 'designation',
    'your_new_field'
  ]
end
```

### 2. Reset permissions

Run [Reset API user permissions](#reset-api-user-permissions) so existing users can see new fields.

Do this whenever `api_attributes` or related permissions change, or when migrations add API-exposed columns.

## Tests

```bash
bundle exec rake test
```

`RACK_ENV` defaults to `test` in [`test/test_helper.rb`](test/test_helper.rb) if unset. Ensure `POSTGRES_TEST_DBNAME` (and related `POSTGRES_*` vars) point at a test database.

## Troubleshooting

- **Database connection errors:** Confirm Postgres is up and `POSTGRES_*` in `.env` match your instance (host/port often differ between Docker and localhost).
- **Missing tables or columns:** Run migrations in the main ProtectedPlanet Rails repository against the same database.
- **`RACK_ENV` missing:** Set it for any command that loads [`config/environment.rb`](config/environment.rb).
- **Secrets:** Compare your `.env` with [`.env.example`](.env.example) and your team’s Keeper record.

## Additional resources

- [API documentation](https://api.protectedplanet.net/documentation) (for API consumers)
- [ProtectedPlanet](https://github.com/unepwcmc/ProtectedPlanet) (main Rails application)
- [protectedplanet-db](https://github.com/unepwcmc/protectedplanet-db) (database submodule)
