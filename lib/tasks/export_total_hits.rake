require 'uri'
require 'net/http'

namespace :export do
  desc "Get API total hits"
  task :total_hits, [:app_id, :appsignal_token, :from, :to] => :environment do |t, args|
    BASE_URL = "https://appsignal.com/api"
    PARAMS = {
      token: args[:appsignal_token],
      from: args[:from],
      to: args[:to],
      kind: 'custom'
    }

    URL = "#{BASE_URL}/#{args[:app_id]}/graphs/custom.json?"

    begin
      uri = URI(URL)
      uri.query = URI.encode_www_form(PARAMS)
      puts("The following url has been produced:\n#{uri}")
      res = Net::HTTP.get_response(uri)
      json = JSON.parse(res.body)
      total_hits = 0
      json["data"].each do |data|
        next unless data["data"]["c"]
        total_hits += data["data"]["c"]["total_hits"].to_i
      end
      puts total_hits
    rescue => e
      puts e.message
    end

  end
end
