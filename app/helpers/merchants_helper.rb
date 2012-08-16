module MerchantsHelper
  def full_address(location)
      [location.city, location.state, location.zipcode, location.country].reject{|n| n.blank? }.join(', ')
  end
end