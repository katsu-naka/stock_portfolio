FactoryBot.define do
  factory :contact do
    message {Faker::Types.rb_string }

    association :user
  end
end
