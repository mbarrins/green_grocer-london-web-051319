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
    coupon = coupons.find{|coupon| coupon[:item] == item}
    # binding.pry
    if coupon.nil?
      new_cart[item] = details
    else
      if details[:count] % coupon[:num] == 0
        new_cart["#{item} W/COUPON"] =
          {
            :price => coupon[:cost],
            :clearance => details[:clearance],
            :count => (details[:count] / coupon[:num])
          }
      elsif details[:count] > 0 && details[:count] % coupon[:num] > 0
        new_cart[item] =
          {
            :price => details[:price],
            :clearance => details[:clearance],
            :count => details[:count] % coupon[:num]
          }
        new_cart["#{item} W/COUPON"] =
          {
            :price => coupon[:cost],
            :clearance => details[:clearance],
            :count => (details[:count] - (details[:count] % coupon[:num]))/coupon[:num]
          }
      end
    end
  end
  new_cart
end

# puts apply_coupons(consolidate_cart(cart), coupons).inspect

def apply_clearance(cart)
  new_cart = {}
  cart.each do |item, details|
    if details[:clearance]
      new_cart[item] = {:price => (details[:price] * 0.80).round(2), :clearance => details[:clearance], :count => details[:count]}
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
  binding.pry
  total = new_cart.reduce(0){|sum, (item, details)| sum + (details[:count] * details[:price])}
  total > 100 ? (total * 0.9).round(2) : total
end

# puts checkout(cart, coupons)
