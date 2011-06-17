class MerchantsController < ApplicationController
  
  def index
  	# @client = GooglePlaces::Client.new('AIzaSyAiRSj2K2KygVMVuqq60fceLRLaPMCJdY0')
  	# @places = @client.spots(29.7628844,-95.3830615)
  	# @places = @client.spots(29.739227, -95.467438, :types => ['lodging'])
  	# @places = @client.spots(-33.8670522, 151.1957362, :types => 'restaurant')
  	# @places = @client.spots(-33.867290, 151.2016020, :sensor => 'true')
  	# @places = @client.spots(29.739227, -95.467438)
  	# @places = Merchant.find_spots(29.739227, -95.467438)
  	# atlanta first data @places = Merchant.find_spots(33.9027799,-84.3562896,['dentist','health','establishment','plumber'])
  	# first data westheimer lat=29.739227&lng=-95.467438
  	# first data memphis lat=35.194011&lng=-89.798199
  	lat = params[:lat] || 33.9027799
  	lng = params[:lng] || -84.3562896
  	@places = Merchant.find_spots(lat, lng,['dentist','health','establishment','plumber'])
  	# puts @places.to_yaml

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @merchants }
      end
    end

    def import
      @merchant = Merchant.new
      @place = Merchant.find_spot(params[:reference])

        @merchant.name = @place['name'].titleize
        @streetAddress = @place['formatted_address'].split(',')

      if @streetAddress.size == 4 then
        @merchant.street = @streetAddress.first.strip.titleize
        @merchant.city = @streetAddress.second.strip.titleize
        @merchant.state = @streetAddress.third.split(' ').first.strip.upcase
        @merchant.zipcode = @streetAddress.third.split(' ').second.strip.titleize
      else
        @merchant.street = @streetAddress.first.strip.titleize + ' ' + @streetAddress.second.strip.titleize
        @merchant.city = @streetAddress.third.strip.titleize
        @merchant.state = @streetAddress.fourth.split(' ').first.strip.upcase
        @merchant.zipcode = @streetAddress.fourth.split(' ').second.strip.titleize
      end
        @merchant.phone_number = @place['formatted_phone_number']
        @merchant.merchant_type = @place['types'][0].titleize
        
        @merchant.country = 'US'
        @merchant.merchant_device_type = 'POS'
        @merchant.status = 'PENDING'

        
      respond_to do |format|
        format.html # new.html.erb
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
