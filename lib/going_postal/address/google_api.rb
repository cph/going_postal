require 'net/http'
require 'rack'


# ===============================================================================
# GoingPostal::Address::GoogleApi
# ===============================================================================
# 
#   This module relies on Google Maps API, version 3
#   http://code.google.com/apis/maps/documentation/geocoding/
#
#   It is important to note that Google enforces Usage Limits on this API
#   by IP address of the computer making the request. This means that
#   application logic that relies on server-side requests made to the API
#   will more quickly exceed the request limit than application logic that
#   moves API calls to the client.
# 
#  Google's Terms of Usage require that this API be used only in conjunction
#  with Google Maps or Google Earth.
#
# ===============================================================================

module GoingPostal
  class Address
    module GoogleApi
      
      
      
      class AddressNotFound < StandardError
      end
      
      
      
      class Result
        
        def initialize(json)
          @json = json
          @address_components = @json['address_components']
          @geometry = @json['geometry']
        end
        
        attr_reader :address_components, :geometry, :json
        
        def latitude
          geometry['location']['lat']
        end
        
        def longitude
          geometry['location']['lng']
        end
        
        def get_address_component(part, variation=:long)
          part = part.to_s
          component = address_components.find {|hash| hash['types'].include?(part)}
          component ? component["#{variation}_name"] : nil
        end
        
      end
      
      
      
      def self.find_address!(address)
        results = find_address(address)
        raise(AddressNotFound) if results.empty?
        results
      end
      
      def self.find_address(address)
        escaped_address = Rack::Utils.escape(address.to_s)
        json = make_request(escaped_address)
        (json['results'] || []).map {|json| Result.new(json)}
      end
      
      
      
    private
      
      
      
      def self.make_request(escaped_address)
        uri = URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=#{escaped_address}&sensor=false")
        response = Net::HTTP.get_response(uri)
        ActiveSupport::JSON.decode(response.body)
      end
      
      
      
    end
  end
end