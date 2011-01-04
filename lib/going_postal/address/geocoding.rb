require 'going_postal/address/google_api'


module GoingPostal
  class Address
    module Geocoding
      
      
      
      attr_reader :latitude, :longitude
      
      
      
      # Lazy geocoding
      def geocode
        geocode! if latitude.nil? or longitude.nil?
      end
      
      def geocode!
        Rails.logger.info "[going_postal] geocoding '#{self.to_s}'" if defined?(Rails)
        response = GoogleApi.find_address(self).first
        if response
          @latitude = response.latitude
          @longitude = response.longitude
        else
          @latitude = nil
          @longitude = nil
        end
      end
      
      
      
    end
  end
end
