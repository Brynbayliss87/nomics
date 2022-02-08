# frozen_string_literal: true

describe Nomics do
  let(:app) { Nomics.new }

  context 'GET to /currencies' do
    context 'without ticker params' do
      let(:response) { get '/currencies' }

      it 'returns an error' do
        expect(response.status).to eq(400)
      end
    end

    context 'with ticker params' do
      let(:response) { get '/currencies', { tickers: 'BTC' } }

      let(:json_response) do
        JSON.parse(
          '[
            {
              "id": "BTC",
              "currency": "BTC",
              "symbol": "BTC",
              "name": "Bitcoin",
              "logo_url": "https://s3.us-east-2.amazonaws.com/nomics-api/static/images/currencies/btc.svg",
              "status": "active",
              "price": "43903.08628940",
              "price_date": "2022-02-07T00:00:00Z",
              "price_timestamp": "2022-02-07T20:55:00Z",
              "circulating_supply": "18951393",
              "max_supply": "21000000",
              "market_cap": "832024642183",
              "market_cap_dominance": "0.4006",
              "num_exchanges": "408",
              "num_pairs": "85051",
              "num_pairs_unmapped": "6783",
              "first_candle": "2011-08-18T00:00:00Z",
              "first_trade": "2011-08-18T00:00:00Z",
              "first_order_book": "2017-01-06T00:00:00Z",
              "rank": "1",
              "rank_delta": "0",
              "high": "67600.78609278",
              "high_timestamp": "2021-11-08T00:00:00Z",
              "1d": {
                "volume": "34790359932.47",
                "price_change": "2288.74557857",
                "price_change_pct": "0.0550",
                "volume_change": "17131940017.06",
                "volume_change_pct": "0.9702",
                "market_cap_change": "43406876750.22",
                "market_cap_change_pct": "0.0550"
              },
              "7d": {
                "volume": "193482254099.78",
                "price_change": "5381.61993696",
                "price_change_pct": "0.1397",
                "volume_change": "-15252895923.41",
                "volume_change_pct": "-0.0731",
                "market_cap_change": "102226563677.59",
                "market_cap_change_pct": "0.1401"
              },
              "30d": {
                "volume": "963443360998.96",
                "price_change": "2099.24244802",
                "price_change_pct": "0.0502",
                "volume_change": "-111794613723.23",
                "volume_change_pct": "-0.1040",
                "market_cap_change": "40945715493.50",
                "market_cap_change_pct": "0.0518"
              },
              "365d": {
                "volume": "21417875375067.93",
                "price_change": "4989.41178923",
                "price_change_pct": "0.1282",
                "volume_change": "8226752238625.04",
                "volume_change_pct": "0.6237",
                "market_cap_change": "107356684487.69",
                "market_cap_change_pct": "0.1481"
              },
              "ytd": {
                "volume": "1246421923411.12",
                "price_change": "-2396.08240880",
                "price_change_pct": "-0.0518",
                "volume_change": "-268157861631.77",
                "volume_change_pct": "-0.1771",
                "market_cap_change": "-43779368651.45",
                "market_cap_change_pct": "-0.0500"
              }
            }
          ]'
        )
      end

      before do
        allow(NomicsApi::Client).to receive(:get_currencies).with(tickers: ['BTC'], convert: nil)
                                                            .and_return(json_response)
      end

      it 'returns a list of the requested currencies' do
        expect(JSON.parse(response.body)['currencies'].first['id']).to eq('BTC')
      end

      context 'with a convert param' do
        let(:response) { get '/currencies', { tickers: 'BTC', convert: 'USD' } }

        context 'with a valid param' do
          before do
            expect(NomicsApi::Client).to receive(:get_currencies).with(tickers: ['BTC'], convert: 'USD')
                                                                 .and_return(json_response)
          end

          it 'returns a list of the requested currencies with the price in the specified currency' do
            expect(JSON.parse(response.body)['currencies'].first['price']).to eq('43903.08628940')
          end
        end

        context 'with an invalid convert param' do
          let(:response) { get '/currencies', { tickers: 'BTC', convert: 'WAZZLE' } }

          it 'returns an error' do
            expect(response.status).to eq(422)
          end
        end
      end

      context 'with field params' do
        let(:response) { get '/currencies', { tickers: 'BTC', fields: fields } }
        let(:fields) { 'name,price' }

        before do
          allow(FieldParser).to receive(:parse).with(currencies: json_response, fields: fields.split(','))
                                               .and_return([{ name: 'BTC', price: '43903.08628940' }])
        end

        it 'returns results with only the specified fields' do
          expect(JSON.parse(response.body)['currencies'].first.keys).to match_array(fields.split(','))
        end

        context 'with invalid fields' do
          let(:fields) { 'name,wizzle' }

          before do
            allow(FieldParser).to receive(:parse).with(currencies: json_response, fields: fields.split(','))
                                                 .and_return([{ name: 'BTC' }])
          end

          it 'returns the valid fields' do
            expect(JSON.parse(response.body)['currencies'].first.keys).to eq(['name'])
          end
        end

        context 'with only invalid fields' do
          let(:fields) { 'wizzle' }

          before do
            allow(FieldParser).to receive(:parse).with(currencies: json_response, fields: [fields])
                                                 .and_return([])
          end

          it 'returns an empty array' do
            expect(JSON.parse(response.body)['currencies']).to eq([])
          end
        end
      end
    end
  end

  context 'GET to /comparative_dollar_prices' do
    context 'without any params' do
      let(:response) { get '/comparative_dollar_prices' }

      it 'returns an error' do
        expect(response.status).to eq(400)
      end
    end

    context 'with missing params' do
      let(:response) { get '/comparative_dollar_prices', { from: 'ETH' } }

      it 'returns an error' do
        expect(response.status).to eq(400)
      end
    end

    context 'with valid params' do
      let(:json_response) do
        JSON.parse(
          '[
            {
              "id": "BTC",
              "currency": "BTC",
              "symbol": "BTC",
              "name": "Bitcoin",
              "logo_url": "https://s3.us-east-2.amazonaws.com/nomics-api/static/images/currencies/btc.svg",
              "status": "active",
              "price": "43903.08628940",
              "price_date": "2022-02-07T00:00:00Z",
              "price_timestamp": "2022-02-07T20:55:00Z",
              "circulating_supply": "18951393",
              "max_supply": "21000000",
              "market_cap": "832024642183",
              "market_cap_dominance": "0.4006",
              "num_exchanges": "408",
              "num_pairs": "85051",
              "num_pairs_unmapped": "6783",
              "first_candle": "2011-08-18T00:00:00Z",
              "first_trade": "2011-08-18T00:00:00Z",
              "first_order_book": "2017-01-06T00:00:00Z",
              "rank": "1",
              "rank_delta": "0",
              "high": "67600.78609278",
              "high_timestamp": "2021-11-08T00:00:00Z"
            },
            {
              "id": "ETH",
              "currency": "ETH",
              "symbol": "ETH",
              "name": "Ethereum",
              "logo_url": "https://s3.us-east-2.amazonaws.com/nomics-api/static/images/currencies/btc.svg",
              "status": "active",
              "price": "3145.27481413",
              "price_date": "2022-02-07T00:00:00Z",
              "price_timestamp": "2022-02-07T20:55:00Z",
              "circulating_supply": "18951393",
              "max_supply": "21000000",
              "market_cap": "832024642183",
              "market_cap_dominance": "0.4006",
              "num_exchanges": "408",
              "num_pairs": "85051",
              "num_pairs_unmapped": "6783",
              "first_candle": "2011-08-18T00:00:00Z",
              "first_trade": "2011-08-18T00:00:00Z",
              "first_order_book": "2017-01-06T00:00:00Z",
              "rank": "1",
              "rank_delta": "0",
              "high": "67600.78609278",
              "high_timestamp": "2021-11-08T00:00:00Z"
            }
          ]'
        )
      end

      let(:response) { get '/comparative_dollar_prices', { from: 'ETH', to: 'BTC' } }

      before do
        expect(NomicsApi::Client).to receive(:get_currencies).with(tickers: %w[ETH BTC], convert: 'USD')
                                                             .and_return(json_response)
      end

      it 'returns the value of the from in the to param' do
        expect(JSON.parse(response.body)['price']).to eq(0.07164131453987092)
      end
    end
  end
end
