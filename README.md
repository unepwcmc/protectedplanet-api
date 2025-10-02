# Protected Planet API

The official API for accessing global protected area data from the World Database on Protected Areas (WDPA).

## 🌍 For API Users

If you want to **use** the API to access protected area data, visit our [API Documentation](https://api.protectedplanet.net/documentation) to get started.

## 🛠️ For Developers

This guide is for developers who want to **contribute** to the API codebase or run it locally.

## Architecture Overview

The Protected Planet API is built as a **Ruby Rack application** with two main components:

| Component | Framework | Purpose |
|-----------|-----------|---------|
| `/api/**/*` | [Grape](https://github.com/ruby-grape/grape) | RESTful API endpoints |
| `/web/**/*` | [Sinatra](https://www.sinatrarb.com/) | Documentation website |

### How it works:
1. Both frameworks are combined using **Rack::Cascade** in [`config.ru`](/config.ru)
2. They share **ActiveRecord models** that are tailored for API usage:
   - Based on [ProtectedPlanet models](https://github.com/unepwcmc/ProtectedPlanet/tree/master/app/models) but optimized for API responses
   - **Important:** Always cross-reference with ProtectedPlanet when making changes
   - **For new models:** Copy from ProtectedPlanet first, then adapt for API needs
3. API responses use **RABL templates** for JSON formatting
4. Documentation is rendered using **ERB and Markdown**

### Database:
The `db/` folder is a **git submodule** linked to [protectedplanet-db](https://github.com/unepwcmc/protectedplanet-db), which contains all database schemas and migrations.

## 📋 Available Tasks

The API includes several rake tasks for maintenance and development:

### User Management Tasks

#### Reset API User Permissions
```bash
bundle exec rake api_users:reset_permissions
```
- **Purpose:** Reset permissions for all API users
- **When to use:** After adding new fields to `api_attributes` arrays
- **Required after:** Database migrations that add API-exposed columns

#### Remove API Users
```bash
# Remove inactive users only
bundle exec rake api_users:remove[inactive]

# Remove archived users only  
bundle exec rake api_users:remove[archived]

# Remove both inactive and archived users
bundle exec rake api_users:remove[archived_or_inactive]
```
- **Purpose:** Clean up inactive or archived API users
- **Safety:** Includes confirmation prompt before deletion
- **Preview:** Shows which users will be deleted before asking for confirmation

### Other Tasks
```bash
# List all available tasks
bundle exec rake -T

# List only api_users tasks
bundle exec rake -T api_users
```

## 🚀 Getting Started

### Option 1: Docker Setup (Recommended)

The easiest way to run the API locally:

1. **Use the docker-compose setup** from the main protectedplanet repository
2. **Create environment file:**
   ```bash
   # Create .env file and copy contents from Keeper (internal password manager)
   touch .env
   ```
3. **Run database migrations** in the main protectedplanet Rails app first
   ```bash
   # Note: We can't run migrations directly in this repo (non-Rails)
   # Run this in the main protectedplanet repository:
   bundle exec rails db:migrate
   ```
4. **Start the server:**
   ```bash
   docker-compose up
   ```
5. **Access the API:** Open your browser to `http://localhost:9292`

### Option 2: Local Ruby Setup

⚠️ **Not recommended** - use Docker instead for easier setup.

<details>
<summary>Click to expand local setup instructions</summary>

1. **Install Ruby version** (check `.ruby-version` file):
   ```bash
   rbenv install $(cat .ruby-version)
   rbenv local $(cat .ruby-version)
   ```

2. **Clone and setup:**
   ```bash
   git clone git@github.com:unepwcmc/protectedplanet-api.git
   cd protectedplanet-api
   bundle install
   ```

3. **Configure environment:**
   ```bash
   # Create .env file and copy contents from Keeper
   touch .env
   ```

4. **Run migrations** (in main protectedplanet Rails app)

5. **Start server:**
   ```bash
   rackup
   ```

6. **Access:** `http://localhost:9292`

</details>

## 🔄 Updating Database Schema

The database schema is managed as a git submodule. To get the latest database updates:

```bash
# Navigate to the database submodule
cd db/

# Fetch and merge latest changes
git fetch
git merge origin/master

# Return to project root
cd ..
```

## 🧪 Development Console

Access the Rails console to interact with models and test functionality:

```bash
# Start IRB with the application environment loaded
RAILS_ENV=development bundle exec irb

# Load the application
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}")
require 'config/environment.rb'
require 'lib/mailer.rb'

# Now you can interact with models
ApiUser.first
ProtectedArea.count
```

## 🔧 API Development

### Adding New API Attributes

When you add new fields to the API, you need to update user permissions:

#### Step 1: Add the attribute to the model
```ruby
# In models/protected_area.rb (or other model)
def api_attributes
  [
    'name', 'wdpa_id', 'designation',
    'your_new_field'  # Add your new field here
  ]
end
```

#### Step 2: Reset user permissions
- Use the **Reset API User Permissions** task mentioned in the [📋 Available Tasks](#-available-tasks) section

#### ⚠️ Important Notes:
- **Always run the rake task** after modifying `api_attributes`
- This ensures existing API users can access new fields
- **Required after:**
  - Adding new fields to `api_attributes` arrays
  - Modifying existing field permissions  
  - Database migrations that add API-exposed columns

## 🐛 Troubleshooting

### PostgreSQL Installation Issues

**Error:** `An error occurred while installing pg (0.18.4), and Bundler cannot continue.`

**Solution:**
```bash
gem install pg -v '0.18.1' -- --with-cflags="-Wno-error=implicit-function-declaration"
```

### Common Issues

- **Database connection errors:** Ensure the main protectedplanet Rails app database is running
- **Missing migrations:** Run migrations in the main protectedplanet repository first
- **Environment variables:** Check that your `.env` file contains all required variables from Keeper

---

## 📚 Additional Resources

- [API Documentation](https://api.protectedplanet.net/documentation) - For API users
- [ProtectedPlanet Main Repository](https://github.com/unepwcmc/ProtectedPlanet) - Main Rails application
- [ProtectedPlanet Database](https://github.com/unepwcmc/protectedplanet-db) - Database schemas and migrations
