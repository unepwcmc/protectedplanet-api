## ⬆️ Incremental Upgrade Guide

If you want to modernize this project, use an incremental upgrade path rather than a rewrite.

### Why incremental upgrade is preferred

- The app is relatively small and structurally simple.
- The main problem is legacy runtime and dependency age, not uncontrolled business complexity.
- A rewrite would still have to preserve API behavior, auth, database assumptions, and coupling with the main `ProtectedPlanet` stack.

### Recommended upgrade order

1. Freeze current API behavior with tests.
2. Move to an intermediate Ruby version first.
3. Upgrade low-level and test dependencies.
4. Upgrade Rack, Grape, Sinatra, and ActiveRecord together.
5. Reduce or replace `RABL`.
6. Move from the intermediate Ruby version to a current supported Ruby.
7. Clean up legacy bootstrapping and deployment leftovers last.

### Phase 0: Freeze current behavior

Before changing Ruby or gems:

- add request coverage for `v4` endpoints
- verify auth success and failure behavior
- cover validation failures and `404` cases
- cover geometry on and off behavior
- make sure contributors can run the focused API tests reliably

Current high-value test files:

- `test/api/v4/protected_areas_test.rb`
- `test/api/v4/protected_area_parcels_test.rb`
- `test/api/v4/countries_test.rb`

### Phase 1: Move to a Ruby stepping stone

Do not jump directly from Ruby `2.3` to the latest Ruby.

Suggested stepping stone:

- Ruby `2.7.x`

Tasks:

- update `.ruby-version`
- update `.tool-versions`
- update `Dockerfile`
- upgrade Bundler
- verify the app boots and tests run on the intermediate runtime

### Phase 2: Upgrade low-level dependencies

Upgrade or replace the least app-specific dependencies first:

- `pg`
- `nokogiri`
- `dotenv`
- test dependencies
- monitoring and notification gems

Expected cleanup:

- `factory_girl` -> `factory_bot`
- old `database_cleaner` usage -> current supported setup

### Phase 3: Upgrade the framework stack

Upgrade these together in one controlled phase:

- Rack
- Sinatra
- Grape
- `grape-kaminari`
- `grape-rabl`
- ActiveRecord / ActiveSupport
- `activerecord-postgis-adapter`

Files most likely to need code changes:

- `config.ru`
- `config/environment.rb`
- `config/active_record.rb`
- `api/root.rb`
- `api/helpers.rb`
- `api/v3/*.rb`
- `api/v4/*.rb`

### Phase 4: Reduce `RABL` dependency

`RABL` is likely to be one of the main long-term upgrade blockers.

Recommended approach:

- keep `RABL` only long enough to complete the framework upgrade
- replace it incrementally, starting with `v4`

Possible replacements:

- Grape entities
- PORO Serialisers
- explicit JSON builders

### Phase 5: Move to current Ruby

Once the app is stable on the intermediate runtime and modernized dependency stack:

- move to Ruby `3.2` or `3.3`
- fix keyword argument and gem compatibility issues
- align Docker and CI with the final supported runtime

### Phase 6: Post-upgrade cleanup

Only after the app is stable:

- remove legacy global boot patterns where practical
- review duplicated model logic against the main `ProtectedPlanet` app
- remove old deployment/runtime setup that is no longer used
- refresh contributor docs

### Gem upgrade priorities

Upgrade in place first:

- `dotenv`
- `pg`
- `kramdown`
- `slack-notifier`
- `exception_notification`
- `appsignal`
- `rack-test`

Replace or rename:

- `factory_girl` -> `factory_bot`
- older `database_cleaner` usage -> current supported pattern

High-risk gems likely to need code changes:

- `grape`
- `grape-rabl`
- `grape-kaminari`
- `sinatra`
- `activerecord`
- `activerecord-postgis-adapter`

### What not to do

- Do not attempt one large `bundle update`.
- Do not rewrite the app before contract-level tests are in place.
- Do not change runtime stack and API response shape in the same step unless required.
- Do not assume this repo can be upgraded independently of the main `ProtectedPlanet` app and `db` submodule.