object @item
attributes :created_at, :likable_item_id, :likable_item_type

child :user do
  attributes :id, :first_name, :last_name, :email
end