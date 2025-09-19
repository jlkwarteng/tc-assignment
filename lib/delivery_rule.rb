# frozen_string_literal: true

class DeliveryRule
  attr_accessor :max_amount, :delivery_price

  def initialize(max_amount:, delivery_price:)
    @max_amount = max_amount
    @delivery_price = delivery_price
  end

  def applicable?(order_amount)
    order_amount <= @max_amount
  end
end
