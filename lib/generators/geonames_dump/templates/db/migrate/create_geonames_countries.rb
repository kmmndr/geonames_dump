class CreateGeonamesCountries < ActiveRecord::Migration
  # http://download.geonames.org/export/dump/countryInfo.txt
  def self.up
    create_table :geonames_countries do |t|
      t.string :iso
      t.string :iso3
      t.string :iso_numeric
      t.string :fips
      t.string :country
      t.string :capital
      t.integer :area # in sq. km
      t.integer :population
      t.string :continent
      t.string :tld
      t.string :currency_code
      t.string :currency_name
      t.string :phone
      t.string :postal_code_format
      t.string :postal_code_regex
      t.string :languages
      t.integer :geonameid
      t.string :neighbours
      t.string :equivalent_fips_code

      t.timestamps
    end

    add_index :geonames_countries, :geonameid
    add_index :geonames_countries, :country
  end

  def self.down
    drop_table :geonames_countries
  end
end
