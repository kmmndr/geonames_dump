module GeonamesDump
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      desc <<DESC
Description:
    Create Geonames initial migrations files and Geonames model files in your application
DESC
      def copy_migrations_files
        #template File.join('app', 'models', 'geonames_country.rb', 'config/initializers/piktur_config.rb'
        %w(create_geonames_countries create_geonames_features).each do |file|
          migration_template File.join('db', 'migrate', "#{file}.rb")
        end
      end

      def copy_models_files
        #template File.join('app', 'models', 'geonames_country.rb', 'config/initializers/piktur_config.rb'
        %w(geonames_admin1 geonames_admin2 geonames_city geonames_country geonames_feature).each do |file|
          copy_file File.join('app', 'models', "#{file}.rb")
        end
      end

      def self.next_migration_number(path)
        sleep 1 # OPTIMIZE: there might be a better way to do this ...
        @migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i.to_s
      end

    end
  end
end
