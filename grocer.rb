def consolidate_cart(cart)
  cart.uniq.map{|items| items.map{|item, detail| [item, detail.merge({:count => cart.count(items)})]}.to_h}.inject(:merge).to_h
end

def apply_coupons(cart, coupons)
  new_cart = {}
  cart.each do |item, details|
    coupon = coupons.find{|coupon| coupon[:item] == item}

    if coupon.nil?
      new_cart[item] = details
    else
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
  new_cart
end

def apply_clearance(cart)
  cart.each do |item, details|
    details[:price] = (details[:price] * 0.80).round(2) if details[:clearance]
  end
end

def checkout(cart, coupons)
  new_cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  total = new_cart.reduce(0){|sum, (item, details)| sum + (details[:count] * details[:price])}
  total > 100 ? (total * 0.9).round(2) : total
end
