class CreateGeonamesAlternateNames < ActiveRecord::Migration
  # http://download.geonames.org/export/dump/countryInfo.txt
  # alternateNameId   : the id of this alternate name, int
  # geonameid         : geonameId referring to id in table 'geoname', int
  # isolanguage       : iso 639 language code 2- or 3-characters; 4-characters 'post' for postal codes and 'iata','icao' and faac for airport codes, fr_1793 for French Revolution names,  abbr for abbreviation, link for a website, varchar(7)
  # alternate name    : alternate name or name variant, varchar(200)
  # isPreferredName   : '1', if this alternate name is an official/preferred name
  # isShortName       : '1', if this is a short name like 'California' for 'State of California'
  # isColloquial      : '1', if this alternate name is a colloquial or slang term
  # isHistoric        : '1', if this alternate name is historic and was used in the past
  def change
    create_table :geonames_alternate_names do |t|
      t.integer :alternate_name_id
      t.integer :geonameid
      t.string :isolanguage, length: 7
      t.string :alternate_name, length: 200
      t.boolean :is_preferred_name
      t.boolean :is_short_name
      t.boolean :is_colloquial
      t.boolean :is_historic

      t.string :alternate_name_first_letters

      t.timestamps
    end

    add_index :geonames_alternate_names, :alternate_name_id
    add_index :geonames_alternate_names, :geonameid
    add_index :geonames_alternate_names, :isolanguage
    add_index :geonames_alternate_names, :alternate_name_first_letters
  end
end
