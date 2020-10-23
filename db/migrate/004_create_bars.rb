class CreateBars < ActiveRecord::Migration[6.0]
    def change 
        create_table :bars do |t|
            t.string :name 
            t.string :type_of_bar
            t.string :location
        end
    end
end