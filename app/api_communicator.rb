# https://github.com/Yelp/yelp-fusion/tree/master/fusion/ruby
require "json"
require "http"
require "optparse"

class Yelp

    API_KEY = "p8Q-YmgL2IRfEfTGYmf66U1Q3SxBjfJv8VHgCHzDgjZEmvEePPFkQsX72jE4WQp9rH_-uwbr4QAygIaPoDuvmq4tCJcEGNBqp7Z3N7woZbRnqEpk0GZZ74VFfV2PX3Yx"

    # Constants, do not change these
    API_HOST = "https://api.yelp.com"
    SEARCH_PATH = "/v3/businesses/search"
    BUSINESS_PATH = "/v3/businesses/"  # trailing / because we append the business id to the path


    DEFAULT_BUSINESS_ID = "yelp-san-francisco"
    DEFAULT_TERM = "dinner"
    DEFAULT_LOCATION = "San Francisco, CA"
    SEARCH_LIMIT = 5

    def self.search(term, location)
        url = "#{API_HOST}#{SEARCH_PATH}"
        params = {
          term: term,
          location: location,
          limit: SEARCH_LIMIT
        }
      
        response = HTTP.auth("Bearer #{API_KEY}").get(url, params: params)
        response.parse
    end
end
