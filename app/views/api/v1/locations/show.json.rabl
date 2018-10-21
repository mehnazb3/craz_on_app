object @location
attributes :id, :name

node(:micro_blogs_count) { @location.micro_blogs.open_status.count }
node(:likes_count) { @location.likes.open_status.count }
node(:comments_count) { @location.comments.open_status.count }
node(:shares_count) { @location.shares.open_status.count }
node(:users_count) { @location.users.count }