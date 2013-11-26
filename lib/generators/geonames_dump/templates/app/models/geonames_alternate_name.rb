class GeonamesAlternateName < ActiveRecord::Base
  validates_uniqueness_of :alternate_name_id
  validates_uniqueness_of :geonameid
  before_save :set_alternate_name_first_letters

  ##
  # default search (by alternate name)
  #
  scope :search, lambda { |q|
    by_alternate_name(q)
  }

  ##
  # search by isolanguage code
  #
  scope :by_isolanguage, lambda { |q|
    where("isolanguage = ?", q)
  }

  ##
  # search prefered names
  #
  scope :prefered, lambda {
    where(is_preferred_name: true)
  }

  ##
  # search by name
  #
  scope :by_alternate_name, lambda { |q|
    ret = self.scoped
    ret = ret.where("alternate_name_first_letters = ?", q[0...3].downcase)
    ret = ret.where("alternate_name LIKE ?", "#{q}%")
  }

  ##
  # Get associated feature
  #
  def feature
    GeonamesFeature.where(geonameid: self.geonameid)
  end

  protected

  ##
  # Set first letters of name into index column
  #
  def set_alternate_name_first_letters
    self.alternate_name_first_letters = self.alternate_name[0...3].downcase unless self.alternate_name.nil?
  end

end
