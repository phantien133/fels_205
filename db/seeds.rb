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
  name = "Category #{n}"
  Category.create! name: name
end
categorires = Category.first(5)
categorires.each do |category|
  50.times do |n|
    word = Word.create content: "word #{n}", category_id: category.id
    5.times do |m|
      correct = m == n % 5 ? true : false
      word.answers.create(content: "answers #{n} #{m}", correct: correct)
    end
  end
end
user = User.first
categorires.each do |category|
  20.times do |n|
    number_of_words = n + 1
    time = n+2
    lesson = user.lessons.create name: "lesson #{n}", category_id: category.id,
      number_of_words: number_of_words, time: time
  end
end
