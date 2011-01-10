require 'active_model'
require 'active_model/validations'
require 'active_support'
require 'active_support/core_ext'
require 'going_postal/address/geocoding'
require 'going_postal/address/verification'


module GoingPostal
  class Address
    include ActiveModel::Validations
    include Geocoding
    include Verification
    include ERB::Util
    
    
    
    ### VALIDATIONS
    validates :street, :presence => true
    validates :city, :presence => true
    validates :state, :presence => true
    validates :zip, :presence => true, :format => {:with => /\A\d{5}(-\d{4})?\Z/, :message => "is the wrong format (<em>xxxxx</em> or <em>xxxxx-xxxx</em>)."}
    
    
    
    def initialize(*args)
      self.errors # !nb: c.f. http://boblail.tumblr.com/post/2528265548/using-validates-associated-with-composed-of-and
      # @latlong = {:latitude => nil, :longitude => nil} # hack in similar vein to above: to get around freeze
      self.attributes = args.extract_options!
    end
    
    # !nb: c.f. http://boblail.tumblr.com/post/2528265548/using-validates-associated-with-composed-of-and
    def validation_context=(value); end
    
    
    
    attr_reader :street, :city, :state, :zip
    
    def attributes=(hash)
      hash = hash.symbolize_keys.reverse_merge(self.class.empty)
      @street, @city, @state, @zip = hash[:street], hash[:city], hash[:state], hash[:zip]
      @latitude, @longitude = hash[:latitude], hash[:longitude]
    end
    
    
    
    def ==(other)
      other.is_a?(Address) &&
      (self.street == other.street) &&
      (self.city == other.city) &&
      (self.state == other.state) &&
      (self.zip == other.zip)
    end
    
    
    
    def to_s
      street.blank? ? "" : "#{street}\n#{city}, #{state}  #{zip}"
    end
    
    
    
    def as_json(options={})
      {
        :street => street,
        :city => city,
        :state => state,
        :zip => zip
      }
    end
    
    
    
    def to_html
      h(self.to_s).gsub(/ /, "&nbsp;").gsub(/\n/, "<br />").html_safe
    end
    
    
    
    def self.empty
      {
        :street => "",
        :city => "",
        :state => "",
        :zip => ""
      }
    end
    
    def to_hash
      {
        :street => street,
        :city => city,
        :state => state,
        :zip => zip
      }
    end
    
    def to_yaml
      to_hash.to_yaml
    end
    
    
    
    def blank?
      (street.blank? and city.blank? and zip.blank?) # not "and state.blank?" because state can sometimes be set to a default
    end
    
    def exists?
      !blank?
    end
    
    
    
    STATES = [
      [ "Alabama", "AL" ],
      [ "Alaska", "AK" ],
      [ "Arizona", "AZ" ],
      [ "Arkansas", "AR" ],
      [ "Armed Forces Americas", "AA" ],
      [ "Armed Forces Europe", "AE" ],
      [ "Armed Forces Pacific", "AP" ],
      [ "California", "CA" ],
      [ "Colorado", "CO" ],
      [ "Connecticut", "CT" ],
      [ "Delaware", "DE" ],
      [ "Florida", "FL" ],
      [ "Georgia", "GA" ],
      [ "Hawaii", "HI" ],
      [ "Idaho", "ID" ],
      [ "Illinois", "IL" ],
      [ "Indiana", "IN" ],
      [ "Iowa", "IA" ],
      [ "Kansas", "KS" ],
      [ "Kentucky", "KY" ],
      [ "Louisiana", "LA" ],
      [ "Maine", "ME" ],
      [ "Maryland", "MD" ],
      [ "Massachusetts", "MA" ],
      [ "Michigan", "MI" ],
      [ "Minnesota", "MN" ],
      [ "Mississippi", "MS" ],
      [ "Missouri", "MO" ],
      [ "Montana", "MT" ],
      [ "Nebraska", "NE" ],
      [ "Nevada", "NV" ],
      [ "New Hampshire", "NH" ],
      [ "New Jersey", "NJ" ],
      [ "New Mexico", "NM" ],
      [ "New York", "NY" ],
      [ "North Carolina", "NC" ],
      [ "North Dakota", "ND" ],
      [ "Ohio", "OH" ],
      [ "Oklahoma", "OK" ],
      [ "Oregon", "OR" ],
      [ "Pennsylvania", "PA" ],
      [ "Puerto Rico", "PR" ],
      [ "Rhode Island", "RI" ],
      [ "South Carolina", "SC" ],
      [ "South Dakota", "SD" ],
      [ "Tennessee", "TN" ],
      [ "Texas", "TX" ],
      [ "Utah", "UT" ],
      [ "Vermont", "VT" ],
      [ "Virginia", "VA" ],
      [ "Washington", "WA" ],
      [ "Washington D.C.", "DC" ],
      [ "West Virginia", "WV" ],
      [ "Wisconsin", "WI" ],
      [ "Wyoming", "WY" ]
    ]  
  
    STATES_ABBREVIATED = [
      [ "AL" ],
      [ "AK" ],
      [ "AZ" ],
      [ "AR" ],
      [ "AA" ], # Armed Forces (the) Americas
      [ "AE" ], # Armed Forces Europe
      [ "AP" ], # Armed Forces Pacific
      [ "CA" ],
      [ "CO" ],
      [ "CT" ],
      [ "DC" ],
      [ "DE" ],
      [ "FL" ],
      [ "GA" ],
      [ "HI" ],
      [ "ID" ],
      [ "IL" ],
      [ "IN" ],
      [ "IA" ],
      [ "KS" ],
      [ "KY" ],
      [ "LA" ],
      [ "ME" ],
      [ "MD" ],
      [ "MA" ],
      [ "MI" ],
      [ "MN" ],
      [ "MS" ],
      [ "MO" ],
      [ "MT" ],
      [ "NE" ],
      [ "NV" ],
      [ "NH" ],
      [ "NJ" ],
      [ "NM" ],
      [ "NY" ],
      [ "NC" ],
      [ "ND" ],
      [ "OH" ],
      [ "OK" ],
      [ "OR" ],
      [ "PA" ],
      [ "PR" ],
      [ "RI" ],
      [ "SC" ],
      [ "SD" ],
      [ "TN" ],
      [ "TX" ],
      [ "UT" ],
      [ "VT" ],
      [ "VA" ],
      [ "WA" ],
      [ "WV" ],
      [ "WI" ],
      [ "WY" ]
    ]
  
  
  
  end
end