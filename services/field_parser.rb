# frozen_string_literal: true

class FieldParser
  def self.parse(currencies:, fields:)
    currencies.map do |currency|
      fields.each_with_object({}) do |field, hsh|
        hsh[field] = currency[field] if currency.key?(field)
      end
    end
  end
end
