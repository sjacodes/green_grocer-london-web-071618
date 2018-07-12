def consolidate_cart(cart)
  new_hash = {}
  i = 0
    cart.each do |item|
      item.each do |key, value|
        cart[i][key][:count] = 1
        i = i + 1
      end
    end
    cart.each do |item|
      item.each do |key, value|
        if new_hash.keys.include?(key) == false
          new_hash[key] = value
        elsif new_hash.keys.include?(key) == true
          new_hash[key][:count] = new_hash[key][:count] + 1
        end
      end
    end
    return new_hash
end
    
def apply_coupons(cart = {}, coupons)
  coupons.each do |coupon|
    if cart.keys.include?(coupon[:item]) == true && cart.keys.include?(coupon[:item] + " W/COUPON") == false && cart[coupon[:item]][:count] >= coupon[:num]
      cart[coupon[:item] + " W/COUPON"] = {:price => coupon[:cost], :clearance => cart[coupon[:item]][:clearance], :count => 1}
      cart[coupon[:item]][:count] = cart[coupon[:item]][:count] - coupon[:num]
    elsif cart.keys.include?(coupon[:item]) == true && cart.keys.include?(coupon[:item] + " W/COUPON") == true && cart[coupon[:item]][:count] >= coupon[:num]
      cart[coupon[:item] + " W/COUPON"][:count] += 1
      cart[coupon[:item]][:count] = cart[coupon[:item]][:count] - coupon[:num]
    end
  end
  return cart
end

def apply_clearance(cart = {})
  cart.each do |item, item_data|
    item_data.each do |key, value|
      if key == :clearance && value == true
        cart[item][:price] = (cart[item][:price] * 0.80).round(2)
      end
    end
  end
  return cart
end
      
def checkout(cart, coupons)
  cart_now_consolidated = consolidate_cart(cart)
  coupons_applied = apply_coupons(cart_now_consolidated, coupons)
  coupons_and_clearance_applied = apply_clearance(coupons_applied)
  total = 0
  coupons_and_clearance_applied.each do |item, item_data|
    total = total + item_data[:price] * item_data[:count]
  end
  if total > 100
    discounted_price = 0.9 * total
    return discounted_price
  else
    return total
  end
end

  
  
  
  
  
