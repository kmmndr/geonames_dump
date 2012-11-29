
# http://download.geonames.org/export/dump/countryInfo.txt

class CreateGeonamesCountries < ActiveRecord::Migration

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
      t.string :geonameid
      t.string :neighbours
      t.string :equivalent_fips_code

      t.timestamps
    end

    add_index :geonames_countries, :country
  end

  def self.down
    # TODO Do we need to remove index if we remove the table anyway?
    remove_index :geonames_countries, :country

    drop_table :geonames_countries
  end
end
