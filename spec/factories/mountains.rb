FactoryBot.define do
  factory :mountain do
    mountain_name { Faker::Lorem.characters(number: 5) }
    mountain_body { Faker::Lorem.characters(number: 20) }
    address { Faker::Address.name}
   mountain_image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/no_image.jpg'))}
   association :user
  end
end