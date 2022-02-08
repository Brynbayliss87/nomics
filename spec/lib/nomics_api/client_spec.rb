# frozen_string_literal: true

describe NomicsApi::Client do
  describe '.get_currencies' do
    subject { described_class.get_currencies(tickers: tickers, convert: convert) }
    let(:tickers) { %w[BTC ETH] }
    let(:convert) { nil }

    it 'returns a list of the valid specified currencies',
       vcr: { cassette_name: 'nomics/client/get_currencies', match_requests_on: %i[method body path] } do
      expect(subject).to be_a(Array)
      expect(subject.map { |curr| curr['id'] }).to match_array(tickers)
    end

    context 'with an invalid ticker' do
      let(:tickers) { ['WIZZLE_WOZZLE'] }

      it 'returns an empty list',
         vcr: { cassette_name: 'nomics/client/get_currencies_invalid', match_requests_on: %i[method body path] } do
        expect(subject).to eq([])
      end
    end

    context 'when specifying a convert value' do
      let(:convert) { 'GDP' }

      it 'returns the price in the specified currency',
         vcr: { cassette_name: 'nomics/client/get_currencies_convert', match_requests_on: %i[method body path] } do
        expect(subject.first['price']).to eq('145074037.31392208')
      end

      context 'when specifying an incorrect convert' do
        let(:convert) { 'WIZZLE_WOZZLE' }

        it 'returns a price of zero',
           vcr: { cassette_name: 'nomics/client/get_currencies_convert_invalid',
                  match_requests_on: %i[method body path] } do
          expect(subject.first['price']).to eq('0.00000000')
        end
      end
    end
  end
end
