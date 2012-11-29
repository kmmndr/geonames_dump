class CreateGeonamesFeatures < ActiveRecord::Migration

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
  # gtopo30           : average elevation of 30'x30' (ca 900mx900m) area in meters, integer
  # timezone          : the timezone id (see file timeZone.txt)
  # modification date : date of last modification in yyyy-MM-dd format
  def self.up
    create_table :geonames_features do |t|
      t.integer :geonameid
      t.string :name
      t.string :asciiname
      t.string :alternatenames
      t.float :latitude
      t.float :longitude
      t.string :feature_class
      t.string :feature
      t.string :country
      t.string :cc2
      t.string :admin1
      t.string :admin2
      t.string :admin3
      t.string :admin4
      t.integer :population
      t.integer :elevation
      t.integer :gtopo30
      t.string :timezone
      t.timestamp :modification
      t.string :type

      t.timestamps
    end

    add_index :geonames_features, :name
    add_index :geonames_features, :country
    add_index :geonames_features, :population
    add_index :geonames_features, :admin1
    add_index :geonames_features, :type
  end

  def self.down
    # TODO Do we need to remove index if we remove the table anyway?
    remove_index :geonames_features, :admin1
    remove_index :geonames_features, :population
    remove_index :geonames_features, :country
    remove_index :geonames_features, :name

    drop_table :geonames_features
  end
end
