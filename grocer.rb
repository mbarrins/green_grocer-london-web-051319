require "pry"

cart = [
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"KALE"    => {:price => 3.0, :clearance => false}}
]

coupons = [{:item => "AVOCADO", :num => 2, :cost => 5.0}]

def consolidate_cart(cart)
  cart.uniq.map{|items| items.map{|item, detail| [item, detail.merge({:count => cart.count(items)})]}.to_h}.inject(:merge).to_h
end

# puts consolidate_cart(cart).inspect

def apply_coupons(cart, coupons)
  # binding.pry
  new_cart = {}
  cart.each do |item, details|
    binding.pry
    coupon = coupons.find{|coupon| coupon[:item] == item}

    # binding.pry
    if coupon.nil?
      new_cart[item] = details
    else
      if item[:count] % coupon[:num] == 0
        new_cart << {"#{item} W/COUPON" =>
          {
            :price => coupon[:cost],
            :clearance => item[:clearance],
            :count => (item[:count] / coupon[:num])}
          }
      elsif item[:count] > 0 && item[:count] % coupon[:num] > 0
        new_cart << {"#{item}" =>
          {
            :price => item[:price],
            :clearance => item[:clearance],
            :count => item[:count] % coupon[:num]}
          }
        new_cart << {"#{item} W/COUPON" =>
          {
            :price => coupon[:cost],
            :clearance => item[:clearance],
            :count => (item[:count] - (item[:count] % coupon[:num]))/coupon[:num]}
          }
      end
    end
  end
  new_cart
end

puts apply_coupons(consolidate_cart(cart), coupons).inspect

def apply_clearance(cart)
  new_cart = {}
  cart.each do |item, details|
    # item_name = item
    # item_price = item[:price]
    # item_count = item[:count]
    # item_clearance = item[:clearance]
    if item[:clearance]
      new_cart[item] = {:price => (item[:price] * 0.80).round(2), :clearance => item[:clearance], :count => item[:count]}
    else
      new_cart[item] = details
    end
  end
  new_cart
end

puts apply_clearance(consolidate_cart(cart)).inspect

def checkout(cart, coupons)
  new_cart = consolidate_cart(cart)
  new_cart = apply_coupons(new_cart, coupons)
  new_cart = apply_clearance(new_cart)
  # new_cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  # binding.pry
  total = new_cart.reduce(0){|sum, item| sum + item.values.first[:price]}
  total > 100 ? (total * 0.9).round(2) : total
end

# puts checkout(cart, coupons)
