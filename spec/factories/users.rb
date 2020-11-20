FactoryBot.define do
  factory :user do
    nickname                {"テスト"}
    email                   {Faker::Internet.free_email}
    password                {Faker::Internet.password(min_length: 6)}
    password_confirmation   {password}
    first_name              {"太郎"}
    last_name               {"山田"}
    first_name_kana         {"タロウ"}
    last_name_kana          {"ヤマダ"}
    birth                   {Faker::Date.backward(days: 365)}
    phone_number            {"09011112222"}
    profile                 {Faker::Types.rb_string}
  end
end
