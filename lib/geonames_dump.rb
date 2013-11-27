require "geonames_dump/version"
require "geonames_dump/blocks"
require "geonames_dump/railtie" #if defined?(Rails)

module GeonamesDump
  def self.search(query, options = {})
    ret = nil

    type = options[:type] || :auto
    begin
      case type
      when :auto # return an array of features
        # city name
        ret = GeonamesCity.search(query)
        # alternate name
        ret = GeonamesAlternateName.search(query).map { |alternate| alternate.feature }.compact  if ret.blank?
        # admin1
        ret = GeonamesAdmin1.search(query) if ret.blank?
        # admin2
        ret = GeonamesAdmin2.search(query) if ret.blank?
        # feature
        ret = GeonamesFeature.search(query) if ret.blank?
      else # country, or specific type
        model = "geonames_#{type.to_s}".camelcase.constantize
        ret = model.search(query)
      end
    rescue NameError => e
      raise $!, "Unknown type for GeonamesDump, #{$!}", $!.backtrace
    end


    ret
  end
end
