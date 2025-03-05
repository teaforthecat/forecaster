FactoryBot.define do
  factory :address do
    sequence(:zipcode) { |n| "1080#{n}"  }
  end
end
