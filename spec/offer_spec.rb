# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Offer do
  set_up_products

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
  let(:bO2Hoffers) do
    [
      described_class.new(name: 'buy one red widget, get the second half price', offer_type: :BOG2H,
                          product_codes: ['R01'])
    ]
  end

  let(:bOGOoffers) do
    [
      described_class.new(name: 'buy one red widget, get the second Free', offer_type: :BOGO,
                          product_codes: ['R01'])
    ]
  end

  describe 'Discount Amounts For BO2H' do
    it 'Computes correct discounts for Buy one get second at half ' do
      first_offer = bO2Hoffers.first
      expect(first_offer.discount_amount({
                                           "R01": {
                                             quantity: 4,
                                             price: 32.95
                                           }
                                         })).to eq(32.95)
    end
    it "Returns 0.0 if the product doesn't have an offer" do
      first_offer = bO2Hoffers.first
      expect(first_offer.discount_amount({
                                           "B01": {
                                             quantity: 4,
                                             price: 32.95
                                           }
                                         })).to eq(0.0)
    end

    it "Returns the correct discount if multiple items are sent if the product doesn't have an offer" do
      first_offer = bO2Hoffers.first
      expect(first_offer.discount_amount({
                                           "R01": {
                                             quantity: 4,
                                             price: 32.95
                                           },
                                           "B01": {
                                             quantity: 4,
                                             price: 32.95
                                           }
                                         })).to eq(32.95)
    end
  end

  describe 'Discount Amounts For BOGO' do
    it 'Computes correct discounts for Buy one get one free' do
      first_offer = bOGOoffers.first
      expect(first_offer.discount_amount({
                                           "R01": {
                                             quantity: 4,
                                             price: 32.95
                                           }
                                         })).to eq(65.9)
    end
    it "Returns 0.0 if the product doesn't have an offer" do
      first_offer = bOGOoffers.first
      expect(first_offer.discount_amount({
                                           "B01": {
                                             quantity: 4,
                                             price: 32.95
                                           }
                                         })).to eq(0.0)
    end

    it "Returns the correct discount if multiple items are sent if the product doesn't have an offer" do
      first_offer = bOGOoffers.first
      expect(first_offer.discount_amount({
                                           "R01": {
                                             quantity: 4,
                                             price: 32.95
                                           },
                                           "B01": {
                                             quantity: 4,
                                             price: 32.95
                                           }
                                         })).to eq(65.90)
    end
  end
end
