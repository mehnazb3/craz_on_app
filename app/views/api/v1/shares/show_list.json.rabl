object @item
attributes :id, :message, :created_at

child :micro_blog do
  attributes :id, :message
end

child :user do
  attributes :id, :first_name, :last_name, :email
end