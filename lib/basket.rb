# frozen_string_literal: true

class Basket
  attr_accessor :items

  def initialize(catalogue:, delivery:, offers: [])
    @catalogue = catalogue
    @items = Hash.new({})
    @delivery = delivery
    @offers = offers
  end

  def add_item(product_code:, quantity: 1)
    product = @catalogue.find_product_by_code(product_code)

    return unless product

    if @items.key?(product_code)
      @items[product_code][:quantity] += quantity
      @items[product_code][:price] = product.price
    else
      @items[product_code] = { price: product.price, quantity: quantity }
    end
  end

  def remove_item(product_code:, quantity: 1)
    return unless @items.key?(product_code)

    if @items[product_code][:quantity] > quantity
      @items[product_code][:quantity] -= quantity
    else
      @items.delete(product_code)
    end
  end

  def total
    sub_total = @items.values.reduce(0) do |sum, item|
      sum + (item[:price] * item[:quantity])
    end
    total_discounts = @offers.reduce(0) { |_sum, offer| offer.discount_amount(@items) }
    delivery_cost = @delivery.cost(sub_total - total_discounts)
    (sub_total - total_discounts + delivery_cost).round(2)
  end
end
