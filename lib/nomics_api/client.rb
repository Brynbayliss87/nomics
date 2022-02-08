# frozen_string_literal: true

module NomicsApi
  class Client
    BASE_URL = 'https://api.nomics.com/v1'

    def self.get_currencies(tickers:, convert:)
      resp = send_request(
        method: :get,
        url: "#{BASE_URL}/currencies/ticker",
        body: {
          ids: tickers.join(','),
          convert: convert
        }
      )
      JSON.parse(resp.body)
    end

    def self.client
      @client ||= Faraday.new do |client|
        client.request :url_encoded
        client.adapter Faraday.default_adapter
        client.request :authorization, 'Bearer', ENV['API_TOKEN']
      end
    end

    def self.send_request(method:, url:, body: nil)
      client.send(method, url, body)
    end

    private_class_method :send_request, :client
  end
end
