require 'pry'
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
        Dir.glob(File.join(File.expand_path(File.join('..', 'templates', 'db', 'migrate'), __FILE__), '*')).each do |full_path|
          file = File.basename(full_path, File.extname(full_path))
          migration_folder = File.join('db', 'migrate')

          if self.class.migration_exists?(migration_folder, file)
            say_status("skip", "Migration #{file} already exists", :yellow)
          else
            srcdst = File.join(migration_folder, "#{file}.rb")
            migration_template(srcdst, srcdst)
          end
        end
      end

      def copy_models_files
        Dir.glob(File.join(File.expand_path(File.join('..', 'templates', 'app', 'models'), __FILE__), '*')).each do |full_path|
          file = File.basename(full_path, File.extname(full_path))
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
