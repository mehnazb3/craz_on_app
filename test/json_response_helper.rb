module JsonResponseHelper
  module UserSessions
    CREATE_OK = {'api_key'=>'some_api_key'}
    CREATE_ERR = {'error'=>'Invalid Email or password.'}
  end

  module UserRegistrations
    CREATE_OK = {'api_key'=>nil}
    CREATE_ERR = {'error'=>'Email is invalid'}
  end

  module Locations
    INDEX = [{"id"=>1, "name"=>"Chennai"}, {"id"=>2, "name"=>"Bangalore"}, {"id"=>3, "name"=>"Mumbai"}, {"id"=>4, "name"=>"Kolkata"}, {"id"=>5, "name"=>"Delhi"}]
    LIST_BY = {
                'micro_blog'=>[{"id"=>1, "message"=>"Anand micro-blog 1", "created_at"=>nil, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}, {"id"=>2, "message"=>"Anand micro-blog 2", "created_at"=>nil, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}],
                'like'=>[{"created_at"=>nil, "likable_item_id"=>1, "likable_item_type"=>"MicroBlog", "micro_blog"=>{"message"=>"Anand micro-blog 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}, {"created_at"=>nil, "likable_item_id"=>1, "likable_item_type"=>"Share", "share"=>{"message"=>"Anand share of micro-blog 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}, {"created_at"=>nil, "likable_item_id"=>4, "likable_item_type"=>"Comment", "comment"=>{"message"=>"Reply comment to comment 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}],
                'comment'=>[{"id"=>1, "message"=>"Comment 1 on micro-blog 1", "commentable_item_id"=>1, "commentable_item_type"=>"MicroBlog", "created_at"=>nil, "micro_blog"=>{"message"=>"Anand micro-blog 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}, "like_id"=>nil, "can_like"=>true, "can_comment"=>true, "can_edit"=>false, "can_abuse"=>true, "can_delete"=>true}, {"id"=>3, "message"=>"Reply comment to comment 1", "commentable_item_id"=>1, "commentable_item_type"=>"Comment", "created_at"=>nil, "comment"=>{"message"=>"Comment 1 on micro-blog 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}, "like_id"=>nil, "can_like"=>true, "can_comment"=>false, "can_edit"=>true, "can_abuse"=>true, "can_delete"=>true}],
                'share'=>[{"id"=>1, "message"=>"Anand share of micro-blog 1", "created_at"=>nil, "micro_blog"=>{"id"=>1, "message"=>"Anand micro-blog 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}, {"id"=>2, "message"=>"Anand share of micro-blog 2", "created_at"=>nil, "micro_blog"=>{"id"=>1, "message"=>"Anand micro-blog 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}],
                'user'=>[{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com", "points"=>0, "title"=>"", "gender"=>"male"}]
              }
    SHOW = {"id"=>2, "name"=>"Bangalore", "micro_blogs_count"=>2, "likes_count"=>2, "comments_count"=>3, "shares_count"=>1, "users_count"=>1}
  end

  module Users
    LIST_BY = {
                'micro_blog'=>[{"id"=>1, "message"=>"Anand micro-blog 1", "created_at"=>nil, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}, {"id"=>2, "message"=>"Anand micro-blog 2", "created_at"=>nil, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}],
                'like'=>[{"created_at"=>nil, "likable_item_id"=>1, "likable_item_type"=>"MicroBlog", "micro_blog"=>{"message"=>"Anand micro-blog 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}, {"created_at"=>nil, "likable_item_id"=>1, "likable_item_type"=>"Share", "share"=>{"message"=>"Anand share of micro-blog 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}, {"created_at"=>nil, "likable_item_id"=>4, "likable_item_type"=>"Comment", "comment"=>{"message"=>"Reply comment to comment 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}],
                'comment'=>[{"id"=>1, "message"=>"Comment 1 on micro-blog 1", "commentable_item_id"=>1, "commentable_item_type"=>"MicroBlog", "created_at"=>nil, "micro_blog"=>{"message"=>"Anand micro-blog 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}, "like_id"=>nil, "can_like"=>true, "can_comment"=>true, "can_edit"=>false, "can_abuse"=>true, "can_delete"=>true}, {"id"=>3, "message"=>"Reply comment to comment 1", "commentable_item_id"=>1, "commentable_item_type"=>"Comment", "created_at"=>nil, "comment"=>{"message"=>"Comment 1 on micro-blog 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}, "like_id"=>nil, "can_like"=>true, "can_comment"=>false, "can_edit"=>true, "can_abuse"=>true, "can_delete"=>true}],
                'share'=>[{"id"=>1, "message"=>"Anand share of micro-blog 1", "created_at"=>nil, "micro_blog"=>{"id"=>1, "message"=>"Anand micro-blog 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}, {"id"=>2, "message"=>"Anand share of micro-blog 2", "created_at"=>nil, "micro_blog"=>{"id"=>1, "message"=>"Anand micro-blog 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}]
              }
    UPDATE_OK = {"id"=>1, "email"=>"anand.s@rails_e2_soln.com", "first_name"=>"Updated_f_name", "last_name"=>"Sai", "location_id"=>1, "location_name"=>"Chennai"}
    SHOW = {"id"=>1, "email"=>"anand.s@rails_e2_soln.com", "first_name"=>"Anand", "last_name"=>"Sai", "location_id"=>1, "location_name"=>"Chennai"}
    BLOCKED_LIST = [{"id"=>2, "email"=>"bharath.n@rails_e2_soln.com", "first_name"=>"Bharath", "last_name"=>"Naren", "location_id"=>2, "location_name"=>"Bangalore"}]
    UNBLOCK_USERS = {"results"=>[{"user_id"=>2, "result"=>"true"}, {"user_id"=>3, "result"=>"true"}]}
    TIMELINE =  {
                  'micro_blog'=>{"timeline"=>[{"id"=>1, "message"=>"Anand micro-blog 1", "created_at"=>nil, "like_id"=>1, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}, "likes"=>[{"user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}, {"user"=>{"id"=>2, "first_name"=>"Bharath", "last_name"=>"Naren", "email"=>"bharath.n@rails_e2_soln.com"}}], "comments"=>[{"id"=>1, "message"=>"Comment 1 on micro-blog 1", "created_at"=>nil, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}, {"id"=>2, "message"=>"Comment 2 on micro-blog 1", "created_at"=>nil, "user"=>{"id"=>2, "first_name"=>"Bharath", "last_name"=>"Naren", "email"=>"bharath.n@rails_e2_soln.com"}}], "shares_count"=>2}, {"id"=>2, "message"=>"Anand micro-blog 2", "created_at"=>nil, "like_id"=>nil, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}, "likes"=>[], "comments"=>[], "shares_count"=>0}]},
                  'share'=>{"timeline"=>[{"id"=>1, "message"=>"Anand share of micro-blog 1", "created_at"=>nil, "like_id"=>3, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}, "likes"=>[{"user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}], "comments"=>[{"id"=>5, "message"=>"Comment on share 1", "created_at"=>nil, "user"=>{"id"=>2, "first_name"=>"Bharath", "last_name"=>"Naren", "email"=>"bharath.n@rails_e2_soln.com"}}]}, {"id"=>2, "message"=>"Anand share of micro-blog 2", "created_at"=>nil, "like_id"=>nil, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}, "likes"=>[], "comments"=>[]}]}
                }
  end

  module Abuses
    INDEX = [{"id"=>1, "reason"=>"Abuse 1 on MicroBlog", "created_at"=>nil, "abusable_item_id"=>1, "abusable_item_type"=>"MicroBlog", "micro_blog"=>{"message"=>"Anand micro-blog 1", "created_at"=>nil, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}}, {"id"=>2, "reason"=>"Abuse 2 on Share", "created_at"=>nil, "abusable_item_id"=>1, "abusable_item_type"=>"Share", "share"=>{"message"=>"Anand share of micro-blog 1", "created_at"=>nil, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}}, {"id"=>3, "reason"=>"Abuse 3 on Comment", "created_at"=>nil, "abusable_item_id"=>1, "abusable_item_type"=>"Comment", "comment"=>{"message"=>"Comment 1 on micro-blog 1", "created_at"=>nil, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}}, {"id"=>4, "reason"=>"Abuse 4 on Comment", "created_at"=>nil, "abusable_item_id"=>2, "abusable_item_type"=>"Comment", "comment"=>{"message"=>"Comment 2 on micro-blog 1", "created_at"=>nil, "user"=>{"id"=>2, "first_name"=>"Bharath", "last_name"=>"Naren", "email"=>"bharath.n@rails_e2_soln.com"}}}, {"id"=>5, "reason"=>"Abuse 5 on Comment", "created_at"=>nil, "abusable_item_id"=>4, "abusable_item_type"=>"Comment", "comment"=>{"message"=>"Reply comment to comment 1", "created_at"=>nil, "user"=>{"id"=>2, "first_name"=>"Bharath", "last_name"=>"Naren", "email"=>"bharath.n@rails_e2_soln.com"}}}]
    HANDLE_ABUSES = {"results"=>[{"abuse_id"=>1, "result"=>"true"}, {"abuse_id"=>2, "result"=>"Already rejected"}, {"abuse_id"=>3, "result"=>"Already rejected"}]}
  end

  module MicroBlogs
    CREATE_OK = {"id"=>7, "message"=>"Sample micro-blog message", "created_at"=>nil, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}, "status"=>"open", "like_id"=>nil, "likes_count"=>0, "comments_count"=>0, "shares_count"=>0, "can_like"=>true, "can_comment"=>true, "can_share"=>true, "can_edit"=>true, "can_abuse"=>true, "can_delete"=>true}
    CREATE_ERR = {"error"=>"Message is too short (minimum is 3 characters)"}
    SHOW = {"id"=>2, "message"=>"Anand micro-blog 2", "created_at"=>nil, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}, "status"=>"open", "like_id"=>nil, "likes_count"=>0, "comments_count"=>0, "shares_count"=>0, "can_like"=>true, "can_comment"=>true, "can_share"=>true, "can_edit"=>true, "can_abuse"=>true, "can_delete"=>true}
    LIST_BY = {
                'like'=>[{"created_at"=>nil, "likable_item_id"=>1, "likable_item_type"=>"MicroBlog", "micro_blog"=>{"message"=>"Anand micro-blog 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}, {"created_at"=>nil, "likable_item_id"=>1, "likable_item_type"=>"MicroBlog", "micro_blog"=>{"message"=>"Anand micro-blog 1"}, "user"=>{"id"=>2, "first_name"=>"Bharath", "last_name"=>"Naren", "email"=>"bharath.n@rails_e2_soln.com"}}],
                'comment'=>[{"id"=>1, "message"=>"Comment 1 on micro-blog 1", "commentable_item_id"=>1, "commentable_item_type"=>"MicroBlog", "created_at"=>nil, "micro_blog"=>{"message"=>"Anand micro-blog 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}, "like_id"=>nil, "can_like"=>true, "can_comment"=>true, "can_edit"=>false, "can_abuse"=>true, "can_delete"=>true}, {"id"=>2, "message"=>"Comment 2 on micro-blog 1", "commentable_item_id"=>1, "commentable_item_type"=>"MicroBlog", "created_at"=>nil, "micro_blog"=>{"message"=>"Anand micro-blog 1"}, "user"=>{"id"=>2, "first_name"=>"Bharath", "last_name"=>"Naren", "email"=>"bharath.n@rails_e2_soln.com"}, "like_id"=>nil, "can_like"=>true, "can_comment"=>true, "can_edit"=>false, "can_abuse"=>true, "can_delete"=>false}],
                'share'=>[{"id"=>1, "message"=>"Anand share of micro-blog 1", "created_at"=>nil, "micro_blog"=>{"id"=>1, "message"=>"Anand micro-blog 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}, {"id"=>2, "message"=>"Anand share of micro-blog 2", "created_at"=>nil, "micro_blog"=>{"id"=>1, "message"=>"Anand micro-blog 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}]
              }
    UPDATE_OK = {"id"=>2, "message"=>"Updated micro-blog message", "created_at"=>nil, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}, "status"=>"open", "like_id"=>nil, "likes_count"=>0, "comments_count"=>0, "shares_count"=>0, "can_like"=>true, "can_comment"=>true, "can_share"=>true, "can_edit"=>true, "can_abuse"=>true, "can_delete"=>true}
  end

  module Shares
    CREATE_OK = {"id"=>4, "message"=>"Sample share message", "created_at"=>nil, "micro_blog_id"=>2, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}, "status"=>"open", "like_id"=>nil, "likes_count"=>0, "comments_count"=>0, "can_like"=>true, "can_comment"=>true, "can_edit"=>true, "can_abuse"=>true, "can_delete"=>false}
    CREATE_ERR = {"error"=>"Message is too short (minimum is 3 characters)"}
    SHOW = {"id"=>2, "message"=>"Anand share of micro-blog 2", "created_at"=>nil, "micro_blog_id"=>1, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}, "status"=>"open", "like_id"=>nil, "likes_count"=>0, "comments_count"=>0, "can_like"=>true, "can_comment"=>true, "can_edit"=>true, "can_abuse"=>true, "can_delete"=>false}
    LIST_BY = {
                'like'=>[{"created_at"=>nil, "likable_item_id"=>1, "likable_item_type"=>"Share", "share"=>{"message"=>"Anand share of micro-blog 1"}, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}}],
                'comment'=>[{"id"=>5, "message"=>"Comment on share 1", "commentable_item_id"=>1, "commentable_item_type"=>"Share", "created_at"=>nil, "share"=>{"message"=>"Anand share of micro-blog 1"}, "user"=>{"id"=>2, "first_name"=>"Bharath", "last_name"=>"Naren", "email"=>"bharath.n@rails_e2_soln.com"}, "like_id"=>nil, "can_like"=>true, "can_comment"=>true, "can_edit"=>false, "can_abuse"=>true, "can_delete"=>false}]
              }
    UPDATE_OK = {"id"=>2, "message"=>"Updated share message", "created_at"=>nil, "micro_blog_id"=>1, "user"=>{"id"=>1, "first_name"=>"Anand", "last_name"=>"Sai", "email"=>"anand.s@rails_e2_soln.com"}, "status"=>"open", "like_id"=>nil, "likes_count"=>0, "comments_count"=>0, "can_like"=>true, "can_comment"=>true, "can_edit"=>true, "can_abuse"=>true, "can_delete"=>false}
  end

  module Error
    INVALID_PARAMETER = {"error"=>"Invalid parameter"}
    NOT_AUTHENTICATED = {"error"=>"User not authenticated"}
    ACCESS_FORBIDDEN = {"error"=>"Access forbidden"}
  end

  SUCCESS = {"success"=>true}
end