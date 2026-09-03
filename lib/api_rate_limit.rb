# frozen_string_literal: true

# Single source of truth for the throttle figures enforced in config/rack_attack.rb
# and displayed in the public API docs (web/views/documentation), so the two can't drift.
module ApiRateLimit
  LIMIT = 15
  PERIOD = 3 # seconds
end
