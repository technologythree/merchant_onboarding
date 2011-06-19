class Merchant < ActiveRecord::Base
  validates :name, :presence => true, :on => :create
  validates :name, :uniqueness => { :case_sensitive => false }
  validates :email,    
              :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i },
              :allow_nil => true,
              :allow_blank => true

  include ::HTTParty

  default_params :output => 'json'
  format :json

  def self.find_spot(reference)
     @spot = get(GOOGLE_CONFIG['spot_url'], :query => {:reference => reference, :key => GOOGLE_CONFIG['google_places_key'], :sensor => 'true'})
     @spot.parsed_response["result"]
  end

  def self.find_spots(lat, lng, typelist)
    location_query = [ lat, lng ].join(',')
    types = (typelist.is_a?(Array) ? typelist.join('|') : typelist)

     @spots = get(GOOGLE_CONFIG['spots_list_url'], :query => {:location => location_query, :radius => '500', :type => types, :key => GOOGLE_CONFIG['google_places_key'], :sensor => 'true'})
     @spots.parsed_response["results"]
  end

end
