FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence}
    content { Faker::Lorem.paragraph}
    published { 
      0 == rand(0..1)
    }
    user
  end
end
