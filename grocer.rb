require "pry"

cart = [
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"KALE"    => {:price => 3.0, :clearance => false}}
]

coupons = [{:item => "AVOCADO", :num => 2, :cost => 5.0}]

def consolidate_cart(cart)
  cart.uniq.map{|items| items.map{|item, detail| [item, detail.merge({:count => cart.count(items)})]}.to_h}
end

puts consolidate_cart(cart).inspect

def apply_coupons(cart, coupons)
  # binding.pry
  new_cart = []
  cart.each do |item|
    item_price = item.values.first[:price]
    item_count = item.values.first[:count]
    item_clearance = item.values.first[:clearance]

    coupon = coupons.find{|coupon| coupon[:item] == item.keys.first}

    # binding.pry
    if coupon.nil?
      new_cart << item
    else
      coupon_item = coupon[:item]
      coupon_num = coupon[:num]
      coupon_cost = coupon[:cost]
      if item_count % coupon_num == 0
        new_cart << {"#{coupon_item} W/COUPON" => {:price => coupon_cost, :clearance => item_clearance, :count => (item_count / coupon_num)}}
      elsif item_count > 0 && item_count % coupon_num > 0
        new_cart << {"#{coupon_item}" => {:price => item_price, :clearance => item_clearance, :count => item_count % coupon_num}}
        new_cart << {"#{coupon_item} W/COUPON" => {:price => coupon_cost, :clearance => item_clearance, :count => (item_count - (item_count % coupon_num))/coupon_num}}
      end
    end
  end
  new_cart
end

puts apply_coupons(consolidate_cart(cart), coupons).inspect

def apply_clearance(cart)
  new_cart = []
  cart.each do |item|
    item_name = item.keys.first
    item_price = item.values.first[:price]
    item_count = item.values.first[:count]
    item_clearance = item.values.first[:clearance]
    if item.values.first[:clearance]
      new_cart << {"#{item_name}" => {:price => (item_price * 0.80).round(2), :clearance => item_clearance, :count => item_count}}
    else
      new_cart << item
    end
  end
  new_cart
end

puts apply_clearance(consolidate_cart(cart)).inspect

def checkout(cart, coupons)
  new_cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  # binding.pry
  total = new_cart.reduce(0){|sum, item| sum + item.values.first[:price]}
  total > 100 ? (total * 0.9).round(2) : total
end

puts checkout(cart, coupons)
