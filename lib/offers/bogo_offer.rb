# frozen_string_literal: true

require_relative 'offer'

class BogoOffer < Offer
  def initialize(product_codes: [])
    @product_codes = product_codes
  end

  def discount_amount(items)
    included_items = items.keys.select { |p| @product_codes.include?(p.to_s) }

    discount = items.filter { |k, _v| included_items.include?(k) }.reduce(0) do |sum, (_k, v)|
      free_items = v[:quantity] / 2 # every second item is free
      sum + (free_items * v[:price])
    end

    discount.round(2)
  end
end
