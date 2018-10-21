object @item
attributes :id, :message, :commentable_item_id, :commentable_item_type, :created_at
node(:like_id) do |item|
  item.likes.where(user_id: @current_user.id).pluck(:id).first
end

child :user do
  attributes :id, :first_name, :last_name, :email
end

# Actions
node(:can_like) do |item|
  !item.liked_by?(@current_user.id)
end
node(:can_comment) do |item|
  if item.is_a?(Comment)
    item.is_status? && !item.is_a_reply
  end
end
node(:can_edit) do |item|
  can?(:update, item)
end
node(:can_abuse) do |item|
  item.is_status?
end
node(:can_delete) do |item|
  can?(:destroy, item)
end
