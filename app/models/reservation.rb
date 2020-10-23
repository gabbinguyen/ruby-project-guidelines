class Reservation < ActiveRecord::Base
    belongs_to :user
    belongs_to :restaurants
    belongs_to :bars
end
