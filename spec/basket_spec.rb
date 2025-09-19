# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Basket do
  set_up_products

  let(:delivery_rules) do
    [
      DeliveryRule.new(max_amount: 50, delivery_price: 4.95),
      DeliveryRule.new(max_amount: 90, delivery_price: 2.95),
      DeliveryRule.new(max_amount: Float::INFINITY, delivery_price: 0)
    ]
  end

  let(:delivery) do
    Delivery.new(delivery_rules)
  end

  let(:product_catalogue) do
    product_catalogue = ProductCatalogue.new
    products.each { |product| product_catalogue.add_product(product) }
    product_catalogue
  end

  let(:offers) do
    [
      Offer.new(name: 'buy one red widget, get the second half price', offer_type: :BOG2H,
                product_codes: ['R01'])
    ]
  end

  let(:basket) do
    described_class.new(delivery: delivery, offers: offers, catalogue: product_catalogue)
  end

  describe 'cart_actions' do
    it 'Adds and Item to the basket' do
      basket.add_item(product_code: 'B01')
      expect(basket.items.length).to eq(1)

      expect(basket.items.keys).to include('B01')
      expect(basket.items['B01'][:quantity]).to eq(1)
      basket.add_item(product_code: 'B01', quantity: 4)
      expect(basket.items['B01'][:quantity]).to eq(5)
    end

    it 'Empties Item from the basket' do
      basket.add_item(product_code: 'B01')
      expect(basket.items.length).to eq(1)
      basket.remove_item(product_code: 'B01')
      expect(basket.items.empty?).to be_truthy
    end
    it 'Reduces the quantity of Item In the basket' do
      basket.add_item(product_code: 'B01', quantity: 5)
      expect(basket.items.length).to eq(1)
      expect(basket.items['B01'][:quantity]).to eq(5)
      basket.remove_item(product_code: 'B01', quantity: 2)
      expect(basket.items['B01'][:quantity]).to eq(3)
    end
  end

  describe 'Basket Total' do
    it 'Computes the right total given B01 and G01' do
      basket.add_item(product_code: 'B01')
      basket.add_item(product_code: 'G01')
      expect(basket.total).to eq(37.85)
    end

    it 'Computes the right total given R01 and R01' do
      basket.add_item(product_code: 'R01')
      basket.add_item(product_code: 'R01')
      expect(basket.total).to eq(54.37)
    end

    it 'Computes the right total given R01 and G01' do
      basket.add_item(product_code: 'R01')
      basket.add_item(product_code: 'G01')
      expect(basket.total).to eq(60.85)
    end

    it 'Computes the right total given B01, B01, R01, R01, R01 ' do
      basket.add_item(product_code: 'B01')
      basket.add_item(product_code: 'B01')
      basket.add_item(product_code: 'R01')
      basket.add_item(product_code: 'R01')
      basket.add_item(product_code: 'R01')
      expect(basket.total).to eq(98.27)
    end
  end
end
