class Address
  include ActiveModel::API
  attr_accessor :zipcode
  validates :zipcode, presence: true, format: /\A\d{5}(?:[-\s]\d{4})?\Z/

  def to_param
    zipcode
  end
end
