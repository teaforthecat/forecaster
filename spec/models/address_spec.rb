require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:zipcodes) { { "12345"       => true,
                     "abcde"       => false,
                     "12345-12345" => false,
                     "12345-1234"  => true,
                     "12345-123"   => false } }

  it "validates zipcode" do
    zipcodes.each do |v, result|
      subject.zipcode = v
      expect(subject.valid?).to eql(result)
    end
  end
end
