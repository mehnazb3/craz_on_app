object @user
attributes :id, :email, :first_name, :last_name, :location_id

node(:location_name) { @user.location.name }

node(:block, if: lambda { |u| can?(:block, u) }) do |u|
  @current_user.has_blocked?(u.id)
end

node(:follow, if: lambda { |u| !(u.is_admin || u.id == @current_user.id) }) do |u|
  u.followers.select(:id).map(&:id).include?(@current_user.id)
end

node(:followed_by, if: lambda { |u| !(u.is_admin || u.id == @current_user.id) }) do |u|
  u.followed_by.select(:id).map(&:id).include?(@current_user.id)
end
