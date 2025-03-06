FactoryBot.define do
  factory :address do
    # note: this value is recorded in vcr_cassettes/tomorrow.yml
    zipcode { "10801"  }
  end
end
