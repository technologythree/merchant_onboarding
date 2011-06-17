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

  SPOTS_LIST_URL = 'https://maps.googleapis.com/maps/api/place/search/json'
  SPOT_URL = 'https://maps.googleapis.com/maps/api/place/details/json'


  def self.find_spot(reference)
     @spot = get(SPOT_URL, :query => {:reference => reference, :key => 'AIzaSyAiRSj2K2KygVMVuqq60fceLRLaPMCJdY0', :sensor => 'false'})
     @spot.parsed_response["result"]
  end

  def self.find_spots(lat, lng, typelist)
  location_query = [ lat, lng ].join(',')
  types = (typelist.is_a?(Array) ? typelist.join('|') : typelist)

   @spots = get(SPOTS_LIST_URL, :query => {:location => location_query, :radius => '500', :type => types, :key => 'AIzaSyAiRSj2K2KygVMVuqq60fceLRLaPMCJdY0', :sensor => 'false'})
   @spots.parsed_response["results"]
  end

end
