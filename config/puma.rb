# frozen_string_literal: true

workers Integer(ENV.fetch('PUMA_WORKERS', '0'))

max_threads = Integer(ENV.fetch('PUMA_MAX_THREADS', 5))
min_threads = Integer(ENV.fetch('PUMA_MIN_THREADS', 1))
threads min_threads, max_threads

port 9292

# Optional: set PUMA_PIDFILE=/tmp/puma.pid if something expects a pidfile
pidfile ENV['PUMA_PIDFILE'] if (path = ENV['PUMA_PIDFILE']) && !path.empty?
