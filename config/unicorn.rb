# Set the working application directory
working_directory "/home/ubuntu/protectedplanet-api/current"

# Unicorn PID file location
pid "/home/ubuntu/protectedplanet-api/current/tmp/pids/unicorn.pid"

# Path to logs
stderr_path "/home/ubuntu/protectedplanet-api/current/log/unicorn.log"
stdout_path "/home/ubuntu/protectedplanet-api/current/log/unicorn.log"

# Unicorn socket
listen "/tmp/unicorn.protectedplanet-api.sock"

# Number of processes
worker_processes 2

# Time-out
timeout 30
