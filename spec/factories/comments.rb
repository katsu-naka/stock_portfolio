FactoryBot.define do
  factory :comment do
    comment {Faker::Types.rb_string }

    association :user
    association :product
  end
end
