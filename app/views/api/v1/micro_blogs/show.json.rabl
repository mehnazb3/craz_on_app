object @micro_blog
attributes :id, :message, :created_at

child :user do
  attributes :id, :first_name, :last_name, :email
end

node(:status) { Constants::Item::Status::REV_NAME_MAP[@micro_blog.status].to_s }
node(:like_id) { @micro_blog.likes.where(user_id: @current_user.id).pluck(:id).first }

# Stats
node(:likes_count) { @micro_blog.likes.count }
node(:comments_count) { @micro_blog.comments.open_status.count }
node(:shares_count) { @micro_blog.shares.open_status.count }

# Actions
node(:can_like) { !@micro_blog.liked_by?(@current_user.id) }
node(:can_comment) { @micro_blog.is_status? }
node(:can_share) { @micro_blog.is_status? }
node(:can_edit) { can?(:update, @micro_blog) }
node(:can_abuse) { @micro_blog.is_status? }
node(:can_delete) { can?(:destroy, @micro_blog) }
