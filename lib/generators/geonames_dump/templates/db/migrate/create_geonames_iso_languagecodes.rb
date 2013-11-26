class CreateGeonamesIsoLanguagecodes < ActiveRecord::Migration
  # http://download.geonames.org/export/dump/iso-languagecodes.txt
  # iso_639_3 : ISO 639-3 language code
  # iso_639_2 : ISO 639-2 language code
  # iso_639_1 : ISO 639-1 language code
  # language_name : language name
  def change
    create_table :geonames_iso_languagecodes do |t|
      t.string :iso_639_3, length: 4
      t.string :iso_639_2, length: 4
      t.string :iso_639_1, length: 4
      t.string :language_name, length: 80

      t.timestamps
    end
  end
end
