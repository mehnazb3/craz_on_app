collection @blocked_users

attributes :id, :email, :first_name, :last_name, :location_id

node(:location_name) { |user| user.location.name }
