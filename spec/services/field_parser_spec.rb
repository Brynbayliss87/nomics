# frozen_string_literal: true

describe FieldParser do
  subject { described_class.parse(currencies: json_response, fields: fields) }
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
  let(:fields) { %w[id price] }

  context 'with valid fields' do
    it 'returns a list of hashes with only the specified fields' do
      expect(subject.first.keys).to match_array(fields)
    end
  end

  context 'with an invalid field' do
    let(:fields) { %w[id wizzle_wozzle] }

    it 'returns a list of hashes with only the valid specified fields' do
      expect(subject.first.keys).to match_array(['id'])
    end
  end

  context 'with only invalid fields' do
    let(:fields) { ['wizzle_wozzle'] }

    it 'returns an empty array' do
      expect(subject.first).to match_array([])
    end
  end
end
