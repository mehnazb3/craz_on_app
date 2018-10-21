object @share
attributes :id, :message, :created_at, :micro_blog_id

child :user do
  attributes :id, :first_name, :last_name, :email
end

node(:status) { Constants::Item::Status::REV_NAME_MAP[@share.status].to_s }
node(:like_id) { @share.likes.where(user_id: @current_user.id).pluck(:id).first }

# Stats
node(:likes_count) { @share.likes.count }
node(:comments_count) { @share.comments.open_status.count }

# Actions
node(:can_like) { !@share.liked_by?(@current_user.id) }
node(:can_comment) { @share.is_status? }
node(:can_edit) { can?(:update, @share) }
node(:can_abuse) { @share.is_status? }
node(:can_delete) { can?(:delete, @share) }
