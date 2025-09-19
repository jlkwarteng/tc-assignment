# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ProductCatalogue do
  set_up_products

  let(:product_catalogue) do
    described_class.new
  end

  describe '#add_product' do
    it 'adds a product to the product Catalogue' do
      products.each { |product| product_catalogue.add_product(product) }
      expect(product_catalogue.products).to match_array(products)
    end
  end
  describe '#find_product_by_code' do
    it 'returns the product with the given code' do
      products.each { |product| product_catalogue.add_product(product) }
      expect(product_catalogue.find_product_by_code('R01')).to eq(products[0])
      expect(product_catalogue.find_product_by_code('G01')).to eq(products[1])
      expect(product_catalogue.find_product_by_code('B01')).to eq(products[2])
    end

    it 'returns nil if no product with the given code exists' do
      expect(product_catalogue.find_product_by_code('XX1')).to be_nil
    end
  end
end
