FactoryBot.define do
  factory :post do
    title { Faker::Lorem.characters(number: 5) }
    body { Faker::Lorem.characters(number: 20) }
   image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/no_image.jpg'))}
   association :user
  end
end