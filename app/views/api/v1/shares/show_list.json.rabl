object @item
attributes :id, :message, :created_at, :micro_blog_id

child :user do
  attributes :id, :first_name, :last_name, :email
end