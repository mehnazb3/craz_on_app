collection @abuses
attributes :id, :reason, :created_at, :abusable_item_id, :abusable_item_type

child :abusable_item do
  attributes :message, :created_at

  child :user do
    attributes :id, :first_name, :last_name, :email
  end
end
