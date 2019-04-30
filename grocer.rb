require "pry"

cart = [
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"KALE"    => {:price => 3.0, :clearance => false}}
]

coupons = [{:item => "AVOCADO", :num => 2, :cost => 5.0}]

def consolidate_cart(cart)
  cart.uniq.map{|items| items.map{|item, detail| [item, detail.merge({:count => cart.count(items)})]}.to_h}
end

puts consolidate_cart(cart)

def apply_coupons(cart, coupons)
  # binding.pry
  new_cart = []
  cart.each do |item|
    item_price = item.values.first[:price]
    item_count = item.values.first[:count]
    item_clearance = item.values.first[:clearance]

    coupon = coupons.find{|coupon| coupon[:item] == item.keys.first}
    coupon_item = coupon[:item]
    coupon_num = coupon[:num]
    coupon_cost = coupon[:cost]
    binding.pry
    if not coupon.nil?
      if item_count % coupon_num == 0
        new_cart << {"#{coupon_item} W/COUPON" => {:price => coupon_cost, :clearance => item_clearance, :count = item_count}
      elsif item_count > 0 && item_count % coupon_num > 0
        new_cart << {"#{coupon_item}" => {:price => item_price, :clearance => item_clearance, :count = item_count % coupon_num}
        new_cart << {"#{coupon_item} W/COUPON" => {:price => coupon_cost, :clearance => item_clearance, :count = item_count - (item_count % coupon_num)}
      end
    else
      new_cart << item
    end
  end
end

puts apply_coupons(consolidate_cart(cart), coupons)

def apply_clearance(cart)
  # code here
end

def checkout(cart, coupons)
  # code here
end
