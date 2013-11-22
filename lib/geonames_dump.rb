require "geonames_dump/version"
require "geonames_dump/blocks"
require "geonames_dump/railtie" #if defined?(Rails)

module GeonamesDump
  # TODO: remove this logger
  #ActiveRecord::Base.logger = Logger.new(STDOUT) if Rails.env.development? && !ENV['SILENT']
end
