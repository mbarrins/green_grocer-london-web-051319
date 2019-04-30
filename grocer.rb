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
  binding.pry
  coupons.each do |coupon|
    item = cart.select{|item| item.keys.first == coupon[:item]}
  end
end

puts apply_coupons(consolidate_cart(cart), coupons)

def apply_clearance(cart)
  # code here
end

def checkout(cart, coupons)
  # code here
end
