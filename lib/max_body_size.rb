# frozen_string_literal: true

# Puma has no request-size cap of its own; nginx used to reject oversized bodies
# (client_max_body_size) before they ever reached the app. kamal-proxy doesn't
# enforce one either, so this replaces it. No route in this app accepts file
# uploads — POST bodies are small forms (signup, admin user edit) — so this is
# set well below nginx's old 20M, which was a generic default, not tuned here.
#
# Checking Content-Length alone isn't enough: a chunked request carries no
# Content-Length, so it would skip that check while Puma still reads the whole
# body into memory. Wrapping rack.input enforces the cap against bytes actually
# read, regardless of how the client declares (or omits) the body size.
class MaxBodySize
  LIMIT = 1 * 1024 * 1024 # 1MB

  class LimitExceeded < StandardError
  end

  def initialize(app, limit: LIMIT)
    @app = app
    @limit = limit
  end

  def call(env)
    return too_large_response if env['CONTENT_LENGTH'].to_i > @limit

    env['rack.input'] = LimitedIO.new(env['rack.input'], @limit)
    @app.call(env)
  rescue LimitExceeded
    too_large_response
  end

  private

  def too_large_response
    [413, { 'Content-Type' => 'text/plain' }, ['Request entity too large']]
  end

  # Delegates everything to the underlying rack.input, raising once more than
  # `limit` bytes have been read from it.
  class LimitedIO
    def initialize(io, limit)
      @io = io
      @limit = limit
      @bytes_read = 0
    end

    def read(*)
      chunk = @io.read(*)
      return chunk if chunk.nil?

      @bytes_read += chunk.bytesize
      raise LimitExceeded if @bytes_read > @limit

      chunk
    end

    def each
      @io.each do |chunk|
        @bytes_read += chunk.bytesize
        raise LimitExceeded if @bytes_read > @limit

        yield chunk
      end
    end

    def method_missing(name, ...)
      @io.send(name, ...)
    end

    def respond_to_missing?(name, include_private = false)
      @io.respond_to?(name, include_private) || super
    end
  end
end
