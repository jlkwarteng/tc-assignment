# frozen_string_literal: true

require_relative 'offer'
class Bog2hOffer < Offer
  def initialize(product_codes: [])
    @product_codes = product_codes
  end

  def discount_amount(items)
    included_items = items.keys.select { |p| @product_codes.include?(p.to_s) }

    discount = items.filter { |k, _v| included_items.include? k }.reduce(0) do |_sum, item|
      v = item[1]
      (v[:quantity] / 2) * (v[:price] / 2.0)
    end

    discount.round(2)
  end
end
