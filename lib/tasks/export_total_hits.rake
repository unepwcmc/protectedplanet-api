require 'uri'
require 'net/http'
require 'json'

namespace :export do
  desc 'Get API total hits'
  task :total_hits, %i[app_id appsignal_token from to] => :environment do |t, args|
    base_url = 'https://appsignal.com/api'
    params = {
      token: args[:appsignal_token],
      from: args[:from],
      to: args[:to],
      kind: 'custom'
    }

    url = "#{base_url}/#{args[:app_id]}/graphs/custom.json?"

    begin
      uri = URI(url)
      uri.query = URI.encode_www_form(params)
      puts("The following url has been produced:\n#{uri}")
      res = Net::HTTP.get_response(uri)
      json = JSON.parse(res.body)
      total_hits = 0
      json['data'].each do |data|
        next unless data['data']['c']

        total_hits += data['data']['c']['total_hits'].to_i
      end
      puts total_hits
    rescue StandardError => e
      puts e.message
    end
  end
end
