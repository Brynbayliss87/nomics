# frozen_string_literal: true

require 'bundler'
Bundler.require
require 'sinatra/base'
require 'dotenv'
Dotenv.load

Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].sort.each { |file| require file }
Dir["#{File.dirname(__FILE__)}/services/**/*.rb"].sort.each { |file| require file }

class Nomics < Sinatra::Base
  before do
    content_type :json
  end

  get '/currencies' do
    validate_currency_params

    currencies = NomicsApi::Client.get_currencies(
      tickers: params['tickers'].split(','),
      convert: params['convert']
    )
    currencies = FieldParser.parse(currencies: currencies, fields: params['fields'].split(',')) if params['fields']
    { currencies: currencies }.to_json
  end

  get '/comparative_dollar_prices' do
    halt(400, { error: 'you must supply 2 tickers to compare' }) unless params['from'] && params['to']

    currencies = NomicsApi::Client.get_currencies(
      tickers: [params['from'], params['to']],
      convert: 'USD'
    )
    resp = {}
    currencies.each do |curr|
      if curr['id'] == params['from']
        resp['from'] = curr['price']
      else
        resp['to'] = curr['price']
      end
    end
    { from: params['from'], to: params['to'], price: resp['from'].to_f / resp['to'].to_f }.to_json
  end

  private

  def validate_currency_params
    if !params['tickers'] || params['tickers'].split(',').empty?
      halt 400,
           { error: 'Error, you must supply an array of tickers' }.to_json
    end

    if params['convert'] && !Money::Currency.find(params['convert'])
      halt 422, { error: 'Error, invalid fiat currency code' }.to_json
    end
  end
end
