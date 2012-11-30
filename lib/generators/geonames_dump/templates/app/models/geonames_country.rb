class GeonamesCountry < ActiveRecord::Base
  validates_uniqueness_of :geonameid
end
