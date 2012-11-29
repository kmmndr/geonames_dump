
namespace :geonames_dump do
  desc 'Copy over the migration files and migrate'
  #task :migrate => [:environment, :copy_migrations, 'db:migrate']
  task :migrate => [:environment, 'db:migrate']

#  # Inspired by http://interblah.net/plugin-migrations
#  desc 'Copy over the migration files and migrate'
#  task :copy_migrations => :environment do
#    require 'fileutils'
#    APP_MIGRATION_DIR = "#{Rails.root}/db/migrate"
#    PLUGIN_MIGRATION_DIR = "#{File.dirname(__FILE__)}/../../db/migrate"
#
#    # Find all application migrations
#    existing_migrations = Dir[APP_MIGRATION_DIR+'/*']
#    existing_migrations.map!{|file| File.basename(file) =~ /^[0-9]+_(.+)$/ && $1}
#
#    # Find all of this plugin's migrations
#    plugin_migrations = Dir[PLUGIN_MIGRATION_DIR+'/*']
#    plugin_migrations.map!{|file| File.basename(file)}
#    # ... handle case when copying to plugins migrate directory.
#    plugin_migrations.map!{|file| File.basename(file) =~ /^[0-9]+_(.+)$/ ? $1 : File.basename(file)}
#
#    # Compare application migrations with this plugins set of migrations, and copy new migrations.
#    puts 'There are no new migrations to copy.' if (plugin_migrations - existing_migrations).empty?
#    base_time = Time.now
#    (plugin_migrations - existing_migrations).each do |new_migration|
#      migration_timestamp = base_time.strftime('%Y%m%d%H%M%S')
#      puts "Copying from #{PLUGIN_MIGRATION_DIR}/#{new_migration} to #{APP_MIGRATION_DIR}/#{migration_timestamp}_#{new_migration}"
#      FileUtils::cp "#{PLUGIN_MIGRATION_DIR}/#{new_migration}", "#{APP_MIGRATION_DIR}/#{migration_timestamp}_#{new_migration}"
#      base_time+=1
#    end
#  end
end
