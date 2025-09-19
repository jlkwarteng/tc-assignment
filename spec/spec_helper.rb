# frozen_string_literal: true

require 'rspec'
Dir[File.join(__dir__, '../lib/**/*.rb')].each { |file| require file }

def set_up_products
  let(:products) do
    [
      Product.new(name: 'Red Widget', price: 32.95, code: 'R01'),
      Product.new(name: 'Green Widget', price: 24.95, code: 'G01'),
      Product.new(name: 'Blude Widget', price: 7.95, code: 'B01')

    ]
  end
end
