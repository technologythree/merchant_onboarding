class CreateMerchants < ActiveRecord::Migration
  def self.up
    create_table :merchants do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :country
      t.string :phone_number
      t.string :fax
      t.string :email
      t.string :tax_id
      t.string :contact_name
      t.string :merchant_type
      t.string :merchant_device_type
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :merchants
  end
end
