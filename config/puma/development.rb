# frozen_string_literal: true

require 'dotenv'
Dotenv.load

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

bind_host = ENV.fetch('PUMA_BIND', '0.0.0.0')
bind "tcp://#{bind_host}:9292"

pidfile ENV.fetch('PUMA_PIDFILE', nil) if (path = ENV.fetch('PUMA_PIDFILE', nil)) && !path.empty?
