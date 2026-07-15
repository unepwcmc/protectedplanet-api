# frozen_string_literal: true

# Production: cluster-friendly preload, AR fork hooks.
# Staging uses the same behaviour via config/puma/staging.rb (delegates here).
# No stdout_redirect (same idea as wdpa-data-management-portal): Puma uses default process logging;
# container runtime / Kamal collects stdout/stderr like the sibling Rails app.

worker_count = Integer(ENV.fetch('PUMA_WORKERS', '0'))
workers worker_count

max_threads = Integer(ENV.fetch('PUMA_MAX_THREADS', '5'))
min_threads = Integer(ENV.fetch('PUMA_MIN_THREADS', '1'))
threads min_threads, max_threads

preload_app! if worker_count.positive?

if worker_count.positive?
  before_fork do
    next unless defined?(ActiveRecord::Base)

    ActiveRecord::Base.connection_pool.disconnect!
  end

  before_worker_boot do
    next unless defined?(ActiveRecord::Base)

    ActiveRecord::Base.establish_connection
  end
end

port 9292

pidfile ENV['PUMA_PIDFILE'] if (path = ENV['PUMA_PIDFILE']) && !path.empty?
