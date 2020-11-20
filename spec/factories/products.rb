FactoryBot.define do
  factory :product do
    title  {Faker::Types.rb_string}
    text   {Faker::Types.rb_string}
    after(:build) do |product|
      product.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
    github_uri  {Faker::Types.rb_string}
    product_uri {Faker::Types.rb_string}

    association :user
  end
end
