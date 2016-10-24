User.create!(
  name: "Triple Tee",
  email: "tien@framgia.com",
  address: "Earth",
  birthday: "1995/03/13",
  sex: "Male",
  phone: "0935253027",
  password: "12312311",
  password_confirmation: "12312311",
  admin: true,
)
50.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@framgia.org"
  password = "123123"
  phone= 93525000 +n+1
  User.create!(
    name: name,
    email: email,
    address: "Galaxy",
    birthday: "1995/03/03",
    sex: "Male",
    phone: phone.to_s,
    password: password,
    password_confirmation: password,
  )
end
50.times do |n|
  name = Faker::Name.name
  Category.create!(
    name: name
  )
end
