# frozen_string_literal: true

# require_relative "bo2h_offer"
# require_relative "bogo_offer"
class Offer
  OFFER_TYPES = {
    BOG2H: {
      name: 'Buy 1 get second half price',
      class_name: 'Bog2hOffer',
      file_name: 'bog2h_offer'
    },
    BOGO: {
      name: 'Buy 1 get one free',
      class_name: 'BogoOffer',
      file_name: 'bogo_offer'
    }
  }.freeze

  def initialize(name: nil, product_codes: [], offer_type: nil)
    @name = name
    @product_codes = product_codes
    @offer_type = offer_type
    offer_type_val = OFFER_TYPES[@offer_type]
    file_name = offer_type_val[:file_name]
    class_name = offer_type_val[:class_name]

    require_relative file_name unless Object.const_defined?(class_name)
    @offer_class = Object.const_get(class_name).new(product_codes:) if OFFER_TYPES.keys.include?(offer_type)
    raise 'Offer Not Found ' unless @offer_class
  end

  def discount_amount(items)
    @offer_class.discount_amount(items)
  end
end
