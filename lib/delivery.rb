# frozen_string_literal: true

class Delivery
  def initialize(delivery_rules)
    @delivery_rules = delivery_rules
  end

  def cost(sub_total)
    return 0 if sub_total.to_f == 0.0
    applicable_rule = @delivery_rules.select { |rule| sub_total < rule.max_amount }.min_by(&:max_amount)
    applicable_rule ? applicable_rule.delivery_price : 0
  end
end
