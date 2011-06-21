class MerchantsController < ApplicationController
  
  def index
  end

  def populate
    # @client = GooglePlaces::Client.new('AIzaSyAiRSj2K2KygVMVuqq60fceLRLaPMCJdY0')
    # @places = @client.spots(29.7628844,-95.3830615)
    # @places = @client.spots(29.739227, -95.467438, :types => ['lodging'])
    # @places = @client.spots(-33.8670522, 151.1957362, :types => 'restaurant')
    # @places = @client.spots(-33.867290, 151.2016020, :sensor => 'true')
    # @places = @client.spots(29.739227, -95.467438)
    # @places = Merchant.find_spots(29.739227, -95.467438)
    # atlanta first data @places = Merchant.find_spots(33.9027799,-84.3562896,['dentist','health','establishment','plumber'])
    # first data westheimer lat=29.739227&lng=-95.467438
    # lat = params[:lat] || 35.194011
    # lng = params[:lng] || -89.798199
    puts "populate+++++++++++++++++++++++++++++++++++++++++++"
    puts params[:lat]
    puts params[:lng]
    puts "+++++++++++++++++++++++++++++++++++++++++++"
    lat = params[:lat]
    lng = params[:lng]
    @places = Merchant.find_spots(lat, lng, '')
    # puts @places.to_yaml

    render :layout => false
  end

  def import
    @merchant = Merchant.new
    @place = Merchant.find_spot(params[:reference])

    @merchant.name = @place['name']
    @streetAddress = @place['formatted_address'].split(',')

      # puts "%%%%%%%%%%%%%%%%%%%%%%%%"
      # puts address_components
      # puts types
      # puts formatted_address
      # puts "@@"
      # puts "street_number= #{street_number}"
      # puts "streett= #{streett}"  
      # puts "@@"
      # puts city
      # puts state
      # puts state_code
      # puts country
      # puts country_code
      # puts postal_code
      # puts "%%%%%%%%%%%%%%%%%%%%%%%%"

     @merchant.street = "#{street_number} #{street}"  
     @merchant.city = city
     @merchant.state = state.upcase
     @merchant.zipcode = postal_code

    # if @streetAddress.size == 4 then
    #   @merchant.street = @streetAddress.first.strip.titleize
    #   @merchant.city = @streetAddress.second.strip.titleize
    #   @merchant.state = @streetAddress.third.split(' ').first.strip.upcase
    #   @merchant.zipcode = @streetAddress.third.split(' ').second.strip.titleize
    # else
    #   @merchant.street = @streetAddress.first.strip.titleize + ' ' + @streetAddress.second.strip.titleize
    #   @merchant.city = @streetAddress.third.strip.titleize
    #   @merchant.state = @streetAddress.fourth.split(' ').first.strip.upcase
    #   @merchant.zipcode = @streetAddress.fourth.split(' ').second.strip.titleize
    # end
      @merchant.phone_number = @place['formatted_phone_number']
      @merchant.merchant_type = @place['types'][0].titleize
      
      @merchant.country = 'US'
      @merchant.merchant_device_type = 'POS'
      @merchant.status = 'PENDING'
     
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @merchant }
    end
  end

  def address_components
    # puts "+++++++++++++++++++++++++++++++"
    # puts @place['address_components']
    # puts "+++++++++++++++++++++++++++++++"
    @place['address_components']
  end
  
  def street_number
    puts "st number is null= #{address_components_of_type(:street_number).first.nil?}"
    puts "st number is blank= #{address_components_of_type(:street_number).first.blank?}"
    if street_number = address_components_of_type(:street_number).first
      street_number['long_name']
    end
  end
  
  def street
    puts "street is null = #{address_components_of_type(:route).first.nil?}"
    puts "street is blank = #{address_components_of_type(:route).first.blank?}"
    if street = address_components_of_type(:route).first
      street['long_name']
    end
  end
  
   
  def city
    fields = [:locality, :sublocality,
      :administrative_area_level_3,
      :administrative_area_level_2]
    fields.each do |f|
      if entity = address_components_of_type(f).first
        return entity['long_name']
      end
    end
    return nil # no appropriate components found
  end
  
  def state
    if state = address_components_of_type(:administrative_area_level_1).first
      state['long_name']
    end
  end
  
  def state_code
    if state = address_components_of_type(:administrative_area_level_1).first
      state['short_name']
    end
  end
  
  def country
    if country = address_components_of_type(:country).first
      country['long_name']
    end
  end
  
  def country_code
    if country = address_components_of_type(:country).first
      country['short_name']
    end
  end
  
  def postal_code
    if postal = address_components_of_type(:postal_code).first
      postal['long_name']
    end
  end
  
  def types
    puts "types = #{@place['types']}"
    @place['types']
  end
   
  def formatted_address
    @place['formatted_address']
  end
  #
  # Get address components of a given type. Valid types are defined in
  # Google's Geocoding API documentation and include (among others):
  #
  #   :street_number
  #   :locality
  #   :neighborhood
  #   :route
  #   :postal_code
  #
  def address_components_of_type(type)
    address_components.select{ |c| c['types'].include?(type.to_s) }
  end   

  def list
    @merchants = Merchant.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @merchants }
    end
  end


  def show
    @place = Merchant.find_spot(params[:reference])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @merchant }
    end
  end
  
  def detail
    @merchant = Merchant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @merchant }
    end
  end


  def new
    @merchant = Merchant.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @merchant }
    end
  end


  def edit
    @merchant = Merchant.find(params[:id])
  end


  def create
    @merchant = Merchant.new(params[:merchant])

    @merchant.country = 'US'
    @merchant.merchant_device_type = 'POS'
    @merchant.status = 'PENDING'
    
    respond_to do |format|
      if @merchant.save
        format.html { render :action => "detail", :notice => 'Merchant was successfully created.' }
        format.xml  { render :xml => @merchant, :status => :created, :location => @merchant }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @merchant.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @merchant = Merchant.find(params[:id])

    respond_to do |format|
      if @merchant.update_attributes(params[:merchant])
        format.html { render :action => "detail", :notice => 'Merchant was successfully updated.' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @merchant.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @merchant = Merchant.find(params[:id])
    @merchant.destroy

    respond_to do |format|
      format.html { redirect_to(merchants_url) }
      format.xml  { head :ok }
    end
  end
end
