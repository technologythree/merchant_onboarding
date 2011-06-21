class MerchantsController < ApplicationController
  before_filter :find_merchant, :only => [:detail, :edit, :update, :destroy]
    
  def index
  end

  def populate
    lat = params[:lat]
    lng = params[:lng]
    @places = Merchant.find_spots(lat, lng, '')

    render :layout => false
  end

  def import
    @merchant = Merchant.new
    @place = Merchant.find_spot(params[:reference])

    @merchant.name = merchant_name

    @merchant.street = street_address
    @merchant.city = city
    @merchant.state = state
    @merchant.zipcode = postal_code
    @merchant.country = country
    
    @merchant.phone_number = formatted_phone_number
    @merchant.merchant_type = merchant_type

    @merchant.merchant_device_type = merchant_device_type
    @merchant.status = merchant_status
     
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @merchant }
    end
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
  end


  def create
    @merchant = Merchant.new(params[:merchant])

    @merchant.merchant_device_type = merchant_device_type
    @merchant.status = merchant_status
    
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
    @merchant.destroy

    respond_to do |format|
      format.html { redirect_to(merchants_url) }
      format.xml  { head :ok }
    end
  end
  
  
  
private

  def find_merchant
    @merchant = Merchant.find(params[:id])
  end

  def merchant_name
    @place['name']
  end

  def address_components
    @place['address_components']
  end

  def street_address
    "#{street_number} #{street}"
  end
   
  def street_number
    if street_number = address_components_of_type(:street_number).first
      street_number['long_name']
    end
  end
  
  def street
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
      state['long_name'].upcase
    end
  end
  
  def state_code
    if state = address_components_of_type(:administrative_area_level_1).first
      state['short_name'].upcase
    end
  end
  
  def country
    if country = address_components_of_type(:country).first
      country['long_name'].upcase
    end
  end
  
  def country_code
    if country = address_components_of_type(:country).first
      country['short_name'].upcase
    end
  end
  
  def postal_code
    if postal = address_components_of_type(:postal_code).first
      postal['long_name']
    end
  end
  
  def types
    @place['types']
  end
   
  def formatted_address
    @place['formatted_address']
  end
  
  def formatted_phone_number
    @place['formatted_phone_number']
  end
  
  def merchant_type
    @place['types'][0].titleize
  end

  def merchant_device_type
    'POS'
  end
  
  def merchant_status
    'PENDING'
  end

  def address_components_of_type(type)
    address_components.select{ |c| c['types'].include?(type.to_s) }
  end

end
