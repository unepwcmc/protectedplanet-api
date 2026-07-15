module API
  module Serialisers
    module V4
      module Concerns
        # Shared helpers for any serialiser or concern in this API version.
        # Include where needed; expose methods with `module_function` when required.
        module SerialiserHelpers
          def add_field(payload, key, enabled)
            return unless enabled

            value = yield
            payload[key] = value
          end
        end
      end
    end
  end
end
