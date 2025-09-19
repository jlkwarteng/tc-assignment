# frozen_string_literal: true
Dir[File.join(__dir__, '/lib/**/*.rb')].each { |file| require file }

# Set up products
products = [
  Product.new(name: 'Red Widget', price: 32.95, code: 'R01'),
  Product.new(name: 'Green Widget', price: 24.95, code: 'G01'),
  Product.new(name: 'Blue Widget', price: 7.95, code: 'B01')
]

product_catalogue = ProductCatalogue.new
products.each { |product| product_catalogue.add_product(product) }

# Set up delivery rules
delivery_rules = [
  DeliveryRule.new(max_amount: 50, delivery_price: 4.95),
  DeliveryRule.new(max_amount: 90, delivery_price: 2.95),
  DeliveryRule.new(max_amount: Float::INFINITY, delivery_price: 0)
]
delivery = Delivery.new(delivery_rules)

# Set up offers
offers = [
  Offer.new(name: 'buy one red widget, get the second half price', offer_type: :BOG2H, product_codes: ['R01'])
]

basket = Basket.new(catalogue: product_catalogue, delivery: delivery, offers: offers)

def print_menu
  puts "\nThriveCart CLI"
  puts "1. List products"
  puts "2. Add item to basket"
  puts "3. Remove item from basket"
  puts "4. View basket"
  puts "5. Checkout"
  puts "6. Exit"
  print "Choose an option: "
end

loop do
  print_menu
  choice = gets.chomp

  case choice
  when '1'
    puts "\nAvailable Products:"
    product_catalogue.products.each do |product|
      puts "#{product.code}: #{product.name} - $#{product.price}"
    end
  when '2'
    print "Enter product code: "
    code = gets.chomp
    print "Enter quantity: "
    qty = gets.chomp.to_i
    basket.add_item(product_code: code, quantity: qty)
    puts "Added #{qty} of #{code} to basket."
  when '3'
    print "Enter product code to remove: "
    code = gets.chomp
    print "Enter quantity to remove: "
    qty = gets.chomp.to_i
    basket.remove_item(product_code: code, quantity: qty)
    puts "Removed #{qty} of #{code} from basket."
  when '4'
    puts "\nBasket Contents:"
    basket.items.each do |code, item|
      product = product_catalogue.find_product_by_code(code)
      puts "#{product.name} (#{code}): $#{item[:price]} x #{item[:quantity]}"
    end
    puts "Subtotal: $#{basket.items.values.reduce(0) { |sum, item| sum + item[:price] * item[:quantity] }}"
    puts "Total (with offers & delivery): $#{basket.total}"
  when '5'
    puts "\nChecking out..."
    puts "Total to pay: $#{basket.total}"
    break
  when '6'
    puts "Goodbye!"
    break
  else
    puts "Invalid option. Please try again."
  end
end
