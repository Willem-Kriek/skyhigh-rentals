# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'open-uri'
require 'faker'
Booking.destroy_all
Drone.destroy_all
User.destroy_all
ActiveRecord::Base.connection.reset_pk_sequence!(Booking.table_name)
ActiveRecord::Base.connection.reset_pk_sequence!(Drone.table_name)
ActiveRecord::Base.connection.reset_pk_sequence!(User.table_name)

20.times do
  User.create(
    email: Faker::Internet.email,
    password: '123456',
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    address: Faker::Address.street_address
  )
end

drone_brands = ['DJI', 'Parrot', 'Autel Robotics', 'Yuneec', 'Skydio', 'Holy Stone', 'Ryze Tech', 'Hubsan']

drone_img = ['https://res.cloudinary.com/dmlxmpwua/image/upload/v1708703387/drone_16_neh9nu.jpg',
              'https://res.cloudinary.com/dmlxmpwua/image/upload/v1708703387/drone_15_vd7wlg.jpg',
              'https://res.cloudinary.com/dmlxmpwua/image/upload/v1708703387/drone_14_zn4twk.webp',
              'https://res.cloudinary.com/dmlxmpwua/image/upload/v1708703387/drone_13_cerjl6.jpg',
              'https://res.cloudinary.com/dmlxmpwua/image/upload/v1708703387/drone_11_p87vnb.jpg',
              'https://res.cloudinary.com/dmlxmpwua/image/upload/v1708703387/Drone_7_hi8cdz.jpg',
              'https://res.cloudinary.com/dmlxmpwua/image/upload/v1708703387/9_x1yock.jpg',
              'https://res.cloudinary.com/dmlxmpwua/image/upload/v1708703388/Drone_6_p8zmtq.jpg',
              'https://res.cloudinary.com/dmlxmpwua/image/upload/v1708703388/Drone_2_nqg7bw.jpg',
              'https://res.cloudinary.com/dmlxmpwua/image/upload/v1708703389/Drone_5_a4r4xm.jpg',
              'https://res.cloudinary.com/dmlxmpwua/image/upload/v1708703390/Drone_10_aipb0i.jpg']

20.times do
  drone_description = "#{Faker::Hacker.verb} #{Faker::Hacker.noun} with #{Faker::Hacker.adjective} features"

  drone = Drone.create(
    price: rand(10..100),
    brand: drone_brands.sample,
    model: Faker::Drone.name,
    time_in_air: rand(15..60),
    description: drone_description,
    weight: rand(100..1000),
    category: Drone::CATEGORY.sample,
    user: User.all.sample
  )

  file = URI.parse(drone_img.sample).open
  drone.photo.attach(io: file, filename: "drone_image.png", content_type: "image/jpeg")
end

30.times do
  Booking.create(
    from_date: Faker::Date.between(from: Date.today, to: 1.year.from_now),
    to_date: Faker::Date.between(from: 1.year.from_now, to: 2.years.from_now),
    accepted: [true, false].sample,
    user: User.all.sample,
    drone: Drone.all.sample
  )
end
