class GeonamesFeature < ActiveRecord::Base
  validates_uniqueness_of :geonameid

  ##
  # Search for feature, searches might include country (separated by ',')
  #
  scope :search, lambda { |query| 
    virgule = query.include? ','

    splited = virgule ? query.split(',') : [query]

    country = virgule ? splited.last.strip : nil

    queries = virgule ? splited[0...-1] : splited
    queries = queries.join(' ').split(' ')

    ret = by_name(*queries)

    unless country.nil?
      geonames_country = GeonamesCountry.search(country).first
      ret = ret.where(:country => geonames_country.iso) unless geonames_country.nil?
    end

    ret
  }

  ##
  # Find by names
  #
  scope :by_name, lambda { |*queries|
    ret = self.scoped
    count = queries.count
    queries.collect.with_index do |q, idx|
      query = idx == 0 ? "#{q}" : "%#{q}%"
      ret = ret.where("asciiname_first_letters = ?", q[0...3])
      ret = ret.where("name LIKE ? or asciiname LIKE ?", query, query)
    end
    ret
  }

end
