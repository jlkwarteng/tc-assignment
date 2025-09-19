# frozen_string_literal: true

class ProductCatalogue
  attr_accessor :products

  def initialize
    @products = []
  end

  def add_product(product)
    @products << product
  end

  def find_product_by_code(code)
    @products.find { |product| product.code.to_s == code.to_s }
  end
end
