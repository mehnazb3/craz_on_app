CRAZ_ON_SETTINGS[:locations].each do |city|
  l = Location.create(name: city)
  if l.errors.any?
    p "Errors when creating '#{city}' location: #{l.errors.messages.join(', ')}"
  else
    p "Created the location '#{city}'"
  end
end

def save_user(user)
  if user.save
    p "Created '#{user.first_name} #{user.last_name}' user"
  else
    p "Errors when creating '#{user.first_name} #{user.last_name}' user: #{user.errors.messages.join(', ')}"
  end
end

admin = User.new(
  email: 'admin@rails_e2_soln.com',
  password: 'RailsE2@dmin',
  password_confirmation: 'RailsE2@dmin',
  first_name: 'RailsE2',
  last_name: 'Admin',
  gender: Constants::User::Gender::MALE,
  is_admin: true,
  location_id: 1
)
save_user(admin)

(1..5).each do |user_i|
  user = User.new(
    email: "user#{user_i}@rails_e2_soln.com",
    password: 'RailsE2@user',
    password_confirmation: 'RailsE2@user',
    first_name: 'RailsE2',
    last_name: "User#{user_i}",
    gender: Constants::User::Gender::MALE,
    location_id: ((user_i % CRAZ_ON_SETTINGS[:locations].count) + 1)
  )
  save_user(user)
end
