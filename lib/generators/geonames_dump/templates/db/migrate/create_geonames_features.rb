class CreateGeonamesFeatures < ActiveRecord::Migration
  # http://download.geonames.org/export/dump/readme.txt
  # geonameid         : integer id of record in geonames database
  # name              : name of geographical point (utf8) varchar(200)
  # asciiname         : name of geographical point in plain ascii characters, varchar(200)
  # alternatenames    : alternatenames, comma separated varchar(4000) (varchar(5000) for SQL Server)
  # latitude          : latitude in decimal degrees (wgs84)
  # longitude         : longitude in decimal degrees (wgs84)
  # feature class     : see http://www.geonames.org/export/codes.html, char(1)
  # feature code      : see http://www.geonames.org/export/codes.html, varchar(10)
  # country code      : ISO-3166 2-letter country code, 2 characters
  # cc2               : alternate country codes, comma separated, ISO-3166 2-letter country code, 60 characters
  # admin1 code       : fipscode (subject to change to iso code), isocode for the us and ch, see file admin1Codes.txt for display names of this code; varchar(20)
  # admin2 code       : code for the second administrative division, a county in the US, see file admin2Codes.txt; varchar(80)
  # admin3 code       : code for third level administrative division, varchar(20)
  # admin4 code       : code for fourth level administrative division, varchar(20)
  # population        : bigint (4 byte int)
  # elevation         : in meters, integer
  # dem               : digital elevation model, srtm3 or gtopo30, average elevation of 3''x3'' (ca 90mx90m) or 30''x30'' (ca 900mx900m) area in meters, integer. srtm processed by cgiar/ciat.
  # timezone          : the timezone id (see file timeZone.txt)
  # modification date : date of last modification in yyyy-MM-dd format
  def change
    create_table :geonames_features do |t|
      t.integer :geonameid
      t.string :name, length: 200
      t.string :asciiname, length: 200
      t.text :alternatenames, length: 5000
      t.float :latitude
      t.float :longitude
      t.string :feature_class
      t.string :feature_code, length: 10
      t.string :country_code
      t.string :cc2, length: 60
      t.string :admin1_code, length: 20
      t.string :admin2_code, length: 80
      t.string :admin3_code, length: 20
      t.string :admin4_code, length: 20
      t.integer :population
      t.integer :elevation
      t.integer :dem
      t.string :timezone, length: 40
      t.timestamp :modification

      t.string :type
      t.string :asciiname_first_letters

      t.timestamps
    end

    add_index :geonames_features, :geonameid
    add_index :geonames_features, :name
    add_index :geonames_features, :asciiname
    add_index :geonames_features, :country_code
    add_index :geonames_features, :population
    add_index :geonames_features, :admin1_code
    add_index :geonames_features, :type
    add_index :geonames_features, :asciiname_first_letters
  end
end
