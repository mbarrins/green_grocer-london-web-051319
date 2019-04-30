require "pry"

cart = [
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"KALE"    => {:price => 3.0, :clearance => false}}
]


def consolidate_cart(cart)
  binding.pry
  cart.map{|items| items.map{|item, detail| [item, detail.merge({:count => cart.count(items)})]}}.to_h
end

puts consolidate_cart(cart)

def apply_coupons(cart, coupons)
  # code here
end

def apply_clearance(cart)
  # code here
end

def checkout(cart, coupons)
  # code here
end
