object @item
attributes :id, :message, :created_at

child :user do
  attributes :id, :first_name, :last_name, :email
end