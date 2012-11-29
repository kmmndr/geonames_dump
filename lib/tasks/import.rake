require 'net/http'
require 'ruby-progressbar'

namespace :geonames_dump do
  namespace :import do
    CACHE_DIR = "#{Rails.root}/db/geonames_cache"

    desc 'Build the geonames download cache directory'
    task :build_cache do
      Dir::mkdir(CACHE_DIR) rescue nil
    end

    desc 'Import all geonames data. Should be performed on a clean install.'
    task :all => [:build_cache, :countries, :cities, :admin1, :admin2]

    desc 'Import all cities, regardless of population. Download requires about 5M.'
    task :cities => [:build_cache, :cities15000, :cities5000, :cities1000]
    
    desc 'Import feature data. Specify Country ISO code for just a single country. NOTE: This task can take a long time!'
    task :features => [:build_cache, :environment] do
      download_file = ENV['COUNTRY'].present? && ENV['COUNTRY'].upcase || 'allCountries'
      zip_filename = download_file+'.zip'
      zip_file = File.join(CACHE_DIR, zip_filename)
      txt_file = File.join(CACHE_DIR, download_file+'.txt')
      # Download and decompress the files if not already downloaded.
      unless File::exist?(txt_file)
        download("http://download.geonames.org/export/dump/#{zip_filename}", zip_file)
        # OSX specific unzip command.
        `unzip -o -d #{File.dirname(zip_file)} #{zip_file}`
        File.unlink(zip_file)
      end
      # Import into the database.
      File.open(txt_file) do |f|
        VALID_FEATURES = %w[ADMIN1]
        feature_attrs = VALID_FEATURES & ENV.keys
        # Filter feature rows according to optional command line params.
        insert_features(f, GeonamesFeature) do |feature|
          feature_attrs.all?{|attr| feature[attr.downcase.to_sym] == ENV[attr]}
        end
      end
    end

    # geonames:import:citiesNNN where NNN is population size.
    %w[15000 5000 1000].each do |population|
      desc "Import cities with population greater than #{population}"
      task "cities#{population}".to_sym => [:build_cache, :environment] do
        zip_file = "#{CACHE_DIR}/cities#{population}.zip"
        txt_file = "#{zip_file[0..-5]}.txt"
        # Download and decompress the files if not already downloaded.
        unless File::exist?(txt_file)
          download("http://download.geonames.org/export/dump/cities#{population}.zip", zip_file)
          # OSX specific unzip command.
          `unzip -o -d #{File.dirname(zip_file)} #{zip_file}`
          File.unlink(zip_file)
        end
        # Import into the database.
        File.open(txt_file) {|f| insert_features(f, GeonamesCity)}
      end
    end

    desc 'Import country information'
    task :countries => :environment do
      countries = fetch("http://download.geonames.org/export/dump/countryInfo.txt")
      col_names = [
        :iso,
        :iso3,
        :iso_numeric,
        :fips,
        :country,
        :capital,
        :area,
        :population,
        :continent,
        :tld,
        :currency_code,
        :currency_name,
        :phone,
        :postal_code_format,
        :postal_code_regex,
        :languages,
        :geonameid,
        :neighbours,
        :equivalent_fips_code
      ]
      countries.each_line do |line|
        attributes = {}
        line.strip.split("\t").each_with_index do |col_value, i|
          attributes[col_names[i]] = col_value
        end
        GeonamesCountry.create(attributes)
      end
    end
    
    desc 'Import admin1 codes'
    task :admin1 => [:build_cache, :environment] do
      txt_file = "#{CACHE_DIR}/admin1CodesASCII.txt"
      unless File::exist?(txt_file)
        download('http://download.geonames.org/export/dump/admin1CodesASCII.txt', txt_file)
      end
      File.open(txt_file) do |file|
        col_names = [:code, :name, :asciiname, :geonameid]
        file.each_line do |line|
          attributes = {}
          line.strip.split("\t").each_with_index do |col_value, i|
            col_value.gsub!('(general)', '')
            col_value.strip!
            if i == 0
              country, admin1 = col_value.split('.')
              attributes[:country] = country.strip
              attributes[:admin1] = admin1.strip rescue nil
            else
              attributes[col_names[i]] = col_value
            end
          end
          GeonamesAdmin1.create(attributes) if filter?(attributes)
        end
      end
    end

    desc 'Import admin2 codes'
    task :admin2 => [:build_cache, :environment] do
      txt_file = "#{CACHE_DIR}/admin2Codes.txt"
      unless File::exist?(txt_file)
        download('http://download.geonames.org/export/dump/admin2Codes.txt', txt_file)
      end
      File.open(txt_file) do |file|
        col_names = [:code, :name, :asciiname, :geonameid]
        file.each_line do |line|
          attributes = {}
          line.strip.split("\t").each_with_index do |col_value, i|
            col_value.gsub!('(general)', '')
            col_value.strip!
            if i == 0
              country, admin1, admin2 = col_value.split('.')
              attributes[:country] = country.strip
              attributes[:admin1] = admin1.strip
              attributes[:admin2] = admin2.strip
            else
              attributes[col_names[i]] = col_value
            end
          end
          GeonamesAdmin2.create(attributes) if filter?(attributes)
        end
      end
    end

    private

    def download(url, output)
      File.open(output, "wb") do |file|
        body = fetch(url)
        puts "Writing #{url} to #{output}"
        file.write(body)
      end
    end
    
    def fetch(url)
      puts "Fetching #{url}"
      url = URI.parse(url)
      req = Net::HTTP::Get.new(url.path)
      res = Net::HTTP.start(url.host, url.port) {|http| http.request(req)}
      return res.body
    end
    
    # Insert features from a file. Pass a block that returns true/false to include/exclude the feature.
    def insert_features(file_fd, klass = GeonamesFeature, &block)
      # Setup nice progress output.
      #require File.join(File.dirname(__FILE__), '../../vendor/plugins/ruby-progressbar/lib/progressbar')
      file_size = file_fd.stat.size
      #progress_bar = ProgressBar.new('Feature Import', file_size)
      progress_bar = ProgressBar.create(:title => 'Feature Import', :total => file_size, :format => '%a |%b>>%i| %p%% %t')

      col_names = [
        :geonameid,
        :name,
        :asciiname,
        :alternatenames,
        :latitude,
        :longitude,
        :feature_class,
        :feature,
        :country,
        :cc2,
        :admin1,
        :admin2,
        :admin3,
        :admin4,
        :population,
        :elevation,
        :gtopo30,
        :timezone,
        :modification
      ]
      file_fd.each_line do |line|
        attributes = {}
        line.strip.split("\t").each_with_index do |col_value, i|
          col = col_names[i]
          attributes[col] = col_value
        end
        
        if (attributes[:feature] == "PPL")
          klass = GeonamesCity
        end
        klass.create(attributes) if filter?(attributes) && (block && block.call(attributes))

        # w00t! Friendly output FTW!
        #progress_bar.set(file_fd.pos)
        progress_bar = file_fd.pos
      end
    end

    # Return true when either:
    #  no filter keys apply.
    #  all applicable filter keys include the filter value.
    def filter?(attributes)
      return attributes.keys.all?{|key| filter_keyvalue?(key, attributes[key])}
    end

    def filter_keyvalue?(col, col_value)
      return true unless ENV[col.to_s]
      return ENV[col.to_s].split('|').include?(col_value.to_s)
    end

  end
end
