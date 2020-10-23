class CreateReservations < ActiveRecord::Migration[6.0]
    def change
        create_table :reservations do |t|
            t.string :name_of_customer
            t.string :name_of_business
            t.string :time
            t.string :date
            t.integer :customer_id
            t.integer :restaurant_id 
        end
    end
end