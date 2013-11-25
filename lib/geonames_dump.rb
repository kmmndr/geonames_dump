require "geonames_dump/version"
require "geonames_dump/blocks"
require "geonames_dump/railtie" #if defined?(Rails)

module GeonamesDump
  # TODO: remove this logger
  #ActiveRecord::Base.logger = Logger.new(STDOUT) if Rails.env.development? && !ENV['SILENT']

  def self.search(query, options = {})
    ret = nil

    type = options[:type] || :city
    begin
      model = "geonames_#{type.to_s}".camelcase.constantize
      ret = model.search(query)
    rescue NameError => e
      Rails.logger.error "Unknown type for GeonamesDump : #{e}"
      #raise
    end

    ret
  end
end
