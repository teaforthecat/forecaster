class Address < ApplicationRecord
  validates :zipcode, presence: true, format: /\A\d{5}(?:[-\s]\d{4})?\Z/

  def to_param
    zipcode
  end
end
