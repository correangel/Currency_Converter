class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :state
      t.string :city
      t.string :zipcode
      t.string :street
      t.string :neighborhood
      t.integer :number
      t.references :customer, foreign_key: true
      t.references  "company", foreign_key: true


      t.timestamps null: false
    end
  end
end
