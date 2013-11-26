require "geonames_dump/version"
require "geonames_dump/blocks"
require "geonames_dump/railtie" #if defined?(Rails)

module GeonamesDump
  # TODO: remove this logger
  #ActiveRecord::Base.logger = Logger.new(STDOUT) if Rails.env.development? && !ENV['SILENT']

  def self.search(query, options = {})
    ret = nil

    type = options[:type] || :auto
    begin
      case type
      when :auto
        # city name
        ret = GeonamesCity.search(query)
        # alternate name
        ret = GeonamesAlternateName.search(query) if ret.blank?
        # admin1
        ret = GeonamesAdmin1.search(query) if ret.blank?
        # admin2
        ret = GeonamesAdmin2.search(query) if ret.blank?
        # country
        ret = GeonamesCountry.search(query) if ret.blank?
        # feature
        ret = GeonamesFeature.search(query) if ret.blank?
      else
        model = "geonames_#{type.to_s}".camelcase.constantize
        ret = model.search(query)
      end
    rescue NameError => e
      Rails.logger.error "Unknown type for GeonamesDump : #{e}"
      #raise
    end

    ret
  end
end
