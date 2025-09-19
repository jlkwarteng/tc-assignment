# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Delivery do
  let(:delivery_rules) do
    [
      DeliveryRule.new(max_amount: 50, delivery_price: 4.95),
      DeliveryRule.new(max_amount: 90, delivery_price: 2.95),
      DeliveryRule.new(max_amount: Float::INFINITY, delivery_price: 0)
    ]
  end

  let(:delivery_cost) do
    described_class.new(delivery_rules)
  end

  describe '#cost' do
    it 'returns the correct delivery cost based on the subtotal' do
      expect(delivery_cost.cost(30)).to eq(4.95)
      expect(delivery_cost.cost(49.99)).to eq(4.95)
      expect(delivery_cost.cost(50)).to eq(2.95)
      expect(delivery_cost.cost(70)).to eq(2.95)
      expect(delivery_cost.cost(90)).to eq(0)
      expect(delivery_cost.cost(120)).to eq(0)
    end

    it 'returns 0 if no delivery rules apply' do
      empty_delivery_cost = described_class.new([])
      expect(empty_delivery_cost.cost(30)).to eq(0)
    end
  end
end
